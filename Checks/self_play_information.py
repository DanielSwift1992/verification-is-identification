#!/usr/bin/env python3
"""Synthetic evidence, internal access and reversible reuse are separate.

All programs, seeds, source bits and clocks belong to finite whole models.
Instruction counts are abstract gate/tick counts, not physical energy claims.
"""
from fractions import Fraction
from itertools import product
import json
from pathlib import Path
import sys

from closed_information import entropy, equal, mutual, pushed
from learning_coverage import version_space
from operational_quotient import canonical, partitions


def conditional_mutual(distribution, left, right, given):
    h = lambda f: entropy(pushed(distribution, f))
    return h(lambda s: (left(s), given(s))) + h(lambda s: (right(s), given(s))) - h(given) - h(lambda s: (left(s), right(s), given(s)))


def generator_audit():
    # General finite joint laws of (target, old record, seed), including zeros.
    # No independence is needed for the upper bound. The seed includes all
    # program choices or other inputs used by the generator beyond the record.
    worlds = tuple(product(range(2), repeat=3))
    cases = independent = 0
    for support in range(1, 1 << len(worlds)):
        selected = tuple(w for i, w in enumerate(worlds) if support & (1 << i))
        law = {w: Fraction(1, len(selected)) for w in selected}
        before = conditional_mutual(law, lambda s: s[0], lambda s: s[2], lambda s: s[1])
        p_b = pushed(law, lambda s: s[1])
        p_tb = pushed(law, lambda s: s[:2])
        p_br = pushed(law, lambda s: s[1:])
        independent_seed = all(law.get(w, 0) * p_b.get(w[1], 0)
                               == p_tb.get(w[:2], 0) * p_br.get(w[1:], 0) for w in worlds)
        for table in product(range(2), repeat=4):
            generated = lambda s: table[2 * s[1] + s[2]]
            after = conditional_mutual(law, lambda s: s[0], generated, lambda s: s[1])
            assert -1e-12 <= after <= before + 1e-12
            equal(conditional_mutual(law, lambda s: s[0], generated, lambda s: (s[1], s[2])), 0)
            if independent_seed:
                equal(before, 0)
                equal(after, 0)
                independent += 1
            cases += 1
    assert cases == 4080
    print(f'self-play: {cases} joint-law/generator cases, {independent} conditionally independent seeds give no added target information')
    # A claimed generator may not smuggle in a target-dependent input.
    def from_record_seed(table):
        return all(table[x] == table[y] for x in worlds for y in worlds if x[1:] == y[1:])
    for program in product(range(2), repeat=4):
        assert from_record_seed({w: program[2 * w[1] + w[2]] for w in worlds})
    assert not from_record_seed({w: w[0] for w in worlds})
    for first, second in product(partitions(3), repeat=2):
        combined = canonical(zip(first, second))
        new_pair = any(first[x] == first[y] and second[x] != second[y] for x in range(3) for y in range(3))
        assert (len(set(combined)) > len(set(first))) == new_pair
    assert len(set(canonical(zip((0, 0), (1, 1))))) == 1
    assert sum(len(set(draw)) == 2 for draw in product(range(2), repeat=2)) == 2
    print('self-play: hidden target access refused, 25 joint-reading refinements and below-mean coverage probability checked')


