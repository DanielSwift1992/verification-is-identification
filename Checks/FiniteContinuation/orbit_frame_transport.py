#!/usr/bin/env python3
"""Transport a live phase boundary; certify a restricted-word obstruction.

The unknown contact still has independent static scalar phases. A known source
permutation changes where its old phase characters reside. No inverse of that
unknown contact is used. The actual live wrapper currently admits Swap_BC.
"""
from collections import deque
from dataclasses import dataclass
import json
import subprocess

import numpy as np
import orbit_return as o
import orbit_future as f
import orbit_live_upgrade as live

require=o.require


def transported(counts,permutation):
    n=len(counts)
    require(sorted(permutation)==list(range(n)),'Not a source permutation')
    inverse=np.argsort(permutation)
    return [counts[int(inverse[s])][:] for s in range(n)]


def equations(m,counts):
    """g[to]-g[from]=delta, derived from equal final phase characters."""
    cycles,length=f.cyclic_model(m);n=len(m['q']);edges=[]
    require(len(counts)==n and all(len(row)==n for row in counts),'Wrong phase-profile carrier')
    require(all(type(v) is int and v>=0 for row in counts for v in row),'Not integral acquired counts')
    for cycle in cycles:
        work=[]
        for s in cycle:
            require(all(counts[s][x]==0 for x in range(n) if x not in cycle),'Cross-answer phase profile')
            w=0
            for x in cycle:
                if counts[s][x]%2:w^=m['f'][x]
            work.append(w)
        require(len(set(work))==1,'Prior phase profile lacks the inherited readiness relation')
        for z,s in enumerate(cycle):
            for k,x in enumerate(cycle):
                edges.append({'from':k,'to':(k-z)%length,
                              'delta':counts[cycle[0]][x]-counts[s][x],
                              'reference':cycle[0],'state':s,'phase_label':x})
    return edges,length


def solve_closed_word(m,counts):
    """Exact decision for a closed, fixed forward V/T suffix, any length.

    A contradiction is a closed chain of actual equations with nonzero sum.
    A consistent connected graph fixes g up to a common integer; min(g)=0
    gives the minimum nonnegative query count. No hidden phase is supplied.
    """
    edges,length=equations(m,counts);graph=[[] for _ in range(length)]
    for i,e in enumerate(edges):
        graph[e['from']].append((e['to'],e['delta'],i,1))
        graph[e['to']].append((e['from'],-e['delta'],i,-1))
    potential={0:0};paths={0:[]};queue=deque([0])
    while queue:
        a=queue.popleft()
        for b,delta,index,sign in graph[a]:
            step={'equation':index,'sign':sign}
            if b not in potential:
                potential[b]=potential[a]+delta;paths[b]=paths[a]+[step];queue.append(b)
            elif potential[b]!=potential[a]+delta:
                cycle=paths[a]+[step]+[{'equation':x['equation'],'sign':-x['sign']} for x in reversed(paths[b])]
                certificate={'kind':'no_closed_forward_word','model':o.fingerprint(m),
                             'from_counts':counts,'cycle':cycle}
                verify_closed_word(m,counts,certificate);return certificate
    require(len(potential)==length,'Full-fiber equations must connect all offsets')
    floor=min(potential.values());g=[potential[r]-floor for r in range(length)]
    program=[];at=0
    for r,uses in enumerate(g):
        if not uses:continue
        if (r-at)%length:program.append({'op':'T','count':(r-at)%length})
        program.extend({'op':'V'} for _ in range(uses));at=r
    if at:program.append({'op':'T','count':(-at)%length})
    result,cleanup=live.symbolic(m,counts,program)
    certificate={'kind':'closed_forward_word','model':o.fingerprint(m),
                 'from_counts':counts,'added_histogram':g,'program':program,
                 'cleanup_by_answer':cleanup,'result_counts':result,
                 'minimum_V':sum(g),'minimum_T':length if any(g[1:]) else 0}
    verify_closed_word(m,counts,certificate);return certificate


def verify_closed_word(m,counts,certificate):
    require(certificate['model']==o.fingerprint(m) and certificate['from_counts']==counts,
            'Not a certificate about this current phase boundary')
    edges,length=equations(m,counts)
    if certificate['kind']=='no_closed_forward_word':
        path=certificate['cycle'];require(bool(path),'Empty obstruction')
        first=None;position=None;total=0
        for item in path:
            require(type(item['equation']) is int and 0<=item['equation']<len(edges)
                    and item['sign'] in (-1,1),'Invalid equation use')
            e=edges[item['equation']];a,b=e['from'],e['to']
            if item['sign']==-1:a,b=b,a
            if first is None:first=position=a
            require(position==a,'Obstruction equations do not compose')
            position=b;total+=item['sign']*e['delta']
        require(position==first and total!=0,'No contradictory closed equation chain')
        return {'impossible_in_declared_word_language':True,'sum':total,'equations':len(path)}
    require(certificate['kind']=='closed_forward_word','Unknown claimed result')
    g=certificate['added_histogram']
    require(len(g)==length and all(type(x) is int and x>=0 for x in g) and min(g)==0,
            'Not the least nonnegative solution')
    require(all(g[e['to']]-g[e['from']]==e['delta'] for e in edges),'Unsatisfied phase equation')
    result,cleanup=live.symbolic(m,counts,certificate['program'])
    # Verify the actual visit histogram by executing the same suffix on zero counts.
    added,_=live.symbolic(m,[[0]*len(counts) for _ in counts],certificate['program'])
    require(added==live.to_counts(m,g),'Program does not realize its offered added profile')
    for cycle in f.cyclic_model(m)[0]:
        require(all(result[s]==result[cycle[0]] for s in cycle),'Residual relative phase remains')
    require(result==certificate['result_counts'] and cleanup==certificate['cleanup_by_answer'],'Wrong scratch return')
    uses=sum(x['op']=='V' for x in certificate['program']);steps=sum(x.get('count',0) for x in certificate['program'])
    require(uses==sum(g)==certificate['minimum_V'] and
            steps==(length if any(g[1:]) else 0)==certificate['minimum_T'],'Wrong attained minimum')
    return {'minimum_V':uses,'minimum_T':steps}


