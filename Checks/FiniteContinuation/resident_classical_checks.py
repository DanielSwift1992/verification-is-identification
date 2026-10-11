#!/usr/bin/env python3
"""All-branch channel, exact closure and actual owned-transfer audit.

Matrix oracle retains unnormalized branches and an untouched reference.
No cloud jobs, postselected retries, or general Swift validation.
"""
import argparse
from copy import deepcopy
from fractions import Fraction as F
from itertools import product
import json
from pathlib import Path

import numpy as np
from qiskit import QuantumCircuit
from qiskit.quantum_info import Kraus, Operator, SuperOp

import resident_classical as m
import resident_memory as r
import resident_acquisition as acq
import whole_word_admission as a
from environment import digest,write

REFUSALS=0
def reject(f):
    global REFUSALS
    try: f()
    except (ValueError,AssertionError,TypeError): REFUSALS+=1;return
    raise AssertionError('Unsupported use accepted')


def apply(ks,rho,ref=1):
    return sum(np.kron(k,np.eye(ref))@rho@np.kron(k.conj().T,np.eye(ref)) for k in ks)


def full_tick(reading):
    result=np.zeros((16,16),complex)
    for row in reading['acquisition']['interpreter']['rows']:
        p,c=row['program'],row['clock'];pc=np.zeros((4,4));pc[2*p+row['next_clock'],2*p+c]=1
        result+=np.kron(pc,np.kron({'h':a.H,'s':a.S}[row['gate']],a.Z))
    return result


def sdk_toggle(axis):
    # Ancilla B records service E, not data D; tensor B,P,C,D,E.
    q=QuantumCircuit(5)
    if axis=='X': q.h(0)
    q.cx(0,4)
    if axis=='X': q.h(0)
    q.cx(4,3)
    u=Operator(q).data
    return [[u[16*b:16*(b+1),:16]] for b in (0,1)]


def intertwining(reading):
    compression=m.compression();residuals={};images=0;sdk=0
    pairs=[('tick',[full_tick(reading)],[m.relative_tick(reading)]),
           ('reopen',[np.kron(np.eye(4),np.diag([1,1,1,-1]))],[m.reopen(reading)])]
    for mode,axis in product(('Toggle','Install'),('X','Z')):
        whole=[]
        for b in (0,1):
            full=m.instrument(reading,axis,mode,b);small=m.instrument(reading,axis,mode,b,relative=True)
            pairs.append((f'{axis}:{mode}:{b}',full,small));whole+=full
            effect=sum(k.conj().T@k for k in full)
            projector=r.at((a.I+(-1)**b*a.P[a.NAMES.index(axis)])/2,3)
            assert np.max(abs(effect-projector))<1e-12
            mapping=m.branch_map(reading,axis,mode,b)
            for i,key in enumerate(r.KEYS):
                actual=sum(k.conj().T@r.basis_matrix(key)@k for k in full)
                vector=tuple(F(int(i==j)) for j in range(r.N))
                assert np.max(abs(actual-r.matrix(r.push(vector,mapping))))<1e-12;images+=1
            if mode=='Toggle': physical=sdk_toggle(axis)[b]
            else:
                q=QuantumCircuit(4);q.reset(3);q.reset(2)
                if b:q.x(3)
                physical=[k@projector for k in Kraus(q).data]
            assert np.max(abs(SuperOp(Kraus(full)).data-SuperOp(Kraus(physical)).data))<1e-12;sdk+=1
        assert Kraus(whole).is_cptp(atol=1e-12)
    for name,full,small in pairs:
        left=SuperOp(Kraus([l@k for l in compression for k in full])).data
        right=SuperOp(Kraus([k@l for k in small for l in compression])).data
        error=float(np.max(abs(left-right)));assert error<1e-12;residuals[name]=error
    assert Kraus(compression).is_cptp(atol=1e-12)
    assert np.max(abs(Operator(r.circuit(reading['acquisition']['interpreter'])).data-full_tick(reading)))<1e-12
    return {'unnormalized_superoperator_equalities':residuals,'exact_basis_images_checked':images,'independent_SDK_branches':sdk}


def space(reading):
    result=m.selective_space(reading)
    hand=r.Span()
    for parity,d,e in product((0,1),a.NAMES,a.NAMES):
        hand.add(tuple(F((-1)**(parity*(p+c)) if dd==d and ee==e else 0) for p,c,dd,ee in r.KEYS))
    assert len(hand.rows)==32 and result['dimension']==32
    for item in result['basis']:
        v=[F(0)]*r.N
        for i,x in item['vector']:v[i]=F(x)
        assert not any(hand.residual(v))
    assert result['renewals']['coordinated_PC'] and result['renewals']['program_dephase']
    assert not result['renewals']['service_dephase'] and not result['renewals']['service_uniform']
    return result


