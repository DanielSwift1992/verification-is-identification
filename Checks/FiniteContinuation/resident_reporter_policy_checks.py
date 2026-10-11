#!/usr/bin/env python3
"""Independent moment algebra, acquired choices and live SDK consumers."""
import argparse
from copy import deepcopy
from fractions import Fraction as F
from itertools import product
import io
import json
import math
from pathlib import Path
import shutil
import tempfile
import time

import numpy as np
from qiskit import QuantumCircuit,ClassicalRegister,qpy
from qiskit_aer import AerSimulator
from qiskit_aer.library import set_density_matrix,save_density_matrix

import resident_reporter_policy as policy
from resident_measurement_wire_checks import I,X,j,embed
from environment import write,digest

CASES=[('asymmetric_low_one',(.02,.6),'AnyOne'),('symmetric',(.15,.15),'Majority'),('asymmetric_low_zero',(.6,.02),'AllOne')]


def law(pair,v):
    a,b=pair;k=sum(v);n=len(v)
    return (a**k*(1-a)**(n-k)+(1-b)**k*b**(n-k))/2


def risk(pair,answers):
    a,b=pair
    return sum((a**sum(v)*(1-a)**(3-sum(v)) if answers[v] else (1-b)**sum(v)*b**(3-sum(v))) for v in product((0,1),repeat=3))/2


def algebra():
    rows=[]
    for a,b in [(F(1,50),F(3,5)),(F(3,20),F(3,20)),(F(3,5),F(1,50)),(F(1,5),F(4,5))]:
        m=(1+a-b)/2;s=(a*a+(1-b)**2)/2;c=s-m*m;p=(a+b)/2
        assert c==(F(1,2)-p)**2
        inferred=(.5-math.sqrt(float(c))+float(m)-.5,.5-math.sqrt(float(c))-float(m)+.5)
        assert max(abs(x-float(y)) for x,y in zip(inferred,(a,b)))<1e-12
        mirror=(1-b,1-a)
        checked=0
        for n in range(1,7):
            for v in product((0,1),repeat=n):assert law((a,b),v)==law(mirror,v);checked+=1
        answers={v:int(sum(v)>=2) for v in product((0,1),repeat=3)}
        assert risk((a,b),answers)+risk(mirror,answers)==1
        rows.append({'pair':list(map(float,(a,b))),'observed_mean':float(m),'observed_second_moment':float(s),
            'inferred_pair':list(inferred),'mirror_pair':list(map(float,mirror)),'indistinguishable_words_checked':checked})
    # Same conditional pair marginals as IID, different third-order error law.
    p=F(1,5);dependent=[]
    for t in [F(0),p**3,p*p]:
        distribution={v:({0:1-3*p+3*p*p-t,1:p-2*p*p+t,2:p*p-t,3:t}[sum(v)]) for v in product((0,1),repeat=3)}
        assert sum(distribution.values())==1 and min(distribution.values())>=0
        for i,jj in [(0,1),(0,2),(1,2)]:
            for bits in product((0,1),repeat=2):
                found=sum(w for v,w in distribution.items() if (v[i],v[jj])==bits)
                assert found==p**sum(bits)*(1-p)**(2-sum(bits))
        dependent.append({'triple_error_probability':float(t),'each_error_rate':float(p),
            'every_pair_independent':True,'majority_error':float(sum(w for v,w in distribution.items() if sum(v)>=2))})
    return {'moments_and_orientation':rows,'pairwise_independence_not_triple_independence':dependent,
        'scope':'Exact fraction checks support the general derivations; finite record agreement does not establish the fixed reporter model.'}


def truth(source):
    out=[]
    for name,table in source['policies'].items():
        for row in table:
            q=QuantumCircuit(1);v=ClassicalRegister(3,'votes');answer=ClassicalRegister(1,'answer');q.add_register(v,answer)
            for bit,x in zip(v,row['votes']):q.store(bit,bool(x))
            with q.if_test(policy.policy_expression(name,*v)):q.x(0)
            q.measure(0,answer[0]);r=AerSimulator().run(q,shots=4,memory=True).result()
            assert all((int(x.replace(' ',''),2)>>3)&1==row['answer'] for x in r.get_memory())
        out.append({'policy':name,'actual_truth_rows':len(table)})
    return out


