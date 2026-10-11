#!/usr/bin/env python3
"""Actual early stopping, selective quantum continuation, and a memory counterexample."""
import argparse
from copy import deepcopy
from itertools import product
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

import resident_stopped_read as stopped
from resident_orientation_word_checks import WANTED,target
from resident_measurement_wire_checks import X,j,embed
from environment import write,digest


def algebra(source):
    maximum=0.;maps=0;words=0;cost_cases=0
    for name,value in source['candidates'].items():
        table={tuple(row['votes']):row['answer'] for row in value['rows']};t=value['tree']
        for votes,answer in table.items():
            node=t
            while 'answer' not in node:node=node['children'][votes[len(node['prefix'])]]
            assert node['answer']==answer;words+=1
            if node['prefix']:
                previous=node['prefix'][:-1]
                assert len({y for v,y in table.items() if v[:len(previous)]==tuple(previous)})>1
        coefficients=stopped.expected_coefficients(t)
        for p in [0.,.01,.13,.5,.78,1.]:
            exact=sum(len(leaf['prefix'])*math.prod(p if b else 1-p for b in leaf['prefix']) for leaf in stopped.leaves(t))
            assert abs(exact-sum(c*p**k for k,c in enumerate(coefficients)))<1e-12;cost_cases+=1
        # Coarse-grain all fixed-length records having the same stopped
        # prefix. Compare unnormalized maps, including their probabilities.
        for pair in [(.1,.3),(.8,.99),(0.,0.),(1.,1.)]:
            for leaf in stopped.leaves(t):
                fixed=np.zeros((4,4),complex);short=np.zeros((4,4),complex);prefix=tuple(leaf['prefix']);answer=leaf['answer']
                for truth,p in enumerate(pair):
                    u=np.linalg.matrix_power(X,truth^answer)@j(.317)
                    term=np.kron(u.conj(),u)/2
                    short+=math.prod(p if vote!=truth else 1-p for vote in prefix)*term
                    for votes in leaf['completions']:
                        fixed+=math.prod(p if vote!=truth else 1-p for vote in votes)*term
                error=float(np.max(abs(fixed-short)));assert error<1e-12;maximum=max(maximum,error);maps+=1
    # General cost needs only the law of the first two reports, not their
    # independence. Full output equivalence still has a physical condition.
    rng=np.random.default_rng(2026091789);general=0
    for _ in range(64):
        p=rng.random(8);p/=p.sum();triples=list(product((0,1),repeat=3))
        m1=sum(x*b[0] for x,b in zip(p,triples));m2=sum(x*b[1] for x,b in zip(p,triples));s=sum(x*b[0]*b[1] for x,b in zip(p,triples))
        formulas={'AnyOne':3-2*m1-m2+s,'AllOne':1+m1+s,'Majority':2+m1+m2-2*s}
        for name,expected in formulas.items():
            actual=0
            for weight,bits in zip(p,triples):
                node=source['candidates'][name]['tree']
                while 'answer' not in node:node=node['children'][bits[len(node['prefix'])]]
                actual+=weight*len(node['prefix'])
            assert abs(actual-expected)<1e-12;general+=1
    return {'source_words_checked':words,'cost_polynomial_cases':cost_cases,'unnormalized_prefix_maps_checked':maps,
        'maximum_superoperator_error':maximum,'arbitrary_correlated_report_laws_cost_checks':general}


def instrument_body(original,dest,history,present):
    # Only test instrumentation appends the report archive. Actual branches
    # and actual quantum operations remain those of the admitted QPY.
    def visit(body,qargs,cargs):
        for item in body.data:
            qs=[qargs[body.find_bit(b).index] for b in item.qubits]
            cs=[cargs[body.find_bit(b).index] for b in item.clbits]
            if item.operation.name=='if_else':
                blocks=item.operation.blocks
                with dest.if_test(item.operation.condition) as otherwise:visit(blocks[0],qs,cs)
                if len(blocks)>1:
                    with otherwise:visit(blocks[1],qs,cs)
            else:
                dest.append(item.operation,qs,cs)
                if item.operation.name=='measure':
                    marker,step,depth,path=item.operation.label.split(':');assert marker=='vote'
                    offset=(1<<int(depth))-1+(0 if path=='root' else int(path,2))
                    index=7*int(step)+offset;dest.store(history[index],cs[0]);dest.store(present[index],True)
    visit(original,list(dest.qubits[:original.num_qubits]),list(original.clbits))


