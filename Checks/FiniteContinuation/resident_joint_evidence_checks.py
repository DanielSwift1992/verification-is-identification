#!/usr/bin/env python3
"""Joint effect, distinct occurrence inputs and retained-memory execution."""
import argparse
from copy import deepcopy
import json
from pathlib import Path
import tempfile
import time

import numpy as np
from qiskit import QuantumCircuit
from qiskit_aer import AerSimulator
from qiskit_aer.library import save_density_matrix

import resident_joint_evidence as joint
import resident_completion_checks as checks
from resident_contact_memory_checks import service_fixture
from resident_failure_evidence_checks import failure_effect
from resident_stream_checks import operators, apply
from environment import write, digest


def joint_effect(source, ks, budget):
    full = operators(source['acquisition']['goal']['raw'], ks)
    if any(len(branch) != 1 for branch in full.values()):
        raise ValueError('This particular oracle enumerates one-Kraus SDK words')
    matrices = {key: branch[0][:8, :8] for key, branch in full.items()}
    z = np.kron(joint.single.admission.Z, np.eye(4)); success = []
    for first in (0, 1):
        for repeated in range(1, budget):
            history = [first]*repeated+[1-first]; r = 0; k = np.eye(8, dtype=complex)
            for bit in history:
                k = matrices[r, bit]@k; r = 1^(r^bit)
                if first^bit:
                    k = z@k
            success.append(k)
    failure = failure_effect(source, ks, budget)
    complete = sum(k.conj().T@k for k in success)
    assert np.max(abs(failure+complete-np.eye(8))) < 1e-11
    effect = failure+sum(k.conj().T@failure@k for k in success)
    second = np.eye(8)-sum(a.conj().T@b.conj().T@b@a for a in success for b in success)
    assert np.max(abs(effect-second)) < 1e-11
    b = float(np.linalg.eigvalsh(failure).max())
    assert np.linalg.eigvalsh(effect).max() <= 1-(1-b)**2+1e-11
    return {'budget': budget, 'first_hit_Kraus_words': len(success),
            'single_average_failure': float(np.trace(failure).real/8),
            'single_max_failure': b, 'joint_average_failure': float(np.trace(effect).real/8),
            'joint_max_failure': float(np.linalg.eigvalsh(effect).max()),
            'wrong_independent_average_formula': 1-(1-float(np.trace(failure).real/8))**2,
            'independent_effect_identity_residual': float(np.max(abs(effect-second)))}


def same_effect_counterexample():
    # General marked CP instruments: same exact first failure operator, but
    # different post-success memory. This is a separate two-dimensional model,
    # not a claim that all such instruments are the resident source fixture.
    p = 1/4; failure = np.diag([0., p]); kf = np.diag([0., np.sqrt(p)])
    base = np.diag([1., np.sqrt(1-p)]); rows = []
    for name, success in [('keep', base), ('flip', joint.single.admission.X@base)]:
        assert np.max(abs(success.conj().T@success+kf.conj().T@kf-np.eye(2))) < 1e-12
        effect = failure+success.conj().T@failure@success
        expected = np.diag([0., 7/16]) if name == 'keep' else np.eye(2)/4
        assert np.max(abs(effect-expected)) < 1e-12
        rows.append({'post_success_memory': name, 'single_failure_effect': failure.tolist(),
                     'joint_failure_effect': effect.real.tolist(),
                     'joint_worst_failure': float(np.linalg.eigvalsh(effect).max())})
    return {'cases': rows, 'scope': 'Even exact knowledge of one-goal F does not determine the next joint question; its successful state update S also matters.'}


