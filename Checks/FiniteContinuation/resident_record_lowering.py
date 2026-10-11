#!/usr/bin/env python3
"""Eliminate Store from a closed, finite classical-control circuit.

Each measurement gets an immutable physical record. Mutable classical fields
become Boolean readings of those records, substituted into actual feedforward.
No quantum operator is evaluated or replaced. This is an alternative lowering,
not a claim that IBM accepts it or that retained records have been erased.
"""
from dataclasses import dataclass
from functools import lru_cache

from qiskit import QuantumCircuit, ClassicalRegister
from qiskit.circuit.classical import expr, types


def require(ok, message):
    if not ok:
        raise ValueError(message)


class BooleanReadings:
    """Reduced ordered Boolean decisions; 0/1 terminals, chronological variables."""
    def __init__(self, limit=16384):
        self.nodes = [None, None]
        self.unique = {}
        self.cache = {}
        self.limit = limit

    def node(self, variable, low, high):
        if low == high:
            return low
        key = (variable, low, high)
        if key not in self.unique:
            require(len(self.nodes) < self.limit, 'Boolean reading exceeds the declared build budget')
            self.unique[key] = len(self.nodes)
            self.nodes.append(key)
        return self.unique[key]

    def choose(self, condition, yes, no):
        if condition in (0, 1):
            return yes if condition else no
        if yes == no:
            return yes
        if (yes, no) == (1, 0):
            return condition
        key = (condition, yes, no)
        if key not in self.cache:
            variable = min(self.nodes[x][0] for x in key if x > 1)
            def at(x, bit):
                return self.nodes[x][1+bit] if x > 1 and self.nodes[x][0] == variable else x
            low = self.choose(*(at(x, 0) for x in key))
            high = self.choose(*(at(x, 1) for x in key))
            self.cache[key] = self.node(variable, low, high)
        return self.cache[key]

    def negate(self, x): return self.choose(x, 0, 1)
    def conjunction(self, x, y): return self.choose(x, y, 0)
    def xor(self, x, y): return self.choose(x, self.negate(y), y)

    def read(self, root, records):
        while root > 1:
            index, low, high = self.nodes[root]
            require(index < len(records) and records[index] in (0, 1), 'Missing actual measurement record')
            root = high if records[index] else low
        return root


@dataclass
class Lowering:
    circuit: QuantumCircuit
    readings: BooleanReadings
    outputs: tuple
    original_registers: dict
    stores_removed: int

    def decode(self, records):
        require(len(records) == self.circuit.num_clbits and all(x in (0, 1) for x in records),
                'Wrong immutable record domain')
        return [self.readings.read(root, records) for root in self.outputs]

    def register(self, name, records):
        bits = self.decode(records)
        return sum(bits[i] << k for k, i in enumerate(self.original_registers[name]))


