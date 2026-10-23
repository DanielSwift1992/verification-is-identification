#!/usr/bin/env python3
"""Offline checks of the separately scoped dynamic State consumer."""

import sys as _evidence_sys
from pathlib import Path as _EvidencePath
_evidence_sys.path.insert(0, str(_EvidencePath(__file__).resolve().parents[1]))
import hardware_runs as _runs
_runs.configure(required=(__name__ == "__main__"))
from copy import deepcopy
import unittest

from dynamic import (ROOT, prepare, source_and_plans, exact_channels,
                     state_fragment, witness, simulate, POLICIES, BASES)
from execute import terminal_job
from runtime import CheckFailure


class DynamicChecks(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.documents, _ = prepare(_runs.prepared('ibm-prepared'))

    def test_all_classical_branches_restore_arbitrary_payload(self):
        result = exact_channels(self.documents)
        for policy, expected in [('acquired',1), ('ignore_reply',0.5), ('invert_reply',0)]:
            self.assertAlmostEqual(result[policy]['uniform_channel_bell_fidelity'], expected)
        bad = deepcopy(self.documents)
        plan = next(p for p in bad['continuations.json']['plans'] if p['name']=='LiveStateAfter')
        # Shape-correct but semantically wrong correction must fail the channel check.
        plan['execution']['by_record']['01']['gates'] = ['z']
        with self.assertRaisesRegex(CheckFailure, 'does not restore'):
            exact_channels(bad)

    def test_state_source_cannot_borrow_another_contact_or_law(self):
        for mutation in ('contact', 'operation', 'law', 'record'):
            with self.subTest(mutation=mutation):
                bad = deepcopy(self.documents)
                model = next(m for m in bad['sources.json']['models'] if m['name']=='LiveStateBefore')
                if mutation == 'contact':
                    request = next(r for r in bad['requests.json']['requests'] if r['name']=='AcquireState')
                    request['cell'] = 1
                elif mutation == 'operation': model['operations'][0]['control'] = 1
                elif mutation == 'law': model['rows'][0]['weight'] = 2
                else: model['acquisitions'] = [[0]]
                with self.assertRaises(CheckFailure): source_and_plans(bad)

    def test_payload_is_unmeasured_until_caller_continuation(self):
        fragment = state_fragment(self.documents, 'acquired')
        measured, seen_if = {}, False
        for ins in fragment.data:
            name = ins.operation.name
            if name == 'measure':
                self.assertFalse(seen_if)
                measured[fragment.find_bit(ins.clbits[0]).index] = fragment.find_bit(ins.qubits[0]).index
            elif name == 'if_else':
                seen_if = True
                self.assertEqual(measured, {0:5, 1:2})
                self.assertEqual(ins.operation.condition[0], fragment.cregs[0])
                self.assertEqual([fragment.find_bit(q).index for q in ins.qubits], [0])
                for block in ins.operation.blocks:
                    self.assertTrue(all(i.operation.name in ('x','y','z') for i in block.data))
        self.assertTrue(seen_if)
        self.assertEqual(measured, {0:5, 1:2})

    def test_actual_measurement_drives_branch_and_preserves_reference(self):
        # Check every reached acquired record, not only aggregated correlations.
        circuits = [witness(self.documents,p,b) for p in POLICIES for b in BASES]
        rows = simulate(circuits,256)
        for row in rows:
            self.assertEqual({key.split(':')[0] for key in row['record_then_out_counts']},
                             {'00','01','10','11'})
            for key,count in row['record_then_out_counts'].items():
                record, out = key.split(':')
                if row['policy'] == 'acquired': expected = -1 if row['basis']=='YY' else 1
                elif row['policy'] == 'invert_reply': expected = -1
                else:
                    expected = -1 if row['basis']=='YY' or record[0]=='1' else 1
                self.assertEqual(1 if out[0]==out[1] else -1, expected)
                self.assertGreater(count,0)

    def test_terminal_state_rejection_remains(self):
        with self.assertRaisesRegex(CheckFailure, 'no supported terminal continuation'):
            terminal_job(self.documents, 'AcquireState', 'plus',256)


if __name__ == '__main__':
    unittest.main()
