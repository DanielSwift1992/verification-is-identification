#!/usr/bin/env python3
"""One small Open-only common-endpoint experiment; no automatic resubmission.

The existing VI source and joint compiler select the operation. This adapter
expands one declared service, lowers it to a five-site path, checks the actual
instrument, and observes the retained D/reference only after the recipient.
"""
import argparse
from collections import Counter
import fcntl
import io
import itertools
import json
from pathlib import Path
import sys
import uuid

import numpy as np
from qiskit import ClassicalRegister, QuantumCircuit, qpy, transpile
from qiskit.circuit import Instruction
from qiskit.circuit.classical import expr
from qiskit.quantum_info import Operator, Pauli
from qiskit_ibm_runtime import RuntimeEncoder, SamplerV2
from qiskit_ibm_runtime.circuit import MidCircuitMeasure
from qiskit_ibm_runtime.utils.validations import validate_isa_circuits

HERE=Path(__file__).resolve().parent; ROOT=HERE.parents[1]
sys.path.insert(0,str(ROOT/'Checks/FiniteContinuation'))
from pilot import service_open, sha, utc, versions
import resident_goal_synthesis as s
import resident_joint_goals as joint
import resident_joint_goals_sdk as sdk
import resident_flat_controller as flat
from resident_raw_reply_checks import fixture
from resident_goal_instrument_audit import interpret, expand

ART=ROOT/'Research/Artifacts/resident-common-endpoint-hardware-20260915'
SEALED=ROOT/'Research/Artifacts/resident-common-endpoint-20260915/receipt.json'
SHOTS=256; MAX_SECONDS=30
ORDER=('correct','ignore','ignore','correct')
SEED=150918
WEIGHTS=(1,1,1,-1)


def dump(path,value): path.write_text(json.dumps(value,indent=2)+'\n')
def read(path): return json.loads(path.read_text())


def implementation():
    prior=read(SEALED)
    for name,digest in {**prior['sha256'],**prior['engine_sha256']}.items():
        p=ROOT/name
        s.require(sha(p.read_bytes())==digest,'Sealed dependency changed: '+name)
    return {**prior['sha256'],**prior['engine_sha256'],
            str(Path(__file__).relative_to(ROOT)):sha(Path(__file__).read_bytes()),
            'Checks/IBMBridge/pilot.py':sha((HERE/'pilot.py').read_bytes())}


def logical(variant):
    s.require(variant in ('correct','ignore'),'Unknown experiment variant')
    source=s.reading();service,_,_=fixture(1.3,-.8)
    receiver=[0,0,0,1] if variant=='correct' else [0,0,0,0]
    request=joint.request(source,[[(m>>i)&1 for i in range(8)] for m in (254,239)],'exit',receiver)
    q,info=sdk.build(source,service,request,memory='first')
    sdk.admit(source,service,request,q,memory='first')
    body=QuantumCircuit(3);body.ry(1.3,0);body.cx(1,0);body.cz(0,2);body.ry(-.8,1);body.cx(2,1)
    s.require(np.max(abs(Operator(body).data-service.to_matrix()))<1e-13,'Not the declared service')
    def lower(c):
        out=c.copy_empty_like()
        for item in c.data:
            op=item.operation
            if op.name=='unitary':
                s.require(np.max(abs(op.to_matrix()-service.to_matrix()))<1e-13,'Different opaque service')
                out.compose(body,qubits=item.qubits,inplace=True)
            elif op.name=='if_else':out.append(op.replace_blocks([lower(b) for b in op.blocks]),item.qubits,item.clbits)
            else:out.append(item)
        return out
    return q,lower(q),source,info


