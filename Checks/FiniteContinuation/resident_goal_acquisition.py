#!/usr/bin/env python3
"""Acquire a stronger current controller through its next actual contact."""
import argparse
from functools import lru_cache
import json
from pathlib import Path
import subprocess

from qiskit import QuantumCircuit, ClassicalRegister
from qiskit.circuit.library import UnitaryGate
from qiskit_aer.library import save_density_matrix

import resident_goal_compiler as goal
import resident_flat_controller as flat
import whole_word_admission as admission
from environment import write, digest
from build_from_source import ROOT, HERE, run


@lru_cache(maxsize=2)
def current_source(key):
    return json.loads(run(['node', HERE/'resident_goal_acquisition_court.js', 'read']))


def validate(source):
    key = tuple((p, digest(ROOT/p)) for p in sorted(source['source_sha256']))
    if dict(key) != source['source_sha256']:
        raise ValueError('Goal acquisition source changed')
    key += tuple((str(p), digest(p)) for p in [HERE/'resident_goal_acquisition_court.js',
                HERE/'resident_goal_court.js', HERE/'court_bridge.js'])
    if current_source(key) != source:
        raise ValueError('Not the current acquisition reading')
    goal.validate(source['goal'])


def contact_transport(source, old, new):
    validate(source); src = source['goal']
    before, after = goal.interpret(src, old), goal.interpret(src, new)
    old_classes, new_classes = old['certificate']['classes'], new['certificate']['classes']
    maps = []
    for bit in (0, 1):
        values = {}; owners = {}
        for i, cls in enumerate(old_classes):
            post = src['operations']['reply'+str(bit)][i]; value = new_classes[post]
            if cls in values and values[cls] != value:
                return {'available': False, 'reply': bit, 'old_class': cls,
                        'states': [src['states'][owners[cls]], src['states'][i]],
                        'post_classes': [values[cls], value]}
            values[cls] = value; owners[cls] = i
        maps.append([values[i] for i in range(before['size'])])
    return {'available': True, 'map_by_actual_reply': maps,
            'quantum_emissions': before['emit'], 'old_width': before['width'],
            'new_width': after['width'], 'scope': 'New class AFTER the source contact; no old state reconstruction.'}


def first_to_agreement(source, plans):
    if any(plans[name]['goal'] != name for name in ('first', 'agreement')):
        raise ValueError('The handoff substituted its source or destination question')
    relation = contact_transport(source, plans['first'], plans['agreement'])
    if not relation['available']:
        raise ValueError('The current source does not support this acquisition')
    ctl = goal.interpret(source['goal'], plans['first'])
    labels = plans['agreement']['certificate']['classes']
    # Cross-check the generic finite factorization against the constructor
    # whose input exposes ONLY Relative and First in the Swift source.
    for bit in (0, 1):
        for old, (r, first) in enumerate(ctl['observation']):
            post = source['after_first']['reply'+str(bit)][2*r+first]
            if relation['map_by_actual_reply'][bit][old] != labels[post]:
                raise ValueError('The source constructor and contact factorization disagree')
    values = [relation['map_by_actual_reply'][word >> ctl['width']][word & ((1 << ctl['width'])-1)]
              for word in range(2**(ctl['width']+1))]
    return {'relation': relation, 'next': [flat.affine([(v >> i)&1 for v in values], ctl['width']+1)
                                          for i in range(relation['new_width'])]}


