#!/usr/bin/env python3
"""Observations of physical execution/receipt failures, not admission; debt T0084."""
import importlib.util
import io
import json
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest import mock

spec = importlib.util.spec_from_file_location('check_run', Path(__file__).with_name('profiles.py'))
runner = importlib.util.module_from_spec(spec)
spec.loader.exec_module(runner)


class PhysicalRunControls(unittest.TestCase):
    def test_absent_literal_is_an_addressed_transport_failure(self):
        row = {'name': 'Example', 'at': {'path': 'Checks/Laws.swift', 'line': 20}, 'axes': {}}
        with self.assertRaisesRegex(ValueError, r'Checks/Laws.swift:20.Name: no unjudged literal'):
            runner.records({'records': [row]})

    def test_unsupported_group_and_ambiguous_name_cannot_disappear(self):
        def packet(group):
            values = dict(Name='one', Description='observed', Command='echo value', Profile='vi', Group=group)
            return {'records': [{'name':'Example', 'at':{'path':'Checks/Laws.swift','line':20},
                'axes':{k:{'literal':{'judged':False,'bytes':runner.base64.b64encode(v.encode()).decode()}} for k,v in values.items()}}]}
        with self.assertRaisesRegex(ValueError, r'Checks/Laws.swift:20.Group: unsupported'):
            runner.records(packet('unread'))
        known = runner.records(packet('serial'))
        with self.assertRaisesRegex(ValueError, r'Checks/Laws.swift:20.Name: ambiguous'):
            runner.selected(known + known)
        self.assertEqual(len(runner.selected(known)),1)

    def test_lock_clean_tree_new_output_and_failed_step_receipts(self):
        with tempfile.TemporaryDirectory(prefix='vi-physical-run-') as tmp:
            root = Path(tmp)/'source'; root.mkdir()
            lock = Path(tmp)/'lock'
            rows = [{'name':'first','profile':'probe'}, {'name':'second','profile':'probe'}]
            def git(_root, *args):
                if args == ('rev-parse','--git-path','vi-profiles.lock'): return str(lock)
                if args == ('rev-parse','HEAD'): return 'a'*40
                return ''
            def run(command, **kwargs):
                kwargs['stdout'].write(b'physical failure\n')
                return subprocess.CompletedProcess(command, 9)
            with mock.patch.object(runner,'git',git), mock.patch.object(runner,'read_registry',return_value=('bound court response',rows)), \
                 mock.patch.object(runner.subprocess,'check_output',return_value='Swift'), mock.patch.object(runner.subprocess,'run',side_effect=run) as physical:
                output = Path(tmp)/'evidence'
                with mock.patch('sys.stdout',io.StringIO()): self.assertEqual(runner.measure(root,'probe',output),9)
                report=json.loads((output/'result.json').read_text())
                self.assertEqual(report['state'],'completed'); self.assertEqual(report['exit_code'],9)
                self.assertEqual(len(report['steps']),1); self.assertEqual(physical.call_count,1)
                self.assertEqual(report['steps'][0]['command'],['bash','check.sh','--only','first'])
                self.assertEqual(len(report['steps'][0]['log_sha256']),64)
                with self.assertRaises(FileExistsError): runner.measure(root,'probe',output)
                with self.assertRaises(ValueError): runner.measure(root,'absent',Path(tmp)/'missing')
                with self.assertRaises(ValueError): runner.measure(root,'probe',root/'inside')
                with lock.open('a') as held:
                    runner.fcntl.flock(held,runner.fcntl.LOCK_EX | runner.fcntl.LOCK_NB)
                    with self.assertRaises(ValueError): runner.measure(root,'probe',Path(tmp)/'concurrent')
            with mock.patch.object(runner,'git',return_value='dirty'):
                with self.assertRaises(ValueError): runner.require_snapshot(root,'a'*40)

    def test_interruption_does_not_become_a_completed_run(self):
        with tempfile.TemporaryDirectory(prefix='vi-physical-run-') as tmp:
            root=Path(tmp)/'source'; root.mkdir()
            def git(_root,*args):
                return str(Path(tmp)/'lock') if '--git-path' in args else ('a'*40 if 'HEAD' in args else '')
            with mock.patch.object(runner,'git',git), \
                 mock.patch.object(runner,'read_registry',return_value=('response',[{'name':'first','profile':'probe'}])), \
                 mock.patch.object(runner.subprocess,'check_output',side_effect=OSError('missing compiler')):
                output=Path(tmp)/'interrupted'
                with self.assertRaises(OSError): runner.measure(root,'probe',output)
                self.assertEqual(json.loads((output/'result.json').read_text())['state'],'interrupted')


if __name__ == '__main__': unittest.main()
