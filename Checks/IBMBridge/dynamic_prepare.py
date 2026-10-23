#!/usr/bin/env python3
"""Prepare a common physical prefix for three Bell readings. Never submits.

The original independently compiled nine circuits remain archived. Here each
policy's source and correction are compiled ONCE. Only native single-qubit
analyzers and final readout are appended afterwards, without recompiling the
whole circuit. This prevents a basis choice from selecting another state source.
"""

import sys as _evidence_sys
from pathlib import Path as _EvidencePath
_evidence_sys.path.insert(0, str(_EvidencePath(__file__).resolve().parents[1]))
import hardware_runs as _runs
_runs.configure(required=(__name__ == "__main__"))
import argparse
import io
import json
from pathlib import Path

from dynamic import POLICIES, BASES, state_fragment, simulate, exact_channels
from pilot import ROOT, prepare, service_open, compact_active, sha, utc, versions
from runtime import require, write_json, load_json


def signature(circuit):
    """Structural signature, including scoped conditional bodies and record bits."""
    from qiskit import ClassicalRegister
    rows = []
    for ins in circuit.data:
        op = ins.operation
        row = {'name':op.name,
               'qubits':[circuit.find_bit(q).index for q in ins.qubits],
               'clbits':[circuit.find_bit(c).index for c in ins.clbits]}
        if op.name == 'if_else':
            condition, value = op.condition
            require(isinstance(condition, ClassicalRegister), 'unsupported conditional input')
            row['condition'] = {'bits':[circuit.find_bit(c).index for c in condition], 'value':value}
            row['blocks'] = [signature(b) for b in op.blocks]
        else:
            require(not hasattr(op, 'blocks'), 'unsupported control-flow node')
            row['params'] = [float(p) for p in op.params]
        rows.append(row)
    return {'qubits':circuit.num_qubits, 'clbits':circuit.num_clbits,
            'registers':[(r.name,len(r)) for r in circuit.cregs],
            'phase':float(circuit.global_phase), 'instructions':rows}


def digest_structure(circuit):
    return sha(json.dumps(signature(circuit), sort_keys=True).encode())


def logical_prefix(documents, policy):
    from qiskit import QuantumCircuit, ClassicalRegister
    fragment = state_fragment(documents, policy)
    circuit = QuantumCircuit(7)
    circuit.add_register(*fragment.cregs)
    circuit.add_register(ClassicalRegister(2,'out'))
    circuit.h(0); circuit.cx(0,6)
    circuit.compose(fragment, qubits=list(range(6)), clbits=list(range(2)), inplace=True)
    circuit.h(0)
    return circuit


def compiled_analyzer(backend, wire, basis):
    from qiskit import QuantumCircuit, transpile
    local = QuantumCircuit(1)
    if basis == 'YY': local.sdg(0)
    if basis in ('XX','YY'): local.h(0)
    native = transpile(local, backend, initial_layout=[wire],
                       optimization_level=0, seed_transpiler=72419)
    require(all(not i.clbits and [native.find_bit(q).index for q in i.qubits] == [wire]
                for i in native.data), 'analyzer changed physical support')
    return native


def append_analyzers(prefix, physical_pair, basis, backend):
    require(basis in BASES, 'invalid basis')
    circuit = prefix.copy()
    for wire in physical_pair:
        native = compiled_analyzer(backend, wire, basis)
        circuit.global_phase += native.global_phase
        for ins in native.data:
            circuit.append(ins.operation, [native.find_bit(q).index for q in ins.qubits])
    out = next(r for r in circuit.cregs if r.name == 'out')
    circuit.measure(physical_pair[0],out[0]); circuit.measure(physical_pair[1],out[1])
    # Source instruction sequence is identical. Tail global phases are irrelevant
    # to all measurement probabilities and are recorded by the complete signature.
    require(signature(circuit)['instructions'][:len(prefix.data)] == signature(prefix)['instructions'],
            'analyzer changed the compiled source prefix')
    return circuit


def validate_family(circuits, manifest):
    require(len(circuits) == 9 and len(manifest) == 3, 'incomplete dynamic family')
    common_acquisition = None
    for i,policy in enumerate(POLICIES):
        group = circuits[3*i:3*i+3]
        specification = manifest[i]
        require(specification['policy'] == policy, 'wrong policy binding')
        prefix_count = specification['prefix_instruction_count']
        physical_pair = specification['physical_payload_reference']
        expected_prefix = None
        for circuit,basis in zip(group,BASES):
            require(circuit.metadata['policy'] == policy and circuit.metadata['basis'] == basis,
                    'wrong circuit question binding')
            sig = signature(circuit)
            prefix = sig['instructions'][:prefix_count]
            first_if = next((j for j,r in enumerate(prefix) if r['name']=='if_else'),None)
            require(first_if is not None, 'missing conditional continuation')
            acquisition = prefix[:first_if]
            if common_acquisition is None: common_acquisition = acquisition
            require(acquisition == common_acquisition, 'policies use different physical acquisition prefixes')
            require(sha(json.dumps(prefix, sort_keys=True).encode()) == specification['prefix_instructions_sha256'],
                    'physical prefix changed')
            if expected_prefix is None: expected_prefix = prefix
            require(prefix == expected_prefix, 'readings do not share a physical source prefix')
            tail = sig['instructions'][prefix_count:]
            require(len(tail) >= 2 and all(row['name'] != 'measure' for row in tail[:-2]),
                    'unexpected interior analyzer measurement')
            require(all(row['qubits'] in ([physical_pair[0]], [physical_pair[1]])
                        and not row['clbits'] for row in tail[:-2]), 'analyzer touches the source memory')
            require([(row['name'],row['qubits'],row['clbits']) for row in tail[-2:]] ==
                    [('measure',[physical_pair[0]],[2]),('measure',[physical_pair[1]],[3])],
                    'terminal reading is bound to another pair')
    return True


