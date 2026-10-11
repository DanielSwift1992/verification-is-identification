#!/usr/bin/env python3
"""One fixed 9 x 1024 dynamic experiment on explicitly verified IBM Open.

No paid instances, adaptive repeats or automatic resubmission after a lost reply.
Analysis criteria are fixed before submission. A returned Bell score is an
observed statistic; its interpretation as fidelity requires common preparation
and calibrated Pauli readout, beyond a successful compiler check.
"""
import argparse
from collections import Counter
from copy import deepcopy
import fcntl
import io
import json
import math
from pathlib import Path
import uuid

from dynamic import POLICIES, BASES, simulate, exact_channels
from dynamic_prepare import prepare_family, validate_family, signature
from pilot import ROOT, BRIDGE, prepare, service_open, compact_active, sha, utc, versions
from runtime import require, load_json, write_json

SHOTS = 1024
MAX_SECONDS = 60
ORDER = (0,4,8,3,7,2,6,1,5)
F_RADIUS = 0.09075  # Outward-rounded simultaneous 99% bound for nine correlations.


def implementation():
    files=[Path(__file__),*(Path(__file__).with_name(n) for n in
            ('dynamic.py','dynamic_prepare.py','pilot.py')),
           *(BRIDGE/n for n in ('execute.py','runtime.py','prepare.py'))]
    return {str(f.relative_to(ROOT)):sha(f.read_bytes()) for f in files}


def named_mid_measure(circuits, manifest, backend):
    from qiskit_ibm_runtime.circuit import MidCircuitMeasure
    require('measure_2' in backend.operation_names, 'named mid-circuit readout unavailable')
    manifest=deepcopy(manifest)
    converted=[]
    for circuit in circuits:
        circuit=circuit.copy(); replaced=0
        for j,ins in enumerate(circuit.data):
            if ins.operation.name=='measure' and circuit.find_bit(ins.clbits[0]).index<2:
                wire=circuit.find_bit(ins.qubits[0]).index
                require(backend.target.instruction_supported(operation_name='measure_2',qargs=(wire,)),
                        'mid readout unavailable at bound resident/record wire')
                circuit.data[j]=ins.replace(operation=MidCircuitMeasure())
                replaced+=1
        require(replaced==2,'incorrect mid-readout conversion count')
        converted.append(circuit)
    for i,spec in enumerate(manifest):
        prefix=signature(converted[3*i])['instructions'][:spec['prefix_instruction_count']]
        spec['prefix_instructions_sha256']=sha(json.dumps(prefix,sort_keys=True).encode())
        spec['mid_measurement_instruction']='measure_2'
    validate_family(converted,manifest)
    return converted,manifest


def ideal_circuit(circuit):
    from qiskit.circuit import Measure
    local=compact_active(circuit)
    # SDK measure_2 is a named hardware implementation of a one-qubit Z
    # measurement. Aer uses its ideal Measure; no hardware error is modeled.
    for j,ins in enumerate(local.data):
        if ins.operation.name=='measure_2':
            local.data[j]=ins.replace(operation=Measure())
    return local


def analyse(rows):
    require(len(rows)==9,'incomplete fixed analysis family')
    by_key={(r['policy'],r['basis']):r for r in rows}
    require(set(by_key)=={(p,b) for p in POLICIES for b in BASES},'duplicate or foreign question')
    scores={}
    for policy in POLICIES:
        correlations={}
        for basis in BASES:
            row=by_key[policy,basis]
            require(row['shots']==SHOTS,'analysis shot budget changed')
            counts=row['out_counts']
            require(isinstance(counts,dict) and all(type(b) is str and len(b)==2 and set(b)<={'0','1'}
                    and type(n) is int and n>=0 for b,n in counts.items()) and sum(counts.values())==SHOTS,
                    'invalid terminal counts')
            correlations[basis]=sum((1 if b[0]==b[1] else -1)*n for b,n in counts.items())/SHOTS
        score=(1+correlations['XX']-correlations['YY']+correlations['ZZ'])/4
        scores[policy]={'correlations':correlations,'bell_score':score,
                        'conditional_99pct_interval':[score-F_RADIUS,score+F_RADIUS]}
    delta=scores['acquired']['bell_score']-scores['ignore_reply']['bell_score']
    return {'policies':scores,'acquired_minus_ignore_reply':delta,
            'conditional_99pct_delta_interval':[delta-2*F_RADIUS,delta+2*F_RADIUS],
            'criteria':{'acquired_lower_bound_above_half':scores['acquired']['bell_score']-F_RADIUS>0.5,
                        'improvement_lower_bound_above_zero':delta-2*F_RADIUS>0},
            'confidence_scope':'Simultaneous 99% Hoeffding region, conditional on independent shots with a fixed law within each circuit. Does not cover drift or analyzer bias.',
            'fidelity_scope':'Bell score becomes state fidelity only for a common prepared state with the stipulated Pauli observables. No device-independent or arbitrary-input accuracy claim.'}


