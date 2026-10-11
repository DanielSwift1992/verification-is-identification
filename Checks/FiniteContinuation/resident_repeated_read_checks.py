#!/usr/bin/env python3
"""Repeated same-branch readings: decoder, sharp rate boundary and live state."""
import argparse
from copy import deepcopy
from fractions import Fraction as F
from itertools import product
import io
import json
from pathlib import Path
import time

import numpy as np
from scipy.optimize import linprog
from qiskit import QuantumCircuit,ClassicalRegister,qpy
from qiskit_aer import AerSimulator
from qiskit_aer.library import save_density_matrix,set_density_matrix

import resident_repeated_read as repeated
from resident_measurement_wire_checks import I,X,j,embed
from environment import write,digest


def g(p):return 3*p*p-2*p*p*p


def analytic():
    rows=[]
    for p,d in [(F(1,10),F(1,10)),(F(1,5),F(0)),(F(1,5),F(1,5)),(F(1,4),F(1,4)),(F(2,5),F(0)),(F(2,5),F(2,5))]:
        a,b=p-d,p+d;r=(g(a)+g(b))/2
        assert r==g(p)+3*(1-2*p)*d*d
        expected_reads=2+2*p*(1-p)-2*d*d
        assert expected_reads==2+a*(1-a)+b*(1-b)
        rows.append({'single_average':float(p),'p01':float(a),'p10':float(b),'majority_error':float(r),
            'early_decision_expected_reads':float(expected_reads),'early_decision_is_not_the_fixed_three_read_implementation':True})
    # The source decoder's one-error region is exactly each radius-one ball.
    ambiguity=[votes for votes in product((0,1),repeat=2) if sum(votes)<=1 and sum(1-x for x in votes)<=1]
    assert ambiguity==[(0,1),(1,0)]
    p=F(1,5);dist={
        'independent':{v:p**sum(v)*(1-p)**(3-sum(v)) for v in product((0,1),repeat=3)},
        'one_common_mask':{(0,0,0):1-p,(1,1,1):p},
        'at_most_one_error':{(0,0,0):1-3*p,**{v:p for v in [(1,0,0),(0,1,0),(0,0,1)]}},
        'paired_errors':{(0,0,0):1-F(3,2)*p,**{v:p/2 for v in [(1,1,0),(1,0,1),(0,1,1)]}}}
    correlated=[]
    for name,law in dist.items():
        assert sum(law.values())==1
        marginals=[sum(weight*v[i] for v,weight in law.items()) for i in range(3)];assert marginals==[p]*3
        r=sum(weight for v,weight in law.items() if sum(v)>=2)
        correlated.append({'law':name,'individual_error_rates':list(map(float,marginals)),'majority_error':float(r)})
    return {'asymmetric_examples':rows,'two_reads_one_error_ambiguity':[list(v) for v in ambiguity],
        'same_marginals_different_correlations':correlated,
        'fixed_average_independent_bounds':'For 0<=p<=1/2: g(p) <= r <= 6p^2-8p^3; the upper bound is <=p iff p<=1/4 or p=1/2.',
        'arbitrary_correlation_equal_marginal_bounds':'max(0,(3p-1)/2) <= P(majority error) <= min(1,3p/2).',
        'scope':'Three reports of one preserved true bit; conditional independence and arbitrary correlation are distinct models.'}


def minimax_check():
    # Independent finite LP includes every randomized decoder of eight actual
    # vote words. The continuum theorem is proved separately by symmetrization.
    words=list(product((0,1),repeat=3));rows=[]
    for p in (.05,.1,.2,.25,.3,.4,.49,.5):
        constraints=[];bounds=[]
        for a in np.linspace(0,2*p,201):
            b=2*p-a
            zero=np.array([a**sum(v)*(1-a)**(3-sum(v)) for v in words])
            one=np.array([(1-b)**sum(v)*b**(3-sum(v)) for v in words])
            constraints.append(list((zero-one)/2)+[-1]);bounds.append(-.5)
        fit=linprog([0]*8+[1],A_ub=constraints,b_ub=bounds,bounds=[(0,1)]*9,method='highs')
        assert fit.success
        expected=min(p,6*p*p-8*p*p*p)
        assert abs(fit.fun-expected)<1e-9
        rows.append({'known_single_average':p,'analytic_minimax_error':expected,'finite_grid_all_decoders_LP':float(fit.fun),
            'attaining_policy':'majority' if p<=.25 else 'one actual report'})
    return {'cases':rows,'scope':'Uniform true branch supplied by the wire; conditional IID given that branch; only p=(p01+p10)/2 known, 0<=p<=1/2. LP grid checks the analytic continuum theorem, not vice versa.'}


