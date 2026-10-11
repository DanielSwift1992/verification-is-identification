#!/usr/bin/env python3
"""Live changing work, branch probabilities, joint-state and ownership checks."""
import argparse
from copy import deepcopy
import io
import json
import math
from pathlib import Path
import time
from unittest.mock import patch

import numpy as np
from qiskit import QuantumCircuit,ClassicalRegister,qpy
from qiskit_aer import AerSimulator
from qiskit_aer.library import set_density_matrix,save_density_matrix

import resident_adaptive_checkpoint as adaptive
from resident_orientation_word_checks import WANTED,target,rz
from resident_measurement_wire_checks import I,X,j,embed
from environment import write,digest

stopped=adaptive.stopped


def stages(packet):return [packet['first'],packet['next']['0'],packet['next']['1']]


def instrument(original,dest,history,present,offsets):
    def visit(body,qargs,cargs,stage):
        for item in body.data:
            qs=[qargs[body.find_bit(b).index] for b in item.qubits];cs=[cargs[body.find_bit(b).index] for b in item.clbits]
            if item.operation.name=='if_else':
                blocks=item.operation.blocks
                with dest.if_test(item.operation.condition) as otherwise:visit(blocks[0],qs,cs,stage)
                if len(blocks)>1:
                    with otherwise:visit(blocks[1],qs,cs,stage)
            else:
                dest.append(item.operation,qs,cs)
                if item.operation.name=='measure':
                    marker,step,depth,path=item.operation.label.split(':');assert marker=='vote'
                    index=offsets[stage]+7*int(step)+(1<<int(depth))-1+(0 if path=='root' else int(path,2))
                    dest.store(history[index],cs[0]);dest.store(present[index],True)
    end=original.metadata['first_instruction_end']
    for index,item in enumerate(original.data):
        if index==end:
            save_density_matrix(dest,range(5),label='checkpoint',pershot=True)
            assert item.operation.name=='if_else'
            with dest.if_test(item.operation.condition) as otherwise:visit(item.operation.blocks[0],list(item.qubits),list(item.clbits),1)
            with otherwise:visit(item.operation.blocks[1],list(item.qubits),list(item.clbits),2)
        else:
            # A one-instruction full-width view retains actual register maps.
            body=original.copy_empty_like();body.append(item);visit(body,list(original.qubits),list(original.clbits),0)


def apply_records(source,packet,records,flags,offset,pair,rho):
    c=packet['cost_reading'];angles=stopped.cost.orientation.expand(source['cost']['orientation'],c['request']);first=None
    for step,(mode,angle) in enumerate(zip(c['selected']['modes'],angles)):
        node=source['candidates'][mode]['tree'];votes=[];visited=[];base=offset+7*step
        while 'answer' not in node:
            prefix=node['prefix'];index=(1<<len(prefix))-1+(int(''.join(map(str,prefix)),2) if prefix else 0)
            assert flags[base+index];bit=records[base+index];votes.append(bit);visited.append(index);node=node['children'][bit]
        assert sum(flags[base:base+7])==len(visited)
        if first is None:first=votes[0]
        value=np.zeros_like(rho)
        for truth,p in enumerate(pair):
            mass=math.prod(p if bit!=truth else 1-p for bit in votes)
            k=np.kron(np.eye(4),np.linalg.matrix_power(X,truth^node['answer'])@j(np.pi*angle[0]/angle[1]))/np.sqrt(2)
            value+=mass*k@rho@k.conj().T
        assert np.trace(value).real>0;rho=value/np.trace(value).real
    return rho,first