@dataclass(frozen=True)
class FrameBoundary:
    prior: live.Boundary
    swapped: bool
    frame_source: str


class FramedOrbit:
    """The same physical carrier, one residual histogram and one frame bit.

    Frame changes are actual known Swap gates, not declarations of a new
    source. They remain available for transport only if the access is retained.
    """
    def __init__(self,m,port):
        self._live=live.LiveOrbit(m,port);self._swapped=False;self.swap_available=True;self.swap_calls=0
        self._swap=f.CONTROLS['Swap_BC']
        require(self._swap.shape==(len(m['q']),len(m['q'])),'This live frame adapter is the eight-row fixture')
        read=subprocess.run(['node',str(o.ROOT/'Checks/FiniteContinuation/orbit_frame_court.js'),'read'],
                            check=True,capture_output=True,text=True)
        self.frame_source=json.loads(read.stdout);self._permutation=self.frame_source['permutation']
        rows=self.frame_source['source']['rows']
        require([r['Control'] for r in rows]==m['q'] and
                [r['ProbeB']+2*r['ProbeParity'] for r in rows]==m['f'] and
                self.frame_source['source']['successor']==m['permutations']['T'],
                'Frame application belongs to another current Swift source')
        require(np.argmax(self._swap,axis=0).tolist()==self._permutation,'Coherent implementation disagrees with constructed coordinate exchange')
        require(all(m['q'][s]==m['q'][t] for s,t in enumerate(self._permutation)),'Frame changes the acquired question')

    def start(self,observables):
        require(not self._swapped,'Acquire before this frame has moved')
        return self._live.start(observables)

    def boundary(self):return FrameBoundary(self._live.boundary(),self._swapped,o.fingerprint(self.frame_source))

    def _check(self,boundary):
        require(boundary.swapped==self._swapped,'Wrong current source frame')
        require(boundary.frame_source==o.fingerprint(self.frame_source),'Different declared frame access')
        self._live._check_boundary(boundary.prior)

    def counts(self):
        return transported(self._live._counts,self._permutation) if self._swapped else self._live._counts

    def can_read(self,observables):
        self.boundary();counts=self.counts()
        return all(counts[s]==counts[t] for s,t in f.edges(self._live.m,observables))

    def change_frame(self):
        self.boundary();require(self.swap_available,'Known inverse frame access is unavailable')
        self._live._source(self._swap)
        self._live._ideal=np.kron(np.eye(self._live.data_dim),self._swap)@self._live._ideal
        self._swapped=not self._swapped;self.swap_calls+=1

    def source_action(self,name):
        self.boundary();require(name in f.CONTROLS and name!='Swap_BC','Use the actual frame-changing contact')
        matrix=f.CONTROLS[name];counts=self.counts();m=self._live.m
        for s,t in np.argwhere(matrix!=0):
            require(m['q'][s]==m['q'][t] and counts[s]==counts[t],'Action crosses an unresolved current phase')
        self._live._source(matrix)
        self._live._ideal=np.kron(np.eye(self._live.data_dim),matrix)@self._live._ideal

    def work(self,gate,port_index):self._live.work(gate,port_index)

    def strengthen(self,boundary,observables):
        self._check(boundary);f.edges(self._live.m,observables)
        if self.can_read(observables):return {'kind':'reuse','additional_V':0,'additional_T':0,'additional_Swap':0}
        # All obligations are checked before the first new physical action.
        require(self._live._port.owner is boundary.prior.phase_owner,'Changed unknown phase-bearing contact')
        if self._swapped:require(self.swap_available,'No retained known frame access for this constructor')
        old_counts=self._live._counts;plan=live.full_upgrade(self._live.m,old_counts)
        live.verify_upgrade(self._live.m,old_counts,plan)
        was_swapped=self._swapped
        if was_swapped:self.change_frame()
        requests=[self._swap.conj().T@e@self._swap for e in observables] if was_swapped else observables
        outcome=self._live.upgrade(self._live.boundary(),requests,plan)
        if was_swapped:self.change_frame()
        require(self.can_read(observables),'Transported strengthening missed the current request')
        return dict(outcome,additional_Swap=2 if was_swapped else 0,
                    transport='known inverse frame, old supplement, known frame')

    def audit_maps(self):return self._live.audit_maps()
    def audit_ideal(self):return self._live.audit_ideal()