def native_instrument(circuit,final_wires):
    """Bounded independent reader of actual five-wire ISA, including routing.

    Retains every unnormalised branch map on arbitrary incoming M,E,D,REF.
    Grouping by returned tuple forgets private paths and branch global phases.
    """
    s.require(circuit.num_qubits==5 and sorted(final_wires)==list(range(5)),'Wrong five-wire boundary')
    initial=np.zeros((32,16),complex);initial[::2]=np.eye(16)
    branches=[(initial,[0]*circuit.num_clbits)];cache={}
    def variable(v,bits):
        if isinstance(v,ClassicalRegister):return sum(bits[circuit.find_bit(b).index]<<i for i,b in enumerate(v))
        return bits[circuit.find_bit(v).index]
    def value(v,bits):
        if isinstance(v,expr.Value):return v.value
        if isinstance(v,expr.Var):return variable(v.var,bits)
        if isinstance(v,expr.Binary):
            x,y=value(v.left,bits),value(v.right,bits)
            if v.op.name=='BIT_XOR':return x^y
            if v.op.name=='EQUAL':return x==y
            if v.op.name=='LOGIC_AND':return bool(x) and bool(y)
        raise ValueError('Uninterpreted classical expression')
    def assign(v,x,bits):
        if isinstance(v,ClassicalRegister):
            s.require(0<=int(x)<2**len(v),'Store overflow')
            for i,b in enumerate(v):bits[circuit.find_bit(b).index]=(int(x)>>i)&1
        else:bits[circuit.find_bit(v).index]=int(bool(x))
    def visit(c,active,qmap,cmap):
        for item in c.data:
            op=item.operation;name=op.name
            qs=[qmap[c.find_bit(b).index] for b in item.qubits]
            cs=[cmap[c.find_bit(b).index] for b in item.clbits]
            if name=='if_else':
                out=[]
                for matrix,bits in active:
                    yes=(variable(op.condition[0],bits)==op.condition[1]) if isinstance(op.condition,tuple) else bool(value(op.condition,bits))
                    k=0 if yes else 1
                    out.extend(visit(op.blocks[k],[(matrix,bits)],qs,cs) if k<len(op.blocks) else [(matrix,bits)])
                active=out
            elif name=='store':
                for _,bits in active:assign(op.lvalue.var,value(op.rvalue,bits),bits)
            elif name=='barrier':continue
            elif name in ('reset','measure','measure_2'):
                if name=='measure_2':validate_mcm(op)
                out=[]
                for matrix,bits in active:
                    for bit in (0,1):
                        local=np.zeros((2,2),complex);local[0 if name=='reset' else bit,bit]=1
                        mapped=expand(local,qs)@matrix
                        if np.linalg.norm(mapped)<1e-13:continue
                        record=list(bits)
                        if name!='reset':record[cs[0]]=bit
                        out.append((mapped,record))
                active=out
            else:
                s.require(name in ('rz','sx','x','id','cz'),'Unknown ISA operation '+name)
                key=(name,tuple(qs),tuple(map(float,op.params)))
                if key not in cache:cache[key]=expand(Operator(op).data,qs)
                active=[(cache[key]@matrix,bits) for matrix,bits in active]
        return active
    branches=visit(circuit,branches,list(range(5)),list(range(circuit.num_clbits)))
    rowmap=[sum(((j>>i)&1)<<wire for i,wire in enumerate(final_wires)) for j in range(32)]
    returned=next(r for r in circuit.cregs if r.name=='joint_answers')
    result={i:np.zeros((256,256),complex) for i in range(4)}
    for matrix,bits in branches:
        matrix=matrix[rowmap]
        s.require(np.max(abs(matrix[1::2]))<1e-11,'Discarded probe not returned at the actual boundary')
        v=matrix[::2].reshape(-1);code=variable(returned,bits)
        result[code]+=np.outer(v,v.conj())
    return result,len(branches)


def expected_instrument(q):
    result={i:np.zeros((256,256),complex) for i in range(4)}
    rho={i:np.zeros((16,16),complex) for i in range(4)}
    for b in interpret(q):
        code=sum(e['bit']<<e['goal'] for e in b['events'] if e['kind']=='answer')
        k=b['map'][::2];v=k.reshape(-1);result[code]+=np.outer(v,v.conj())
        rho[code]+=np.outer(k[:,0],k[:,0].conj())
    return result,rho


def lower_core(logical):
    c=transpile(logical,basis_gates=['rz','sx','x','id','cz','reset'],
        coupling_map=[[i,j] for i in range(5) for j in range(5) if abs(i-j)==1],
        initial_layout=list(range(5)),layout_method='trivial',routing_method='sabre',
        optimization_level=1,seed_transpiler=SEED,num_processes=1)
    return c,c.layout.final_index_layout()


def mcm(c):
    out=c.copy_empty_like()
    for item in c.data:
        op=item.operation
        if op.name=='measure':out.append(MidCircuitMeasure(label=op.label),item.qubits,item.clbits)
        elif op.name=='if_else':out.append(op.replace_blocks([mcm(b) for b in op.blocks]),item.qubits,item.clbits)
        else:out.append(item)
    return out


