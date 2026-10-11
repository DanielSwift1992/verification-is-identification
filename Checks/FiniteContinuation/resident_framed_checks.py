#!/usr/bin/env python3
"""Independent SDK instruments, all-history comparison and frame obstructions."""
import argparse
from copy import deepcopy
from itertools import product
import json
from pathlib import Path

import numpy as np
from qiskit import QuantumCircuit
from qiskit.quantum_info import Kraus,Operator,SuperOp

import resident_framed as f
import resident_classical as m
import resident_memory as r
import whole_word_admission as a
from environment import write,digest

REFUSALS=0
def reject(call):
    global REFUSALS
    try:call()
    except (ValueError,AssertionError,TypeError,AttributeError):REFUSALS+=1;return
    raise AssertionError('Unsupported use accepted')


def apply(ks,rho,ref=1):
    return sum(np.kron(k,np.eye(ref))@rho@np.kron(k.conj().T,np.eye(ref)) for k in ks)


def sdk_joint(axis,frame,read_relative=True):
    # Six wires, tensor T,B,P,C,D,E. B is the raw meter, T is the actual
    # post-write parity meter. Reset P has its separate discarded environment.
    before=QuantumCircuit(6)
    if axis=='X':before.h(0)
    before.cx(0,4);before.cx(3 if frame=='Program' else 2,4)
    if axis=='X':before.h(0)
    after=QuantumCircuit(6);after.cx(4,3)
    if read_relative:after.cx(3,5);after.cx(2,5)
    reset=QuantumCircuit(1);reset.reset(0)
    u,v=Operator(before).data,Operator(after).data
    ops=[v@np.kron(np.eye(4),np.kron(k,np.eye(8)))@u for k in Kraus(reset).data]
    return {(y,t):[k[32*t+16*y:32*t+16*(y+1),:16] for k in ops] for y,t in product((0,1),repeat=2)}


def channels(reading):
    comp=m.compression();residuals={};sdk_residuals={};averaged={}
    for frame,axis in product(('Program','Clock'),('X','Z')):
        sdk=sdk_joint(axis,frame);rawsdk=sdk_joint(axis,frame,False)
        full=[];small=[]
        for t in (0,1):
            whole=f.instrument(reading,axis,frame,t);relative=f.instrument(reading,axis,frame,t,kind='relative')
            full+=whole;small+=relative
            left=SuperOp(Kraus([l@k for l in comp for k in whole])).data
            right=SuperOp(Kraus([k@l for k in relative for l in comp])).data
            e=float(np.max(abs(left-right)));assert e<1e-12;residuals[f'{frame}:{axis}:{t}']=e
            hardware=[k for y in (0,1) for k in sdk[y,t]]
            e=float(np.max(abs(SuperOp(Kraus(hardware)).data-SuperOp(Kraus(whole)).data)))
            assert e<1e-12;sdk_residuals[f'{frame}:{axis}:{t}']=e
            # Output control is acquired, not reconstructed from a guessed
            # old program. The complete branch has support only on R=t.
            projector=f.post_parity(t)
            assert all(np.max(abs(projector@k-k))<1e-12 for k in whole)
        for y in (0,1):
            assert np.max(abs(SuperOp(Kraus(rawsdk[y,0])).data-SuperOp(Kraus(f.raw_instrument(reading,axis,frame,y))).data))<1e-12
        assert Kraus(full).is_cptp(atol=1e-12) and Kraus(small).is_cptp(atol=1e-12)
        raw=[k for y in (0,1) for k in f.raw_instrument(reading,axis,frame,y)]
        before_return=SuperOp(Kraus([l@k for l in comp for k in raw])).data
        after_return=SuperOp(Kraus([l@k for l in comp for k in full])).data
        e=float(np.max(abs(before_return-after_return)));assert e<1e-12;averaged[f'{frame}:{axis}']=e
    return {'selective_return_equalities':residuals,'independent_SDK_return_branch_residuals':sdk_residuals,
            'hidden_raw_contact_and_extra_return_same_after_compression':averaged,'SDK_raw_branch_equalities':8}


def affine_table():
    result=[]
    for alpha,kappa,delta in product((0,1),repeat=3):
        raw_ok=post_ok=True;rows=[]
        for old,b in product((0,1),repeat=2):
            group=[]
            for c in (0,1):
                p=old^c;y=b^(alpha&p)^(kappa&c)^delta;group.append((y,y^c))
            raw_ok&=group[0][0]==group[1][0];post_ok&=group[0][1]==group[1][1]
            rows.append({'relative':old,'service_eigenlabel':b,'two_representatives':group})
        assert raw_ok==(alpha==kappa) and post_ok==(alpha!=kappa)
        result.append({'alpha':alpha,'kappa':kappa,'delta':delta,'raw_record_factors':raw_ok,
                       'post_write_relative_state_factors':post_ok,'joint_factors':raw_ok and post_ok,'rows':rows})
    assert sum(x['post_write_relative_state_factors'] for x in result)==4
    assert not any(x['joint_factors'] for x in result)
    return result


