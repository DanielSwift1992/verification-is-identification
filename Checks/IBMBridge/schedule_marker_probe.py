#!/usr/bin/env python3
"""Minimal labelled-schedule/physical-record correspondence probe on Open.

Two isolated qubits encode each arm's index in actual returned measurements.
The marker is not inferred from circuit_metadata. One fixed submission only.
"""
import argparse
from collections import Counter
import fcntl
import io
import json
from math import pi
from pathlib import Path

from qiskit import QuantumCircuit, ClassicalRegister, qpy, transpile
from qiskit_aer import AerSimulator
from qiskit_ibm_runtime import SamplerV2, RuntimeEncoder
from qiskit_ibm_runtime.circuit import MidCircuitMeasure
from qiskit_ibm_runtime.utils.validations import validate_isa_circuits
from pilot import service_open, sha, utc, versions, require, compact_active
from classical_boundary_probe import aer_form
from resident_joint_confirmation import place, canonical_mcm
from arrival_schedule_binding_audit import source_signature, timing_signature, classify

ROOT=Path(__file__).resolve().parents[2]
ART=ROOT/'Research/Artifacts/schedule-marker-20260916'
PRIVATE=ROOT/'private/ibm-schedule-marker-20260916'
ARMS=('conditional','slots_only','slots_no_reset','echo')
ORDER=(0,1,2,3,3,2,1,0)
PATH=[14,15,34,35,118]
TAG='vi-schedule-marker-20260916-a'
SHOTS=32
CAP=10


def read(p):return json.loads(p.read_text())
def write(p,v):p.write_text(json.dumps(v,indent=2)+'\n')


def circuit(code):
    q=QuantumCircuit(5)
    flag=ClassicalRegister(1,'request');scratch=ClassicalRegister(1,'scratch')
    marker=ClassicalRegister(2,'physical_marker')
    q.add_register(flag,scratch,marker)
    # Work wires P,Q = 0,1. Marker wires 2,3 never interact with them.
    # q4 is measured for the real condition; its preparation is always 0.
    for bit in range(2):
        if (code>>bit)&1:q.x(2+bit)
    q.rz(pi/2,0);q.sx(0);q.rz(pi/2,0);q.barrier()
    q.append(MidCircuitMeasure(),[4],[flag[0]])
    if code==0:
        with q.if_test((flag[0],1)):q.cz(0,1)
    if code in (0,1,2):q.append(MidCircuitMeasure(),[0],[scratch[0]])
    if code in (0,1):q.reset(0)
    if code==3:
        with q.if_test((flag[0],1)):q.x(1)
    q.barrier();q.measure([2,3],marker)
    return q


def options():
    return {'default_shots':SHOTS,'max_execution_time':CAP,
            'environment':{'job_tags':[TAG]},'execution':{'init_qubits':True},
            'twirling':{'enable_gates':False,'enable_measure':False},
            'dynamical_decoupling':{'enable':False},
            'experimental':{'execution':{'scheduler_timing':True}}}


