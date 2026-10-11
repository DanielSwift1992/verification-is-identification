#!/usr/bin/env python3
"""Offline obligations for the bounded joint-memory hardware adapter."""
from copy import deepcopy
import json
from pathlib import Path
import tempfile
from types import SimpleNamespace
import shutil
from unittest.mock import patch
import argparse
import math

import joint_memory as j
from qiskit import transpile


def rejects(f):
    try:f()
    except (AssertionError,ValueError):return
    raise AssertionError('invalid evidence was accepted')


def collection_checks():
    from qiskit.primitives.containers import BitArray,DataBin,SamplerPubResult,PrimitiveResult
    original=j.ROOT/'private/ibm-joint-memory-20260914'
    if not original.exists():return {'prepared_collection':'not yet available'}
    plan,circuits=j.load(original,True);pubs=[]
    for circuit in circuits:
        bits=BitArray.from_samples(['0000']*j.SHOTS,num_bits=4)
        pubs.append(SamplerPubResult(DataBin(out=bits),metadata={'circuit_metadata':circuit.metadata}))
    result=PrimitiveResult(pubs)
    job=SimpleNamespace(job_id=lambda:'offline-job',tags=[plan['tag']],backend=lambda:SimpleNamespace(name=plan['backend']),
       status=lambda:'DONE',inputs={'pubs':[(c,) for c in circuits]},result=lambda:result,metrics=lambda:{'offline':True})
    service=SimpleNamespace(active_instance=lambda:plan['instance'],job=lambda key:job,usage=lambda:{'offline':True})
    with tempfile.TemporaryDirectory(prefix='vi-joint-collector-check-') as tmp:
        target=Path(tmp)/'test';shutil.copytree(original,target)
        j.write(target/'ledger.json',{'tag':plan['tag'],'qpy_sha256':plan['qpy_sha256'],'job_id':'offline-job'})
        with patch.object(j,'service_open',lambda:service):
            assert j.collect(target)['status']=='DONE'
            assert j.read(target/'hardware-result.json')['rows'][0]['counts']=={'0000':1024}
            job.tags=['foreign-job'];rejects(lambda:j.collect(target));job.tags=[plan['tag']]
            foreign=circuits[0].copy();foreign.x(0)
            job.inputs['pubs'][0]=(foreign,);rejects(lambda:j.collect(target));job.inputs['pubs'][0]=(circuits[0],)
            pubs[0].metadata['circuit_metadata']={'case':'foreign'}
            rejects(lambda:j.collect(target));pubs[0].metadata['circuit_metadata']=circuits[0].metadata
            result=PrimitiveResult(pubs[:-1]);rejects(lambda:j.collect(target))
        p=j.read(target/'plan.json');p['options']['max_execution_time']=900;j.write(target/'plan.json',p)
        rejects(lambda:j.load(target))
    return {'prepared_collection':'passed offline','foreign_or_incomplete_result_refusals':4,'altered_resource_limit_refusals':1}


