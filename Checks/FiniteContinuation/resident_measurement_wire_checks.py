#!/usr/bin/env python3
"""Independent quantum-output checks for a wire driven by actual measurements."""
import argparse
from copy import deepcopy
import io
from itertools import product
import json
import math
from pathlib import Path
import time

import numpy as np
from qiskit import QuantumCircuit,ClassicalRegister,qpy
from qiskit.quantum_info import Operator
from qiskit_aer import AerSimulator
from qiskit_aer.library import save_density_matrix

import resident_measurement_wire as wire
import resident_workbench as work
from environment import write,digest

I=np.eye(2);X=np.array([[0,1],[1,0]]);Z=np.diag([1,-1]);H=np.array([[1,1],[1,-1]])/np.sqrt(2)


def rz(a):return np.diag([np.exp(-.5j*a),np.exp(.5j*a)])
def j(a):return H@rz(a)
def f(row):
    return (1j**row['phase']*np.linalg.matrix_power(X,row['x'])
            @np.linalg.matrix_power(Z,row['z']))
def radians(pair):return math.pi*pair[0]/pair[1]


def physical_kraus(alpha,b):
    # Build from entanglement, actual input-axis rotation and measurement.
    # Matrix convention: incoming logical qubit is low, new carrier high.
    q=QuantumCircuit(2);q.cz(0,1);q.rz(alpha,0);q.h(0);u=Operator(q).data
    prepare=np.zeros((4,2),complex)
    for x in range(2):
        for a in range(2):prepare[x+2*a,x]=1/np.sqrt(2)
    return (u@prepare)[[b,b+2],:]


def exact_branches(source):
    maximum=0.;checked=0
    for row in source['rows']:
        before=f(row['before'])
        for alpha in (0.,math.pi/4,-math.pi/3,.317):
            for b in (0,1):
                k=physical_kraus((-1)**row['negate']*alpha,b)
                left=k@before;right=f(row['next'][b])@j(alpha)/np.sqrt(2)
                e=float(np.max(abs(left-right)));assert e<1e-12;maximum=max(maximum,e);checked+=1
                assert np.max(abs(k.conj().T@k-I/2))<1e-12
    # Check complete paths with retained exact scalar phases as well as words.
    lookup={tuple(r['before'][n] for n in ('phase','x','z')):r for r in source['rows']}
    lengths=[1,2,3,8];paths=0
    for n in lengths:
        angles=[(math.pi/4,-math.pi/3,math.pi/5)[i%3] for i in range(n)];u=I.astype(complex)
        for a in angles:u=j(a)@u
        for replies in product((0,1),repeat=n):
            row=source['initial'];k=I.astype(complex)
            for a,b in zip(angles,replies):
                current=lookup[tuple(row[n] for n in ('phase','x','z'))]
                k=physical_kraus((-1)**current['negate']*a,b)@k;row=current['next'][b]
            e=float(np.max(abs(k-f(row)@u/np.sqrt(2**n))));assert e<1e-12;maximum=max(maximum,e);paths+=1
    return {'one_step_exact_operator_relations':checked,'complete_histories':paths,
        'maximum_residual':maximum,'each_reply_probability':.5,
        'scope':'Kraus operators, including probability and exact scalar; the analytic identity holds for every real angle.'}


def memory_boundary(source,selection):
    cert=selection['certificate'];assert len(cert['quotient']['observation'])==4
    weak=wire.model(source);weak['observation']=[r['before']['x'] for r in source['rows']]
    c=wire.goal.saturate.synthesize(weak);wire.goal.saturate.verify(weak,c)
    assert len(c['quotient']['observation'])==4
    # Four channel frames are pairwise distinguishable with a Bell reference.
    bell=np.array([1,0,0,1])/np.sqrt(2)
    states=[np.kron(I,p)@bell for p in [I,Z,X,X@Z]]
    gram=np.array([[np.vdot(a,b) for b in states] for a in states]);assert np.max(abs(gram-np.eye(4)))<1e-12
    return {'exact_phase_label_states':16,'density_output_frame_classes':4,
        'angle_sign_only_initial_classes':2,'closed_angle_sign_classes':4,
        'pairwise_Pauli_Choi_overlap':abs(gram).tolist(),
        'scope':'Minimum classical distinctions with the current physical carrier and arbitrary subsequent logical-state questions. Program text and physical-owner schedule are separate resources.'}


def embed(rho,owner):
    indices=[((i&1)<<owner)|(((i>>1)&1)<<2)|(((i>>2)&1)<<3) for i in range(8)]
    result=np.zeros((16,16),complex);result[np.ix_(indices,indices)]=rho
    return result


