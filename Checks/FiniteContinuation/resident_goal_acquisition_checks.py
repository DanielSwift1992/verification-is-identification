#!/usr/bin/env python3
"""Future-class acquisition, non-recovery and a live two-recipient experiment."""
import argparse
from copy import deepcopy
import json
from pathlib import Path
import time

import numpy as np
from qiskit import ClassicalRegister
from qiskit_aer import AerSimulator

import resident_goal_acquisition as acquire
import resident_goal_compiler as goal
import resident_flat_controller as flat
from resident_flat_checks import history_audit
from resident_raw_reply_checks import fixture
from resident_stream_checks import operators, trajectory, apply
import whole_word_admission as admission
from environment import write, digest


def contact_relations(source, plans):
    result = {}; src = source['goal']
    for a, old in plans.items():
        for b, new in plans.items():
            direct = goal.transport(src, old, new)
            stepped = acquire.contact_transport(source, old, new)
            result[a+' -> '+b] = {'direct': direct, 'after_one_contact': stepped}
    assert not result['first -> agreement']['direct']['available']
    assert result['first -> agreement']['after_one_contact']['available']
    for target in ('first', 'agreement'):
        assert not result['continue -> '+target]['after_one_contact']['available']
    reachable = set(src['initial']); finite_horizons = []
    for n in range(1, 5):
        fibers = {}
        for i in reachable:
            old_class = plans['first']['certificate']['classes'][i]
            fibers.setdefault(old_class, set()).add(plans['agreement']['certificate']['classes'][i])
        finite_horizons.append({'previous_contacts': n, 'reachable_states': len(reachable),
                               'zero_contact_map_on_this_domain': all(len(v) == 1 for v in fibers.values())})
        reachable = {src['operations']['reply'+str(bit)][i] for i in reachable for bit in (0, 1)}
    assert [x['zero_contact_map_on_this_domain'] for x in finite_horizons] == [True, True, False, False]
    # A finite invariant relation proves non-recovery for arbitrary length;
    # this is not testing a finite collection of long words.
    pairs = []
    for i, a in enumerate(src['states']):
        for j, b in enumerate(src['states']):
            if a[0] == b[0] and a[1] != b[1]:
                pairs.append((i, j))
    relation = set(pairs); ctl = goal.interpret(src, plans['continue'])
    labels = plans['continue']['certificate']['classes']
    for i, j in pairs:
        assert labels[i] == labels[j]
        for bit in (0, 1):
            ni, nj = [src['operations']['reply'+str(bit)][x] for x in (i, j)]
            assert (ni, nj) in relation
            assert src['states'][ni][2] == src['states'][nj][2]
            assert src['observation']['first'][ni] != src['observation']['first'][nj]
            assert src['observation']['agreement'][ni] != src['observation']['agreement'][nj]
            assert ctl['emit'][labels[i]][bit] == ctl['emit'][labels[j]][bit]
    return {'transports': result, 'finite_horizon_domains': finite_horizons,
            'closed_nonrecovery_pairs': [[src['states'][i], src['states'][j]] for i, j in pairs],
            'witness_instrument': 'K_0=K_1=I_EM/sqrt(2), same maximally mixed full quantum payload',
            'conclusion': 'No policy using only these replies can guarantee recovery of the original First from Continue; each finite transcript has indistinguishable opposite-first realizations.'}


def locality_boundary():
    # Same old First reading and same visible quantum state, but a hypothetical
    # hidden control of the instrument by discarded Last yields different
    # branch probabilities. No common reduced CP instrument can represent both.
    rho = np.eye(16)/16
    probabilities = []
    for last in (0, 1):
        k = np.eye(16) if last == 0 else np.zeros((16, 16))
        probabilities.append(float(np.trace(k@rho@k.conj().T).real))
    assert probabilities == [1, 0]
    return {'old_states': ['000', '001'], 'same_first_reading': [0, 0],
        'same_quantum_state': 'I/16', 'counter_instrument': 'K_b,last = delta(b,last) I',
        'reply_zero_probabilities': probabilities,
        'excluded_condition': 'The instrument acts only on retained E,M with the same actual branch maps.'}


