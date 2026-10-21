#!/usr/bin/env python3
"""Run the versioned finite CLI contract against a supplied implementation.

The command is an argv array, never shell source. Expectations live in the
versioned manifest, separately from observed results. No output is accepted
on the strength of an exit code alone.
"""
from collections import Counter
from pathlib import Path
import argparse
import hashlib
import json
import re
import subprocess
import sys
import tempfile
import time


# An immutable suite name binds the exact manifest bytes, including its case set.
# New normative expectations require a new release and a deliberate registry entry.
SUITE_HASHES = {
    "vi.court.questions/0.3": "85386b2809b8d36a8f74c59df6c8a6768ee10747b3850b1e2c4bf123cdf746ef",
    "vi.court.questions/0.2": "89803c35cccd5f1c3cf8f2cc451a60e08b7a82d8195b6289f9c3475eb71a54c9",
    "vi.court.questions/0.1": "f6092c3c2bcfed822ee8aef878bb2b0d42c2756ec4fc002026d6d5a9fdfd54e6",
}


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def within(root, name):
    path = (root / name).resolve()
    if not path.is_relative_to(root):
        raise ValueError(f"input escapes contract directory: {name}")
    return path


def load_contract(path):
    root = path.resolve().parent
    contract = json.loads(path.read_text())
    if contract.get('schema') != 'vi.court.conformance/1':
        raise ValueError('unknown manifest schema')
    expected_hash = SUITE_HASHES.get(contract.get('suite'))
    if expected_hash is None or digest(path) != expected_hash:
        raise ValueError('unregistered or changed manifest for this suite identity')
    cases = contract['cases']
    ids = [case['id'] for case in cases]
    if not cases or len(ids) != len(set(ids)):
        raise ValueError('empty or duplicate case list')
    absent = set(contract['missing_files'])
    for name in absent:
        if within(root, name).exists():
            raise ValueError(f'missing-file control exists: {name}')
    for name, entry in contract['files'].items():
        if digest(within(root, name)) != entry['sha256']:
            raise ValueError(f'fixture hash mismatch: {name}')
    for case in cases:
        if case['pass'] not in ('where', 'count') or not case['files']:
            raise ValueError(f"invalid pass or empty inputs: {case['id']}")
        if not set(case['files']) <= set(contract['files']) | absent:
            raise ValueError(f"unbound input: {case['id']}")
        for channel in ('stdout', 'stderr'):
            rule = case['expected'][channel]
            if ('lines' in rule) == ('line_patterns' in rule):
                raise ValueError(f"ambiguous output rule: {case['id']}")
            for pattern in rule.get('line_patterns', []):
                re.compile(pattern)
    return root, contract


def channel_matches(text, rule):
    # CRLF is the only permitted transport normalization. VT/CR/Unicode
    # separators cannot hide a required LF-delimited record.
    text = text.replace('\r\n', '\n')
    if any(separator in text for separator in ('\r', '\v', '\f', '\u0085', '\u2028', '\u2029')):
        return False
    if text and not text.endswith('\n'):
        return False
    lines = text[:-1].split('\n') if text else []
    if 'lines' in rule:
        wanted = rule['lines']
        return Counter(lines) == Counter(wanted) if rule.get('unordered') else lines == wanted
    patterns = rule['line_patterns']
    return len(lines) == len(patterns) and all(re.fullmatch(p, line) for p, line in zip(patterns, lines))


def mismatches(actual, expected):
    if actual.get('error'):
        return [actual['error']]
    failures = []
    if actual['exit'] != expected['exit']:
        failures.append('exit')
    for channel in ('stdout', 'stderr'):
        if not channel_matches(actual[channel], expected[channel]):
            failures.append(channel)
    return failures


