#!/usr/bin/env python3
"""Bounded SDK loop from the existing raw-reply root; no new VI evaluator.

One acquired R bit controls the next gate. The measured scratch bit can be
overwritten after its effect enters R. E,M remain live. The SDK owns loop
iteration; its program/counter resources are not called constant memory.
"""
import json
from pathlib import Path

from qiskit import QuantumCircuit,ClassicalRegister
from qiskit.circuit.classical import expr
from qiskit.circuit.library import UnitaryGate
from qiskit_aer.library import save_density_matrix

import resident_raw_reply as raw
import resident_acquisition as acquisition
import whole_word_admission as admission
from build_from_source import HERE,run


def reading():
    result=json.loads(run(['node',HERE/'resident_raw_reply_court.js','read']))
    raw.validate(result);return result


def finite_control(source):
    raw.validate(source)
    control=source['interpreter']['acquisition'];commands=source['interpreter']['controls']
    assert [x['next'] for x in commands]==[1,0]
    assert [x['gate'] for x in commands]==['JointHLabel','JointSLabel']
    for b in (0,1):
        assert acquisition.relative_table(control,'Install'+str(b))=={0:b,1:b}
        assert acquisition.relative_table(control,'Toggle'+str(b))=={0:b,1:1^b}
    return commands


def compile(source,service,contacts,*,archive=False,snapshot=True):
    """Fixed contact family with no history access except acquired R.

    archive=True is a reference implementation for the bounded audit. It
    keeps every acquired bit; it is not the compact streaming interface.
    """
    commands=finite_control(source)
    if type(contacts)is not int or not 1<=contacts<=64:raise ValueError('Bounded SDK contact count is 1 through 64')
    if not isinstance(service,UnitaryGate) or service.num_qubits!=3:raise ValueError('Opaque E,M,probe contact required')
    service=service.copy();service.label='unmodelled_service'
    B,M,E,D,REF=0,1,2,3,4
    q=QuantumCircuit(5);out=ClassicalRegister(4,'out');q.add_register(out)
    history=ClassicalRegister(contacts,'history') if archive else None
    if archive:q.add_register(history)
    q.h(D);q.cx(D,REF);q.h(E);q.cx(E,M)

    def contact(bit,install):
        q.reset(B);q.append(service,[B,M,E]);q.measure(B,bit)
        q.store(out[0],bit if install else expr.bit_xor(out[0],bit))
        for r in (0,1):
            with q.if_test((out[0],r)):
                getattr(q,{'JointHLabel':'h','JointSLabel':'s'}[commands[r]['gate']])(D)
        q.z(E);q.store(out[0],expr.logic_not(out[0]));q.cz(D,E)
        if not archive:q.store(out[1],False)

    contact(history[0] if archive else out[1],True)
    if archive:
        for i in range(1,contacts):contact(history[i],False)
    elif contacts>1:
        with q.for_loop(range(contacts-1)):contact(out[1],False)
    if snapshot:save_density_matrix(q,[M,E,D,REF],label='continued',pershot=True)
    q.cx(D,REF);q.h(D);q.measure(D,out[2]);q.measure(REF,out[3])
    q.metadata={'source':admission.fingerprint(source),'contacts':contacts,
        'retained_ports':[E,M],'controller_bits':[0],'scratch_bits':[] if archive else [1],
        'export':'current R and continued DEM; terminal Bell read is only an audit recipient',
        'history_exported':archive,'snapshot':snapshot,'new_QPU_jobs':0}
    return q


def profile(q):
    """Inventory only. It does not infer semantics from instruction names."""
    def walk(body):
        result=[]
        for item in body.data:
            op=item.operation
            result.append(op.name)
            for block in getattr(op,'blocks',()):result+=walk(block)
        return result
    names=walk(q)
    return {'quantum_qubits':q.num_qubits,'declared_classical_bits':q.num_clbits,
        'controller_bits':1,'scratch_bits':len(q.metadata['scratch_bits']),
        'archive_bits':q.metadata['contacts'] if q.metadata['history_exported'] else 0,
        'top_level_instructions':len(q.data),'recursive_instruction_nodes':len(names),
        'for_loop_nodes':names.count('for_loop'),'contact_instruction_nodes':names.count('unitary'),
        'actual_contacts':q.metadata['contacts'],
        'loop_iteration_resource':'SDK-owned bounded loop, not an unbounded autonomous clock'}
