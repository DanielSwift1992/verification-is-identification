#!/usr/bin/env python3
"""One frozen Open job: a measured record changes the resident program.

Fixed ten circuits, 1024 shots each, 30 free QPU seconds maximum. No paid
instance, postselection, adaptive repeat or host-supplied acquired answer.
"""
import argparse
from collections import Counter
import fcntl
import io
import json
import math
from pathlib import Path
import random
import sys
import uuid

HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[1]
sys.path.insert(0,str(HERE));sys.path.insert(0,str(ROOT/'Checks/FiniteContinuation'))
from pilot import service_open,sha,utc,versions,compact_active
from joint_memory import read,write
import resident_acquisition as source_adapter
import resident_memory as resident
import whole_word_admission as algebra

ARTIFACT=ROOT/'Research/Artifacts/resident-acquisition-20260915'
PROTOCOL='Research/2026-09-15-selective-resident-hardware-protocol.md'
VARIANTS=('Full00','Full11','Relative','WrongWrite11','Install11')
CASES=tuple((v,a) for v in VARIANTS for a in ('Z','X'))
ORDER=list(range(len(CASES)));random.Random(649315).shuffle(ORDER)
SHOTS=1024;MAX_SECONDS=30;ALPHA=.01
QUESTIONS=('pass','record_zero','joint_00','joint_01','joint_10','joint_11')


def implementation():
    names=['Checks/IBMBridge/resident_feedback.py','Checks/IBMBridge/pilot.py',
           'Checks/IBMBridge/joint_memory.py','Checks/FiniteContinuation/resident_acquisition.py',
           'Checks/FiniteContinuation/resident_acquisition_court.js','Checks/FiniteContinuation/resident_memory.py',
           'Checks/FiniteContinuation/resident_program_court.js','Checks/FiniteContinuation/whole_word_admission.py',
           'Checks/FiniteContinuation/memory_boundary.py','Checks/FiniteContinuation/joint_return_court.js',
           'Checks/FiniteContinuation/contact_court.js','Checks/FiniteContinuation/court_bridge.js',PROTOCOL]
    return {n:sha((ROOT/n).read_bytes()) for n in names}


def current_source():
    receipt=read(ARTIFACT/'receipt.json')
    for n,h in receipt['artifact_sha256'].items():assert sha((ARTIFACT/n).read_bytes())==h
    source=read(ARTIFACT/'acquisition-reading.json');source_adapter.validate(source)
    # Interpret only the constructors that the actual physical adapter lowers.
    for p,c in ((0,0),(0,1),(1,0),(1,1)):
        for b in (0,1):
            assert source_adapter.control_table(source,'Toggle'+str(b))[p,c]==(p^b,c)
            assert source_adapter.control_table(source,'Write'+str(b))[p,c]==(b,c)
            assert source_adapter.control_table(source,'Install'+str(b))[p,c]==(b,0)
    return source


def options(tag):
    return {'default_shots':SHOTS,'max_execution_time':MAX_SECONDS,
            'environment':{'job_tags':[tag]},'execution':{'init_qubits':True},
            'twirling':{'enable_gates':False,'enable_measure':False},
            'dynamical_decoupling':{'enable':False}}


def tick(source,full):
    from qiskit import QuantumCircuit
    from qiskit.circuit.library import HGate,SGate
    q=QuantumCircuit(3 if full else 2)
    gates={}
    for row in source['interpreter']['rows']:
        r=row['program']^row['clock']
        assert row['next_clock']==1-row['clock']
        if r in gates:assert gates[r]==row['gate']
        gates[r]=row['gate']
    if full:q.cx(2,1)
    for r,g in sorted(gates.items()):q.append({'h':HGate,'s':SGate}[g]().control(1,ctrl_state=r),[1,0])
    q.x(1)
    if full:q.cx(2,1)
    return q


