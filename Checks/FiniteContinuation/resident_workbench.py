#!/usr/bin/env python3
"""One local entry point for two already established resident contracts.

The source, minimizer and quantum controllers are reused. This is an adapter,
not a new VI judge. It never creates cloud jobs. The returned circuit leaves
D,E,M and the reference unmeasured, ready for an in-circuit continuation.
"""
import argparse
from collections import Counter
import json
from pathlib import Path

from qiskit import ClassicalRegister, qpy
from qiskit.circuit import QuantumCircuit
from qiskit_aer import AerSimulator

import resident_contact_memory as contact
import resident_goal_compiler as goal
import resident_flat_controller as flat
import whole_word_admission as admission
from environment import write, digest


def current_source():
    path = goal.ROOT/'Research/Artifacts/resident-goal-acquisition-20260915/acquisition-reading.json'
    source = json.loads(path.read_text())
    contact.acquisition.validate(source)
    return source


def request(contacts, late_comparison=False):
    result = {'contacts': contacts, 'late_comparison': late_comparison}
    validate_request(result)
    return result


def validate_request(value):
    if (set(value) != {'contacts', 'late_comparison'} or type(value['contacts']) is not int
            or not 1 <= value['contacts'] <= 64 or type(value['late_comparison']) is not bool):
        raise ValueError('Request needs 1..64 contacts and a Boolean late_comparison')


def demand(source, wanted):
    validate_request(wanted)
    edges = contact.model(source)
    rows = [{'contact': row} for row in edges['observation']]
    if wanted['late_comparison']:
        for row, observation in zip(rows, source['goal']['observation']['agreement']):
            row['at_closed_boundary'] = observation[1]
    return {**edges, 'name': 'Requested resident readings', 'observation': rows,
        'scope': 'All eight monitor states; recipient during every contact' +
                 ('; current Agreement readable at a closed boundary.' if wanted['late_comparison'] else '.')}


def factor(model, classes):
    """Check the demanded observation AND continued class on every fiber."""
    members = {}
    for i, label in enumerate(classes):
        if label in members:
            j = members[label]
            if model['observation'][i] != model['observation'][j]:
                return {'applicable': False, 'states': [model['states'][j], model['states'][i]],
                        'reason': 'Different required readings in one candidate class'}
            for operation, next_states in model['operations'].items():
                if classes[next_states[i]] != classes[next_states[j]]:
                    return {'applicable': False, 'states': [model['states'][j], model['states'][i]],
                            'reason': 'Next class is not determined', 'operation': operation}
        members[label] = i
    return {'applicable': True, 'readings': [model['observation'][members[c]] for c in sorted(members)]}


def select(source, wanted):
    model = demand(source, wanted)
    certificate = goal.saturate.synthesize(model)
    verification = goal.saturate.verify(model, certificate)
    plans = {'contact': contact.plan(source), 'state': goal.plan(source['goal'], 'agreement')}
    choices = {}
    for name, plan in plans.items():
        # Verify applicability from the demanded relation, not the name.
        if name == 'contact':
            contact.interpret(source, plan)
        else:
            goal.interpret(source['goal'], plan)
        classes = plan['certificate']['classes']
        choices[name] = {**factor(model, classes), 'classes': len(set(classes))}
    admitted = [name for name, value in choices.items() if value['applicable']]
    if not admitted:
        raise ValueError('No existing executor realizes this demand')
    chosen = min(admitted, key=lambda name: choices[name]['classes'])
    if choices[chosen]['classes'] != verification['final_classes']:
        raise ValueError('Existing executors do not attain the certified monitor minimum')
    return {'request': wanted, 'model': model, 'certificate': certificate, 'candidates': choices,
            'selected': chosen, 'plan': plans[chosen], 'source': admission.fingerprint(source),
            'minimum_scope': 'Classical reusable quotient on the full eight-state source monitor; fixed retained quantum carrier. Not a horizon-specific or physical memory lower bound.'}


