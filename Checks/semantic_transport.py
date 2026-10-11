#!/usr/bin/env python3
"""Question-preserving transport, compatible scopes, and one closed carrier.

The finite audit is separate from the Swift constructor proof. It checks total
maps with restricted certificate domains and every state of a resident-clock
machine, including preparation failures and cancelling local errors.
"""
from itertools import product
import json
from pathlib import Path
import sys


def maps(source_size, target_size):
    return tuple(product(range(target_size), repeat=source_size))


def subsets(size):
    return tuple(tuple(x for x in range(size) if mask & (1 << x))
                 for mask in range(1 << size))


def composition_audit():
    counts = {'cases': 0, 'compatible_certificates': 0,
              'compatible_nonempty': 0, 'unsafe_scope_failures': 0}
    for na, nb, nc in ((2, 2, 2), (2, 3, 2)):
        for qa, qb, qc, t, s, da, db in product(
                maps(na, 2), maps(nb, 2), maps(nc, 2),
                maps(na, nb), maps(nb, nc), subsets(na), subsets(nb)):
            counts['cases'] += 1
            first = all(qb[t[a]] == qa[a] for a in da)
            second = all(qc[s[b]] == qb[b] for b in db)
            if not (first and second):
                continue
            compatible = all(t[a] in db for a in da)
            composed = all(qc[s[t[a]]] == qa[a] for a in da)
            if compatible:
                assert composed, (qa, qb, qc, t, s, da, db)
                counts['compatible_certificates'] += 1
                counts['compatible_nonempty'] += bool(da)
            elif not composed:
                counts['unsafe_scope_failures'] += 1
    assert counts['unsafe_scope_failures'] > 0
    # Two individually valid certificates, but the first lands outside the
    # second's certified scope. No change of the shared question is needed.
    qa = qb = qc = (0, 1)
    t, s, da, db = (0, 1), (0, 0), (1,), (0,)
    assert all(qb[t[a]] == qa[a] for a in da)
    assert all(qc[s[b]] == qb[b] for b in db)
    assert qc[s[t[1]]] != qa[1]
    return counts


def whole_step(state):
    x, h, u, v, z, phase = state
    if phase == 0:
        u, v = u ^ h, v ^ x
    elif phase == 1:
        z ^= v
    return x, h, u, v, z, (phase + 1) % 3


def whole_inverse(state):
    x, h, u, v, z, phase = state
    previous_phase = (phase - 1) % 3
    if previous_phase == 0:
        u, v = u ^ h, v ^ x
    elif previous_phase == 1:
        z ^= v
    return x, h, u, v, z, previous_phase


def whole_audit():
    states = tuple(bits + (phase,) for bits in product((0, 1), repeat=5)
                   for phase in range(3))
    assert len(states) == 96
    assert {whole_step(w) for w in states} == set(states)
    for w in states:
        assert whole_inverse(whole_step(w)) == w
        assert whole_step(whole_inverse(w)) == w
    prepared = []
    for x, h in product((0, 1), repeat=2):
        before = (x, h, 0, 0, 0, 0)
        wire = whole_step(before)
        scalar = whole_step(wire)
        assert wire[2:4] == (h, x)
        assert wire[3] == before[0] == scalar[4]
        assert scalar[:2] == (x, h)
        assert whole_inverse(whole_inverse(scalar)) == before
        prepared.append({'source': [x, h], 'wire': list(wire[2:4]),
                         'scalar': scalar[4], 'ready_whole': list(scalar)})
    assert len({tuple(row['ready_whole']) for row in prepared}) == 4
    assert len({row['scalar'] for row in prepared}) == 2

    scope_counts = {'starts': 0, 'first_payload_correct': 0,
                    'final_payload_correct': 0, 'both_payloads_correct': 0,
                    'cancelled_errors': 0}
    for before in states:
        if before[-1] != 0:
            continue
        x, h, u, v, z, _ = before
        wire = whole_step(before)
        scalar = whole_step(wire)
        # Independent closed-form calculation for every buffer preparation.
        assert wire[2:4] == (u ^ h, v ^ x)
        assert scalar[4] == z ^ v ^ x
        first_ok, final_ok = wire[3] == x, scalar[4] == x
        scope_counts['starts'] += 1
        scope_counts['first_payload_correct'] += first_ok
        scope_counts['final_payload_correct'] += final_ok
        scope_counts['both_payloads_correct'] += first_ok and final_ok
        scope_counts['cancelled_errors'] += (not first_ok) and final_ok
    assert scope_counts == {'starts': 32, 'first_payload_correct': 16,
                            'final_payload_correct': 16,
                            'both_payloads_correct': 8, 'cancelled_errors': 8}

    def trace(start):
        middle = whole_step(start)
        return [list(start), list(middle), list(whole_step(middle))]

    unprepared_wire = trace((0, 0, 0, 1, 0, 0))
    unprepared_receiver = trace((0, 0, 0, 0, 1, 0))
    cancelled = trace((0, 0, 0, 1, 1, 0))
    assert unprepared_wire[-1][4] != unprepared_wire[0][0]
    assert unprepared_receiver[-1][4] != unprepared_receiver[0][0]
    assert cancelled[1][3] != cancelled[0][0] == cancelled[2][4]
    return {'states': len(states), 'prepared': prepared,
            'preparation_scope': scope_counts,
            'counterexamples': {'unprepared_wire': unprepared_wire,
                               'unprepared_receiver': unprepared_receiver,
                               'cancelled_errors': cancelled}}


