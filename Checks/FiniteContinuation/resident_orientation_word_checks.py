#!/usr/bin/env python3
"""Per-branch orientation quotient, minimal word, acquired live continuation."""
import argparse
from copy import deepcopy
from itertools import product
import io
import json
import math
from pathlib import Path
import shutil
import tempfile
import time

import numpy as np
from qiskit import ClassicalRegister,qpy
from qiskit_aer import AerSimulator
from qiskit_aer.library import set_density_matrix,save_density_matrix

import resident_orientation_word as orientation
from resident_measurement_wire_checks import I,X,j,embed
from environment import write,digest

Z=np.diag([1,-1]);H=j(0)
WANTED=[{'z':[1,3],'x':[1,4]},{'z':[-1,6],'x':[0,1]}]


def rz(t):return np.diag([np.exp(-1j*t/2),np.exp(1j*t/2)])
def rx(t):return H@rz(t)@H
def target(wanted):
    u=I.astype(complex)
    for r in wanted:u=rx(np.pi*r['x'][0]/r['x'][1])@rz(np.pi*r['z'][0]/r['z'][1])@u
    return u


def error_word(errors,angles):
    u=I.astype(complex)
    for e,a in zip(errors,angles):u=np.linalg.matrix_power(X,e)@j(a)@u
    return u


def phase_error(a,b):
    c=np.trace(a.conj().T@b)/2
    return float(np.max(abs(b-c*a)))


def algebra(source):
    maximum=0.;count=0
    for u,v in [(.19,.73),(0.,np.pi/3),(np.pi/4,0.),(-.51,.27)]:
        angles=[v+np.pi/2,np.pi/2,u+np.pi/2]
        for e in product((0,1),repeat=3):
            actual=error_word(e,angles);other=error_word([1-x for x in e],angles)
            row=source['errors'][int(''.join(map(str,e)),2)]
            expected=rx(u)@np.linalg.matrix_power(X,row['x'])@np.linalg.matrix_power(Z,row['z'])@rz(v)
            maximum=max(maximum,phase_error(expected,actual),phase_error(actual,other));count+=1
    assert maximum<1e-12
    # For one or two arbitrary J angles, the two orientation actions have
    # zero Hilbert-Schmidt overlap. No nonempty shorter word is invariant.
    shorter=[]
    for n in [1,2]:
        overlaps=[]
        for values in product([0.,.19,np.pi/2,-.73],repeat=n):
            a=error_word([0]*n,values);b=error_word([1]*n,values)
            overlaps.append(float(abs(np.trace(a.conj().T@b)/2)))
        assert max(overlaps)<1e-12;shorter.append({'steps':n,'angle_cases':len(overlaps),'maximum_overlap':max(overlaps)})
    middle=[]
    for beta in [0.,.2,np.pi/4,np.pi/2,np.pi/2+.1,-np.pi/2]:
        a=error_word([0]*3,[.19,beta,.73]);b=error_word([1]*3,[.19,beta,.73]);overlap=abs(np.trace(a.conj().T@b)/2)
        assert abs(overlap-abs(np.sin(beta)))<1e-12
        middle.append({'middle_angle':beta,'orientation_unitary_overlap':float(overlap),'half_diamond_distance':float(abs(np.cos(beta)))})
    return {'residual_words_checked':count,'maximum_operator_error':maximum,'shorter_word_checks':shorter,'middle_angle_boundary':middle,
        'scope':'The continuum proof is in the report; these finite checks include every residual error pattern and parameter examples.'}


def depolarizing(source):
    maximum=0.;rows=[];angles=orientation.expand(source,WANTED);angles=[np.pi*a[0]/a[1] for a in angles];u=target(WANTED)
    for r in [0.,.02,.13,.3,.5,.8,1.]:
        lam=(1-2*r)**(2*len(WANTED))
        for a,b in product(range(2),repeat=2):
            unit=np.zeros((2,2),complex);unit[a,b]=1;rho=unit
            for angle in angles:
                tmp=j(angle)@rho@j(angle).conj().T;rho=(1-r)*tmp+r*X@tmp@X
            expected=lam*u@unit@u.conj().T+(1-lam)*np.trace(unit)*I/2
            e=float(np.max(abs(rho-expected)));assert e<1e-12;maximum=max(maximum,e)
        rows.append({'primitive_error':r,'word_contraction':lam,'word_half_diamond_error':.75*(1-lam)})
    return {'matrix_units_checked':28,'maximum_superoperator_error':maximum,'cases':rows}


