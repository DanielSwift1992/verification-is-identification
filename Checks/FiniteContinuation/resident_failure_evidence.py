#!/usr/bin/env python3
"""Measured whole-goal failure chooses a reusable resident body.

Reuse the existing positive-effect coverage bound and binomial endpoint. The
working decision never computes the service's failure effect. This module is
local-only: the complete fixed service, full preparation and ideal readout are
implemented here, not asserted for a remote device by a metadata flag.
"""
import argparse
from copy import deepcopy
import hashlib
import io
import json
from pathlib import Path

import numpy as np
from qiskit import QuantumCircuit, ClassicalRegister, qpy
from qiskit.quantum_info import Statevector, partial_trace
from qiskit_aer import AerSimulator

import resident_completion as completion
import resident_workbench as work
import whole_word_admission as admission
from environment import digest, write


def body(source, selection, service, budget):
    """New acquisition epoch on the existing DEM/Ref, with no re-preparation."""
    base = completion.circuit(source, selection, service, budget)
    first = [(x.operation.name, [base.find_bit(q).index for q in x.qubits], len(x.clbits))
             for x in base.data[:4]]
    if first != [('h', [3], 0), ('cx', [3, 4], 0), ('h', [2], 0), ('cx', [2, 1], 0)]:
        raise ValueError('The inherited preparation boundary changed')
    q = base.copy_empty_like()
    for item in base.data[4:]:
        q.append(item)
    q.metadata = {**base.metadata, 'input': 'Existing arbitrary DEM and reference; new first-reply epoch.'}
    return q


def covering_preparation():
    # Order B,M,E,D,Ref_D,Ref_E,Ref_M. Three Bell pairs give exactly I_DEM/8.
    q = QuantumCircuit(7)
    for data, reference in [(3, 4), (2, 5), (1, 6)]:
        q.h(data); q.cx(data, reference)
    return q


def coverage():
    prep = covering_preparation()
    reduced = partial_trace(Statevector.from_instruction(prep), [0, 4, 5, 6]).data
    if np.max(abs(reduced-np.eye(8)/8)) > 1e-12:
        raise ValueError('Actual calibration preparation does not cover DEM uniformly')
    return {'carrier': ['D', 'E', 'M'], 'dimension': 8, 'minimum_eigenvalue': 1/8,
            'construction': 'Three actual Bell pairs; B is disposable and Ref_D/E/M are untouched by the body.',
            'ordered_preparation': work.ordered_bindings(prep)}


def covering_circuit(source, selection, service, budget):
    main = body(source, selection, service, budget); q = covering_preparation()
    q.add_register(*main.cregs)
    for item in main.data:
        q.append(item.operation, [main.find_bit(bit).index for bit in item.qubits], list(item.clbits))
    q.metadata = {**main.metadata, 'preparation': coverage()}
    completion.flat.check_flat_fragment(q)
    return q


