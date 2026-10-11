#!/usr/bin/env python3
"""Independent instruction-level branch audit of the returning learner."""
from copy import deepcopy
import io
import json
from pathlib import Path
import time

import numpy as np
from qiskit import QuantumCircuit, qpy
from qiskit.circuit.library import HGate, RYGate
from qiskit.quantum_info import Operator, Statevector
from qiskit_aer import AerSimulator
from qiskit_aer.library import save_density_matrix

from resident_goal_instrument_audit import expand
import returning_attempt_learning as learning
from returning_attempt_sdk import ReturningAssembly, Ports

OUT = learning.ROOT / 'Research/Artifacts/returning-attempt-20260916/sdk'


def read_instrument(circuit, ports, *, final_layout=None, checkpoints=True):
    """Maps from ALL four retained qubits; no assumed Bell or law input."""
    assert circuit.num_qubits == 5
    retained = [ports.law_a, ports.law_b, ports.data, ports.later_data]
    rowmap = [sum(((x >> i) & 1) << w for i, w in enumerate(retained)) for x in range(16)]
    initial = np.zeros((32, 16), complex)
    initial[rowmap] = np.eye(16)
    branches = [{'map': initial, 'bits': [0] * circuit.num_clbits, 'snapshots': {}}]
    cache = {}

    def visit(body, active, wires, cbits):
        for item in body.data:
            op = item.operation
            qs = [wires[body.find_bit(b).index] for b in item.qubits]
            cs = [cbits[body.find_bit(b).index] for b in item.clbits]
            if op.name == 'barrier':
                if op.label and checkpoints:
                    for branch in active:
                        absent = [i for i in range(32) if (i >> ports.probe) & 1]
                        assert np.max(abs(branch['map'][absent])) < 1e-12
                        branch['snapshots'][op.label] = branch['map'][rowmap].copy()
            elif op.name == 'if_else':
                assert isinstance(op.condition, tuple)
                bit, wanted = op.condition
                # Actual condition bit identity is resolved in the block scope.
                index = cbits[body.find_bit(bit).index]
                after = []
                for branch in active:
                    k = 0 if branch['bits'][index] == wanted else 1
                    after.extend(visit(op.blocks[k], [branch], qs, cs)
                                 if k < len(op.blocks) else [branch])
                active = after
            elif op.name in ('measure', 'measure_2', 'reset'):
                if final_layout is None:
                    assert qs == [ports.probe], 'Retained input measured/reset'
                if op.name == 'measure_2':
                    assert op.num_qubits == op.num_clbits == 1 and not op.params and op.definition is None
                after = []
                for branch in active:
                    for b in (0, 1):
                        local = np.zeros((2, 2), complex)
                        local[0 if op.name == 'reset' else b, b] = 1
                        mapped = expand(local, qs) @ branch['map']
                        if np.max(abs(mapped)) < 1e-13:
                            continue
                        new = {'map': mapped, 'bits': list(branch['bits']),
                               'snapshots': dict(branch['snapshots'])}
                        if op.name != 'reset':
                            new['bits'][cs[0]] = b
                        after.append(new)
                active = after
            else:
                assert op.name in ('cx', 'cz', 'h', 'ry', 'rz', 's', 'sx', 'z', 'x', 'id')
                matrix = Operator(op).data
                key = (tuple(qs), matrix.tobytes())
                if key not in cache:
                    cache[key] = expand(matrix, qs)
                for branch in active:
                    branch['map'] = cache[key] @ branch['map']
        return active

    rows = visit(circuit, branches, list(range(5)), list(range(circuit.num_clbits)))
    if final_layout is not None:
        assert sorted(final_layout) == list(range(5))
        rowmap = [sum(((x >> i) & 1) << final_layout[w] for i, w in enumerate(retained))
                  for x in range(16)]
    absent = sorted(set(range(32)) - set(rowmap))
    for row in rows:
        assert np.max(abs(row['map'][absent])) < 1e-11, 'Probe was not returned at the final boundary'
        row['map'] = row['map'][rowmap]
    return rows


def projector(a=None, b=None):
    return np.diag([int((a is None or x & 1 == a) and
                        (b is None or (x >> 1) & 1 == b)) for x in range(16)])


def audit(q, ports, gates, *, acquired=True):
    rows = read_instrument(q, ports)
    g0 = expand(Operator(gates[0]).data, [2], 4)
    g1 = expand(Operator(gates[1]).data, [3], 4)
    worst = 0.
    complete = np.zeros((16, 16), complex)
    for row in rows:
        if acquired:
            b, p = row['bits']
            a = b ^ p
            law = projector(a, b)
            wanted = {'returned_B': projector(b=b), 'returned_Parity': law,
                      'worked_first': g0 @ law, 'worked_later': g1 @ g0 @ law}
        else:
            law = np.eye(16)
            wanted = {'echo_first': g0, 'echo_later': g1 @ g0}
        for name, matrix in wanted.items():
            worst = max(worst, float(np.max(abs(row['snapshots'][name] - matrix))))
        worst = max(worst, float(np.max(abs(row['map'] - g1 @ g0 @ law))))
        complete += row['map'].conj().T @ row['map']
    assert worst < 1e-11, f'Full branch mismatch {worst}'
    assert np.max(abs(complete - np.eye(16))) < 1e-11
    return {'branches': len(rows), 'input_dimension': 16, 'max_operator_residual': worst,
            'complete': True, 'checkpoints_per_branch': 4 if acquired else 2}


