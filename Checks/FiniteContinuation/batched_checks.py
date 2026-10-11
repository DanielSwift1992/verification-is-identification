#!/usr/bin/env python3
"""Independent path accounting, closed-form bounds and a nonquantum task."""
import argparse
from fractions import Fraction as F
from itertools import product
import json
from pathlib import Path

from batched import synthesize_batches, execute_batches
from model import problem


def check_paths(p,program):
    probes={q['id']:q for q in p['probes']}
    prices={k:F(v) for k,v in program['prices'].items()}
    costs=[];resources=[]
    for world in program['initial']:
        calls=[]
        def acquire(ids):
            calls.append(tuple(ids))
            return {key:probes[key]['replies'][world] for key in ids}
        result=execute_batches(program,acquire)
        if result['kind']=='act':assert result['action'] in p['valid'][world]
        else:assert result['kind']=='unavailable' and not p['valid'][world]
        n=sum(len(q) for q in calls)
        uses=sum(probes[key]['module_uses'] for q in calls for key in q)
        costs.append(prices['round']*len(calls)+prices['probe']*n+prices['module']*uses)
        resources.append((len(calls),n,uses))
    assert max(costs)==F(program['cost'])
    return {'maximum_rounds':max(r[0] for r in resources),
            'maximum_probes':max(r[1] for r in resources),
            'maximum_module_uses':max(r[2] for r in resources)}


def parity_selector():
    worlds=list(product((0,1),repeat=5))
    return {'valid':[{str((a^b) if s==0 else (c^d))} for s,a,b,c,d in worlds],
            'actions':{'0':{},'1':{}},
            'probes':[{'id':name,'module_uses':0,'replies':[w[i] for w in worlds]}
                      for i,name in enumerate(('selector','a','b','c','d'))]}


def two_single_probes_suffice(p):
    # Direct universal search over two-level experiments, separate from the
    # batch dynamic program. A leaf may stop early if its answer is already set.
    def common(family):return bool(set.intersection(*(set(p['valid'][i]) for i in family)))
    family=list(range(len(p['valid'])))
    for first in p['probes']:
        groups={}
        for i in family:groups.setdefault(first['replies'][i],[]).append(i)
        all_success=True
        for group in groups.values():
            if common(group):continue
            branch_success=False
            for second in p['probes']:
                children={}
                for i in group:children.setdefault(second['replies'][i],[]).append(i)
                if all(common(child) for child in children.values()):branch_success=True;break
            if not branch_success:all_success=False;break
        if all_success:return True
    return False


def checks():
    p=problem(('t',),'terminal','X');rows=[]
    for latency,contact,module in [(0,1,0),(0,1,1),(1,1,1),(2,1,1),(5,1,1),(50,1,1),('1/2','1/3','1/4')]:
        r=synthesize_batches(p,round_price=latency,probe_price=contact,module_price=module)
        l,c,d=map(F,(latency,contact,module))
        assert F(r['cost'])==min(2*l+2*c+3*d,l+3*c+4*d)
        resources=check_paths(p,r)
        rows.append({'prices':r['prices'],'optimum':r['cost'],'first_batch':r['tree']['probes'],**resources})

    other=parity_selector()
    r=synthesize_batches(other,round_price=1,probe_price=1)
    assert r['cost']=='5' and r['tree']['probes']==['selector']
    assert {tuple(child['probes']) for child in r['tree']['branches'].values()}=={('a','b'),('c','d')}
    assert not two_single_probes_suffice(other)
    # Every input coordinate is essential: a fixed batch omitting it fails.
    tables={tuple(q['replies']) for q in other['probes']}
    assert len(tables)==5
    worlds=list(product((0,1),repeat=5))
    for j in range(5):
        assert any(other['valid'][i]!=other['valid'][worlds.index(tuple(v^(k==j) for k,v in enumerate(w)))]
                   for i,w in enumerate(worlds))
    resources=check_paths(other,r)
    assert resources['maximum_rounds']==2 and resources['maximum_probes']==3

    unavailable={'valid':[set(),set()],'actions':{},'probes':[]}
    assert synthesize_batches(unavailable,round_price=1)['tree']['kind']=='unavailable'
    ambiguous={'valid':[{'yes'},{'no'}],'actions':{},'probes':[]}
    assert synthesize_batches(ambiguous,round_price=1)['tree']['kind']=='insufficient'
    try:synthesize_batches(other,round_price=-1)
    except ValueError:pass
    else:raise AssertionError('Negative cost accepted')
    try:execute_batches(r,lambda requested:{'foreign':0})
    except ValueError:pass
    else:raise AssertionError('Wrong batch identity accepted')
    return {'scope':'Exact finite ideal model, no hardware submissions',
            'T_X_costs':rows,'nonquantum_conditional_parity':{
                'sources':32,'minimum_cost':'5','all_in_one_batch_cost':'6',
                'fully_sequential_minimum_cost':'6','resources':resources,'program':r},
            'boundary_checks':['unsupported catalog','insufficient contacts','negative price','foreign receipt']}


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--output',type=Path)
    args=parser.parse_args();result=checks()
    if args.output:
        args.output.parent.mkdir(parents=True,exist_ok=True)
        args.output.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:v for k,v in result.items() if k!='nonquantum_conditional_parity'},indent=2))
    print('Nonquantum task: mixed batches cost 5; sequential or single batch cost 6.')
