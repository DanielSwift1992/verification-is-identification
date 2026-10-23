#!/usr/bin/env python3
"""Fixed joint-return experiment on IBM Open, at most one submitted job.

Nine 4-qubit circuits, 1024 shots each; source-derived A/B words, Bell
reference for BOTH D and E. All outcomes retained. No paid plan or retry-until-
success. Direct H is a benchmark, never an added execution capability.
"""

import sys as _evidence_sys
from pathlib import Path as _EvidencePath
_evidence_sys.path.insert(0, str(_EvidencePath(__file__).resolve().parents[1]))
import hardware_runs as _runs
_runs.configure(required=False)
import argparse
from collections import Counter
from copy import deepcopy
import fcntl
import io
import json
import math
import os
from pathlib import Path
import sys
import uuid

HERE=_runs.owned(__file__).resolve().parent;ROOT=HERE.parents[1]
sys.path.insert(0,str(HERE));sys.path.insert(0,str(ROOT/'Checks/FiniteContinuation'))
from pilot import service_open,compact_active,signature,sha,utc,versions
from joint_returns import choose,validate,check_source

SHOTS=1024;MAX_SECONDS=45;ALPHA=.01
ARTIFACT=ROOT/'Research/Artifacts/joint-returns-complete-20260914'
CASES=('baseline_h','single_keep','single_replace','keep_h','reset_h','moving_h',
       'moving_h_wrong_memory','keep_twice','moving_twice')
ORDER=(0,4,7,1,5,8,2,6,3)


def write(path,value):
    value=_runs.bind_receipt(value,destination=path)
    temporary=path.with_name(path.name+'.'+uuid.uuid4().hex+'.tmp')
    with temporary.open('x') as f:
        f.write(json.dumps(value,indent=2,default=str)+'\n');f.flush();os.fsync(f.fileno())
    temporary.replace(path)
    fd=os.open(path.parent,os.O_RDONLY)
    try:os.fsync(fd)
    finally:os.close(fd)
def read(path):return json.loads(path.read_text())


def options(tag):
    return {'default_shots':SHOTS,'max_execution_time':MAX_SECONDS,
            'environment':{'job_tags':[tag]},'execution':{'init_qubits':True},
            'twirling':{'enable_gates':False,'enable_measure':False},
            'dynamical_decoupling':{'enable':False}}


@_runs.include_reader
def implementation():
    names=['Checks/IBMBridge/joint_memory.py','Checks/IBMBridge/pilot.py',
           'Checks/FiniteContinuation/joint_returns.py','Checks/FiniteContinuation/joint_return_court.js',
           'Checks/FiniteContinuation/planner.py','Checks/FiniteContinuation/court_bridge.js',
           'Checks/FiniteContinuation/contact_court.js']
    return {n:sha((ROOT/n).read_bytes()) for n in names}


def current_source():
    source=read(ARTIFACT/'source-reading.json');build=read(ARTIFACT/'build.json')
    for n,h in build['artifact_sha256'].items():assert sha((ARTIFACT/n).read_bytes())==h
    for n,h in build['implementation_sha256'].items():assert sha((ROOT/n).read_bytes())==h
    check_source(source);return source


