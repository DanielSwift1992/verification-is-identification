#!/usr/bin/env python3
"""Resolve review hypotheses against frozen ISA and package actual evidence.

Read-only toward all old packets. No cloud client, credentials or new jobs.
The small portable verifier reuses the already independent byte/wire audit,
not the experiment's original collector or its declared ideal model.
"""

import sys as _evidence_sys
from pathlib import Path as _EvidencePath
_evidence_sys.path.insert(0, str(_EvidencePath(__file__).resolve().parents[1]))
import hardware_runs as _runs
_runs.configure(required=(__name__ == "__main__"))
import argparse
from collections import Counter
import json
from pathlib import Path
import shutil
import time
import zipfile

from qiskit import qpy
import resident_wire_audit as w


VERIFY = '''#!/usr/bin/env python3
"""Offline: Python + numpy + qiskit; no IBM SDK, account, Aer or network."""
from pathlib import Path
import json
from qiskit import qpy
import wire_reader as w
root=Path(__file__).resolve().parent
manifest=w.read(root/'manifest.json')
assert all(w.digest(root/n)==h for n,h in manifest['package_sha256'].items())
total=0;diagnostics=0;maximum=0.
for name in ('feedback','boundary'):
    p=root/name
    with (p/'isa.qpy').open('rb') as f: circuits=qpy.load(f)
    raw=w.raw_arrays(p/'raw-result.json')
    hardware=w.read(p/'hardware-result-view.json')
    old={(r['variant'],r['probe']):r for r in hardware['rows']}
    ideals={(r['variant'],r['probe']):r['ideal_probabilities'] for r in w.read(p/'ideal-validation.json')}
    plan=w.read(p/'plan-view.json')
    assert w.digest(p/'isa.qpy')==plan['qpy_sha256']
    assert w.digest(p/'raw-result.json')==hardware['raw_sha256']
    assert len(circuits)==len(raw)==len(old)
    for c,a in zip(circuits,raw):
        key=(c.metadata['variant'],c.metadata['probe'])
        assert c.metadata==a['metadata']
        assert a['counts']==old[key]['counts']
        route=w.route(c)
        if name=='boundary':
            assert [route[j]['physical_qubit'] for j in range(4)]==[23,23,16,3]
            probabilities,traces=w.diagnostic_ideal(c)
            error=max(abs(probabilities[k]-ideals[key][k]) for k in probabilities)
            assert error<1e-10
            maximum=max(maximum,error);diagnostics+=1
        total+=len(a['ints'])
print(json.dumps({'shots_decoded':total,'independent_diagnostic_models':diagnostics,
                  'maximum_ideal_difference':maximum,'files_verified':len(manifest['package_sha256']),
                  'QPU_jobs':0},indent=2))
'''


