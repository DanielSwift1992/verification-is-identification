#!/usr/bin/env python3
"""Support proof, necessary boundary and actual two-contact continuation.

No statistics admit the program here. General CP relations are checked over
the complete input operator space; SDK executions validate the owned local
construction and source-preserving specialization, including reference.
"""
import argparse
from copy import deepcopy
import io
import json
from pathlib import Path
import time

import numpy as np
from qiskit import QuantumCircuit, ClassicalRegister, qpy
from qiskit.circuit.library import UnitaryGate
from qiskit.quantum_info import Operator
from qiskit_aer import AerSimulator
from qiskit_aer.library import save_density_matrix

import resident_supported_contact as supported
import resident_completion_checks as old
from resident_failure_evidence_checks import failure_effect
from resident_stream_checks import operators, apply
from environment import write, digest


I=np.eye(2); X=np.array([[0,1],[1,0]]); Z=np.diag([1,-1])
ZD=np.kron(I,np.kron(Z,np.eye(4))); XD=np.kron(I,np.kron(X,np.eye(4)))


def unitary(seed):
    rng=np.random.default_rng(seed)
    q,r=np.linalg.qr(rng.normal(size=(2,2))+1j*rng.normal(size=(2,2)))
    return UnitaryGate(q)


def ks_of(contact):
    u=contact.service().to_matrix()
    return [[u[b::2,::2]] for b in (0,1)]


def general_cp(source):
    rng=np.random.default_rng(96631); maximum=0.; words=0; units=0
    raw=source['completion']['acquisition']['goal']['raw']
    # Independent unknown E channels at the two contacts, two Kraus each.
    for case in range(3):
        stages=[]
        for j in range(2):
            branches=[]
            for b in (0,1):
                v,_=np.linalg.qr(rng.normal(size=(4,2))+1j*rng.normal(size=(4,2)))
                m=np.zeros((2,2));m[1-b,b]=1
                branch=[np.kron(v[2*k:2*k+2],m) for k in (0,1)]
                p=np.kron(I,np.diag([int(b==0),int(b==1)]))
                assert np.max(abs(sum(k.conj().T@k for k in branch)-p))<1e-12
                assert max(np.max(abs(p@k)) for k in branch)<1e-12
                branches.append(branch)
            stages.append(branches)
        maps=[operators(raw,k) for k in stages]; success=[]
        for b in (0,1):
            wrong=[v@u for v in maps[1][1^b,b] for u in maps[0][0,b]]
            for k in wrong:
                e=float(np.max(abs(k)));assert e<1e-12;maximum=max(maximum,e);words+=1
            good=[ZD@v@u for v in maps[1][1^b,1-b] for u in maps[0][0,b]]
            success.extend(good)
            # The next source action is the same H irrespective of b. Compare
            # its actual complete branch, not just its probability effect.
            cz=np.kron(I,np.kron(np.diag([1,1,1,-1]),I))
            fixed_action=cz@np.kron(I,np.kron(supported.single.admission.H,np.kron(Z,I)))
            fixed=[fixed_action@np.kron(np.eye(4),k) for k in stages[1][1-b]]
            for a in range(16):
                for c in range(16):
                    x=np.zeros((16,16),complex);x[a,c]=1
                    direct=apply(good,x)
                    staged=ZD@apply(fixed,apply(maps[0][0,b],x))@ZD
                    e=float(np.max(abs(direct-staged)));assert e<1e-12;maximum=max(maximum,e);units+=1
        assert np.max(abs(sum(k.conj().T@k for k in success)-np.eye(16)))<1e-12
    return {'cases':3,'unknown_E_Kraus_per_reply':2,'forbidden_Kraus_words':words,
        'complete_input_matrix_units_checked':units,'maximum_residual':maximum,
        'scope':'Independent E channels per contact, full DEM/reference, same selector M.'}


def constructor_relations(source):
    rows=[]
    for seed in (971,983,997):
        c=supported.OwnedContact(source,[unitary(seed),unitary(seed+1)])
        ks=ks_of(c);maximum=0.
        for b in (0,1):
            selector=np.zeros((2,2));selector[1-b,b]=1
            expected=np.kron(c.payloads[b].to_matrix(),selector)
            e=float(np.max(abs(ks[b][0]-expected)));assert e<1e-12;maximum=max(maximum,e)
        rows.append({'seed':seed,'actual_constructor_Kraus_residual':maximum})
    return rows


