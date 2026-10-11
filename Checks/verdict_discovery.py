#!/usr/bin/env python3
"""Finite policies for a fixed question about the original state.

A belief contains (current state, required original answer) pairs. The answer
label is transported through interventions, never recomputed on current state.
"""
from collections import deque
from itertools import combinations


def split(observation, pairs):
    groups = {}
    for state, answer in sorted(set(pairs)):
        groups.setdefault(observation[state], []).append((state, answer))
    return tuple(tuple(group) for group in groups.values())


def terminal(belief):
    return len({answer for _, answer in belief}) == 1


def conflict(belief):
    return any(x == y and a != b for (x, a), (y, b) in combinations(belief, 2))


def move(observation, transition, belief):
    return split(observation, ((transition[state], answer) for state, answer in belief))


def solve(observation, operations, question):
    assert len(question) == len(observation) and question
    roots = split(observation, enumerate(question))
    pending = deque(roots)
    known = set(roots)
    edges = {}
    while pending:
        belief = pending.popleft()
        if terminal(belief) or conflict(belief):
            continue
        edges[belief] = {}
        for action, transition in operations.items():
            children = move(observation, transition, belief)
            edges[belief][action] = children
            for child in children:
                if child not in known:
                    known.add(child)
                    pending.append(child)
    winning = {b: {'rank': 0, 'action': None, 'answer': b[0][1]}
               for b in known if terminal(b)}
    rank = 0
    while True:
        added = {}
        for belief, actions in edges.items():
            if belief in winning:
                continue
            for action, children in actions.items():
                if all(child in winning for child in children):
                    added[belief] = {'rank': rank + 1, 'action': action, 'answer': None}
                    break
        if not added:
            break
        winning.update(added)
        rank += 1
    return {'answerable': all(b in winning for b in roots),
            'winning': [{'belief': [list(p) for p in b], **row} for b, row in sorted(winning.items())],
            'losing': [[list(p) for p in b] for b in sorted(known - winning.keys())]}


def verify(observation, operations, question, certificate):
    # Check supplied proof obligations directly, without constructing the
    # reachable graph or repeating the solver's fixed-point computation.
    normalize = lambda pairs: tuple(tuple(pair) for pair in pairs)
    rows = certificate['winning']
    winning = {normalize(r['belief']): r for r in rows}
    losing = {normalize(b) for b in certificate['losing']}
    assert len(winning) == len(rows) and len(losing) == len(certificate['losing'])
    assert not (winning.keys() & losing)
    universe = winning.keys() | losing
    answers = set(question)
    for belief in universe:
        assert belief and belief == tuple(sorted(set(belief)))
        assert all(type(x) is int and 0 <= x < len(observation) and a in answers for x, a in belief)
        assert len({observation[x] for x, _ in belief}) == 1
    for belief, row in winning.items():
        assert type(row['rank']) is int and row['rank'] >= 0
        if terminal(belief):
            assert row['rank'] == 0 and row['action'] is None and row['answer'] == belief[0][1]
            continue
        assert not conflict(belief) and row['action'] in operations and row['answer'] is None
        for child in move(observation, operations[row['action']], belief):
            assert child in winning and winning[child]['rank'] < row['rank']
    for belief in losing:
        assert not terminal(belief)
        if conflict(belief):
            continue
        for transition in operations.values():
            assert any(child in losing for child in move(observation, transition, belief))
    roots = split(observation, enumerate(question))
    assert all(b in universe for b in roots)
    expected = all(b in winning for b in roots)
    assert type(certificate['answerable']) is bool and certificate['answerable'] == expected
    return True


def replay(observation, operations, question, certificate):
    if not certificate['answerable']:
        return []
    winning = {tuple(tuple(p) for p in r['belief']): r for r in certificate['winning']}
    traces = []
    for actual in range(len(observation)):
        candidates = {origin: origin for origin in range(len(observation))
                      if observation[origin] == observation[actual]}
        current = actual
        word, observations = [], [observation[current]]
        while True:
            belief = tuple(sorted({(state, question[origin]) for origin, state in candidates.items()}))
            row = winning[belief]
            if row['action'] is None:
                assert all(question[origin] == row['answer'] for origin in candidates)
                assert row['answer'] == question[actual]
                traces.append({'origin': actual, 'answer': row['answer'], 'actions': word,
                               'observations': observations, 'possible_origins': sorted(candidates)})
                break
            transition = operations[row['action']]
            current = transition[current]
            candidates = {origin: transition[state] for origin, state in candidates.items()
                          if observation[transition[state]] == observation[current]}
            word.append(row['action'])
            observations.append(observation[current])
    return traces
