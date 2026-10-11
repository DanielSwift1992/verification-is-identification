#!/usr/bin/env python3
"""Acquire q by finite measured contacts while preserving every q-fiber.

Physical scope: a declared orthonormal source basis, static deterministic
contacts realized by their diagonal Lüders projectors, classical adaptive
control, and no access to a discarded coherent measurement environment.
Certificate rejection is scoped to this language, never to all physics.
"""
from functools import lru_cache
import hashlib
import json
from pathlib import Path
import subprocess

import numpy as np
import returning_attempt_learning as learning

ROOT = learning.ROOT


def read_source():
    result = subprocess.run(['node',str(Path(__file__).with_name('coarse_acquisition_court.js')),'read'],
                            capture_output=True,text=True,check=True,timeout=30)
    source=json.loads(result.stdout)
    for name,digest in source['source_sha256'].items():
        learning.require(hashlib.sha256((ROOT/name).read_bytes()).hexdigest()==digest,'Current source changed')
    return source


def model(source, question, probes):
    q=[row[question] for row in source['rows']]
    fs={name:[row[field] for row in source['rows']] for name,field in probes.items()}
    learning.require(q and all(type(x) is int and x>=0 for x in q),'Finite nonempty question domain')
    learning.require(all(len(f)==len(q) and all(type(x) is int and x in (0,1) for x in f) for f in fs.values()),
                     'This executable fragment uses binary contacts')
    return {'schema':'vi.coarse-acquisition-model.v1','source':learning.fingerprint(source),
            'question_field':question,'probe_fields':probes,'q':q,'probes':fs}


def probe_case(m, support, name):
    f=m['probes'][name];q=m['q']
    for i in support:
        for j in support:
            if q[i]==q[j] and f[i]!=f[j]:
                return {'kind':'leaks','pair':[i,j]}
    groups={str(b):tuple(i for i in support if f[i]==b) for b in (0,1) if any(f[i]==b for i in support)}
    if len(groups)==1:return {'kind':'constant','reply':int(next(iter(groups)))}
    return {'kind':'safe-split','groups':groups}


def synthesize(m):
    """Exact finite minimax depth; failed states carry all-action obstructions."""
    @lru_cache(None)
    def visit(support):
        answers={m['q'][i] for i in support}
        if len(answers)==1:
            return {'kind':'answer','answer':next(iter(answers)),'depth':0}
        candidates=[];reasons={}
        for name in m['probes']:
            case=probe_case(m,support,name)
            if case['kind']!='safe-split':reasons[name]=case;continue
            branches={reply:visit(child) for reply,child in case['groups'].items()}
            bad=next((r for r,t in branches.items() if t['kind']=='blocked'),None)
            if bad is not None:
                reasons[name]={'kind':'blocked-child','reply':int(bad),'child':branches[bad]}
            else:
                candidates.append({'kind':'query','probe':name,'branches':branches,
                                   'depth':1+max(t['depth'] for t in branches.values())})
        if candidates:return min(candidates,key=lambda t:(t['depth'],t['probe']))
        return {'kind':'blocked','reasons':reasons}
    tree=visit(tuple(range(len(m['q']))))
    return {'schema':'vi.coarse-acquisition-certificate.v1','model':learning.fingerprint(m),'tree':tree}


def verify(m, certificate):
    """Apply a proposed tree/obstruction to all actual current source fibers.

    Does not call the optimizer. Checks the upper depth, not optimality of a
    successful proposal; the report's separate binary bound closes the example.
    """
    learning.require(certificate['schema']=='vi.coarse-acquisition-certificate.v1' and
                     certificate['model']==learning.fingerprint(m),'Wrong certificate source')
    nodes=0
    def visit(t, support):
        nonlocal nodes
        nodes+=1
        answers={m['q'][i] for i in support}
        if t['kind']=='answer':
            learning.require(answers=={t['answer']} and t['depth']==0,'Unestablished answer')
            return True,0
        if t['kind']=='query':
            learning.require(t['probe'] in m['probes'],'Unavailable contact')
            case=probe_case(m,support,t['probe'])
            learning.require(case['kind']=='safe-split','Contact destroys promised fiber or makes no progress')
            learning.require(set(t['branches'])==set(case['groups']),'Missing actual outcome')
            depths=[]
            for reply,child in case['groups'].items():
                ok,depth=visit(t['branches'][reply],child)
                learning.require(ok,'Claimed policy contains an impossible continuation');depths.append(depth)
            depth=1+max(depths)
            learning.require(t['depth']==depth,'Wrong rank/upper depth')
            return True,depth
        learning.require(t['kind']=='blocked' and len(answers)>1,'False obstruction at a resolved question')
        learning.require(set(t['reasons'])==set(m['probes']),'Obstruction omitted an available contact')
        for name,reason in t['reasons'].items():
            f=m['probes'][name]
            if reason['kind']=='leaks':
                i,j=reason['pair']
                learning.require(i in support and j in support and m['q'][i]==m['q'][j] and f[i]!=f[j],
                                 'False destructive pair')
            elif reason['kind']=='constant':
                learning.require({f[i] for i in support}=={reason['reply']},'Contact is not constant')
            else:
                learning.require(reason['kind']=='blocked-child','Unknown obstruction relation')
                case=probe_case(m,support,name);key=str(reason['reply'])
                learning.require(case['kind']=='safe-split' and key in case['groups'],'Wrong obstructed branch')
                ok,_=visit(reason['child'],case['groups'][key])
                learning.require(not ok,'Obstructed child has a solution')
        return False,None
    ok,depth=visit(certificate['tree'],tuple(range(len(m['q']))))
    return {'possible_in_measured_catalogue':ok,'worst_case_queries':depth,'checked_nodes':nodes}


