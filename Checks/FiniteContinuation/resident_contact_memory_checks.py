#!/usr/bin/env python3
"""Independent action histories for state-output and contact-output controllers."""
import argparse
from copy import deepcopy
import io
import json
from pathlib import Path
import time

import numpy as np
from qiskit import ClassicalRegister, qpy
from qiskit.circuit.library import RYGate, UnitaryGate
from qiskit_aer import AerSimulator

import resident_contact_memory as contact
import resident_goal_compiler as goal
import resident_flat_controller as flat
from resident_flat_checks import history_audit
from resident_raw_reply_checks import fixture, initial_quantum
from resident_stream_checks import operators, apply
import whole_word_admission as admission
from environment import write, digest


def semantics(source, plan, old_plans):
    summary = goal.saturate.verify(plan['model'], plan['certificate'])
    assert summary['final_classes'] == 4
    assert plan['certificate']['classes'] == old_plans['first']['certificate']['classes']
    assert len(set(old_plans['agreement']['certificate']['classes'])) == 8
    for i, state in enumerate(source['goal']['states']):
        r, f, _ = map(int, state)
        for b in (0, 1):
            expected = {'gate': ['JointHLabel', 'JointSLabel'][r^b],
                        'recipient': ['QI', 'QZ'][f^b]}
            assert plan['model']['observation'][i][b] == expected
    # Four distinct actual data channels, not merely four different labels.
    # Choose the admitted b=0 identity service with E=M=0.
    matrices = []
    for row in plan['certificate']['quotient']['observation']:
        entry = row[0]
        matrices.append({'QI': admission.I, 'QZ': admission.Z}[entry['recipient']] @
                        {'JointHLabel': admission.H, 'JointSLabel': admission.S}[entry['gate']])
    overlaps = [[float(abs(np.trace(a.conj().T@b))**2/4) for b in matrices] for a in matrices]
    assert max(overlaps[i][j] for i in range(4) for j in range(i)) < .26
    return {'certificate': summary, 'same_partition_as_First': True,
            'state_Agreement_classes': 8, 'b0_data_channel_overlaps': overlaps,
            'lower_bound_scope': 'Classical quotient preserving every admitted contact action on arbitrary data, with the retained quantum carrier unchanged.'}


def late_read_boundary():
    # These two different inputs arrive at the SAME updated First state and
    # pre-recipient quantum data. Forgetting both b and the old snapshot then
    # loses the information required for the delayed recipient.
    plus = np.array([1, 1], complex)/np.sqrt(2)
    before_recipient = admission.S@plus; results = []
    y = np.array([[0, -1j], [1j, 0]])
    for r, b in [(0, 1), (1, 0)]:
        f = 0
        assert 1^(r^b) == 0 and r^b == 1
        after = ([admission.I, admission.Z][f^b])@before_recipient
        results.append(float(np.vdot(after, y@after).real))
    assert abs(results[0]+1) < 1e-12 and abs(results[1]-1) < 1e-12
    return {'old_relative_and_reply': [[0, 1], [1, 0]], 'first': 0,
            'same_updated_First': [0, 0], 'same_pre_recipient_data': 'S|+>, E=M=0',
            'required_Y_answers': results,
            'same_instrument': 'K_0=K_1=I_EM/sqrt(2)', 'branch_probabilities': [.5, .5],
            'scope': 'Two actual branches of the same instrument; raw reply and old snapshot no longer available.'}


