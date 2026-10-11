#!/usr/bin/env python3
"""Finite interpretation checks and counterexamples for boundary transport.

Analytical norm, sharpness and planning proofs are in the companion report.
No cloud calls; old simulation evidence is replayed, not newly acquired.
"""
import argparse
from copy import deepcopy
from itertools import product
import json
from pathlib import Path

import numpy as np
from qiskit.quantum_info import Kraus, SuperOp

import memory_boundary as b
import whole_word_admission as a
from environment import digest, write


def distance(r, s): return float(np.linalg.norm(r-s, ord='nuc')/2)
def reject(f):
    try: f()
    except (ValueError, AssertionError): return
    raise AssertionError('Unjustified application accepted')


def channel(rng, din, dout, rank):
    z = rng.normal(size=(rank*dout, din))+1j*rng.normal(size=(rank*dout, din))
    return list(np.linalg.qr(z)[0].reshape(rank, dout, din))


def transport():
    rng = np.random.default_rng(640201); worst = 0.; rows = []
    for k in range(12):
        m, out, mi, mo = [(2, 3, 3, 2), (3, 2, 2, 1), (2, 2, 2, 3)][k % 3]
        ks = channel(rng, 2*m, 2*out, 4); pre = channel(rng, mi, m, 3); post = channel(rng, out, mo, 4)
        u = a.ideal(['h', 's']); _, gamma = a.blocks(ks, u)
        joint = b.compose([np.kron(a.I, q) for q in post], b.compose(ks, [np.kron(a.I, q) for q in pre]))
        _, got = a.blocks(joint, u)
        predicted = sum(q.conj().T@gamma@q for q in pre)
        residual = float(np.max(abs(got-predicted))); worst = max(worst, residual); assert residual < 1e-11
        # Strong post-change need not preserve the whole superoperator, but
        # cannot alter this data-error effect when it is memory-only and TP.
        old = a.twirled(ks, u)
        after = b.compose([np.kron(a.I, q) for q in post], old)
        assert np.max(abs(a.blocks(after, u)[1]-gamma)) < 1e-11
        z = rng.normal(size=(m, m))+1j*rng.normal(size=(m, m)); tau = z@z.conj().T; tau /= np.trace(tau)
        e = float(np.trace(tau@gamma).real); d = float(np.linalg.eigvalsh(gamma).max())
        for p in (0., .25, .5, 1.):
            transformed = b.compose(old, [np.kron(a.I, q) for q in b.prepare(tau, p)])
            g = a.blocks(transformed, u)[1]
            exact = (1-p)*d+p*e
            assert np.max(abs(g-((1-p)*gamma+p*e*np.eye(m)))) < 1e-11
            assert abs(np.linalg.eigvalsh(g).max()-exact) < 1e-11
        rows.append({'memory_in': m, 'memory_out': out, 'new_in': mi, 'new_out': mo, 'pullback_residual': residual})
    return {'random_complete_channels': 12, 'preparation_instances': 48, 'max_residual': worst, 'cases': rows}


