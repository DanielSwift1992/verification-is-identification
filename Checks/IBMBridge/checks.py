"""Offline boundary checks: actual bit order, source binding and lost submission reply."""
from pathlib import Path
import tempfile
from types import SimpleNamespace
import unittest
from unittest.mock import patch
import shutil
import sys
from collections import Counter

from pilot import normalize, lower, send_once, CASES, SHOTS, ROOT
from execute import terminal_job, decode_result
from prepare import prepare
from runtime import CheckFailure, load_json
import pilot


class SubmissionService:
    def __init__(self): self.calls = 0; self.visible = []; self.remaining = 600
    def active_instance(self): return 'test-open'
    def usage(self): return {'usage_remaining_seconds':self.remaining}
    def backend(self,name):
        return SimpleNamespace(status=lambda:SimpleNamespace(operational=True,status_msg='active'))
    def jobs(self,**kw): return self.visible


class Boundaries(unittest.TestCase):
    @classmethod
    def setUpClass(cls): cls.docs,_ = prepare(ROOT/'private/ibm-prepared')

    def test_bit_order_with_every_possible_reply(self):
        # Independent expression from the checked relabel table. Exhaustive,
        # asymmetric counts ensure a bit-order reversal cannot pass by symmetry.
        for name,preparation,_ in CASES:
            job,desc,req = terminal_job(self.docs,name,preparation,SHOTS)
            width = len(desc['measured_wires'])
            strings = [format(i,f'0{width}b') for i in range(1<<width)]
            counts = {bits:i+1 for i,bits in enumerate(strings)}
            counts[strings[-1]] += SHOTS-sum(counts.values())
            expected = Counter()
            for ibm_string,n in counts.items():
                bits = list(reversed(ibm_string))
                record = bits[0] if req['action']=='skip' else bits[1]+bits[0]
                answer = int(bits[-1]) ^ desc['execution']['by_record'][record]['relabel']
                expected[str(answer)] += n
            normalized = normalize({'job':job,'descriptor':desc},counts)
            self.assertEqual(decode_result(job,desc,normalized)['answer_counts'],dict(expected))
            with self.assertRaises(CheckFailure):
                normalize({'job':job,'descriptor':desc},{'0':256})

    def test_changed_source_and_descriptor_are_rejected(self):
        job,desc,_=terminal_job(self.docs,'AcquireZ','plus',SHOTS)
        changed=dict(job,qasm=job['qasm']+'x q[0];\n')
        with self.assertRaises(CheckFailure): lower(changed,desc)
        swapped=dict(desc,measured_wires=list(reversed(desc['measured_wires'])))
        with self.assertRaises(CheckFailure): lower(job,swapped)

    def test_reply_loss_never_submits_twice(self):
        with tempfile.TemporaryDirectory() as tmp:
            directory=Path(tmp); service=SubmissionService()
            plan={'tag':'test-tag','backend':'test','instance':'test-open','qpy_sha256':'test'}
            class Sampler:
                def __init__(self,**kwargs):
                    self.options=kwargs['options']
                    assert self.options['max_execution_time']==30
                def run(self,circuits,shots):
                    assert load_json(directory/'ledger.json')['status']=='submission_intent'
                    service.calls+=1
                    raise TimeoutError('response lost after remote acceptance')
            with self.assertRaises(TimeoutError): send_once(directory,service,plan,[],Sampler)
            with self.assertRaises(CheckFailure): send_once(directory,service,plan,[],Sampler)
            service.visible=[SimpleNamespace(job_id=lambda:'remote-id')]
            self.assertEqual(send_once(directory,service,plan,[],Sampler)['job_id'],'remote-id')
            self.assertEqual(send_once(directory,service,plan,[],Sampler)['job_id'],'remote-id')
            self.assertEqual(service.calls,1)

    def test_quota_rejection_precedes_submission(self):
        with tempfile.TemporaryDirectory() as tmp:
            directory=Path(tmp); service=SubmissionService(); service.remaining=0
            plan={'tag':'test-tag','backend':'test','instance':'test-open','qpy_sha256':'test'}
            with self.assertRaises(CheckFailure): send_once(directory,service,plan,[],lambda **kw:self.fail('created sampler'))
            self.assertFalse((directory/'ledger.json').exists())

    def test_complete_collection_and_foreign_occurrence_rejection(self):
        from qiskit.primitives.containers import BitArray, DataBin, SamplerPubResult, PrimitiveResult
        from pilot import read_plan, lower
        original=ROOT/'private/ibm-qpu-pilot-20260914'
        if not (original/'plan.json').exists(): self.skipTest('requires a prepared pilot, no cloud execution')
        plan,circuits=read_plan(original,current=False)
        pubs=[]
        for case in plan['cases']:
            width=len(case['descriptor']['measured_wires'])
            counts={format(i,f'0{width}b'):SHOTS//(1<<width) for i in range(1<<width)}
            pubs.append(SamplerPubResult(DataBin(out=BitArray.from_counts(counts)),
                metadata={'circuit_metadata':lower(case['job'],case['descriptor']).metadata}))
        result=PrimitiveResult(pubs)
        job=SimpleNamespace(job_id=lambda:'fake-only',tags=[plan['tag']],status=lambda:'DONE',
            backend=lambda:SimpleNamespace(name=plan['backend']),
            inputs={'pubs':[[c,None,SHOTS] for c in circuits]},result=lambda:result,metrics=lambda:{})
        service=SimpleNamespace(job=lambda _:job,active_instance=lambda:plan['instance'],usage=lambda:{})
        with tempfile.TemporaryDirectory() as tmp:
            out=Path(tmp)
            for name in ('plan.json','isa.qpy'): shutil.copyfile(original/name,out/name)
            from runtime import write_json
            write_json(out/'ledger.json',{'tag':plan['tag'],'qpy_sha256':plan['qpy_sha256'],'job_id':'fake-only'})
            with patch('pilot.service_open',return_value=service),patch('builtins.print'):
                pilot.collect(out)
                self.assertEqual(load_json(out/'hardware-result.json')['status'],'DONE')
                self.assertTrue((out/'raw-result.json').is_file())
                job.tags=['another-occurrence']
                with self.assertRaises(CheckFailure): pilot.collect(out)


if __name__=='__main__': unittest.main()