def whole_observation():
    programs = tuple(product(range(2), repeat=4))
    # (law first bit, law second bit, old record, seed, output, ready, program, mode)
    worlds = tuple((*bits, program, mode) for bits in product(range(2), repeat=6)
                   for program in range(16) for mode in range(2))
    def step(w):
        first, second, record, seed, output, ready, program, mode = w
        reading = second if mode else programs[program][2 * record + seed]
        return first, second, record, seed, output ^ reading, ready ^ 1, program, mode
    assert len(worlds) == 2048 and len({step(w) for w in worlds}) == len(worlds)
    assert all(step(step(w)) == w for w in worlds)
    for program in range(16):
        for mode in range(2):
            before = {(a, b, a, r, 0, 0, program, mode): Fraction(1, 8)
                      for a, b, r in product(range(2), repeat=3)}
            after = pushed(before, step)
            equal(entropy(before), entropy(after))
            equal(conditional_mutual(after, lambda s: s[1], lambda s: s[4], lambda s: s[2]), mode)
            assert all(w[5] == 1 for w in after)
    # Marginal seed independence is insufficient: record and seed can jointly
    # decode the target, although either alone carries zero target information.
    masked = {(a, b, a ^ b): Fraction(1, 4) for a, b in product(range(2), repeat=2)}
    equal(mutual(masked, lambda s: s[1], lambda s: s[2]), 0)
    equal(conditional_mutual(masked, lambda s: s[1], lambda s: s[2], lambda s: s[0]), 1)
    # A private synthetic target can be learned without learning an independent
    # unknown environmental target. Both are parts of the same whole.
    two_targets = {(actual, drawn): Fraction(1, 4) for actual, drawn in product(range(2), repeat=2)}
    equal(mutual(two_targets, lambda s: s[0], lambda s: s[1]), 0)
    equal(mutual(two_targets, lambda s: s[1], lambda s: s[1]), 1)
    return len(worlds)


def schedule(n, m, cached):
    accumulator = n
    compute = tuple((i, accumulator) for i in range(n))
    copies = tuple((accumulator, n + 1 + j) for j in range(m))
    if cached:
        return compute + copies + compute[::-1]
    return tuple(gate for copy in copies for gate in compute + (copy,) + compute[::-1])


def gate(registers, instruction):
    control, target = instruction
    out = list(registers)
    out[target] ^= out[control]
    return tuple(out)


def closed_machine(n, m):
    plans = (schedule(n, m, False), schedule(n, m, True))
    registers = tuple(product(range(2), repeat=n + 1 + m))
    worlds = tuple((r, mode, phase) for r in registers for mode in range(2)
                   for phase in range(len(plans[mode]) + 1))
    def step(w):
        r, mode, phase = w
        plan = plans[mode]
        if phase == len(plan):
            return r, mode, 0
        return gate(r, plan[phase]), mode, phase + 1
    def inverse(w):
        r, mode, phase = w
        if phase == 0:
            return r, mode, len(plans[mode])
        return gate(r, plans[mode][phase - 1]), mode, phase - 1
    assert len({step(w) for w in worlds}) == len(worlds)
    assert all(inverse(step(w)) == w and step(inverse(w)) == w for w in worlds)
    final_laws = []
    for mode, plan in enumerate(plans):
        before = {(bits + (0,) * (m + 1), mode, 0): Fraction(1, 2 ** n)
                  for bits in product(range(2), repeat=n)}
        current = before
        for _ in plan:
            current = pushed(current, step)
            equal(entropy(current), entropy(before))
        for (r, _, phase) in current:
            assert r[n] == 0 and r[n + 1:] == (sum(r[:n]) % 2,) * m
            assert phase == len(plan)  # Readiness is an internal clock state.
        final_laws.append(pushed(current, lambda w: w[0]))
    assert final_laws[0] == final_laws[1]
    assert len(plans[0]) == m * (2 * n + 1) and len(plans[1]) == 2 * n + m
    return {'input_bits': n, 'answer_copies': m, 'whole_states': len(worlds),
            'recompute_ticks': len(plans[0]), 'reuse_ticks': len(plans[1]),
            'whole_entropy_bits': n, 'accumulator_final': 0}


def synthetic_filter_audit():
    cases = misleading = 0
    for n in range(1, 5):
        family = tuple(product(range(2), repeat=n))
        for actual in family:
            for mask in range(1 << n):
                evidence = tuple((i, actual[i]) for i in range(n) if mask & (1 << i))
                versions = version_space(family, evidence)
                # Fixed deterministic generator: choose first consistent law.
                guessed = versions[0]
                synthetic = tuple(enumerate(guessed))
                narrowed = version_space(family, evidence + synthetic)
                assert narrowed == (guessed,)
                assert all(version_space(family, tuple((i, alternative[i]) for i, _ in evidence))[0] == guessed
                           for alternative in versions)
                misleading += actual not in narrowed
                cases += 1
    assert cases == 340
    print(f'self-play: {cases} relabeling models, {misleading} synthetic singletons exclude actual law without new measurements')


