#!/usr/bin/env python3
"""Actual export and downstream action checks for the two resident demands."""
import argparse
from copy import deepcopy
import io
import json
from pathlib import Path
import tempfile
import time

import numpy as np
import qiskit
from qiskit import QuantumCircuit, qpy
from qiskit.circuit import IfElseOp, Store
from qiskit.circuit.classical import expr
from qiskit.circuit.library import UnitaryGate
from qiskit.quantum_info import Operator, Statevector
from qiskit_aer import AerSimulator
from qiskit_aer.library import save_density_matrix

import resident_workbench as work
from resident_contact_memory_checks import service_fixture
from resident_flat_checks import history_audit
from resident_raw_reply_checks import initial_quantum
from resident_stream_checks import operators, apply
from environment import write, digest


def request_boundary(source):
    rows = []
    for late in (False, True):
        selection = work.select(source, work.request(8, late))
        n = selection['candidates'][selection['selected']]['classes']
        assert n == (8 if late else 4)
        rows.append({'late_comparison': late, 'selected': selection['selected'],
                     'classes': n, 'candidate_applicability': selection['candidates']})
    witness = rows[1]['candidate_applicability']['contact']['states']
    assert witness == ['000', '001']
    return rows


def equality_boundary():
    gate = UnitaryGate(np.kron(np.eye(2), work.admission.X))
    a = QuantumCircuit(2); a.append(gate, [0, 1])
    b = QuantumCircuit(2); b.append(gate, [1, 0])
    left, right = Statevector.from_instruction(a), Statevector.from_instruction(b)
    assert a == b
    assert work.ordered_bindings(a) != work.ordered_bindings(b)
    assert abs(np.vdot(left.data, right.data)) == 0
    assert not Operator(a).equiv(Operator(b))
    return {'qiskit_version': qiskit.__version__, 'gate_matrix': 'I tensor X',
            'ordered_ports': [[0, 1], [1, 0]], 'QuantumCircuit_equality': True,
            'ordered_binding_equality': False, 'operator_equivalence': False,
            'outputs_from_00': [left.probabilities_dict(), right.probabilities_dict()],
            'scope': 'Reproduced behavior of the installed SDK; this does not diagnose all equality cases or claim an upstream fix.'}


def replaced(q, position, operation=None, qubits=None, clbits=None, *, omit=False):
    new = q.copy_empty_like()
    for i, item in enumerate(q.data):
        if i != position:
            new.append(item)
        elif not omit:
            new.append(operation if operation is not None else item.operation,
                       item.qubits if qubits is None else qubits,
                       item.clbits if clbits is None else clbits)
    return new


def guards(source, service):
    wanted = work.request(3, True); selection = work.select(source, wanted)
    q = work.circuit(source, wanted, selection, service); refused = []
    def no(name, function):
        try:
            function()
        except (ValueError, FileExistsError):
            refused.append(name); return
        raise AssertionError('Accepted '+name)

    bad = deepcopy(selection); bad['selected'] = 'contact'
    no('choose a compact executor without the late relation', lambda: work.circuit(source, wanted, bad, service))
    bad = deepcopy(selection); bad['model']['observation'][0]['at_closed_boundary'] = 1
    bad['certificate'] = work.goal.saturate.synthesize(bad['model'])
    no('valid certificate for a substituted question', lambda: work.circuit(source, wanted, bad, service))
    no('same artifact under a different request',
       lambda: work.admit(source, work.request(3), work.select(source, work.request(3)), service, q))

    position = next(i for i, item in enumerate(q.data) if item.operation.name == 'unitary')
    no('service memory and environment ports exchanged',
       lambda: work.admit(source, wanted, selection, service, replaced(q, position, qubits=[0, 2, 1])))
    position = next(i for i, item in enumerate(q.data) if item.operation.name == 'if_else')
    op = q.data[position].operation
    new = IfElseOp((op.condition[0], 1-int(op.condition[1])), *op.blocks)
    bad_circuit = replaced(q, position, operation=new)
    no('correct name but opposite acquired branch', lambda: work.admit(source, wanted, selection, service, bad_circuit))
    position = next(i for i, item in enumerate(q.data)
                    if item.operation.name == 'store' and item.operation.lvalue == expr.lift(q.cregs[2][0]))
    bad_circuit = replaced(q, position, operation=Store(expr.lift(q.cregs[2][0]), expr.lift(True)))
    no('scratch cleanup replaced by a different Store value', lambda: work.admit(source, wanted, selection, service, bad_circuit))
    late_reg = next(r for r in q.cregs if r.name == 'late_comparison')
    position = next(i for i, item in enumerate(q.data) if item.clbits == (late_reg[0],))
    bad_circuit = replaced(q, position, qubits=[3])
    no('late export measures data instead of the disposable probe', lambda: work.admit(source, wanted, selection, service, bad_circuit))
    bad_circuit = replaced(q, position, omit=True)
    no('late result named but never measured', lambda: work.admit(source, wanted, selection, service, bad_circuit))
    returned = next(r for r in q.cregs if r.name == 'acquired_class')
    position = next(i for i, item in enumerate(q.data) if item.clbits == (returned[0],))
    bad_circuit = replaced(q, position, clbits=[returned[1]])
    no('export bit redirected while preserving labels', lambda: work.admit(source, wanted, selection, service, bad_circuit))
    bad_circuit = q.copy(); bad_circuit.x(3)
    no('unrequested action on the continuing data', lambda: work.admit(source, wanted, selection, service, bad_circuit))

    with tempfile.TemporaryDirectory() as directory:
        output = Path(directory)/'prepared'
        work.prepare(output, source, wanted, service)
        no('overwrite a prepared occurrence', lambda: work.prepare(output, source, wanted, service))
        descriptor = json.loads((output/'descriptor.json').read_text())
        changed = deepcopy(descriptor)
        changed['readout']['registers']['late_comparison'] = changed['readout']['registers']['acquired_class'][:1]
        write(output/'descriptor.json', changed)
        no('decoder reads a different existing bit', lambda: work.run_local(output, source, service, 16))
        write(output/'descriptor.json', descriptor)
        with (output/'program.qpy').open('wb') as stream:
            qpy.dump(bad_circuit, stream)
        descriptor['QPY_sha256'] = digest(output/'program.qpy')
        write(output/'descriptor.json', descriptor)
        no('resaved altered circuit with an updated byte digest', lambda: work.run_local(output, source, service, 16))
    return refused


