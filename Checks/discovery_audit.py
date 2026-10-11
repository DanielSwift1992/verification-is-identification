#!/usr/bin/env python3
"""Independent replay, shortest-word search and adversarial certificate checks."""
from copy import deepcopy
from itertools import combinations, permutations, product
import json
from pathlib import Path

from discovery_gate import (inspect, markdown, shortest_separator, solve_policy,
                            verify_policy, replay_policy, reversible_word)
from operational_quotient import canonical, partitions, refine


def trace(observation, operations, word, state):
    answers = [observation[state]]
    for action in word:
        state = operations[action][state]
        answers.append(observation[state])
    return tuple(answers)


def check_separators(observation, operations):
    n = len(observation)
    maximum = n - len(set(observation))
    behavior = refine(observation, tuple(operations.values()))
    for x, y in combinations(range(n), 2):
        result = shortest_separator(observation, operations, x, y)
        minimum = next((length for length in range(maximum + 1)
                        if any(trace(observation, operations, word, x)
                               != trace(observation, operations, word, y)
                               for word in product(operations, repeat=length))), None)
        assert (result is None) == (behavior[x] == behavior[y])
        assert (None if result is None else len(result)) == minimum
        if result is not None:
            assert trace(observation, operations, result, x) != trace(observation, operations, result, y)


def rejected(observation, operations, certificate):
    try:
        verify_policy(observation, operations, certificate)
    except (AssertionError, KeyError, TypeError):
        return
    raise AssertionError('corrupt discovery certificate was accepted')


def main():
    count = 0
    maps = tuple(product(range(3), repeat=3))
    vocabularies = [()] + [(t,) for t in maps] + list(combinations(maps, 2))
    for observation in partitions(3):
        for vocabulary in vocabularies:
            operations = {f'op{i}': t for i, t in enumerate(vocabulary)}
            check_separators(observation, operations)
            certificate = solve_policy(observation, operations)
            verify_policy(observation, operations, certificate)
            replay_policy(observation, operations, certificate)
            # With three states, a nonconstant current observation leaves at
            # most two unresolved states. A pair separator is then a policy.
            behavior = refine(observation, vocabulary)
            assert certificate['identifiable'] == (len(set(behavior)) == 3)
            count += 1
    assert count == 1895
    print('discovery: all 1895 three-state systems, shortest words and policy certificates verified')

    count = 0
    reversible = tuple(permutations(range(4)))
    vocabularies = [()] + [(t,) for t in reversible] + list(combinations(reversible, 2))
    for observation in partitions(4):
        for vocabulary in vocabularies:
            operations = {f'op{i}': t for i, t in enumerate(vocabulary)}
            word = reversible_word(observation, operations)
            realized = canonical(trace(observation, operations, word, x) for x in range(4))
            behavior = refine(observation, vocabulary)
            assert realized == behavior
            certificate = solve_policy(observation, operations)
            verify_policy(observation, operations, certificate)
            replay_policy(observation, operations, certificate)
            assert certificate['identifiable'] == (len(set(behavior)) == 4)
            bound = (len(set(behavior)) - len(set(observation))) * (4 - len(set(observation)))
            assert len(word) <= bound
            count += 1
    assert count == 4515
    print('discovery: all 4515 reversible four-state systems admit a bounded preset behavioral experiment')

    root = Path(__file__).parent
    results = {}
    for name in ('discovery_trap', 'discovery_reversible'):
        model = json.loads((root / 'Models' / f'{name}.json').read_text())
        result = inspect(model)
        check_separators(model['observation'], model['operations'])
        assert len(set(result['behavior'])) == 4
        assert result['policy']['identifiable'] == (name == 'discovery_reversible')
        assert json.loads((root / 'Reports' / f'{name}.json').read_text()) == result
        assert (root / 'Reports' / f'{name}.md').read_text() == markdown(result)
        results[name] = result
    print('discovery: trap and reversible repair reports match their verified certificates')

    trap = results['discovery_trap']
    positive = results['discovery_reversible']
    model = positive['model']
    broken = deepcopy(positive['policy'])
    broken['winning'] = [r for r in broken['winning'] if r['belief'] != [0]]
    rejected(model['observation'], model['operations'], broken)
    broken = deepcopy(positive['policy'])
    row = next(r for r in broken['winning'] if len(r['belief']) > 1)
    row['rank'] = 0
    rejected(model['observation'], model['operations'], broken)
    broken = deepcopy(positive['policy'])
    broken['winning'].append(deepcopy(broken['winning'][0]))
    rejected(model['observation'], model['operations'], broken)
    model = trap['model']
    broken = deepcopy(trap['policy'])
    broken['identifiable'] = True
    rejected(model['observation'], model['operations'], broken)
    broken = deepcopy(trap['policy'])
    broken['losing'].remove([0, 1, 2])
    broken['winning'].append({'belief': [0, 1, 2], 'rank': 10, 'action': 'ask_A'})
    rejected(model['observation'], model['operations'], broken)
    print('discovery: missing coverage, false rank, duplicate proof, false result and destructive step refused')

    # The chosen finite program is retained inside the modeled whole. Its
    # instruction pointer is the current history length, not an external clock.
    operations = trap['model']['operations']
    histories = [h for length in range(1, 4) for h in product(range(4), repeat=length)]
    programs = [p for length in range(1, 4) for p in product(operations, repeat=length)]
    inputs = [(p, h) for p in programs for h in histories]
    def step(whole):
        program, history = whole
        action = program[(len(history) - 1) % len(program)]
        return program, history + (operations[action][history[-1]],)
    outputs = [step(whole) for whole in inputs]
    assert len(set(outputs)) == len(inputs) == 1176
    assert all((program, history[:-1]) == original
               for original, (program, history) in zip(inputs, outputs))
    assert all(len(history) >= 2 for program, history in outputs)
    # Any one-state history has no predecessor under this append law, even
    # beyond the enumerated bound: output length is always input length + 1.
    for initial in range(4):
        assert (('ask_A',), (initial,)) not in set(outputs)
    b = step((('ask_A',), (1,)))
    c = step((('ask_A',), (2,)))
    assert b != c and b[1][-1] == c[1][-1] == 0
    print('discovery: 1176 internally programmed history steps preserve the whole while reduced states can merge')



if __name__ == '__main__':
    main()