def compile(source, plans, service, before_contacts, after_contacts, *, snapshot=True):
    validate(source); src = source['goal']
    if src['recipient'] != ['QI', 'QZ']:
        raise ValueError('Unsupported recipient action correspondence')
    if any(type(n) is not int or n < 1 for n in [before_contacts, after_contacts]) or before_contacts+after_contacts > 64:
        raise ValueError('Two nonempty stages with at most 64 actual contacts required')
    if not isinstance(service, UnitaryGate) or service.num_qubits != 3:
        raise ValueError('Opaque local service dilation required')
    bridge = first_to_agreement(source, plans)
    controllers = {name: goal.interpret(src, plans[name]) for name in ('first', 'agreement')}
    formulas = {name: flat.affine_control(src, plans[name]) for name in controllers}
    if [controllers[n]['width'] for n in ('first', 'agreement')] != [2, 3]:
        raise ValueError('This bounded slot layout requires the current 2/3-bit controllers')
    q = QuantumCircuit(5)
    state = ClassicalRegister(3, 'current'); old = ClassicalRegister(3, 'previous')
    out = ClassicalRegister(3, 'out'); returned = ClassicalRegister(3, 'acquired_class')
    q.add_register(state, old, out, returned)
    B, M, E, D, REF = range(5)
    q.h(D); q.cx(D, REF); q.h(E); q.cx(E, M)
    service = service.copy(); service.label = 'unmodelled_service'

    def acquire():
        q.reset(B); q.append(service, [B, M, E]); q.measure(B, out[0])

    def gate(bit):
        label = src['raw']['interpreter']['controls'][bit]['gate']
        getattr(q, {'JointHLabel': 'h', 'JointSLabel': 's'}[label])(D)

    def tick():
        q.z(E); q.cz(D, E); q.store(old, 0)

    def step(name, next_forms=None):
        acquire(); q.store(old, state)
        ctl, forms = controllers[name], formulas[name]
        variables = list(old)[:ctl['width']]+[out[0]]
        with q.if_test(flat.expression(forms['gate'], variables)) as otherwise:
            gate(1)
        with otherwise:
            gate(0)
        for bit, form in enumerate(forms['next'] if next_forms is None else next_forms):
            q.store(state[bit], flat.expression(form, variables))
        tick()

    def recipient(name):
        with q.if_test(flat.expression(formulas[name]['recipient'], list(state)[:controllers[name]['width']])):
            q.z(D)

    acquire()
    with q.if_test((out[0], 1)) as otherwise:
        gate(1); q.store(state, controllers['first']['initial'][1])
    with otherwise:
        gate(0); q.store(state, controllers['first']['initial'][0])
    tick()
    for _ in range(before_contacts-1):
        step('first')
    recipient('first')
    # Close the old interface: the probe and raw-reply scratch must not be
    # an undeclared archive of Last when assessing what First still knows.
    q.reset(B); q.store(out[0], False)
    if snapshot:
        save_density_matrix(q, [B, M, E, D, REF], label='before_handoff', pershot=True)
    # A genuine service contact supplies b and changes the quantum payload.
    # The new state is built from only the old two active bits and this b.
    step('first', bridge['next'])
    for _ in range(after_contacts-1):
        step('agreement')
    recipient('agreement')
    for bit in range(3):
        q.reset(B)
        with q.if_test((state[bit], 1)):
            q.x(B)
        q.measure(B, returned[bit])
    if snapshot:
        save_density_matrix(q, [M, E, D, REF], label='continued', pershot=True)
    q.cx(D, REF); q.h(D); q.measure(D, out[1]); q.measure(REF, out[2])
    q.metadata = {'source': admission.fingerprint(source),
        'plans': admission.fingerprint(plans), 'before_contacts': before_contacts,
        'after_contacts': after_contacts, 'same_retained_quantum_ports': [D, E, M],
        'active_controller_bits': [2, 3], 'allocated_controller_bits': 3,
        'recipient_sequence': ['first', 'agreement'], 'new_QPU_jobs': 0,
        'old_last_reconstructed': False, 'old_raw_reply_and_probe_cleared_at_boundary': True}
    flat.check_flat_fragment(q, allow_snapshot=snapshot)
    return q


def build(directory):
    directory.mkdir(parents=True, exist_ok=True)
    result = json.loads(run(['node', HERE/'resident_goal_acquisition_court.js', 'build', directory]))
    native = ROOT/'.build/arm64-apple-macosx/debug/Tools'
    text = run([native, 'judge', 'where', directory/'ResidentGoalAcquisition.swift'])
    assert f"{result['equalities']} equalities" in text and 'THE WHERE holds' in text
    for entry in result['negatives']:
        p = subprocess.run([str(native), 'judge', 'where', str(directory/entry['file'])],
                           capture_output=True, text=True, timeout=30)
        assert p.returncode == 1 and 'requires the types' in p.stdout+p.stderr
    result['native'] = text.strip(); write(directory/'build.json', result)
    return result


if __name__ == '__main__':
    p = argparse.ArgumentParser(description=__doc__); p.add_argument('--output', type=Path, required=True)
    print(json.dumps(build(p.parse_args().output.resolve())))
