#!/usr/bin/env python3
"""Last planned night job: inspect the live measurement/update boundary.

Source-derived PC actions, separately declared diagnostic data preparations.
Same device/wires as the completed feedback experiment; no V or recipient.
"""
import argparse
from collections import Counter
import io
import json
import math
from pathlib import Path
import random
import sys
import uuid

HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[1]
sys.path.insert(0,str(HERE))
import resident_feedback as f

PROTOCOL='Research/2026-09-15-resident-boundary-diagnostic-protocol.md'
FIRST=ROOT/'private/ibm-resident-acquisition-20260915'
VARIANTS=('Baseline11','Retain11','Toggle00','Toggle11','Write11','Install11','DataFeedback11','Regenerate11')
CASES=tuple((v,a) for v in VARIANTS for a in ('Z','X'))
ORDER=list(range(len(CASES)));random.Random(649316).shuffle(ORDER)
QUESTIONS=('data','program','clock','joint','record_zero')
WIRES=[23,16,3];SHOTS=1024;MAX_SECONDS=30;ALPHA=.01


def implementation():
    names=[Path(__file__),ROOT/PROTOCOL]
    return {**f.implementation(),**{str(p.relative_to(ROOT)):f.sha(p.read_bytes()) for p in names}}


def descriptor(source,variant):
    assert variant in VARIANTS
    initial=(0,0) if variant=='Toggle00' else (1,1)
    mode=next((s for s in ('Toggle','Write','Install') if variant.startswith(s)),None)
    outputs=[]
    for b in (0,1):
        action=(mode+str(b)) if mode else 'Toggle0'
        outputs.append(f.source_adapter.control_table(source,action)[initial])
    return {'initial_PC':list(initial),'mode':mode,'output_PC':[list(x) for x in outputs],
            'data_bit':'zero' if variant in ('Baseline11','DataFeedback11') else 'record',
            'record':'zero' if variant=='Baseline11' else 'balanced'}


def logical(source,variant,axis,tag):
    from qiskit import QuantumCircuit,ClassicalRegister
    from qiskit_ibm_runtime.circuit import MidCircuitMeasure
    spec=descriptor(source,variant);c=QuantumCircuit(3);out=ClassicalRegister(4,'out');c.add_register(out)
    for q in range(3):c.reset(q)
    p,t=spec['initial_PC']
    if p:c.x(2)
    if t:c.x(1)
    c.barrier()
    if variant=='Baseline11':
        if axis=='X':c.h(0)
    else:
        if axis=='Z':c.h(0)
        if axis=='X':c.h(0)
        c.append(MidCircuitMeasure(),[0],[out[0]])
        if axis=='X':c.h(0)
    c.barrier()
    if spec['mode']:
        if spec['mode'] in ('Write','Install'):c.reset(2)
        if spec['mode']=='Install':c.reset(1)
        with c.if_test((out[0],source['probes'][axis]['records'][1])):c.x(2)
    elif variant in ('DataFeedback11','Regenerate11'):
        if variant=='Regenerate11':
            c.reset(0)
            if axis=='X':c.h(0)
        with c.if_test((out[0],1)):
            getattr(c,'x' if axis=='Z' else 'z')(0)
    c.barrier()
    if axis=='X':c.h(0)
    if variant=='Baseline11':c.measure(0,out[0])
    c.measure(0,out[1]);c.measure(1,out[2]);c.measure(2,out[3])
    c.metadata={'experiment':tag,'variant':variant,'probe':axis,'question':'selective_boundary',
                'source_sha256':source['source_sha256'],'descriptor':spec,
                'scope':'Diagnostic PC and measured-basis D at this prefix; no later V, no claim of whole-instrument tomography.'}
    return c


