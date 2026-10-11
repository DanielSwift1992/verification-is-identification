#!/usr/bin/env python3
"""Independent goal meaning, existing saturation certificates and SDK use."""
import argparse
from collections import deque
from copy import deepcopy
from itertools import product
import io
import json
from pathlib import Path
import time

import numpy as np
from qiskit import qpy
from qiskit.circuit.classical import expr
from qiskit_aer import AerSimulator

import resident_goal_compiler as g
import resident_stream as stream
from resident_stream_checks import operators,trajectory
from resident_raw_reply_checks import fixture
import whole_word_admission as admission
from environment import write,digest


def question(goal,history):
    if goal=='continue':return 0
    if goal=='first':return history[0]
    if goal=='agreement':return history[0]^history[-1]
    raise ValueError('Independent question not declared')


def reading_semantics(source):
    for i,name in enumerate(source['states']):
        r,f,l=map(int,name)
        assert source['observation']['continue'][i]==[r,0]
        assert source['observation']['first'][i]==[r,f]
        assert source['observation']['agreement'][i]==[r,f^l]
        for b in (0,1):
            assert source['states'][source['operations']['reply'+str(b)][i]]==f'{1^(r^b)}{f}{b}'
    assert [source['states'][i] for i in source['initial']]==['100','011']
    # Every monitor state is reachable by an actual binary event history;
    # the separating words are possible with the admitted fair-coin service.
    witnesses={};todo=deque((i,[b]) for b,i in enumerate(source['initial']))
    while todo:
        i,h=todo.popleft()
        if i in witnesses:continue
        witnesses[i]=h
        for b in (0,1):todo.append((source['operations']['reply'+str(b)][i],h+[b]))
    assert len(witnesses)==8
    at_three=set()
    for h in product((0,1),repeat=3):
        i=source['initial'][h[0]]
        for b in h[1:]:i=source['operations']['reply'+str(b)][i]
        at_three.add(i)
    assert len(at_three)==8
    return {source['states'][i]:h for i,h in sorted(witnesses.items())}


def guards(source,plans):
    refused=[]
    def no(name,plan):
        try:g.interpret(source,plan)
        except (ValueError,AssertionError):refused.append(name);return
        raise AssertionError('Accepted '+name)
    bad=deepcopy(plans['agreement']);bad['certificate']['steps']=[];no('lost refinement reason',bad)
    bad=deepcopy(plans['continue']);bad['certificate']['classes']=list(range(8));bad['certificate']['quotient']=g.saturate.quotient(bad['model'],list(range(8)))
    no('autonomous but unjustified extra distinctions',bad)
    bad=deepcopy(plans['agreement']);labels=g.saturate.canonical(bad['model']['observation'])
    bad['certificate']['steps']=[];bad['certificate']['classes']=labels;bad['certificate']['quotient']=g.saturate.quotient(bad['model'],labels)
    no('current agreement without continuation closure',bad)
    bad=deepcopy(plans['first']);bad['goal']='agreement';no('other question under the plan',bad)
    bad=deepcopy(plans['continue']);bad['model']['operations']['reply0'][0]=0;no('changed source reply step',bad)
    return refused


def archive_reference(source,gate,n,goal):
    old=stream.compile(source['raw'],gate,n,archive=True);q=old.copy_empty_like();h=old.cregs[1]
    predicate=None if goal=='continue' else expr.lift(h[0]) if goal=='first' else expr.bit_xor(h[0],h[-1])
    for item in old.data:
        if item.operation.name=='save_density_matrix' and predicate is not None:
            with q.if_test(predicate):q.z(3)
        q.append(item)
    return q


def audit_sdk(source,plans):
    gate,ks,_=fixture(1.3,-.8);maps=operators(source['raw'],ks);cases=[];count=0;maximum=0.;shots=128
    z=np.kron(admission.I,np.kron(admission.Z,np.eye(4)))
    for goal,plan in plans.items():
        ctl=g.interpret(source,plan);width=ctl['width']
        for n in (1,3,16,64):
            qc=g.compile(source,plan,gate,n);archive=archive_reference(source,gate,n,goal)
            rs=[AerSimulator(method='statevector',max_parallel_threads=1).run(q,shots=shots,
                    seed_simulator=17302+n,memory=True).result() for q in [qc,archive]]
            assert all(r.success for r in rs)
            actual=[int(x.replace(' ',''),2) for x in rs[0].get_memory()]
            recorded=[int(x.replace(' ',''),2) for x in rs[1].get_memory()]
            matrices=[r.data()['continued'] for r in rs];error=0.;seen=set()
            for j,value in enumerate(recorded):
                h=tuple((value>>(4+k))&1 for k in range(n));r,rho=trajectory(maps,h);flag=question(goal,h)
                if flag:rho=z@rho@z
                i=source['states'].index(f'{r}{h[0]}{h[-1]}');cls=plan['certificate']['classes'][i];seen.add(cls)
                assert ctl['observation'][cls]==[r,flag]
                out=actual[j];assert out&((1<<width)-1)==cls and not (out>>width)&1
                assert (out>>(width+1))&3==(value>>2)&3
                for values in matrices:
                    e=float(np.max(abs(values[j].data-rho)));assert e<1e-10;error=max(error,e);count+=1
            maximum=max(maximum,error);f=io.BytesIO();qpy.dump(qc,f)
            cases.append({'goal':goal,'contacts':n,'classes':ctl['size'],'controller_bits':width,
                'declared_classical_bits':qc.num_clbits,'quantum_qubits':qc.num_qubits,'QPY_bytes':len(f.getvalue()),
                'classes_encountered':sorted(seen),'maximum_trajectory_residual':error,
                'same_seed_projected_records_and_recipient_bits_equal':True,
                'output_counts':rs[0].get_counts(),'archive_memory_sha256':admission.fingerprint(recorded)})
    return {'circuits':24,'shots_each':shots,'trajectory_states_checked':count,'maximum_state_residual':maximum,
            'cases':cases,'scope':'Local compilation and live recipient audit; same seed couples simulated trajectories, not physical experiments.'}


