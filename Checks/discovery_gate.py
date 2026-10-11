#!/usr/bin/env python3
"""Finite discovery certificates: separating words, policies and losing traps.

The interpreted transition table is a premise. This tool validates certificates
against that table; it does not infer a physical model from observations.
"""
import argparse
from collections import deque
from itertools import combinations, permutations, product
import json
from pathlib import Path

from operational_quotient import canonical, partitions, refine


def shortest_separator(observation, operations, left, right):
    pending = deque([(left, right, ())])
    seen = {(left, right)}
    while pending:
        a, b, word = pending.popleft()
        if observation[a] != observation[b]:
            return word
        for name, transition in operations.items():
            pair = (transition[a], transition[b])
            if pair not in seen:
                seen.add(pair)
                pending.append((*pair, word + (name,)))
    return None


def branches(observation, states):
    grouped = {}
    for state in sorted(states):
        grouped.setdefault(observation[state], []).append(state)
    return tuple(tuple(group) for group in grouped.values())


def successors(observation, transition, belief):
    outputs = tuple(transition[x] for x in belief)
    # Merged origins cannot be recovered later from this model's current state.
    if len(set(outputs)) != len(belief):
        return None
    return branches(observation, outputs)


def solve_policy(observation, operations):
    n = len(observation)
    beliefs = tuple(tuple(x for x in range(n) if mask & (1 << x))
                    for mask in range(1, 1 << n))
    beliefs = tuple(s for s in beliefs if len({observation[x] for x in s}) == 1)
    winning = {s: {'rank': 0, 'action': None} for s in beliefs if len(s) == 1}
    rank = 0
    while True:
        added = {}
        for belief in beliefs:
            if belief in winning:
                continue
            for name, transition in operations.items():
                children = successors(observation, transition, belief)
                if children is not None and all(child in winning for child in children):
                    added[belief] = {'rank': rank + 1, 'action': name}
                    break
        if not added:
            break
        winning.update(added)
        rank += 1
    roots = branches(observation, range(n))
    return {
        'identifiable': all(root in winning for root in roots),
        'winning': [{'belief': list(s), **proof} for s, proof in sorted(winning.items())],
        'losing': [list(s) for s in beliefs if s not in winning],
    }


def verify_policy(observation, operations, certificate):
    """Check local proof obligations, without running the fixed-point solver."""
    n = len(observation)
    required = {tuple(x for x in range(n) if mask & (1 << x))
                for mask in range(1, 1 << n)}
    required = {s for s in required if len({observation[x] for x in s}) == 1}
    entries = certificate['winning']
    win = {tuple(row['belief']): row for row in entries}
    lose = {tuple(s) for s in certificate['losing']}
    assert len(win) == len(entries) and len(lose) == len(certificate['losing'])
    assert not (win.keys() & lose) and win.keys() | lose == required
    for belief, row in win.items():
        assert type(row['rank']) is int and row['rank'] >= 0
        if len(belief) == 1:
            assert row['rank'] == 0 and row['action'] is None
            continue
        assert row['action'] in operations
        transition = operations[row['action']]
        # Directly reconstruct every origin's outcome and preserve multiplicity.
        outcomes = [(source, transition[source], observation[transition[source]]) for source in belief]
        assert len({target for _, target, _ in outcomes}) == len(outcomes)
        for answer in {answer for _, _, answer in outcomes}:
            child = tuple(sorted(target for _, target, value in outcomes if value == answer))
            assert child in win and win[child]['rank'] < row['rank']
    for belief in lose:
        assert len(belief) > 1
        for transition in operations.values():
            outcomes = [transition[x] for x in belief]
            if len(set(outcomes)) < len(outcomes):
                continue
            groups = {answer: tuple(sorted(x for x in outcomes if observation[x] == answer))
                      for answer in {observation[x] for x in outcomes}}
            assert any(group in lose for group in groups.values())
    expected = all(root in win for root in branches(observation, range(n)))
    assert type(certificate['identifiable']) is bool and certificate['identifiable'] == expected
    return True


def replay_policy(observation, operations, certificate):
    """Replay every possible origin, checking the reported original identity."""
    if not certificate['identifiable']:
        return []
    win = {tuple(row['belief']): row for row in certificate['winning']}
    traces = []
    for actual in range(len(observation)):
        possible = {x: x for x in range(len(observation)) if observation[x] == observation[actual]}
        current = actual
        actions, readings = [], [observation[current]]
        while len(possible) > 1:
            belief = tuple(sorted(possible.values()))
            action = win[belief]['action']
            transition = operations[action]
            current = transition[current]
            possible = {origin: transition[state] for origin, state in possible.items()
                        if observation[transition[state]] == observation[current]}
            actions.append(action)
            readings.append(observation[current])
        assert next(iter(possible)) == actual
        traces.append({'origin': actual, 'actions': actions, 'observations': readings})
    return traces


def reversible_word(observation, operations):
    """Construct one preset word separating all behavioral classes on finite K."""
    n = len(observation)
    assert all(sorted(t) == list(range(n)) for t in operations.values())
    behavior = refine(observation, tuple(operations.values()))
    current = list(range(n))
    history = [(observation[x],) for x in range(n)]
    word = []
    while True:
        pair = next(((x, y) for x in range(n) for y in range(x + 1, n)
                     if behavior[x] != behavior[y] and history[x] == history[y]), None)
        if pair is None:
            return tuple(word)
        x, y = pair
        separator = shortest_separator(observation, operations, current[x], current[y])
        assert separator is not None and separator
        before = len(set(history))
        for action in separator:
            current = [operations[action][state] for state in current]
            history = [trace + (observation[state],) for trace, state in zip(history, current)]
            word.append(action)
        assert len(set(history)) > before


