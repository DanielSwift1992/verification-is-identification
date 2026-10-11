#!/usr/bin/env python3
"""Read every unnormalised branch on all five retained quantum inputs.

No true law or arrival is passed to the builder. The verifier compares the
emitted instruction maps with an independently written instrument contract.
"""
import io
import itertools
import json
import time

import numpy as np
from qiskit import QuantumCircuit, qpy
from qiskit.circuit import IfElseOp
from qiskit.circuit.classical import expr
from qiskit.circuit.library import HGate, SGate, RYGate
from qiskit.quantum_info import Operator, Statevector
from qiskit_aer import AerSimulator
from qiskit_aer.library import save_density_matrix

import returning_attempt_learning as learning
import returning_boundary_admission as boundary
from resident_goal_instrument_audit import expand
from returning_attempt_arrival import ArrivalAssembly, ArrivalPorts

OUT = learning.ROOT / 'Research/Artifacts/returning-attempt-20260916/arrival'
GATES = (HGate(), SGate(), HGate(), RYGate(2*np.arctan2(4, 3)), SGate())


def read_instrument(q, ports, *, reply_overrides=None):
    """P=0, arbitrary AB D R C: 64x32 maps, with immutable actual records.

    reply_overrides injects classical probe-readout faults for a separate idle
    safety check. It never overrides the acquired arrival bit.
    """
    assert q.num_qubits == 6 and q.num_clbits == 3
    ports.validate()
    kept = [ports.law_a, ports.law_b, ports.data, ports.reference, ports.arrival]
    rowmap = [sum(((x >> i) & 1) << w for i, w in enumerate(kept)) for x in range(32)]
    absent = sorted(set(range(64)) - set(rowmap))
    initial = np.zeros((64, 32), complex)
    initial[rowmap] = np.eye(32)
    rows = [{'map': initial, 'bits': [0, 0, 0], 'written': set(), 'snapshots': {}}]
    cache = {}

    def lifted(matrix, wires):
        key = (tuple(wires), matrix.tobytes())
        if key not in cache:
            cache[key] = expand(matrix, wires, 6)
        return cache[key]

    def value(node, bits, body, cbits):
        if isinstance(node, expr.Value):
            return node.value
        if isinstance(node, expr.Var):
            return bits[cbits[body.find_bit(node.var).index]]
        if isinstance(node, expr.Binary) and node.op.name == 'LOGIC_AND':
            return bool(value(node.left, bits, body, cbits) and
                        value(node.right, bits, body, cbits))
        raise ValueError('Unsupported classical condition')

    def visit(body, active, wires, cbits, inside=False):
        for item in body.data:
            op = item.operation
            qs = [wires[body.find_bit(b).index] for b in item.qubits]
            cs = [cbits[body.find_bit(b).index] for b in item.clbits]
            if op.name == 'if_else':
                assert not inside, 'Nested control is outside the lowering contract'
                after = []
                for row in active:
                    if isinstance(op.condition, tuple):
                        bit, wanted = op.condition
                        yes = row['bits'][cbits[body.find_bit(bit).index]] == wanted
                    else:
                        yes = value(op.condition, row['bits'], body, cbits)
                    k = 0 if yes else 1
                    after.extend(visit(op.blocks[k], [row], qs, cs, True)
                                 if k < len(op.blocks) else [row])
                active = after
            elif op.name == 'barrier':
                if op.label:
                    for row in active:
                        assert np.max(abs(row['map'][absent])) < 1e-11, 'Scratch not returned'
                        assert op.label not in row['snapshots'], 'Duplicate boundary'
                        row['snapshots'][op.label] = row['map'][rowmap].copy()
            elif op.name in ('measure', 'reset'):
                assert not inside, 'Measurement/reset inside condition'
                if op.name == 'reset':
                    assert qs == [ports.probe], 'Reset of retained input'
                else:
                    assert ((qs == [ports.arrival] and cs == [0]) or
                            (qs == [ports.probe] and cs in ([1], [2]))), 'Wrong record origin'
                after = []
                for row in active:
                    for b in (0, 1):
                        local = np.zeros((2, 2), complex)
                        local[0 if op.name == 'reset' else b, b] = 1
                        matrix = lifted(local, qs) @ row['map']
                        if np.max(abs(matrix)) < 1e-13:
                            continue
                        new = {'map': matrix, 'bits': list(row['bits']),
                               'written': set(row['written']), 'snapshots': dict(row['snapshots'])}
                        if op.name == 'measure':
                            assert cs[0] not in new['written'], 'Overwritten acquired record'
                            new['written'].add(cs[0])
                            new['bits'][cs[0]] = (reply_overrides or {}).get(cs[0], b) if cs[0] else b
                        after.append(new)
                active = after
            else:
                assert op.name in ('cx', 'cz', 'h', 's', 'id', 'ry', 'rz', 'sx', 'z', 'x')
                assert ports.reference not in qs, 'Reference is not a working port'
                matrix = lifted(Operator(op).data, qs)
                for row in active:
                    row['map'] = matrix @ row['map']
        return active

    rows = visit(q, rows, list(range(6)), list(range(3)))
    for row in rows:
        assert np.max(abs(row['map'][absent])) < 1e-11
        row['map'] = row['map'][rowmap]
    return rows