def sharpness_and_limits():
    rows = []
    for weights in ([.5, .5], [.15, .25, .6], [0., .3, .7]):
        tau = np.diag(weights); lam = min(weights); m = len(weights)
        for e in (0., .02, .2, .7, 1.):
            upper = min(1., e/lam) if lam > 0 else 1.
            diag = [e/lam]+[0.]*(m-1) if lam > 0 and e <= lam else [1.]+[(e-lam)/(1-lam)]*(m-1)
            gamma = np.diag(diag)
            assert abs(np.trace(tau@gamma)-e) < 1e-12
            ks = [np.kron(a.I, np.diag(np.sqrt(1-np.array(diag)))), np.kron(a.X, np.diag(np.sqrt(diag)))]
            for p in (0., .25, .5, 1.):
                wrapped = b.compose(ks, [np.kron(a.I, q) for q in b.prepare(tau, p)])
                actual = float(np.linalg.eigvalsh(a.blocks(wrapped, a.I)[1]).max())
                bound = (1-p)*upper+p*e
                assert abs(actual-bound) < 1e-11
            rows.append({'tau_eigenvalues': weights, 'calibrated_failure': e, 'worst_unprepared': upper})
    # Same exact scalar, two compatible mechanisms. Partial preparation
    # improves the bad-direction source and leaves isotropic error unchanged.
    e = .0004
    gains = {name: [(1-p)*d+p*e for p in (0., .5, 1.)]
             for name, d in [('isotropic', e), ('one_bad_memory_direction', 2*e)]}
    # CZ / CZ cancels with internal memory retained. Depolarizing between
    # those calls does not implement depolarizing before the whole pair.
    cz = [np.diag([1., 1., 1., -1.])]
    prep = [np.kron(a.I, q) for q in b.prepare(a.I/2, 1.)]
    boundary = b.compose(b.compose(cz, cz), prep)
    internal = b.compose(cz, b.compose(prep, cz))
    boundary_error = a.bell_failure(boundary, a.I, a.I/2)
    internal_error = a.bell_failure(internal, a.I, a.I/2)
    assert boundary_error < 1e-12 and abs(internal_error-.5) < 1e-12
    # It is not a guarantee to restore E and its reference.
    bell = np.array([1, 0, 0, 1])/np.sqrt(2); rho = np.outer(bell, bell)
    memory_changed = a.apply(b.prepare(a.I/2, 1.), rho, 2)
    memory_error = distance(memory_changed, rho)
    assert abs(memory_error-.75) < 1e-12
    # Coherent joint drift with the same old data target is not a transport
    # by known memory-only channels: W=I becomes X_D tensor I_E.
    old = a.blocks([np.eye(4)], a.I)[1]
    new = a.blocks([np.kron(a.X, a.I)], a.I)[1]
    assert np.linalg.norm(old) == 0 and np.allclose(new, a.I)
    return {'sharp_scalar_cases': rows, 'distance_at_preparation_weights_0_half_1': gains,
            'whole_boundary_Bell_failure': boundary_error, 'internal_insertion_Bell_failure': internal_error,
            'full_preparation_memory_reference_error': memory_error, 'unknown_joint_drift_changes_zero_effect_to_identity': True}