def replay(directory,publish=None):
    """Re-read the serialized provider result; no network and no new experiment."""
    from qiskit_ibm_runtime import RuntimeDecoder
    p,circuits=j.load(directory);r=j.read(directory/'hardware-result.json')
    ledger=j.read(directory/'ledger.json');protocol=j.read(directory/'protocol-receipt.json')
    assert r['job_id']==ledger['job_id'] and r['status']=='DONE' and r['backend']==p['backend']
    assert j.sha((directory/'plan.json').read_bytes())==protocol['plan_sha256']
    assert j.sha((directory/'protocol-before-submission.md').read_bytes())==protocol['sha256']
    assert j.sha((directory/'raw-result.json').read_bytes())==r['raw_sha256']
    raw=json.loads((directory/'raw-result.json').read_text(),cls=RuntimeDecoder)
    assert len(raw)==len(circuits)==9
    rows=[];radius=math.sqrt(math.log(5400)/2048)
    for c,pub in zip(circuits,raw):
        assert pub.metadata['circuit_metadata']==c.metadata and set(pub.data.keys())=={'out'}
        assert pub.data.out.num_bits==4 and pub.data.out.num_shots==1024 and pub.data.out.shape==()
        counts=dict(pub.data.out.get_counts());name=c.metadata['case']
        rows.append({'case':name,'shots':1024,'counts':counts})
        # Independent string-based readout, including asymmetric bit patterns.
        successes={'data':sum(n for bits,n in counts.items() if bits[-2:]=='00'),
                   'memory':sum(n for bits,n in counts.items() if bits[:2]=='00'),
                   'joint':sum(n for bits,n in counts.items() if bits=='0000')}
        assert sum(counts.values())==1024
        for key,n in successes.items():
            claimed=r['analysis']['cases'][name][key]
            assert claimed['successes']==n and claimed['frequency']==n/1024
            expected=[max(0,n/1024-radius),min(1,n/1024+radius)]
            assert max(abs(a-b) for a,b in zip(expected,claimed['simultaneous_interval']))<1e-14
    assert rows==r['rows'] and j.analyse(rows)==r['analysis']
    artifact={'schema':'vi.ibm.joint-memory.observations.v1','job_id':r['job_id'],'backend':r['backend'],
      'plan_sha256':protocol['plan_sha256'],'protocol_sha256':protocol['sha256'],
      'raw_result_sha256':r['raw_sha256'],'qpy_sha256':p['qpy_sha256'],
      'source_sha256':p['source_sha256'],'implementation':p['implementation'],'versions':p['versions'],
      'physical_D_E_RD_RE':p['physical_D_E_RD_RE'],'case_bindings':[c.metadata for c in circuits],
      'instruction_manifests':p['manifests'],'ideal_validation':j.read(directory/'ideal-validation.json'),
      'rows':rows,'analysis':r['analysis'],'timestamps':r['metrics']['timestamps'],
      'qpu_charge_time_seconds':r['metrics']['usage']['qpu_charge_time_seconds'],
      'free_quota_before_seconds':p['usage_before']['usage_remaining_seconds'],
      'free_quota_after_seconds':r['usage_after']['usage_remaining_seconds'],
      'actual_plan':'open/free','billed_money':0,
      'scope':'Executed four-qubit tests including preparation and analyzer; no future, SPAM-free or full-DE diamond guarantee.'}
    if publish:j.write(publish,artifact)
    return {'provider_rows_replayed':9,'independently_recomputed_scores_and_intervals':27,
            'shots':sum(row['shots'] for row in rows),'criteria':r['analysis']['criteria'],
            'qpu_charge_time_seconds':artifact['qpu_charge_time_seconds'],'output':str(publish) if publish else None}


