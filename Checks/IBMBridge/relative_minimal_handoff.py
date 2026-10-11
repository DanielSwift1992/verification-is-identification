#!/usr/bin/env python3
"""Whole-instrument reduction, keeping the actual acquired record and payload.

P,A,B,D,R,C at their original input ports. C is unused and preserved. For the
old C=1 precondition this has the same recipient instrument as the heavy
handoff, with an explicit different final port map. No physical noise inverse
is assumed: only the declared ideal gate contract is simplified.
"""
import json
from math import pi
import numpy as np
from qiskit import QuantumCircuit, ClassicalRegister, transpile
import relative_acquisition as relative
from pilot import require


def core(use_record=True):
    q = QuantumCircuit(6); answer = ClassicalRegister(1, 'actual_a'); q.add_register(answer)
    gate = QuantumCircuit(6); gate.cx(1, 0)
    q.compose(transpile(gate, basis_gates=['rz', 'sx', 'x', 'id', 'cz'], optimization_level=0), inplace=True)
    mcm = next(i.operation for i in relative.core()[0].data if i.operation.name == 'measure_2')
    q.append(mcm, [0], [answer[0]])
    with q.if_test((answer[0], 1)): q.x(0)
    q.barrier(label='actual_relative_record')
    q.reset(1)
    q.barrier(label='source_retired')
    if use_record:
        with q.if_test((answer[0], 1)): q.rz(pi, 3)
    q.barrier(label='record_driven_recipient_exit')
    return q, list(range(6))


def rows(q, final):
    require(q.num_clbits == 1, 'Unexpected record interface')
    padded = q.copy(); padded.add_register(ClassicalRegister(2, 'interpreter_unused_pad'))
    for k, bits in relative.old.native_rows(padded, final):
        require(bits[1:] == [0, 0], 'The proof pad became an acquired record')
        yield k, bits[0]


def certificate(use_record=True):
    q, final = core(use_record)
    total = np.zeros((32, 32), complex); worst = 0.; seen = set()
    for actual, a in rows(q, final):
        require(a not in seen, 'Repeated minimal branch'); seen.add(a)
        reset = np.zeros((2, 2), complex); reset[0, a] = 1
        target = relative.old.expand(reset, [0], 5)
        if use_record and a: target = relative.old.expand(np.diag([1, -1]), [2], 5) @ target
        phase = np.vdot(target, actual) / np.vdot(target, target)
        worst = max(worst, float(np.max(abs(actual-phase*target))), float(abs(abs(phase)-1)))
        total += actual.conj().T @ actual
    require(seen == {0, 1} and worst < 1e-12 and np.max(abs(total-np.eye(32))) < 1e-12, 'Wrong minimal handoff')
    return {'input_dimension_ABDRC': 32, 'branches': 2, 'operator_residual': worst,
            'P_and_A_returned_zero': True, 'B_and_C_untouched_by_target_instrument': True,
            'uses_actual_record': use_record, 'recipient': 'Z^a on same D' if use_record else 'identity on same D',
            'comparison_to_heavy': 'Same full ABDR instrument on its C=1 domain, with declared final wire maps.',
            'scope': 'A measured then retired. Ideal known-gate whole-program reduction, not inversion of unknown physical noise.'}


if __name__ == '__main__': print(json.dumps({str(v): certificate(v) for v in (True, False)}, indent=2))
