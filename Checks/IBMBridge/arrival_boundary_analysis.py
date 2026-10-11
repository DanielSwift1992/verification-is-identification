#!/usr/bin/env python3
"""Frozen descriptive analysis of the conditional-boundary hardware test.

No provider calls, filtering, fitted noise model, or inferred process fidelity.
"""
from collections import defaultdict
import json
from pathlib import Path

from arrival_boundary_probe import ART, ROOT, read, write, sha, require, ideal, verify_parent


def analyze(status, plan):
    require(status['status']=='DONE' and len(status['rows'])==len(plan['PUBs'])==32,'Incomplete result')
    groups=defaultdict(lambda:{'shots':0,'B_zero':0,'arrival_agreement':0})
    data=defaultdict(lambda:{'shots':0,'even':0})
    seen=set();total=0
    for row,pub in zip(status['rows'],plan['PUBs']):
        metadata={k:v for k,v in pub.items() if k not in ('inventory','exact_moments')}
        require(all(row[k]==v for k,v in metadata.items()),'Result/plan origin mismatch')
        c=row['prepared_arrival'];sign=int(row['law_b_preparation']=='-');variant=row['variant'];basis=row['basis']
        key=(c,sign,basis,variant);require(key not in seen,'Duplicate PUB');seen.add(key)
        require(row['prediction']==ideal(variant,c,basis,sign),'Prediction changed')
        shots=b0=even=arrival_ok=0
        for record,n in row['counts'].items():
            request,replies,witness=record.split()
            require(len(request)==1 and set(request)<=set('01') and
                    len(witness)==3 and set(witness)<=set('01') and type(n) is int and n>0,'Invalid acquired count')
            require(replies=='--' if variant=='echo' else len(replies)==2 and set(replies)<=set('01'),
                    'Invalid probe record')
            w=int(witness,2);shots+=n;b0+=n*((w&1)==0)
            even+=n*(((w>>1)&1)==((w>>2)&1));arrival_ok+=n*(int(request)==c)
        require(shots==row['shots']==32 and b0==row['B_zero'] and even==row['data_even'] and
                arrival_ok==row['arrival_agreement'],'Summary differs from actual counts')
        require(row['B_X']==2*b0/shots-1 and row['data_parity']==2*even/shots-1,'Wrong observable decoder')
        g=groups[c,variant,sign];g['shots']+=shots;g['B_zero']+=b0;g['arrival_agreement']+=arrival_ok
        d=data[c,variant,basis];d['shots']+=shots;d['even']+=even;total+=shots
    require(total==plan['total_shots']==1024,'Wrong campaign total')
    rows=[]
    for c in (0,1):
        for variant in ('conditional','unconditional','echo','ignore_learning'):
            plus=groups[c,variant,0];minus=groups[c,variant,1]
            require(plus['shots']==minus['shots']==64,'Unbalanced signed input')
            xp=2*plus['B_zero']/plus['shots']-1;xm=2*minus['B_zero']/minus['shots']-1
            rows.append({'prepared_arrival':c,'variant':variant,
                         'plus':{**plus,'B_X':xp},'minus':{**minus,'B_X':xm},
                         'balanced_B_response':(xp-xm)/2,
                         'data':{b:{**data[c,variant,b], 'parity':2*data[c,variant,b]['even']/data[c,variant,b]['shots']-1}
                                 for b in ('XX','ZZ')}})
    at={(r['prepared_arrival'],r['variant']):r for r in rows}
    return {'schema':'vi.arrival-boundary-analysis.v1','job_id':status['job_id'],'total_shots':total,
            'rows':rows,'primary_contrast_at_absent_arrival':
            at[0,'conditional']['balanced_B_response']-at[0,'unconditional']['balanced_B_response'],
            'scope':'All shots. Balanced signed-input response and terminal data parity are descriptive '
                    'observables, not process fidelity, error attribution, an IID guarantee or quantum advantage. '
                    'Acquisition arms share gate bodies/layout; provider timing and gate faults may differ.'}


def run():
    verify_parent(ART/'manifest.json')
    plan=read(ART/'plan.json');status=read(ART/'status.json')
    private=ROOT/'private/ibm-arrival-boundary-20260916'
    require(sha((private/'raw-result.json').read_bytes())==status['raw_sha256'],'Raw evidence changed')
    result=analyze(status,plan)
    result['raw_sha256']=status['raw_sha256']
    write(ART/'analysis.json',result)
    print(json.dumps(result,indent=2))


if __name__=='__main__':run()
