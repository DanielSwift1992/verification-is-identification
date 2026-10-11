#!/usr/bin/env python3
"""Symbolic all-phase obligations, full instruments, and independent SDK word."""
from copy import deepcopy
from itertools import permutations
import json
import subprocess
import time

import numpy as np
from qiskit import QuantumCircuit, qpy
from qiskit.circuit.library import DiagonalGate
from qiskit.quantum_info import Operator

import orbit_return as o

OUT=o.ROOT/'Research/Artifacts/returning-attempt-20260916/orbit'


def instrument_error(m,result):
    n=len(m['q']);worst=0.;seen=set();total=np.zeros((n,n),complex)
    for a,w,k in result['rows']:
        assert w==0 and a not in seen;seen.add(a)
        p=np.diag([int(x==a) for x in m['q']]);index=m['q'].index(a)
        z=k[index,index]
        worst=max(worst,float(abs(abs(z)-1)),float(np.max(abs(k-z*p))))
        total+=k.conj().T@k
    assert seen==set(m['q'])
    return max(worst,float(np.max(abs(total-np.eye(n)))))


def coherence_probability(result,pair):
    n=result['rows'][0][2].shape[0];v=np.zeros(n,complex)
    v[pair[0]]=v[pair[1]]=1/np.sqrt(2)
    return sum(float(abs(v.conj()@k@v)**2) for _,_,k in result['rows'])


def circuit(phases):
    """Independent six-qubit gate construction on C,B,A,W_B,W_parity,O."""
    q=QuantumCircuit(6,name='four_forward_orbits_measured_question')
    for j in range(4):
        q.append(DiagonalGate(list(phases)),[0,1,2])
        q.cx(1,3);q.cx(2,4);q.cx(1,4)
        if j==0:q.cx(3,5);q.cx(4,5)
        q.cx(0,1);q.x(0)
    # XOR over every four-position fiber is zero; no work cleanup gate is
    # needed in this example. O is measured only at the declared exit boundary.
    return q


