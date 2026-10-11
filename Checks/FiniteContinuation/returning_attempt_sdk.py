#!/usr/bin/env python3
"""Store-free lowering of the checked returning-attempt acquisition.

The builder never accepts a true law row. A,B are retained device ports; only
actual probe measurements select repairs and working corrections. This is a
finite circuit construction, not a persistent cloud-state handle.
"""
from dataclasses import dataclass
from copy import deepcopy

from qiskit import QuantumCircuit, ClassicalRegister
from qiskit.circuit import Gate
from qiskit.quantum_info import Operator

import returning_attempt_learning as learning


def schedule(source, certificate):
    """Read a common two-probe schedule and its answer from a verified tree."""
    learning.verify(source, certificate)
    root = certificate['tree']
    learning.require(root['kind'] == 'probe' and root['probe'] == 'B' and
                     set(root['branches']) == {'0', '1'}, 'Unsupported first contact')
    table = {}
    for b in (0, 1):
        child = root['branches'][str(b)]
        learning.require(child['kind'] == 'probe' and child['probe'] == 'Parity' and
                         set(child['branches']) == {'0', '1'}, 'No shared second contact')
        for p in (0, 1):
            leaf = child['branches'][str(p)]
            learning.require(leaf['kind'] == 'act', 'Acquisition has not finished')
            table[b, p] = leaf['control']
    # These two flat conditions are a compiled reading, not assumed semantics.
    learning.require(all(table[b, p] == b ^ p for b, p in table), 'Not the XOR reading')
    return table


@dataclass(frozen=True)
class Ports:
    probe: int = 0
    law_a: int = 1
    law_b: int = 2
    data: int = 3
    later_data: int = 4

    def validate(self, q):
        wires = tuple(vars(self).values())
        learning.require(len(set(wires)) == 5 and all(type(i) is int and 0 <= i < q.num_qubits
                                                     for i in wires), 'Aliased or absent live ports')


class ReturningAssembly:
    """One ready circuit with arbitrary data on two distinct input ports.

    Probe must enter in zero; A,B are fixed classical device parameters. Data
    and later_data may be arbitrarily correlated with each other/reference and
    with the classical law. No preparation or measurement of those inputs.
    Resource reserve is a construction budget, not a hardware reset guarantee.
    """
    def __init__(self, source, *, ports=Ports(), reserve=2):
        learning.require(source == learning.read_source(), 'Source is not the current court reading')
        self.source = deepcopy(source)
        self.ports = ports
        self.q = QuantumCircuit(5)
        ports.validate(self.q)
        learning.require(type(reserve) is int and reserve >= 0, 'Bad return reserve')
        self.reserve = reserve
        self.records = None
        self.trace = []

    def acquire(self, certificate):
        learning.require(self.records is None and self.reserve >= 2, 'No fresh acquisition reserve')
        table = schedule(self.source, certificate)
        records = ClassicalRegister(2, 'actual_replies')
        self.q.add_register(records)
        p = self.ports
        for slot, name in enumerate(('B', 'Parity')):
            if name == 'Parity':
                self.q.cx(p.law_a, p.probe)
            self.q.cx(p.law_b, p.probe)
            self.q.cz(p.probe, p.data)
            self.q.measure(p.probe, records[slot])
            with self.q.if_test((records[slot], 1)):
                self.q.z(p.data)
            self.q.reset(p.probe)
            self.q.barrier(label='returned_' + name)
            self.reserve -= 1
            self.trace.append({'kind': 'returned_probe', 'name': name, 'record': slot})
        self.records = records
        return {'reading': [{'B': b, 'Parity': p, 'Control': answer}
                            for (b, p), answer in table.items()], 'remaining_reserve': self.reserve}

    def _service(self, gate, target):
        learning.require(target in (self.ports.data, self.ports.later_data) and
                         isinstance(gate, Gate) and gate.num_qubits == 1 and
                         gate.num_clbits == 0 and Operator(gate).is_unitary(),
                         'Wrong working input or gate')
        # Target and opaque law ports stay the same between calibration/work.
        self.q.append(gate, [target])
        self.q.cz(self.ports.law_a, target)
        self.trace.append({'kind': 'work', 'target': target, 'gate': gate.name})

    def apply(self, gate, *, later=False):
        learning.require(self.records is not None, 'No acquired working reading')
        target = self.ports.later_data if later else self.ports.data
        self._service(gate, target)
        for bit in self.records:
            with self.q.if_test((bit, 1)):
                self.q.z(target)
        self.q.barrier(label='worked_later' if later else 'worked_first')

    def echo(self, gate, *, later=False):
        from qiskit.circuit.library import IGate
        target = self.ports.later_data if later else self.ports.data
        self._service(gate, target)
        self._service(IGate(), target)
        self.q.barrier(label='echo_later' if later else 'echo_first')

    def program(self):
        q = self.q.copy()
        q.metadata = {'schema': 'vi.returning-attempt-sdk.v1',
                      'source': learning.fingerprint(self.source),
                      'ports': vars(self.ports), 'remaining_reserve': self.reserve,
                      'trace': deepcopy(self.trace),
                      'scope': 'Classical fixed A,B; arbitrary joint data/reference; probe enters zero. '
                               'Construction boundary, not live cloud memory.'}
        return q
