#!/usr/bin/env python3
"""First-hit branches, correlated memory, flat execution and honest failure."""
import argparse
from copy import deepcopy
import io
import json
from pathlib import Path
import time

import numpy as np
from qiskit import QuantumCircuit, ClassicalRegister, qpy
from qiskit.circuit.library import UnitaryGate
from qiskit_aer import AerSimulator
from qiskit_aer.library import save_density_matrix

import resident_completion as completion
import resident_workbench as work
from resident_contact_memory_checks import service_fixture
from resident_raw_reply_checks import initial_quantum
from resident_stream_checks import operators, apply
from environment import write, digest


Z_DATA = np.kron(work.admission.I, np.kron(work.admission.Z, np.eye(4)))
X_DATA = np.kron(work.admission.I, np.kron(work.admission.X, np.eye(4)))


def instruments():
    cases = []
    for name in ('fresh_coin', 'constant_memory', 'alternating_memory'):
        q = QuantumCircuit(3)
        if name == 'fresh_coin':
            q.h(0)
        else:
            q.cx(1, 0)
            if name == 'alternating_memory':
                q.x(1)
        from qiskit.quantum_info import Operator
        u = Operator(q).data
        cases.append((name, UnitaryGate(u), [[u[b::2, ::2]] for b in (0, 1)]))
    for name, values in [('rotated_memory', (1.3, -.8, .71)), ('second_memory', (1.45, .91, 0))]:
        gate, ks = service_fixture(*values); cases.append((name, gate, ks))
    return cases


def reachable_boundary(source, plans):
    compact = completion.interpret(source, plans['reachable']); full = completion.interpret(source, plans['full'])
    assert compact['size'] == 4 and compact['width'] == 2
    assert full['size'] == 5 and full['width'] == 3
    states = plans['reachable']['model']['states']
    assert states == ['000', '001', '011', '100', '101', '110']
    # The missing live state 111 is excluded by actual acquisition and the
    # first-hit boundary, not by assigning it an arbitrary default action.
    return {'reachable_states': states, 'excluded_states': ['010', '111'],
        'reachable_classes': compact['size'], 'full_source_classes': full['size'],
        'completed_class': compact['completed'], 'reachable_initial_classes': compact['initial'],
        'scope': 'Preserve the completion reading and every admitted next action on the same retained quantum carrier.'}


def exact(source, ks, budget):
    maps = operators(source['acquisition']['goal']['raw'], ks)
    live = {(1^b, b): apply(maps[0, b], initial_quantum()) for b in (0, 1)}
    stopped = np.zeros((16, 16), complex); survival = [float(sum(np.trace(x).real for x in live.values()))]
    first_hit = [0.]
    for _ in range(1, budget):
        nxt = {}; hit = 0.
        for (r, first), rho in live.items():
            for b in (0, 1):
                value = apply(maps[r, b], rho)
                if first^b:
                    value = Z_DATA@value@Z_DATA; stopped += value
                    hit += np.trace(value).real
                else:
                    key = (1^(r^b), first)
                    nxt[key] = nxt.get(key, 0)+value
        live = nxt; first_hit.append(float(hit))
        survival.append(float(sum(np.trace(x).real for x in live.values())))
        assert abs(np.trace(stopped).real+survival[-1]-1) < 1e-11
    floor = max(0., min(float(np.linalg.eigvalsh(sum(k.conj().T@k for k in branch)).min()) for branch in ks))
    success = float(np.trace(stopped).real)
    if floor > 1e-12:
        assert success+1e-11 >= 1-(1-floor)**(budget-1)
    return {'budget': budget, 'success_probability': success,
        'unfinished_probability': survival[-1], 'first_hit_probabilities': first_hit,
        'survival_after_contacts': survival, 'expected_actual_contacts': 1+sum(survival[:-1]),
        'minimum_effect_eigenvalue': floor,
        'uniform_floor_success_bound': 1-(1-floor)**(budget-1),
        'scope': 'Unnormalized exact local branch maps; no independent-reply assumption.'}


