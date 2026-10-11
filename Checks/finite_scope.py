#!/usr/bin/env python3
"""Finite audits of EF5–EF7: members, carriers and ranks are different bounds."""
from functools import lru_cache
from itertools import product


@lru_cache(None)
def height(tree):
    return 0 if tree is None else 1 + max(height(tree[0]), height(tree[1]))


def main():
    tables = 0
    for n in range(1, 4):
        assert 1 + n * n > n
        for pairing in product(range(n), repeat=n * n):
            # Fixing the floor to 0 loses no case up to renaming the carrier.
            images = (0,) + pairing
            assert len(set(images)) < len(images)
            term = 0
            chain = [term]
            for _ in range(n):
                term = pairing[term * n]  # p(term, floor)
                chain.append(term)
            assert len(set(chain)) < len(chain)
            tables += 1
    assert tables == 19700
    print('finite scope: all 19700 finite operation tables violate free disjoint constructor preservation')

    catalogs = [{None}]
    expected = [1]
    for _ in range(4):
        previous = catalogs[-1]
        catalogs.append({None} | {(a, b) for a in previous for b in previous})
        expected.append(1 + expected[-1] ** 2)
    assert expected == [1, 2, 5, 26, 677]
    for d, catalog in enumerate(catalogs):
        assert len(catalog) == expected[d]
        assert max(map(height, catalog)) == d
        deepest = next(t for t in catalog if height(t) == d)
        assert (deepest, None) not in catalog
        if d:
            assert catalogs[d - 1] < catalog
    pairs = 0
    for d, catalog in enumerate(catalogs[:-1]):
        for a, b in product(catalog, repeat=2):
            node = (a, b)
            assert node in catalogs[d + 1]
            assert (node in catalog) == (max(height(a), height(b)) < d)
            pairs += 1
    assert pairs == 706
    print('finite scope: height catalogs 1, 2, 5, 26, 677 and all 706 bounded pairings have the declared boundary')

    # The counterexample is the induction t_(n+1)=(t_n,leaf). This finite
    # prefix audits the representation, rather than proving an infinite run.
    term = None
    for n in range(65):
        level = {term}
        assert len(level) == 1 and height(term) == n
        term = (term, None)
    # A merely nonincreasing rank may stutter forever: the one-state identity.
    assert 1 <= 1 and not 1 < 1
    print('finite scope: 65 singleton finite levels do not supply a last level; nonincrease permits identity')

    checked = 0
    for ranks in product(range(4), repeat=3):
        for transition in product(range(3), repeat=3):
            if not all(ranks[x] == 0 or ranks[transition[x]] < ranks[x] for x in range(3)):
                continue
            for start in range(3):
                current, steps = start, 0
                while ranks[current] > 0:
                    current = transition[current]
                    steps += 1
                    assert steps <= ranks[start]
            checked += 1
    assert checked > 0
    print(f'finite scope: {checked} strictly ranked finite dynamics stop within their initial rank')


if __name__ == '__main__':
    main()
