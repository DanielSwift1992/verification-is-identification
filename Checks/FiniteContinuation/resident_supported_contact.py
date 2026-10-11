#!/usr/bin/env python3
"""Construct a support-forcing interface and a source-derived two-contact body.

The unspecified gates receive only the E port. No claimed termination flag
from a caller, no calibration record and no arbitrary three-wire service can
enter this constructor. Quantum payloads remain live on the same DEM/Ref.
"""
import argparse
from copy import deepcopy
from functools import lru_cache
import json
from pathlib import Path
import subprocess

import numpy as np
from qiskit import QuantumCircuit, ClassicalRegister, qpy
from qiskit.circuit.classical import expr
from qiskit.circuit.library import UnitaryGate
from qiskit.quantum_info import Operator

import resident_completion as completion
import resident_failure_evidence as single
from environment import digest, write


@lru_cache(maxsize=2)
def current(key):
    return json.loads(completion.goal.run(['node', completion.goal.HERE/'resident_supported_contact_court.js', 'read']))


def validate(source):
    key = tuple((p, digest(completion.goal.ROOT/p)) for p in sorted(source['source_sha256']))
    if dict(key) != source['source_sha256']:
        raise ValueError('Supported-contact source changed')
    key += tuple((str(p), digest(p)) for p in [completion.goal.HERE/'resident_supported_contact_court.js',
        completion.goal.HERE/'resident_completion_court.js', completion.goal.HERE/'court_bridge.js'])
    if current(key) != source:
        raise ValueError('Not the current supported-contact reading')
    completion.validate(source['completion'])
    for row in source['rows']:
        if row['next'] != row['next_contact_reply'] or row['completion'] != source['completion']['target']:
            raise ValueError('Support no longer implies the actual source goal')


class OwnedContact:
    def __init__(self, source, payloads):
        validate(source)
        if len(payloads) != 2 or any(not isinstance(g, UnitaryGate) or g.num_qubits != 1 for g in payloads):
            raise ValueError('Two one-qubit E-only payloads are required')
        self.source = deepcopy(source); self.payloads = tuple(g.copy() for g in payloads)

    def service(self):
        validate(self.source)
        q = QuantumCircuit(3); B,M,E=range(3)
        q.cx(M,B); q.x(M)
        q.x(B); q.append(self.payloads[0].control(), [B,E]); q.x(B)
        q.append(self.payloads[1].control(), [B,E])
        return UnitaryGate(Operator(q).data, label='owned_support_contact')


def body(source, contacts):
    validate(source)
    if len(contacts) != 2 or any(type(c) is not OwnedContact or c.source != source for c in contacts):
        raise ValueError('Both actual contacts must be supplied by the current owned constructor')
    acquisition=source['completion']['acquisition']
    raw=acquisition['goal']['raw']; controls=raw['interpreter']['controls']
    edges=completion.contact.model(acquisition)
    rows=source['rows']; labels=[controls[r['first_relative'] ^ r['next']]['gate'] for r in rows]
    second_actions=[edges['observation'][acquisition['goal']['initial'][r['first']]][r['next']] for r in rows]
    if any(action != {'gate':label,'recipient':'QZ'} for action,label in zip(second_actions,labels)):
        raise ValueError('Specialized source action or recipient changed')
    if len(set(labels)) != 1 or len({r['final_relative'] for r in rows}) != 1:
        raise ValueError('The second source action cannot be specialized uniformly')
    q=QuantumCircuit(5); first=ClassicalRegister(1,'first'); reply=ClassicalRegister(1,'reply')
    completed=ClassicalRegister(1,'completed'); q.add_register(first,reply,completed)
    B,M,E,D,REF=range(5)
    def data_gate(label):
        getattr(q, {'JointHLabel':'h','JointSLabel':'s'}[label])(D)
    q.reset(B); q.append(contacts[0].service(),[B,M,E]); q.measure(B,first[0])
    with q.if_test((first[0],1)) as otherwise:
        data_gate(controls[1]['gate'])
    with otherwise:
        data_gate(controls[0]['gate'])
    q.z(E); q.cz(D,E); q.reset(B)
    q.append(contacts[1].service(),[B,M,E]); q.measure(B,reply[0])
    data_gate(labels[0]); q.z(E); q.cz(D,E); q.z(D)
    # Read the real two-contact comparison, even though the constructed
    # support law proves it equals the target in this ideal family.
    q.reset(B)
    with q.if_test(expr.bit_xor(first[0],reply[0])):
        q.x(B)
    q.measure(B,completed[0]); q.reset(B)
    q.store(first[0],False); q.store(reply[0],False)
    q.metadata={'source':single.admission.fingerprint(source),'actual_service_contacts':2,
        'bound':'exact from owned support, not statistical calibration',
        'final_relative':rows[0]['final_relative'],'quantum_input':'Inherited arbitrary DEM/reference',
        'classical_boundary':'Only measured completion remains; First and last reply are cleared.',
        'new_QPU_jobs':0}
    completion.flat.check_flat_fragment(q)
    return q


def build(output):
    output.mkdir(parents=True,exist_ok=True)
    result=json.loads(completion.goal.run(['node',completion.goal.HERE/'resident_supported_contact_court.js','build',output]))
    native=completion.goal.ROOT/'.build/arm64-apple-macosx/debug/Tools'
    text=completion.goal.run([native,'judge','where',output/'ResidentSupportedContact.swift'])
    assert f"{result['equalities']} equalities" in text and 'THE WHERE holds' in text
    for entry in result['negatives']:
        p=subprocess.run([str(native),'judge','where',str(output/entry['file'])],capture_output=True,text=True,timeout=30)
        assert p.returncode==1 and 'requires the types' in p.stdout+p.stderr
    result['native']=text.strip();write(output/'build.json',result)
    return result


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    print(json.dumps(build(p.parse_args().output.resolve())))