def logical(source,name,tag):
    from qiskit import QuantumCircuit,ClassicalRegister
    assert name in CASES
    c=QuantumCircuit(4);c.add_register(ClassicalRegister(4,'out'))
    # Logical wire order D,E,R_D,R_E. Actual reset, not a documentation flag.
    for q in range(4):c.reset(q)
    c.barrier();c.h(0);c.cx(0,2);c.h(1);c.cx(1,3);c.barrier()
    instructions=[];iterations=2 if name.endswith('twice') else 1
    if name=='baseline_h':instructions=[{'gate':'h','target':'D'}]
    elif name.startswith('single'):
        if name=='single_replace':instructions.append({'gate':'refresh','memory':'E','boundary':1})
        for p in source['modules']['JointKeep']['A']:
            assert p=='cz';instructions.append({'gate':'cz','memory':'E','data':'D'})
    else:
        offer='Moving' if name.startswith('moving') else 'Replace' if name=='reset_h' else 'Keep'
        packet=choose(source,['h'],[offer],[1,1])
        instructions=validate(source,packet,['h'],[offer],[1,1])
        # q=0 refresh sites do nothing; q=1 sites physically replace memory.
        q=source['offers'][offer]['rate'];assert q in ([0,1],[1,1])
        instructions=[o for o in instructions if o['gate']!='refresh' or q==[1,1]]
    core_cz=0;core_resets=0
    for _ in range(iterations):
        for o in instructions:
            g=o['gate']
            if g=='cz':c.cz(0,1);core_cz+=1
            elif g=='refresh':c.reset(1);c.h(1);core_resets+=1
            else:getattr(c,g)(0 if o['target']=='D' else 1)
            c.barrier()  # Preserve each real interaction boundary in the ISA.
    # Independent recipient target, NOT inferred from emitted instructions.
    target_h=name not in ('single_keep','single_replace','keep_twice','moving_twice')
    target_z=name=='moving_h'
    if target_h:c.h(0)
    if target_z:c.z(1)
    c.barrier();c.cx(0,2);c.h(0);c.cx(1,3);c.h(1);c.barrier()
    for bit,q in enumerate((0,2,1,3)):c.measure(q,bit)
    c.metadata={'experiment':tag,'case':name,'question':'joint_Bell_return',
                'source_sha256':source['source_sha256'],'target_H':target_h,'target_memory_Z':target_z,
                'core_cz':core_cz,'core_resets':core_resets,'iterations':iterations}
    return c


def layout(backend):
    target=backend.target;edges={};neighbors={i:set() for i in range(backend.num_qubits)}
    for pair,p in target['cz'].items():
        if pair is None or p is None or p.error is None:continue
        i,j=pair;edges[frozenset(pair)]=float(p.error);neighbors[i].add(j);neighbors[j].add(i)
    choices=[]
    for d in neighbors:
        for e in neighbors[d]:
            for rd in neighbors[d]-{e}:
                for re in neighbors[e]-{d,rd}:
                    wires=(d,e,rd,re)
                    if len(set(wires))<4:continue
                    if any(not target.instruction_supported(operation_name=g,qargs=(q,)) for g in ('reset','measure') for q in wires):continue
                    ro=[target['measure'][(q,)].error for q in wires]
                    if any(x is None for x in ro):continue
                    score=8*edges[frozenset((d,e))]+2*edges[frozenset((d,rd))]+2*edges[frozenset((e,re))]+sum(ro)
                    choices.append((score,wires,ro))
    assert choices,'No supported adjacent four-wire path'
    score,wires,ro=min(choices)
    return list(wires),{'selection_score':score,'readout_errors':ro,
                       'cz_errors':{','.join(map(str,sorted(k))):v for k,v in edges.items() if k<=set(wires)}}


def validate_isa(circuit,wires):
    m=circuit.metadata;two=Counter();resets=Counter();measure={}
    for i in circuit.data:
        qs=tuple(circuit.find_bit(q).index for q in i.qubits);g=i.operation.name
        if len(qs)==2 and g!='barrier':
            assert g=='cz','Unaccounted routing or entangling gate';two[frozenset(qs)]+=1
        if g=='reset':resets[qs[0]]+=1
        if g=='measure':
            bit=circuit.find_bit(i.clbits[0]).index;assert bit not in measure;measure[bit]=qs[0]
    d,e,rd,re=wires
    expected=Counter({frozenset((d,rd)):2,frozenset((e,re)):2})
    if m['core_cz']:expected[frozenset((d,e))]=m['core_cz']
    assert two==expected,('Actual module calls lost or changed',two,expected)
    assert resets==Counter({d:1,e:1+m['core_resets'],rd:1,re:1})
    assert measure=={0:d,1:rd,2:e,3:re}
    assert circuit.count_ops().get('barrier',0)>=5
    return {'cz_by_pair':{','.join(map(str,sorted(k))):v for k,v in two.items()},'resets':dict(resets),'measurement_wires':measure}