def reader_truth_table(q):
    suffix = q.data[-4:]
    assert [x.operation.name for x in suffix] == ['reset', 'if_else', 'measure', 'reset']
    registers = {reg.name: reg for reg in q.cregs}; positions = joint.readout(q); rows = []
    for first in (0, 1):
        for second in (0, 1):
            test = q.copy_empty_like()
            test.store(registers['epoch0_completed'][0], bool(first))
            test.store(registers['epoch1_completed'][0], bool(second))
            for item in suffix:
                test.append(item)
            result = AerSimulator(method='statevector', max_parallel_threads=1).run(
                test, shots=4, memory=True, seed_simulator=94117).result()
            values = [(int(word.replace(' ', ''), 2) >> positions['joint_completed']) & 1 for word in result.get_memory()]
            assert values == [first & second]*4
            rows.append({'first': first, 'second': second, 'joint': values[0]})
    return rows


def working(source_session, packet, ks, seed):
    main = source_session.working_body(packet); budget = packet['budget']
    ctl = joint.single.completion.interpret(source_session.source, source_session.selection)
    rng = np.random.default_rng(seed); psi = rng.normal(size=16)+1j*rng.normal(size=16); psi /= np.linalg.norm(psi)
    q = main.copy_empty_like(); q.initialize(psi, [1, 2, 3, 4])
    from qiskit import ClassicalRegister
    histories = [ClassicalRegister(budget, 'audit_history'+str(i)) for i in range(2)]
    contacts = [ClassicalRegister(budget, 'audit_contacts'+str(i)) for i in range(2)]
    q.add_register(*histories, *contacts)
    named = {reg.name: reg for reg in main.cregs}
    exports = [named['epoch'+str(i)+'_completed'] for i in range(2)]
    joint_reg = named['joint_completed']; index = 0; pending = None; captured = []
    # Instrument the actual production body, retaining every operation and
    # occurrence binding. No replacement of its two-epoch control program.
    for item in main.data:
        q.append(item)
        if item.operation.name == 'measure' and item.clbits == (main.cregs[2][0],):
            epoch, slot = divmod(index, budget)
            q.store(histories[epoch][slot], main.cregs[2][0])
            q.store(contacts[epoch][slot], True if slot == 0 else
                    joint.single.completion.active_expression(main.cregs[0], ctl['completed']))
            index += 1
        if item.operation.name == 'measure':
            for epoch, reg in enumerate(exports):
                if item.clbits == (reg[0],):
                    pending = epoch
        if pending is not None and item.operation.name == 'reset' and item.qubits == (main.qubits[0],):
            save_density_matrix(q, range(5), label='epoch'+str(pending), pershot=True)
            captured.append(pending); pending = None
    assert index == 2*budget and captured == [0, 1]
    with q.if_test((joint_reg[0], 1)):
        q.x(3)
    save_density_matrix(q, range(5), label='consumer', pershot=True)
    result = AerSimulator(method='statevector', max_parallel_threads=1).run(
        q, shots=128, memory=True, seed_simulator=seed+83).result()
    assert result.success; maps = operators(source_session.source['acquisition']['goal']['raw'], ks)
    maximum = 0.; pairs = {}
    for i, text in enumerate(result.get_memory()):
        word = int(text.replace(' ', ''), 2); rho = np.outer(psi, psi.conj()); outcome = []
        def read(reg):return [(word >> q.find_bit(bit).index) & 1 for bit in reg]
        for epoch in range(2):
            history, active = read(histories[epoch]), read(contacts[epoch]); first = history[0]; r = 0; done = False
            for bit, contacted in zip(history, active):
                assert contacted == int(not done)
                if done:
                    assert bit == 0; continue
                rho = apply(maps[r, bit], rho); rho /= np.trace(rho).real; r = 1^(r^bit)
                if first^bit:
                    rho = checks.Z_DATA@rho@checks.Z_DATA; done = True
            assert read(exports[epoch]) == [int(done)]; outcome.append(int(done))
            error = float(np.max(abs(result.data()['epoch'+str(epoch)][i].data-np.kron(rho, np.diag([1, 0])))))
            assert error < 1e-10; maximum = max(maximum, error)
        flag = outcome[0] & outcome[1]
        assert read(joint_reg) == [flag]
        if flag:
            rho = checks.X_DATA@rho@checks.X_DATA
        error = float(np.max(abs(result.data()['consumer'][i].data-np.kron(rho, np.diag([1, 0])))))
        assert error < 1e-10; maximum = max(maximum, error)
        key = ''.join(map(str, outcome)); pairs[key] = pairs.get(key, 0)+1
    return {'initial_state_seed': seed, 'joint_states_checked': 384, 'maximum_joint_state_error': maximum,
            'completion_pairs': pairs, 'actual_joint_result_controls_consumer': True}


