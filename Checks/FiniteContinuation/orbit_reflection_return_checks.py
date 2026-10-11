#!/usr/bin/env python3
"""Noncommuting memory return: full operators, finite lower bound, current root."""
from copy import deepcopy
from itertools import permutations
import json
import subprocess
import time

import numpy as np
from qiskit import QuantumCircuit,ClassicalRegister,qpy
from qiskit.circuit.library import UnitaryGate

import orbit_return as o
import orbit_future as f
import orbit_live_upgrade_checks as old
import orbit_quantum_memory as memory
import orbit_quantum_memory_checks as memory_checks
import orbit_reflection_return as r

OUT=o.ROOT/'Research/Artifacts/returning-attempt-20260916/reflection-memory'


def make_device(m,dimension,seed,exact=False):
    rng=np.random.default_rng(seed);bases={}
    for s in range(8):
        value=rng.normal(size=(dimension,dimension))+1j*rng.normal(size=(dimension,dimension))
        bases[s]=np.linalg.qr(value)[0]
    signs=[[1 if j%2==0 else -1 for j in range(dimension)] for _ in range(8)]
    angles=np.zeros(8) if exact else rng.uniform(-2,2,8)
    return r.ReflectionDevice(m,bases,signs,angles),bases,signs,angles


def raw_circuit(device,plan):
    q=QuantumCircuit(9);record=ClassicalRegister(1,'acquired_answer');q.add_register(record)
    joint=np.zeros((16,16),complex)
    for s in range(8):
        for i in range(2):
            for j in range(2):joint[s+8*i,s+8*j]=device._actions[s][i,j]
    for index,k in enumerate(plan['powers']):
        q.append(UnitaryGate(joint,label='same_noncommuting_memory_contact'),[0,1,2,8]);q.cx(1,3);q.cx(2,4);q.cx(1,4)
        if index==0:q.cx(3,5);q.cx(4,5)
        for _ in range(k):q.cx(0,1);q.x(0)
    q.measure(5,record[0]);q.barrier(label='whole_source_and_memory_returned')
    q.h(1);q.h(8)
    q.h(6);q.cz(2,6);q.cz(5,6);q.s(7);q.cz(2,7);q.cz(5,7)
    return q