def prepare_family(documents, backend, initial_layout):
    from qiskit import transpile
    require(len(initial_layout)==7 and len(set(initial_layout))==7, 'invalid common input layout')
    circuits, manifest = [], []
    for policy in POLICIES:
        logical = logical_prefix(documents,policy)
        prefix = transpile(logical,backend,initial_layout=initial_layout,
                           optimization_level=1,seed_transpiler=72419)
        mapping = prefix.layout.final_index_layout()
        pair = [mapping[0],mapping[6]]
        prefix_sig = signature(prefix)['instructions']
        require(sum(r['name']=='measure' for r in prefix_sig)==2,
                'source prefix must measure exactly two records')
        # No source operation follows feedback in this fragment other than the
        # fixed target inverse. Do not bind mid-circuit wires by a final layout.
        measurements = [(r['qubits'][0],r['clbits'][0]) for r in prefix_sig if r['name']=='measure']
        require({c for _,c in measurements}=={0,1}, 'source readout has another record destination')
        specification = {'policy':policy, 'initial_layout':initial_layout,
                         'physical_payload_reference':pair,
                         'mid_measurement_wire_and_destination':measurements,
                         'prefix_instruction_count':len(prefix.data),
                         'prefix_instructions_sha256':sha(json.dumps(prefix_sig,sort_keys=True).encode())}
        manifest.append(specification)
        for basis in BASES:
            circuit = append_analyzers(prefix,pair,basis,backend)
            circuit.metadata = {'vi_request':'AcquireState','policy':policy,'basis':basis,
                                'scope':'common-prefix preparation; no hardware result'}
            circuits.append(circuit)
    # Policy comparisons also use the same physical payload/reference addresses.
    require(all(m['physical_payload_reference']==manifest[0]['physical_payload_reference']
                for m in manifest), 'policies compiled onto different output pairs')
    validate_family(circuits,manifest)
    return circuits,manifest


def main():
    from qiskit import qpy
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--output',type=_runs.owned,required=True)
    p.add_argument('--archive',type=_runs.input_path,default=_runs.path('ibm-dynamic-local-20260914'))
    p.add_argument('--shots',type=int,default=1024)
    a=p.parse_args()
    require(not a.output.exists() and 1<=a.shots<=4096, 'invalid output/shots')
    old=load_json(a.archive/'result.json')
    payload=(a.archive/'isa.qpy').read_bytes()
    require(sha(payload)==old['compile_only']['qpy_sha256'], 'archived compilation changed')
    archived=qpy.load(io.BytesIO(payload))
    require(archived[0].metadata['policy']=='acquired' and archived[0].metadata['basis']=='XX',
            'unexpected reference layout source')
    layout=archived[0].layout.initial_index_layout(filter_ancillas=True)
    docs,receipt=prepare(_runs.prepared('ibm-prepared'))
    exact_channels(docs)
    backend=service_open().backend(old['compile_only']['backend'])
    require('if_else' in backend.operation_names, 'conditional execution unsupported')
    circuits,manifest=prepare_family(docs,backend,layout)
    # Only idle physical address labels are removed. Scoped conditional blocks,
    # classical registers, measurements and native gate sequences are retained.
    local=[compact_active(c) for c in circuits]
    rows=simulate(local,a.shots)
    for row in rows:
        if row['policy']=='acquired':
            require(row['correlation']==(-1 if row['basis']=='YY' else 1),
                    'compiled continuation does not restore Bell reference')
        elif row['policy']=='invert_reply':
            require(row['correlation']==-1, 'inverted-reply control changed meaning')
    a.output.mkdir(parents=True)
    data=io.BytesIO();qpy.dump(circuits,data)
    (a.output/'isa.qpy').write_bytes(data.getvalue())
    report={'schema':'vi.ibm.dynamic-common-prefix.v1','created_at':utc(),
            'scope':'LOCAL IDEAL validation of compiled ISA with idle wires removed; no QPU job',
            'backend':backend.name,'checked_build':receipt,'versions':versions(),
            'initial_layout_from_archive':str(a.archive),'archived_qpy_sha256':sha(payload),
            'manifest':manifest,'qpy_sha256':sha(data.getvalue()),'shots_each':a.shots,'rows':rows,
            'compact_qubit_counts':[c.num_qubits for c in local],
            'implementation':{_runs.address(f, ROOT):sha(f.read_bytes()) for f in
                (_runs.owned(__file__),_runs.owned(__file__).with_name('dynamic.py'),_runs.owned(__file__).with_name('pilot.py'))}}
    write_json(a.output/'result.json',_runs.bind_receipt(report, destination=a.output/'result.json'))
    print(json.dumps(_runs.bind_receipt({'output':str(a.output),'physical_pair':manifest[0]['physical_payload_reference'],
                      'compiled_and_simulated':len(circuits),'hardware_submitted':False}),indent=2))


if __name__=='__main__':main()
