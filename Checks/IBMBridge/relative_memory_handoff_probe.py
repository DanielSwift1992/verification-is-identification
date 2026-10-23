#!/usr/bin/env python3
"""Second-attempt candidate: a record acts after its source has been retired.

Preparation includes A=+ so that the controller must use the actual per-shot
record. Mean XX alone is not the requested answer in this case. This builder
does not submit until explicitly run, and the shared transport enforces the
two-job Open-only campaign cap.
"""

import sys as _evidence_sys
from pathlib import Path as _EvidencePath
_evidence_sys.path.insert(0, str(_EvidencePath(__file__).resolve().parents[1]))
import hardware_runs as _runs
_runs.configure(required=(__name__ == "__main__"))
import argparse
import io
import json
from pathlib import Path
from qiskit import QuantumCircuit, ClassicalRegister, transpile, qpy
from qiskit_aer import AerSimulator
from pilot import require, service_open, compact_active
from classical_boundary_probe import aer_form
from resident_joint_confirmation import place
import relative_memory_handoff as handoff
import relative_minimal_handoff as minimal
import relative_acquisition as relative
import arrival_failure_localization as diag
import arrival_boundary_probe as old
import bounded_open_experiment as cloud

ROOT = old.ROOT
PRIVATE = _runs.work('ibm-relative-memory-handoff-20260916')
ART = ROOT / 'Research/Artifacts/relative-acquisition-20260916/attempt-2'
TAG = 'vi-relative-memory-handoff-2-20260916'


def witness(core, final, a, b, basis):
    q = QuantumCircuit(6)
    if a == '+': q.h(1)
    elif a == '1': q.x(1)
    else: require(a == '0', 'Unknown A preparation')
    if b == '-': q.x(2)
    else: require(b == '+', 'Unknown B preparation')
    q.h(2)
    q.h(3); q.cx(3, 4); q.x(5)
    q = transpile(q, basis_gates=['rz', 'sx', 'x', 'id', 'cz'], optimization_level=0)
    for reg in core.cregs: q.add_register(reg)
    q.compose(core, inplace=True)
    tail = QuantumCircuit(6)
    tail.h(final[2])
    if basis == 'XX': tail.h(final[3]); tail.h(final[4])
    tail = transpile(tail, basis_gates=['rz', 'sx', 'x', 'id', 'cz'], optimization_level=0)
    q.compose(tail, inplace=True)
    w = ClassicalRegister(3, 'witness')
    source = ClassicalRegister(1, 'retired_source_check')
    q.add_register(w, source)
    q.measure([final[2], final[3], final[4]], w)
    q.measure(final[1], source[0])
    return q


def check_witness(q, use_record, a, b, basis):
    q = aer_form(compact_active(q))
    result = AerSimulator(max_parallel_threads=1).run(q, shots=32, memory=True, seed_simulator=160918).result()
    require(result.success, 'Ideal handoff failed')
    def read(v, name):
        r = next(r for r in q.cregs if r.name == name)
        return sum(((v >> q.find_bit(bit).index) & 1) << i for i, bit in enumerate(r))
    seen = set()
    for sample in result.get_memory():
        v = int(sample.replace(' ', ''), 2)
        record = read(v, 'actual_a'); w = read(v, 'witness')
        seen.add(record)
        if any(r.name == 'actual_arrival' for r in q.cregs):
            require(read(v, 'actual_arrival') == 1, 'Lost request')
        require(read(v, 'retired_source_check') == 0, 'Source not retired')
        require((w & 1) == int(b == '-'), 'Lost future B question')
        if a != '+': require(record == int(a), 'Lost acquisition')
        expected = record if use_record and basis == 'XX' else 0
        require((((w >> 1) ^ (w >> 2)) & 1) == expected, 'Wrong recipient action')
    if a == '+': require(seen == {0, 1}, 'Seeded stochastic witness missed a branch')


def prepare():
    require(not (PRIVATE / 'plan.json').exists(), 'Already prepared')
    certificates = {'heavy_record': handoff.certificate(True),
                    'minimal_record': minimal.certificate(True), 'minimal_ignore': minimal.certificate(False)}
    reference = QuantumCircuit(6); reference.add_register(ClassicalRegister(1, 'actual_a'))
    cores = {'heavy_record': handoff.core(True), 'minimal_record': minimal.core(True),
             'minimal_ignore': minimal.core(False), 'reference_only': (reference, list(range(6)))}
    cases = [(a, '+', basis, arm) for a in ('0', '1', '+')
             for basis in ('XX', 'ZZ') for arm in ('heavy_record', 'minimal_record', 'minimal_ignore')]
    cases += [('0', '+', basis, 'reference_only') for basis in ('XX', 'ZZ')]
    cases += [('+', '-', basis, 'minimal_record') for basis in ('XX', 'ZZ')]
    base = cloud.read(diag.OLD / 'plan.json')
    service = service_open(); backend = service.backend(base['backend'])
    qs = []
    for a, b, basis, arm in cases:
        core, final = cores[arm]
        use = arm in ('heavy_record', 'minimal_record')
        q = witness(core, final, a, b, basis)
        q.metadata = {'tag': TAG, 'pub_index': len(qs), 'arm': arm,
                      'prepared_a': a, 'prepared_b': b, 'prepared_arrival': 1, 'basis': basis,
                      'final_layout': final, 'acquires_a': arm != 'reference_only',
                      'measures_request': arm == 'heavy_record',
                      'expected_retired_source': 0, 'ideal_B_X': -1 if b == '-' else 1,
                      'recipient_target': 'Z^actual_a on the same data; source A retired'}
        q = place(q, base['path'], backend.num_qubits)
        buf = io.BytesIO(); qpy.dump(q, buf); buf.seek(0); restored, = qpy.load(buf)
        check_witness(restored, use, a, b, basis)
        qs.append(q)
    plan = {'schema': 'vi.relative-memory-handoff-probe.v2', 'attempt': 2, 'tag': TAG, 'shots_each': 128,
            'path': base['path'], 'instrument_certificates': certificates,
            'adaptation': 'First acquisition preserved B and acquired A, but failed the full data XX continuation. '
                          'Compare the heavy handoff to a whole-instrument reduction with one adjacent CX, '
                          'one actual reading, source retirement, and record-controlled recipient. '
                          'Input physical ports agree; output layouts are explicit and may differ. '
                          'This changes multiple physical operations, not a single-component causal diagnosis.',
            'analysis': 'All shots. Compare heavy and minimal real-record recipients and omission of only the minimal final phase. '
                        'XX target score is E[(-1)^actual_a X_D X_R], ZZ target is E[Z_D Z_R]. '
                        'For A=+ mean XX can vanish in the correct arm, while the joint target score is +1. '
                        'Also retain B_X, request agreement and measured retirement A=0. '
                        'No postselection, arbitrary-state hardware certification, trusted retirement measurement '
                        'or inference that an old law applies to the new zero source.'}
    dependencies = [_runs.owned(__file__), _runs.owned(handoff.__file__), _runs.owned(minimal.__file__), _runs.owned(relative.__file__), _runs.owned(old.__file__),
                    _runs.owned(diag.__file__), ROOT / 'Checks/IBMBridge/classical_boundary_probe.py']
    return cloud.freeze(PRIVATE, ART, qs, plan, service, backend, dependencies)


if __name__ == '__main__':
    p = argparse.ArgumentParser(); p.add_argument('stage', choices=['prepare', 'submit', 'collect'])
    stage = p.parse_args().stage
    print(json.dumps(_runs.bind_receipt(prepare() if stage == 'prepare' else getattr(cloud, stage)(PRIVATE, ART)), indent=2))
