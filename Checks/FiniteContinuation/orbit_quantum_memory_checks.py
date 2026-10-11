#!/usr/bin/env python3
"""Unknown commuting memory, correlated input, and a fixed-law counterfamily."""
from itertools import product
import json
import time

import numpy as np
from qiskit import QuantumCircuit,ClassicalRegister,qpy
from qiskit.circuit.library import UnitaryGate
from qiskit.quantum_info import Operator

import orbit_return as o
import orbit_future as f
import orbit_live_upgrade as u
import orbit_live_upgrade_checks as old
import orbit_quantum_memory as memory

OUT=o.ROOT/'Research/Artifacts/returning-attempt-20260916/quantum-memory'


def random_device(m,dimension,seed):
    rng=np.random.default_rng(seed);bases={}
    for a in set(m['q']):
        matrix=rng.normal(size=(dimension,dimension))+1j*rng.normal(size=(dimension,dimension))
        bases[a]=np.linalg.qr(matrix)[0]
    angles=rng.uniform(-2,2,(len(m['q']),dimension))
    return memory.CommutingMemoryDevice(m,bases,angles)


def raw_circuit(device):
    assert device.dimension==2
    q=QuantumCircuit(9);record=ClassicalRegister(1,'retained_answer');q.add_register(record)
    joint=np.zeros((16,16),complex)
    for s in range(8):
        for a in range(2):
            for b in range(2):joint[s+8*a,s+8*b]=device._actions[s][a,b]
    def oracle():
        q.append(UnitaryGate(joint,label='same_source_memory_contact'),[0,1,2,8]);q.cx(1,3);q.cx(2,4);q.cx(1,4)
    def tick(k):
        for _ in range(k):q.cx(0,1);q.x(0)
    oracle();q.cx(3,5);q.cx(4,5);tick(2);oracle();tick(2)
    q.x(3);q.x(4);q.measure(5,record[0]);q.barrier(label='correlated_memory_is_retained')
    q.h(1);q.h(6);q.cz(2,6);q.cz(5,6);q.s(7);q.cz(2,7);q.cz(5,7)
    tick(1);oracle();tick(2);oracle();tick(1);q.x(3);q.x(4)
    return q


def independent_branches(q):
    initial=np.zeros((512,64),complex)
    for env,d2,d1,s in product(range(2),range(2),range(2),range(8)):
        initial[s+64*d1+128*d2+256*env,s+8*d1+16*d2+32*env]=1
    rows={None:initial};segment=QuantumCircuit(9);reads=0
    def flush():
        nonlocal rows,segment
        if segment.data:
            matrix=Operator(segment).data;rows={a:matrix@k for a,k in rows.items()};segment=QuantumCircuit(9)
    for instruction in q.data:
        gate=instruction.operation;wires=[q.find_bit(x).index for x in instruction.qubits]
        if gate.name=='barrier':continue
        if gate.name=='measure':
            assert wires==[5] and reads==0;reads+=1;flush();matrix=rows.pop(None)
            for a in (0,1):
                branch=matrix.copy()
                for r in range(512):
                    if (r>>5)&1!=a:branch[r]=0
                rows[a]=branch
        else:segment.append(gate,wires)
    flush();assert reads==1
    result={}
    for a,branch in rows.items():
        indices=[s+32*a+64*d1+128*d2+256*env for env,d2,d1,s in product(range(2),range(2),range(2),range(8))]
        allowed=set(indices)
        assert max(float(np.max(abs(branch[i]))) for i in range(512) if i not in allowed)<1e-12
        result[a]=branch[indices,:]
    return result


def evaluate_density(maps,rho):return sum(k@rho@k.conj().T for k in maps.values())


