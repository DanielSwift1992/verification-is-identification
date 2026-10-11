#!/usr/bin/env python3
"""Audit explanatory saturation against pair search and every small quotient."""
from copy import deepcopy
from fractions import Fraction
from itertools import combinations, product
import json
from pathlib import Path
import sys

from discovery_gate import solve_policy
from operational_quotient import distinguishes, kernel, partitions, preserves, refine
from saturate import canonical, markdown, quotient, synthesize, verify
from closed_information import entropy, equal, pushed
from time_entropy import coarse, divergence


def small_models():
    systems = candidates = 0
    for n in (1, 2, 3):
        maps = tuple(product(range(n), repeat=n))
        vocabularies = [()] + [(t,) for t in maps] + list(combinations(maps, 2))
        for observation in partitions(n):
            for vocabulary in vocabularies:
                model = {'states': [str(i) for i in range(n)], 'observation': list(observation),
                         'operations': {'op' + str(i): list(t) for i, t in enumerate(vocabulary)}}
                certificate = synthesize(model)
                summary = verify(model, certificate)
                labels = certificate['classes']
                # Independent reachable-pair search: no use of synthesis or its
                # selected feature words to determine behavioral equivalence.
                for x, y in product(range(n), repeat=2):
                    assert (labels[x] == labels[y]) == (not distinguishes(x, y, observation, vocabulary))
                for candidate in partitions(n):
                    if kernel(candidate) <= kernel(observation) and all(preserves(candidate, t) for t in vocabulary):
                        assert kernel(candidate) <= kernel(labels)
                    candidates += 1
                assert summary['refinements'] <= n - len(set(observation))
                systems += 1
    # JSON types are part of this reading grammar: true and 1 have distinct codes.
    typed = {'states': ['integer', 'boolean'], 'observation': [1, True], 'operations': {}}
    assert verify(typed, synthesize(typed))['final_classes'] == 2
    assert systems == 1919 and candidates == 9521
    return {'systems': systems, 'candidate_quotients': candidates}


def clock_model():
    states = tuple(product(range(4), range(2)))
    index = {w: i for i, w in enumerate(states)}
    swap = (1, 0, 2, 3)
    return {'name': 'Repairing the entropy example',
            'states': [str(x) + '@' + str(c) for x, c in states],
            'observation': [[c, 'small' if x == 0 else 'large'] for x, c in states],
            'operations': {'tick': [index[swap[x], 1-c] for x, c in states]},
            'scope': 'The eight complete states include an internal two-phase clock. This is the finite model of M38-M40, with a fixed reading and a permutation.'}


def mixed_model():
    states = tuple(product(range(2), repeat=4))
    index = {w: i for i, w in enumerate(states)}
    return {'name': 'Separate saturation misses a mixed continuation',
            'states': [''.join(map(str, w)) for w in states],
            'observation': [a for a, b, c, r in states],
            'operations': {'swap_ab': [index[b, a, c, r] for a, b, c, r in states],
                           'swap_bc': [index[a, c, b, r] for a, b, c, r in states]},
            'scope': 'A declared vocabulary of two coordinate permutations on (a,b,c,r). The r coordinate is retained by the whole and ignored by every allowed future reading. These maps alone do not supply an outside chooser or a measurement device.'}


def internal_model():
    states = tuple(bits + (phase,) for bits in product(range(2), repeat=4) for phase in range(3))
    index = {w: i for i, w in enumerate(states)}
    def step(w):
        a, b, c, r, phase = w
        if phase == 0:
            b, c = c, b
        elif phase == 1:
            a, b = b, a
        return a, b, c, r, (phase + 1) % 3
    return {'name': 'Mixed continuation under a resident program and clock',
            'states': [''.join(map(str, w[:4])) + '@' + str(w[4]) for w in states],
            'observation': [[w[4], w[0]] for w in states],
            'operations': {'tick': [index[step(w)] for w in states]},
            'scope': 'The complete 48-state whole includes (a,b,c,r) and a three-phase clock. Phase 0 swaps b,c, phase 1 swaps a,b, and phase 2 changes no bit. Every step advances phase. This fixed permutation has no external action selector.'}


