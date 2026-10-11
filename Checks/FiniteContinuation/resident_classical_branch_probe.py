#!/usr/bin/env python3
"""Small local reproduction of a classical-only conditional execution mismatch.

No account, hardware job, credentials, or repository-wide changes.
"""
import argparse
import json
from pathlib import Path

import qiskit
from qiskit import QuantumCircuit,ClassicalRegister,qpy
import qiskit_aer
from qiskit_aer import AerSimulator

from environment import write,digest


def circuit(truth,include_identity):
    q=QuantumCircuit(2);reply=ClassicalRegister(1,'reply');output=ClassicalRegister(1,'output');q.add_register(reply,output)
    if truth:q.x(0)
    q.measure(0,reply[0])
    # This branch should preserve the measured bit for BOTH truth values.
    with q.if_test((reply[0],0)) as otherwise:
        if include_identity:q.id(0)
        q.store(reply[0],False)
    with otherwise:
        if include_identity:q.id(0)
        q.store(reply[0],True)
    # Observe a physical quantum action, not only a Store-backed export.
    with q.if_test((reply[0],1)):q.x(1)
    q.measure(1,output[0])
    return q


def run(output):
    output.mkdir(parents=True,exist_ok=True);rows=[]
    for quantum in [False,True]:
        for truth in [0,1]:
            q=circuit(truth,quantum);path=output/f'branch-{int(quantum)}-{truth}.qpy'
            with path.open('wb') as stream:qpy.dump(q,stream)
            r=AerSimulator(method='density_matrix',max_parallel_threads=1).run(q,shots=8,memory=True,seed_simulator=2026091899).result();assert r.success
            bits=[(int(text.replace(' ',''),2)>>1)&1 for text in r.get_memory()]
            rows.append({'truth':truth,'identity_in_each_branch':quantum,'expected_measured_output':truth,'actual_measured_outputs':bits,
                'matches_intended_semantics':all(b==truth for b in bits),'QPY_sha256':digest(path)})
    assert all(r['matches_intended_semantics'] for r in rows if r['identity_in_each_branch'])
    result={'qiskit':qiskit.__version__,'qiskit_aer':qiskit_aer.__version__,'cases':rows,
        'classical_only_mismatch_observed':any(not r['matches_intended_semantics'] for r in rows if not r['identity_in_each_branch']),
        'scope':'Observed behavior of this installed local stack and these explicit circuits. Not a claim about IBM QPU execution or every Qiskit/Aer version.',
        'new_QPU_jobs':0,'check_sha256':digest(Path(__file__))}
    write(output/'probe.json',result);return result


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    print(json.dumps(run(p.parse_args().output.resolve())))