class LocalEvidence:
    def __init__(self, source, selection, service, *, budgets=(8, 16), shots=8192, alpha=.01, risk=.01):
        completion.interpret(source, selection)
        if (not budgets or tuple(sorted(set(budgets))) != tuple(budgets) or
                any(type(n) is not int or not 1 <= n <= 64 for n in budgets) or
                type(shots) is not int or not 1 <= shots <= 32768 or not 0 < alpha < 1 or not 0 < risk < 1):
            raise ValueError('Invalid prespecified acquisition design')
        self.source = deepcopy(source); self.selection = deepcopy(selection); self.service = service.copy()
        self.budgets = tuple(budgets); self.shots = shots; self.alpha = alpha; self.risk = risk
        self.records = []; self.origin = self.binding()

    def binding(self):
        completion.interpret(self.source, self.selection)
        return {'source': admission.fingerprint(self.source), 'selection': admission.fingerprint(self.selection),
            'service_unitary_sha256': hashlib.sha256(np.asarray(self.service.to_matrix(), dtype=np.complex128).tobytes()).hexdigest(),
            'coverage': coverage(), 'budgets': self.budgets, 'shots': self.shots,
            'alpha_total': self.alpha, 'risk': self.risk,
            'implementation_sha256': digest(Path(__file__)),
            'completion_implementation_sha256': digest(Path(completion.__file__)),
            'scope': 'Constructed fixed complete local service; fresh full covering preparation per IID calibration shot. Quantum M is never refreshed inside a goal body or between working bodies.'}

    def check(self):
        if self.binding() != self.origin:
            raise ValueError('Current service, preparation, source or evidence design changed')

    def acquire_next(self, output):
        self.check(); index = len(self.records)
        if index >= len(self.budgets):
            raise ValueError('Prespecified acquisition catalogue exhausted; no retry search')
        if any(self.decision(record)['kind'] == 'act' for record in self.records):
            raise ValueError('An applicable body was already acquired')
        budget = self.budgets[index]; q = covering_circuit(self.source, self.selection, self.service, budget)
        output.mkdir(parents=True, exist_ok=True)
        path = output/f'calibration-{budget}.qpy'
        if path.exists():
            raise ValueError('This acquired occurrence already exists')
        with path.open('wb') as stream:
            qpy.dump(q, stream)
        with path.open('rb') as stream:
            restored, = qpy.load(stream)
        if q != restored or work.ordered_bindings(q) != work.ordered_bindings(restored):
            raise ValueError('Actual calibration ports changed in serialization')
        seed = 20260915+97*index
        result = AerSimulator(method='statevector', max_parallel_threads=1).run(
            restored, shots=self.shots, memory=True, seed_simulator=seed).result()
        if not result.success:
            raise ValueError('Calibration execution failed')
        completed = restored.find_bit(restored.cregs[3][0]).index
        values = [int(record.replace(' ', ''), 2) for record in result.get_memory()]
        failures = sum(1-((word >> completed) & 1) for word in values)
        record = {'binding': deepcopy(self.origin), 'budget': budget, 'shots': self.shots,
            'failures': failures, 'alpha': self.alpha/len(self.budgets), 'simulation_seed': seed,
            'QPY_sha256': digest(path), 'raw_records_sha256': admission.fingerprint(values),
            'measured_completion_bit': completed, 'new_QPU_jobs': 0}
        self.records.append(deepcopy(record))
        write(output/f'calibration-{budget}.json', record)
        return record

    def decision(self, record):
        self.check()
        if record not in self.records:
            raise ValueError('This evidence was not acquired from the current local source')
        upper = admission.upper_binomial(record['failures'], record['shots'], record['alpha'])
        risk = min(1., upper/self.origin['coverage']['minimum_eigenvalue'])
        return {'kind': 'act' if risk <= self.risk else 'needs_evidence', 'budget': record['budget'],
            'failure_probability_upper': risk, 'calibration_failure_upper': upper,
            'required_risk': self.risk, 'alpha_total': self.alpha,
            'record_sha256': admission.fingerprint(record), 'binding_sha256': admission.fingerprint(self.origin),
            'scope': 'Uniform over arbitrary incoming DEM/reference for this fixed local body and fresh first-reply epoch. Confidence is over the prespecified calibration experiment, not certainty of any single execution.'}

    def working_body(self, packet):
        self.check()
        matches = [record for record in self.records if self.decision(record) == packet]
        if packet['kind'] != 'act' or len(matches) != 1:
            raise ValueError('No applicable acquired guarantee for this working body')
        return body(self.source, self.selection, self.service, packet['budget'])


def append_epoch(q, main, name):
    # Reuse the actual working registers. The first acquisition overwrites
    # current, and each body clears scratch. Renaming register expressions
    # through SDK compose is not required for this fixed-port interface.
    if q.num_qubits != main.num_qubits:
        raise ValueError('The body requires the same complete quantum ports')
    for reg in main.cregs:
        if reg not in q.cregs:
            q.add_register(reg)
        if any(bit not in q.clbits for bit in reg):
            raise ValueError('Working register binding changed')
    exported = ClassicalRegister(1, name+'_completed'); q.add_register(exported)
    copied = 0
    for item in main.data:
        q.append(item.operation, [main.find_bit(bit).index for bit in item.qubits], list(item.clbits))
        if item.operation.name == 'measure' and item.clbits == (main.cregs[3][0],):
            # The body has just measured B and has not reset it yet. Acquire
            # a separate output before the next epoch reuses `completed`.
            q.measure(0, exported[0]); copied += 1
    if copied != 1:
        raise ValueError('One actual completion export required')
    return exported


def acquire(output):
    path = completion.goal.ROOT/'Research/Artifacts/resident-completion-20260915'
    source = json.loads((path/'completion-reading.json').read_text())
    selection = json.loads((path/'plans.json').read_text())['reachable']
    from resident_contact_memory_checks import service_fixture
    service, _ = service_fixture(1.3, -.8, .71)
    session = LocalEvidence(source, selection, service); decisions = []
    for _ in session.budgets:
        record = session.acquire_next(output); packet = session.decision(record); decisions.append(packet)
        if packet['kind'] == 'act':
            main = session.working_body(packet)
            with (output/'working-body.qpy').open('wb') as stream:
                qpy.dump(main, stream)
            break
    write(output/'decisions.json', decisions)
    return session, decisions


if __name__ == '__main__':
    p = argparse.ArgumentParser(description=__doc__); p.add_argument('--output', type=Path, required=True)
    _, decisions = acquire(p.parse_args().output.resolve())
    print(json.dumps([{k: d[k] for k in ('kind', 'budget', 'failure_probability_upper')} for d in decisions]))
