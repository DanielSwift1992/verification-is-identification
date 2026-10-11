#!/usr/bin/env python3
"""Relative certificates, record novelty and finite question completion (LQ3/LQ11)."""
from itertools import product
from math import log2
import json
from pathlib import Path


def subsets(items):
    items = tuple(items)
    return [frozenset(items[i] for i in range(len(items)) if mask >> i & 1)
            for mask in range(1 << len(items))]


def survivors(states, queries, x, keys):
    return frozenset(y for y in states if all(queries[i][y] == queries[i][x] for i in keys))


def certificate_by_cover(belief, queries, answer, x, cached):
    wrong = {y for y in belief if answer[y] != answer[x]}
    cuts = {i: {y for y in wrong if f[y] != f[x]}
            for i, f in enumerate(queries) if i not in cached}
    costs = [len(keys) for keys in subsets(cuts)
             if set().union(*(cuts[i] for i in keys)) == wrong]
    return min(costs, default=float('inf'))


def audit():
    models = contexts = extensions = settled = 0
    # Every ordered triple of binary queries (including duplicates), binary
    # target and sound initial cache on each carrier with 1, 2 or 3 states.
    # Independent version-space intersection checks the set-cover criterion.
    keys = frozenset(range(3))
    for n in (1, 2, 3):
        states = tuple(range(n))
        maps = tuple(product(range(2), repeat=n))
        for queries, answer in product(product(maps, repeat=3), maps):
            models += 1
            for x, cached in product(states, subsets(keys)):
                contexts += 1
                belief = survivors(states, queries, x, cached)
                cert = certificate_by_cover(belief, queries, answer, x, cached)
                successful = []
                for fresh in subsets(keys - cached):
                    extensions += 1
                    remaining = survivors(states, queries, x, cached | fresh)
                    assert x in remaining and remaining <= belief
                    completed = len({answer[y] for y in remaining}) == 1
                    # An independent, pairwise eventual-separation check.
                    separated = all(any(queries[i][y] != queries[i][x] for i in fresh)
                                    for y in belief if answer[y] != answer[x])
                    assert completed == separated
                    if completed:
                        settled += 1
                        successful.append(len(fresh))
                        assert cert <= len(fresh)
                assert cert == min(successful, default=float('inf'))

    states = tuple(product(range(2), repeat=2))
    queries = tuple(tuple(f(a, b) for a, b in states)
                    for f in (lambda a, b: a, lambda a, b: b, lambda a, b: a & b))
    universe = range(4)
    x = 0
    cached = frozenset({0})
    # A distinct function and key, already implied on this branch: new record,
    # no smaller belief and no answer to b.
    belief = survivors(universe, queries, x, cached)
    assert belief == survivors(universe, queries, x, {0, 2}) == frozenset({0, 1})
    assert certificate_by_cover(belief, queries, queries[1], x, cached) == 1
    assert certificate_by_cover(belief, queries, queries[0], x, cached) == 0
    # Every finite prefix of an infinite repeat stream has this same belief.
    # The update is idempotent, so this proves a persistent unresolved orbit.
    assert survivors(belief, queries, x, {0}) == belief
    # Exhaust every length <= 5 transcript: calls, distinct records and strict
    # belief reductions differ. This also checks repeated successful episodes.
    transcripts = 0
    for length in range(6):
        for stream in product(range(3), repeat=length):
            current, known, strict = belief, set(cached), 0
            for i in stream:
                after = survivors(current, queries, x, {i})
                strict += after != current
                current, known = after, known | {i}
            fresh = len(known - cached)
            assert strict <= fresh <= length
            if len({queries[1][y] for y in current}) == 1:
                assert 1 <= fresh
            transcripts += 1

    # Whole = two source bits and an internal memory bit. A fixed CNOT is a
    # permutation on ALL 8 states. Preparation m=0 is an explicit premise.
    worlds = tuple(product(range(2), repeat=3))
    transition = lambda w: (w[0], w[1], w[2] ^ w[0])
    assert set(map(transition, worlds)) == set(worlds)
    assert all(transition(transition(w)) == w for w in worlds)
    prepared = tuple(w for w in worlds if w[2] == 0)
    after = tuple(map(transition, prepared))
    def entropy(values):
        counts = {v: values.count(v) for v in set(values)}
        return -sum((c / len(values)) * log2(c / len(values)) for c in counts.values())
    assert entropy(prepared) == entropy(after) == 2
    assert entropy(tuple(w[2] for w in prepared)) == 0
    assert entropy(tuple(w[2] for w in after)) == 1
    assert all(w[2] == w[0] for w in after)
    # Run the same closed operation again: accessible memory is cleared.
    # Closure and reversibility do not imply permanent local learning.
    assert tuple(map(transition, after)) == prepared

    report = {'models': models, 'sound_cache_contexts': contexts,
              'extensions': extensions, 'settling_extensions': settled,
              'repeat_transcripts': transcripts, 'closed_whole_states': len(worlds),
              'scope': 'All binary targets and ordered triples of binary queries on 1..3 states, all sound caches and new-key subsets.',
              'controls': ['repeat with zero novelty', 'distinct redundant query',
                           'persistent unresolved loop', 'internal reversible acquisition and loss'],
              'limits': 'Static total queries and sound fixed models. No physical entropy law, adaptive-cost optimum or runtime speedup inferred.'}
    path = Path(__file__).with_name('Reports') / 'learning_progress.json'
    encoded = json.dumps(report, indent=2) + '\n'
    if path.exists():
        assert path.read_text() == encoded, 'learning progress report drift'
    else:
        path.write_text(encoded)
    print(json.dumps(report, ensure_ascii=False))


if __name__ == '__main__':
    audit()
