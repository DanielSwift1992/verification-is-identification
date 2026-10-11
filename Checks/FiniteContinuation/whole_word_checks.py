#!/usr/bin/env python3
"""Independent finite checks of the whole-word theorem and local application.

No QPU, no inferred hardware stability, no numerical Choi norm advertised as
a diamond upper bound. The exact norm and composition proofs are analytical.
"""
import argparse
from copy import deepcopy
import json
from pathlib import Path

import numpy as np
from qiskit.quantum_info import Operator,Kraus,SuperOp

import whole_word_admission as a
from environment import write,digest
from joint_return_checks import module_operator


def distance(r,s):return float(np.linalg.norm(r-s,ord='nuc')/2)
def superop(ks):return SuperOp(Kraus(ks)).data
def compose(later,earlier):return [b@c for b in later for c in earlier]
def reject(f):
    try:f()
    except (ValueError,AssertionError):return
    raise AssertionError('Unjustified application was accepted')


def random_channels():
    rng=np.random.default_rng(930172);maximum=0.;rows=[]
    for test in range(12):
        m,out,r=[(1,1,3),(2,2,5),(3,2,5),(2,3,4)][test%4]
        z=rng.normal(size=(2*out*r,2*m))+1j*rng.normal(size=(2*out*r,2*m))
        q=np.linalg.qr(z)[0];ks=list(q.reshape(r,2*out,2*m))
        u=a.ideal(['h','s'] if test%2 else ['s','h']);bs,gamma=a.blocks(ks,u)
        direct=a.twirled(ks,u)
        branches=[np.kron(u@p,b) for p,branch in zip(a.P,bs) for b in branch]
        delta=float(np.max(np.abs(superop(direct)-superop(branches))));assert delta<1e-11
        maximum=max(maximum,delta)
        rr=[b for branch in bs for b in branch];assert Kraus(rr).is_cptp(atol=1e-10)
        for _ in range(2):
            z=rng.normal(size=(m,m))+1j*rng.normal(size=(m,m));tau=z@z.conj().T;tau/=np.trace(tau)
            raw=a.bell_failure(ks,u,tau);tw=a.bell_failure(direct,u,tau);effect=float(np.trace(tau@gamma).real)
            delta=max(abs(raw-tw),abs(raw-effect));maximum=max(maximum,delta);assert delta<1e-11
        eig,v=np.linalg.eigh(gamma);tau=np.outer(v[:,-1],v[:,-1].conj());rho=a.bell_memory(tau)
        target=[np.kron(u,b) for b in rr]
        witness=distance(a.apply(direct,rho,2),a.apply(target,rho,2))
        assert abs(witness-eig[-1])<1e-10
        rows.append({'memory_in':m,'memory_out':out,'kraus':r,'maximum_effect_eigenvalue':float(eig[-1]),'attaining_Bell_witness':witness})
    return {'CPTP_channels':12,'calibration_states':24,'max_residual':maximum,'cases':rows}


def boundaries():
    theta=.17;v=np.cos(theta)*a.I-1j*np.sin(theta)*a.Z
    raw=[np.kron(v,a.I)];tw=a.twirled(raw,a.I);rho=a.bell_memory(a.I/2)
    raw_error=distance(a.apply(raw,rho,2),rho);tw_error=distance(a.apply(tw,rho,2),rho)
    assert abs(raw_error-np.sin(theta))<1e-12 and abs(tw_error-np.sin(theta)**2)<1e-12
    # Seed visible: a label-dependent Y test sees a linear residual even
    # against EVERY identity-data product target with arbitrary flag state.
    plus=np.array([1,1],complex)/np.sqrt(2);rho_plus=np.outer(plus,plus.conj())
    flagged_signal=0.
    for p in a.P:
        w=p@v@p;sign=1 if np.trace(a.Z@p@a.Z@p).real>0 else -1
        flagged_signal+=sign*np.trace(a.Y@w@rho_plus@w.conj().T).real/4
    flagged_lower=abs(flagged_signal)/2
    assert abs(flagged_lower-abs(np.sin(2*theta))/2)<1e-12 and flagged_lower>tw_error
    # If the unknown word is given P as an extra classical input, it can
    # undo the wrapper: P (P V P) P = V in every branch.
    leaked=[p@(p@v@p)@p/2 for p in a.P]
    assert np.max(abs(superop(leaked)-superop([v])))<1e-12
    # One environmental bad direction saturates m e and defeats rank-deficient calibration.
    m=3;b=.6;effect=np.diag([b,0,0]);bad=np.diag([np.sqrt(b),0,0]);good=np.diag([np.sqrt(1-b),1,1])
    ks=[np.kron(a.I,good),np.kron(a.X,bad)]
    e=a.bell_failure(ks,a.I,np.eye(m)/m)
    assert abs(e-b/m)<1e-12
    unsupported=np.diag([0.,1.,0.]);assert a.bell_failure(ks,a.I,unsupported)<1e-12
    rho=a.bell_memory(np.diag([1.,0,0]));target=[np.kron(a.I,c) for c in (good,bad)]
    assert abs(distance(a.apply(ks,rho,2),a.apply(target,rho,2))-b)<1e-12
    # Finer boundaries erase a genuine cancellation: V followed by V†.
    bare=compose([v.conj().T],[v]);fine=compose(a.twirled([v.conj().T],a.I),a.twirled([v],a.I))
    assert np.max(abs(superop(bare)-np.eye(4)))<1e-12
    fine_error=a.bell_failure(fine,a.I,np.ones((1,1)))
    assert abs(fine_error-2*tw_error*(1-tw_error))<1e-12 and fine_error>0
    # Generic scalar diamond bounds alone still do not imply a product rule.
    t=np.pi/6;g=np.diag(np.exp(1j*np.array([t,-t])))
    generic_two=abs(np.sin(2*t));assert generic_two>1-(1-.5)**2
    return {'coherent_raw_error':raw_error,'twirled_error':tw_error,'visible_seed_product_distance_lower':flagged_lower,
            'bad_direction_average_failure':e,'bad_direction_worst_failure':b,
            'rank_deficient_calibration_failure':0,'fine_randomization_breaks_exact_cancellation':fine_error,
            'generic_distance_sum_counterexample':generic_two}