def circuit(source, wanted, selection, service):
    if selection != select(source, wanted):
        raise ValueError('Selection does not apply to this current source and demand')
    if selection['selected'] == 'contact':
        base = contact.compile(source, selection['plan'], service, wanted['contacts'], snapshot=False)
    else:
        base = contact.reference(source, selection['plan'], service, wanted['contacts'], snapshot=False)
    # The older test harness ends with a destructive Bell test. The workbench
    # exports a continuation instead: validate and remove exactly that suffix.
    tail = base.data[-4:]
    expected = [('cx', [3, 4], []), ('h', [3], []),
                ('measure', [3], [base.find_bit(base.cregs[2][1]).index]),
                ('measure', [4], [base.find_bit(base.cregs[2][2]).index])]
    actual = [(i.operation.name, [base.find_bit(q).index for q in i.qubits],
               [base.find_bit(c).index for c in i.clbits]) for i in tail]
    if actual != expected:
        raise ValueError('The existing terminal test boundary changed')
    q = base.copy_empty_like()
    for item in base.data[:-4]:
        q.append(item)
    state = q.cregs[0]
    if wanted['late_comparison']:
        values = [int(x['at_closed_boundary']) for x in selection['candidates'][selection['selected']]['readings']]
        form = flat.affine(values, len(state))
        returned = ClassicalRegister(1, 'late_comparison'); q.add_register(returned)
        q.reset(0)
        with q.if_test(flat.expression(form, list(state))):
            q.x(0)
        q.measure(0, returned[0])
    q.reset(0)
    q.metadata = {'source': admission.fingerprint(source), 'selection': admission.fingerprint(selection),
        'request': wanted, 'retained_quantum_ports': [3, 2, 1, 4], 'probe_returned_to_zero': True,
        'boundary': 'After all requested recipients and classical exports; before any terminal data measurement.',
        'new_QPU_jobs': 0}
    flat.check_flat_fragment(q)
    return q


def ordered_bindings(q):
    # Qiskit's DAG equality alone may identify circuits whose unitary qargs
    # have been permuted. Our named resident ports are part of the contract.
    # Keep their order at every instruction and inside conditional bodies.
    return {'qubits': q.num_qubits, 'clbits': q.num_clbits,
        'instructions': [{'name': item.operation.name,
                          'qubits': [q.find_bit(bit).index for bit in item.qubits],
                          'clbits': [q.find_bit(bit).index for bit in item.clbits],
                          'blocks': [ordered_bindings(block) for block in getattr(item.operation, 'blocks', ())]}
                         for item in q.data]}


def admit(source, wanted, selection, service, actual):
    """Reconstruct the supported producer, then use Qiskit's structural check.

    This deliberately does not accept every semantically equivalent circuit,
    and does not establish physical execution fidelity. Qiskit remains in the
    trust boundary. Ordered ports, metadata and registers are checked separately.
    """
    expected = circuit(source, wanted, selection, service)
    if (not isinstance(actual, QuantumCircuit) or actual.metadata != expected.metadata or
            [(r.name, len(r)) for r in actual.cregs] != [(r.name, len(r)) for r in expected.cregs] or
            ordered_bindings(actual) != ordered_bindings(expected) or actual != expected):
        raise ValueError('Actual circuit is not the admitted current producer')
    return flat.check_flat_fragment(actual)


def readout(q):
    # Only measure-backed exports enter the external result decoder. Store
    # registers and cleared scratch are deliberately absent from this schema.
    registers = {}
    for reg in q.cregs:
        if reg.name in ('acquired_class', 'late_comparison'):
            registers[reg.name] = [q.find_bit(bit).index for bit in reg]
    return {'width': q.num_clbits, 'registers': registers, 'bit_order': 'little-endian integer positions'}