def demo():
    family = tuple(product(range(2), repeat=2))
    evidence = ((0, 0),)
    synthetic = ((1, 0),)
    return {'evidence': evidence, 'compatible_actual_laws': version_space(family, evidence),
            'generated_label': synthetic, 'synthetically_narrowed': version_space(family, evidence + synthetic),
            'possible_actual_countermodel': (0, 1), 'observation_whole_states': whole_observation(),
            'reuse_machine': closed_machine(3, 4),
            'synthetic_target_information_bits': 1, 'independent_actual_target_information_bits': 0,
            'direct_internal_measurement_gain_bits': 1}


def markdown(result):
    machine = result['reuse_machine']
    return f'''# What self-play can add inside a closed whole

## Synthetic labels do not certify an unmeasured law

First-input observation 0 leaves actual laws (0,0) and (0,1) compatible.
Choosing (0,0) as the generator and appending its synthetic second label 0
makes the synthetic training set uniquely identify (0,0). This happens in
both possible actual worlds, including (0,1), where that second label is false.
The correct evidence-based version set still contains both laws.

For generated history G=F(B,R), I(Θ;G|B)≤I(Θ;R|B).
Here B contains prior accessible evidence and R contains all additional
program/seed inputs. If Θ and R are conditionally independent given B,
the extra information about Θ is zero. Independence only before conditioning
is insufficient: B and a masked seed can jointly decode the unknown bit.

A poser can still teach its privately drawn synthetic target to a solver.
An independent one-bit draw carries one bit about that draw and zero about
an unrelated unknown target. Which object is being learned matters.

## New access is possible without anything entering the whole

A {result['observation_whole_states']}-state permutation contains two law bits,
the old record, seed, output, readiness, a generator program and a mode.
Generating from the old record and independent seed adds zero conditional
information about the unknown second bit. Reading that internal law bit adds
one bit to the local output. Both operations are reversible and preserve
whole entropy. The next tick reverses the record, so the reading window matters.

## Computation can improve without new evidence

The known task is parity of {machine['input_bits']} retained input bits,
requested {machine['answer_copies']} times. Both machines use only reversible
controlled bit flips, prepared output bits, an accumulator and an internal clock.

| Policy | Gate/clock ticks before ready | Final accumulator | Final outputs |
|---|---|---|---|
| Compute, copy and uncompute for every request | {machine['recompute_ticks']} | 0 | Four exact parity bits |
| Compute once, copy to every output, uncompute once | {machine['reuse_ticks']} | 0 | Four exact parity bits |

Both reach the same data-register state. Program mode and clock also belong
to the whole, which has {machine['whole_states']} states and an explicit inverse.
Joint entropy stays {machine['whole_entropy_bits']} bits throughout. The outputs
are determined by the retained inputs, so add no information conditional on
those inputs. They make the answer directly readable with less repeated work.
Precomputation, copying and cleanup are all counted. The clock reset after
the readout window is outside both compared prefixes and is explicit in the
whole permutation. This is a reversible reuse construction, not a neural
training benchmark, physical energy bound or claim of globally optimal circuitry.
'''


def main():
    generator_audit()
    synthetic_filter_audit()
    total = 0
    for n, m in product(range(1, 4), range(1, 5)):
        total += closed_machine(n, m)['whole_states']
    print(f'self-play: 12 reversible reuse machines, {total} whole states, inverse and complete costs checked')
    result = json.loads(json.dumps(demo()))
    root = Path(__file__).parent / 'Reports'
    if '--write' in sys.argv:
        (root / 'self_play_information.json').write_text(json.dumps(result, indent=2) + '\n')
        (root / 'self_play_information.md').write_text(markdown(result))
    assert result == json.loads((root / 'self_play_information.json').read_text())
    assert markdown(result) == (root / 'self_play_information.md').read_text()
    print('self-play: synthetic target versus actual law, internal measurement and reversible reuse reports agree')


if __name__ == '__main__':
    main()
