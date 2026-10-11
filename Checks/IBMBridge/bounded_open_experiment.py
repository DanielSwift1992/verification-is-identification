#!/usr/bin/env python3
"""Shared transport for the two explicitly bounded relative-acquisition jobs.

Source certificates are produced by each experiment builder before freeze.
This transport checks frozen identity and free resources; it does not certify
the meaning of arbitrary circuits or promote samples to theoretical proofs.
"""
from collections import Counter
import fcntl
import json
from pathlib import Path
from qiskit import qpy
from qiskit_ibm_runtime import SamplerV2, RuntimeEncoder
from qiskit_ibm_runtime.utils.validations import validate_isa_circuits
from pilot import service_open,sha,utc,versions,require
from resident_joint_confirmation import canonical_mcm

ROOT=Path(__file__).resolve().parents[2]
CAMPAIGN=ROOT/'Research/Artifacts/relative-acquisition-20260916/state.json'

def read(p):return json.loads(p.read_text())
def write(p,v):p.write_text(json.dumps(v,indent=2)+'\n')

def options(tag,shots):
    return {'default_shots':shots,'max_execution_time':30,'environment':{'job_tags':[tag]},
            'execution':{'init_qubits':True},'twirling':{'enable_gates':False,'enable_measure':False},
            'dynamical_decoupling':{'enable':False}}

def freeze(private,art,qs,plan,service,backend,dependencies):
    require(not (private/'plan.json').exists(),'Already frozen')
    require(plan['attempt'] in (1,2) and len(qs)*plan['shots_each']<=4096,'Unbounded plan')
    validate_isa_circuits(qs,backend.target)
    private.mkdir(parents=True,exist_ok=True);art.mkdir(parents=True,exist_ok=True)
    with (private/'isa.qpy').open('wb') as f:qpy.dump(qs,f)
    with (private/'isa.qpy').open('rb') as f:restored=qpy.load(f)
    require(len(restored)==len(qs) and all(canonical_mcm(a)==canonical_mcm(b) and a.metadata==b.metadata
                                        for a,b in zip(qs,restored)),'QPY changed source')
    files=set(dependencies)|{Path(__file__),ROOT/'Checks/IBMBridge/pilot.py',ROOT/'Checks/IBMBridge/resident_joint_confirmation.py'}
    p={**plan,'at':utc(),'backend':backend.name,'instance':service.active_instance(),'plan':'open',
       'versions':versions(),'options':options(plan['tag'],plan['shots_each']),
       'total_shots':len(qs)*plan['shots_each'],'cap_seconds':30,
       'qpy_sha256':sha((private/'isa.qpy').read_bytes()),'PUBs':[q.metadata for q in qs],
       'dependencies':{str(f.relative_to(ROOT)):sha(f.read_bytes()) for f in sorted(files)}}
    write(private/'plan.json',p);write(art/'plan.json',{k:v for k,v in p.items() if k!='instance'})
    manifest_files=[private/'isa.qpy',art/'plan.json']+sorted(files)
    write(art/'prepared-manifest.json',{'sha256':{str(f.relative_to(ROOT)):sha(f.read_bytes()) for f in manifest_files}})
    return {'prepared':True,'attempt':p['attempt'],'PUBs':len(qs),'shots':p['total_shots']}

def load(private):
    p=read(private/'plan.json')
    require(p['versions']==versions() and p['options']==options(p['tag'],p['shots_each']),'Execution changed')
    for name,digest in p['dependencies'].items():require(sha((ROOT/name).read_bytes())==digest,'Frozen dependency changed: '+name)
    require(sha((private/'isa.qpy').read_bytes())==p['qpy_sha256'],'Source changed')
    with (private/'isa.qpy').open('rb') as f:qs=qpy.load(f)
    require([q.metadata for q in qs]==p['PUBs'] and len(qs)*p['shots_each']==p['total_shots']<=4096,'PUB identity/budget changed')
    return p,qs

