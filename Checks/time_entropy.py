#!/usr/bin/env python3
"""Exact finite transport, macrocell counting and coarse entropy bookkeeping."""
from collections import Counter
from fractions import Fraction
from itertools import permutations, product
import json
from math import log2
from pathlib import Path
import sys

from closed_information import entropy, equal, pushed


def partitions(n):
    def extend(labels):
        if len(labels) == n:
            yield labels
        else:
            for label in range(max(labels, default=-1) + 2):
                yield from extend(labels + (label,))
    yield from extend(())


def coarse(prior, labels):
    weights = Counter(labels.values())
    macro = pushed(prior, labels.__getitem__)
    return {x: macro[labels[x]] / weights[labels[x]]
            for x in labels if macro.get(labels[x], 0)}


def divergence(prior, reference):
    return sum(float(p) * log2(float(p / reference[x]))
               for x, p in prior.items() if p)


def ledger(prior, labels):
    bar = coarse(prior, labels)
    weights = Counter(labels.values())
    macro = pushed(prior, labels.__getitem__)
    fine = entropy(prior)
    observed = entropy(bar)
    mean_boltzmann = sum(float(p) * log2(weights[a]) for a, p in macro.items())
    debt = divergence(prior, bar)
    equal(observed, entropy(macro) + mean_boltzmann)
    equal(debt, observed - fine)
    assert debt >= -1e-12
    assert bar == coarse(bar, labels)
    return {'fine': fine, 'coarse': observed, 'macro': entropy(macro),
            'mean_boltzmann': mean_boltzmann, 'within_cell_divergence': debt}


def exhaustive():
    counts = {'transition_partitions': 0, 'macro_pairs': 0, 'prior_transports': 0,
              'autonomous_partitions': 0}
    for n in range(1, 5):
        priors = [{x: Fraction(c, 4) for x, c in enumerate(cs) if c}
                  for cs in product(range(5), repeat=n) if sum(cs) == 4]
        for u in permutations(range(n)):
            inverse = tuple(u.index(x) for x in range(n))
            for part in partitions(n):
                labels = dict(enumerate(part))
                weights = Counter(part)
                forward = Counter((part[x], part[u[x]]) for x in range(n))
                backward = Counter((part[y], part[inverse[y]]) for y in range(n))
                next_labels = {a: {part[u[x]] for x in range(n) if part[x] == a}
                               for a in weights}
                autonomous = all(len(targets) == 1 for targets in next_labels.values())
                if autonomous:
                    quotient = {a: next(iter(targets)) for a, targets in next_labels.items()}
                    assert len(set(quotient.values())) == len(weights)
                    assert all(weights[a] == weights[quotient[a]] for a in weights)
                    counts['autonomous_partitions'] += 1
                counts['transition_partitions'] += 1
                for a, b in product(weights, repeat=2):
                    pf = Fraction(forward[a, b], weights[a])
                    pr = Fraction(backward[b, a], weights[b])
                    assert forward[a, b] == backward[b, a]
                    assert weights[a] * pf == weights[b] * pr
                    if pf:
                        assert pf / pr == Fraction(weights[b], weights[a])
                        equal(log2(float(pf / pr)), log2(weights[b])-log2(weights[a]))
                    counts['macro_pairs'] += 1
                # Uniform complete-state measure gives the invariant macro weights.
                for b in weights:
                    arriving = sum((Fraction(weights[a], n)
                                    * Fraction(forward[a, b], weights[a])
                                    for a in weights), Fraction())
                    assert arriving == Fraction(weights[b], n)
                for prior in priors:
                    after = pushed(prior, u.__getitem__)
                    before_l, after_l = ledger(prior, labels), ledger(after, labels)
                    equal(before_l['fine'], after_l['fine'])
                    equal(after_l['coarse']-before_l['coarse'],
                          after_l['within_cell_divergence']-before_l['within_cell_divergence'])
                    if autonomous:
                        assert coarse(after, labels) == pushed(coarse(prior, labels), u.__getitem__)
                        equal(after_l['coarse'], before_l['coarse'])
                        equal(after_l['mean_boltzmann'], before_l['mean_boltzmann'])
                    if prior == coarse(prior, labels):
                        assert after_l['coarse'] >= before_l['coarse']-1e-12
                    # Repeated uniformization is an explicitly different evolution.
                    projected = coarse(prior, labels)
                    for _ in range(3):
                        next_projected = coarse(pushed(projected, u.__getitem__), labels)
                        assert entropy(next_projected) >= entropy(projected)-1e-12
                        projected = next_projected
                    counts['prior_transports'] += 1
    assert counts['transition_partitions'] == 395 and counts['macro_pairs'] == 2519
    assert counts['prior_transports'] == 13071
    return counts