def projection(*, request=None, a=None, b=None):
    return np.diag([int((request is None or ((x >> 4) & 1) == request) and
                        (a is None or (x & 1) == a) and
                        (b is None or ((x >> 1) & 1) == b)) for x in range(32)])


def expected(bits, acquired, recipient):
    request, b, p = bits
    a = b ^ p
    current = np.eye(32, dtype=complex)
    snapshots = {}
    for i, gate in enumerate(GATES[:3], 1):
        current = expand(Operator(gate).data, [2], 5) @ current
        snapshots['echo_' + str(i)] = current.copy()
    snapshots['arrival_read'] = projection(request=request) @ current
    if acquired:
        snapshots['returned_B'] = projection(request=request, b=b if request else None) @ current
        snapshots['returned_Parity'] = projection(request=request, a=a if request else None,
                                                  b=b if request else None) @ current
    law = projection(request=request, a=a if request and acquired else None,
                     b=b if request and acquired else None)
    if request:
        current = expand(Operator(GATES[3]).data, [2], 5) @ current
    current = law @ current
    snapshots['conditional_exit'] = current.copy()
    if recipient:
        current = expand(Operator(GATES[4]).data, [2], 5) @ current
        snapshots['recipient_exit'] = current.copy()
    return current, snapshots


def audit(q, ports, *, acquired, recipient):
    rows = read_instrument(q, ports)
    complete = np.zeros((32, 32), complex)
    worst = 0.
    for row in rows:
        assert row['written'] == ({0, 1, 2} if acquired else {0})
        request, b, p = row['bits']
        assert request or b == p == 0, 'Idle branch acquired a law record'
        want, snapshots = expected(row['bits'], acquired, recipient)
        assert row['snapshots'].keys() == snapshots.keys()
        worst = max(worst, float(np.max(abs(row['map'] - want))))
        for name, matrix in snapshots.items():
            worst = max(worst, float(np.max(abs(row['snapshots'][name] - matrix))))
        complete += row['map'].conj().T @ row['map']
    assert len(rows) == (5 if acquired else 2)
    assert worst < 1e-11, f'Instrument or boundary mismatch: {worst}'
    assert np.max(abs(complete - np.eye(32))) < 1e-11
    return {'retained_input_dimension': 32, 'branches': len(rows),
            'max_operator_residual': worst, 'probability_complete': True,
            'snapshots_per_branch': len(rows[0]['snapshots'])}


def sample(q, ports, *, acquired, recipient):
    """Aer: coherent A,B,C; D entangled with the same retained reference."""
    kept = [ports.law_a, ports.law_b, ports.data, ports.reference, ports.arrival]
    logical = QuantumCircuit(5)
    logical.h(0); logical.h(1); logical.h(2); logical.cx(2, 3); logical.h(4)
    vector = Statevector.from_instruction(logical).data
    full = QuantumCircuit(6)
    full.compose(logical, qubits=kept, inplace=True)
    for reg in q.cregs:
        full.add_register(reg)
    full.compose(q, inplace=True)
    # Save sorted physical ports; permute their density matrix to logical order.
    physical = sorted(kept)
    save_density_matrix(full, physical, label='retained', pershot=True)
    result = AerSimulator(method='statevector', max_parallel_threads=1).run(
        full, shots=32, memory=True, seed_simulator=91661).result()
    assert result.success
    index = [sum(((x >> i) & 1) << physical.index(w) for i, w in enumerate(kept)) for x in range(32)]
    worst = 0.
    seen = set()
    for density, record in zip(result.data()['retained'], result.get_memory()):
        number = int(record.replace(' ', ''), 2)
        bits = [(number >> i) & 1 for i in range(3)]
        seen.add(tuple(bits))
        matrix, _ = expected(bits, acquired, recipient)
        v = matrix @ vector
        probability = np.vdot(v, v).real
        assert probability > 1e-12
        want = np.outer(v, v.conj()) / probability
        actual = density.data[np.ix_(index, index)]
        worst = max(worst, float(np.max(abs(actual - want))))
    assert worst < 1e-11, f'Aer branch mismatch: {worst}'
    return {'Aer_shots': 32, 'sampled_records': sorted(seen), 'Aer_density_residual': worst}


