#!/usr/bin/env python3
"""Acquire only a source-sufficient vote prefix, with a physical omission scope."""
import argparse
from copy import deepcopy
from functools import lru_cache
import json
from pathlib import Path
import subprocess

from qiskit import QuantumCircuit
from qiskit.circuit import Measure

import resident_reading_cost as cost
from environment import write,digest


def tree(rows,prefix=()):
    choices=[r for r in rows if tuple(r['votes'][:len(prefix)])==prefix]
    if not choices:raise ValueError('No source completion of this prefix')
    answers={r['answer'] for r in choices}
    if len(answers)==1:return {'prefix':list(prefix),'answer':answers.pop(),'completions':[r['votes'] for r in choices]}
    return {'prefix':list(prefix),'children':[tree(rows,prefix+(b,)) for b in (0,1)]}


@lru_cache(maxsize=2)
def current(key):return json.loads(cost.policy.repeated.wire.goal.run(['node',cost.policy.repeated.wire.goal.HERE/'resident_stopped_read_court.js','read']))


def validate(source):
    root=cost.policy.repeated.wire.goal.ROOT
    key=tuple((p,digest(root/p)) for p in sorted(source['source_sha256']))
    if dict(key)!=source['source_sha256']:raise ValueError('Stopped-reading source changed')
    key+=tuple((str(p),digest(p)) for p in [cost.policy.repeated.wire.goal.HERE/'resident_stopped_read_court.js',cost.policy.repeated.wire.goal.HERE/'resident_reading_cost_court.js',cost.policy.repeated.wire.goal.HERE/'court_bridge.js'])
    if current(key)!=source:raise ValueError('Not the current stopped-reading source')
    cost.validate(source['cost'])
    for name,value in source['candidates'].items():
        if value['rows']!=source['cost']['candidates'][name] or value['tree']!=tree(value['rows']):raise ValueError('The proposed stopping tree is not the source reading')
        if any(not leaf['prefix'] or leaf['answer']!=leaf['prefix'][-1] for leaf in leaves(value['tree'])):
            raise ValueError('This bounded lowering requires the final acquired bit itself to be the answer')


def expected_coefficients(node):
    # A report is paid at each internal node. A proper prefix has length at
    # most two. Its probability is a polynomial in the conditional P(vote=1).
    # These coefficients come from the actual tree, not the threshold name.
    if 'answer' in node:return [0,0,0]
    poly=[1]
    for bit in node['prefix']:
        factor=[0,1] if bit else [1,-1];value=[0]*(len(poly)+1)
        for i,a in enumerate(poly):
            for j,b in enumerate(factor):value[i+j]+=a*b
        poly=value
    if len(poly)>3:raise ValueError('The bounded moment interface does not describe longer prefixes')
    poly+= [0]*(3-len(poly))
    for child in node['children']:
        poly=[a+b for a,b in zip(poly,expected_coefficients(child))]
    return poly


def leaves(node):return [node] if 'answer' in node else [leaf for child in node['children'] for leaf in leaves(child)]


def select(source,packet):
    validate(source)
    if packet.get('source')!=cost.admission.fingerprint(source['cost']):raise ValueError('The cost reading has another source')
    base={'source':cost.admission.fingerprint(source),'cost_reading':deepcopy(packet)}
    if packet['kind']!='act':return {**base,'kind':'needs_evidence'}
    coefficients=[0,0,0];minimum=0;maximum=0
    for name in packet['selected']['modes']:
        t=source['candidates'][name]['tree'];coefficients=[a+b for a,b in zip(coefficients,expected_coefficients(t))]
        lengths=[len(leaf['prefix']) for leaf in leaves(t)];minimum+=min(lengths);maximum+=max(lengths)
    witness=packet['least_favourable'];m=witness['mean_interval'];s=witness['second_moment_interval'];a,b,c=coefficients
    corners=[a+b*x+c*y for x in m for y in s]
    return {**base,'kind':'act','expected_reads_coefficients':coefficients,
        'expected_report_reads_interval':[max(minimum,min(corners)-1e-11),min(maximum,max(corners)+1e-11)],
        'minimum_report_reads':minimum,'maximum_report_reads':maximum,
        'whole_output_error_upper':packet['selected']['error_upper'],
        'scope':'Same chosen fixed threshold functions, stopped at a sufficient prefix. Constructed fresh memoryless probes of one preserved true branch; unused report channel leaves the required continuation unchanged. Not minimum expected cost among all adaptive policies.'}


def emit_tree(q,node,reply,acquire):
    if 'answer' in node:
        if not node['prefix'] or node['answer']!=node['prefix'][-1]:raise ValueError('The stopped answer is not the actual last report')
        return
    acquire(node['prefix'])
    zero,one=node['children']
    if 'answer' in zero and 'answer' in one:return
    if 'answer' in one:
        with q.if_test((reply,0)):emit_tree(q,zero,reply,acquire)
    elif 'answer' in zero:
        with q.if_test((reply,1)):emit_tree(q,one,reply,acquire)
    else:
        with q.if_test((reply,0)) as otherwise:emit_tree(q,zero,reply,acquire)
        with otherwise:emit_tree(q,one,reply,acquire)


