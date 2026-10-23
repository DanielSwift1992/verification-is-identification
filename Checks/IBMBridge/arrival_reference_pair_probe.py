#!/usr/bin/env python3
"""Attempt 1: an identity on R, tested on the original failed continuation.

No assertion of equal elapsed times or a microscopic noise mechanism.
The immutable parent instrument remains the ideal semantic reference.
"""

import sys as _evidence_sys
from pathlib import Path as _EvidencePath
_evidence_sys.path.insert(0, str(_EvidencePath(__file__).resolve().parents[1]))
import hardware_runs as _runs
_runs.configure(required=(__name__ == "__main__"))
import argparse
from collections import Counter
import csv
import fcntl
import io
import json
from pathlib import Path

from qiskit import qpy, QuantumRegister, ClassicalRegister
from qiskit_ibm_runtime import SamplerV2, RuntimeEncoder
from qiskit_ibm_runtime.utils.validations import validate_isa_circuits
from pilot import service_open, sha, utc, versions, require
from resident_joint_confirmation import place, canonical_mcm
from resident_scheduler_pilot import schedule_evidence
from arrival_schedule_binding_audit import source_signature, timing_signature
import arrival_failure_localization as diag
import arrival_boundary_probe as old

ROOT=diag.ROOT
ART=ROOT/'Research/Artifacts/xx-three-attempts-20260916/attempt-1'
PRIVATE=_runs.work('ibm-xx-reference-pair-20260916')
STATE=ROOT/'Research/Artifacts/xx-three-attempts-20260916/state.json'
TAG='vi-xx-three-attempts-1-20260916'
ARMS=('original','reference_pair')
SHOTS=128
CAP=30
MARKER_SITE=140


def read(p):return json.loads(p.read_text())
def write(p,v):p.write_text(json.dumps(_runs.bind_receipt(v, destination=p),indent=2)+'\n')


@_runs.include_reader
def dependencies():
    files=[_runs.owned(__file__),_runs.owned(diag.__file__),_runs.owned(old.__file__),
           ROOT/'Checks/IBMBridge/pilot.py',ROOT/'Checks/IBMBridge/resident_joint_confirmation.py',
           ROOT/'Checks/IBMBridge/classical_boundary_probe.py',
           ROOT/'Checks/IBMBridge/arrival_schedule_binding_audit.py']
    return {_runs.address(p, ROOT):sha(p.read_bytes()) for p in files}


def cores():
    original=diag.contexts()['conditional']
    final=read(diag.OLD/'plan.json')['PUBs'][0]['final_layout']
    r=final[4]
    # The reference is not touched at ANY point of the service. This is
    # checked from contents, not from the qubit's name.
    for item in original.data:
        if item.operation.name!='barrier':
            require(r not in [original.find_bit(b).index for b in item.qubits],
                    'Reference participates in parent service')
    altered=original.copy_empty_like();resets=0
    for item in original.data:
        altered.append(item)
        if item.operation.name=='reset':
            resets+=1
            if resets==1:
                altered.barrier(label='reference_pair_first');altered.x(r)
                altered.barrier(label='reference_pair_first_done')
    require(resets==2,'Different parent slot structure')
    altered.x(r);altered.barrier(label='reference_pair_done')
    return {'original':original,'reference_pair':altered},final


def tagged(q,code):
    out=q.copy_empty_like();out.add_register(QuantumRegister(1,'marker_q'))
    marker=ClassicalRegister(1,'physical_variant');out.add_register(marker)
    if code:out.x(6)
    out.barrier(label='marker_prepared_before_input')
    out.compose(q,qubits=list(range(6)),clbits=list(range(q.num_clbits)),inplace=True)
    out.measure(6,marker[0])
    return out


def options():
    return {'default_shots':SHOTS,'max_execution_time':CAP,
            'environment':{'job_tags':[TAG]},'execution':{'init_qubits':True},
            'twirling':{'enable_gates':False,'enable_measure':False},
            'dynamical_decoupling':{'enable':False},
            'experimental':{'execution':{'scheduler_timing':True}}}


def source_reference_x(q):
    return sum(x.operation.name=='x' and [q.find_bit(b).index for b in x.qubits]==[34]
               for x in q.data)


