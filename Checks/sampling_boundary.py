#!/usr/bin/env python3
"""Countable coverage, convergence boundaries and finite internal IID windows.

Infinite claims have comparison proofs in the article. Finite audits below
check exact identities and counterexamples, not an infinite cutoff heuristic.
"""
from fractions import Fraction
from itertools import product
import json
import math
from pathlib import Path
import sys

from closed_information import entropy, equal, pushed


def density(s, power):
    # Exact integer ceil(2**s / s**power), with finite norm bands.
    denominator = s ** power
    return ((1 << s) + denominator - 1) // denominator


def critical_audit():
    cases = 0
    for power, s, moment in product((0, 2, 3, 4), range(1, 257), range(3)):
        term = Fraction(s ** moment * density(s, power), 1 << s)
        base = Fraction(s ** moment, s ** power)
        # These exact bounds extend algebraically to all positive s.
        assert base <= term < base + Fraction(s ** moment, 1 << s)
        cases += 1
    # Convergence follows by comparing to sum s**(moment-power), plus an
    # absolutely convergent geometric remainder. Never infer it from totals.
    finite = {str(p): [p > k + 1 for k in range(3)] for p in (0, 2, 3, 4)}
    assert finite == {'0': [False, False, False], '2': [True, False, False],
                      '3': [True, True, False], '4': [True, True, True]}
    # A rigorous numerical enclosure at the critical point for p=4.
    # For r=p-k>1, integral comparison bounds the power-series tail.
    # For s>=N+1, successive s**k / 2**s terms have ratio at most rho.
    cutoff = 128
    intervals = []
    for k in range(3):
        partial = sum((Fraction(s ** k * density(s, 4), 1 << s)
                       for s in range(1, cutoff + 1)), Fraction())
        r = 4 - k
        lower_tail = Fraction(1, (r-1) * (cutoff+1) ** (r-1))
        upper_tail = Fraction(1, (r-1) * cutoff ** (r-1))
        rho = Fraction((cutoff+2) ** k, 2 * (cutoff+1) ** k)
        geometric_tail = Fraction((cutoff+1) ** k, 1 << (cutoff+1)) / (1-rho)
        assert 0 <= rho < 1
        intervals.append((partial + lower_tail, partial + upper_tail + geometric_tail))
    z, m1, m2 = intervals
    mean = m1[0] / z[1], m1[1] / z[0]
    variance = m2[0] / z[1] - mean[1] ** 2, m2[1] / z[0] - mean[0] ** 2
    assert 0 < mean[0] < mean[1] < 2
    assert 0 < variance[0] < variance[1] < 3
    return {'exact_comparison_cases': cases, 'critical_raw_moments_finite': finite,
            'power4_critical_intervals': {'Z': list(map(float, z)),
                'mean': list(map(float, mean)), 'variance': list(map(float, variance))}}


def coverage_audit():
    cases = 0
    # Finite projections of the countable law p_i=2**(-i). The tail remains
    # an explicit outcome, never a renormalization onto the named prefix.
    for prefix in range(1, 4):
        probabilities = tuple(Fraction(1, 1 << i) for i in range(1, prefix+1))
        probabilities += (Fraction(1, 1 << prefix),)
        for horizon in range(1, 6):
            mass = [Fraction() for _ in range(prefix)]
            any_missing = Fraction()
            for sequence in product(range(prefix+1), repeat=horizon):
                weight = math.prod(probabilities[i] for i in sequence)
                for i in range(prefix):
                    if i not in sequence:
                        mass[i] += weight
                if any(i not in sequence for i in range(prefix)):
                    any_missing += weight
            for i, missing in enumerate(mass):
                assert missing == (1-probabilities[i]) ** horizon
                assert 0 < 1-missing <= horizon * probabilities[i]
                cases += 1
            assert any_missing <= sum(mass)
    # Same one-time marginals do not imply IID: choose one symbol once,
    # then repeat it. Two positive classes are never jointly visited.
    for horizon in range(2, 6):
        support = ((0,) * horizon, (1,) * horizon)
        assert all(set(sequence) != {0, 1} for sequence in support)
        assert all({sequence[t] for sequence in support} == {0, 1} for t in range(horizon))
    return cases