def run():
    started=time.perf_counter();OUT.mkdir(parents=True,exist_ok=True)
    source=o.read_source();m=o.model(source);cert=o.propose(m,['T']*4)
    verdict=o.verify(m,cert);assert verdict['admitted']
    assert verdict['joint_oracle_calls']==verdict['count_lower_bound']==4
    assert verdict['elementary_forward_contacts']==8
    assert cert['computed']['cleanup_by_answer']=={'0':0,'1':0}
    for s in range(8):
        assert cert['computed']['visits'][s]==[int(t//4==s//4) for t in range(8)]

    # Symbolic integer vectors establish the all-phase statement. Numerical
    # phases below independently test the operator implementation, not that
    # universal quantifier. Include non-root-of-unity phases.
    theta=np.array([.17,-.42,.73,1.14,-2.01,.26,.31,-.87])
    phases=np.exp(1j*theta)
    exact=o.execute(m,cert,lambda j,s,w:phases[s])
    residual=instrument_error(m,exact);assert residual<1e-12
    sdk=circuit(phases);actual=Operator(sdk).data[:,:8]
    sdk_error=float(np.max(abs(actual-exact['isometry'])));assert sdk_error<1e-12
    with (OUT/'OrbitReturn.qpy').open('wb') as f:qpy.dump(sdk,f)
    with (OUT/'OrbitReturn.qpy').open('rb') as f:restored=qpy.load(f)[0]
    assert np.max(abs(Operator(restored).data[:,:8]-actual))<1e-12
    common_drift=o.execute(m,cert,lambda j,s,w:np.exp(1j*(theta[s]+.37*j*j)))
    assert instrument_error(m,common_drift)<1e-12

    # The acquired answer controls two later uses on two actual, unprepared
    # data ports. Each device use is W_a(G)=Z^a G; the output register provides
    # Z^a correction. Source A is consulted by the device, never by the decoder.
    # Full 32-dimensional retained maps include arbitrary joint S,D,E input.
    reuse=QuantumCircuit(8,name='orbit_acquire_then_two_live_recipients')
    reuse.compose(sdk,qubits=range(6),inplace=True)
    reuse.h(6);reuse.cz(2,6);reuse.cz(5,6)
    reuse.s(7);reuse.cz(2,7);reuse.cz(5,7)
    matrix=Operator(reuse).data
    prepared=[s+64*d+128*e for e in range(2) for d in range(2) for s in range(8)]
    h=np.array([[1,1],[1,-1]],complex)/np.sqrt(2);sgate=np.diag([1,1j])
    reuse_error=0.;completeness=np.zeros((32,32),complex)
    for a in (0,1):
        k=matrix[np.ix_([row+32*a for row in prepared],prepared)]
        p=np.diag([int(q==a) for q in m['q']]);target=np.kron(sgate,np.kron(h,p))
        z=exact['rows'][a][2][4*a,4*a]
        reuse_error=max(reuse_error,float(np.max(abs(k-z*target))))
        completeness+=k.conj().T@k
    assert reuse_error<1e-12 and np.max(abs(completeness-np.eye(32)))<1e-12
    outside=[row for row in range(256) if ((row>>3)&3)!=0]
    assert np.max(abs(matrix[np.ix_(outside,prepared)]))<1e-12
    with (OUT/'OrbitReturnTwoRecipients.qpy').open('wb') as f:qpy.dump(reuse,f)

    # A universal phase word needs at least one visit to every member of the
    # starting q-fiber, since every start is queried at step zero. The symbolic
    # bound is attained here; not a claim about arbitrary quantum algorithms.
    short=[]
    for k in (1,2,3):
        rejected=o.propose(m,['T']*k);assert not o.verify(m,rejected)['admitted']
        short.append({'calls':k,'obstruction':rejected['obstruction']})

    # Source returns in two steps and workspace can be cleared, but the two
    # c-sectors inside a fiber have unequal phase visits.
    small=deepcopy(m);small['permutations']['T']=[2,3,0,1,6,7,4,5]
    bad=o.propose(small,['T']*2);assert not o.verify(small,bad)['admitted']
    wrong_orbits=o.execute_word(small,['T']*2,bad['computed']['decoder'],{'0':3,'1':3},
                               lambda j,s,w:(1j)**(s%2))
    assert all(w==0 for _,w,_ in wrong_orbits['rows'])
    assert coherence_probability(wrong_orbits,(0,1))<1e-12

    # Time-dependent differential phases, or static phases of (s,work), break
    # the original oracle contract while leaving source/work and answers right.
    differential=o.execute(m,cert,lambda j,s,w:(-1)**(s%2) if j==0 else 1)
    workspace=o.execute(m,cert,lambda j,s,w:-1 if (s,w)==(3,0) else 1)
    assert coherence_probability(differential,(0,1))<1e-12
    assert coherence_probability(workspace,(0,3))<1e-12
    assert all(w==0 for r in [differential,workspace] for _,w,_ in r['rows'])

    # Coarse-only phase is harmless AFTER measuring O, but cannot be silently
    # erased before an arbitrary coherent receiver. A full eight-cycle returns
    # a common global phase and solves that stronger boundary at twice the cost.
    qphase=lambda j,s,w:np.exp(1j*np.pi/4) if s>=4 else 1
    measured_only=o.execute(m,cert,qphase);assert instrument_error(m,measured_only)<1e-12
    # Disentangle O using known q=A, then test coherence between q=0 and q=1.
    def erase_output(result):
        matrix=sum(k for _,w,k in result['rows'] if w==0)
        return {'rows':[(0,0,matrix)]}
    assert coherence_probability(erase_output(measured_only),(0,4))<1e-12
    global_model=deepcopy(m);global_model['permutations']['T']=list(range(1,8))+[0]
    global_cert=o.propose(global_model,['T']*8);assert o.verify(global_model,global_cert)['admitted']
    global_result=o.execute(global_model,global_cert,qphase)
    assert instrument_error(global_model,global_result)<1e-12
    assert abs(coherence_probability(erase_output(global_result),(0,4))-1)<1e-12
    assert len({tuple(v) for v in global_cert['computed']['visits']})==1
    assert any(m['q'][s]!=m['q'][global_model['permutations']['T'][s]] for s in range(8))

    # Static repeatable noncommuting environment actions are NOT scalar
    # phases. Balanced visits no longer balance their ordered products.
    x=np.array([[0,1],[1,0]],complex);z=np.diag([1,-1]);eye=np.eye(2)
    environment_actions=[x,z,eye,eye,eye,eye,eye,eye]
    branch=np.zeros((16,16),complex)
    for s in range(4):
        product=eye
        for t in cert['computed']['paths'][s]:product=environment_actions[t]@product
        for before in range(2):
            for after in range(2):branch[s+8*after,s+8*before]=product[after,before]
    state=np.zeros(16,complex);state[0]=state[1]=1/np.sqrt(2)
    evolved=branch@state
    plus=np.zeros(8,complex);plus[0]=plus[1]=1/np.sqrt(2)
    hidden_memory_probability=sum(float(abs(plus.conj()@evolved[8*k:8*(k+1)])**2) for k in range(2))
    assert hidden_memory_probability==0

    # Numerical fourth-root phases alone would miss exponents differing by
    # four. Exact counts correctly reject this apparently returning word.
    roots_model={'schema':m['schema'],'source':'phase-grid-boundary','q':[0,0],'f':[0,0],
        'work_bits':1,'elementary_contacts_per_oracle':1,'permutations':{'T':[0,1]},
        'oracle_contract':m['oracle_contract']}
    roots_cert=o.propose(roots_model,['T']*4);assert not o.verify(roots_model,roots_cert)['admitted']
    roots_result=o.execute_word(roots_model,['T']*4,roots_cert['computed']['decoder'],{'0':0},
                               lambda j,s,w:np.exp(1j*np.pi/4) if s else 1)
    assert coherence_probability(roots_result,(0,1))<1e-12

    # Independent finite check of the orbit criterion: all 15 partitions of
    # four source positions, against all 24 permutations, with F(s)=s.
    def partitions(prefix,n):
        if len(prefix)==n:yield prefix;return
        for a in range(max(prefix,default=-1)+2):yield from partitions(prefix+[a],n)
    orbit_cases=0;orbit_admitted=0
    for q in partitions([],4):
        for p in permutations(range(4)):
            cycles=[];remaining=set(range(4))
            while remaining:
                start=min(remaining);cycle=[];s=start
                while s not in cycle:cycle.append(s);remaining.remove(s);s=p[s]
                cycles.append(cycle)
            length=int(np.lcm.reduce([len(c) for c in cycles]))
            orbit=[next(j for j,c in enumerate(cycles) if s in c) for s in range(4)]
            criterion=all(q[s]!=q[t] or orbit[s]==orbit[t] for s in range(4) for t in range(4))
            sample={'schema':m['schema'],'source':'exhaustive-four-state','q':q,'f':list(range(4)),
                'work_bits':2,'elementary_contacts_per_oracle':1,'permutations':{'T':list(p)},
                'oracle_contract':m['oracle_contract']}
            checked=o.verify(sample,o.propose(sample,['T']*length))
            assert checked['admitted']==criterion
            orbit_cases+=1;orbit_admitted+=int(criterion)
    assert orbit_cases==360

    # A nonzero cleanup must also be constructed from acquired q, not replaced
    # by reset. A three-cycle with q constant has XOR 1 and one work bit.
    cleanup_model={'schema':m['schema'],'source':'explicit-three-state-fixture','q':[0,0,0],
        'f':[1,0,0],'work_bits':1,'elementary_contacts_per_oracle':1,
        'permutations':{'T':[1,2,0]},'oracle_contract':m['oracle_contract']}
    cleanup_cert=o.propose(cleanup_model,['T']*3)
    assert cleanup_cert['computed']['cleanup_by_answer']=={'0':1}
    assert instrument_error(cleanup_model,o.execute(cleanup_model,cleanup_cert))==0
    uncleared=o.execute(cleanup_model,cleanup_cert,clear_work=False)
    assert {w for _,w,_ in uncleared['rows']}=={1}

    negatives=[]
    def reject(name,fn):
        try:fn()
        except (ValueError,AssertionError,KeyError):negatives.append(name)
        else:raise AssertionError('Accepted '+name)
    forged=deepcopy(cert);forged['computed']['visits'][0][0]=0
    reject('invented visit balance',lambda:o.verify(m,forged))
    forged=deepcopy(cert);forged['computed']['cleanup_by_answer']['0']=1
    reject('invented ready workspace',lambda:o.verify(m,forged))
    forged=deepcopy(cert);forged['computed']['decoder']['0']=1
    reject('decoder unrelated to the question',lambda:o.verify(m,forged))
    forged=deepcopy(cert);forged['schedule']=['T']*2
    reject('old obligation attached to new word',lambda:o.verify(m,forged))
    reject('old source certificate after changed access',lambda:o.verify(small,cert))
    reject('unavailable return action',lambda:o.propose(m,['Inverse']))
    reject('obstruction declared executable',lambda:o.execute(small,bad))
    insufficient=deepcopy(m);insufficient['f']=[r['ProbeB'] for r in source['rows']]
    reject('fine record does not determine independent q',lambda:o.propose(insufficient,['T']*4))

    court=json.loads(subprocess.run(['node',str(o.ROOT/'Checks/FiniteContinuation/orbit_return_court.js'),
        'check',str(OUT)],capture_output=True,text=True,check=True,timeout=30).stdout)
    for name,value in [('model',m),('certificate',cert),('short-orbit-obstruction',bad),
                       ('global-model',global_model),('global-certificate',global_cert),('court',court)]:
        (OUT/(name+'.json')).write_text(json.dumps(value,indent=2)+'\n')
    result={'schema':'vi.orbit-return-checks.v1','source':o.fingerprint(source),'word':verdict,
        'all_phase_basis':'Exact nonnegative integer visit vectors, constant on each independent q-fiber',
        'operator_residual':residual,'independent_Qiskit_operator_residual':sdk_error,
        'retained_source_dimension':8,'work_qubits':2,'answer_qubits':1,
        'correct_instrument_ranks':[4,4],'arbitrary_external_reference':True,
        'two_live_recipients':{'retained_input_dimension':32,'full_operator_residual':reuse_error,
                               'actions':['H on D','S on E'],'payload_reset_or_preparation':False},
        'common_time_phase_drift_preserved':True,'short_words':short,
        'exhaustive_four_state_orbit_check':{'cases':orbit_cases,'admitted':orbit_admitted},
        'counterexamples':{
          'two_returning_small_orbits':{'obstruction':bad['obstruction'],'same_question_plus_probability':coherence_probability(wrong_orbits,(0,1))},
          'differential_time_drift':{'same_question_plus_probability':coherence_probability(differential,(0,1))},
          'workspace_dependent_phase':{'same_question_plus_probability':coherence_probability(workspace,(0,3))},
          'noncommuting_hidden_memory':{'same_question_plus_probability':hidden_memory_probability},
          'fourth_roots_are_not_all_phases':{'same_question_plus_probability':coherence_probability(roots_result,(0,1))},
          'coherent_output_stronger_than_measured_question':{
             'four_call_cross_question_probability':coherence_probability(erase_output(measured_only),(0,4)),
             'eight_call_cross_question_probability':coherence_probability(erase_output(global_result),(0,4))}},
        'nonzero_cleanup_example':{'calls':3,'work_xor':1,'cleanup_from_answer':True},
        'expected_certificate_rejections':negatives,
        'Swift_bounded_court':{'equalities':court['equalities'],'rejections':court['expected_rejections']},
        'new_QPU_jobs':0,'runtime_seconds':time.perf_counter()-started,
        'scope':'Known phase-free permutations, fixed coherent XOR access. No noise robustness, hardware phase acquisition, '
                'universal algorithmic optimum, or full Swift build is asserted.'}
    (OUT/'checks.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))


if __name__=='__main__':run()
