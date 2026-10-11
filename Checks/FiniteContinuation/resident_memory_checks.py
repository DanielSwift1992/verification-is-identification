#!/usr/bin/env python3
"""Independent matrix interpretation, exact closure and running-state audit."""
import argparse
from copy import deepcopy
from fractions import Fraction as F
from itertools import product
import json
from pathlib import Path

import numpy as np
from qiskit.quantum_info import Operator, Kraus, SuperOp

import resident_memory as r
import whole_word_admission as a
from environment import write, digest

REFUSALS = 0


def reject(f):
    global REFUSALS
    try: f()
    except (ValueError, AssertionError):
        REFUSALS += 1
        return
    raise AssertionError('Invalid continuation accepted')


def analytic_step(reading):
    v = np.zeros((16, 16), complex)
    for row in reading['rows']:
        control = np.zeros((4, 4)); control[2*row['program']+row['next_clock'], 2*row['program']+row['clock']] = 1
        v += np.kron(control, np.kron({'h': a.H, 's': a.S}[row['gate']], a.Z))
    return v


def renewed(name, rho):
    if name == 'coordinated_PC': ks = [np.eye(16)/np.sqrt(2), r.at(a.X, 0)@r.at(a.X, 1)/np.sqrt(2)]
    elif name.endswith('dephase'):
        reg = 0 if name == 'program_dephase' else 3
        ks = [np.eye(16)/np.sqrt(2), r.at(a.Z, reg)/np.sqrt(2)]
    else:
        reg = {'service_uniform': 3, 'program_uniform': 0, 'clock_uniform': 1, 'data_uniform': 2}[name]
        ks = [r.at(p, reg)/2 for p in a.P]
    return a.apply(ks, rho, len(rho)//16)


def vector(item):
    v = [F(0)]*r.N
    for i, x in item['vector']: v[i] = F(x)
    return tuple(v)


def interpretation(reading):
    v = analytic_step(reading); compiled = Operator(r.circuit(reading)).data
    assert np.allclose(v.conj().T@v, np.eye(16), atol=1e-12)
    residual = float(np.max(abs(v-compiled))); assert residual < 1e-11
    actions = {'tick': v, 'reopen_service': np.kron(np.eye(4), np.diag([1, 1, 1, -1]))}
    maps = r.maps(reading); worst = residual
    for name, op in actions.items():
        for i, key in enumerate(r.KEYS):
            basis = tuple(F(int(k == i)) for k in range(r.N))
            actual = op.conj().T@r.basis_matrix(key)@op
            wanted = r.matrix(r.push(basis, maps[name]))
            error = float(np.max(abs(actual-wanted))); worst = max(worst, error); assert error < 1e-11
    for name in r.RENEWALS:
        for i, key in enumerate(r.KEYS):
            basis = tuple(F(int(k == i)) for k in range(r.N))
            # All offered renewal channels are self-adjoint. Evaluating this
            # linear expression on an observable requires no density assumption.
            actual = renewed(name, r.basis_matrix(key))
            wanted = r.matrix(r.push(basis, r.renewal_map(name)))
            assert np.max(abs(actual-wanted)) < 1e-11
    return {'fixed_circuit_matrix_residual': residual, 'Heisenberg_images_checked': 128,
            'renewal_images_checked': r.N*len(r.RENEWALS), 'maximum_residual': worst}, actions


def exact_spaces(reading, actions):
    cases = []
    for names, expected in [(('tick',), 7), (('tick', 'reopen_service'), 13)]:
        cert = r.closure(reading, names); assert cert['dimension'] == expected
        # An independently specified closed form for the entire space.
        hand = r.Span(); hand.add(r.query('I'))
        for parity, d, e in product((0, 1), ('X', 'Y', 'Z'), ('I',) if expected == 7 else ('I', 'Z')):
            hand.add(tuple(F((-1)**(parity*(p+c)) if dd == d and ee == e else 0) for p, c, dd, ee in r.KEYS))
        assert len(hand.rows) == expected
        for item in cert['basis']: assert not any(hand.residual(vector(item)))
        witnesses = {}
        for name, decision in cert['renewals'].items():
            if decision['allowed']: continue
            w = decision['witness']; delta = [F(0)]*r.N
            for i, x in w['observable_delta']: delta[i] = F(x)
            op = r.matrix(delta); vals, vecs = np.linalg.eigh(op)
            i = int(np.argmax(abs(vals))); psi = vecs[:, i]; rho = np.outer(psi, psi.conj())
            other = renewed(name, rho)
            for action in w['word']:
                rho = a.apply([actions[action]], rho); other = a.apply([actions[action]], other)
            observable = r.matrix(r.query(w['question']))
            observed = float(np.trace(observable@(other-rho)).real)
            assert abs(observed-vals[i]) < 1e-10 and abs(observed) > .1
            witnesses[name] = {'question': w['question'], 'word': w['word'], 'expectation_difference': observed,
                               'binary_probability_difference': abs(observed)/2}
        cases.append({'certificate': cert, 'independent_closed_form_dimension': expected, 'physical_witnesses': witnesses})
    extra = r.closure(reading, ('tick',), ('X', 'Y', 'Z', 'program_Z'))
    assert extra['dimension'] == 8 and not extra['renewals']['coordinated_PC']['allowed']
    return cases, extra


def channels_and_execution(reading, action_matrices, cases, extra):
    rng = np.random.default_rng(649201); maximum = 0.; reference_error = 0.; repeated = 0; programs = []
    for p in (0, 1):
        psi = np.zeros(16); psi[8*p] = 1
        resident = r.Resident(reading, np.outer(psi, psi)); initial_tick_hash = resident._tick_hash
        resident.step(); resident.step(); state, history = resident.snapshot()
        x = float(np.trace(r.matrix(r.query('X'))@state).real)
        y = float(np.trace(r.matrix(r.query('Y'))@state).real)
        assert np.allclose((x, y), (0, 1) if p == 0 else (1, 0), atol=1e-10)
        assert resident._tick_hash == initial_tick_hash
        assert abs(np.trace(r.at(a.Z, 0)@state)-(-1)**p) < 1e-10
        assert abs(np.trace(r.at(a.Z, 1)@state)-1) < 1e-10
        programs.append({'initial_program': p, 'same_step_sha256': initial_tick_hash, 'two_tick_data_X': x, 'two_tick_data_Y': y, 'clock_returned': True})
    assert programs[0]['same_step_sha256'] == programs[1]['same_step_sha256']
    # All-state/reference intertwining checked as complete superoperator
    # equalities, not just agreement of selected initial vectors.
    reductions = []
    for item in cases:
        cert = item['certificate']; keep, ks, vsmall = r.reduction(reading, cert)
        sm = {'tick': vsmall}
        if keep: sm['reopen_service'] = np.kron(np.eye(2), np.diag([1, 1, 1, -1]))
        residuals = {}
        for name in cert['future_actions']:
            left = SuperOp(Kraus([k@action_matrices[name] for k in ks])).data
            right = SuperOp(Kraus([sm[name]@k for k in ks])).data
            error = float(np.max(abs(left-right))); assert error < 1e-11
            residuals[name] = error
        for trial in range(4):
            z = rng.normal(size=32)+1j*rng.normal(size=32); z /= np.linalg.norm(z); rho = np.outer(z, z.conj())
            original = r.Resident(reading, rho, actions=tuple(cert['future_actions']))
            renewed_process = r.Resident(reading, rho, actions=tuple(cert['future_actions']))
            owner = r.Resident(reading, rho, actions=tuple(cert['future_actions']))
            small = owner.reduce(); reject(lambda: owner.step()); reject(lambda: owner.snapshot())
            for step in range(9):
                action = cert['future_actions'][int(rng.integers(len(cert['future_actions'])))]
                renewed_process.renew('coordinated_PC')
                renewed_process.renew('service_dephase' if keep else 'service_uniform')
                original.step(action); renewed_process.step(action); small.step(action)
                full = original.snapshot()[0]; altered = renewed_process.snapshot()[0]; reduced = small.snapshot()[0]
                want = a.apply(ks, full, 2)
                error = float(np.max(abs(reduced-want))); maximum = max(maximum, error); assert error < 1e-10
                for axis in ('X', 'Y', 'Z'):
                    op = np.kron(r.matrix(r.query(axis)), np.eye(2))
                    error = abs(np.trace(op@(full-altered))); assert error < 1e-10
                # Retained quantum D AND its untouched reference, not merely
                # the three unconditioned data means, must agree.
                def data_reference(state):
                    return np.einsum('pderpfes->drfs', state.reshape(4, 2, 2, 2, 4, 2, 2, 2)).reshape(4, 4)
                error = float(np.max(abs(data_reference(full)-data_reference(altered))))
                reference_error = max(reference_error, error); assert error < 1e-10
                repeated += 1
        reductions.append({'service_retained': keep, 'original_hilbert_dimension': 16, 'reduced_hilbert_dimension': 8 if keep else 4, 'intertwining_residuals': residuals})
    # The scope changes an actual permission, not merely a cached status.
    psi = np.zeros(16); psi[0] = 1; rho = np.outer(psi, psi)
    owner = r.Resident(reading, rho); old = owner.certificate()
    reject(lambda: owner.renew('program_uniform'))
    owner.set_scope(('tick', 'reopen_service'))
    before = owner.snapshot(); reject(lambda: owner.renew('service_uniform', old))
    reject(lambda: owner.renew('service_uniform'))
    assert np.array_equal(owner.snapshot()[0], before[0])
    owner.set_scope(('tick',), ('X', 'Y', 'Z', 'program_Z'))
    reject(lambda: owner.renew('coordinated_PC'))
    reject(lambda: owner.reduce())
    assert np.array_equal(owner.snapshot()[0], before[0])
    owner = r.Resident(reading, rho); small = owner.reduce()
    reject(lambda: small.step('reopen_service'))
    bad = deepcopy(old); bad['renewals']['program_uniform']['allowed'] = True
    owner = r.Resident(reading, rho); reject(lambda: owner.renew('program_uniform', bad))
    saved = owner._reopen; owner._reopen = np.eye(16); reject(lambda: owner.step()); owner._reopen = saved
    fake = deepcopy(reading); fake['rows'][0]['gate'] = 's'; reject(lambda: r.Resident(fake, rho))
    # Full program coherence is outside the diagonal reading grammar.
    plus = np.array([1, 1])/np.sqrt(2); ppsi = np.kron(plus, np.eye(8)[0]); prho = np.outer(ppsi, ppsi)
    erased = renewed('program_dephase', prho)
    phase_loss = float(np.trace(r.at(a.X, 0)@(prho-erased)).real); assert abs(phase_loss-1) < 1e-12
    return {'different_programs_same_rule': programs, 'reductions': reductions,
            'executed_comparison_steps_with_reference': repeated, 'max_reduced_state_residual': maximum,
            'max_renewed_data_reference_residual': reference_error,
            'program_coherence_reading_changes_outside_scope': phase_loss,
            'runtime_refusals': REFUSALS}


def run(directory):
    global REFUSALS
    REFUSALS = 0
    reading = json.loads((directory/'resident-reading.json').read_text()); r.validate(reading)
    interpreted, actions = interpretation(reading)
    cases, extra = exact_spaces(reading, actions)
    result = {'interpretation': interpreted, 'spaces': cases, 'expanded_question_certificate': extra,
              'execution': channels_and_execution(reading, actions, cases, extra),
              'test_sha256': digest(Path(__file__)), 'cloud_jobs': 0,
              'scope': 'Exact finite-model result and local SDK execution, not an autonomous quantum hardware demonstration.'}
    write(directory/'audit.json', result); return result


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__); parser.add_argument('--output', required=True, type=Path)
    result = run(parser.parse_args().output.resolve())
    print(json.dumps({'interpretation': result['interpretation'],
                      'spaces': [{'dimension': c['certificate']['dimension'], 'renewals': {n: d['allowed'] for n, d in c['certificate']['renewals'].items()}} for c in result['spaces']],
                      'execution': result['execution']}, indent=2))
