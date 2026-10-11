#!/usr/bin/env python3
"""Independent matrix bounds and actual mixed-read continuation checks."""
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
from qiskit import ClassicalRegister,qpy
from qiskit_aer import AerSimulator
from qiskit_aer.library import set_density_matrix,save_density_matrix

import resident_reading_cost as cost
from resident_orientation_word_checks import WANTED,target
from resident_measurement_wire_checks import I,X,j,embed
from environment import write,digest

Y=np.array([[0,-1j],[1j,0]]);Z=np.diag([1,-1]);PAULIS=[X,Y,Z]


def bloch(u):
    return np.array([[np.trace(a@u@b@u.conj().T).real/2 for b in PAULIS] for a in PAULIS])


def channel(modes,angles,pair):
    value=np.eye(3)
    for name,angle in zip(modes,angles):
        r=cost.error_rate(name,*pair)
        value=np.diag([1,1-2*r,1-2*r])@bloch(j(angle))@value
    return value


def independent_rate(rows,a,b):
    risk=0.
    for truth,p in enumerate((a,b)):
        for row in rows:
            if row['answer']!=truth:
                risk+=.5*math.prod(p if vote!=truth else 1-p for vote in row['votes'])
    return risk


def algebra(source,record,packets):
    witness=packets[0]['least_favourable'];pair=witness['canonical_pair']
    angles=[np.pi*a[0]/a[1] for a in cost.orientation.expand(source['orientation'],WANTED)]
    rotation=bloch(target(WANTED));lower=packets[0]['lower_by_upgraded_steps']
    lower={int(k):v for k,v in lower.items()};minimum={};maximum=0.;checked=0
    for name,rows in source['candidates'].items():
        for a,b in [pair,(.1,.3),(.8,.99),(0.,0.),(1.,1.)]:
            error=abs(independent_rate(rows,a,b)-cost.error_rate(name,a,b))
            assert error<1e-12;maximum=max(maximum,error)
    # All four readings at all six logical steps. The lower bound must
    # cover arrangements not emitted by the restricted constructive search.
    matrices={name:[np.diag([1,1-2*cost.error_rate(name,*pair),1-2*cost.error_rate(name,*pair)])@bloch(j(a)) for a in angles]
        for name in source['candidates']}
    for modes in product(source['candidates'],repeat=6):
        value=np.eye(3)
        for i,name in enumerate(modes):value=matrices[name][i]@value
        k=sum(name!='Single' for name in modes)
        bell_failure=float((3-np.trace(rotation.T@value))/4)
        assert bell_failure+1e-12>=lower[k]
        minimum[k]=min(minimum.get(k,1.),bell_failure);checked+=1
    # At most one anisotropic block makes the selected bound exact at the
    # common witness, up to its deliberate outward numerical padding.
    for packet in packets:
        if packet['kind']!='act':continue
        chosen=packet['selected'];value=channel(chosen['modes'],angles,pair)
        exact=float((3-np.trace(rotation.T@value))/4)
        if chosen['block_counts'][1]+chosen['block_counts'][2]<=1:
            assert 0<=chosen['error_upper']-exact<1e-9
        if packet['cost_minimality']=='proved_in_declared_catalogue':
            assert all(value>packet['required_error'] for k,value in minimum.items() if k<chosen['upgraded_steps'])
    # The joint confidence rectangle has one worst feasible reporter, not
    # the incompatible independent maxima of its two error coordinates.
    rng=np.random.default_rng(2026091571);physical=0
    for mean,second in zip(rng.uniform(*witness['mean_interval'],2048),rng.uniform(*witness['second_moment_interval'],2048)):
        if second<mean*mean:continue
        t=math.sqrt(second-mean*mean);a=mean-t;b=1-mean-t
        if min(a,b)<0:continue
        assert a<=pair[0]+1e-12 and b<=pair[1]+1e-12
        for name in source['candidates']:assert cost.error_rate(name,a,b)<=cost.error_rate(name,*pair)+1e-12
        physical+=1
    assert physical>0
    # Endpoint geometry independent of the particular acquisition. These
    # hand-set intervals are mathematical fixtures, not new evidence.
    fixtures=[([.4,.6],[.16,.36],'witness',True),([.1,.2],[.3,.4],'incompatible_moments',None),
              ([.4,.5],[.01,.05],'incompatible_moments',None),([.4,.45],[.22,.24],'witness',False)]
    for mean,second,kind,zero in fixtures:
        with patch.object(cost.policy,'parameter_region',return_value={'mean':mean,'second_moment':second}):
            result=cost.least_favourable({'orientation':'unoriented'})
        assert result['kind']==kind
        if zero is not None:assert result['zero_contraction']==zero
    return {'fixed_plans_checked':checked,'minimum_Bell_failure_by_upgrades':minimum,
        'physical_moment_points_checked':physical,'geometry_fixtures':len(fixtures),'maximum_rate_formula_error':maximum,
        'scope':'Finite matrix validation accompanies the analytic trace and channel bounds; not a general diamond-norm solver.'}


