#!/usr/bin/env python3
"""Read-only preregistered four-contrast analysis, with repeats retained."""
import json
from scipy.stats import beta
import arrival_reference_pair_confirmation as p


def interval(k,n,alpha):
    lo=0. if k==0 else float(beta.ppf(alpha/2,k,n-k+1))
    hi=1. if k==n else float(beta.ppf(1-alpha/2,k+1,n-k))
    return [2*lo-1,2*hi-1]


def analyze():
    plan,qs=p.load();p.old.verify_parent(p.ART/'prepared-manifest.json')
    status=p.read(p.ART/'status.json');p.require(status['status']=='DONE','No completed result')
    for name,key in [('provider-result.txt','provider_raw_sha256'),('raw-result.json','raw_sha256')]:
        p.require(p.sha((p.PRIVATE/name).read_bytes())==status[key],'Acquired record changed')
    samples=[]
    p.require(len(status['rows'])==16,'Wrong number of readings')
    for row,entry in zip(status['rows'],plan['PUBs']):
        p.require(all(row[k]==v for k,v in entry.items()),'Plan/result identity differs')
        n=even=b0=request_ok=0
        for key,count in row['counts'].items():
            c,r,w=key.split();p.require(len(c)==1 and len(r)==2 and len(w)==3
                                      and set(c+r+w)<=set('01') and type(count) is int and count>0,
                                      'Malformed raw count')
            z=int(w,2);n+=count;b0+=count*((z&1)==0)
            even+=count*(((z>>1)&1)==((z>>2)&1))
            request_ok+=count*(int(c,2)==row['prepared_arrival'])
        p.require(n==row['shots']==256 and even==row['data_even'] and b0==row['B_zero']
                  and request_ok==row['arrival_agreement'],'Summary not justified by records')
        samples.append({**entry,'shots':n,'even':even,'mean':2*even/n-1,
                        'interval':interval(even,n,.05/16),'B_X':2*b0/n-1,'arrival_agreement':request_ok})
    contrasts=[]
    for c in (0,1):
        for basis in ('XX','ZZ'):
            arms={}
            for arm in p.ARMS:
                rows=[r for r in samples if r['arm']==arm and r['prepared_arrival']==c and r['basis']==basis]
                p.require(len(rows)==2,'Missing repeat')
                arms[arm]={'mean':sum(r['mean'] for r in rows)/2,'shots':sum(r['shots'] for r in rows),
                           'repeat_means':[r['mean'] for r in rows],
                           'blocks':[r['block'] for r in rows],
                           'average_mean_interval':[sum(r['interval'][j] for r in rows)/2 for j in (0,1)]}
            a,b=arms['original'],arms['reference_pair'];ai=a['average_mean_interval'];bi=b['average_mean_interval']
            contrasts.append({'prepared_arrival':c,'basis':basis,'arms':arms,
                              'difference':b['mean']-a['mean'],'difference_interval':[bi[0]-ai[1],bi[1]-ai[0]]})
    return {'schema':'vi.xx-attempt3-analysis.v1','job_id':status['job_id'],'total_shots':4096,
            'method':'Sixteen simultaneous 95% Bonferroni Clopper-Pearson intervals, conditional IID shots '
                'within each PUB. Mean of two repeat expectations bounded by averaging interval endpoints. '
                'No common probability assumed across repeats. Difference intervals by interval arithmetic.',
            'rows':samples,'contrasts':contrasts,
            'arrival_agreement':sum(r['arrival_agreement'] for r in samples),
            'scope':'All shots. No postselection, fitted correction or inference from old mismatched schedules. '
                'Not full process tomography or a guarantee against time/context changes. ABBA is submission order only.'}


if __name__=='__main__':print(json.dumps(analyze(),indent=2))