def decode(schema, record):
    bits = record.replace(' ', '')
    if len(bits) != schema['width'] or set(bits) - {'0', '1'}:
        raise ValueError('Result does not have the declared measured record width')
    word = int(bits, 2)
    return {name: sum(((word >> position) & 1) << i for i, position in enumerate(positions))
            for name, positions in schema['registers'].items()}


def describe(source, wanted, selection, q, path):
    return {'source': admission.fingerprint(source), 'selection': admission.fingerprint(selection),
            'QPY_sha256': digest(path), 'readout': readout(q),
            'contacts': wanted['contacts'], 'selected': selection['selected'],
            'persistent_bits': len(q.cregs[0]), 'classical_bits': q.num_clbits, 'qubits': q.num_qubits,
            'scope': 'Local prepared circuit, not a serialized surviving quantum state or a cloud job.'}


def prepare(output, source, wanted, service):
    # Refuse overwrite; a prepared occurrence must not silently change.
    output.mkdir(parents=True, exist_ok=False)
    selection = select(source, wanted); q = circuit(source, wanted, selection, service)
    path = output/'program.qpy'
    with path.open('wb') as stream:
        qpy.dump(q, stream)
    with path.open('rb') as stream:
        restored, = qpy.load(stream)
    admit(source, wanted, selection, service, restored)
    descriptor = describe(source, wanted, selection, restored, path)
    write(output/'request.json', wanted); write(output/'selection.json', selection)
    write(output/'descriptor.json', descriptor)
    return q, descriptor


def run_local(output, source, service, shots=256):
    if type(shots) is not int or not 1 <= shots <= 4096:
        raise ValueError('Local shots must be 1..4096')
    if (output/'local-result.json').exists():
        raise ValueError('This prepared local occurrence already has a result')
    wanted = json.loads((output/'request.json').read_text())
    selection = json.loads((output/'selection.json').read_text())
    descriptor = json.loads((output/'descriptor.json').read_text())
    if descriptor['QPY_sha256'] != digest(output/'program.qpy'):
        raise ValueError('Prepared program bytes changed')
    with (output/'program.qpy').open('rb') as stream:
        q, = qpy.load(stream)
    admit(source, wanted, selection, service, q)
    if descriptor != describe(source, wanted, selection, q, output/'program.qpy'):
        raise ValueError('Prepared decoder or source correspondence changed')
    result = AerSimulator(method='statevector', max_parallel_threads=1).run(
        q, shots=shots, memory=True, seed_simulator=73109).result()
    if not result.success:
        raise ValueError('Local execution failed')
    counts = Counter(json.dumps(decode(descriptor['readout'], record), sort_keys=True)
                     for record in result.get_memory())
    decoded = [{'reading': json.loads(reading), 'count': count} for reading, count in sorted(counts.items())]
    record = {'source': descriptor['source'], 'program_sha256': descriptor['QPY_sha256'],
              'shots': shots, 'measured_readings': decoded, 'new_QPU_jobs': 0,
              'scope': 'Sampled local ideal execution; D,E,M and reference have no terminal measurement in the prepared circuit. The simulator run has ended, so this file is not a resumable physical state.'}
    write(output/'local-result.json', record)
    return record


if __name__ == '__main__':
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--contacts', type=int, default=8); p.add_argument('--late-comparison', action='store_true')
    p.add_argument('--shots', type=int, default=256); p.add_argument('--output', type=Path, required=True)
    a = p.parse_args()
    # A named local fixture only; no credentials or service calls enter this CLI.
    from resident_contact_memory_checks import service_fixture
    service, _ = service_fixture(1.3, -.8, .71)
    source = current_source(); wanted = request(a.contacts, a.late_comparison)
    _, descriptor = prepare(a.output.resolve(), source, wanted, service)
    result = run_local(a.output.resolve(), source, service, a.shots)
    print(json.dumps({'selected': descriptor['selected'], 'persistent_bits': descriptor['persistent_bits'],
                      'shots': result['shots'], 'measured_readings': result['measured_readings']}))
