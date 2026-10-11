#!/usr/bin/env python3
"""Opaque-instrument laws, persistent-memory counterexamples and local MCM.

Only the auditor sees fixture matrices. The control compiler uses the same
current-root program for every service and receives no desired outcome.
"""
import argparse
from copy import deepcopy
from itertools import product
import json
from pathlib import Path
import time

import numpy as np
from qiskit import QuantumCircuit
from qiskit.circuit import IfElseOp
from qiskit.circuit.library import UnitaryGate
from qiskit.quantum_info import Kraus,Operator,Statevector,SuperOp
from qiskit_aer import AerSimulator

import resident_raw_reply as n
import resident_classical as m
import resident_acquisition as acq
import resident_memory as r
import whole_word_admission as a
from environment import write,digest

REFUSALS=0
def reject(fn):
    global REFUSALS
    try:fn()
    except (AssertionError,ValueError,TypeError):REFUSALS+=1;return
    raise AssertionError('Unsupported construction accepted')


def apply(ks,rho):return sum(k@rho@k.conj().T for k in ks)


def fixture(theta,phi):
    # Private dilation order probe=0,M=1,E=2. The reported bit is not a
    # projective reading of either E or M, and M survives every contact.
    q=QuantumCircuit(3);q.ry(theta,0);q.cx(1,0);q.cz(0,2);q.ry(phi,1);q.cx(2,1)
    gate=UnitaryGate(Operator(q).data)
    u=Operator(gate).data;ks=[[u[b::2,::2]] for b in (0,1)]
    assert Kraus(ks[0]+ks[1]).is_cptp(atol=1e-12)
    eigen=np.linalg.eigvalsh(ks[0][0].conj().T@ks[0][0])
    assert eigen.min()>.1 and eigen.max()<.9
    return gate,ks,[float(x) for x in eigen]


def channel_laws(reading,fixtures):
    comp=n.compression(2);result=[]
    for j,(_,ks,eigen) in enumerate(fixtures):
        for mode,b in product(('Toggle','Install'),(0,1)):
            full=n.instrument(reading,ks[b],mode,b);small=n.instrument(reading,ks[b],mode,b,relative=True)
            left=SuperOp(Kraus([l@k for l in comp for k in full])).data
            right=SuperOp(Kraus([k@l for k in small for l in comp])).data
            err=float(np.max(abs(left-right)));assert err<1e-12
            result.append({'fixture':j,'mode':mode,'reported_b':b,'unnormalized_superoperator_residual':err})
    return result


def criterion_and_hidden_control(reading,ks):
    comp=n.compression(2);section=n.section(8)
    assert section.shape==(32,16) and np.max(abs(section.conj().T@section-np.eye(16)))<1e-12
    # Check the physical-section criterion, not just equality on a few states.
    # This target is the CQ image of Lambda; Lambda*section is dephasing of R.
    q=[section@l for l in comp]
    good=n.instrument(reading,ks[0],'Toggle',0)
    left=SuperOp(Kraus([l@k for l in comp for k in good])).data
    right=SuperOp(Kraus([l@k@z for l in comp for k in good for z in q])).data
    error=float(np.max(abs(left-right)));assert error<1e-12
    # Hidden P-dependent disturbance is invisible in the outcome POVM.
    W=np.diag([(-1)**(p*d) for p,c,d,e,mem in product((0,1),repeat=5)])
    bad=[k@W for k in good]
    assert np.max(abs(sum(k.conj().T@k for k in bad)-sum(k.conj().T@k for k in good)))<1e-12
    badleft=SuperOp(Kraus([l@k for l in comp for k in bad])).data
    badright=SuperOp(Kraus([l@k@z for l in comp for k in bad for z in q])).data
    defect=float(np.max(abs(badleft-badright)));assert defect>.1
    states=[]
    for p,c in ((0,0),(1,1)):
        pc=np.zeros(4);pc[2*p+c]=1
        v=np.kron(pc,np.kron(np.array([1,1])/np.sqrt(2),np.array([1,0,0,0])))
        states.append(np.outer(v,v.conj()))
    assert np.max(abs(apply(comp,states[0])-apply(comp,states[1])))<1e-12
    after=[apply(comp,apply(bad,x)) for x in states]
    probabilities=[float(np.trace(x).real) for x in after]
    xdata=np.kron(np.eye(2),np.kron(a.X,np.eye(4)))
    values=[float(np.trace(xdata@x).real/np.trace(x).real) for x in after]
    assert abs(probabilities[0]-probabilities[1])<1e-12 and abs(values[0]-values[1])>1.9
    # A correction before the control update closes the whole word; the
    # erroneous intermediate cut still cannot use the relative state.
    corrected=[]
    for control in n.control(reading,'Toggle',0):
        for local in ks[0]:corrected.append(np.kron(control,np.eye(8))@W@np.kron(np.eye(8),local)@W)
    corrected_error=float(np.max(abs(SuperOp(Kraus(good)).data-SuperOp(Kraus(corrected)).data)))
    assert corrected_error<1e-12
    return {'physical_section_criterion_residual':error,'hidden_P_branch_criterion_defect':defect,
            'same_outcome_POVM':True,'same_outcome_probabilities':probabilities,'different_conditional_D_X':values,
            'whole_corrected_word_residual':corrected_error}