def marginal_boundary(source):
    rows = {}
    for name, _, ks in instruments()[:3]:
        maps = operators(source['acquisition']['goal']['raw'], ks)
        table = [[float(np.trace(apply(maps[1^first, second],
                     apply(maps[0, first], initial_quantum()))).real)
                  for second in (0, 1)] for first in (0, 1)]
        matrix = np.asarray(table)
        assert np.max(abs(matrix.sum(axis=0)-.5)) < 1e-12
        assert np.max(abs(matrix.sum(axis=1)-.5)) < 1e-12
        rows[name] = {'first_two_actual_replies': table,
                      'probability_of_completion_at_second_contact': float(matrix[0, 1]+matrix[1, 0])}
    assert rows['constant_memory']['probability_of_completion_at_second_contact'] == 0
    assert abs(rows['alternating_memory']['probability_of_completion_at_second_contact']-1) < 1e-12
    return {'same_individual_reply_marginals': [.5, .5], 'different_joint_laws': rows,
            'scope': 'One-shot marginals do not determine this path-dependent goal. The same M survives both actual contacts.'}


def completed_state_boundary(source, selection):
    # Both circuits truthfully report completion. The second silently performs
    # a further retained-memory contact, which changes an allowed joint reading.
    _, service, _ = next(x for x in instruments() if x[0] == 'alternating_memory')
    zz = np.kron(np.eye(4), np.kron(work.admission.Z, work.admission.Z)); values = []
    for extra in (False, True):
        q = completion.circuit(source, selection, service, 3)
        if extra:
            q.append(service, [0, 1, 2]); q.measure(0, q.cregs[2][0])
            q.reset(0); q.store(q.cregs[2][0], False)
        save_density_matrix(q, [1, 2, 3, 4], label='retained', pershot=True)
        result = AerSimulator(method='statevector', max_parallel_threads=1).run(
            q, shots=64, memory=True, seed_simulator=81919).result()
        observed = [float(np.trace(zz@state.data).real) for state in result.data()['retained']]
        expected = -1 if extra else 1
        assert max(abs(x-expected) for x in observed) < 1e-12
        completed_position = q.find_bit(q.cregs[3][0]).index
        assert all((int(record.replace(' ', ''), 2) >> completed_position) & 1 for record in result.get_memory())
        values.append({'extra_service_after_success': extra, 'completed_records': 64,
                       'retained_ZE_ZM': expected})
    return {'cases': values, 'joint_states_checked': 128,
            'scope': 'A correct success bit does not certify that the first-hit quantum state was preserved. Local ideal counterexample, not hardware noise.'}


def selective_relations(source, selection):
    # General nonprojective two-Kraus-per-outcome instrument, not only the
    # one-Kraus outcomes of the SDK's three-wire dilation.
    rng = np.random.default_rng(80381)
    v, _ = np.linalg.qr(rng.normal(size=(16, 4))+1j*rng.normal(size=(16, 4)))
    ks = [[v[4*(2*b+j):4*(2*b+j+1)] for j in (0, 1)] for b in (0, 1)]
    assert np.max(abs(sum(k.conj().T@k for branch in ks for k in branch)-np.eye(4))) < 1e-12
    maps = operators(source['acquisition']['goal']['raw'], ks)
    model = selection['model']; cert = selection['certificate']; classes = cert['classes']
    maximum = 0.; checked = 0
    for i, state in enumerate(model['states']):
        r, first, last = map(int, state); representative = classes.index(classes[i])
        rr, ff, ll = map(int, model['states'][representative])
        for b in (0, 1):
            assert classes[model['operations']['reply'+str(b)][i]] == classes[model['operations']['reply'+str(b)][representative]]
            def instrument(r, f, l):
                if f^l:
                    return [np.eye(16)] if b == 0 else []
                return [Z_DATA@k if f^b else k for k in maps[r, b]]
            left, right = instrument(r, first, last), instrument(rr, ff, ll)
            for a in range(16):
                for c in range(16):
                    x = np.zeros((16, 16), complex); x[a, c] = 1
                    # apply returns scalar zero for an empty list; broadcasting
                    # is intentional for the impossible post-completion reply1.
                    error = float(np.max(abs(apply(left, x)-apply(right, x))))
                    assert error < 1e-12; maximum = max(maximum, error)
            checked += 1
    return {'selective_controller_relations': checked, 'quantum_matrix_units_each': 256,
            'Kraus_operators_per_real_outcome': 2, 'maximum_residual': maximum,
            'post_completion_instrument': 'identity on probe outcome0, zero map on outcome1',
            'scope': 'Full retained quantum operator space, including untouched reference; source monitor is classical.'}