def composition():
    # Memory-dependent branch probabilities and noncommuting E rotations.
    g1=np.diag([.10,.03]);g2=a.H@np.diag([.02,.15])@a.H
    sqrt=lambda x:(lambda ev: (ev[1]*np.sqrt(np.maximum(ev[0],0)))@ev[1].conj().T)(np.linalg.eigh(x))
    r1=[a.H@sqrt(a.I-g1),a.S@sqrt(g1)]
    r2=[a.S@sqrt(a.I-g2),a.H@sqrt(g2)]
    k1=[np.kron(a.I,r1[0]),np.kron(a.X,r1[1])]
    k2=[np.kron(a.I,r2[0]),np.kron(a.Z,r2[1])]
    actual=compose(k2,k1);memory=compose(r2,r1);target=[np.kron(a.I,r) for r in memory]
    bound=1-(1-.1)*(1-.15);rng=np.random.default_rng(409170)
    worst=0.
    for _ in range(80):
        v=rng.normal(size=16)+1j*rng.normal(size=16);v/=np.linalg.norm(v);rho=np.outer(v,v.conj())
        d=distance(a.apply(actual,rho,4),a.apply(target,rho,4));assert d<=bound+1e-11;worst=max(worst,d)
    # Sharp already for two distinct Pauli errors, no memory needed.
    simple=compose([np.sqrt(.85)*a.I,np.sqrt(.15)*a.Z],[np.sqrt(.9)*a.I,np.sqrt(.1)*a.X])
    assert abs(a.bell_failure(simple,a.I,np.ones((1,1)))-bound)<1e-12
    return {'noncommuting_memory_reference_inputs':80,'bound':bound,'largest_sampled_trace_distance':worst,'two_step_sharp_witness':bound}


def scalar_range_and_statistics():
    from scipy.stats import binom
    ranges=[]
    for weights in ([.5,.5],[.15,.25,.6]):
        tau=np.diag(weights);small=min(weights);m=len(weights)
        for e in (.02,.2,.7):
            lo=e;hi=min(1,e/small)
            extremal=np.diag([e/small]+[0.]*(m-1)) if e<=small else np.diag([1.]+[(e-small)/(1-small)]*(m-1))
            for effect in (e*np.eye(m),extremal):
                good=np.diag(np.sqrt(1-np.diag(effect)));bad=np.diag(np.sqrt(np.diag(effect)))
                ks=[np.kron(a.I,good),np.kron(a.X,bad)]
                assert abs(a.bell_failure(ks,a.I,tau)-e)<1e-12
                norm=float(np.max(np.diag(effect)));assert min(abs(norm-lo),abs(norm-hi))<1e-12
            ranges.append({'tau_eigenvalues':weights,'same_Bell_failure':e,'sharp_distance_interval':[lo,hi]})
    n=31;alpha=.01;upper=np.array([a.upper_binomial(k,n,alpha) for k in range(n+1)])
    worst=0.
    for p in np.linspace(0,1,501):
        risk=float(binom.pmf(np.arange(n+1),n,p)[upper<p].sum());worst=max(worst,risk);assert risk<=alpha+1e-12
    assert binom.cdf(1,4096,a.upper_binomial(1,4096,.01))<=.01
    return {'sharp_scalar_ranges':ranges,'binomial_grid_points':501,'largest_grid_noncoverage':worst}