def run():
    source=j.current_source();rows=[];manifests=[];ideal={}
    for name in j.CASES:
        circuit=j.logical(source,name,'offline-test')
        isa=transpile(circuit,basis_gates=['cz','rz','sx','x','reset'],optimization_level=0)
        m=j.validate_isa(isa,[0,1,2,3]);manifests.append(m)
        a,b=j.probabilities(circuit),j.probabilities(isa)
        assert max(abs(a.get(k,0)-b.get(k,0)) for k in set(a)|set(b))<1e-10
        counts={k:round(p*j.SHOTS) for k,p in a.items()};ideal[name]=counts
        rows.append({'case':name,'shots':j.SHOTS,'counts':counts})
        if name=='keep_h':
            bad=isa.copy()
            bad.data.pop(next(i for i,x in enumerate(bad.data) if x.operation.name=='cz' and {bad.find_bit(q).index for q in x.qubits}=={0,1}))
            rejects(lambda:j.validate_isa(bad,[0,1,2,3]))
        if name=='reset_h':
            bad=isa.copy();bad.data.pop(next(i for i,x in enumerate(bad.data) if x.operation.name=='reset'))
            rejects(lambda:j.validate_isa(bad,[0,1,2,3]))
        rejects(lambda:j.validate_isa(isa,[0,1,3,2]))
    assert j.scores(ideal['single_keep'])['data']==j.SHOTS//2
    assert j.scores(ideal['single_replace'])['data']==j.SHOTS//2
    assert j.scores(ideal['reset_h'])=={'data':256,'memory':256,'joint':64}
    assert ideal['moving_h_wrong_memory']=={'0100':1024}
    for name in ('baseline_h','keep_h','moving_h','keep_twice','moving_twice'):
        assert ideal[name]=={'0000':1024}
    result=j.analyse(rows);assert all(result['criteria'].values())
    assert .06<result['simultaneous_radius']<.07
    bad=deepcopy(rows);bad[0]['counts']={'0000':1023};rejects(lambda:j.analyse(bad))
    bad=deepcopy(rows);bad[0]['case']=bad[1]['case'];rejects(lambda:j.analyse(bad))
    for c in ({'000':1024},{'0000':True},{'0000':1025},{'0000':1024,'1000':-1}):
        rejects(lambda:j.scores(c))
    assert j.scores({'1100':512,'0011':512})=={'data':512,'memory':512,'joint':0}

    # A real run can be called once, including an uncertain network response.
    state={'calls':0,'jobs':[],'quota':585,'lost':False}
    job=SimpleNamespace(job_id=lambda:'fake-job')
    backend=SimpleNamespace(status=lambda:SimpleNamespace(operational=True,status_msg='active'))
    service=SimpleNamespace(active_instance=lambda:'open-test',usage=lambda:{'usage_remaining_seconds':state['quota']},
       backend=lambda name:backend,jobs=lambda **kw:state['jobs'])
    class Sampler:
        def __init__(self,mode,options):assert mode is backend and options==j.options('fake-tag')
        def run(self,circuits,shots):
            assert shots==1024;state['calls']+=1;state['jobs']=[job]
            if state['lost']:raise ConnectionError('simulated lost response')
            return job
    plan={'tag':'fake-tag','qpy_sha256':'fake-digest','instance':'open-test',
          'backend':'ibm_kingston','options':j.options('fake-tag')}
    with tempfile.TemporaryDirectory(prefix='vi-joint-memory-check-') as tmp:
        root=Path(tmp);normal=root/'normal';normal.mkdir()
        assert j.send_once(normal,service,plan,[],Sampler)['job_id']=='fake-job'
        assert j.send_once(normal,service,plan,[],Sampler)['job_id']=='fake-job'
        assert state['calls']==1
        uncertain=root/'uncertain';uncertain.mkdir();state['lost']=True
        try:j.send_once(uncertain,service,plan,[],Sampler)
        except ConnectionError:pass
        else:raise AssertionError('expected lost response')
        assert state['calls']==2
        state['jobs']=[];rejects(lambda:j.send_once(uncertain,service,plan,[],Sampler))
        state['jobs']=[job,job];rejects(lambda:j.send_once(uncertain,service,plan,[],Sampler))
        state['jobs']=[job]
        assert j.send_once(uncertain,service,plan,[],Sampler)['status']=='recovered'
        assert state['calls']==2
        poor=root/'poor';poor.mkdir();state['quota']=44
        rejects(lambda:j.send_once(poor,service,plan,[],Sampler));assert not (poor/'ledger.json').exists()
    return {'logical_cases':9,'ideal_ISA_matches':9,'compilation_contact_reset_wiring_refusals':11,
            'statistics_and_record_refusals':6,'submission_calls_including_lost_response':2,
            'duplicate_submissions':0,'ideal_criteria':result['criteria'],
            'collection':collection_checks(),
            'scope':'Offline interpreter, fixed questions, actual instruction retention and at-most-once submission; no QPU claim.'}


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--replay',type=Path);parser.add_argument('--publish',type=Path)
    args=parser.parse_args();assert not args.publish or args.replay
    print(json.dumps(replay(args.replay,args.publish) if args.replay else run(),indent=2))
