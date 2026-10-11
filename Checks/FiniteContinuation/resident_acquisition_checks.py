#!/usr/bin/env python3
"""Independent instrument, adaptive transcript and current-source audit."""
import argparse
from copy import deepcopy
from fractions import Fraction as F
from itertools import product
import json
from pathlib import Path

import numpy as np
from qiskit import QuantumCircuit
from qiskit.quantum_info import Kraus, Operator, SuperOp

import resident_acquisition as m
import resident_memory as r
import whole_word_admission as a
from environment import write, digest

REFUSALS=0
def reject(f):
    global REFUSALS
    try: f()
    except (ValueError, AssertionError): REFUSALS+=1;return
    raise AssertionError('Unsupported operation accepted')


def apply(ks,rho,ref=1):
    # Independent plain-matrix audit, including subnormalized branches.
    return sum(np.kron(k,np.eye(ref))@rho@np.kron(k.conj().T,np.eye(ref)) for k in ks)


def sdk_toggle(axis):
    # Tensor B,P,C,D,E. B starts at zero, receives a genuine D measurement
    # record coherently, and controls feedback before its terminal readout.
    q=QuantumCircuit(5)
    if axis=='X': q.h(1)
    q.cx(1,4)
    if axis=='X': q.h(1)
    q.cx(4,3)
    u=Operator(q).data
    return [[u[16*b:16*(b+1),:16]] for b in (0,1)]


def instruments(reading,compression):
    maximum=0.;branches=0;images=0;residuals={}
    for mode,axis in product(('Toggle','Install'),('X','Z')):
        all_full=[];all_small=[]
        for b in (0,1):
            full=m.instrument(reading,axis,mode,b);small=m.instrument(reading,axis,mode,b,reduced=True)
            all_full+=full;all_small+=small
            left=SuperOp(Kraus([l@k for l in compression for k in full])).data
            right=SuperOp(Kraus([k@l for k in small for l in compression])).data
            error=float(np.max(abs(left-right)));assert error<1e-12;maximum=max(maximum,error)
            residuals[f'{axis}:{mode}:{b}']=error;branches+=1
            # This branch is trace-nonincreasing, not normalized before compare.
            effect=sum(k.conj().T@k for k in full)
            projector=r.at((a.I+(-1)**b*a.P[a.NAMES.index(axis)])/2,2)
            assert np.max(abs(effect-projector))<1e-12
            mapping=m.branch_map(reading,axis,mode,b)
            for i,key in enumerate(r.KEYS):
                actual=sum(k.conj().T@r.basis_matrix(key)@k for k in full)
                basis=tuple(F(int(j==i)) for j in range(r.N))
                assert np.max(abs(actual-r.matrix(r.push(basis,mapping))))<1e-12;images+=1
            if mode=='Toggle':
                physical=sdk_toggle(axis)[b]
                assert np.max(abs(SuperOp(Kraus(full)).data-SuperOp(Kraus(physical)).data))<1e-12
            else:
                # Independent SDK reset both PC wires, then write the measured b.
                q=QuantumCircuit(4);q.reset(3);q.reset(2)
                if b:q.x(3)
                physical=[k@projector for k in Kraus(q).data]
                assert np.max(abs(SuperOp(Kraus(full)).data-SuperOp(Kraus(physical)).data))<1e-12
        assert Kraus(all_full).is_cptp(atol=1e-12) and Kraus(all_small).is_cptp(atol=1e-12)
    return {'branch_channel_equalities':branches,'unnormalized_superoperator_residuals':residuals,
            'exact_basis_images_independently_checked':images,'max_intertwining_residual':maximum,
            'independent_SDK_instruments':4}


def spaces(reading):
    answers=[]
    for service in (False,True):
        exact=m.selective_space(reading,service=service);expected=16 if service else 8
        assert exact['dimension']==expected
        hand=r.Span()
        for parity,d,e in product((0,1),a.NAMES,('I','Z') if service else ('I',)):
            hand.add(tuple(F((-1)**(parity*(p+c)) if dd==d and ee==e else 0) for p,c,dd,ee in r.KEYS))
        assert len(hand.rows)==expected
        for item in exact['basis']:
            v=[F(0)]*r.N
            for i,x in item['vector']:v[i]=F(x)
            assert not any(hand.residual(v))
        assert exact['renewals']['coordinated_PC'] and exact['renewals']['service_dephase']
        assert exact['renewals']['service_uniform']==(not service)
        answers.append(exact)
    return answers


def boundaries(reading,compression,tick):
    # Identical reduced inputs; ordinary clock restart exposes their hidden p.
    states=[]
    for p,c in ((0,0),(1,1)):
        v=np.zeros(16);v[8*p+4*c]=1;states.append(np.outer(v,v))
    assert np.array_equal(apply(compression,states[0]),apply(compression,states[1]))
    result={}
    for action in ('Restart','Write0'):
        reject(lambda: m.relative_table(reading,action))
        ks=[np.kron(k,np.eye(4)) for k in m.control(reading,action)]
        after=[apply([tick],apply(ks,state)) for state in states]
        values=[float(np.trace(r.at(a.Z,2)@x).real) for x in after]
        assert abs(values[0]-values[1])>.9
        result[action]={'same_reduced_input':True,'next_data_Z':values}
    # Averaged acquisition can be valid while the record itself is unavailable.
    hidden=[r.at(np.diag([1,0]),0),r.at(np.diag([0,1]),0)]
    avg_left=SuperOp(Kraus([l@k for l in compression for k in hidden])).data
    avg_right=SuperOp(Kraus(compression)).data
    assert np.array_equal(avg_left,avg_right)
    probs=[float(np.trace(apply(hidden[:1],state)).real) for state in states]
    assert probs==[1.,0.]
    result['averaging_is_not_branch_preservation']={'averaged_reduced_channel_identical':True,'record_zero_probabilities':probs}
    return result


