#!/usr/bin/env python3
"""One measured task arrival chooses acquisition on the SAME live payload.

This is a finite circuit with a construction-time future promise. It does not
know the law, the arrival bit, or a total task count. No cloud state is stored.
The law gates specify coherent access explicitly; a classical truth table alone
would not establish their action on superpositions of A and B.
"""
from dataclasses import dataclass
from copy import deepcopy

from qiskit import QuantumCircuit, ClassicalRegister
from qiskit.circuit import Gate
from qiskit.circuit.classical import expr
from qiskit.circuit.library import IGate
from qiskit.quantum_info import Operator

import returning_attempt_learning as learning
from returning_attempt_sdk import schedule
from returning_attempt_online import acquisition_admission, verify_upper, upper_certificate


@dataclass(frozen=True)
class ArrivalPorts:
    probe: int = 0
    law_a: int = 1
    law_b: int = 2
    data: int = 3
    reference: int = 4
    arrival: int = 5

    def validate(self):
        learning.require(sorted(vars(self).values()) == list(range(6)) and
                         all(type(x) is int for x in vars(self).values()),
                         'Six distinct, existing input ports required')


class ArrivalAssembly:
    """P enters zero; AB D R C may be arbitrary, jointly with an external ref.

    Exactly three echo tasks precede a measured C request. If acquisition is
    admitted, C=1 enables the two returning probes and one-call fourth task.
    C=0 leaves AB coherent, despite the unconditional idle scratch measurements.
    A stronger future promise selects echo instead. R is never touched.
    """
    def __init__(self, source, certificate, future, *, ports=ArrivalPorts(), reserve=2):
        learning.require(source == learning.read_source(), 'Not the current source reading')
        learning.require(type(reserve) is int and reserve >= 0, 'Invalid return reserve')
        ports.validate()
        schedule(source, certificate)
        verify_upper(upper_certificate())
        self.admission = acquisition_admission(future)
        self.can_acquire = self.admission['admitted'] and reserve >= 2
        self.source = deepcopy(source)
        self.future = deepcopy(future)
        self.ports = ports
        self.q = QuantumCircuit(6)
        self.request = ClassicalRegister(1, 'actual_arrival')
        self.replies = ClassicalRegister(2, 'actual_replies')
        self.q.add_register(self.request, self.replies)
        self._prefix = 0
        self._arrival = False
        self._receiver = False
        self.reserve = reserve

    def _gate(self, gate):
        learning.require(isinstance(gate, Gate) and gate.num_qubits == 1 and
                         gate.num_clbits == 0 and Operator(gate).is_unitary(),
                         'A one-qubit unitary goal is required')

    def _service(self, gate):
        self.q.append(gate, [self.ports.data])
        self.q.cz(self.ports.law_a, self.ports.data)

    def _echo(self, gate):
        self._service(gate)
        self._service(IGate())

    def _guarded_correction(self, bit):
        # Idle-slot readout errors must not activate a data correction.
        with self.q.if_test(expr.logic_and(self.request[0], bit)):
            self.q.z(self.ports.data)

    def prefix(self, gate):
        self._gate(gate)
        learning.require(not self._arrival and self._prefix < 3, 'Wrong prefix boundary')
        self._echo(gate)
        self._prefix += 1
        self.q.barrier(label='echo_' + str(self._prefix))

    def observe_arrival(self, gate):
        """The input C, not a host Boolean, decides whether this goal is run."""
        self._gate(gate)
        learning.require(self._prefix == 3 and not self._arrival, 'Not at the fourth-task boundary')
        p = self.ports
        self.q.measure(p.arrival, self.request[0])
        self.q.barrier(label='arrival_read')
        if self.can_acquire:
            for slot, name in enumerate(('B', 'Parity')):
                # Flat conditions only. Measurement/reset remain outside if.
                with self.q.if_test((self.request[0], 1)):
                    if name == 'Parity':
                        self.q.cx(p.law_a, p.probe)
                    self.q.cx(p.law_b, p.probe)
                    self.q.cz(p.probe, p.data)
                self.q.measure(p.probe, self.replies[slot])
                self._guarded_correction(self.replies[slot])
                self.q.reset(p.probe)
                self.q.barrier(label='returned_' + name)
            with self.q.if_test((self.request[0], 1)):
                self._service(gate)
            for bit in self.replies:
                self._guarded_correction(bit)
        else:
            with self.q.if_test((self.request[0], 1)):
                self._echo(gate)
        self.q.barrier(label='conditional_exit')
        self._arrival = True

    def receive(self, gate):
        """Separate bounded recipient: use the acquired record, else use echo.

        This is not the all-horizon optimal policy after a missing task. A new
        guaranteed recipient is an additional contract, shown to compose safely.
        """
        self._gate(gate)
        learning.require(self._arrival and not self._receiver, 'Missing or already consumed exit')
        if self.can_acquire:
            with self.q.if_test((self.request[0], 1)):
                self._service(gate)
            for bit in self.replies:
                self._guarded_correction(bit)
            with self.q.if_test((self.request[0], 0)):
                self._echo(gate)
        else:
            self._echo(gate)
        self.q.barrier(label='recipient_exit')
        self._receiver = True

    def program(self):
        learning.require(self._arrival, 'No conditional exit constructed')
        q = self.q.copy()
        q.metadata = {
            'schema': 'vi.returning-attempt-arrival.v1',
            'source': learning.fingerprint(self.source), 'ports': vars(self.ports),
            'future': self.future, 'acquisition_admission': self.admission,
            'acquisition_enabled': self.can_acquire,
            'entry_return_reserve': self.reserve,
            'remaining_return_reserve_by_arrival': {
                '0': self.reserve, '1': self.reserve - 2 if self.can_acquire else self.reserve},
            'scratch_measurement_slots': 2 if self.can_acquire else 0,
            'recipient': self._receiver,
            'scope': 'Fixed finite coherent gate model; arbitrary retained input. C is measured. '
                     'The same D and reference survive; no incoming data preparation or reset. '
                     'Idle scratch measurements still cost hardware time. Not a cloud-session handle.'}
        return q
