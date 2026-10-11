#!/usr/bin/env python3
"""Read the actual lowered instructions as unnormalized branch operators.

Five physical wire positions, independent classical Store/if interpretation.
Each branch is a 32x16 map, so comparison covers arbitrary incoming DEM+REF,
not only the Bell vector used in the sampled harness. No cloud client.
"""
import argparse
import json
from pathlib import Path
import time
import numpy as np
from qiskit.circuit import ClassicalRegister
from qiskit.circuit.classical import expr

import resident_goal_synthesis as s
import resident_goal_synthesis_sdk as sdk
from resident_raw_reply_checks import fixture
from resident_stream_checks import operators
import whole_word_admission as a
from qiskit_aer import AerSimulator
from environment import write


def expand(local,wires,n=5):
    out=np.zeros((2**n,2**n),complex)
    for col in range(2**n):
        j=sum(((col>>q)&1)<<i for i,q in enumerate(wires))
        base=col & ~sum(1<<q for q in wires)
        for i in range(2**len(wires)):
            row=base | sum(((i>>bit)&1)<<q for bit,q in enumerate(wires))
            out[row,col]=local[i,j]
    return out


def interpret(circuit):
    initial=np.zeros((32,16),complex); initial[::2,:]=np.eye(16)
    branches=[{'map':initial,'bits':[0]*circuit.num_clbits,'events':[],'snapshots':{},'pending':False}]
    gate_cache={}

    def value(v,record):
        if isinstance(v,expr.Value): return v.value
        if isinstance(v,expr.Var): return variable(v.var,record)
        if isinstance(v,expr.Binary):
            x,y=value(v.left,record),value(v.right,record)
            if v.op.name=='BIT_XOR': return x^y
            if v.op.name=='EQUAL': return x==y
            if v.op.name=='LOGIC_AND': return bool(x) and bool(y)
        raise ValueError('Uninterpreted classical expression')

    def variable(v,record):
        if isinstance(v,ClassicalRegister):
            return sum(record[circuit.find_bit(bit).index]<<i for i,bit in enumerate(v))
        return record[circuit.find_bit(v).index]

    def assign(v,x,record):
        if isinstance(v,ClassicalRegister):
            s.require(0<=int(x)<2**len(v),'Classical write overflows its actual register')
            for i,bit in enumerate(v):record[circuit.find_bit(bit).index]=(int(x)>>i)&1
        else:record[circuit.find_bit(v).index]=int(bool(x))

    def block(body,active,qubits,clbits):
        for item in body.data:
            op=item.operation; name=op.name
            qs=[qubits[body.find_bit(bit).index] for bit in item.qubits]
            cs=[clbits[body.find_bit(bit).index] for bit in item.clbits]
            if name=='if_else':
                after=[]
                for branch in active:
                    if isinstance(op.condition,tuple):
                        v,wanted=op.condition; yes=variable(v,branch['bits'])==wanted
                    else:yes=bool(value(op.condition,branch['bits']))
                    k=0 if yes else 1
                    after.extend(block(op.blocks[k],[branch],qs,cs) if k<len(op.blocks) else [branch])
                active=after; continue
            if name=='store':
                for branch in active:assign(op.lvalue.var,value(op.rvalue,branch['bits']),branch['bits'])
                continue
            if name=='save_density_matrix':
                s.require(qs==[1,2,3,4],'Snapshot moved off the retained ports')
                for branch in active:
                    s.require(np.max(abs(branch['map'][1::2]))<1e-12,'Disposable probe not returned at the boundary')
                    branch['snapshots'][op.label]=branch['map'][::2,:].copy()
                continue
            if name=='barrier':continue
            if name in ('measure','reset'):
                s.require(qs==[0],'A retained datum was measured or reset')
                after=[]
                for branch in active:
                    for bit in (0,1):
                        local=np.zeros((2,2),complex)
                        local[bit if name=='measure' else 0,bit]=1
                        mapped=expand(local,[0])@branch['map']
                        if np.linalg.norm(mapped)<1e-13:continue
                        new={**branch,'map':mapped,'bits':list(branch['bits']),
                             'events':list(branch['events']),'snapshots':dict(branch['snapshots'])}
                        if name=='measure':
                            new['bits'][cs[0]]=bit
                            if new['pending']:
                                new['events'].append({'kind':'contact','reply':bit});new['pending']=False
                            elif op.label and op.label.endswith(':answer'):
                                new['events'].append({'kind':'answer','goal':int(op.label.split(':')[0][4:]),'bit':bit})
                            else:
                                s.require(bit==0,'An inactive probe slot returned new service information')
                        after.append(new)
                active=after;continue
            s.require(name in ('h','s','x','z','id','cx','cz','unitary'),'Unknown quantum instruction '+name)
            key=(name,tuple(qs),op.to_matrix().tobytes())
            if key not in gate_cache:gate_cache[key]=expand(op.to_matrix(),qs)
            unitary=gate_cache[key]
            for branch in active:
                branch['map']=unitary@branch['map']
                if name=='unitary':
                    s.require(qs==[0,1,2] and not branch['pending'],'Wrong or repeated service contact')
                    branch['pending']=True
        return active

    result=block(circuit,branches,list(range(5)),list(range(circuit.num_clbits)))
    s.require(all(not b['pending'] for b in result),'A service call lost its acquired result')
    return result


