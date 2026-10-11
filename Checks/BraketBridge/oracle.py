"""Independent matrix oracle for the bounded Braket bridge QA.

This module knows only one logical qubit and the declared source word H, S,
and Z(control).  It is not a circuit simulator, planner, or proof checker.
Source operations are dictionaries such as {"gate": "z", "control": 0}.
Control zero is the most significant bit of the fixture's valuation integer.
The fixture may call this oracle with private controls; the working planner
and corrector must not receive those realized controls.

All matrices are literal, independent of the planner's frame recurrence.
Choi matrices use reference tensor data, with the reference untouched.
Floating-point comparisons here are implementation checks, not proofs of
the analytical channel bounds.
"""

import argparse
import math
from typing import Any, Mapping, Sequence, Tuple


Matrix2 = Tuple[Tuple[complex, complex], Tuple[complex, complex]]
Density4 = Tuple[Tuple[complex, ...], ...]
State2 = Tuple[complex, complex]

_INV_SQRT2 = 1.0 / math.sqrt(2.0)
DEFAULT_TOLERANCE = 1.0e-10

I: Matrix2 = ((1 + 0j, 0j), (0j, 1 + 0j))
X: Matrix2 = ((0j, 1 + 0j), (1 + 0j, 0j))
Y: Matrix2 = ((0j, -1j), (1j, 0j))
Z: Matrix2 = ((1 + 0j, 0j), (0j, -1 + 0j))
H: Matrix2 = (
    (_INV_SQRT2 + 0j, _INV_SQRT2 + 0j),
    (_INV_SQRT2 + 0j, -_INV_SQRT2 + 0j),
)
S: Matrix2 = ((1 + 0j, 0j), (0j, 1j))

PAULIS = {"I": I, "X": X, "Y": Y, "Z": Z}
STATES = {
    "zero": (1 + 0j, 0j),
    "one": (0j, 1 + 0j),
    "plus": (_INV_SQRT2 + 0j, _INV_SQRT2 + 0j),
    "minus": (_INV_SQRT2 + 0j, -_INV_SQRT2 + 0j),
    "plus_i": (_INV_SQRT2 + 0j, 1j * _INV_SQRT2),
    "minus_i": (_INV_SQRT2 + 0j, -1j * _INV_SQRT2),
}


def _matrix2(value: Sequence[Sequence[complex]]) -> Matrix2:
    if len(value) != 2 or any(len(row) != 2 for row in value):
        raise ValueError("The oracle accepts only 2 by 2 logical matrices.")
    return (
        (complex(value[0][0]), complex(value[0][1])),
        (complex(value[1][0]), complex(value[1][1])),
    )


def multiply(left: Matrix2, right: Matrix2) -> Matrix2:
    """Matrix product: right acts first, then left."""
    a, b = _matrix2(left), _matrix2(right)
    return (
        (
            a[0][0] * b[0][0] + a[0][1] * b[1][0],
            a[0][0] * b[0][1] + a[0][1] * b[1][1],
        ),
        (
            a[1][0] * b[0][0] + a[1][1] * b[1][0],
            a[1][0] * b[0][1] + a[1][1] * b[1][1],
        ),
    )


def dagger(matrix: Matrix2) -> Matrix2:
    a = _matrix2(matrix)
    return (
        (a[0][0].conjugate(), a[1][0].conjugate()),
        (a[0][1].conjugate(), a[1][1].conjugate()),
    )


def control_bit(valuation: int, control_count: int, index: int) -> int:
    """Read a fixture control, with s0 as the most significant bit."""
    if type(control_count) is not int or control_count < 0:
        raise ValueError("control_count must be a nonnegative integer.")
    if type(valuation) is not int or not 0 <= valuation < (1 << control_count):
        raise ValueError("Fixture valuation is outside its declared controls.")
    if type(index) is not int or not 0 <= index < control_count:
        raise ValueError("Control index is outside its declared controls.")
    return (valuation >> (control_count - 1 - index)) & 1


