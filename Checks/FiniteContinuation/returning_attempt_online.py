#!/usr/bin/env python3
"""Unknown-horizon execution in the existing finite returning-attempt language.

Cost: returning probe=2, echo goal=2, learned one-call goal=1. Arbitrary finite
task count is not passed to the controller. Random guarantees assume independent
private coins and an oblivious task horizon. Default is deterministic.
"""
from fractions import Fraction as F
from functools import lru_cache
import json
from pathlib import Path
import secrets

import returning_attempt_learning as learning
import returning_boundary_admission as boundary
from returning_attempt_sdk_checks import read_instrument
from returning_attempt_sdk import Ports
from qiskit import qpy

WEIGHTS = ((0,54),(1,72),(2,96),(3,128),(None,81))
DENOMINATOR=431
RANDOM_RATIO=F(512,431)
DETERMINISTIC_RATIO=F(11,8)


def offline(n, acquisition_allowed=True):
    """Comparator knows N, NOT the hidden law; it has the same entry/access."""
    learning.require(type(n) is int and n>0,'Positive number of arrived tasks')
    return min(2*n,n+4) if acquisition_allowed else 2*n


def threshold_cost(n, threshold):
    return 2*n if threshold is None or n<=threshold else n+threshold+4


def select_threshold(ticket):
    learning.require(type(ticket) is int and 0<=ticket<DENOMINATOR,'Ticket outside the declared finite domain')
    for threshold,count in WEIGHTS:
        if ticket<count:return threshold
        ticket-=count
    raise AssertionError('Incomplete ticket partition')


def upper_certificate():
    return {'schema':'vi.returning-online-upper.v1','deterministic_threshold':3,
            'deterministic_ratio':str(DETERMINISTIC_RATIO),
            'random_weights':[[t,str(F(w,DENOMINATOR))] for t,w in WEIGHTS],
            'random_ratio':str(RANDOM_RATIO),
            'scope':'Every fixed N and law, expectation over independent private coins only; comparator knows N but not the hidden law, with same admissible catalogue.'}


def verify_upper(cert):
    """Rational finite coefficients certify ALL integer horizons, not a cutoff."""
    learning.require(cert['schema']=='vi.returning-online-upper.v1','Wrong upper certificate')
    t=cert['deterministic_threshold'];r=F(cert['deterministic_ratio'])
    learning.require(type(t) is int and t==3 and r>=1,'Unsupported deterministic shape')
    for n in range(1,5):learning.require(threshold_cost(n,t)<=r*offline(n),'False prefix bound')
    # For N>=4: R(N+4)-(N+7) has nonnegative slope and value at N=4.
    learning.require(r-1>=0 and 8*r-11>=0,'Unbounded deterministic tail')
    weights=[(t,F(p)) for t,p in cert['random_weights']]
    learning.require(len({t for t,_ in weights})==len(weights) and
                     all(t is None or (type(t) is int and 0<=t<=3) for t,_ in weights) and
                     all(p>=0 for _,p in weights) and sum(p for _,p in weights)==1,'Invalid distribution')
    r=F(cert['random_ratio'])
    for n in range(1,5):
        learning.require(sum(p*threshold_cost(n,t) for t,p in weights)<=r*offline(n),'False expected prefix')
    slope=sum(p*(2 if t is None else 1) for t,p in weights)
    intercept=sum(p*(t+4) for t,p in weights if t is not None)
    learning.require(r-slope>=0 and 8*r-(4*slope+intercept)>=0,'Unbounded expected tail')
    return {'all_horizons':True,'tail_coefficients':[str(slope),str(intercept)]}


def lower_certificate(source,reserve=2):
    """Bellman potential for an independent uniform law/geometric horizon.

    A task ends the stream with probability 1/4 AFTER it is completed. Each
    probe uses the actual posterior, including partial/repeated/Residue probes.
    Values lower-bound EVERY policy in the catalogue, not only thresholds.
    """
    rows={};probes=tuple(p for p in learning.EPISODES if learning.admission(p)['admitted'])
    def key(s,r):return ','.join(map(str,s))+'/'+str(r)

    @lru_cache(None)
    def value(support,remaining):
        control=learning.shared_control(source,support)
        candidates=[F(8)]
        if control is not None:candidates.append(F(4))
        if remaining:
            for p in probes:
                branches=learning.successors(source,support,p)
                candidates.append(2+sum(F(len(post),len(support))*value(post,remaining-1)
                                        for post in branches.values()))
        answer=min(candidates)
        rows[key(support,remaining)]={'support':list(support),'remaining':remaining,'value':str(answer)}
        return answer
    support=tuple(range(len(source['rows'])))
    root=value(support,reserve)
    return {'schema':'vi.returning-online-lower.v1','source':learning.fingerprint(source),
            'stop_probability':'1/4','initial_law':'uniform on the eight declared rows',
            'reserve':reserve,'probes':list(probes),'root':key(support,reserve),'nodes':rows,
            'root_value':str(root),'expected_offline':'431/64','ratio':str(RANDOM_RATIO)}