def validate_mcm(op):
    # QPY loads the documented backend instruction as a bare Instruction.
    # Admit this exact external opcode, never an embedded alternate body.
    s.require(type(op) in (MidCircuitMeasure,Instruction) and op.name=='measure_2'
        and op.num_qubits==op.num_clbits==1 and not op.params and op.definition is None,
        'Unrecognised MCM semantics')


def canonical_mcm(c):
    out=c.copy_empty_like()
    for item in c.data:
        op=item.operation
        if op.name=='measure_2':validate_mcm(op);op=MidCircuitMeasure(label=op.label)
        elif op.name=='if_else':op=op.replace_blocks([canonical_mcm(b) for b in op.blocks])
        out.append(op,item.qubits,item.clbits)
    return out


def add_witness(core,final):
    # Pauli word YXII in Qiskit order REF,D,E,M. D is measured in X,
    # REF in Y. No M/E measurement and no preparation of a replacement D.
    q=core.copy();out=ClassicalRegister(2,'witness');q.add_register(out)
    tail=QuantumCircuit(5);tail.h(final[3]);tail.sdg(final[4]);tail.h(final[4])
    tail=transpile(tail,basis_gates=['rz','sx','x','id','cz'],optimization_level=0)
    q.compose(tail,inplace=True);q.measure(final[3],out[0]);q.measure(final[4],out[1])
    return q


def inventory(c):
    counts=Counter()
    def walk(c):
        for item in c.data:
            counts[item.operation.name]+=1
            for b in getattr(item.operation,'blocks',()):walk(b)
    walk(c)
    return dict(counts)


def choose_path(backend):
    # A connected five-site path suffices; no routing outside these sites.
    target=backend.target;cz=target['cz'];neighbors={i:set() for i in range(backend.num_qubits)}
    for x,y in cz:neighbors[x].add(y);neighbors[y].add(x)
    choices=[]
    def grow(path):
        if len(path)==5:
            errors=[]
            for x in path:
                for name in ('measure','measure_2','sx','x','rz','reset'):
                    if name not in target.operation_names or (x,) not in target[name]:return
                errors.append(target['measure'][(x,)].error or 0.)
            for x,y in zip(path,path[1:]):
                if (x,y) not in cz or (y,x) not in cz:return
                errors.append(max(cz[(x,y)].error or 0.,cz[(y,x)].error or 0.))
            choices.append((sum(errors),tuple(path)));return
        for n in sorted(neighbors[path[-1]]-set(path)):grow(path+[n])
    for i in range(backend.num_qubits):grow([i])
    s.require(choices,'No admitted five-site path')
    score,path=min(choices)
    return list(path),score


def place(c,path,n):
    q=QuantumCircuit(n)
    for reg in c.cregs:q.add_register(reg)
    q.compose(c,qubits=path,inplace=True);q.metadata=c.metadata
    return q


def options(tag):
    return {'default_shots':SHOTS,'max_execution_time':MAX_SECONDS,
        'environment':{'job_tags':[tag]},'execution':{'init_qubits':True},
        'twirling':{'enable_gates':False,'enable_measure':False},
        'dynamical_decoupling':{'enable':False}}