def manifest(c):
    resets=Counter();measure={};conditions=[]
    def visit(block,qmap,cmap,inside=False):
        for ins in block.data:
            op=ins.operation;qs=[qmap[block.find_bit(q).index] for q in ins.qubits];cs=[cmap[block.find_bit(x).index] for x in ins.clbits]
            if op.name=='barrier':continue
            if op.name=='if_else':
                assert not inside
                bit,value=op.condition;assert not hasattr(bit,'size')
                assert cmap[block.find_bit(bit).index]==0 and value==1
                conditions.append(qs)
                for b in op.blocks:visit(b,qs,cs,True)
            elif op.name=='reset':assert not inside;resets[qs[0]]+=1
            elif op.name in ('measure','measure_2'):
                assert not inside and len(qs)==len(cs)==1 and cs[0] not in measure
                measure[cs[0]]={'wire':qs[0],'instruction':op.name}
            else:assert len(qs)==1 and op.name in ('rz','sx','x','id','delay')
    visit(c,list(range(c.num_qubits)),list(range(c.num_clbits)))
    v=c.metadata['variant'];mode=c.metadata['descriptor']['mode'];d,t,p=WIRES
    want=Counter({d:1,t:1,p:1})
    if mode in ('Write','Install'):want[p]+=1
    if mode=='Install':want[t]+=1
    if v=='Regenerate11':want[d]+=1
    assert resets==want
    assert measure=={0:{'wire':d,'instruction':'measure' if v=='Baseline11' else 'measure_2'},
                     1:{'wire':d,'instruction':'measure'},2:{'wire':t,'instruction':'measure'},3:{'wire':p,'instruction':'measure'}}
    assert conditions==([[p]] if mode else [[d]] if v in ('DataFeedback11','Regenerate11') else [])
    return {'resets':dict(resets),'measurements':measure,'condition_targets':conditions,
            'recursive_signature_sha256':f.sha(json.dumps(f.signature(c),sort_keys=True).encode())}


def ideal(circuit):
    import numpy as np
    from qiskit.quantum_info import DensityMatrix,Kraus,SuperOp
    c=f.compact_active(circuit);result={}
    for b in (0,1):
        rho=DensityMatrix.from_label('0'*c.num_qubits);terminal={};acquired=[]
        def visit(block,qmap,cmap):
            nonlocal rho
            for ins in block.data:
                op=ins.operation;qs=[qmap[block.find_bit(q).index] for q in ins.qubits];cs=[cmap[block.find_bit(x).index] for x in ins.clbits]
                if op.name=='barrier':continue
                if op.name=='if_else':
                    bit,value=op.condition;assert cmap[block.find_bit(bit).index]==0
                    choice=0 if b==value else 1
                    if choice<len(op.blocks):visit(op.blocks[choice],qs,cs)
                elif op.name in ('measure','measure_2'):
                    if cs==[0]:
                        acquired.append(qs[0]);proj=np.zeros((2,2));proj[b,b]=1
                        rho=rho.evolve(Kraus([proj]),qargs=qs)
                    else:assert cs[0] in (1,2,3);terminal[cs[0]]=qs[0]
                else:rho=rho.evolve(SuperOp(op),qargs=qs)
        visit(c,list(range(c.num_qubits)),list(range(c.num_clbits)))
        assert len(acquired)==1 and set(terminal)=={1,2,3}
        for value,prob in enumerate(rho.probabilities([terminal[j] for j in (1,2,3)])):
            result[format(2*value+b,'04b')]=float(prob)
    assert abs(sum(result.values())-1)<1e-10;return result


def expected_distribution(source,variant):
    desc=descriptor(source,variant);result={format(i,'04b'):0. for i in range(16)}
    for b in (0,1):
        weight=(1. if b==0 else 0.) if desc['record']=='zero' else .5
        p,c=desc['output_PC'][b];d=0 if desc['data_bit']=='zero' else b
        result[f'{p}{c}{d}{b}']+=weight
    return result


