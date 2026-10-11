#!/usr/bin/env python3
"""Unknown frame and mechanism: actual acquisition, retained source, new use."""
from copy import deepcopy
from itertools import product
import json
import time

import numpy as np
from qiskit import QuantumCircuit,ClassicalRegister,qpy
from qiskit.circuit.library import UnitaryGate
from qiskit.quantum_info import Operator

import orbit_return as o
import memory_future_admission as f
import acquired_memory_capability as a

OUT=o.ROOT/'Research/Artifacts/returning-attempt-20260916/acquired-memory'


def raw_future(port,word):
    matrix=np.eye(2*port.dimension,dtype=complex)
    for name in word:
        if name=='V':matrix=port.forward(matrix)
        else:matrix=np.kron(np.eye(port.dimension),f.H if name=='H_source' else f.S)@matrix
    return matrix


def key_name(key):return 'quantum' if key[0] else 'classical_'+str(key[1])


def build_circuit(port,word):
    q=QuantumCircuit(3);h=ClassicalRegister(1,'mode');z=ClassicalRegister(1,'working_bit')
    q.add_register(h,z);q.h(2)
    def query():q.append(UnitaryGate(port._unitary,label='same_opaque_contact'),[0,1])
    def episode(count,record):
        q.swap(0,2)
        for _ in range(count):query()
        q.h(0);q.measure(0,record[0]);q.h(0);q.swap(0,2)
        with q.if_test((record[0],1)):q.z(2)
    episode(4,h)
    with q.if_test((h[0],0)):episode(1,z)
    q.barrier(label='old_source_and_probe_returned')
    for name in word:
        if name=='V':
            with q.if_test((h[0],1)):query()
            with q.if_test((h[0],0)):
                with q.if_test((z[0],1)):q.z(0)
        elif name=='H_source':q.h(0)
        elif name=='S_source':q.s(0)
        else:raise AssertionError(name)
    return q


def expand(matrix,wires):
    out=np.zeros((8,8),complex)
    for col in range(8):
        j=sum(((col>>q)&1)<<i for i,q in enumerate(wires));base=col&~sum(1<<q for q in wires)
        for i in range(2**len(wires)):
            row=base|sum(((i>>bit)&1)<<q for bit,q in enumerate(wires));out[row,col]=matrix[i,j]
    return out


def independent_instrument(q):
    initial=np.zeros((8,4),complex);initial[:4]=np.eye(4)
    branches=[{'map':initial,'bits':[0]*q.num_clbits,'reads':0}]
    def visit(body,rows,wires,cbits):
        for item in body.data:
            op=item.operation;qs=[wires[body.find_bit(b).index] for b in item.qubits]
            cs=[cbits[body.find_bit(b).index] for b in item.clbits]
            if op.name=='barrier':continue
            if op.name=='if_else':
                bit,wanted=op.condition;index=cbits[body.find_bit(bit).index];after=[]
                for row in rows:
                    branch=0 if row['bits'][index]==wanted else 1
                    after.extend(visit(op.blocks[branch],[row],qs,cs) if branch<len(op.blocks) else [row])
                rows=after
            elif op.name=='measure':
                assert qs==[0];after=[]
                for row in rows:
                    for answer in (0,1):
                        p=np.zeros((2,2),complex);p[answer,answer]=1
                        bits=row['bits'].copy();bits[cs[0]]=answer
                        after.append({'map':expand(p,qs)@row['map'],'bits':bits,'reads':row['reads']+1})
                rows=after
            else:
                assert op.name in ('unitary','swap','h','s','z')
                matrix=expand(Operator(op).data,qs)
                for row in rows:row['map']=matrix@row['map']
        return rows
    result={}
    for row in visit(q,branches,list(range(3)),list(range(q.num_clbits))):
        h,z=row['bits'];key=(h,None if h else z)
        assert row['reads']==(1 if h else 2)
        # Independent check that contracting P is a returned tensor factor.
        matrix=np.kron(a.PLUS.conj()[None,:],np.eye(4))@row['map']
        assert np.max(abs(row['map']-np.kron(a.PLUS[:,None],matrix)))<1e-12
        result[key]=matrix
    assert set(result)=={(0,0),(0,1),(1,None)}
    return result


def branch_effects(live,key,effect):
    h,z=key;output=np.kron(f.I,effect) if h else effect
    return sum(k.conj().T@output@k for k in live.branches[key])