def prepare(directory):
    s.require(not (directory/'plan.json').exists(),'Frozen plan exists')
    directory.mkdir(parents=True,exist_ok=True);ART.mkdir(exist_ok=True)
    files=implementation();service=service_open();backend=service.backend('ibm_kingston')
    path,score=choose_path(backend);tag='vi-common-endpoint-'+uuid.uuid4().hex[:12]
    cores={};circuits={};rows=[]
    for variant in ('correct','ignore'):
        original,expanded,source,info=logical(variant)
        expected,rho=expected_instrument(original)
        core,final=lower_core(expanded);core=mcm(core)
        actual,branches=native_instrument(core,final)
        error=max(float(np.max(abs(actual[k]-expected[k]))) for k in expected)
        s.require(error<1e-10,'ISA changed the complete returned-tuple instrument')
        q=add_witness(core,final)
        q.metadata={'experiment':tag,'variant':variant,'source_sha256':source['source_sha256'],
            'query':original.metadata['query'],'physical_path':path,'final_logical_to_path':final,
            'question':'Signed X_D Y_REF using the actually measured joint tuple',
            'scope':'One declared source fixture, First memory, one common exit, retained data until final witness.'}
        q=place(q,path,backend.num_qubits);flat.check_flat_fragment(q,allow_unitary=False)
        validate_isa_circuits([q],backend.target)
        buf=io.BytesIO();qpy.dump(q,buf);buf.seek(0);loaded,=qpy.load(buf)
        s.require(canonical_mcm(loaded)==canonical_mcm(q) and loaded.metadata==q.metadata,'QPY changed the candidate')
        circuits[variant]=q;cores[variant]=core
        dump(ART/(variant+'-metadata.json'),q.metadata)
        (ART/(variant+'-isa.qpy')).write_bytes(buf.getvalue())
        with (ART/(variant+'-core.qpy')).open('wb') as f:qpy.dump(core,f)
        p=Pauli('YXII').to_matrix()
        mean=sum(WEIGHTS[k]*float(np.trace(p@rho[k]).real) for k in rho)
        rows.append({'variant':variant,'full_instrument_max_residual':error,'branches':branches,
            'ideal_mean':mean,'tuple_probabilities':[float(np.trace(rho[k]).real) for k in range(4)],
            'core_static_instruction_inventory':inventory(core),'final_logical_to_path':final})
    selected=[circuits[v] for v in ORDER]
    with (directory/'isa.qpy').open('wb') as f:qpy.dump(selected,f)
    plan={'schema':'vi.ibm.common-endpoint-confirmation.v1','at':utc(),'tag':tag,
        'backend':backend.name,'instance':service.active_instance(),'instance_plan':'open',
        'path':path,'path_error_score_for_selection_only':score,'source_sha256':source['source_sha256'],
        'qpy_sha256':sha((directory/'isa.qpy').read_bytes()),'implementation':files,'versions':versions(),
        'shots':SHOTS,'max_execution_seconds':MAX_SECONDS,'order':list(ORDER),'options':options(tag),
        'ideal':rows,'analysis':{'weights_by_tuple_code':list(WEIGHTS),'witness_bit_order':['D_X','REF_Y'],
            'sample':'All shots. No postselection, no hidden-path conditioning.',
            'contrast':'Mean(correct) minus mean(ignore), with per-PUB descriptive counts.',
            'interpretation':'Exploratory hardware contrast for the specified complete programs. No IID, stationarity, device diagnosis or future guarantee inferred.',
            'success_is_not':'Server acceptance, QPY round-trip and ideal equality are not hardware fidelity.'}}
    dump(directory/'plan.json',plan)
    public={k:v for k,v in plan.items() if k!='instance'}
    dump(ART/'plan.json',public);dump(ART/'compile-audit.json',rows)
    return {'prepared':True,'at':plan['at'],'path':path,'ideal':rows,'pubs':4,'shots_each':SHOTS,'free_seconds_cap':MAX_SECONDS}


def load(directory):
    p=read(directory/'plan.json')
    s.require(p['schema']=='vi.ibm.common-endpoint-confirmation.v1' and p['instance_plan']=='open' and
        p['shots']==SHOTS and p['max_execution_seconds']==MAX_SECONDS and p['order']==list(ORDER)
        and p['backend']=='ibm_kingston' and p['options']==options(p['tag']),'Wrong pilot contract')
    s.require(sha((directory/'isa.qpy').read_bytes())==p['qpy_sha256'],'Frozen circuit bytes changed')
    with (directory/'isa.qpy').open('rb') as f:cs=qpy.load(f)
    s.require(len(cs)==4,'Wrong circuit cardinality')
    for c,v in zip(cs,ORDER):s.require(c.metadata['variant']==v and c.metadata['experiment']==p['tag'],'Wrong PUB identity')
    return p,cs


