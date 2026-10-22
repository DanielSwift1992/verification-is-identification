#!/usr/bin/env python3
"""Frozen reader: see Checks/Archive/WhereV2/README.md.

Bounded completion audit of the 15 September resident research session.

Reads sealed evidence; writes only to a new output directory. No network,
calibration, QPU submission, Swift build, or general repository regression.
Hash agreement preserves provenance, not the truth of an interpretation.
"""
import argparse
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import re
import shutil
import subprocess
import time

ROOT = Path(__file__).resolve().parents[2]
ARTIFACTS = ROOT / 'Research/Artifacts'
NATIVE = ROOT / '.build/arm64-apple-macosx/debug/Tools'
JUDGE = ROOT / 'Checks/Archive/WhereV2/judge-where.js'
# New, unrelated research folders must not invalidate this night's reading.
# Its acquisition scope is these packages, not every future dated directory.
PACKAGES = tuple('resident-' + name + '-20260915' for name in (
    'acquisition', 'adaptive-checkpoint', 'classical-control', 'completion',
    'contact-memory', 'failure-evidence', 'flat-controller', 'framed-contact',
    'goal-acquisition', 'goal-memory', 'joint-evidence', 'measurement-wire',
    'numerical-bounds', 'orientation-word', 'raw-reply', 'reading-cost',
    'repeated-read', 'reporter-policy', 'stopped-read', 'stream',
    'supported-contact', 'wire-audit', 'wire-readout', 'workbench', 'joint-cost',
))
OLD_REPORTS = {
    'resident-acquisition-20260915': '2026-09-15-selective-resident-continuation.md',
    'resident-classical-control-20260915': '2026-09-15-acquired-classical-control.md',
    'resident-framed-contact-20260915': '2026-09-15-framed-measurement-continuation.md',
}


def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def read(path):
    return json.loads(Path(path).read_text())


def verify_map(entries, base, checked):
    for name, expected in entries.items():
        path = (base / name).resolve()
        actual = digest(path)
        assert actual == expected, f'Changed sealed input: {path}'
        key = str(path.relative_to(ROOT)) if path.is_relative_to(ROOT) else str(path)
        if key in checked:
            assert checked[key] == actual
        checked[key] = actual


def receipts():
    checked, rows = {}, []
    for path in sorted(ARTIFACTS / name / 'receipt.json' for name in PACKAGES):
        receipt = read(path)
        if 'sha256' in receipt:
            verify_map(receipt['sha256'], ROOT, checked)
            count = len(receipt['sha256'])
        else:
            report = ROOT / 'Research' / OLD_REPORTS[path.parent.name]
            verify_map({str(report): receipt['report_sha256']}, ROOT, checked)
            verify_map(receipt['artifact_sha256'], path.parent, checked)
            count = len(receipt['artifact_sha256']) + 1
        rows.append({'receipt': str(path.relative_to(ROOT)),
                     'receipt_sha256': digest(path), 'entries': count})
    assert len(rows) == 25, f'Unexpected nightly receipt inventory: {len(rows)}'
    return rows, checked