def inspect(model):
    states = model['states']
    assert states and len(set(states)) == len(states) and all(isinstance(s, str) for s in states)
    observation = model['observation']
    n = len(states)
    assert len(observation) == n
    assert all(type(x) in (str, int) for x in observation)
    operations = model['operations']
    assert isinstance(operations, dict)
    assert all(isinstance(name, str) and name for name in operations)
    assert all(len(t) == n and all(type(x) is int and 0 <= x < n for x in t)
               for t in operations.values())
    policy = solve_policy(observation, operations)
    verify_policy(observation, operations, policy)
    behavior = refine(observation, tuple(operations.values()))
    pairs = []
    for left, right in combinations(range(n), 2):
        word = shortest_separator(observation, operations, left, right)
        pairs.append({'left': left, 'right': right, 'word': None if word is None else list(word)})
    residual = max(len({behavior[x] for x in range(n) if observation[x] == e})
                   for e in set(observation))
    result = {'model': model, 'behavior': list(behavior), 'predictive_residual_values': residual, 'separators': pairs,
              'policy': policy, 'traces': replay_policy(observation, operations, policy)}
    if 'question' in model:
        from verdict_discovery import solve, verify, replay
        question = model['question']
        assert len(question) == n and all(type(x) in (str, int) for x in question)
        assert len({type(x) for x in question}) == 1
        certificate = solve(observation, operations, question)
        verify(observation, operations, question, certificate)
        result['question_discovery'] = {'certificate': certificate,
                                       'traces': replay(observation, operations, question, certificate)}
    if all(sorted(t) == list(range(n)) for t in operations.values()):
        result['preset_word'] = list(reversible_word(observation, operations))
    return result


def markdown(result):
    model = result['model']
    states = model['states']
    lines = [f"# {model['name']}", '', model.get('scope', ''), '',
             f"Behavioral classes: **{len(set(result['behavior']))}**.",
             f"Minimum extra label alphabet for predictive sufficiency: **{result['predictive_residual_values']}** values.",
             f"Guaranteed initial-state identification in one run: **{result['policy']['identifiable']}**.", '',
             '| ' + ' | '.join(['State', 'Current observation', *model['operations']]) + ' |',
             '|' + '---|' * (2 + len(model['operations']))]
    for i, state in enumerate(states):
        lines.append("| " + " | ".join([state, str(model["observation"][i]),
                                             *(states[t[i]] for t in model["operations"].values())]) + " |")
    lines += ['', '## Shortest pair separators', '', '| Pair | Operation word |', '|---|---|']
    for pair in result['separators']:
        word = pair['word']
        label = 'none' if word is None else (' → '.join(word) if word else 'current observation')
        lines.append(f"| {states[pair['left']]} / {states[pair['right']]} | {label} |")
    if result['traces']:
        lines += ['', '## Verified adaptive execution', '', '| Original state | Actions | Observations |', '|---|---|---|']
        for trace in result['traces']:
            lines.append(f"| {states[trace['origin']]} | {' → '.join(trace['actions']) or 'none'} | " +
                         ' → '.join(map(str, trace['observations'])) + ' |')
    else:
        lines += ['', '## Checked obstruction', '',
                  'The JSON certificate lists a closed family of losing beliefs. For each available action, '
                  'either two origins merge or some possible outcome remains in that family. '
                  'A finite successful policy cannot leave such a family on every outcome.']
        for root in branches(model['observation'], range(len(states))):
            if list(root) not in result['policy']['losing']:
                continue
            lines += ['', 'Unresolved initial belief: ' + ', '.join(states[x] for x in root) + '.']
            for name, transition in model['operations'].items():
                collisions = [(x, y) for x, y in combinations(root, 2) if transition[x] == transition[y]]
                if collisions:
                    x, y = collisions[0]
                    lines.append(f"- {name} merges {states[x]} and {states[y]} into {states[transition[x]]}.")
    if 'preset_word' in result:
        lines += ['', 'Preset word separating behavioral classes: ' +
                  (' → '.join(result['preset_word']) or 'current observation') + '.']
    if 'question_discovery' in result:
        discovery = result['question_discovery']
        lines += ['', '## The fixed question about the original state', '',
                  f"Guaranteed verdict discovery: **{discovery['certificate']['answerable']}**.", '',
                  '| Origin | Certified answer | Actions | Remaining original candidates |', '|---|---|---|---|']
        for row in discovery['traces']:
            lines.append('| ' + ' | '.join([states[row['origin']], str(row['answer']),
                                           ' → '.join(row['actions']) or 'none',
                                           ', '.join(states[x] for x in row['possible_origins'])]) + ' |')
    return '\n'.join(lines) + '\n'


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('model', type=Path)
    parser.add_argument('--output', type=Path, required=True,
                        help='Output prefix for the checked JSON certificate and Markdown report')
    args = parser.parse_args()
    result = inspect(json.loads(args.model.read_text()))
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.with_suffix('.json').write_text(json.dumps(result, indent=2) + '\n')
    args.output.with_suffix('.md').write_text(markdown(result))
    print(f"discovery: checked {args.model}, wrote {args.output}.json and .md")


if __name__ == '__main__':
    main()