def traced(qc, budget, completed_class):
    q = qc.copy_empty_like(); history = ClassicalRegister(budget, 'audit_slot_values')
    active = ClassicalRegister(budget, 'audit_actual_contacts'); q.add_register(history, active)
    reply = qc.cregs[2][0]; position = 0
    for item in qc.data:
        q.append(item)
        if item.operation.name == 'measure' and item.clbits == (reply,):
            q.store(history[position], reply)
            q.store(active[position], True if position == 0 else completion.active_expression(qc.cregs[0], completed_class))
            position += 1
    assert position == budget
    return q


def sdk_one(source, selection, service, ks, budget, shots):
    ctl = completion.interpret(source, selection)
    qc = completion.circuit(source, selection, service, budget, snapshot=False)
    stream = io.BytesIO(); qpy.dump(qc, stream); stream.seek(0); restored, = qpy.load(stream)
    assert restored == qc and work.ordered_bindings(restored) == work.ordered_bindings(qc)
    q = traced(restored, budget, ctl['completed'])
    save_density_matrix(q, range(5), label='resident', pershot=True)
    with q.if_test((qc.cregs[3][0], 1)):
        q.x(3)
    save_density_matrix(q, range(5), label='consumed', pershot=True)
    result = AerSimulator(method='statevector', max_parallel_threads=1).run(
        q, shots=shots, memory=True, seed_simulator=81173+budget).result()
    assert result.success
    maps = operators(source['acquisition']['goal']['raw'], ks); maximum = 0.
    hits = {}; calls = {}; n = qc.num_clbits; width = ctl['width']
    for i, record in enumerate(result.get_memory()):
        word = int(record.replace(' ', ''), 2)
        values = [(word >> (n+j)) & 1 for j in range(budget)]
        active = [(word >> (n+budget+j)) & 1 for j in range(budget)]
        rho = initial_quantum(); r = 0; first = values[0]; last = first; done = False; hit = None
        for j, (b, contacted) in enumerate(zip(values, active)):
            assert contacted == int(not done)
            if done:
                assert b == 0  # measured clean probe, not a source reply
                continue
            rho = apply(maps[r, b], rho); rho /= np.trace(rho).real
            r = 1^(r^b); last = b
            if first^b:
                rho = Z_DATA@rho@Z_DATA; done = True; hit = j+1
        state = f'{r}{first}{last}'
        cls = selection['certificate']['classes'][selection['model']['states'].index(state)]
        assert (word & ((1 << width)-1)) == cls
        assert ((word >> width) & ((1 << (width+1))-1)) == 0
        assert ((word >> (2*width+1)) & 1) == int(done)
        assert sum(active) == (hit if done else budget)
        hits[str(hit)] = hits.get(str(hit), 0)+1
        calls[sum(active)] = calls.get(sum(active), 0)+1
        consumer = X_DATA if done else np.eye(16)
        for name, value in [('resident', rho), ('consumed', consumer@rho@consumer.conj().T)]:
            expected = np.kron(value, np.diag([1, 0]))
            error = float(np.max(abs(result.data()[name][i].data-expected)))
            assert error < 1e-10; maximum = max(maximum, error)
    return {'budget': budget, 'starting_domain': 'reachable' if selection['reachable'] else 'full',
        'persistent_bits': width, 'qubits': qc.num_qubits, 'classical_bits': qc.num_clbits,
        'QPY_bytes': len(stream.getvalue()), 'maximum_joint_state_error': maximum,
        'first_hit_counts': hits, 'actual_contact_counts': calls, 'joint_states_checked': shots*2,
        'syntax': completion.flat.check_flat_fragment(qc)}


