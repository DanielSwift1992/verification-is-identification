#!/usr/bin/env python3
"""Explain and certify the least autonomous refinement of a finite reading.

The given complete transition table is a premise. Features are future readings
in that table, not automatically instruments available to an internal observer.
Verification replays supplied witnesses and local equations, without synthesis.
"""
import argparse
import hashlib
import json
from pathlib import Path
import sys


def require(condition, message):
    if not condition:
        raise ValueError(message)


def json_key(value):
    return json.dumps(value, sort_keys=True, separators=(',', ':'), allow_nan=False)


def validate_model(model):
    states, observation, operations = (model[k] for k in ('states', 'observation', 'operations'))
    require(isinstance(states, list) and len(states) > 0, 'nonempty state list required')
    require(all(isinstance(s, str) for s in states) and len(set(states)) == len(states),
            'state names must be distinct strings')
    require(isinstance(observation, list) and len(observation) == len(states), 'observation coverage')
    require(isinstance(operations, dict), 'operation table required')
    for name, table in operations.items():
        require(isinstance(name, str) and name != '', 'operation name required')
        require(isinstance(table, list) and len(table) == len(states), 'operation coverage: ' + name)
        require(all(type(x) is int and 0 <= x < len(states) for x in table),
                'operation must be total on the declared carrier: ' + name)
    json_key(model)
    return states, observation, operations


def fingerprint(model):
    return hashlib.sha256(json_key(model).encode()).hexdigest()


def canonical(values):
    labels = {}
    return [labels.setdefault(json_key(v), len(labels)) for v in values]


def feature_values(model, word):
    require(isinstance(word, list), 'feature word must be a list')
    require(all(isinstance(op, str) and op in model['operations'] for op in word),
            'unknown feature operation')
    values = []
    for start in range(len(model['states'])):
        state = start
        for op in word:
            state = model['operations'][op][state]
        values.append(model['observation'][state])
    return values


def partition(columns):
    return canonical([list(row) for row in zip(*columns)])


def quotient(model, labels):
    representatives = [labels.index(i) for i in range(max(labels) + 1)]
    return {'observation': [model['observation'][x] for x in representatives],
            'operations': {name: [labels[table[x]] for x in representatives]
                           for name, table in model['operations'].items()}}


def synthesize(model):
    states, observation, operations = validate_model(model)
    words, columns, steps = [[]], [observation], []
    labels = partition(columns)
    while True:
        conflict = None
        for x in range(len(states)):
            for y in range(x + 1, len(states)):
                if labels[x] != labels[y]:
                    continue
                for name, table in sorted(operations.items()):
                    if labels[table[x]] != labels[table[y]]:
                        suffix = next(i for i, col in enumerate(columns)
                                      if json_key(col[table[x]]) != json_key(col[table[y]]))
                        conflict = (x, y, name, suffix)
                        break
                if conflict:
                    break
            if conflict:
                break
        if conflict is None:
            break
        x, y, name, suffix = conflict
        word = [name] + words[suffix]
        steps.append({'pair': [x, y], 'operation': name, 'suffix_feature': suffix, 'word': word})
        words.append(word)
        columns.append(feature_values(model, word))
        updated = partition(columns)
        require(len(set(updated)) > len(set(labels)), 'synthesis did not refine')
        labels = updated
    return {'version': 1, 'model_sha256': fingerprint(model), 'steps': steps,
            'classes': labels, 'quotient': quotient(model, labels)}