def worked_models():
    clock, mixed, internal = clock_model(), mixed_model(), internal_model()
    cm, mm, im = (synthesize(m) for m in (clock, mixed, internal))
    assert verify(clock, cm)['final_classes'] == 6
    assert verify(mixed, mm)['final_classes'] == 8
    assert verify(internal, im)['final_classes'] == 24
    # The automatically produced clock classes equal the hand-proved repair.
    expected_clock = [(phase, min(x, 2)) for x, phase in product(range(4), range(2))]
    assert kernel(cm['classes']) == kernel(canonical(expected_clock))
    first = refine(mixed['observation'], (mixed['operations']['swap_ab'],))
    second = refine(mixed['observation'], (mixed['operations']['swap_bc'],))
    combined_reading = canonical(list(zip(first, second)))
    assert len(set(first)) == 4 and len(set(second)) == 2 and len(set(combined_reading)) == 4
    assert not preserves(combined_reading, mixed['operations']['swap_bc'])
    assert len(set(refine(combined_reading, tuple(mixed['operations'].values())))) == 8
    assert mm['steps'][-1]['word'] == ['swap_bc', 'swap_ab']
    expanded_question = deepcopy(mixed)
    expanded_question['observation'] = [[int(s[0]), int(s[3])] for s in mixed['states']]
    assert verify(expanded_question, synthesize(expanded_question))['final_classes'] == 16
    for x, y in product(range(16), repeat=2):
        assert (mm['classes'][x] == mm['classes'][y]) == (x // 2 == y // 2)
    for model in (clock, mixed, internal):
        for transition in model['operations'].values():
            assert sorted(transition) == list(range(len(model['states'])))
            inverse = {target: source for source, target in enumerate(transition)}
            assert all(inverse[transition[x]] == x for x in range(len(transition)))
    for x, y in product(range(48), repeat=2):
        wx, wy = internal['states'][x], internal['states'][y]
        assert (im['classes'][x] == im['classes'][y]) == (wx[:3] == wy[:3] and wx[-1] == wy[-1])
    # Explicit observation trace exposes c only after the internally scheduled mix.
    trace = []
    for state in (internal['states'].index('0000@0'), internal['states'].index('0010@0')):
        row = [internal['observation'][state]]
        for _ in range(2):
            state = internal['operations']['tick'][state]
            row.append(internal['observation'][state])
        trace.append(row)
    assert trace == [[[0, 0], [1, 0], [2, 0]], [[0, 0], [1, 0], [2, 1]]]
    return {'clock_classes': 6, 'separate_classes': [4, 2], 'joined_separate_classes': 4,
            'mixed_classes': 8, 'mixed_states': 16, 'added_residual_question_classes': 16, 'internal_classes': 24,
            'internal_states': 48, 'internal_witness_trace': trace}


def corruptions():
    model = clock_model()
    certificate = synthesize(model)
    cases = {}
    def changed(name, mutate):
        c = deepcopy(certificate)
        mutate(c)
        cases[name] = (model, c)
    def over_refine(c):
        c['classes'] = list(range(8))
        c['quotient'] = quotient(model, c['classes'])
        assert all(preserves(c['classes'], t) for t in model['operations'].values())
    changed('unnecessary_distinctions_despite_valid_dynamics', over_refine)
    changed('merged_classes', lambda c: c.update(classes=[0] * 8))
    changed('missing_state', lambda c: c['classes'].pop())
    changed('invalid_pair', lambda c: c['steps'][0].update(pair=[0, 0]))
    changed('already_distinguished_pair', lambda c: c['steps'][0].update(pair=[0, 1]))
    changed('unjustified_word', lambda c: c['steps'][0].update(word=[]))
    changed('future_suffix_reference', lambda c: c['steps'][0].update(suffix_feature=1))
    changed('wrong_successor', lambda c: c['quotient']['operations']['tick'].__setitem__(0, 0))
    changed('missing_operation', lambda c: c['quotient']['operations'].clear())
    changed('changed_base_answer', lambda c: c['quotient']['observation'].__setitem__(0, 'wrong'))
    def stop_early(c):
        c['steps'] = []
        c['classes'] = canonical(model['observation'])
        c['quotient'] = quotient(model, c['classes'])
    changed('premature_stop_with_consistent_tables', stop_early)
    another = deepcopy(model)
    another['operations']['tick'][0] = 0
    cases['different_model'] = (another, certificate)
    for name, (m, c) in cases.items():
        try:
            verify(m, c)
        except (ValueError, KeyError, TypeError, IndexError):
            continue
        raise AssertionError('accepted corrupt saturation certificate: ' + name)
    return sorted(cases)


def entropy_refinement():
    cases = strict_coarse_decreases = strict_macro_increases = 0
    for n in (1, 2, 3, 4):
        priors = [{i: Fraction(v, 4) for i, v in enumerate(counts) if v}
                  for counts in product(range(5), repeat=n) if sum(counts) == 4]
        for old, new in product(partitions(n), repeat=2):
            if not kernel(new) <= kernel(old):
                continue
            e, f = dict(enumerate(old)), dict(enumerate(new))
            for prior in priors:
                old_bar, new_bar = coarse(prior, e), coarse(prior, f)
                assert coarse(new_bar, e) == old_bar
                decrease = entropy(old_bar) - entropy(new_bar)
                equal(decrease, divergence(new_bar, old_bar))
                macro_increase = entropy(pushed(prior, f.__getitem__)) - entropy(pushed(prior, e.__getitem__))
                assert decrease >= -1e-12 and macro_increase >= -1e-12
                strict_coarse_decreases += decrease > 1e-12
                strict_macro_increases += macro_increase > 1e-12
                cases += 1
    assert strict_coarse_decreases > 0 and strict_macro_increases > 0
    return {'nested_partition_priors': cases, 'strict_coarse_decreases': strict_coarse_decreases,
            'strict_macro_increases': strict_macro_increases}


def main():
    root = Path(__file__).resolve().parent
    trap = json.loads((root / 'Models/discovery_trap.json').read_text())
    trap_certificate = synthesize(trap)
    trap_summary = verify(trap, trap_certificate)
    assert trap_summary['final_classes'] == 4
    assert not solve_policy(trap['observation'], trap['operations'])['identifiable']
    result = {'exhaustive': small_models(), 'worked': worked_models(),
              'corruptions_refused': corruptions(),
              'fixed_prior_entropy': entropy_refinement(),
              'acquisition_boundary': {'behavioral_classes': 4, 'single_run_identification': False}}
    outputs = {root / 'Reports/saturation_audit.json': json.dumps(result, indent=2) + '\n'}
    for name, model in [('saturation_clock', clock_model()), ('saturation_mixed', mixed_model()),
                        ('saturation_internal', internal_model()), ('saturation_trap', trap)]:
        certificate = synthesize(model)
        if name != 'saturation_trap':
            outputs[root / ('Models/' + name + '.json')] = json.dumps(model, indent=2) + '\n'
        outputs[root / ('Reports/' + name + '.json')] = json.dumps(certificate, indent=2) + '\n'
        outputs[root / ('Reports/' + name + '.md')] = markdown(model, certificate)
    for path, content in outputs.items():
        if '--write' in sys.argv:
            path.write_text(content)
        else:
            assert path.read_text() == content, 'stale artifact: ' + str(path)
    print('saturation:', result['exhaustive'], '; corruption refusals:', len(result['corruptions_refused']),
          '; worked:', result['worked'], '; acquisition:', result['acquisition_boundary'])


if __name__ == '__main__':
    main()
