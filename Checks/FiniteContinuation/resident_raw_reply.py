#!/usr/bin/env python3
"""Current-root compilation with an opaque local service and retained memory.

The compiler appends a supplied SDK instruction to the service ports. It
does not inspect its matrix, estimate a measurement law or decide its reply.
All feedback uses actual classical bits of the same circuit execution.
"""
import argparse
from functools import lru_cache
import json
from pathlib import Path
import subprocess

import numpy as np
from qiskit import QuantumCircuit,ClassicalRegister
from qiskit.circuit.classical import expr
from qiskit.circuit.library import UnitaryGate
from qiskit.quantum_info import Operator
from qiskit_aer.library import save_density_matrix

import resident_classical as m
import resident_acquisition as acq
import resident_memory as r
import whole_word_admission as a
from build_from_source import ROOT,HERE,run
from environment import digest,write


@lru_cache(maxsize=2)
def current_source(key):return json.loads(run(['node',HERE/'resident_raw_reply_court.js','read']))


def validate(reading):
    key=tuple((n,digest(ROOT/n)) for n in sorted(reading['source_sha256']))
    if dict(key)!=reading['source_sha256']:raise ValueError('Raw reply source changed')
    key+=tuple((str(p),digest(p)) for p in [HERE/'resident_raw_reply_court.js',HERE/'resident_classical_court.js',HERE/'court_bridge.js'])
    if current_source(key)!=reading:raise ValueError('Not the current raw reply contract')
    m.validate(reading['interpreter'])
    if reading['working']!='ResidentDataPort' or reading['contact']!=['ResidentServicePort','ResidentHiddenMemoryPort'] or reading['next_contact']!=reading['contact']:
        raise ValueError('Local service or retained memory address changed')
    if reading['reply']!=[0,1] or reading['known']!=reading['reply']:raise ValueError('Record does not install the acquired control')


def control(reading,mode,b,*,relative=False):
    return acq.control(reading['interpreter']['acquisition'],mode+str(b),reduced=relative)


def instrument(reading,local_kraus,mode,b,*,relative=False):
    # Mathematical/SDK audit constructor. local_kraus act on E,M and may
    # contain multiple operators per outcome. They are not policy inputs.
    if mode not in ('Toggle','Install') or b not in reading['reply']:raise ValueError('Unknown reply action')
    return [np.kron(c,np.kron(a.I,k)) for c in control(reading,mode,b,relative=relative) for k in local_kraus]


def compression(memory_dimension):
    if type(memory_dimension)is not int or memory_dimension<1:raise ValueError('Invalid retained memory carrier')
    return [np.kron(k,np.eye(memory_dimension)) for k in m.compression()]


def section(service_dimension):
    # Physical section on the CQ image of Lambda: choose P=0,C=R. Coherences
    # outside that image are not part of this sufficient reading.
    return np.kron(np.array([[1],[0]]),np.eye(2*service_dimension))


def compile(reading,service_instruction,representation='full00',steps=3):
    """One bounded circuit; all MCM replies and M stay in this execution."""
    validate(reading)
    if representation not in ('full00','full11','relative','classical') or steps!=3:raise ValueError('Unsupported bounded demonstration')
    if not isinstance(service_instruction,UnitaryGate) or service_instruction.num_qubits!=3:raise ValueError('Local fixture requires a three-wire unitary dilation')
    gate=service_instruction.copy();gate.label='unmodelled_service'
    full=representation.startswith('full');classical=representation=='classical'
    B,M,E,D=0,1,2,3;R=None if classical else 4;P=5 if full else None;ref=6 if full else 4 if classical else 5
    q=QuantumCircuit(ref+1);out=ClassicalRegister(steps+2,'out');q.add_register(out)
    # Test preparations: unknown live D entangled with reference; E,M Bell.
    # These preparations are audit inputs, not data read by the policy.
    q.h(D);q.cx(D,ref);q.h(E);q.cx(E,M)
    if representation=='full11':q.x(P);q.x(R)
    source=reading['interpreter'];raw=source['acquisition'];r_expression=None
    for step in range(steps):
        q.reset(B)
        # The instruction port order is probe, M, E: its matrix convention
        # is E tensor M tensor probe. M is never replaced between contacts.
        q.append(gate,[B,M,E]);q.measure(B,out[step]);q.barrier()
        mode='Install' if step==0 else 'Toggle'
        table=acq.relative_table(raw,mode+'0'),acq.relative_table(raw,mode+'1')
        if mode=='Install':assert all(table[b][old]==b for b in (0,1) for old in (0,1))
        else:assert all(table[b][old]==(old^b) for b in (0,1) for old in (0,1))
        if classical:
            r_expression=expr.lift(out[step]) if mode=='Install' else expr.bit_xor(r_expression,out[step])
            for bit in (0,1):
                predicate=r_expression if bit else expr.logic_not(r_expression)
                with q.if_test(predicate):
                    label=source['controls'][bit]['gate'];getattr(q,{'JointHLabel':'h','JointSLabel':'s'}[label])(D)
            q.z(E);r_expression=expr.logic_not(r_expression)
        else:
            if mode=='Install':
                q.reset(R)
                if full:q.reset(P)
            target=P if full else R
            with q.if_test((out[step],reading['reply'][1])):q.x(target)
            tick=Operator(r.circuit(source['acquisition']['interpreter'])).data if full else m.relative_tick(source)
            q.append(UnitaryGate(tick,label='source_tick'),[E,D,R,P] if full else [E,D,R])
        if step%2:q.cz(D,E)
    # Save the continued quantum state before terminal destructive reads.
    # SDK order: reference,D,E,M; the returned record has only low steps bits.
    save_density_matrix(q,[M,E,D,ref],label='live',conditional=True)
    q.cx(D,ref);q.h(D);q.measure(D,out[steps]);q.measure(ref,out[steps+1])
    q.metadata={'source':a.fingerprint(reading),'representation':representation,'steps':steps,
                'ports':{'probe':B,'memory':M,'service':E,'data':D,'reference':ref},
                'reply_semantics':'Actual device digit; not a calibrated eigenvalue',
                'preservation':'The same E,M wires remain inside this one circuit'}
    manifest(q,reading);return q