def live(source,packet,device,pair,seed,shots=64,ideal=False,expect_mismatch=False):
    buf=io.BytesIO();qpy.dump(device,buf);buf.seek(0);restored,=qpy.load(buf)
    assert restored==device and stopped.cost.policy.repeated.work.ordered_bindings(restored)==stopped.cost.policy.repeated.work.ordered_bindings(device)
    sizes=[21*len(p['cost_reading']['request']) for p in stages(packet)];offsets=[0,sizes[0],sizes[0]+sizes[1]]
    rng=np.random.default_rng(seed);v=rng.normal(size=8)+1j*rng.normal(size=8);v/=np.linalg.norm(v);initial=np.outer(v,v.conj())
    q=restored.copy_empty_like();set_density_matrix(q,np.kron(np.diag([1,0]),embed(initial,0)))
    history=ClassicalRegister(sum(sizes),'audit_reports');present=ClassicalRegister(sum(sizes),'audit_present');q.add_register(history,present)
    instrument(restored,q,history,present,offsets)
    save_density_matrix(q,range(5),label='output',pershot=True);q.s(packet['final_owner']);save_density_matrix(q,range(5),label='consumer',pershot=True)
    result=AerSimulator(method='density_matrix',max_parallel_threads=1).run(q,shots=shots,memory=True,seed_simulator=seed+271).result();assert result.success
    maximum=0.;choice_counts={0:0,1:0};counts=[]
    for index,text in enumerate(result.get_memory()):
        word=int(text.replace(' ',''),2);assert word&7==0;choice=(word>>device.metadata['choice_bit'])&1;choice_counts[choice]+=1
        records=[(word>>q.find_bit(b).index)&1 for b in history];flags=[(word>>q.find_bit(b).index)&1 for b in present];counts.append(sum(flags))
        middle,first=apply_records(source,packet['first'],records,flags,0,pair,initial);assert choice==first
        selected=1+choice;unselected=2-choice
        assert sum(flags[offsets[unselected]:offsets[unselected]+sizes[unselected]])==0
        final,_=apply_records(source,packet['next'][str(choice)],records,flags,offsets[selected],pair,middle)
        if ideal:
            u=np.kron(np.eye(4),target(packet['next'][str(choice)]['cost_reading']['request'])@target(packet['first']['cost_reading']['request']))
            assert np.max(abs(final-u@initial@u.conj().T))<1e-11
        action=np.kron(np.eye(4),np.diag([1,1j]));after=action@final@action.conj().T
        for label,state,owner in [('checkpoint',middle,packet['checkpoint_owner']),('output',final,packet['final_owner']),('consumer',after,packet['final_owner'])]:
            expected=np.kron(np.diag([1,0]),embed(state,owner));error=float(np.max(abs(result.data()[label][index].data-expected)))
            if not expect_mismatch:assert error<1e-10, (label,index,error,choice)
            maximum=max(maximum,error)
    if expect_mismatch:assert maximum>.01
    assert all(choice_counts.values())
    return {'first_rotation_pairs':len(packet['first']['cost_reading']['request']),'checkpoint_owner':packet['checkpoint_owner'],
        'final_owner':packet['final_owner'],'physical_reporter':list(pair),'choice_counts':choice_counts,
        'actual_report_count_min':min(counts),'actual_report_count_max':max(counts),'sample_average_report_count':sum(counts)/shots,
        'full_joint_states_checked':3*shots,'maximum_joint_state_error':maximum,'intentional_owner_mismatch':expect_mismatch,
        'qubits':device.num_qubits,'working_classical_bits':device.num_clbits,'QPY_bytes':len(buf.getvalue()),'ideal_output_asserted':ideal}


def fixture(source,packet,pair):
    first=stopped.compile_stopped(source,pair,packet['first']);branches={b:stopped.compile_stopped(source,pair,packet['next'][b]) for b in ['0','1']}
    q=adaptive.AdaptiveCheckpoint.assemble(source,packet,first,branches);q.metadata['fixture_only']=True;q.metadata['joint_error_upper']=None
    return q,branches


def wrong_owner(good,branches):
    q=good.copy_empty_like();end=good.metadata['first_instruction_end']
    for item in good.data[:end]:q.append(item)
    bad={}
    for b,body in branches.items():
        bad[b]=q.copy_empty_like();bad[b].compose(body,qubits=list(range(5)),clbits=list(q.clbits[:3]),inplace=True)
    q.if_else((q.clbits[good.metadata['choice_bit']],0),bad['0'],bad['1'],list(q.qubits),list(q.clbits));q.metadata=deepcopy(good.metadata)
    return q


