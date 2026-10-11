#!/usr/bin/env python3
"""Finite audit of VI §§6e–6f, independent of the Swift certificate syntax.

Enumerate every observation partition and every zero-, one-, or two-operation
vocabulary on three states. Compare partition refinement with an independent
reachable-pair search, then inspect every possible candidate quotient. This is
an exhaustive finite audit, not a proof for arbitrary carriers.
"""
from itertools import combinations, permutations, product


def canonical(values):
    labels = {}
    return tuple(labels.setdefault(value, len(labels)) for value in values)


def partitions(n):
    return sorted({canonical(values) for values in product(range(n), repeat=n)})


def kernel(partition):
    return {(x, y) for x in range(len(partition)) for y in range(len(partition))
            if partition[x] == partition[y]}


def preserves(partition, operation):
    return all(partition[operation[x]] == partition[operation[y]]
               for x, y in kernel(partition))


def refine(observation, operations):
    current = canonical(observation)
    while True:
        updated = canonical((observation[x], *(current[t[x]] for t in operations))
                            for x in range(len(observation)))
        if updated == current:
            return updated
        current = updated


def distinguishes(x, y, observation, operations):
    # Search executions of a pair, with no partition-refinement operation.
    pending = [(x, y)]
    visited = set()
    while pending:
        pair = pending.pop()
        if pair in visited:
            continue
        visited.add(pair)
        a, b = pair
        if observation[a] != observation[b]:
            return True
        pending.extend((t[a], t[b]) for t in operations)
    return False


def require(condition, witness):
    if not condition:
        raise AssertionError(witness)


def main():
    n = 3
    observations = partitions(n)
    operations = tuple(product(range(n), repeat=n))
    vocabularies = [()] + [(t,) for t in operations] + list(combinations(operations, 2))
    systems = 0
    quotients = 0
    for q in observations:
        for vocabulary in vocabularies:
            behavior = refine(q, vocabulary)
            relation = kernel(behavior)
            searched = {(x, y) for x in range(n) for y in range(n)
                        if not distinguishes(x, y, q, vocabulary)}
            require(relation == searched, ('refinement vs execution', q, vocabulary))
            require(relation <= kernel(q), ('current question', q, vocabulary))
            require(all(preserves(behavior, t) for t in vocabulary),
                    ('behavior is stable', q, vocabulary))
            for candidate in observations:
                candidate_relation = kernel(candidate)
                if candidate_relation <= kernel(q) and all(preserves(candidate, t) for t in vocabulary):
                    require(candidate_relation <= relation,
                            ('greatest compatible equivalence', q, vocabulary, candidate))
                quotients += 1
            if len(vocabulary) == 2:
                for t in vocabulary:
                    require(relation <= kernel(refine(q, (t,))),
                            ('adding an operation only splits', q, vocabulary))
            systems += 1
        # Every total endomorphism: nonconstant observations force identity.
        unrestricted = refine(q, operations)
        expected = (0, 0, 0) if len(set(q)) == 1 else (0, 1, 2)
        require(unrestricted == expected, ('unrestricted operations', q))

    # More information preserves adequacy for the old question, but can destroy
    # closure of the representation itself under a supplied operation.
    coarse = (0, 0, 1, 1)
    richer = (0, 1, 2, 2)
    complete = (0, 1, 2, 3)
    reset_first_coordinate = (0, 1, 0, 1)
    require(kernel(complete) < kernel(richer) < kernel(coarse), 'strict refinement chain')
    require(preserves(coarse, reset_first_coordinate), 'coarse representation executes')
    require(not preserves(richer, reset_first_coordinate), 'richer representation fails to execute')
    require(preserves(complete, reset_first_coordinate), 'complete representation executes')
    old_behavior = kernel(refine(coarse, (reset_first_coordinate,)))
    require(kernel(richer) <= old_behavior, 'richer still answers every old future question')
    require(refine(richer, (reset_first_coordinate,)) == complete,
            'making the richer record a question requires complete future distinctions')

    # The worked binary-coordinate beam domain: visible observations are exact
    # for swap and hidden erasure. Adding hidden exposure splits to all triples.
    beams = tuple(product(range(2), repeat=3))
    index = {beam: i for i, beam in enumerate(beams)}
    visible = canonical((a, b) for a, b, h in beams)
    swap = tuple(index[b, a, h] for a, b, h in beams)
    forget = tuple(index[a, b, 0] for a, b, h in beams)
    expose = tuple(index[h, 0, 0] for a, b, h in beams)
    require(refine(visible, (swap, forget)) == visible, 'visible beam object')
    require(refine(visible, (swap, forget, expose)) == tuple(range(len(beams))),
            'exposure refines the object to the full triple')

    # Behavioral equivalence need not be a symmetry orbit. A symmetry must
    # preserve both the current observation and source-level transitions.
    symmetries = [p for p in permutations(range(len(beams)))
                  if all(visible[p[x]] == visible[x] for x in range(len(beams)))
                  and all(p[t[x]] == t[p[x]] for t in (swap, forget)
                          for x in range(len(beams)))]
    require(symmetries == [tuple(range(len(beams)))],
            'only identity preserves the visible labels and both transitions')

    print(f'quotient: {systems} systems, {quotients} candidate quotients checked exhaustively')
    print('quotient: refinement agrees with reachable-pair search in every system')
    print('quotient: unrestricted operations force identity for all four nonconstant observations')
    print('quotient: richer information can lose execution closure while retaining answer adequacy')
    print('quotient: the 8-beam model has 4 operational objects before exposure and 8 after')
    print('quotient: all 40320 state permutations checked, only identity is an automorphism')


if __name__ == '__main__':
    main()