def live(source,device,pair,wanted,seed,shots=64,assert_ideal=False):
    buf=io.BytesIO();qpy.dump(device,buf);buf.seek(0);restored,=qpy.load(buf)
    assert restored==device and stopped.cost.policy.repeated.work.ordered_bindings(restored)==stopped.cost.policy.repeated.work.ordered_bindings(device)
    angles=stopped.cost.orientation.expand(source['cost']['orientation'],wanted);modes=device.metadata['modes'];n=len(angles)
    owner=device.metadata['wire_boundary']['boundary']['physical_owner']
    rng=np.random.default_rng(seed);v=rng.normal(size=8)+1j*rng.normal(size=8);v/=np.linalg.norm(v);initial=np.outer(v,v.conj())
    q=restored.copy_empty_like();set_density_matrix(q,np.kron(np.diag([1,0]),embed(initial,0)))
    history=ClassicalRegister(7*n,'audit_reports');present=ClassicalRegister(7*n,'audit_present');q.add_register(history,present)
    instrument_body(restored,q,history,present)
    save_density_matrix(q,range(5),label='output',pershot=True);q.s(owner);save_density_matrix(q,range(5),label='consumer',pershot=True)
    result=AerSimulator(method='density_matrix',max_parallel_threads=1).run(q,shots=shots,memory=True,seed_simulator=seed+17).result()
    assert result.success;maximum=0.;observed=[];ideal=np.kron(np.eye(4),target(wanted));ideal=ideal@initial@ideal.conj().T
    for index,text in enumerate(result.get_memory()):
        word=int(text.replace(' ',''),2);assert word&((1<<device.num_clbits)-1)==0
        records=[(word>>q.find_bit(bit).index)&1 for bit in history];flags=[(word>>q.find_bit(bit).index)&1 for bit in present]
        observed.append(sum(flags));rho=initial
        for step,(mode,angle) in enumerate(zip(modes,angles)):
            local=flags[7*step:7*step+7];votes=[];node=source['candidates'][mode]['tree'];visited=[]
            while 'answer' not in node:
                prefix=node['prefix'];offset=(1<<len(prefix))-1+(int(''.join(map(str,prefix)),2) if prefix else 0)
                assert local[offset]==1;visited.append(offset);bit=records[7*step+offset];votes.append(bit);node=node['children'][bit]
            assert sum(local)==len(visited), 'An acquisition outside the actually selected source path was executed'
            assert node['prefix']==votes
            value=np.zeros_like(rho)
            for truth,p in enumerate(pair):
                likelihood=math.prod(p if vote!=truth else 1-p for vote in votes)
                k=np.kron(np.eye(4),np.linalg.matrix_power(X,truth^node['answer'])@j(np.pi*angle[0]/angle[1]))/np.sqrt(2)
                value+=likelihood*k@rho@k.conj().T
            assert np.trace(value).real>0;rho=value/np.trace(value).real
        if assert_ideal:assert np.max(abs(rho-ideal))<1e-11
        consumer=np.kron(np.eye(4),np.diag([1,1j]));after=consumer@rho@consumer.conj().T
        for label,state in [('output',rho),('consumer',after)]:
            expected=np.kron(np.diag([1,0]),embed(state,owner));error=float(np.max(abs(result.data()[label][index].data-expected)))
            assert error<1e-10, {'error':error,'shot':index,'label':label,'modes':modes,'pair':pair,'records':records,'flags':flags}
            maximum=max(maximum,error)
    return {'rotation_pairs':len(wanted),'logical_steps':n,'modes':modes,'physical_reporter':list(pair),
        'actual_report_count_min':min(observed),'actual_report_count_max':max(observed),'sample_average_report_count':sum(observed)/shots,
        'full_joint_states_checked':2*shots,'maximum_joint_state_error':maximum,'qubits':device.num_qubits,
        'working_classical_bits':device.num_clbits,'QPY_bytes':len(buf.getvalue()),'ideal_output_asserted':assert_ideal}