def sample(q, ports, gates, *, acquired=True):
    """Separate Aer check with TWO retained Bell references, all four laws."""
    worst = 0.
    for a in (0, 1):
        for b in (0, 1):
            full = QuantumCircuit(7)
            if a: full.x(ports.law_a)
            if b: full.x(ports.law_b)
            full.h(ports.data); full.cx(ports.data, 5)
            full.h(ports.later_data); full.cx(ports.later_data, 6)
            for reg in q.cregs: full.add_register(reg)
            full.compose(q, qubits=range(5), inplace=True)
            kept = [ports.data, 5, ports.later_data, 6]
            save_density_matrix(full, kept, label='kept', pershot=True)
            ideal = QuantumCircuit(4)
            ideal.h(0); ideal.cx(0, 1); ideal.h(2); ideal.cx(2, 3)
            ideal.append(gates[0], [0]); ideal.append(gates[1], [2])
            v = Statevector.from_instruction(ideal).data
            expected = np.outer(v, v.conj())
            result = AerSimulator(method='statevector', max_parallel_threads=1).run(
                full, shots=8, memory=True, seed_simulator=91651).result()
            assert result.success
            if acquired:
                assert all(int(x.replace(' ', ''), 2) == b + 2*(a ^ b)
                           for x in result.get_memory())
            for density in result.data()['kept']:
                worst = max(worst, float(np.max(abs(density.data - expected))))
    assert worst < 1e-11
    return {'law_cases': 4, 'shots_each': 8, 'two_Bell_references_residual': worst}


def negative_cases(source, cert, gates):
    failures = []
    def reject(name, f):
        try: f()
        except (ValueError, AssertionError): failures.append(name)
        else: raise AssertionError('Accepted ' + name)
    reject('working before acquisition', lambda: ReturningAssembly(source).apply(gates[0]))
    reject('missing return reserve', lambda: ReturningAssembly(source, reserve=1).acquire(cert))
    bad = deepcopy(cert); bad['tree']['branches']['0']['branches']['1']['control'] = 0
    reject('invented answer', lambda: ReturningAssembly(source).acquire(bad))
    reject('data/probe alias', lambda: ReturningAssembly(source, ports=Ports(data=0)))
    original = ReturningAssembly(source); original.acquire(cert)
    original.apply(gates[0]); original.apply(gates[1], later=True)
    q = original.program()
    # Omit the first actual correction. Correct later truth table alone cannot
    # repair this omitted physical action on the first payload.
    broken = q.copy_empty_like(); skipped = False
    for item in q.data:
        if item.operation.name == 'if_else' and not skipped:
            skipped = True
        else: broken.append(item)
    reject('omitted actual repair', lambda: audit(broken, Ports(), gates))
    # A wrong, but existing, law port does not certify common source continuity.
    broken = q.copy_empty_like()
    for item in q.data:
        if item.operation.name == 'cz' and item.qubits == (q.qubits[1], q.qubits[4]):
            broken.cz(2, 4)
        else: broken.append(item)
    reject('later work on another law', lambda: audit(broken, Ports(), gates))
    return failures


def run():
    started = time.perf_counter()
    source = learning.read_source()
    cert = learning.synthesize(source)
    gates = (HGate(), RYGate(2*np.arctan2(4, 3)))
    OUT.mkdir(parents=True, exist_ok=True)
    cases = []
    for ports in (Ports(), Ports(4, 2, 0, 1, 3)):
        for acquired in (True, False):
            assembly = ReturningAssembly(source, ports=ports)
            if acquired:
                assembly.acquire(cert)
                assembly.apply(gates[0]); assembly.apply(gates[1], later=True)
            else:
                assembly.echo(gates[0]); assembly.echo(gates[1], later=True)
            q = assembly.program()
            buffer = io.BytesIO(); qpy.dump(q, buffer)
            data = buffer.getvalue(); buffer.seek(0)
            restored, = qpy.load(buffer)
            result = audit(restored, ports, gates, acquired=acquired)
            result.update(sample(restored, ports, gates, acquired=acquired))
            name = ('acquired' if acquired else 'echo') + '-' + str(ports.probe)
            (OUT / (name + '.qpy')).write_bytes(data)
            result.update(name=name, ports=vars(ports), QPY_sha256=learning.hashlib.sha256(data).hexdigest(),
                          actual_measurements=2 if acquired else 0,
                          service_calls=2 if acquired else 4)
            cases.append(result)
    out = {'schema': 'vi.returning-attempt-sdk-checks.v1', 'source': learning.fingerprint(source),
           'cases': cases, 'negative_cases': negative_cases(source, cert, gates),
           'runtime_seconds': time.perf_counter()-started, 'new_QPU_jobs': 0,
           'scope': 'Branch operators on arbitrary input, including external references; fixed classical law. '
                    'QPY/Aer checked. No hardware or continuous live-session claim.'}
    (OUT / 'checks.json').write_text(json.dumps(out, indent=2)+'\n')
    print(json.dumps(out, indent=2))


if __name__ == '__main__': run()