def closed_clock_example():
    # Both the four-state coordinate and the two-phase clock belong to the whole.
    worlds = tuple(product(range(4), range(2)))
    transposition = (1, 0, 2, 3)
    def step(w):
        x, c = w
        return transposition[x], 1-c
    assert len({step(w) for w in worlds}) == len(worlds)
    assert all(step(step(w)) == w for w in worlds)
    labels = {w: (w[1], 'small' if w[0] == 0 else 'large') for w in worlds}
    refined = {w: (w[1], min(w[0], 2)) for w in worlds}
    assert len(set(refined.values())) == 6
    for w, v in product(worlds, repeat=2):
        # One future reading splits exactly the missing class; it is a
        # mathematical sufficiency witness, not free physical foresight.
        window_equal = (labels[w], labels[step(w)]) == (labels[v], labels[step(v)])
        assert window_equal == (refined[w] == refined[v])
        if refined[w] == refined[v]:
            assert refined[step(w)] == refined[step(v)]
    initial = {(x, 0): Fraction(1, 3) for x in (1, 2, 3)}
    assert coarse(initial, labels) == initial
    actual = initial
    approximate = initial
    rows = []
    for t in range(3):
        row = ledger(actual, labels)
        equal(ledger(actual, refined)['coarse'], log2(3))
        row['phase'] = t % 2
        row['iterated_coarse'] = entropy(approximate)
        rows.append({key: round(value, 12) for key, value in row.items()})
        assert all(w[1] == t % 2 for w in actual)
        if t == 2:
            assert actual == initial
            assert sum((p for w, p in actual.items() if w[0] == 0), Fraction()) == 0
            assert sum((p for w, p in approximate.items() if w[0] == 0), Fraction()) == Fraction(2, 9)
        actual = pushed(actual, step)
        approximate = coarse(pushed(approximate, step), labels)
    assert rows[1]['coarse'] > rows[0]['coarse']
    assert rows[1]['mean_boltzmann'] < rows[0]['mean_boltzmann']
    equal(rows[2]['coarse'], rows[0]['coarse'])
    assert rows[2]['iterated_coarse'] > rows[1]['iterated_coarse']

    # Uniformity inside the initially declared cells is necessary for the
    # lower bound relative to initial coarse entropy, not for the exact ledger.
    point = {(1, 0): Fraction(1)}
    assert ledger(pushed(point, step), labels)['coarse'] < ledger(point, labels)['coarse']
    # A non-injective whole map invalidates the preserved-fine-entropy premise.
    erased = pushed(initial, lambda w: (0, 0))
    assert entropy(erased) < entropy(initial)
    # Correct reverse probabilities use the inverse map, not the same forward
    # map, unless an additional reversal relation has been supplied.
    cycle = (1, 2, 3, 0)
    assert cycle[0] == 1 and cycle[1] != 0
    assert cycle.index(1) == 0
    return {'whole_states': len(worlds), 'rows': rows,
            'autonomous_refined_cells': 6,
            'actual_small_after_two': '0', 'iterated_small_after_two': '2/9'}


