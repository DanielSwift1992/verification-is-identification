#!/usr/bin/env python3
"""Exact finite audits for VI VC20–VC24. No physical universality inference."""
from fractions import Fraction
from itertools import permutations, product
from operational_quotient import canonical, partitions, preserves, refine, distinguishes
from closed_information import entropy, pushed, equal


def window_partition(observation, transition, length):
    rows = []
    for source in range(len(observation)):
        row = []
        current = source
        for _ in range(length):
            row.append(observation[current])
            current = transition[current]
        rows.append(tuple(row))
    return canonical(rows)


def main():
    n = 4
    observations = partitions(n)
    maps = list(product(range(n), repeat=n))
    reversible = list(permutations(range(n)))
    autonomous = 0
    prior = {i: Fraction(i + 1, 10) for i in range(n)}
    for transition in reversible:
        inverse = tuple(transition.index(x) for x in range(n))
        for observation in observations:
            future = refine(observation, (transition,))
            past = refine(observation, (inverse,))
            assert future == past, (transition, observation, 'past vs future')
            if preserves(observation, transition):
                induced = {observation[x]: observation[transition[x]] for x in range(n)}
                assert len(set(induced.values())) == len(induced)
                macro = pushed(prior, observation.__getitem__)
                equal(entropy(macro), entropy(pushed(macro, induced.__getitem__)))
                autonomous += 1
        # On four states every ordering of a scalar can be represented using
        # four ranks. Search all 256 assignments, without using cycle sums.
        for clock in product(range(n), repeat=n):
            if all(clock[transition[x]] >= clock[x] for x in range(n)):
                assert all(clock[transition[x]] == clock[x] for x in range(n))
    print(f'dynamics: 360 reversible observation systems, {autonomous} autonomous quotients, all reversible')
    print('dynamics: past and future behavioral partitions agree for all 360 systems')
    print('dynamics: 6144 ranked-clock cases permit no changing globally monotone clock')

    audited = 0
    longest = 0
    for transition in maps:
        for observation in observations:
            limit = n - len(set(observation)) + 1
            expected = refine(observation, (transition,))
            # Independently enumerate observation windows and reachable pairs.
            actual = window_partition(observation, transition, limit)
            assert actual == expected, (transition, observation, limit)
            for x in range(n):
                for y in range(n):
                    assert (actual[x] != actual[y]) == distinguishes(x, y, observation, (transition,))
            first_sufficient = next(length for length in range(1, limit + 1)
                                    if window_partition(observation, transition, length) == expected)
            longest = max(longest, first_sufficient)
            audited += 1
    print(f'dynamics: all {audited} finite systems obey the observation-window bound, maximum needed {longest}')

    # Same present, different future. A two-frame trace repairs this example.
    states = list(product(range(2), repeat=2))
    index = {s: i for i, s in enumerate(states)}
    swap = tuple(index[b, a] for a, b in states)
    visible = tuple(a for a, b in states)
    assert not preserves(visible, swap)
    assert window_partition(visible, swap, 2) == tuple(range(4))

    ready_extensions = target_preserving = universal_copies = 0
    for perm in permutations(states):
        operation = dict(zip(states, perm))
        preserves_target = all(operation[x, m][0] == x for x, m in states)
        target_preserving += preserves_target
        ready = all(operation[x, 0] == (x, x) for x in range(2))
        ready_extensions += ready
        universal_copies += all(operation[x, m] == (x, x) for x, m in states)
    assert (ready_extensions, target_preserving, universal_copies) == (2, 4, 0)
    print('dynamics: 2 reversible extensions copy from blank memory, none overwrite every initial memory')

    # Each pair context has a uniform, nonempty local table. All overlap
    # marginals agree, yet half of the eight parity declarations cannot glue.
    possible = impossible = 0
    for ab, bc, ac in product(range(2), repeat=3):
        contexts = [{(u, v): Fraction(1, 2) for u, v in states if u ^ v == parity}
                    for parity in (ab, bc, ac)]
        for distribution in contexts:
            assert sum(distribution.values()) == 1
            for position in (0, 1):
                assert pushed(distribution, lambda s: s[position]) == {0: Fraction(1, 2), 1: Fraction(1, 2)}
        global_states = [(a, b, c) for a, b, c in product(range(2), repeat=3)
                         if a ^ b == ab and b ^ c == bc and a ^ c == ac]
        assert bool(global_states) == (ab ^ bc ^ ac == 0)
        assert len(global_states) in (0, 2)
        possible += bool(global_states)
        impossible += not global_states
    assert (possible, impossible) == (4, 4)
    print('dynamics: all 8 local parity systems agree on overlaps, only 4 admit a global state')

    audited_residuals = 0
    for transition in product(range(3), repeat=3):
        for observation in partitions(3):
            behavior = refine(observation, (transition,))
            expected = max(len({behavior[x] for x in range(3) if observation[x] == e})
                           for e in set(observation))
            forbidden = [(x, y) for x in range(3) for y in range(3)
                         if observation[x] == observation[y]
                         and distinguishes(x, y, observation, (transition,))]
            actual = next(size for size in range(1, 4)
                          if any(all(labels[x] != labels[y] for x, y in forbidden)
                                 for labels in product(range(size), repeat=3)))
            assert actual == expected, (transition, observation, expected, actual)
            audited_residuals += 1
    assert audited_residuals == 135
    print('dynamics: predictive residual minimum checked by label search on all 135 three-state systems')



if __name__ == '__main__':
    main()
