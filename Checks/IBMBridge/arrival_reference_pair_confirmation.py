#!/usr/bin/env python3
"""Final bounded attempt: balanced original/R-pair comparison in one job.

Only the reference identity is changed. No marker, new scheduler request,
postselection, fitted correction, or automatic additional job is allowed.
"""
import argparse
from collections import Counter
import fcntl
import io
import json
from pathlib import Path

from qiskit import qpy
from qiskit_ibm_runtime import SamplerV2, RuntimeEncoder
from qiskit_ibm_runtime.utils.validations import validate_isa_circuits
from pilot import service_open, sha, utc, versions, require, compact_active
from resident_joint_confirmation import canonical_mcm, place
import arrival_reference_pair_probe as first
import arrival_boundary_probe as old

ROOT=old.ROOT
PARENT=ROOT/'private/ibm-arrival-boundary-20260916'
PRIVATE=ROOT/'private/ibm-xx-reference-confirmation-20260916'
ART=ROOT/'Research/Artifacts/xx-three-attempts-20260916/attempt-3'
STATE=first.STATE
TAG='vi-xx-three-attempts-3-20260916'
ARMS=('original','reference_pair')
BLOCKS=('original','reference_pair','reference_pair','original')
SHOTS=256
CAP=30


def read(p):return json.loads(p.read_text())
def write(p,v):p.write_text(json.dumps(v,indent=2)+'\n')


def dependencies():
    return {**first.dependencies(),str(Path(__file__).relative_to(ROOT)):sha(Path(__file__).read_bytes())}


def options():
    return {'default_shots':SHOTS,'max_execution_time':CAP,'environment':{'job_tags':[TAG]},
            'execution':{'init_qubits':True},'twirling':{'enable_gates':False,'enable_measure':False},
            'dynamical_decoupling':{'enable':False}}


def remove_reference_pair(q):
    out=q.copy_empty_like();removed_x=removed_barriers=0
    for ins in q.data:
        wires=[q.find_bit(b).index for b in ins.qubits]
        if ins.operation.name=='x' and wires==[34]:removed_x+=1;continue
        if ins.operation.name=='barrier' and ins.operation.label in (
                'reference_pair_first','reference_pair_first_done','reference_pair_done'):
            removed_barriers+=1;continue
        out.append(ins)
    require(removed_x==2 and removed_barriers==3,'Intervention not the declared pair')
    return out


def prepare():
    require(not (PRIVATE/'plan.json').exists(),'Already prepared')
    parent,parent_qs=old.load(PARENT);bodies,final=first.cores()
    checks={arm:old.operator_check(q,final,'conditional') for arm,q in bodies.items()}
    parent_by_case={(q.metadata['prepared_arrival'],q.metadata['basis']):q for q in parent_qs
                    if q.metadata['variant']=='conditional' and q.metadata['law_b_preparation']=='+'}
    require(len(parent_by_case)==4,'Wrong frozen baseline')
    service=service_open();backend=service.backend(parent['backend']);st=backend.status()
    require(service.active_instance()==parent['instance'],'Instance changed')
    require(st.operational and st.status_msg=='active','Backend unavailable')
    qs=[];moments=[]
    for block,arm in enumerate(BLOCKS):
        for c in (0,1):
            for basis in ('XX','ZZ'):
                baseline=parent_by_case[c,basis]
                if arm=='original':q=baseline.copy()
                else:
                    small=old.witness(bodies[arm],final,c,basis,0)
                    q=place(small,parent['path'],backend.num_qubits)
                    require(canonical_mcm(remove_reference_pair(q))==canonical_mcm(baseline),
                            'More than the declared reference identity changed')
                q.metadata={'tag':TAG,'pub_index':len(qs),'block':block,'arm':arm,
                            'prepared_arrival':c,'basis':basis,'law_b_preparation':'+',
                            'prediction':old.ideal('conditional',c,basis,0)}
                validate_isa_circuits([q],backend.target)
                buf=io.BytesIO();qpy.dump(q,buf);buf.seek(0);restored,=qpy.load(buf)
                require(canonical_mcm(q)==canonical_mcm(restored) and q.metadata==restored.metadata,
                        'Serialization changed source or identity')
                old.local(compact_active(restored),'conditional',c,basis,0)
                moments.append(old.exact_witness_moments(bodies[arm],final,'conditional',c,basis,0))
                qs.append(q)
    require(len(qs)==16 and len(qs)*SHOTS==4096,'Final budget differs')
    PRIVATE.mkdir(parents=True,exist_ok=True);ART.mkdir(parents=True,exist_ok=True)
    with (PRIVATE/'isa.qpy').open('wb') as f:qpy.dump(qs,f)
    p={'schema':'vi.xx-reference-confirmation.v1','at':utc(),'tag':TAG,'backend':backend.name,
       'instance':service.active_instance(),'plan':'open','options':options(),'versions':versions(),
       'dependencies':dependencies(),'qpy_sha256':sha((PRIVATE/'isa.qpy').read_bytes()),
       'parent_qpy_sha256':sha((PARENT/'isa.qpy').read_bytes()),'PUBs':[q.metadata for q in qs],
       'operator_checks':checks,'exact_witness_moments':moments,'shots_each':SHOTS,'total_shots':4096,
       'cap_seconds':CAP,'path':parent['path'],'final_layout':final,
       'baseline_instructions_match_frozen_parent':True,'only_declared_pair_differs':True,
       'analysis':'All shots; retain 16 separate PUBs. Four contrasts: C=0/1 and XX/ZZ. '
                  'Primary sampling intervals: 16 simultaneous Bonferroni Clopper-Pearson intervals, '
                  'conditional IID Bernoulli shots within each PUB. Average interval endpoints over '
                  'the two repeats; do not assume repeats share a probability. Compare pair minus '
                  'original using interval arithmetic. ABBA is submitted order only, not a claim '
                  'of chronological hardware execution. No timing attribution, full process fidelity '
                  'claim, postselection or phase correction. Stop after this final job.'}
    write(PRIVATE/'plan.json',p);write(ART/'plan.json',{k:v for k,v in p.items() if k!='instance'})
    return {'prepared':True,'PUBs':16,'shots':4096,'operator_checks':checks,
            'only_reference_pair_differs':True}


