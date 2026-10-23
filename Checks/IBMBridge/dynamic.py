#!/usr/bin/env python3
"""LOCAL AcquireState prototype: measured records control a live payload.

No submission API. --backend only reads an IBM compilation target. The legacy
terminal executor still rejects State. This separately scoped consumer admits
the same Uniform2/CZ resident source and the checked State continuation.
"""

import sys as _evidence_sys
from pathlib import Path as _EvidencePath
_evidence_sys.path.insert(0, str(_EvidencePath(__file__).resolve().parents[1]))
import hardware_runs as _runs
_runs.configure(required=(__name__ == "__main__"))
import argparse
from collections import Counter
import io
import json
from pathlib import Path

from pilot import ROOT, BRIDGE, lower, prepare, service_open, sha, utc, versions
from execute import terminal_job, unique_named
from runtime import bind_continuation, require, write_json

POLICIES = ('acquired', 'ignore_reply', 'invert_reply')
BASES = ('XX', 'YY', 'ZZ')


def source_and_plans(documents):
    """Reuse the admitted producer only after establishing identical sources."""
    models = unique_named(documents['sources.json']['models'])
    plans = unique_named(documents['continuations.json']['plans'])
    requests = unique_named(documents['requests.json']['requests'])
    request = requests['AcquireState']
    z_request = requests['AcquireZ']
    require(request['action'] == 'acquire' and request['contacts'] == 1
            and request['backend'] == 'unsupported_live_quantum_feedback',
            'changed State/legacy-terminal scope')
    require(all(request[k] == z_request[k] for k in ('action', 'cell', 'contact_id', 'contacts')),
            'State contact is not the admitted physical resident')

    def physical(model):
        return {'operations': model['operations'], 'acquisitions': model['acquisitions'],
                'rows': [{k:r[k] for k in ('index', 'weight', 'frame', 'record')}
                         for r in model['rows']]}

    for key in ('before', 'selected'):
        require(models[request[key]]['question'] == 'State'
                and physical(models[request[key]]) == physical(models[z_request[key]]),
                'State and terminal source/acquisition differ')
        plan = plans[request[key]]
        require(plan['question'] == 'State', 'wrong continuation question')
        execution = plan['execution']
        width = 1 if key == 'before' else 2
        require(execution['input_records'] == ['r'+str(i) for i in range(width)]
                and set(execution['by_record']) == {format(i, f'0{width}b') for i in range(2**width)},
                'incomplete State record domain')
        for record in execution['by_record']:
            bound = bind_continuation(execution, record)
            require(not bound['measure_payload'], 'State continuation measures the payload')
    require(plans[request['selected']]['exact'] is True
            and plans[request['selected']]['loss_numerator'] == 0, 'no exact acquired continuation')

    job, descriptor, _ = terminal_job(documents, 'AcquireZ', 'zero', 256)
    terminal = lower(job, descriptor)
    require(descriptor['execution']['analyzer'] == [] and descriptor['data_wire'] == 0
            and descriptor['record_wire'] == 5 and descriptor['contact_wire'] == 2,
            'this State consumer requires the admitted Z source without an analyzer')
    # The zero input adds no preparation gate. Remove only the verified final
    # readout suffix, never a payload preparation/reset or an interior reading.
    cut = len(terminal.data) - len(descriptor['measured_wires'])
    require(all(i.operation.name == 'measure' for i in terminal.data[cut:])
            and all(not i.clbits and i.operation.name in ('h','cx','cz')
                    for i in terminal.data[:cut]), 'source has an unsupported interior operation')
    from qiskit import QuantumCircuit
    unitary = QuantumCircuit(6)
    for ins in terminal.data[:cut]:
        unitary.append(ins.operation, [terminal.find_bit(q).index for q in ins.qubits])
    return unitary, plans[request['before']], plans[request['selected']], request


def branch_gates(before, after, policy, code):
    """code is ONLY the measured two-bit register (resident, parity)."""
    require(policy in POLICIES and type(code) is int and 0 <= code < 4, 'bad controller input')
    if policy == 'ignore_reply':
        execution, record = before['execution'], str(code & 1)
    else:
        execution = after['execution']
        record = format(code ^ (2 if policy == 'invert_reply' else 0), '02b')
    return bind_continuation(execution, record)['gates']


def state_fragment(documents, policy):
    """Caller supplies payload q0; other wires must start in zero.

    The returned payload is quantum and unmeasured. Its ideal target is H times
    the incoming payload. Any reference supplied by the caller is untouched.
    """
    from qiskit import ClassicalRegister
    source, before, after, _ = source_and_plans(documents)
    record = ClassicalRegister(2, 'record')
    source.add_register(record)
    source.measure(5, record[0])  # acquired parity: low bit
    source.measure(2, record[1])  # actual current CZ resident: high bit
    for code in range(4):
        gates = branch_gates(before, after, policy, code)
        if gates:
            with source.if_test((record, code)):
                for gate in gates:
                    getattr(source, gate)(0)
    return source


def witness(documents, policy, basis):
    from qiskit import QuantumCircuit, ClassicalRegister
    require(basis in BASES, 'unsupported witness basis')
    fragment = state_fragment(documents, policy)
    circuit = QuantumCircuit(7)
    circuit.add_register(*fragment.cregs)
    out = ClassicalRegister(2, 'out'); circuit.add_register(out)
    circuit.h(0); circuit.cx(0, 6)  # Bell input; q6 is the untouched reference.
    circuit.compose(fragment, qubits=list(range(6)), clbits=list(range(2)), inplace=True)
    circuit.h(0)  # Invert the independently fixed target H, not a measured answer.
    for wire in (0, 6):
        if basis == 'YY': circuit.sdg(wire)
        if basis in ('XX', 'YY'): circuit.h(wire)
    circuit.measure(0, out[0]); circuit.measure(6, out[1])
    circuit.metadata = {'vi_request':'AcquireState', 'policy':policy, 'basis':basis,
                        'scope':'local dynamic prototype; no hardware result'}
    return circuit


