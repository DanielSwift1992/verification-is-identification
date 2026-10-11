#!/usr/bin/env python3
"""Exact finite future certificates, real erasure, and two-use distinction."""
from copy import deepcopy
import json
import time

import numpy as np
from qiskit import QuantumCircuit, ClassicalRegister, qpy
from qiskit.quantum_info import Operator

import orbit_return as o
import orbit_future as orbit
import memory_future_admission as f

OUT=o.ROOT/'Research/Artifacts/returning-attempt-20260916/memory-future'
DEPHASE=[f.I/np.sqrt(2),f.Z/np.sqrt(2)]
RESET=[np.array([[1,0],[0,0]],complex),np.array([[0,1],[0,0]],complex)]


def apply_memory(rho,kraus,reference=1):
    operators=[np.kron(k,np.eye(2*reference)) for k in kraus]
    return sum(k@rho@k.conj().T for k in operators)


def trace_memory(rho):
    n=len(rho)//2
    return np.trace(rho.reshape(2,n,2,n),axis1=0,axis2=2)


def physical_circuit(spec,word,terminal,initial_memory='none'):
    require= f.require
    require(terminal in ('IX','IY','IZ'),'Read one source Pauli')
    q=QuantumCircuit(2,name=spec['description']['kind']+'_'+initial_memory)
    answer=ClassicalRegister(1,'source_answer');q.add_register(answer)
    if initial_memory=='dephase':
        lost=ClassicalRegister(1,'unread_memory_record');q.add_register(lost);q.measure(1,lost[0])
    elif initial_memory=='Z':q.z(1)
    else:require(initial_memory=='none','Unknown memory action')
    kind=spec['description']['kind']
    for gate in word:
        if gate=='H_source':q.h(0)
        elif gate=='S_source':q.s(0)
        elif gate=='H_memory':q.h(1)
        elif gate=='V':
            if kind=='common_factor':q.z(0);q.h(1)
            else:
                q.cz(0,1)
                if kind=='rotating_memory':q.h(1)
        else:raise AssertionError(gate)
    if terminal=='IY':q.sdg(0)
    if terminal in ('IX','IY'):q.h(0)
    q.measure(0,answer[0]);return q


def independent_effect(q):
    """All unnormalized branches of serialized gates, including ignored E read."""
    branches={():np.eye(4,dtype=complex)};segment=QuantumCircuit(2)
    def flush():
        nonlocal branches,segment
        if segment.data:
            gate=Operator(segment).data;branches={a:gate@k for a,k in branches.items()};segment=QuantumCircuit(2)
    for ins in q.data:
        wires=[q.find_bit(x).index for x in ins.qubits];gate=ins.operation
        if gate.name=='measure':
            flush();wire=wires[0];updated={}
            for history,k in branches.items():
                for value in (0,1):
                    projector=np.diag([int(((i>>wire)&1)==value) for i in range(4)])
                    updated[history+((wire,value),)]=projector@k
            branches=updated
        else:segment.append(gate,wires)
    flush();assert all(history[-1][0]==0 for history in branches)
    return sum(k.conj().T@k for history,k in branches.items() if history[-1]==(0,0))


