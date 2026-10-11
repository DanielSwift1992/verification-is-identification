#!/usr/bin/env python3
"""AI6/AI7: scoped soundness, proposal coverage, trial dependence and budgets."""
from fractions import Fraction
from itertools import product
from pathlib import Path
import json
import sys


def powerset(items):
    items = tuple(items)
    return [frozenset(x for i, x in enumerate(items) if mask >> i & 1)
            for mask in range(1 << len(items))]


def audit():
    # A checker is an accepted subset A of the finite output set, while C
    # denotes outputs correct under the declared task semantics.
    cases = sound_cases = complete_cases = 0
    outputs = tuple(range(3))
    streams = [s for n in range(5) for s in product(outputs, repeat=n)]
    for correct, accepted in product(powerset(outputs), repeat=2):
        sound, complete = accepted <= correct, correct <= accepted
        assert sound == all(y in correct for y in outputs if y in accepted)
        for stream in streams:
            emitted = tuple(y for y in stream if y in accepted)
            raw_hit = any(y in correct for y in stream)
            checked_hit = any(y in correct for y in emitted)
            if sound:
                assert set(emitted) <= correct
                sound_cases += 1
            if complete:
                assert raw_hit == checked_hit
                complete_cases += 1
            else:
                assert any(y in correct and y not in accepted for y in outputs)
            cases += 1
    # A correct proposal can be refused by a sound but incomplete checker.
    assert frozenset() <= {1} and 1 not in frozenset()
    # Decidability alone permits an always-accepting, incorrect checker.
    assert 0 in {0, 1} and 0 not in {1}

    # Every law uniform on a nonempty support of length-three success tapes.
    # Exact conditional hazards factor survival without IID assumptions.
    tapes = tuple(product(range(2), repeat=3))
    laws = horizons = 0
    for support in powerset(tapes):
        if not support: continue
        laws += 1
        surviving = set(support)
        survival = Fraction(1)
        for i in range(3):
            hazard = Fraction(sum(t[i] for t in surviving), len(surviving)) if surviving else Fraction(0)
            survival *= 1 - hazard
            surviving = {t for t in surviving if not t[i]}
            assert survival == Fraction(len(surviving), len(support))
            marginals = [Fraction(sum(t[j] for t in support), len(support)) for j in range(i + 1)]
            hit = 1 - survival
            assert max(marginals) <= hit <= min(1, sum(marginals))
            horizons += 1
    repeated = ((0, 0, 0), (1, 1, 1))
    assert all(Fraction(sum(t[i] for t in repeated), 2) == Fraction(1, 2) for i in range(3))
    assert Fraction(sum(any(t) for t in repeated), 2) == Fraction(1, 2)
    for n in range(1, 5):
        iid = tuple(product(range(2), repeat=n))
        assert Fraction(sum(any(t) for t in iid), len(iid)) == 1 - Fraction(1, 2) ** n

    # Same proposals, perfect checker, different number affordable in a common
    # cost budget: raw sees the second (correct), wrapper only the first.
    stream, budget, generation, checking = (0, 1), 2, 1, 1
    raw = stream[:budget // generation]
    wrapped = stream[:budget // (generation + checking)]
    assert 1 in raw and 1 not in wrapped
    # A sound result about one input does not certify an untested input.
    laws2 = tuple(product(range(2), repeat=2))
    accepted_laws = tuple(h for h in laws2 if h[0] == 0)
    assert (0, 1) in accepted_laws and any(h[1] != 1 for h in accepted_laws)

    # Historical ledger versus current model coverage, on two fixed tasks.
    current0, current1 = frozenset({0}), frozenset({1})
    historical0, historical1 = current0, current0 | current1
    assert not current0 <= current1 and historical0 <= historical1
    # A currently failing task can still have an applicable stored certificate.
    assert 0 in historical1 and 0 not in current1

    # Proposal tape, phase and accepted-record mask all belong to the whole.
    # A controlled XOR writes the accepted event into a prepared zero mask.
    # It is a permutation on ALL 4*3*4 configurations, including unprepared
    # masks. The third internal phase restores the initial mask and phase.
    worlds = tuple(product(product(range(2), repeat=2), range(3), range(4)))
    def step(w):
        tape, phase, memory = w
        event_mask = (tape[0] << 0) | (tape[1] << 1)
        delta = (tape[phase] << phase) if phase < 2 else event_mask
        return tape, (phase + 1) % 3, memory ^ delta
    assert set(map(step, worlds)) == set(worlds)
    assert all(step(step(step(w))) == w for w in worlds)
    for tape in product(range(2), repeat=2):
        start = (tape, 0, 0)
        after = step(step(start))
        assert after[2] == tape[0] | (tape[1] << 1)
        assert bool(after[2]) == any(tape)
        assert step(after) == start
    return {'checker_stream_cases': cases, 'sound_cases': sound_cases, 'complete_cases': complete_cases,
            'finite_tape_laws': laws, 'hazard_horizons': horizons, 'closed_whole_states': len(worlds),
            'counterexamples': ['sound but incomplete checker', 'decidable unsound checker',
                               'repeated fixed seed has constant success marginals without IID coverage',
                               'checking reduces proposals affordable in a time budget',
                               'checked sample does not identify untested output',
                               'current coverage can change while the historical ledger grows'],
            'scope': 'Finite output sets, exact checker tables and prepared internal proposal tapes. No global physical entropy or real-model adequacy theorem.'}


def main():
    report = audit()
    path = Path(__file__).parent / 'Reports' / 'gate_wrapper.json'
    encoded = json.dumps(report, indent=2) + '\n'
    if '--write' in sys.argv: path.write_text(encoded)
    assert path.read_text() == encoded
    print('wrapper: ' + json.dumps(report))


if __name__ == '__main__': main()