def memory_boundary():
    # The previously known record/memory boundary remains necessary here.
    k=[np.kron(a.I,np.diag([int(b==0),int(b==1)])) for b in (0,1)]
    rho=np.eye(4)/4;kept={};replaced={}
    for b,c in product((0,1),repeat=2):
        x=k[b]@rho@k[b]
        marginal=np.trace(x.reshape(2,2,2,2),axis1=1,axis2=3)
        fresh=np.kron(marginal,np.eye(2)/2)
        kept[f'{b}{c}']=float(np.trace(k[c]@x@k[c]).real)
        replaced[f'{b}{c}']=float(np.trace(k[c]@fresh@k[c]).real)
    assert kept=={'00':.5,'01':0.,'10':0.,'11':.5} and set(replaced.values())=={.25}
    return {'same_memory_two_record_law':kept,'independent_replacement_two_record_law':replaced,
            'unconditional_memory_marginal_unchanged':True}


def initial_quantum():
    # Native order reference,D,E,M, matching the SDK snapshot's wire list.
    q=QuantumCircuit(4);q.h(2);q.cx(2,3);q.h(1);q.cx(1,0)
    v=Statevector(q).data;return np.outer(v,v.conj())


def history_oracle(reading,ks,history):
    rho=initial_quantum();source=reading['interpreter'];bit=None
    for step,b in enumerate(history):
        rho=apply([np.kron(np.eye(4),k) for k in ks[b]],rho)
        table=acq.relative_table(source['acquisition'],('Install' if step==0 else 'Toggle')+str(b))
        bit=table[0 if bit is None else bit]
        gate,nxt=m.gate_at(source,bit);rho=apply([np.kron(a.I,np.kron(gate,a.I))],rho);bit=nxt
        if step%2:rho=apply([np.kron(a.I,np.kron(np.diag([1,1,1,-1]),a.I))],rho)
    return rho,bit


def replace(q,index,operation=None,qubits=None):
    out=q.copy_empty_like()
    for j,ins in enumerate(q.data):
        op=ins.operation if j!=index or operation is None else operation
        qs=[q.find_bit(x).index for x in ins.qubits] if j!=index or qubits is None else qubits
        cs=[q.find_bit(x).index for x in ins.clbits]
        out.append(op,qs,cs)
    return out


def compiler_guards(reading,gate):
    q=n.compile(reading,gate,'full00');index=[i for i,x in enumerate(q.data) if x.operation.name=='if_else'][1]
    op=q.data[index].operation
    bad=replace(q,index,IfElseOp((q.clbits[0],1),op.blocks[0]));reject(lambda:n.manifest(bad,reading))
    index=next(i for i,x in enumerate(q.data) if x.operation.label=='unmodelled_service')
    bad=replace(q,index,qubits=[0,3,2]);reject(lambda:n.manifest(bad,reading))
    bad=q.copy();bad.reset(q.metadata['ports']['memory']);reject(lambda:n.manifest(bad,reading))
    q=n.compile(reading,gate,'classical');index=[i for i,x in enumerate(q.data) if x.operation.name=='if_else'][2]
    op=q.data[index].operation
    from qiskit.circuit.classical import expr
    bad=replace(q,index,IfElseOp(expr.lift(q.clbits[0]),op.blocks[0]));reject(lambda:n.manifest(bad,reading))
    fake=deepcopy(reading);fake['next_contact'][1]='ResidentDataPort';reject(lambda:n.compile(fake,gate))


def controller_signature(q):
    # Ignore only the opaque service's internal matrix; keep every controller
    # target, condition truth table and known unitary in the comparison.
    result=[]
    for item in q.data:
        op=item.operation;qs=[q.find_bit(x).index for x in item.qubits];cs=[q.find_bit(x).index for x in item.clbits]
        if op.label=='unmodelled_service':entry=['service',qs]
        elif op.name=='if_else':
            body=op.blocks[0]
            if isinstance(op.condition,tuple):bit,value=op.condition;condition=['bit',q.find_bit(bit).index,int(value)]
            else:condition=['truth_table',[n.expression_value(op.condition,q,h) for h in product((0,1),repeat=3)]]
            entry=['if',qs,cs,condition,[(x.operation.name,[body.find_bit(b).index for b in x.qubits]) for x in body.data]]
        elif op.name=='unitary':entry=['unitary',qs,a.channel_digest([np.asarray(op.params[0])])]
        else:entry=[op.name,qs,cs,[str(x) for x in op.params],op.label]
        result.append(entry)
    return a.fingerprint(result)


