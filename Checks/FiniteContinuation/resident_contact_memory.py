#!/usr/bin/env python3
"""Existing saturation for a recipient executed inside each actual contact.

The observation is the complete table of requested edge outputs. It does not
promise an answer about the previous contact at an arbitrary later time.
"""
import argparse
import json
from pathlib import Path

from qiskit import QuantumCircuit, ClassicalRegister
from qiskit.circuit.library import UnitaryGate
from qiskit_aer.library import save_density_matrix

import resident_goal_acquisition as acquisition
import resident_goal_compiler as goal
import resident_flat_controller as flat
import whole_word_admission as admission
from environment import write, digest


def model(source):
    acquisition.validate(source); src = source['goal']; observations = []
    if src['recipient'] != ['QI', 'QZ']:
        raise ValueError('Unsupported recipient correspondence')
    for i in range(len(src['states'])):
        r, first = src['observation']['first'][i]; row = []
        for bit in (0, 1):
            post = source['after_first']['reply'+str(bit)][2*r+first]
            if post != src['operations']['reply'+str(bit)][i]:
                raise ValueError('The actual contact and First constructor disagree')
            next_r, flag = src['observation']['agreement'][post]
            controls = [x for x in src['raw']['interpreter']['controls'] if x['next'] == next_r]
            if len(controls) != 1:
                raise ValueError('The source does not identify one prior quantum action')
            row.append({'gate': controls[0]['gate'], 'recipient': src['recipient'][flag]})
        observations.append(row)
    return {'name': 'Agreement recipient on each actual contact', 'states': src['states'],
        'observation': observations, 'operations': src['operations'],
        'source_sha256': admission.fingerprint(source),
        'scope': 'Edge quantum action and recipient; no old Agreement read between contacts.'}


def plan(source):
    m = model(source); certificate = goal.saturate.synthesize(m)
    goal.saturate.verify(m, certificate)
    return {'model': m, 'certificate': certificate}


def interpret(source, plan):
    if plan['model'] != model(source):
        raise ValueError('The plan changed its question, source or occurrence')
    goal.saturate.verify(plan['model'], plan['certificate'])
    cert = plan['certificate']; quotient = cert['quotient']; size = len(quotient['observation'])
    width = max(1, (size-1).bit_length())
    if size != 2**width:
        raise ValueError('This adapter needs a complete binary encoding')
    zero, one = [x['gate'] for x in source['goal']['raw']['interpreter']['controls']]
    gates = []; recipients = []; destinations = []
    for word in range(2**(width+1)):
        old, bit = word & (size-1), word >> width
        entry = quotient['observation'][old][bit]
        if entry['gate'] not in (zero, one) or zero == one:
            raise ValueError('Ambiguous quantum branch')
        gates.append(int(entry['gate'] == one)); recipients.append(source['goal']['recipient'].index(entry['recipient']))
        destinations.append(quotient['operations']['reply'+str(bit)][old])
    return {'size': size, 'width': width, 'rows': quotient['observation'],
        'gate': flat.affine(gates, width+1), 'recipient': flat.affine(recipients, width+1),
        'next': [flat.affine([(x >> bit)&1 for x in destinations], width+1) for bit in range(width)],
        'initial': [cert['classes'][i] for i in source['goal']['initial']]}


def finish(q, state, out, *, snapshot):
    B, M, E, D, REF = range(5); width = len(state)
    if snapshot:
        save_density_matrix(q, [B, M, E, D, REF], label='closed_boundary', pershot=True)
    returned = ClassicalRegister(width, 'acquired_class'); q.add_register(returned)
    for bit in range(width):
        q.reset(B)
        with q.if_test((state[bit], 1)):
            q.x(B)
        q.measure(B, returned[bit])
    if snapshot:
        save_density_matrix(q, [M, E, D, REF], label='continued', pershot=True)
    q.cx(D, REF); q.h(D); q.measure(D, out[1]); q.measure(REF, out[2])


