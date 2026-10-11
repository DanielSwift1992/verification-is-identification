#!/usr/bin/env python3
"""Exact CQ example: quotienting a loop preserves its exit instrument and tails.

This is a mathematical fixture, not the night's learning executor. The source
has four classical labels (phase, disposable tag) and arbitrary quantum data.
All identities are checked on a linear operator basis, using rational numbers.
No sampling, SDK, QPU, secret input to a working policy, or Swift claim here.
"""
from fractions import Fraction as F
import json

from resident_record_recovery import (
    matrix, identity, zero, scale, add, multiply, transpose, trace,
    total, positive,
)

I = identity(2)
X = matrix([[0, 1], [1, 0]])
Z = matrix([[1, 0], [0, -1]])


def conjugate(operator, value):
    return multiply(multiply(operator, value), transpose(operator))


def blocks(count):
    return tuple(zero(2, 2) for _ in range(count))


def basis(count):
    for label in range(count):
        for row in range(2):
            for col in range(2):
                value = list(blocks(count))
                value[label] = matrix([[int(i == row and j == col)
                                       for j in range(2)] for i in range(2)])
                yield tuple(value)


def block_trace(values):
    return sum(map(trace, values))


def quotient(values):
    """Forget tag, preserving the complete phase/data joint state."""
    return (add(values[0], values[1]), add(values[2], values[3]))


def failure(values):
    """One actual unsuccessful step; its trace is NOT renormalized.

    Phase 0 always fails into phase 1. Phase 1 fails with probability 1/2
    into phase 0. The tag toggles. Retained data is untouched in either case.
    """
    out = list(blocks(4))
    for state, value in enumerate(values):
        phase, tag = divmod(state, 2)
        destination = 2 * (1 - phase) + (1 - tag)
        out[destination] = add(out[destination], scale(value, F(1, 2) if phase else F(1)))
    return tuple(out)


def reduced_failure(values):
    return (scale(values[1], F(1, 2)), values[0])


def success(values):
    return scale(conjugate(X, add(values[2], values[3])), F(1, 2))


def reduced_success(values, recipient=X):
    return scale(conjugate(recipient, values[1]), F(1, 2))


def main():
    tested = 0
    for value in basis(4):
        assert quotient(failure(value)) == reduced_failure(quotient(value))
        assert success(value) == reduced_success(quotient(value))
        assert block_trace(quotient(value)) == block_trace(value)
        assert block_trace(failure(value)) + trace(success(value)) == block_trace(value)
        # A genuine all-input identity, stronger than checking observed tails.
        assert failure(failure(value)) == tuple(scale(v, F(1, 2)) for v in value)
        tested += 1

    # Representative tails are explanatory output, not the infinite proof.
    tails = {}
    for phase in (0, 1):
        state = list(blocks(4)); state[2 * phase] = scale(I, F(1, 2)); state = tuple(state)
        row = []
        for n in range(9):
            row.append(str(block_trace(state)))
            state = failure(state)
        tails[str(phase)] = row

    # Bellman equations for expected logical steps, independently verified.
    means = (F(4), F(3))
    assert means[0] == 1 + means[1]
    assert means[1] == 1 + F(1, 2) * means[0]

    # Same current completion reading (false), different future survival.
    phase0 = (scale(I, F(1, 2)), zero(2, 2), zero(2, 2), zero(2, 2))
    phase1 = (zero(2, 2), zero(2, 2), scale(I, F(1, 2)), zero(2, 2))
    assert total(phase0) == total(phase1)
    assert total(failure(phase0)) != total(failure(phase1))

    # A swapped successful recipient keeps all tail probabilities but changes
    # the quantum output. Exhibit the actual joint exit map difference.
    plus = matrix([[F(1, 2), F(1, 2)], [F(1, 2), F(1, 2)]])
    at_phase1 = (zero(2, 2), zero(2, 2), plus, zero(2, 2))
    right = success(at_phase1)
    wrong = reduced_success(quotient(at_phase1), Z)
    assert trace(right) == trace(wrong) == F(1, 2)
    assert right != wrong
    assert trace(multiply(plus, right)) == F(1, 2)
    assert trace(multiply(plus, wrong)) == 0

    # Positive probability every round alone has no global completion bound.
    # Product from n=1..N of (1-1/(n+1)^2) = (N+2)/(2(N+1)).
    product = F(1)
    for n in range(1, 33):
        product *= 1 - F(1, (n + 1) ** 2)
        assert product == F(n + 2, 2 * (n + 1))

    # Failure=identity admits an unchanged positive state, a concrete trap.
    trapped = scale(I, F(1, 2))
    assert positive(trapped) and trace(trapped) == 1
    assert conjugate(I, trapped) == trapped

    return {
        'scope': 'Exact finite CQ instrument, arbitrary retained qubit/reference; not acquired hardware law or learning demonstration.',
        'linear_basis_inputs_checked': tested,
        'full_labels': 4,
        'quotient_labels': 2,
        'intertwining_failure_and_success': True,
        'two_failure_steps': 'C^2 = (1/2) identity on complete CQ operator space',
        'tail_by_initial_phase_n_0_to_8': tails,
        'mean_logical_steps_by_phase': list(map(str, means)),
        'no_positive_one_step_success_floor': True,
        'forgetting_phase_rejected': True,
        'same_tails_wrong_quantum_recipient_detected': True,
        'wrong_recipient_joint_Xplus_probability': ['1/2', '0'],
        'positive_chances_noncompletion_limit': '1/2',
        'identity_failure_trap_exhibited': True,
        'new_QPU_jobs': 0,
    }


if __name__ == '__main__':
    print(json.dumps(main(), indent=2))