def decoder_truth(source):
    rows=[]
    for row in source['table']:
        q=QuantumCircuit(1);v=ClassicalRegister(3,'votes');out=ClassicalRegister(1,'out');q.add_register(v,out)
        for bit,value in zip(v,row['votes']):q.store(bit,bool(value))
        with q.if_test(repeated.majority(*v)):q.x(0)
        q.measure(0,out[0]);r=AerSimulator().run(q,shots=4,memory=True).result()
        assert all((int(t.replace(' ',''),2)>>3)&1==row['answer'] for t in r.get_memory())
        rows.append({'actual_votes':row['votes'],'measured_decoding':row['answer']})
    return rows


def main_word(source,n):
    angles=[[[0,1],[1,4],[-1,3]][i%3] for i in range(n)]
    q=QuantumCircuit(4);w=repeated.wire.Wire(q,source['wire'],repeated.wire.plan(source['wire']))
    w.append(angles);w.rectify();q.metadata={'boundary':w.boundary()}
    return q,angles,w.owner


def deterministic_reports(device,pattern):
    q=device.copy_empty_like();i=0
    for item in device.data:
        if item.operation.name=='kraus':
            if pattern[i%3]:q.x(4)
            i+=1
        else:q.append(item)
    assert i==device.metadata['physical_report_reads']
    return q


def sdk(source,n,pair,seed,pattern=None,shots=64):
    main,angles,owner=main_word(source,n);device=repeated.compile_reports(main,source,pair)
    if pattern is not None:device=deterministic_reports(device,pattern)
    stream=io.BytesIO();qpy.dump(device,stream);stream.seek(0);restored,=qpy.load(stream)
    assert device==restored and repeated.work.ordered_bindings(device)==repeated.work.ordered_bindings(restored)
    rng=np.random.default_rng(seed);v=rng.normal(size=8)+1j*rng.normal(size=8);v/=np.linalg.norm(v);initial=np.outer(v,v.conj())
    q=restored.copy_empty_like();set_density_matrix(q,np.kron(np.diag([1,0]),embed(initial,0)))
    history=ClassicalRegister(3*n,'audit_reports');q.add_register(history);i=0
    for item in restored.data:
        q.append(item)
        if item.operation.name=='measure':q.store(history[i],item.clbits[0]);i+=1
    assert i==3*n
    save_density_matrix(q,range(5),label='output',pershot=True)
    with q.if_test((main.cregs[0][0],0)):q.s(owner)  # a real use of the rectified live carrier
    save_density_matrix(q,range(5),label='consumer',pershot=True)
    result=AerSimulator(method='density_matrix',max_parallel_threads=1).run(q,shots=shots,memory=True,seed_simulator=seed+17).result()
    assert result.success;maximum=0.;triples={};u=I.astype(complex)
    for a in angles:u=j(np.pi*a[0]/a[1])@u
    for index,text in enumerate(result.get_memory()):
        word=int(text.replace(' ',''),2);assert word&31==0
        reports=[(word>>q.find_bit(bit).index)&1 for bit in history];rho=initial
        for step,a in enumerate(angles):
            votes=reports[3*step:3*step+3];y=int(sum(votes)>=2);triples[''.join(map(str,votes))]=triples.get(''.join(map(str,votes)),0)+1
            value=np.zeros_like(rho)
            for b,p in enumerate(pair):
                likelihood=(float(all(v==(b^e) for v,e in zip(votes,pattern))) if pattern is not None
                    else np.prod([p if vote!=b else 1-p for vote in votes]))
                k=np.kron(np.eye(4),np.linalg.matrix_power(X,b^y)@j(np.pi*a[0]/a[1]))/np.sqrt(2)
                value+=likelihood*k@rho@k.conj().T
            assert np.trace(value).real>0;rho=value/np.trace(value).real
        if pattern is not None and sum(pattern)<=1:
            uu=np.kron(np.eye(4),u);assert np.max(abs(rho-uu@initial@uu.conj().T))<1e-11
        for name,expected in [('output',rho),('consumer',np.kron(np.eye(4),np.diag([1,1j]))@rho@np.kron(np.eye(4),np.diag([1,-1j])))]:
            full=np.kron(np.diag([1,0]),embed(expected,owner))
            e=float(np.max(abs(result.data()[name][index].data-full)));assert e<1e-10;maximum=max(maximum,e)
    return {'logical_steps':n,'report_reads':3*n,'qubits':5,'working_classical_bits':5,
        'p01':pair[0],'p10':pair[1],'deterministic_error_pattern':pattern,'majority_rate_if_stochastic':(g(pair[0])+g(pair[1]))/2,
        'actual_vote_counts':triples,'full_joint_states_checked':2*shots,'maximum_joint_state_error':maximum,
        'QPY_bytes':len(stream.getvalue())},device