def live(session,packet,n,seed,shots=64):
    angles=[[[0,1],[1,4],[-1,3]][i%3] for i in range(n)]
    device=session.working_body(packet,angles);owner=device.metadata['wire_boundary']['boundary']['physical_owner']
    buf=io.BytesIO();qpy.dump(device,buf);buf.seek(0);restored,=qpy.load(buf)
    assert device==restored and policy.repeated.work.ordered_bindings(device)==policy.repeated.work.ordered_bindings(restored)
    rng=np.random.default_rng(seed);v=rng.normal(size=8)+1j*rng.normal(size=8);v/=np.linalg.norm(v);initial=np.outer(v,v.conj())
    q=restored.copy_empty_like();set_density_matrix(q,np.kron(np.diag([1,0]),embed(initial,0)))
    history=ClassicalRegister(3*n,'audit_reports');q.add_register(history);count=0
    for item in restored.data:
        q.append(item)
        if item.operation.name=='measure':q.store(history[count],item.clbits[0]);count+=1
    assert count==3*n
    save_density_matrix(q,range(5),label='output',pershot=True)
    q.s(owner);save_density_matrix(q,range(5),label='consumer',pershot=True)
    result=AerSimulator(method='density_matrix',max_parallel_threads=1).run(q,shots=shots,memory=True,seed_simulator=seed+19).result()
    assert result.success;maximum=0.;table={tuple(row['votes']):row['answer'] for row in session.source['policies'][packet['policy']]}
    for index,text in enumerate(result.get_memory()):
        word=int(text.replace(' ',''),2);assert word&31==0
        records=[(word>>q.find_bit(bit).index)&1 for bit in history];rho=initial
        for step,angle in enumerate(angles):
            votes=tuple(records[3*step:3*step+3]);answer=table[votes];value=np.zeros_like(rho)
            for b,p in enumerate(session.pair):
                likelihood=np.prod([p if x!=b else 1-p for x in votes])
                k=np.kron(np.eye(4),np.linalg.matrix_power(X,b^answer)@j(np.pi*angle[0]/angle[1]))/np.sqrt(2)
                value+=likelihood*k@rho@k.conj().T
            assert np.trace(value).real>0;rho=value/np.trace(value).real
        consumer=np.kron(np.eye(4),np.diag([1,1j]));after=consumer@rho@consumer.conj().T
        for name,state in [('output',rho),('consumer',after)]:
            expected=np.kron(np.diag([1,0]),embed(state,owner));e=float(np.max(abs(result.data()[name][index].data-expected)))
            assert e<1e-10;maximum=max(maximum,e)
    return {'logical_steps':n,'acquired_policy':packet['policy'],'full_joint_states_checked':shots*2,
        'maximum_joint_state_error':maximum,'QPY_bytes':len(buf.getvalue()),'qubits':device.num_qubits,'working_classical_bits':device.num_clbits},device


def compare_choices(source,pair,packet):
    values={name:risk(pair,{tuple(row['votes']):row['answer'] for row in table}) for name,table in source['policies'].items()}
    assert values[packet['policy']]<=min(values.values())+1e-12
    assert values[packet['policy']]<=packet['logical_error_upper']+1e-12
    region=packet['region'];assert all(region[name][0]<=x<=region[name][1] for name,x in zip(['p01','p10'],pair))
    # Every competitor, including all 256 Boolean tables, is dominated on
    # this fixture. The interval argument in the report covers the continuum.
    words=list(product((0,1),repeat=3));best=min(risk(pair,dict(zip(words,answers))) for answers in product((0,1),repeat=8))
    assert abs(best-values[packet['policy']])<1e-12
    selected={tuple(row['votes']):row['answer'] for row in source['policies'][packet['policy']]}
    improvements={}
    competitors={name:{tuple(row['votes']):row['answer'] for row in table} for name,table in source['policies'].items()}
    competitors['FirstReport']={v:v[0] for v in words}
    for name,table in competitors.items():
        lower=0.
        for v in words:
            if table[v]!=selected[v]:
                row=packet['likelihood_rows'][sum(v)];own=row['true1_likelihood' if selected[v] else 'true0_likelihood'];other=row['true0_likelihood' if selected[v] else 'true1_likelihood']
                lower+=(own[0]-other[1])/2
        assert lower>=-1e-12;actual=risk(pair,table)-values[packet['policy']];assert actual>=lower-1e-12
        improvements[name]={'confidence_improvement_lower':lower,'fixture_actual_improvement':actual}
    return {'fixture_error_rates':{**values,'FirstReport':sum(pair)/2},'selected':packet['policy'],
        'reported_logical_error_upper':packet['logical_error_upper'],'all_256_decoders_minimum':best,'improvement_bounds':improvements,
        'fixture_parameters_used_only_by_independent_check':list(pair)}