def run(argv, root, timeout):
    start = time.monotonic()
    try:
        result = subprocess.run(argv, cwd=root, capture_output=True, timeout=timeout)
        return {'argv': argv, 'exit': result.returncode, 'stdout': result.stdout.decode('utf-8', errors='replace'),
                'stderr': result.stderr.decode('utf-8', errors='replace'), 'seconds': round(time.monotonic() - start, 6)}
    except (OSError, subprocess.TimeoutExpired) as exc:
        return {'argv': argv, 'exit': None, 'stdout': '', 'stderr': '',
                'error': type(exc).__name__, 'detail': str(exc),
                'seconds': round(time.monotonic() - start, 6)}


def compiler_failures(actual, expected):
    if actual.get('error'):
        return [actual['error']]
    errors = []
    if actual['exit'] != expected['exit'] or actual['stdout']:
        errors.append('compiler exit/stdout')
    if expected['diagnostic'] == 'none':
        if actual['stderr']:
            errors.append('compiler diagnostic')
    else:
        lines = re.findall(r'^.*:\d+:\d+: error:.*$', actual['stderr'], re.M)
        if len(lines) != 1 or 'requires the types' not in lines[0] or 'be equivalent' not in lines[0]:
            errors.append('compiler equivalence diagnostic')
    return errors


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--manifest', type=Path, default=Path(__file__).resolve().parents[1] / 'Contracts/Court/v0.1/contract.json')
    parser.add_argument('--command-json', required=True, help='JSON argv prefix, e.g. ["/absolute/Tools", "judge"]')
    parser.add_argument('--implementation-id', required=True, help='caller-supplied identity; not proof of a source/binary correspondence')
    parser.add_argument('--compiler', help='optional Swift compiler for the six compiler-backed fixtures')
    parser.add_argument('--report', type=Path)
    parser.add_argument('--timeout', type=float, default=60)
    args = parser.parse_args()
    try:
        command = json.loads(args.command_json)
        if not isinstance(command, list) or not command or not all(isinstance(s, str) and s for s in command):
            raise ValueError('command must be a nonempty array of strings')
        if args.timeout <= 0:
            raise ValueError('timeout must be positive')
        root, contract = load_contract(args.manifest)
        executable = Path(command[0])
        if not executable.is_absolute():
            raise ValueError('command executable must have an absolute path')
        report = {'schema': 'vi.court.conformance-report/1', 'suite': contract['suite'],
                  'manifest_sha256': digest(args.manifest), 'versions': contract['versions'],
                  'implementation_id': args.implementation_id, 'command': command,
                  'executable_sha256': digest(executable),
                  'identity_scope': 'Executable hash and caller label only; wrapper/interpreter dependencies need a separate build receipt.',
                  'compiler_requested': bool(args.compiler), 'results': []}
        with tempfile.TemporaryDirectory(prefix='vi-court-contract-') as tmp:
            for case in contract['cases']:
                actual = run(command + [case['pass']] + case['files'] + case['args'], root, args.timeout)
                failures = mismatches(actual, case['expected'])
                row = {'id': case['id'], 'expected_outcome_for_this_case': case['expected']['outcome_for_this_case'],
                       'actual': actual, 'mismatches': failures}
                if args.compiler and 'compiler' in case:
                    compiled = run([args.compiler, '-typecheck', '-module-cache-path', tmp + '/cache'] + case['files'], root, args.timeout)
                    row['compiler'] = compiled
                    failures.extend(compiler_failures(compiled, case['compiler']))
                row['matched'] = not failures
                report['results'].append(row)
                print(('PASS ' if row['matched'] else 'FAIL ') + case['id'] + (': ' + ', '.join(failures) if failures else ''))
        report['passed'] = all(r['matched'] for r in report['results'])
        report['claim'] = 'This implementation matched this finite CLI suite.' if report['passed'] else 'This implementation did not match this finite CLI suite.'
        if args.report:
            args.report.parent.mkdir(parents=True, exist_ok=True)
            args.report.write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')
        print(f"{sum(r['matched'] for r in report['results'])}/{len(report['results'])} cases matched; general equivalence is not established")
        return 0 if report['passed'] else 1
    except (OSError, ValueError, KeyError, TypeError) as exc:
        print(f'court-contract: {exc}', file=sys.stderr)
        return 2


if __name__ == '__main__':
    sys.exit(main())
