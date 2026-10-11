#!/usr/bin/env python3
"""Numerical application to two frozen continuation programs, no cloud call.

Unlike the rational examples, these are floating-point fixture diagnostics,
not a tolerance-based admission of an unknown physical instrument.
"""
import hashlib
import json
from pathlib import Path
import time

import numpy as np
from qiskit import qpy
from resident_goal_instrument_audit import interpret

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT/'Research/Artifacts/resident-record-lowering-20260916'
OUT = ROOT/'Research/Artifacts/resident-record-recovery-20260916'


def digest(p): return hashlib.sha256(p.read_bytes()).hexdigest()


def run():
    began = time.perf_counter()
    frozen = json.loads((SOURCE/'manifest.json').read_text())
    for name, expected in frozen['sha256'].items(): assert digest(ROOT/name)==expected, name
    cases = json.loads((SOURCE/'audit.json').read_text())['cases']
    results = []
    for index in (0,1):
        assert cases[index]['presentation']=='direct'
        payload = SOURCE/f'case{index}.qpy'
        reading = json.loads((SOURCE/f'case{index}-reading.json').read_text())
        assert digest(payload)==reading['QPY_sha256']
        with payload.open('rb') as stream: circuit, = qpy.load(stream)
        def decode(bits):
            result = []
            for root in reading['outputs']:
                while root > 1:
                    variable, low, high = reading['nodes'][root]
                    root = high if bits[variable] else low
                result.append(root)
            return tuple(result)
        groups = {}
        branches = interpret(circuit)
        for branch in branches:
            assert np.max(abs(branch['map'][1::2])) < 1e-12
            groups.setdefault(decode(branch['bits']),[]).append((branch['bits'],branch['map'][::2]))
        rows = []
        for old, group in groups.items():
            matrices = [a for bits,a in group]
            vectors = [a.reshape(-1,order='F') for a in matrices]
            effect = sum(a.conj().T@a for a in matrices)
            joint = sum(np.outer(v,v.conj()) for v in vectors)
            d = matrices[0].shape[1]
            weight = np.trace(effect).real
            details = []
            for (bits,a),v in zip(group,vectors):
                probability = float(np.vdot(v,v).real/weight)
                delta_effect = a.conj().T@a-probability*effect
                delta_choi = (np.outer(v,v.conj())-probability*joint)/d
                eig = np.linalg.eigvalsh(delta_effect)
                details.append({'record':bits,'candidate_probability':probability,
                                'outcome_probability_witness_gap':float(eig[np.argmax(abs(eig))]),
                                'normalized_Choi_Frobenius_residual':float(np.linalg.norm(delta_choi))})
            rows.append({'old_record':old,'refinements':len(group),
                         'residual_code': [{'index':i,'fine_record':bits} for i,(bits,a) in enumerate(group)],
                         'fine_Kraus_span_rank_at_1e_minus_10':int(np.linalg.matrix_rank(np.column_stack(vectors),tol=1e-10)),
                         'branches':details})
        worst_probability = max(abs(b['outcome_probability_witness_gap']) for row in rows for b in row['branches'])
        worst_choi = max(b['normalized_Choi_Frobenius_residual'] for row in rows for b in row['branches'])
        # A large explicit mismatch, not failure to find a recovery algorithm.
        assert worst_probability > 1e-6 and worst_choi > 1e-6
        results.append({'mode':cases[index]['mode'],'QPY_sha256':digest(payload),
                        'formal_fixture_branches':len(branches),'coarse_records':len(groups),
                        'fixed_width_residual_bits':(max(len(group) for group in groups.values())-1).bit_length(),
                        'maximum_probability_witness_gap':worst_probability,
                        'maximum_normalized_Choi_residual':worst_choi,'groups':rows})
    output = {'schema':'vi.record-recovery-fixture-diagnostic.v1','cases':results,
              'seconds':time.perf_counter()-began,'new_QPU_jobs':0,
              'scope':'Numerical exact-model fixtures, arbitrary retained input. '
                      'Not hardware probabilities or a calibrated physical instrument. '
                      'Classical reconstruction only; failure does not forbid other quantum contacts.'}
    OUT.mkdir(exist_ok=True)
    (OUT/'fixtures.json').write_text(json.dumps(output,indent=2)+'\n')
    print(json.dumps({'cases':[{k:v for k,v in case.items() if k!='groups'} for case in results],
                      'seconds':output['seconds']},indent=2))


if __name__ == '__main__': run()
