#!/usr/bin/env python3
"""Offline checks for the boundary diagnostic, before any hardware results."""
import argparse
from copy import deepcopy
import json
from pathlib import Path

import resident_boundary as g
from resident_feedback_checks import replace_instruction

REFUSALS=0
def reject(fn):
    global REFUSALS
    try:fn()
    except (AssertionError,ValueError):REFUSALS+=1;return
    raise AssertionError('Incorrect boundary packet accepted')


def remove_instruction(c,index):
    out=c.copy_empty_like()
    for j,ins in enumerate(c.data):
        if j==index:continue
        out.append(ins.operation,[out.qubits[c.find_bit(q).index] for q in ins.qubits],
                   [out.clbits[c.find_bit(q).index] for q in ins.clbits])
    return out


def independent_expected(variant,b):
    # Separate elementary Boolean interpretation of the stated experiment.
    p=0 if variant=='Toggle00' else 1;c=p;d=b
    if variant.startswith('Toggle'):p^=b
    elif variant=='Write11':p=b
    elif variant=='Install11':p=b;c=0
    if variant in ('Baseline11','DataFeedback11'):d=0
    return p,c,d


def run(directory):
    from qiskit.circuit import IfElseOp
    plan,circuits=g.load(directory,True);source=g.f.current_source();lookup={(c.metadata['variant'],c.metadata['probe']):c for c in circuits}
    for variant,axis in g.CASES:
        actual=g.ideal(lookup[variant,axis]);expected={format(i,'04b'):0. for i in range(16)}
        for b in (0,1):
            p,c,d=independent_expected(variant,b)
            weight=(1. if b==0 else 0.) if variant=='Baseline11' else .5
            expected[f'{p}{c}{d}{b}']+=weight
        assert max(abs(actual[k]-expected[k]) for k in expected)<1e-10
        spec=g.descriptor(source,variant)
        for b in (0,1):assert tuple(spec['output_PC'][b])==independent_expected(variant,b)[:2]
    c=lookup['Install11','X'].copy();i=next(i for i,x in enumerate(c.data) if x.operation.name=='if_else');ins=c.data[i]
    c=replace_instruction(c,i,IfElseOp((c.clbits[1],1),ins.operation.blocks[0]));reject(lambda:g.manifest(c))
    c=lookup['Install11','Z'];ix=[i for i,x in enumerate(c.data) if x.operation.name=='reset' and c.find_bit(x.qubits[0]).index==g.WIRES[1]][-1]
    bad=remove_instruction(c,ix);reject(lambda:g.manifest(bad))
    c=lookup['Regenerate11','Z'];ix=[i for i,x in enumerate(c.data) if x.operation.name=='reset' and c.find_bit(x.qubits[0]).index==g.WIRES[0]][-1]
    bad=remove_instruction(c,ix);reject(lambda:g.manifest(bad))
    # The ideal state may coincide without renewal. The manifest must still
    # reject removal of the actual intervention used by the diagnostic contrast.
    bad=lookup['Retain11','Z'].copy();bad.metadata=deepcopy(c.metadata)
    reject(lambda:g.manifest(bad))
    assert max(abs(g.ideal(bad)[k]-g.ideal(c)[k]) for k in g.ideal(c))<1e-10
    c=lookup['Retain11','Z'];bad=c.copy_empty_like()
    for ins in c.data:
        qs=[c.find_bit(q).index for q in ins.qubits];cs=[c.find_bit(x).index for x in ins.clbits]
        if ins.operation.name=='measure' and cs==[2]:qs=[g.WIRES[2]]
        bad.append(ins.operation,qs,cs)
    reject(lambda:g.manifest(bad))
    assert g.f.signature(bad)!=g.f.signature(c)
    # Decode all sixteen possible records under every announced rule. This
    # checks bit order and correctness predicates beyond the ideal support.
    decoded=0
    for variant in g.VARIANTS:
        for value in range(16):
            key=format(value,'04b');p,c,d,b=map(int,key);pp,cc,dd=independent_expected(variant,b)
            score,conditional=g.score({key:1024},g.descriptor(source,variant))
            assert score=={'data':1024*(d==dd),'program':1024*(p==pp),'clock':1024*(c==cc),
                           'joint':1024*((d,p,c)==(dd,pp,cc)),'record_zero':1024*(b==0)}
            assert conditional[str(b)]['n']==1024 and conditional[str(1-b)]['n']==0;decoded+=1
    reject(lambda:g.score({'0000':1023},g.descriptor(source,'Retain11')))
    rows=[]
    for variant,axis in g.CASES:
        probs=g.expected_distribution(source,variant)
        rows.append({'variant':variant,'probe':axis,'shots':1024,'counts':{k:round(1024*p) for k,p in probs.items() if p}})
    analysis=g.analyse(rows,source)
    assert all(v['questions']['joint']['frequency']==1 for v in analysis['cases'].values())
    bad=deepcopy(rows);bad[0]['probe']='Y';reject(lambda:g.analyse(bad,source))
    # A mutated type reading must not become a different implicit control law.
    fake=deepcopy(source);fake['rows'][3]['actions']['Install1']=[1,1]
    reject(lambda:g.f.source_adapter.validate(fake))
    result={'prepared_circuits_checked':16,'ideal_source_and_ISA_agree':True,'possible_records_independently_decoded':decoded,
            'runtime_refusals':REFUSALS,'explicit_intervention_preserved_even_when_ideal_endpoints_agree':True,
            'first_sender_reused':True,'real_sender_calls':0,'plan_sha256':g.f.sha((directory/'plan.json').read_bytes()),
            'test_sha256':g.f.sha(Path(__file__).read_bytes()),'simultaneous_radius':analysis['simultaneous_radius']}
    g.f.write(directory/'offline-audit.json',result);return result


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--input',required=True,type=Path)
    print(json.dumps(run(p.parse_args().input.resolve()),indent=2))
