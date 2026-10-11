#!/usr/bin/env python3
"""Small free-Open compiler/control probe; not a VI channel confirmation.

Two known probe inputs. The actual measurement is saved in a Boolean and a
two-bit code; two retained zero targets are flipped from those saved readings.
Every submission has a durable intent; uncertain submission is never repeated.
"""
import argparse
import fcntl
import io
import json
from pathlib import Path
import uuid

from qiskit import QuantumCircuit, ClassicalRegister, qpy
from qiskit.circuit import Measure
from qiskit.circuit.classical import expr
from qiskit_aer import AerSimulator
from qiskit_ibm_runtime import SamplerV2, RuntimeEncoder
from qiskit_ibm_runtime.circuit import MidCircuitMeasure
from qiskit_ibm_runtime.utils.validations import validate_isa_circuits

from pilot import service_open, compact_active, sha, utc, versions, require
from resident_joint_confirmation import canonical_mcm, validate_mcm

ROOT = Path(__file__).resolve().parents[2]
ART = ROOT/'Research/Artifacts/classical-boundary-probe-20260916'
SHOTS, CAP = 128, 30


def read(p): return json.loads(p.read_text())
def write(p,v): p.write_text(json.dumps(v,indent=2)+'\n')


def logical(bit):
    q = QuantumCircuit(3)
    raw, saved, code, out = (ClassicalRegister(1,'raw'),ClassicalRegister(1,'saved'),
                             ClassicalRegister(2,'code'),ClassicalRegister(3,'out'))
    q.add_register(raw,saved,code,out)
    q.reset([0,1,2])
    if bit: q.x(0)
    q.append(MidCircuitMeasure(),[0],[raw[0]])
    q.store(saved[0],expr.bit_xor(raw[0],True))
    q.store(code,0)
    with q.if_test((saved[0],1)):
        q.id(0)
        q.store(code,2)
    with q.if_test((saved[0],1)): q.x(1)
    with q.if_test(expr.logic_and(expr.equal(code,2),expr.equal(raw[0],False))): q.x(2)
    q.store(out[0],raw[0])
    q.measure(1,out[1]);q.measure(2,out[2])
    return q


def aer_form(q):
    out=q.copy_empty_like()
    for item in q.data:
        op=item.operation
        if op.name=='measure_2':validate_mcm(op);op=Measure()
        elif op.name=='if_else':op=op.replace_blocks([aer_form(b) for b in op.blocks])
        out.append(op,item.qubits,item.clbits)
    return out


def local(q,bit):
    q=aer_form(compact_active(q))
    r=AerSimulator().run(q,shots=32,memory=True,seed_simulator=216).result()
    require(r.success,'Local probe failed')
    regs={x.name:x for x in q.cregs}
    for memory in r.get_memory():
        value=int(memory.replace(' ',''),2)
        def number(reg):return sum(((value>>q.find_bit(b).index)&1)<<i for i,b in enumerate(regs[reg]))
        require(number('raw')==bit and number('out')==(1 if bit else 6) and
                number('saved')==1-bit and number('code')==2*(1-bit),'Probe truth table changed')
    return {'shots':32,'forced_input':bit,'expected_out':'001' if bit else '110'}


def options(tag):
    return {'default_shots':SHOTS,'max_execution_time':CAP,'environment':{'job_tags':[tag]},
            'execution':{'init_qubits':True},'twirling':{'enable_gates':False,'enable_measure':False},
            'dynamical_decoupling':{'enable':False},'experimental':{'execution':{'scheduler_timing':True}}}


def engine():
    names=[Path(__file__),ROOT/'Checks/IBMBridge/pilot.py',ROOT/'Checks/IBMBridge/resident_joint_confirmation.py']
    return {str(p.relative_to(ROOT)):sha(p.read_bytes()) for p in names}


def prepare(directory):
    require(not (directory/'plan.json').exists(),'Plan already frozen')
    service=service_open();backend=service.backend('ibm_kingston');target=backend.target
    ranked=[]
    for i in range(backend.num_qubits):
        if i==16:continue
        records=[target[name].get((i,)) for name in ('measure','measure_2','reset','x','id')]
        if any(v is None for v in records):continue
        error=records[0].error
        if error is not None:ranked.append((error,i))
    require(len(ranked)>=3,'No three supported probe ports')
    ports=[i for _,i in sorted(ranked)[:3]]
    tag='vi-classical-boundary-'+uuid.uuid4().hex[:12]
    circuits=[];checks=[]
    for bit in (0,1):
        core=logical(bit);check=local(core,bit)
        q=QuantumCircuit(backend.num_qubits)
        for reg in core.cregs:q.add_register(reg)
        q.compose(core,qubits=ports,inplace=True)
        q.metadata={'tag':tag,'input_bit':bit,'ports':ports,
                    'scope':'Boolean and Uint Store admission/control; not a general continuation or device certificate.'}
        validate_isa_circuits([q],target)
        buf=io.BytesIO();qpy.dump(q,buf);buf.seek(0);restored,=qpy.load(buf)
        require(canonical_mcm(restored)==canonical_mcm(q),'QPY changed the probe')
        local(restored,bit);circuits.append(q);checks.append(check)
    directory.mkdir(parents=True,exist_ok=True);ART.mkdir(exist_ok=True)
    with (directory/'isa.qpy').open('wb') as f:qpy.dump(circuits,f)
    plan={'schema':'vi.classical-boundary-probe.v1','at':utc(),'tag':tag,'backend':backend.name,
          'instance':service.active_instance(),'ports':ports,'shots_each':SHOTS,'cap':CAP,
          'options':options(tag),'versions':versions(),'engine':engine(),
          'qpy_sha256':sha((directory/'isa.qpy').read_bytes()),'local_checks':checks,
          'analysis':'Return all raw/out counts per input; score out=001 for raw=1 and out=110 for raw=0. '
                     'Also show forced-input agreement separately. No postselection, IID claim, or automatic retry.'}
    write(directory/'plan.json',plan);write(ART/'plan.json',{k:v for k,v in plan.items() if k!='instance'})
    return {'prepared':True,'ports':ports,'PUBs':2,'total_shots':2*SHOTS,'free_Open_seconds_cap':CAP,'local':checks}


