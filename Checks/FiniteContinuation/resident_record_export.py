#!/usr/bin/env python3
"""A measured export of the acquired choice, from the current admitted body.

Runtime classical memory and returned measurement memory are different
interfaces. This adapter fixes the retained choice only; it is NOT an IBM
hardware lowering of the nested, noisy local checkpoint.
"""
from copy import deepcopy

from qiskit.circuit import Clbit, ClassicalRegister
from qiskit.circuit.classical import expr

import resident_joint_cost as joint

ordered = joint.cost.policy.repeated.work.ordered_bindings


def events(circuit):
    """Read actual local-to-parent addresses, including Store-only ports."""
    result = []

    def visit(block, qmap, cmap, depth, path):
        for i, item in enumerate(block.data):
            op = item.operation
            qs = [qmap[block.find_bit(q).index] for q in item.qubits]
            cs = [cmap[block.find_bit(c).index] for c in item.clbits]
            at = path + [i]
            row = {'path': at, 'name': op.name, 'qubits': qs,
                   'clbits': cs, 'depth': depth, 'label': op.label}
            if op.name == 'store':
                writes = []
                for var in expr.iter_vars(op.lvalue):
                    bits = ([var.var] if isinstance(var.var, Clbit) else
                            list(var.var) if isinstance(var.var, ClassicalRegister) else None)
                    if bits is None:
                        raise ValueError('Unmapped Store target')
                    writes.extend(cmap[block.find_bit(c).index] for c in bits)
                row['writes'] = writes
            result.append(row)
            for branch, body in enumerate(getattr(op, 'blocks', ())):
                visit(body, qs, cs, depth + 1, at + [branch])

    visit(circuit, list(range(circuit.num_qubits)), list(range(circuit.num_clbits)), 0, [])
    return result


def export_schema(circuit):
    """Require the choice to be acquired exactly once, before any branch.

    Only its initial Store(false) may write this bit besides that measurement.
    The complete producer is separately checked by reconstruction below.
    """
    choice = circuit.metadata['choice_bit']
    rows = events(circuit)
    reads = [r for r in rows if r['name'] == 'measure' and choice in r['clbits']]
    if len(reads) != 1 or reads[0]['depth'] != 0:
        raise ValueError('The retained choice needs one unconditional measurement')
    read = reads[0]
    if read['label'] != circuit.metadata['first_actual_reply_label']:
        raise ValueError('The export is not the requested acquired occurrence')
    for r in rows:
        if r['name'] == 'store' and choice in r['writes']:
            if r['path'] != [0]:
                raise ValueError('Store overwrites the retained measured choice')
            op = circuit.data[0].operation
            if not isinstance(op.rvalue, expr.Value) or op.rvalue.value != 0:
                raise ValueError('Unexpected choice initialization')
    register = [r for r in circuit.cregs if len(r) == 1 and circuit.find_bit(r[0]).index == choice]
    if len(register) != 1 or register[0].name != 'next_request':
        raise ValueError('The returned choice register changed')
    return {'register': 'next_request', 'register_bit': 0, 'circuit_bit': choice,
            'measurement_path': read['path'], 'physical_program_qubit': read['qubits'][0],
            'measurement_label': read['label'],
            'working_scratch_exported': False,
            'scope': 'Measurement-backed first choice only; no exported live quantum state.'}


def limitations(circuit):
    rows = events(circuit)
    return {
        'nested_conditionals': sum(r['name'] == 'if_else' and r['depth'] > 0 for r in rows),
        'conditional_measurements': sum(r['name'] == 'measure' and r['depth'] > 0 for r in rows),
        'conditional_resets': sum(r['name'] == 'reset' and r['depth'] > 0 for r in rows),
        'local_kraus_instructions': sum(r['name'] == 'kraus' for r in rows),
        'IBM_submission_ready': False,
        'scope': 'Inventory of known remaining obstacles, not a complete provider validator.'}


def lower_acquired_choice(original):
    """Replace an adjacent pair; caller must establish the input producer.

    M -> reply; choice := reply   becomes   M -> choice; reply := choice.
    At the pair boundary both classical values and every quantum branch
    coincide. No measurement is added and no physical operation is changed.
    """
    choice = original.clbits[original.metadata['choice_bit']]
    reply = original.cregs[2][0]
    end = original.metadata['first_instruction_end']
    matches = [i for i, item in enumerate(original.data[:end])
               if item.operation.name == 'measure' and
               item.operation.label == original.metadata['first_actual_reply_label']]
    if len(matches) != 1:
        raise ValueError('One actual first report is required')
    index = matches[0]
    measure, copy = original.data[index:index+2]
    if (measure.clbits != (reply,) or copy.operation.name != 'store' or
            copy.operation.lvalue != expr.lift(choice) or
            copy.operation.rvalue != expr.lift(reply)):
        raise ValueError('The expected adjacent measurement/copy link is missing')
    result = original.copy_empty_like()
    for i, item in enumerate(original.data):
        if i == index:
            result.append(item.operation, item.qubits, [choice])
        elif i == index + 1:
            result.store(reply, choice)
        else:
            result.append(item)
    result.metadata = deepcopy(original.metadata)
    result.metadata['record_export'] = export_schema(result)
    result.metadata['export_lowering'] = 'measure-choice-then-copy-working-reply.v1'
    result.metadata['hardware_limitations'] = limitations(result)
    return joint.stopped.check_control(result)


class MeasuredChoiceCheckpoint:
    """Apply the small lowering to a currently reconstructible VI producer."""
    def __init__(self, session):
        self.session = session

    def working_body(self, packet):
        original = self.session.working_body(packet)
        self.session.admit(packet, original)
        return lower_acquired_choice(original)

    def admit(self, packet, candidate):
        expected = self.working_body(packet)
        schema = export_schema(candidate)
        if (schema != expected.metadata['record_export'] or
                candidate.metadata != expected.metadata or
                [(r.name, len(r)) for r in candidate.cregs] != [(r.name, len(r)) for r in expected.cregs] or
                ordered(candidate) != ordered(expected) or candidate != expected):
            raise ValueError('The exported choice or its current producer changed')
        return candidate