def sdk_run(reading,fixtures,directory):
    circuits=[];specs=[];oracles={}
    for j,(gate,ks,eigen) in enumerate(fixtures):
        for kind in ('full00','full11','relative','classical'):
            q=n.compile(reading,gate,kind);circuits.append(q);specs.append((j,kind))
        oracles[j]={sum(b<<i for i,b in enumerate(h)):history_oracle(reading,ks,h) for h in product((0,1),repeat=3)}
        assert abs(sum(np.trace(x).real for x,bit in oracles[j].values())-1)<1e-12
    signatures={kind:[controller_signature(q) for q,(j,k) in zip(circuits,specs) if k==kind] for kind in ('full00','full11','relative','classical')}
    assert all(len(set(v))==1 for v in signatures.values())
    before=time.perf_counter()
    result=AerSimulator(method='statevector',max_parallel_threads=2).run(circuits,shots=512,seed_simulator=159305).result(timeout=30)
    elapsed=time.perf_counter()-before;assert result.success
    recipient=QuantumCircuit(4);recipient.cx(2,3);recipient.h(2);u=Operator(recipient).data
    details=[];worst=0.;histogram_residual=0.;histories=0
    for index,(j,kind) in enumerate(specs):
        saved=result.data(index)['live'];assert set(map(lambda x:int(x,16),saved))==set(oracles[j])
        expected={format(i,'05b'):0. for i in range(32)}
        for history,(rho,control) in oracles[j].items():
            p=float(np.trace(rho).real);assert p>.01
            actual=saved[hex(history)].data
            error=float(np.max(abs(actual-rho/p)));assert error<1e-10;worst=max(worst,error);histories+=1
            out=u@rho@u.conj().T
            for value,prob in enumerate(np.diag(out).real):
                d=(value>>2)&1;ref=(value>>3)&1;expected[format(history+(d<<3)+(ref<<4),'05b')]+=float(prob)
        counts=result.get_counts(index);assert sum(counts.values())==512
        residual=max(abs(counts.get(k,0)/512-p) for k,p in expected.items())
        # Sampling comparison is descriptive; exact conditional states and the
        # branch-channel proof carry the semantic claim, not a lucky histogram.
        histogram_residual=max(histogram_residual,residual)
        details.append({'fixture':j,'representation':kind,'qubits':circuits[index].num_qubits,
                        'counts':counts,'expected_probabilities':expected,'observed_history_count':len(saved),
                        'maximum_probability_frequency_residual':residual})
    write(directory/'sdk-results.json',{'cases':details,'circuits':len(circuits),'shots_each':512,
            'seconds':elapsed,'all_conditional_states_checked':histories,'max_state_residual':worst,
            'max_sampling_residual_descriptive':histogram_residual,'controller_signatures':signatures,'physical_QPU_jobs':0})
    return {'circuits':len(circuits),'shots_each':512,'elapsed_seconds':elapsed,'conditional_states_checked':histories,
            'maximum_conditional_state_residual':worst,'maximum_sampling_residual_descriptive':histogram_residual,
            'quantum_qubits_full_relative_classical':[7,6,5],'returned_raw_bits_each':3,
            'same_controller_for_three_unknown_instruments':True,
            'scope':'One local SDK circuit per case; persistent M, actual MCM and classical feedback. No state is carried between SDK jobs.'}


def run(directory):
    global REFUSALS
    REFUSALS=0;reading=json.loads((directory/'raw-reply-reading.json').read_text());n.validate(reading)
    fixtures=[fixture(theta,phi) for theta,phi in [(np.pi/3,np.pi/5),(1.3,-.8),(1.45,.91)]]
    compiler_guards(reading,fixtures[0][0])
    result={'branch_laws':channel_laws(reading,fixtures),'criterion_and_hidden_control':criterion_and_hidden_control(reading,fixtures[0][1]),
            'memory_boundary':memory_boundary(),'SDK':sdk_run(reading,fixtures,directory),
            'nonprojective_effect_eigenvalues':[x[2] for x in fixtures],'runtime_refusals':REFUSALS,
            'implementation_sha256':digest(Path(n.__file__)),'test_sha256':digest(Path(__file__)),'new_QPU_jobs':0}
    write(directory/'audit.json',result);return result


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    result=run(p.parse_args().output.resolve())
    print(json.dumps(result,indent=2))