def expression_value(node,q,history):
    if isinstance(node,expr.Var):
        j=q.find_bit(node.var).index
        if j>=len(history):raise ValueError('Controller reads an unacquired future bit')
        return bool(history[j])
    if isinstance(node,expr.Value):return bool(node.value)
    if isinstance(node,expr.Unary) and node.op.name=='LOGIC_NOT':return not expression_value(node.operand,q,history)
    if isinstance(node,expr.Binary) and node.op.name=='BIT_XOR':return expression_value(node.left,q,history)^expression_value(node.right,q,history)
    raise ValueError('Unexpected controller expression')


def manifest(q,reading):
    from itertools import product
    ports=q.metadata['ports'];M=ports['memory'];B=ports['probe'];calls=[];measurements={};resets=[]
    step=-1;conditions=[];classical=q.metadata['representation']=='classical'
    for ins in q.data:
        op=ins.operation;qs=[q.find_bit(x).index for x in ins.qubits];cs=[q.find_bit(x).index for x in ins.clbits]
        if op.name=='reset':
            if M in qs or ports['service'] in qs:raise ValueError('Persistent service memory reset inside the episode')
            resets+=qs
        if op.label=='unmodelled_service':calls.append(qs)
        if op.name=='measure':
            if len(cs)!=1 or cs[0] in measurements:raise ValueError('Record overwritten')
            measurements[cs[0]]=qs[0]
            if cs[0]<q.metadata['steps']:step=cs[0]
        if op.name=='if_else':
            if step<0 or len(op.blocks)!=1 or len(op.blocks[0].data)!=1:raise ValueError('Unexpected feedback scope')
            body=op.blocks[0];cmd=body.data[0]
            actual=[qs[body.find_bit(x).index] for x in cmd.qubits]
            if classical:
                if actual!=[ports['data']] or cmd.operation.name not in ('h','s'):raise ValueError('Wrong data instruction in classical feedback')
                for history in product((0,1),repeat=step+1):
                    bit=history[0]
                    for b in history[1:]:bit=reading['interpreter']['controls'][bit]['next']^b
                    expected={'JointHLabel':'h','JointSLabel':'s'}[reading['interpreter']['controls'][bit]['gate']]
                    if expression_value(op.condition,q,history)!=(cmd.operation.name==expected):raise ValueError('Gate does not use the actual acquired history')
            else:
                bit,value=op.condition
                target=5 if q.metadata['representation'].startswith('full') else 4
                if q.find_bit(bit).index!=step or value!=reading['reply'][1] or actual!=[target] or cmd.operation.name!='x':raise ValueError('Feedback uses another bit or control port')
            conditions.append(step)
    if calls!=[[B,M,ports['service']]]*q.metadata['steps']:raise ValueError('Service call changed the retained-memory port')
    if resets.count(B)!=q.metadata['steps']:raise ValueError('Probe preparation changed')
    if any(measurements.get(j)!=B for j in range(q.metadata['steps'])):raise ValueError('Feedback does not use the acquired probe record')
    if q.metadata['source']!=a.fingerprint(reading):raise ValueError('Other source compiled')
    expected=[j for j in range(q.metadata['steps']) for _ in range(2 if classical else 1)]
    if conditions!=expected:raise ValueError('Missing or additional record-dependent control')
    return {'local_calls':calls,'probe_resets':resets.count(B),'actual_measurement_ports':measurements,'record_bound_feedback_sites':conditions}


def build(directory):
    directory.mkdir(parents=True,exist_ok=True)
    proof=json.loads(run(['node',HERE/'resident_raw_reply_court.js','build',directory]))
    native=ROOT/'.build/arm64-apple-macosx/debug/Tools';log=run([native,'judge','where',directory/'ResidentRawReply.swift'])
    assert f"{proof['equalities']} equalities" in log and 'THE WHERE holds' in log
    for item in proof['negatives']:
        got=subprocess.run([str(native),'judge','where',str(directory/item['file'])],capture_output=True,text=True,timeout=30)
        assert got.returncode==1 and 'requires the types' in got.stdout+got.stderr
    proof['native']=log.strip();proof['implementation_sha256']={str(p.relative_to(ROOT)):digest(p) for p in [Path(__file__),HERE/'resident_raw_reply_court.js']}
    write(directory/'build.json',proof);return proof


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    result=build(p.parse_args().output.resolve());print(json.dumps({'equalities':result['equalities'],'refusals_each_court':len(result['negatives'])}))