def adaptive(reading):
    rng=np.random.default_rng(159031);comp=m.compression();v=full_tick(reading);vr=m.relative_tick(reading)
    nodes=0;worst=0.;prob=0.;totals=[]
    for trial in range(3):
        z=rng.normal(size=32)+1j*rng.normal(size=32);z/=np.linalg.norm(z);rho=np.outer(z,z.conj())
        frontier=[((),rho,apply(comp,rho,2))]
        for depth in range(5):
            following=[]
            for history,full,small in frontier:
                full=apply([v],full,2);small=apply([vr],small,2)
                if depth%2:
                    full=apply([m.reopen(reading,full=True)],full,2);small=apply([m.reopen(reading)],small,2)
                axis='X' if sum(history)%2 else 'Z';mode='Install' if history and history[-1] else 'Toggle'
                for b in (0,1):
                    f=apply(m.instrument(reading,axis,mode,b),full,2)
                    s=apply(m.instrument(reading,axis,mode,b,relative=True),small,2)
                    e=float(np.max(abs(apply(comp,f,2)-s)));p=float(abs(np.trace(f)-np.trace(s)))
                    assert e<1e-10 and p<1e-10;worst=max(worst,e);prob=max(prob,p);nodes+=1
                    following.append((history+(b,),f,s))
            frontier=following
        total=sum(np.trace(f).real for _,f,_ in frontier);assert abs(total-1)<1e-10;totals.append(float(total))
    return {'all_history_nodes_with_reference':nodes,'maximum_joint_state_residual':worst,
            'maximum_transcript_probability_residual':prob,'total_probabilities_at_depth_five':totals}


def de_reference_bell():
    # D-Ref Bell, E plus. Neither D nor the service outcome is supplied to policy.
    z=np.zeros(8,complex)
    for d,e in product((0,1),repeat=2):z[4*d+2*e+d]=.5
    return np.outer(z,z.conj())


def trace_service(rho):
    return np.trace(rho.reshape(2,2,2,2,2,2),axis1=1,axis2=4).reshape(4,4)


def bell_fidelity(rho):
    b=np.array([1,0,0,1])/np.sqrt(2);return float((b@rho@b).real)


def encode_classical(owner):
    state,_=owner.snapshot();p=np.zeros((2,2));p[owner.control_record(),owner.control_record()]=1
    return np.kron(p,state)


def owned(reading):
    pc=np.ones((4,4))/4;rho=np.kron(pc,de_reference_bell());comp=m.compression()
    full=m.ServiceResident(reading,rho,rng=np.random.default_rng(9715))
    holder=m.ServiceResident(reading,rho,rng=np.random.default_rng(9715))
    reject(holder.classicalize);reject(holder.control_record)
    record=holder.acquire('Z','Install');other=full.acquire('Z','Install');assert record['bit']==other['bit']
    before=holder;holder=holder.classicalize();reject(before.tick);reject(lambda:before.acquire('X'));reject(before.snapshot)
    data_ref=trace_service(holder.snapshot()[0]);fid=bell_fidelity(data_ref)
    partial=data_ref.reshape(2,2,2,2).transpose(2,1,0,3).reshape(4,4)
    negativity=float(-sum(x for x in np.linalg.eigvalsh(partial) if x<0))
    assert abs(fid-1)<1e-12 and abs(negativity-.5)<1e-12
    records=[record];worst=0.
    for step in range(10):
        b=holder.control_record();holder.tick();full.tick()
        if step==0:
            # The unknown quantum payload remains usable: inverse known local
            # gate recovers Bell correlation, without touching the reference.
            g={'JointHLabel':a.H,'JointSLabel':a.S}[reading['controls'][b]['gate']]
            undone=apply([np.kron(g.conj().T,a.I)],holder.snapshot()[0],2)
            assert abs(bell_fidelity(trace_service(undone))-1)<1e-12
        if step%2: holder.reopen();full.reopen()
        axis='X' if sum(x['bit'] for x in records)%2 else 'Z';mode='Install' if step%3==1 else 'Toggle'
        x=holder.acquire(axis,mode);y=full.acquire(axis,mode)
        assert x['bit']==y['bit'] and abs(x['conditional_probability']-y['conditional_probability'])<1e-10
        records.append(x)
        error=float(np.max(abs(encode_classical(holder)-apply(comp,full.snapshot()[0],2))))
        assert error<1e-10;worst=max(worst,error)
    # Delayed transfer must fold the intervening actual program changes.
    late=full.classicalize();assert late.control_record()==holder.control_record()
    assert np.max(abs(late.snapshot()[0]-holder.snapshot()[0]))<1e-10
    reject(holder.classicalize);reject(lambda:holder.acquire('Y'));reject(lambda:holder.acquire('X','Write'))
    reject(lambda:holder.acquire('X','Toggle',bit=0))
    fake=deepcopy(reading);fake['probes']['X']['port']='ResidentDataPort'
    reject(lambda:m.ServiceResident(fake,rho))
    fake=deepcopy(reading);fake['controls'][0]['next']=0;reject(lambda:m.ServiceResident(fake,rho))
    old=holder._classical;holder._classical=1-old;reject(holder.tick);holder._classical=old
    old=holder._history[-1]['acquisition']['bit'];holder._history[-1]['acquisition']['bit']=1-old
    reject(holder.tick);holder._history[-1]['acquisition']['bit']=old
    old=holder._state;holder._state=old[::-1,::-1].copy();reject(holder.tick);holder._state=old
    reject(lambda:m.ClassicalService(None,holder,holder.snapshot()[0],0))
    holder.check()
    return {'quantum_payload_reference_Bell_fidelity_after_install_and_transfer':fid,
            'payload_reference_negativity':negativity,'live_acquisitions':records,'live_tick_count':10,
            'quantum_carrier_dimensions_before_after':[16,4],'classical_control_bits':1,
            'maximum_live_state_residual':worst,'delayed_transfer_agrees':True}