def logical(source,variant,axis,tag,mid_measure=True):
    from qiskit import QuantumCircuit,ClassicalRegister
    from qiskit_ibm_runtime.circuit import MidCircuitMeasure
    assert (variant,axis) in CASES
    full=variant!='Relative';n=3 if full else 2
    c=QuantumCircuit(n);out=ClassicalRegister(2,'out');c.add_register(out)
    for q in range(n):c.reset(q)
    if variant in ('Full11','WrongWrite11','Install11'):c.x(2);c.x(1)
    c.barrier()
    if axis=='Z':c.h(0)
    if axis=='X':c.h(0)
    if mid_measure:c.append(MidCircuitMeasure(),[0],[out[0]])
    else:c.measure(0,out[0])
    if axis=='X':c.h(0)
    c.barrier()
    if variant in ('WrongWrite11','Install11'):c.reset(2)
    if variant=='Install11':c.reset(1)
    with c.if_test((out[0],source['probes'][axis]['records'][1])):c.x(2 if full else 1)
    c.barrier();c.compose(tick(source,full),inplace=True);c.barrier()
    # One recipient for every implementation, fixed independently of variant.
    if axis=='Z':
        with c.if_test((out[0],0)):c.h(0)
        with c.if_test((out[0],1)):c.x(0)
    else:
        with c.if_test((out[0],1)):c.s(0);c.h(0)
    c.barrier();c.measure(0,out[1])
    c.metadata={'experiment':tag,'variant':variant,'probe':axis,'question':'record_conditioned_data_return',
                'source_sha256':source['source_sha256'],'logical_qubits':n,
                'source_mode':'Write' if variant=='WrongWrite11' else 'Install' if variant=='Install11' else 'Toggle',
                'scope':'These fixed classical PC preparations; D readout including selective disturbance. E is outside the declared continuation.'}
    return c


def signature(c):
    """Include nested bodies AND the actual classical condition operand."""
    def condition(op):
        bit,value=op.condition
        if hasattr(bit,'size'):bits=[c.find_bit(x).index for x in bit]
        else:bits=[c.find_bit(bit).index]
        return {'bits':bits,'value':int(value)}
    instructions=[]
    for ins in c.data:
        op=ins.operation
        item={'name':op.name,'qubits':[c.find_bit(q).index for q in ins.qubits],
              'clbits':[c.find_bit(q).index for q in ins.clbits]}
        if op.name=='if_else':item.update(condition=condition(op),blocks=[signature(b) for b in op.blocks])
        else:item['params']=[float(p) for p in op.params]
        instructions.append(item)
    return {'qubits':c.num_qubits,'clbits':c.num_clbits,'cregs':[(r.name,len(r)) for r in c.cregs],
            'global_phase':float(c.global_phase),'metadata':c.metadata,'instructions':instructions}


def manifest(c,wires):
    two=Counter();resets=Counter();measure={};conditions=[]
    def visit(c,qmap,cmap,inside=False):
        for ins in c.data:
            op=ins.operation;qs=[qmap[c.find_bit(q).index] for q in ins.qubits];cs=[cmap[c.find_bit(q).index] for q in ins.clbits]
            if op.name=='if_else':
                assert not inside
                bit,value=op.condition;assert not hasattr(bit,'size')
                operand=cmap[c.find_bit(bit).index];assert operand==0 and value in (0,1)
                conditions.append({'bit':operand,'value':int(value),'qubits':qs})
                for block in op.blocks:visit(block,qs,cs,True)
            elif op.name=='barrier':continue
            elif op.name in ('measure','measure_2'):
                assert not inside and len(qs)==len(cs)==1 and cs[0] not in measure
                measure[cs[0]]={'wire':qs[0],'instruction':op.name}
            elif op.name=='reset':assert not inside;resets[qs[0]]+=1
            elif len(qs)==2:
                assert op.name=='cz' and not inside;two[tuple(sorted(qs))]+=1
            else:assert len(qs)==1 and op.name in ('rz','sx','x','id','delay')
    visit(c,list(range(c.num_qubits)),list(range(c.num_clbits)))
    variant,axis=c.metadata['variant'],c.metadata['probe'];full=variant!='Relative'
    d,r,p=wires
    assert measure=={0:{'wire':d,'instruction':'measure_2'},1:{'wire':d,'instruction':'measure'}}
    expect=Counter({q:1 for q in wires[:3 if full else 2]})
    if variant in ('WrongWrite11','Install11'):expect[p]+=1
    if variant=='Install11':expect[r]+=1
    assert resets==expect
    assert len(conditions)==(3 if axis=='Z' else 2)
    assert conditions[0]=={'bit':0,'value':1,'qubits':[p if full else r]}
    assert all(x['qubits']==[d] for x in conditions[1:])
    assert set(two)<=set((tuple(sorted((d,r))),tuple(sorted((r,p)))))
    assert two[tuple(sorted((r,p)))]==(2 if full else 0)
    assert two[tuple(sorted((d,r)))]>0
    return {'entanglers':{','.join(map(str,k)):v for k,v in sorted(two.items())},'resets':dict(resets),
            'measurements':measure,'conditions':conditions,'recursive_signature_sha256':sha(json.dumps(signature(c),sort_keys=True).encode())}


