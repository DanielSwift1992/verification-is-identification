#!/usr/bin/env python3
"""Stationary retention, preparation and a sharp total-variation bound."""
from fractions import Fraction
from itertools import product
import json
from pathlib import Path
import sys

from closed_information import entropy, equal, mutual, pushed


def tv(left, right):
    return sum((abs(left.get(x, 0)-right.get(x, 0))
                for x in set(left) | set(right)), Fraction()) / 2


def stationary_audit():
    n = 3
    priors = [{i: Fraction(c, 4) for i, c in enumerate(counts) if c}
              for counts in product(range(5), repeat=n) if sum(counts) == 4]
    assert len(priors) == 15
    ranks = tuple(product((Fraction(0), Fraction(1, 2), Fraction(1)), repeat=n))
    counts = {'rank_models': 0, 'monotone_models': 0,
              'stationary_pairs': 0, 'retaining_cache_models': 0}
    for transition in product(range(n), repeat=n):
        for prior in priors:
            after = pushed(prior, transition.__getitem__)
            distance = tv(prior, after)
            stationary = after == prior
            # Independently check TV as a supremum over all finite events.
            differences = [abs(sum(prior.get(i, 0)-after.get(i, 0)
                                   for i in range(n) if mask & (1 << i)))
                           for mask in range(1 << n)]
            assert distance == max(differences)
            for rank in ranks:
                delta = {i: rank[transition[i]]-rank[i] for i in prior}
                expected = sum((prior[i]*delta[i] for i in prior), Fraction())
                assert abs(expected) <= distance
                if all(d >= 0 for d in delta.values()):
                    assert 0 <= expected <= distance
                    for epsilon in (Fraction(1, 2), Fraction(1)):
                        progress = sum((prior[i] for i in prior if delta[i] >= epsilon), Fraction())
                        assert progress <= distance/epsilon
                    if stationary:
                        assert all(d == 0 for d in delta.values())
                    counts['monotone_models'] += 1
                counts['rank_models'] += 1
            if stationary:
                counts['stationary_pairs'] += 1
                # Three identifiable facts, encoded by masks. Cardinality is
                # not used to test retention: verify actual set inclusion.
                for cache in product(range(8), repeat=n):
                    if all(cache[i] & cache[transition[i]] == cache[i] for i in prior):
                        assert all(cache[i] == cache[transition[i]] for i in prior)
                        counts['retaining_cache_models'] += 1
    # Almost surely does not mean everywhere when the prior has null states.
    transition = (0, 2, 2)
    prior = {0: Fraction(1)}
    rank = (0, 0, 1)
    assert pushed(prior, transition.__getitem__) == prior
    assert rank[transition[1]] > rank[1]
    assert all(rank[transition[i]] >= rank[i] for i in range(3))
    return counts


def ring(length):
    tapes = tuple(product(range(2), repeat=length))
    worlds = tuple((tape, phase) for tape in tapes for phase in range(length+1))
    def step(w):
        return w[0], (w[1]+1) % (length+1)
    def inverse(w):
        return w[0], (w[1]-1) % (length+1)
    def cache(w):
        return w[0][:w[1]]
    def rank(w):
        return Fraction(w[1], length)
    assert len({step(w) for w in worlds}) == len(worlds)
    assert all(inverse(step(w)) == w and step(inverse(w)) == w for w in worlds)
    stationary = {w: Fraction(1, len(worlds)) for w in worlds}
    assert pushed(stationary, step) == stationary
    equal(mutual(stationary, lambda w: w[0], cache), length/2)
    assert sum(p*(rank(step(w))-rank(w)) for w, p in stationary.items()) == 0
    gain_mass = sum(p for w, p in stationary.items() if rank(step(w)) > rank(w))
    loss_mass = sum(p for w, p in stationary.items() if rank(step(w)) < rank(w))
    assert gain_mass == Fraction(length, length+1) and loss_mass == Fraction(1, length+1)
    prepared = {(tape, 0): Fraction(1, len(tapes)) for tape in tapes}
    trajectory = []
    for phase in range(length+2):
        expected = phase % (length+1)
        equal(entropy(prepared), length)
        information = mutual(prepared, lambda w: w[0], cache)
        equal(information, expected)
        assert {w[1] for w in prepared} == {expected}
        trajectory.append({'phase': expected, 'whole_entropy_bits': length,
                           'accessible_information_bits': round(information, 12)})
        prepared = pushed(prepared, step)
    # A nonstationary preparation makes the quantitative bound exact.
    tight = {(tape, phase): Fraction(1, len(tapes)*length)
             for tape in tapes for phase in range(length)}
    after = pushed(tight, step)
    distance = tv(tight, after)
    progress = sum(p*(rank(step(w))-rank(w)) for w, p in tight.items())
    assert all(rank(step(w))-rank(w) == Fraction(1, length) for w in tight)
    assert progress == distance == Fraction(1, length)
    equal(entropy(tight), entropy(after))
    equal(mutual(after, lambda w: w[0], cache)-mutual(tight, lambda w: w[0], cache), 1)
    return {'length': length, 'whole_states': len(worlds), 'trajectory': trajectory,
            'tight_tv': str(distance), 'tight_progress': str(progress)}


def unbounded_clock_window():
    # Finite projections of an infinite-clock model, without a wrap. This
    # audit is not a finite exhaustive verification of an infinite carrier.
    cases = 0
    for length in range(1, 5):
        for tape in product(range(2), repeat=length):
            for clock in range(-3, length+3):
                state = tape, clock
                after = tape, clock+1
                assert (after[0], after[1]-1) == state
                before_cache = tape[:min(length, max(clock, 0))]
                after_cache = tape[:min(length, max(clock+1, 0))]
                assert after_cache[:len(before_cache)] == before_cache
                if 0 <= clock < length:
                    assert len(after_cache) == len(before_cache)+1
                cases += 1
    return cases


