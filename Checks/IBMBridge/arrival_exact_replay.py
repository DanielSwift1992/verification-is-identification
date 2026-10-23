#!/usr/bin/env python3
"""Attempt 2: exact frozen QPY and exposed settings, new job occurrence.

Source circuit metadata is deliberately unchanged. The new outer job tag
distinguishes this occurrence. No old campaign writer or submitter is called.
"""

import sys as _evidence_sys
from pathlib import Path as _EvidencePath
_evidence_sys.path.insert(0, str(_EvidencePath(__file__).resolve().parents[1]))
import hardware_runs as _runs
_runs.configure(required=(__name__ == "__main__"))
import argparse
from collections import Counter
import copy
import fcntl
import json
from pathlib import Path

from qiskit import qpy
from qiskit_ibm_runtime import SamplerV2, RuntimeEncoder
from qiskit_ibm_runtime.utils.validations import validate_isa_circuits
from pilot import service_open, sha, utc, versions, require, compact_active
from resident_joint_confirmation import canonical_mcm
import arrival_boundary_probe as old
from arrival_boundary_analysis import analyze as original_analysis

ROOT=old.ROOT
PARENT=_runs.path('ibm-arrival-boundary-20260916')
PRIVATE=_runs.work('ibm-xx-exact-replay-20260916')
ART=ROOT/'Research/Artifacts/xx-three-attempts-20260916/attempt-2'
STATE=ROOT/'Research/Artifacts/xx-three-attempts-20260916/state.json'
TAG='vi-xx-three-attempts-2-20260916'
EXPECTED_QPY='b0707c0d4b05bd2eeeddcdae517113e26c081a67e361227ba0eda28552e41893'
SHOTS=32
CAP=30


def read(p):return json.loads(p.read_text())
def write(p,v):p.write_text(json.dumps(_runs.bind_receipt(v, destination=p),indent=2)+'\n')


@_runs.include_reader
def dependencies():
    paths=[_runs.owned(__file__),_runs.owned(old.__file__),ROOT/'Checks/IBMBridge/arrival_boundary_analysis.py',
           ROOT/'Checks/IBMBridge/pilot.py',ROOT/'Checks/IBMBridge/resident_joint_confirmation.py',
           ROOT/'Checks/IBMBridge/classical_boundary_probe.py']
    return {_runs.address(p, ROOT):sha(p.read_bytes()) for p in paths}


def options():
    parent=read(PARENT/'plan.json');out=copy.deepcopy(parent['options'])
    out['environment']['job_tags']=[TAG]
    return out