def courts(checked):
    specifications, rows = [], []
    for path in sorted(ARTIFACTS / name / 'build.json' for name in PACKAGES):
        if not path.exists():
            continue
        build = read(path)
        if 'equalities' not in build:
            continue
        verify_map(build['source_sha256'], ROOT, checked)
        positive = [p for p in path.parent.glob('*.swift')
                    if not p.name.startswith('Rejected')]
        assert len(positive) == 1, path
        specifications.append({'file': str(positive[0]),
                               'equalities': build['equalities'], 'positive': True})
        for negative in build['negatives']:
            specifications.append({'file': str(path.parent / negative['file']),
                                   'name': negative['name'], 'positive': False})
    assert sum(x['positive'] for x in specifications) == 14
    assert sum(not x['positive'] for x in specifications) == 40
    assert sum(x.get('equalities', 0) for x in specifications) == 498

    script = """
const fs=require('node:fs');
const {judgeWhereTexts}=require(process.argv[1]);
const specs=JSON.parse(fs.readFileSync(0,'utf8'));
process.stdout.write(JSON.stringify(specs.map(s=>{
 const r=judgeWhereTexts(fs.readFileSync(s.file,'utf8'));
 return {file:s.file,judged:r.judged,refusals:r.refusals};
})));
"""
    node = shutil.which('node')
    assert node is not None
    js = subprocess.run([node, '-e', script, str(JUDGE)],
                        input=json.dumps(specifications), text=True,
                        capture_output=True, timeout=90, check=True)
    answers = json.loads(js.stdout)
    assert len(answers) == len(specifications)
    for spec, answer in zip(specifications, answers):
        assert answer['file'] == spec['file']
        native = subprocess.run([str(NATIVE), 'judge', 'where', spec['file']],
                                text=True, capture_output=True, timeout=20)
        text = native.stdout + native.stderr
        if spec['positive']:
            assert not answer['refusals'] and answer['judged'] == spec['equalities']
            match = re.search(r'THE WHERE holds: (\d+) equalities', text)
            assert native.returncode == 0 and match, (spec, text)
            assert int(match.group(1)) == spec['equalities']
        else:
            assert answer['refusals'], spec
            assert native.returncode == 1 and 'requires the types' in text, (spec, text)
        rows.append({'file': str(Path(spec['file']).relative_to(ROOT)),
                     'positive': spec['positive'], 'equalities': spec.get('equalities'),
                     'JS_judged': answer['judged'], 'JS_refusals': answer['refusals'],
                     'native_exit': native.returncode, 'native_output': text.strip()})
    return {'positive_files': 14, 'equalities': 498, 'negative_files': 40,
            'rows': rows, 'native_binary_sha256': digest(NATIVE),
            'JS_judge_sha256': digest(JUDGE),
            'node_version': subprocess.check_output([node, '--version'], text=True).strip(),
            'scope': 'Existing finite equality courts, not full Swift typechecking or a proof of analytic error bounds.'}


def hardware_inputs(checked):
    old = read(ARTIFACTS / 'resident-wire-audit-20260915/audit.json')
    verify_map(old['original_packet_sha256'], ROOT, checked)
    rows = []
    for name in ['ibm-resident-feedback-20260915.json',
                 'ibm-resident-boundary-20260915.json']:
        result = read(ARTIFACTS / name)
        assert result['status'] == 'DONE' and result['paid_cost_usd'] == 0
        rows.append({key: result[key] for key in
                     ['job_id', 'status', 'backend', 'actual_free_QPU_seconds', 'paid_cost_usd']})
        rows[-1]['total_shots'] = result.get('shot_count', result.get('shots'))
    assert sum(row['actual_free_QPU_seconds'] for row in rows) == 12
    assert sum(row['total_shots'] for row in rows) == 26624
    return {'sealed_private_inputs_verified': len(old['original_packet_sha256']),
            'jobs': rows, 'network_calls': 0,
            'scope': 'Verification of saved completed jobs, not a fresh quota or hardware-calibration reading.'}


def qpy_control_scan():
    import qiskit
    from qiskit import qpy
    import qiskit_aer
    paths = {path for name in PACKAGES for path in (ARTIFACTS / name).rglob('*.qpy')}
    paths.update(ROOT / 'private' / name / 'isa.qpy' for name in
                 ['ibm-resident-acquisition-20260915', 'ibm-resident-boundary-20260915'])
    rows, findings = [], []

    def walk(body, location, found):
        for index, item in enumerate(body.data):
            for branch, block in enumerate(getattr(item.operation, 'blocks', ())):
                here = location + [index, branch]
                if block.num_qubits == 0 and any(op.operation.name == 'store' for op in block.data):
                    found.append(here)
                walk(block, here, found)

    for path in sorted(paths):
        with path.open('rb') as stream:
            circuits = qpy.load(stream)
        records = []
        for index, circuit in enumerate(circuits):
            found = []
            walk(circuit, [], found)
            if found:
                records.append({'circuit': index, 'locations': found})
        name = str(path.relative_to(ROOT))
        if records:
            findings.append(name)
        rows.append({'file': name, 'sha256': digest(path),
                     'circuits': len(circuits), 'zero_width_Store_blocks': records})
    expected = {'Research/Artifacts/resident-stopped-read-20260915/classical-branch-probe/'
                + f'branch-0-{bit}.qpy' for bit in [0, 1]}
    assert set(findings) == expected, findings
    return {'QPY_files': len(rows), 'circuits': sum(r['circuits'] for r in rows),
            'only_intentional_issue_reproducers_contain_detected_shape': True,
            'findings': findings, 'files': rows,
            'Qiskit_version': qiskit.__version__, 'Aer_version': qiskit_aer.__version__,
            'scope': 'Structural scan for the reproduced local zero-quantum-width Store issue; absence is not general SDK correctness.'}