def obstructions(reading):
    comp=m.compression();states=[]
    for p,c in ((0,0),(1,1)):
        pc=np.zeros(4);pc[2*p+c]=1;v=np.kron(pc,np.kron(np.array([1,0]),np.array([1,1])/np.sqrt(2)))
        states.append(np.outer(v,v.conj()))
    assert np.array_equal(apply(comp,states[0]),apply(comp,states[1]))
    zr=np.kron(a.Z,np.eye(4));raw_summary={}
    for frame in ('Program','Clock'):
        for y in (0,1):
            out=[apply(comp,apply(f.raw_instrument(reading,'Z',frame,y),rho)) for rho in states]
            p=[float(np.trace(x).real) for x in out];z=[float(np.trace(zr@x).real) for x in out]
            assert max(abs(x-.5) for x in p)<1e-12 and abs(z[0]-z[1])>.99
            raw_summary[f'{frame}:{y}']={'same_raw_outcome_probabilities':p,'different_unnormalized_R_Z':z}
        # The exported/raw-y instrument as a whole reveals hidden C through
        # the observable (-1)^y Z_R, irrespective of the meter's probabilities.
        joint_values=[]
        for rho in states:
            value=sum((-1)**y*np.trace(zr@apply(comp,apply(f.raw_instrument(reading,'Z',frame,y),rho))).real for y in (0,1))
            joint_values.append(float(value))
        assert abs(joint_values[0]-1)<1e-12 and abs(joint_values[1]+1)<1e-12
        raw_summary[frame+'_raw_times_control']=joint_values
    # Acquiring T is a real extra contact; it need not preserve the full
    # unquotiented C coherence. Equality after Lambda is the correct scope.
    v=np.kron(np.array([1,0]),np.kron(np.array([1,1])/np.sqrt(2),np.kron(np.array([1,0]),np.array([1,1])/np.sqrt(2))))
    rho=np.outer(v,v.conj())
    raw=[k for y in (0,1) for k in f.raw_instrument(reading,'Z','Program',y)]
    ret=[k for t in (0,1) for k in f.instrument(reading,'Z','Program',t)]
    values=[float(np.trace(r.at(a.X,1)@apply(ks,rho)).real) for ks in (raw,ret)]
    assert abs(values[0]-1)<1e-12 and abs(values[1])<1e-12
    return {'raw_branch_obstruction':raw_summary,'extra_return_contact_changes_full_C_X':values}


def adaptive(reading):
    rng=np.random.default_rng(392501);comp=m.compression();s=reading['service']
    v=Operator(r.circuit(s['acquisition']['interpreter'])).data;vr=m.relative_tick(s)
    nodes=0;worst=0.;pe=0.
    for trial in range(3):
        z=rng.normal(size=32)+1j*rng.normal(size=32);z/=np.linalg.norm(z);rho=np.outer(z,z.conj())
        frontier=[((),rho,apply(comp,rho,2))]
        for depth in range(5):
            following=[]
            for history,whole,small in frontier:
                whole=apply([v],whole,2);small=apply([vr],small,2)
                if depth%2:whole=apply([m.reopen(s,full=True)],whole,2);small=apply([m.reopen(s)],small,2)
                frame='Clock' if history and history[-1] else 'Program';axis='X' if sum(history)%2 else 'Z'
                for t in (0,1):
                    x=apply(f.instrument(reading,axis,frame,t),whole,2)
                    y=apply(f.instrument(reading,axis,frame,t,kind='relative'),small,2)
                    error=float(np.max(abs(apply(comp,x,2)-y)));prob=float(abs(np.trace(x)-np.trace(y)))
                    assert error<1e-10 and prob<1e-10;worst=max(worst,error);pe=max(pe,prob);nodes+=1
                    following.append((history+(t,),x,y))
            frontier=following
        assert abs(sum(np.trace(x).real for _,x,_ in frontier)-1)<1e-10
    return {'all_adaptive_history_nodes':nodes,'maximum_joint_state_residual':worst,'maximum_probability_residual':pe}


def relative_past(reading):
    # Old R is a classical index in the admitted quotient. A Program-framed
    # return transfers that index into the measured E axis, conditioned on T.
    # This is not recovery of an unmeasured coherent quantum program or of D.
    rows=[];clock_pairs=[];comp=m.compression()
    for axis in ('X','Z'):
        ev=np.array([1,0]) if axis=='X' else np.array([1,1])/np.sqrt(2)
        sigma=np.kron(np.eye(4),a.P[a.NAMES.index(axis)])
        initial=[]
        for old in (0,1):
            pc=np.zeros(4);pc[2*old]=1;v=np.kron(pc,np.kron(np.array([1,0]),ev));initial.append(np.outer(v,v.conj()))
        for t in (0,1):
            for old,rho in enumerate(initial):
                out=apply(comp,apply(f.instrument(reading,axis,'Program',t),rho));p=np.trace(out).real
                expected=float((-1)**t*np.trace(sigma@out).real/p)
                assert abs(p-.5)<1e-12 and abs(expected-(-1)**old)<1e-12
                rows.append({'axis':axis,'returned_relative':t,'old_relative':old,'branch_probability':float(p),'recovered_old_Z_expectation':expected})
            out=[apply(comp,apply(f.instrument(reading,axis,'Clock',t),rho)) for rho in initial]
            error=float(np.max(abs(out[0]-out[1])));assert error<1e-12
            clock_pairs.append({'axis':axis,'returned_relative':t,'distinct_old_relative_same_subnormalized_output':True,'residual':error})
    return {'program_frame_past_relation':rows,'clock_frame_erased_past_pairs':clock_pairs}