def memory_counterexample(source):
    cases=[];maximum=0.;t=source['candidates']['Majority']['tree']
    for preparation in ['0','1','+']:
        for mode in ['fixed','stopped','stopped_with_memory_repair']:
            stop=mode!='fixed'
            q=QuantumCircuit(4);reply=ClassicalRegister(1,'reply');votes=ClassicalRegister(2,'votes');q.add_register(reply,votes)
            # D=0, held branch B at 1, fresh probe at 2, retained M=0 at 3.
            if preparation=='1':q.x(1)
            if preparation=='+':q.h(1)
            def read(prefix,bit=reply[0]):
                q.reset(2);q.cx(1,2);q.measure(2,bit);q.reset(2);q.x(3)
            if stop:
                stopped.emit_tree(q,t,reply[0],read)
                # For this explicitly perfect reporter the prefix always
                # has length two. The omitted third contact's known X_M
                # can be paid directly without another report acquisition.
                if mode=='stopped_with_memory_repair':q.x(3)
            else:
                read([],votes[0]);read([],votes[1]);read([])
                q.store(reply[0],stopped.cost.policy.policy_expression('Majority',votes[0],votes[1],reply[0]))
                for bit in votes:q.store(bit,False)
            save_density_matrix(q,range(4),label='before',pershot=True);q.cx(3,0);save_density_matrix(q,range(4),label='after',pershot=True)
            result=AerSimulator(method='density_matrix',max_parallel_threads=1).run(q,shots=64,memory=True,seed_simulator=2026091850).result();assert result.success
            memory=0 if mode=='stopped' else 1
            for k,text in enumerate(result.get_memory()):
                answer=int(text.replace(' ',''),2)&1
                for label,data in [('before',0),('after',memory)]:
                    position=data+2*answer+8*memory;expected=np.zeros((16,16),complex);expected[position,position]=1
                    error=float(np.max(abs(result.data()[label][k].data-expected)));assert error<1e-12;maximum=max(maximum,error)
            cases.append({'held_preparation':preparation,'mode':mode,'reports_per_run':2 if stop else 3,
                'additional_memory_X_actions':int(mode=='stopped_with_memory_repair'),
                'majority_always_equals_held_branch':True,'data_Z_before':1,'data_Z_after':1-2*memory,'full_joint_states_checked':128})
    return {'cases':cases,'full_joint_states_checked':sum(c['full_joint_states_checked'] for c in cases),'maximum_joint_state_error':maximum,
        'scope':'Every report is perfect and nondemolition of B, but its actual X_M action is relevant to the later controlled-X on D. An explicitly charged X_M repairs the omitted contact. This family and repair are outside the admitted memoryless reporter.'}


def mass_probe(source,device):
    # Known-model simulator validation only. These trials are not appended
    # to the saved calibration or used to choose an execution policy.
    q=device.copy_empty_like();h=ClassicalRegister(42,'audit_reports');f=ClassicalRegister(42,'audit_present');q.add_register(h,f)
    instrument_body(device,q,h,f);shots=16384
    result=AerSimulator(method='density_matrix',max_parallel_threads=1).run(q,shots=shots,memory=True,seed_simulator=100).result();assert result.success
    positions=[q.find_bit(f[35+i]).index for i in [4,5]]
    count=sum(sum((int(text.replace(' ',''),2)>>i)&1 for i in positions) for text in result.get_memory())
    expected=.8*(1-.8)+.99*(1-.99);observed=count/shots
    radius=math.sqrt(math.log(2/1e-6)/(2*shots));assert abs(observed-expected)<=radius
    return {'validation_trials':shots,'third_report_events':count,'observed_probability':observed,
        'known_model_probability':expected,'Hoeffding_radius':radius,'test_failure_probability':1e-6,
        'new_calibration_occurrences':0,'scope':'One predeclared local distribution check; not a hardware confidence bound or new input to the selector.'}