def prepare():
    require(not (PRIVATE/'plan.json').exists(),'Already prepared')
    # This is a read-only parent admission. It neither resumes its night
    # ledger nor replaces any source, derived result or previous intent.
    parent,qs=old.load(PARENT)
    require(parent['qpy_sha256']==EXPECTED_QPY and parent['shots_each']==SHOTS
            and parent['total_shots']==1024,'Not the planned historical source')
    old.verify_parent(old.ART/'manifest.json')
    checks={}
    for variant in old.VARIANTS:
        with (old.ART/(variant+'-core.qpy')).open('rb') as f:core,=qpy.load(f)
        final=next(r['final_layout'] for r in parent['PUBs'] if r['variant']==variant)
        checks[variant]=old.operator_check(core,final,variant)
    for q in qs:
        m=q.metadata
        old.local(compact_active(q),m['variant'],m['prepared_arrival'],m['basis'],int(m['law_b_preparation']=='-'))
    service=service_open();backend=service.backend(parent['backend']);st=backend.status()
    require(service.active_instance()==parent['instance'],'Parent instance changed')
    require(st.operational and st.status_msg=='active','Backend unavailable')
    validate_isa_circuits(qs,backend.target)
    PRIVATE.mkdir(parents=True,exist_ok=True);ART.mkdir(parents=True,exist_ok=True)
    # Literal copy, not round-trip serialization or recompilation.
    (PRIVATE/'isa.qpy').write_bytes((PARENT/'isa.qpy').read_bytes())
    require(sha((PRIVATE/'isa.qpy').read_bytes())==EXPECTED_QPY,'Literal copy differs')
    p={'schema':'vi.xx-exact-replay.v1','at':utc(),'tag':TAG,'backend':backend.name,
       'instance':service.active_instance(),'plan':'open','options':options(),'versions':versions(),
       'dependencies':dependencies(),'qpy_sha256':EXPECTED_QPY,'parent_plan_sha256':sha((PARENT/'plan.json').read_bytes()),
       'parent_raw_sha256':sha((PARENT/'raw-result.json').read_bytes()),
       'shots_each':SHOTS,'total_shots':1024,'cap_seconds':CAP,'PUBs':parent['PUBs'],
       'operator_checks':checks,'all_32_serialized_witnesses_checked':True,
       'analysis':'All shots, original decoder and balanced B/XX/ZZ analysis. Primary comparison: '
                  'prepared C=0 conditional XX old versus replay. Retain separate B+ and B- rows. '
                  'Other arms and ZZ are controls. No postselection or timing attribution. '
                  'Only exposed circuit/settings equality established; hidden compiler/calibration '
                  'and physical context may change between jobs. No automatic resubmission.'}
    write(PRIVATE/'plan.json',p);write(ART/'plan.json',{k:v for k,v in p.items() if k!='instance'})
    return {'prepared':True,'PUBs':32,'shots':1024,'literal_qpy_sha256':EXPECTED_QPY,
            'operator_checks':checks}


def load():
    p=read(PRIVATE/'plan.json')
    require(p['dependencies']==dependencies() and p['options']==options() and p['versions']==versions(),
            'Frozen implementation or options changed')
    require(sha((PARENT/'plan.json').read_bytes())==p['parent_plan_sha256']
            and sha((PARENT/'raw-result.json').read_bytes())==p['parent_raw_sha256'],'Parent evidence changed')
    require(sha((PRIVATE/'isa.qpy').read_bytes())==p['qpy_sha256']==EXPECTED_QPY,'Frozen circuits changed')
    with (PRIVATE/'isa.qpy').open('rb') as f:qs=qpy.load(f)
    require(len(qs)==32 and all(q.metadata=={k:v for k,v in row.items() if k not in ('inventory','exact_moments')}
                for q,row in zip(qs,p['PUBs'])),'PUB identity changed')
    return p,qs


def submit():
    p,qs=load();state=read(STATE)
    require(state['status']=='active' and state['current_attempt']==2,'Wrong campaign')
    require(len(state['new_jobs'])<state['new_job_limit'],'Job limit reached')
    service=service_open();require(service.active_instance()==p['instance'],'Instance changed')
    with (PRIVATE/'submit.lock').open('a') as lock:
        fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
        require(not (PRIVATE/'submission.json').exists(),'Intent exists; never resubmit')
        quota=service.usage()['usage_remaining_seconds'];require(quota>=CAP,'No free quota')
        backend=service.backend(p['backend']);st=backend.status()
        require(st.operational and st.status_msg=='active','Backend unavailable')
        validate_isa_circuits(qs,backend.target)
        sent={'at':utc(),'tag':TAG,'status':'intent','qpy_sha256':EXPECTED_QPY,
              'cap_seconds':CAP,'total_shots':1024,'free_seconds_before':quota}
        write(PRIVATE/'submission.json',sent);write(ART/'submission.json',sent)
        state['new_jobs'].append({'attempt':2,'tag':TAG,'status':'intent'})
        state['current_stage']='submitting';write(STATE,state)
        job=SamplerV2(mode=backend,options=p['options']).run(qs,shots=SHOTS)
        sent.update(job_id=job.job_id(),status='submitted')
        write(PRIVATE/'submission.json',sent);write(ART/'submission.json',sent)
        state['new_jobs'][-1].update(job_id=job.job_id(),status='submitted')
        state['current_stage']='waiting_for_job';write(STATE,state)
        return sent