def live(source,device,pair,wanted,seed,shots=64,assert_ideal=False):
    buf=io.BytesIO();qpy.dump(device,buf);buf.seek(0);restored,=qpy.load(buf)
    assert restored==device and cost.policy.repeated.work.ordered_bindings(restored)==cost.policy.repeated.work.ordered_bindings(device)
    angles=cost.orientation.expand(source['orientation'],wanted);modes=device.metadata['modes']
    owner=device.metadata['wire_boundary']['boundary']['physical_owner'];reads=device.metadata['physical_report_reads']
    tables={name:{tuple(row['votes']):row['answer'] for row in rows} for name,rows in source['candidates'].items()}
    rng=np.random.default_rng(seed);v=rng.normal(size=8)+1j*rng.normal(size=8);v/=np.linalg.norm(v);initial=np.outer(v,v.conj())
    q=restored.copy_empty_like();set_density_matrix(q,np.kron(np.diag([1,0]),embed(initial,0)))
    history=ClassicalRegister(reads,'audit_reports');q.add_register(history);count=0
    for item in restored.data:
        q.append(item)
        if item.operation.name=='measure':q.store(history[count],item.clbits[0]);count+=1
    assert count==reads
    save_density_matrix(q,range(5),label='output',pershot=True);q.s(owner);save_density_matrix(q,range(5),label='consumer',pershot=True)
    result=AerSimulator(method='density_matrix',max_parallel_threads=1).run(q,shots=shots,memory=True,seed_simulator=seed+19).result()
    assert result.success;maximum=0.;ideal=np.kron(np.eye(4),target(wanted));ideal=ideal@initial@ideal.conj().T
    for index,text in enumerate(result.get_memory()):
        word=int(text.replace(' ',''),2);assert word&((1<<device.num_clbits)-1)==0
        records=[(word>>q.find_bit(bit).index)&1 for bit in history];rho=initial;offset=0
        for mode,angle in zip(modes,angles):
            n=source['report_counts'][mode];votes=tuple(records[offset:offset+n]);offset+=n
            answer=tables[mode][votes];value=np.zeros_like(rho)
            for b,p in enumerate(pair):
                likelihood=math.prod(p if y!=b else 1-p for y in votes)
                k=np.kron(np.eye(4),np.linalg.matrix_power(X,b^answer)@j(np.pi*angle[0]/angle[1]))/np.sqrt(2)
                value+=likelihood*k@rho@k.conj().T
            assert np.trace(value).real>0;rho=value/np.trace(value).real
        assert offset==reads
        if assert_ideal:assert np.max(abs(rho-ideal))<1e-11
        consumer=np.kron(np.eye(4),np.diag([1,1j]));after=consumer@rho@consumer.conj().T
        for label,state in [('output',rho),('consumer',after)]:
            expected=np.kron(np.diag([1,0]),embed(state,owner));error=float(np.max(abs(result.data()[label][index].data-expected)))
            assert error<1e-10;maximum=max(maximum,error)
    return {'rotation_pairs':len(wanted),'logical_steps':len(angles),'physical_report_reads':reads,'physical_reporter':list(pair),
        'modes':modes,'ideal_output_asserted':assert_ideal,'full_joint_states_checked':2*shots,
        'maximum_joint_state_error':maximum,'QPY_bytes':len(buf.getvalue()),'qubits':device.num_qubits,'working_classical_bits':device.num_clbits}