def prepare():
    require(not (PRIVATE/'plan.json').exists(),'Already prepared')
    service=service_open();backend=service.backend('ibm_marrakesh')
    st=backend.status();require(st.operational and st.status_msg=='active','Backend unavailable')
    qs=[]
    for i,code in enumerate(ORDER):
        q=circuit(code);q.metadata={'tag':TAG,'pub_index':i,'arm':ARMS[code],'expected_marker':code}
        q=place(q,PATH,backend.num_qubits);validate_isa_circuits([q],backend.target)
        b=io.BytesIO();qpy.dump(q,b);b.seek(0);loaded,=qpy.load(b)
        require(canonical_mcm(q)==canonical_mcm(loaded),'QPY changed')
        require(classify(**source_signature(loaded))==ARMS[code],'Wrong source signature')
        compact=aer_form(compact_active(loaded));result=AerSimulator(max_parallel_threads=1).run(compact,shots=16,memory=True).result()
        require(result.success,'Ideal marker failed')
        reg=next(r for r in compact.cregs if r.name=='physical_marker')
        for value in result.get_memory():
            bits=int(value.replace(' ',''),2)
            actual=sum(((bits>>compact.find_bit(bit).index)&1)<<j for j,bit in enumerate(reg))
            require(actual==code,'Marker is not physically produced')
        qs.append(q)
    PRIVATE.mkdir(parents=True,exist_ok=True);ART.mkdir(parents=True,exist_ok=True)
    with (PRIVATE/'isa.qpy').open('wb') as f:qpy.dump(qs,f)
    p={'schema':'vi.schedule-marker.v1','tag':TAG,'at':utc(),'backend':backend.name,
       'instance':service.active_instance(),'plan':'open','options':options(),'path':PATH,
       'versions':versions(),'script_sha256':sha(Path(__file__).read_bytes()),
       'qpy_sha256':sha((PRIVATE/'isa.qpy').read_bytes()),'PUBs':[q.metadata for q in qs],
       'shots_each':SHOTS,'total_shots':len(qs)*SHOTS,'cap_seconds':CAP,
       'analysis':'Compare literal submitted opcode signatures and returned schedule features; '
                  'decode isolated physical two-bit marker from all returned shots. '
                  'Marker agreement supports this sample correspondence, not arbitrary future execution. '
                  'No timing or data permutation is repaired from its label.'}
    write(PRIVATE/'plan.json',p);write(ART/'plan.json',{k:v for k,v in p.items() if k!='instance'})
    return {'prepared':True,'PUBs':8,'shots':p['total_shots']}


def load():
    p=read(PRIVATE/'plan.json')
    require(p['options']==options() and p['versions']==versions() and
            p['script_sha256']==sha(Path(__file__).read_bytes()),'Changed executor')
    require(sha((PRIVATE/'isa.qpy').read_bytes())==p['qpy_sha256'],'Changed ISA')
    with (PRIVATE/'isa.qpy').open('rb') as f:qs=qpy.load(f)
    require(len(qs)==8 and [q.metadata for q in qs]==p['PUBs'],'Changed PUBs')
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
        sent={'tag':TAG,'at':utc(),'status':'intent','cap_seconds':CAP,'total_shots':p['total_shots'],
              'free_seconds_before':quota,'qpy_sha256':p['qpy_sha256']}
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
        # Preserve the provider response before SDK conversion as well.
        raw=job._api_client.job_results(job_id=job.job_id())
        (PRIVATE/'provider-result.txt').write_text(raw)
        result=job.result();require(len(result)==len(qs),'Incomplete result')
        write(PRIVATE/'raw-result.json',json.loads(json.dumps(result,cls=RuntimeEncoder)))
        rows=[]
        for q,pub,entry in zip(qs,result,job.inputs['pubs']):
            remote=entry[0] if isinstance(entry,(tuple,list)) else entry.circuit
            require(canonical_mcm(q)==canonical_mcm(remote) and pub.metadata['circuit_metadata']==q.metadata,'Origin mismatch')
            values=pub.data.physical_marker.get_int_counts()
            require(sum(values.values())==SHOTS,'Sample size changed')
            raw_timing=pub.metadata.get('compilation',{}).get('scheduler_timing',{}).get('timing')
            observed=classify(**timing_signature(raw_timing)) if raw_timing else 'missing'
            rows.append({**q.metadata,'shots':SHOTS,'marker_counts':values,
                         'correct_marker_count':values.get(q.metadata['expected_marker'],0),
                         'schedule_arm':observed,'timing_matches_arm':observed==q.metadata['arm']})
        report.update(rows=rows,provider_raw_sha256=sha((PRIVATE/'provider-result.txt').read_bytes()),
                      raw_sha256=sha((PRIVATE/'raw-result.json').read_bytes()))
    if status in ('ERROR','CANCELLED'):report['error']=job.error_message()
    if status in ('DONE','ERROR','CANCELLED'):
        report.update(metrics=job.metrics(),free_seconds_after=service.usage()['usage_remaining_seconds'])
    write(PRIVATE/'status.json',report);write(ART/'status.json',report)
    return report


if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('stage',choices=['prepare','submit','collect'])
    print(json.dumps(globals()[p.parse_args().stage](),indent=2))
