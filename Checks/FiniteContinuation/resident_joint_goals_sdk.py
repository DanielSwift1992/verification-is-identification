#!/usr/bin/env python3
"""Common classical endpoint -> measured tuple -> ONE live I/Z recipient.

The existing source contact is unchanged. No cloud client or sender.
"""
import json
from qiskit import ClassicalRegister
from qiskit.circuit import Measure
from qiskit.circuit.classical import expr
from qiskit.circuit.library import UnitaryGate
from qiskit_aer.library import save_density_matrix

import resident_joint_goals as joint
import resident_goal_synthesis as s
import resident_goal_compiler as goal
import resident_flat_controller as flat
import resident_workbench as work
import whole_word_admission as a


def build(source,service,query,*,memory='continue',snapshot=False):
    s.validate_source(source);joint.validate_request(source,query)
    s.require(memory in ('continue','first'),'The memory must be chosen before acquisition')
    s.require(isinstance(service,UnitaryGate) and service.num_qubits==3,'Opaque source service required')
    reading=source['goal']['observation'][memory]
    values=sorted(set(map(tuple,reading)))
    supports={i:[j for j,v in enumerate(reading) if tuple(v)==value] for i,value in enumerate(values)}
    certs={i:joint.synthesize(source,K,query) for i,K in supports.items()}
    if any(c['worst_case_contacts'] is None for c in certs.values()):
        return None,{'applicable':False,'certificates':certs}
    plan=goal.plan(source['goal'],'continue')
    base=flat.compile(source['goal'],plan,service,3,snapshot=False,export=False,strategy='affine')
    tail=[(x.operation.name,[base.find_bit(q).index for q in x.qubits]) for x in base.data[-4:]]
    s.require(tail==[('cx',[3,4]),('h',[3]),('measure',[3]),('measure',[4])],'Live source prefix changed')
    q=base.copy_empty_like();B,M,E,D,REF=range(5)
    retained=ClassicalRegister(1,'first_record');q.add_register(retained)
    acquired=0
    for item in base.data[:-4]:
        q.append(item)
        if item.operation.name=='measure':
            if acquired==0 and memory=='first':q.store(retained[0],item.clbits[0])
            acquired+=1
    s.require(acquired==3,'The memory was not acquired in the expected actual source prefix')
    q.reset(B);q.store(q.cregs[1],0);q.store(q.cregs[2][0],False)
    if snapshot:save_density_matrix(q,[M,E,D,REF],label='joint_entry',pershot=True)

    nodes=[];starts={}
    for key,cert in certs.items():
        reached={0};todo=[0]
        while todo:
            i=todo.pop();row=cert['nodes'][i]
            if row['answers'] is None:
                for j in row['next']:
                    if j not in reached:reached.add(j);todo.append(j)
        index={old:len(nodes)+i for i,old in enumerate(sorted(reached))};starts[key]=index[0]
        for i in sorted(reached):
            row=cert['nodes'][i]
            nodes.append({**row,'next':[index[j] for j in row['next']] if row['answers'] is None else None})
    width=max(1,(len(nodes)-1).bit_length());n=len(query['questions'])
    node=ClassicalRegister(width,'joint_node');old=ClassicalRegister(width,'joint_previous')
    reply=ClassicalRegister(1,'joint_reply');packet=ClassicalRegister(n,'joint_packet')
    returned=ClassicalRegister(n,'joint_answers');q.add_register(node,old,reply,packet,returned)
    # Continue's class code is translated by the SOURCE observation, not
    # equated by name to r. The additional first bit was copied at acquisition.
    ctl=goal.interpret(source['goal'],plan)
    for old_class,observation in enumerate(ctl['observation']):
        for key,value in enumerate(values):
            if value[0]!=observation[0]:continue
            condition=expr.equal(q.cregs[0],old_class)
            if memory=='first':condition=expr.logic_and(condition,expr.equal(retained[0],bool(value[1])))
            with q.if_test(condition):q.id(B);q.store(node,starts[key])
    q.store(retained[0],False)
    bound=max(c['worst_case_contacts'] for c in certs.values())
    for slot in range(bound):
        q.store(old,node);q.reset(B)
        for i,row in enumerate(nodes):
            if row['answers'] is None:
                with q.if_test((old,i)):q.append(service,[B,M,E])
        q.measure(B,reply[0])
        for i,row in enumerate(nodes):
            if row['answers'] is None:
                for bit in (0,1):
                    condition=expr.logic_and(expr.equal(old,i),expr.equal(reply[0],bool(bit)))
                    label=source['goal']['raw']['interpreter']['controls'][row['relative']^bit]['gate']
                    s.require(label in ('JointHLabel','JointSLabel'),'Unknown source emission')
                    with q.if_test(condition):
                        getattr(q,{'JointHLabel':'h','JointSLabel':'s'}[label])(D)
                        q.z(E);q.cz(D,E);q.store(node,row['next'][bit])
        q.store(old,0);q.store(reply[0],False)
    q.reset(B)
    if snapshot:save_density_matrix(q,[M,E,D,REF],label='joint_endpoint',pershot=True)
    for i,row in enumerate(nodes):
        if row['answers'] is not None:
            with q.if_test((node,i)):q.id(B);q.store(packet,row['code'])
    # All tuple fields are copied from this SAME endpoint. There is no
    # service contact or data operation between their actual record exports.
    for bit in range(n):
        q.reset(B)
        with q.if_test((packet[bit],1)):q.x(B)
        q.append(Measure(label=f'goal{bit}:answer'),[B],[returned[bit]])
        q.reset(B)
    q.store(packet,0)
    if snapshot:save_density_matrix(q,[M,E,D,REF],label='joint_recorded',pershot=True)
    s.require(source['goal']['recipient']==['QI','QZ'],'Recipient is not the current source I/Z')
    for code,bit in enumerate(query['recipient']):
        if bit:
            with q.if_test((returned,code)):q.z(D)
    if snapshot:save_density_matrix(q,[M,E,D,REF],label='joint_used',pershot=True)
    info={'applicable':True,'certificates':certs,'nodes':nodes,'starts':starts,'bound':bound,
          'memory':memory,'quantum_ports_B_M_E_D_REF':list(range(5)),
          'returned_register':returned.name,'prefix_contacts':3,'new_QPU_jobs':0,
          'scope':'One declared common classical endpoint, unchanged retained quantum ports, measured tuple then one recipient. No hardware admission claim.'}
    q.metadata=json.loads(json.dumps({'schema':'vi.common-endpoint-sdk.v1','source':a.fingerprint(source),
                                     'query':query,'plan':info,'snapshot':snapshot}))
    flat.check_flat_fragment(q,allow_snapshot=snapshot)
    return q,info


def admit(source,service,query,candidate,*,memory='continue',snapshot=False):
    expected,info=build(source,service,query,memory=memory,snapshot=snapshot)
    s.require(expected is not None and candidate.metadata==expected.metadata and candidate==expected and
              work.ordered_bindings(candidate)==work.ordered_bindings(expected),'Actual common-endpoint continuation differs')
    return info
