#!/usr/bin/env python3
"""Fixed unknown common readout inversion; no calibration reference required.

This is an EXACT deterministic model, not permission to replace conditional
noise bounds with marginal error rates. The inversion is common to every
acquisition in one episode and is NOT applied to the future payload readout.
The target remains the logical continuation accepted by the declared receiver.
"""
import argparse
from itertools import combinations
import json
from pathlib import Path

from batched import synthesize_batches,execute_batches
from batched_checks import check_paths,two_single_probes_suffice
from model import problem
from planner import synthesize,execute


def expanded():
    original=problem(('t',),'terminal','X')
    # The realized (source,inversion) is never passed into either constructor.
    result={k:v for k,v in original.items() if k not in ('valid','probes','worlds')}
    result['valid']=tuple(row for row in original['valid'] for _ in (0,1))
    result['probes']=[{**p,'replies':tuple(bit^flip for bit in p['replies'] for flip in (0,1))}
                      for p in original['probes']]
    return original,result


def checks():
    original,p=expanded();tables={q['id']:q for q in p['probes']}
    plan=synthesize(p)
    assert plan['tree']['cost'][0]==3 and not two_single_probes_suffice(p)
    for n in range(1,4):
        for contacts in combinations(p['probes'],n):
            groups={}
            for w in range(32):
                groups.setdefault(tuple(q['replies'][w] for q in contacts),[]).append(w)
            assert not all(set.intersection(*(set(p['valid'][w]) for w in group)) for group in groups.values())

    leaves=[]
    for world in range(32):
        result=execute(plan,lambda q:tables[q]['replies'][world])
        assert result['kind']=='act' and result['action'] in p['valid'][world]
        feasible=[w for w in range(32) if all(tables[q]['replies'][w]==bit for q,bit in result['transcript'])]
        assert len(feasible)==4
        assert {w%2 for w in feasible}=={0,1}, 'Controller unnecessarily identified detector inversion'
        leaves.append({'configured_source':world//2,'configured_inversion':world%2,
                       'action':result['action'],'transcript':result['transcript'],
                       'remaining_joint_sources':feasible,'detector_inversion_identified':False})

        # Explicit relational construction: y_AX xor y_AY = u; the shared
        # inversion cancels. Then compare y_AX with y_BX (u=0) or y_BY (u=1).
        ax=tables['A:X:X']['replies'][world];ay=tables['A:Y:Y']['replies'][world]
        u=ax^ay
        last=tables['B:Y:Y' if u else 'B:X:X']['replies'][world]
        r=ax^last
        action=f'read:{-1 if r else 1:+}:{"Y" if u else "X"}'
        assert action in p['valid'][world]

    costs=[]
    for latency in (0,1,5,50):
        r=synthesize_batches(p,round_price=latency,probe_price=1,module_price=1)
        assert int(r['cost'])==min(2*latency+6,latency+8)
        resources=check_paths(p,r)
        costs.append({'prices':r['prices'],'cost':r['cost'],'first_batch':r['tree']['probes'],**resources})
    return {'scope':'Finite exact common-inversion model; no new hardware data',
            'joint_sources':32,'minimum_adaptive_probes':3,'minimum_fixed_probes':4,
            'source_and_instrument_remain_ambiguous':True,
            'cases':leaves,'batch_costs':costs,
            'boundary':'Independent per-probe inversions can emulate any chosen source; without their common relation no action is universally identified.'}


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--output',type=Path)
    args=parser.parse_args();result=checks()
    if args.output:
        args.output.parent.mkdir(parents=True,exist_ok=True)
        args.output.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:v for k,v in result.items() if k!='cases'},indent=2))
