#!/usr/bin/env python3
"""Separate retained entries, covered rules, dispatch and predictive coverage.

All models are finite and deterministic. Hidden truth tables are fixed source
states, not information injected by an external teacher. Probabilistic learning
and physical costs are outside this audit.
"""
from itertools import combinations, product
from fractions import Fraction
from functools import lru_cache
import json
from pathlib import Path
import sys

from operational_quotient import partitions
from entropy_questions import optimal_questions, replay


def version_space(family, observations):
    return tuple(rule for rule in family if all(rule[x] == y for x, y in observations))


def predictable(family):
    assert family, 'empty version space is rejection, not certain prediction'
    return {x: next(iter(values)) for x in range(len(family[0]))
            if len(values := {rule[x] for rule in family}) == 1}


def dispatch(features, targets):
    decoder = {}
    for feature, target in zip(features, targets):
        if feature in decoder and decoder[feature] != target:
            return None
        decoder[feature] = target
    return decoder


def check_prediction(family, observations, query, answer):
    candidates = version_space(family, observations)
    assert candidates and all(rule[query] == answer for rule in candidates)


def coverage_audit():
    cases = 0
    for targets in partitions(4):
        classes = set(targets)
        for length in range(5):
            for sequence in product(range(4), repeat=length):
                raw, covered = set(), set()
                fresh = 0
                for task in sequence:
                    old = covered.copy()
                    raw.add((task, targets[task]))
                    covered.add(targets[task])
                    fresh += targets[task] not in old
                    assert old <= covered <= classes
                    assert covered == {rule for _, rule in raw}
                    assert len(covered) == fresh <= len(classes)
                assert (fresh == len(classes)) == (covered == classes)
                cases += 1
    assert cases == 5115
    print(f'coverage: {cases} task streams obey class projection and fresh-class counting')

    cases = possible = 0
    for features, targets in product(partitions(4), repeat=2):
        decoder = dispatch(features, targets)
        # Independent pair criterion, independent of decoder construction.
        factors = all(features[x] != features[y] or targets[x] == targets[y]
                      for x, y in product(range(4), repeat=2))
        assert (decoder is not None) == factors
        if factors:
            assert all(decoder[features[x]] == targets[x] for x in range(4))
            possible += 1
        else:
            x, y = next((x, y) for x, y in product(range(4), repeat=2)
                        if features[x] == features[y] and targets[x] != targets[y])
            assert all(answer != targets[x] or answer != targets[y] for answer in set(targets))
        cases += 1
    assert cases == 225
    print(f'dispatch: {cases} feature/target partitions, {possible} exact decoders, every failure has a conflicting pair')


def learning_audit():
    cases = 0
    for n in range(1, 6):
        family = tuple(product(range(2), repeat=n))
        for truth in family:
            for mask in range(1 << n):
                seen = tuple(x for x in range(n) if mask & (1 << x))
                evidence = tuple((x, truth[x]) for x in seen)
                candidates = version_space(family, evidence)
                assert truth in candidates and len(candidates) == 2 ** (n - len(seen))
                known = predictable(candidates)
                assert known == dict(evidence)
                for x in range(n):
                    updated = version_space(candidates, ((x, truth[x]),))
                    assert set(known) <= set(predictable(updated))
                    if x not in known:
                        # Explicit indistinguishable whole-source pair: only the
                        # unobserved table cell changes; all recorded data agree.
                        other = truth[:x] + (1 - truth[x],) + truth[x + 1:]
                        assert other in candidates and other[x] != truth[x]
                        assert sum(rule[x] for rule in candidates) * 2 == len(candidates)
                cases += 1
    assert cases == 1364
    print(f'learning: {cases} truth/evidence models, exact version counts and unseen-cell countermodels')

    # Audit every nonempty family of two-input truth tables, every realizable
    # evidence pattern and every family expansion. Expansion may retract certainty.
    universe = tuple(product(range(2), repeat=2))
    cases = retractions = 0
    for size in range(1, 5):
        for family in combinations(universe, size):
            for truth in family:
                for mask in range(4):
                    evidence = tuple((x, truth[x]) for x in range(2) if mask & (1 << x))
                    old = predictable(version_space(family, evidence))
                    for added in universe:
                        expanded = tuple(sorted(set(family) | {added}))
                        new = predictable(version_space(expanded, evidence))
                        assert set(new) <= set(old)
                        assert all(old[x] == answer for x, answer in new.items())
                        retractions += len(new) < len(old)
                        cases += 1
    print(f'learning: {cases} family expansions, {retractions} retract certainty without changing evidence')