def collect():
    p,qs=load();sent=read(PRIVATE/'submission.json');require(sent.get('job_id'),'Uncertain intent')
    service=service_open();require(service.active_instance()==p['instance'],'Instance changed')
    job=service.job(sent['job_id']);require(TAG in job.tags and job.backend().name==p['backend'],'Wrong occurrence')
    status=job.status();out={'at':utc(),'job_id':job.job_id(),'status':status}
    if status=='DONE':
        raw=job._api_client.job_results(job_id=job.job_id());(PRIVATE/'provider-result.txt').write_text(raw)
        result=job.result();require(len(result)==len(qs),'Incomplete result')
        write(PRIVATE/'raw-result.json',json.loads(json.dumps(result,cls=RuntimeEncoder)))
        rows=[]
        for q,pub,entry in zip(qs,result,job.inputs['pubs']):
            remote=entry[0] if isinstance(entry,(tuple,list)) else entry.circuit
            require(canonical_mcm(q)==canonical_mcm(remote) and pub.metadata['circuit_metadata']==q.metadata,
                    'Returned source correspondence failed')
            w=pub.data.witness.get_bitstrings();c=pub.data.actual_arrival.get_bitstrings()
            r=pub.data.actual_replies.get_bitstrings() if q.metadata['variant']!='echo' else ['--']*SHOTS
            require(len(w)==len(c)==len(r)==SHOTS,'Shot count differs')
            b0=sum((int(x,2)&1)==0 for x in w)
            even=sum(((int(x,2)>>1)&1)==((int(x,2)>>2)&1) for x in w)
            rows.append({**q.metadata,'counts':dict(Counter(' '.join(x) for x in zip(c,r,w))),
                         'shots':SHOTS,'B_zero':b0,'B_X':2*b0/SHOTS-1,'data_even':even,
                         'data_parity':2*even/SHOTS-1,
                         'arrival_agreement':sum(int(x,2)==q.metadata['prepared_arrival'] for x in c)})
        out.update(rows=rows,provider_raw_sha256=sha((PRIVATE/'provider-result.txt').read_bytes()),
                   raw_sha256=sha((PRIVATE/'raw-result.json').read_bytes()))
    if status in ('ERROR','CANCELLED'):out['error']=job.error_message()
    if status in ('DONE','ERROR','CANCELLED'):
        out.update(metrics=job.metrics(),free_seconds_after=service.usage()['usage_remaining_seconds'])
    write(PRIVATE/'status.json',out);write(ART/'status.json',out)
    return {k:v for k,v in out.items() if k!='rows'}


def analyze():
    p,_=load();status=read(ART/'status.json')
    require(status['status']=='DONE','No completed observations')
    require(sha((PRIVATE/'raw-result.json').read_bytes())==status['raw_sha256'],'Returned record changed')
    parent=read(PARENT/'plan.json');previous=original_analysis(read(PARENT/'status.json'),parent)
    current=original_analysis(status,parent)
    pairs=[]
    for a,b in zip(previous['rows'],current['rows']):
        require(a['variant']==b['variant'] and a['prepared_arrival']==b['prepared_arrival'],'Wrong comparison')
        pairs.append({'variant':a['variant'],'prepared_arrival':a['prepared_arrival'],
                      'old_B_response':a['balanced_B_response'],'new_B_response':b['balanced_B_response'],
                      'old_XX':a['data']['XX']['parity'],'new_XX':b['data']['XX']['parity'],
                      'old_ZZ':a['data']['ZZ']['parity'],'new_ZZ':b['data']['ZZ']['parity']})
    return {'old_job_id':previous['job_id'],'new_job_id':current['job_id'],'comparison':pairs,
            'current':current,'same_literal_qpy_and_exposed_execution_settings_except_tag':True,
            'scope':'Descriptive per-job comparison; not a stationary-channel assumption or microscopic attribution.'}


if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('stage',choices=['prepare','submit','collect','analyze'])
    print(json.dumps(_runs.bind_receipt(globals()[p.parse_args().stage]()),indent=2))
