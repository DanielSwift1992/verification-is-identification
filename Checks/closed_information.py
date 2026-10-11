#!/usr/bin/env python3
"""Finite classical models. No inference from closure to reversibility or heat."""
from collections import defaultdict
from fractions import Fraction
from itertools import permutations, product
from math import isclose, log2


def pushed(distribution, fn):
    result = defaultdict(Fraction)
    for state, probability in distribution.items():
        result[fn(state)] += probability
    return dict(result)


def entropy(distribution):
    return -sum(float(p) * log2(float(p)) for p in distribution.values() if p)


def mutual(distribution, left, right):
    return (entropy(pushed(distribution, left))
            + entropy(pushed(distribution, right))
            - entropy(pushed(distribution, lambda s: (left(s), right(s)))))


def equal(actual, expected):
    assert isclose(actual, expected, abs_tol=1e-12), (actual, expected)


def main():
    # Generated algebra with a floor and binary operation, but no free syntax.
    pair = {(a, b): int(a == b == 0) for a, b in product(range(2), repeat=2)}
    assert set(pair) == set(product(range(2), repeat=2))
    assert {0, pair[0, 0]} == {0, 1}
    assert pair[pair[0, 0], 0] == 0
    assert pair[1, 0] == pair[0, 1]
    print('information: finite generation does not imply recoverable constructors')

    maps = list(product(range(2), repeat=2))
    injective = [f for f in maps if len(set(f)) == 2]
    assert len(maps) == 4 and len(injective) == 2
    assert (0, 0) in maps and (0, 0) not in injective
    print('information: all 4 two-state maps are closed, only 2 preserve distinctions')

    states = list(product(range(2), repeat=2))
    for state in states:
        equal(entropy({state: Fraction(1)}), 0)
    prior = {s: Fraction(i + 1, 10) for i, s in enumerate(states)}
    for targets in permutations(states):
        operation = dict(zip(states, targets))
        inverse = {v: k for k, v in operation.items()}
        assert all(inverse[operation[s]] == s for s in states)
        equal(entropy(pushed(prior, operation.__getitem__)), entropy(prior))
        for start in states:
            current = start
            for length in range(1, len(states) + 1):
                current = operation[current]
                if current == start:
                    break
            else:
                raise AssertionError('finite bijection failed recurrence')
    print('information: all 24 four-state permutations preserve entropy and recur')

    blank = {(0, 0): Fraction(1, 2), (1, 0): Fraction(1, 2)}
    swap = lambda s: (s[1], s[0])
    copy = lambda s: (s[0], s[0] ^ s[1])
    for operation in (swap, copy):
        assert len({operation(s) for s in states}) == 4
        assert all(operation(operation(s)) == s for s in states)
    after_swap = pushed(blank, swap)
    after_copy = pushed(blank, copy)
    first, second = lambda s: s[0], lambda s: s[1]
    for distribution, expected in (
        (blank, (1, 1, 0, 0)),
        (after_swap, (1, 0, 1, 0)),
        (after_copy, (1, 1, 1, 1)),
    ):
        actual = (entropy(distribution), entropy(pushed(distribution, first)),
                  entropy(pushed(distribution, second)), mutual(distribution, first, second))
        for value, goal in zip(actual, expected):
            equal(value, goal)
    print('information: internal reset transfers a bit, reversible recording creates correlation')

    # The input coordinate X is an index in this joint probability calculation,
    # not an additional physical system outside the two-register whole.
    uniform = {s: Fraction(1, 4) for s in states}
    masked = lambda s: (s[1], s[0] ^ s[1])
    assert len({masked(s) for s in states}) == 4
    assert all((masked(s)[0] ^ masked(s)[1]) == s[0] for s in states)
    equal(mutual(uniform, first, lambda s: masked(s)[0]), 0)
    equal(mutual(uniform, first, lambda s: masked(s)[1]), 0)
    equal(mutual(uniform, first, masked), 1)
    equal(entropy(pushed(uniform, masked)), 2)
    print('information: original bit is absent from either marginal and recoverable jointly')

    beams = list(product(range(2), repeat=3))
    visible = lambda s: s[:2]
    fibers = defaultdict(list)
    for beam in beams:
        fibers[visible(beam)].append(beam)
    assert len(fibers) == 4 and max(map(len, fibers.values())) == 2
    assert len({(visible(s), 0) for s in beams}) == 4
    assert len({(visible(s), s[2]) for s in beams}) == 8
    valid = 0
    uniform_beams = {s: Fraction(1, 8) for s in beams}
    for labels in product(range(2), repeat=8):
        residual = dict(zip(beams, labels))
        encoded = lambda s: (visible(s), residual[s])
        if len({encoded(s) for s in beams}) == 8:
            valid += 1
            equal(entropy(pushed(uniform_beams, encoded))
                  - entropy(pushed(uniform_beams, visible)), 1)
    assert valid == 16
    print('information: 16 of 256 binary residual assignments recover all 8 beams')



if __name__ == '__main__':
    main()
