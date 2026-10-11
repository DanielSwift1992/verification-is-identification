#!/usr/bin/env python3
"""Forward-only acquisition with symbolic phase visits and a returned source.

One fixed coherent oracle V|s,w> = lambda[s]|s,w XOR F(s)> is available.
lambda is arbitrary, unknown, repeatable and independent of w. Permutations
are declared available, known, phase-free actions on the same source. The
certificate proves this CONDITIONAL contract, not membership of real hardware.
"""
from collections import Counter
import hashlib
import json
from pathlib import Path
import subprocess

import numpy as np
import returning_attempt_learning as learning

ROOT=learning.ROOT
require=learning.require
fingerprint=learning.fingerprint


def read_source():
    reply=subprocess.run(['node',str(Path(__file__).with_name('orbit_return_court.js')),'read'],
                         capture_output=True,text=True,check=True,timeout=30)
    source=json.loads(reply.stdout)
    for name,digest in source['source_sha256'].items():
        require(hashlib.sha256((ROOT/name).read_bytes()).hexdigest()==digest,'Current source changed')
    return source


def model(source):
    return {'schema':'vi.orbit-return-model.v1','source':fingerprint(source),
            'q':[r['Control'] for r in source['rows']],
            'f':[r['ProbeB']+2*r['ProbeParity'] for r in source['rows']],
            'work_bits':2,'elementary_contacts_per_oracle':2,
            'permutations':{'T':source['successor']},
            'oracle_contract':'repeatable source-only phases and XOR word on the same source/work'}


def analyse(m, schedule):
    """Compute obligations from actual word; never consult unknown phases."""
    q,f=m['q'],m['f'];n=len(q);wdim=1<<m['work_bits']
    require(n>0 and len(f)==n and all(type(a) is int and a>=0 for a in q),'Bad finite question')
    require(all(type(w) is int and 0<=w<wdim for w in f),'Wrong word domain')
    require(schedule and all(name in m['permutations'] for name in schedule),'Unavailable permutation')
    for p in m['permutations'].values():require(sorted(p)==list(range(n)),'Action is not a permutation')
    decoder={}
    for s in range(n):
        require(str(f[s]) not in decoder or decoder[str(f[s])]==q[s],'F does not determine the independent q')
        decoder[str(f[s])]=q[s]
    visits=[];final=[];work=[];paths=[]
    for start in range(n):
        s=start;w=0;count=[0]*n;path=[]
        for name in schedule:
            path.append(s);count[s]+=1;w^=f[s];s=m['permutations'][name][s]
        visits.append(count);final.append(s);work.append(w);paths.append(path)
    return {'decoder':decoder,'visits':visits,'final_source':final,'work_before_cleanup':work,'paths':paths}


def obligations(m, schedule):
    info=analyse(m,schedule);q=m['q'];n=len(q)
    nonreturn=next((s for s in range(n) if info['final_source'][s]!=s),None)
    if nonreturn is not None:return info,{'kind':'source-not-returned','state':nonreturn}
    pair=next(((s,t) for s in range(n) for t in range(s)
               if q[s]==q[t] and info['visits'][s]!=info['visits'][t]),None)
    if pair is not None:
        s,t=pair;label=next(j for j in range(n) if info['visits'][s][j]!=info['visits'][t][j])
        delta=info['visits'][s][label]-info['visits'][t][label]
        # Choosing this one phase exp(i*pi/delta) makes the relative phase -1.
        return info,{'kind':'phase-splits-question','pair':list(pair),'label':label,'count_difference':delta}
    cleanup={}
    for s,a in enumerate(q):
        key=str(a);w=info['work_before_cleanup'][s]
        require(key not in cleanup or cleanup[key]==w,'Internal error: equal counts imply equal XOR')
        cleanup[key]=w
    info['cleanup_by_answer']=cleanup
    info['question_fiber_lower_bound']=max(Counter(q).values())
    return info,None


def propose(m, schedule):
    info,obstruction=obligations(m,schedule)
    return {'schema':'vi.orbit-return-certificate.v1','model':fingerprint(m),
            'schedule':list(schedule),'kind':'obstructed' if obstruction else 'admitted',
            'computed':info,'obstruction':obstruction}


def verify(m, cert):
    require(cert['schema']=='vi.orbit-return-certificate.v1' and cert['model']==fingerprint(m),
            'Wrong current model')
    # Word application, not a search for another word or reliance on a status.
    info,obstruction=obligations(m,cert['schedule'])
    require(cert['computed']==info and cert['obstruction']==obstruction,'Unsupported word obligation')
    admitted=obstruction is None
    require(cert['kind']==('admitted' if admitted else 'obstructed'),'Wrong stated consequence')
    return {'admitted':admitted,'joint_oracle_calls':len(cert['schedule']),
            'elementary_forward_contacts':len(cert['schedule'])*m['elementary_contacts_per_oracle'],
            'permutation_calls':len(cert['schedule']),
            'count_lower_bound':max(Counter(m['q']).values()),
            'scope':'This finite word and static independent source phases; not all possible access strategies.'}


def execute(m, cert, phase=None, *, clear_work=True):
    """Full prepared-slice isometry by actual gates, not the count formula.

    phase(step,source,work) is a physical test oracle; it is never supplied to
    the planner/decoder. General callbacks intentionally allow contract-breaking
    examples. Execution uses only the presented word, decoder and cleanup.
    Row index = s + n*(w + wdim*answer). No intermediate measurement/reset.
    """
    verify(m,cert)
    require(cert['kind']=='admitted','Obstructed word has no authorized executor')
    return execute_word(m,cert['schedule'],cert['computed']['decoder'],
                        cert['computed']['cleanup_by_answer'],phase,clear_work=clear_work)


def execute_word(m,schedule,decoder,cleanup,phase=None,*,clear_work=True):
    """Low-level physical word, also used to expose rejected proposals."""
    n=len(m['q']);wdim=1<<m['work_bits'];adim=1<<max(m['q']).bit_length()
    size=n*wdim*adim;live=np.zeros((size,n),complex);live[:n]=np.eye(n)
    phase=phase or (lambda step,s,w:1)
    for step,name in enumerate(schedule):
        out=np.zeros_like(live)
        for row in range(size):
            s=row%n;w=(row//n)%wdim;a=row//(n*wdim)
            z=complex(phase(step,s,w));require(abs(abs(z)-1)<1e-12,'Oracle phase must have unit modulus')
            nw=w^m['f'][s]
            out[s+n*(nw+wdim*a)]=z*live[row]
        live=out
        if step==0:
            copied=np.zeros_like(live)
            for row in range(size):
                s=row%n;w=(row//n)%wdim;a=row//(n*wdim)
                na=a^decoder.get(str(w),0)
                copied[s+n*(w+wdim*na)]=live[row]
            live=copied
        moved=np.zeros_like(live)
        for row in range(size):
            s=row%n;w=(row//n)%wdim;a=row//(n*wdim)
            moved[m['permutations'][name][s]+n*(w+wdim*a)]=live[row]
        live=moved
    if clear_work:
        cleared=np.zeros_like(live)
        for row in range(size):
            s=row%n;w=(row//n)%wdim;a=row//(n*wdim)
            cleared[s+n*((w^cleanup.get(str(a),0))+wdim*a)]=live[row]
        live=cleared
    rows=[]
    for a in range(adim):
        for w in range(wdim):
            k=live[n*(w+wdim*a):n*(w+wdim*a+1)]
            if np.any(k):rows.append((a,w,k))
    return {'rows':rows,'isometry':live}
