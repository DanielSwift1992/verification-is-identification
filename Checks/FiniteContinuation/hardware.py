#!/usr/bin/env python3
"""Bounded IBM Open demonstration of data-selected acquisitions.

One fixed T/X task, all 16 deliberately configured Pauli pairs, opaque episode
IDs. Only receipts enter Evidence. Actual configured gates belong to a separate
fixture used to build contacts and later audit success. No paid instances.
"""
import argparse
from collections import Counter
from fractions import Fraction as F
import io
import json
from pathlib import Path
import sys
import uuid

from model import PAULI_WORDS, WORLDS, problem
from noisy import Evidence

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
sys.path.insert(0,str(ROOT/'Checks/IBMBridge'))
from pilot import service_open, compact_active, sha, utc, versions, signature
from runtime import require, load_json, write_json

MAX_ROUNDS=4
BATCH_SHOTS=16
VALIDATION_SHOTS=256
MAX_JOB_SECONDS=20
MAX_JOBS=MAX_ROUNDS+1
WIRE=45


def implementation():
    paths=[HERE/n for n in ('model.py','planner.py','noisy.py','hardware.py')]
    paths += [ROOT/'Checks/IBMBridge/pilot.py',ROOT/'Checks/BraketBridge/runtime.py']
    return {str(p.relative_to(ROOT)):sha(p.read_bytes()) for p in paths}


def init(directory):
    require(not directory.exists(),'Campaign directory already exists')
    service=service_open(); usage=service.usage()
    require(usage['usage_remaining_seconds']>=MAX_JOBS*MAX_JOB_SECONDS,'Insufficient free quota')
    backend=service.backend('ibm_kingston')
    require(backend.status().operational,'Backend unavailable')
    directory.mkdir(parents=True)
    tag='vi-acquire-'+uuid.uuid4().hex
    cases=[{'episode':uuid.uuid4().hex,'fixture':list(world)} for world in WORLDS]
    spec={'schema':'vi.finite-hardware.v1','created_at':utc(),'tag':tag,
          'backend':backend.name,'wire':WIRE,'instance':service.active_instance(),
          'instance_plan':'open','pricing_type':'free','cases':cases,
          'request':{'connector':['t'],'consumer':'terminal','axis':'X'},
          'family_alpha':'1/100','per_episode_alpha':str(F(1,100)/16),
          'assumed_conditional_probe_error_upper_bound':'1/5',
          'noise_bound_status':'Declared exploratory assumption; NOT established by this experiment or IBM calibration metadata',
          'batch_shots':BATCH_SHOTS,'validation_shots':VALIDATION_SHOTS,
          'max_acquisition_rounds':MAX_ROUNDS,'max_jobs':MAX_JOBS,
          'max_job_seconds':MAX_JOB_SECONDS,'usage_before':usage,
          'implementation':implementation(),'versions':versions(),
          'validation_criterion':'Every acquired action agrees with the fixture ideal relation; every plus/minus validation has corrected success frequency >= 0.90. No repeat-until-pass.',
          'scope':'Classically adaptive job sequence on deliberately configured single-qubit modules, not autonomous in-QPU control or unknown hardware tomography.'}
    write_json(directory/'campaign.json',spec)
    for name in spec['implementation']:
        dest=directory/'source'/name;dest.parent.mkdir(parents=True,exist_ok=True)
        dest.write_bytes((ROOT/name).read_bytes())
    print(json.dumps({'initialized':True,'tag':tag,'cases':len(cases),
                      'max_free_seconds':MAX_JOBS*MAX_JOB_SECONDS,'usage_remaining':usage['usage_remaining_seconds']},indent=2))


