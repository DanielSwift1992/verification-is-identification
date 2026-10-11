#!/usr/bin/env python3
"""Audit the physical link between a wire branch and its reported result.

Decorate the existing ideal production circuit with explicit local device
models. These models are not silently admitted by the ideal source contract.
No hardware behavior is inferred from a simulator fixture.
"""
import argparse
import io
import json
from pathlib import Path
import time

import numpy as np
from qiskit import QuantumCircuit,ClassicalRegister,qpy
from qiskit.quantum_info import Kraus
from qiskit_aer import AerSimulator
from qiskit_aer.library import save_density_matrix,set_density_matrix

import resident_measurement_wire as wire
from resident_measurement_wire_checks import I,X,Z,H,j,rz,embed
import resident_workbench as work
from environment import write,digest

P=[np.diag([1,0]),np.diag([0,1])]


def classical_report_channel(p01,p10):
    if not 0<=p01<=1 or not 0<=p10<=1:raise ValueError('Invalid reporter probabilities')
    values=[]
    for b,p in enumerate((p01,p10)):
        for y in (0,1):
            k=np.zeros((2,2));k[y,b]=np.sqrt(p if y!=b else 1-p);values.append(k)
    return Kraus(values).to_instruction()


def decorate(main,mode,probabilities=(.1,.3)):
    q=main.copy_empty_like();steps=0
    for item in main.data:
        if item.operation.name=='measure':
            incoming=main.find_bit(item.qubits[0]).index
            if mode=='memoryless':q.append(classical_report_channel(*probabilities),[incoming])
            elif mode in ('classical_retained','coherent_retained'):
                if mode=='classical_retained':q.append(Kraus(P).to_instruction(),[incoming])
                q.cx(2,incoming)
            else:raise ValueError('Unknown explicit device model')
            steps+=1
        q.append(item)
    q.metadata={'ideal_boundary':main.metadata,'device_model':mode,'measurements':steps,
        'memory_port':2 if mode!='memoryless' else None,
        'scope':'Explicit local channel model; the ideal wire source does not certify this modified device.',
        'new_QPU_jobs':0}
    return q


def frame_error_identity(source):
    maximum=0.;count=0
    for row in source['rows']:
        x,z=row['before']['x'],row['before']['z']
        incoming=np.linalg.matrix_power(X,x)@np.linalg.matrix_power(Z,z)
        for alpha in (0.,np.pi/4,.417):
            for b in (0,1):
                for y in (0,1):
                    out=row['next'][y];correction=np.linalg.matrix_power(Z,out['z'])@np.linalg.matrix_power(X,out['x'])
                    actual=correction@np.linalg.matrix_power(X,b)@j((-1)**x*alpha)@incoming
                    expected=np.linalg.matrix_power(X,b^y)@j(alpha)
                    # Acquired branches are classical; the source's scalar is
                    # retained in its own audit and irrelevant to this channel.
                    phase=np.trace(expected.conj().T@actual)/2
                    e=float(np.max(abs(actual-phase*expected)));assert e<1e-12
                    assert abs(abs(phase)-1)<1e-12;maximum=max(maximum,e);count+=1
    alpha=np.pi/4;error=j(alpha)@X@j(alpha).conj().T
    expected=np.cos(alpha)*Z-np.sin(alpha)*np.array([[0,-1j],[1j,0]])
    assert np.max(abs(error-expected))<1e-12
    overlaps=[float(abs(np.trace(p.conj().T@error)/2)**2) for p in [I,X,np.array([[0,-1j],[1j,0]]),Z]]
    assert np.max(abs(np.array(overlaps)-[0,0,.5,.5]))<1e-12
    return {'reported_branch_relations':count,'maximum_residual':maximum,
        'logical_error_at_its_occurrence':'X^(true_b xor reported_y) after J(alpha)',
        'early_error_after_next_pi_over_4_step_Pauli_overlaps':overlaps,
        'scope':'Classical true branch followed by classical report processing. Does not include coherent mixing of branches.'}