def closed_window(length, probabilities):
    alphabet = range(len(probabilities))
    tapes = tuple(product(alphabet, repeat=length))
    worlds = tuple((tape, phase) for tape in tapes for phase in range(length))
    def step(w):
        tape, phase = w
        return tape[1:] + tape[:1], (phase+1) % length
    def inverse(w):
        tape, phase = w
        return tape[-1:] + tape[:-1], (phase-1) % length
    assert len({step(w) for w in worlds}) == len(worlds)
    assert all(inverse(step(w)) == w and step(inverse(w)) == w for w in worlds)
    def trace(w, n):
        result = ()
        for _ in range(n):
            result += (w[0][0],)
            w = step(w)
        return result
    prepared = {(tape, 0): math.prod(probabilities[i] for i in tape) for tape in tapes}
    h = entropy(dict(enumerate(probabilities)))
    equal(entropy(prepared), length * h)
    for n in range(1, length+2):
        observed = pushed(prepared, lambda w: trace(w, n))
        equal(entropy(observed), min(n, length) * h)
        if n <= length:
            expected = {s: math.prod(probabilities[i] for i in s)
                        for s in product(alphabet, repeat=n)}
            assert observed == expected
        else:
            assert all(s[-1] == s[0] for s in observed)
            assert len(observed) < len(probabilities) ** n
    assert all(trace(w, length+1)[0] == trace(w, length+1)[-1] for w in worlds)
    return len(worlds)


def ensemble_audit():
    # Finite exponential-family identities, entropy bound and exact rare wait
    # versus norm variance. Parameter exp(-lambda)=t is rational here.
    cases = 0
    for norms in product(range(1, 4), repeat=3):
        for t in (Fraction(1, 2), Fraction(1, 4), Fraction(1, 8)):
            weights = tuple(t ** s for s in norms)
            z = sum(weights)
            p = tuple(w/z for w in weights)
            lam = -math.log(t)
            mean = sum(prob*s for prob, s in zip(p, norms))
            variance = sum(prob*(s-mean)**2 for prob, s in zip(p, norms))
            # Derivatives of the finite partition sum, no finite differences.
            z_prime = -sum(s*w for s, w in zip(norms, weights))
            z_second = sum(s*s*w for s, w in zip(norms, weights))
            assert -z_prime/z == mean
            assert z_second/z - (z_prime/z)**2 == variance
            for counts in product(range(4), repeat=3):
                if sum(counts) != 3:
                    continue
                q = tuple(Fraction(c, 3) for c in counts)
                kl = sum(float(a)*math.log(a/b) for a, b in zip(q, p) if a)
                h = -sum(float(a)*math.log(a) for a in q if a)
                cross = lam*float(sum(a*s for a, s in zip(q, norms))) + math.log(z)
                equal(cross-h, kl)
                assert kl >= -1e-12
                cases += 1
    counterexamples = []
    for k in (1, 2, 4, 8):
        t = Fraction(1, 1 << k)
        rare = t/(1+t)
        variance = rare*(1-rare)
        counterexamples.append({'lambda_over_log2': k, 'rare_wait': int(1/rare),
                                'norm_variance': float(variance)})
    assert all(a['rare_wait'] < b['rare_wait'] and a['norm_variance'] > b['norm_variance']
               for a, b in zip(counterexamples, counterexamples[1:]))
    return cases, counterexamples