def prepare(directory):
    from qiskit import transpile,qpy
    from qiskit_ibm_runtime.utils.validations import validate_isa_circuits
    assert not directory.exists()
    previous=f.read(FIRST/'hardware-result.json');assert previous['status']=='DONE'
    first_plan=f.read(FIRST/'plan.json');assert first_plan['physical_D_R_P']==WIRES
    source=f.current_source();impl=implementation();service=f.service_open()
    usage=service.usage();assert usage['usage_remaining_seconds']>=MAX_SECONDS
    backend=service.backend(first_plan['backend']);assert backend.name=='ibm_kingston' and backend.status().operational
    snapshot={}
    for name in ('measure','measure_2','reset','sx','x','rz'):
        for q in WIRES:
            if name=='measure_2' and q!=WIRES[0]:continue
            assert backend.target.instruction_supported(operation_name=name,qargs=(q,))
            prop=backend.target[name][(q,)]
            snapshot[f'{name}:{q}']=None if prop is None else {'error':prop.error,'duration_seconds':prop.duration}
    for q in WIRES:
        prop=backend.qubit_properties(q)
        snapshot[f'qubit:{q}']={'t1_seconds':prop.t1,'t2_seconds':prop.t2,'frequency_hz':prop.frequency}
    tag='vi-resident-boundary-'+uuid.uuid4().hex
    originals=[logical(source,*CASES[i],tag) for i in ORDER]
    isa=[transpile(c,backend,initial_layout=WIRES,optimization_level=0,routing_method='none',seed_transpiler=649316) for c in originals]
    validate_isa_circuits(isa,backend.target);manifests=[manifest(c) for c in isa];local=[]
    for before,after in zip(originals,isa):
        x,y=ideal(before),ideal(after);expected=expected_distribution(source,before.metadata['variant'])
        assert max(abs(x[k]-y[k]) for k in x)<1e-10
        assert max(abs(y[k]-expected[k]) for k in y)<1e-10
        local.append({'variant':before.metadata['variant'],'probe':before.metadata['probe'],'ideal_probabilities':y})
    assert impl==implementation()
    directory.mkdir(parents=True);buf=io.BytesIO();qpy.dump(isa,buf);raw=buf.getvalue();(directory/'isa.qpy').write_bytes(raw)
    snapshots={}
    for n,h in {**impl,**source['source_sha256']}.items():
        rel=n if not Path(n).is_absolute() else 'external/'+Path(n).name
        p=directory/'source'/rel;p.parent.mkdir(parents=True,exist_ok=True)
        data=(ROOT/n).read_bytes();assert f.sha(data)==h;p.write_bytes(data);snapshots[str(p.relative_to(directory))]=h
    f.write(directory/'source-reading.json',source)
    plan={'schema':'vi.ibm.resident-boundary.v1','created_at':f.utc(),'tag':tag,'backend':backend.name,
          'instance':service.active_instance(),'instance_plan':'open','shots':SHOTS,'max_seconds':MAX_SECONDS,
          'physical_D_C_P':WIRES,'target_snapshot':snapshot,'usage_before':usage,'cases':list(CASES),'order':ORDER,
          'manifests':manifests,'implementation':impl,'versions':f.versions(),'source_sha256':source['source_sha256'],
          'snapshots':snapshots,'qpy_sha256':f.sha(raw),'source_reading_sha256':f.sha((directory/'source-reading.json').read_bytes()),
          'analysis':{'alpha':ALPHA,'questions':list(QUESTIONS),'no_postselection':True,'no_adaptive_repeats':True},
          'options':f.options(tag),'first_night_job':previous['job_id'],'last_planned_night_job':True}
    f.write(directory/'plan.json',plan);f.write(directory/'ideal-validation.json',local)
    return {'prepared':True,'circuits':len(isa),'shots':len(isa)*SHOTS,'wires':WIRES,'max_free_QPU_seconds':MAX_SECONDS}


def load(directory,current=False):
    from qiskit import qpy
    p=f.read(directory/'plan.json');assert p['schema']=='vi.ibm.resident-boundary.v1'
    assert p['shots']==SHOTS and p['max_seconds']==MAX_SECONDS and p['cases']==[list(x) for x in CASES] and p['order']==ORDER
    assert p['physical_D_C_P']==WIRES and p['instance_plan']=='open' and p['backend']=='ibm_kingston' and p['options']==f.options(p['tag'])
    assert p['analysis']=={'alpha':ALPHA,'questions':list(QUESTIONS),'no_postselection':True,'no_adaptive_repeats':True}
    assert p['last_planned_night_job'] is True and p['first_night_job']==f.read(FIRST/'ledger.json')['job_id']
    for n,h in p['snapshots'].items():assert f.sha((directory/n).read_bytes())==h
    assert p['qpy_sha256']==f.sha((directory/'isa.qpy').read_bytes()) and p['source_reading_sha256']==f.sha((directory/'source-reading.json').read_bytes())
    if current:assert p['implementation']==implementation() and p['versions']==f.versions() and f.read(directory/'source-reading.json')==f.current_source()
    circuits=qpy.load(io.BytesIO((directory/'isa.qpy').read_bytes()));assert len(circuits)==len(CASES)
    for c,i,m in zip(circuits,ORDER,p['manifests']):
        assert (c.metadata['variant'],c.metadata['probe'])==CASES[i] and c.metadata['experiment']==p['tag']
        assert json.loads(json.dumps(manifest(c)))==m
    return p,circuits