def build(source, cert, future, ports=ArrivalPorts(), *, reserve=2, recipient=True):
    assembly = ArrivalAssembly(source, cert, future, ports=ports, reserve=reserve)
    for gate in GATES[:3]:
        assembly.prefix(gate)
    assembly.observe_arrival(GATES[3])
    if recipient:
        assembly.receive(GATES[4])
    return assembly.program(), assembly.can_acquire


def inline_first_contact(q):
    broken = q.copy_empty_like()
    replaced = False
    for item in q.data:
        if item.operation.name == 'if_else' and not replaced:
            body = item.operation.blocks[0]
            for instruction in body.data:
                broken.append(instruction.operation,
                              [item.qubits[body.find_bit(b).index] for b in instruction.qubits],
                              [item.clbits[body.find_bit(b).index] for b in instruction.clbits])
            replaced = True
        else:
            broken.append(item)
    assert replaced
    return broken


def continuation_algebra(q):
    """Remove known conditional work; derive the actual pinching blocks.

    This establishes a maximal recoverable question algebra, not merely a list
    of examples fixed by one convenient decoder. The report proves maximality.
    """
    rows = read_instrument(q, ArrivalPorts())
    target = sum(expected(bits, False, True)[0] for bits in ([0,0,0], [1,0,0]))
    assert np.max(abs(target.conj().T @ target - np.eye(32))) < 1e-11
    residual = [target.conj().T @ row['map'] for row in rows]
    for i, p in enumerate(residual):
        assert np.max(abs(p - p.conj().T)) < 1e-11
        assert np.max(abs(p @ p - p)) < 1e-11
        for other in residual[:i]:
            assert np.max(abs(p @ other)) < 1e-11
    assert np.max(abs(sum(residual) - np.eye(32))) < 1e-11
    ranks = [int(round(np.trace(p).real)) for p in residual]
    witnesses = []
    for name, i, j, survives in (
            ('law B coherence when arrival=0', 0, 2, True),
            ('law B coherence when arrival=1', 16, 18, False),
            ('coherence between different arrivals', 0, 16, False)):
        plus = np.zeros(32, complex); plus[i] = plus[j] = 1/np.sqrt(2)
        minus = plus.copy(); minus[j] *= -1
        rho0 = np.outer(plus, plus.conj()); rho1 = np.outer(minus, minus.conj())
        # Keeping every real classical record still cannot separate a killed pair.
        difference = sum(np.linalg.norm(k @ (rho0-rho1) @ k.conj().T, ord='nuc')/2 for k in residual)
        assert abs(difference-int(survives)) < 1e-11
        witnesses.append({'question':name, 'input_discriminating_probabilities':[1,0],
                          'full_classical_quantum_output_trace_distance':float(difference)})
    return {'block_ranks':ranks, 'retained_Hilbert_dimension':32,
            'maximal_question_dimension':sum(r*r for r in ranks),
            'erased_Hermitian_dimension':1024-sum(r*r for r in ranks),
            'normal_form':'M_16 direct-sum four copies of M_4',
            'witnesses':witnesses}


def unguard_corrections(q):
    broken = q.copy_empty_like()
    for item in q.data:
        op = item.operation
        if op.name == 'if_else' and isinstance(op.condition, expr.Binary):
            op = IfElseOp((op.condition.right.var, 1), op.blocks[0],
                          op.blocks[1] if len(op.blocks) > 1 else None)
            broken.append(op, item.qubits, item.clbits)
        else:
            broken.append(item)
    return broken