def memoryless(source,selection,n,pair,output):
    angles=[[[0,1],[1,4],[-1,3]][i%3] for i in range(n)]
    main=QuantumCircuit(4);session=wire.Wire(main,source,selection);session.append(angles);session.rectify()
    main.metadata={'boundary':session.boundary()};device=decorate(main,'memoryless',pair)
    stream=io.BytesIO();qpy.dump(device,stream);stream.seek(0);restored,=qpy.load(stream)
    assert device==restored and work.ordered_bindings(device)==work.ordered_bindings(restored)
    q=restored.copy_empty_like();rng=np.random.default_rng(100071+n)
    v=rng.normal(size=8)+1j*rng.normal(size=8);v/=np.linalg.norm(v)
    set_density_matrix(q,embed(np.outer(v,v.conj()),0))
    history=ClassicalRegister(n,'audit_reported');q.add_register(history);step=0
    for item in restored.data:
        q.append(item)
        if item.operation.name=='measure':q.store(history[step],restored.cregs[2][0]);step+=1
    save_density_matrix(q,range(4),label='state',pershot=True)
    result=AerSimulator(method='density_matrix',max_parallel_threads=1).run(q,shots=128,memory=True,seed_simulator=100171+n).result()
    assert result.success;maximum=0.;first={};initial=np.outer(v,v.conj())
    for index,text in enumerate(result.get_memory()):
        word=int(text.replace(' ',''),2);assert word&7==0
        reports=[(word>>q.find_bit(bit).index)&1 for bit in history]
        first[str(reports[0])]=first.get(str(reports[0]),0)+1;rho=initial
        for a,y in zip(angles,reports):
            value=np.zeros_like(rho);alpha=np.pi*a[0]/a[1]
            for b,p in enumerate(pair):
                probability=p if y!=b else 1-p
                k=np.kron(np.eye(4),np.linalg.matrix_power(X,b^y)@j(alpha))/np.sqrt(2)
                value+=probability*k@rho@k.conj().T
            expected_p=(1-pair[0]+pair[1])/2 if y==0 else (1+pair[0]-pair[1])/2
            assert abs(np.trace(value).real-expected_p)<1e-12
            rho=value/np.trace(value).real
        e=float(np.max(abs(result.data()['state'][index].data-embed(rho,session.owner))));assert e<1e-10;maximum=max(maximum,e)
    if n==8:
        with (output/'memoryless-device-word.qpy').open('wb') as f:qpy.dump(device,f)
    return {'steps':n,'p01':pair[0],'p10':pair[1],'uniform_logical_bit_flip_rate':sum(pair)/2,
        'first_report_counts':first,'conditional_full_states_checked':128,'maximum_joint_state_error':maximum}


def same_one_contact_channel():
    controlled=np.kron(P[0],I)+np.kron(P[1],X);a=controlled@np.kron(I,H)/np.sqrt(2)
    classical=[np.kron(P[e],np.linalg.matrix_power(X,e)@H)/np.sqrt(2) for e in (0,1)]
    maximum=0.;count=0
    def trace_m(value):return np.trace(value.reshape(2,2,2,2),axis1=0,axis2=2)
    for y in (0,1):
        for i in range(4):
            for k in range(4):
                x=np.zeros((4,4),complex);x[i,k]=1
                coherent=a@x@a.conj().T;incoherent=sum(b@x@b.conj().T for b in classical)
                e=float(np.max(abs(trace_m(coherent)-trace_m(incoherent))));assert e<1e-12
                maximum=max(maximum,e);count+=1
    return {'reported_outcome_operator_relations':count,'maximum_residual':maximum,
        'scope':'Same reduced logical-output map for each reported y and every joint logical/M input at a rectified frame; memory itself is excluded from that one-contact reading.'}