def run():
    started=time.perf_counter();OUT.mkdir(parents=True,exist_ok=True)
    source=o.read_source();results=[];plans={};sdk_error=0.;projective=None
    for relation in ('projective_involution','exact_involution'):
        m=r.model(source,relation)
        for dimension in (2,3,4):
            device,bases,signs,angles=make_device(m,dimension,316+dimension,relation=='exact_involution')
            live=r.WholeMemoryOrbit(m,device);plan=live.start_full();plans[relation]=plan
            returned=old.compare_maps(live.audit_maps(),live.audit_return_target())
            assert max(returned.values())<1e-12
            # The stronger exit permits a new action on E itself, without an
            # assumption that it commutes with the old device's memory action.
            gate=np.eye(dimension,dtype=complex);gate[:2,:2]=old.H
            live.source_action('H_B');live.internal_action(gate);live.work(old.H,0);live.work(old.S,1)
            actual=live.audit_maps();after=old.compare_maps(actual,live.audit_return_target())
            assert max(after.values())<1e-12
            noncommuting=max(float(np.max(abs(device._actions[s]@device._actions[t]-device._actions[t]@device._actions[s])))
                            for s in range(4) for t in range(4))
            assert noncommuting>.1
            squares=[]
            for s in range(8):
                squared=device._actions[s]@device._actions[s]
                squares.append(float(np.max(abs(squared-np.exp(2j*angles[s])*np.eye(dimension)))))
            results.append({'relation':relation,'dimension':dimension,'input_dimension':live.input_dim,
                'V':live.V_calls,'T':live.T_calls,'read_count':live.read_calls,'copy_count':live.copy_calls,
                'square_residual':max(squares),'within_fiber_noncommutation':noncommuting,
                'whole_memory_return':returned,'after_new_memory_access_and_two_live_data_uses':after})
            assert (live.V_calls,live.T_calls)==((2,0) if relation=='exact_involution' else (8,4))
            if dimension==2:
                path=OUT/(relation+'.qpy');q=raw_circuit(device,plan)
                with path.open('wb') as handle:qpy.dump(q,handle)
                with path.open('rb') as handle:restored=qpy.load(handle)[0]
                independent=memory_checks.independent_branches(restored)
                error=max(float(np.max(abs(actual[a]-independent[a]))) for a in actual)
                sdk_error=max(sdk_error,error);assert error<1e-12
                if relation=='projective_involution':projective=(m,device,bases,signs,angles)

    # Finite reflection representations separate all candidate m-query words.
    # The phase subclass excludes every positive L<2m other than L=m; all such
    # remaining words have one visit to each label, hence no adjacent equal pair.
    lower=[]
    for length in range(2,6):
        tree=r.finite_reflections(length,length);tested=0
        assert all(p[p[i]]==i for p in tree['generators'] for i in range(len(p)))
        for word in permutations(range(length)):
            outputs=[r.execute_reflections(tree,[(letter+shift)%length for letter in word])
                     for shift in range(length)]
            assert len(set(outputs))==length
            tested+=1
        # The paired achieving word returns EVERY memory state, not just root.
        for shift in range(length):
            paired=[(s+shift)%length for s in range(length) for _ in range(2)]
            for start in range(len(tree['words'])):
                at=start
                for s in paired:at=tree['generators'][s][at]
                assert at==start
        lower.append({'cycle_length':length,'finite_memory_dimension':len(tree['words']),
                      'm_query_orders_rejected':tested,'achieving_calls':2*length})
    assert lower[2]['finite_memory_dimension']==161

    # Returning E projectively twice is insufficient for S. No memory has to
    # be entangled here: a scalar phase already destroys the claimed return.
    m,device,bases,signs,angles=projective
    scalar_actions=[np.eye(2,dtype=complex) for _ in range(8)];scalar_actions[1]=1j*np.eye(2)
    pair_phases=np.array([x[0,0]**2 for x in scalar_actions])
    state=np.zeros(8,complex);state[0]=state[1]=1/np.sqrt(2)
    out=pair_phases*state;pair_cplus=float(abs(np.vdot(state,out))**2)
    assert pair_cplus<1e-12

    # Broad commuting memory cannot promise to return E with any positive
    # finite forward word: use the SAME diag(1,exp(i theta)) for every s.
    # This statement is a family-wise obstruction, not a claim against inverse E access.
    positive_counts=[2,4,8];common_motion=[]
    for count in positive_counts:
        theta=np.pi/count;u=np.diag([1,np.exp(1j*theta)])
        final=np.linalg.matrix_power(u,count);plus=np.ones(2)/np.sqrt(2)
        p=float(abs(np.vdot(plus,final@plus))**2);assert p<1e-12
        common_motion.append({'V_calls':count,'angle':theta,'Eplus_probability':p})

    rejected=[]
    def reject(name,fn):
        try:fn()
        except (ValueError,AssertionError,KeyError):rejected.append(name)
        else:raise AssertionError('Accepted '+name)
    fresh=r.WholeMemoryOrbit(m,device)
    reject('commuting planner substituted for return relation',lambda:fresh.start([f.pauli('IXI')]))
    bad=deepcopy(plans['projective_involution']);bad['powers']=[1]*4
    _,bad['computed']=f.word_data(m,bad['powers'])
    reject('same counts without ordered return',lambda:r.verify(m,bad))
    short=deepcopy(plans['projective_involution']);short['powers']=[0,0]
    _,short['computed']=f.word_data(m,short['powers']);short['reductions']=[]
    for path in short['computed']['paths']:
        value=r.reduction(path);value['square_counts']+=[0]*(8-len(value['square_counts']));short['reductions'].append(value)
    reject('projective E return declared exact S return',lambda:r.verify(m,short))
    reject('certificate for another physical relation',lambda:r.verify(m,plans['exact_involution']))
    wrong=memory.CommutingMemoryDevice(m,{0:np.eye(2),1:np.eye(2)},np.zeros((8,2)))
    reject('arbitrary device with the same return label',lambda:r.WholeMemoryOrbit(m,wrong))
    reject('nonzero scalar phases under exact relation',lambda:r.ReflectionDevice(r.model(source,'exact_involution'),bases,signs,angles))
    reject('read whole memory before actual acquisition',lambda:fresh.internal_action(old.H))
    fresh.start_full()
    reject('fresh acquisition over existing retained carrier',lambda:fresh.start_full())

    result={'schema':'vi.noncommuting-projective-memory-return.v1','device_cases':results,
            'independent_QPY_residual':sdk_error,'finite_lower_bound':lower,
            'two_queries_return_E_but_Cplus':pair_cplus,
            'commuting_common_memory_not_returned':common_motion,
            'rejected_applications':rejected,'new_QPU_jobs':0,'seconds':time.perf_counter()-started,
            'scope':'Exact minimum for nonempty fixed forward V/T acquisitions on equal q-cycles m>=2. No claim about arbitrary quantum query algorithms or acquired hardware membership.'}
    payload={'source':source,'plans':plans}
    (OUT/'court-input.json').write_text(json.dumps(payload,indent=2)+'\n')
    court=subprocess.run(['node',str(o.ROOT/'Checks/FiniteContinuation/orbit_reflection_court.js'),str(OUT/'court-input.json'),str(OUT)],
                         check=True,capture_output=True,text=True)
    result['bounded_Swift_court']=json.loads(court.stdout)
    result['seconds']=time.perf_counter()-started
    for name,value in [('checks.json',result),('plans.json',plans),('model.json',m)]:
        (OUT/name).write_text(json.dumps(value,indent=2)+'\n')
    print(json.dumps({k:result[k] for k in ('device_cases','independent_QPY_residual','finite_lower_bound','rejected_applications','seconds')},indent=2))


if __name__=='__main__':run()
