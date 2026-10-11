#!/usr/bin/env python3
"""Bounded IBM-oriented lowering of the existing goal certificate.

This module never submits a job. A local syntax audit is not a hardware
acceptance or accuracy guarantee. The source and saturation certificate remain
those of resident_goal_compiler; only their execution representation changes.
"""
from collections import Counter

from qiskit import QuantumCircuit, ClassicalRegister
from qiskit.circuit.classical import expr
from qiskit.circuit.library import UnitaryGate
from qiskit_aer.library import save_density_matrix

import resident_goal_compiler as goal
import whole_word_admission as admission


def predicate(state, old, reply, bit):
    return expr.logic_and(expr.equal(state, old), expr.equal(reply, bool(bit)))


def affine(values, width):
    """Find an affine Boolean expression, then verify EVERY source table row."""
    if len(values) != 2**width or any(type(x) is not int or x not in (0, 1) for x in values):
        raise ValueError('Complete Boolean table required')
    constant = values[0]
    terms = [i for i in range(width) if values[1 << i] ^ constant]
    for word, expected in enumerate(values):
        actual = constant
        for bit in terms:
            actual ^= (word >> bit) & 1
        if actual != expected:
            raise ValueError('The source function is not affine')
    return {'constant': constant, 'terms': terms, 'rows_verified': len(values)}


def affine_control(source, plan):
    ctl = goal.interpret(source, plan); width = ctl['width']
    if ctl['size'] != 2**width:
        raise ValueError('Affine adapter requires a complete binary class encoding')
    zero, one = [x['gate'] for x in source['raw']['interpreter']['controls']]
    table = []
    for word in range(2**(width+1)):
        state, reply = word & ((1 << width)-1), word >> width
        gate = ctl['emit'][state][reply]
        if gate not in (zero, one) or zero == one:
            raise ValueError('Quantum output is not a distinguished binary choice')
        table.append((int(gate == one), ctl['next']['reply'+str(reply)][state]))
    return {'input_order': ['state_bit_'+str(i) for i in range(width)]+['reply'],
        'gate': affine([x[0] for x in table], width+1),
        'next': [affine([(x[1] >> i)&1 for x in table], width+1) for i in range(width)],
        'recipient': affine([int(x[1]) for x in ctl['observation']], width)}


def expression(form, variables):
    result = expr.lift(bool(form['constant']))
    for bit in form['terms']:
        result = expr.bit_xor(result, variables[bit])
    return result


