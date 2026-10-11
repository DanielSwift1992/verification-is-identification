#!/usr/bin/env python3
"""Current-control quotient, bounded SDK loop, and archive counterexample.

Uses no cloud service. Paired SDK runs deliberately use the same simulator
random seed. Equality of trajectories is a compiler audit, not hardware
evidence or a proof about finite-sample frequencies.
"""
import argparse
from collections import Counter
from copy import deepcopy
import io
import json
from pathlib import Path
import time

import numpy as np
from qiskit import qpy
from qiskit_aer import AerSimulator

import resident_stream as stream
import resident_raw_reply as raw
from resident_raw_reply_checks import fixture,initial_quantum
import resident_classical as classical
import whole_word_admission as admission
from environment import write,digest


def operators(source,ks):
    result={}
    cz=np.kron(admission.I,np.kron(np.diag([1,1,1,-1]),admission.I))
    for r in (0,1):
        for b in (0,1):
            control=r^b;gate,nxt=classical.gate_at(source['interpreter'],control)
            result[r,b]=[cz@np.kron(admission.I,np.kron(gate,admission.I))@np.kron(np.eye(4),k) for k in ks[b]]
    return result


def apply(ks,rho):return sum(k@rho@k.conj().T for k in ks)


def trajectory(maps,history):
    # Install equals the Toggle table from representative r=0. Later values
    # are the actually acquired controller, not a caller-supplied answer.
    rho=initial_quantum();r=0
    for b in history:
        rho=apply(maps[r,b],rho);p=np.trace(rho).real
        assert p>0;rho/=p;r=1^(r^b)
    return r,rho


def reduced_law(maps,contacts):
    # Two quantum blocks, independent of the number of possible histories.
    blocks={0:initial_quantum(),1:np.zeros((16,16),complex)}
    for _ in range(contacts):
        nxt={0:np.zeros((16,16),complex),1:np.zeros((16,16),complex)}
        for r,rho in blocks.items():
            for b in (0,1):nxt[1^(r^b)]+=apply(maps[r,b],rho)
        blocks=nxt
    assert abs(sum(np.trace(x).real for x in blocks.values())-1)<1e-11
    from qiskit import QuantumCircuit
    from qiskit.quantum_info import Operator
    recipient=QuantumCircuit(4);recipient.cx(2,3);recipient.h(2);u=Operator(recipient).data
    result={format(i,'04b'):0. for i in range(16) if not i&2}
    for r,rho in blocks.items():
        for value,p in enumerate(np.diag(u@rho@u.conj().T).real):
            d=(value>>2)&1;ref=(value>>3)&1;result[format(r+(d<<2)+(ref<<3),'04b')]+=float(p)
    return result


def control_table(q,body,install):
    """Read only the generated Boolean control, never the service matrix."""
    result=[]
    for initial in (0,1):
        for reply in (0,1):
            values=[False]*q.num_clbits;values[0]=bool(initial);gates=[]
            for item in body.data:
                op=item.operation
                if op.name=='measure':values[q.find_bit(item.clbits[0]).index]=bool(reply)
                elif op.name=='store':
                    values[q.find_bit(op.lvalue.var).index]=raw.expression_value(op.rvalue,q,values)
                elif op.name=='if_else':
                    bit,value=op.condition
                    if values[q.find_bit(bit).index]==bool(value):
                        gates.extend(x.operation.name for x in op.blocks[0].data)
            expected=reply if install else initial^reply
            assert gates==['h' if expected==0 else 's']
            assert int(values[0])==1^expected and values[1] is False
            result.append({'before':initial,'reply':reply,'gate':gates[0],'after':int(values[0]),'scratch':0})
    return result


def guards(source,gate):
    failures=[]
    def refuse(name,fn):
        try:fn()
        except (ValueError,AssertionError,TypeError):failures.append(name);return
        raise AssertionError('Accepted '+name)
    refuse('zero contacts',lambda:stream.compile(source,gate,0))
    changed=deepcopy(source);changed['known']=[1,0]
    refuse('other acquired control',lambda:stream.compile(changed,gate,3))
    q=stream.compile(source,gate,3,snapshot=False)
    loop=next(x.operation.blocks[0] for x in q.data if x.operation.name=='for_loop')
    table=control_table(q,loop,False)
    # A realistic overwrite bug: clear the scratch before reading its reply.
    bad=loop.copy_empty_like();items=list(loop.data)
    clear=items.pop();assert clear.operation.name=='store'
    measurement=next(i for i,x in enumerate(items) if x.operation.name=='measure')
    items.insert(measurement+1,clear)
    for x in items:bad.append(x)
    refuse('scratch cleared before reply is used',lambda:control_table(q,bad,False))
    prefix=q.copy_empty_like()
    for x in q.data:
        if x.operation.name=='for_loop':break
        # Preparation gates are unconditional and do not enter the table.
        prefix.append(x)
    install=control_table(q,prefix,True)
    return {'refusals':failures,'round_rows':table,'install_rows':install}