def selective_reflection(source):
    # Thresholds and conditional IID make count patterns cover every ordering
    # of the nine actual reports in this one macro. Each specific word keeps
    # its own probability; no combinatorial factor is inserted here.
    maximum=0.;count=0;angles=[.31+np.pi/2,np.pi/2,-.27+np.pi/2]
    for pair in [(.8,.99),(.1,.3)]:
        mirror=(1-pair[1],1-pair[0])
        for name,table in source['policy']['policies'].items():
            answers={tuple(row['votes']):row['answer'] for row in table}
            for counts in product(range(4),repeat=3):
                votes=[tuple([1]*k+[0]*(3-k)) for k in counts];ys=[answers[v] for v in votes];maps=[]
                for probabilities in [pair,mirror]:
                    superop=np.zeros((4,4),complex)
                    for bits in product((0,1),repeat=3):
                        weight=1/8
                        for b,v in zip(bits,votes):weight*=np.prod([probabilities[b] if y!=b else 1-probabilities[b] for y in v])
                        u=error_word([b^y for b,y in zip(bits,ys)],angles)
                        superop+=weight*np.kron(u.conj(),u)
                    maps.append(superop)
                e=float(np.max(abs(maps[0]-maps[1])));assert e<1e-12;maximum=max(maximum,e);count+=1
    return {'unnormalized_record_maps_checked':count,'maximum_superoperator_error':maximum,
        'specific_report_words_represented':2*3*512,'scope':'Both record mass and quantum state agree under one common hidden-branch reflection.'}


def live(source,device,pair,wanted,seed,shots=64,assert_ideal=False):
    buf=io.BytesIO();qpy.dump(device,buf);buf.seek(0);restored,=qpy.load(buf)
    assert restored==device and orientation.policy.repeated.work.ordered_bindings(restored)==orientation.policy.repeated.work.ordered_bindings(device)
    angles=orientation.expand(source,wanted);owner=device.metadata['wire_boundary']['boundary']['physical_owner'];n=len(angles)
    name=device.metadata['selected_policy'];table={tuple(r['votes']):r['answer'] for r in source['policy']['policies'][name]}
    rng=np.random.default_rng(seed);v=rng.normal(size=8)+1j*rng.normal(size=8);v/=np.linalg.norm(v);initial=np.outer(v,v.conj())
    q=restored.copy_empty_like();set_density_matrix(q,np.kron(np.diag([1,0]),embed(initial,0)))
    history=ClassicalRegister(3*n,'audit_reports');q.add_register(history);count=0
    for item in restored.data:
        q.append(item)
        if item.operation.name=='measure':q.store(history[count],item.clbits[0]);count+=1
    assert count==3*n
    save_density_matrix(q,range(5),label='output',pershot=True);q.s(owner);save_density_matrix(q,range(5),label='consumer',pershot=True)
    result=AerSimulator(method='density_matrix',max_parallel_threads=1).run(q,shots=shots,memory=True,seed_simulator=seed+19).result()
    assert result.success;maximum=0.;ideal=np.kron(np.eye(4),target(wanted));ideal=ideal@initial@ideal.conj().T
    for index,text in enumerate(result.get_memory()):
        word=int(text.replace(' ',''),2);assert word&31==0
        records=[(word>>q.find_bit(bit).index)&1 for bit in history];rho=initial
        for step,angle in enumerate(angles):
            votes=tuple(records[3*step:3*step+3]);answer=table[votes];value=np.zeros_like(rho)
            for b,p in enumerate(pair):
                likelihood=np.prod([p if y!=b else 1-p for y in votes])
                k=np.kron(np.eye(4),np.linalg.matrix_power(X,b^answer)@j(np.pi*angle[0]/angle[1]))/np.sqrt(2)
                value+=likelihood*k@rho@k.conj().T
            assert np.trace(value).real>0;rho=value/np.trace(value).real
        if assert_ideal:assert np.max(abs(rho-ideal))<1e-11
        consumer=np.kron(np.eye(4),np.diag([1,1j]));after=consumer@rho@consumer.conj().T
        for name2,state in [('output',rho),('consumer',after)]:
            expected=np.kron(np.diag([1,0]),embed(state,owner));e=float(np.max(abs(result.data()[name2][index].data-expected)))
            assert e<1e-10;maximum=max(maximum,e)
    return {'rotation_pairs':len(wanted),'logical_steps':n,'physical_report_reads':3*n,'selected_policy':name,
        'physical_reporter':list(pair),'ideal_output_asserted':assert_ideal,'full_joint_states_checked':2*shots,
        'maximum_joint_state_error':maximum,'QPY_bytes':len(buf.getvalue()),'qubits':device.num_qubits,'working_classical_bits':device.num_clbits}