def schedule_check(q,metadata):
    raw=metadata.get('compilation',{}).get('scheduler_timing',{}).get('timing')
    if not raw:return {'available':False,'admitted':False}
    rows=[next(csv.reader([line])) for line in raw.splitlines() if line.strip()]
    require(all(len(x)==6 for x in rows),'Malformed schedule')
    # X has one drive play per invocation; INIT/FINI excluded by name.
    pulses=[x for x in rows if x[0]=='main' and x[1]=='x_34'
            and x[2]=='Qubit 34' and x[5]=='play']
    wanted=source_reference_x(q)
    return {'available':True,'source_reference_x':wanted,
            'returned_reference_x_drive_plays':len(pulses),
            'family_structure_matches':source_signature(q)==timing_signature(raw),
            'admitted':wanted==len(pulses) and source_signature(q)==timing_signature(raw),
            'scope':'Necessary signature check only; not a full pulse/source equivalence proof.'}


def prepare():
    require(not (PRIVATE/'plan.json').exists(),'Already prepared')
    bodies,final=cores()
    # Full 32-dimensional instrument, BOTH values of the actual request.
    checks={a:old.operator_check(q,final,'conditional') for a,q in bodies.items()}
    base=read(diag.OLD/'plan.json');path=base['path']+[MARKER_SITE]
    require(len(set(path))==7,'Marker overlaps the actual carrier')
    service=service_open();backend=service.backend(base['backend']);st=backend.status()
    require(st.operational and st.status_msg=='active','Backend unavailable')
    cases=[('original_Bell',None,b) for b in ('XX','ZZ')]
    cases += [('R',s,b) for s in (0,1) for b in ('ZX','ZY')]
    qs=[];checks_witness=[]
    for case_index,(kind,spectator,basis) in enumerate(cases):
        # Reverse within alternate pairs to reduce a simple order confound.
        for code in ((0,1) if case_index%2==0 else (1,0)):
            arm=ARMS[code]
            if kind=='original_Bell':
                q=old.witness(bodies[arm],final,0,basis,0)
                expected={'B':1.,'D':0.,'R':0.,'DR':1.}
            else:
                q=diag.witness(bodies[arm],final,kind,spectator,basis)
                expected=diag.ideal(kind,spectator,basis)
            q=tagged(q,code)
            q.metadata={'tag':TAG,'pub_index':len(qs),'arm':arm,'marker':code,
                        'input':kind,'spectator':spectator,'basis':basis,
                        'prepared_request':0,'expected':expected}
            q=place(q,path,backend.num_qubits);validate_isa_circuits([q],backend.target)
            b=io.BytesIO();qpy.dump(q,b);b.seek(0);restored,=qpy.load(b)
            require(canonical_mcm(q)==canonical_mcm(restored),'QPY changed the instrument')
            checks_witness.append(diag.exact_serialized(restored,expected))
            require(source_reference_x(restored)==2*code,'Reference intervention changed')
            qs.append(q)
    require(len(qs)==12 and len(qs)*SHOTS<=4096,'Budget exceeded')
    PRIVATE.mkdir(parents=True,exist_ok=True);ART.mkdir(parents=True,exist_ok=True)
    with (PRIVATE/'isa.qpy').open('wb') as f:qpy.dump(qs,f)
    p={'schema':'vi.xx-reference-pair.v1','at':utc(),'tag':TAG,'backend':backend.name,
       'instance':service.active_instance(),'plan':'open','options':options(),'versions':versions(),
       'dependencies':dependencies(),'dt':backend.dt,'path':path,'final_layout':final,
       'qpy_sha256':sha((PRIVATE/'isa.qpy').read_bytes()),'PUBs':[q.metadata for q in qs],
       'operator_checks':checks,'serialized_witness_checks':checks_witness,
       'shots_each':SHOTS,'total_shots':len(qs)*SHOTS,'cap_seconds':CAP,
       'analysis':'All shots retained, no postselection or fitted correction. Primary contrast: original '
                  'Bell XX and ZZ, original versus reference X pair. Product R readings distinguish '
                  'phase rotation and attenuation descriptively. Physical marker tests variant binding. '
                  'Only if both marker error fractions <=0.1 may an arm contrast be interpreted. '
                  'Report binomial sampling intervals conditionally on independent shots, not as '
                  'protection from drift. No equal-time or microscopic mechanism claim. '
                  'No reliance on old contradictory schedules.'}
    write(PRIVATE/'plan.json',p);write(ART/'plan.json',{k:v for k,v in p.items() if k!='instance'})
    return {'prepared':True,'PUBs':12,'shots':p['total_shots'],'operator_checks':checks}


def load():
    p=read(PRIVATE/'plan.json')
    require(p['dependencies']==dependencies() and p['versions']==versions()
            and p['options']==options(),'Frozen execution dependencies changed')
    require(sha((PRIVATE/'isa.qpy').read_bytes())==p['qpy_sha256'],'QPY changed')
    with (PRIVATE/'isa.qpy').open('rb') as f:qs=qpy.load(f)
    require(len(qs)==12 and [q.metadata for q in qs]==p['PUBs'],'PUBs changed')
    return p,qs


