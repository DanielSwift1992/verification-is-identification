#!/usr/bin/env python3
"""A common physical word across coherent invariant sectors, and its limits."""
from copy import deepcopy
from itertools import product
import json
import time

import numpy as np
from qiskit import QuantumCircuit, ClassicalRegister, qpy
from qiskit.circuit.library import UnitaryGate
from qiskit.quantum_info import Operator

import orbit_return as o
import orbit_future as f
import orbit_live_upgrade_checks as old
import orbit_quantum_memory as memory
import orbit_quantum_memory_checks as memory_checks
import orbit_reflection_return_checks as reflection_checks
import orbit_invariant_sectors as sectors

OUT=o.ROOT/'Research/Artifacts/returning-attempt-20260916/invariant-sectors'


def make_device(m,left_dim,right_dim,seed):
    left=memory_checks.random_device(m['components']['commuting'],left_dim,seed)
    right=reflection_checks.make_device(m['components']['reflection'],right_dim,seed+1)[0]
    rng=np.random.default_rng(seed+2);dim=left_dim+right_dim
    basis=np.linalg.qr(rng.normal(size=(dim,dim))+1j*rng.normal(size=(dim,dim)))[0]
    return sectors.InvariantSectorDevice(m,left,right,basis)


def raw_circuit(device,plan):
    assert device.dimension==4
    q=QuantumCircuit(10);record=ClassicalRegister(1,'acquired_answer');q.add_register(record)
    joint=np.zeros((32,32),complex)
    for s,i,j in product(range(8),range(4),range(4)):
        joint[s+8*i,s+8*j]=device._actions[s][i,j]
    for index,k in enumerate(plan['powers']):
        q.append(UnitaryGate(joint,label='fixed_invariant_sector_contact'),[0,1,2,8,9])
        q.cx(1,3);q.cx(2,4);q.cx(1,4)
        if index==0:q.cx(3,5);q.cx(4,5)
        for _ in range(k):q.cx(0,1);q.x(0)
    q.measure(5,record[0]);q.barrier(label='same_unread_memory_continues')
    q.h(1);q.h(6);q.cz(2,6);q.cz(5,6);q.s(7);q.cz(2,7);q.cz(5,7)
    return q


def independent_branches(q):
    """Read the serialized SDK gates; no SectorOrbit methods or sector proof."""
    assert q.num_qubits==10
    size=1<<10;input_dim=128
    initial=np.zeros((size,input_dim),complex)
    for env,d2,d1,s in product(range(4),range(2),range(2),range(8)):
        initial[s+64*d1+128*d2+256*env,s+8*d1+16*d2+32*env]=1
    rows={None:initial};segment=QuantumCircuit(10);reads=0
    def flush():
        nonlocal rows,segment
        if segment.data:
            matrix=Operator(segment).data
            rows={a:matrix@k for a,k in rows.items()};segment=QuantumCircuit(10)
    for instruction in q.data:
        gate=instruction.operation;wires=[q.find_bit(x).index for x in instruction.qubits]
        if gate.name=='barrier':continue
        if gate.name=='measure':
            assert wires==[5] and reads==0;reads+=1;flush();matrix=rows.pop(None)
            for a in (0,1):
                branch=matrix.copy();branch[((np.arange(size)>>5)&1)!=a]=0;rows[a]=branch
        else:segment.append(gate,wires)
    flush();assert reads==1
    result={}
    for a,branch in rows.items():
        indices=[s+32*a+64*d1+128*d2+256*env
                 for env,d2,d1,s in product(range(4),range(2),range(2),range(8))]
        excluded=np.ones(size,bool);excluded[indices]=False
        assert np.max(abs(branch[excluded]))<1e-12
        result[a]=branch[indices,:]
    return result