def submit(private,art):
    p,qs=load(private);s=read(CAMPAIGN)
    require(s['status']=='active' and s['current_attempt']==p['attempt'],'Wrong active attempt')
    require(len(s['new_jobs'])<s['new_job_limit']==2 and all(j['status'] in ('DONE','ERROR','CANCELLED') for j in s['new_jobs']),
            'Campaign job limit or pending job')
    service=service_open();require(service.active_instance()==p['instance'],'Wrong instance')
    with (private/'submit.lock').open('a') as lock:
        fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
        require(not (private/'submission.json').exists(),'Intent exists; never resubmit')
        quota=service.usage()['usage_remaining_seconds'];require(quota>=30,'Free quota unavailable')
        backend=service.backend(p['backend']);st=backend.status()
        require(st.operational and st.status_msg=='active','Backend unavailable')
        validate_isa_circuits(qs,backend.target)
        sent={'at':utc(),'tag':p['tag'],'status':'intent','attempt':p['attempt'],'total_shots':p['total_shots'],
              'cap_seconds':30,'qpy_sha256':p['qpy_sha256'],'free_seconds_before':quota}
        write(private/'submission.json',sent);write(art/'submission.json',sent)
        s['new_jobs'].append(sent.copy());s['current_stage']='submitting';write(CAMPAIGN,s)
        job=SamplerV2(mode=backend,options=p['options']).run(qs,shots=p['shots_each'])
        sent.update(job_id=job.job_id(),status='submitted')
        write(private/'submission.json',sent);write(art/'submission.json',sent)
        s['new_jobs'][-1].update(job_id=job.job_id(),status='submitted');s['current_stage']='waiting_for_job';write(CAMPAIGN,s)
        return sent

def collect(private,art):
    p,qs=load(private);sent=read(private/'submission.json');require(sent.get('job_id'),'Uncertain intent: recover by tag')
    service=service_open();require(service.active_instance()==p['instance'],'Wrong instance')
    job=service.job(sent['job_id']);require(p['tag'] in job.tags and job.backend().name==p['backend'],'Wrong job occurrence')
    status=job.status();out={'at':utc(),'job_id':job.job_id(),'status':status}
    if status=='DONE':
        raw=job._api_client.job_results(job_id=job.job_id());(private/'provider-result.txt').write_text(raw)
        result=job.result();require(len(result)==len(qs),'Incomplete result')
        write(private/'raw-result.json',json.loads(json.dumps(result,cls=RuntimeEncoder)))
        rows=[]
        for q,pub,entry in zip(qs,result,job.inputs['pubs']):
            remote=entry[0] if isinstance(entry,(tuple,list)) else entry.circuit
            require(canonical_mcm(q)==canonical_mcm(remote) and pub.metadata['circuit_metadata']==q.metadata,'Source/record binding differs')
            names=[r.name for r in q.cregs if hasattr(pub.data,r.name)]
            records=[getattr(pub.data,name).get_bitstrings() for name in names]
            require(records and all(len(x)==p['shots_each'] for x in records),'Missing/short record')
            rows.append({**q.metadata,'shots':p['shots_each'],'registers':names,
                         'counts':dict(Counter(' '.join(x) for x in zip(*records)))})
        out.update(rows=rows,provider_raw_sha256=sha((private/'provider-result.txt').read_bytes()),
                   raw_sha256=sha((private/'raw-result.json').read_bytes()))
    if status in ('ERROR','CANCELLED'):out['error']=job.error_message()
    if status in ('DONE','ERROR','CANCELLED'):
        out.update(metrics=job.metrics(),free_seconds_after=service.usage()['usage_remaining_seconds'])
        s=read(CAMPAIGN);match=[j for j in s['new_jobs'] if j['tag']==p['tag']]
        require(len(match)==1,'Campaign intent absent');match[0].update(status=status,free_seconds_after=out['free_seconds_after'])
        write(CAMPAIGN,s)
    write(private/'status.json',out);write(art/'status.json',out)
    return {k:v for k,v in out.items() if k!='rows'}
