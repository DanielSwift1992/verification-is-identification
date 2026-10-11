#!/usr/bin/env python3
"""Lower a synthesized goal policy at an existing live five-wire boundary.

No QPU sender. The source-contact dilation stays opaque to the planner.
Fixed clock slots include disposable-probe reads after early completion;
those are explicitly NOT counted as contacts with the retained service.
"""
from qiskit import ClassicalRegister
from qiskit.circuit import Measure
from qiskit.circuit.classical import expr
from qiskit.circuit.library import UnitaryGate
from qiskit_aer.library import save_density_matrix

import resident_goal_synthesis as s
import resident_goal_compiler as goal
import resident_flat_controller as flat
import resident_workbench as work
import whole_word_admission as a


def append_goal(q, source, query, service, selector, supports, index):
    """Compile all possible incoming acquired classes, not their true member."""
    s.require(selector in q.cregs and q.num_qubits==5, 'Unbound live controller or quantum ports')
    s.require(isinstance(service,UnitaryGate) and service.num_qubits==3, 'Expected opaque service on B,M,E')
    s.require(supports and all(type(k)is int and 0<=k<2**len(selector) for k in supports), 'Invalid incoming class address')
    certificates={key:s.synthesize(source,support,query) for key,support in supports.items()}
    if any(c['worst_case_contacts'] is None for c in certificates.values()):
        return {'applicable':False,'certificates':certificates}  # no mutation or source contact
    nodes=[]; starts={}; maps={}
    for key,certificate in certificates.items():
        reachable={0}; todo=[0]
        while todo:
            i=todo.pop(); row=certificate['nodes'][i]
            if row['answer'] is None:
                for j in row['next']:
                    if j not in reachable:
                        reachable.add(j); todo.append(j)
        local={i:len(nodes)+j for j,i in enumerate(sorted(reachable))}
        starts[key]=local[0]; maps[key]=local
        for i in sorted(reachable):
            row=certificate['nodes'][i]
            nodes.append({'answer':row['answer'],'relative':row['relative'], 'rank':row['rank'],
                'next':[local[j] for j in row['next']] if row['answer'] is None else None,
                'support':sorted({x[1] for x in row['pairs']}), 'certificate':key,'node':i})
    width=max(1,(len(nodes)-1).bit_length())
    state=ClassicalRegister(width,f'goal{index}_node'); previous=ClassicalRegister(width,f'goal{index}_previous')
    reply=ClassicalRegister(1,f'goal{index}_reply'); value=ClassicalRegister(1,f'goal{index}_value')
    returned=ClassicalRegister(1,f'goal{index}_answer')
    q.add_register(state,previous,reply,value,returned)
    B,M,E,D,REF=range(5)
    for key,node in starts.items():
        with q.if_test((selector,key)):
            # The checked SDK mishandles some zero-quantum-width Store-only
            # branches. An identity on disposable B supplies an explicit port.
            q.id(B); q.store(state,node)
    bound=max(c['worst_case_contacts'] for c in certificates.values())
    slot_indices=[]
    for slot in range(bound):
        q.store(previous,state); q.reset(B)
        for i,row in enumerate(nodes):
            if row['answer'] is None:
                with q.if_test((previous,i)):
                    q.append(service,[B,M,E])
        # This idle probe read cannot change DEM when no service was called.
        slot_indices.append(len(q.data))
        q.append(Measure(label=f'goal{index}:slot{slot}'),[B],[reply[0]])
        for i,row in enumerate(nodes):
            if row['answer'] is None:
                for bit in (0,1):
                    label=source['goal']['raw']['interpreter']['controls'][row['relative']^bit]['gate']
                    s.require(label in ('JointHLabel','JointSLabel'), 'Unknown source quantum emission')
                    condition=expr.logic_and(expr.equal(previous,i),expr.equal(reply[0],bool(bit)))
                    with q.if_test(condition):
                        getattr(q,{'JointHLabel':'h','JointSLabel':'s'}[label])(D)
                        q.z(E); q.cz(D,E); q.store(state,row['next'][bit])
        q.store(previous,0); q.store(reply[0],False)
    s.require(source['goal']['recipient']==['QI','QZ'], 'Recipient is not the bound source operation')
    q.store(value[0],False)
    for i,row in enumerate(nodes):
        if row['answer']==1:
            with q.if_test((state,i)):
                q.z(D); q.store(value[0],True)
    q.reset(B)
    with q.if_test((value[0],True)):
        q.x(B)
    q.append(Measure(label=f'goal{index}:answer'),[B],[returned[0]])
    q.reset(B); q.store(value[0],False)
    output={i:row['support'] for i,row in enumerate(nodes) if row['answer'] is not None}
    return {'applicable':True,'query':query,'certificates':certificates,'nodes':nodes,'starts':starts,
        'bound':bound,'selector':state,'supports':output,'answer_register':returned,
        'slot_measurement_indices':slot_indices,'source_contact_slots':bound,
        'disposable_probe_reads':bound+1}


