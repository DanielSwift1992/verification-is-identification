#!/usr/bin/env python3
"""Independent executions and adversarial checks for internal controllers."""
from copy import deepcopy
from itertools import combinations, permutations, product
import json
from pathlib import Path

from internal_controller import (BOOT, closed_cycles, compile_controller,
                                 joint_step, markdown, output, report,
                                 verify_controller)
from operational_quotient import partitions
from verdict_discovery import solve


def run_case(observation, operations, question):
    certificate = solve(observation, operations, question)
    if not certificate['answerable']:
        try:
            compile_controller(observation, operations, question, certificate)
        except AssertionError:
            return False, 0
        raise AssertionError('an impossible question acquired a guaranteed controller')
    compiled = compile_controller(observation, operations, question, certificate)
    verify_controller(observation, operations, question, compiled)
    program = compiled['program']
    horizon = 1 + max(n['rank'] for n in compiled['annotations'])
    whole_map, starts, finals = closed_cycles(observation, operations, program, horizon)
    assert len(whole_map) == len(observation) * (horizon + 1)
    assert set(whole_map) == set(whole_map.values())
    inverse = {after: before for before, after in whole_map.items()}
    for origin, (start, final) in enumerate(zip(starts, finals)):
        current = (origin, BOOT)
        whole = start
        seen_output = False
        for _ in range(horizon):
            # This execution has no access to certificate labels or q(original).
            previous = whole
            current = joint_step(observation, operations, program, current)
            whole = whole_map[whole]
            assert whole[:-1] == previous and whole[-1] == current
            assert inverse[whole] == previous
            answer = output(program, current[1])
            if answer is not None:
                assert answer == question[origin]
                seen_output = True
            elif seen_output:
                raise AssertionError('output lost inside promised experiment window')
        assert whole == final and seen_output
        assert whole_map[final] == start and output(program, start[-1][1]) is None
    return True, len(whole_map)


def reject(observation, operations, question, compiled):
    try:
        verify_controller(observation, operations, question, compiled)
    except (AssertionError, KeyError, IndexError, TypeError):
        return
    raise AssertionError('corrupt executable controller accepted')


def main():
    maps = tuple(product(range(3), repeat=3))
    vocabularies = [()] + [(t,) for t in maps] + list(combinations(maps, 2))
    cases = accepted = whole_states = 0
    for observation in partitions(3):
        for vocabulary in vocabularies:
            operations = {f'op{i}': t for i, t in enumerate(vocabulary)}
            for question in partitions(3):
                success, size = run_case(observation, operations, question)
                cases += 1
                accepted += success
                whole_states += size
    assert cases == 9475
    print(f'controller: {cases} system/questions, {accepted} compiled successes, {whole_states} finite whole states checked')

    # Every branch map is a permutation. Feedback selects a branch from the
    # observation, so the assembled map need not be one-to-one. Remembering the
    # selected branch makes the prepared-slice output injective again.
    feedback_cases = feedback_losses = 0
    for observation in partitions(3):
        for operations in product(tuple(permutations(range(3))), repeat=2):
            for selector in product(range(2), repeat=len(set(observation))):
                outputs = tuple(operations[selector[observation[x]]][x] for x in range(3))
                images = [{outputs[x] for x in range(3) if selector[observation[x]] == i}
                          for i in range(2)]
                injective = len(set(outputs)) == 3
                assert injective == images[0].isdisjoint(images[1])
                tagged = {(selector[observation[x]], outputs[x]) for x in range(3)}
                assert len(tagged) == 3
                feedback_cases += 1
                feedback_losses += not injective
    assert feedback_cases == 792 and feedback_losses > 0
    print(f'controller: {feedback_cases} feedback selections, {feedback_losses} noninjective despite reversible branches')

    # A forward-invariant subset of a finite permutation cannot be newly entered.
    invariant_sets = 0
    for transition in permutations(range(4)):
        for bits in product(range(2), repeat=4):
            subset = {x for x in range(4) if bits[x]}
            if {transition[x] for x in subset} <= subset:
                assert {x for x in range(4) if transition[x] in subset} == subset
                invariant_sets += 1
    print(f'controller: {invariant_sets} forward-invariant sets admit no incoming acquisition step')

    root = Path(__file__).parent
    model = json.loads((root / 'Models/discovery_verdict.json').read_text())
    observation, operations, question = model['observation'], model['operations'], model['question']
    result = report(model)
    assert result == json.loads((root / 'Reports/internal_controller.json').read_text())
    assert markdown(result) == (root / 'Reports/internal_controller.md').read_text()
    program = result['program']
    # B and C have equal accessible final configurations, distinct whole histories.
    assert result['traces'][1]['configurations'][-1] == result['traces'][2]['configurations'][-1]
    assert result['traces'][1]['configurations'][0] != result['traces'][2]['configurations'][0]
    compiled = {'program': program, 'annotations': result['annotations']}
    broken = deepcopy(compiled)
    broken['program']['boot'][0]['memory'] = broken['program']['boot'][1]['memory']
    reject(observation, operations, question, broken)
    broken = deepcopy(compiled)
    active = next(s for s in broken['program']['states'] if s['action'] is not None)
    active['branches'][0]['memory'] = active['branches'][1]['memory']
    reject(observation, operations, question, broken)
    broken = deepcopy(compiled)
    leaf = next(s for s in broken['program']['states'] if s['answer'] == 'was_not_A')
    leaf['answer'] = 'was_A'
    reject(observation, operations, question, broken)
    broken = deepcopy(compiled)
    broken['program']['original_answer'] = question
    reject(observation, operations, question, broken)
    print('controller: wrong boot, wrong observation branch, wrong answer and undeclared oracle input refused')

    reversible = json.loads((root / 'Models/discovery_reversible.json').read_text())
    success, _ = run_case(reversible['observation'], reversible['operations'], tuple(range(4)))
    assert success
    certificate = solve(reversible['observation'], reversible['operations'], tuple(range(4)))
    assert max(row['rank'] for row in certificate['winning']) >= 2
    print('controller: the four-state reversible experiment also compiles a multi-action controller')


if __name__ == '__main__':
    main()
