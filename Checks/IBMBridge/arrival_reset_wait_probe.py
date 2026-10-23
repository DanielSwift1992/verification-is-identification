#!/usr/bin/env python3
"""Follow-up intervention: replace each probe reset by its nominal idle time.

This is a new C=0-only control, not a rerun or correction of the first sample.
The returned schedule must establish whether the compared ages really match.
"""

import sys as _evidence_sys
from pathlib import Path as _EvidencePath
_evidence_sys.path.insert(0, str(_EvidencePath(__file__).resolve().parents[1]))
import hardware_runs as _runs
_runs.configure(required=(__name__ == "__main__"))
import argparse
from collections import Counter
import fcntl
import io
import json
from pathlib import Path

from qiskit import qpy
from qiskit_ibm_runtime import RuntimeEncoder, SamplerV2
from qiskit_ibm_runtime.utils.validations import validate_isa_circuits
from pilot import service_open, sha, utc, versions, require
from resident_joint_confirmation import canonical_mcm, place, inventory
from resident_scheduler_pilot import schedule_evidence
import arrival_failure_localization as diag

ROOT=diag.ROOT
ART=ROOT/'Research/Artifacts/arrival-reset-wait-20260916'
PRIVATE=_runs.work('ibm-arrival-reset-wait-20260916')
TAG='vi-arrival-reset-wait-20260916-a'
ARMS=('reset','matched_idle','short_slots')
SHOTS=128
CAP=30
RESET_DT=680


def read(p): return json.loads(p.read_text())
def write(p,v): p.write_text(json.dumps(_runs.bind_receipt(v, destination=p),indent=2)+'\n')


def cores():
    prior=diag.contexts()['conditional']
    # Keep the entire common routed prefix, the real C measurement and its
    # following barrier. Every new slot starts at this established boundary.
    cut=next(i for i,x in enumerate(prior.data) if x.operation.name=='barrier'
             and x.operation.label=='arrival_read')
    slots=[x for x in prior.data[cut+1:] if x.operation.name=='measure_2']
    require(len(slots)==2,'Changed scratch contacts')
    result={}
    for arm in ARMS:
        q=prior.copy_empty_like()
        for x in prior.data[:cut+1]: q.append(x)
        for i,slot in enumerate(slots):
            q.append(slot);q.barrier(label='after_scratch_'+str(i))
            if arm=='reset': q.reset(0)
            elif arm=='matched_idle':q.delay(RESET_DT,0,unit='dt')
            q.barrier(label='after_return_'+str(i))
        q.barrier(label='diagnostic_exit')
        result[arm]=q
    return result


def ideal_core(q):
    out=q.copy_empty_like()
    for ins in q.data:
        if ins.operation.name=='delay':
            require(ins.operation.unit=='dt' and ins.operation.duration==RESET_DT,
                    'Wrong idle duration')
        else:out.append(ins)
    return out


def options():
    return {'default_shots':SHOTS,'max_execution_time':CAP,
            'environment':{'job_tags':[TAG]},'execution':{'init_qubits':True},
            'twirling':{'enable_gates':False,'enable_measure':False},
            'dynamical_decoupling':{'enable':False},
            'experimental':{'execution':{'scheduler_timing':True}}}


def prepare():
    require(not (PRIVATE/'plan.json').exists(),'Already prepared')
    # A current, content-based correspondence is required before extracting
    # any duration from the earlier provider record. Metadata names alone
    # demonstrably failed in that job. Do not weaken this refusal.
    from arrival_schedule_binding_audit import require_current_binding
    require_current_binding()
    previous=read(diag.ART/'status.json');require(previous['status']=='DONE','Missing parent observation')
    # The 680 dt reset duration is read from actual previous server records.
    samples=[]
    for row in previous['rows']:
        if row['arm']!='conditional':continue
        rs=[r for r in row['schedule']['parsed']['rows'] if r['channel']=='Qubit 14'
            and r['instruction']=='reset_14' and r['pulse']=='play']
        require(len(rs)==10,'Unexpected reset pulse groups')
        for start in (0,5):
            block=rs[start:start+5]
            samples.append(max(x['start_dt']+x['duration_dt'] for x in block)-min(x['start_dt'] for x in block))
    require(set(samples)=={RESET_DT},'Nominal reset duration not supported')
    base=read(diag.OLD/'plan.json');path=base['path'];final=base['PUBs'][0]['final_layout']
    bodies=cores();checks={a:diag.core_check(ideal_core(q),final) for a,q in bodies.items()}
    service=service_open();backend=service.backend(base['backend'])
    status=backend.status();require(status.operational and status.status_msg=='active','Backend unavailable')
    cases=[('R',s,b) for s in (0,1) for b in ('ZX','ZY')]
    cases += [('D',0,b) for b in ('XZ','YZ')]+[('Bell',None,b) for b in ('XX','ZZ')]
    qs=[];entries=[]
    for name,spectator,basis in cases:
        for arm in ARMS:
            q=diag.witness(bodies[arm],final,name,spectator,basis)
            entry={'tag':TAG,'arm':arm,'input_at_arrival':name,'spectator':spectator,
                   'basis':basis,'prepared_arrival':0,'path':path,'final_layout':final,
                   'ideal':diag.ideal(name,spectator,basis)}
            q.metadata=entry;q=place(q,path,backend.num_qubits)
            validate_isa_circuits([q],backend.target)
            b=io.BytesIO();qpy.dump(q,b);b.seek(0);restored,=qpy.load(b)
            require(canonical_mcm(q)==canonical_mcm(restored),'Serialization changed circuit or dt')
            diag.exact_serialized(restored,entry['ideal'])
            qs.append(q);entries.append(entry)
    require(len(qs)==24,'Changed budget')
    PRIVATE.mkdir(parents=True,exist_ok=True);ART.mkdir(parents=True,exist_ok=True)
    with (PRIVATE/'isa.qpy').open('wb') as f:qpy.dump(qs,f)
    p={'schema':'vi.arrival-reset-wait.v1','tag':TAG,'at':utc(),'backend':backend.name,
       'instance':service.active_instance(),'plan':'open','options':options(),'dt':backend.dt,
       'versions':versions(),'script_sha256':sha(_runs.owned(__file__).read_bytes()),
       'helper_sha256':sha(_runs.owned(diag.__file__).read_bytes()),
       'prior_raw_sha256':previous['raw_sha256'],'nominal_reset_dt':RESET_DT,
       'qpy_sha256':sha((PRIVATE/'isa.qpy').read_bytes()),'PUBs':entries,'operator_checks':checks,
       'shots_each':SHOTS,'total_shots':len(qs)*SHOTS,'cap_seconds':CAP,
       'inventory':{a:inventory(q) for a,q in bodies.items()},
       'analysis':'All shots, same prepared C=0 boundary. Reset versus equal nominal idle versus short slots. '
                  'First compare actual returned schedules. If ages differ, do not infer reset-specific noise. '
                  'No local correction, Pauli fit or postselection. These are different programs from the '
                  'previous guard-bearing conditional, not a proof of fixing that full controller.'}
    write(PRIVATE/'plan.json',p);write(ART/'plan.json',{k:v for k,v in p.items() if k!='instance'})
    return {'prepared':True,'PUBs':24,'shots':p['total_shots'],'reset_dt':RESET_DT}


