#!/usr/bin/env python3
"""Negative controls for the Press conformance driver, not a second Press."""
import importlib.util
import json
from pathlib import Path
import shutil
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('press_contract', ROOT / 'Checks/press-contract.py')
c = importlib.util.module_from_spec(spec)
spec.loader.exec_module(c)


class Controls(unittest.TestCase):
    def test_complete_registered_case_set(self):
        manifest, cases = c.load_contract(ROOT / 'Contracts/Press/v0.1/contract.json')
        self.assertEqual(len(cases), 33)
        self.assertEqual(len(manifest['native_controls']), 27)

    def test_manifest_cannot_drop_a_case(self):
        with tempfile.TemporaryDirectory() as tmp:
            target = Path(tmp) / 'suite'
            shutil.copytree(ROOT / 'Contracts/Press/v0.1', target)
            path = target / 'contract.json'
            data = json.loads(path.read_text())
            data['cases'].pop()
            path.write_text(json.dumps(data))
            with self.assertRaisesRegex(ValueError, 'changed manifest'):
                c.load_contract(path)

    def test_fixture_hash_is_checked(self):
        with tempfile.TemporaryDirectory() as tmp:
            target = Path(tmp) / 'suite'
            shutil.copytree(ROOT / 'Contracts/Press/v0.1', target)
            with (target / 'fixtures/cases.json').open('a') as stream:
                stream.write(' ')
            with self.assertRaisesRegex(ValueError, 'hash mismatch'):
                c.load_contract(target / 'contract.json')

    def test_refusal_needs_reason_address_and_unchanged_bytes(self):
        _, cases = c.load_contract(ROOT / 'Contracts/Press/v0.1/contract.json')
        expected = next(row['expected'] for row in cases if row['id'] == 'unknown-rule')
        actual = {'state': expected['state'], 'changed': False, 'refusal': {'address': 'rules.swift#Absent', 'reason': 'no rule named Absent'}}
        self.assertEqual(c.mismatches(actual, expected), [])
        for key, value in [('state', 'altered'), ('changed', True), ('refusal', None)]:
            self.assertTrue(c.mismatches({**actual, key: value}, expected))
        for refusal in [{'address': 'elsewhere', 'reason': 'no rule named Absent'}, {'address': 'rules.swift#Absent', 'reason': 'failed'}]:
            self.assertTrue(c.mismatches({**actual, 'refusal': refusal}, expected))

    def test_utf16_half_or_normalization_is_not_the_state(self):
        self.assertTrue(c.mismatches({'state': '\ud801', 'changed': True}, {'state': '', 'changed': True, 'refusal': None}))
        self.assertTrue(c.mismatches({'state': 'é', 'changed': True}, {'state': 'e\u0301', 'changed': True, 'refusal': None}))


if __name__ == '__main__':
    unittest.main()
