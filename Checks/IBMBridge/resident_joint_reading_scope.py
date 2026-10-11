#!/usr/bin/env python3
"""Local follow-up: substitutions depend on the permitted output reading.

No account, submission, collection, or change to the pending QPU experiment.
Use system Python for --symbolic, the existing SDK venv for --numeric.
"""
import argparse
import hashlib
import itertools
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / 'Research/Artifacts/resident-joint-reading-scope-20260915'


def symbolic():
    import sympy as s
    from resident_joint_branch_symbolic import embed

    a, b, c, d = s.symbols('a b c d', real=True)
    H = s.Matrix([[1, 1], [1, -1]]) / s.sqrt(2)
    S = s.diag(1, s.I)
    X = s.Matrix([[0, 1], [1, 0]])
    Y = s.Matrix([[0, -s.I], [s.I, 0]])
    Z = s.diag(1, -1)
    CZ = s.diag(1, 1, 1, -1)
    CX = s.Matrix([[1, 0, 0, 0], [0, 0, 0, 1],
                   [0, 0, 1, 0], [0, 1, 0, 0]])
    service = s.eye(8)
    for gate, wires in [(s.Matrix([[a, -b], [b, a]]), [0]), (CX, [1, 0]),
                        (CZ, [0, 2]), (s.Matrix([[c, -d], [d, c]]), [1]),
                        (CX, [2, 1])]:
        service = embed(gate, wires, 3) * service
    kraus = [service.extract(list(range(bit, 8, 2)), list(range(0, 8, 2)))
             for bit in (0, 1)]
    initial = s.zeros(16, 1)
    initial[0] = 1
    for gate, wires in [(H, [2]), (CX, [2, 3]), (H, [1]), (CX, [1, 0])]:
        initial = embed(gate, wires, 4) * initial
    obs = {f'{name}_{wire}': embed(gate, [wire], 4)
           for name, gate in [('X', X), ('Y', Y), ('Z', Z)] for wire in (2, 3)}
    obs['XY'] = embed(X, [2], 4) * embed(Y, [3], 4)
    obs['YY'] = embed(Y, [2], 4) * embed(Y, [3], 4)
    rows = {}
    for history in [(0, 0, 1, 0), (0, 1, 0, 0)]:
        v = initial
        relative = 0
        for bit in history:
            v = s.kronecker_product(s.eye(4), kraus[bit]) * v
            v = embed(H if (relative ^ bit) == 0 else S, [2], 4) * v
            v = embed(Z, [1], 4) * v
            v = (embed(CZ, [2, 1], 4) * v).applyfunc(s.expand)
            relative = 1 ^ relative ^ bit
        assert (relative, history[0], history[-1]) == (1, 0, 0)
        row = {name: s.factor(s.expand((v.conjugate().T * op * v)[0]))
               for name, op in obs.items()}
        assert all(row[name] == 0 for name in obs if name != 'YY')
        rows[''.join(map(str, history))] = row
    yy = s.factor(sum(row['YY'] for row in rows.values()))
    assert yy != 0
    rational = s.factor(yy.subs({a: s.Rational(3, 5), b: s.Rational(4, 5),
                                c: s.Rational(5, 13), d: -s.Rational(12, 13)}))
    assert rational != 0
    fixture = {a: s.cos(s.Rational(13, 20)), b: s.sin(s.Rational(13, 20)),
               c: s.cos(-s.Rational(2, 5)), d: s.sin(-s.Rational(2, 5))}
    return {'per_history': {h: {k: str(v) for k, v in row.items()} for h, row in rows.items()},
            'YY_polynomial': str(yy), 'YY_rational_normalized_example': str(rational),
            'YY_at_fixture': float(yy.subs(fixture).evalf(17)),
            'scope': 'Code 1, declared initial Bell preparations and real Ry/CX/CZ family; not all sources.',
            'sympy': s.__version__}