def production(source,selection,n,rectify_middle=False):
    q=QuantumCircuit(4);session=wire.Wire(q,source,selection)
    angles=[[[1,4],[-1,3],[1,5]][i%3] for i in range(n)]
    split=max(1,n//2);marks=[]
    session.append(angles[:split]);marks.append((len(q.data),session.boundary()))
    if rectify_middle:
        session.rectify();marks.append((len(q.data),session.boundary()))
    if split<n:
        session.append(angles[split:]);marks.append((len(q.data),session.boundary()))
    session.rectify();marks.append((len(q.data),session.boundary()))
    q.metadata={'boundary':session.boundary(),'model':'Measurement-driven J(alpha) word; arbitrary logical input and E/reference; scratch carrier is reset.'}
    return q,marks,angles


def traced(main,marks,angles,seed):
    rng=np.random.default_rng(seed);v=rng.normal(size=8)+1j*rng.normal(size=8);v/=np.linalg.norm(v)
    q=main.copy_empty_like();q.initialize(v,[0,2,3]);q.x(1)  # non-ready scratch must really be reset
    history=ClassicalRegister(len(angles),'audit_history');frames=ClassicalRegister(2*len(marks),'audit_frames')
    q.add_register(history,frames);step=0;by_index={}
    for k,(at,_) in enumerate(marks):by_index.setdefault(at,[]).append(k)
    for index,item in enumerate(main.data,1):
        q.append(item)
        if item.operation.name=='measure':
            assert item.clbits==(main.cregs[2][0],)
            q.store(history[step],main.cregs[2][0]);step+=1
        for k in by_index.get(index,[]):
            q.store(frames[2*k],main.cregs[0][0]);q.store(frames[2*k+1],main.cregs[1][0])
            save_density_matrix(q,range(4),label='boundary'+str(k),pershot=True)
    assert step==len(angles)
    # A real consumer acts on the returned logical carrier, not the retired one.
    owner=marks[-1][1]['physical_owner'];q.s(owner)
    save_density_matrix(q,range(4),label='consumer',pershot=True)
    return q,v,history,frames


def sdk_case(source,selection,n,seed,rectify_middle=False,shots=128):
    main,marks,angles=production(source,selection,n,rectify_middle)
    stream=io.BytesIO();qpy.dump(main,stream);stream.seek(0);restored,=qpy.load(stream)
    assert main==restored and work.ordered_bindings(main)==work.ordered_bindings(restored)
    q,v,history,frames=traced(restored,marks,angles,seed)
    result=AerSimulator(method='statevector',max_parallel_threads=1).run(q,shots=shots,memory=True,seed_simulator=seed+93).result()
    assert result.success;maximum=0.;returned={};initial=np.outer(v,v.conj())
    for k,text in enumerate(result.get_memory()):
        word=int(text.replace(' ',''),2);replies=[(word>>q.find_bit(b).index)&1 for b in history]
        assert word&7==0
        u=I.astype(complex);x=z=0;step=0;previous_corrections=0
        for index,(_,boundary) in enumerate(marks):
            count=len(boundary['logical_word'])
            for a,b in zip(angles[step:count],replies[step:count]):
                u=j(radians(a))@u;x,z=b^z,x
            step=count
            if len(boundary['rectified_at'])>previous_corrections:x=z=0
            previous_corrections=len(boundary['rectified_at'])
            assert ((word>>q.find_bit(frames[2*index]).index)&1)==x
            assert ((word>>q.find_bit(frames[2*index+1]).index)&1)==z
            assert boundary['physical_owner']==count%2
            frame=np.linalg.matrix_power(X,x)@np.linalg.matrix_power(Z,z)
            a=np.kron(np.eye(4),frame@u);expected=embed(a@initial@a.conj().T,boundary['physical_owner'])
            e=float(np.max(abs(result.data()['boundary'+str(index)][k].data-expected)));assert e<1e-10;maximum=max(maximum,e)
        consumer=np.kron(np.eye(4),np.diag([1,1j])@u)
        expected=embed(consumer@initial@consumer.conj().T,marks[-1][1]['physical_owner'])
        e=float(np.max(abs(result.data()['consumer'][k].data-expected)));assert e<1e-10;maximum=max(maximum,e)
        key=''.join(map(str,replies[:min(3,n)]));returned[key]=returned.get(key,0)+1
    return {'measurements':n,'midword_rectification':rectify_middle,'quantum_wires':main.num_qubits,
        'live_classical_bits':main.num_clbits,'output_owner':marks[-1][1]['physical_owner'],
        'QPY_bytes':len(stream.getvalue()),'full_joint_states_checked':shots*(len(marks)+1),
        'maximum_joint_state_error':maximum,'first_reply_prefix_counts':returned},main,marks


def nonadaptive_counterexample():
    alpha=math.pi/4;target=j(alpha)@j(0);bell=np.array([1,0,0,1])/np.sqrt(2)
    ideal=np.kron(I,target)@bell;outputs=[];rows=[]
    for b,c in product((0,1),repeat=2):
        k=physical_kraus(alpha,c)@physical_kraus(0,b)  # deliberately ignores incoming frame
        x,z=c,b;correction=np.linalg.matrix_power(Z,z)@np.linalg.matrix_power(X,x)
        psi=np.kron(I,correction@k)@bell;p=float(np.vdot(psi,psi).real)
        fidelity=float(abs(np.vdot(ideal,psi))**2/p);outputs.append(np.outer(psi,psi.conj()))
        assert abs(p-.25)<1e-12
        rows.append({'actual_history':[b,c],'probability':p,'conditional_process_fidelity':fidelity})
    average=float(np.vdot(ideal,sum(outputs)@ideal).real);assert abs(average-.75)<1e-12
    return {'target_angles':[[0,1],[1,4]],'histories':rows,'uncorrected_basis_average_process_fidelity':average,
        'scope':'Exactly the same uniform classical histories; correct terminal Pauli corrections do not repair a lost non-Clifford basis dependency.'}


def physical_wrong_basis(source,selection):
    q=QuantumCircuit(4);s=wire.Wire(q,source,selection);s.append([[0,1],[1,4]]);s.rectify()
    # Replace the actual second adaptive Rz conditional by the unconditional
    # positive angle. Retain every measured bit and all frame corrections.
    bad=q.copy_empty_like();seen=0
    for item in q.data:
        if item.operation.name=='if_else' and any(x.operation.name=='rz' for block in item.operation.blocks for x in block.data):
            seen+=1
            if seen==2:bad.rz(math.pi/4,1);continue
        bad.append(item)
    assert seen==2
    test=bad.copy_empty_like();test.h(0);test.cx(0,3)
    hist=ClassicalRegister(2,'audit_history');test.add_register(hist);i=0
    for item in bad.data:
        test.append(item)
        if item.operation.name=='measure':test.store(hist[i],bad.cregs[2][0]);i+=1
    save_density_matrix(test,[s.owner,3],label='returned',pershot=True)
    r=AerSimulator(method='statevector',max_parallel_threads=1).run(test,shots=256,memory=True,seed_simulator=98971).result()
    target=j(math.pi/4)@j(0);ideal=np.kron(I,target)@np.array([1,0,0,1])/np.sqrt(2);groups={}
    for i,text in enumerate(r.get_memory()):
        word=int(text.replace(' ',''),2);b=(word>>test.find_bit(hist[0]).index)&1
        fidelity=float(np.vdot(ideal,r.data()['returned'][i].data@ideal).real)
        expected=.5 if b else 1.;assert abs(fidelity-expected)<1e-12
        groups.setdefault(str(b),[]).append(fidelity)
    assert len(groups)==2
    return {'shots':256,'grouped_by_first_real_reply':{k:{'count':len(v),'process_fidelity':v[0]} for k,v in groups.items()}}


def guards(source,selection):
    refused=[]
    def no(name,action):
        try:action()
        except (ValueError,AssertionError):refused.append(name);return
        raise AssertionError('Accepted '+name)
    bad=deepcopy(source);bad['next_owner']=[0,1]
    no('logical output kept at the measured carrier',lambda:wire.validate(bad))
    bad=deepcopy(source);bad['initial']['x']=1
    no('unacquired initial frame supplied',lambda:wire.validate(bad))
    bad=deepcopy(selection);bad['model']['observation']=[[0,0] for _ in bad['model']['observation']]
    bad['certificate']=wire.goal.saturate.synthesize(bad['model'])
    no('valid quotient for a weaker output question',lambda:wire.lowering(source,bad))
    no('angle without declared parameter meaning',lambda:wire.angle(.25))
    no('missing preparation carrier',lambda:wire.Wire(QuantumCircuit(3),source,selection))
    return refused


def run(output):
    start=time.perf_counter();source=json.loads((output/'wire-reading.json').read_text());selection=json.loads((output/'plan.json').read_text());rows=[]
    for n in (1,2,3,8,32,64):
        for middle in (False,True):
            row,main,marks=sdk_case(source,selection,n,98101+n,middle);rows.append(row)
    # Production artifact returns the rectified live logical carrier.
    # The additional consumer belongs to the separately instrumented tests.
    main,marks,_=production(source,selection,8,False)
    with (output/'measurement-working-word.qpy').open('wb') as f:qpy.dump(main,f)
    write(output/'boundaries.json',[b for _,b in marks])
    result={'source':wire.admission.fingerprint(source),'exact_branches':exact_branches(source),
        'memory':memory_boundary(source,selection),'sdk':rows,
        'nonadaptive_boundary':nonadaptive_counterexample(),'actual_wrong_basis':physical_wrong_basis(source,selection),
        'refusals':guards(source,selection),'full_joint_states_checked':sum(r['full_joint_states_checked'] for r in rows),
        'maximum_joint_state_error':max(r['maximum_joint_state_error'] for r in rows),
        'seconds':time.perf_counter()-start,'new_QPU_jobs':0,'implementation_sha256':digest(Path(wire.__file__)),
        'check_sha256':digest(Path(__file__))}
    write(output/'audit.json',result);return result


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    r=run(p.parse_args().output.resolve());print(json.dumps({k:r[k] for k in ['full_joint_states_checked','maximum_joint_state_error','seconds']}))
