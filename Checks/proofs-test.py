#!/usr/bin/env python3
"""Negative physical controls of the Lean gate, not proofs of its driver."""
from pathlib import Path
import importlib.util
import io
import os
import tempfile
import unittest

spec = importlib.util.spec_from_file_location('proofs', Path(__file__).with_name('proofs.py'))
proofs = importlib.util.module_from_spec(spec)
spec.loader.exec_module(proofs)


class ProofLawControls(unittest.TestCase):
    def test_actual_lean_sorry_custom_axiom_and_legal_neighbor(self):
        # A fresh, tiny project exercises real transitive #print axioms output.
        # No accepted mathematical module or its cache is edited by the probe.
        with tempfile.TemporaryDirectory(prefix='vi-proofs-controls-') as directory:
            root = Path(directory)
            (root / 'lean-toolchain').write_bytes((proofs.PROJECT / 'lean-toolchain').read_bytes())
            (root / 'lakefile.toml').write_text(
                'name = "proof_controls"\ndefaultTargets = ["Probe"]\n'
                '[[lean_lib]]\nname = "Probe"\n')
            (root / 'Probe.lean').write_text(
                'theorem legal : True := True.intro\n'
                'theorem unfinished : False := by sorry\n'
                'axiom invented : False\n'
                'theorem custom : False := invented\n')
            for name, axiom in [('unfinished', 'sorryAx'), ('custom', 'invented'), ('legal', None)]:
                with self.subTest(name=name):
                    (root / 'Axioms.lean').write_text(f'import Probe\n#print axioms {name}\n')
                    output = io.StringIO()
                    status = proofs.run(root, output=output)
                    response = output.getvalue()
                    self.assertEqual(status, 1 if axiom else 0, response)
                    if axiom:
                        self.assertIn(f'Axioms.lean:2: claim {name}: forbidden axioms: {axiom}', response)
                        print(response[response.index('proofs: REFUSED:'):].strip())
                    else:
                        self.assertIn('1/1 declared claims', response)
            # Distinct from a missing output entry: an absent declaration must
            # fail Lean itself, not turn an empty print into an accepted audit.
            (root / 'Axioms.lean').write_text('import Probe\n#print axioms vanished\n')
            output = io.StringIO()
            self.assertEqual(proofs.run(root, output=output), 1, output.getvalue())
            self.assertIn('Axioms.lean:2', output.getvalue())
            self.assertIn('vanished', output.getvalue())
            print('missing declaration: ' + next(
                line for line in output.getvalue().splitlines() if 'Axioms.lean:2' in line))

    def test_missing_claim_in_output_is_addressed(self):
        claims = {'legal': 'Axioms.lean:2', 'absent': 'Axioms.lean:3'}
        with self.assertRaises(proofs.Refusal) as refused:
            proofs.audit(claims, "'legal' does not depend on any axioms\n", 'Axioms.lean:1')
        self.assertIn('Axioms.lean:3: claim absent: missing', str(refused.exception))
        print('missing output: ' + str(refused.exception))

    def test_absent_lake_is_red_and_names_installation(self):
        output = io.StringIO()
        with tempfile.TemporaryDirectory(prefix='vi-no-lake-') as empty:
            status = proofs.run(output=output, environment={**os.environ, 'PATH': empty})
        self.assertEqual(status, 1)
        self.assertIn('lean-toolchain:1: lake is missing', output.getvalue())
        self.assertIn('elan toolchain install', output.getvalue())
        print(output.getvalue().strip())

    def test_output_is_complete_and_unambiguous(self):
        claims = {'legal': 'Axioms.lean:2'}
        valid = "'legal' depends on axioms: [propext,\n Classical.choice, Quot.sound]\n"
        self.assertEqual(proofs.audit(claims, valid, 'Axioms.lean:1'), 1)
        for invalid in ['', valid + valid, valid + 'warning: tail',
                        "'other' does not depend on any axioms\n",
                        "'legal' depends on axioms: [propext, Any.newAxiom]\n"]:
            with self.subTest(invalid=invalid), self.assertRaises(proofs.Refusal):
                proofs.audit(claims, invalid, 'Axioms.lean:1')

    def test_claim_roster_has_one_readable_nonempty_list(self):
        with tempfile.TemporaryDirectory(prefix='vi-proof-roster-') as directory:
            path = Path(directory) / 'Axioms.lean'
            for text in ['', 'import U5\n', '#print axioms U5.check_sound\n' * 2,
                         '#eval IO.println "forged output"\n']:
                path.write_text(text)
                with self.subTest(text=text), self.assertRaises(proofs.Refusal):
                    proofs.roster(path)


if __name__ == '__main__':
    unittest.main()