def score(counts,spec):
    assert sum(counts.values())==SHOTS and all(len(k)==4 and set(k)<=set('01') and type(v)is int and v>=0 for k,v in counts.items())
    total=Counter({q:0 for q in QUESTIONS});conditional={b:Counter({'n':0,**{q:0 for q in QUESTIONS[:-1]}}) for b in (0,1)}
    for key,n in counts.items():
        p,c,d,b=map(int,key);pp,cc=spec['output_PC'][b];dd=0 if spec['data_bit']=='zero' else b
        checks={'data':d==dd,'program':p==pp,'clock':c==cc,'joint':(d,p,c)==(dd,pp,cc),'record_zero':b==0}
        for q,ok in checks.items():total[q]+=n*ok
        conditional[b]['n']+=n
        for q in QUESTIONS[:-1]:conditional[b][q]+=n*checks[q]
    return dict(total),{str(b):dict(v) for b,v in conditional.items()}


def analyse(rows,source):
    assert len(rows)==len(CASES) and {(x['variant'],x['probe']) for x in rows}==set(CASES)
    radius=math.sqrt(math.log(2*len(CASES)*len(QUESTIONS)/ALPHA)/(2*SHOTS));result={}
    for row in rows:
        assert row['shots']==SHOTS
        counts,conditional=score(row['counts'],descriptor(source,row['variant']))
        result[row['variant']+':'+row['probe']]={'questions':{q:{'count':n,'frequency':n/SHOTS,
            'simultaneous_interval':[max(0,n/SHOTS-radius),min(1,n/SHOTS+radius)]} for q,n in counts.items()},
            'conditional_counts_descriptive':conditional}
    return {'cases':result,'alpha':ALPHA,'simultaneous_radius':radius,
            'statistical_question':'Average conditional event probabilities during the fixed diagnostic shots; no independent microscopic cause identified by these frequencies.'}


def collect(directory):
    from qiskit_ibm_runtime import RuntimeEncoder
    p,circuits=load(directory);ledger=f.read(directory/'ledger.json');service=f.service_open()
    assert ledger['tag']==p['tag'] and ledger['qpy_sha256']==p['qpy_sha256'] and service.active_instance()==p['instance']
    job=service.job(ledger['job_id']);assert p['tag'] in job.tags and job.backend().name==p['backend']
    status=job.status()
    if status!='DONE':
        r={'job_id':job.job_id(),'status':status}
        if status in ('ERROR','CANCELLED'):r['error']=job.error_message()
        f.write(directory/'status.json',r);return r
    pubs=job.inputs['pubs'];assert len(pubs)==len(circuits)
    for pub,c in zip(pubs,circuits):
        remote=pub[0] if isinstance(pub,(list,tuple)) else pub.circuit
        assert f.signature(remote)==f.signature(c)
    result=job.result();assert len(result)==len(circuits)
    (directory/'raw-result.json').write_text(json.dumps(result,cls=RuntimeEncoder,indent=2));rows=[]
    for pub,c in zip(result,circuits):
        assert pub.metadata.get('circuit_metadata')==c.metadata and set(pub.data.keys())=={'out'}
        bits=pub.data.out;assert bits.num_shots==SHOTS and bits.num_bits==4 and bits.shape==()
        rows.append({'variant':c.metadata['variant'],'probe':c.metadata['probe'],'shots':SHOTS,'counts':dict(bits.get_counts())})
    analysis=analyse(rows,f.read(directory/'source-reading.json'));usage=service.usage()
    r={'job_id':job.job_id(),'status':'DONE','backend':p['backend'],'collected_at':f.utc(),'rows':rows,'analysis':analysis,
       'metrics':job.metrics(),'usage_after':usage,'raw_sha256':f.sha((directory/'raw-result.json').read_bytes()),'collector_sha256':implementation()}
    f.write(directory/'hardware-result.json',r);f.write(directory/'status.json',{'job_id':job.job_id(),'status':'DONE'})
    return {'job_id':job.job_id(),'status':'DONE','free_quota_remaining':usage['usage_remaining_seconds'],
            'frequencies':{k:{q:v['frequency'] for q,v in row['questions'].items()} for k,row in analysis['cases'].items()}}


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('stage',choices=['prepare','submit','collect']);p.add_argument('--output',required=True,type=Path)
    a=p.parse_args();d=a.output.resolve()
    if a.stage=='prepare':result=prepare(d)
    elif a.stage=='submit':
        plan,circuits=load(d,True);audit=f.read(d/'offline-audit.json')
        assert audit['plan_sha256']==f.sha((d/'plan.json').read_bytes()) and audit['prepared_circuits_checked']==16
        assert audit['test_sha256']==f.sha((HERE/'resident_boundary_checks.py').read_bytes())
        result=f.send_once(d,f.service_open(),plan,circuits)
    else:result=collect(d)
    print(json.dumps(result,indent=2))
