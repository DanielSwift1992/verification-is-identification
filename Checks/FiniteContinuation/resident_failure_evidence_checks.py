#!/usr/bin/env python3
"""Independent failure effects and inherited-state executions after acquisition."""
import argparse
from copy import deepcopy
import json
from pathlib import Path
import tempfile
import time

import numpy as np
from qiskit import QuantumCircuit, ClassicalRegister
from qiskit.quantum_info import Statevector, partial_trace
from qiskit_aer import AerSimulator
from qiskit_aer.library import save_density_matrix

import resident_failure_evidence as evidence
import resident_completion_checks as completion_checks
from resident_contact_memory_checks import service_fixture
from resident_stream_checks import operators, apply
from environment import write, digest


def failure_effect(source, ks, budget):
    full = operators(source['acquisition']['goal']['raw'], ks)
    maps = {}
    for key, branch in full.items():
        maps[key] = []
        for k in branch:
            reduced = k[:8, :8]
            assert np.max(abs(k-np.kron(np.eye(2), reduced))) < 1e-12
            maps[key].append(reduced)
    effect = np.zeros((8, 8), complex)
    for bit in (0, 1):
        r = 0; prior = []
        for _ in range(budget):
            prior.append(r); r = 1^(r^bit)
        value = np.eye(8, dtype=complex)
        for r in reversed(prior):
            value = sum(k.conj().T@value@k for k in maps[r, bit])
        effect += value
    values = np.linalg.eigvalsh(effect)
    assert values.min() > -1e-12 and values.max() < 1+1e-12
    return effect


def effect_checks(source):
    results = {}
    for name, _, ks in completion_checks.instruments():
        rows = []
        for budget in (2, 8, 16):
            effect = failure_effect(source, ks, budget)
            if name == 'fresh_coin':
                assert np.max(abs(effect-2.**(1-budget)*np.eye(8))) < 1e-12
            if name == 'constant_memory':
                assert np.max(abs(effect-np.eye(8))) < 1e-12
            if name == 'alternating_memory':
                assert np.max(abs(effect)) < 1e-12
            rows.append({'budget': budget, 'max_failure_eigenvalue': float(np.linalg.eigvalsh(effect).max()),
                         'uniform_preparation_failure': float(np.trace(effect).real/8)})
        results[name] = rows
    # Existing five-wire example preparation covers only a rank-two DEM
    # subspace. It is not the new all-input calibration preparation.
    q = QuantumCircuit(5); q.h(3); q.cx(3, 4); q.h(2); q.cx(2, 1)
    tau = partial_trace(Statevector.from_instruction(q), [0, 4]).data
    assert np.linalg.matrix_rank(tau, tol=1e-12) == 2
    return {'effects': results, 'old_example_preparation_rank': 2,
        'actual_covering_preparation': evidence.coverage(),
        'scope': 'These exact local maps are audit oracles only; the working admission receives sampled completion records, not these effects or spectra.'}


def working_chain(session, packet, ks, *, seed, shots=128):
    main = session.working_body(packet); budget = packet['budget']
    ctl = evidence.completion.interpret(session.source, session.selection)
    traced = completion_checks.traced(main, budget, ctl['completed'])
    rng = np.random.default_rng(seed)
    psi = rng.normal(size=16)+1j*rng.normal(size=16); psi /= np.linalg.norm(psi)
    q = QuantumCircuit(5); q.initialize(psi, [1, 2, 3, 4]); registers = []; exports = []
    for epoch in (0, 1):
        exports.append(evidence.append_epoch(q, traced, 'epoch'+str(epoch)))
        saved = []
        for reg in traced.cregs:
            snapshot = ClassicalRegister(len(reg), 'audit_epoch'+str(epoch)+'_'+reg.name)
            q.add_register(snapshot); q.store(snapshot, reg); saved.append(snapshot)
        registers.append(saved)
        save_density_matrix(q, range(5), label='epoch'+str(epoch), pershot=True)
    result = AerSimulator(method='statevector', max_parallel_threads=1).run(
        q, shots=shots, memory=True, seed_simulator=seed+91).result()
    assert result.success; maximum = 0.; pairs = {}
    maps = operators(session.source['acquisition']['goal']['raw'], ks)
    for i, record in enumerate(result.get_memory()):
        word = int(record.replace(' ', ''), 2); rho = np.outer(psi, psi.conj()); outcomes = []
        for epoch, regs in enumerate(registers):
            def read(reg):
                return [(word >> q.find_bit(bit).index) & 1 for bit in reg]
            history = read(regs[4]); contacts = read(regs[5])
            r = 0; first = history[0]; last = first; done = False
            for bit, active in zip(history, contacts):
                assert active == int(not done)
                if done:
                    assert bit == 0; continue
                rho = apply(maps[r, bit], rho); rho /= np.trace(rho).real
                r = 1^(r^bit); last = bit
                if first^bit:
                    rho = completion_checks.Z_DATA@rho@completion_checks.Z_DATA; done = True
            assert read(regs[3]) == [int(done)]
            assert read(exports[epoch]) == [int(done)]
            assert read(regs[1]) == [0]*ctl['width'] and read(regs[2]) == [0]
            cls = session.selection['certificate']['classes'][session.selection['model']['states'].index(f'{r}{first}{last}')]
            assert sum(v << k for k, v in enumerate(read(regs[0]))) == cls
            expected = np.kron(rho, np.diag([1, 0]))
            error = float(np.max(abs(result.data()['epoch'+str(epoch)][i].data-expected)))
            assert error < 1e-10; maximum = max(maximum, error); outcomes.append(int(done))
        key = ''.join(map(str, outcomes)); pairs[key] = pairs.get(key, 0)+1
    b = packet['failure_probability_upper']
    return {'initial_state_seed': seed, 'body_budget': budget, 'epochs': 2,
        'same_M_preserved_between_epochs': True, 'same_DEM_reference_preserved_between_epochs': True,
        'completed_pairs': pairs, 'joint_states_checked': shots*2, 'maximum_joint_state_error': maximum,
        'acquired_bound_for_any_failure_in_two_epochs': 1-(1-b)**2,
        'scope': 'New first-reply epoch, inherited quantum state. The simultaneous calibration confidence is reused, not multiplied; operational success bounds do compose.'}