def guards(source, plan):
    refused = []
    def no(label, value):
        try:
            contact.interpret(source, value)
        except (ValueError, AssertionError):
            refused.append(label); return
        raise AssertionError('Accepted '+label)
    bad = deepcopy(plan); bad['model']['scope'] = 'Current Agreement at arbitrary time'
    bad['certificate'] = goal.saturate.synthesize(bad['model'])
    no('same tables under a stronger occurrence promise', bad)
    bad = deepcopy(plan); bad['model']['observation'][0][1]['recipient'] = 'QI'
    bad['certificate'] = goal.saturate.synthesize(bad['model'])
    no('valid certificate for a changed source recipient', bad)
    bad = deepcopy(plan); labels = list(range(8)); bad['certificate']['classes'] = labels
    bad['certificate']['quotient'] = goal.saturate.quotient(bad['model'], labels)
    no('unjustified retention of Last', bad)
    bad = deepcopy(plan); labels = [int(s[0]) for s in source['goal']['states']]
    bad['certificate']['classes'] = labels; bad['certificate']['quotient'] = goal.saturate.quotient(bad['model'], labels)
    no('forgetting First changes an actual recipient', bad)
    return refused


def service_fixture(theta, phi, rotation):
    gate, ks, _ = fixture(theta, phi)
    if not rotation:
        return gate, ks
    # Rotating the retained E input removes the original fixture's special
    # insensitivity to E phase. The controller sees only the same opaque port.
    u = gate.to_matrix()@np.kron(RYGate(rotation).to_matrix(), np.eye(4))
    return UnitaryGate(u), [[u[b::2, ::2]] for b in (0, 1)]


def feedback_witness(source):
    gate, ks = service_fixture(1.3, -.8, .71); maps = operators(source['goal']['raw'], ks)
    z = np.kron(admission.I, np.kron(admission.Z, np.eye(4))); history = [1, 0, 1, 1, 1]
    cases = []
    for live in (False, True):
        rho = initial_quantum(); r = 0; mass = 1.
        for b in history:
            rho = apply(maps[r, b], rho); p = float(np.trace(rho).real)
            mass *= p; rho /= p; r = 1^(r^b)
            if live and history[0]^b:
                rho = z@rho@z
        next_zero = float(np.trace(apply(maps[r, 0], rho)).real)
        # Also sum the whole ensemble: no postselection or equal-history
        # reweighting is used for this separate marginal quantity.
        blocks = {(1^b, b): apply(maps[0, b], initial_quantum()) for b in (0, 1)}
        for _ in range(4):
            nxt = {}
            for (r, first), value in blocks.items():
                for b in (0, 1):
                    out = apply(maps[r, b], value)
                    if live and first^b:
                        out = z@out@z
                    key = 1^(r^b), first; nxt[key] = nxt.get(key, 0)+out
            blocks = nxt
        assert abs(sum(np.trace(x).real for x in blocks.values())-1) < 1e-12
        marginal = float(sum(np.trace(apply(maps[r, 0], value)).real for (r, _), value in blocks.items()))
        cases.append({'recipient_after_every_contact': live, 'history_probability': mass,
                      'next_zero_given_history': next_zero, 'history_then_zero_probability': mass*next_zero,
                      'sixth_reply_zero_marginal': marginal})
    assert abs(cases[0]['next_zero_given_history']-cases[1]['next_zero_given_history']) > .05
    return {'fixture': [1.3, -.8, .71], 'history': history, 'cases': cases,
            'scope': 'Constructed local ideal example comparing two genuinely different recipient schedules. The optimized and reference controllers both use the live schedule and are compared separately.'}