def compile(source, plan, service, contacts, *, snapshot=False, export=True, strategy='cases'):
    ctl = goal.interpret(source, plan)
    if strategy not in ('cases', 'affine'):
        raise ValueError('Unknown lowering strategy')
    formulas = affine_control(source, plan) if strategy == 'affine' else None
    if type(contacts) is not int or not 1 <= contacts <= 64:
        raise ValueError('Contact budget must be 1 through 64')
    if not isinstance(service, UnitaryGate) or service.num_qubits != 3:
        raise ValueError('Opaque local service dilation required')
    service = service.copy(); service.label = 'unmodelled_service'
    width = ctl['width']
    q = QuantumCircuit(5)
    state = ClassicalRegister(width, 'current')
    old = ClassicalRegister(width, 'previous')
    out = ClassicalRegister(3, 'out')
    q.add_register(state, old, out)
    returned = ClassicalRegister(width, 'acquired_class') if export else None
    if returned is not None:
        q.add_register(returned)
    B, M, E, D, REF = range(5)
    q.h(D); q.cx(D, REF); q.h(E); q.cx(E, M)

    def acquire():
        q.reset(B); q.append(service, [B, M, E]); q.measure(B, out[0])

    def gate(label):
        getattr(q, {'JointHLabel': 'h', 'JointSLabel': 's'}[label])(D)

    acquire()
    with q.if_test((out[0], 1)) as otherwise:
        gate(source['raw']['interpreter']['controls'][1]['gate'])
        q.store(state, ctl['initial'][1])
    with otherwise:
        gate(source['raw']['interpreter']['controls'][0]['gate'])
        q.store(state, ctl['initial'][0])
    q.z(E); q.cz(D, E)
    for _ in range(contacts - 1):
        acquire()
        # The selector is sampled ONCE before any branch writes `current`.
        # Every later flat condition reads that same selector and actual reply.
        q.store(old, state)
        if formulas is None:
            for cls in range(ctl['size']):
                for bit in (0, 1):
                    with q.if_test(predicate(old, cls, out[0], bit)):
                        gate(ctl['emit'][cls][bit])
                        q.store(state, ctl['next']['reply' + str(bit)][cls])
        else:
            variables = list(old)+[out[0]]
            with q.if_test(expression(formulas['gate'], variables)) as otherwise:
                gate(source['raw']['interpreter']['controls'][1]['gate'])
            with otherwise:
                gate(source['raw']['interpreter']['controls'][0]['gate'])
            for bit, form in enumerate(formulas['next']):
                q.store(state[bit], expression(form, variables))
        q.z(E); q.cz(D, E)

    if source['recipient'] != ['QI', 'QZ']:
        raise ValueError('Unsupported source recipient')
    if formulas is None:
        for cls, observation in enumerate(ctl['observation']):
            if observation[1]:
                with q.if_test((state, cls)):
                    q.z(D)
    else:
        recipient = formulas['recipient']
        if recipient['constant'] or recipient['terms']:
            with q.if_test(expression(recipient, list(state))):
                q.z(D)

    if returned is not None:
        # Store-only registers are live execution state, not IBM result data.
        # Produce new measurement records using a discarded probe, without
        # measuring or reinitializing the retained D,E,M or its reference.
        for bit in range(width):
            q.reset(B)
            with q.if_test((state[bit], 1)):
                q.x(B)
            q.measure(B, returned[bit])
    if snapshot:
        save_density_matrix(q, [M, E, D, REF], label='continued', pershot=True)
    q.cx(D, REF); q.h(D); q.measure(D, out[1]); q.measure(REF, out[2])
    q.metadata = {
        'source': admission.fingerprint(source), 'plan': admission.fingerprint(plan),
        'contacts': contacts, 'controller_bits': width, 'snapshot_bits': width,
        'export_bits': width if export else 0,
        'export_register': 'acquired_class' if export else None,
        'retained_quantum_ports': [D, E, M], 'goal': plan['goal'],
        'strategy': strategy, 'affine_formulas': formulas,
        'new_QPU_jobs': 0, 'hardware_acceptance_established': False,
    }
    return q


def check_flat_fragment(q, *, allow_snapshot=False, allow_unitary=True):
    """Reject the specific unavailable structures this adapter can introduce.

    This is intentionally NOT a replacement Qiskit/IBM validator. Its successful
    result only establishes membership in the advertised bounded fragment.
    """
    counts = Counter()
    allowed = {'reset', 'measure', 'measure_2', 'store', 'if_else', 'h', 's',
               'x', 'sx', 'z', 'rz', 'rx', 'ry', 'cx', 'cz', 'ecr', 'id', 'barrier'}
    if allow_snapshot:
        allowed.add('save_density_matrix')
    if allow_unitary:
        allowed.add('unitary')

    def expression(node):
        if isinstance(node, (expr.Var, expr.Value)):
            return
        if isinstance(node, expr.Binary) and node.op.name in {'EQUAL', 'LOGIC_AND', 'BIT_XOR'}:
            expression(node.left); expression(node.right); return
        raise ValueError('Expression outside the flat adapter fragment')

    def visit(circuit, inside=False):
        for item in circuit.data:
            op = item.operation; name = op.name; counts[name] += 1
            if name not in allowed:
                raise ValueError('Unsupported adapter instruction: ' + name)
            if name == 'if_else':
                if inside:
                    raise ValueError('Nested conditionals are not admitted')
                condition = op.condition
                if isinstance(condition, tuple):
                    owner, _ = condition
                    if isinstance(owner, ClassicalRegister) and len(owner) > 32:
                        raise ValueError('Conditional operand exceeds 32 bits')
                else:
                    expression(condition)
                    for v in expr.iter_vars(condition):
                        if isinstance(v.var, ClassicalRegister) and len(v.var) > 32:
                            raise ValueError('Conditional operand exceeds 32 bits')
                for block in op.blocks:
                    visit(block, True)
            elif inside and name in {'reset', 'measure', 'measure_2'}:
                raise ValueError('Conditional reset or measurement is not admitted')
            elif name == 'store':
                expression(op.lvalue); expression(op.rvalue)
    visit(q)
    return {'instructions': dict(sorted(counts.items())), 'qubits': q.num_qubits,
            'classical_bits': q.num_clbits, 'scope': 'Local bounded syntax only',
            'hardware_acceptance_established': False}