def check_control(q):
    # Observed local-stack boundary: classical-only control-flow bodies with
    # Store do not preserve this test's semantics in Aer 0.17.2/Qiskit 2.5.2.
    # Current source leaves already ARE the actual last report, so no such
    # assignment is needed. Do not silently widen the admitted fragment.
    for item in q.data:
        for block in getattr(item.operation,'blocks',()):
            if block.num_qubits==0 and any(i.operation.name=='store' for i in block.data):
                raise ValueError('Classical-only Store branch is outside the verified local execution fragment')
            check_control(block)
    return q


def compile_stopped(source,pair,packet):
    validate(source)
    if packet!=select(source,packet['cost_reading']) or packet['kind']!='act':raise ValueError('No applicable stopping construction')
    c=packet['cost_reading'];reference=cost.compile_plan(source['cost'],pair,c)
    angles=cost.orientation.expand(source['cost']['orientation'],c['request'])
    main=cost.policy.main_word(source['cost']['orientation']['policy'],angles)
    q=QuantumCircuit(5);q.add_register(*main.cregs);step=0
    for item in main.data:
        if item.operation.name!='measure':
            q.append(item.operation,[main.find_bit(b).index for b in item.qubits],list(item.clbits));continue
        if item.clbits!=(main.cregs[2][0],):raise ValueError('The current acquired reply port changed')
        retiring=main.find_bit(item.qubits[0]).index;reply=main.cregs[2][0];name=c['selected']['modes'][step]
        def acquire(prefix):
            q.reset(4);q.cx(retiring,4)
            q.append(cost.policy.repeated.readout.classical_report_channel(*pair),[4])
            path=''.join(map(str,prefix)) or 'root'
            q.append(Measure(label=f'vote:{step}:{len(prefix)}:{path}'),[4],[reply]);q.reset(4)
        emit_tree(q,source['candidates'][name]['tree'],reply,acquire);step+=1
    if step!=len(angles):raise ValueError('The entire requested word was not lowered')
    q.metadata={'stopped_source':cost.admission.fingerprint(source),'stopped_reading':cost.admission.fingerprint(packet),
        'wire_boundary':main.metadata,'modes':c['selected']['modes'],'logical_steps':len(angles),
        'requested_rotation_pairs':c['request'],'maximum_report_reads':packet['maximum_report_reads'],
        'expected_report_reads_interval':packet['expected_report_reads_interval'],
        'physical_word_error_upper':packet['whole_output_error_upper'],
        'compared_fixed_body':cost.admission.fingerprint(reference.metadata),'working_classical_bits':q.num_clbits,
        'physical_omission_scope':'Owned fresh memoryless report channel; discarded tails act identically on the preserved true branch and required continuation.',
        'backend_scope':'Local SDK construction; not asserted to satisfy the cached IBM flat-control profile.'}
    return check_control(q)


class StoppedView:
    def __init__(self,source,pair,artifact):
        validate(source);self.source=deepcopy(source);self.saved=cost.SavedCostView(source['cost'],pair,artifact)

    def request(self,wanted,risk):
        validate(self.source);return select(self.source,self.saved.request(wanted,risk))

    def working_body(self,packet):
        self.saved.check();c=packet['cost_reading']
        if packet!=self.request(c['request'],c['required_error']):raise ValueError('The stopped reading no longer applies to this acquired occurrence')
        return compile_stopped(self.source,self.saved.pair,packet)

    def admit(self,packet,candidate):
        expected=self.working_body(packet)
        if candidate.metadata!=expected.metadata or candidate!=expected or cost.policy.repeated.work.ordered_bindings(candidate)!=cost.policy.repeated.work.ordered_bindings(expected):
            raise ValueError('The actual stopped execution changed')
        return candidate


def build(output):
    output.mkdir(parents=True,exist_ok=True)
    r=json.loads(cost.policy.repeated.wire.goal.run(['node',cost.policy.repeated.wire.goal.HERE/'resident_stopped_read_court.js','build',output]))
    native=cost.policy.repeated.wire.goal.ROOT/'.build/arm64-apple-macosx/debug/Tools'
    text=cost.policy.repeated.wire.goal.run([native,'judge','where',output/'ResidentStoppedRead.swift'])
    assert f"{r['equalities']} equalities" in text and 'THE WHERE holds' in text
    for entry in r['negatives']:
        p=subprocess.run([str(native),'judge','where',str(output/entry['file'])],capture_output=True,text=True,timeout=30)
        assert p.returncode==1 and 'requires the types' in p.stdout+p.stderr
    r['native']=text.strip();write(output/'build.json',r);return r


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    print(json.dumps(build(p.parse_args().output.resolve())))