def markdown(r):
    bounds = r['critical']['power4_critical_intervals']
    return f'''# Sampling a countable closure

A countably infinite class set has no uniform probability distribution.
It has proper full-support distributions, for example p_i=2^(-i), i≥1.
For IID draws, P(class i absent after n draws)=(1-p_i)^n→0. The countable
union of never-visited events has probability zero. Every class is eventually
visited almost surely, while every finite prefix omits infinitely many classes.
Each fixed finite target set A has E[T_A]≤Σ_(i∈A)1/p_i<∞. This is not a
uniform deadline, a computable stopping certificate or a proof of learning
correctness. With an effective enumeration and finite norm bands, ordered
enumeration also visits every class, but is not the unique possible schedule.

## Same exponential rate, different boundary behavior

Let n_p(s)=ceil(2^s/s^p), s≥1. All four examples have γ=ln2.
At λ=γ, s^(-p)≤n_p(s)2^(-s)<s^(-p)+2^(-s).
Multiplying by s^k proves that the kth raw moment numerator converges
exactly when p>k+1. This comparison is a proof for all s. Finite audits do
not decide convergence by looking at a large cutoff.

| p | Z at γ | Mean as λ↓γ | Variance as λ↓γ |
|---|---|---|---|
| 0 | Infinite | Infinite | Infinite |
| 2 | Finite | Infinite | Infinite |
| 3 | Finite | Finite | Infinite |
| 4 | Finite | Finite | Finite |

For p=4, exact rational partial sums with analytic tail bounds enclose:
Z in {bounds['Z']}, mean in {bounds['mean']}, variance in {bounds['variance']}.
Only the displayed endpoints are rounded to floating point.
These are abstract finite-band count sequences. They refute conclusions
from γ alone, without claiming every sequence comes from a particular VI grammar.

For finite γ=limsup log(n(s))/s, λ>γ gives convergence and all norm moments,
λ<γ gives divergence, and λ=γ needs the actual density. On the open domain,
ψ=ln Z has -ψ'=mean and ψ''=variance. ψ is a log-partition function, not
directly thermodynamic free energy. A physical temperature or heat capacity
requires a physical implementation and the appropriate parameter factors.
The Gibbs law maximizes entropy among finite-entropy competitors with its
same finite mean, by D(q||p)=λE_q[s]+lnZ-H(q)≥0. This does not assert existence
for every requested mean or identify a deterministic enumeration with λ→0.

## Waiting time is not norm variance

Two classes of norms 1 and 2, with exp(-λ)=2^(-k), have rare-class probability
1/(2^k+1). As k goes 1,2,4,8, mean wait goes 3,5,17,257, while norm variance
decreases toward zero. Sampling delay and the ensemble's variance differ.

## IID windows inside one finite whole

For autonomous finite Ω with deterministic U and reading E, a length-n
observation tuple is a function of the initial whole state. Thus
H(Y_1,…,Y_n)≤H(Ω_0). If the readings are IID with nonzero entropy h,
nh≤H(Ω_0)≤log2|Ω|. With m positive-probability symbols, their support also
requires m^n≤|supp Ω_0|. An infinite nondegenerate IID stream therefore is
not supplied by a deterministic finite closed whole.
This exact-independence bound does not assess the practical quality of a
pseudorandom generator or exclude approximate independence for specified tests.

A positive bounded construction has an internal length-L tape and clock.
Each tick rotates the tape and advances the clock cyclically. Both inverses
are explicit. Prepare the tape from p^L and clock at zero: the first L reads
are IID, the next repeats the first. Whole entropy is L H(p), preserved.
The tuple is an analytical observation map, not an extra physical recorder.
A retained transcript would also need storage inside Ω. The input product
preparation is an assumption, not generated independent randomness.

Closure itself does not forbid an infinite IID process. On A^Z with product
measure p^Z, the two-sided shift is a bijective measure-preserving map and
coordinate-zero readings are IID. This standard infinite-state construction
has all its coordinates inside the whole. It is not a finite device or a
derived physical implementation. No finite audit certifies that infinite space.

Checks: {r['critical']['exact_comparison_cases']} exact critical-term comparisons,
{r['coverage_identities']} exhaustive finite projected missing-class identities,
{r['ensemble_identities']} finite entropy/partition identities and
{r['whole_states']} closed states across {r['whole_models']} tape models.
The Swift witness projects three cyclic readings and derives the repeated
fourth reading. It does not encode probabilities or prove an infinite theorem.

Sources: [Fithian, exponential families](https://www.stat.berkeley.edu/~wfithian/courses/stat210a/exponential-families.html),
differential identities on the parameter-space interior;
[MIT, radius of convergence](https://ocw.mit.edu/ans7870/18/18.013a/textbook/HTML/chapter30/section04.html).
For the infinite construction, see [Solomyak, Example 1.5](https://u.math.biu.ac.il/~solomyb/TEACH/20/ET/Lec1.pdf).
The elementary coverage and comparison proofs are written above. These
standard probability and convergence facts are not claimed as VI inventions.
'''


def main():
    result = {'critical': critical_audit(), 'coverage_identities': coverage_audit()}
    count, counterexamples = ensemble_audit()
    result.update(ensemble_identities=count, waiting_counterexamples=counterexamples)
    probabilities = ((Fraction(1, 2), Fraction(1, 2)),
                     (Fraction(1, 3), Fraction(2, 3)),
                     (Fraction(1, 2), Fraction(1, 3), Fraction(1, 6)))
    result['whole_states'] = sum(closed_window(n, p) for p in probabilities for n in range(1, 5))
    result['whole_models'] = 12
    result = json.loads(json.dumps(result))
    root = Path(__file__).parent / 'Reports'
    if '--write' in sys.argv:
        (root / 'sampling_boundary.json').write_text(json.dumps(result, indent=2) + '\n')
        (root / 'sampling_boundary.md').write_text(markdown(result))
    assert result == json.loads((root / 'sampling_boundary.json').read_text())
    assert markdown(result) == (root / 'sampling_boundary.md').read_text()
    print(f"sampling: {result['critical']['exact_comparison_cases']} critical comparisons, {result['coverage_identities']} missing-class identities, {count} ensemble identities, {result['whole_states']} whole states; boundary and IID-window reports agree")


if __name__ == '__main__':
    main()