def load():
    p=read(PRIVATE/'plan.json')
    require(p['options']==options() and p['versions']==versions()
            and p['script_sha256']==sha(_runs.owned(__file__).read_bytes())
            and p['helper_sha256']==sha(_runs.owned(diag.__file__).read_bytes()),'Changed executor')
    require(sha((PRIVATE/'isa.qpy').read_bytes())==p['qpy_sha256'],'Changed ISA')
    with (PRIVATE/'isa.qpy').open('rb') as f:qs=qpy.load(f)
    require(len(qs)==24 and [q.metadata for q in qs]==p['PUBs'],'Changed PUB correspondence')
    return p,qs


def submit():
    p,qs=load();service=service_open();require(service.active_instance()==p['instance'],'Different instance')
    with (PRIVATE/'submit.lock').open('a') as lock:
        fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
        require(not (PRIVATE/'submission.json').exists(),'Intent exists; never resubmit')
        quota=service.usage()['usage_remaining_seconds'];require(quota>=CAP,'No free quota')
        backend=service.backend(p['backend']);st=backend.status()
        require(st.operational and st.status_msg=='active','Backend unavailable')
        validate_isa_circuits(qs,backend.target)
        sent={'tag':TAG,'at':utc(),'status':'intent','qpy_sha256':p['qpy_sha256'],
              'total_shots':p['total_shots'],'cap_seconds':CAP,'free_seconds_before':quota}
        write(PRIVATE/'submission.json',sent)
        job=SamplerV2(mode=backend,options=p['options']).run(qs,shots=SHOTS)
        sent.update(job_id=job.job_id(),status='submitted')
        write(PRIVATE/'submission.json',sent);write(ART/'submission.json',sent)
        return sent


def collect():
    p,qs=load();sent=read(PRIVATE/'submission.json');require(sent.get('job_id'),'Uncertain intent')
    service=service_open();require(service.active_instance()==p['instance'],'Different instance')
    job=service.job(sent['job_id']);require(TAG in job.tags and job.backend().name==p['backend'],'Wrong job')
    status=job.status();report={'at':utc(),'job_id':job.job_id(),'status':status}
    if status=='DONE':
        result=job.result();require(len(result)==len(qs),'Incomplete result')
        write(PRIVATE/'raw-result.json',json.loads(json.dumps(result,cls=RuntimeEncoder)))
        rows=[]
        for q,pub,entry in zip(qs,result,job.inputs['pubs']):
            remote=entry[0] if isinstance(entry,(tuple,list)) else entry.circuit
            require(canonical_mcm(remote)==canonical_mcm(q) and pub.metadata['circuit_metadata']==q.metadata,'Origin mismatch')
            w=pub.data.witness.get_bitstrings();c=pub.data.actual_arrival.get_bitstrings();r=pub.data.actual_replies.get_bitstrings()
            require(len(w)==len(c)==len(r)==SHOTS,'Sample size changed')
            ints=[int(x,2) for x in w]
            def mean(indices):return sum((-1)**sum((x>>i)&1 for i in indices) for x in ints)/SHOTS
            rows.append({**q.metadata,'shots':SHOTS,'counts':dict(Counter(' '.join(x) for x in zip(c,r,w))),
                         'means':{n:mean(i) for n,i in {'B':[0],'D':[1],'R':[2],'DR':[1,2]}.items()},
                         'arrival_zero':sum(x=='0' for x in c),'schedule':schedule_evidence(pub.metadata,p['dt'])})
        report.update(rows=rows,raw_sha256=sha((PRIVATE/'raw-result.json').read_bytes()))
    if status in ('ERROR','CANCELLED'):report['error']=job.error_message()
    if status in ('DONE','ERROR','CANCELLED'):
        report.update(metrics=job.metrics(),free_seconds_after=service.usage()['usage_remaining_seconds'])
    write(PRIVATE/'status.json',report);write(ART/'status.json',report)
    return {k:v for k,v in report.items() if k!='rows'}


if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('stage',choices=['prepare','submit','collect'])
    print(json.dumps(_runs.bind_receipt(globals()[p.parse_args().stage]()),indent=2))
