#!/usr/bin/env python3
"""An acquired record becomes a working controller after the source is retired.

Scope: prepared request C=1; A,B,D,R otherwise arbitrary. Retiring A is
allowed only after its classical content has been acquired. D and R are
never measured, reset or re-prepared inside this continuation.
"""
import json
import numpy as np
from math import pi
from qiskit import QuantumCircuit,transpile
from qiskit.quantum_info import Operator
import relative_acquisition as relative
import arrival_boundary_probe as old
from pilot import require


def core(use_record=True):
    q,final=relative.core()
    d=final[3];a=final[1]
    undo=QuantumCircuit(6)
    undo.h(d);undo.h(d);undo.sdg(d);undo.h(d)
    undo=transpile(undo,basis_gates=['rz','sx','x','id','cz'],optimization_level=0)
    q.compose(undo,inplace=True)
    q.barrier(label='same_payload_recovered')
    q.reset(a)
    q.barrier(label='source_retired')
    record=next(r for r in q.cregs if r.name=='actual_a')
    if use_record:
        with q.if_test((record[0],1)):q.rz(pi,d)
    q.barrier(label='record_driven_recipient_exit')
    return q,final


def certificate(use_record=True):
    q,final=core(use_record);columns=list(range(16,32))
    total=np.zeros((16,16),complex);worst=0.;seen=set()
    for matrix,bits in relative.rows(q,final):
        actual=matrix[:,columns]
        if np.linalg.norm(actual)<1e-12:continue
        c,a=bits;require(c==1 and a not in seen,'Wrong handoff record');seen.add(a)
        reset=np.zeros((2,2),complex);reset[0,a]=1
        desired=old.expand(reset,[0],5)
        if use_record and a:desired=old.expand(np.diag([1,-1]),[2],5)@desired
        expected=desired[:,columns]
        phase=np.vdot(expected,actual)/np.vdot(expected,expected)
        worst=max(worst,float(np.max(abs(actual-phase*expected))),float(abs(abs(phase)-1)))
        total+=actual.conj().T@actual
    require(seen=={0,1} and worst<1e-10 and np.max(abs(total-np.eye(16)))<1e-10,'Handoff differs')
    return {'request_precondition':1,'free_ABDR_input_dimension':16,'branches':2,
            'uses_actual_acquired_record':use_record,'operator_residual':worst,
            'P_and_source_A_returned_zero':True,'B_preserved_conditionally_on_acquired_A':True,
            'recipient_action':'Z^a on the same D' if use_record else 'identity on the same D',
            'scope':'A is measured then retired; no preservation of its original coherence is claimed. '
                    'Actual record controls a future operation on the same unknown data, not a re-prepared payload.'}


if __name__=='__main__':print(json.dumps({str(v):certificate(v) for v in (False,True)},indent=2))
