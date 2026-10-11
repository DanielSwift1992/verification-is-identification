#!/usr/bin/env python3
"""Second bounded night experiment: conditional acquisition versus coherence.

One controller per variant, two acquired-arrival preparations, no postselection.
No purchase, automatic retry or resubmission of an uncertain intent.
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
from qiskit import QuantumCircuit, ClassicalRegister, transpile, qpy
from qiskit.circuit import IfElseOp
from qiskit.circuit.classical import expr
from qiskit.circuit.library import HGate, SGate
from qiskit.transpiler import CouplingMap
from qiskit.quantum_info import Operator, Statevector
from qiskit_aer import AerSimulator
from qiskit_ibm_runtime import SamplerV2, RuntimeEncoder
from qiskit_ibm_runtime.utils.validations import validate_isa_circuits

from pilot import service_open, sha, utc, versions, require, compact_active
from resident_joint_confirmation import choose_path, place, mcm, canonical_mcm, inventory, validate_mcm
from classical_boundary_probe import aer_form

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT/'Checks/FiniteContinuation'))
import returning_attempt_learning as learning
import returning_boundary_admission as boundary
from returning_attempt_arrival import ArrivalAssembly
from returning_attempt_arrival_checks import projection
from resident_goal_instrument_audit import expand

ART = ROOT/'Research/Artifacts/returning-attempt-20260916/arrival-hardware'
PARENT = ROOT/'Research/Artifacts/returning-attempt-20260916/arrival/manifest.json'
NIGHT = ROOT/'Research/Artifacts/returning-attempt-20260916/hardware-ledger.json'
SHOTS, CAP = 32, 30
VARIANTS = ('conditional', 'unconditional', 'echo', 'ignore_learning')


def read(p): return json.loads(p.read_text())
def write(p, v): p.write_text(json.dumps(v, indent=2)+'\n')


def verify_parent(path=PARENT, seen=None):
    seen = set() if seen is None else seen
    if path in seen: return
    seen.add(path)
    for name, digest in read(path)['sha256'].items():
        p = ROOT/name
        require(sha(p.read_bytes()) == digest, 'Frozen parent changed: '+name)
        if name.endswith('manifest.json'): verify_parent(p, seen)


def engine():
    verify_parent()
    names = [Path(__file__), PARENT, ROOT/'Checks/IBMBridge/pilot.py',
             ROOT/'Checks/IBMBridge/resident_joint_confirmation.py',
             ROOT/'Checks/IBMBridge/classical_boundary_probe.py',
             ROOT/'Checks/FiniteContinuation/resident_goal_instrument_audit.py']
    return {str(p.relative_to(ROOT)):sha(p.read_bytes()) for p in names}


def core(source, certificate, variant):
    require(variant in VARIANTS, 'Unknown variant')
    future = boundary.future_questions(['IZII'], ['H_B']) if variant == 'echo' else \
        boundary.future_questions(['II'+''.join(w) for w in itertools.product('IXYZ', repeat=2)], [])
    assembly = ArrivalAssembly(source, certificate, future)
    for gate in (HGate(), SGate(), HGate()): assembly.prefix(gate)
    assembly.observe_arrival(HGate())
    q = assembly.program()
    out = q.copy_empty_like()
    correction = 0
    for item in q.data:
        op = item.operation
        if op.name == 'if_else':
            contact = any(x.operation.name == 'cx' for x in op.blocks[0].data)
            if contact and variant == 'unconditional':
                block = op.blocks[0]
                for instruction in block.data:
                    out.append(instruction.operation,
                               [item.qubits[block.find_bit(b).index] for b in instruction.qubits],
                               [item.clbits[block.find_bit(b).index] for b in instruction.clbits])
                continue
            if isinstance(op.condition, expr.Binary):
                correction += 1
                if variant == 'ignore_learning' and correction > 2: continue
                if variant == 'unconditional' and correction <= 2:
                    op = IfElseOp((op.condition.right.var, 1), op.blocks[0])
                    out.append(op, item.qubits, item.clbits)
                    continue
        out.append(item)
    return out


def expected(variant, bits):
    c, b, p = bits
    u3 = expand(HGate().to_matrix() @ SGate().to_matrix() @ HGate().to_matrix(), [2], 5)
    target = expand(HGate().to_matrix(), [2], 5) @ u3 if c else u3
    acquired = variant == 'unconditional' or (variant != 'echo' and c)
    if not acquired:
        require(b == p == 0, 'No probe reply exists on this branch')
    law = projection(request=c, a=b^p if acquired else None, b=b if acquired else None)
    if variant == 'ignore_learning' and c and b^p:
        target = expand(np.diag([1,-1]), [2], 5) @ target
    return target @ law


def native_rows(q, final):
    """Six-wire ISA reader with routing. Initial P=0, all other inputs free."""
    require(q.num_qubits == 6 and q.num_clbits == 3 and sorted(final) == list(range(6)), 'Wrong native boundary')
    initial = np.zeros((64,32),complex); initial[::2] = np.eye(32)
    active = [(initial,[0,0,0])]; cache = {}
    def variable(v,bits,body,cbits): return bits[cbits[body.find_bit(v).index]]
    def value(v,bits,body,cbits):
        if isinstance(v,expr.Value): return v.value
        if isinstance(v,expr.Var): return variable(v.var,bits,body,cbits)
        if isinstance(v,expr.Binary) and v.op.name == 'LOGIC_AND':
            return bool(value(v.left,bits,body,cbits) and value(v.right,bits,body,cbits))
        raise ValueError('Unknown classical expression')
    def lifted(matrix,qs):
        key = (tuple(qs),matrix.tobytes())
        if key not in cache: cache[key] = expand(matrix,qs,6)
        return cache[key]
    def visit(body, rows, wires, cbits, inside=False):
        for item in body.data:
            op = item.operation
            qs = [wires[body.find_bit(b).index] for b in item.qubits]
            cs = [cbits[body.find_bit(b).index] for b in item.clbits]
            if op.name == 'barrier': continue
            if op.name == 'if_else':
                require(not inside, 'Nested native conditional')
                after=[]
                for matrix,bits in rows:
                    yes = (variable(op.condition[0],bits,body,cbits)==op.condition[1]) \
                        if isinstance(op.condition,tuple) else value(op.condition,bits,body,cbits)
                    k=0 if yes else 1
                    after.extend(visit(op.blocks[k],[(matrix,bits)],qs,cs,True) if k<len(op.blocks) else [(matrix,bits)])
                rows=after
            elif op.name in ('measure','measure_2','reset'):
                require(not inside, 'Conditional measurement/reset')
                if op.name == 'measure_2': validate_mcm(op)
                after=[]
                for matrix,bits in rows:
                    for b in (0,1):
                        local=np.zeros((2,2),complex); local[0 if op.name=='reset' else b,b]=1
                        mapped=lifted(local,qs) @ matrix
                        if np.max(abs(mapped))<1e-13: continue
                        record=list(bits)
                        if op.name!='reset':record[cs[0]]=b
                        after.append((mapped,record))
                rows=after
            else:
                require(op.name in ('rz','sx','x','id','cz','h','s','cx','z'), 'Uninterpreted native instruction '+op.name)
                matrix=lifted(Operator(op).data,qs)
                rows=[(matrix@old,bits) for old,bits in rows]
        return rows
    rows=visit(q,active,list(range(6)),list(range(3)))
    rowmap=[sum(((x>>i)&1)<<final[i+1] for i in range(5)) for x in range(32)]
    absent=sorted(set(range(64))-set(rowmap))
    result=[]
    for matrix,bits in rows:
        require(np.max(abs(matrix[absent]))<1e-11, 'Scratch not returned after routing')
        result.append((matrix[rowmap],bits))
    return result


def operator_check(q,final,variant):
    rows=native_rows(q,final); seen=set(); worst=0.; complete=np.zeros((32,32),complex)
    for actual,bits in rows:
        require(tuple(bits) not in seen,'Duplicate output branch');seen.add(tuple(bits))
        want=expected(variant,bits)
        phase=np.vdot(want,actual)/np.vdot(want,want)
        worst=max(worst,float(np.max(abs(actual-phase*want))),abs(abs(phase)-1))
        complete+=actual.conj().T@actual
    require(len(rows)=={'conditional':5,'unconditional':8,'echo':2,'ignore_learning':5}[variant], 'Wrong branch count')
    require(worst<1e-10 and np.max(abs(complete-np.eye(32)))<1e-10,'Native instrument differs')
    return {'branches':len(rows),'input_dimension':32,'operator_residual_up_to_branch_phase':worst,
            'probability_complete':True,'returned_probe_zero':True}


def lower(q):
    graph=CouplingMap([[i,j] for i in range(5) for j in range(5) if abs(i-j)==1])
    graph.add_physical_qubit(5)  # C only gets local gates and measurement.
    native=transpile(q,basis_gates=['rz','sx','x','id','cz','reset'],coupling_map=graph,
                     initial_layout=list(range(6)),layout_method='trivial',routing_method='sabre',
                     optimization_level=1,seed_transpiler=91662,num_processes=1)
    return mcm(native),native.layout.final_index_layout()


def shared_native_variant(q, variant):
    """Keep the same routed gate bodies/layout for the three acquisition arms.

    Only the specified classical guards change. This avoids independently
    routing the unconditional control onto different final physical ports.
    """
    require(variant in ('conditional','unconditional','ignore_learning'),'Not a shared acquisition arm')
    out=q.copy_empty_like();contact=0;correction=0
    for item in q.data:
        op=item.operation
        if op.name=='if_else':
            if isinstance(op.condition,tuple):
                contact+=1
                if variant=='unconditional' and contact<=2:
                    block=op.blocks[0]
                    for instruction in block.data:
                        out.append(instruction.operation,
                                   [item.qubits[block.find_bit(b).index] for b in instruction.qubits],
                                   [item.clbits[block.find_bit(b).index] for b in instruction.clbits])
                    continue
            else:
                require(isinstance(op.condition,expr.Binary),'Unknown guard shape')
                correction+=1
                if variant=='ignore_learning' and correction>2:continue
                if variant=='unconditional' and correction<=2:
                    op=IfElseOp((op.condition.right.var,1),op.blocks[0])
                    out.append(op,item.qubits,item.clbits);continue
        out.append(item)
    require(contact==3 and correction==4,'Shared native shape changed')
    return out


def ideal(variant,c,basis,sign):
    return {'B_X':0 if variant=='unconditional' or (c and variant!='echo') else (-1)**sign,
            'Bell':-1 if variant=='ignore_learning' and c and basis=='ZZ' else 1}


def witness(native,final,c,basis,sign):
    q=QuantumCircuit(6)
    q.x(1)
    if sign:q.x(2)
    q.h(2);q.h(3);q.cx(3,4)
    if c:q.x(5)
    q=transpile(q,basis_gates=['rz','sx','x','id','cz'],optimization_level=0)
    for reg in native.cregs:q.add_register(reg)
    q.compose(native,inplace=True)
    # Harness inverse of intended U_c, independent of the actual acquired bit.
    # A wrongly acquired request remains an error; it is never postselected away.
    tail=QuantumCircuit(6)
    if c:tail.h(final[3])
    tail.h(final[3]);tail.sdg(final[3]);tail.h(final[3])
    tail.h(final[2])
    if basis=='XX':tail.h(final[3]);tail.h(final[4])
    tail=transpile(tail,basis_gates=['rz','sx','x','id','cz'],optimization_level=0)
    q.compose(tail,inplace=True)
    out=ClassicalRegister(3,'witness');q.add_register(out)
    q.measure([final[2],final[3],final[4]],out)
    return q


def local(q,variant,c,basis,sign):
    result=AerSimulator(max_parallel_threads=1).run(aer_form(q),shots=16,memory=True,seed_simulator=91663).result()
    require(result.success,'Local witness failed')
    regs={r.name:r for r in q.cregs}
    def number(value,name):return sum(((value>>q.find_bit(bit).index)&1)<<i for i,bit in enumerate(regs[name]))
    prediction=ideal(variant,c,basis,sign)
    for memory in result.get_memory():
        value=int(memory.replace(' ',''),2);w=number(value,'witness')
        require((-1)**(((w>>1)&1)^((w>>2)&1))==prediction['Bell'],'Wrong ideal data contrast')
        if prediction['B_X']: require((-1)**(w&1)==prediction['B_X'],'Wrong ideal coherence witness')
        require(number(value,'actual_arrival')==c,'Request origin lost')
        if variant!='echo':
            r=number(value,'actual_replies')
            require(((r&1)^((r>>1)&1))==1 if (c or variant=='unconditional') else r==0,
                    'Wrong returning record relation')
    return 16


def exact_witness_moments(native,final,variant,c,basis,sign):
    prep=QuantumCircuit(5);prep.x(0)
    if sign:prep.x(1)
    prep.h(1);prep.h(2);prep.cx(2,3)
    if c:prep.x(4)
    vector=Statevector.from_instruction(prep).data
    h=HGate().to_matrix();s=SGate().to_matrix()
    u=h@s@h
    if c:u=h@u
    undo=expand(u.conj().T,[2],5)
    x=np.array([[0,1],[1,0]]);z=np.diag([1,-1])
    bx=expand(x,[1],5);m=x if basis=='XX' else z
    bell=expand(m,[2],5)@expand(m,[3],5)
    got={'B_X':0.,'Bell':0.};probability=0.
    for matrix,_ in native_rows(native,final):
        v=undo@matrix@vector;probability+=np.vdot(v,v).real
        got['B_X']+=float(np.vdot(v,bx@v).real);got['Bell']+=float(np.vdot(v,bell@v).real)
    require(abs(probability-1)<1e-10 and all(abs(got[k]-value)<1e-10 for k,value in ideal(variant,c,basis,sign).items()),
            'Exact ideal witness expectations differ')
    return got


def options(tag):
    return {'default_shots':SHOTS,'max_execution_time':CAP,'environment':{'job_tags':[tag]},
            'execution':{'init_qubits':True},'twirling':{'enable_gates':False,'enable_measure':False},
            'dynamical_decoupling':{'enable':False}}


def prepare(directory):
    require(not (directory/'plan.json').exists(),'Already frozen')
    sealed=engine();source=learning.read_source();cert=learning.synthesize(source)
    # Verify locally before accessing a provider or freezing a submission plan.
    cores={};checks={}
    base,base_final=lower(core(source,cert,'conditional'))
    for variant in VARIANTS:
        logical=core(source,cert,variant)
        operator_check(logical,list(range(6)),variant)
        native,final=lower(logical) if variant=='echo' else (shared_native_variant(base,variant),base_final)
        checks[variant]=operator_check(native,final,variant)
        cores[variant]=native,final
    service=service_open();backend=service.backend('ibm_marrakesh');st=backend.status()
    require(st.operational and st.status_msg=='active','Backend is not active')
    path,score=choose_path(backend)
    available=[]
    for i in range(backend.num_qubits):
        if i in path:continue
        records=[backend.target[name].get((i,)) for name in ('measure','measure_2','sx','x','rz','reset')]
        if all(x is not None for x in records):available.append((records[0].error if records[0].error is not None else 1.,i))
    require(available,'No extra arrival-readout site')
    arrival_error,arrival_site=min(available);path=path+[arrival_site]
    directory.mkdir(parents=True,exist_ok=True);ART.mkdir(parents=True,exist_ok=True)
    tag='vi-arrival-boundary-'+uuid.uuid4().hex[:12]
    circuits=[];pubs=[]
    for variant,(native,_) in cores.items():
        with (ART/(variant+'-core.qpy')).open('wb') as f:qpy.dump(native,f)
    for c,sign,basis,variant in itertools.product((0,1),(0,1),('XX','ZZ'),VARIANTS):
        native,final=cores[variant];small=witness(native,final,c,basis,sign)
        moments=exact_witness_moments(native,final,variant,c,basis,sign)
        local(small,variant,c,basis,sign)
        metadata={'tag':tag,'variant':variant,'prepared_arrival':c,'law_a_preparation':1,
                  'law_b_preparation':'-' if sign else '+','basis':basis,'prediction':ideal(variant,c,basis,sign),
                  'path':path,'final_layout':final,
                  'scope':'Fixed coherent B input and Bell D,R; actual measured arrival; descriptive contrasts, no process tomography.'}
        small.metadata=metadata;q=place(small,path,backend.num_qubits)
        validate_isa_circuits([q],backend.target)
        buffer=io.BytesIO();qpy.dump(q,buffer);buffer.seek(0);restored,=qpy.load(buffer)
        require(canonical_mcm(restored)==canonical_mcm(q) and restored.metadata==q.metadata,'QPY changed')
        local(compact_active(restored),variant,c,basis,sign)
        circuits.append(q);pubs.append({**metadata,'inventory':inventory(q),'exact_moments':moments})
    with (directory/'isa.qpy').open('wb') as f:qpy.dump(circuits,f)
    plan={'schema':'vi.arrival-boundary-hardware.v1','at':utc(),'tag':tag,'backend':backend.name,
          'instance':service.active_instance(),'source':learning.fingerprint(source),'engine':sealed,
          'versions':versions(),'path':path,'path_calibration_score':score,'arrival_readout_error':arrival_error,
          'shots_each':SHOTS,'total_shots':len(circuits)*SHOTS,'cap':CAP,'options':options(tag),
          'qpy_sha256':sha((directory/'isa.qpy').read_bytes()),'operator_checks':checks,'PUBs':pubs,
          'analysis':'All joint records, no postselection. Per PUB report measured B_X and Bell XX/ZZ parity; '
                     'arrival and reply consistency separately. Pool B_X across the two terminal data bases within '
                     'each preparation; also show the balanced response (B_X[+]-B_X[-])/2, descriptively. '
                     'Conditional c=0 and echo preserve B_X=+1/-1, active acquisition or unsolicited acquisition '
                     'give B_X=0. All data parities ideal +1 except ignore_learning c=1 ZZ gives -1. '
                     'Primary contrast is conditional versus unsolicited at prepared c=0. Echo is a shorter-depth baseline. '
                     'The acquisition variants share routed gate bodies and final ports; only named guards are changed. '
                     'No IID, fidelity/tomography or universal accuracy claim; no automatic retries.'}
    require(plan['total_shots']==1024,'Shot budget changed')
    write(directory/'plan.json',plan);write(ART/'plan.json',{k:v for k,v in plan.items() if k!='instance'})
    return {'prepared':True,'backend':backend.name,'path':path,'PUBs':len(pubs),'shots':plan['total_shots'],
            'cap_seconds':CAP,'operator_checks':checks,
            'inventories':{v:inventory(cores[v][0]) for v in VARIANTS}}


def load(directory):
    p=read(directory/'plan.json')
    require(p['engine']==engine() and p['versions']==versions() and p['source']==learning.fingerprint(learning.read_source()),
            'Frozen implementation changed')
    require(p['shots_each']==SHOTS and p['cap']==CAP and p['total_shots']==1024 and p['options']==options(p['tag']),
            'Execution contract changed')
    require(sha((directory/'isa.qpy').read_bytes())==p['qpy_sha256'],'QPY changed')
    with (directory/'isa.qpy').open('rb') as f:qs=qpy.load(f)
    require(len(qs)==32 and all(q.metadata=={k:v for k,v in row.items() if k not in ('inventory','exact_moments')}
                             for q,row in zip(qs,p['PUBs'])),'PUB identity changed')
    return p,qs


def submit(directory):
    p,qs=load(directory);service=service_open()
    require(service.active_instance()==p['instance'],'Wrong instance')
    with NIGHT.with_suffix('.lock').open('a') as lock:
        fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
        night=read(NIGHT);jobs=night['jobs'];limits=night['limits']
        require(utc()<night['deadline_utc'],'Night budget expired')
        require(not any(j['tag']==p['tag'] for j in jobs),'Intent exists; recover, never resubmit')
        require(len(jobs)<limits['max_new_jobs'] and all(j['status'] in ('DONE','ERROR','CANCELLED') for j in jobs),
                'Night job count or nonterminal-job limit')
        require(sum(j['total_shots'] for j in jobs)+p['total_shots']<=limits['max_total_shots'] and
                sum(j['cap_seconds'] for j in jobs)+CAP<=limits['max_total_execution_seconds'],'Night resource limit')
        quota=service.usage()['usage_remaining_seconds'];require(quota>=CAP,'Insufficient free quota')
        backend=service.backend(p['backend']);st=backend.status()
        require(st.operational and st.status_msg=='active','Backend unavailable')
        validate_isa_circuits(qs,backend.target)
        item={'tag':p['tag'],'qpy_sha256':p['qpy_sha256'],'at':utc(),'status':'intent',
              'backend':p['backend'],'total_shots':p['total_shots'],'cap_seconds':CAP,
              'free_seconds_before':quota,'private_directory':str(directory.relative_to(ROOT))}
        jobs.append(item);write(NIGHT,night);write(directory/'submission.json',item)
        job=SamplerV2(mode=backend,options=p['options']).run(qs,shots=SHOTS)
        item.update(job_id=job.job_id(),status='submitted');write(NIGHT,night)
        write(directory/'submission.json',item);write(ART/'submission.json',item)
        return item


def collect(directory):
    p,qs=load(directory);sent=read(directory/'submission.json')
    require(sent.get('job_id'),'Uncertain submission: recover by tag')
    service=service_open();require(service.active_instance()==p['instance'],'Wrong instance')
    job=service.job(sent['job_id']);require(p['tag'] in job.tags and job.backend().name==p['backend'],'Wrong job')
    status=job.status();out={'at':utc(),'job_id':job.job_id(),'status':status}
    if status in ('ERROR','CANCELLED'):out['error']=job.error_message()
    if status=='DONE':
        result=job.result();require(len(result)==len(qs),'Missing PUBs')
        write(directory/'raw-result.json',json.loads(json.dumps(result,cls=RuntimeEncoder)))
        rows=[]
        for pub,q,entry in zip(result,qs,job.inputs['pubs']):
            remote=entry[0] if isinstance(entry,(tuple,list)) else entry.circuit
            require(canonical_mcm(remote)==canonical_mcm(q) and pub.metadata['circuit_metadata']==q.metadata,'Remote origin changed')
            w=pub.data.witness.get_bitstrings();c=pub.data.actual_arrival.get_bitstrings()
            r=pub.data.actual_replies.get_bitstrings() if q.metadata['variant']!='echo' else ['--']*SHOTS
            require(len(w)==len(c)==len(r)==SHOTS,'Shot count changed')
            b0=sum(int(x,2)&1==0 for x in w)
            even=sum(((int(x,2)>>1)&1)==((int(x,2)>>2)&1) for x in w)
            rows.append({**q.metadata,'counts':dict(Counter(' '.join(x) for x in zip(c,r,w))),
                         'shots':SHOTS,'B_zero':b0,'B_X':2*b0/SHOTS-1,
                         'data_even':even,'data_parity':2*even/SHOTS-1,
                         'arrival_agreement':sum(int(x,2)==q.metadata['prepared_arrival'] for x in c)})
        out.update(rows=rows,raw_sha256=sha((directory/'raw-result.json').read_bytes()))
    if status in ('DONE','ERROR','CANCELLED'):
        out.update(metrics=job.metrics(),free_seconds_after=service.usage()['usage_remaining_seconds'])
    with NIGHT.with_suffix('.lock').open('a') as lock:
        fcntl.flock(lock,fcntl.LOCK_EX)
        night=read(NIGHT);matches=[j for j in night['jobs'] if j['tag']==p['tag']]
        require(len(matches)==1,'Missing night intent');matches[0]['status']=status
        if 'free_seconds_after' in out:matches[0]['free_seconds_after']=out['free_seconds_after']
        write(NIGHT,night)
    write(directory/'status.json',out);write(ART/'status.json',out)
    return out


if __name__=='__main__':
    parser=argparse.ArgumentParser();parser.add_argument('stage',choices=['prepare','submit','collect'])
    parser.add_argument('--output',type=Path,required=True);args=parser.parse_args()
    print(json.dumps(globals()[args.stage](args.output.resolve()),indent=2))
