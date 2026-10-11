#!/usr/bin/env python3
"""Synthetic shared-detector comparisons; no QPU measurements."""
import argparse
import json
from pathlib import Path
import random

from model import problem
from shared_readout import SharedReadout


def run():
    p=problem(('t',),'terminal','X'); rng=random.Random(2026091402)
    settings=[('ordinary',(0.05,0.95)),('inverted',(0.95,0.05)),('perfect_common_flip',(1.,0.))]
    results=[]
    for name,theta in settings:
        for world in range(16):
            e=SharedReadout(p,max_shots=8192)
            while e.decision()['kind']=='probe':
                key=e.decision()['probe']
                b=int(key[-1]) if key.startswith('reference:') else e.probes[key]['replies'][world]
                bits=[int(rng.random()<theta[b]) for _ in range(32)]
                e.acquire(key,bits)
            d=e.decision()
            assert d['kind']=='act' and d['action'] in p['valid'][world]
            assert len(d['family'])==4
            results.append({'detector':name,'world':world,**e.export()})
    tied=SharedReadout(p,max_shots=512)
    while tied.decision()['kind']=='probe':tied.acquire(tied.decision()['probe'],[0,1]*16)
    assert tied.decision()['kind']=='needs_evidence' and len(tied.family())==16
    # When theta0=theta1, the *law* of every available stream is identical for
    # every h. No strategy can identify a nonconstant question from these data.
    summary=[]
    for name,_ in settings:
        selected=[r for r in results if r['detector']==name]
        summary.append({'detector':name,'correct':len(selected),
                        'min_shots':min(r['shots'] for r in selected),
                        'max_shots':max(r['shots'] for r in selected)})
    return {'scope':'LOCAL SYNTHETIC DATA ONLY','summary':summary,'episodes':results,
            'uninformative_detector':tied.export(),
            'claim':'Joint interval feasibility identifies the required action while h and detector parameters remain nonunique, under a shared conditional-response contract.'}


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    args=p.parse_args();data=run();args.output.parent.mkdir(parents=True,exist_ok=True)
    args.output.write_text(json.dumps(data,indent=2)+'\n')
    print(json.dumps(data['summary'],indent=2))