def audit_circuit(qc, n, width, maps, labels, source, shots):
    traced = history_audit(qc, n); q = traced.copy_empty_like()
    cut = ClassicalRegister(width+1, 'audit_closed_scratch'); q.add_register(cut)
    for item in traced.data:
        q.append(item)
        if item.operation.name == 'save_density_matrix' and item.operation.label == 'closed_boundary':
            for bit, origin in enumerate([qc.cregs[2][0], *qc.cregs[1]]):
                q.store(cut[bit], origin)
    result = AerSimulator(method='statevector', max_parallel_threads=1).run(
        q, shots=shots, memory=True, seed_simulator=70821+n).result()
    assert result.success; maximum = 0.; seen = set(); z = np.kron(admission.I, np.kron(admission.Z, np.eye(4)))
    for j, record in enumerate(result.get_memory()):
        word = int(record.replace(' ', ''), 2)
        h = tuple((word >> (qc.num_clbits+i))&1 for i in range(n))
        rho = initial_quantum(); r = 0; f = h[0]
        for b in h:
            rho = apply(maps[r, b], rho); probability = np.trace(rho).real
            assert probability > 0; rho /= probability; r = 1^(r^b)
            if f^b:
                rho = z@rho@z
        cls = labels[source['goal']['states'].index(f'{r}{f}{h[-1]}')]; seen.add(cls)
        assert word & ((1 << width)-1) == cls
        assert (word >> (2*width+3)) & ((1 << width)-1) == cls
        assert word >> traced.num_clbits == 0
        for name, expected in [('continued', rho), ('closed_boundary', np.kron(rho, np.diag([1, 0])))]:
            error = float(np.max(abs(result.data()[name][j].data-expected)))
            assert error < 1e-10; maximum = max(maximum, error)
    stream = io.BytesIO(); qpy.dump(qc, stream)
    return {'classes_encountered': sorted(seen), 'maximum_state_residual': maximum,
            'QPY_bytes': len(stream.getvalue()), 'qubits': qc.num_qubits, 'classical_bits': qc.num_clbits,
            'persistent_controller_bits': width, 'scratch_bits': width+1,
            'measured_export_bits': width, 'profile': flat.check_flat_fragment(qc, allow_snapshot=True)}


def sdk(source, plan, old_plans):
    results = []; shots = 128; maximum = 0.; states = 0
    for theta, phi, rotation in [(1.3, -.8, 0), (1.45, .91, 0), (1.3, -.8, .71)]:
        gate, ks = service_fixture(theta, phi, rotation); maps = operators(source['goal']['raw'], ks)
        for n in (1, 3, 16, 64):
            variants = [('contact', contact.compile(source, plan, gate, n), 2, plan['certificate']['classes']),
                        ('state', contact.reference(source, old_plans['agreement'], gate, n), 3,
                         old_plans['agreement']['certificate']['classes'])]
            for name, qc, width, labels in variants:
                row = audit_circuit(qc, n, width, maps, labels, source, shots)
                results.append({'variant': name, 'contacts': n, 'fixture': [theta, phi, rotation], **row})
                maximum = max(maximum, row['maximum_state_residual']); states += 2*shots
    return {'circuits': len(results), 'shots_each': shots, 'full_quantum_states_checked': states,
            'maximum_state_residual': maximum, 'cases': results,
            'scope': 'Local ideal maps and live recipients after every acquired event; not QPU validation or equal arbitrary-time read interfaces.'}


def run(output):
    source = json.loads((goal.ROOT/'Research/Artifacts/resident-goal-acquisition-20260915/acquisition-reading.json').read_text())
    old = json.loads((goal.ROOT/'Research/Artifacts/resident-goal-memory-20260915/plans.json').read_text())
    plan = json.loads((output/'plan.json').read_text()); started = time.perf_counter()
    result = {'semantics': semantics(source, plan, old), 'late_read_boundary': late_read_boundary(),
        'feedback_witness': feedback_witness(source), 'refusals': guards(source, plan), 'SDK': sdk(source, plan, old),
        'seconds': time.perf_counter()-started, 'new_QPU_jobs': 0,
        'implementation_sha256': digest(Path(contact.__file__)), 'check_sha256': digest(Path(__file__)),
        'source_sha256': source['source_sha256']}
    write(output/'audit.json', result); return result


if __name__ == '__main__':
    p = argparse.ArgumentParser(description=__doc__); p.add_argument('--output', type=Path, required=True)
    r = run(p.parse_args().output.resolve())
    print(json.dumps({'states': r['SDK']['full_quantum_states_checked'], 'maximum_error': r['SDK']['maximum_state_residual'],
                      'seconds': r['seconds'], 'refusals': len(r['refusals'])}))