def decode_result(result, circuits):
    require(len(result)==9 and len(circuits)==9,'wrong returned circuit count')
    rows=[]
    for pub,circuit in zip(result,circuits):
        require(pub.metadata.get('circuit_metadata')==circuit.metadata,'result belongs to another circuit occurrence')
        require(set(pub.data.keys())=={'out','record'},'missing or extra result register')
        out,record=pub.data.out,pub.data.record
        require(out.num_bits==record.num_bits==2 and out.num_shots==record.num_shots==SHOTS
                and out.shape==record.shape==(),'wrong two-register result shape')
        joint=Counter(r+':'+o for r,o in zip(record.get_bitstrings(),out.get_bitstrings()))
        counts=dict(out.get_counts())
        marginal=Counter()
        for key,n in joint.items():marginal[key.split(':')[1]]+=n
        require(dict(marginal)==counts and sum(joint.values())==SHOTS,'joint/marginal records differ')
        rows.append({'policy':circuit.metadata['policy'],'basis':circuit.metadata['basis'],
                     'shots':SHOTS,'out_counts':counts,'record_counts':dict(record.get_counts()),
                     'record_then_out_counts':dict(joint)})
    return rows


def make_plan(directory):
    from qiskit import qpy
    from qiskit_ibm_runtime.utils.validations import validate_isa_circuits
    require(not directory.exists(),'output already exists')
    current=implementation()
    docs,receipt=prepare(ROOT/'private/ibm-prepared')
    exact_channels(docs)
    archive=ROOT/'private/ibm-dynamic-common-prefix-20260914'
    old=load_json(archive/'result.json')
    service=service_open();usage=service.usage()
    require(usage['usage_remaining_seconds']>=MAX_SECONDS,'insufficient free quota')
    backend=service.backend(old['backend'])
    require(backend.status().operational,'backend unavailable')
    circuits,manifest=prepare_family(docs,backend,old['manifest'][0]['initial_layout'])
    circuits,manifest=named_mid_measure(circuits,manifest,backend)
    tag='vi-state-'+uuid.uuid4().hex
    for c in circuits:
        c.metadata={'experiment':tag,'request':'AcquireState','policy':c.metadata['policy'],
                    'basis':c.metadata['basis'],'checked_root':receipt['key']}
    validate_family(circuits,manifest)
    validate_isa_circuits(circuits,backend.target)
    local=simulate([ideal_circuit(c) for c in circuits],SHOTS)
    for row in local:
        if row['policy']=='acquired':
            require(row['correlation']==(-1 if row['basis']=='YY' else 1),'local acquired continuation failed')
        elif row['policy']=='invert_reply':
            require(row['correlation']==-1,'local negative control changed')
    require(implementation()==current,'implementation changed during preparation')
    directory.mkdir(parents=True)
    buf=io.BytesIO();qpy.dump(circuits,buf)
    (directory/'isa.qpy').write_bytes(buf.getvalue())
    # The submission program and all included implementation files remain reviewable.
    for name in current:
        target=directory/'source'/name;target.parent.mkdir(parents=True,exist_ok=True)
        target.write_bytes((ROOT/name).read_bytes())
    plan={'schema':'vi.ibm.dynamic-plan.v1','created_at':utc(),'tag':tag,
          'backend':backend.name,'instance':service.active_instance(),'instance_plan':'open',
          'shots':SHOTS,'max_seconds':MAX_SECONDS,'order':list(ORDER),'manifest':manifest,
          'qpy_sha256':sha(buf.getvalue()),'checked_build':receipt,'versions':versions(),
          'implementation':current,'usage_before':usage,'backend_status':backend.status().to_dict(),
          'mid_readout':'measure_2','options':{'max_execution_time':MAX_SECONDS,'default_shots':SHOTS,
            'environment':{'job_tags':[tag]},'twirling':{'enable_gates':False,'enable_measure':False},
            'dynamical_decoupling':{'enable':False},'execution':{'init_qubits':True}},
          'criteria':{'alpha':0.01,'f_radius':F_RADIUS,'primary':['acquired lower > 0.5','acquired-minus-ignore lower > 0'],
                      'fixed_family':'3 policies x 3 bases; all outcomes retained; no repeat-until-pass'},
          'assumptions':'Intervals require independent fixed-law shots within each circuit. Fidelity requires common preparation and stipulated Pauli readout; identical prefixes do not establish hardware stationarity.'}
    write_json(directory/'plan.json',plan)
    write_json(directory/'local-validation.json',{'scope':'IDEAL LOCAL ONLY; measure_2 mapped to ideal Measure',
                                                 'rows':local,'analysis':analyse(local)})
    # Calibration metadata includes datetime values, unlike the finite VI exports.
    write_json(directory/'calibration-at-preparation.json',
               json.loads(json.dumps(backend.properties().to_dict(),default=str)))
    print(json.dumps({'prepared':True,'backend':backend.name,'shots':9*SHOTS,'max_free_seconds':MAX_SECONDS,
                      'physical_pair':manifest[0]['physical_payload_reference'],'tag':tag},indent=2))