def adaptive(reading,compression,tick,small_tick):
    rng=np.random.default_rng(649315);nodes=0;worst=0.;probability_error=0.;totals=[]
    # Enumerate all histories, including low-probability ones, on genuinely
    # correlated initial PCDE + untouched two-dimensional reference states.
    for trial in range(3):
        z=rng.normal(size=32)+1j*rng.normal(size=32);z/=np.linalg.norm(z);rho=np.outer(z,z.conj())
        frontier=[((),rho,apply(compression,rho,2))]
        for depth in range(4):
            following=[]
            for history,full,small in frontier:
                full=apply([tick],full,2);small=apply([small_tick],small,2)
                # Policy uses only past returned bits; no program, rho, or law.
                axis='X' if sum(history)%2 else 'Z'
                mode='Install' if history and history[-1] else 'Toggle'
                for b in (0,1):
                    f=apply(m.instrument(reading,axis,mode,b),full,2)
                    s=apply(m.instrument(reading,axis,mode,b,reduced=True),small,2)
                    want=apply(compression,f,2)
                    e=float(np.max(abs(want-s)));pe=float(abs(np.trace(f)-np.trace(s)))
                    assert e<1e-10 and pe<1e-10
                    worst=max(worst,e);probability_error=max(probability_error,pe);nodes+=1
                    following.append((history+(b,),f,s))
            frontier=following
        total=sum(np.trace(f).real for _,f,_ in frontier);assert abs(total-1)<1e-10;totals.append(float(total))
    # Working ownership: use actual sampled acquisitions, transfer the live
    # state after two, continue six more, and compare a separate full executor.
    z=rng.normal(size=32)+1j*rng.normal(size=32);z/=np.linalg.norm(z);rho=np.outer(z,z.conj())
    owner=m.LearningResident(reading,rho);other=m.LearningResident(reading,rho)
    random_full=np.random.default_rng(614);random_small=np.random.default_rng(614);records=[]
    for step in range(8):
        axis='X' if step%2 else 'Z';mode='Toggle' if step%3 else 'Install'
        owner.tick();other.tick()
        x=owner.acquire(axis,mode,rng=random_small);y=other.acquire(axis,mode,rng=random_full)
        assert x['bit']==y['bit'] and abs(x['conditional_probability']-y['conditional_probability'])<1e-10
        records.append(x)
        if step==1:
            old=owner;owner=owner.reduce();reject(old.tick);reject(old.snapshot)
        if step>=1:
            assert np.max(abs(owner.snapshot()[0]-apply(compression,other.snapshot()[0],2)))<1e-10
    before=owner.snapshot();reject(lambda:owner.acquire('Z','Write'));assert np.array_equal(before[0],owner.snapshot()[0])
    reject(lambda:owner.acquire('Y'));reject(owner.reduce)
    fake=deepcopy(reading);fake['rows'][0]['actions']['Toggle1']=[0,0]
    reject(lambda:m.LearningResident(fake,rho))
    saved=owner._tick;owner._tick=np.eye(4);reject(owner.tick);owner._tick=saved
    # No supplied-answer argument exists. The local random seed is a declared
    # test resource, not acquired information about an unknown physical law.
    return {'all_history_nodes_with_reference':nodes,'final_total_probabilities':totals,
            'maximum_joint_state_residual':worst,'maximum_transcript_probability_residual':probability_error,
            'working_acquisitions':records,'transferred_after_acquisitions':2}


def run(directory):
    global REFUSALS
    REFUSALS=0
    reading=json.loads((directory/'acquisition-reading.json').read_text());m.validate(reading)
    _,compression,small_tick=r.reduction(reading['interpreter'],r.closure(reading['interpreter']))
    # Independent complete tick from row action, not the executor's circuit.
    tick=np.zeros((16,16),complex)
    for row in reading['interpreter']['rows']:
        p,c=row['program'],row['clock'];target=2*p+row['next_clock']
        k=np.zeros((4,4));k[target,2*p+c]=1
        tick+=np.kron(k,np.kron({'h':a.H,'s':a.S}[row['gate']],a.Z))
    result={'instruments':instruments(reading,compression),'selective_spaces':spaces(reading),
            'boundaries':boundaries(reading,compression,tick),'adaptive_execution':adaptive(reading,compression,tick,small_tick),
            'runtime_refusals':REFUSALS,'test_sha256':digest(Path(__file__)),'cloud_jobs':0,
            'scope':'Exact finite selective instruments; rational all-finite-history closure; numerical SDK and live local ownership. No hardware or unknown-source guarantee.'}
    write(directory/'audit.json',result);return result


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    result=run(p.parse_args().output.resolve())
    print(json.dumps({'instruments':result['instruments'],'spaces':[x['dimension'] for x in result['selective_spaces']],
                      'boundaries':result['boundaries'],'runtime_refusals':result['runtime_refusals'],
                      'adaptive':{k:v for k,v in result['adaptive_execution'].items() if k!='working_acquisitions'}},indent=2))