def word_maps(m,actions,powers):
    """Direct audit of a fixed raw controlled device, including actual q read.

    This is NOT an admissible SectorOrbit port. It permits testing a fixed-law
    counterexample outside the invariant-sector constructor without certifying it.
    """
    _,info=f.word_data(m,powers);dim=actions[0].shape[0];n=len(m['q']);result={}
    assert info['final_source']==list(range(n))
    for a in set(m['q']):
        matrix=np.zeros((n*dim,n*dim),complex)
        for s,path in enumerate(info['paths']):
            if m['q'][s]!=a:continue
            motion=np.eye(dim,dtype=complex)
            for t in path:motion=actions[t]@motion
            for i,j in product(range(dim),repeat=2):matrix[s+n*i,s+n*j]=motion[i,j]
        result[a]=matrix
    return result


def run():
    started=time.perf_counter();OUT.mkdir(parents=True,exist_ok=True)
    source=o.read_source();m=sectors.model(source);plan=sectors.common_plan(m);cases=[];sdk=None
    for left_dim,right_dim,seed in ((2,2,717),(2,3,718),(3,2,719)):
        device=make_device(m,left_dim,right_dim,seed);dim=device.dimension
        live=sectors.SectorOrbit(m,device);actual_plan=live.start_for();assert actual_plan==plan
        initial_maps=live.audit_maps();initial_target=live.audit_common_target()
        initial_error=max(float(np.max(abs(initial_maps[a]-initial_target[a]))) for a in initial_maps)
        live.source_action('H_B');live.work(old.H,0);live.work(old.S,1)
        actual=live.audit_maps();target=live.audit_common_target()
        error=max(float(np.max(abs(actual[a]-target[a]))) for a in actual)
        complete=float(np.max(abs(sum(k.conj().T@k for k in actual.values())-np.eye(live.input_dim))))
        assert max(initial_error,error,complete)<1e-12
        assert (live.V_calls,live.T_calls,live.copy_calls,live.read_calls)==(8,4,1,1)
        assert live.can_read([f.pauli('IXI'),f.pauli('IIX')])
        boundary=live.boundary();reused=live.upgrade(boundary,[f.pauli('IIX')])
        assert reused=={'kind':'reuse','additional_V':0,'additional_T':0}

        # Explicit correlated input, including an untouched external R. E is
        # highest, followed by data/source, then R. No sector projection occurs.
        rng=np.random.default_rng(seed+100);r_dim=2
        v=rng.normal(size=(live.input_dim*r_dim,3))+1j*rng.normal(size=(live.input_dim*r_dim,3))
        rho=v@v.conj().T;rho/=np.trace(rho)
        reduced=memory.trace_memory(rho,dim)
        ideal=np.kron(live._ideal[:32,:32],np.eye(r_dim));partial_error=0.
        for a,k in actual.items():
            kk=np.kron(k,np.eye(r_dim))
            p=np.kron(np.kron(np.eye(4),np.diag([int(q==a) for q in m['q']])),np.eye(r_dim))
            wanted=p@ideal@reduced@ideal.conj().T@p
            partial_error=max(partial_error,float(np.max(abs(memory.trace_memory(kk@rho@kk.conj().T,dim)-wanted))))
        assert partial_error<1e-12
        sector=np.kron(device.audit_sector_projector(),np.eye(64))
        cross_norm=float(np.linalg.norm(sector@rho@(np.eye(len(rho))-sector)))
        assert cross_norm>.05

        within=max(float(np.max(abs(device._actions[s]@device._actions[t]-device._actions[t]@device._actions[s])))
                   for cycle in f.cyclic_model(m)[0] for s in cycle for t in cycle)
        nonscalar=max(float(np.max(abs(u@u-np.trace(u@u)/dim*np.eye(dim)))) for u in device._actions)
        assert within>.1 and nonscalar>.1
        invariant=max(float(np.max(abs(device.audit_sector_projector()@u-u@device.audit_sector_projector())))
                      for u in device._actions)
        common=np.zeros((8*dim,8*dim),complex);query=np.zeros_like(common)
        for cycle in f.cyclic_model(m)[0]:
            ua=device.audit_common(cycle)
            for s,i,j in product(cycle,range(dim),range(dim)):
                common[s+8*i,s+8*j]=ua[i,j];query[s+8*i,s+8*j]=device._actions[s][i,j]
        t_matrix=np.zeros((8,8));t_matrix[m['permutations']['T'],np.arange(8)]=1
        generators=[query,np.kron(np.eye(dim),t_matrix)]+[
            np.kron(np.eye(dim),matrix) for matrix in f.CONTROLS.values()]
        future_error=max(float(np.max(abs(common@g-g@common))) for g in generators)
        assert max(invariant,future_error)<1e-12
        cases.append({'sector_dimensions':[left_dim,right_dim],'input_dimension':live.input_dim,
            'joint_operator_residual':error,'initial_acquisition_residual':initial_error,
            'completeness_residual':complete,'correlated_external_reference_residual':partial_error,
            'initial_cross_sector_coherence_norm':cross_norm,'sector_invariance_residual':invariant,
            'common_motion_future_commutator':future_error,
            'whole_device_noncommutation':within,'whole_device_nonscalar_square':nonscalar})
        if dim==4:sdk=(device,actual)

    q=raw_circuit(sdk[0],plan);qpy_path=OUT/'ActualInvariantSectorWord.qpy'
    with qpy_path.open('wb') as handle:qpy.dump(q,handle)
    with qpy_path.open('rb') as handle:restored=qpy.load(handle)[0]
    independent=independent_branches(restored)
    qpy_error=max(float(np.max(abs(independent[a]-sdk[1][a]))) for a in independent)
    assert qpy_error<1e-12

    # Every contact is fixed, but S_swap J_s exchanges the two proposed sectors.
    # Paired squares then carry R_s in BOTH blocks: ordered products do not cancel.
    x=np.array([[0,1],[1,0]],complex);z=np.diag([1,-1]);identity=np.eye(2)
    values=[x,z,identity,identity]*2
    invariant=[sectors.block_sum(identity,r) for r in values]
    swap=sectors.block_sum(np.zeros((2,2)),np.zeros((2,2)))
    swap[:2,2:]=identity;swap[2:,:2]=identity
    mixed=[swap@u for u in invariant]
    cplus=np.zeros(8,complex);cplus[0]=cplus[1]=1/np.sqrt(2)
    input_state=np.kron(np.eye(4)[:,0],cplus)
    effect=np.kron(np.eye(4),(np.eye(8)+f.pauli('IIX'))/2)
    probabilities=[]
    for actions,powers in ((invariant,plan['powers']),(mixed,plan['powers']),(mixed,[0]*4)):
        output=sum(np.outer(k@input_state,(k@input_state).conj()) for k in word_maps(m,actions,powers).values())
        probabilities.append(float(np.trace(effect@output).real))
    assert np.max(abs(np.array(probabilities)-[1,0,1]))<1e-12
    # Four consecutive calls restore the entire input for this DIFFERENT,
    # sector-exchanging exact-reflection construction, not just the chosen state.
    repaired=word_maps(m,mixed,[0]*4)
    repair_error=max(float(np.max(abs(k-np.kron(np.eye(4),np.diag([int(q==a) for q in m['q']])))))
                     for a,k in repaired.items())
    assert repair_error<1e-12
    sector_failure=max(float(np.max(abs(u@np.diag([1,1,0,0])-np.diag([1,1,0,0])@u))) for u in mixed)
    assert sector_failure==1

    whole_examples=[]
    for length in (2,4,8):
        device,state=sectors.whole_memory_counterexample(m,length)
        assert all(np.max(abs(u-device._actions[0]))<1e-12 for u in device._actions)
        after=np.linalg.matrix_power(device._actions[0],length)@state
        probability=float(abs(np.vdot(state,after))**2);assert probability<1e-12
        whole_examples.append({'positive_V_calls':length,'initial_memory_return_probability':probability})

    rejected=[]
    def reject(name,fn):
        try:fn()
        except (ValueError,AssertionError,KeyError):rejected.append(name)
        else:raise AssertionError('Accepted '+name)
    fresh=sectors.SectorOrbit(m,sdk[0])
    before={a:k.copy() for a,k in fresh._branches.items()}
    refusal=fresh.start_for('whole_initial_memory')
    assert refusal['kind']=='no_uniform_positive_word' and fresh.V_calls==fresh.read_calls==0
    assert all(np.array_equal(before[a],k) for a,k in fresh._branches.items())
    reject('guess a component through inherited start',lambda:fresh.start([f.pauli('IXI')]))
    bad=deepcopy(m);bad['components']['commuting']['f'][0]^=1
    reject('components from different source contracts',lambda:sectors.common_plan(bad))
    bad=deepcopy(plan);bad['model']='old root'
    reject('old root used for the new application',lambda:sectors.verify(m,bad))
    bad=deepcopy(plan);bad['goal']='whole_initial_memory'
    reject('component E-return promoted to composite E-return',lambda:sectors.verify(m,bad))
    bad=deepcopy(plan);bad['reflection_interpretation']['powers']=[0]*8
    reject('different words used in the two component proofs',lambda:sectors.verify(m,bad))
    wrong=memory.CommutingMemoryDevice(m,{a:np.eye(4) for a in set(m['q'])},np.zeros((8,4)))
    reject('same label without producing construction',lambda:sectors.SectorOrbit(m,wrong))
    fresh.start_for()
    reject('new acquisition replacing the retained carrier',lambda:fresh.start_for())
    reject('commuting audit substituted for composite target',lambda:fresh.audit_common_memory_target())
    # A private raw contact can leave an ordered residual; the public upgrade
    # must not quietly switch to the old commuting completion theorem.
    fresh._probe();fresh._probe();fresh._clean({'0':0,'1':0})
    residual_boundary=fresh.boundary()
    reject('count-only repair of a noncommuting residual',
           lambda:fresh.upgrade(residual_boundary,[f.pauli('IIX')]))

    # Reuse the frozen actual ordered-address/count obligations; no regeneration
    # of old court files and no claim that a type equality establishes physics.
    frozen=o.ROOT/'Research/Artifacts/returning-attempt-20260916/reflection-memory'
    prior=json.loads((frozen/'court-input.json').read_text())
    assert prior['source']==source
    assert prior['plans']['projective_involution']==plan['reflection_interpretation']
    reuse={'frozen_manifest':str((frozen/'manifest.json').relative_to(o.ROOT)),
           'same_actual_source':True,'same_ordered_word_and_reflection_obligations':True,
           'commuting_sector_counts':plan['computed']['visits'],
           'scope':'Address/count proof reuse; not whole-E return for the composite, not a physical device certificate.'}
    result={'schema':'vi.invariant-sector-common-word-checks.v1','device_cases':cases,
        'independent_QPY_residual':qpy_error,'joint_V_calls':8,'forward_T_calls':4,'q_copies':1,'q_reads':1,
        'fixed_sector_exchange_counterexample':{'Cplus_probabilities_invariant_mixed_repaired':probabilities,
            'sector_commutator':sector_failure,'four_V_whole_input_repair_residual':repair_error},
        'whole_initial_memory_obstructions':whole_examples,'whole_memory_refusal_without_action':refusal,
        'rejected_applications':rejected,'seconds':time.perf_counter()-started,'new_QPU_jobs':0}
    for name,value in (('checks.json',result),('model.json',m),('plan.json',plan),('proof-reuse.json',reuse)):
        (OUT/name).write_text(json.dumps(value,indent=2)+'\n')
    print(json.dumps(result,indent=2))


if __name__=='__main__':run()
