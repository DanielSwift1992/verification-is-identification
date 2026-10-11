#!/usr/bin/env python3
from copy import deepcopy
from itertools import combinations, product
import json
from pathlib import Path

from discovery_gate import inspect, markdown, solve_policy
from operational_quotient import partitions
from verdict_discovery import solve, verify, replay


def reject(observation, operations, question, certificate):
    try:
        verify(observation, operations, question, certificate)
    except (AssertionError, KeyError, TypeError):
        return
    raise AssertionError('corrupt original-question certificate accepted')


def main():
    maps = tuple(product(range(3), repeat=3))
    vocabularies = [()] + [(t,) for t in maps] + list(combinations(maps, 2))
    cases = 0
    for observation in partitions(3):
        for vocabulary in vocabularies:
            operations = {f'op{i}': t for i, t in enumerate(vocabulary)}
            identity = solve_policy(observation, operations)['identifiable']
            for question in partitions(3):
                certificate = solve(observation, operations, question)
                verify(observation, operations, question, certificate)
                replay(observation, operations, question, certificate)
                if question == (0, 1, 2):
                    assert certificate['answerable'] == identity
                if question == (0, 0, 0):
                    assert certificate['answerable']
                    assert all(not row['actions'] for row in replay(observation, operations, question, certificate))
                cases += 1
    assert cases == 9475
    print('verdict discovery: 9475 finite system/question combinations have verified certificates and replays')

    root = Path(__file__).parent
    model = json.loads((root / 'Models/discovery_verdict.json').read_text())
    result = inspect(model)
    assert result == json.loads((root / 'Reports/discovery_verdict.json').read_text())
    assert markdown(result) == (root / 'Reports/discovery_verdict.md').read_text()
    assert not result['policy']['identifiable'] and result['question_discovery']['certificate']['answerable']
    observation, operations = model['observation'], model['operations']
    for question in partitions(4):
        certificate = solve(observation, operations, question)
        verify(observation, operations, question, certificate)
        replay(observation, operations, question, certificate)
        # Each possible first action merges a specific pair of quiet origins.
        expected = question[1] == question[2] or question[0] == question[2]
        assert certificate['answerable'] == expected
    print('verdict discovery: all 15 target partitions in the trap match the direct first-action obstruction')

    question = model['question']
    certificate = result['question_discovery']['certificate']
    broken = deepcopy(certificate)
    leaf = next(r for r in broken['winning'] if r['belief'] == [[0, 'was_not_A']])
    leaf['answer'] = 'was_A'  # Recompute q on current A, instead of original B/C.
    reject(observation, operations, question, broken)
    broken = deepcopy(certificate)
    nonterminal = next(r for r in broken['winning'] if r['action'] is not None)
    nonterminal['rank'] = 0
    reject(observation, operations, question, broken)
    broken = deepcopy(certificate)
    broken['winning'] = [r for r in broken['winning'] if r['belief'] != [[0, 'was_A'], [1, 'was_not_A'], [2, 'was_not_A']]]
    reject(observation, operations, question, broken)
    ask_c = (0, 0, 1, 0)
    impossible = solve(observation, operations, ask_c)
    assert not impossible['answerable']
    impossible['answerable'] = True
    reject(observation, operations, ask_c, impossible)
    print('verdict discovery: retargeted answer, false rank, missing initial belief and false success refused')


if __name__ == '__main__':
    main()