def probabilities(circuit):
    from qiskit_aer import AerSimulator
    from qiskit import transpile
    c=compact_active(circuit);measure={}
    for ins in c.data:
        if ins.operation.name=='measure':measure[c.find_bit(ins.clbits[0]).index]=c.find_bit(ins.qubits[0]).index
    c=c.remove_final_measurements(inplace=False);c.save_density_matrix()
    simulator=AerSimulator(method='density_matrix')
    c=transpile(c,simulator,optimization_level=0)
    rho=simulator.run(c,shots=1).result().data(0)['density_matrix'].data
    answer=Counter()
    for basis,p in enumerate(rho.diagonal().real):
        bits=sum(((basis>>wire)&1)<<bit for bit,wire in measure.items())
        answer[format(bits,'04b')]+=float(p)
    return {k:v for k,v in answer.items() if v>1e-12}


def scores(counts):
    assert isinstance(counts,dict) and counts
    assert all(isinstance(k,str) and len(k)==4 and set(k)<=set('01') and type(v) is int and v>=0 for k,v in counts.items())
    n=sum(counts.values());assert n==SHOTS
    return {'data':sum(v for k,v in counts.items() if int(k,2)&3==0),
            'memory':sum(v for k,v in counts.items() if int(k,2)&12==0),'joint':counts.get('0000',0)}


def analyse(rows):
    assert {r['case'] for r in rows}==set(CASES) and len(rows)==len(CASES)
    # 27 fixed Bernoulli questions, two-sided Hoeffding-Azuma with predictable
    # conditional means. No fixed-law/IID claim and no transfer to future shots.
    radius=math.sqrt(math.log(2*len(CASES)*3/ALPHA)/(2*SHOTS))
    result={}
    for row in rows:
        assert row['shots']==SHOTS
        result[row['case']]={k:{'successes':v,'frequency':v/SHOTS,
             'simultaneous_interval':[max(0,v/SHOTS-radius),min(1,v/SHOTS+radius)]} for k,v in scores(row['counts']).items()}
    def lo(case,key):return result[case][key]['simultaneous_interval'][0]
    def hi(case,key):return result[case][key]['simultaneous_interval'][1]
    return {'cases':result,'alpha':ALPHA,'simultaneous_radius':radius,
      'keep_minus_replace_data_interval':[lo('keep_h','data')-hi('reset_h','data'),hi('keep_h','data')-lo('reset_h','data')],
      'criteria':{'retained_data_lower_above_half':lo('keep_h','data')>.5,
                  'retained_joint_lower_above_half':lo('keep_h','joint')>.5,
                  'retained_minus_replaced_data_lower_positive':lo('keep_h','data')>hi('reset_h','data'),
                  'moving_correct_memory_beats_wrong_memory':lo('moving_h','joint')>hi('moving_h_wrong_memory','joint'),
                  'retained_two_uses_joint_lower_above_half':lo('keep_twice','joint')>.5,
                  'moving_two_uses_joint_lower_above_half':lo('moving_twice','joint')>.5},
      'statistical_question':'Average conditional pass probabilities during the executed fixed tests, including apparatus. Future probabilities need an additional transport relation.',
      'channel_accuracy':'No empirical full-DE diamond bound, convex-mixture rate q, SPAM-free fidelity, or old Pauli-key applicability is established.'}