def robust_boundary(source):
    # An unowned selector rotation is outside the exact support constructor.
    # Its genuine source failure effect is nevertheless exactly computable.
    delta=.37; eta=float(np.sin(delta/2)**2);q=QuantumCircuit(3)
    q.cx(1,0);q.x(1);q.rx(delta,1);u=Operator(q).data
    ks=[[u[b::2,::2]] for b in (0,1)];rows=[]
    for n in (1,2,3,8):
        effect=failure_effect(source['completion'],ks,n);expected=eta**(n-1)*np.eye(8)
        e=float(np.max(abs(effect-expected)));assert e<1e-12
        rows.append({'budget':n,'uniform_failure':eta**(n-1),'effect_residual':e})
    # Moving the unspecified operation to M can undo the owned flip. Then
    # all later real replies are equal to the first on every input.
    q=QuantumCircuit(3);q.cx(1,0);q.x(1);q.x(1);u=Operator(q).data
    wrong=[[u[b::2,::2]] for b in (0,1)]
    f=failure_effect(source['completion'],wrong,8)
    assert np.max(abs(f-np.eye(8)))<1e-12
    return {'selector_rotation':delta,'conditional_repeat_probability':eta,'rows':rows,
        'payload_relocated_onto_M_failure_at_8':float(np.linalg.eigvalsh(f).min()),
        'scope':'Robust-bound example is analyzed in the general source, not admitted by the exact constructor.'}


def audit_body(main, stages, source, seed, epochs=2, shots=128):
    # Instrument the actual production body, then execute it twice on the
    # same quantum input. Extra history and state reads belong only to audit.
    rng=np.random.default_rng(seed);psi=rng.normal(size=16)+1j*rng.normal(size=16);psi/=np.linalg.norm(psi)
    q=main.copy_empty_like();q.initialize(psi,[1,2,3,4])
    history=ClassicalRegister(2*epochs,'audit_replies');flags=ClassicalRegister(epochs,'audit_flags')
    q.add_register(history,flags)
    for epoch in range(epochs):
        for item in main.data:
            q.append(item)
            if item.operation.name=='measure':
                if item.clbits==(main.cregs[0][0],):q.store(history[2*epoch],main.cregs[0][0])
                elif item.clbits==(main.cregs[1][0],):q.store(history[2*epoch+1],main.cregs[1][0])
                elif item.clbits==(main.cregs[2][0],):q.store(flags[epoch],main.cregs[2][0])
        save_density_matrix(q,range(5),label='epoch'+str(epoch),pershot=True)
    with q.if_test((main.cregs[2][0],1)):q.x(3)
    save_density_matrix(q,range(5),label='consumer',pershot=True)
    result=AerSimulator(method='statevector',max_parallel_threads=1).run(q,shots=shots,memory=True,seed_simulator=seed+71).result()
    assert result.success;raw=source['completion']['acquisition']['goal']['raw'];maps=[operators(raw,k) for k in stages]
    maximum=0.; counts={}
    for i,text in enumerate(result.get_memory()):
        word=int(text.replace(' ',''),2);rho=np.outer(psi,psi.conj())
        assert word&7==4  # scratch zero, actual final completion true
        for epoch in range(epochs):
            b=(word>>q.find_bit(history[2*epoch]).index)&1
            nxt=(word>>q.find_bit(history[2*epoch+1]).index)&1
            assert nxt==1-b and (word>>q.find_bit(flags[epoch]).index)&1
            counts[str(b)+str(nxt)]=counts.get(str(b)+str(nxt),0)+1
            rho=apply(maps[0][0,b],rho);rho=ZD@apply(maps[1][1^b,nxt],rho)@ZD
            rho/=np.trace(rho).real
            expected=np.kron(rho,np.diag([1,0]));actual=result.data()['epoch'+str(epoch)][i].data
            e=float(np.max(abs(actual-expected)));assert e<1e-10;maximum=max(maximum,e)
        expected=np.kron(XD@rho@XD,np.diag([1,0]))
        e=float(np.max(abs(result.data()['consumer'][i].data-expected)));assert e<1e-10;maximum=max(maximum,e)
    return {'seed':seed,'epochs':epochs,'shots':shots,'actual_reply_pairs':counts,
        'joint_states_checked':shots*(epochs+1),'maximum_joint_state_error':maximum,
        'same_quantum_memory_between_epochs':True,'consumer_uses_actual_completion':True}