def refinement_boundaries(source,plans):
    result={}
    for a,b in product(plans,repeat=2):result[a+' -> '+b]=g.transport(source,plans[a],plans[b])
    # Same-length acquired histories, maximally mixed DEM and a fair-coin
    # service make the missing classical record a true operational ambiguity.
    def state(h):
        i=source['initial'][h[0]]
        for b in h[1:]:i=source['operations']['reply'+str(b)][i]
        return i
    witnesses={}
    for old,new in [('continue','first'),('continue','agreement'),('first','agreement')]:
        found=None
        for n in range(1,5):
            histories=list(product((0,1),repeat=n))
            for h in histories:
                for k in histories:
                    i,j=state(h),state(k)
                    if plans[old]['certificate']['classes'][i]==plans[old]['certificate']['classes'][j] and question(new,h)!=question(new,k):
                        found={'contacts':n,'histories':[list(h),list(k)],'states':[source['states'][i],source['states'][j]],
                               'old_class':plans[old]['certificate']['classes'][i],'new_answers':[question(new,h),question(new,k)],
                               'same_quantum_state':'I/8 on DEM, retained reference absent'};break
                if found:break
            if found:break
        assert found;witnesses[old+' -> '+new]=found
        # Stronger than unequal labels: unknown input data can cancel the
        # different past unitary words, giving the SAME present |+>. The new
        # I/Z recipient then needs opposite actions on that very state.
        after=[];inputs=[]
        for history in found['histories']:
            bit=0;u=np.eye(2,dtype=complex)
            for reply in history:
                active=bit^reply;u=([admission.H,admission.S][active])@u;bit=1^active
            plus=np.array([1,1])/np.sqrt(2);initial=u.conj().T@plus;present=u@initial
            assert np.max(abs(present-plus))<1e-12
            actual=([admission.I,admission.Z][question(new,history)])@present
            after.append(float(np.vdot(actual,admission.X@actual).real))
            inputs.append([[float(z.real),float(z.imag)] for z in initial])
        assert abs(after[0]-after[1])>1.9
        found['separate_live_recipient_witness']={
            'same_present_data':'|+>, with E=M=0 and an independent fair-coin instrument',
            'input_data_vectors_real_imag':inputs,'new_recipient_X_answers':after,
            'each_history_probability':2**(-found['contacts'])}
    return {'transports':result,'late_question_witnesses':witnesses}


def run(directory):
    source=json.loads((directory/'goal-reading.json').read_text());plans=json.loads((directory/'plans.json').read_text())
    before=time.perf_counter();reachability=reading_semantics(source)
    certs={goal:g.saturate.verify(p['model'],p['certificate']) for goal,p in plans.items()}
    assert {k:v['final_classes'] for k,v in certs.items()}=={'continue':2,'first':4,'agreement':8}
    result={'certificate_summaries':certs,'reachable_monitor_states':reachability,'refusals':guards(source,plans),
            'refinement_boundaries':refinement_boundaries(source,plans),'SDK':audit_sdk(source,plans),
            'seconds':time.perf_counter()-before,'new_QPU_jobs':0,'source_sha256':source['source_sha256'],
            'implementation_sha256':digest(Path(g.__file__)),'test_sha256':digest(Path(__file__))}
    write(directory/'audit.json',result);return result


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    x=run(p.parse_args().output.resolve());print(json.dumps({'classes':{k:v['final_classes'] for k,v in x['certificate_summaries'].items()},
        'SDK_states':x['SDK']['trajectory_states_checked'],'maximum_residual':x['SDK']['maximum_state_residual'],'seconds':x['seconds'],'refusals':len(x['refusals'])}))