def submit():
    p,qs=load();state=read(STATE)
    require(state['current_attempt']==1 and state['status']=='active','Wrong campaign state')
    require(len(state['new_jobs'])<state['new_job_limit'],'Campaign budget exhausted')
    service=service_open();require(service.active_instance()==p['instance'],'Instance changed')
    with (PRIVATE/'submit.lock').open('a') as lock:
        fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
        require(not (PRIVATE/'submission.json').exists(),'Intent exists; never resubmit')
        quota=service.usage()['usage_remaining_seconds'];require(quota>=CAP,'No free quota')
        backend=service.backend(p['backend']);st=backend.status()
        require(st.operational and st.status_msg=='active','Backend unavailable')
        validate_isa_circuits(qs,backend.target)
        sent={'tag':TAG,'at':utc(),'status':'intent','total_shots':p['total_shots'],
              'cap_seconds':CAP,'free_seconds_before':quota,'qpy_sha256':p['qpy_sha256']}
        write(PRIVATE/'submission.json',sent);write(ART/'submission.json',sent)
        state['new_jobs'].append({'attempt':1,'tag':TAG,'status':'intent'})
        state['current_stage']='submitting';write(STATE,state)
        job=SamplerV2(mode=backend,options=p['options']).run(qs,shots=SHOTS)
        sent.update(job_id=job.job_id(),status='submitted')
        write(PRIVATE/'submission.json',sent);write(ART/'submission.json',sent)
        state['new_jobs'][-1].update(job_id=job.job_id(),status='submitted')
        state['current_stage']='waiting_for_job';write(STATE,state)
        return sent


def collect():
    p,qs=load();sent=read(PRIVATE/'submission.json');require(sent.get('job_id'),'Uncertain intent')
    service=service_open();require(service.active_instance()==p['instance'],'Different instance')
    job=service.job(sent['job_id']);require(TAG in job.tags and job.backend().name==p['backend'],'Wrong job')
    status=job.status();report={'at':utc(),'job_id':job.job_id(),'status':status}
    if status=='DONE':
        raw=job._api_client.job_results(job_id=job.job_id());(PRIVATE/'provider-result.txt').write_text(raw)
        result=job.result();require(len(result)==len(qs),'Incomplete result')
        write(PRIVATE/'raw-result.json',json.loads(json.dumps(result,cls=RuntimeEncoder)))
        rows=[]
        for q,pub,entry in zip(qs,result,job.inputs['pubs']):
            remote=entry[0] if isinstance(entry,(tuple,list)) else entry.circuit
            require(canonical_mcm(q)==canonical_mcm(remote) and pub.metadata['circuit_metadata']==q.metadata,
                    'Returned origin mismatch')
            records=[getattr(pub.data,k).get_bitstrings() for k in
                     ('actual_arrival','actual_replies','witness','physical_variant')]
            require(all(len(x)==SHOTS for x in records),'Sample size changed')
            c,r,w,m=records;values=[int(x,2) for x in w]
            def mean(indices):return sum((-1)**sum((x>>i)&1 for i in indices) for x in values)/SHOTS
            rows.append({**q.metadata,'shots':SHOTS,'counts':dict(Counter(' '.join(x) for x in zip(*records))),
                         'means':{k:mean(v) for k,v in {'B':[0],'D':[1],'R':[2],'DR':[1,2]}.items()},
                         'marker_correct':sum(int(x,2)==q.metadata['marker'] for x in m),
                         'request_zero':sum(x=='0' for x in c),
                         'schedule_check':schedule_check(q,pub.metadata),
                         'schedule':schedule_evidence(pub.metadata,p['dt'])})
        report.update(rows=rows,provider_raw_sha256=sha((PRIVATE/'provider-result.txt').read_bytes()),
                      raw_sha256=sha((PRIVATE/'raw-result.json').read_bytes()))
    if status in ('ERROR','CANCELLED'):report['error']=job.error_message()
    if status in ('DONE','ERROR','CANCELLED'):
        report.update(metrics=job.metrics(),free_seconds_after=service.usage()['usage_remaining_seconds'])
    write(PRIVATE/'status.json',report);write(ART/'status.json',report)
    return {k:v for k,v in report.items() if k!='rows'}


if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('stage',choices=['prepare','submit','collect'])
    print(json.dumps(_runs.bind_receipt(globals()[p.parse_args().stage]()),indent=2))