def run(output):
    start = time.perf_counter()
    output.mkdir(parents=True, exist_ok=False)
    bundle = output/'evidence'
    bundle.mkdir()
    frozen = _runs.rebind_map(w.read(w.ROOT/'Research/Artifacts/resident-wire-audit-20260915/audit.json')['original_packet_sha256'],w.ROOT)
    assert all(w.digest(_runs.resolve_recorded(n,h,w.ROOT)) == h for n, h in frozen.items())
    prior_final = w.read(w.ROOT/'Research/Artifacts/resident-night-final-audit-20260915/receipt.json')
    assert all(w.digest(_runs.resolve_recorded(n,h,w.ROOT)) == h for n, h in prior_final['sha256'].items())
    findings = []
    all_measures = {}
    for name, dirname in [('feedback', 'ibm-resident-acquisition-20260915'),
                          ('boundary', 'ibm-resident-boundary-20260915')]:
        folder = _runs.root()/dirname
        dest = bundle/name
        dest.mkdir()
        for file in ['isa.qpy', 'raw-result.json', 'ideal-validation.json', 'source-reading.json']:
            shutil.copyfile(folder/file, dest/file)
        plan = w.read(folder/'plan.json')
        # Explicit views: retain experiment information, omit account/usage.
        keys = ['schema', 'created_at', 'tag', 'backend', 'shots', 'max_seconds',
                'physical_D_C_P', 'physical_D_R_P', 'target_snapshot', 'calibration_selection',
                'cases', 'order', 'manifests', 'implementation', 'versions', 'source_sha256',
                'qpy_sha256', 'source_reading_sha256', 'analysis', 'options']
        plan_view = {k: plan[k] for k in keys if k in plan}
        plan_view['original_plan_sha256'] = w.digest(folder/'plan.json')
        plan_view['view_notice'] = 'Selected fields, not byte-identical original plan. Account and usage fields omitted.'
        w.write(dest/'plan-view.json', _runs.bind_receipt(plan_view, destination=dest/'plan-view.json'))
        hardware = w.read(folder/'hardware-result.json')
        view = {k: hardware[k] for k in ['job_id', 'status', 'backend', 'collected_at', 'rows', 'analysis', 'raw_sha256', 'collector_sha256']}
        view['original_hardware_result_sha256'] = w.digest(folder/'hardware-result.json')
        w.write(dest/'hardware-result-view.json', _runs.bind_receipt(view, destination=dest/'hardware-result-view.json'))
        with (folder/'isa.qpy').open('rb') as f:
            circuits = qpy.load(f)
        arrays = w.raw_arrays(folder/'raw-result.json')
        assert len(circuits) == len(arrays)
        measure_counts = Counter()
        for i, (c, raw) in enumerate(zip(circuits, arrays)):
            assert c.metadata == raw['metadata']
            ops = w.flatten(c)
            for op in ops:
                if op['name'] in ('measure', 'measure_2'):
                    measure_counts[(op['name'], op['qubits'][0])] += 1
            if name != 'boundary':
                continue
            probabilities, traces = w.diagnostic_ideal(c)
            ctrace = [op for op in ops if 16 in op['qubits'] and op['name'] != 'barrier']
            assert all(not op['conditions'] for op in ctrace)
            assert [op['name'] for op in ctrace] in [
                ['reset', 'measure'], ['reset', 'x', 'measure'], ['reset', 'x', 'reset', 'measure']]
            ones = sum((v >> 2) & 1 for v in raw['ints'])
            by_b = {str(b): {'shots': sum((v & 1) == b for v in raw['ints']),
                            'C_one': sum((v & 1) == b and (v >> 2) & 1 for v in raw['ints'])}
                    for b in (0, 1)}
            record = {'pub_index': i, 'variant': c.metadata['variant'], 'probe': c.metadata['probe'],
                      'C_operations': ctrace, 'intended_C': traces[0]['ideal_C'],
                      'C_zero': 1024-ones, 'C_one': ones, 'by_acquired_b_descriptive': by_b,
                      'flattened_operation_count_with_barriers': len(ops),
                      'explicit_delay_count': sum(op['name'] == 'delay' for op in ops),
                      'explicit_intermediate_C_measurements': 0, 'conditional_C_operations': 0,
                      'ideal_probability_sum': sum(probabilities.values())}
            findings.append(record)
            if c.metadata['probe'] == 'Z' and c.metadata['variant'] in ('Baseline11', 'Toggle00'):
                w.write(dest/(c.metadata['variant']+'-Z-actual-ISA.json'),
                        _runs.bind_receipt({'pub_index': i, 'metadata': c.metadata, 'instructions': ops,
                         'raw_counts': raw['counts'], 'analysis': record,
                         'scope': 'Projection of an intact submitted circuit. Not a separately executed isolated C circuit or reconstructed pulse schedule.'}, destination=dest/(c.metadata['variant']+'-Z-actual-ISA.json')))
        all_measures[name] = [{'instruction': k[0], 'wire': k[1], 'count': v} for k, v in sorted(measure_counts.items())]
        assert not any(k[1] == 16 and k[0] == 'measure_2' for k in measure_counts)
    selected = {}
    for desired in (0, 1):
        rows = [r for r in findings if r['intended_C'] == desired]
        selected[str(desired)] = min(rows, key=lambda r: r['flattened_operation_count_with_barriers'])
    assert selected['0']['variant'] == 'Toggle00' and selected['0']['probe'] == 'Z'
    assert selected['1']['variant'] == 'Baseline11' and selected['1']['probe'] == 'Z'
    result = {'schema': 'vi.review-ISA-followup.v1', 'diagnostic_rows': findings,
              'all_submitted_measurements': all_measures,
              'shortest_available_frozen_witnesses_by_operation_count': selected,
              'review_C_measure_wait_invert_chain_present': False,
              'explicit_C_midcircuit_measurement_in_either_ISA': False,
              'explicit_matched_delay_controls_available': False,
              'isolated_baseline_zero_available': False,
              'physical_cause_identified': False,
              'scope': 'Actual QPY instruction order and raw records, not provider pulse schedule or proof of physical reset/readout.',
              'original_packets_unchanged': True, 'verified_original_files': len(frozen),
              'previous_final_receipt_files_verified': len(prior_final['sha256']),
              'new_QPU_jobs': 0, 'seconds': time.perf_counter()-start}
    w.write(bundle/'followup.json', _runs.bind_receipt(result, destination=bundle/'followup.json'))
    shutil.copyfile(_runs.owned(w.__file__), bundle/'wire_reader.py')
    shutil.copyfile(_runs.owned(_runs.__file__), bundle/'hardware_runs.py')
    (bundle/'verify.py').write_text(VERIFY)
    (bundle/'README.md').write_text('''# Actual hardware evidence, 15 September 2026

Two frozen jobs: feedback (10 circuits, 10,240 shots), boundary (16 circuits,
16,384 shots). The original `isa.qpy` and `raw-result.json` bytes are included.
Plans and collected summaries are explicitly labelled views; account/usage
fields are omitted. Circuit metadata still contains local source paths/hashes.
No credentials, billing configuration or new cloud execution are included.

Run offline in an environment with Python, NumPy and Qiskit 2.5.2 or compatible:

    python verify.py

This checks every exported file hash, decodes every raw shot without
RuntimeDecoder/BitArray.get_counts, binds each result to its actual QPY,
and independently calculates all 16 separable diagnostic ideal distributions.
It does not simulate the first job's entangling circuits or establish device
noise, intermediate physical states, or a pulse schedule.

`followup.json` identifies the shortest AVAILABLE frozen examples with each
intended C value by flattened instruction count. The two readable ISA JSONs
retain all instructions and physical addresses; their C-only projection is
NOT a separately executed minimal circuit. No C mid-circuit measurement or
conditional C gate exists in the diagnostic job. The first job does not
measure C at all. The proposed C-measure/wait/invert hypothesis therefore
does not match these submitted instruction sequences. This statement concerns
explicit ISA instructions. It does not inspect the physical implementation of
reset, measurement or provider-side scheduling, and does not exclude internal
measurement/feedback or other backaction during those operations.

The local measured-choice correction belongs to a later, different program;
it is not an explanation of these jobs. Baseline0 in isolation, timing-matched
controls and repeated C measurement are absent. Physical cause remains open.
''')
    package_hashes = {str(p.relative_to(bundle)): w.digest(p) for p in bundle.rglob('*') if p.is_file()}
    w.write(bundle/'manifest.json', _runs.bind_receipt({'package_sha256': package_hashes,
            'original_packet_sha256': frozen, 'generator_sha256': w.digest(_runs.owned(__file__)),
            'scope': 'Integrity and provenance inventory, not proof of prose or physical execution.'}, destination=bundle/'manifest.json'))
    assert all(w.digest(_runs.resolve_recorded(n,h,w.ROOT)) == h for n, h in frozen.items())
    with zipfile.ZipFile(output/'hardware-evidence.zip', 'w', zipfile.ZIP_DEFLATED) as archive:
        for p in sorted(bundle.rglob('*')):
            if p.is_file():
                archive.write(p, _runs.owned('vi-hardware-evidence')/p.relative_to(bundle))
    return result


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=_runs.owned, required=True)
    result = run(parser.parse_args().output.resolve())
    print(json.dumps(_runs.bind_receipt({k: result[k] for k in ['all_submitted_measurements',
                     'review_C_measure_wait_invert_chain_present', 'verified_original_files', 'seconds']}), indent=2))
