#!/usr/bin/env python3
"""Read the same retiring branch through fresh probes before releasing it.

The logical measurement is not repeated. Its retained classical carrier
controls three new report probes. The existing wire then consumes the decoded
actual reports and continues on its new quantum carrier.
"""
import argparse
from functools import lru_cache
import json
from pathlib import Path
import subprocess

from qiskit import QuantumCircuit,ClassicalRegister
from qiskit.circuit.classical import expr

import resident_measurement_wire as wire
import resident_wire_readout as readout
import resident_workbench as work
from environment import write,digest


@lru_cache(maxsize=2)
def current(key):return json.loads(wire.goal.run(['node',wire.goal.HERE/'resident_repeated_read_court.js','read']))


def validate(source):
    key=tuple((p,digest(wire.goal.ROOT/p)) for p in sorted(source['source_sha256']))
    if dict(key)!=source['source_sha256']:raise ValueError('Repeated-read source changed')
    key+=tuple((str(p),digest(p)) for p in [wire.goal.HERE/'resident_repeated_read_court.js',wire.goal.HERE/'resident_measurement_wire_court.js',wire.goal.HERE/'court_bridge.js'])
    if current(key)!=source:raise ValueError('Not the current repeated-read reading')
    wire.validate(source['wire'])
    for row in source['cases']:
        if row['answer']!=row['truth']:raise ValueError('The proposed reading does not answer the source question')
    for row in source['table']:
        a,b,c=row['votes'];answer=(a&b)^(a&c)^(b&c)
        if answer!=row['answer']:raise ValueError('The Boolean lowering no longer denotes the source reading')


def majority(a,b,c):
    return expr.bit_xor(expr.bit_xor(expr.logic_and(a,b),expr.logic_and(a,c)),expr.logic_and(b,c))


def compile_reports(main,source,probabilities,*,preserve_branch=True):
    validate(source)
    if main.num_qubits!=4 or [r.name for r in main.cregs]!=['frame_x','frame_z','reply']:
        raise ValueError('Current wire ports are required')
    boundary=(main.metadata or {}).get('boundary',{})
    word=boundary.get('logical_word',[])
    if boundary.get('rectified_at')!=[len(word)]:
        raise ValueError('This bounded adapter requires one final rectification')
    expected=QuantumCircuit(4);owner=wire.Wire(expected,source['wire'],wire.plan(source['wire']))
    owner.append(word);owner.rectify()
    if boundary!=owner.boundary() or main!=expected or work.ordered_bindings(main)!=work.ordered_bindings(expected):
        raise ValueError('The reported word is not the current constructed logical source')
    if len(probabilities)!=2 or any(not 0<=p<=1 for p in probabilities):raise ValueError('Invalid explicit reporter model')
    if preserve_branch is not True:raise ValueError('Three observations must preserve the same retiring branch')
    q=QuantumCircuit(5);q.add_register(*main.cregs)
    votes=ClassicalRegister(2,'votes');q.add_register(votes);probe=4;count=0
    for item in main.data:
        if item.operation.name=='measure':
            if item.clbits!=(main.cregs[2][0],):raise ValueError('A different acquired field was substituted')
            retiring=main.find_bit(item.qubits[0]).index
            # The first report channel resolves the true branch on the probe.
            # That value remains in `retiring` until all three actual reads.
            for bit in [votes[0],votes[1],main.cregs[2][0]]:
                q.reset(probe);q.cx(retiring,probe)
                q.append(readout.classical_report_channel(*probabilities),[probe])
                q.measure(probe,bit);q.reset(probe)
            q.store(main.cregs[2][0],majority(votes[0],votes[1],main.cregs[2][0]))
            q.store(votes[0],False);q.store(votes[1],False);count+=1
        else:
            q.append(item.operation,[main.find_bit(b).index for b in item.qubits],list(item.clbits))
    q.metadata={'wire_boundary':main.metadata,'source':wire.admission.fingerprint(source),
        'logical_steps':count,'physical_report_reads':3*count,'retained_branch':'Original measured input until all three reports; never replaced by the report probe.',
        'device_model':{'p01':probabilities[0],'p10':probabilities[1],'conditional_independence':'Explicit local memoryless report channel per fresh probe.'},
        'scope':'Known local fixture model. The exact at-most-one-error family is not asserted for these stochastic reports.',
        'new_QPU_jobs':0}
    return q


def build(output):
    output.mkdir(parents=True,exist_ok=True)
    r=json.loads(wire.goal.run(['node',wire.goal.HERE/'resident_repeated_read_court.js','build',output]))
    native=wire.goal.ROOT/'.build/arm64-apple-macosx/debug/Tools';text=wire.goal.run([native,'judge','where',output/'ResidentRepeatedRead.swift'])
    assert f"{r['equalities']} equalities" in text and 'THE WHERE holds' in text
    for entry in r['negatives']:
        p=subprocess.run([str(native),'judge','where',str(output/entry['file'])],capture_output=True,text=True,timeout=30)
        assert p.returncode==1 and 'requires the types' in p.stdout+p.stderr
    r['native']=text.strip();write(output/'build.json',r);return r


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    r=build(p.parse_args().output.resolve());print(json.dumps({k:r[k] for k in ['equalities','negatives']}))