def campaign(directory,current=False):
    spec=load_json(directory/'campaign.json')
    require(spec['schema']=='vi.finite-hardware.v1' and spec['instance_plan']=='open'
            and spec['max_jobs']==MAX_JOBS and spec['max_job_seconds']==MAX_JOB_SECONDS
            and spec['batch_shots']==BATCH_SHOTS and spec['validation_shots']==VALIDATION_SHOTS
            and spec['max_acquisition_rounds']==MAX_ROUNDS and spec['wire']==WIRE,
            'Campaign scope changed')
    require(len(spec['cases'])==16 and [tuple(c['fixture']) for c in spec['cases']]==list(WORLDS),
            'Fixture family changed')
    require(spec['request']=={'connector':['t'],'consumer':'terminal','axis':'X'}
            and spec['family_alpha']=='1/100'
            and spec['per_episode_alpha']==str(F(1,1600))
            and spec['assumed_conditional_probe_error_upper_bound']=='1/5','Statistical request changed')
    if current:
        require(spec['implementation']==implementation() and spec['versions']==versions(),
                'Implementation changed after preregistration')
    return spec


def evidence(directory,spec):
    p=problem(('t',),'terminal','X')
    engines={c['episode']:Evidence(p,episode=c['episode'],alpha=spec['per_episode_alpha'],
                 epsilon=spec['assumed_conditional_probe_error_upper_bound'],
                 max_shots=MAX_ROUNDS*BATCH_SHOTS) for c in spec['cases']}
    for path in sorted(directory.glob('round-*/hardware-result.json')):
        data=load_json(path)
        if data['kind']=='acquisition':
            for row in data['rows']:
                engines[row['episode']].acquire({k:row[k] for k in
                    ('episode','batch_id','probe','shots','counts')})
    return engines


def prepare_axis(circuit,axis):
    if axis in ('X','Y'):circuit.h(0)
    if axis=='Y':circuit.s(0)


def read_axis(circuit,axis):
    if axis=='Y':circuit.sdg(0)
    if axis in ('X','Y'):circuit.h(0)
    circuit.measure(0,0)


def module(circuit,label):
    circuit.barrier(0)
    for gate in PAULI_WORDS[label]:getattr(circuit,gate)(0)
    circuit.barrier(0)


def logical(spec,descriptor):
    from qiskit import QuantumCircuit
    case=next(c for c in spec['cases'] if c['episode']==descriptor['episode'])
    a,b=case['fixture']
    circuit=QuantumCircuit(1,1)
    if descriptor['kind']=='acquisition':
        p=next(p for p in problem(('t',),'terminal','X')['probes'] if p['id']==descriptor['probe'])
        prepare_axis(circuit,p['prep'])
        if p['path'] in ('A','neutral','current'):module(circuit,a)
        if p['path']=='current':circuit.t(0)
        if p['path'] in ('B','neutral','current'):module(circuit,b)
        read_axis(circuit,p['read'])
    else:
        # Prepare T†|+X> or T†|-X>; the unchanged user target T then has X
        # outcome given by target_bit. This is a two-input hardware validation,
        # not arbitrary-input process certification.
        if descriptor['target_bit']:circuit.x(0)
        circuit.h(0);circuit.tdg(0)
        module(circuit,a);circuit.t(0);module(circuit,b)
        read_axis(circuit,descriptor['execution']['read'])
    circuit.metadata=dict(descriptor)
    return circuit