def demo():
    targets = (0, 0, 0, 1)
    raw = tuple((task, targets[task]) for task in (0, 1, 2))
    assert len(raw) == 3 > len(set(targets)) == 2
    assert {rule for _, rule in raw} == {0}
    first_library = ((0, 0), (3, 1))
    second_library = ((1, 0), (3, 1))
    assert first_library != second_library
    assert {r for _, r in first_library} == {r for _, r in second_library} == {0, 1}
    assert dispatch((0, 0), (0, 1)) is None
    constants = ((0, 0), (1, 1))
    observations = ((0, 0),)
    assert version_space(constants, observations) == ((0, 0),)
    check_prediction(constants, observations, 1, 0)
    actual = (0, 1)
    assert actual not in constants and actual[0] == 0 and actual[1] == 1
    full = tuple(product(range(2), repeat=2))
    assert version_space(full, observations) == ((0, 0), (0, 1))
    assert predictable(version_space(full, observations)) == {0: 0}
    failures = (
        (full, observations, 1, 0),
        (full, observations, 1, 1),
        (constants, ((0, 0), (1, 1)), 0, 0),
        (constants, observations, 1, 1),
    )
    for args in failures:
        try:
            check_prediction(*args)
        except AssertionError:
            continue
        raise AssertionError('false prediction accepted')
    # Same complete four-rule library and same allowed tests, different dispatch
    # policies: completeness does not certify an optimal policy.
    names = tuple(tuple(int(x == i) for x in range(4)) for i in range(3))
    bits = tuple(tuple((x >> i) & 1 for x in range(4)) for i in range(2))
    identity = (0, 1, 2, 3)
    uniform = (Fraction(1, 4),) * 4
    sequential = optimal_questions(names, identity, uniform)
    all_tests = optimal_questions(names + bits, identity, uniform)
    assert replay(names + bits, identity, uniform, sequential['mean_policy']) == (3, Fraction(9, 4))
    assert replay(names + bits, identity, uniform, all_tests['mean_policy']) == (2, Fraction(2))
    # This reader's genuine limit: it accepts the unique constant within F.
    # It receives no independent evidence that actual belongs to F.
    return {'rule_classes': 2, 'raw_entries': raw, 'covered_rules': [0],
            'complete_library_a': first_library, 'complete_library_b': second_library,
            'dispatch_collision': {'features': [0, 0], 'required_rules': [0, 1]},
            'observations': observations, 'assumed_family': constants,
            'restricted_survivor': [0, 0], 'actual_outside_family': actual,
            'expanded_survivors': version_space(full, observations),
            'restricted_prediction': 0, 'actual_second_answer': 1,
            'rejected_prediction_certificates': len(failures),
            'complete_library_dispatch': {'sequential_worst': 3, 'sequential_mean': '9/4',
                                         'optimal_worst': 2, 'optimal_mean': '2'}}