def guards(session,record,packet,device,output):
    names=[]
    def no(name,f):
        try:f()
        except (ValueError,AssertionError):names.append(name);return
        raise AssertionError('Accepted '+name)
    no('unoriented record used as an oriented primitive certificate',lambda:orientation.policy.choose(session.source,record))
    bad=deepcopy(record);bad['pair_counts']['00']-=1;bad['pair_counts']['11']+=1
    no('substituted acquisition',lambda:session.decision(bad))
    bad=deepcopy(packet);bad['request'][0]['x']=[0,1]
    no('different requested output under the same packet',lambda:session.working_body(bad))
    changed=device.copy();changed.x(0)
    no('extra physical action under unchanged word metadata',lambda:session.admit(packet,changed))
    no('a primitive instead of a complete rotation request',lambda:orientation.requests(session.word_source,[[0,1]]))
    old=deepcopy(session.wanted);session.wanted[0]['x']=[0,1]
    no('in-place mutation of the acquisition goal',lambda:session.working_body(packet));session.wanted=old
    old=session.pair;session.pair=(.4,.4)
    no('different device outside the acquired reflection orbit',lambda:session.working_body(packet));session.pair=old
    no('retry search after the fixed acquisition',lambda:session.acquire(output/'forbidden-repeat'))
    return names


def run(output):
    start=time.perf_counter();source=json.loads((output/'orientation-reading.json').read_text());rows=[]
    with tempfile.TemporaryDirectory(prefix='vi-orientation-audit-') as directory:
        tmp=Path(directory);session=orientation.UnorientedEvidence(source,(.8,.99),WANTED,risk=.5)
        record=session.acquire(tmp);packet=session.decision(record);assert packet['kind']=='act'
        old_path=output/'acquisition/paired-acquisition.json'
        if old_path.exists():
            old=json.loads(old_path.read_text())
            assert {k:v for k,v in old.items() if k!='QPY_sha256'}=={k:v for k,v in record.items() if k!='QPY_sha256'}
        else:shutil.copytree(tmp,output/'acquisition');write(output/'decision.json',packet)
        shutil.copyfile(tmp/'paired-acquisition.qpy',output/'audit-paired-acquisition.qpy');write(output/'audit-paired-acquisition.json',record);write(output/'audit-decision.json',packet)
        device=session.working_body(packet);session.admit(packet,device)
        rows.append(live(source,device,session.pair,WANTED,2026091591))
        with (output/'working-unoriented-word.qpy').open('wb') as f:qpy.dump(device,f)
        # Same acquired evidence remains applicable through the established
        # reflection relation. No new occurrence or status flag is supplied.
        session.pair=(1-session.pair[1],1-session.pair[0]);session.check();mirror=session.working_body(packet);session.admit(packet,mirror)
        rows.append(live(source,mirror,session.pair,WANTED,2026091592))
        with (output/'working-reflected-word.qpy').open('wb') as f:qpy.dump(mirror,f)
        refusals=guards(session,record,packet,mirror,tmp)
    for blocks in [1,2,7,21]:
        wanted=[WANTED[i%2] for i in range(blocks)];angles=orientation.expand(source,wanted)
        for pair in [(0.,0.),(1.,1.),(.1,.3)]:
            main=orientation.policy.main_word(source['policy'],angles)
            q=orientation.policy.compile_policy(main,source['policy'],pair,'Majority')
            rows.append(live(source,q,pair,wanted,2026091600+blocks+int(10*pair[0]),assert_ideal=pair in [(0.,0.),(1.,1.)]))
    from resident_reporter_policy_checks import risk
    table={tuple(r['votes']):r['answer'] for r in source['policy']['policies'][packet['selected']['canonical_policy']]}
    physical_r=risk((.8,.99),table);canonical_r=1-physical_r
    exact_error=.75*(1-(1-2*physical_r)**(2*len(WANTED)))
    assert exact_error<=packet['selected']['physical_word_error_upper']
    result={'source':orientation.admission.fingerprint(source),'algebra':algebra(source),'depolarizing':depolarizing(source),
        'selective_reflection':selective_reflection(source),'acquired_decision':packet,'sdk':rows,'refusals':refusals,
        'same_evidence_used_after_known_reflection':True,'fixture_oracle':{'physical_primitive_error':physical_r,'canonical_primitive_error':canonical_r,
            'requested_word_half_diamond_error':exact_error,'not_inputs_to_the_acquired_decision':True},
        'full_joint_states_checked':sum(r['full_joint_states_checked'] for r in rows),
        'maximum_joint_state_error':max(r['maximum_joint_state_error'] for r in rows),
        'seconds':time.perf_counter()-start,'new_QPU_jobs':0,'full_regression':False,
        'implementation_sha256':digest(Path(orientation.__file__)),'check_sha256':digest(Path(__file__))}
    write(output/'audit.json',result);return result


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    r=run(p.parse_args().output.resolve());print(json.dumps({k:r[k] for k in ['full_joint_states_checked','maximum_joint_state_error','seconds','fixture_oracle']}))
