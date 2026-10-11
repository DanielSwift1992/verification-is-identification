#!/usr/bin/env python3
"""Finite obstruction: a sufficient answer can come from an insufficient process.

This file has no provider access. Operators use A as the low bit, B as the
high bit. The full classical record is included in the indistinguishability
check; discarding only an unwanted classical bit cannot undo its measurement.
"""
import json
import numpy as np


def certificate():
    eye = np.eye(2)
    z = [np.diag([1, 0]), np.diag([0, 1])]
    rho_a = z[1]
    plus = np.array([[1, 1], [1, 1]]) / 2
    minus = np.array([[1, -1], [-1, 1]]) / 2
    inputs = [np.kron(b, rho_a) for b in (plus, minus)]
    x_b = np.kron(np.array([[0, 1], [1, 0]]), eye)
    old_records = []
    new_outputs = []
    for rho in inputs:
        # Each old branch retains both answers (b, parity=a XOR b), as well
        # as the post-measurement quantum state. Thus this is stronger than
        # an obstruction based merely on equal classical distributions.
        branches = {}
        for a in (0, 1):
            for b in (0, 1):
                p = np.kron(z[b], z[a])
                branches[b, a ^ b] = p @ rho @ p
        old_records.append(branches)
        new_outputs.append(sum(np.kron(eye, p) @ rho @ np.kron(eye, p) for p in z))
    residual = max(float(np.max(abs(old_records[0][key] - old_records[1][key])))
                   for key in old_records[0])
    new_x = [float(np.trace(x_b @ rho).real) for rho in new_outputs]
    assert residual == 0 and new_x == [1, -1]
    assert all(abs(sum(np.trace(m).real for m in record.values()) - 1) < 1e-12
               for record in old_records)
    return {
        'full_old_classical_quantum_outputs_equal_residual': residual,
        'new_B_X_for_two_old_indistinguishable_inputs': new_x,
        'conclusion': 'No processing of the old full output can reproduce the new instrument on all inputs.',
        'premise': 'The receiver has only the measured instrument output, not coherent access to its dilation or discarded environment.',
        'scope': 'Exact finite channel obstruction; no hardware-noise attribution or novelty claim.'}


if __name__ == '__main__':
    print(json.dumps(certificate(), indent=2))