def applications(directory):
    olddir = a.ROOT/'Research/Artifacts/whole-word-admission-20260914'
    oldaudit = json.loads((olddir/'audit.json').read_text())
    frames = json.loads((olddir/'frame-reading.json').read_text())
    reading = json.loads((directory/'boundary-reading.json').read_text())
    source = a.LocalWord(frames); record = source.acquire()
    assert record == oldaudit['application']['record'], 'This is the very same simulated acquisition replay'
    interface = b.BoundaryInterface(source, record, reading)
    e, bound, options = interface.options()
    phi = np.eye(4).reshape(-1)/2; rho = np.outer(phi, phi).astype(complex)
    bs, _ = a.blocks(source.ks, source.u); rr = [q for branch in bs for q in branch]
    results = []
    for n in (3, 4, 5, 6, 7):
        flow = b.BoundaryContinuation(interface, rho, tolerance=.01)
        packet = flow.reserve(n)
        # Independent exhaustive ordered schedules for n<=7, rather than
        # the producer's multiset enumeration and existing generic selector.
        prices = []
        for schedule in product(options, repeat=n):
            success = float(np.prod([1-options[q]['one_use_bound'] for q in schedule]))
            if success >= .99: prices.append(sum(options[q]['expected_E_controls'] for q in schedule))
        if not prices:
            assert packet['kind'] == 'needs_evidence'
            assert flow.step()['kind'] == 'needs_plan' and np.array_equal(flow.snapshot()[0], rho)
            results.append({'uses': n, 'kind': packet['kind']}); continue
        assert packet['kind'] == 'act' and abs(packet['expected_E_controls']-min(prices)) < 1e-12
        target = rho.copy(); steps = []
        for _ in range(n):
            applied = flow.step(); assert applied['kind'] == 'act'
            _, _, pre = b.decode(reading['recipes'][applied['recipe']])
            mem = b.compose(rr, pre)
            target = a.apply([np.kron(source.u, q) for q in mem], target, 4)
            actual, history, pending = flow.snapshot()
            observed = distance(actual, target)
            assert observed <= applied['total_bound']+1e-10
            steps.append({'recipe': applied['recipe'], 'bound': applied['total_bound'], 'actual_reference_trace_error': observed})
        assert flow.step()['kind'] == 'needs_plan'
        results.append({'uses': n, 'kind': packet['kind'], 'schedule': packet['schedule'], 'bound': packet['total_bound'],
                        'expected_E_controls': packet['expected_E_controls'], 'steps': steps})
    # Planning only the next cheap step consumes a budget that cannot be
    # restored afterwards by the strongest remaining boundary preparation.
    myopic = b.BoundaryContinuation(interface, rho, tolerance=.01)
    for _ in range(3):
        p = myopic.reserve(1); assert p['schedule'] == ['Retain']; myopic.step()
    before = myopic.snapshot(); rescue = myopic.reserve(1)
    assert rescue['kind'] == 'needs_evidence' and np.array_equal(before[0], myopic.snapshot()[0])
    # Actual application obligations, not merely six malformed aliases.
    bad = deepcopy(record); bad['failures'] = 0
    reject(lambda: b.BoundaryInterface(source, bad, reading))
    badreading = deepcopy(reading); badreading['recipes']['Half']['tree'] = {'pauli': 'I'}
    reject(lambda: b.BoundaryInterface(source, record, badreading))
    badreading = deepcopy(reading); badreading['recipes']['Half']['target'] = 'D'
    reject(lambda: b.BoundaryInterface(source, record, badreading))
    changed = a.LocalWord(frames, residual_sine=.03)
    reject(lambda: b.BoundaryInterface(changed, record, reading))
    pure = a.LocalWord(frames, tau=np.diag([1., 0.])); pure_record = pure.acquire(simulation_seed=2)
    reject(lambda: b.BoundaryInterface(pure, pure_record, reading))
    flow = b.BoundaryContinuation(interface, rho, tolerance=.01); flow.reserve(4)
    reject(lambda: flow.reserve(1))
    saved = source.wrapped; source.wrapped = source.ks
    reject(lambda: flow.step()); source.wrapped = saved
    saved = interface.record; interface.record = bad
    reject(lambda: flow.step()); interface.record = saved
    invalid = rho.copy(); invalid[0, 0] -= 1
    reject(lambda: b.BoundaryContinuation(interface, invalid, tolerance=.01))
    threshold = 1-.99**(.25)
    pstar = (bound-threshold)/(bound-e)
    return {'replayed_evidence_sha256': a.fingerprint(record), 'new_acquisition_information': False,
            'bell_failure_upper': e, 'options': options, 'horizons': results,
            'continuous_four_step_minimum_equal_p': pstar,
            'continuous_four_step_expected_E_controls': 3*pstar,
            'myopic_3_then_rescue': rescue['kind'], 'runtime_refusals': 9}


def run(directory):
    report = {'transport': transport(), 'sharpness_and_limits': sharpness_and_limits(),
              'application': applications(directory), 'test_sha256': digest(Path(__file__)),
              'scope': 'Constructed local fixed full channel; no new hardware or general temporal stability claim.'}
    write(directory/'audit.json', report)
    return report


if __name__ == '__main__':
    p = argparse.ArgumentParser(description=__doc__); p.add_argument('--output', type=Path, required=True)
    r = run(p.parse_args().output.resolve())
    print(json.dumps({'max_pullback_residual': r['transport']['max_residual'],
                      'horizons': [{k: v for k, v in h.items() if k != 'steps'} for h in r['application']['horizons']],
                      'refusals': r['application']['runtime_refusals']}, indent=2))