def numeric():
    import numpy as np
    from qiskit import QuantumCircuit
    from qiskit.quantum_info import DensityMatrix, Operator, Pauli, partial_trace
    import resident_joint_confirmation as p

    plan = p.read(p.ART / 'plan.json')
    for name, digest in plan['implementation'].items():
        if name.startswith('Checks/') and name.endswith(('.py', '.swift')):
            assert hashlib.sha256((ROOT / name).read_bytes()).hexdigest() == digest, name
    q, _, source, _ = p.logical('ignore')
    assert source['source_sha256'] == plan['source_sha256']
    _, rho = p.expected_instrument(q)
    I = np.eye(16)
    X = Pauli('IXII').to_matrix()
    Y = Pauli('IYII').to_matrix()
    R = Pauli('YIII').to_matrix()
    Z = Pauli('IZII').to_matrix()
    symbolic_result = json.loads((OUT / 'symbolic.json').read_text())
    yy = float(np.trace(Y @ R @ rho[1]).real)
    assert abs(yy - symbolic_result['YY_at_fixture']) < 1e-12
    delta = Z @ rho[1] @ Z - rho[1]
    single_residuals = [float(np.linalg.norm(partial_trace(DensityMatrix(delta), traced).data))
                        for traced in ([0, 1, 3], [0, 1, 2])]
    assert max(single_residuals) < 1e-12
    joint_residual = float(np.linalg.norm(partial_trace(DensityMatrix(delta), [0, 1]).data))
    assert joint_residual > .08

    def distribution(table, angle):
        Q = np.cos(angle) * X + np.sin(angle) * Y
        result = np.zeros((4, 2, 2))
        for code in range(4):
            state = Z @ rho[code] @ Z if table[code] else rho[code]
            for x, y in itertools.product((0, 1), repeat=2):
                effect = (I + (-1)**x * Q) @ (I + (-1)**y * R) / 4
                result[code, x, y] = np.trace(effect @ state).real
        assert result.min() > -1e-12 and abs(result.sum() - 1) < 1e-12
        return result

    settings = {}
    for name, angle, expected_classes in [('X_Y', 0, 4), ('Y_Y', np.pi/2, 4),
                                          ('diagonal_Y', np.pi/4, 8)]:
        groups = {}
        for table in itertools.product((0, 1), repeat=4):
            key = tuple(distribution(table, angle).round(12).reshape(-1))
            groups.setdefault(key, []).append(list(table))
        assert len(groups) == expected_classes
        Q = np.cos(angle) * X + np.sin(angle) * Y
        moments = [float(np.trace(Q @ R @ rho[a]).real) for a in range(4)]
        settings[name] = {'angle': float(angle), 'moments_full_denominator': moments,
                          'classes': list(groups.values())}
        if name == 'diagonal_Y':
            for group in groups.values():
                assert len(group) == 2 and group[0][1:] == group[1][1:]
            assert min(abs(v) for v in moments[1:]) > .037
        # Verify the literal SDK measurement tail, including signs/order.
        tail = QuantumCircuit(4)
        tail.rz(-float(angle), 2)
        tail.h(2)
        tail.sdg(3)
        tail.h(3)
        U = Operator(tail).data
        assert np.max(abs(U.conj().T @ Pauli('IZII').to_matrix() @ U - Q)) < 1e-12
        assert np.max(abs(U.conj().T @ Pauli('ZIII').to_matrix() @ U - R)) < 1e-12
        for code in range(4):
            direct = np.diag(U @ rho[code] @ U.conj().T).real.reshape(2, 2, 4).sum(axis=2).T
            assert np.max(abs(direct - distribution([0]*4, angle)[code])) < 1e-12

    correct = [0, 0, 0, 1]
    extra = [0, 1, 0, 1]
    assert np.max(abs(distribution(correct, 0) - distribution(extra, 0))) < 1e-12
    assert np.max(abs(distribution(correct, np.pi/4) - distribution(extra, np.pi/4))) > .027
    # Boundary: a memory-local change is invisible to every D/REF reading.
    XM = Pauli('IIIX').to_matrix()
    memory_delta = XM @ rho[1] @ XM - rho[1]
    memory_norm = float(np.linalg.norm(memory_delta))
    assert memory_norm > .01
    assert np.linalg.norm(partial_trace(DensityMatrix(memory_delta), [0, 1]).data) < 1e-12
    return {'source_sha256': source['source_sha256'], 'submitted_QPY_sha256': plan['qpy_sha256'],
            'branch_1_mass': float(np.trace(rho[1]).real),
            'unchanged_single_qubit_residuals': single_residuals,
            'changed_D_REF_Frobenius': joint_residual, 'YY_before_extra_Z': yy,
            'YY_after_extra_Z': -yy, 'settings': settings,
            'still_invisible_memory_change_Frobenius': memory_norm,
            'scope': 'Ideal fixed source/preparation and deterministic I/Z receiver table. Exact probability distinguishability, not finite-shot identification or arbitrary channel tomography.',
            'QPU_jobs_submitted': 0}


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('mode', choices=['symbolic', 'numeric'])
    args = parser.parse_args()
    OUT.mkdir(exist_ok=True)
    result = symbolic() if args.mode == 'symbolic' else numeric()
    result['checker_sha256'] = hashlib.sha256(Path(__file__).read_bytes()).hexdigest()
    (OUT / (args.mode + '.json')).write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps(result, indent=2))