def run():
    started = time.perf_counter()
    source = learning.read_source()
    cert = learning.synthesize(source)
    data_future = boundary.future_questions(['II'+''.join(w) for w in itertools.product('IXYZ', repeat=2)], [])
    strong_future = boundary.future_questions(['IZII'], ['H_B'])
    OUT.mkdir(parents=True, exist_ok=True)
    cases = []
    programs = []
    for name, future, reserve, ports, recipient in (
            ('arrival', data_future, 2, ArrivalPorts(), False),
            ('recipient', data_future, 2, ArrivalPorts(), True),
            ('permuted', data_future, 2, ArrivalPorts(5, 2, 4, 0, 3, 1), True),
            ('strong-future', strong_future, 2, ArrivalPorts(), True),
            ('one-return', data_future, 1, ArrivalPorts(), True)):
        q, acquired = build(source, cert, future, ports, reserve=reserve, recipient=recipient)
        buffer = io.BytesIO(); qpy.dump(q, buffer); data = buffer.getvalue(); buffer.seek(0)
        restored, = qpy.load(buffer)
        checked = audit(restored, ports, acquired=acquired, recipient=recipient)
        checked.update(sample(restored, ports, acquired=acquired, recipient=recipient))
        checked.update(name=name, acquisition_enabled=acquired,
                       ports=vars(ports), QPY_sha256=learning.hashlib.sha256(data).hexdigest())
        (OUT / (name+'.qpy')).write_bytes(data)
        cases.append(checked)
        programs.append(restored)

    q = programs[1]
    idle_residual = 0.
    for b, p in itertools.product((0, 1), repeat=2):
        idle = [r for r in read_instrument(q, ArrivalPorts(), reply_overrides={1:b, 2:p}) if not r['bits'][0]]
        assert len(idle) == 1
        want, _ = expected([0, 0, 0], True, True)
        idle_residual = max(idle_residual, float(np.max(abs(idle[0]['map'] - want))))
    assert idle_residual < 1e-11

    # This mutant passes the entire IDEAL instrument check, but fails the
    # declared idle readout-fault contract. Keep those two claims separate.
    unguarded = unguard_corrections(q)
    audit(unguarded, ArrivalPorts(), acquired=True, recipient=True)
    bad_idle = [r for r in read_instrument(unguarded, ArrivalPorts(), reply_overrides={1:1, 2:0})
                if not r['bits'][0]]
    want, _ = expected([0,0,0], True, True)
    unguarded_error = float(np.max(abs(bad_idle[0]['map'] - want)))
    assert unguarded_error > 1
    algebra = continuation_algebra(q)

    rejected = []
    def reject(name, f):
        try:
            f()
        except (AssertionError, ValueError):
            rejected.append(name)
        else:
            raise AssertionError('Accepted negative control: '+name)
    reject('unconditional law contact destroys inactive coherence',
           lambda: audit(inline_first_contact(q), ArrivalPorts(), acquired=True, recipient=True))
    missing = q.copy_empty_like()
    for item in q.data:
        if item.operation.name == 'measure' and item.clbits == (q.clbits[0],):
            continue
        missing.append(item)
    reject('host-default zero substituted for the acquired arrival',
           lambda: audit(missing, ArrivalPorts(), acquired=True, recipient=True))
    reset = q.copy(); reset.reset(ArrivalPorts().data)
    reject('reprepare retained payload', lambda: audit(reset, ArrivalPorts(), acquired=True, recipient=True))
    reject('aliased arrival and data', lambda: ArrivalPorts(arrival=3).validate())
    reject('acquire before three completed tasks',
           lambda: ArrivalAssembly(source, cert, data_future).observe_arrival(GATES[3]))
    reject('wrong claimed admission for the strong future',
           lambda: audit(programs[3], ArrivalPorts(), acquired=True, recipient=True))

    result = {'schema':'vi.returning-attempt-arrival-checks.v1',
              'source': learning.fingerprint(source), 'cases':cases,
              'idle_probe_readout_fault_cases':4, 'idle_guard_residual':idle_residual,
              'unguarded_mutant':{'passes_ideal_instrument':True,
                                  'idle_readout_fault_operator_error':unguarded_error},
              'derived_continuation_algebra':algebra,
              'negative_controls':rejected, 'new_QPU_jobs':0,
              'runtime_seconds':time.perf_counter()-started,
              'scope':'Five complete input qubits plus returned zero scratch. Ideal unnormalised '
                      'instruments include all input/reference correlations. Fixed finite gates, '
                      'explicit arrival measurement; no all-horizon hardware-cost bound.'}
    (OUT/'checks.json').write_text(json.dumps(result, indent=2)+'\n')
    print(json.dumps(result, indent=2))


if __name__ == '__main__':
    run()