def expected(source,queries,ks,events):
    # Matrix of the explicit prefix preparation. The input to this unitary is
    # left arbitrary; it spans the complete retained 16-dimensional space.
    prep=np.eye(16,dtype=complex)
    for matrix,wires in [(a.H,[2]),(np.array([[1,0,0,0],[0,0,0,1],[0,0,1,0],[0,1,0,0]]),[2,3]),
                         (a.H,[1]),(np.array([[1,0,0,0],[0,0,0,1],[0,0,1,0],[0,1,0,0]]),[1,0])]:
        prep=expand(matrix,wires,4)@prep
    maps=operators(source['goal']['raw'],ks)
    current=prep; r=0; history=[]; entry=None; snapshots={}; contacts=0; goal_index=0
    for event in events:
        if event['kind']=='contact':
            bit=event['reply']; K,=maps[r,bit];current=K@current; r=1^r^bit;history.append(bit);contacts+=1
            if contacts==3:
                entry=4*r+2*history[0]+history[-1];snapshots['live_entry']=current.copy()
        else:
            assert event['goal']==goal_index
            state=4*r+2*history[0]+history[-1];q=queries[goal_index]
            answer=q['values'][entry if q['occurrence']=='entry' else state]
            s.require(answer==event['bit'],'Actual goal record is not its independently evaluated answer')
            if answer:current=np.kron(a.I,np.kron(a.Z,np.eye(4)))@current
            snapshots[f'goal{goal_index}_output']=current.copy()
            entry=state;goal_index+=1
    assert goal_index==3
    return current,snapshots