def prepare(directory):
    from qiskit import transpile,qpy
    from qiskit_ibm_runtime.utils.validations import validate_isa_circuits
    assert not directory.exists();source=current_source();impl=implementation()
    service=service_open();usage=service.usage();assert usage['usage_remaining_seconds']>=MAX_SECONDS
    backend=service.backend('ibm_kingston');assert backend.status().operational
    wires,cal=layout(backend);tag='vi-joint-memory-'+uuid.uuid4().hex
    logicals=[logical(source,CASES[i],tag) for i in ORDER]
    isa=transpile(logicals,backend,initial_layout=wires,optimization_level=0,routing_method='none',seed_transpiler=803177)
    validate_isa_circuits(isa,backend.target)
    manifests=[validate_isa(c,wires) for c in isa];local=[]
    for a,b in zip(logicals,isa):
        x,y=probabilities(a),probabilities(b)
        assert max(abs(x.get(k,0)-y.get(k,0)) for k in set(x)|set(y))<1e-10
        name=a.metadata['case'];bell=sum(v for k,v in y.items() if int(k,2)&3==0)
        expected=.5 if name.startswith('single') else .25 if name=='reset_h' else 1.
        assert abs(bell-expected)<1e-10,(name,y)
        if name=='moving_h_wrong_memory':assert y.get('0000',0)<1e-10
        elif name not in ('reset_h','single_keep','single_replace'):assert abs(y.get('0000',0)-1)<1e-10
        local.append({'case':name,'exact_ideal_probabilities':y})
    assert implementation()==impl
    directory.mkdir(parents=True)
    buf=io.BytesIO();qpy.dump(isa,buf);raw=buf.getvalue();(directory/'isa.qpy').write_bytes(raw)
    snapshots={}
    for n,h in {**impl,**source['source_sha256']}.items():
        relative=n if not _runs.owned(n).is_absolute() else 'external/'+_runs.owned(n).name
        p=directory/'source'/relative;p.parent.mkdir(parents=True,exist_ok=True)
        data=(ROOT/n).read_bytes();assert sha(data)==h;p.write_bytes(data)
        snapshots[str(p.relative_to(directory))]=h
    for n in ('build.json','JointReturns.swift'):
        p=directory/('proof-'+n);p.write_bytes((ARTIFACT/n).read_bytes())
        snapshots[p.name]=sha(p.read_bytes())
    write(directory/'source-reading.json',source)
    plan={'schema':'vi.ibm.joint-memory.v1','created_at':utc(),'tag':tag,'backend':backend.name,
          'instance':service.active_instance(),'instance_plan':'open','shots':SHOTS,'max_seconds':MAX_SECONDS,
          'physical_D_E_RD_RE':wires,'calibration_selection':cal,'usage_before':usage,
          'cases':list(CASES),'order':list(ORDER),'manifests':manifests,
          'implementation':impl,'versions':versions(),'source_sha256':source['source_sha256'],
          'snapshots':snapshots,
          'qpy_sha256':sha(raw),'source_reading_sha256':sha((directory/'source-reading.json').read_bytes()),
          'analysis':{'alpha':ALPHA,'questions':27,'no_postselection':True,'no_adaptive_repeats':True},
          'options':options(tag)}
    write(directory/'plan.json',plan);write(directory/'ideal-validation.json',local)
    print(json.dumps({'prepared':True,'backend':backend.name,'physical_D_E_RD_RE':wires,'cases':9,'shots':9*SHOTS,'max_free_seconds':MAX_SECONDS},indent=2))


def load(directory,current=False):
    from qiskit import qpy
    p=read(directory/'plan.json');assert p['schema']=='vi.ibm.joint-memory.v1'
    assert p['shots']==SHOTS and p['max_seconds']==MAX_SECONDS and p['cases']==list(CASES) and p['order']==list(ORDER)
    assert p['analysis']=={'alpha':ALPHA,'questions':27,'no_postselection':True,'no_adaptive_repeats':True}
    assert p['instance_plan']=='open' and p['backend']=='ibm_kingston' and p['options']==options(p['tag'])
    for name,h in p['snapshots'].items():assert sha((directory/name).read_bytes())==h
    assert p['qpy_sha256']==sha((directory/'isa.qpy').read_bytes())
    assert p['source_reading_sha256']==sha((directory/'source-reading.json').read_bytes())
    if current:
        assert p['implementation']==implementation() and p['versions']==versions()
        assert read(directory/'source-reading.json')==current_source()
    circuits=qpy.load(io.BytesIO((directory/'isa.qpy').read_bytes()));assert len(circuits)==9
    for circuit,i,m in zip(circuits,ORDER,p['manifests']):
        assert circuit.metadata['case']==CASES[i] and circuit.metadata['experiment']==p['tag']
        actual=validate_isa(circuit,p['physical_D_E_RD_RE'])
        assert json.loads(json.dumps(actual))==m
    return p,circuits