def representation_audit():
    cases = []
    for x, h in product((0, 1), repeat=2):
        native, wire, scalar = (x, h), (h, x), x
        assert native[0] == wire[1] == scalar
        cases.append({'native': list(native), 'wire': list(wire), 'scalar': scalar})
    # One raw pair, two different question answers under different codes.
    raw = (0, 1)
    assert raw[0] != raw[1]
    assert ('native', raw) != ('wire', raw)
    # An unchanged answer is weaker than the unchanged full intermediate input.
    assert (0, 1) != (1, 1) and (0, 1)[1] == (1, 1)[1]
    # Projection is not invertible: both native inputs give the same scalar.
    assert (1, 0) != (1, 1) and (1, 0)[0] == (1, 1)[0]
    return {'cases': cases, 'same_raw_pair': list(raw),
            'native_answer': raw[0], 'wire_answer': raw[1]}


def report(data):
    c, w = data['composition'], data['whole']
    lines = [
        '# A question across different representations', '',
        'VC36 composes q_B(t(a))=q_A(a) on D_A and q_C(s(b))=q_B(b)',
        'on D_B when t(D_A) is contained in D_B. Substitution proves the',
        'result for s after t. The intermediate question and its interpretation',
        'must be shared. The Swift constructor requires the same actual reading.', '',
        'The audit enumerates binary questions, total maps and all certificate',
        'domains for carrier sizes (2,2,2) and (2,3,2). Empty scopes are included',
        'and nonempty compatible scopes counted separately.', '',
        '```json', json.dumps(c, indent=2), '```', '',
        '## A complete internally clocked realization', '',
        'Whole state is (x,h,u,v,z,phase): five bits and phase in {0,1,2}.',
        'The source is (x,h), the wire has resident buffers (u,v), and the',
        'receiver has z. Phase 0 XORs (h,x) into the wire, phase 1 XORs the',
        'wire payload v into z, and phase 2 changes only the phase. Every step',
        'advances phase modulo three. Reverse the phase and repeat its XORs',
        'to recover the previous whole. All 96 states and both inverse equations',
        'are checked. No outside controller, random tape or disposal is added.', '',
        'Prepare u=v=z=0 at phase 0. At phase 1 the wire is (h,x), and at',
        'phase 2 the receiver is x. This realizes the symbolic type path',
        '(native,(x,h)) -> (wire,(h,x)) -> (scalar,x) on this prepared slice.',
        'The original source and the wire remain inside the whole. The receiver',
        'alone cannot recover h. All four complete prepared alternatives remain',
        'distinct, while their two possible final payloads do not identify them.', '',
        '| Native source | Wire representation | Scalar answer | Ready whole |',
        '| --- | --- | --- | --- |']
    for row in w['prepared']:
        lines.append('| {} | {} | {} | {} |'.format(
            row['source'], row['wire'], row['scalar'], row['ready_whole']))
    lines += [
        '', '## Correct output does not certify every intermediate interpretation', '',
        'For arbitrary buffers at phase 0 the wire is (u XOR h, v XOR x),',
        'and the final payload is z XOR v XOR x. The first payload is correct',
        'exactly when v=0. The final payload is correct exactly when z=v.',
        'Both are correct exactly when v=z=0, independently of u. Reproducing',
        'the full intended wire representation additionally requires u=0.', '',
        '```json', json.dumps(w['preparation_scope'], indent=2), '```', '',
        'With v=z=1 the intermediate payload is wrong, yet the final payload',
        'is right. This is an actual end-to-end equality on that preparation,',
        'but not evidence that each stage preserved the declared question.',
        'A direct certificate can therefore be valid without the proposed',
        'factorization into locally preserving certificates being valid.', '',
        'Counterexample traces use the same complete transition law:', '',
        '```json', json.dumps(w['counterexamples'], indent=2), '```', '',
        'Readiness is a phase, not an everlasting result or a permanent blank',
        'buffer supply. This is a finite logical model, not a hardware efficiency',
        'claim, a new physical law, or an implementation of every symbolic path.', '',
        '## Evidence boundary', '',
        'The universal set-theoretic proof and generic Swift constructor are',
        'given in Verdict Is Invariant VC36. Finite enumeration checks nearby',
        'scope failures. VC37 records the closed realization and cancelling-error',
        'boundary. The type constructors prove projection and composition in',
        'the supplied tagged grammar. Physical interpretation and preparation',
        'still require their own evidence. No theorem of category theory or',
        'information theory is claimed as new.', '']
    return '\n'.join(lines)


def main():
    data = {'composition': composition_audit(), 'representations': representation_audit(),
            'whole': whole_audit()}
    report_dir = Path(__file__).resolve().parent / 'Reports'
    outputs = {'semantic_transport.json': json.dumps(data, indent=2) + '\n',
               'semantic_transport.md': report(data)}
    for name, content in outputs.items():
        path = report_dir / name
        if '--write' in sys.argv:
            path.write_text(content)
        else:
            assert path.read_text() == content, 'stale report: ' + str(path)
    print('semantic transport:', data['composition'],
          '; closed states:', data['whole']['states'],
          '; preparation scopes:', data['whole']['preparation_scope'])


if __name__ == '__main__':
    main()
