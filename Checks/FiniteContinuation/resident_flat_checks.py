#!/usr/bin/env python3
"""Audit flat control and an acquired output against actual branch histories."""
import argparse
import io
import json
from pathlib import Path
import time

import numpy as np
from qiskit import ClassicalRegister, QuantumCircuit, qpy
from qiskit_aer import AerSimulator

import resident_flat_controller as flat
import resident_goal_compiler as goal
from resident_goal_checks import question
from resident_raw_reply_checks import fixture
from resident_stream_checks import operators, trajectory
import whole_word_admission as admission
from environment import write, digest


def history_audit(q, contacts):
    # Test-only Stores copy already acquired replies; no new quantum contact.
    out = next(c for c in q.cregs if c.name == 'out')
    t = q.copy_empty_like(); h = ClassicalRegister(contacts, 'audit_history'); t.add_register(h)
    index = 0
    for item in q.data:
        t.append(item)
        if item.operation.name == 'measure' and item.clbits == (out[0],):
            t.store(h[index], out[0]); index += 1
    assert index == contacts
    return t


def syntax_refusals(source, plans):
    refused = []
    def no(name, q):
        try:
            flat.check_flat_fragment(q, allow_snapshot=True)
        except ValueError:
            refused.append(name); return
        raise AssertionError('Accepted ' + name)
    gate = fixture(1.3, -.8)[0]
    no('unlowered loop and switch', goal.compile(source, plans['agreement'], gate, 3))
    q = QuantumCircuit(1, 2)
    with q.if_test((q.clbits[0], 1)):
        with q.if_test((q.clbits[1], 1)):
            q.x(0)
    no('nested if', q)
    for operation in ('reset', 'measure'):
        q = QuantumCircuit(1, 1)
        with q.if_test((q.clbits[0], 1)):
            q.reset(0) if operation == 'reset' else q.measure(0, 0)
        no('conditional ' + operation, q)
    q = QuantumCircuit(1, 33)
    with q.if_test((q.cregs[0], 1)):
        q.x(0)
    no('33-bit conditional operand', q)
    return refused


def selector_witnesses(source, plans):
    result = {}
    for name, plan in plans.items():
        ctl = goal.interpret(source, plan); witness = None
        for old in range(ctl['size']):
            for bit in (0, 1):
                state = old; executed = []
                for cls in range(ctl['size']):
                    if state == cls:
                        executed.append(cls)
                        state = ctl['next']['reply' + str(bit)][cls]
                if len(executed) != 1:
                    witness = {'initial_class': old, 'reply': bit, 'executed_cases': executed,
                               'naive_final_class': state,
                               'required_final_class': ctl['next']['reply' + str(bit)][old]}
                    break
            if witness:
                break
        assert witness
        result[name] = witness
    return result


def export_identity():
    # Independent full CQ Kraus calculation including an arbitrary reference.
    # For each classical class, the new output must be deterministic and the
    # complete quantum operator unchanged, including off-diagonal entries.
    rng = np.random.default_rng(67411); maximum = 0.; count = 0
    for width in (1, 2, 3):
        for cls in range(2**width):
            a = rng.normal(size=(16, 16)) + 1j*rng.normal(size=(16, 16))
            rho = a@a.conj().T; rho /= np.trace(rho)
            out = rho.copy()
            for bit in range(width):
                probe = np.array([1, 0], dtype=complex)
                if (cls >> bit) & 1:
                    probe = admission.X@probe
                actual = []
                for reading in (0, 1):
                    branch = abs(probe[reading])**2*out
                    expected = out if reading == (cls >> bit)&1 else np.zeros_like(out)
                    maximum = max(maximum, float(np.max(abs(branch - expected))))
                    actual.append(branch)
                out = sum(actual); count += 2
            assert np.max(abs(out-rho)) < 1e-12
    return {'selective_full_quantum_blocks': count, 'maximum_residual': maximum,
            'scope': 'Ideal reset/controlled-X/measurement on a disposable probe, 16-dimensional quantum payload including reference.'}