def verify(model, certificate):
    states, observation, operations = validate_model(model)
    require(certificate['version'] == 1, 'certificate version')
    require(certificate['model_sha256'] == fingerprint(model), 'certificate belongs to another model')
    words, columns = [[]], [observation]
    labels = partition(columns)
    initial_classes = len(set(labels))
    steps = certificate['steps']
    require(isinstance(steps, list) and len(steps) <= len(states) - initial_classes,
            'strict refinement budget')
    for index, step in enumerate(steps):
        pair = step['pair']
        require(isinstance(pair, list) and len(pair) == 2, 'witness pair')
        x, y = pair
        require(all(type(s) is int and 0 <= s < len(states) for s in pair) and x != y,
                'witness state address')
        name, suffix, word = step['operation'], step['suffix_feature'], step['word']
        require(name in operations and type(suffix) is int and 0 <= suffix < len(words),
                'witness operation or suffix')
        require(word == [name] + words[suffix], 'feature must prefix its witnessed suffix')
        require(labels[x] == labels[y], 'witness was already distinguished')
        tx, ty = operations[name][x], operations[name][y]
        require(json_key(columns[suffix][tx]) != json_key(columns[suffix][ty]),
                'suffix does not distinguish the successor pair')
        words.append(word)
        columns.append(feature_values(model, word))
        updated = partition(columns)
        require(len(set(updated)) > len(set(labels)), 'non-refining feature at ' + str(index))
        labels = updated

    # Exact feature kernels rule out unexplained, unnecessary extra distinctions.
    require(certificate['classes'] == labels, 'classes must equal the witnessed feature kernel')
    q = certificate['quotient']
    count = len(set(labels))
    require(len(q['observation']) == count, 'quotient observation coverage')
    require(set(q['operations']) == set(operations), 'quotient operation vocabulary')
    for name, table in q['operations'].items():
        require(len(table) == count and all(type(i) is int and 0 <= i < count for i in table),
                'quotient transition coverage')
    # These are local proof obligations on the supplied quotient, not a rerun
    # of the conflict search. They establish closure for every finite word.
    for x in range(len(states)):
        require(json_key(q['observation'][labels[x]]) == json_key(observation[x]),
                'quotient changed the initial reading')
        for name, table in operations.items():
            require(q['operations'][name][labels[x]] == labels[table[x]],
                    'representation is not autonomous under ' + name)
    return {'initial_classes': initial_classes, 'final_classes': count,
            'refinements': len(steps), 'features': words,
            'maximum_word_length': max(map(len, words)), 'whole_states': len(states)}


def markdown(model, certificate):
    summary = verify(model, certificate)
    lines = ['# ' + model.get('name', 'Certified saturation'), '',
             model.get('scope', 'The finite model is an input premise.'), '',
             '## Result', '',
             '{} states, {} initial classes, {} final classes. Strict refinement steps: {}.'.format(
                 summary['whole_states'], summary['initial_classes'], summary['final_classes'],
                 summary['refinements']), '',
             'The result is the coarsest autonomous refinement of the initial reading',
             'for exactly the declared total operations. Minimality concerns its',
             'distinctions, not the number or cost of sensors, memory or feature words.', '',
             '## Why each distinction was added', '',
             'Words run from left to right. The empty word reads the current state.', '']
    if not certificate['steps']:
        lines += ['No refinement is needed: every supplied operation already descends.', '']
    for i, step in enumerate(certificate['steps'], 1):
        x, y = step['pair']
        values = feature_values(model, step['word'])
        lines += ['{}. Previously equal: `{}` and `{}`. Read after `{}`: `{}` versus `{}`.'.format(
            i, model['states'][x], model['states'][y], ' then '.join(step['word']),
            json_key(values[x]), json_key(values[y]))]
    lines += ['', '## Certified quotient', '', '| State | Class |', '| --- | --- |']
    for state, label in zip(model['states'], certificate['classes']):
        lines.append('| {} | {} |'.format(state, label))
    lines += ['', '```json', json.dumps(certificate['quotient'], indent=2), '```', '',
              '## Proof boundary', '',
              'Every feature is a future reading of the original model. Consequently',
              'no behaviorally equivalent states are separated. The checked quotient',
              'preserves the original observation and every operation, so states it',
              'merges agree on every future word. Together these two directions prove',
              'minimality. A fingerprint binds the certificate to this supplied model;',
              'it does not prove that model faithful to reality.', '',
              'Synthesis reads the transition table. Physical acquisition of the feature',
              'vector requires a separate experiment, preparation and internal memory.',
              'In an irreversible reduced model, pairwise future distinctions may not',
              'be jointly discoverable in a single run. No free reset or sensor is added.', '']
    return '\n'.join(lines)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('model', type=Path)
    parser.add_argument('--output', type=Path, help='prefix for .json certificate and .md explanation')
    parser.add_argument('--verify', type=Path, help='verify an existing certificate without synthesis')
    args = parser.parse_args()
    try:
        model = json.loads(args.model.read_text())
        certificate = json.loads(args.verify.read_text()) if args.verify else synthesize(model)
        summary = verify(model, certificate)
        if args.output:
            args.output.with_suffix('.json').write_text(json.dumps(certificate, indent=2) + '\n')
            args.output.with_suffix('.md').write_text(markdown(model, certificate))
        print(json.dumps(summary, indent=2))
    except (ValueError, KeyError, TypeError, IndexError, OSError) as error:
        print('saturation refused: ' + str(error), file=sys.stderr)
        raise SystemExit(1)


if __name__ == '__main__':
    main()