def build(source, service, queries, *, prefix_contacts=3, snapshot=False):
    s.validate_source(source)
    plan=goal.plan(source['goal'],'continue')
    base=flat.compile(source['goal'],plan,service,prefix_contacts,snapshot=False,export=False,strategy='affine')
    expected=[('cx',[3,4]),('h',[3]),('measure',[3]),('measure',[4])]
    actual=[(i.operation.name,[base.find_bit(x).index for x in i.qubits]) for i in base.data[-4:]]
    s.require(actual==expected,'Live prefix no longer ends with the known disposable test suffix')
    q=base.copy_empty_like()
    for item in base.data[:-4]: q.append(item)
    prefix_indices=[i for i,item in enumerate(q.data) if item.operation.name=='measure']
    s.require(len(prefix_indices)==prefix_contacts,'Prefix lost actual acquisitions')
    q.reset(0); q.store(q.cregs[1],0); q.store(q.cregs[2][0],False)
    if snapshot: save_density_matrix(q,[1,2,3,4],label='live_entry',pershot=True)
    labels=plan['certificate']['classes']
    supports={c:[i for i,x in enumerate(labels) if x==c] for c in sorted(set(labels))}
    selector=q.cregs[0]; stages=[]
    for index,query in enumerate(queries):
        before=len(q.data)
        stage=append_goal(q,source,query,service,selector,supports,index)
        if not stage['applicable']:
            s.require(len(q.data)==before,'A refused goal touched the retained process')
            stages.append(stage); break
        stages.append(stage); selector=stage['selector']; supports=stage['supports']
        if snapshot: save_density_matrix(q,[1,2,3,4],label=f'goal{index}_output',pershot=True)
    serial=[]
    for stage in stages:
        serial.append({k:(v.name if isinstance(v,ClassicalRegister) else v) for k,v in stage.items()})
    import json
    q.metadata=json.loads(json.dumps({'schema':'vi.synthesized-goal-sequence.v1','source':a.fingerprint(source),
        'queries':queries,'stages':serial,'prefix_contacts':prefix_contacts,
        'prefix_measurement_indices':prefix_indices,'quantum_ports_B_M_E_D_REF':list(range(5)),
        'retained_quantum_ports':[1,2,3,4], 'snapshot':snapshot,
        'scope':'Local live continuation. No re-preparation between goals. The goal sequence is supplied before this circuit runs.',
        'hardware_acceptance_established':False,'new_QPU_jobs':0}))
    flat.check_flat_fragment(q,allow_snapshot=snapshot)
    return q,stages


def admit(source,service,queries,candidate,*,prefix_contacts=3,snapshot=False):
    expected,stages=build(source,service,queries,prefix_contacts=prefix_contacts,snapshot=snapshot)
    s.require(candidate.metadata==expected.metadata and work.ordered_bindings(candidate)==work.ordered_bindings(expected)
        and candidate==expected, 'Actual continuation differs from the current goal construction')
    return stages
