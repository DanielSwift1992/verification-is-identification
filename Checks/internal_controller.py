#!/usr/bin/env python3
"""Compile verdict certificates into controllers with observation-only inputs.

Proof annotations describe possible worlds. They are never passed to the
controller at execution. A bounded history construction separately closes the
joint plant/controller trajectory into a finite permutation.
"""
import argparse
import json
from pathlib import Path

from discovery_gate import inspect
from verdict_discovery import move, split, verify


BOOT = -1


def normalize(pairs):
    return tuple(tuple(pair) for pair in pairs)


def compile_controller(observation, operations, question, certificate):
    verify(observation, operations, question, certificate)
    assert certificate['answerable'], 'no guaranteed controller for this question'
    rows = {normalize(r['belief']): r for r in certificate['winning']}
    roots = split(observation, enumerate(question))
    beliefs = list(roots)
    index = {b: i for i, b in enumerate(beliefs)}
    states, annotations = [], []
    for belief in beliefs:
        row = rows[belief]
        branches = []
        if row['action'] is not None:
            for child in move(observation, operations[row['action']], belief):
                if child not in index:
                    index[child] = len(beliefs)
                    beliefs.append(child)
                branches.append({'observation': observation[child[0][0]],
                                 'memory': index[child]})
        states.append({'action': row['action'], 'answer': row['answer'],
                       'branches': branches})
        annotations.append({'belief': [list(p) for p in belief], 'rank': row['rank']})
    program = {'boot': [{'observation': observation[b[0][0]], 'memory': index[b]}
                        for b in roots], 'states': states}
    return {'program': program, 'annotations': annotations}


def lookup(branches, reading):
    matches = [b['memory'] for b in branches if b['observation'] == reading]
    assert len(matches) == 1, 'observation has no unique declared branch'
    return matches[0]


def verify_controller(observation, operations, question, compiled):
    """Check the supplied machine and annotations, without calling the solver."""
    program, notes = compiled['program'], compiled['annotations']
    assert set(compiled) == {'program', 'annotations'}
    assert set(program) == {'boot', 'states'}
    assert len(program['states']) == len(notes) > 0
    for branches in [program['boot']] + [s['branches'] for s in program['states']]:
        assert len({b['observation'] for b in branches}) == len(branches)
        for branch in branches:
            assert set(branch) == {'observation', 'memory'}
            assert type(branch['memory']) is int and 0 <= branch['memory'] < len(notes)
    for state, note in zip(program['states'], notes):
        assert set(state) == {'action', 'answer', 'branches'}
        assert set(note) == {'belief', 'rank'}
    # The existing certificate checker validates the meaning of the annotation,
    # including original-question coverage, terminal answers and strict ranks.
    certificate = {'answerable': True, 'losing': [], 'winning': [
        {**note, 'action': state['action'], 'answer': state['answer']}
        for note, state in zip(notes, program['states'])]}
    verify(observation, operations, question, certificate)
    roots = split(observation, enumerate(question))
    assert {b['observation'] for b in program['boot']} == set(observation)
    for root in roots:
        memory = lookup(program['boot'], observation[root[0][0]])
        assert normalize(notes[memory]['belief']) == root
    for state, note in zip(program['states'], notes):
        if state['action'] is None:
            assert state['branches'] == []
            continue
        children = move(observation, operations[state['action']], normalize(note['belief']))
        assert {b['observation'] for b in state['branches']} == {observation[c[0][0]] for c in children}
        for child in children:
            memory = lookup(state['branches'], observation[child[0][0]])
            assert normalize(notes[memory]['belief']) == child
    return True


def joint_step(observation, operations, program, configuration):
    """The environment applies actions. Control reads only memory and readings.

    Neither original state, q, proof annotations nor a policy search are inputs.
    BOOT is a prepared controller state common to every environmental origin.
    Terminal self-loops describe a reduced machine, not a reversible whole.
    """
    current, memory = configuration
    if memory == BOOT:
        return current, lookup(program['boot'], observation[current])
    state = program['states'][memory]
    if state['action'] is None:
        return configuration
    current = operations[state['action']][current]
    return current, lookup(state['branches'], observation[current])