def boundaries(reading):
    # Discarding E coherence was allowed for the earlier CZ-only service. It is
    # invalid when the new interface actually acquires service X.
    states=[]
    for sign in (1,-1):
        e=np.array([1,sign])/np.sqrt(2);v=np.kron(np.array([1,0,0,0]),np.kron(np.array([1,0]),e))
        states.append(np.outer(v,v.conj()))
    old_dephase=[r.at(np.diag([1,0]),3),r.at(np.diag([0,1]),3)]
    assert np.max(abs(apply(old_dephase,states[0])-apply(old_dephase,states[1])))<1e-12
    probs=[float(np.trace(apply(m.instrument(reading,'X','Install',0),x)).real) for x in states]
    assert abs(probs[0]-1)<1e-12 and abs(probs[1])<1e-12
    # A coherent program question really is lost, even with the same entire
    # reduced RDE state. It is outside the future action grammar.
    coherent=[]
    for sign in (1,-1):
        v=np.zeros(16);v[0]=1/np.sqrt(2);v[8]=sign/np.sqrt(2);coherent.append(np.outer(v,v))
    assert np.max(abs(apply(m.compression(),coherent[0])-apply(m.compression(),coherent[1])))<1e-12
    answers=[float(np.trace(r.at(a.X,0)@x).real) for x in coherent]
    assert abs(answers[0]-1)<1e-12 and abs(answers[1]+1)<1e-12
    return {'old_service_dephasing_has_same_record_but_new_X_zero_probabilities':probs,
            'same_RDE_coherent_program_X_answers':answers}


def run(directory):
    global REFUSALS
    REFUSALS=0;reading=json.loads((directory/'classical-reading.json').read_text());m.validate(reading)
    result={'channels':intertwining(reading),'selective_space':space(reading),'adaptive':adaptive(reading),
            'owned_execution':owned(reading),'boundaries':boundaries(reading),'runtime_refusals':REFUSALS,
            'source_sha256':reading['source_sha256'],'implementation_sha256':digest(Path(m.__file__)),
            'test_sha256':digest(Path(__file__)),'cloud_jobs':0,
            'scope':'Exact finite service instrument and classical acquired-control construction, numerically audited with SDK and untouched reference. Not a hardware improvement claim.'}
    write(directory/'audit.json',result);return result


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    result=run(p.parse_args().output.resolve())
    print(json.dumps({'channels':result['channels'],'dimension':result['selective_space']['dimension'],
                      'adaptive':result['adaptive'],'owned':{k:v for k,v in result['owned_execution'].items() if k!='live_acquisitions'},
                      'boundaries':result['boundaries'],'runtime_refusals':result['runtime_refusals']},indent=2))