def retained_history_example():
    worlds = tuple(product(range(4), range(2)))
    def step(w):
        return (1, 0, 2, 3)[w[0]], 1-w[1]
    def append(history):
        return history + (step(history[-1]),)
    layer = tuple((w,) for w in worlds)
    prior = {((x, 0),): Fraction(1, 3) for x in (1, 2, 3)}
    rows = []
    for t in range(7):
        assert len(set(layer)) == 8
        assert len({h[-1] for h in layer}) == 8
        assert all(len(h) == t+1 for h in layer)
        labels = {h: (len(h), h[-1][1], h[-1][0] == 0) for h in layer}
        # In the full space of all valid nonempty histories, a fixed length
        # has exactly these eight histories, so the reading cells are complete.
        value = ledger(prior, labels)
        equal(value['fine'], log2(3))
        rows.append({'history_length': t+1, 'coarse': round(value['coarse'], 12)})
        next_layer = tuple(append(h) for h in layer)
        assert all(after[:-1] == before for before, after in zip(layer, next_layer))
        assert not set(layer) & set(next_layer)
        prior = pushed(prior, append)
        layer = next_layer
    assert rows[1]['coarse'] > rows[2]['coarse']
    equal(rows[0]['coarse'], rows[2]['coarse'])
    return {'checked_history_states': 56, 'rows': rows}