def load(directory):
    p=read(directory/'plan.json')
    require(p['schema']=='vi.classical-boundary-probe.v1' and p['shots_each']==SHOTS and p['cap']==CAP
            and p['options']==options(p['tag']) and p['engine']==engine() and p['versions']==versions(),
            'Frozen probe contract changed')
    require(sha((directory/'isa.qpy').read_bytes())==p['qpy_sha256'],'Frozen bytes changed')
    with (directory/'isa.qpy').open('rb') as f:qs=qpy.load(f)
    require(len(qs)==2 and all(q.metadata['tag']==p['tag'] and q.metadata['input_bit']==i
            for i,q in enumerate(qs)),'Wrong probe occurrences')
    return p,qs


def submit(directory):
    p,qs=load(directory);s=service_open();require(s.active_instance()==p['instance'],'Another instance')
    with (directory/'submit.lock').open('a') as lock:
        fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
        path=directory/'ledger.json'
        if path.exists():
            ledger=read(path)
            require(ledger['tag']==p['tag'] and ledger['qpy_sha256']==p['qpy_sha256'],'Another intent')
            require(ledger.get('job_id'),'Uncertain prior submission: no automatic retry')
            return ledger
        backend=s.backend(p['backend']);st=backend.status()
        require(st.operational and st.status_msg=='active','Backend not active')
        require(s.usage()['usage_remaining_seconds']>=CAP,'Insufficient free quota')
        validate_isa_circuits(qs,backend.target)
        ledger={'tag':p['tag'],'qpy_sha256':p['qpy_sha256'],'at':utc(),'status':'intent'}
        write(path,ledger)
        job=SamplerV2(mode=backend,options=p['options']).run(qs,shots=SHOTS)
        ledger.update(job_id=job.job_id(),status='submitted');write(path,ledger);write(ART/'submission.json',ledger)
        return ledger


def collect(directory):
    p,qs=load(directory);ledger=read(directory/'ledger.json');s=service_open()
    require(s.active_instance()==p['instance'],'Another instance')
    job=s.job(ledger['job_id']);require(p['tag'] in job.tags and job.backend().name==p['backend'],'Another job')
    state=job.status();result={'job_id':job.job_id(),'status':state,'at':utc()}
    if state in ('ERROR','CANCELLED'):result['error']=job.error_message()
    if state=='DONE':
        data=job.result();write(directory/'raw-result.json',json.loads(json.dumps(data,cls=RuntimeEncoder)))
        require(len(data)==2,'Wrong PUB coverage');rows=[]
        for i,(pub,q,entry) in enumerate(zip(data,qs,job.inputs['pubs'])):
            remote=entry[0] if isinstance(entry,(tuple,list)) else entry.circuit
            require(canonical_mcm(remote)==canonical_mcm(q) and pub.metadata['circuit_metadata']==q.metadata,
                    'Returned program or record origin changed')
            raw,out=pub.data.raw.get_bitstrings(),pub.data.out.get_bitstrings()
            require(len(raw)==len(out)==SHOTS,'Missing shots')
            pairs={}
            for b,v in zip(raw,out):pairs[b+' '+v]=pairs.get(b+' '+v,0)+1
            rows.append({'input_bit':i,'counts':pairs,'shots':SHOTS,
                         'relation_correct':sum(v==('001' if b=='1' else '110') for b,v in zip(raw,out)),
                         'forced_input_correct':sum(int(b)==i for b in raw)})
        result.update(rows=rows,metrics=job.metrics(),raw_sha256=sha((directory/'raw-result.json').read_bytes()))
    write(directory/'status.json',result);write(ART/'status.json',result)
    return result


if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('stage',choices=['prepare','submit','collect']);p.add_argument('--output',type=Path,required=True)
    args=p.parse_args();print(json.dumps(globals()[args.stage](args.output.resolve()),indent=2))