def literal_unitaries(
    operations: Sequence[Mapping[str, Any]],
    valuation: int,
    control_count: int,
) -> Tuple[Matrix2, Matrix2]:
    """Return (actual, ideal) by literal chronological matrix products.

    The ideal word keeps H/S and omits each recorded Z contact.  Unknown
    operations, missing controls, and surplus operation fields are errors;
    no unsupported source operation is silently interpreted as identity.
    """
    if type(control_count) is not int or control_count < 0:
        raise ValueError("control_count must be a nonnegative integer.")
    if type(valuation) is not int or not 0 <= valuation < (1 << control_count):
        raise ValueError("Fixture valuation is outside its declared controls.")
    actual, ideal = I, I
    for operation in operations:
        gate = operation.get("gate")
        if gate in ("h", "s"):
            if set(operation) != {"gate"}:
                raise ValueError("H/S source operations accept only gate.")
            matrix = H if gate == "h" else S
            actual = multiply(matrix, actual)
            ideal = multiply(matrix, ideal)
        elif gate == "z":
            if set(operation) != {"gate", "control"}:
                raise ValueError("Recorded Z requires exactly gate and control.")
            bit = control_bit(valuation, control_count, operation["control"])
            actual = multiply(Z if bit else I, actual)
        else:
            raise ValueError("Unsupported oracle source operation: {!r}".format(gate))
    return actual, ideal


def max_entry_error(
    left: Sequence[Sequence[complex]], right: Sequence[Sequence[complex]]
) -> float:
    """Entrywise QA discrepancy; this is not a diamond-norm calculation."""
    if len(left) != len(right) or any(
        len(a) != len(b) for a, b in zip(left, right)
    ):
        raise ValueError("Compared matrices must have the same shape.")
    return max(
        (abs(complex(a) - complex(b)) for ar, br in zip(left, right)
         for a, b in zip(ar, br)),
        default=0.0,
    )


def independent_frame_label(
    actual: Matrix2,
    ideal: Matrix2,
    tolerance: float = DEFAULT_TOLERANCE,
) -> str:
    """Compare actual * ideal-dagger to literal I/X/Y/Z modulo phase.

    This deliberately does not update or consult symbolic frame bits.
    A word outside the declared Pauli-relative family raises an error.
    """
    if not math.isfinite(tolerance) or tolerance <= 0:
        raise ValueError("Comparison tolerance must be finite and positive.")
    residual = multiply(actual, dagger(ideal))
    for label, pauli in PAULIS.items():
        phase = sum(
            pauli[row][col].conjugate() * residual[row][col]
            for row in range(2) for col in range(2)
        ) / 2.0
        candidate = tuple(
            tuple(phase * value for value in row) for row in pauli
        )
        if (abs(abs(phase) - 1.0) <= tolerance
                and max_entry_error(residual, candidate) <= tolerance):
            return label
    raise ValueError("Actual and ideal words do not differ by a Pauli up to phase.")


def density_from_state(state: Sequence[complex]) -> Matrix2:
    if len(state) != 2:
        raise ValueError("The oracle accepts only a two-amplitude pure input.")
    vector = (complex(state[0]), complex(state[1]))
    norm_squared = abs(vector[0]) ** 2 + abs(vector[1]) ** 2
    if not math.isfinite(norm_squared) or abs(norm_squared - 1.0) > DEFAULT_TOLERANCE:
        raise ValueError("The supplied pure input must be normalized.")
    return (
        (vector[0] * vector[0].conjugate(), vector[0] * vector[1].conjugate()),
        (vector[1] * vector[0].conjugate(), vector[1] * vector[1].conjugate()),
    )


def transform_density(unitary: Matrix2, input_density: Matrix2) -> Matrix2:
    """Literal U rho U-dagger, for one supplied logical density matrix."""
    return multiply(multiply(unitary, _matrix2(input_density)), dagger(unitary))


def output_density(unitary: Matrix2, input_state: Sequence[complex]) -> Matrix2:
    """Density of a supplied pure logical input after the literal unitary."""
    return transform_density(unitary, density_from_state(input_state))