def compare_generic(source,contact,shots=64):
    prior=source['completion'];plan=supported.completion.plan(prior)
    generic=supported.single.body(prior,plan,contact.service(),2)
    # Test arbitrary quantum input as well as the old fixed preparation.
    rng=np.random.default_rng(97261);v=rng.normal(size=16)+1j*rng.normal(size=16);v/=np.linalg.norm(v)
    q=generic.copy_empty_like();q.initialize(v,[1,2,3,4])
    for item in generic.data:q.append(item)
    q=old.traced(q,2,supported.completion.interpret(prior,plan)['completed'])
    save_density_matrix(q,range(5),label='state',pershot=True)
    result=AerSimulator(method='statevector',max_parallel_threads=1).run(q,shots=shots,memory=True,seed_simulator=97261).result()
    assert result.success;maps=operators(prior['acquisition']['goal']['raw'],ks_of(contact));maximum=0.
    for i,text in enumerate(result.get_memory()):
        word=int(text.replace(' ',''),2);b=(word>>generic.num_clbits)&1;nxt=(word>>(generic.num_clbits+1))&1
        assert nxt==1-b;rho=np.outer(v,v.conj());rho=apply(maps[0,b],rho)
        rho=ZD@apply(maps[1^b,nxt],rho)@ZD;rho/=np.trace(rho).real
        e=float(np.max(abs(result.data()['state'][i].data-np.kron(rho,np.diag([1,0])))))
        assert e<1e-10;maximum=max(maximum,e)
    return {'generic_classical_bits':generic.num_clbits,'specialized_classical_bits':3,
        'generic_states_checked':shots,'maximum_joint_state_error':maximum}


def not_complete_output(source):
    rows=[]
    for changed in (False,True):
        first=supported.OwnedContact(source,[UnitaryGate(X if changed else I)]*2)
        second=supported.OwnedContact(source,[UnitaryGate(I)]*2)
        q=supported.body(source,[first,second]);save_density_matrix(q,[1,2,3,4],label='state',pershot=True)
        result=AerSimulator(method='statevector',max_parallel_threads=1).run(q,shots=32,memory=True,seed_simulator=97417).result()
        values=[float(np.trace(ZD@s.data).real) for s in result.data()['state']]
        expected=-1 if changed else 1
        assert max(abs(x-expected) for x in values)<1e-12
        assert all(int(s.replace(' ',''),2)==4 for s in result.get_memory())
        rows.append({'first_E_payload':'X' if changed else 'I','completed':1,'final_data_Z':expected})
    return {'cases':rows,'scope':'Exact completion does not determine all other output questions. The payload still changes the live quantum result.'}


def guards(source):
    failures=[];good=supported.OwnedContact(source,[UnitaryGate(I)]*2)
    def no(name,f):
        try:f()
        except (ValueError,TypeError):failures.append(name);return
        raise AssertionError('Accepted '+name)
    no('unknown operation widened to include M',lambda:supported.OwnedContact(source,[UnitaryGate(np.eye(4))]*2))
    no('opaque three-wire service substituted for owned constructor',lambda:supported.body(source,[good.service(),good.service()]))
    no('second actual contact omitted',lambda:supported.body(source,[good]))
    bad=deepcopy(source);bad['rows'][0]['next']=0
    no('unsupported same-reply continuation',lambda:supported.validate(bad))
    bad=deepcopy(source);bad['rows'][0]['completion']=0
    no('different goal reading substituted',lambda:supported.validate(bad))
    return failures


def run(output):
    start=time.perf_counter();source=json.loads((output/'support-reading.json').read_text());rows=[]
    for seed in (97501,97511,97531):
        contacts=[supported.OwnedContact(source,[unitary(seed+2*j),unitary(seed+2*j+1)]) for j in range(2)]
        main=supported.body(source,contacts);stream=io.BytesIO();qpy.dump(main,stream);stream.seek(0);restored,=qpy.load(stream)
        assert main==restored and supported.single.work.ordered_bindings(main)==supported.single.work.ordered_bindings(restored)
        rows.append(audit_body(restored,[ks_of(c) for c in contacts],source,seed))
    # One plain production output, before any test-only instrumentation.
    path=output/'supported-working-body.qpy'
    with path.open('wb') as f:qpy.dump(main,f)
    result={'source':supported.single.admission.fingerprint(source),'source_equalities':16,
        'constructor_relations':constructor_relations(source),'general_CP':general_cp(source),
        'working_chains':rows,'generic_comparison':compare_generic(source,contacts[0]),
        'robustness_and_counterexample':robust_boundary(source),'goal_not_full_output':not_complete_output(source),
        'refusals':guards(source),'joint_states_checked':sum(r['joint_states_checked'] for r in rows),
        'maximum_joint_state_error':max(r['maximum_joint_state_error'] for r in rows),
        'production_qubits':main.num_qubits,'production_classical_bits':main.num_clbits,
        'production_QPY_bytes':path.stat().st_size,'calibration_shots':0,'new_QPU_jobs':0,
        'seconds':time.perf_counter()-start,'implementation_sha256':digest(Path(supported.__file__)),
        'check_sha256':digest(Path(__file__))}
    write(output/'audit.json',result);return result


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    r=run(p.parse_args().output.resolve());print(json.dumps({k:r[k] for k in ['joint_states_checked','maximum_joint_state_error','seconds','calibration_shots']}))
