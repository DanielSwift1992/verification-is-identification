#!/usr/bin/env python3
"""Coherent composition before acquisition; different future-memory contract.

The old two classical readings are not treated as a coherent interface.
Here the declared unitary contacts and controlled backaction repair allow
composition before observation. This capability is explicit and essential.
"""
import json
from math import pi
import numpy as np
from qiskit import QuantumCircuit, ClassicalRegister, transpile
from qiskit.circuit.classical import expr
from qiskit.quantum_info import Operator
import arrival_failure_localization as diag
import arrival_boundary_probe as old
from pilot import require


def word_certificate():
    # P,A,B,D in little-endian order; repair CZ(P,D) follows each contact.
    word=QuantumCircuit(4)
    word.cx(2,0);word.cz(0,3);word.cz(0,3)
    word.cx(1,0);word.cx(2,0);word.cz(0,3);word.cz(0,3)
    target=QuantumCircuit(4);target.cx(1,0)
    error=float(np.max(abs(Operator(word).data-Operator(target).data)))
    require(error<1e-12,'Coherent contact composition differs')
    # Remote CX(A,P) via B restores arbitrary B; no prepared intermediary.
    bridge=QuantumCircuit(3)
    bridge.cx(1,0);bridge.cx(2,1);bridge.cx(1,0);bridge.cx(2,1)
    want=QuantumCircuit(3);want.cx(2,0)
    bridge_error=float(np.max(abs(Operator(bridge).data-Operator(want).data)))
    require(bridge_error<1e-12,'Bridge consumes or changes B')
    return {'coherent_word_dimension':16,'word_residual':error,'bridge_dimension':8,
            'bridge_residual':bridge_error,
            'premise':'Coherent unitary contacts and controlled cancellation of their known CZ(P,D) backaction; not classical-only answers.'}


def core():
    original=diag.contexts()['conditional']
    final=diag.read(diag.OLD/'plan.json')['PUBs'][0]['final_layout']
    require(final==[0,2,1,3,4,5],'Different physical source map')
    cut=next(i for i,x in enumerate(original.data) if x.operation.name=='barrier'
             and x.operation.label=='arrival_read')
    request=next(r for r in original.cregs if r.name=='actual_arrival')
    answer=ClassicalRegister(1,'actual_a')
    q=QuantumCircuit(6);q.add_register(request,answer)
    for ins in original.data[:cut+1]:q.append(ins)
    bridge=QuantumCircuit(6)
    bridge.cx(1,0);bridge.cx(2,1);bridge.cx(1,0);bridge.cx(2,1)
    bridge=transpile(bridge,basis_gates=['rz','sx','x','id','cz'],optimization_level=0)
    with q.if_test((request[0],1)):
        for ins in bridge.data:q.append(ins)
    # Same native intermediate measurement, a different result destination.
    measure=next(x.operation for x in original.data[cut+1:] if x.operation.name=='measure_2')
    q.append(measure,[0],[answer[0]])
    with q.if_test((answer[0],1)):q.x(0)
    q.barrier(label='relative_answer_returned')
    work=[x for x in original.data if x.operation.name=='if_else'
          and isinstance(x.operation.condition,tuple)][-1]
    q.append(work)
    with q.if_test(expr.logic_and(request[0],answer[0])):q.rz(pi,3)
    q.barrier(label='relative_exit')
    return q,final


def rows(q,final):
    # Read-only adapter to the frozen three-classical-slot interpreter.
    # The pad is not submitted to hardware and carries no acquired evidence.
    require(q.num_clbits==2,'Unexpected instrument record')
    padded=q.copy();padded.add_register(ClassicalRegister(1,'interpreter_unused_pad'))
    for matrix,bits in old.native_rows(padded,final):
        require(bits[2]==0,'Interpreter padding became an observation')
        yield matrix,bits[:2]


def certificate():
    word=word_certificate();q,final=core()
    u=old.expand(old.HGate().to_matrix()@old.SGate().to_matrix()@old.HGate().to_matrix(),[2],5)
    total=np.zeros((32,32),complex);worst=0.;seen=set()
    for actual,(c,a) in rows(q,final):
        require((c,a) not in seen,'Repeated acquired branch');seen.add((c,a))
        target=old.expand(old.HGate().to_matrix(),[2],5)@u if c else u
        expected=target@old.projection(request=c,a=a if c else None)
        require(c or a==0,'Absent request acquired a law bit')
        phase=np.vdot(expected,actual)/np.vdot(expected,expected)
        worst=max(worst,float(np.max(abs(actual-phase*expected))),float(abs(abs(phase)-1)))
        total+=actual.conj().T@actual
    require(seen=={(0,0),(1,0),(1,1)} and worst<1e-10
            and np.max(abs(total-np.eye(32)))<1e-10,'Wrong relative-acquisition instrument')
    return {'word':word,'full_input_dimension':32,'branches':3,'operator_residual':worst,
            'returns_P_zero':True,'absent_request_preserves_AB':True,
            'active_request_measures_A_and_preserves_B':True,
            'scope':'Full arbitrary joint input AB,D,R,C. Compared target is a new instrument preserving B; not the old five-branch instrument.'}


if __name__=='__main__':print(json.dumps(certificate(),indent=2))