def send_once(directory,service,p,circuits,sampler_factory=None):
    from qiskit_ibm_runtime import SamplerV2
    with (directory/'submit.lock').open('a') as lock:
        fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB);file=directory/'ledger.json'
        if file.exists():
            ledger=read(file);assert ledger['tag']==p['tag'] and ledger['qpy_sha256']==p['qpy_sha256']
            if ledger.get('job_id'):return ledger
            jobs=service.jobs(limit=2,job_tags=[p['tag']]);assert len(jobs)==1,'Uncertain submission: reconcile, never resubmit'
            ledger.update(job_id=jobs[0].job_id(),status='recovered');write(file,ledger);return ledger
        assert service.active_instance()==p['instance'] and service.usage()['usage_remaining_seconds']>=MAX_SECONDS
        backend=service.backend(p['backend']);status=backend.status();assert status.operational and status.status_msg=='active'
        sampler=(sampler_factory or SamplerV2)(mode=backend,options=p['options'])
        ledger={'tag':p['tag'],'qpy_sha256':p['qpy_sha256'],'status':'intent','at':utc()}
        write(file,ledger);job=sampler.run(circuits,shots=SHOTS)
        ledger.update(status='submitted',job_id=job.job_id());write(file,ledger);return ledger


def collect(directory):
    from qiskit_ibm_runtime import RuntimeEncoder
    p,circuits=load(directory);ledger=read(directory/'ledger.json')
    assert ledger['tag']==p['tag'] and ledger['qpy_sha256']==p['qpy_sha256']
    service=service_open();assert service.active_instance()==p['instance'];job=service.job(ledger['job_id'])
    assert job.job_id()==ledger['job_id'] and p['tag'] in job.tags and job.backend().name==p['backend']
    state=job.status()
    if state!='DONE':
        r={'job_id':job.job_id(),'status':state}
        if state in ('ERROR','CANCELLED'):r['error']=job.error_message()
        write(directory/'status.json',r);return r
    pubs=job.inputs['pubs'];assert len(pubs)==len(circuits)
    for pub,circuit in zip(pubs,circuits):
        remote=pub[0] if isinstance(pub,(list,tuple)) else pub.circuit
        assert signature(remote)==signature(circuit)
    result=job.result();assert len(result)==9
    (directory/'raw-result.json').write_text(json.dumps(result,cls=RuntimeEncoder,indent=2))
    rows=[]
    for pub,c in zip(result,circuits):
        assert pub.metadata.get('circuit_metadata')==c.metadata and set(pub.data.keys())=={'out'}
        bits=pub.data.out;assert bits.num_shots==SHOTS and bits.num_bits==4 and bits.shape==()
        counts=dict(bits.get_counts());scores(counts)
        rows.append({'case':c.metadata['case'],'shots':SHOTS,'counts':counts})
    report={'job_id':job.job_id(),'status':'DONE','backend':p['backend'],'collected_at':utc(),
            'rows':rows,'analysis':analyse(rows),'metrics':job.metrics(),'usage_after':service.usage(),
            'raw_sha256':sha((directory/'raw-result.json').read_bytes()),'collector_sha256':implementation()}
    write(directory/'hardware-result.json',report);write(directory/'status.json',{'job_id':job.job_id(),'status':'DONE'})
    return {'job_id':job.job_id(),'status':'DONE','analysis':report['analysis'],'usage_after':report['usage_after']}


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('stage',choices=['prepare','submit','collect']);p.add_argument('--output',required=True,type=_runs.owned)
    a=p.parse_args();d=a.output.resolve()
    if a.stage=='prepare':prepare(d)
    elif a.stage=='submit':
        plan,circuits=load(d,True);print(json.dumps(send_once(d,service_open(),plan,circuits),indent=2))
    else:print(json.dumps(collect(d),indent=2,default=str))