def lower(circuit, *, max_records=64, max_operations=20000):
    """Closed zero-initialized classical state; finite if/else and a narrow AST.

    The original bit-to-reading relation holds after every processed prefix.
    At an if, its condition is captured before either arm updates a field.
    Quantum operations retain their order, ports, labels, and actual guards.
    Unknown classical/quantum instructions are refused, never silently omitted.
    """
    require(circuit.num_vars == 0 and circuit.num_stretches == 0,
            'External variables or stretches are outside this closed fragment')
    out = QuantumCircuit()
    for register in circuit.qregs:
        out.add_register(register)
    out.add_bits([bit for bit in circuit.qubits if bit not in out.qubits])
    require(out.qubits == circuit.qubits, 'Quantum address order changed')
    readings = BooleanReadings()
    record_bits = []
    removed = 0

    @lru_cache(maxsize=None)
    def expression(root):
        if root in (0, 1):
            return expr.lift(bool(root))
        index, low, high = readings.nodes[root]
        v = expr.lift(record_bits[index])
        if (low, high) == (0, 1): return v
        if (low, high) == (1, 0): return expr.bit_xor(v, True)
        if low == 0: return expr.logic_and(v, expression(high))
        if high == 0: return expr.logic_and(expr.bit_xor(v, True), expression(low))
        # Disjoint alternatives; XOR is their union. This uses the same small
        # expression fragment as the independent existing instrument readers.
        return expr.bit_xor(expr.logic_and(v, expression(high)),
                            expr.logic_and(expr.bit_xor(v, True), expression(low)))

    def addresses(variable, body, cbits):
        bits = list(variable) if isinstance(variable, ClassicalRegister) else [variable]
        return [cbits[body.find_bit(bit).index] for bit in bits]

    def value(node, env, body, cbits):
        if isinstance(node, expr.Value):
            width = 1 if isinstance(node.type, types.Bool) else node.type.width
            require(type(node.value) in (bool, int) and 0 <= node.value < 2**width,
                    'Unsupported classical literal')
            return tuple((int(node.value) >> i) & 1 for i in range(width))
        if isinstance(node, expr.Var):
            return tuple(env[i] for i in addresses(node.var, body, cbits))
        if isinstance(node, expr.Binary):
            left, right = value(node.left, env, body, cbits), value(node.right, env, body, cbits)
            require(len(left) == len(right), 'Mixed-width expression outside fragment')
            if node.op.name == 'BIT_XOR':
                return tuple(readings.xor(x, y) for x, y in zip(left, right))
            if node.op.name == 'EQUAL':
                answer = 1
                for x, y in zip(left, right):
                    answer = readings.conjunction(answer, readings.negate(readings.xor(x, y)))
                return (answer,)
            if node.op.name == 'LOGIC_AND' and len(left) == 1:
                return (readings.conjunction(left[0], right[0]),)
        raise ValueError('Classical expression outside the admitted fragment')

    def emit(op, qs, cs, guard):
        if guard == 0: return
        require(len(out.data) < max_operations, 'Lowered program exceeds the declared build budget')
        if guard == 1:
            out.append(op, qs, cs)
        else:
            with out.if_test(expression(guard)):
                out.append(op, qs, cs)

    def visit(body, env, wires, cbits, guard):
        nonlocal removed
        require(body.global_phase == 0, 'Block global phase is outside the admitted fragment')
        for item in body.data:
            op = item.operation
            qs = [wires[body.find_bit(bit).index] for bit in item.qubits]
            cs = [cbits[body.find_bit(bit).index] for bit in item.clbits]
            if op.name == 'if_else':
                if isinstance(op.condition, tuple):
                    variable, wanted = op.condition
                    fields = addresses(variable, body, cbits)
                    require(type(wanted) in (int, bool) and 0 <= wanted < 2**len(fields),
                            'Condition value overflows its field')
                    condition = 1
                    for k, index in enumerate(fields):
                        bit = env[index] if (wanted >> k) & 1 else readings.negate(env[index])
                        condition = readings.conjunction(condition, bit)
                else:
                    bits = value(op.condition, env, body, cbits)
                    require(len(bits) == 1, 'Condition is not Boolean')
                    condition, = bits
                arms = []
                for choice in (1, 0):
                    nested = env.copy()
                    k = 0 if choice else 1
                    if k < len(op.blocks):
                        visit(op.blocks[k], nested, qs, cs,
                              readings.conjunction(guard, condition if choice else readings.negate(condition)))
                    arms.append(nested)
                env[:] = [readings.choose(condition, yes, no) for yes, no in zip(*arms)]
            elif op.name == 'store':
                require(isinstance(op.lvalue, expr.Var), 'Store destination is not a direct field')
                fields = addresses(op.lvalue.var, body, cbits)
                bits = value(op.rvalue, env, body, cbits)
                require(len(fields) == len(bits), 'Store width changed')
                for index, root in zip(fields, bits): env[index] = root
                removed += 1
            elif op.name in ('measure', 'measure_2'):
                require(len(qs) == len(cs) == 1, 'Measurement is not a single actual record')
                if guard == 0: continue
                require(len(record_bits) < max_records, 'Immutable record budget exceeded')
                register = ClassicalRegister(1, 'record_'+str(len(record_bits)))
                out.add_register(register)
                variable = len(record_bits)
                record_bits.append(register[0])
                emit(op, qs, [register[0]], guard)
                env[cs[0]] = readings.node(variable, 0, 1)
            else:
                require(op.name in ('reset', 'h', 's', 'x', 'z', 'id', 'cx', 'cz', 'unitary', 'barrier')
                        and not cs, 'Instruction outside the admitted fragment: '+op.name)
                emit(op, qs, [], guard)

    env = [0]*circuit.num_clbits
    visit(circuit, env, list(range(circuit.num_qubits)), list(range(circuit.num_clbits)), 1)
    out.metadata = {'schema': 'vi.immutable-record-lowering.v1',
                    'classical_initial_state': 'zero', 'stores_removed': removed,
                    'source_classical_bits': circuit.num_clbits,
                    'scope': 'Ideal decoded instrument equivalence; backend admission and timing not established.'}
    return Lowering(out, readings, tuple(env),
                    {reg.name: [circuit.find_bit(b).index for b in reg] for reg in circuit.cregs}, removed)