def exact_channels(documents):
    """Independent SDK matrix check for all admitted classical valuations.

    Valuations are QA inputs here, never inputs to the executable controller.
    """
    from qiskit import QuantumCircuit
    from qiskit.quantum_info import Operator
    import numpy as np
    _, before, after, request = source_and_plans(documents)
    model = unique_named(documents['sources.json']['models'])[request['before']]
    output = {}
    for policy in POLICIES:
        fidelities = []
        for s0 in (0, 1):
            for s1 in (0, 1):
                valuation = (s0, s1)
                branch = QuantumCircuit(1)
                for op in model['operations']:
                    if op['gate'] in ('z', 'retained_z'):
                        if valuation[op['control']]: branch.z(0)
                    else: getattr(branch, op['gate'])(0)
                code = (s1 << 1) | (s0 ^ s1)
                for gate in branch_gates(before, after, policy, code): getattr(branch, gate)(0)
                branch.h(0)
                u = Operator(branch).data
                # Bell overlap of (U x identity)|Phi+> is |tr U|^2/4.
                fidelity = float(abs(np.trace(u))**2 / 4)
                if policy == 'acquired':
                    require(Operator(branch).equiv(Operator(np.eye(2))),
                            'acquired branch does not restore every input up to a scalar')
                fidelities.append(fidelity)
        output[policy] = {'branch_bell_fidelities':fidelities,
                          'uniform_channel_bell_fidelity':sum(fidelities)/4}
    return output


def simulate(circuits, shots):
    from qiskit.primitives import BackendSamplerV2
    from qiskit_aer import AerSimulator
    sampler = BackendSamplerV2(backend=AerSimulator(),
                               options={'default_shots':shots, 'seed_simulator':46371})
    result = sampler.run(circuits).result()
    rows = []
    for circuit, pub in zip(circuits, result):
        out, record = pub.data.out, pub.data.record
        require(out.num_shots == record.num_shots == shots, 'incomplete local shots')
        counts = out.get_counts()
        correlation = sum((1 if b[0] == b[1] else -1)*n for b,n in counts.items())/shots
        joint = Counter(r+':'+o for r,o in zip(record.get_bitstrings(), out.get_bitstrings()))
        rows.append({**circuit.metadata, 'shots':shots, 'out_counts':counts,
                     'record_then_out_counts':dict(joint), 'correlation':correlation})
    return rows


def main():
    from qiskit import qpy, transpile
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--output', type=_runs.owned, required=True)
    p.add_argument('--backend', help='Read-only IBM target; never submits')
    p.add_argument('--shots', type=int, default=1024)
    args = p.parse_args()
    require(1 <= args.shots <= 4096 and not args.output.exists(), 'invalid shots/existing output')
    documents, receipt = prepare(_runs.prepared('ibm-prepared'))
    exact = exact_channels(documents)
    circuits = [witness(documents, policy, basis) for policy in POLICIES for basis in BASES]
    rows = simulate(circuits, args.shots)
    fidelities = {}
    for policy in POLICIES:
        c = {r['basis']:r['correlation'] for r in rows if r['policy'] == policy}
        fidelities[policy] = (1 + c['XX'] - c['YY'] + c['ZZ'])/4
    args.output.mkdir(parents=True)
    buffer = io.BytesIO(); qpy.dump(circuits, buffer)
    (args.output/'logical.qpy').write_bytes(buffer.getvalue())
    report = {'schema':'vi.ibm.dynamic-local.v1', 'created_at':utc(),
              'scope':'LOCAL IDEAL SIMULATION; no QPU job and no noise model',
              'checked_build':receipt, 'versions':versions(), 'shots_each':args.shots,
              'exact_channels':exact, 'sample_bell_fidelities':fidelities, 'rows':rows,
              'logical_qpy_sha256':sha(buffer.getvalue()),
              'implementation':{_runs.address(f, ROOT):sha(f.read_bytes()) for f in
                (_runs.owned(__file__), _runs.owned(__file__).with_name('pilot.py'),
                 BRIDGE/'execute.py', BRIDGE/'runtime.py')}}
    # Save local evidence before an optional network/compilation failure.
    write_json(args.output/'result.json', _runs.bind_receipt(report, destination=args.output/'result.json'))
    if args.backend:
        backend = service_open().backend(args.backend)
        require('if_else' in backend.operation_names, 'backend has no conditional operation')
        isa = transpile(circuits, backend, optimization_level=1, seed_transpiler=72419)
        require(all(c.count_ops().get('if_else', 0) > 0 for c in isa),
                'compiled circuit lost its dynamic continuation')
        compiled = io.BytesIO(); qpy.dump(isa, compiled)
        (args.output/'isa.qpy').write_bytes(compiled.getvalue())
        report['compile_only'] = {'backend':backend.name, 'qpy_sha256':sha(compiled.getvalue()),
                                  'circuit_count':len(isa),
                                  'if_else_counts':[c.count_ops().get('if_else',0) for c in isa],
                                  'scope':'target compilation only; ISA not simulated or executed on QPU'}
        write_json(args.output/'result.json', _runs.bind_receipt(report, destination=args.output/'result.json'))
    print(json.dumps(_runs.bind_receipt({'output':str(args.output), 'sample_bell_fidelities':fidelities,
                      'compiled':args.backend, 'hardware_submitted':False}), indent=2))


if __name__ == '__main__':
    main()