def audit_sdk(source, plans, strategy):
    result = []; states = 0; maximum = 0.; shots = 128
    z = np.kron(admission.I, np.kron(admission.Z, np.eye(4)))
    for theta, phi in ((1.3, -.8), (1.45, .91)):
        gate, ks, _ = fixture(theta, phi); maps = operators(source['raw'], ks)
        for name, plan in plans.items():
            ctl = goal.interpret(source, plan); width = ctl['width']
            for n in (1, 3, 16, 64):
                qc = flat.compile(source, plan, gate, n, snapshot=True, strategy=strategy)
                profile = flat.check_flat_fragment(qc, allow_snapshot=True)
                q = history_audit(qc, n)
                r = AerSimulator(method='statevector', max_parallel_threads=1).run(
                    q, shots=shots, seed_simulator=2497+n, memory=True).result()
                assert r.success
                quantum = r.data()['continued']; error = 0.; seen = set()
                for j, record in enumerate(r.get_memory()):
                    number = int(record.replace(' ', ''), 2)
                    history = tuple((number >> (qc.num_clbits+i))&1 for i in range(n))
                    relative, rho = trajectory(maps, history); flag = question(name, history)
                    if flag:
                        rho = z@rho@z
                    index = source['states'].index(f'{relative}{history[0]}{history[-1]}')
                    cls = plan['certificate']['classes'][index]; seen.add(cls)
                    mask = (1 << width)-1
                    live = number & mask
                    acquired = (number >> (2*width+3)) & mask
                    last_reply = (number >> (2*width)) & 1
                    assert live == acquired == cls and last_reply == history[-1]
                    assert ctl['observation'][acquired] == [relative, flag]
                    e = float(np.max(abs(quantum[j].data-rho)))
                    assert e < 1e-10; error = max(error, e); states += 1
                maximum = max(maximum, error); stream = io.BytesIO(); qpy.dump(qc, stream)
                result.append({'goal': name, 'contacts': n, 'fixture': [theta, phi], 'strategy': strategy,
                    'width': width, 'profile': profile, 'QPY_bytes': len(stream.getvalue()),
                    'classes_encountered': sorted(seen), 'maximum_state_residual': error,
                    'acquired_class_matches_live_class_and_history': True,
                    'counts': r.get_counts() if n == 1 else None})
    return {'circuits': len(result), 'shots_each': shots, 'states_checked': states,
            'maximum_state_residual': maximum, 'cases': result,
            'scope': 'Aer trajectories with a test-only classical history copy; not hardware results.'}


def run(output):
    source_path = goal.ROOT/'Research/Artifacts/resident-goal-memory-20260915'
    source = json.loads((source_path/'goal-reading.json').read_text())
    plans = json.loads((source_path/'plans.json').read_text())
    started = time.perf_counter()
    output.mkdir(parents=True, exist_ok=True)
    audits = [audit_sdk(source, plans, strategy) for strategy in ('cases', 'affine')]
    combined = {'circuits': sum(x['circuits'] for x in audits), 'shots_each': audits[0]['shots_each'],
        'states_checked': sum(x['states_checked'] for x in audits),
        'maximum_state_residual': max(x['maximum_state_residual'] for x in audits),
        'cases': [case for audit in audits for case in audit['cases']], 'scope': audits[0]['scope']}
    affine_refused = []
    for label, table, width in [('nonlinear AND', [0, 0, 0, 1], 2), ('missing table row', [0, 1, 1], 2)]:
        try:
            flat.affine(table, width)
        except ValueError:
            affine_refused.append(label)
        else:
            raise AssertionError('Accepted ' + label)
    result = {'SDK': combined, 'export_identity': export_identity(),
        'affine_control': {name: flat.affine_control(source, plan) for name, plan in plans.items()},
        'affine_refusals': affine_refused,
        'syntax_refusals': syntax_refusals(source, plans),
        'selector_overwrite_witnesses': selector_witnesses(source, plans),
        'seconds': time.perf_counter()-started, 'new_QPU_jobs': 0,
        'source_sha256': source['source_sha256'],
        'implementation_sha256': digest(Path(flat.__file__)), 'check_sha256': digest(Path(__file__))}
    write(output/'local-audit.json', result)
    return result


if __name__ == '__main__':
    p = argparse.ArgumentParser(description=__doc__); p.add_argument('--output', type=Path, required=True)
    r = run(p.parse_args().output.resolve())
    print(json.dumps({'states': r['SDK']['states_checked'], 'maximum_error': r['SDK']['maximum_state_residual'],
                      'seconds': r['seconds'], 'refusals': len(r['syntax_refusals'])}))