def scalar_reporter_effect():
    rng=np.random.default_rng(100307);rates=(.1,.3);alpha=.413;terms=[];error=np.zeros((2,2),complex)
    for b,p in enumerate(rates):
        for y in (0,1):
            u,_=np.linalg.qr(rng.normal(size=(2,2))+1j*rng.normal(size=(2,2)))
            probability=p if y!=b else 1-p;l=np.sqrt(probability)*u
            if b!=y:error+=l.conj().T@l/2
            terms.append(np.kron(l,np.linalg.matrix_power(X,b^y)@j(alpha))/np.sqrt(2))
    p=sum(rates)/2;assert np.max(abs(error-p*I))<1e-12
    assert np.max(abs(sum(k.conj().T@k for k in terms)-np.eye(4)))<1e-12
    def trace_m(value):return np.trace(value.reshape(2,2,2,2),axis1=0,axis2=2)
    maximum=0.
    for a in range(4):
        for b in range(4):
            rho=np.zeros((4,4),complex);rho[a,b]=1
            actual=trace_m(sum(k@rho@k.conj().T for k in terms));before=trace_m(rho)
            v=j(alpha)@before@j(alpha).conj().T;expected=(1-p)*v+p*X@v@X
            e=float(np.max(abs(actual-expected)));assert e<1e-12;maximum=max(maximum,e)
    return {'scalar_error_effect':p,'unknown_conditional_memory_unitaries':4,
        'correlated_input_operator_units':16,'maximum_residual':maximum,
        'scope':'A scalar aggregate error effect gives the same reduced logical channel even when the reporter changes and retains quantum memory.'}


def reopen_memory(source,selection,mode,output):
    main=QuantumCircuit(4);s=wire.Wire(main,source,selection);s.append([[0,1]]);s.rectify()
    main.h(2);s.append([[0,1]]);s.rectify();main.metadata={'boundary':s.boundary(),'intervening_memory_action':'H_M'}
    device=decorate(main,mode);q=device.copy_empty_like();q.h(2)
    for item in device.data:q.append(item)
    save_density_matrix(q,range(4),label='state',pershot=True)
    r=AerSimulator(method='density_matrix',max_parallel_threads=1).run(q,shots=64,memory=True,seed_simulator=100291).result()
    assert r.success
    expected=np.zeros((16,16),complex)
    if mode=='coherent_retained':expected[0,0]=1
    else:expected[0,0]=expected[5,5]=.5
    maximum=0.
    for state in r.data()['state']:
        e=float(np.max(abs(state.data-expected)));assert e<1e-12;maximum=max(maximum,e)
    zd=np.diag([(-1)**(i&1) for i in range(16)]);expectation=float(np.trace(zd@expected).real)
    with (output/(mode+'-reopen.qpy')).open('wb') as f:qpy.dump(device,f)
    return {'model':mode,'logical_Z_after_two_contacts':expectation,'full_states_checked':64,
        'maximum_joint_state_error':maximum,'scope':'Same current reduced instrument; different retained memory permits a different future quantum answer.'}


def counts_do_not_calibrate():
    rows=[]
    for p in (0.,.2,1.):
        histories=[sum((p if y!=b else 1-p)/2 for b in (0,1)) for y in (0,1)]
        assert histories==[.5,.5]
        rows.append({'p01':p,'p10':p,'reported_distribution':histories,
            'logical_process_fidelity_to_J':1-p})
    return rows


def run(output):
    start=time.perf_counter();output.mkdir(parents=True,exist_ok=True)
    prior=wire.goal.ROOT/'Research/Artifacts/resident-measurement-wire-20260915'
    source=json.loads((prior/'wire-reading.json').read_text());selection=json.loads((prior/'plan.json').read_text())
    wire.lowering(source,selection)
    rows=[memoryless(source,selection,n,(.1,.3),output) for n in (1,2,3,8)]
    result={'source':wire.admission.fingerprint(source),'frame_error_identity':frame_error_identity(source),
        'memoryless_SDK':rows,'identical_records_different_logical_quality':counts_do_not_calibrate(),
        'same_one_contact_channel':same_one_contact_channel(),
        'scalar_reporter_effect':scalar_reporter_effect(),
        'memory_reopening':[reopen_memory(source,selection,m,output) for m in ('classical_retained','coherent_retained')],
        'full_conditional_states_checked':sum(r['conditional_full_states_checked'] for r in rows)+128,
        'maximum_memoryless_residual':max(r['maximum_joint_state_error'] for r in rows),
        'seconds':time.perf_counter()-start,'new_QPU_jobs':0,'source_contract_automatically_admits_noise':False,
        'implementation_sha256':digest(Path(__file__))}
    write(output/'audit.json',result);return result


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    r=run(p.parse_args().output.resolve());print(json.dumps({k:r[k] for k in ['full_conditional_states_checked','maximum_memoryless_residual','seconds']}))
