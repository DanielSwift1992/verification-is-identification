#!/usr/bin/env python3
"""Fast full-operator and serialized-instrument checks for a bounded future."""
from copy import deepcopy
from math import pi
import json,time
import numpy as np
from qiskit import QuantumCircuit,ClassicalRegister,qpy
from qiskit.circuit.library import UnitaryGate
from qiskit.quantum_info import Operator
import horizon_phase_memory as h
import orbit_return as o

OUT=o.ROOT/'Research/Artifacts/returning-attempt-20260916/horizon-memory'


def circuit(port,words=None):
    # n=3, D=4; wires S,E,P,T0,T1. P and T start AND finish zero.
    q=QuantumCircuit(5);record=ClassicalRegister(2,'phase_record');q.add_register(record)
    target=np.r_[h.weights(3),0];v=np.array([1,0,0,0])-target;v=v/np.linalg.norm(v)
    q.append(UnitaryGate(np.eye(4)-2*np.outer(v,v),label='known_sine_preparation'),[3,4])
    q.swap(0,2)
    def toggle(k):
        for t in range(k+1,4):
            for bit,wire in enumerate((3,4)):
                if not ((t>>bit)&1):q.x(wire)
            q.ccx(3,4,0)
            for bit,wire in enumerate((3,4)):
                if not ((t>>bit)&1):q.x(wire)
    for k in range(2):
        toggle(k);q.append(UnitaryGate(port._v,label='same_unknown_V'),[0,1]);toggle(k)
    q.swap(0,2)
    fourier=np.exp(-2j*pi*np.outer(np.arange(4),np.arange(4))/4)/2
    q.append(UnitaryGate(fourier,label='known_fourier_read'),[3,4]);q.measure([3,4],record)
    for bit,wire in enumerate((3,4)):
        with q.if_test((record[bit],1)):q.x(wire)
    if words is not None:
        for y in range(4):
            with q.if_test((record,y)):
                for name in words[y]:
                    if name=='V':q.append(UnitaryGate(np.diag([1,np.exp(2j*pi*y/4)]),label='acquired_phase'),[0])
                    elif name=='H_source':q.h(0)
                    elif name=='S_source':q.s(0)
                    else:raise AssertionError(name)
    return q


def expand(matrix,wires):
    out=np.zeros((32,32),complex)
    for col in range(32):
        j=sum(((col>>q)&1)<<i for i,q in enumerate(wires));base=col&~sum(1<<q for q in wires)
        for i in range(2**len(wires)):
            row=base|sum(((i>>bit)&1)<<q for bit,q in enumerate(wires));out[row,col]=matrix[i,j]
    return out


def read_instrument(q):
    initial=np.zeros((32,4),complex);initial[:4]=np.eye(4)
    def visit(body,rows,wires,cbits):
        for ins in body.data:
            op=ins.operation;qs=[wires[body.find_bit(b).index] for b in ins.qubits]
            cs=[cbits[body.find_bit(b).index] for b in ins.clbits]
            if op.name=='if_else':
                address,want=op.condition
                indices=[cbits[body.find_bit(b).index] for b in address] if isinstance(address,ClassicalRegister) else [cbits[body.find_bit(address).index]]
                after=[]
                for row in rows:
                    number=sum(row[1][index]<<i for i,index in enumerate(indices));branch=int(number!=want)
                    after.extend(visit(op.blocks[branch],[row],qs,cs) if branch<len(op.blocks) else [row])
                rows=after
            elif op.name=='measure':
                assert len(qs)==len(cs)==1;after=[]
                for matrix,bits in rows:
                    for value in (0,1):
                        p=np.zeros((2,2));p[value,value]=1;newbits=bits.copy();newbits[cs[0]]=value
                        after.append((expand(p,qs)@matrix,newbits))
                rows=after
            elif op.name!='barrier':
                assert op.name in ('unitary','x','ccx','swap','h','s')
                gate=expand(Operator(op).data,qs);rows=[(gate@matrix,bits) for matrix,bits in rows]
        return rows
    result={}
    for matrix,bits in visit(q,[(initial,[0,0])],list(range(5)),[0,1]):
        assert np.max(abs(matrix[4:]))<1e-12,'Working registers did not return'
        result[bits[0]+2*bits[1]]=matrix[:4]
    return result


