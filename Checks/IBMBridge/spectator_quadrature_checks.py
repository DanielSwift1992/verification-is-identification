#!/usr/bin/env python3
"""Verify the question against arbitrary states and explicit ambiguities."""
import argparse
import json
from pathlib import Path
import numpy as np
import spectator_quadrature_question as q

X = np.array([[0, 1], [1, 0]], complex)
Y = np.array([[0, -1j], [1j, 0]], complex)
Z = np.diag([1, -1]).astype(complex)
OPS = {a+b: np.kron(x, y) for a, x in zip('XYZ', (X, Y, Z)) for b, y in zip('XYZ', (X, Y, Z))}


def readings(rho):
    return {b: float(np.trace(rho @ OPS[b]).real) for b in q.BASES}


def bell(phi=0, odd=False):
    v = np.zeros(4, complex); v[int(odd)] = 1/np.sqrt(2)
    v[2 if odd else 3] = np.exp(1j*phi)/np.sqrt(2)
    return np.outer(v, v.conj())


def run(out):
    rng = np.random.default_rng(9161630); residual = 0.
    for _ in range(128):
        a = rng.normal(size=(4, 4))+1j*rng.normal(size=(4, 4))
        rho = a@a.conj().T; rho /= np.trace(rho)
        result = q.infer(readings(rho))
        expected = (rho[0, 0].real+rho[3, 3].real)/2 + abs(rho[0, 3])
        residual = max(residual, abs(result['phase_optimized_Bell_overlap']-expected),
                       abs(result['even_coherence_minus_imag_times_two']+2*rho[0, 3].imag))
        phi = result['best_phase'] or 0
        assert abs(np.trace(rho@bell(phi)).real-expected) < 1e-12
        intervals = {b: [max(-1., v-.07), min(1., v+.07)] for b, v in readings(rho).items()}
        bound = q.interval_infer(intervals)['phase_optimized_Bell_overlap']
        assert bound[0] <= expected <= bound[1]

    # XX/XY/ZZ alone cannot isolate the even block when odd parity is present.
    coherent = (bell()+bell(np.pi, odd=True))/2; mixed = np.eye(4)/4
    assert all(abs(readings(coherent)[b]-readings(mixed)[b]) < 1e-12 for b in ('XX', 'XY', 'ZZ'))
    assert abs(q.infer(readings(coherent))['even_coherence_radius']-.5) < 1e-12
    assert q.infer(readings(mixed))['even_coherence_radius'] == 0

    # Two admissible states with exactly the last experiment's empirical
    # minimal_ignore A=0 XX and ZZ, interpreted here only as target numbers.
    # These are NOT reconstructed hardware states or confidence statements.
    x, z = .203125, .609375; p = (1+z)/2
    states = []
    for t, u, odd in [(max(0., x-(1-p)), 0., min(x, 1-p)),
                      (x, np.sqrt(p*p-x*x), 0.)]:
        rho = np.diag([p/2, (1-p)/2, (1-p)/2, p/2]).astype(complex)
        rho[0, 3] = (t-1j*u)/2; rho[3, 0] = rho[0, 3].conjugate()
        rho[1, 2] = rho[2, 1] = odd/2
        assert np.linalg.eigvalsh(rho).min() > -1e-12
        assert abs(readings(rho)['XX']-x) < 1e-12 and abs(readings(rho)['ZZ']-z) < 1e-12
        states.append({'readings': readings(rho), 'question': q.infer(readings(rho))})
    assert np.allclose([s['question']['phase_optimized_Bell_overlap'] for s in states], [.40625, .8046875])

    # The actual acquired bit must weight both quadratures. Independent bit
    # substitution has the same marginal but removes the useful correlation.
    branches = [bell()/2, bell(np.pi)/2]
    z_d = np.kron(Z, np.eye(2)); corrected = branches[0]+z_d@branches[1]@z_d
    same_shot = {b: sum((-1)**a*np.trace(rho@OPS[b]).real for a, rho in enumerate(branches))
                 if b != 'ZZ' else sum(np.trace(rho@OPS[b]).real for rho in branches) for b in q.BASES}
    assert np.allclose(list(same_shot.values()), list(readings(corrected).values()))
    independent_record = {b: 0. if b != 'ZZ' else same_shot[b] for b in q.BASES}
    assert abs(q.infer(same_shot)['fixed_zero_phase_Bell_overlap']-1) < 1e-12
    assert abs(q.infer(independent_record)['fixed_zero_phase_Bell_overlap']-.5) < 1e-12
    for basis in q.BASES:
        for a in (0, 1):
            for d in (0, 1):
                for rr in (0, 1):
                    assert q.record_weighted_parity(a, d, rr, basis) == ((-1)**(d+rr) * ((-1)**a if basis != 'ZZ' else 1))

    result = {'schema': 'vi.spectator-quadrature-question-audit.v1', 'arbitrary_density_matrices_checked': 128,
              'max_algebra_residual': float(residual), 'same_three_readings_counterexample':
              [q.infer(readings(coherent)), q.infer(readings(mixed))],
              'same_old_XX_ZZ_two_distinct_completions': states,
              'same_shot_record_question': q.infer(same_shot),
              'independent_record_substitution': q.infer(independent_record),
              'new_QPU_jobs': 0, 'scope': 'Mathematical question and synthetic counterexamples, not hardware identification.'}
    out.mkdir(parents=True, exist_ok=True); (out/'quadrature-audit.json').write_text(json.dumps(result, indent=2)+'\n')
    return {'arbitrary_states': 128, 'residual': residual,
            'same_XX_ZZ_phase_optimized_overlaps': [s['question']['phase_optimized_Bell_overlap'] for s in states],
            'new_QPU_jobs': 0}


if __name__ == '__main__':
    parser = argparse.ArgumentParser(); parser.add_argument('--out', type=Path, required=True)
    print(json.dumps(run(parser.parse_args().out), indent=2))