def frame_interpretation(frames):
    count=0
    for row in frames['rows']:
        u=a.ideal(row['question'])
        for model in ('Keep','Moving'):
            aa=module_operator(frames['source'],'Joint'+model,'A');bb=module_operator(frames['source'],'Joint'+model,'B')
            whole=aa@bb@aa@bb@np.kron(u,a.I)@aa@aa
            target=np.kron(u,a.I if model=='Keep' else a.Z)
            for f in row['frames']:
                w=np.kron(a.P[a.NAMES.index(f['after'])],a.I)@whole@np.kron(a.P[a.NAMES.index(f['before'])],a.I)
                assert np.max(abs(w-f['sign']*target))<1e-11
                count+=1
    return count


def application(frames):
    source=a.LocalWord(frames);record=source.acquire();packet=source.decision(record,tolerance=.01)
    assert packet['kind']=='act'
    assert source.decision(record,tolerance=.001)['kind']=='needs_evidence'
    rho=np.outer(np.eye(4).reshape(-1)/2,np.eye(4).reshape(-1)/2).astype(complex)
    start=rho.copy();history=[];steps=[]
    stream=a.LocalContinuation(source,record,rho,tolerance=.01)
    for _ in range(5):
        previous_rho,previous_history=stream.snapshot();proposal=stream.step()
        rho,history=stream.snapshot()
        if proposal['kind']!='act':
            assert np.array_equal(rho,previous_rho) and history==previous_history
            reject(lambda:source.execute(record,proposal,rho,prior=history));steps.append({'kind':proposal['kind'],'bound':proposal['total_bound']});break
        n=len(history);u=np.linalg.matrix_power(np.kron(a.H,a.Z),n)
        target=np.kron(u,np.eye(4))@start@np.kron(u.conj().T,np.eye(4))
        actual=distance(rho,target);assert actual<=proposal['total_bound']+1e-10
        steps.append({'kind':'act','bound':proposal['total_bound'],'actual_reference_trace_error':actual})
    assert len(history)>=1 and steps[-1]['kind']=='needs_evidence'
    bad=deepcopy(record);bad['failures']=0;reject(lambda:source.decision(bad,tolerance=.01))
    reject(lambda:source.decision(record,tolerance=.01,seed_output=True))
    reject(lambda:source.decision(record,tolerance=.01,question=['s']))
    bad=deepcopy(packet);bad['one_use_bound']=0;reject(lambda:source.execute(record,bad,start))
    bad=deepcopy(history);bad[0]['total_bound']=0;reject(lambda:source.decision(record,tolerance=.01,prior=bad))
    # Archived hardware evidence cannot be interpreted as a fixed simulator law.
    ibm=json.loads((a.ROOT/'Research/Artifacts/ibm-joint-memory-20260914.json').read_text())
    reject(lambda:source.decision(ibm,tolerance=.01))
    old=source.wrapped;source.wrapped=source.ks;reject(lambda:source.decision(record,tolerance=.01));source.wrapped=old
    old=source.body;source.body=[{'gate':'reset','target':'E'}]+old;reject(lambda:source.decision(record,tolerance=.01));source.body=old
    rank=a.LocalWord(frames,tau=np.diag([1.,0.]));rec=rank.acquire(simulation_seed=8301)
    assert rank.decision(rec,tolerance=.01)['kind']=='needs_coverage'
    exact=a.LocalWord(frames,residual_sine=0);assert a.bell_failure(exact.wrapped,exact.u,a.I/2)<1e-12
    return {'record':record,'first_application':packet,'steps':steps,'refusals':9,
            'raw_coherent_error':.02,'exact_randomized_product_error':.0004,
            'saturation_Moving_data_failure':a.bell_failure(exact.wrapped,exact.u,a.I/2)}


def run(directory):
    frames=json.loads((directory/'frame-reading.json').read_text())
    a.validate_frames(frames)
    result={'frame_interpretations':frame_interpretation(frames),'random_channels':random_channels(),
            'boundaries':boundaries(),'composition':composition(),'scalar_and_statistics':scalar_range_and_statistics(),'application':application(frames),
            'limits':'Local fixed-source sampling and mathematical witnesses; no empirical IBM diamond claim or generic channel-distance product rule.',
            'test_sha256':digest(Path(__file__))}
    write(directory/'audit.json',result)
    return result


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',required=True,type=Path)
    r=run(p.parse_args().output.resolve())
    print(json.dumps({'frame_interpretations':r['frame_interpretations'],'random_channel_max_residual':r['random_channels']['max_residual'],
                     'boundaries':r['boundaries'],'composition':r['composition'],
                     'sample':{k:r['application']['record'][k] for k in ('shots','failures','alpha')},
                     'continuation':r['application']['steps'],'refusals':r['application']['refusals']},indent=2))