def read_plan(directory,current=False):
    from qiskit import qpy
    plan=load_json(directory/'plan.json')
    require(plan['schema']=='vi.ibm.dynamic-plan.v1' and plan['shots']==SHOTS
            and plan['max_seconds']==MAX_SECONDS and plan['order']==list(ORDER)
            and plan['criteria']['f_radius']==F_RADIUS and plan['instance_plan']=='open', 'plan scope changed')
    raw=(directory/'isa.qpy').read_bytes()
    require(sha(raw)==plan['qpy_sha256'],'ISA payload changed')
    circuits=qpy.load(io.BytesIO(raw));validate_family(circuits,plan['manifest'])
    for c in circuits:
        require(c.metadata['experiment']==plan['tag'] and c.metadata['checked_root']==plan['checked_build']['key'],
                'source occurrence mismatch')
    if current:
        require(plan['implementation']==implementation() and plan['versions']==versions(),'implementation/runtime changed')
        _,receipt=prepare(ROOT/'private/ibm-prepared')
        require(receipt['key']==plan['checked_build']['key'],'current checked VI root changed')
    return plan,circuits


def send_once(directory,service,plan,circuits,sampler_factory=None):
    from qiskit_ibm_runtime import SamplerV2
    with (directory/'submit.lock').open('a') as lock:
        fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
        path=directory/'ledger.json'
        if path.exists():
            ledger=load_json(path)
            require(ledger['tag']==plan['tag'] and ledger['qpy_sha256']==plan['qpy_sha256'],'ledger mismatch')
            if ledger.get('job_id'):return ledger
            jobs=service.jobs(limit=2,job_tags=[plan['tag']])
            require(len(jobs)==1,'uncertain submission; reconcile existing jobs, do not resubmit')
            ledger.update(job_id=jobs[0].job_id(),status='recovered',at=utc())
            write_json(path,ledger);return ledger
        require(service.active_instance()==plan['instance'],'wrong instance')
        require(service.usage()['usage_remaining_seconds']>=MAX_SECONDS,'insufficient free quota')
        backend=service.backend(plan['backend']);status=backend.status()
        require(status.operational and status.status_msg=='active','backend not active')
        sampler=(sampler_factory or SamplerV2)(mode=backend,options=plan['options'])
        ledger={'tag':plan['tag'],'qpy_sha256':plan['qpy_sha256'],'status':'submission_intent','at':utc(),
                'backend':plan['backend'],'instance':plan['instance']}
        write_json(path,ledger)
        job=sampler.run([circuits[i] for i in ORDER],shots=SHOTS)
        ledger.update(job_id=job.job_id(),status='submitted')
        write_json(path,ledger);return ledger


def collect(directory):
    from qiskit_ibm_runtime import RuntimeEncoder
    plan,canonical=read_plan(directory)
    circuits=[canonical[i] for i in ORDER]
    ledger=load_json(directory/'ledger.json')
    require(ledger['tag']==plan['tag'] and ledger['qpy_sha256']==plan['qpy_sha256'],'collection ledger mismatch')
    service=service_open()
    require(service.active_instance()==plan['instance'],'collection instance mismatch')
    job=service.job(ledger['job_id'])
    require(job.job_id()==ledger['job_id'] and plan['tag'] in job.tags
            and job.backend().name==plan['backend'],'remote occurrence mismatch')
    status=job.status()
    status_record={'job_id':job.job_id(),'status':status,'checked_at':utc(),'backend':plan['backend']}
    if status in ('ERROR','CANCELLED'):status_record['error']=job.error_message()
    write_json(directory/'status.json',status_record)
    if status!='DONE':print(json.dumps(status_record,indent=2));return status_record
    pubs=job.inputs['pubs']
    require(len(pubs)==9,'remote program count mismatch')
    for pub,circuit in zip(pubs,circuits):
        remote=pub[0] if isinstance(pub,(list,tuple)) else pub.circuit
        shots=pub[2] if isinstance(pub,(list,tuple)) else pub.shots
        require(signature(remote)==signature(circuit) and remote.metadata==circuit.metadata
                and shots==SHOTS,'remote source/conditional program/shots changed')
    result=job.result()
    raw=json.dumps(result,cls=RuntimeEncoder,indent=2)
    (directory/'raw-result.json').write_text(raw)
    rows=decode_result(result,circuits)
    report={'schema':'vi.ibm.dynamic-result.v1',**status_record,'scope':'PHYSICAL QPU DATA',
            'raw_result_sha256':sha(raw.encode()),'rows':rows,'analysis':analyse(rows),
            'metrics':job.metrics(),'usage_after':service.usage(),'collector_implementation':implementation()}
    write_json(directory/'hardware-result.json',report)
    print(json.dumps({'status':'DONE','job_id':job.job_id(),'analysis':report['analysis'],
                      'metrics':report['metrics'],'usage_after':report['usage_after']},indent=2,default=str))
    return report


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('stage',choices=('prepare','submit','collect'))
    p.add_argument('--output',type=Path,required=True)
    a=p.parse_args();directory=a.output.resolve()
    if a.stage=='prepare':make_plan(directory)
    elif a.stage=='submit':
        plan,circuits=read_plan(directory,current=True)
        print(json.dumps(send_once(directory,service_open(),plan,circuits),indent=2))
    else:collect(directory)


if __name__=='__main__':main()
