#!/usr/bin/env python3
"""Existing certified saturation -> current-root live SDK controller.

No physical service model enters the state minimizer or control compiler.
The eight-state classical monitor and target reading are supplied by Swift.
Quantum lifting additionally uses the common acquired instrument on retained
E,M and the branch operation selected by the quotient state and actual reply.
"""
import argparse
from functools import lru_cache
import json
from pathlib import Path
import subprocess
import sys

from qiskit import QuantumCircuit,ClassicalRegister
from qiskit.circuit.library import UnitaryGate
from qiskit_aer.library import save_density_matrix

import resident_raw_reply as raw
import whole_word_admission as admission
from environment import write,digest
from build_from_source import ROOT,HERE,run
sys.path.insert(0,str(ROOT/'Checks'))
import saturate


@lru_cache(maxsize=2)
def current_source(key):return json.loads(run(['node',HERE/'resident_goal_court.js','read']))


def validate(source):
    key=tuple((p,digest(ROOT/p)) for p in sorted(source['source_sha256']))
    if dict(key)!=source['source_sha256']:raise ValueError('Goal memory source changed')
    key+=tuple((str(p),digest(p)) for p in [HERE/'resident_goal_court.js',HERE/'resident_raw_reply_court.js',HERE/'court_bridge.js'])
    if current_source(key)!=source:raise ValueError('Not the current goal reading')
    raw.validate(source['raw'])


def model(source,goal):
    validate(source)
    if goal not in source['observation']:raise ValueError('Question is absent from the current source')
    return {'name':'Resident acquired history: '+goal,'states':source['states'],
            'observation':source['observation'][goal],'operations':source['operations'],
            'source_sha256':admission.fingerprint(source),
            'scope':'Finite monitor with actual incoming reply labels; quantum DEM is not enumerated or independently reset.'}


def plan(source,goal):
    m=model(source,goal);certificate=saturate.synthesize(m);saturate.verify(m,certificate)
    return {'goal':goal,'model':m,'certificate':certificate}


def interpret(source,plan):
    expected=model(source,plan['goal'])
    if expected!=plan['model']:raise ValueError('Plan substituted its source or question')
    saturate.verify(expected,plan['certificate'])
    cert=plan['certificate'];labels=cert['classes'];q=cert['quotient'];size=len(q['observation'])
    # A quotient class must provide the actual branch operation, not merely
    # an equally named classical answer. The current goal includes R.
    emit=[]
    for cls in range(size):
        members=[i for i,x in enumerate(labels) if x==cls]
        rows=[]
        for b in (0,1):
            operations={source['raw']['interpreter']['controls'][source['observation']['continue'][i][0]^b]['gate'] for i in members}
            if len(operations)!=1:raise ValueError('One memory class selects different quantum actions')
            rows.append(next(iter(operations)))
        emit.append(rows)
    return {'size':size,'width':max(1,(size-1).bit_length()),'emit':emit,'next':q['operations'],
            'observation':q['observation'],'initial':[labels[i] for i in source['initial']]}


def transport(source,old,new):
    old_ctl,new_ctl=interpret(source,old),interpret(source,new)
    a,b=old['certificate']['classes'],new['certificate']['classes'];mapping={}
    for i,(u,v) in enumerate(zip(a,b)):
        if u in mapping and mapping[u]!=v:
            j=next(j for j in range(i) if a[j]==u and b[j]!=v)
            return {'available':False,'pair':[j,i],'states':[source['states'][j],source['states'][i]],
                    'old_class':u,'new_classes':[b[j],v],
                    'reason':'The old live reading does not identify the requested new memory state.'}
        mapping[u]=v
    table=[mapping[i] for i in range(len(mapping))]
    for u,v in enumerate(table):
        for b in (0,1):
            if table[old_ctl['next']['reply'+str(b)][u]]!=new_ctl['next']['reply'+str(b)][v]:raise ValueError('Transport lost a next-state relation')
            if old_ctl['emit'][u][b]!=new_ctl['emit'][v][b]:raise ValueError('Transport changes the continued quantum action')
    return {'available':True,'map':table,'all_next_states_and_quantum_emissions_checked':True}


