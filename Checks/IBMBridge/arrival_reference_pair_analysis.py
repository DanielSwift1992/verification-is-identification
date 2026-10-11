#!/usr/bin/env python3
"""Read-only comparison for three-attempt campaign, first intervention.

Sampling intervals assume independent identical Bernoulli shots within each
PUB. They do not bound device drift or prove a physical error mechanism.
"""
import json
import math
from scipy.stats import beta
import arrival_reference_pair_probe as p


def interval(mean,n,alpha):
    k=round(n*(1+mean)/2)
    assert abs(2*k/n-1-mean)<1e-12
    lo=0. if k==0 else float(beta.ppf(alpha/2,k,n-k+1))
    hi=1. if k==n else float(beta.ppf(1-alpha/2,k+1,n-k))
    return [2*lo-1,2*hi-1]


def analyze():
    plan,qs=p.load()
    for name,digest in p.read(p.ART/'prepared-manifest.json')['sha256'].items():
        p.require(p.sha((p.ROOT/name).read_bytes())==digest,'Frozen plan changed: '+name)
    status=p.read(p.ART/'status.json');p.require(status['status']=='DONE','No completed observations')
    for file,key in [('provider-result.txt','provider_raw_sha256'),('raw-result.json','raw_sha256')]:
        p.require(p.sha((p.PRIVATE/file).read_bytes())==status[key],'Observation changed')
    rows=status['rows'];p.require(len(rows)==12,'Missing conditions')
    markers={}
    for arm in p.ARMS:
        rr=[r for r in rows if r['arm']==arm]
        n=sum(r['shots'] for r in rr);k=sum(r['marker_correct'] for r in rr)
        markers[arm]={'correct':k,'shots':n,'error_fraction':1-k/n,
                      'meets_preregistered_marker_threshold':1-k/n<=.1}
    admitted=all(r['meets_preregistered_marker_threshold'] for r in markers.values())
    bell={}
    # Four simultaneous exact binomial intervals, Bonferroni 95% coverage.
    for basis in ('XX','ZZ'):
        arms={}
        for arm in p.ARMS:
            r,=[r for r in rows if r['input']=='original_Bell' and r['basis']==basis and r['arm']==arm]
            arms[arm]={'mean':r['means']['DR'],'shots':r['shots'],
                       'mean_interval':interval(r['means']['DR'],r['shots'],.05/4)}
        a,b=arms['original'],arms['reference_pair']
        bell[basis]={'arms':arms,'difference':b['mean']-a['mean'],
                     'difference_interval':[b['mean_interval'][0]-a['mean_interval'][1],
                                            b['mean_interval'][1]-a['mean_interval'][0]]}
    coherence=[]
    for spectator in (0,1):
        for arm in p.ARMS:
            part={r['basis']:r['means']['R'] for r in rows if r['input']=='R'
                  and r['spectator']==spectator and r['arm']==arm}
            x,y=part['ZX'],part['ZY']
            coherence.append({'spectator':spectator,'arm':arm,'R_X':x,'R_Y':y,
                              'radius_descriptive':math.hypot(x,y),
                              'phase_descriptive_radians':math.atan2(y,x)})
    return {'schema':'vi.xx-attempt1-analysis.v1','job_id':status['job_id'],
            'marker_controls':markers,'arm_contrasts_admitted_by_marker':admitted,
            'bell':bell,'product_R':coherence,
            'schedule_signature_failures':[r['pub_index'] for r in rows if not r['schedule_check']['admitted']],
            'request_zero':sum(r['request_zero'] for r in rows),'shots':sum(r['shots'] for r in rows),
            'interpretation_limits':'No shot postselection. Conditional IID binomial intervals for four Bell means only; '
                'not a drift bound. Marker agreement is sample-scoped, not universal provenance. '
                'A reference-pair contrast changes physical execution and time as well as toggling-frame signs. '
                'It does not identify a microscopic noise model. Product R radii/phases are descriptive, '
                'not corrections estimated for later execution.'}


if __name__=='__main__':print(json.dumps(analyze(),indent=2))
