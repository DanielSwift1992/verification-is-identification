#!/usr/bin/env python3
"""Stop actual service contacts on the current source's acquired target.

Remaining SDK slots only reset/read disposable B. They do not call the
retained service, execute a source tick or report their zeros as new replies.
The completion flag is measured; budget exhaustion alone does not set it.
"""
import argparse
from functools import lru_cache
import json
from pathlib import Path
import subprocess

from qiskit import ClassicalRegister, QuantumCircuit
from qiskit.circuit.classical import expr
from qiskit.circuit.library import UnitaryGate
from qiskit_aer.library import save_density_matrix

import resident_contact_memory as contact
import resident_flat_controller as flat
import resident_goal_compiler as goal
import whole_word_admission as admission
from environment import write, digest


@lru_cache(maxsize=2)
def current(key):
    return json.loads(goal.run(['node', goal.HERE/'resident_completion_court.js', 'read']))


def validate(source):
    key = tuple((p, digest(goal.ROOT/p)) for p in sorted(source['source_sha256']))
    if dict(key) != source['source_sha256']:
        raise ValueError('Completion source changed')
    key += tuple((str(p), digest(p)) for p in [goal.HERE/'resident_completion_court.js',
        goal.HERE/'resident_goal_acquisition_court.js', goal.HERE/'court_bridge.js'])
    if current(key) != source:
        raise ValueError('Not the current completion reading')
    contact.acquisition.validate(source['acquisition'])


def model(source, *, reachable=True):
    validate(source); a = source['acquisition']; src = a['goal']; edge = contact.model(a)
    done = [flag == source['target'] for flag in source['flags']]
    for i, (r, first) in enumerate(src['observation']['first']):
        for b in (0, 1):
            after = src['operations']['reply'+str(b)][i]
            if source['after']['reply'+str(b)][2*r+first] != source['flags'][after]:
                raise ValueError('Completion reading lost its acquired occurrence')
    operations = {name: [i if done[i] else nxt[i] for i in range(len(done))]
                  for name, nxt in src['operations'].items()}
    included = set(src['initial']) if reachable else set(range(len(done)))
    while True:
        expanded = included | {nxt[i] for nxt in operations.values() for i in included}
        if expanded == included:
            break
        included = expanded
    indices = sorted(included); address = {s: i for i, s in enumerate(indices)}
    observations = [{'complete': done[i], 'contact': None if done[i] else edge['observation'][i]}
                    for i in indices]
    return {'name': 'First acquired target with absorbing completed boundary',
        'states': [src['states'][i] for i in indices], 'source_indices': indices,
        'observation': observations,
        'operations': {name: [address[nxt[i]] for i in indices] for name, nxt in operations.items()},
        'initial': [address[i] for i in src['initial']], 'source_sha256': admission.fingerprint(source),
        'scope': ('Reachable from the actual first acquisition' if reachable else 'All eight monitor states')+
                 '; completed states admit identity continuation. Reply1 on a completed state is only a totalized controller input, not an acquired service event.'}


def plan(source, *, reachable=True):
    m = model(source, reachable=reachable); certificate = goal.saturate.synthesize(m)
    goal.saturate.verify(m, certificate)
    return {'model': m, 'certificate': certificate, 'reachable': reachable}


def interpret(source, selection):
    if selection['model'] != model(source, reachable=selection['reachable']):
        raise ValueError('Completion plan changed its source, goal or starting domain')
    goal.saturate.verify(selection['model'], selection['certificate'])
    cert = selection['certificate']; quotient = cert['quotient']; observations = quotient['observation']
    completed = [i for i, row in enumerate(observations) if row['complete']]
    if len(completed) != 1:
        raise ValueError('One completed observation class required')
    return {'size': len(observations), 'width': max(1, (len(observations)-1).bit_length()),
        'completed': completed[0], 'observation': observations, 'next': quotient['operations'],
        'initial': [cert['classes'][i] for i in selection['model']['initial']]}


def active_expression(register, completed):
    return expr.bit_xor(expr.equal(register, completed), True)