def measured_instrument(m, tree):
    """Execute actual projectors and conditional control, independent of names."""
    n=len(m['q']);rows=[]
    def visit(node,matrix,record):
        if node['kind']=='answer':
            rows.append((node['answer'],tuple(record),matrix));return
        learning.require(node['kind']=='query','No executable policy')
        f=m['probes'][node['probe']]
        for b in (0,1):
            k=np.diag([int(x==b) for x in f])@matrix
            if np.any(k):visit(node['branches'][str(b)],k,record+[(node['probe'],b)])
    visit(tree,np.eye(n),[])
    return rows


def projectors(m):
    return {answer:np.diag([int(q==answer) for q in m['q']]) for answer in sorted(set(m['q']))}


def coherent_acquire(m, contacts, *, phase_exponents=None, undo='inverse'):
    """Explicit compute/copy/uncompute, no direct access to q at execution.

    Each provided oracle acts on |s,w> by XORing its contact value into one
    work bit and multiplying by i**phase[s]. Decoder sees only the joint work
    word. The inverse is the actual conjugate inverse, not merely another call
    to the forward contact. All output Kraus operators are returned, including
    any leftover work that would be discarded at the requested boundary.
    """
    learning.require(undo in ('inverse','forward','discard'),'Unknown return operation')
    n=len(m['q']);names=tuple(contacts)
    learning.require(names and len(set(names))==len(names) and all(x in m['probes'] for x in names),'Bad coherent access list')
    wdim=1<<len(names);adim=1<<max(m['q']).bit_length()
    decoder={}
    for s,q in enumerate(m['q']):
        word=sum(m['probes'][name][s]<<j for j,name in enumerate(names))
        learning.require(word not in decoder or decoder[word]==q,'Joint contact word does not determine q')
        decoder[word]=q
    # Missing words cannot occur on the prepared slice; defining them as zero
    # still gives a permutation on the complete answer/work register.
    decode=[decoder.get(w,0) for w in range(wdim)]
    phases={name:(phase_exponents or {}).get(name,[0]*n) for name in names}
    learning.require(all(len(v)==n and all(type(e) is int for e in v) for v in phases.values()),'Wrong phase domain')
    size=n*wdim*adim
    live=np.zeros((size,n),complex);live[:n]=np.eye(n)
    def oracle(matrix,j,inverse=False):
        name=names[j];result=np.zeros_like(matrix)
        for row in range(size):
            s=row%n;w=(row//n)%wdim;a=row//(n*wdim)
            new=s+n*((w^(m['probes'][name][s]<<j))+wdim*a)
            phase=(1j)**(phases[name][s]%4)
            result[new]=phase.conjugate()*matrix[row] if inverse else phase*matrix[row]
        return result
    for j in range(len(names)):live=oracle(live,j)
    copied=np.zeros_like(live)
    for row in range(size):
        s=row%n;w=(row//n)%wdim;a=row//(n*wdim)
        copied[s+n*(w+wdim*(a^decode[w]))]=live[row]
    live=copied
    if undo!='discard':
        for j in reversed(range(len(names))):live=oracle(live,j,inverse=undo=='inverse')
    result=[]
    for a in range(adim):
        for w in range(wdim):
            k=live[n*(w+wdim*a):n*(w+wdim*a+1)]
            if np.any(k):result.append((a,w,k))
    return {'decoder':decode,'oracle_uses':len(names)*(1 if undo=='discard' else 2),
            'workspace_bits':len(names),'answer_bits':max(m['q']).bit_length(),
            'rows':result}
