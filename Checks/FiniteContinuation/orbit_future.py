#!/usr/bin/env python3
"""Derive future admission and an exact cyclic forward-query optimum.

Physical assumptions are inherited from orbit_return. q-fibers here are
equal-length T-cycles. Only forward powers of that SAME T are available.
Future observables commute with q; acquisition measures q at its exit.
"""
from collections import defaultdict
from functools import reduce
from math import gcd
import json

import numpy as np
import orbit_return as o

require=o.require
I=np.eye(2);X=np.array([[0,1],[1,0]]);Y=np.array([[0,-1j],[1j,0]]);Z=np.diag([1,-1])
PAULI={'I':I,'X':X,'Y':Y,'Z':Z}


def pauli(word):
    return reduce(np.kron,[PAULI[c] for c in word])


def controls():
    h=(X+Z)/np.sqrt(2);s=np.diag([1,1j]);swap=np.zeros((8,8))
    for i in range(8):swap[(i&4)+((i&1)<<1)+((i>>1)&1),i]=1
    return {'H_B':np.kron(I,np.kron(h,I)),'H_C':np.kron(I,np.kron(I,h)),
            'S_B':np.kron(I,np.kron(s,I)),'Swap_BC':swap}


CONTROLS=controls()


def pullback(word,name):
    u=CONTROLS[name];a=u.conj().T@pauli(word)@u
    from itertools import product
    for letters in product('IXYZ',repeat=3):
        candidate=''.join(letters);p=pauli(candidate)
        if min(np.max(abs(a-p)),np.max(abs(a+p)))<1e-12:return candidate
    raise ValueError('The supplied control left the declared Pauli fragment')


def future(initial,available):
    require(all(len(w)==3 and set(w)<=set(PAULI) and w[0] in 'IZ' for w in initial),
            'Future here is after measuring A; cross-A coherence needs another boundary')
    require(set(available)<=set(CONTROLS),'Unavailable future control')
    closure={w:{'terminal':w,'word':[]} for w in ['III']+list(initial)}
    queue=list(closure)
    for word in queue:
        for name in available:
            p=pullback(word,name)
            if p not in closure:
                closure[p]={'terminal':closure[word]['terminal'],'word':[name]+closure[word]['word']}
                queue.append(p)
    result={'initial':list(initial),'controls':list(available),'closure':closure}
    verify_future(result);return result


def verify_future(cert):
    require(set(cert['controls'])<=set(CONTROLS),'Unknown future control')
    require('III' in cert['closure'] and set(cert['initial'])<=set(cert['closure']),'Missing terminal')
    for word,witness in cert['closure'].items():
        require(len(word)==3 and word[0] in 'IZ','An acquired classical answer cannot retain cross-A coherence')
        require(witness['terminal'] in cert['initial']+['III'],'Ungrounded future question')
        got=witness['terminal']
        for name in reversed(witness['word']):
            require(name in cert['controls'],'Unavailable future word');got=pullback(got,name)
        require(got==word,'False pullback witness')
        for name in cert['controls']:require(pullback(word,name) in cert['closure'],'Unclosed future')
    return True


def cyclic_model(m):
    """Derive coordinates from the actual q and permutation, not labels alone."""
    n=len(m['q']);t=m['permutations']['T'];require(sorted(t)==list(range(n)),'Not a permutation')
    cycles=[];remaining=set(range(n))
    while remaining:
        s=min(remaining);cycle=[]
        while s not in cycle:
            require(s in remaining,'Non-disjoint orbit');remaining.remove(s);cycle.append(s);s=t[s]
        require(s==cycle[0],'Bad orbit');cycles.append(cycle)
    lengths={len(c) for c in cycles};require(len(lengths)==1,'This optimal constructor requires equal cycle lengths')
    groups={a:{s for s,q in enumerate(m['q']) if q==a} for a in set(m['q'])}
    require({frozenset(c) for c in cycles}=={frozenset(c) for c in groups.values()},'q-fibers are not the actual T-cycles')
    return cycles,next(iter(lengths))


def powered_model(m):
    cycles,length=cyclic_model(m);result=json.loads(json.dumps(m));n=len(m['q'])
    p=list(range(n));result['permutations']={}
    for k in range(length):
        result['permutations'][f'T{k}']=p.copy();p=[m['permutations']['T'][s] for s in p]
    return result


def word_data(m,powers):
    _,length=cyclic_model(m)
    require(powers and all(type(k) is int and 0<=k<length for k in powers),'Bad cyclic word')
    pm=powered_model(m);info=o.analyse(pm,[f'T{k}' for k in powers])
    require(info['final_source']==list(range(len(m['q']))),'Source not returned')
    cleanup={}
    for s,a in enumerate(m['q']):
        key=str(a);w=info['work_before_cleanup'][s]
        require(key not in cleanup or cleanup[key]==w,'Workspace cannot be cleared from acquired q')
        cleanup[key]=w
    info['cleanup_by_answer']=cleanup
    return pm,info