def submit(directory):
    p,cs=load(directory)
    s.require(p['implementation']==implementation() and p['versions']==versions(),'Implementation changed since freeze')
    s.require(s.reading()['source_sha256']==p['source_sha256'],'Current VI root changed')
    service=service_open();s.require(service.active_instance()==p['instance'],'Wrong Open instance')
    with (directory/'submit.lock').open('a') as lock:
        fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB);file=directory/'ledger.json'
        if file.exists():
            ledger=read(file)
            s.require(ledger['tag']==p['tag'] and ledger['qpy_sha256']==p['qpy_sha256'],'Wrong ledger')
            if ledger.get('job_id'):return ledger
            jobs=service.jobs(limit=2,job_tags=[p['tag']])
            s.require(len(jobs)==1,'Uncertain submission; never automatically retry')
            ledger.update(job_id=jobs[0].job_id(),status='recovered');dump(file,ledger);return ledger
        backend=service.backend(p['backend']);st=backend.status()
        if not st.operational or st.status_msg!='active':
            return {'submitted':False,'reason':'backend not active','status':st.status_msg,'at':utc()}
        s.require(service.usage()['usage_remaining_seconds']>=MAX_SECONDS,'Insufficient free quota')
        validate_isa_circuits(cs,backend.target)
        sampler=SamplerV2(mode=backend,options=p['options'])
        ledger={'tag':p['tag'],'qpy_sha256':p['qpy_sha256'],'status':'intent','at':utc()}
        dump(file,ledger)
        job=sampler.run(cs,shots=SHOTS)
        ledger.update(job_id=job.job_id(),status='submitted');dump(file,ledger)
        dump(ART/'submission.json',ledger)
        return ledger


def read_samples(data):
    s.require('joint_answers' in data.keys() and 'witness' in data.keys(),'Actual result registers absent')
    answers=data.joint_answers;witness=data.witness
    s.require(answers.num_bits==witness.num_bits==2 and answers.num_shots==witness.num_shots==SHOTS
              and answers.shape==witness.shape==(),'Returned sample dimensions changed')
    counts=Counter(zip(answers.get_bitstrings(),witness.get_bitstrings()))
    s.require(sum(counts.values())==SHOTS,'Missing shots')
    signed=0
    for (a,w),n in counts.items():
        s.require(len(a)==len(w)==2 and set(a+w)<={'0','1'},'Malformed result bits')
        signed+=n*WEIGHTS[int(a,2)]*(-1 if w.count('1')%2 else 1)
    return {'counts':{a+' '+w:n for (a,w),n in sorted(counts.items())},'mean':signed/SHOTS,
            'shots':SHOTS,'tuple_00_count':sum(n for (a,w),n in counts.items() if a=='00')}


def collect(directory):
    p,cs=load(directory);ledger=read(directory/'ledger.json')
    s.require(ledger['tag']==p['tag'] and ledger['qpy_sha256']==p['qpy_sha256'],'Wrong submitted bytes')
    service=service_open();s.require(service.active_instance()==p['instance'],'Wrong instance')
    job=service.job(ledger['job_id']);state=job.status()
    s.require(p['tag'] in job.tags and job.backend().name==p['backend'],'Wrong hardware occurrence')
    summary={'job_id':job.job_id(),'status':state,'at':utc()}
    if state!='DONE':
        if state in ('ERROR','CANCELLED'):summary['error']=job.error_message()
        dump(directory/'status.json',summary);dump(ART/'status.json',summary);return summary
    result=job.result();dump(directory/'raw-result.json',json.loads(json.dumps(result,cls=RuntimeEncoder)))
    pubs=job.inputs['pubs'];s.require(len(pubs)==len(result)==len(cs),'PUB result cardinality changed')
    rows=[]
    for i,(entry,pub,c) in enumerate(zip(pubs,result,cs)):
        remote=entry[0] if isinstance(entry,(tuple,list)) else entry.circuit
        s.require(canonical_mcm(remote)==canonical_mcm(c) and remote.metadata==c.metadata,'Returned input differs from the frozen program')
        s.require(pub.metadata.get('circuit_metadata')==c.metadata,'Sample occurrence metadata mismatch')
        rows.append({'index':i,'variant':ORDER[i],**read_samples(pub.data)})
    means={v:sum(r['mean'] for r in rows if r['variant']==v)/2 for v in ('correct','ignore')}
    summary.update(rows=rows,means=means,contrast=means['correct']-means['ignore'],metrics=job.metrics(),
        raw_sha256=sha((directory/'raw-result.json').read_bytes()),interpretation=p['analysis'])
    dump(directory/'hardware-result.json',summary);dump(ART/'hardware-result.json',summary)
    return summary


if __name__=='__main__':
    cli=argparse.ArgumentParser(description=__doc__)
    cli.add_argument('stage',choices=('prepare','submit','collect'))
    cli.add_argument('--output',type=Path,required=True)
    args=cli.parse_args();print(json.dumps(globals()[args.stage](args.output.resolve()),indent=2))
