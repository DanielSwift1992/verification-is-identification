"""Offline fixed-criteria, joint-record and once-only submission checks."""

import sys as _evidence_sys
from pathlib import Path as _EvidencePath
_evidence_sys.path.insert(0, str(_EvidencePath(__file__).resolve().parents[1]))
import hardware_runs as _runs
_runs.configure(required=(__name__ == "__main__"))
from copy import deepcopy
from pathlib import Path
import shutil
import tempfile
from types import SimpleNamespace
import unittest
from unittest.mock import patch

from qiskit.primitives.containers import BitArray, DataBin, SamplerPubResult, PrimitiveResult
import dynamic_run as run
from runtime import CheckFailure, load_json, write_json


def fake_result(circuits):
    pubs=[]
    for c in circuits:
        record=BitArray.from_samples(['10','01','11','00']*256)
        out=BitArray.from_samples(['01','10','11','11']*256)
        pubs.append(SamplerPubResult(DataBin(out=out,record=record),
                                     metadata={'circuit_metadata':c.metadata}))
    return PrimitiveResult(pubs)


class DynamicRuntimeChecks(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.original=_runs.path('ibm-dynamic-qpu-ready-20260914')
        if not (cls.original/'plan.json').exists():
            cls.original=_runs.path('ibm-dynamic-qpu-20260914')
        cls.plan,cs=run.read_plan(cls.original)
        cls.circuits=[cs[i] for i in run.ORDER]

    def test_actual_two_register_order_and_foreign_metadata(self):
        result=fake_result(self.circuits)
        rows=run.decode_result(result,self.circuits)
        for row in rows:
            self.assertEqual(row['record_then_out_counts'],
                             {'10:01':256,'01:10':256,'11:11':256,'00:11':256})
            self.assertEqual(row['out_counts'],{'01':256,'10':256,'11':512})
        result[0].metadata['circuit_metadata']={'experiment':'foreign'}
        with self.assertRaises(CheckFailure):run.decode_result(result,self.circuits)

    def test_fixed_bell_criteria_and_incomplete_data(self):
        rows=[]
        for p in run.POLICIES:
            for b in run.BASES:
                counts=({'01':1024} if b=='YY' or p=='invert_reply' else
                        {'00':512,'01':512} if p=='ignore_reply' else {'00':1024})
                rows.append({'policy':p,'basis':b,'shots':1024,'out_counts':counts})
        a=run.analyse(rows)
        self.assertEqual([a['policies'][p]['bell_score'] for p in run.POLICIES],[1,.5,0])
        self.assertTrue(all(a['criteria'].values()))
        self.assertAlmostEqual(a['conditional_99pct_delta_interval'][0],.3185)
        with self.assertRaises(CheckFailure):run.analyse(rows[:-1]+[rows[0]])
        bad=deepcopy(rows);bad[0]['out_counts']={'00':1000}
        with self.assertRaises(CheckFailure):run.analyse(bad)

    def test_complete_collection_checks_conditional_source_and_shots(self):
        plan=self.plan;circuits=self.circuits
        job=SimpleNamespace(job_id=lambda:'fake-dynamic-only',tags=[plan['tag']],status=lambda:'DONE',
            backend=lambda:SimpleNamespace(name=plan['backend']),
            inputs={'pubs':[[c,None,1024] for c in circuits]},result=lambda:fake_result(circuits),metrics=lambda:{})
        service=SimpleNamespace(job=lambda _:job,active_instance=lambda:plan['instance'],usage=lambda:{})
        with tempfile.TemporaryDirectory() as tmp:
            out=_runs.owned(tmp)
            for name in ('plan.json','isa.qpy'):shutil.copyfile(self.original/name,out/name)
            write_json(out/'ledger.json',_runs.bind_receipt({'tag':plan['tag'],'qpy_sha256':plan['qpy_sha256'],'job_id':'fake-dynamic-only'}, destination=out/'ledger.json'))
            with patch('dynamic_run.service_open',return_value=service),patch('builtins.print'):
                report=run.collect(out)
                self.assertEqual(report['status'],'DONE')
                self.assertTrue((out/'raw-result.json').is_file())
                job.inputs['pubs'][0][2]=512
                with self.assertRaisesRegex(CheckFailure,'shots changed'):run.collect(out)
                job.inputs['pubs'][0][2]=1024
                original=circuits[0]
                changed=original.copy_empty_like()
                j=next(j for j,i in enumerate(original.data) if i.operation.name=='if_else')
                from qiskit.circuit import IfElseOp
                for k,ins in enumerate(original.data):
                    op=ins.operation
                    if k==j:op=IfElseOp((op.condition[0],0),op.blocks[0].copy())
                    changed.append(op,ins.qubits,ins.clbits)
                job.inputs['pubs'][0][0]=changed
                with self.assertRaisesRegex(CheckFailure,'conditional program'):run.collect(out)

    def test_missing_reply_cannot_trigger_a_second_submission(self):
        state={'calls':0,'jobs':[],'remaining':600}
        service=SimpleNamespace(active_instance=lambda:self.plan['instance'],
            usage=lambda:{'usage_remaining_seconds':state['remaining']},
            backend=lambda _:SimpleNamespace(status=lambda:SimpleNamespace(operational=True,status_msg='active')),
            jobs=lambda **kwargs:state['jobs'])
        with tempfile.TemporaryDirectory() as tmp:
            out=_runs.owned(tmp)
            class Sampler:
                def __init__(self,**kwargs):
                    assert kwargs['options']['max_execution_time']==60
                def run(self,circuits,shots):
                    assert shots==1024 and len(circuits)==9
                    assert load_json(out/'ledger.json')['status']=='submission_intent'
                    state['calls']+=1
                    raise TimeoutError('accepted remotely; reply lost')
            with self.assertRaises(TimeoutError):run.send_once(out,service,self.plan,self.circuits,Sampler)
            with self.assertRaises(CheckFailure):run.send_once(out,service,self.plan,self.circuits,Sampler)
            state['jobs']=[SimpleNamespace(job_id=lambda:'recovered-once')]
            self.assertEqual(run.send_once(out,service,self.plan,self.circuits,Sampler)['job_id'],'recovered-once')
            self.assertEqual(state['calls'],1)
        with tempfile.TemporaryDirectory() as tmp:
            state['remaining']=0
            with self.assertRaises(CheckFailure):run.send_once(_runs.owned(tmp),service,self.plan,self.circuits,Sampler)


if __name__=='__main__':unittest.main()