def compile(source, plan, service, contacts, *, snapshot=True):
    ctl = interpret(source, plan); src = source['goal']; width = ctl['width']
    if type(contacts) is not int or not 1 <= contacts <= 64:
        raise ValueError('One through 64 actual contacts required')
    if not isinstance(service, UnitaryGate) or service.num_qubits != 3:
        raise ValueError('Opaque local service dilation required')
    q = QuantumCircuit(5); state = ClassicalRegister(width, 'current')
    old = ClassicalRegister(width, 'previous'); out = ClassicalRegister(3, 'out')
    q.add_register(state, old, out)
    B, M, E, D, REF = range(5)
    q.h(D); q.cx(D, REF); q.h(E); q.cx(E, M)
    service = service.copy(); service.label = 'unmodelled_service'

    def acquire():
        q.append(service, [B, M, E]); q.measure(B, out[0])

    def gate(bit):
        label = src['raw']['interpreter']['controls'][bit]['gate']
        getattr(q, {'JointHLabel': 'h', 'JointSLabel': 's'}[label])(D)

    def cleanup():
        # Between contacts, neither the probe nor a classical scratch bit
        # silently retains Last. Quantum D,E,M remain untouched by cleanup.
        q.reset(B); q.store(out[0], False); q.store(old, 0)

    q.reset(B)
    acquire()
    with q.if_test((out[0], 1)) as otherwise:
        gate(1); q.store(state, ctl['initial'][1])
    with otherwise:
        gate(0); q.store(state, ctl['initial'][0])
    q.z(E); q.cz(D, E)
    for bit, initial in enumerate(src['initial']):
        if src['observation']['agreement'][initial][1]:
            with q.if_test((out[0], bit)):
                q.z(D)
    cleanup()
    for _ in range(contacts-1):
        acquire(); q.store(old, state); variables = list(old)+[out[0]]
        with q.if_test(flat.expression(ctl['gate'], variables)) as otherwise:
            gate(1)
        with otherwise:
            gate(0)
        q.z(E); q.cz(D, E)
        with q.if_test(flat.expression(ctl['recipient'], variables)):
            q.z(D)
        for bit, form in enumerate(ctl['next']):
            q.store(state[bit], flat.expression(form, variables))
        cleanup()
    finish(q, state, out, snapshot=snapshot)
    q.metadata = {'source': admission.fingerprint(source), 'plan': admission.fingerprint(plan),
        'contacts': contacts, 'persistent_controller_bits': width, 'scratch_cleared_between_contacts': True,
        'recipient': 'Agreement after EVERY actual contact', 'retained_quantum_ports': [D, E, M],
        'old_Agreement_read_between_contacts': False, 'new_QPU_jobs': 0}
    flat.check_flat_fragment(q, allow_snapshot=snapshot)
    return q


def reference(source, agreement_plan, service, contacts, *, snapshot=True):
    """Existing full Agreement controller, with its recipient after every step.

    This transformation adds recipients and cleanup to existing compiled
    steps. It does not use the new edge-output minimizer or its formulas.
    """
    src = source['goal']
    base = flat.compile(src, agreement_plan, service, contacts, snapshot=False, export=False, strategy='affine')
    state, old, out = base.cregs; q = base.copy_empty_like()
    form = flat.affine_control(src, agreement_plan)['recipient']
    positions = [i for i, item in enumerate(base.data) if item.operation.name == 'cz']
    if len(positions) != contacts:
        raise ValueError('Existing contact boundary changed')
    completed = 0
    for item in base.data[:positions[-1]+1]:
        if completed and item.operation.name == 'reset' and item.qubits == (base.qubits[0],):
            continue  # the preceding cleanup already returned this probe to 0
        q.append(item)
        if item.operation.name == 'cz':
            with q.if_test(flat.expression(form, list(state))):
                q.z(3)
            q.reset(0); q.store(out[0], False); q.store(old, 0)
            completed += 1
    finish(q, state, out, snapshot=snapshot)
    q.metadata = {'source': admission.fingerprint(source), 'contacts': contacts,
                  'role': 'Full state-output reference with per-contact recipient', 'new_QPU_jobs': 0}
    flat.check_flat_fragment(q, allow_snapshot=snapshot)
    return q


def build(output):
    output.mkdir(parents=True, exist_ok=True)
    source = json.loads((goal.ROOT/'Research/Artifacts/resident-goal-acquisition-20260915/acquisition-reading.json').read_text())
    result = plan(source)
    write(output/'plan.json', result); write(output/'controller.json', interpret(source, result))
    return goal.saturate.verify(result['model'], result['certificate'])


if __name__ == '__main__':
    p = argparse.ArgumentParser(description=__doc__); p.add_argument('--output', type=Path, required=True)
    print(json.dumps(build(p.parse_args().output.resolve())))