def guards(session, packet):
    refused = []
    def no(name, function):
        try:
            function()
        except ValueError:
            refused.append(name); return
        raise AssertionError('Accepted '+name)
    record = deepcopy(session.records[-1]); record['failures'] = 0
    no('favourable counts not actually acquired', lambda: session.decision(record))
    wrong = deepcopy(packet); wrong['budget'] = 2
    no('evidence for sixteen slots used for two', lambda: session.working_body(wrong))
    wrong = deepcopy(packet); wrong['failure_probability_upper'] = 0
    no('acquired bound replaced by exact success', lambda: session.working_body(wrong))
    no('rejected earlier candidate used as a working body', lambda: session.working_body(session.decision(session.records[0])))
    old = session.service
    session.service = service_fixture(1.45, .91, 0)[0]
    no('changed service under an archived guarantee', session.check)
    session.service = old
    old_shots = session.shots; session.shots = old_shots*2
    no('retroactive change to the acquisition design', session.check)
    session.shots = old_shots
    with tempfile.TemporaryDirectory() as directory:
        no('another trial after admission', lambda: session.acquire_next(Path(directory)))
    return refused


def run(output):
    started = time.perf_counter()
    # Deterministic replay verifies the archived local experiment. It is not
    # an additional independent sample and contributes no new confidence.
    with tempfile.TemporaryDirectory() as directory:
        session, decisions = evidence.acquire(Path(directory)); packet = decisions[-1]
        assert packet['kind'] == 'act' and packet['budget'] == 16
        for record in session.records:
            original = json.loads((output/f"calibration-{record['budget']}.json").read_text())
            assert evidence.admission.fingerprint(record['binding']) == evidence.admission.fingerprint(original['binding'])
            for field in ('failures', 'shots', 'alpha', 'raw_records_sha256'):
                assert record[field] == original[field]
        oracle = effect_checks(session.source)
        actual = oracle['effects']['rotated_memory']
        assert actual[1]['max_failure_eigenvalue'] > session.risk
        assert actual[2]['max_failure_eigenvalue'] < packet['failure_probability_upper'] < session.risk
        _, ks = service_fixture(1.3, -.8, .71)
        chains = [working_chain(session, packet, ks, seed=seed) for seed in (91031, 91039, 91049)]
        result = {'decisions_replayed': [{k: d[k] for k in ('kind', 'budget', 'failure_probability_upper')} for d in decisions],
            'archived_counts_reproduced_exactly': True, 'replay_adds_no_statistical_evidence': True,
            'oracle': oracle, 'working_chains': chains,
            'joint_states_checked': sum(x['joint_states_checked'] for x in chains),
            'maximum_joint_state_error': max(x['maximum_joint_state_error'] for x in chains),
            'refusals': guards(session, packet), 'seconds': time.perf_counter()-started, 'new_QPU_jobs': 0,
            'implementation_sha256': digest(Path(evidence.__file__)), 'check_sha256': digest(Path(__file__))}
    write(output/'audit.json', result)
    return result


if __name__ == '__main__':
    p = argparse.ArgumentParser(description=__doc__); p.add_argument('--output', type=Path, required=True)
    result = run(p.parse_args().output.resolve())
    print(json.dumps({k: result[k] for k in ('joint_states_checked', 'maximum_joint_state_error', 'seconds')}))
