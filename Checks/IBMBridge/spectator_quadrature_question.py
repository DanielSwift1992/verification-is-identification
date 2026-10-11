#!/usr/bin/env python3
"""Question-specific Bell coherence; no provider, calibration or diagnosis.

XX, YY, XY, YX and ZZ refer to one common two-qubit output ensemble and
established measurement axes. Optional same-shot record weighting describes
the virtual Z_D^a-corrected ensemble, not postselection on a trusted answer.
"""
from math import atan2, hypot, isfinite

BASES = ('XX', 'YY', 'XY', 'YX', 'ZZ')


def infer(expectations):
    if set(expectations) != set(BASES):
        raise ValueError('All five comparisons required; no implicit even-parity support')
    if not all(isfinite(v) and -1 <= v <= 1 for v in expectations.values()):
        raise ValueError('Invalid expectation')
    e = expectations
    p = (1+e['ZZ'])/2
    t = (e['XX']-e['YY'])/2
    u = (e['XY']+e['YX'])/2
    radius = hypot(t, u)
    return {'even_population': p, 'even_coherence_real_times_two': t,
            'even_coherence_minus_imag_times_two': u, 'even_coherence_radius': radius,
            'best_phase': atan2(u, t) if radius > 0 else None,
            'fixed_zero_phase_Bell_overlap': (p+t)/2,
            'phase_optimized_Bell_overlap': (p+radius)/2,
            # Necessary physical constraint. Descriptive sample estimates
            # may violate it; they are not silently projected into a state.
            'even_block_positivity_residual': max(0., radius-p)}


def interval_infer(intervals):
    """Propagate GIVEN simultaneous expectation intervals, no IID assumption hidden.

Returns conservative bounds if the intervals cover the same physical
    ensemble. It does not obtain those intervals from shots or certify SPAM.
    These are floating evaluations of analytic bounds, not outward-rounded
    computer interval certificates.
"""
    if set(intervals) != set(BASES): raise ValueError('Missing comparison interval')
    if not all(len(v) == 2 and all(isfinite(x) for x in v) and -1 <= v[0] <= v[1] <= 1
               for v in intervals.values()): raise ValueError('Invalid intervals')
    xx, yy, xy, yx, zz = [intervals[k] for k in BASES]
    p = [(1+zz[0])/2, (1+zz[1])/2]
    t = [(xx[0]-yy[1])/2, (xx[1]-yy[0])/2]
    u = [(xy[0]+yx[0])/2, (xy[1]+yx[1])/2]
    r_low = hypot(max(t[0], -t[1], 0), max(u[0], -u[1], 0))
    r_high = min(p[1], hypot(max(abs(v) for v in t), max(abs(v) for v in u)))
    if r_low > p[1]: raise ValueError('Intervals contradict even-block positivity')
    return {'fixed_zero_phase_Bell_overlap': [max(0., (p[0]+t[0])/2), min(1., (p[1]+t[1])/2)],
            'phase_optimized_Bell_overlap': [(p[0]+r_low)/2, min(p[1], (p[1]+r_high)/2)],
            'scope': 'Conditional on simultaneous coverage and a common ensemble with established measurement axes.'}


def record_weighted_parity(a, d, r, basis):
    if basis not in BASES or any(type(v) is not int or v not in (0, 1) for v in (a, d, r)):
        raise ValueError('Actual binary records and a declared basis required')
    return (-1)**(d ^ r ^ (a if basis != 'ZZ' else 0))
