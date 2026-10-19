#!/usr/bin/env python3
"""Coverage and refusal controls for pre-extraction check profiles."""
import collections
import importlib.util
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import tempfile
import unittest
from unittest import mock

ROOT = Path(__file__).resolve().parent.parent
spec = importlib.util.spec_from_file_location('profiles', ROOT / 'Checks/profiles.py')
profiles = importlib.util.module_from_spec(spec)
spec.loader.exec_module(profiles)


class ProfileControls(unittest.TestCase):
    def test_registry_and_commands(self):
        raw, registry = profiles.read_registry(ROOT)
        self.assertIn('response', registry)
        self.assertEqual(profiles.command_for('verdict'), ['bash', 'check.sh', '--only', 'verdict'])
        self.assertEqual(profiles.command_for('verdict:core'), ['bash', 'Checks/verdict.sh', 'core'])
        self.assertEqual(profiles.command_for('court'), ['bash', 'check.sh', '--only', 'court'])
        with self.assertRaises(ValueError):
            profiles.validate_coverage({**registry, 'verdict': {'command': 'bash Checks/replacement-verdict.sh'}})
        with self.assertRaises(ValueError):
            profiles.validate_coverage({**registry, 'unassigned-new-law': {}})
        missing = dict(registry)
        del missing['response']
        with self.assertRaises(ValueError):
            profiles.validate_coverage(missing)
        with mock.patch.dict(profiles.PROFILES, {'extra': ['response']}):
            with self.assertRaises(ValueError):
                profiles.validate_coverage(registry)
        # The company's laws moved to the showcase package; naming one here is not coverage.
        with mock.patch.dict(profiles.PROFILES, {'showcase': ['rules', 'artifacts', 'judge']}):
            with self.assertRaises(ValueError):
                profiles.validate_coverage(registry)

    def test_list_does_not_execute(self):
        result = subprocess.run(['bash', 'check.sh', '--list'], cwd=ROOT, capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertTrue(all(len(line.split('|', 2)) == 3 for line in result.stdout.splitlines()))
        bad = subprocess.run(['bash', 'check.sh', '--list', '--only', 'court'], cwd=ROOT, capture_output=True)
        self.assertEqual(bad.returncode, 2)
        listing = subprocess.run([sys.executable, 'Checks/profiles.py', '--list'], cwd=ROOT, capture_output=True)
        self.assertEqual(listing.returncode, 0, listing.stderr)
        self.assertEqual(set(json.loads(listing.stdout)), set(profiles.PROFILES))

    def test_measurement_failure_and_source_changes(self):
        for child_exit, dirty_after, changed_commit, expected in [(0, '', False, 0), (7, '', False, 7),
                                                                 (3, '', False, 3), (0, ' M x', False, 3),
                                                                 (0, '', True, 3)]:
            with self.subTest(child_exit=child_exit, dirty_after=dirty_after, changed_commit=changed_commit):
                with tempfile.TemporaryDirectory() as tmp:
                    root = Path(tmp) / 'source'; root.mkdir()
                    output = Path(tmp) / 'evidence'
                    calls = collections.Counter()
                    completed = []
                    def fake_run(command, **kwargs):
                        completed.append(command)
                        return subprocess.CompletedProcess(command, child_exit)
                    def fake_git(root, *args):
                        calls[args] += 1
                        if args == ('status', '--porcelain'):
                            return dirty_after if len(completed) == 2 else ''
                        if args == ('rev-parse', 'HEAD'):
                            return 'b' * 40 if changed_commit and len(completed) == 2 else 'a' * 40
                        if args == ('rev-parse', '--git-path', 'vi-profiles.lock'):
                            return str(Path(tmp) / 'lock')
                        raise AssertionError(args)
                    with mock.patch.object(profiles, 'git', fake_git), \
                         mock.patch.object(profiles.platform, 'platform', return_value='test host'), \
                         mock.patch.dict(profiles.PROFILES, {'probe': ['first', 'second']}), \
                         mock.patch.object(profiles.subprocess, 'check_output', return_value='Swift test'), \
                         mock.patch.object(profiles, 'read_registry', return_value=('test registry', {})), \
                         mock.patch.object(profiles.subprocess, 'run', side_effect=fake_run) as run:
                        code = profiles.measure(root, 'probe', output)
                    self.assertEqual(code, expected)
                    report = json.loads((output / 'result.json').read_text())
                    self.assertEqual(report['exit_code'], expected)
                    self.assertEqual(report['state'], 'completed')
                    self.assertEqual(run.call_count, 1 if child_exit else 2)
                    self.assertEqual(report['steps'][0]['exit_code'], child_exit)
                    self.assertIn('elapsed_seconds', report['steps'][0])
                    self.assertIn('log_sha256', report['steps'][0])

    def test_measurement_preconditions_and_interruption(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp) / 'source'; root.mkdir()
            with self.assertRaises(ValueError):
                profiles.measure(root, 'court', root / 'output')
            with mock.patch.object(profiles, 'git', return_value=' M dirty'):
                with self.assertRaises(ValueError):
                    profiles.measure(root, 'court', Path(tmp) / 'outside')
            def fake_git(root, *args):
                return str(Path(tmp) / 'lock') if args[-1] == 'vi-profiles.lock' else ''
            with mock.patch.object(profiles, 'git', fake_git), \
                         mock.patch.object(profiles.platform, 'platform', return_value='test host'), \
                 mock.patch.object(profiles, 'read_registry', return_value=('test registry', {})), \
                 mock.patch.object(profiles.subprocess, 'check_output', side_effect=OSError('missing swift')):
                with self.assertRaises(OSError):
                    profiles.measure(root, 'court', Path(tmp) / 'interrupted')
                with self.assertRaises(FileExistsError):
                    profiles.measure(root, 'court', Path(tmp) / 'interrupted')
            report = json.loads((Path(tmp) / 'interrupted/result.json').read_text())
            self.assertEqual(report['state'], 'interrupted')
            self.assertNotIn('exit_code', report)


    def test_registry_is_captured_under_lock_and_bound_to_commit(self):
        _, registry_a = profiles.read_registry(ROOT)
        for change in ['new-law-before-lock', 'commit-during-registry', 'dirty-during-registry',
                       'commit-before-first-command']:
            with self.subTest(change=change), tempfile.TemporaryDirectory() as tmp:
                root = Path(tmp) / 'source'; root.mkdir()
                lock_path = Path(tmp) / 'lock'
                state = {'commit': 'a' * 40, 'dirty': ''}
                registry_b = {**registry_a, 'unassigned-new-law': {}}
                if change == 'new-law-before-lock':
                    state['commit'] = 'b' * 40
                def fake_git(root, *args):
                    if args == ('rev-parse', '--git-path', 'vi-profiles.lock'): return str(lock_path)
                    if args == ('rev-parse', 'HEAD'): return state['commit']
                    if args == ('status', '--porcelain'): return state['dirty']
                    raise AssertionError(args)
                def read_now(root):
                    # Opening another descriptor proves the run already owns the lock.
                    with lock_path.open('a') as other:
                        with self.assertRaises(BlockingIOError):
                            profiles.fcntl.flock(other, profiles.fcntl.LOCK_EX | profiles.fcntl.LOCK_NB)
                    if change == 'new-law-before-lock':
                        profiles.validate_coverage(registry_b)
                    if change == 'commit-during-registry': state['commit'] = 'b' * 40
                    if change == 'dirty-during-registry': state['dirty'] = ' M check.sh'
                    return 'registry A', registry_a
                def version(*args, **kwargs):
                    if change == 'commit-before-first-command': state['commit'] = 'b' * 40
                    return 'Swift test'
                with mock.patch.object(profiles, 'git', fake_git), \
                     mock.patch.object(profiles, 'read_registry', side_effect=read_now), \
                     mock.patch.object(profiles.platform, 'platform', return_value='test host'), \
                     mock.patch.object(profiles.subprocess, 'check_output', side_effect=version), \
                     mock.patch.object(profiles.subprocess, 'run') as run:
                    with self.assertRaises(ValueError):
                        profiles.measure(root, 'court', Path(tmp) / 'evidence')
                run.assert_not_called()
                receipt = Path(tmp) / 'evidence/result.json'
                if receipt.exists():
                    self.assertEqual(json.loads(receipt.read_text())['state'], 'interrupted')

    def test_profile_lock_rejects_a_second_measurement(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp) / 'source'; root.mkdir()
            lock_path = Path(tmp) / 'lock'
            with lock_path.open('a') as held:
                profiles.fcntl.flock(held, profiles.fcntl.LOCK_EX)
                with mock.patch.object(profiles, 'git', return_value=str(lock_path)), \
                     mock.patch.object(profiles, 'read_registry') as read:
                    with self.assertRaisesRegex(ValueError, 'already running'):
                        profiles.measure(root, 'court', Path(tmp) / 'evidence')
                read.assert_not_called()


class VerdictPartitionControls(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.temp = tempfile.TemporaryDirectory(prefix='vi-profile-controls-')
        cls.scratch = Path(cls.temp.name)
        cls.tools = cls.scratch / 'bin'; cls.tools.mkdir()
        script = (ROOT / 'Checks/verdict.sh').read_text()
        cls.pairs = re.findall(r'^    ([A-Z][A-Z0-9_]*):([A-Za-z][A-Za-z0-9_]*)[ \\]*$', script, re.M)
        cls.flags = dict(cls.pairs)
        cases = '\n'.join(f'{flag}) echo "error: {name}" >&2; exit 1 ;;' for flag, name in cls.pairs)
        compiler = '''#!/usr/bin/env bash
printf 'swiftc' >> "$VI_TRACE"
printf '\\t%s' "$@" >> "$VI_TRACE"
printf '\\n' >> "$VI_TRACE"
for arg in "$@"; do
    case "$arg" in -D*) flag="${arg#-D}" ;;
    esac
done
if [ -z "${flag:-}" ]; then
    [ "${VI_FAULT:-}" = positive ] && { echo 'error: positive failed' >&2; exit 1; }
    exit 0
fi
case "${VI_FAULT:-}" in
    crash) echo 'Stack dump: compiler failed' >&2; exit 70 ;;
    missing) echo 'error: no such module Missing' >&2; echo "error: $VI_FIRST_NAME" >&2; exit 1 ;;
    unrelated) echo 'error: UnrelatedFailure' >&2; exit 1 ;;
    accepts) exit 0 ;;
esac
case "$flag" in
''' + cases + '\n*) echo "unexpected flag $flag" >&2; exit 79 ;;\nesac\n'
        (cls.tools / 'swiftc').write_text(compiler)
        (cls.tools / 'swift').write_text('''#!/usr/bin/env bash
printf 'swift' >> "$VI_TRACE"
printf '\\t%s' "$@" >> "$VI_TRACE"
printf '\\n' >> "$VI_TRACE"
[ "${VI_FAULT:-}" = build ] && exit 23
[ "${2:-}" = --show-bin-path ] && echo "$VI_FAKE_BIN"
exit 0
''')
        for tool in cls.tools.iterdir(): tool.chmod(0o755)

    @classmethod
    def tearDownClass(cls):
        cls.temp.cleanup()

    def run_scope(self, scope, fault=''):
        trace = self.scratch / f'{scope}-{fault}.trace'
        trace.write_text('')
        env = {**os.environ, 'PATH': str(self.tools) + os.pathsep + os.environ['PATH'],
               'VI_TRACE': str(trace), 'VI_FAKE_BIN': str(self.scratch), 'VI_FAULT': fault,
               'VI_FIRST_NAME': self.pairs[0][1]}
        result = subprocess.run(['bash', 'Checks/verdict.sh', scope], cwd=ROOT, env=env, capture_output=True, text=True)
        return result, [line.split('\t') for line in trace.read_text().splitlines()]

    def test_core_equals_all_after_the_publication_moved(self):
        observations = {}
        for scope in ['all', 'core']:
            result, calls = self.run_scope(scope)
            self.assertEqual(result.returncode, 0, result.stdout[-1000:] + result.stderr)
            positives = [call for call in calls if call[0] == 'swiftc' and not any(x.startswith('-D') for x in call)]
            flags = [x[2:] for call in calls for x in call if x.startswith('-D')]
            self.assertEqual(len(flags), len(set(flags)))
            observations[scope] = (positives, set(flags), calls)
        all_positive, all_flags, all_calls = observations['all']
        core_positive, core_flags, core_calls = observations['core']
        self.assertEqual(all_flags, set(self.flags))
        self.assertEqual(core_flags, all_flags)
        self.assertFalse(any(flag.startswith('PUBLICATION_') for flag in all_flags))
        sources = lambda call: {arg for arg in call if arg.endswith('.swift')}
        self.assertEqual(sources(all_positive[0]), sources(core_positive[0]))
        self.assertFalse(any('DocumentKitDemo' in arg or 'Publication.swift' in arg
                             for call in all_calls + core_calls for arg in call))
        for calls in (all_calls, core_calls):
            self.assertIn(['swift', 'build', '--target', 'GrammarLexicon'], calls)
            self.assertIn(['swift', 'build', '--target', 'Examples'], calls)
        rejected = subprocess.run(['bash', 'Checks/verdict.sh', 'publication'], cwd=ROOT, capture_output=True, text=True)
        self.assertEqual(rejected.returncode, 2)
        print(f'coverage: {len(all_flags)} refusals, core and all identical', flush=True)

    def test_wrong_failures_cannot_pass(self):
        for fault in ['build', 'positive', 'crash', 'missing', 'unrelated', 'accepts']:
            with self.subTest(fault=fault):
                result, calls = self.run_scope('all', fault)
                self.assertNotEqual(result.returncode, 0)
                self.assertNotIn(f'verdict: refused {self.pairs[0][0]}', result.stdout)


if __name__ == '__main__':
    unittest.main()