def phase_blocks(m,info):
    groups=defaultdict(list)
    for s,a in enumerate(m['q']):groups[(a,tuple(info['visits'][s]))].append(s)
    blocks=list(groups.values())
    return {'blocks':blocks,'dimension':sum(len(b)**2 for b in blocks)}


def edges(m,observables):
    n=len(m['q']);result=set()
    for e in observables:
        require(e.shape==(n,n) and np.all(np.isfinite(e)) and np.array_equal(e,e.conj().T),
                'Not an exactly represented finite Hermitian source question')
        for s in range(n):
            for t in range(s):
                if e[s,t]!=0:
                    require(m['q'][s]==m['q'][t],'Question requires cross-answer coherence before acquisition')
                    result.add((t,s))
    return sorted(result)


def admit(m,powers,observables):
    pm,info=word_data(m,powers)
    needed=edges(m,observables)
    for s,t in needed:
        if info['visits'][s]!=info['visits'][t]:
            x=next(x for x in range(len(m['q'])) if info['visits'][s][x]!=info['visits'][t][x])
            return {'admitted':False,'pair':[s,t],'phase_label':x,
                    'difference':info['visits'][s][x]-info['visits'][t][x],
                    'boundary':phase_blocks(m,info)}
    return {'admitted':True,'boundary':phase_blocks(m,info)}


def lower_bound(m,observables):
    """Derive the finite arithmetic premises of the general counting bound.

    h is the common visit histogram on offsets of each T-cycle. Required
    differences generate H. h must be H-invariant. h(0)>=1 forces |H| calls.
    If the single H-sweep leaves a non-q workspace, the next possible size is
    2|H| and doubling every visit attains it. No hidden phase is an input.
    """
    cycles,length=cyclic_model(m);needed=edges(m,observables)
    position={s:z for cycle in cycles for z,s in enumerate(cycle)}
    differences=[(position[t]-position[s])%length for s,t in needed]
    d=reduce(gcd,[length]+differences);subgroup=list(range(0,length,d))
    cleanup={};first_sweep=[];ready=True
    for cycle in cycles:
        for z,s in enumerate(cycle):
            w=0
            for r in subgroup:w^=m['f'][cycle[(z+r)%length]]
            first_sweep.append((s,w));a=str(m['q'][s])
            if a in cleanup and cleanup[a]!=w:ready=False
            cleanup[a]=w
    multiple=1 if ready else 2
    lower={'cycle_length':length,'edge_differences':differences,'subgroup_step':d,'subgroup':subgroup,
           'single_sweep_work':sorted(first_sweep),'single_sweep_ready':ready,
           'oracle_multiple':multiple,'minimum_oracle_calls':multiple*len(subgroup),
           'minimum_forward_T_calls':0 if len(subgroup)==1 else length}
    return lower


def optimal(m,observables):
    """Produce an attaining word, without phase information or bounded search."""
    lower=lower_bound(m,observables)
    count=len(lower['subgroup']);step=lower['subgroup_step']%lower['cycle_length']
    powers=([step]*count if lower['oracle_multiple']==1 else [k for _ in range(count) for k in (0,step)])
    _,info=word_data(m,powers);verdict=admit(m,powers,observables)
    require(verdict['admitted'],'Constructed word failed its own relation')
    require(len(powers)==lower['minimum_oracle_calls'] and sum(powers)==lower['minimum_forward_T_calls'],
            'Construction does not attain both counted resources')
    return {'schema':'vi.orbit-future-plan.v1','model':o.fingerprint(m),
            'question_edges':[list(pair) for pair in edges(m,observables)],'powers':powers,'lower_bound':lower,
            'computed':info,'admission':verdict}


def verify(m,observables,plan):
    require(plan['schema']=='vi.orbit-future-plan.v1' and plan['model']==o.fingerprint(m),'Wrong current model')
    needed=edges(m,observables)
    require(plan['question_edges']==[list(x) for x in needed],'Different promised question')
    _,info=word_data(m,plan['powers']);verdict=admit(m,plan['powers'],observables)
    require(plan['computed']==info and plan['admission']==verdict and verdict['admitted'],'False boundary obligation')
    # Reconstruct the finite arithmetic lower-bound premise; this is not a
    # bounded search. The report supplies the all-word counting argument.
    computed=lower_bound(m,observables)
    require(plan['lower_bound']==computed,'False cost lower bound')
    require(len(plan['powers'])==computed['minimum_oracle_calls'] and sum(plan['powers'])==computed['minimum_forward_T_calls'],
            'Presented word does not attain the lower bounds')
    return {'minimum_joint_oracle_calls':len(plan['powers']),'minimum_forward_T_calls':sum(plan['powers']),
            'future_algebra_dimension':verdict['boundary']['dimension']}


def execute(m,plan,observables,phase=None):
    # Application requires the recipient's ACTUAL current questions. A previous
    # accepted plan is not an independent reusable "safe" status.
    verify(m,observables,plan)
    pm,info=word_data(m,plan['powers'])
    require(plan['model']==o.fingerprint(m) and plan['computed']==info,'Wrong word/source application')
    return o.execute_word(pm,[f'T{k}' for k in plan['powers']],info['decoder'],
                          info['cleanup_by_answer'],phase)