def prepare(directory):
    from qiskit import qpy, transpile
    from qiskit.quantum_info import Statevector
    from qiskit_ibm_runtime.utils.validations import validate_isa_circuits
    import numpy as np
    spec=campaign(directory,current=True)
    existing=sorted(directory.glob('round-*/plan.json'))
    require(len(existing)<MAX_JOBS,'Maximum number of hardware jobs reached')
    require(all((p.parent/'hardware-result.json').exists() for p in existing),'Collect preceding round first')
    require(not any(load_json(p)['kind']=='validation' for p in existing),'Validation already prepared')
    engines=evidence(directory,spec)
    pending=[(c,e.decision()) for c in spec['cases'] if (e:=engines[c['episode']]).decision()['kind']=='probe']
    round_number=len(existing)
    kind='acquisition' if pending and round_number<MAX_ROUNDS else 'validation'
    descriptors=[]
    if kind=='acquisition':
        for c,d in pending:
            descriptors.append({'episode':c['episode'],'kind':kind,'probe':d['probe']})
        shots=BATCH_SHOTS
    else:
        for c in spec['cases']:
            decision=engines[c['episode']].decision()
            if decision['kind']=='act':
                for bit in (0,1):
                    descriptors.append({'episode':c['episode'],'kind':kind,'target_bit':bit,
                                        'action':decision['action'],'execution':decision['execution']})
        shots=VALIDATION_SHOTS
    require(descriptors,'No supported continuation available for validation')
    service=service_open();backend=service.backend(spec['backend'])
    require(service.active_instance()==spec['instance'],'Instance changed')
    tag=spec['tag']+'-r'+str(round_number)
    for n,d in enumerate(descriptors):d.update(tag=tag,round=round_number,pub=n)
    source=[logical(spec,d) for d in descriptors]
    isa=transpile(source,backend,initial_layout=[WIRE],optimization_level=0,seed_transpiler=734)
    validate_isa_circuits(isa,backend.target)
    for original,compiled in zip(source,isa):
        measurements=[(compiled.find_bit(i.qubits[0]).index,compiled.find_bit(i.clbits[0]).index)
                      for i in compiled.data if i.operation.name=='measure']
        require(measurements==[(WIRE,0)],'Measurement/layout binding changed')
        compact=compact_active(compiled)
        expected=Statevector.from_instruction(original.remove_final_measurements(inplace=False))
        actual=Statevector.from_instruction(compact.remove_final_measurements(inplace=False))
        require(abs(np.vdot(expected.data,actual.data))>1-1e-10,'Compiled action differs from source')
    output=directory/f'round-{round_number:02}'
    require(not output.exists(),'Round directory already exists');output.mkdir()
    raw=io.BytesIO();qpy.dump(isa,raw);(output/'isa.qpy').write_bytes(raw.getvalue())
    plan={'kind':kind,'round':round_number,'tag':tag,'shots':shots,'descriptors':descriptors,
          'qpy_sha256':sha(raw.getvalue()),'campaign_sha256':sha((directory/'campaign.json').read_bytes()),
          'previous_results':{str(p.relative_to(directory)):sha(p.read_bytes()) for p in directory.glob('round-*/hardware-result.json')},
          'decisions_before':{key:e.export() for key,e in engines.items()},
          'local_validation':'Pure-state native ISA/source equivalence on declared preparations; ideal only'}
    write_json(output/'plan.json',plan)
    print(json.dumps({'prepared':str(output),'kind':kind,'pubs':len(isa),'shots':shots*len(isa)},indent=2))


def read_round(directory,index,current=False):
    from qiskit import qpy
    spec=campaign(directory,current=current);path=directory/f'round-{index:02}'
    plan=load_json(path/'plan.json')
    require(plan['campaign_sha256']==sha((directory/'campaign.json').read_bytes()),'Campaign changed')
    require(all(sha((directory/p).read_bytes())==digest for p,digest in plan['previous_results'].items()),
            'Upstream measured evidence changed')
    raw=(path/'isa.qpy').read_bytes();require(sha(raw)==plan['qpy_sha256'],'ISA payload changed')
    circuits=qpy.load(io.BytesIO(raw))
    require(len(circuits)==len(plan['descriptors']) and all(c.metadata==d for c,d in zip(circuits,plan['descriptors'])),
            'Circuit/record occurrence differs')
    return spec,path,plan,circuits


def submit(directory,index):
    import fcntl
    from qiskit_ibm_runtime import SamplerV2
    spec,path,plan,circuits=read_round(directory,index,current=True)
    with (path/'submit.lock').open('a') as lock:
        fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
        service=service_open()
        if (path/'ledger.json').exists():
            ledger=load_json(path/'ledger.json')
            if 'job_id' not in ledger:
                matches=service.jobs(job_tags=[plan['tag']],limit=2)
                require(len(matches)==1,'Submission uncertain: refusing another job')
                ledger['job_id']=matches[0].job_id();write_json(path/'ledger.json',ledger)
            print(json.dumps(ledger,indent=2));return
        require(service.active_instance()==spec['instance'],'Instance changed')
        require(service.usage()['usage_remaining_seconds']>=MAX_JOB_SECONDS,'Insufficient free quota')
        backend=service.backend(spec['backend'])
        require(backend.status().operational,'Backend unavailable')
        ledger={'tag':plan['tag'],'qpy_sha256':plan['qpy_sha256'],'status':'intent','at':utc()}
        write_json(path/'ledger.json',ledger)
        sampler=SamplerV2(mode=backend,options={'max_execution_time':MAX_JOB_SECONDS,
            'environment':{'job_tags':[plan['tag']]},
            'twirling':{'enable_gates':False,'enable_measure':False},
            'dynamical_decoupling':{'enable':False},'execution':{'init_qubits':True}})
        job=sampler.run(circuits,shots=plan['shots'])
        ledger.update(job_id=job.job_id(),status='submitted');write_json(path/'ledger.json',ledger)
        print(json.dumps(ledger,indent=2))


