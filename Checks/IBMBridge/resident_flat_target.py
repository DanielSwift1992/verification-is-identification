#!/usr/bin/env python3
"""Read one IBM target; compile and audit locally. No primitive or job creation."""
import argparse
import json
from pathlib import Path
import sys
import time

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
sys.path.insert(0, str(ROOT/'Checks/FiniteContinuation'))

import numpy as np
from qiskit import QuantumCircuit, qpy
from qiskit.circuit import Measure
from qiskit.transpiler import generate_preset_pass_manager
from qiskit_aer import AerSimulator
from qiskit_aer.library import save_density_matrix
from qiskit_ibm_runtime.circuit import MidCircuitMeasure
from qiskit_ibm_runtime.utils.validations import validate_isa_circuits

from pilot import service_open, utc, versions
import resident_flat_controller as flat
import resident_goal_compiler as goal
from resident_flat_checks import history_audit
from resident_goal_checks import question
from resident_raw_reply_checks import fixture
from resident_stream_checks import operators, trajectory
import whole_word_admission as admission
from environment import write, digest


def endpoint(q):
    if [i.operation.name for i in q.data[-4:]] != ['cx', 'h', 'measure', 'measure']:
        raise ValueError('Terminal test receiver changed')
    prefix = q.copy_empty_like()
    for item in q.data[:-4]:
        if item.operation.name == 'measure':
            prefix.append(MidCircuitMeasure(), item.qubits, item.clbits)
        else:
            prefix.append(item)
    return prefix


def local_projection(isa):
    # Only remove unused physical wires; retain every used routing wire.
    active = sorted({isa.find_bit(b).index for item in isa.data for b in item.qubits})
    if len(active) > 10:
        raise ValueError('Local trajectory audit exceeds ten active qubits')
    mapping = {v: i for i, v in enumerate(active)}
    q = QuantumCircuit(len(active)); q.add_register(*isa.cregs)
    q.global_phase = isa.global_phase
    for item in isa.data:
        op = Measure() if item.operation.name == 'measure_2' else item.operation
        q.append(op, [mapping[isa.find_bit(b).index] for b in item.qubits], item.clbits)
    logical = isa.layout.final_index_layout()
    ports = [mapping[logical[i]] for i in [1, 2, 3, 4]]
    save_density_matrix(q, ports, label='continued', pershot=True)
    return q, active, logical


def run(output, strategy):
    output.mkdir(parents=True, exist_ok=True)
    source_path = ROOT/'Research/Artifacts/resident-goal-memory-20260915'
    source = json.loads((source_path/'goal-reading.json').read_text())
    plans = json.loads((source_path/'plans.json').read_text())
    # Existing helper verifies both free/Open instance selection and key mode.
    backend = service_open().backend('ibm_kingston')
    if not {'if_else', 'store', 'measure_2'} <= set(backend.supported_instructions):
        raise ValueError('Selected backend does not advertise the required operations')
    snapshot = {'retrieved_at': utc(), 'backend': backend.name, 'num_qubits': backend.num_qubits,
        'supported_instructions': backend.supported_instructions,
        'target_operation_names': sorted(backend.target.operation_names), 'versions': versions(),
        'documentation': [
            'https://quantum.cloud.ibm.com/docs/en/guides/execute-dynamic-circuits',
            'https://quantum.cloud.ibm.com/docs/en/guides/qasm-feature-table'],
        'client_ISA_validation_scope': 'Target instruction/operand membership; Store is exempted, nested if is recursively accepted.',
        'hardware_acceptance_established': False, 'new_QPU_jobs': 0}
    write(output/'target.json', snapshot)
    started = time.perf_counter(); gate, ks, _ = fixture(1.3, -.8)
    maps = operators(source['raw'], ks)
    z = np.kron(admission.I, np.kron(admission.Z, np.eye(4)))
    cases = []; states = 0; maximum = 0.; shots = 64
    pm = generate_preset_pass_manager(target=backend.target, optimization_level=1, seed_transpiler=713)
    for name, plan in plans.items():
        ctl = goal.interpret(source, plan); width = ctl['width']
        for contacts in (3, 64):
            q = endpoint(flat.compile(source, plan, gate, contacts, strategy=strategy))
            t = time.perf_counter(); isa = pm.run(q)
            validate_isa_circuits([isa], backend.target)
            profile = flat.check_flat_fragment(isa, allow_unitary=False)
            compile_seconds = time.perf_counter()-t
            path = output/f'{strategy}-{name}-{contacts}-endpoint.qpy'
            with path.open('wb') as stream:
                qpy.dump(isa, stream)
            # This substitutes the IDEAL semantics of measure_2 for simulation;
            # it does not infer device noise, timing or hardware execution.
            sim, active, layout = local_projection(isa)
            sim = history_audit(sim, contacts)
            rs = AerSimulator(method='statevector', max_parallel_threads=1).run(
                sim, shots=shots, memory=True, seed_simulator=45821+contacts).result()
            assert rs.success; error = 0.
            for j, record in enumerate(rs.get_memory()):
                number = int(record.replace(' ', ''), 2)
                h = tuple((number >> (q.num_clbits+i))&1 for i in range(contacts))
                r, rho = trajectory(maps, h); flag = question(name, h)
                if flag:
                    rho = z@rho@z
                index = source['states'].index(f'{r}{h[0]}{h[-1]}')
                cls = plan['certificate']['classes'][index]
                assert number & ((1 << width)-1) == cls
                assert (number >> (2*width+3)) & ((1 << width)-1) == cls
                e = float(np.max(abs(rs.data()['continued'][j].data-rho)))
                assert e < 1e-9; error = max(error, e); states += 1
            maximum = max(maximum, error)
            cases.append({'goal': name, 'contacts': contacts, 'profile': profile,
                'active_physical_qubits': active, 'final_logical_layout': layout,
                'compiler_seconds': compile_seconds, 'maximum_state_residual': error,
                'QPY': path.name, 'QPY_sha256': digest(path), 'QPY_bytes': path.stat().st_size})
    # A concrete scope boundary: instruction membership accepts nested ifs,
    # whereas the current IBM guide excludes them and our local audit rejects.
    nested = QuantumCircuit(backend.num_qubits, 2)
    with nested.if_test((nested.clbits[0], 1)):
        with nested.if_test((nested.clbits[1], 1)):
            nested.x(44)
    validate_isa_circuits([nested], backend.target)
    rejected = False
    try:
        flat.check_flat_fragment(nested, allow_unitary=False)
    except ValueError:
        rejected = True
    assert rejected
    result = {'target': snapshot, 'strategy': strategy, 'cases': cases, 'states_checked': states,
        'maximum_state_residual': maximum, 'seconds': time.perf_counter()-started,
        'scope_witness': {'nested_if_passes_client_ISA_validator': True,
                          'nested_if_rejected_by_bounded_fragment': True},
        'new_QPU_jobs': 0, 'hardware_acceptance_established': False,
        'hardware_accuracy_established': False,
        'check_sha256': digest(Path(__file__))}
    write(output/f'target-audit-{strategy}.json', result)
    return result


if __name__ == '__main__':
    p = argparse.ArgumentParser(description=__doc__); p.add_argument('--output', type=Path, required=True)
    p.add_argument('--strategy', choices=('cases', 'affine'), default='affine')
    args = p.parse_args(); result = run(args.output.resolve(), args.strategy)
    print(json.dumps({'states': result['states_checked'], 'maximum_error': result['maximum_state_residual'],
                      'seconds': result['seconds'], 'new_QPU_jobs': result['new_QPU_jobs']}))