def output(program, memory):
    if memory == BOOT or program['states'][memory]['action'] is not None:
        return None
    return program['states'][memory]['answer']


def closed_cycles(observation, operations, program, horizon):
    """A finite set of prepared trajectory prefixes, closed into disjoint cycles.

    Internal history length supplies the phase. At the last phase a recovery
    transition returns to the first configuration. That transition is outside
    the promised experimental window and need not be an allowed plant action.
    This is an abstract permutation, not a local physical implementation.
    """
    assert type(horizon) is int and horizon >= 1
    permutation, starts, finals = {}, [], []
    for origin in range(len(observation)):
        history = ((origin, BOOT),)
        starts.append(history)
        for _ in range(horizon):
            following = history + (joint_step(observation, operations, program, history[-1]),)
            permutation[history] = following
            history = following
        permutation[history] = starts[-1]
        finals.append(history)
    return permutation, starts, finals


def report(model):
    observation, operations, question = model['observation'], model['operations'], model['question']
    # Reuse the table schema checks, including non-null homogeneous answer tags.
    certificate = inspect(model)['question_discovery']['certificate']
    compiled = compile_controller(observation, operations, question, certificate)
    verify_controller(observation, operations, question, compiled)
    horizon = 1 + max(n['rank'] for n in compiled['annotations'])
    program = compiled['program']
    permutation, starts, finals = closed_cycles(observation, operations, program, horizon)
    assert set(permutation) == set(permutation.values())
    traces = []
    for origin, (start, final) in enumerate(zip(starts, finals)):
        whole = start
        for _ in range(horizon):
            whole = permutation[whole]
        assert whole == final and output(program, whole[-1][1]) == question[origin]
        traces.append({'origin': model['states'][origin], 'configurations': [
            {'scene': model['states'][x], 'memory': m, 'answer': output(program, m)}
            for x, m in whole]})
    return {'title': 'An internal controller reads observations, not original-answer tags',
            **compiled, 'horizon_including_boot': horizon,
            'whole_states': len(permutation), 'cycle_length': horizon + 1,
            'traces': traces}


def markdown(result):
    lines = ['# ' + result['title'], '',
             'The executable program contains a boot table and numbered memory states.',
             'The separate proof annotations are unavailable to the running controller.', '',
             '| Memory | Action | Answer when finished | Next observation → memory |',
             '|---|---|---|---|']
    for i, state in enumerate(result['program']['states']):
        branches = ', '.join(f"{b['observation']} → {b['memory']}" for b in state['branches'])
        lines.append(f"| {i} | {state['action']} | {state['answer']} | {branches} |")
    lines += ['', '| Initial observation | Prepared memory becomes |', '|---|---|']
    for branch in result['program']['boot']:
        lines.append(f"| {branch['observation']} | {branch['memory']} |")
    lines += ['', '| Origin | Scene / controller memory / readable answer |', '|---|---|']
    for trace in result['traces']:
        path = ' → '.join(f"{c['scene']} / {c['memory']} / {c['answer']}" for c in trace['configurations'])
        lines.append(f"| {trace['origin']} | {path} |")
    lines += ['', f"The prepared experiment finishes within **{result['horizon_including_boot']}** joint steps, including boot.",
              f"Its finite history completion has **{result['whole_states']}** whole states in cycles of length **{result['cycle_length']}**.",
              'Different origins remain in different whole histories even when scene and controller merge.',
              'The next transition after the demonstrated window restores the prepared configuration.',
              'Consequently the output is available in a finite window, not as a newly acquired permanent absorbing state.',
              'History recovery is an abstract whole-system transition. It is not a new action supplied to the agent.',
              'The construction assumes a prepared controller and enough history capacity. It establishes no physical cost or locality bound.', '']
    return '\n'.join(lines)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('model', type=Path)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    result = report(json.loads(args.model.read_text()))
    args.output.with_suffix('.json').write_text(json.dumps(result, indent=2) + '\n')
    args.output.with_suffix('.md').write_text(markdown(result))
    print(f"controller: {len(result['program']['states'])} memory states, {result['whole_states']} whole states")


if __name__ == '__main__':
    main()