def superop(source,packet,pair,retained=None):
    c=packet['cost_reading'];angles=stopped.cost.orientation.expand(source['cost']['orientation'],c['request']);value=np.eye(4,dtype=complex)
    for index,(mode,angle) in enumerate(zip(c['selected']['modes'],angles)):
        step=np.zeros((4,4),complex)
        for leaf in stopped.leaves(source['candidates'][mode]['tree']):
            if index==0 and retained is not None and leaf['prefix'][0]!=retained:continue
            for truth,p in enumerate(pair):
                weight=math.prod(p if b!=truth else 1-p for b in leaf['prefix'])/2
                u=np.linalg.matrix_power(X,truth^leaf['answer'])@j(np.pi*angle[0]/angle[1]);step+=weight*np.kron(u.conj(),u)
        value=step@value
    return value


def choi(s):
    result=np.zeros((4,4),complex)
    for a in range(2):
        for b in range(2):
            unit=np.zeros((2,2),complex);unit[a,b]=1
            result[2*a:2*a+2,2*b:2*b+2]=(s@unit.reshape(4,order='F')).reshape((2,2),order='F')/2
    assert np.max(abs(result-result.conj().T))<1e-12
    return result


def joint_algebra(source,packet):
    witness=packet['first']['cost_reading']['least_favourable']['canonical_pair'];rows=[]
    for pair in [(.8,.99),witness,(0.,0.),(1.,1.)]:
        error=0.;masses=[]
        for bit in [0,1]:
            acquired=superop(source,packet['first'],pair,retained=bit)
            actual=superop(source,packet['next'][str(bit)],pair)@acquired
            mass=float(np.trace((actual@I.reshape(4,order='F')).reshape((2,2),order='F')).real/2);masses.append(mass)
            u=target(packet['next'][str(bit)]['cost_reading']['request'])@target(packet['first']['cost_reading']['request'])
            difference=actual-mass*np.kron(u.conj(),u)
            assert np.max(abs(difference@I.reshape(4,order='F')))<1e-12
            error+=float(np.sum(abs(np.linalg.eigvalsh(choi(difference))))/2)
        assert abs(sum(masses)-1)<1e-12
        assert error<=packet['joint_error_upper']+1e-12
        rows.append({'physical_reporter':list(pair),'choice_probabilities':masses,'joint_half_diamond_error':error})
    return {'cases':rows,'scope':'For trace-annihilating unital qubit maps, Bloch SVD reduces to a signed Pauli map; its diamond norm is attained on a Bell input. The same Bell input attains each classical block, so these trace-norm sums are exact.'}


def retained_record_boundary():
    theta=np.pi/3;bell=np.array([1,0,0,1])/np.sqrt(2);ideal=np.outer(bell,bell.conj());states=[]
    for sign in [1,-1]:u=np.kron(I,rz(sign*theta));states.append(u@ideal@u.conj().T)
    distance=lambda a,b:float(np.sum(abs(np.linalg.eigvalsh(a-b)))/2)
    marginal=distance(sum(states)/2,ideal);joint=sum(distance(x,ideal) for x in states)/2
    assert abs(marginal-.25)<1e-12 and abs(joint-.5)<1e-12
    q=QuantumCircuit(3,1);q.h(0);q.cx(0,1);q.h(2);q.measure(2,0)
    with q.if_test((q.clbits[0],0)) as otherwise:q.rz(theta,0)
    with otherwise:q.rz(-theta,0)
    save_density_matrix(q,range(3),label='before',pershot=True)
    with q.if_test((q.clbits[0],0)) as otherwise:q.rz(-theta,0)
    with otherwise:q.rz(theta,0)
    save_density_matrix(q,range(3),label='after',pershot=True)
    result=AerSimulator(method='density_matrix',max_parallel_threads=1).run(q,shots=64,memory=True,seed_simulator=2026092500).result();assert result.success;maximum=0.
    for i,text in enumerate(result.get_memory()):
        bit=int(text,2);coin=np.diag([1-bit,bit])
        for name,state in [('before',states[bit]),('after',ideal)]:
            error=float(np.max(abs(result.data()[name][i].data-np.kron(coin,state))));assert error<1e-12;maximum=max(maximum,error)
    return {'theta_over_pi':[1,3],'quantum_only_half_diamond_error':marginal,'retained_record_half_diamond_error':joint,
        'known_record_controlled_inverse_restores_ideal':True,'full_joint_states_checked':128,'maximum_joint_state_error':maximum,
        'scope':'A separate explicit instrument illustrates the application boundary; it is not a model inferred for the actual acquired reporter.'}


