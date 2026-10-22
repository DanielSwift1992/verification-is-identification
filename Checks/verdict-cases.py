#!/usr/bin/env python3
"""Check each fixture once, then each mutation in a separate compiler process."""
from concurrent.futures import ThreadPoolExecutor, wait, FIRST_COMPLETED
from collections import OrderedDict, defaultdict
from pathlib import Path
import argparse
import os
import re
import signal
import subprocess
import sys
from threading import Event, Lock

CRASH = re.compile(r'Stack dump:|[Pp][Ll][Ee][Aa][Ss][Ee] submit a bug report|Assertion failed|cannot build rewrite system|rule (length|count) limit exceeded|reasonable time')
MISSING = re.compile(r'error: (cannot find .* in scope|no such module )')


def fixtures(root, cases):
    index = defaultdict(set)
    for path in sorted((root / 'Checks').rglob('*.swift')):
        for flag in re.findall(rb'^#if ([A-Z][A-Z0-9_]*)$', path.read_bytes(), re.M):
            index[flag.decode()].add(str(path.relative_to(root)))
    grouped = OrderedDict()
    seen = set()
    for flag, name in cases:
        if flag in seen:
            raise ValueError(f'duplicate mutation {flag}')
        seen.add(flag)
        if len(index[flag]) != 1:
            raise ValueError(f'expected one fixture for {flag}')
        path = next(iter(index[flag]))
        grouped.setdefault(path, []).append((flag, name))
    return grouped


def sources(path):
    if path in ('Checks/Coverage.swift', 'Checks/Saturation.swift',
                'Checks/Transition.swift', 'Checks/Transport.swift'):
        return [path, 'Checks/Verdict.swift']
    if path in ('Checks/IceIncidence.swift', 'Checks/IceCoverage.swift'):
        return ['Checks/IceIncidence.swift', 'Checks/IceCoverage.swift']
    return [path]


def refusal_error(status, output, flag, name):
    if status == 0:
        return f'verdict: ERROR — {flag} was accepted\n'
    if status != 1 or CRASH.search(output):
        return output + f'verdict: ERROR — compiler could not check {flag} (exit {status})\n'
    if MISSING.search(output):
        return output + f'verdict: ERROR — missing dependency while checking {flag}\n'
    if 'error:' not in output or name not in output:
        return output + f'verdict: ERROR — failure did not name {name}\n'
    return None


def run(root, cases, modules, cache, jobs, output):
    if not cases:
        raise ValueError('no registered mutations selected')
    groups = fixtures(root, cases)
    commands = {path: ['swiftc', '-typecheck',
                       '-I', str(modules), '-module-cache-path', str(cache), *sources(path)]
                for path in groups}
    stop = Event()
    running = set()
    process_lock = Lock()
    def compile(path, extra):
        with process_lock:
            if stop.is_set():
                return None, ''
            process = subprocess.Popen([*commands[path], *extra], cwd=root,
                                       stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                                       start_new_session=True)
            running.add(process)
        try:
            diagnostic, _ = process.communicate()
            return process.returncode, diagnostic.decode('utf-8', errors='replace')
        finally:
            with process_lock:
                running.remove(process)
    pending = {}
    results = {}
    next_case = 0
    with ThreadPoolExecutor(max_workers=jobs) as pool:
        try:
            # Each fixture's positive precedes its own mutations. Ready
            # mutations can use spare workers while another positive runs.
            for path in groups:
                pending[pool.submit(compile, path, [])] = ('positive', path, None, None)
            while pending:
                done, _ = wait(pending, return_when=FIRST_COMPLETED)
                for future in done:
                    kind, path, flag, name = pending.pop(future)
                    status, diagnostic = future.result()
                    if kind == 'positive':
                        if status != 0:
                            first_flag = groups[path][0][0]
                            results[first_flag] = (True, diagnostic + f'verdict: ERROR — standalone positive failed for {path}\n')
                        else:
                            for flag, name in groups[path]:
                                task = pool.submit(compile, path, ['-D' + flag])
                                pending[task] = ('mutation', path, flag, name)
                    else:
                        error = refusal_error(status, diagnostic, flag, name)
                        results[flag] = (bool(error), error or f'verdict: refused {flag}\n')
                # Publish complete responses in registry order, preserving
                # the failing refusal's original place in the CI stream.
                while next_case < len(cases) and cases[next_case][0] in results:
                    failed, message = results.pop(cases[next_case][0])
                    output.write(message); output.flush()
                    if failed:
                        return 1
                    next_case += 1
            if next_case != len(cases):
                raise ValueError('some mutations have no compiler result')
        finally:
            # Drain active compiler calls before Bash removes their scratch.
            # Queued mutations stop with a failed or interrupted run.
            with process_lock:
                stop.set()
                for process in running:
                    if process.returncode is not None:
                        continue
                    try:
                        os.killpg(process.pid, signal.SIGTERM)
                    except ProcessLookupError:
                        pass
            for future in pending: future.cancel()

    return 0


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--modules', type=Path, required=True)
    parser.add_argument('--cache', type=Path, required=True)
    parser.add_argument('--jobs', type=int, default=3)
    args = parser.parse_args()
    if not 1 <= args.jobs <= 64:
        parser.error('--jobs must be between 1 and 64')
    try:
        cases = []
        for line in sys.stdin:
            match = re.fullmatch(r'([A-Z][A-Z0-9_]*):([A-Za-z][A-Za-z0-9_]*)\n', line)
            if match is None:
                raise ValueError('invalid mutation record')
            cases.append(match.groups())
        return run(Path(__file__).resolve().parent.parent, cases, args.modules, args.cache, args.jobs, sys.stdout)
    except (OSError, ValueError) as error:
        print(f'verdict: ERROR — {error}', file=sys.stderr)
        return 1


if __name__ == '__main__':
    sys.exit(main())