def collect(directory,index):
    from qiskit_ibm_runtime import RuntimeEncoder
    spec,path,plan,circuits=read_round(directory,index)
    ledger=load_json(path/'ledger.json')
    if (path/'hardware-result.json').exists():
        existing=load_json(path/'hardware-result.json')
        require(existing['job_id']==ledger['job_id'] and
                existing['raw_sha256']==sha((path/'raw-result.json').read_bytes()),'Archived result changed')
        print(json.dumps({'job_id':existing['job_id'],'status':'DONE','archived':True}));return
    service=service_open();job=service.job(ledger['job_id'])
    require(service.active_instance()==spec['instance'] and job.backend().name==spec['backend']
            and plan['tag'] in job.tags,'Remote job scope mismatch')
    status=job.status();print(json.dumps({'job_id':job.job_id(),'status':status}))
    if status!='DONE':return
    remote=job.inputs['pubs'];require(len(remote)==len(circuits),'Wrong remote pub count')
    for pub,circuit in zip(remote,circuits):
        c=pub[0] if isinstance(pub,(tuple,list)) else pub.circuit
        shots=pub[2] if isinstance(pub,(tuple,list)) else pub.shots
        require(signature(c)==signature(circuit) and shots==plan['shots'],'Remote program or shots changed')
    result=job.result();raw=json.dumps(result,cls=RuntimeEncoder,indent=2)
    (path/'raw-result.json').write_text(raw)
    rows=[];require(len(result)==len(circuits),'Wrong result count')
    for i,(pub,d) in enumerate(zip(result,plan['descriptors'])):
        require(pub.metadata.get('circuit_metadata')==d and set(pub.data.keys())=={'c'},'Result metadata/register mismatch')
        bits=pub.data.c
        require(bits.num_bits==1 and bits.num_shots==plan['shots'] and bits.shape==(),'Wrong bit/shot shape')
        counts=dict(bits.get_counts())
        require(sum(counts.values())==plan['shots'] and not set(counts)-{'0','1'},'Invalid result counts')
        rows.append({**d,'batch_id':job.job_id()+':'+str(i),'counts':counts,'shots':plan['shots']})
    report={'schema':'vi.finite-hardware-result.v1','kind':plan['kind'],'status':'DONE',
            'job_id':job.job_id(),'scope':'REAL QPU DATA','rows':rows,'metrics':job.metrics(),
            'raw_sha256':sha(raw.encode()),'usage_after':service.usage()}
    write_json(path/'hardware-result.json',report)
    if plan['kind']=='acquisition':
        engines=evidence(directory,spec)
        print(json.dumps({'decisions':dict(Counter(e.decision()['kind'] for e in engines.values())),
                          'next_probes':dict(Counter(e.decision().get('probe','resolved') for e in engines.values()))},indent=2))
    print(json.dumps({'completed':str(path),'pubs':len(rows),'metrics':report['metrics'],
                      'free_remaining_seconds':report['usage_after']['usage_remaining_seconds']},indent=2,default=str))


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('stage',choices=('init','prepare','submit','collect'))
    parser.add_argument('--output',type=Path,required=True)
    parser.add_argument('--round',type=int,default=0)
    args=parser.parse_args();directory=args.output.resolve()
    if args.stage=='init':init(directory)
    elif args.stage=='prepare':prepare(directory)
    elif args.stage=='submit':submit(directory,args.round)
    else:collect(directory,args.round)
