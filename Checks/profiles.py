#!/usr/bin/env python3
"""Run and measure one named, pre-extraction check profile."""
import argparse
import datetime
import fcntl
import hashlib
import json
import os
from pathlib import Path
import platform
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parent.parent
PROFILES = {
    'vi': ['verdict', 'renames', 'topics', 'families', 'quotes'],
    'court': ['light', 'ladder', 'grants', 'alias', 'extension', 'conditional',
              'memberships', 'lexical', 'scope', 'applications', 'court', 'contract', 'response'],
    'integration': ['build', 'lawcheck-policy', 'archive-where', 'drawing', 'target-graph', 'artifacts', 'census', 'voice', 'readme', 'profiles', 'ci', 'law', 'boundary'],
}


def read_registry(root):
    raw = subprocess.check_output(['bash', 'check.sh', '--list'], cwd=root, text=True)
    registry = {}
    for line in raw.splitlines():
        parts = line.split('|', 2)
        if len(parts) != 3 or not all(parts) or parts[0] in registry:
            raise ValueError('invalid or duplicate law in check.sh --list')
        registry[parts[0]] = {'description': parts[1], 'command': parts[2]}
    validate_coverage(registry)
    return raw, registry


def validate_coverage(registry):
    if registry.get('verdict', {}).get('command') != 'bash Checks/verdict.sh':
        raise ValueError('verdict executor changed; its profile partition must be reviewed')
    selected = [item for group in PROFILES.values() for item in group]
    if len(selected) != len(set(selected)):
        raise ValueError('duplicate profile obligation')
    if set(selected) != set(registry):
        raise ValueError('profile coverage differs from registered laws: ' +
                         repr(sorted(set(selected) ^ set(registry))))


def command_for(item):
    if item.startswith('verdict:'):
        return ['bash', 'Checks/verdict.sh', item.split(':', 1)[1]]
    return ['bash', 'check.sh', '--only', item]


def git(root, *args):
    return subprocess.check_output(['git', *args], cwd=root, text=True).strip()


def timestamp():
    return datetime.datetime.now(datetime.timezone.utc).isoformat()


def require_snapshot(root, commit):
    if git(root, 'rev-parse', 'HEAD') != commit or git(root, 'status', '--porcelain'):
        raise ValueError('checkout changed after profile coverage was captured')


def measure(root, profile, output):
    root = root.resolve()
    output = output.resolve()
    if output == root or root in output.parents:
        raise ValueError('measurement output must be outside the source checkout')
    lock_path = Path(git(root, 'rev-parse', '--git-path', 'vi-profiles.lock'))
    if not lock_path.is_absolute():
        lock_path = root / lock_path
    with lock_path.open('a') as lock:
        try:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError as error:
            raise ValueError('a profile is already running in this checkout') from error
        # Capture and validate under the same lock used for this run. A registry
        # read by an earlier listing is never an input to measurement.
        commit = git(root, 'rev-parse', 'HEAD')
        require_snapshot(root, commit)
        registry_raw, registry = read_registry(root)
        require_snapshot(root, commit)
        output.mkdir(parents=True, exist_ok=False)
        report_path = output / 'result.json'
        report = {
            'schema': 'vi.check-profile-run/1', 'profile': profile,
            'commit': commit, 'checkout': str(root),
            'registry_sha256': hashlib.sha256(registry_raw.encode()).hexdigest(),
            'started_utc': timestamp(), 'pid': os.getpid(), 'state': 'running',
            'platform': platform.platform(), 'python': sys.version,
            'cache': {'build_directory_existed': (root / '.build').exists(),
                      'policy': 'Existing package and global caches retained; no cold-cache claim.'},
            'steps': [],
        }
        def save():
            temporary = report_path.with_suffix('.tmp')
            temporary.write_text(json.dumps(report, indent=2) + '\n')
            temporary.replace(report_path)
        save()
        started = time.monotonic()
        exit_code = 0
        try:
            report['swift_version'] = subprocess.check_output(['swift', '--version'], text=True).strip()
            for number, item in enumerate(PROFILES[profile], 1):
                require_snapshot(root, commit)
                log = output / f'{number:02d}-{item.replace(":", "-")}.log'
                step = {'obligation': item, 'command': command_for(item), 'log': str(log),
                        'started_utc': timestamp(), 'state': 'running'}
                report['steps'].append(step)
                save()
                before = time.monotonic()
                print(f'{profile}: {item}', flush=True)
                with log.open('wb') as stream:
                    result = subprocess.run(step['command'], cwd=root, stdout=stream, stderr=subprocess.STDOUT)
                step.update(elapsed_seconds=time.monotonic() - before, exit_code=result.returncode,
                            state='completed', log_sha256=hashlib.sha256(log.read_bytes()).hexdigest())
                save()
                if result.returncode:
                    exit_code = result.returncode if result.returncode > 0 else 1
                    break
            report['status_after'] = git(root, 'status', '--porcelain')
            report['commit_after'] = git(root, 'rev-parse', 'HEAD')
            if not exit_code and (report['status_after'] or report['commit_after'] != report['commit']):
                exit_code = 3
            report.update(state='completed', exit_code=exit_code)
        except BaseException as error:
            report.update(state='interrupted', error=repr(error))
            raise
        finally:
            report.update(finished_utc=timestamp(), elapsed_seconds=time.monotonic() - started)
            save()
        return exit_code


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--list', action='store_true', help='list validated profile commands; do not run checks')
    parser.add_argument('--profile', choices=PROFILES)
    parser.add_argument('--output', type=Path, help='new evidence directory outside the checkout')
    args = parser.parse_args()
    if args.list == bool(args.profile) or (args.list and args.output) or (args.profile and not args.output):
        parser.error('choose --list, or --profile NAME --output NEW_DIRECTORY')
    try:
        if args.list:
            read_registry(ROOT)
            print(json.dumps({name: [{'obligation': x, 'command': command_for(x)} for x in items]
                              for name, items in PROFILES.items()}, indent=2))
            return 0
        return measure(ROOT, args.profile, args.output)
    except (ValueError, OSError, subprocess.CalledProcessError) as error:
        print(f'profiles: {error}', file=sys.stderr)
        return 2


if __name__ == '__main__':
    sys.exit(main())