def load():
    p=read(PRIVATE/'plan.json')
    require(p['dependencies']==dependencies() and p['versions']==versions() and p['options']==options(),
            'Frozen implementation changed')
    require(sha((PRIVATE/'isa.qpy').read_bytes())==p['qpy_sha256'] and
            sha((PARENT/'isa.qpy').read_bytes())==p['parent_qpy_sha256'],'Source changed')
    with (PRIVATE/'isa.qpy').open('rb') as f:qs=qpy.load(f)
    require(len(qs)==16 and [q.metadata for q in qs]==p['PUBs'],'PUB binding changed')
    return p,qs


def submit():
    p,qs=load();state=read(STATE)
    require(state['status']=='active' and state['current_attempt']==3,'Wrong campaign')
    require(len(state['new_jobs'])==2 and state['new_job_limit']==3,'Last job allowance missing')
    require(all(x['status'] in ('DONE','ERROR','CANCELLED') for x in state['new_jobs']),'Prior job pending')
    service=service_open();require(service.active_instance()==p['instance'],'Instance changed')
    with (PRIVATE/'submit.lock').open('a') as lock:
        fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
        require(not (PRIVATE/'submission.json').exists(),'Intent exists; never resubmit')
        quota=service.usage()['usage_remaining_seconds'];require(quota>=CAP,'No free quota')
        backend=service.backend(p['backend']);st=backend.status()
        require(st.operational and st.status_msg=='active','Backend unavailable')
        validate_isa_circuits(qs,backend.target)
        sent={'at':utc(),'tag':TAG,'status':'intent','qpy_sha256':p['qpy_sha256'],
              'total_shots':4096,'cap_seconds':CAP,'free_seconds_before':quota}
        write(PRIVATE/'submission.json',sent);write(ART/'submission.json',sent)
        state['new_jobs'].append({'attempt':3,'tag':TAG,'status':'intent'})
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
            records=[getattr(pub.data,k).get_bitstrings() for k in ('actual_arrival','actual_replies','witness')]
            require(all(len(x)==SHOTS for x in records),'Shot count differs')
            c,r,w=records;b0=sum((int(x,2)&1)==0 for x in w)
            even=sum(((int(x,2)>>1)&1)==((int(x,2)>>2)&1) for x in w)
            rows.append({**q.metadata,'shots':SHOTS,'counts':dict(Counter(' '.join(x) for x in zip(*records))),
                         'B_zero':b0,'B_X':2*b0/SHOTS-1,'data_even':even,'data_parity':2*even/SHOTS-1,
                         'arrival_agreement':sum(int(x,2)==q.metadata['prepared_arrival'] for x in c)})
        out.update(rows=rows,provider_raw_sha256=sha((PRIVATE/'provider-result.txt').read_bytes()),
                   raw_sha256=sha((PRIVATE/'raw-result.json').read_bytes()))
    if status in ('ERROR','CANCELLED'):out['error']=job.error_message()
    if status in ('DONE','ERROR','CANCELLED'):
        out.update(metrics=job.metrics(),free_seconds_after=service.usage()['usage_remaining_seconds'])
    write(PRIVATE/'status.json',out);write(ART/'status.json',out)
    return {k:v for k,v in out.items() if k!='rows'}


if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('stage',choices=['prepare','submit','collect'])
    print(json.dumps(globals()[p.parse_args().stage](),indent=2))
