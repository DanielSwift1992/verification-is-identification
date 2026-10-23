#!/usr/bin/env python3
"""Offline Store-free lowering of the frozen 6062 probe. Never submits a job."""

import sys as _evidence_sys
from pathlib import Path as _EvidencePath
_evidence_sys.path.insert(0, str(_EvidencePath(__file__).resolve().parents[1]))
import hardware_runs as _runs
_runs.configure(required=(__name__ == "__main__"))
import io
import itertools
import json
from pathlib import Path
import sys

from qiskit import qpy
from qiskit_aer import AerSimulator

from pilot import compact_active, sha, require
from classical_boundary_probe import aer_form

ROOT = _runs.owned(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT/'Checks/FiniteContinuation'))
from resident_record_lowering import lower


def run():
    directory = _runs.path('ibm-classical-boundary-20260916')
    public = ROOT/'Research/Artifacts/classical-boundary-probe-20260916'
    plan = json.loads((public/'plan.json').read_text())
    payload = (directory/'isa.qpy').read_bytes()
    require(sha(payload) == plan['qpy_sha256'], 'Frozen probe bytes changed')
    circuits = qpy.load(io.BytesIO(payload))
    require(len(circuits) == 2, 'Wrong frozen PUB coverage')
    rows = []
    for bit, original in enumerate(circuits):
        require(original.metadata['input_bit'] == bit and original.metadata['tag'] == plan['tag'],
                'Wrong probe occurrence')
        product = lower(original)
        require(product.circuit.num_clbits == 3, 'Actual measurement coverage changed')
        # All records, including outcomes inconsistent with ideal preparation
        # or corrections: decoding cannot replace actual bits with expected ones.
        for raw, target1, target2 in itertools.product((0,1), repeat=3):
            records = [raw,target1,target2]
            require(product.register('raw', records) == raw and
                    product.register('saved', records) == 1-raw and
                    product.register('code', records) == 2*(1-raw) and
                    product.register('out', records) == raw+2*target1+4*target2,
                    'Reading substitutes expected for actual outcome')
        buffer = io.BytesIO(); qpy.dump(product.circuit, buffer)
        lowered_bytes = buffer.getvalue(); buffer.seek(0)
        restored, = qpy.load(buffer)
        result = AerSimulator().run(aer_form(compact_active(restored)),
                                    shots=32, memory=True, seed_simulator=916).result()
        require(result.success, 'Lowered probe failed locally')
        for memory in result.get_memory():
            number = int(memory.replace(' ',''),2)
            records = [(number>>i)&1 for i in range(3)]
            require(product.register('raw',records) == bit and
                    product.register('out',records) == (1 if bit else 6), 'Wrong local probe relation')
        (public/f'local-store-free-input{bit}.qpy').write_bytes(lowered_bytes)
        rows.append({'input':bit, 'local_shots':32, 'record_assignments_checked':8,
                     'physical_record_bits':3, 'source_classical_bits':original.num_clbits,
                     'stores_removed':product.stores_removed,
                     'lowered_QPY_sha256':sha(lowered_bytes)})
    output = {'schema':'vi.classical-boundary-offline-lowering.v1', 'source_QPY_sha256':sha(payload),
              'cases':rows, 'new_QPU_jobs':0,
              'scope':'Local alternative representation of the actual failed probe; '
                      'not a diagnosis of 6062 and not evidence of server acceptance.'}
    (public/'offline-lowering.json').write_text(json.dumps(_runs.bind_receipt(output, destination=public/'offline-lowering.json'),indent=2)+'\n')
    print(json.dumps(_runs.bind_receipt(output),indent=2))


if __name__ == '__main__': run()