def run(output):
    start = time.perf_counter()
    receipt_rows, checked = receipts()
    print(f'Verified {len(receipt_rows)} sealed receipts.', flush=True)
    court_result = courts(checked)
    print('Native and JS: 498 equalities and 40 expected refusals.', flush=True)
    hardware = hardware_inputs(checked)
    control = qpy_control_scan()
    print(f'Checked {control["QPY_files"]} QPY files and saved hardware provenance.', flush=True)
    from resident_adaptive_checkpoint_checks import run as live_run
    from resident_numerical_bounds_checks import run as numerical_run
    from resident_joint_cost_checks import run as joint_cost_run
    for name in ['live-continuation', 'numerical-bounds', 'joint-cost']:
        (output / name).mkdir(parents=True, exist_ok=True)
    live = live_run(output / 'live-continuation')
    numeric = numerical_run(output / 'numerical-bounds')
    joint_cost = joint_cost_run(output / 'joint-cost')
    # No sealed input may have changed while the concrete continuation ran.
    after, after_checked = receipts()
    assert after == receipt_rows
    verify_map(checked, ROOT, {})
    result = {'schema': 'vi.resident-night-completion-audit.v1',
              'completed_UTC': datetime.now(timezone.utc).isoformat(),
              'receipts': receipt_rows, 'verified_input_sha256': checked,
              'unique_checked_input_files': len(checked), 'courts': court_result,
              'hardware_inputs': hardware, 'QPY_control_scan': control,
              'live_continuation': {
                  'positive_full_joint_states': 1664,
                  'intentional_wrong_owner_states': live['wrong_owner_counterexample']['full_joint_states_checked'],
                  'maximum_correct_joint_state_error': live['maximum_correct_joint_state_error'],
                  'refusals': live['refusals'], 'seconds': live['seconds'],
                  'audit_sha256': digest(output / 'live-continuation/audit.json')},
              'numerical_bounds': {
                  'fixed_cost_bounds': numeric['fixed_cost_bounds'],
                  'adaptive_joint_error_interval': numeric['adaptive_joint_error_interval'],
                  'seconds': numeric['seconds'],
                  'audit_sha256': digest(output / 'numerical-bounds/audit.json')},
              'joint_cost': {
                  'selected_readings': joint_cost['selected']['selected_readings'],
                  'joint_error_upper': joint_cost['selected']['joint_error_upper'],
                  'expected_report_reads_upper': joint_cost['selected']['expected_report_reads_upper'],
                  'sixteen_plan_minimum': joint_cost['selected']['minimum_expected_cost'],
                  'full_joint_states_checked': joint_cost['full_joint_states_checked'],
                  'maximum_joint_state_error': joint_cost['maximum_joint_state_error'],
                  'refusals': joint_cost['refusals'], 'seconds': joint_cost['seconds'],
                  'audit_sha256': digest(output / 'joint-cost/audit.json')},
              'new_calibrations': 0, 'new_QPU_jobs': 0, 'network_calls': 0,
              'full_repository_regression': False, 'full_Swift_typecheck': False,
              'check_sha256': digest(__file__), 'seconds': time.perf_counter() - start}
    (output / 'audit.json').write_text(json.dumps(result, indent=2) + '\n')
    return result


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    value = run(args.output.resolve())
    print(json.dumps({key: value[key] for key in
                     ['completed_UTC', 'unique_checked_input_files', 'seconds',
                      'new_calibrations', 'new_QPU_jobs', 'full_repository_regression']}))
