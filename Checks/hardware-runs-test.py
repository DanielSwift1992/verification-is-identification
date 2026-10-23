#!/usr/bin/env python3
"""Offline evidence input controls; no SDK, provider or existing evidence mutation."""
import hashlib
import importlib.util
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest import mock

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('hardware_runs', ROOT/'Checks/hardware_runs.py')
inputs = importlib.util.module_from_spec(spec)
spec.loader.exec_module(inputs)


class EvidenceControls(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix='vi-evidence-controls-')
        self.addCleanup(self.temporary.cleanup)
        self.base = Path(self.temporary.name)
        self.runs = self.base/'runs'; self.runs.mkdir()
        self.manifest = self.base/'MANIFEST.json'
        files = []
        for name, raw in [('campaign/raw-result.json', b'{"fixed": 7}\n'), ('prepared/ready.json', b'{"old": true}\n')]:
            file = self.runs/name; file.parent.mkdir(exist_ok=True); file.write_bytes(raw)
            files.append({'path': 'hardware-runs/'+name, 'sha256': hashlib.sha256(raw).hexdigest(), 'bytes': len(raw)})
        self.manifest.write_text(json.dumps({'files': files}))
        self.store = inputs.Evidence(self.runs, self.manifest)
        patcher = mock.patch.object(inputs, '_STORE', self.store)
        patcher.start(); self.addCleanup(patcher.stop)

    def test_complete_catalogue_and_relative_reference(self):
        self.assertEqual(self.store.verify_all(), 2)
        path = inputs.path('campaign/raw-result.json')
        self.assertEqual(json.loads(path.read_text()), {'fixed': 7})
        self.assertEqual(inputs.address(path, ROOT), 'campaign/raw-result.json')
        self.assertEqual(self.store.reads['campaign/raw-result.json']['sha256'], hashlib.sha256(path.read_bytes()).hexdigest())

    def test_changed_missing_undeclared_and_escaping_inputs_refuse(self):
        for fault in ('changed', 'missing', 'undeclared', 'escape'):
            with self.subTest(fault=fault):
                file = self.runs/'campaign/raw-result.json'; original = file.read_bytes()
                try:
                    if fault=='changed':file.write_bytes(b'changed')
                    if fault=='missing':file.unlink()
                    if fault=='undeclared':(self.runs/'extra.json').write_bytes(b'extra')
                    if fault=='escape':(self.runs/'link').symlink_to(self.base.parent)
                    name = 'extra.json' if fault=='undeclared' else 'link/outside' if fault=='escape' else 'campaign/raw-result.json'
                    with self.assertRaises(inputs.EvidenceError):inputs.path(name)
                finally:file.write_bytes(original)
        with self.assertRaises(inputs.EvidenceError):inputs.path('../outside')

    def test_evidence_paths_refuse_writes_and_removal(self):
        path = inputs.path('campaign/raw-result.json'); original = path.read_bytes()
        for action in (lambda:path.write_bytes(b'changed'), lambda:path.write_text('changed'),
                       lambda:path.unlink(), lambda:path.rename(self.base/'moved'),
                       lambda:inputs.root().joinpath('new-directory').mkdir()):
            with self.assertRaises(inputs.EvidenceError):action()
        self.assertEqual(path.read_bytes(), original)

    def test_saved_machine_keys_resolve_by_hash_without_opening_the_old_path(self):
        row = self.store.files['campaign/raw-result.json']
        path = inputs.resolve_recorded('/'+'retired/machine/data.json', row['sha256'], ROOT)
        self.assertEqual(inputs.address(path, ROOT), 'campaign/raw-result.json')
        with self.assertRaises(inputs.EvidenceError):inputs.resolve_recorded('missing', '0'*64, ROOT)

    def test_equal_hash_files_follow_catalogue_origin_and_ambiguity_refuses(self):
        first = 'campaign/raw-result.json'
        second = 'other-run/same.json'
        raw = (self.runs/first).read_bytes()
        duplicate = self.runs/second
        duplicate.parent.mkdir(); duplicate.write_bytes(raw)
        data = json.loads(self.manifest.read_text())
        data['files'][0]['origin'] = 'retired/'+first
        data['files'].append({'path': 'hardware-runs/'+second, 'origin': 'retired/'+second,
                              'sha256': hashlib.sha256(raw).hexdigest(), 'bytes': len(raw)})
        self.manifest.write_text(json.dumps(data))
        store = inputs.Evidence(self.runs, self.manifest)
        digest = hashlib.sha256(raw).hexdigest()
        with mock.patch.object(inputs, '_STORE', store):
            entries = {'retired/'+first: digest, '/old/machine/retired/'+second: digest}
            self.assertEqual(inputs.rebind_map(entries, ROOT), {first: digest, second: digest})
            self.assertEqual(inputs.address(inputs.resolve_recorded(second, digest, ROOT), ROOT), second)
            with self.assertRaisesRegex(inputs.EvidenceError, 'ambiguous'):
                inputs.resolve_recorded('unknown-name', digest, ROOT)
            store.files[second]['origin'] = store.files[first]['origin']
            with self.assertRaisesRegex(inputs.EvidenceError, 'ambiguous'):
                inputs.resolve_recorded('retired/'+first, digest, ROOT)
            store.files[second]['origin'] = 'retired/'+second
            with self.assertRaisesRegex(inputs.EvidenceError, 'collapse'):
                inputs.rebind_map({'retired/'+first: digest, first: digest}, ROOT)

    def test_retired_machine_path_is_not_resolved_or_opened(self):
        retired = Path('/retired/machine/data.json')
        original_resolve = Path.resolve
        def guarded_resolve(path, *args, **kwargs):
            self.assertNotEqual(path, retired, 'an opaque retired path must never be followed')
            return original_resolve(path, *args, **kwargs)
        digest = self.store.files['campaign/raw-result.json']['sha256']
        with mock.patch.object(Path, 'resolve', guarded_resolve):
            path = inputs.resolve_recorded(str(retired), digest, ROOT)
        self.assertEqual(inputs.address(path, ROOT), 'campaign/raw-result.json')

    def test_new_work_outside_the_corpus_has_a_relative_receipt_address(self):
        work = (self.base/'explicit-work').resolve()
        with mock.patch.object(inputs, '_WORK', work):
            file = inputs.work('new-run')/'plan.json'
            file.parent.mkdir(parents=True); file.write_text('{}')
            self.assertEqual(inputs.address(file, ROOT), 'new-run/plan.json')
        self.assertFalse((self.runs/'new-run').exists())

    def test_local_research_artifacts_keep_their_explicit_base_and_checksum(self):
        base = self.base/'Research/report'; base.mkdir(parents=True)
        file = base/'checks.json'; file.write_bytes(b'local corpus artifact')
        digest = hashlib.sha256(file.read_bytes()).hexdigest()
        self.assertEqual(inputs.resolve_recorded('checks.json', digest, base, corpus_root=self.base), file.resolve())
        self.assertEqual(inputs.resolve_recorded(str(file), digest, self.base), file.resolve())
        with self.assertRaises(inputs.EvidenceError):
            inputs.resolve_recorded('checks.json', '0'*64, base, corpus_root=self.base)

    def test_unsubmitted_output_slot_is_not_invented_evidence(self):
        with self.assertRaisesRegex(inputs.EvidenceError, '--work'):
            inputs.work('unsubmitted-run')
        self.assertFalse((self.runs/'unsubmitted-run').exists())
        with mock.patch.object(inputs, '_WORK', self.base/'explicit-work'):
            fresh = inputs.work('unsubmitted-run')
            self.assertEqual(fresh, self.base/'explicit-work/unsubmitted-run')
            self.assertNotIsInstance(fresh, inputs.EvidencePath)

    def test_existing_hash_changes_only_the_path_and_missing_hash_is_bound(self):
        path = inputs.path('campaign/raw-result.json'); digest = self.store.reads['campaign/raw-result.json']['sha256']
        prior = {'input': str(path), 'sha256': digest}
        receipt = inputs.bind_receipt(prior)
        self.assertEqual(receipt, {'input': 'campaign/raw-result.json', 'sha256': digest})
        self.assertEqual(prior['input'], str(path))
        fresh = inputs.bind_receipt({'result': 'checked'})
        self.assertEqual(fresh['evidence_inputs'], [{'path': 'campaign/raw-result.json', 'sha256': digest}])
        self.assertEqual(fresh['evidence_manifest_sha256'], self.store.manifest_sha256)
        raw = {'provider': 'unchanged'}
        self.assertIs(inputs.bind_receipt(raw, destination='raw-result.json'), raw)
        wire = {'schema': 'vi.braket.jobs.v1', 'jobs': []}
        self.assertIs(inputs.bind_receipt(wire, destination='jobs.json'), wire)

    def test_cli_check_mode_is_offline_and_missing_arguments_are_addressed(self):
        command = [sys.executable, str(ROOT/'Checks/hardware_runs.py')]
        missing = subprocess.run(command, capture_output=True, text=True)
        self.assertEqual(missing.returncode, 2)
        self.assertIn('hardware-runs folder', missing.stderr)
        good = subprocess.run(command+['--runs',str(self.runs),'--manifest',str(self.manifest),'--check-evidence'],capture_output=True,text=True)
        self.assertEqual(good.returncode, 0, good.stderr)
        self.assertEqual(json.loads(good.stdout)['evidence_files_verified'], 2)
        (self.runs/'campaign/raw-result.json').write_bytes(b'changed')
        bad = subprocess.run(command+['--runs',str(self.runs),'--manifest',str(self.manifest),'--check-evidence'],capture_output=True,text=True)
        self.assertEqual(bad.returncode, 2)
        self.assertIn('SHA-256', bad.stderr)

    def test_implicit_run_readers_refuse_before_optional_sdk_imports(self):
        marker = b'_runs.' + b'configure(required='
        scripts = [p for p in (ROOT/'Checks').rglob('*.py') if marker in p.read_bytes()]
        self.assertEqual(len(scripts), 41)
        optional = {'Checks/BraketBridge/build.py', 'Checks/BraketBridge/prepare.py',
                    'Checks/BraketBridge/execute.py', 'Checks/IBMBridge/joint_memory.py'}
        for path in scripts:
            if path.relative_to(ROOT).as_posix() in optional:
                continue
            with self.subTest(path=path.relative_to(ROOT)):
                result = subprocess.run([sys.executable, str(path)], capture_output=True, text=True, timeout=10)
                self.assertEqual(result.returncode, 2, result.stderr)
                self.assertIn('hardware-runs folder', result.stderr)
                self.assertNotIn('ModuleNotFoundError', result.stderr)
        print(f'evidence readers: {len(scripts)-len(optional)} refuse before SDK imports without explicit inputs; {len(optional)} allow explicit fresh outputs/cache')


    def test_fresh_writers_need_output_and_help_needs_no_evidence_or_sdk(self):
        for name, extra in [('BraketBridge/build.py', []), ('IBMBridge/joint_memory.py', ['prepare'])]:
            command = [sys.executable, str(ROOT/'Checks'/name)]
            refused = subprocess.run(command+extra, capture_output=True, text=True, timeout=10)
            self.assertEqual(refused.returncode, 2, refused.stderr)
            self.assertIn('--output', refused.stderr)
            self.assertNotIn('hardware-runs folder', refused.stderr)
            self.assertNotIn('ModuleNotFoundError', refused.stderr)
            help_result = subprocess.run(command+['--help'], capture_output=True, text=True, timeout=10)
            self.assertEqual(help_result.returncode, 0, help_result.stderr)
            self.assertIn('--output', help_result.stdout)
        for name in ('BraketBridge/prepare.py', 'BraketBridge/execute.py'):
            result = subprocess.run([sys.executable, str(ROOT/'Checks'/name), '--help'],
                                    capture_output=True, text=True, timeout=10)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertIn('--cache', result.stdout)
        with mock.patch.object(inputs, '_STORE', None), mock.patch.object(sys, 'argv', ['writer']):
            self.assertEqual(inputs.arguments(), [])
            self.assertEqual(inputs.bind_receipt({'new': True}), {'new': True})


if __name__ == '__main__':
    unittest.main()
