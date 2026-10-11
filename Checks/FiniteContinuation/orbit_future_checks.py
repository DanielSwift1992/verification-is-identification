#!/usr/bin/env python3
"""Exact cyclic cost, actual operator questions, and joint-realization refusals."""
from copy import deepcopy
from itertools import product,combinations_with_replacement
import json
import subprocess
import time

import numpy as np
from qiskit import QuantumCircuit,qpy
from qiskit.circuit.library import DiagonalGate
from qiskit.quantum_info import Operator

import orbit_return as o
import orbit_future as f

OUT=o.ROOT/'Research/Artifacts/returning-attempt-20260916/future-orbit'


def circuit(m,plan,phases,observables):
    f.verify(m,observables,plan)
    # This lowering is the bound three-source-bit fixture, not a general
    # synthesis of arbitrary F. A physical gate-body is not extra user access.
    assert m['f']==[0,0,3,3,2,2,1,1] and m['permutations']['T']==[1,2,3,0,5,6,7,4]
    q=QuantumCircuit(6,name='question_selected_forward_return')
    for j,k in enumerate(plan['powers']):
        q.append(DiagonalGate(list(phases)),[0,1,2])
        q.cx(1,3);q.cx(2,4);q.cx(1,4)
        if j==0:q.cx(3,5);q.cx(4,5)
        for _ in range(k):q.cx(0,1);q.x(0)
    delta=plan['computed']['cleanup_by_answer']
    for bit in (0,1):
        if (delta['0']>>bit)&1:q.x(3+bit)
        if ((delta['0']^delta['1'])>>bit)&1:q.cx(5,3+bit)
    return q


def boundary_witness(m,plan,observable):
    """Same returned CQ state in two allowed (input,unknown-phase) worlds.

    A known fixed unitary is reversible. The obstruction instead concerns
    ONE output-only decoder that must work for every still-possible phase.
    """
    refusal=f.admit(m,plan['powers'],[observable]);assert not refusal['admitted']
    s,t=refusal['pair'];x=refusal['phase_label'];diff=refusal['difference']
    phase=np.ones(len(m['q']),complex);phase[x]=np.exp(1j*np.pi/diff)
    original=np.zeros(len(m['q']),complex);original[s]=1/np.sqrt(2)
    original[t]=np.conj(observable[s,t])/abs(observable[s,t])/np.sqrt(2)
    counts=np.array(plan['computed']['visits'])
    residual=np.prod(phase[None,:]**counts,axis=1)
    other=residual.conj()*original
    # This word was admitted for the smaller support family. The stronger
    # observable is a proposed new recipient, not a renamed old admission.
    admitted_question=np.zeros((len(m['q']),len(m['q'])),complex)
    for i,j in plan['question_edges']:admitted_question[i,j]=admitted_question[j,i]=1
    first=f.execute(m,plan,[admitted_question])
    second=f.execute(m,plan,[admitted_question],lambda j,s,w:phase[s])
    equal=max(float(np.max(abs(np.outer(k0@original,(k0@original).conj())-
                                   np.outer(k1@other,(k1@other).conj()))))
              for (a0,w0,k0),(a1,w1,k1) in zip(first['rows'],second['rows'])
              if (a0,w0)==(a1,w1))
    assert [(a,w) for a,w,k in first['rows']]==[(a,w) for a,w,k in second['rows']]
    wanted=[float((v.conj()@observable@v).real) for v in (original,other)]
    assert equal<1e-12 and abs(wanted[0]-wanted[1])>1e-12
    return {'pair':[s,t],'phase_label':x,'count_difference':diff,
            'entire_returned_CQ_residual':equal,'different_target_expectations':wanted,
            'scope':'Unknown source input AND unknown static phase are independently allowed; no further unknown-oracle access.'}


def brute_histogram_minimum(m,observables,upper):
    """Independent enumeration of visit multisets, not the subgroup formula."""
    cycles,length=f.cyclic_model(m);n=len(m['q'])
    required=f.edges(m,observables)
    for calls in range(1,upper+1):
        for tail in combinations_with_replacement(range(length),calls-1):
            offsets=(0,)+tail;counts=[[0]*n for _ in range(n)];works=[0]*n
            for cycle in cycles:
                for z,s in enumerate(cycle):
                    for offset in offsets:
                        at=cycle[(z+offset)%length];counts[s][at]+=1;works[s]^=m['f'][at]
            if any(counts[s]!=counts[t] for s,t in required):continue
            if any(m['q'][s]==m['q'][t] and works[s]!=works[t] for s in range(n) for t in range(n)):continue
            return calls
    raise AssertionError('No attaining histogram')


