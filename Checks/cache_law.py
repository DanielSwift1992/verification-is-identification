#!/usr/bin/env python3
"""Truth, retained storage and semantic cache growth have separate laws."""
from itertools import product
from fractions import Fraction


def subsets(mask):
    return tuple(x for x in range(mask + 1) if x & mask == x)


def identify(candidates, target, initial_cache, retain):
    cache = dict(initial_cache)
    accepted, calls = [], 0
    for candidate in candidates:
        key = candidate, target
        if key in cache:
            answer = cache[key]
        else:
            answer = candidate == target
            calls += 1
            if retain:
                cache[key] = answer
        if answer:
            accepted.append(candidate)
    return tuple(accepted), calls


def main():
    # The whole contains immutable comparison inputs and two internal registers.
    # None means no cached answer. SWAP preserves every whole configuration.
    worlds = tuple(product(range(2), range(2), (None, False, True), (None, False, True)))
    transition = {w: (w[0], w[1], w[3], w[2]) for w in worlds}
    assert len(worlds) == 36 and set(transition) == set(transition.values())
    for before, after in transition.items():
        assert transition[after] == before
        assert (before[0] == before[1]) == (after[0] == after[1])
    for a, b in product(range(2), repeat=2):
        before = (a, b, a == b, None)
        after = transition[before]
        assert after[2] is None and after[3] == (a == b)
    print('cache: a 36-state closed permutation keeps comparison truth while removing its accessible cache entry')

    # Two keys with two possible answers give four possible factual entries.
    # This truth table contains bits 0 and 3, one correct answer per key.
    truth = 0b1001
    caches = subsets(truth)
    sound = retaining = both = 0
    for outputs in product(range(16), repeat=len(caches)):
        is_sound = all(after & truth == after for after in outputs)
        is_retaining = all(before & after == before for before, after in zip(caches, outputs))
        is_union = all(any(before | delta == after for delta in caches)
                       for before, after in zip(caches, outputs))
        assert is_union == (is_sound and is_retaining)
        sound += is_sound
        retaining += is_retaining
        both += is_union
    assert (sound, retaining, both) == (256, 4096, 16)
    print('cache: all 65536 update tables separate truth (256), retention (4096) and both (16)')

    # The same retained bytes admit either a union decoder or a latest-only
    # decoder. Raw recovery alone does not determine semantic cache inclusion.
    for old, event in product(caches, repeat=2):
        raw = old, event
        assert raw[0] == old
        joined = raw[0] | raw[1]
        assert joined & old == old and joined & truth == joined
        assert joined | event == joined  # Repeating evidence is idempotent.
    old, event = 0b0001, 0
    assert ((old, event)[1] & old) != old
    assert not (0b0001 & 0b1000 == 0b0001) and not (0b1000 & 0b0001 == 0b1000)
    print('cache: all 16 union-decoded appends retain truth; latest-only reading and a total-order claim have counterexamples')

    # Exhaustive finite identification works without an append-only comparison
    # cache. Test every candidate support, target and valid pre-existing cache.
    cases = 0
    for support, target, cached in product(range(16), range(4), range(16)):
        candidates = tuple(x for x in range(4) if support & (1 << x))
        initial = {(x, target): x == target for x in range(4) if cached & (1 << x)}
        fresh, fresh_calls = identify(candidates, target, {}, False)
        remembered, cached_calls = identify(candidates, target, initial, True)
        assert fresh == remembered == ((target,) if target in candidates else ())
        assert fresh_calls == len(candidates) and cached_calls <= fresh_calls
        cases += 1
    assert cases == 1024
    print('cache: 1024 finite searches return the same verdict with and without retained comparisons')

    # Semantic progress need not be strict, even when a newly stored fact is
    # correct. It may already be implied by the remaining candidate support.
    hypotheses = tuple(product(range(2), repeat=2))
    constraints = ((0, 0), (0, 1), (1, 0), (1, 1))
    def survivors(support, facts):
        return {h for i, h in enumerate(hypotheses) if support & (1 << i)
                and all(h[key] == answer for bit, (key, answer) in enumerate(constraints)
                        if facts & (1 << bit))}
    for support, old, delta in product(range(16), caches, caches):
        assert survivors(support, old | delta) <= survivors(support, old)
    truth_only = 1 << hypotheses.index((0, 1))
    assert survivors(truth_only, 0) == survivors(truth_only, truth)
    print('cache: candidate sets shrink weakly; repeated or already implied facts need not advance identification')

    for size in range(1, 33):
        score = lambda remaining: 1 - Fraction(remaining, size)
        assert score(0) == 1
        assert score(1) == 1 - Fraction(1, size) < 1
        assert score(size) == 0
    print('cache: elimination score one means rejection; a unique survivor has score 1 minus 1/|F|')


if __name__ == '__main__':
    main()
