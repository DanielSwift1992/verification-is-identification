#!/usr/bin/env python3
"""Compare exact change detection with full key refresh in the current model.

The key applications are type-certified separately. This program checks
finite decision trees and their minima; it does not claim that a verifier has
proved a physical no-drift assumption.
"""
import argparse
import json
from pathlib import Path

from build_from_source import HERE,run
from planner import synthesize,execute
from audit import depth_bound,fixed_bound


def check(directory):
    r=json.loads((directory/'source-reading.json').read_text())
    result=json.loads((directory/'result.json').read_text())
    assert r['source_sha256']==result['source_sha256']
    assert json.loads(run(['node',HERE/'renewal_court.js','read']))==r
    cases=json.loads((directory/'cases.json').read_text())
    partitions={}
    for p in sorted(r['probes'],key=lambda p:(p['control_gates'],p['id'])):
        bits=tuple(p['replies']);part=min(bits,tuple(1-b for b in bits));partitions.setdefault(part,p)
    probes=list(partitions.values());columns={p['id']:p['replies'] for p in probes}
    expected={'known_A_X':0,'paired_Z':0,'same_Pauli':1,'A_only':2,'B_only':2,'one_unspecified_module':2,'arbitrary':3}
    plans=[];summary={}
    for c in cases:
        old=c['old_key'];rows=tuple(frozenset(['same' if k==old else 'changed']) for k in r['keys'])
        p={'valid':[list(row) for row in rows],
           'actions':{a:{'physical_gates':0} for a in ('same','changed')},'probes':probes}
        plan=synthesize(p,c['family']);depth=depth_bound(rows,columns,c['family']);fixed,_=fixed_bound(rows,columns,c['family'])
        assert plan['tree']['cost'][0]==depth==fixed==expected[c['profile']]
        for i in c['family']:
            assert execute(plan,lambda q:columns[q][i])['action'] in rows[i]
        plans.append({'profile':c['profile'],'old_key':old,'plan':plan})
        summary[c['profile']]={'minimum_verification_queries':depth,
                               'minimum_full_refresh_queries':c['plan']['tree']['cost'][0]}

    # Positive repair: under the one-module relation, q/p first, S only when p
    # changed. This requires at most three probes, and just two on every branch
    # where the key can be inferred without determining which module flipped X.
    primary={}
    for middle,prep,name in [([], 'X','q'),([], 'Z','p'),(['s'],'X','k')]:
        primary[name]=next(p for p in r['probes'] if p['middle']==middle and p['prep']==prep)['replies']
    lengths=[]
    for c in cases:
        if c['profile']!='one_unspecified_module':continue
        q0,p0,u0=c['old_key']
        for i in c['family']:
            q,p=primary['q'][i],primary['p'][i]
            if p==p0:u=u0;shots=2
            else:u=p^q^primary['k'][i];shots=3
            assert [q,p,u]==r['keys'][i];lengths.append(shots)
    return {'source_sha256':r['source_sha256'],'summary':summary,'verification_plans':plans,
            'one_module_repair_branches':{'two_queries':lengths.count(2),'three_queries':lengths.count(3)},
            'limits':['Exact Pauli change relations are premises, not acquired from the old key.',
                      'New probes and payload must share the relevant current key.',
                      'These finite decision-tree checks supplement, but are not part of, the Swift equality certificates.']}


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--input',type=Path,required=True);p.add_argument('--output',type=Path,required=True)
    a=p.parse_args()
    if a.output.exists():raise ValueError('Use a new output file')
    result=check(a.input)
    a.output.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:v for k,v in result.items() if k!='verification_plans'},indent=2))