def run():
    start=time.perf_counter();OUT.mkdir(parents=True,exist_ok=True)
    source=o.read_source();m=memory.memory_model(source);checks=[];plans=[];first=None
    for dimension in (1,2,3,4):
        device=random_device(m,dimension,916+dimension);live=memory.MemoryOrbit(m,device)
        prefix=live.start([f.pauli('IXI')]);boundary=live.boundary()
        live.source_action('H_B');live.work(old.H,0);live.work(old.S,1)
        extension=live.upgrade(boundary,[f.pauli('IIX')]);actual=live.audit_maps();wanted=live.audit_common_memory_target()
        error=max(float(np.max(abs(actual[a]-wanted[a]))) for a in actual)
        complete=float(np.max(abs(sum(k.conj().T@k for k in actual.values())-np.eye(live.input_dim))))
        assert error<1e-12 and complete<1e-12
        rng=np.random.default_rng(519+dimension)
        vectors=rng.normal(size=(live.input_dim,3))+1j*rng.normal(size=(live.input_dim,3))
        rho=vectors@vectors.conj().T;rho/=np.trace(rho)
        reduced=memory.trace_memory(rho,dimension);ideal=live._ideal[:32,:32];partial_error=0.
        for a,k in actual.items():
            p=np.kron(np.eye(4),np.diag([int(x==a) for x in m['q']]))
            target=p@ideal@reduced@ideal.conj().T@p
            partial_error=max(partial_error,float(np.max(abs(memory.trace_memory(k@rho@k.conj().T,dimension)-target))))
        assert partial_error<1e-12
        within=max(float(np.max(abs(device._actions[s]@device._actions[t]-device._actions[t]@device._actions[s])))
                   for s in range(8) for t in range(8) if m['q'][s]==m['q'][t])
        across=max(float(np.max(abs(device._actions[s]@device._actions[t]-device._actions[t]@device._actions[s])))
                   for s in range(8) for t in range(8) if m['q'][s]!=m['q'][t])
        # The discarded common memory motion commutes with every generator of
        # the declared future, not merely with the final output measurement.
        common=np.zeros((8*dimension,8*dimension),complex)
        query=np.zeros_like(common)
        for cycle in f.cyclic_model(m)[0]:
            ua=device.audit_word(cycle)
            for s in cycle:
                for i,j in product(range(dimension),repeat=2):
                    common[s+8*i,s+8*j]=ua[i,j]
                    query[s+8*i,s+8*j]=device._actions[s][i,j]
        t_matrix=np.zeros((8,8));t_matrix[m['permutations']['T'],np.arange(8)]=1
        generators=[query,np.kron(np.eye(dimension),t_matrix)]+[
            np.kron(np.eye(dimension),matrix) for matrix in f.CONTROLS.values()]
        future_error=max(float(np.max(abs(common@g-g@common))) for g in generators)
        assert future_error<1e-12
        checks.append({'dimension':dimension,'full_input_dimension':live.input_dim,'joint_operator_residual':error,
                       'completeness_residual':complete,'initially_correlated_reduced_instrument_residual':partial_error,
                       'within_fiber_commutator':within,'across_fiber_commutator':across,
                       'discarded_motion_future_commutator':future_error})
        plans.append({'prefix':prefix['powers'],'extension':extension['certificate']['program']})
        assert (live.V_calls,live.T_calls,live.copy_calls,live.read_calls)==(4,8,1,1)
        if dimension==2:first=(device,actual)
    assert all(p==plans[0] for p in plans)
    assert max(x['across_fiber_commutator'] for x in checks)>.1

    q=raw_circuit(first[0])
    with (OUT/'ActualPersistentMemory.qpy').open('wb') as handle:qpy.dump(q,handle)
    with (OUT/'ActualPersistentMemory.qpy').open('rb') as handle:restored=qpy.load(handle)[0]
    independent=independent_branches(restored)
    qpy_error=max(float(np.max(abs(independent[a]-first[1][a]))) for a in independent)
    assert qpy_error<1e-12

    # A memory that stores the C sign relationally during the short prefix:
    # U_0=X, all other U_s=I. It commutes, yet E is genuinely quantum and the
    # prefix reduced S outputs for +/- are exactly the same.
    angles=np.zeros((8,2));angles[0,1]=np.pi
    echo_device=memory.CommutingMemoryDevice(m,{0:old.H,1:old.H},angles)
    echo=memory.MemoryOrbit(m,echo_device);echo.start([f.pauli('IXI')]);prefix=echo.audit_maps()
    states=[]
    for sign in (1,-1):
        state=np.zeros(64,complex);state[0]=1/np.sqrt(2);state[1]=sign/np.sqrt(2)
        states.append(np.outer(state,state.conj()))
    prefix_states=[evaluate_density(prefix,rho) for rho in states]
    reduced_prefix=[memory.trace_memory(rho,2) for rho in prefix_states]
    assert np.max(abs(reduced_prefix[0]-reduced_prefix[1]))<1e-12
    echo.upgrade(echo.boundary(),[f.pauli('IIX')]);final=echo.audit_maps()
    outputs=[memory.trace_memory(evaluate_density(final,rho),2) for rho in states]
    x_c=np.kron(np.eye(4),f.pauli('IIX'));effect=(np.eye(32)+x_c)/2
    probabilities=[float(np.trace(effect@rho).real) for rho in outputs]
    assert np.max(abs(np.array(probabilities)-[1,0]))<1e-12
    final_plus=evaluate_density(final,states[0])
    # Trace data/source: common device action is X, so memory has NOT returned.
    memory_state=np.trace(final_plus.reshape(2,32,2,32),axis1=1,axis2=3)
    assert np.max(abs(memory_state-np.diag([0,1])))<1e-12
    # Replace only E by |0> after the prefix: the available S inputs then agree.
    # Apply the actual known suffix on S,E; no new acquisition of the lost sign.
    suffix=np.zeros((64,64),complex)
    cycles,_=f.cyclic_model(m)
    for cycle in cycles:
        for z,s in enumerate(cycle):
            action=echo_device.audit_word([cycle[(z+1)%4],cycle[(z+3)%4]])
            for data in range(4):
                for i,j in product(range(2),repeat=2):suffix[s+8*data+32*i,s+8*data+32*j]=action[i,j]
    reset_outputs=[]
    for reduced in reduced_prefix:
        reset=np.kron(np.diag([1,0]),reduced)
        reset_outputs.append(memory.trace_memory(suffix@reset@suffix.conj().T,2))
    reset_probabilities=[float(np.trace(effect@rho).real) for rho in reset_outputs]
    assert np.max(abs(np.array(reset_probabilities)-[.5,.5]))<1e-12

    # Once a new H_E access is admitted, the old common motion X_E is no longer
    # invisible. Following H_E by the same V distinguishes the two E states.
    # For this input s=0,1 have F=0, so W is ready without a new cleanup.
    control=np.zeros((64,64),complex)
    for s,d,i,j in product(range(8),range(4),range(2),range(2)):
        control[s+8*d+32*i,s+8*d+32*j]=echo_device._actions[s][i,j]
    cplus=np.zeros(32,complex);cplus[0]=cplus[1]=1/np.sqrt(2)
    new_access_probabilities=[]
    for e in (0,1):
        basis=np.eye(2)[:,e];v=np.kron(old.H@basis,cplus);after=control@v
        new_access_probabilities.append(float(np.vdot(after,np.kron(np.eye(2),effect)@after).real))
    assert np.max(abs(np.array(new_access_probabilities)-[1,0]))<1e-12

    # General finite-word obstruction with one STATIC reversible memory law.
    # For each budget choose memory size n*(L+1); never reinterpret this as a
    # fixed small device that defeats all arbitrarily long programs.
    witnesses=[]
    for length in range(1,17):
        # Actual words return S: the final power supplies the remaining rotation.
        powers=[(j*j+1)%4 for j in range(length-1)]
        powers.append((-sum(powers))%4)
        pm=f.powered_model(m);info=o.analyse(pm,[f'T{k}' for k in powers])
        witness=memory.retained_first_labels(info['paths'])
        assert info['final_source']==list(range(8))
        assert len(set(witness['final_memory_states']))==8
        assert witness['final_memory_states']==[8*length+s for s in range(8)]
        witnesses.append(dict(witness,powers=powers))
    # On the actual completed four-visit word, W is also cleanable and q is
    # correct. Orthogonal E labels erase every within-fiber source coherence.
    full=f.optimal(m,[f.pauli('IXI'),f.pauli('IIX')]);info=full['computed']
    obstructed=memory.retained_first_labels(info['paths'])
    assert info['work_before_cleanup']==[0]*8 and len(set(obstructed['final_memory_states']))==8
    # Actual isometry from the source to source+internal memory on q=0.
    dim=obstructed['memory_dimension'];isometry=np.zeros((8*dim,8),complex)
    for s,e in enumerate(obstructed['final_memory_states']):isometry[s+8*e,s]=1
    v=np.zeros(8,complex);v[0]=v[1]=1/np.sqrt(2)
    lost=memory.trace_memory(isometry@np.outer(v,v)@isometry.conj().T,dim)
    contrast=float(np.trace(f.pauli('IIX')@lost).real);assert abs(contrast)<1e-12

    result={'schema':'vi.persistent-commuting-quantum-memory.v1','model':m,
            'commuting_device_checks':checks,'same_controller_program_for_all_memory_dimensions':True,
            'controller_program':plans[0],'independent_QPY_residual':qpy_error,
            'record_reads':1,'copy_count':1,'joint_V_calls':4,'forward_T_calls':8,
            'preserved_memory_relation':{'prefix_reduced_plus_minus_residual':float(np.max(abs(reduced_prefix[0]-reduced_prefix[1]))),
                'same_memory_Cplus_probabilities':probabilities,'replaced_memory_Cplus_probabilities':reset_probabilities,
                'final_internal_memory':[[float(x.real) for x in row] for row in memory_state],
                'new_H_on_internal_memory_then_query_probabilities':new_access_probabilities},
            'unrestricted_memory_obstruction':{'finite_budgets_checked':len(witnesses),
                'full_word_memory_dimension':dim,'full_word_XC_expectation':contrast,
                'scope':'For every fixed positive finite V/T word there exists a finite static reversible memory retaining its first source label. No common memory-dimension bound.'},
            'new_QPU_jobs':0,'seconds':time.perf_counter()-start,
            'scope':'Within-fiber commuting persistent memory; arbitrary initial correlations. Internal E may change and is not an untouched reference or promised later output.'}
    for name,data in [('checks.json',result),('model.json',m),('counterfamily.json',witnesses)]:
        (OUT/name).write_text(json.dumps(data,indent=2)+'\n')
    print(json.dumps({k:result[k] for k in ['commuting_device_checks','independent_QPY_residual','preserved_memory_relation','unrestricted_memory_obstruction','seconds']},indent=2))


if __name__=='__main__':run()