def guards(source, plans):
    refused = []
    def no(name, candidate, reading=source):
        try:
            completion.interpret(reading, candidate)
        except (ValueError, AssertionError):
            refused.append(name); return
        raise AssertionError('Accepted '+name)
    bad = deepcopy(plans['reachable']); bad['reachable'] = False
    no('reachable certificate applied to all source states', bad)
    bad = deepcopy(plans['reachable']); bad['model']['observation'][0]['complete'] = True
    bad['certificate'] = completion.goal.saturate.synthesize(bad['model'])
    no('valid certificate that declares a live state successful', bad)
    bad = deepcopy(plans['reachable']); bad['model']['initial'] = [1, 1]
    bad['certificate'] = completion.goal.saturate.synthesize(bad['model'])
    no('goal provided by a different initial preparation', bad)
    bad_source = deepcopy(source); bad_source['target'] = 0
    no('unestablished target substituted in the reading', plans['reachable'], bad_source)
    return refused


def run(output):
    started = time.perf_counter()
    source = json.loads((output/'completion-reading.json').read_text())
    plans = json.loads((output/'plans.json').read_text()); rows = []; laws = {}; shots = 128
    for name, service, ks in instruments():
        laws[name] = exact(source, ks, 64)
        if name == 'fresh_coin':
            for n in (1, 2, 3, 8, 64):
                law = exact(source, ks, n)
                assert abs(law['success_probability']-(1-2.**(1-n))) < 1e-12
                assert abs(law['expected_actual_contacts']-(3-2.**(2-n))) < 1e-12
        if name == 'constant_memory':
            assert laws[name]['success_probability'] == 0
            assert abs(laws[name]['expected_actual_contacts']-64) < 1e-11
        if name == 'alternating_memory':
            assert abs(laws[name]['first_hit_probabilities'][1]-1) < 1e-12
            assert abs(laws[name]['expected_actual_contacts']-2) < 1e-11
        for n in (1, 2, 3, 8, 64):
            for selection in plans.values():
                rows.append({'instrument': name, **sdk_one(source, selection, service, ks, n, shots)})
        if name in ('constant_memory', 'alternating_memory', 'rotated_memory'):
            qc = completion.circuit(source, plans['reachable'], service, 64)
            with (output/(name+'.qpy')).open('wb') as stream:
                qpy.dump(qc, stream)
    result = {'source': work.admission.fingerprint(source), 'domain': reachable_boundary(source, plans),
        'selective': selective_relations(source, plans['reachable']), 'refusals': guards(source, plans),
        'marginal_boundary': marginal_boundary(source),
        'completed_state_boundary': completed_state_boundary(source, plans['reachable']),
        'exact_laws': laws, 'circuits': len(rows), 'shots_each': shots,
        'joint_states_checked': sum(x['joint_states_checked'] for x in rows),
        'maximum_joint_state_error': max(x['maximum_joint_state_error'] for x in rows), 'cases': rows,
        'seconds': time.perf_counter()-started, 'new_QPU_jobs': 0,
        'implementation_sha256': digest(Path(completion.__file__)), 'check_sha256': digest(Path(__file__)),
        'scope': 'Local first-hit execution with arbitrary retained-memory examples. Counts after completion are dummy probe padding, not new source acquisitions. Not a QPU runtime or physical liveness claim.'}
    write(output/'audit.json', result)
    return result


if __name__ == '__main__':
    p = argparse.ArgumentParser(description=__doc__); p.add_argument('--output', type=Path, required=True)
    result = run(p.parse_args().output.resolve())
    print(json.dumps({k: result[k] for k in ('circuits', 'joint_states_checked', 'maximum_joint_state_error', 'seconds')}))
