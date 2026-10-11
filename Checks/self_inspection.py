#!/usr/bin/env python3
"""Relative internal inspection and the exact Boolean diagonal obstruction."""
from itertools import product
import json
from pathlib import Path
import sys


TABLES = tuple(product(range(2), repeat=4))
EQUALITY = (1, 0, 0, 1)


def diagonal_audit():
    counts = {}
    for n in range(1, 4):
        count = 0
        for flat in product(range(2), repeat=n * n):
            rows = tuple(flat[i*n:(i+1)*n] for i in range(n))
            missing = tuple(1 - rows[i][i] for i in range(n))
            assert missing not in rows
            # Independent local contradiction at every proposed code.
            assert all(rows[i][i] != missing[i] for i in range(n))
            count += 1
        counts[str(n)] = count
    evaluator = ((0, 0), (0, 1))
    assert evaluator[1][1] == 1  # Total self-application is well defined.
    assert (1, 0) not in evaluator
    return counts


def step(state):
    candidate, reference, record, verdict, phase = state
    if phase < 4:
        record ^= (TABLES[candidate][phase] ^ TABLES[reference][phase]) << phase
    elif phase == 4:
        verdict ^= int(record == 0)
    return candidate, reference, record, verdict, (phase + 1) % 6


def inverse(state):
    candidate, reference, record, verdict, phase = state
    previous = (phase - 1) % 6
    if previous < 4:
        record ^= (TABLES[candidate][previous] ^ TABLES[reference][previous]) << previous
    elif previous == 4:
        verdict ^= int(record == 0)
    return candidate, reference, record, verdict, previous


def ready(candidate, reference, record=0, verdict=0):
    state = candidate, reference, record, verdict, 0
    for _ in range(5):
        state = step(state)
    return state


def inspection_audit():
    worlds = tuple(product(range(16), range(16), range(16), range(2), range(6)))
    assert len(worlds) == 49152
    assert len({step(w) for w in worlds}) == len(worlds)
    assert all(inverse(step(w)) == w and step(inverse(w)) == w for w in worlds)
    for candidate, reference in product(range(16), repeat=2):
        result = ready(candidate, reference)
        expected_record = sum((a ^ b) << i for i, (a, b) in
                              enumerate(zip(TABLES[candidate], TABLES[reference])))
        assert result[:2] == (candidate, reference)
        assert result[2:] == (expected_record, int(candidate == reference), 5)
    eq = TABLES.index(EQUALITY)
    assert sum(ready(c, eq)[3] for c in range(16)) == 1
    # At every tick a uniform preparation over the 16 candidates still has
    # 16 distinct equal-weight states: its whole entropy remains four bits.
    support = {(c, eq, 0, 0, 0) for c in range(16)}
    for _ in range(24):
        support = {step(w) for w in support}
        assert len(support) == 16
    # Preparation and interpretation cannot be removed from the claim.
    wrong = TABLES.index((1, 1, 1, 1))
    assert ready(wrong, wrong)[3] == 1 and TABLES[wrong] != EQUALITY
    mask = sum((a ^ b) << i for i, (a, b) in enumerate(zip(TABLES[wrong], EQUALITY)))
    assert ready(wrong, eq, record=mask)[3] == 1  # Unprepared mismatch register.
    assert ready(wrong, eq, verdict=1)[3] == 1  # Unprepared verdict register.
    # Running onward does not create a permanently absorbing ready state.
    first = ready(eq, eq)
    second = first
    for _ in range(6):
        second = step(second)
    assert second[4] == 5 and second[3] == 0
    return len(worlds)


def circular_audit():
    accepted = [g for g in TABLES if all(g[2 * actual + expected]
                                       for actual, expected in zip(g, EQUALITY))]
    assert len(accepted) == 5 and EQUALITY in accepted
    assert (1, 1, 1, 1) in accepted and (0, 1, 1, 0) in accepted
    return accepted


def markdown(result):
    return f'''# Internal self-inspection and Boolean diagonalization

## Exact obstruction

A total evaluator E:C×C→{{0,1}} cannot represent its own diagonal complement
d(c)=1−E(c,c). If a represents d, substituting c=a gives E(a,a)=1−E(a,a).
All {sum(result['diagonal_matrices'].values())} Boolean matrices for code sets
of sizes 1, 2 and 3 obey this. Total self-application alone is allowed:
E=((0,0),(0,1)) has E(1,1)=1. Its missing diagonal complement is (1,0).
The proof excludes universality with this diagonal, not every self-inspection.

## Closed finite inspection

The whole has {result['whole_states']} states: a four-bit resident implemented
gate C, four-bit resident reference S, four mismatch bits r, verdict v and
phase 0…5. No checker, reference register or clock is outside this model.
At phases i=0…3, r_i is flipped by C_i XOR S_i; at phase 4, v is flipped
iff r=0; phase 5 wraps to 0. Decreasing phase and repeating the corresponding
flip is the inverse. Every state and both inverse identities were checked.

From r=0, v=0, phase=0, five ticks produce v=1 iff C=S. All 256 candidate /
reference pairs were checked. For the equality reference (1,0,0,1), exactly
one of 16 candidate gates passes. A uniform preparation over candidates
retains four bits of whole entropy. The candidate is the same resident
implementation whose input/output table the inspection reads.

This proves relative correctness of an internal component under the declared
transition semantics. It does not prove those semantics or the intended
meaning of S without premises. Coherently wrong C=S passes. Unprepared r or
v can also produce false acceptance; the readout window is finite and the
clock continues. Physical closure and logical justification are separate.

## Circular test can fail

If the candidate gate itself compares each actual output with the equality
reference output, {len(result['circular_accepted'])} of 16 gates accept themselves.
Four are wrong, including constant true and XOR. This finite counterexample
shows that a reassuring self-test needs an explicit soundness argument.
It is not an impossibility proof for all internal checking architectures.

The Swift witness only projects a represented evaluator's two self-readings.
Two independently compiled refusals reject identification of the missing
diagonal complement with either represented row. It does not implement the
finite machine, prove all truth-table sizes or certify the Swift compiler.

Sources: Lawvere, Diagonal Arguments and Cartesian Closed Categories,
[primary reprint](https://conceptualmathematics.wordpress.com/wp-content/uploads/2025/03/diagonal_arguments.pdf),
Theorem 1.1; [CakeML POPL 2014](https://cakeml.org/popl14.pdf), abstract and §2.1,
for an established example of verified bootstrapping relative to semantics.
Neither self-application nor verified bootstrapping is claimed as a VI novelty.
'''


def main():
    result = {'diagonal_matrices': diagonal_audit(),
              'whole_states': inspection_audit(),
              'circular_accepted': circular_audit()}
    result = json.loads(json.dumps(result))
    root = Path(__file__).parent / 'Reports'
    if '--write' in sys.argv:
        (root / 'self_inspection.json').write_text(json.dumps(result, indent=2) + '\n')
        (root / 'self_inspection.md').write_text(markdown(result))
    assert result == json.loads((root / 'self_inspection.json').read_text())
    assert markdown(result) == (root / 'self_inspection.md').read_text()
    print('self-inspection: 530 diagonal matrices; 49152 whole states and inverse; 256 relative inspections; four circular false acceptances; preparation and reference counterexamples pass')


if __name__ == '__main__':
    main()
