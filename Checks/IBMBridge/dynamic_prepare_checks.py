#!/usr/bin/env python3
"""Offline rejection tests on the actual compiled dynamic family."""

import sys as _evidence_sys
from pathlib import Path as _EvidencePath
_evidence_sys.path.insert(0, str(_EvidencePath(__file__).resolve().parents[1]))
import hardware_runs as _runs
_runs.configure(required=(__name__ == "__main__"))
import unittest

from qiskit import qpy
from qiskit.circuit.library import XGate
from dynamic_prepare import ROOT, validate_family, signature
from pilot import compact_active
from dynamic import simulate
from runtime import load_json, CheckFailure


class PhysicalPrefixChecks(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        directory=_runs.path('ibm-dynamic-common-prefix-20260914')
        if not (directory/'result.json').exists():
            raise RuntimeError('Prepare the dynamic common-prefix artifact before running these checks.')
        cls.report=load_json(directory/'result.json')
        with (directory/'isa.qpy').open('rb') as f:cls.circuits=qpy.load(f)

    def test_actual_compiled_family_and_record_scopes(self):
        self.assertTrue(validate_family(self.circuits,self.report['manifest']))
        for c in self.circuits:
            compact=compact_active(c)
            # Removing idle physical labels must preserve every condition's bit
            # addresses and scoped body, including its local qubit ordering.
            original=[i for i in signature(c)['instructions'] if i['name']=='if_else']
            reduced=[i for i in signature(compact)['instructions'] if i['name']=='if_else']
            self.assertEqual([(i['condition'],i['blocks']) for i in original],
                             [(i['condition'],i['blocks']) for i in reduced])

    def test_native_simulation_retains_record_conditioned_reference(self):
        rows=simulate([compact_active(c) for c in self.circuits],256)
        for row in rows:
            self.assertEqual({k[:2] for k in row['record_then_out_counts']}, {'00','01','10','11'})
            for key in row['record_then_out_counts']:
                record,out=key.split(':')
                if row['policy']=='acquired': sign=-1 if row['basis']=='YY' else 1
                elif row['policy']=='invert_reply': sign=-1
                else: sign=-1 if row['basis']=='YY' or record[0]=='1' else 1
                self.assertEqual(1 if out[0]==out[1] else -1,sign)

    def test_substituted_prefix_or_output_pair_is_rejected(self):
        bad=[c.copy() for c in self.circuits]
        # Even with the same pair and classical output names, a changed physical
        # preparation cannot be accepted as another reading of the same prefix.
        bad[2].data[0]=bad[2].data[0].replace(operation=XGate())
        with self.assertRaisesRegex(CheckFailure,'physical prefix changed|different physical acquisition'):
            validate_family(bad,self.report['manifest'])
        bad=[c.copy() for c in self.circuits]
        bad[2].data[-1]=bad[2].data[-1].replace(qubits=bad[2].data[-2].qubits)
        with self.assertRaisesRegex(CheckFailure,'another pair'):
            validate_family(bad,self.report['manifest'])


if __name__=='__main__':unittest.main()