def audit(source):
    queries=[s.request(source,[(m>>i)&1 for i in range(8)],t) for m,t in
             [(240,'entry'),(21,'exit'),(170,'entry'),(204,'entry')]]
    cases=[]; worst=0.; rejected=[]; sampled=0; sample_worst=0.
    for theta,phi in ((1.3,-.8),(1.45,.91)):
        service,ks,_=fixture(theta,phi);q,_=sdk.build(source,service,queries,snapshot=True)
        branches=interpret(q); total=np.zeros((16,16),complex); residual=0.;lengths=set()
        for branch in branches:
            want,checkpoints=expected(source,queries,ks,branch['events'])
            actual=branch['map'][::2,:]
            residual=max(residual,float(np.max(abs(actual-want))))
            for name,mat in checkpoints.items():
                residual=max(residual,float(np.max(abs(branch['snapshots'][name]-mat))))
            total+=actual.conj().T@actual
            lengths.add(sum(e['kind']=='contact' for e in branch['events'])-3)
        s.require(residual<1e-11,'Lowered branch operator changed the target channel')
        s.require(np.max(abs(total-np.eye(16)))<1e-11,'Stopped instrument is not complete')
        assert lengths=={1,2};worst=max(worst,residual)
        # Observer-only history registers distinguish the actually performed
        # trajectory. No production condition reads these extra registers.
        audited=q.copy_empty_like(); measurements=sum(item.operation.name=='measure' for item in q.data)
        history=ClassicalRegister(measurements,'audit_records');audited.add_register(history)
        k=0
        for item in q.data:
            audited.append(item)
            if item.operation.name=='measure':
                audited.store(history[k],item.clbits[0]);k+=1
        interpreted=interpret(audited)
        by_record={tuple(b['bits']):b for b in interpreted}
        s.require(len(by_record)==len(interpreted),'The independent audit history lost a branch')
        run=AerSimulator(method='statevector',max_parallel_threads=1).run(
            audited,shots=128,memory=True,seed_simulator=4501+len(cases)).result()
        s.require(run.success,'Local execution failed')
        sampled_error=0.
        for shot,record in enumerate(run.get_memory()):
            number=int(record.replace(' ',''),2)
            bits=tuple((number>>i)&1 for i in range(audited.num_clbits))
            s.require(bits in by_record,'SDK returned a record outside the interpreted instrument')
            branch=by_record[bits]
            for name,operator in branch['snapshots'].items():
                vector=operator[:,0]; probability=np.vdot(vector,vector).real
                s.require(probability>0,'SDK selected a zero-probability audit branch')
                target=np.outer(vector,vector.conj())/probability
                sampled_error=max(sampled_error,float(np.max(abs(run.data()[name][shot].data-target))))
                sampled+=1
        s.require(sampled_error<1e-11,'Aer trajectory lost a retained-state or record relation')
        sample_worst=max(sample_worst,sampled_error)
        cases.append({'fixture':[theta,phi],'branches':len(branches),'extra_service_contacts':sorted(lengths),
            'maximum_full_operator_residual':residual,'completeness_residual':float(np.max(abs(total-np.eye(16)))),
            'retained_input_dimension':16,'checkpoints_per_branch':4,
            'independently_matched_Aer_shots':128,'sampled_state_residual':sampled_error})
    # A wrong port can survive the SDK's loose equality, but cannot survive
    # current-producer admission or this retained-port audit.
    altered=q.copy_empty_like()
    changed=False
    for item in q.data:
        if not changed and item.operation.name=='reset':
            altered.reset(3);changed=True
        else:altered.append(item)
    try:interpret(altered)
    except ValueError:rejected.append('reset of retained data instead of disposable probe')
    else:raise AssertionError('Accepted data destruction')
    altered=q.copy_empty_like();changed=False
    for item in q.data:
        if not changed and item.operation.name=='unitary':
            altered.append(item.operation,[0,2,1],item.clbits);changed=True
        else:altered.append(item)
    try:interpret(altered)
    except ValueError:rejected.append('permuted actual service ports')
    else:raise AssertionError('Accepted reordered service interface')
    return {'cases':cases,'maximum_full_operator_residual':worst,'refusals':rejected,
        'independent_Aer_checkpoint_states':sampled,'maximum_Aer_state_residual':sample_worst,
        'scope':'All unnormalized branches of two declared local dilations, including live checkpoints; arbitrary retained input/reference. No physical calibration claim.'}


if __name__=='__main__':
    cli=argparse.ArgumentParser(description=__doc__)
    cli.add_argument('--output',type=Path,required=True)
    args=cli.parse_args()
    start=time.perf_counter()
    source=s.reading();s.validate_source(source)
    result=audit(source);result['seconds']=time.perf_counter()-start
    write(args.output.resolve(),result)
    print(json.dumps({k:result[k] for k in ['maximum_full_operator_residual',
        'independent_Aer_checkpoint_states','maximum_Aer_state_residual','seconds']},indent=2))