def markdown(result):
    rows = '\n'.join('| ' + ' | '.join(str(row[k]) for k in
                    ('phase', 'fine', 'coarse', 'mean_boltzmann', 'iterated_coarse')) + ' |'
                     for row in result['clock']['rows'])
    return f'''# Time, entropy and an extra forgetting step

Let a fixed reading partition a finite complete-state space K into cells M_a
of size w_a. Let U be a permutation. All logarithms here use base two.
For a distribution mu put p_a=mu(M_a) and bar_mu(x)=p_a/w_a inside M_a.
These are probability descriptions of one declared whole, not an external
source choosing the laws or adding randomness to its actual evolution.

## An exact entropy ledger

H(bar_mu)=H(p)+sum_a p_a log2(w_a).
D(mu||bar_mu)=H(bar_mu)-H(mu)>=0.
Permutation evolution preserves H(mu), so changes in H(bar_mu) equal changes
in this within-cell divergence. It measures structure lost by uniformizing
the cells; it is not automatically heat or a physical entropy production.
If mu starts uniform within every occupied cell, H(bar_mu_t)>=H(bar_mu_0).
This lower bound relative to the prepared start does not imply monotonicity
between arbitrary subsequent times. Average log cell size is also a different
quantity: its difference from H(bar_mu) is the macro-outcome entropy H(p).

## Forward and inverse cell counts

N_ab=|M_a intersect U^(-1)(M_b)| counts both forward transitions a to b
and inverse transitions b to a. Under separate uniform cell preparations,
P_U(b|a)/P_inverse(a|b)=w_b/w_a whenever N_ab>0.
Thus the logarithm of that probability ratio equals the log-volume change.
No sign of time or entropy growth is selected by the identity. For a general
U, the inverse experiment is not the same forward process started in b.
The macro measure w_a/|K| is stationary. Applying the same counting argument
to any power of U is valid; it does not require a macro Markov assumption.

## A whole with an internal clock

K contains x in {{0,1,2,3}} and phase c in {{0,1}}. U swaps x=0 with x=1,
leaves x=2,3 unchanged and flips c. U is its own inverse on all eight states.
The reading retains phase and reports small for x=0, large for x=1,2,3.
Initially c=0 and x is uniform over the large cell. The clock phases are
internal, cyclic and observable in the model. They do not identify an absolute
cycle count or by themselves supply a thermodynamic arrow or permanent record.

| Phase | Whole H | Coarse H | Mean log cell size | Iterated-uniformization H |
| --- | --- | --- | --- | --- |
{rows}

On the first tick coarse entropy rises while mean log cell size falls.
On the second tick the exact whole returns, and coarse entropy falls back.
This is a small non-thermodynamic countermodel to an unconditional inference
from closure and reversible evolution to monotone coarse entropy.

## When the arrow was added by the description

Exact observation at t is Pi U_*^t mu_0. Replacing the distribution by a
uniform one inside each cell after every tick instead gives
(Pi U_*)^t mu_0. Each permutation preserves entropy and each Pi increases
or preserves it, so the latter sequence has non-decreasing entropy.
It is a different sequence. After two ticks the actual probability of the
small cell is zero, while the repeatedly uniformized model predicts 2/9.
The original coarse reading lost distinctions needed to update itself:
in the large cell, x=1 and x=2 have different next readings. This is VI's
execution-closure boundary, now applied to an entropy calculation.

Pi is an inference approximation here. If physical mixing implements it,
that mixing mechanism, its preparation and residual must belong to the whole;
they cannot be silently added to U. A useful approximate macro law requires
a measured or proved error bound and regime of validity.

There is a precise positive repair. Split the large cell into x=1 and
x in {{2,3}}, retaining the phase. The resulting six-class reading determines
its own next value, and its coarse entropy stays log2(3) in this experiment.
The current and next old readings identify exactly these classes, as checked
pairwise. This is a sufficient encoding, not an asserted free measurement.
In general, a deterministic autonomous finite image of a permutation is a
permutation (VI VC20). Its successive fiber sizes are equal, so both coarse
entropy and cell-volume entropy are constant. The audit verifies this on all
{result['audit']['autonomous_partitions']} autonomous partitions in its finite enumeration.

## Keeping every event still does not force monotone entropy

To impose literal retention, use the whole space of all nonempty finite valid
histories h=(w_0,...,w_t), where w_(i+1)=U(w_i). The actual update appends
U(w_t); removing the last entry recovers the prior history. This map is
injective but not onto the singleton histories. The whole has unbounded
capacity. No history recurs, and its length increases on every step.

At each length there are exactly eight histories, in bijection with their
last states because U is a permutation. A reading that reports length, phase
and small/large therefore still has cells of size one or three. Prepare the
same three equiprobable one-entry histories. Whole Shannon entropy stays
log2(3), and coarse entropy still alternates between 1.584963 and 1.974938
bits. Every actual event remains in the whole while the chosen reading's
entropy decreases on alternate steps. This follows for every length from
the formula; {result['history']['checked_history_states']} history states in seven layers
were also checked, including recovery of every preceding prefix.

Thus irreversible growth of a retained historical order is stronger than
finite recurrence permits but still does not entail monotone coarse entropy.
The extra record has an explicit unbounded-capacity premise. It is not
implemented by the finite eight-state machine or by free outside storage.

## Checks and prior art

All {result['audit']['transition_partitions']} permutation/partition models on
one to four labeled states, {result['audit']['macro_pairs']} cell pairs and
{result['audit']['prior_transports']} rational-prior transports were checked.
Probabilities, cell counts and the two-step disagreement are exact Fractions;
entropy and log identities use tolerance 1e-12. All eight clock states and
the inverse are checked. The three missing-premise examples are a nonuniform
initial cell, a noninjective transition and using U instead of its inverse.
General identities have the elementary proofs in VI M38-M40; finite counts
do not prove a physical second law or a cosmological initial condition.

The entropy distinctions and the difference between a bound from the initial
time and genuine monotonicity are established prior art:
[Goldstein, Lebowitz, Tumulka and Zanghi, sections 1 and 8](https://arxiv.org/pdf/1903.11870).
The coarse quantity is the finite one-partition form of
[Safranek, Aguirre and Deutsch's observational entropy](https://arxiv.org/pdf/1905.03841),
Theorem 3 and equation 22. This audit contributes a small complete countermodel
and its VI execution-scope linkage; no priority for those entropy notions is claimed.
'''


def main():
    result = {'audit': exhaustive(), 'clock': closed_clock_example(),
              'history': retained_history_example()}
    root = Path(__file__).parent / 'Reports'
    if '--write' in sys.argv:
        (root / 'time_entropy.json').write_text(json.dumps(result, indent=2) + '\n')
        (root / 'time_entropy.md').write_text(markdown(result))
    assert result == json.loads((root / 'time_entropy.json').read_text())
    assert markdown(result) == (root / 'time_entropy.md').read_text()
    print(f"time/entropy: {result['audit']}; eight-state clock and exact/iterated counterexample agree")


if __name__ == '__main__':
    main()