def guards(session, record, packet):
    refused = []
    def no(name, function):
        try:function()
        except ValueError:refused.append(name);return
        raise AssertionError('Accepted '+name)
    wrong = deepcopy(record); wrong['failures'] = 0
    no('observed second-epoch failure removed', lambda: session.decision(wrong))
    wrong = deepcopy(record); wrong['epoch_pair_counts'] = {'11': wrong['shots']}
    no('joint event replaced by a favourable marginal', lambda: session.decision(wrong))
    wrong = deepcopy(packet); wrong['scope'] = 'Independent fresh memory in each epoch'
    no('guarantee moved to a different connection', lambda: session.working_body(wrong))
    wrong = deepcopy(packet); wrong['budget'] = 8
    no('two sixteen-slot words replaced by two shorter words', lambda: session.working_body(wrong))
    with tempfile.TemporaryDirectory() as directory:
        no('unplanned repeat after seeing the result', lambda: session.acquire_next(Path(directory)))
    return refused


def run(output):
    started = time.perf_counter()
    with tempfile.TemporaryDirectory() as directory:
        session, record, packet = joint.acquire(Path(directory))
        original = json.loads((output/'joint-calibration.json').read_text())
        assert joint.single.admission.fingerprint(record['binding']) == joint.single.admission.fingerprint(original['binding'])
        for field in ('failures', 'shots', 'epoch_pair_counts', 'alpha', 'raw_records_sha256'):
            assert record[field] == original[field]
        assert packet['kind'] == 'act' and packet['failure_probability_upper'] < .01
        _, ks = service_fixture(1.3, -.8, .71)
        oracle = [joint_effect(session.source, ks, n) for n in (2, 8, 16)]
        assert oracle[-1]['joint_max_failure'] < packet['failure_probability_upper']
        main = session.working_body(packet); truth = reader_truth_table(main)
        chains = [working(session, packet, ks, seed) for seed in (95021, 95027, 95063)]
        # This check also removes the advantage of spending a larger alpha
        # on the new single candidate. At old alpha=.005 it still admits.
        equal_alpha_upper = 8*joint.single.admission.upper_binomial(record['failures'], record['shots'], .005)
        assert equal_alpha_upper < .01
        result = {'source': joint.single.admission.fingerprint(session.source), 'joint_record_reproduced': True,
            'replay_adds_no_samples_or_confidence': True, 'joint_failure_upper': packet['failure_probability_upper'],
            'joint_upper_at_old_candidate_alpha_005': equal_alpha_upper, 'effect_oracle': oracle,
            'same_single_effect_counterexample': same_effect_counterexample(), 'joint_reader_truth_table': truth,
            'working_chains': chains, 'joint_states_checked': sum(x['joint_states_checked'] for x in chains),
            'maximum_joint_state_error': max(x['maximum_joint_state_error'] for x in chains),
            'refusals': guards(session, record, packet), 'seconds': time.perf_counter()-started, 'new_QPU_jobs': 0,
            'implementation_sha256': digest(Path(joint.__file__)), 'check_sha256': digest(Path(__file__))}
    write(output/'audit.json', result); return result


if __name__ == '__main__':
    p = argparse.ArgumentParser(description=__doc__); p.add_argument('--output', type=Path, required=True)
    result = run(p.parse_args().output.resolve())
    print(json.dumps({k: result[k] for k in ('joint_states_checked', 'maximum_joint_state_error', 'joint_failure_upper', 'seconds')}))