def markdown(result):
    demo = result['ring4']
    rows = '\n'.join(f"| {r['phase']} | {r['whole_entropy_bits']} | {r['accessible_information_bits']} |"
                     for r in demo['trajectory'])
    return f'''# Stationary retention and prepared growth

## A restriction stronger than finite recurrence

Let U preserve a probability measure μ on the entire state space Ω. If a
measurable real V satisfies V(Ux)≥V(x) almost surely, then V(Ux)=V(x)
almost surely, without requiring invertibility, finite Ω or integrability of V.
For each rational r, monotonicity nests {{V(Ux)≤r}} inside {{V(x)≤r}}.
Stationarity gives equal probabilities. Every strict increase crosses some
rational threshold, so the countable union of these null differences is null.
Measure preservation extends the conclusion to all forward steps on one
full-measure set. This is an almost-sure conclusion, not a claim at null states.

For a fixed countable fact vocabulary, apply the result to each measurable
membership indicator of a retaining cache. Every fact's insertion has zero
probability, and their countable union has zero probability. Thus a cache
that never drops facts also gains none almost surely under this stationary
whole measure. Infinite cardinality is not used as a progress measure.
Fresh facts need stable identities. Truth stability alone is not retention.

## Quantitative finite bound

Put μ'=U_*μ and TV(μ,μ')=sup_A|μ(A)-μ'(A)|. For fixed 0≤V≤1,
|E_μ[V(Ux)-V(x)]|≤TV(μ,μ'). The layer-cake expression for the expectation
integrates event-probability differences, each bounded by TV.
If V does not decrease on the prepared support, then
P_μ(V(Ux)-V(x)≥ε)≤TV(μ,μ')/ε. Without that monotonicity, gains and losses
can cancel. The normalization of V matters; this is not a universal bound
on bits learned, training loss, physical entropy production or energy.

## Closed finite construction

The whole consists of a four-bit retained source and an internal cursor
0…4: {demo['whole_states']} states. U advances the cursor cyclically and keeps
the source unchanged. The decoded accessible cache is the source prefix
ending at the cursor. Its length names stable source positions. Decreasing
the cursor modulo five is the inverse. Access is part of the declared model,
not a claim that a physical reader has no implementation costs.

With a uniform source and cursor prepared at zero:

| Cursor | Whole entropy, bits | I(source; accessible cache), bits |
|---|---|---|
{rows}

The whole entropy stays constant, but its distribution is not stationary:
the supported cursor value changes. The cache grows until wrap, then loses
access while the full source survives. Under the stationary uniform measure
on all 80 states, the mean cache length is constant: four growing phases
are balanced by one reset phase. Stationarity permits such fluctuations.

For a uniform source and cursor uniform on 0…3, one step increases V=cursor/4
by 1/4 on every prepared state. TV(μ,U_*μ)=1/4, so the bound is sharp.
Whole entropy is unchanged and accessible source information rises by one
bit. The next ensemble includes the reset phase, so this preparation does
not justify indefinite monotone growth.

## An infinite closed model can grow indefinitely

Take Ω=A^N×Z: an immutable infinite source tape x and an internal integer
cursor k. U(x,k)=(x,k+1) is bijective. C(x,k) contains (i,x_i) for
0≤i<max(k,0), so every record is finite and C grows by inclusion everywhere.
From k=0 it adds one source position each step. With a product tape law,
the ensemble at time t has cursor δ_t, so the whole distribution changes.
All source coordinates and the cursor remain inside Ω.

There is no U-invariant probability measure on this whole: its cursor
marginal would have equal mass at every integer, which cannot sum to one.
The product tape measure times counting measure is invariant but has
infinite total mass. Thus the stationary-probability premise fails.
This model assumes an infinite tape and unbounded cursor, not a finite
physical implementation. The growing cache expresses expanding access to
an existing internal source. It is not an inference of an unknown physical
law or a creation of information outside the whole.

Checks: {result['finite']['rank_models']} finite rank models,
{result['finite']['stationary_pairs']} stationary transition/prior pairs,
{result['finite']['retaining_cache_models']} retaining cache models,
{result['ring_states']} complete reversible ring states and
{result['unbounded_clock_windows']} finite projections of an unbounded clock.
The infinite assertions have proofs above, not exhaustive finite verification.
Pure Swift exposes one resident source field into a cache pair and rewinds
it, preserving all fields. It does not encode stationary probability or
ensure that an arbitrary Pair is a nonempty physical tape.

Source: [Solomyak, Proposition 1.11](https://u.math.biu.ac.il/~solomyb/TEACH/20/ET/Lec1.pdf).
The stationary monotonicity theorem is established mathematics. This audit
applies it to VI's retention assumptions and separates preparation from
closure and entropy conservation.
'''


def main():
    models = [ring(length) for length in range(1, 6)]
    result = {'finite': stationary_audit(), 'ring_states': sum(m['whole_states'] for m in models),
              'ring4': models[3], 'unbounded_clock_windows': unbounded_clock_window()}
    root = Path(__file__).parent / 'Reports'
    if '--write' in sys.argv:
        (root / 'stationary_memory.json').write_text(json.dumps(result, indent=2) + '\n')
        (root / 'stationary_memory.md').write_text(markdown(result))
    assert result == json.loads((root / 'stationary_memory.json').read_text())
    assert markdown(result) == (root / 'stationary_memory.md').read_text()
    print(f"stationarity: {result['finite']}; {result['ring_states']} whole states, sharp TV bound, prepared growth and reset checked")


if __name__ == '__main__':
    main()