def ideal(circuit):
    """Fixed two-branch audit using SDK channels, not an execution policy.

    The supplied b is only an enumeration variable for independent checking.
    The actual QPU circuit receives no such supplied b.
    """
    import numpy as np
    from qiskit.quantum_info import DensityMatrix,Kraus,SuperOp
    c=compact_active(circuit);result={}
    for b in (0,1):
        rho=DensityMatrix.from_label('0'*c.num_qubits);terminal=[];acquired=[]
        def visit(c,qmap,cmap):
            nonlocal rho
            for ins in c.data:
                op=ins.operation;qs=[qmap[c.find_bit(q).index] for q in ins.qubits];cs=[cmap[c.find_bit(q).index] for q in ins.clbits]
                if op.name=='barrier':continue
                if op.name=='if_else':
                    bit,value=op.condition;assert cmap[c.find_bit(bit).index]==0
                    index=0 if b==value else 1
                    if index<len(op.blocks):visit(op.blocks[index],qs,cs)
                elif op.name in ('measure','measure_2'):
                    if cs==[0]:
                        acquired.append(qs[0]);proj=np.zeros((2,2));proj[b,b]=1
                        rho=rho.evolve(Kraus([proj]),qargs=qs)
                    else:assert cs==[1];terminal.append(qs[0])
                else:rho=rho.evolve(SuperOp(op),qargs=qs)
        visit(c,list(range(c.num_qubits)),list(range(c.num_clbits)))
        assert len(acquired)==len(terminal)==1
        probs=rho.probabilities([terminal[0]])
        for o,p in enumerate(probs):result[f'{o}{b}']=float(p)
    assert abs(sum(result.values())-1)<1e-10
    return result


def layout(backend):
    target=backend.target;edges={};neighbors={i:set() for i in range(backend.num_qubits)}
    for pair,v in target['cz'].items():
        if pair is None or v is None or v.error is None:continue
        i,j=pair;edges[frozenset(pair)]=v.error;neighbors[i].add(j);neighbors[j].add(i)
    choices=[]
    for r in neighbors:
        for d in neighbors[r]:
            for p in neighbors[r]-{d}:
                wires=(d,r,p)
                if not target.instruction_supported(operation_name='measure_2',qargs=(d,)):continue
                if any(not target.instruction_supported(operation_name=g,qargs=(q,)) for q in wires for g in ('reset','measure')):continue
                errors=[target['measure'][(q,)].error for q in wires]
                if any(x is None for x in errors):continue
                score=8*edges[frozenset((d,r))]+2*edges[frozenset((r,p))]+sum(errors)
                choices.append((score,wires,errors))
    assert choices,'No supported adjacent dynamic three-wire path'
    score,wires,errors=min(choices)
    return list(wires),{'selection_score':score,'readout_errors':errors,
                        'cz_errors':[edges[frozenset(wires[:2])],edges[frozenset(wires[1:])]]}