def run(output):
    start=time.perf_counter();source=json.loads((output/'stopped-reading.json').read_text());root=stopped.cost.policy.repeated.wire.goal.ROOT
    receipt=json.loads((root/'Research/Artifacts/resident-reading-cost-20260915/receipt.json').read_text())
    assert all(digest(root/p)==value for p,value in receipt['sha256'].items())
    with patch.object(AerSimulator,'run',side_effect=AssertionError('Unexpected acquisition')):
        view=stopped.StoppedView(source,(.8,.99),root/'Research/Artifacts/resident-orientation-word-20260915')
        packets=[view.request(WANTED,risk) for risk in [.6,.5,.35]]
        for packet in packets:view.admit(packet,view.working_body(packet))
    rows=[];cases=[]
    for index,packet in enumerate(packets):
        write(output/f'plan-{packet["cost_reading"]["required_error"]}.json',packet)
        for pair in [(.8,.99),(.010000000000000009,.19999999999999996)]:
            view.saved.pair=pair;q=view.working_body(packet);view.admit(packet,q)
            rows.append(live(source,q,pair,WANTED,2026091810+len(rows)))
            with (output/f'working-{index}-{len(rows)%2}.qpy').open('wb') as f:qpy.dump(q,f)
        c=packet['expected_reads_coefficients'];m=(1+.8-.99)/2;s=(.8**2+(1-.99)**2)/2
        cases.append({'required_error':packet['cost_reading']['required_error'],'expected_interval':packet['expected_report_reads_interval'],
            'fixture_expected_reports':c[0]+c[1]*m+c[2]*s,'old_fixed_reports':packet['maximum_report_reads']})
    view.saved.pair=(.8,.99)
    for n,risk in [(7,.72),(21,.74999)]:
        wanted=[WANTED[i%2] for i in range(n)];packet=view.request(wanted,risk);q=view.working_body(packet);view.admit(packet,q)
        rows.append(live(source,q,view.saved.pair,wanted,2026091830+n))
    # Low-level endpoint fixtures do not acquire a different reporter law.
    for pair in [(0.,0.),(1.,1.)]:rows.append(live(source,stopped.compile_stopped(source,pair,packets[1]),pair,WANTED,2026091880+int(pair[0]),assert_ideal=True))
    # Exercise both asymmetric source trees too. These are explicit lowering
    # fixtures, not admitted replacements under a copied Majority guarantee.
    for name in ['AnyOne','AllOne']:
        c=deepcopy(packets[1]['cost_reading']);c['selected']['modes']=[name]*6;c['selected']['physical_report_reads']=18
        p=stopped.select(source,c);q=stopped.compile_stopped(source,(.1,.3),p)
        q.metadata['physical_word_error_upper']=None;q.metadata['fixture_only']=True
        row=live(source,q,(.1,.3),WANTED,2026091890+len(rows));row['fixture_only']=True;rows.append(row)
    refusals=[]
    def no(name,f):
        try:f()
        except (ValueError,AssertionError):refusals.append(name);return
        raise AssertionError('Accepted '+name)
    q=view.working_body(packets[1]);changed=q.copy();changed.x(0)
    no('changed stopped execution',lambda:view.admit(packets[1],changed))
    bad=deepcopy(packets[1]);bad['whole_output_error_upper']=0
    no('invented exact-output guarantee',lambda:view.working_body(bad))
    bad=deepcopy(source);bad['candidates']['Majority']['tree']={'prefix':[],'answer':0,'completions':[]}
    no('premature stop without source sufficiency',lambda:stopped.validate(bad))
    no('unresolved cost request',lambda:view.working_body(view.request(WANTED,.2)))
    from resident_classical_branch_probe import circuit
    no('unverified classical-only Store branch',lambda:stopped.check_control(circuit(0,False)))
    counter=memory_counterexample(source);mass=mass_probe(source,view.working_body(packets[1]));view.saved.check()
    result={'source':stopped.cost.admission.fingerprint(source),'algebra':algebra(source),'cost_cases':cases,'sdk':rows,
        'memory_counterexample':counter,'report_mass_probe':mass,'refusals':refusals,'new_acquisitions':0,'new_QPU_jobs':0,
        'previous_cost_receipt_entries_verified':len(receipt['sha256']),
        'full_joint_states_checked':sum(r['full_joint_states_checked'] for r in rows)+counter['full_joint_states_checked'],
        'maximum_joint_state_error':max([r['maximum_joint_state_error'] for r in rows]+[counter['maximum_joint_state_error']]),
        'seconds':time.perf_counter()-start,'full_regression':False,'implementation_sha256':digest(Path(stopped.__file__)),'check_sha256':digest(Path(__file__))}
    write(output/'audit.json',result);return result


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    result=run(p.parse_args().output.resolve());print(json.dumps({k:result[k] for k in ['full_joint_states_checked','maximum_joint_state_error','seconds','cost_cases','refusals']}))