def circuit(source, selection, service, budget, *, snapshot=False):
    ctl = interpret(source, selection); a = source['acquisition']; src = a['goal']
    if source['target'] != 1 or source['initial_flags'] != [0, 0]:
        raise ValueError('This adapter implements first different reply after initial acquisition')
    if type(budget) is not int or not 1 <= budget <= 64:
        raise ValueError('One through 64 potential service slots required')
    if not isinstance(service, UnitaryGate) or service.num_qubits != 3:
        raise ValueError('Three-wire local service dilation required')
    width = ctl['width']; q = QuantumCircuit(5)
    state = ClassicalRegister(width, 'current'); old = ClassicalRegister(width, 'previous')
    reply = ClassicalRegister(1, 'slot_probe'); completed = ClassicalRegister(1, 'completed')
    q.add_register(state, old, reply, completed)
    B, M, E, D, REF = range(5); service = service.copy(); service.label = 'unmodelled_service'
    q.h(D); q.cx(D, REF); q.h(E); q.cx(E, M)

    def gate(label):
        getattr(q, {'JointHLabel': 'h', 'JointSLabel': 's'}[label])(D)

    def cleanup():
        q.reset(B); q.store(reply[0], False); q.store(old, 0)

    # Source Install: First is acquired here, never supplied by the caller.
    q.reset(B); q.append(service, [B, M, E]); q.measure(B, reply[0])
    with q.if_test((reply[0], 1)) as otherwise:
        gate(src['raw']['interpreter']['controls'][1]['gate']); q.store(state, ctl['initial'][1])
    with otherwise:
        gate(src['raw']['interpreter']['controls'][0]['gate']); q.store(state, ctl['initial'][0])
    q.z(E); q.cz(D, E); cleanup()

    for _ in range(budget-1):
        q.store(old, state)
        with q.if_test(active_expression(old, ctl['completed'])):
            q.append(service, [B, M, E])
        # Measurements are unconditional in the flat execution fragment.
        # After completion this reads a clean probe, not the service.
        q.measure(B, reply[0])
        for previous, row in enumerate(ctl['observation']):
            if row['complete']:
                continue
            for b in (0, 1):
                with q.if_test(flat.predicate(old, previous, reply[0], b)):
                    action = row['contact'][b]
                    gate(action['gate']); q.z(E); q.cz(D, E)
                    if action['recipient'] == 'QZ':
                        q.z(D)
                    elif action['recipient'] != 'QI':
                        raise ValueError('Unsupported actual recipient')
                    q.store(state, ctl['next']['reply'+str(b)][previous])
        cleanup()
    q.reset(B)
    with q.if_test((state, ctl['completed'])):
        q.x(B)
    q.measure(B, completed[0]); q.reset(B)
    if snapshot:
        save_density_matrix(q, range(5), label='resident', pershot=True)
    q.metadata = {'source': admission.fingerprint(source), 'plan': admission.fingerprint(selection),
        'potential_service_slots': budget, 'stop': 'First acquired source comparison equal to Target',
        'completed_class': ctl['completed'], 'persistent_bits': width,
        'retained_quantum_ports': [D, E, M, REF], 'new_QPU_jobs': 0,
        'padding': 'Only disposable probe reset/read after completion; not new service replies.',
        'scope': 'In-circuit first-hit state. No guaranteed success, physical runtime saving or cross-job persistence.'}
    flat.check_flat_fragment(q, allow_snapshot=snapshot)
    return q


def build(output):
    output.mkdir(parents=True, exist_ok=True)
    result = json.loads(goal.run(['node', goal.HERE/'resident_completion_court.js', 'build', output]))
    native = goal.ROOT/'.build/arm64-apple-macosx/debug/Tools'
    text = goal.run([native, 'judge', 'where', output/'ResidentCompletion.swift'])
    assert f"{result['equalities']} equalities" in text and 'THE WHERE holds' in text
    for entry in result['negatives']:
        process = subprocess.run([str(native), 'judge', 'where', str(output/entry['file'])],
                                 capture_output=True, text=True, timeout=30)
        assert process.returncode == 1 and 'requires the types' in process.stdout+process.stderr
    source = json.loads((output/'completion-reading.json').read_text())
    plans = {name: plan(source, reachable=reachable) for name, reachable in [('reachable', True), ('full', False)]}
    write(output/'plans.json', plans); result['native'] = text.strip(); write(output/'build.json', result)
    return {'source_equalities': result['equalities'], 'plans': {k: interpret(source, p)['size'] for k, p in plans.items()}}


if __name__ == '__main__':
    p = argparse.ArgumentParser(description=__doc__); p.add_argument('--output', type=Path, required=True)
    print(json.dumps(build(p.parse_args().output.resolve())))