def guards(view,packet,body):
    names=[]
    def no(name,f):
        try:f()
        except (ValueError,AssertionError,KeyError):names.append(name);return
        raise AssertionError('Accepted '+name)
    old=deepcopy(view.record);view.record['pair_counts']['00']-=1
    no('changed acquired record',view.check);view.record=old
    old=view.pair;view.pair=(.4,.4);no('unacquired reporter orbit',view.check);view.pair=old
    wrong=deepcopy(packet);wrong['selected']['modes']=['Single']*6;wrong['selected']['physical_report_reads']=6
    no('cheaper execution with a copied stronger guarantee',lambda:view.working_body(wrong))
    wrong=deepcopy(packet);wrong['request'][0]['x']=[0,1]
    # The bound is uniform in the requested angles. Re-reading the same
    # evidence for a new angle is valid; executing the OLD body is not.
    new_body=view.working_body(wrong);view.admit(wrong,new_body)
    no('old execution substituted for the newly requested target',lambda:view.admit(wrong,body))
    changed=body.copy();changed.x(0)
    no('extra physical action under unchanged metadata',lambda:view.admit(packet,changed))
    no('an isolated primitive without the complete orientation word',lambda:view.request([[0,1]],.5))
    old=deepcopy(view.source);view.source['report_counts']['Single']=0
    no('unpaid report cost',view.check);view.source=old
    no('an unresolved stricter request cannot execute',lambda:view.working_body(view.request(WANTED,.2)))
    return names


def run(output):
    start=time.perf_counter();source=json.loads((output/'cost-reading.json').read_text())
    prior=cost.policy.repeated.wire.goal.ROOT/'Research/Artifacts/resident-orientation-word-20260915'
    rows=[];packets=[]
    # Any accidental reacquisition here is a test failure, before ordinary
    # SDK execution is enabled below. The old occurrence answers new goals.
    with patch.object(AerSimulator,'run',side_effect=AssertionError('Unexpected new acquisition')):
        view=cost.SavedCostView(source,(.8,.99),prior)
        for risk in [.6,.5,.35,.2]:packets.append(view.request(WANTED,risk))
        for packet in packets[:3]:view.admit(packet,view.working_body(packet))
        new_goal=view.request([WANTED[0]],.5);assert new_goal['kind']=='act'
    assert [p['selected']['physical_report_reads'] for p in packets[:3]]==[6,8,16]
    assert all(p['cost_minimality']=='proved_in_declared_catalogue' for p in packets[:3])
    assert packets[3]['kind']=='needs_evidence' and packets[3]['witness_excludes_all_current_plans']
    for index,packet in enumerate(packets[:3]):
        write(output/f'plan-{packet["required_error"]}.json',packet)
        for pair in [(.8,.99),(1-.99,1-.8)]:
            view.pair=pair;body=view.working_body(packet);view.admit(packet,body)
            rows.append(live(source,body,pair,WANTED,2026091700+len(rows)))
            with (output/f'working-{index}-{len(rows)%2}.qpy').open('wb') as stream:qpy.dump(body,stream)
    view.pair=(.8,.99);refusals=guards(view,packets[1],view.working_body(packets[1]))
    # Fixed-size memory and longer mixed programs. All remain actual source
    # applications; low-level ideal fixtures are explicitly not admissions.
    long_plans=[]
    for length,risk in [(7,.72),(21,.74999)]:
        wanted=[WANTED[i%2] for i in range(length)];packet=view.request(wanted,risk);long_plans.append(packet)
        assert packet['kind']=='act';body=view.working_body(packet);view.admit(packet,body)
        rows.append(live(source,body,view.pair,wanted,2026091740+length))
    for pair in [(0.,0.),(1.,1.)]:
        body=cost.compile_plan(source,pair,packets[1])
        rows.append(live(source,body,pair,WANTED,2026091780+int(pair[0]),assert_ideal=True))
    view.check()
    result={'source':cost.admission.fingerprint(source),'saved_receipt_entries_verified':len(view.receipt['sha256']),
        'new_acquisitions':0,'new_QPU_jobs':0,'acquired_record_sha256':view.origin,
        'same_occurrence_answers_new_target':new_goal,'new_tolerance_readings':packets,'long_plans':long_plans,
        'algebra':algebra(source,view.record,packets),'sdk':rows,'refusals':refusals,
        'full_joint_states_checked':sum(r['full_joint_states_checked'] for r in rows),
        'maximum_joint_state_error':max(r['maximum_joint_state_error'] for r in rows),
        'seconds':time.perf_counter()-start,'full_regression':False,
        'implementation_sha256':digest(Path(cost.__file__)),'check_sha256':digest(Path(__file__))}
    write(output/'audit.json',result);return result


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    result=run(p.parse_args().output.resolve())
    print(json.dumps({k:result[k] for k in ['full_joint_states_checked','maximum_joint_state_error','seconds','refusals','new_acquisitions']}))