def run(output):
    start=time.perf_counter();root=stopped.cost.policy.repeated.wire.goal.ROOT
    source=json.loads((root/'Research/Artifacts/resident-stopped-read-20260915/stopped-reading.json').read_text())
    receipt=json.loads((root/'Research/Artifacts/resident-stopped-read-20260915/receipt.json').read_text());assert all(digest(root/p)==v for p,v in receipt['sha256'].items())
    with patch.object(AerSimulator,'run',side_effect=AssertionError('New calibration requested')):
        session=adaptive.AdaptiveCheckpoint(source,(.8,.99),root/'Research/Artifacts/resident-orientation-word-20260915');packet=session.request();device=session.working_body(packet);session.admit(packet,device)
    rows=[]
    for first,risk,joint in [(adaptive.FIRST,.2,.30),(WANTED,.5,.70)]:
        p=session.request(first,stage_risk=risk,joint_risk=joint);assert p['kind']=='act'
        for pair in [(.8,.99),(.010000000000000009,.19999999999999996)]:
            session.view.saved.pair=pair;q=session.working_body(p);session.admit(p,q);rows.append(live(source,p,q,pair,2026092000+100*len(rows)))
        for pair in [(0.,0.),(1.,1.)]:
            q,_=fixture(source,p,pair);rows.append(live(source,p,q,pair,2026092100+100*len(rows),ideal=True))
    session.view.saved.pair=(.8,.99);good,branches=fixture(source,packet,(0.,0.));bad=wrong_owner(good,branches)
    counter=live(source,packet,bad,(0.,0.),2026092400,ideal=True,expect_mismatch=True)
    refusals=[]
    def no(name,f):
        try:f()
        except (ValueError,AssertionError):refusals.append(name);return
        raise AssertionError('Accepted '+name)
    no('old carrier used as the new logical input',lambda:session.admit(packet,bad))
    wrong=deepcopy(packet);wrong['joint_error_upper']=packet['first']['whole_output_error_upper']
    no('quantum-only bound copied onto the joint goal',lambda:session.working_body(wrong))
    wrong=deepcopy(packet);wrong['next']['1']=deepcopy(wrong['next']['0'])
    no('old body after changing an acquired branch goal',lambda:session.admit(wrong,device))
    wrong=deepcopy(adaptive.NEXT);wrong['1']=wrong['1']*2
    no('branch-dependent output carrier without a matching interface',lambda:session.request(next_requests=wrong,stage_risk=.6,joint_risk=.99))
    no('tighter joint guarantee without sufficient evidence',lambda:session.working_body(session.request(joint_risk=.2)))
    boundary=retained_record_boundary();algebra=joint_algebra(source,packet);session.view.saved.check()
    result={'source':stopped.cost.admission.fingerprint(source),'joint_reading':packet,'sdk':rows,'joint_algebra':algebra,
        'wrong_owner_counterexample':counter,'retained_record_boundary':boundary,'refusals':refusals,
        'full_joint_states_checked':sum(r['full_joint_states_checked'] for r in rows)+counter['full_joint_states_checked']+boundary['full_joint_states_checked'],
        'maximum_correct_joint_state_error':max([r['maximum_joint_state_error'] for r in rows]+[boundary['maximum_joint_state_error']]),
        'previous_receipt_entries_verified':len(receipt['sha256']),'new_device_calibrations':0,'new_QPU_jobs':0,'full_regression':False,
        'seconds':time.perf_counter()-start,'implementation_sha256':digest(Path(adaptive.__file__)),'check_sha256':digest(Path(__file__))}
    write(output/'audit.json',result);return result


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    result=run(p.parse_args().output.resolve());print(json.dumps({k:result[k] for k in ['full_joint_states_checked','maximum_correct_joint_state_error','seconds','refusals','joint_algebra']}))