def live(reading):
    rng=np.random.default_rng(19253);z=rng.normal(size=32)+1j*rng.normal(size=32);z/=np.linalg.norm(z);rho=np.outer(z,z.conj())
    full=f.FramedProcess(reading,rho,rng=np.random.default_rng(720))
    owner=f.FramedProcess(reading,rho,rng=np.random.default_rng(720))
    reject(owner.classicalize);reject(owner.control_record)
    old=owner;owner=owner.relative();reject(old.tick);reject(lambda:old.acquire('Z'));reject(owner.classicalize)
    records=[];worst=0.
    for step in range(10):
        full.tick();owner.tick()
        if step%2:full.reopen();owner.reopen()
        axis='X' if sum(x['value'] for x in records)%2 else 'Z';frame='Clock' if records and records[-1]['value'] else 'Program'
        x=owner.acquire(axis,frame);y=full.acquire(axis,frame)
        assert x['value']==y['value'] and abs(x['conditional_probability']-y['conditional_probability'])<1e-10
        assert not any(k in x for k in ('raw','service_eigenlabel','program','clock'));records.append(x)
        if step==2:
            previous=owner;owner=owner.classicalize();reject(previous.snapshot);reject(previous.classicalize)
        state=owner.snapshot()[0]
        if owner._kind=='classical':
            p=np.zeros((2,2));p[owner.control_record(),owner.control_record()]=1;state=np.kron(p,state)
        error=float(np.max(abs(state-apply(m.compression(),full.snapshot()[0],2))))
        assert error<1e-10;worst=max(worst,error)
    final=full.classicalize();assert np.max(abs(final.snapshot()[0]-owner.snapshot()[0]))<1e-10
    reject(lambda:owner.acquire('Y'));reject(lambda:owner.acquire('Z','Unframed'));reject(owner.relative)
    reject(lambda:owner.acquire('Z',value=0));reject(lambda:owner.raw_record())
    fake=deepcopy(reading);fake['rows'][0]['frames']['Program'][1]['after']=[0,0];reject(lambda:f.FramedProcess(fake,rho))
    old=owner._history[-1]['relative_return']['value'];owner._history[-1]['relative_return']['value']=1-old
    reject(owner.tick);owner._history[-1]['relative_return']['value']=old;owner.check()
    # Relative control is acquired although the two absolute PC labels remain
    # unresolved: C is still uniformly distributed after this actual contact.
    diagonal=np.diag([.5,0,0,.5]);e=np.array([1,1])/np.sqrt(2)
    state=np.kron(diagonal,np.kron(np.diag([1,0]),np.outer(e,e)))
    sample=f.FramedProcess(reading,state,rng=np.random.default_rng(90));record=sample.acquire('Z','Program')
    c=float(np.trace(r.at(a.Z,1)@sample.snapshot()[0]).real);assert abs(c)<1e-12
    reduced=sample.classicalize();assert reduced.control_record()==record['value']
    return {'records':records,'transferred_before_acquisition_to_relative':True,'classicalized_after_returns':3,
            'maximum_live_state_residual':worst,'late_full_transfer_agrees':True,
            'known_relative_control_with_unknown_absolute_C_Z':c}


def run(directory):
    global REFUSALS
    REFUSALS=0;reading=json.loads((directory/'framed-reading.json').read_text());f.validate(reading)
    result={'channels':channels(reading),'affine_classification':affine_table(),'obstructions':obstructions(reading),
            'adaptive':adaptive(reading),'relative_past':relative_past(reading),'live':live(reading),'runtime_refusals':REFUSALS,
            'source_sha256':reading['source_sha256'],'implementation_sha256':digest(Path(f.__file__)),
            'test_sha256':digest(Path(__file__)),'cloud_jobs':0}
    write(directory/'audit.json',result);return result


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    result=run(p.parse_args().output.resolve())
    print(json.dumps({'channels':result['channels'],'affine_family_members':len(result['affine_classification']),
                      'obstructions':result['obstructions'],'adaptive':result['adaptive'],'relative_past':result['relative_past'],
                      'live':{k:v for k,v in result['live'].items() if k!='records'},'runtime_refusals':result['runtime_refusals']},indent=2))