def arrival_audit():
    cases = 0
    for k in range(1, 6):
        distributions = [(Fraction(1, k),) * k,
                         tuple(Fraction(i + 1, k * (k + 1) // 2) for i in range(k))]
        for probabilities in distributions:
            full = (1 << k) - 1
            @lru_cache(None)
            def expectation(covered):
                if covered == full:
                    return Fraction(0)
                new_mass = sum(p for i, p in enumerate(probabilities) if not covered & (1 << i))
                return (1 + sum(p * expectation(covered | (1 << i)) for i, p in enumerate(probabilities)
                                if not covered & (1 << i))) / new_mass
            # Independent subset inclusion-exclusion formula for cover time.
            inclusion = sum(((-1) ** (bin(mask).count('1') + 1)) /
                            sum(p for i, p in enumerate(probabilities) if mask & (1 << i))
                            for mask in range(1, full + 1))
            assert expectation(0) == inclusion
            if len(set(probabilities)) == 1:
                assert expectation(0) == k * sum(Fraction(1, i) for i in range(1, k + 1))
            law = {0: Fraction(1)}
            for step in range(9):
                missing_probability = 1 - law.get(full, 0)
                assert missing_probability <= sum((1 - p) ** step for p in probabilities)
                updated = {}
                for covered, mass in law.items():
                    for i, p in enumerate(probabilities):
                        new = covered | (1 << i)
                        updated[new] = updated.get(new, Fraction(0)) + mass * p
                law = updated
                cases += 1
    # Uniform marginal frequencies at every time do not imply independent draws.
    correlated_sequences = ((0,) * 8, (1,) * 8)
    assert all({sequence[t] for sequence in correlated_sequences} == {0, 1} for t in range(8))
    assert all(len(set(sequence)) == 1 for sequence in correlated_sequences)
    print(f'arrivals: {cases} finite IID horizons, cover-time recurrences and inclusion-exclusion agree; correlated marginals fail coverage')


def markdown(result):
    return '''# A full cache is not a certificate of generalization

## Entries versus covered rule classes

Four tasks have required rules (0,0,0,1). Three distinct successful tasks can
produce entries (task₀,rule₀), (task₁,rule₀), (task₂,rule₀): three entries,
but only one of two rule classes covered. Repeating those tasks need never
visit the other class. Count newly represented classes, not successful events.

Complete libraries {(task₀,rule₀),(task₃,rule₁)} and
{(task₁,rule₀),(task₃,rule₁)} have the same rule projection and different raw entries.

## Coverage versus dispatch

Both required rules may be stored. If two new tasks expose the same feature
and need different rules, no deterministic feature-only decoder can choose
correctly for both. A new discriminating measurement or a sufficient feature
map is required. Reverification may supply such information and incurs its own work.

Even with all four rules covered and the same allowed name/coordinate tests,
a sequential-name dispatcher takes 3 questions worst and 9/4 mean. An optimal
dispatcher takes 2 worst and 2 mean. Cache completeness does not certify optimality.

## Coverage needs an arrival model

For independent uniform draws from K classes, expected cover time is K·H_K.
For arbitrary positive IID class probabilities, the probability of an incomplete
library after n draws is at most the sum over classes of (1−p_class)^n.
Choose one fair hidden bit once and repeat its class forever: each time has
uniform marginal probabilities, yet one class is never visited. Marginals alone
do not justify a coupon-collector argument. IID arrivals are a separate model,
not a consequence of whole-system closure or retaining memory.

## Uniqueness within a family versus truth of the family

Two-input binary tables encode possible fixed laws. Observe only the first input, with answer 0.

| Assumed family | Surviving tables | Certified second answer within family |
|---|---|---|
| {(0,0),(1,1)}: constant laws | {(0,0)} | 0 |
| All four binary tables | {(0,0),(0,1)} | Undetermined |

The actual fixed law (0,1) agrees with the observation, but lies outside the
constant family and gives second answer 1. A checker of that restricted
family correctly proves its conditional claim and cannot certify the missing
family-adequacy premise from the same observation.

For all binary laws on n inputs, m distinct observed cells leave exactly
2^(n−m) laws. Every unobserved cell has both possible labels. A valid restriction
such as constancy supplies generalization, but the observations alone do not
establish that restriction. Expanding the family may retract predictions while
every empirical observation remains recorded and true.

The hidden table, queried input, controller and memory belong to the same whole.
The models compare possible internal tables; they do not change the actual law
between queries. No physical memory, time or heat bound follows from this audit.
'''


def main():
    coverage_audit()
    learning_audit()
    arrival_audit()
    result = json.loads(json.dumps(demo()))
    root = Path(__file__).parent / 'Reports'
    if '--write' in sys.argv:
        (root / 'learning_coverage.json').write_text(json.dumps(result, indent=2) + '\n')
        (root / 'learning_coverage.md').write_text(markdown(result))
    assert result == json.loads((root / 'learning_coverage.json').read_text())
    assert markdown(result) == (root / 'learning_coverage.md').read_text()
    print('learning: four false predictions refused; family misspecification remains an explicit boundary; reports agree')


if __name__ == '__main__':
    main()