def changed_carrier_counterexample():
    rows=[]
    for b in (0,1):
        for preserve in (False,True):
            q=QuantumCircuit(2);votes=ClassicalRegister(3,'votes');out=ClassicalRegister(1,'out');q.add_register(votes,out)
            if b:q.x(0)
            for i in range(3):
                q.reset(1)
                if i==0 and not preserve:q.x(0)
                q.cx(0,1)
                if i==0 and preserve:q.x(1)
                q.measure(1,votes[i])
            q.reset(1)
            with q.if_test(repeated.majority(*votes)):q.x(1)
            q.measure(1,out[0]);r=AerSimulator().run(q,shots=4,memory=True).result()
            values={int(t.replace(' ',''),2) for t in r.get_memory()};assert len(values)==1
            word=values.pop();decoded=(word>>3)&1;actual=[(word>>i)&1 for i in range(3)]
            assert decoded==(b if preserve else 1-b)
            rows.append({'true_initial_bit':b,'retiring_carrier_preserved':preserve,'one_physical_flip':'report probe' if preserve else 'retiring carrier','actual_votes':actual,'decoded':decoded})
    return rows


def guards(source):
    main,_,_=main_word(source,2);names=[]
    def no(name,action):
        try:action()
        except (ValueError,AssertionError):names.append(name);return
        raise AssertionError('Accepted '+name)
    no('re-read after changing the original branch',lambda:repeated.compile_reports(main,source,(.1,.3),preserve_branch=False))
    bad=deepcopy(source);bad['table'][3]['answer']=0
    no('decoder misses a valid one-error realization',lambda:repeated.validate(bad))
    changed=main.copy();changed.x(0)
    no('extra quantum action under an unchanged source boundary',lambda:repeated.compile_reports(changed,source,(.1,.3)))
    no('invalid reporter probability',lambda:repeated.compile_reports(main,source,(.1,1.1)))
    return names


def run(output):
    start=time.perf_counter();source=json.loads((output/'repeated-reading.json').read_text());rows=[]
    for n in (1,2,8,32):
        for pair in ((.1,.3),(.0,.8)):
            r,device=sdk(source,n,pair,101071+n);rows.append(r)
    for pattern in ([0,0,0],[1,0,0],[0,1,0],[0,0,1]):
        r,_=sdk(source,3,(.1,.3),101171+sum(pattern),pattern);rows.append(r)
    main,_,_=main_word(source,8);device=repeated.compile_reports(main,source,(.1,.3))
    with (output/'repeated-read-word.qpy').open('wb') as f:qpy.dump(device,f)
    result={'source':repeated.wire.admission.fingerprint(source),'analytic':analytic(),'minimax':minimax_check(),
        'source_decoder_truth_table':decoder_truth(source),'sdk':rows,
        'changed_branch_counterexample':changed_carrier_counterexample(),'refusals':guards(source),
        'full_joint_states_checked':sum(r['full_joint_states_checked'] for r in rows),
        'maximum_joint_state_error':max(r['maximum_joint_state_error'] for r in rows),
        'seconds':time.perf_counter()-start,'new_QPU_jobs':0,'full_regression':False,
        'implementation_sha256':digest(Path(repeated.__file__)),'check_sha256':digest(Path(__file__))}
    write(output/'audit.json',result);return result


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    r=run(p.parse_args().output.resolve());print(json.dumps({k:r[k] for k in ['full_joint_states_checked','maximum_joint_state_error','seconds']}))