def lost_archive_question():
    # Private fair coin with K_0=K_1=I/sqrt(2) and maximally mixed DEM.
    # All operations are unital, so equal-r histories have equal live states.
    value=[]
    for h in [(0,0),(1,1)]:
        r=0
        for b in h:r=1^(r^b)
        value.append({'history':list(h),'relative_control':r,'first_reply':h[0]})
    assert value[0]['relative_control']==value[1]['relative_control']
    assert value[0]['first_reply']!=value[1]['first_reply']
    # The control itself cannot also be discarded: same |0> data, next H
    # versus S produce X expectation 1 versus 0, even without reading R.
    v=np.array([1,0]);answers=[float(np.vdot(g@v,admission.X@g@v).real) for g in [admission.H,admission.S]]
    assert abs(answers[0]-1)<1e-12 and abs(answers[1])<1e-12
    return {'same_remaining_DEM':'I/8','histories':value,'future_X_if_control_erased':answers}


def run(directory):
    directory.mkdir(parents=True,exist_ok=True);source=stream.reading()
    fixtures=[fixture(np.pi/3,np.pi/5),fixture(1.3,-.8)]
    checks=guards(source,fixtures[0][0]);cases=[];worst=0.;shots=256
    before=time.perf_counter();state_checks=0
    for j,(gate,ks,eigen) in enumerate(fixtures):
        maps=operators(source,ks)
        for n in (1,3,16,64):
            circuits=[stream.compile(source,gate,n,archive=a) for a in (False,True)]
            results=[AerSimulator(method='statevector',max_parallel_threads=1).run(q,shots=shots,
                     seed_simulator=16200+j*100+n,memory=True).result() for q in circuits]
            assert all(r.success for r in results)
            record=[int(x.replace(' ',''),2) for x in results[1].get_memory()]
            compact=[int(x.replace(' ',''),2) for x in results[0].get_memory()]
            assert compact==[x&15 for x in record]
            saved=[r.data()['continued'] for r in results]
            assert all(len(x)==shots for x in saved)
            maximum=0.
            for i,full in enumerate(record):
                history=tuple((full>>(4+k))&1 for k in range(n));r,rho=trajectory(maps,history)
                assert r==(full&1) and not full&2
                for states in saved:
                    error=float(np.max(abs(states[i].data-rho)));assert error<1e-10
                    maximum=max(maximum,error);state_checks+=1
            worst=max(worst,maximum)
            expected=reduced_law(maps,n);counts=dict(Counter(format(x,'04b') for x in compact))
            discrepancy=max(abs(counts.get(k,0)/shots-p) for k,p in expected.items())
            size=[]
            for q in circuits:
                f=io.BytesIO();qpy.dump(q,f);size.append(len(f.getvalue()))
            cases.append({'fixture':j,'contacts':n,'stream':stream.profile(circuits[0]),
                'archive':stream.profile(circuits[1]),'QPY_bytes_stream_archive':size,
                'compact_counts':counts,'expected_probabilities':expected,
                'sampling_residual_descriptive':discrepancy,'maximum_trajectory_state_residual':maximum,
                'same_seed_projected_memories_equal':True,
                'archive_memory_sha256':admission.fingerprint(record)})
    result={'cases':cases,'SDK_circuits':16,'shots_each':shots,'conditional_trajectory_states_checked':state_checks,
            'maximum_state_residual':worst,'elapsed_seconds':time.perf_counter()-before,'guards':checks,
            'archive_boundary':lost_archive_question(),'source_sha256':source['source_sha256'],
            'implementation_sha256':digest(Path(stream.__file__)),'test_sha256':digest(Path(__file__)),
            'new_QPU_jobs':0,'scope':'Exact model proof plus same-seed local SDK trajectory audit; frequencies descriptive only'}
    write(directory/'audit.json',result);return result


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    result=run(p.parse_args().output.resolve())
    print(json.dumps({k:result[k] for k in ['SDK_circuits','conditional_trajectory_states_checked','maximum_state_residual','elapsed_seconds','new_QPU_jobs']}))