def run():
    start=time.perf_counter();OUT.mkdir(parents=True,exist_ok=True);source=o.read_source();model=o.model(source)
    assert model['q'][:2]==[0,0] and model['f'][:2]==[0,0]
    assert np.max(abs(orbit.CONTROLS['H_C']-np.kron(np.eye(4),f.H)))<1e-12
    swap=orbit.CONTROLS['Swap_BC'] if 'Swap_BC' in orbit.CONTROLS else orbit.CONTROLS['SwapBC']
    assert np.max(abs(swap@orbit.CONTROLS['S_B']@swap-np.kron(np.eye(4),f.S)))<1e-12
    specs={name:f.interface(source,name) for name in ('common_factor','phase_memory','rotating_memory')}
    specs['phase_with_memory_access']=f.interface(source,'phase_memory',True)
    certificates={name:f.build(spec) for name,spec in specs.items()}
    assert [len(certificates[n]['basis']) for n in specs]==[4,7,16,16]
    assert certificates['rotating_memory']['strict_expansion_dimensions']==[4,6,9,13,16]

    # Every entry checked against two different representations: exact signed
    # Pauli rules and dense operators from the producing contact circuit.
    checked_images=0
    for spec in specs.values():
        for name,gate in spec['gates'].items():
            for label in f.MATRICES:
                assert f.image(gate,label)==f.exact_image(spec['description']['kind'],name,label)
                checked_images+=1

    operations={'identity':[f.I],'Z':[f.Z],'H':[f.H],'dephase_Z':DEPHASE,'reset_zero':RESET,
                'unknown_example_Z_rotation':[np.cos(.317)*f.I+1j*np.sin(.317)*f.Z]}
    admissions={name:{op:f.admit_channel(spec,certificates[name],ks)['kind'] for op,ks in operations.items()}
                for name,spec in specs.items()}
    good='preserves_declared_future';bad='distinguished'
    assert set(admissions['common_factor'].values())=={good}
    assert admissions['phase_memory']=={op:(good if op not in ('H','reset_zero') else bad) for op in operations}
    assert all(admissions['rotating_memory'][op]==(good if op=='identity' else bad) for op in operations)
    assert all(admissions['phase_with_memory_access'][op]==(good if op=='identity' else bad) for op in operations)
    # A visible restriction can be weaker than commuting with every device action.
    noncommutator=float(np.max(abs(f.Z@f.H-f.H@f.Z)));assert noncommutator>1

    # Identical one-use reduced channels on ALL correlated source/E inputs.
    phase=specs['phase_memory'];rotating=specs['rotating_memory']
    va=phase['gates']['V'];vb=rotating['gates']['V'];one_use=0.
    for matrix in f.MATRICES.values():
        one_use=max(one_use,float(np.max(abs(trace_memory(va@matrix@va.conj().T)-trace_memory(vb@matrix@vb.conj().T)))))
    assert one_use<1e-12
    for visible in f.VISIBLE:
        assert np.max(abs(va.conj().T@f.MATRICES[visible]@va-vb.conj().T@f.MATRICES[visible]@vb))<1e-12

    # The actual two-use distinction is a product input, no entangled setup:
    # |Y+>_E |Y+>_S. Z_E is invisible for one query and detectable after two.
    plus_y=np.array([1,1j])/np.sqrt(2);v=np.kron(plus_y,plus_y);rho=np.outer(v,v.conj())
    table={}
    for name,spec in (('phase_memory',phase),('rotating_memory',rotating)):
        table[name]={}
        for count in (1,2):
            unitary=f.word_operator(spec,['V']*count);effect=(np.eye(4)+f.MATRICES['IX'])/2
            table[name][str(count)]={op:float(np.trace(effect@unitary@apply_memory(rho,ks)@unitary.conj().T).real)
                                   for op,ks in (('none',[f.I]),('Z',[f.Z]),('dephase_Z',DEPHASE))}
    assert np.max(abs(np.array(list(table['rotating_memory']['1'].values()))-[.5,.5,.5]))<1e-12
    assert np.max(abs(np.array(list(table['rotating_memory']['2'].values()))-[1,0,.5]))<1e-12
    assert np.max(abs(np.array(list(table['phase_memory']['2'].values()))-[.5,.5,.5]))<1e-12
    other=np.kron(plus_y.conj(),plus_y);rho_minus=np.outer(other,other.conj())
    erased_pair_error=float(np.max(abs(apply_memory(rho,DEPHASE)-apply_memory(rho_minus,DEPHASE))))
    pair_answers=[f.audit_reading(rotating,['V','V'],'IX',r) for r in (rho,rho_minus)]
    assert erased_pair_error<1e-12 and np.max(abs(np.array(pair_answers)-[1,0]))<1e-12

    # A rejected transformation comes with a realizable finite continuation and
    # a legitimate distinguishing density matrix, not only a failed search.
    rejected=f.admit(rotating,certificates['rotating_memory'],f.Z)
    assert rejected['continuation']['word']==['V','V']
    witness,probabilities=f.witness_state(rotating,rejected,f.Z)
    assert np.min(np.linalg.eigvalsh(witness))>-1e-12 and abs(sum(probabilities)-1)<1e-12
    assert abs(probabilities[0]-probabilities[1])>1-1e-12

    # Physical memory erasure admitted on the phase interface survives arbitrary
    # initial correlations with an untouched reference and random source controls.
    rng=np.random.default_rng(91647);v=rng.normal(size=(8,3))+1j*rng.normal(size=(8,3))
    correlated=v@v.conj().T;correlated/=np.trace(correlated);retained_error=0.
    for spec,ks in ((phase,DEPHASE),(specs['common_factor'],RESET)):
        before=apply_memory(correlated,ks,reference=2)
        names=list(spec['gates'])
        for length in range(13):
            word=[names[int(rng.integers(len(names)))] for _ in range(length)]
            u=np.kron(f.word_operator(spec,word),np.eye(2))
            first=trace_memory(u@correlated@u.conj().T);second=trace_memory(u@before@u.conj().T)
            retained_error=max(retained_error,float(np.max(abs(first-second))))
    assert retained_error<1e-12

    # Execute the synthesized physical memory choices, including their update,
    # on the same correlated input throughout a stream. No history replay.
    memory_plans={name:f.retained_memory_plan(spec,certificates[name]) for name,spec in specs.items()}
    assert [memory_plans[n]['kind'] for n in specs]==['no_active_environment_memory','classical_Z_record',
        'retain_quantum_environment','retain_quantum_environment']
    stream_checks={}
    for name,spec in specs.items():
        reduced=f.ReducedFlow(spec,certificates[name],correlated);actual=correlated.copy();error=0.
        names=list(spec['gates']);word=[names[int(rng.integers(len(names)))] for _ in range(31)]
        for gate in word:
            reduced.step(gate);u=np.kron(spec['gates'][gate],np.eye(2));actual=u@actual@u.conj().T
            error=max(error,float(np.max(abs(reduced.source_and_reference()-trace_memory(actual)))))
        assert error<1e-12
        stream_checks[name]={'steps':reduced.count,'source_reference_residual':error,'plan':reduced.plan,
            'quantum_E_retained':reduced.quantum is not None}
    common_extra=f.interface(source,'common_factor',True);extra_cert=f.build(common_extra)
    extra_flow=f.ReducedFlow(common_extra,extra_cert,correlated)
    extra_flow.step('H_memory');extra_flow.step('V')
    extra_u=np.kron(f.word_operator(common_extra,['H_memory','V']),np.eye(2))
    assert np.max(abs(extra_flow.source_and_reference()-trace_memory(extra_u@correlated@extra_u.conj().T)))<1e-12

    # Independent SDK readers for EVERY nonidentity derived direction of the
    # full interface, plus the three actual two-query memory treatments.
    circuits=[];wanted=[];descriptions=[]
    for label,w in certificates['rotating_memory']['basis'].items():
        if label=='II':continue
        circuits.append(physical_circuit(rotating,w['word'],w['terminal']))
        wanted.append((np.eye(4)+w['sign']*f.MATRICES[label])/2)
        descriptions.append({'direction':label,**w})
    for op,ks in (('none',[f.I]),('Z',[f.Z]),('dephase',DEPHASE)):
        circuits.append(physical_circuit(rotating,['V','V'],'IX',op))
        u=f.word_operator(rotating,['V','V']);a=u.conj().T@(np.eye(4)+f.MATRICES['IX'])/2@u
        wanted.append(sum(np.kron(k,f.I).conj().T@a@np.kron(k,f.I) for k in ks))
        descriptions.append({'memory_action':op,'word':['V','V'],'terminal':'IX'})
    path=OUT/'DerivedFutureWitnesses.qpy'
    with path.open('wb') as handle:qpy.dump(circuits,handle)
    with path.open('rb') as handle:restored=qpy.load(handle)
    errors=[float(np.max(abs(independent_effect(q)-w))) for q,w in zip(restored,wanted)]
    assert max(errors)<1e-12 and len(restored)==18

    refusals=[]
    def refuse(name,fn):
        try:fn()
        except (ValueError,AssertionError,KeyError):refusals.append(name)
        else:raise AssertionError('Accepted '+name)
    refuse('same one-use channel treated as same future interface',lambda:f.verify(rotating,certificates['phase_memory']))
    damaged=deepcopy(certificates['rotating_memory']);del damaged['basis']['YY']
    refuse('one-query agreement without continuation closure',lambda:f.verify(rotating,damaged))
    damaged=deepcopy(certificates['rotating_memory']);damaged['basis']['YY']['word']=['V']
    refuse('invented finite witness',lambda:f.verify(rotating,damaged))
    damaged=deepcopy(certificates['rotating_memory']);damaged['closure']['IX']['V']=['IX',1]
    refuse('self comparison substituted for actual pullback',lambda:f.verify(rotating,damaged))
    changed=dict(phase);changed['gates']=dict(phase['gates']);changed['gates']['V']=vb
    refuse('gate replaced behind old interface identifier',lambda:f.verify(changed,certificates['phase_memory']))
    refuse('old memory permission carried across new memory access',lambda:f.verify(specs['phase_with_memory_access'],certificates['phase_memory']))
    refuse('postselected erasure declared trace preserving',lambda:f.admit_channel(phase,certificates['phase_memory'],[RESET[0]]))

    result={'schema':'vi.memory-future-admission-checks.v1',
        'basis_dimensions':{name:len(c['basis']) for name,c in certificates.items()},
        'growth':{name:c['strict_expansion_dimensions'] for name,c in certificates.items()},
        'executable_memory_plans':memory_plans,'streamed_continuations':stream_checks,
        'admitted_memory_operations':admissions,'one_use_channel_residual':one_use,
        'allowed_Z_common_H_commutator':noncommutator,'two_use_Xplus_probabilities':table,
        'irreversible_dephasing_pair':{'full_available_output_residual':erased_pair_error,'required_original_answers':pair_answers},
        'generated_distinguishing_probabilities':probabilities,'correlated_reference_future_residual':retained_error,
        'exact_image_cross_checks':checked_images,'QPY_witness_circuits':len(restored),'QPY_max_effect_residual':max(errors),
        'rejected_certificates':refusals,'new_QPU_jobs':0,'seconds':time.perf_counter()-start,
        'scope':'IiS19 specialization: complete Pauli terminal reading, these fixed two-qubit Clifford contacts and source controls; no acquisition of an unknown hardware model.'}
    for name,value in (('checks.json',result),('certificates.json',certificates),
                       ('interfaces.json',{name:s['description'] for name,s in specs.items()}),('QPY-witnesses.json',descriptions)):
        (OUT/name).write_text(json.dumps(value,indent=2)+'\n')
    print(json.dumps(result,indent=2))


if __name__=='__main__':run()