def prepare(directory):
    import numpy as np
    from qiskit import transpile,qpy
    from qiskit.quantum_info import Operator
    from qiskit_ibm_runtime.utils.validations import validate_isa_circuits
    assert not directory.exists();source=current_source();impl=implementation()
    # Independent full and relative all-state tick identities.
    full=Operator(tick(source,True)).data
    expected=Operator(resident.circuit(source['interpreter'])).data
    assert np.max(abs(np.kron(full,algebra.Z)-expected))<1e-11
    small=resident.reduction(source['interpreter'],resident.closure(source['interpreter']))[2]
    assert np.max(abs(Operator(tick(source,False)).data-small))<1e-11
    service=service_open();usage=service.usage();assert usage['usage_remaining_seconds']>=MAX_SECONDS
    backend=service.backend('ibm_kingston');assert backend.status().operational
    wires,cal=layout(backend);tag='vi-resident-feedback-'+uuid.uuid4().hex
    logicals=[logical(source,*CASES[i],tag) for i in ORDER]
    isa=[transpile(c,backend,initial_layout=wires[:c.num_qubits],optimization_level=0,routing_method='none',seed_transpiler=649315) for c in logicals]
    validate_isa_circuits(isa,backend.target)
    manifests=[manifest(c,wires) for c in isa];local=[]
    for before,after in zip(logicals,isa):
        x,y=ideal(before),ideal(after);assert max(abs(x[k]-y[k]) for k in x)<1e-10
        passed=sum(p for k,p in y.items() if k[0]=='0');expected=.5 if before.metadata['variant']=='WrongWrite11' else 1.
        assert abs(passed-expected)<1e-10
        assert abs(sum(p for k,p in y.items() if k[1]=='0')-.5)<1e-10
        local.append({'variant':before.metadata['variant'],'probe':before.metadata['probe'],'ideal_probabilities':y})
    assert implementation()==impl
    directory.mkdir(parents=True);buf=io.BytesIO();qpy.dump(isa,buf);raw=buf.getvalue();(directory/'isa.qpy').write_bytes(raw)
    snapshots={}
    for n,h in {**impl,**source['source_sha256']}.items():
        relative=n if not Path(n).is_absolute() else 'external/'+Path(n).name
        p=directory/'source'/relative;p.parent.mkdir(parents=True,exist_ok=True)
        data=(ROOT/n).read_bytes();assert sha(data)==h;p.write_bytes(data);snapshots[str(p.relative_to(directory))]=h
    write(directory/'source-reading.json',source)
    plan={'schema':'vi.ibm.resident-feedback.v1','created_at':utc(),'tag':tag,'backend':backend.name,
          'instance':service.active_instance(),'instance_plan':'open','shots':SHOTS,'max_seconds':MAX_SECONDS,
          'physical_D_R_P':wires,'calibration_selection':cal,'usage_before':usage,'cases':list(CASES),'order':ORDER,
          'manifests':manifests,'implementation':impl,'versions':versions(),'source_sha256':source['source_sha256'],
          'snapshots':snapshots,'qpy_sha256':sha(raw),'source_reading_sha256':sha((directory/'source-reading.json').read_bytes()),
          'analysis':{'alpha':ALPHA,'questions':list(QUESTIONS),'no_postselection':True,'no_adaptive_repeats':True},'options':options(tag)}
    write(directory/'plan.json',plan);write(directory/'ideal-validation.json',local)
    return {'prepared':True,'physical_D_R_P':wires,'circuits':len(isa),'shots':len(isa)*SHOTS,'max_free_QPU_seconds':MAX_SECONDS}


def load(directory,current=False):
    from qiskit import qpy
    p=read(directory/'plan.json');assert p['schema']=='vi.ibm.resident-feedback.v1'
    assert p['shots']==SHOTS and p['max_seconds']==MAX_SECONDS and p['cases']==[list(x) for x in CASES] and p['order']==ORDER
    assert p['instance_plan']=='open' and p['backend']=='ibm_kingston' and p['options']==options(p['tag'])
    assert p['analysis']=={'alpha':ALPHA,'questions':list(QUESTIONS),'no_postselection':True,'no_adaptive_repeats':True}
    for name,h in p['snapshots'].items():assert sha((directory/name).read_bytes())==h
    assert p['qpy_sha256']==sha((directory/'isa.qpy').read_bytes()) and p['source_reading_sha256']==sha((directory/'source-reading.json').read_bytes())
    if current:assert p['implementation']==implementation() and p['versions']==versions() and read(directory/'source-reading.json')==current_source()
    circuits=qpy.load(io.BytesIO((directory/'isa.qpy').read_bytes()));assert len(circuits)==len(CASES)
    for c,i,m in zip(circuits,ORDER,p['manifests']):
        assert (c.metadata['variant'],c.metadata['probe'])==CASES[i] and c.metadata['experiment']==p['tag']
        assert json.loads(json.dumps(manifest(c,p['physical_D_R_P'])))==m
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
        ledger={'tag':p['tag'],'qpy_sha256':p['qpy_sha256'],'status':'intent','at':utc()};write(file,ledger)
        job=sampler.run(circuits,shots=SHOTS);ledger.update(status='submitted',job_id=job.job_id());write(file,ledger);return ledger