def choi_density(unitary: Matrix2) -> Density4:
    """Normalized Choi density in reference-tensor-data order.

    Apply I_reference tensor U_data to (|00> + |11>)/sqrt(2).
    The vector is column-stacked U: U00, U10, U01, U11.
    """
    u = _matrix2(unitary)
    vector = (
        u[0][0] * _INV_SQRT2,
        u[1][0] * _INV_SQRT2,
        u[0][1] * _INV_SQRT2,
        u[1][1] * _INV_SQRT2,
    )
    return tuple(
        tuple(left * right.conjugate() for right in vector)
        for left in vector
    )


def derive_effect(unitary: Matrix2, basis: str, relabel_bit: int = 0) -> Matrix2:
    """Pull back the reported-plus effect through a literal unitary.

    relabel_bit=1 interchanges the two measured outcomes.  The return value
    is U-dagger [(I + (-1)^relabel_bit P_basis)/2] U, an input effect, not a
    reconstructed output state or an individual guaranteed measurement bit.
    """
    if basis not in ("X", "Y", "Z"):
        raise ValueError("The bounded oracle supports only X/Y/Z questions.")
    if type(relabel_bit) is not int or relabel_bit not in (0, 1):
        raise ValueError("Outcome relabeling must be a classical bit.")
    sign = 1 if relabel_bit == 0 else -1
    pauli = PAULIS[basis]
    projector = tuple(
        tuple((I[row][col] + sign * pauli[row][col]) / 2.0 for col in range(2))
        for row in range(2)
    )
    return multiply(multiply(dagger(unitary), projector), unitary)


def effect_probability(effect: Matrix2, input_state: Sequence[complex]) -> float:
    density = density_from_state(input_state)
    value = sum(
        effect[row][col] * density[col][row]
        for row in range(2) for col in range(2)
    )
    if abs(value.imag) > DEFAULT_TOLERANCE:
        raise ValueError("The supplied effect produced a non-real probability.")
    return float(value.real)


def self_check() -> None:
    """Small literal convention checks, not an enumeration of source words."""
    assert control_bit(2, 2, 0) == 1
    assert control_bit(2, 2, 1) == 0

    # H transports the actual Z to X at the output: H Z H-dagger = X.
    actual, ideal = literal_unitaries(
        [{"gate": "z", "control": 0}, {"gate": "h"}], 1, 1
    )
    assert max_entry_error(actual, multiply(H, Z)) < DEFAULT_TOLERANCE
    assert independent_frame_label(actual, ideal) == "X"

    actual, ideal = literal_unitaries(
        [{"gate": "z", "control": 0}, {"gate": "h"},
         {"gate": "z", "control": 1}], 3, 2
    )
    assert independent_frame_label(actual, ideal) == "Y"

    # Chronological S-dagger then H measures Y.  H then S-dagger does not.
    y_analyzer = multiply(H, dagger(S))
    assert max_entry_error(
        derive_effect(y_analyzer, "Z"), derive_effect(I, "Y")
    ) < DEFAULT_TOLERANCE
    assert abs(effect_probability(derive_effect(I, "Y"), STATES["plus_i"]) - 1) < DEFAULT_TOLERANCE
    assert abs(effect_probability(derive_effect(I, "Y", 1), STATES["plus_i"])) < DEFAULT_TOLERANCE
    assert max_entry_error(
        output_density(y_analyzer, STATES["plus_i"]), density_from_state(STATES["zero"])
    ) < DEFAULT_TOLERANCE

    # S H is asymmetric: this entry detects swapping reference and data.
    choi = choi_density(multiply(S, H))
    assert abs(choi[1][2] - 0.25j) < DEFAULT_TOLERANCE
    assert abs(sum(choi[i][i] for i in range(4)) - 1) < DEFAULT_TOLERANCE

    try:
        literal_unitaries([{"gate": "unsupported"}], 0, 0)
    except ValueError:
        pass
    else:
        raise AssertionError("Unsupported operations must not become identity.")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--self-check", action="store_true")
    args = parser.parse_args()
    if not args.self_check:
        parser.error("Use --self-check, or import the bounded QA functions.")
    self_check()
    print("oracle self-check: passed (literal gates, Y convention, Choi wire order)")


if __name__ == "__main__":
    main()
