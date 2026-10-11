#!/usr/bin/env python3
"""Choose between two PRESENTED continuations from actual receiver resources.

Not a complete planner for all quantum programs. A missing candidate is
unresolved, never a physical impossibility certificate. No hidden matrices,
phase values, or device type labels occur in choose().
"""
from copy import deepcopy
import numpy as np
import orbit_return as o
import horizon_phase_memory as h


def choose(m,request):
    q=deepcopy(request);L=q['horizon'];eps=q['error']
    o.require(type(L) is int and L>=1 and 0<=eps<1,'Finite future and nontrivial tolerance required')
    for name in ('future_port_queries','preparation_queries','classical_values'):
        o.require(type(q[name]) is int and q[name]>=0,'Negative or noninteger resource budget')
    o.require(type(q['can_receive_E_and_port']) is bool,'Declare actual receiving access')
    result={'schema':'vi.continuation-resource-choice.v1','model':o.fingerprint(m),'request':q}
    if q['error_scope']!='joint_record_source_reference':
        return result|{'route':'unresolved','reason':'No construction for that error question'}
    # For 0<eps<1, the fresh sine-window construction always needs MORE
    # preparation V queries than L. See the report's dominance argument.
    if q['can_receive_E_and_port'] and q['future_port_queries']>=L:
        return result|{'route':'keep_access','preparation_queries':0,'future_queries':L,
                       'classical_values':0,'error_bound':0.}
    if eps==0:
        return result|{'route':'unresolved','reason':'These presented candidates provide no exact released boundary'}
    p=h.plan(m,L,eps)
    missing={name:{'needed':need,'available':q[name]} for name,need in
             (('preparation_queries',p['forward_queries']),('classical_values',p['readout_values'])) if need>q[name]}
    if missing:return result|{'route':'unresolved','reason':'Presented release construction exceeds resources','missing':missing}
    return result|{'route':'release_access','phase_plan':p,'preparation_queries':p['forward_queries'],
                   'future_queries':0,'classical_values':p['readout_values'],'error_bound':p['bound']}


def verify(m,selection):
    o.require(selection==choose(m,selection['request']),'Selection does not follow from this current demand and available constructions')
    if selection['route']=='release_access':h.verify(m,selection['phase_plan'])
    return selection['route']


class Handoff:
    def __init__(self,m,selection,port):
        route=verify(m,selection)
        o.require(route!='unresolved','No presented continuation: '+selection.get('reason',''))
        o.require(type(port) is h.CommutingPhasePort and port.model==o.fingerprint(m),'Wrong producing contact')
        self.selection=deepcopy(selection);self.route=route;self.model=o.fingerprint(m)
        self._owner=port.owner;self._dimension=port.dimension
        self._prepared_cost=selection['preparation_queries']
        if route=='keep_access':
            self.port=port;self.carrier=np.eye(2*port.dimension,dtype=complex)
            self.remaining={None:selection['request']['horizon']};self.words={None:[]}
        else:
            self.released=h.BudgetedContinuation(m,selection['phase_plan'],port)
            self.remaining=self.released.remaining;self.words=self.released.actions
            # The receiver has the actual CQ instrument output, not E or V.
            self.port=None

    def step(self,record,name):
        o.require(name in ('V','H_source','S_source'),'A new kind of access needs a new construction')
        if self.route=='release_access':
            self.released.step(record,name);return
        o.require(record is None,'Retained route has no acquired phase record')
        o.require(self.port.owner is self._owner and self.port.model==self.model,'This is not the retained contact')
        if name=='V':
            o.require(self.remaining[None]>0,'Declared future call budget is exhausted')
            self.carrier=self.port.forward(self.carrier);self.remaining[None]-=1
        else:self.carrier=np.kron(np.eye(self._dimension),h.f.H if name=='H_source' else h.f.S)@self.carrier
        self.words[None].append(name)

    def source_effect(self,effect):
        if self.route=='keep_access':
            return self.carrier.conj().T@np.kron(np.eye(self._dimension),effect)@self.carrier
        return sum(k.conj().T@effect@k for maps in self.released.branches.values() for k in maps)
