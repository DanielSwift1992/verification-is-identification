#!/usr/bin/env python3
"""Physical profile execution and timing; debt T0084. Selection is a Court projection."""
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
import base64


def roster(root=ROOT):
    build = subprocess.run(['swift', 'build', '--product', 'Tools'], cwd=root, stdout=sys.stderr)
    if build.returncode:
        raise ValueError('check registry: Tools build failed')
    binary = Path(subprocess.check_output(['swift', 'build', '--show-bin-path'], cwd=root, text=True).strip()) / 'Tools'
    command = [str(binary), 'judge', 'roster', 'Checks/Laws.swift', '--protocol', 'LawRecord']
    result = subprocess.run(command, cwd=root, capture_output=True, text=True)
    answer = json.loads(result.stdout)
    if result.returncode or answer['outcome'] != 'holds':
        raise ValueError('Checks/Laws.swift: roster did not hold: ' + '; '.join(answer['diagnostics']))
    return answer


def carried(literal, at):
    if literal is None or literal['judged'] is not False:
        raise ValueError(at + ': no unjudged literal byte carrier')
    # This is the byte transport declared by the owner, not Swift evaluation.
    return base64.b64decode(literal['bytes'], validate=True).decode('utf-8')


def records(answer):
    result = []
    for row in answer['records']:
        at = row['at']['path'] + ':' + str(row['at']['line'])
        fields = row['axes']
        item = {'record': row['name'], 'at': at}
        for name in ('Name', 'Description', 'Command', 'Profile', 'Group'):
            item[name.lower()] = carried(fields.get(name, {}).get('literal'), at + '.' + name)
        # Delimiter/transport failures do not pretend to be profile proofs.
        if any(not item[key] for key in ('name', 'description', 'command', 'profile', 'group')):
            raise ValueError(at + ': empty literal cannot be executed by the shell-line transport')
        if any('\n' in item[key] or '\r' in item[key] or '\0' in item[key]
               for key in ('name', 'description', 'command', 'profile', 'group')):
            raise ValueError(at + ': the shell-line transport cannot carry LF/CR/NUL')
        if any('|' in item[key] for key in ('name', 'description', 'profile', 'group')):
            raise ValueError(at + ': the shell-line transport cannot carry a separator in metadata')
        if item['group'] not in ('serial', 'parallel', 'research', 'optional'):
            raise ValueError(at + '.Group: unsupported physical execution group ' + item['group'])
        result.append(item)
    return result


def selected(items, research=False, only='', profile=None):
    result = [r for r in items if
            (r['group'] == 'research' if research else
             r['group'] in ('serial', 'parallel') or (r['group'] == 'optional' and r['name'] == only))
            and (profile is None or r['profile'] == profile)]
    names = set()
    for row in result:
        if row['name'] in names:
            raise ValueError(row['at'] + '.Name: ambiguous shell selection name ' + row['name'])
        names.add(row['name'])
    return result


def read_registry(root):
    answer = roster(root)
    return json.dumps(answer, sort_keys=True), selected(records(answer))


def command_for(item):
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
        selected = [row['name'] for row in registry if row['profile'] == profile]
        if not selected:
            raise ValueError('Checks/Laws.swift:1: no profile ' + profile)
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
            for number, item in enumerate(selected, 1):
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
    parser.add_argument('--list', action='store_true', help='list Court-projected profile commands')
    parser.add_argument('--project', action='store_true', help='carry the Court roster to check.sh')
    parser.add_argument('--select-profile')
    parser.add_argument('--research-only', action='store_true')
    parser.add_argument('--only', default='')
    parser.add_argument('--profile')
    parser.add_argument('--output', type=Path, help='new physical-run evidence directory')
    args = parser.parse_args()
    try:
        if args.project:
            if args.profile or args.output or args.list:
                parser.error('--project cannot measure a profile')
            items = selected(records(roster()), args.research_only, args.only, args.select_profile)
            if not items:
                raise ValueError('Checks/Laws.swift:1: no records for the requested selection')
            for r in items:
                print('|'.join(r[k] for k in ('name', 'group', 'description', 'command')))
            return 0
        if args.list:
            if args.profile or args.output:
                parser.error('--list cannot measure a profile')
            _, rows = read_registry(ROOT)
            print(json.dumps({name: [{'obligation': x['name'], 'command': command_for(x['name'])}
                                    for x in rows if x['profile'] == name]
                              for name in sorted({x['profile'] for x in rows})}, indent=2))
            return 0
        if not args.profile or not args.output:
            parser.error('choose --list, --project, or --profile NAME --output NEW_DIRECTORY')
        return measure(ROOT, args.profile, args.output)
    except (ValueError, KeyError, OSError, subprocess.CalledProcessError) as error:
        print(f'profiles host: {error}', file=sys.stderr)
        return 2


if __name__ == '__main__':
    sys.exit(main())