def sdk(source, plans):
    cases = []; maximum = 0.; count = 0; shots = 256
    z = np.kron(admission.I, np.kron(admission.Z, np.eye(4)))
    for theta, phi in ((1.3, -.8), (1.45, .91)):
        service, ks, _ = fixture(theta, phi); maps = operators(source['goal']['raw'], ks)
        for before, after in ((1, 1), (2, 1), (3, 3), (8, 56)):
            qc = acquire.compile(source, plans, service, before, after)
            traced = history_audit(qc, before+after); q = traced.copy_empty_like()
            audit_cut = ClassicalRegister(5, 'audit_cut'); q.add_register(audit_cut)
            # Independent audit access, not supplied to the live controller.
            for item in traced.data:
                q.append(item)
                if item.operation.name == 'save_density_matrix' and item.operation.label == 'before_handoff':
                    watched = [qc.cregs[2][0], *qc.cregs[1], qc.cregs[0][2]]
                    for bit, old_bit in enumerate(watched):
                        q.store(audit_cut[bit], old_bit)
            rs = AerSimulator(method='statevector', max_parallel_threads=1).run(
                q, shots=shots, memory=True, seed_simulator=23931+before+after).result()
            assert rs.success; error = 0.; seen = set(); flags = set()
            for j, record in enumerate(rs.get_memory()):
                number = int(record.replace(' ', ''), 2)
                h = tuple((number >> (qc.num_clbits+i))&1 for i in range(before+after))
                r, rho = trajectory(maps, h[:before])
                if h[0]:
                    rho = z@rho@z  # First recipient really executed before handoff.
                at_cut = np.kron(rho, np.diag([1, 0]))
                assert np.max(abs(rs.data()['before_handoff'][j].data-at_cut)) < 1e-10
                assert number >> traced.num_clbits == 0
                for bit in h[before:]:
                    rho = apply(maps[r, bit], rho); probability = np.trace(rho).real
                    assert probability > 0; rho /= probability; r = 1^(r^bit)
                flag = h[0]^h[-1]
                if flag:
                    rho = z@rho@z
                index = source['goal']['states'].index(f'{r}{h[0]}{h[-1]}')
                cls = plans['agreement']['certificate']['classes'][index]
                assert number & 7 == cls and (number >> 9)&7 == cls
                assert (number >> 3)&7 == 0  # old snapshot was actually cleared
                error = max(error, float(np.max(abs(rs.data()['continued'][j].data-rho))))
                assert error < 1e-10; count += 1; seen.add(cls); flags.add((h[0], flag))
            maximum = max(maximum, error)
            cases.append({'before_contacts': before, 'after_contacts': after,
                'fixture': [theta, phi], 'classes_encountered': sorted(seen),
                'recipient_flag_pairs_encountered': sorted(flags), 'maximum_state_residual': error,
                'profile': flat.check_flat_fragment(qc, allow_snapshot=True),
                'allocated_controller_bits': 3, 'active_bits_before_and_after': [2, 3]})
    return {'circuits': len(cases), 'shots_each': shots, 'states_checked': count,
            'additional_pre_handoff_probe_and_payload_states_checked': count,
            'maximum_state_residual': maximum, 'cases': cases,
            'scope': 'Two recipients on the same retained quantum payload in one local execution; no quantum transfer between jobs.'}


def guards(source, plans):
    refused = []
    def no(label, callback):
        try:
            callback()
        except (ValueError, AssertionError):
            refused.append(label); return
        raise AssertionError('Accepted '+label)
    bad = deepcopy(source); bad['after_first']['reply0'][0] ^= 1
    no('changed contact constructor', lambda: acquire.first_to_agreement(bad, plans))
    bad_plans = deepcopy(plans); bad_plans['agreement'] = bad_plans['first']
    no('destination question substituted', lambda: acquire.first_to_agreement(source, bad_plans))
    gate = fixture(1.3, -.8)[0]
    no('handoff without a new contact', lambda: acquire.compile(source, plans, gate, 3, 0))
    no('unbounded compiled horizon', lambda: acquire.compile(source, plans, gate, 32, 33))
    return refused


def run(output):
    started = time.perf_counter()
    source = json.loads((output/'acquisition-reading.json').read_text())
    plans = json.loads((goal.ROOT/'Research/Artifacts/resident-goal-memory-20260915/plans.json').read_text())
    result = {'contact_relations': contact_relations(source, plans),
        'first_to_agreement': acquire.first_to_agreement(source, plans),
        'locality_boundary': locality_boundary(), 'SDK': sdk(source, plans),
        'refusals': guards(source, plans), 'seconds': time.perf_counter()-started,
        'new_QPU_jobs': 0, 'source_sha256': source['source_sha256'],
        'implementation_sha256': digest(Path(acquire.__file__)), 'check_sha256': digest(Path(__file__))}
    write(output/'audit.json', result); return result


if __name__ == '__main__':
    p = argparse.ArgumentParser(description=__doc__); p.add_argument('--output', type=Path, required=True)
    r = run(p.parse_args().output.resolve())
    print(json.dumps({'states': r['SDK']['states_checked'], 'maximum_error': r['SDK']['maximum_state_residual'],
        'seconds': r['seconds'], 'refusals': len(r['refusals'])}))