def analyse(rows):
    assert {(r['variant'],r['probe']) for r in rows}==set(CASES) and len(rows)==len(CASES)
    radius=math.sqrt(math.log(2*len(CASES)*len(QUESTIONS)/ALPHA)/(2*SHOTS));answer={}
    for row in rows:
        counts=row['counts'];assert row['shots']==SHOTS and sum(counts.values())==SHOTS
        assert all(len(k)==2 and set(k)<=set('01') and type(v)is int and v>=0 for k,v in counts.items())
        numbers={'pass':sum(v for k,v in counts.items() if k[0]=='0'),
                 'record_zero':sum(v for k,v in counts.items() if k[1]=='0'),
                 **{'joint_'+k:counts.get(k,0) for k in ('00','01','10','11')}}
        answer[row['variant']+':'+row['probe']]={q:{'count':n,'frequency':n/SHOTS,
            'simultaneous_interval':[max(0,n/SHOTS-radius),min(1,n/SHOTS+radius)]} for q,n in numbers.items()}
    comparisons={}
    for axis in ('X','Z'):
        wrong=answer['WrongWrite11:'+axis]['pass']['simultaneous_interval']
        for v in ('Full00','Full11','Relative','Install11'):
            ok=answer[v+':'+axis]['pass']['simultaneous_interval']
            comparisons[v+':'+axis]=[ok[0]-wrong[1],ok[1]-wrong[0]]
    return {'cases':answer,'correct_minus_wrong_intervals':comparisons,'simultaneous_radius':radius,'alpha':ALPHA,
            'all_correct_minus_wrong_lower_positive':all(x[0]>0 for x in comparisons.values()),
            'statistical_question':'Average conditional event probabilities during these performed shots, including SPAM and feedback. No fixed-law, future-shot or full-channel identity claim.'}


def collect(directory):
    from qiskit_ibm_runtime import RuntimeEncoder
    p,circuits=load(directory);ledger=read(directory/'ledger.json')
    assert ledger['tag']==p['tag'] and ledger['qpy_sha256']==p['qpy_sha256']
    service=service_open();assert service.active_instance()==p['instance'];job=service.job(ledger['job_id'])
    assert job.job_id()==ledger['job_id'] and p['tag'] in job.tags and job.backend().name==p['backend']
    state=job.status()
    if state!='DONE':
        result={'job_id':job.job_id(),'status':state}
        if state in ('ERROR','CANCELLED'):result['error']=job.error_message()
        write(directory/'status.json',result);return result
    pubs=job.inputs['pubs'];assert len(pubs)==len(circuits)
    for pub,circuit in zip(pubs,circuits):
        remote=pub[0] if isinstance(pub,(list,tuple)) else pub.circuit
        assert signature(remote)==signature(circuit)
    result=job.result();assert len(result)==len(circuits)
    (directory/'raw-result.json').write_text(json.dumps(result,cls=RuntimeEncoder,indent=2))
    rows=[]
    for pub,c in zip(result,circuits):
        assert pub.metadata.get('circuit_metadata')==c.metadata and set(pub.data.keys())=={'out'}
        bits=pub.data.out;assert bits.num_shots==SHOTS and bits.num_bits==2 and bits.shape==()
        rows.append({'variant':c.metadata['variant'],'probe':c.metadata['probe'],'shots':SHOTS,'counts':dict(bits.get_counts())})
    report={'job_id':job.job_id(),'status':'DONE','backend':p['backend'],'collected_at':utc(),'rows':rows,
            'analysis':analyse(rows),'metrics':job.metrics(),'usage_after':service.usage(),
            'raw_sha256':sha((directory/'raw-result.json').read_bytes()),'collector_sha256':implementation()}
    write(directory/'hardware-result.json',report);write(directory/'status.json',{'job_id':job.job_id(),'status':'DONE'})
    return {'job_id':job.job_id(),'status':'DONE','analysis':report['analysis'],'usage_after':report['usage_after']}


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('stage',choices=['prepare','submit','collect']);p.add_argument('--output',type=Path,required=True)
    args=p.parse_args();d=args.output.resolve()
    if args.stage=='prepare':result=prepare(d)
    elif args.stage=='submit':plan,circuits=load(d,True);result=send_once(d,service_open(),plan,circuits)
    else:result=collect(d)
    print(json.dumps(result,indent=2))