def run():
    start=time.perf_counter();OUT.mkdir(parents=True,exist_ok=True)
    source=o.read_source();m=o.model(source)
    requests={
        'diagonal':f.future(['IZI'],[]),
        'B_phase':f.future(['IXI'],[]),
        'C_phase':f.future(['IIX'],[]),
        'B_phase_then_possible_swap':f.future(['IXI'],['Swap_BC']),
        'B_label_then_possible_H':f.future(['IZI'],['H_B']),
    }
    plans={};costs={};operator_checks={};refusals={}
    angles=np.array([.17,-.42,.73,1.14,-2.01,.26,.31,-.87]);phases=np.exp(1j*angles)
    words=[''.join(v) for v in product('IZ','IXYZ','IXYZ')]
    for name,request in requests.items():
        f.verify_future(request);observables=[f.pauli(w) for w in request['closure']]
        plan=f.optimal(m,observables);cost=f.verify(m,observables,plan)
        plans[name]=plan;costs[name]=cost
        result=f.execute(m,plan,observables,lambda j,s,w:phases[s])
        rows=result['rows'];assert all(w==0 for _,w,_ in rows)
        complete=sum(k.conj().T@k for _,_,k in rows)
        assert np.max(abs(complete-np.eye(8)))<1e-12
        worst=0.
        for e in observables:
            actual=sum(k.conj().T@e@k for _,_,k in rows)
            worst=max(worst,float(np.max(abs(actual-e))))
        assert worst<1e-12
        # Check the complete requested future word with its actual sign, not
        # only membership of a Pauli name in the sign-free closure.
        future_word_error=0.
        for witness in request['closure'].values():
            u=np.eye(8,dtype=complex)
            for name_of_control in witness['word']:u=f.CONTROLS[name_of_control]@u
            e=u.conj().T@f.pauli(witness['terminal'])@u
            actual=sum(k.conj().T@e@k for _,_,k in rows)
            future_word_error=max(future_word_error,float(np.max(abs(actual-e))))
        assert future_word_error<1e-12
        qc=circuit(m,plan,phases,observables);sdk=Operator(qc).data[:,:8]
        sdk_error=float(np.max(abs(sdk-result['isometry'])));assert sdk_error<1e-12
        with (OUT/(name+'.qpy')).open('wb') as out:qpy.dump(qc,out)
        classified={'kept':[],'obstructed':[]}
        for word in words:
            e=f.pauli(word)
            if f.admit(m,plan['powers'],[e])['admitted']:classified['kept'].append(word)
            else:classified['obstructed'].append({'word':word,**boundary_witness(m,plan,e)})
        assert len(classified['kept'])==cost['future_algebra_dimension']
        operator_checks[name]={'all_input_adjoint_residual':worst,'SDK_isometry_residual':sdk_error,
                               'actual_signed_future_word_residual':future_word_error,
                               'maximal_Pauli_space':classified}
    assert [costs[k]['minimum_joint_oracle_calls'] for k in requests]==[2,2,4,4,2]
    assert [costs[k]['future_algebra_dimension'] for k in requests]==[8,16,32,32,16]
    assert [costs[k]['minimum_forward_T_calls'] for k in requests]==[0,4,4,4,4]

    # Rejecting a later requested swap is not enough: backward closure derives
    # the larger requirement BEFORE acquisition, selecting four calls.
    half=plans['B_phase'];e=f.pauli('IIX')
    refuses_swap=boundary_witness(m,half,e)
    assert requests['B_phase_then_possible_swap']['closure']['IIX']['word']==['Swap_BC']

    # The answer exists after the first V even for a diagonal consumer; W is
    # still F(s), which cannot be cleared using only q. This is a readiness
    # lower bound, not missing target information.
    one=o.analyse(f.powered_model(m),['T0'])
    assert one['final_source']==list(range(8))
    assert m['q'][0]==m['q'][2] and one['work_before_cleanup'][0]!=one['work_before_cleanup'][2]

    # General finite examples use two q-cycles, NOT the eight-state fixture.
    # All binary payload masks for lengths 2..5 and selected masks at 6..8;
    # every nonzero cyclic difference is a separate requested observable.
    general=[]
    for length in range(2,9):
        masks=range(1<<length) if length<=4 else [0,1,3,(1<<length)-1]
        for mask in masks:
            model={'schema':m['schema'],'source':f'explicit-cycle-{length}-{mask}',
                'q':[a for a in (0,1) for _ in range(length)],
                'f':[2*a+((mask>>z)&1) for a in (0,1) for z in range(length)],
                'work_bits':2,'elementary_contacts_per_oracle':1,
                'permutations':{'T':[a*length+(z+1)%length for a in (0,1) for z in range(length)]},
                'oracle_contract':m['oracle_contract']}
            for diff in range(length):
                e=np.zeros((2*length,2*length),complex)
                if diff:e[0,diff]=e[diff,0]=1
                p=f.optimal(model,[e]);checked=f.verify(model,[e],p)
                minimum=brute_histogram_minimum(model,[e],checked['minimum_joint_oracle_calls'])
                assert minimum==checked['minimum_joint_oracle_calls']
                general.append({'length':length,'mask':mask,'difference':diff,'calls':minimum,
                                'T_calls':checked['minimum_forward_T_calls']})

    # All closed words up to four calls in the actual cycle independently
    # confirm the achieved two-resource lower bounds (no larger search claim).
    brute={k:None for k in requests}
    for calls in range(1,5):
        for powers in product(range(4),repeat=calls):
            if sum(powers)%4:continue
            for name,request in requests.items():
                try:r=f.admit(m,list(powers),[f.pauli(w) for w in request['closure']])
                except ValueError:continue
                if r['admitted']:
                    pair=(calls,sum(powers));brute[name]=min(brute[name] or pair,pair)
    for name,cost in costs.items():assert brute[name]==(cost['minimum_joint_oracle_calls'],cost['minimum_forward_T_calls'])

    rejected=[]
    def reject(name,fn):
        try:fn()
        except (ValueError,AssertionError,KeyError):rejected.append(name)
        else:raise AssertionError('Accepted '+name)
    wrong=deepcopy(requests['B_phase_then_possible_swap']);del wrong['closure']['IIX']
    reject('omitted future needed after swap',lambda:f.verify_future(wrong))
    wrong=deepcopy(half);wrong['lower_bound']['minimum_oracle_calls']=1
    reject('invented lower bound',lambda:f.verify(m,[f.pauli('IXI')],wrong))
    wrong=deepcopy(half);wrong['powers']=[0,0]
    reject('correct answer but wrong future',lambda:f.verify(m,[f.pauli('IXI')],wrong))
    reject('old narrow plan reused for expanded future',lambda:f.verify(m,[f.pauli('IXI'),f.pauli('IIX')],half))
    reject('execution skipped current recipient admission',lambda:f.execute(m,half,[f.pauli('IIX')]))
    reject('answer mistaken for reusable readiness',lambda:f.word_data(m,[0]))
    reject('cross-answer coherence silently discarded',lambda:f.future(['XII'],[]))
    changed=deepcopy(m);changed['f'][0]=1
    reject('archived certificate attached to new source',lambda:f.verify(changed,[f.pauli('IXI')],half))
    # Exact support, not a tolerance: an arbitrarily small nonzero coefficient
    # still requires the C-phase relation in an exact guarantee.
    tiny=1e-16*f.pauli('IIX');assert f.optimal(m,[tiny])['lower_bound']['minimum_oracle_calls']==4

    payload={'source':source,'plans':{k:plans[k] for k in ('diagonal','B_phase','C_phase')}}
    (OUT/'court-input.json').write_text(json.dumps(payload,indent=2)+'\n')
    court=json.loads(subprocess.run(['node',str(o.ROOT/'Checks/FiniteContinuation/orbit_future_court.js'),
        str(OUT/'court-input.json'),str(OUT)],capture_output=True,text=True,check=True,timeout=30).stdout)
    for name,value in [('model',m),('requests',requests),('plans',plans),('court',court),('general-cases',general)]:
        (OUT/(name+'.json')).write_text(json.dumps(value,indent=2)+'\n')
    result={'schema':'vi.orbit-future-checks.v1','costs':costs,'actual_word_checks':operator_checks,
        'expanded_future_refusal':refuses_swap,'one_call_readiness_pair':[0,2],
        'independent_histogram_cases':len(general),'bounded_word_costs':brute,
        'rejected_certificates':rejected,'exact_tiny_coefficient_requires_four':True,
        'Swift_bounded_court':court,'new_QPU_jobs':0,'seconds':time.perf_counter()-start,
        'scope':'Static independent scalar phases; fixed words using powers of one actual cycle. '
                'Uniform output-only recovery and declared post-q futures. No hardware result.'}
    (OUT/'checks.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:v for k,v in result.items() if k not in ('actual_word_checks','Swift_bounded_court')},indent=2))


if __name__=='__main__':run()