def trace_distance_on_choi(raw,compiled,d):
    result=0.;size=2*d
    for y,k in raw.items():
        def reduced(matrix):
            vector=matrix.reshape(-1)/np.sqrt(size)
            rho=np.outer(vector,vector.conj()).reshape(d,2,size,d,2,size)
            return np.trace(rho,axis1=0,axis2=3).reshape(2*size,2*size)
        difference=reduced(k)-reduced(compiled[y]);result+=np.sum(abs(np.linalg.eigvalsh(difference)))/2
    return float(result)


def run():
    started=time.perf_counter();OUT.mkdir(parents=True,exist_ok=True);source=o.read_source();m=h.model(source)
    rng=np.random.default_rng(91652);cases=[];max_moment=0.;max_acquisition=0.;max_ratio=0.
    for d in (1,2,3,5):
        basis=np.linalg.qr(rng.normal(size=(d,d))+1j*rng.normal(size=(d,d)))[0]
        port=h.CommutingPhasePort(m,basis,rng.uniform(-pi,pi,d),rng.uniform(-pi,pi,d))
        for n in (3,7,15,31):
            acquired=h.acquire(m,port,n);predicted=h.expected(port,n);D=n+1
            acquisition_error=max(float(np.max(abs(acquired[y]-np.kron(predicted[y],np.eye(2))))) for y in range(D))
            norm=sum(k.conj().T@k for k in predicted.values())
            moment=sum(k.conj().T@(port._r-np.exp(2j*pi*y/D)*np.eye(d)).conj().T@
                       (port._r-np.exp(2j*pi*y/D)*np.eye(d))@k for y,k in predicted.items())
            moment_error=max(float(np.max(abs(norm-np.eye(d)))),float(np.max(abs(moment-h.rms(n)**2*np.eye(d)))))
            max_moment=max(max_moment,moment_error);max_acquisition=max(max_acquisition,acquisition_error)
            futures=[]
            for L in (1,2,3):
                words={y:sum(([('H_source' if (y+j)%2 else 'S_source'),'V'] for j in range(L-(y%2))),[]) for y in range(D)}
                norm_error,raw,compiled=h.comparison(port,n,acquired,words)
                bound=L*h.rms(n);choi_error=trace_distance_on_choi(raw,compiled,d)
                assert norm_error<=bound+1e-12 and choi_error<=min(1,bound)+1e-12
                max_ratio=max(max_ratio,norm_error/bound)
                futures.append({'maximum_queries':L,'dilation_operator_error':norm_error,'bound':bound,'joint_record_source_reference_Choi_trace_distance':choi_error})
            cases.append({'E_dimension':d,'n':n,'acquisition_forward_queries':n-1,'returned_input_operator_error':acquisition_error,
                          'moment_identity_error':moment_error,'record_selected_futures':futures})
    assert max(max_acquisition,max_moment)<1e-12

    # The spectral window is optimal for THIS first-moment objective.
    spectral=[]
    for n in (2,3,7,15,31,63):
        path=np.diag(np.ones(n-1)/2,1)+np.diag(np.ones(n-1)/2,-1)
        c=h.weights(n);alpha=np.cos(pi/(n+1));eig=np.linalg.eigvalsh(path)[-1]
        assert abs(eig-alpha)<1e-12 and np.max(abs(path@c-alpha*c))<1e-12
        spectral.append({'n':n,'sine_RMS':h.rms(n),'uniform_RMS':np.sqrt(2/n),'top_path_eigenvalue':eig})

    plans=[h.plan(m,L,eps) for L,eps in ((1,.4),(3,.2),(10,.1))]
    p=plans[0];port=h.CommutingPhasePort(m,h.f.H,[.27,-.8],[.17,1.13])
    live=h.BudgetedContinuation(m,p,port)
    for y in live.branches:
        live.step(y,'H_source');live.step(y,'V')
    actual_acquisition=h.acquire(m,port,3)
    words={0:['H_source','V','V'],1:['V'],2:['S_source','V','H_source'],3:['H_source','V']}
    circuits=[circuit(port),circuit(port,words)]
    path=OUT/'HorizonMemory.qpy'
    with path.open('wb') as handle:qpy.dump(circuits,handle)
    with path.open('rb') as handle:restored=qpy.load(handle)
    qpy_error=0.
    for index,q in enumerate(restored):
        branches=read_instrument(q)
        for y,k in branches.items():
            wanted=actual_acquisition[y]
            if index:wanted=np.kron(np.eye(2),h.compiled_word(y,4,words[y]))@wanted
            qpy_error=max(qpy_error,float(np.max(abs(k-wanted))))
    assert qpy_error<1e-12

    # No pointwise conditional guarantee follows from the joint channel bound.
    scalar=h.CommutingPhasePort(m,np.eye(1),[0],[.17]);n=31;y=16
    my=h.expected(scalar,n)[y][0,0];conditional_error=abs(np.sin((.17-2*pi*y/(n+1))/2))
    assert abs(my)**2>0 and conditional_error>10*h.rms(n)
    # A fixed acquired correction does not remain safe for unlimited reuse.
    scalar_long=h.CommutingPhasePort(m,np.eye(1),[0],[pi/100])
    long_probability=float(abs(h.expected(scalar_long,31)[0][0,0])**2)
    assert long_probability>0
    long_error=abs(np.sin(100*(pi/100)/2));assert abs(long_error-1)<1e-12

    # D=n creates an alias term; the same claimed constant is false.
    n=3;phi=pi/3;c=h.weights(n);D=n
    probabilities=[abs(sum(c[t]*np.exp(1j*t*(phi-2*pi*y/D)) for t in range(n))/np.sqrt(D))**2 for y in range(D)]
    alias_moment=sum(probabilities[y]*abs(np.exp(1j*phi)-np.exp(2j*pi*y/D))**2 for y in range(D))
    assert alias_moment>h.rms(n)**2+.1

    refused=[]
    def reject(name,fn):
        try:fn()
        except (ValueError,AssertionError,KeyError):refused.append(name)
        else:raise AssertionError('Accepted '+name)
    reject('using one acquired branch beyond its promised horizon',lambda:live.step(0,'V'))
    reject('new internal E contact',lambda:live.step(0,'H_memory'))
    bad=deepcopy(p);bad['readout_values']-=1
    reject('Fourier alias silently changes the acquired guarantee',lambda:h.verify(m,bad))
    bad=deepcopy(p);bad['horizon']+=1
    reject('longer future reuses the old error claim',lambda:h.verify(m,bad))
    bad=deepcopy(p);bad['model']='different root'
    reject('another source borrows this guarantee',lambda:h.verify(m,bad))
    class NamedPort: model=o.fingerprint(m)
    reject('name replaces a producing commuting relation',lambda:h.acquire(m,NamedPort(),3))

    result={'schema':'vi.horizon-phase-memory-checks.v1','model':m,'cases':cases,'resource_plans':plans,
        'max_acquisition_operator_error':max_acquisition,'max_moment_identity_error':max_moment,
        'max_observed_dilation_error_to_bound':max_ratio,'sine_window_spectral_checks':spectral,
        'QPY_circuits':len(restored),'QPY_max_operator_error':qpy_error,
        'rare_branch':{'probability':float(abs(my)**2),'conditional_trace_error':conditional_error,'joint_one_use_bound':h.rms(31)},
        'unlimited_reuse_counterexample':{'record':0,'probability':long_probability,'future_queries':100,'conditional_error':long_error},
        'alias_counterexample':{'n':3,'readout_values':3,'actual_moment':float(alias_moment),'inapplicable_no_alias_value':h.rms(3)**2},
        'refusals':refused,'new_QPU_jobs':0,'seconds':time.perf_counter()-started}
    (OUT/'checks.json').write_text(json.dumps(result,indent=2)+'\n')
    (OUT/'model.json').write_text(json.dumps(m,indent=2)+'\n')
    print(json.dumps({k:result[k] for k in ('max_acquisition_operator_error','max_moment_identity_error',
        'max_observed_dilation_error_to_bound','resource_plans','QPY_circuits','QPY_max_operator_error',
        'rare_branch','unlimited_reuse_counterexample','alias_counterexample','refusals','seconds')},indent=2))


if __name__=='__main__':run()