def audit_one(source, wanted, service, ks, shots):
    selection = work.select(source, wanted); qc = work.circuit(source, wanted, selection, service)
    stream = io.BytesIO(); qpy.dump(qc, stream); stream.seek(0); restored, = qpy.load(stream)
    work.admit(source, wanted, selection, service, restored)
    assert all(item.qubits == (qc.qubits[0],) for item in qc.data if item.operation.name in ('reset', 'measure'))
    n = wanted['contacts']; q = history_audit(restored, n)
    save_density_matrix(q, range(5), label='resident', pershot=True)
    # Test a later user of the measured answer, while DEM and Ref still live.
    if wanted['late_comparison']:
        late = next(r for r in q.cregs if r.name == 'late_comparison')
        with q.if_test((late[0], 1)):
            q.x(3)
    else:
        q.s(3)
    save_density_matrix(q, range(5), label='after_consumer', pershot=True)
    result = AerSimulator(method='statevector', max_parallel_threads=1).run(
        q, shots=shots, memory=True, seed_simulator=74889+n).result()
    assert result.success
    maps = operators(source['goal']['raw'], ks); labels = selection['plan']['certificate']['classes']
    z = np.kron(work.admission.I, np.kron(work.admission.Z, np.eye(4)))
    x = np.kron(work.admission.I, np.kron(work.admission.X, np.eye(4)))
    s = np.kron(work.admission.I, np.kron(work.admission.S, np.eye(4)))
    maximum = 0.; seen = set(); classes = set(); width = len(qc.cregs[0]); schema = work.readout(qc)
    for i, record in enumerate(result.get_memory()):
        word = int(record.replace(' ', ''), 2)
        history = [(word >> (qc.num_clbits+j)) & 1 for j in range(n)]
        r = 0; first = history[0]; rho = initial_quantum()
        for bit in history:
            rho = apply(maps[r, bit], rho); rho /= np.trace(rho).real; r = 1^(r^bit)
            if first^bit:
                rho = z@rho@z
        cls = labels[source['goal']['states'].index(f'{r}{first}{history[-1]}')]
        acquired = work.decode(schema, format(word & ((1 << qc.num_clbits)-1), f'0{qc.num_clbits}b'))
        assert acquired['acquired_class'] == cls and word & ((1 << width)-1) == cls
        assert (word >> width) & ((1 << (width+3))-1) == 0  # old, out including cleared reply
        classes.add(cls)
        if wanted['late_comparison']:
            flag = first^history[-1]
            assert acquired['late_comparison'] == flag
            seen.add(flag); consumer = x if flag else np.eye(16)
        else:
            assert 'late_comparison' not in acquired
            consumer = s
        for label, value in [('resident', rho), ('after_consumer', consumer@rho@consumer.conj().T)]:
            expected = np.kron(value, np.diag([1, 0]))
            error = float(np.max(abs(result.data()[label][i].data-expected)))
            assert error < 1e-10; maximum = max(maximum, error)
    return {'contacts': n, 'late_comparison': wanted['late_comparison'], 'executor': selection['selected'],
            'persistent_bits': width, 'classical_bits': qc.num_clbits, 'qubits': qc.num_qubits,
            'QPY_bytes': len(stream.getvalue()), 'maximum_joint_state_error': maximum,
            'classes_seen': sorted(classes), 'late_answers_seen': sorted(seen),
            'full_joint_states_checked': 2*shots, 'roundtrip_and_structural_admission': True}


def run(output):
    output.mkdir(parents=True, exist_ok=True)
    source = work.current_source(); started = time.perf_counter(); rows = []; shots = 128
    for fixture in [(1.3, -.8, 0), (1.45, .91, 0), (1.3, -.8, .71)]:
        service, ks = service_fixture(*fixture)
        for n in (1, 3, 8, 64):
            for late in (False, True):
                rows.append({'fixture': fixture, **audit_one(source, work.request(n, late), service, ks, shots)})
    result = {'demand_boundary': request_boundary(source), 'SDK_equality_boundary': equality_boundary(),
              'refusals': guards(source, service),
              'circuits': len(rows), 'shots_each': shots, 'joint_states_checked': sum(r['full_joint_states_checked'] for r in rows),
              'maximum_joint_state_error': max(r['maximum_joint_state_error'] for r in rows), 'cases': rows,
              'seconds': time.perf_counter()-started, 'new_QPU_jobs': 0,
              'source': work.admission.fingerprint(source), 'implementation_sha256': digest(Path(work.__file__)),
              'check_sha256': digest(Path(__file__)), 'scope': 'Local ideal execution, including an actual downstream recipient of the measured late reply. No claim about QPU acceptance, readout fidelity or cross-job quantum persistence.'}
    write(output/'audit.json', result)
    return result


if __name__ == '__main__':
    p = argparse.ArgumentParser(description=__doc__); p.add_argument('--output', type=Path, required=True)
    result = run(p.parse_args().output.resolve())
    print(json.dumps({k: result[k] for k in ('circuits', 'joint_states_checked', 'maximum_joint_state_error', 'seconds')},
                     default=str))