def guards(session,record,packet,output):
    names=[]
    def no(name,f):
        try:f()
        except (ValueError,AssertionError):names.append(name);return
        raise AssertionError('Accepted '+name)
    bad=deepcopy(record);bad['pair_counts']['00']-=1;bad['pair_counts']['11']+=1
    no('unacquired replacement record',lambda:session.decision(bad))
    bad=deepcopy(packet);bad['policy']='AllOne' if packet['policy']!='AllOne' else 'AnyOne'
    no('favourable policy not supplied by this evidence',lambda:session.working_body(bad,[[0,1]]))
    no('repeat search after one fixed acquisition',lambda:session.acquire(output/'forbidden-repeat'))
    bad=deepcopy(record);bad.pop('orientation')
    no('anonymous records without an orientation premise',lambda:policy.parameter_region(bad))
    old=session.pair;session.pair=(.4,.4)
    no('old evidence on a changed reporter',lambda:session.working_body(packet,[[0,1]]));session.pair=old
    bad=deepcopy(session.source);bad['policies']['Majority'][3]['answer']=0
    no('changed current source reading',lambda:policy.validate(bad))
    return names


def run(output):
    started=time.perf_counter();source=json.loads((output/'policy-reading.json').read_text());rows=[];cases=[];refusals=[]
    for i,(name,pair,expected) in enumerate(CASES):
        saved=json.loads((output/name/'paired-acquisition.json').read_text())
        # Deterministic replay verifies the sealed-to-be data path, not an
        # additional independent statistical experiment or a retry search.
        with tempfile.TemporaryDirectory(prefix='vi-reporter-check-') as directory:
            s=policy.LocalReporterEvidence(source,pair,shots=32768,alpha=.01/3,seed=2026091531+i)
            record=s.acquire(Path(directory))
            # SDK autogenerated circuit names can change QPY bytes across
            # processes. Compare the actual bound circuit, not byte identity.
            assert {k:v for k,v in record.items() if k!='QPY_sha256'}=={k:v for k,v in saved.items() if k!='QPY_sha256'}
            with (output/name/'paired-acquisition.qpy').open('rb') as f:old_circuit,=qpy.load(f)
            with (Path(directory)/'paired-acquisition.qpy').open('rb') as f:new_circuit,=qpy.load(f)
            assert old_circuit==new_circuit and policy.repeated.work.ordered_bindings(old_circuit)==policy.repeated.work.ordered_bindings(new_circuit)
            packet=s.decision(record);old_packet=json.loads((output/name/'decision.json').read_text())
            assert {k:v for k,v in packet.items() if k!='record_sha256'}=={k:v for k,v in old_packet.items() if k!='record_sha256'}
            shutil.copyfile(Path(directory)/'paired-acquisition.qpy',output/name/'replay-paired-acquisition.qpy')
            write(output/name/'replay-paired-acquisition.json',record);write(output/name/'replay-decision.json',packet)
            assert packet['kind']=='act' and packet['policy']==expected
            for n in [1,3,8,32]:
                r,q=live(s,packet,n,2026091590+17*i+n);rows.append(r)
                if n==8:
                    with (output/name/'working-policy-word.qpy').open('wb') as f:qpy.dump(q,f)
            cases.append({'case':name,**compare_choices(source,pair,packet)})
            refusals.extend(guards(s,record,packet,Path(directory)))
    result={'source':policy.admission.fingerprint(source),'algebra':algebra(),'source_truth_tables':truth(source),
        'acquired_cases':cases,'sdk':rows,'refusals':refusals,'calibration_occurrences':3,'calibration_shots_per_occurrence':32768,
        'alpha_total':.01,'replay_is_not_additional_evidence':True,'new_QPU_jobs':0,'full_regression':False,
        'full_joint_states_checked':sum(r['full_joint_states_checked'] for r in rows),
        'maximum_joint_state_error':max(r['maximum_joint_state_error'] for r in rows),
        'seconds':time.perf_counter()-started,'implementation_sha256':digest(Path(policy.__file__)),'check_sha256':digest(Path(__file__))}
    write(output/'audit.json',result);return result


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    r=run(p.parse_args().output.resolve());print(json.dumps({k:r[k] for k in ['full_joint_states_checked','maximum_joint_state_error','seconds']}))