def compile(source,plan,service,contacts):
    ctl=interpret(source,plan)
    if type(contacts)is not int or not 1<=contacts<=64:raise ValueError('Contact budget must be 1 through 64')
    if not isinstance(service,UnitaryGate) or service.num_qubits!=3:raise ValueError('Opaque local service dilation required')
    service=service.copy();service.label='unmodelled_service'
    q=QuantumCircuit(5);state=ClassicalRegister(ctl['width'],'current');out=ClassicalRegister(3,'out');q.add_register(state,out)
    B,M,E,D,REF=0,1,2,3,4
    q.h(D);q.cx(D,REF);q.h(E);q.cx(E,M)
    def acquire():q.reset(B);q.append(service,[B,M,E]);q.measure(B,out[0])
    def gate(label):getattr(q,{'JointHLabel':'h','JointSLabel':'s'}[label])(D)
    acquire()
    with q.if_test((out[0],1)) as otherwise:
        gate(source['raw']['interpreter']['controls'][1]['gate']);q.store(state,ctl['initial'][1])
    with otherwise:
        gate(source['raw']['interpreter']['controls'][0]['gate']);q.store(state,ctl['initial'][0])
    q.z(E);q.cz(D,E);q.store(out[0],False)
    if contacts>1:
        with q.for_loop(range(contacts-1)):
            acquire()
            # Switch samples the old class once; updating it inside a case
            # must not accidentally execute a second matching case.
            with q.switch(state) as case:
                for old in range(ctl['size']):
                    with case(old):
                        with q.if_test((out[0],1)) as otherwise:
                            gate(ctl['emit'][old][1]);q.store(state,ctl['next']['reply1'][old])
                        with otherwise:
                            gate(ctl['emit'][old][0]);q.store(state,ctl['next']['reply0'][old])
            q.z(E);q.cz(D,E);q.store(out[0],False)
    # Same I/Z recipient for every question. Which bit it receives is read
    # from the source and preserved by saturation; not chosen by a goal name.
    if source['recipient']!=['QI','QZ']:raise ValueError('Unsupported source recipient')
    marked=[i for i,v in enumerate(ctl['observation']) if v[1]]
    if marked:
        with q.switch(state) as case:
            with case(*marked):q.z(D)
    save_density_matrix(q,[M,E,D,REF],label='continued',pershot=True)
    q.cx(D,REF);q.h(D);q.measure(D,out[1]);q.measure(REF,out[2])
    q.metadata={'source':admission.fingerprint(source),'plan':admission.fingerprint(plan),'contacts':contacts,
                'controller_width':ctl['width'],'classes':ctl['size'],'qubit_ports':[B,M,E,D,REF],
                'goal':plan['goal'],'retained_quantum_ports':[D,E,M],'new_QPU_jobs':0}
    return q


def build(directory):
    directory.mkdir(parents=True,exist_ok=True)
    result=json.loads(run(['node',HERE/'resident_goal_court.js','build',directory]))
    native=ROOT/'.build/arm64-apple-macosx/debug/Tools';text=run([native,'judge','where',directory/'ResidentGoalMemory.swift'])
    assert f"{result['equalities']} equalities" in text and 'THE WHERE holds' in text
    for entry in result['negatives']:
        p=subprocess.run([str(native),'judge','where',str(directory/entry['file'])],capture_output=True,text=True,timeout=30)
        assert p.returncode==1 and 'requires the types' in p.stdout+p.stderr
    result['native']=text.strip();result['saturation_implementation_sha256']=digest(ROOT/'Checks/saturate.py')
    source=json.loads((directory/'goal-reading.json').read_text())
    plans={g:plan(source,g) for g in source['observation']}
    write(directory/'plans.json',plans);write(directory/'build.json',result)
    return {g:interpret(source,p)['size'] for g,p in plans.items()}


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    print(json.dumps(build(p.parse_args().output.resolve())))
