#!/usr/bin/env python3
"""Check a supplied Press JSON carrier against the owner's complete finite suite."""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import time

SUITE_HASHES = {'vi.press.substitution/0.1': 'cf01573a6326db2c7749046867c10de5e6a8ef50b41941ffcbbaf630dc105b64', 'vi.press.substitution/0.2': '5c9657f01799795ead0a413a9343b27fa9eadd7504133808a38b3e2da1370e1f'}


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_contract(path):
    root = path.resolve().parent
    manifest = json.loads(path.read_text(encoding='utf-8'))
    if manifest.get('schema') != 'vi.press.conformance/1' or SUITE_HASHES.get(manifest.get('suite')) != digest(path):
        raise ValueError('unregistered or changed manifest for this suite identity')
    for name, wanted in manifest['files'].items():
        file = (root / name).resolve()
        if not file.is_relative_to(root) or digest(file) != wanted:
            raise ValueError('fixture path/hash mismatch: ' + name)
    if manifest['cases_file'] not in manifest['files']:
        raise ValueError('unbound cases file')
    cases = json.loads((root / manifest['cases_file']).read_text(encoding='utf-8'))
    ids = [c['id'] for c in cases]
    if not ids or ids != manifest['cases'] or len(set(ids)) != len(ids):
        raise ValueError('incomplete or duplicate case set')
    return manifest, cases


def mismatches(actual, expected):
    if not isinstance(actual, dict):
        return ['response is not an object']
    errors = []
    if actual.get('state') != expected['state']:
        errors.append('state bytes')
    if type(actual.get('changed')) is not bool or actual['changed'] != expected['changed']:
        errors.append('changed')
    if 'replayed' in expected and actual.get('replayed') is not expected['replayed']:
        errors.append('certificate replay')
    refusal = actual.get('refusal')
    if expected['refusal'] is None:
        if refusal is not None:
            errors.append('unexpected refusal')
    elif not isinstance(refusal, dict):
        errors.append('missing addressed refusal')
    else:
        if refusal.get('address') != expected['refusal']['address']:
            errors.append('refusal address')
        if not isinstance(refusal.get('reason'), str) or expected['refusal']['reason_contains'] not in refusal['reason']:
            errors.append('refusal reason')
    return errors


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--manifest', type=Path, default=Path(__file__).resolve().parents[1] / 'Contracts/Press/v0.1/contract.json')
    parser.add_argument('--command-json', required=True)
    parser.add_argument('--implementation-id', required=True)
    parser.add_argument('--report', type=Path)
    parser.add_argument('--timeout', type=float, default=15)
    args = parser.parse_args()
    try:
        manifest, cases = load_contract(args.manifest)
        command = json.loads(args.command_json)
        if not isinstance(command, list) or not command or not all(isinstance(x, str) and x for x in command) or not Path(command[0]).is_absolute():
            raise ValueError('command must be an argv array with an absolute executable')
        if args.timeout <= 0:
            raise ValueError('timeout must be positive')
        report = {'suite': manifest['suite'], 'manifest_sha256': digest(args.manifest), 'implementation_id': args.implementation_id,
                  'command': command, 'executable_sha256': digest(Path(command[0])), 'results': []}
        for case in cases:
            start = time.monotonic()
            actual = None
            process = {}
            try:
                result = subprocess.run(command, input=json.dumps(case['request'], ensure_ascii=False).encode('utf-8'), capture_output=True, timeout=args.timeout)
                process = {'exit': result.returncode, 'stdout': result.stdout.decode('utf-8'), 'stderr': result.stderr.decode('utf-8')}
                actual = json.loads(process['stdout'])
                errors = mismatches(actual, case['expected'])
                if result.returncode != 0 or result.stderr:
                    errors.append('carrier exit/stderr')
            except (OSError, subprocess.TimeoutExpired, UnicodeError, ValueError) as exc:
                errors = [type(exc).__name__ + ': ' + str(exc)]
            row = {'id': case['id'], 'actual': actual, 'process': process, 'mismatches': errors, 'seconds': round(time.monotonic() - start, 6)}
            report['results'].append(row)
            print(('FAIL ' if errors else 'PASS ') + case['id'] + (': ' + ', '.join(errors) if errors else ''))
        report['passed'] = all(not r['mismatches'] for r in report['results'])
        report['claim'] = 'Finite substitution suite only; no general equivalence or publication guarantee.'
        if args.report:
            args.report.write_text(json.dumps(report, ensure_ascii=True, indent=2) + '\n', encoding='utf-8')
        print(str(sum(not r['mismatches'] for r in report['results'])) + '/' + str(len(cases)))
        return 0 if report['passed'] else 1
    except (OSError, ValueError, KeyError, TypeError) as exc:
        print('press contract: ' + str(exc), file=sys.stderr)
        return 2


if __name__ == '__main__':
    sys.exit(main())