def run():
    started=time.perf_counter();OUT.mkdir(parents=True,exist_ok=True);source=o.read_source();m=a.model(source)
    base=o.model(source);assert base['q'][:2]==[0,0] and base['f'][:2]==[0,0]
    rng=np.random.default_rng(91648)
    frames=[f.I,f.H,np.linalg.qr(rng.normal(size=(2,2))+1j*rng.normal(size=(2,2)))[0]]
    cases=[];circuits=[];expected=[];descriptions=[];classical_model_ids=set()
    word=['H_source','V','S_source','V','H_source','V']
    certificates={kind:f.build(f.interface(source,kind)) for kind in ('common_factor','phase_memory','rotating_memory')}
    for kind,frame_index in product(certificates,range(len(frames))):
        b=frames[frame_index];port=a.HiddenFrameDevice(m,kind,b);classical_model_ids.add(port.model)
        acquisition=a.Acquisition(m,port);live=acquisition.acquire()
        h_b=b@f.H@b.conj().T;z_b=b@f.Z@b.conj().T
        expected_branches={key:np.zeros((4,4),complex) for key in acquisition.full_branches}
        if kind=='common_factor':expected_branches[(0,1)]=np.kron(h_b,f.I)
        elif kind=='phase_memory':
            for z in (0,1):expected_branches[(0,z)]=np.kron((f.I+(-1)**z*z_b)/2,f.I)
        else:expected_branches[(1,None)]=np.eye(4)
        acquisition_error=max(float(np.max(abs(acquisition.full_branches[key]-matrix))) for key,matrix in expected_branches.items())
        norm_error=float(np.max(abs(live.source_effect(f.I)-np.eye(4))))
        assert max(acquisition_error,norm_error)<1e-12
        # All actual future-basis witnesses, conjugated by an unknown frame.
        future_error=0.
        for witness in certificates[kind]['basis'].values():
            follow=live.audit_after(witness['word']);raw=raw_future(port,witness['word'])
            terminal=f.PAULI[witness['terminal'][1]]
            future_error=max(future_error,float(np.max(abs(follow.source_effect(terminal)-raw.conj().T@np.kron(f.I,terminal)@raw))))
        assert future_error<1e-12
        # Continue one retained instrument through a stream; no caller supplies
        # kind, basis, z or the input state to any policy decision.
        names=['V','H_source','S_source'];stream=[names[int(rng.integers(3))] for _ in range(27)]
        raw=np.eye(4,dtype=complex);stream_error=0.
        for name in stream:
            live.step(name);raw=raw_future(port,[name])@raw
            for terminal in (f.I,f.X,f.Y,f.Z):
                stream_error=max(stream_error,float(np.max(abs(live.source_effect(terminal)-raw.conj().T@np.kron(f.I,terminal)@raw))))
        assert stream_error<1e-12
        supports={key_name(key):float(np.trace(k.conj().T@k).real/4) for key,k in acquisition.full_branches.items()}
        cases.append({'audit_hidden_kind':kind,'audit_frame':frame_index,'operator_acquisition_residual':acquisition_error,
            'completeness_residual':norm_error,'all_future_basis_residual':future_error,'stream_steps':len(stream),
            'stream_effect_residual':stream_error,'record_weights_on_maximally_mixed_input':supports,
            'acquisition_cost_by_record':{key_name(key):v for key,v in acquisition.costs.items()},
            'actual_future_V_by_record':{key_name(key):v for key,v in live.future_V.items()}})
        fresh=a.Acquisition(m,port).acquire();compiled=fresh.audit_after(word)
        circuits.append(build_circuit(port,word));expected.append(compiled)
        descriptions.append({'audit_kind':kind,'audit_frame':frame_index,'word':word,'model':port.model})
    assert len(classical_model_ids)==1

    qpy_path=OUT/'AcquiredMemoryCapability.qpy'
    with qpy_path.open('wb') as handle:qpy.dump(circuits,handle)
    with qpy_path.open('rb') as handle:restored=qpy.load(handle)
    qpy_error=0.
    for q,wanted in zip(restored,expected):
        actual=independent_instrument(q)
        for key,matrix in actual.items():
            for effect in (f.I,f.X,f.Y,f.Z):
                raw=matrix.conj().T@np.kron(f.I,effect)@matrix
                qpy_error=max(qpy_error,float(np.max(abs(raw-branch_effects(wanted,key,effect)))))
    assert qpy_error<1e-12 and len(restored)==9

    # The acquired bit cannot be replaced by an independent bit with the same
    # marginal. Bell(SE) produces a uniform but correlated working bit.
    phase=a.HiddenFrameDevice(m,'phase_memory',f.I);acq=a.Acquisition(m,phase);learned=acq.acquire()
    bell=np.array([1,0,0,1],complex)/np.sqrt(2);rho=np.outer(bell,bell.conj())
    real=learned.audit_after(['H_source','V']);effect=(f.I+f.X)/2
    actual_probability=float(np.trace(real.source_effect(effect)@rho).real)
    no_record=sum(k@rho@k.conj().T for key,maps in learned.branches.items() if key[0]==0 for k in maps)
    independently_read=0.
    for z in (0,1):
        u=(f.Z if z else f.I)@f.H
        independently_read+=float(np.trace(effect@u@no_record@u.conj().T).real)/2
    assert abs(actual_probability-1)<1e-12 and abs(independently_read-.5)<1e-12
    # A new arbitrary data input can use z: in the phase case the measured E
    # projector intertwines the real contact with Z^z on that NEW input.
    new_input_error=0.
    for b in frames:
        port=a.HiddenFrameDevice(m,'phase_memory',b)
        for z in (0,1):
            p=(f.I+(-1)**z*b@f.Z@b.conj().T)/2
            new_input_error=max(new_input_error,float(np.max(abs(port.forward(np.kron(p,f.I))-np.kron(p,f.Z if z else f.I)))))
    assert new_input_error<1e-12

    # Four-return testing is not a certificate of an unrestricted unknown
    # unitary. I/S on E has V^4=I but does not furnish the phase/common repair.
    class OutsideFamily:
        model=o.fingerprint(m);owner=object();dimension=2
        _unitary=f.controlled((f.I,f.S))
        def forward(self,matrix):return (self._unitary if len(matrix)==4 else np.kron(f.I,self._unitary))@matrix
    impostor=OutsideFamily();modes=a.probe_episode(impostor,a.INITIAL,4)
    assert np.max(abs(a.ready_map(modes[0])-np.eye(4)))<1e-12
    wrong={z:a.ready_map(k) for z,k in a.probe_episode(impostor,modes[0],1).items()}
    v=np.kron(np.array([0,1]),a.PLUS);r=np.outer(v,v.conj());target=(f.I+f.Y)/2
    original=float(np.trace(np.kron(f.I,target)@impostor._unitary@r@impostor._unitary.conj().T).real)
    proposed=0.
    for z,k in wrong.items():
        out=k@r@k.conj().T;reduced=np.trace(out.reshape(2,2,2,2),axis1=0,axis2=2)
        zz=f.Z if z else f.I;proposed+=float(np.trace(target@zz@reduced@zz).real)
    assert abs(original-1)<1e-12 and abs(proposed-.5)<1e-12

    rejected=[]
    def reject(name,fn):
        try:fn()
        except (ValueError,AssertionError,KeyError):rejected.append(name)
        else:raise AssertionError('Accepted '+name)
    reject('a matching label without the producing family',lambda:a.Acquisition(m,impostor))
    reject('continuation before acquisition',lambda:a.LearnedContinuation(a.Acquisition(m,phase)))
    reject('reprepare an already acquired source',lambda:acq.acquire())
    reject('new internal memory access without new boundary',lambda:learned.step('H_memory'))
    changed=deepcopy(m);changed['source_domain']='different source'
    reject('same port attached to a different current root',lambda:a.Acquisition(changed,phase))
    original_owner=phase.owner;phase.owner=object()
    reject('retained ability used as a claim about a replacement contact',lambda:learned.step('V'))
    phase.owner=original_owner

    # The mechanism labels above are examples, not the scope boundary. The
    # same policy accepts two producing OPERATOR RELATIONS on arbitrary E.
    general=[]
    for dimension in (1,2,3,4,5):
        bases=[np.linalg.qr(rng.normal(size=(dimension,dimension))+1j*rng.normal(size=(dimension,dimension)))[0]
               for _ in range(2)]
        roots=[int(x) for x in rng.integers(4,size=dimension)];signs=[1 if x%2==0 else -1 for x in range(dimension)]
        low=a.HiddenRelationDevice(m,roots,bases[0],signs=signs)
        high=a.HiddenRelationDevice(m,roots,bases[0],roots1=[int(x) for x in rng.integers(4,size=dimension)],basis1=bases[1])
        for relation,port in (('commuting_binary_relative',low),('opposite_fourth_powers',high)):
            acquisition=a.Acquisition(m,port);live=acquisition.acquire();u0=port._unitary[0::2,0::2];u1=port._unitary[1::2,1::2]
            fourth=max(float(np.max(abs(np.linalg.matrix_power(u0,4)-np.eye(dimension)))),
                       float(np.max(abs(np.linalg.matrix_power(u1,4)-(1 if relation=='commuting_binary_relative' else -1)*np.eye(dimension)))))
            expected={key:np.zeros((2*dimension,2*dimension),complex) for key in acquisition.full_branches}
            if relation=='commuting_binary_relative':
                r=u0.conj().T@u1
                for z in (0,1):expected[(0,z)]=np.kron(u0@(np.eye(dimension)+(-1)**z*r)/2,f.I)
            else:expected[(1,None)]=np.eye(2*dimension)
            branch_error=max(float(np.max(abs(k-expected[key]))) for key,k in acquisition.full_branches.items())
            # The next word may itself depend on the acquired record. Compare
            # each unnormalized branch with actual reuse of that SAME E.
            adaptive_error=0.
            chosen={(0,0):['V','H_source','V'],(0,1):['H_source','S_source','V','V'],
                    (1,None):['V','V','H_source','S_source','V']}
            for key,word in chosen.items():
                candidate=live.audit_after(word);raw_branch=raw_future(port,word)@acquisition.full_branches[key]
                for effect in (f.I,f.X,f.Y,f.Z):
                    out=np.kron(np.eye(dimension),effect) if key[0] else effect
                    actual=sum(k.conj().T@out@k for k in candidate.branches[key])
                    wanted=raw_branch.conj().T@np.kron(np.eye(dimension),effect)@raw_branch
                    adaptive_error=max(adaptive_error,float(np.max(abs(actual-wanted))))
            stream_error=0.;raw=np.eye(2*dimension,dtype=complex)
            for name in ['V','H_source','V','S_source','V','H_source']*4:
                live.step(name);raw=raw_future(port,[name])@raw
                for effect in (f.I,f.X,f.Y,f.Z):
                    stream_error=max(stream_error,float(np.max(abs(live.source_effect(effect)-raw.conj().T@np.kron(np.eye(dimension),effect)@raw))))
            assert max(fourth,branch_error,stream_error,adaptive_error)<1e-12
            general.append({'relation':relation,'memory_dimension':dimension,'input_dimension':2*dimension,
                'fourth_power_residual':fourth,'acquisition_branch_residual':branch_error,'stream_steps':24,
                'record_selected_continuation_residual':adaptive_error,'all_input_source_effect_residual':stream_error})

    result={'schema':'vi.acquired-memory-capability-checks.v1','cases':cases,'operator_relation_cases':general,
        'controller_model_count':len(classical_model_ids),'independent_dynamic_QPY_count':len(restored),
        'independent_dynamic_QPY_residual':qpy_error,'new_input_intertwining_residual':new_input_error,
        'same_marginal_wrong_record':{'acquired_correlated_record':actual_probability,'independent_record':independently_read},
        'outside_family_four_return_counterexample':{'original_Yplus':original,'wrong_classical_replacement_Yplus':proposed},
        'rejected_applications':rejected,'new_QPU_jobs':0,'seconds':time.perf_counter()-started,
        'scope':'One policy for two declared operator-relation families on arbitrary finite E, with three unknown-frame examples. Arbitrary initial SE/reference. Protected probe/swap access explicit. Four/five queries are constructions, not proved minima.'}
    for name,value in (('checks.json',result),('model.json',m),('QPY-programs.json',descriptions)):
        (OUT/name).write_text(json.dumps(value,indent=2)+'\n')
    print(json.dumps({k:result[k] for k in ('controller_model_count','independent_dynamic_QPY_count','independent_dynamic_QPY_residual',
          'new_input_intertwining_residual','same_marginal_wrong_record','outside_family_four_return_counterexample','rejected_applications','seconds')},indent=2))


if __name__=='__main__':run()