def verify_lower(source,cert):
    """Check a subsolution for every action without invoking an optimizer."""
    learning.require(cert['schema']=='vi.returning-online-lower.v1' and cert['source']==learning.fingerprint(source),
                     'Wrong lower-bound source')
    learning.require(cert['stop_probability']=='1/4' and cert['reserve']==2 and len(source['rows'])==8,
                     'Different lower-bound experiment')
    probes=tuple(p for p in learning.EPISODES if learning.admission(p)['admitted'])
    learning.require(cert['probes']==list(probes),'Omitted admitted contact')
    def key(s,r):return ','.join(map(str,s))+'/'+str(r)
    root=key(tuple(range(8)),2);learning.require(cert['root']==root,'Wrong initial posterior')
    nodes=cert['nodes'];visited=set()
    def visit(name):
        if name in visited:return
        visited.add(name);node=nodes[name];s=tuple(node['support']);r=node['remaining'];v=F(node['value'])
        learning.require(s and list(s)==sorted(set(s)) and 0<=r<=2 and key(s,r)==name,'Bad potential address')
        learning.require(0<=v<=8 and v<=2+F(3,4)*v,'Echo violates lower potential')
        if learning.shared_control(source,s) is not None:
            learning.require(v<=1+F(3,4)*v,'Single work violates lower potential')
        if r:
            for p in probes:
                children=learning.successors(source,s,p)
                rhs=F(2)
                for post in children.values():
                    child=key(post,r-1);learning.require(child in nodes,'Missing possible continuation')
                    visit(child);rhs+=F(len(post),len(s))*F(nodes[child]['value'])
                learning.require(v<=rhs,'Returning query violates lower potential')
    visit(root)
    learning.require(set(nodes)==visited and F(cert['root_value'])==F(nodes[root]['value'])==8,'Bad root potential')
    # E N=4. E min(N,4)=1+3/4+(3/4)^2+(3/4)^3=175/64.
    expected_offline=F(4)+sum(F(3,4)**i for i in range(4))
    learning.require(F(cert['expected_offline'])==expected_offline and
                     F(cert['ratio'])==8/expected_offline,'Wrong comparator expectation')
    return {'potential_states':len(nodes),'all_actions_checked':True,
            'expected_cost_lower_bound':'8','expected_offline':str(expected_offline),'ratio':str(8/expected_offline)}


def acquisition_admission(future):
    """Bind the promise to the previously established actual instrument."""
    boundary.verified_parent()
    with (boundary.PARENT/'acquired-0.qpy').open('rb') as f:q,=qpy.load(f)
    return boundary.admit(boundary.residual_instrument(q),future)


class OnlineReturning:
    """Receive one task at a time. The total count is absent from this API.

    LocalPort executes the CQ law model. If the independently checked future
    promise forbids acquisition, use the source-coherence-preserving echo.
    Random ticket injection is for deterministic replay/testing; real expected
    guarantees require that its uniform independent provenance be supplied.
    """
    def __init__(self,source,port,future,*,mode='deterministic',ticket=None):
        learning.require(source==learning.read_source(),'Online model is not the current source reading')
        learning.require(port.source==learning.fingerprint(source) and port.mode=='ready','Wrong input boundary')
        learning.require(mode in ('deterministic','randomized'),'Unknown online policy')
        self.source=source;self.port=port;self.completed=0;self.ability=None
        self._has_payload=False;self._waited=0;self._commands=0
        self.knowledge=learning.Knowledge(source,port.owner)
        self.admission=acquisition_admission(future)
        self.can_acquire=self.admission['admitted'] and port.reserve>=2
        if mode=='randomized':
            self.threshold=select_threshold(secrets.randbelow(DENOMINATOR) if ticket is None else ticket)
        else:
            learning.require(ticket is None,'Deterministic policy has no random input')
            self.threshold=3
        if not self.can_acquire:self.threshold=None
        self.mode=mode

    def arrive(self,gate):
        # New payload is an input supplied between completed goals, never a
        # recreation of the previous unknown datum during repair.
        start=len(self.port.events)
        if self._has_payload:self.port.new_payload()
        if self.ability is None and self.threshold is not None and self._waited>=self.threshold:
            cert=learning.synthesize(self.source,support=self.knowledge.support,reserve=self.port.reserve)
            self.ability,self.knowledge=learning.learn(self.source,self.port,cert,self.knowledge)
        if self.ability is None:learning.echo(self.port,gate)
        else:self.ability.apply(self.port,gate)
        if self.ability is None and self.threshold is not None:
            self._waited=min(self.threshold,self._waited+1)
        self._has_payload=True
        self._commands+=sum(e[0] in ('probe','repair','work') for e in self.port.events[start:])
        # completed and commands are accounting outputs, not policy inputs.
        self.completed+=1
        return {'completed':self.completed,'commands':self.cost(),'acquired':self.ability is not None,
                'remaining_reserve':self.port.reserve,'compatible_laws':len(self.knowledge.support)}

    def cost(self):
        return self._commands
