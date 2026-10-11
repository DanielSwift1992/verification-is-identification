#!/usr/bin/env python3
"""Continue an already executed acquisition on the same live carrier.

The planner receives a finite phase-visit profile, actual source/model binding
and the retained answer access, never the unknown phases or input state.
This is an operator-level local device model, not a hardware trust boundary.
"""
from dataclasses import dataclass
import json

import numpy as np
import orbit_return as o
import orbit_future as f

require=o.require


def to_counts(m,h):
    cycles,length=f.cyclic_model(m);n=len(m['q'])
    require(len(h)==length and all(type(x) is int and x>=0 for x in h),'Bad active phase profile')
    counts=[[0]*n for _ in range(n)]
    for cycle in cycles:
        for z,s in enumerate(cycle):
            for r,value in enumerate(h):counts[s][cycle[(z+r)%length]]=value
    return counts


def histogram(m,counts):
    cycles,length=f.cyclic_model(m);n=len(m['q']);h=None
    for cycle in cycles:
        for z,s in enumerate(cycle):
            require(all(counts[s][x]==0 for x in range(n) if x not in cycle),'Profile escaped its cycle')
            row=[counts[s][cycle[(z+r)%length]] for r in range(length)]
            require(all(type(x) is int and x>=0 for x in row),'Not an actual nonnegative phase count')
            if h is None:h=row
            require(row==h,'No common cyclic profile for this constructor')
    return h


def normalized(m,counts):
    result=[row[:] for row in counts];common=min(histogram(m,counts))
    for cycle in f.cyclic_model(m)[0]:
        for s in cycle:
            for x in cycle:result[s][x]-=common
    return result


def symbolic(m,counts,program):
    n=len(m['q']);result=[row[:] for row in counts];work=[0]*n;shift=0
    _,length=f.cyclic_model(m);t=m['permutations']['T'];inverse=np.argsort(t).tolist()
    for action in program:
        if action['op']=='V':
            require(set(action)=={'op'},'An oracle action cannot embed an answer')
            for s in range(n):result[s][s]+=1;work[s]^=m['f'][s]
        else:
            require(action['op']=='T' and set(action)=={'op','count'} and
                    type(action['count']) is int and 0<=action['count']<length,'Unavailable source step')
            for _ in range(action['count']):
                result=[result[inverse[s]][:] for s in range(n)]
                work=[work[inverse[s]] for s in range(n)];shift=(shift+1)%length
    require(shift==0,'Extension does not return the actual source')
    cleanup={}
    for s,a in enumerate(m['q']):
        key=str(a)
        require(key not in cleanup or cleanup[key]==work[s],'Cannot clean suffix work from retained answer')
        cleanup[key]=work[s]
    return result,cleanup


def full_upgrade(m,counts):
    """Least nonnegative completion to a uniform cycle profile, no phase read."""
    h=histogram(m,counts);height=max(h);deficit=[height-x for x in h]
    current=0;program=[];length=len(h)
    for offset,uses in enumerate(deficit):
        if not uses:continue
        steps=(offset-current)%length
        if steps:program.append({'op':'T','count':steps})
        program.extend({'op':'V'} for _ in range(uses));current=offset
    if current:program.append({'op':'T','count':(-current)%length})
    result,cleanup=symbolic(m,counts,program)
    certificate={'schema':'vi.live-orbit-extension.v1','model':o.fingerprint(m),
        'from_counts':counts,'histogram':h,'deficit':deficit,'program':program,
        'cleanup_by_answer':cleanup,'result_counts':result,
        'minimum_additional_V':length*height-sum(h),
        'minimum_additional_T':length if any(deficit[1:]) else 0}
    verify_upgrade(m,counts,certificate);return certificate


def verify_upgrade(m,counts,cert):
    require(cert['schema']=='vi.live-orbit-extension.v1' and cert['model']==o.fingerprint(m),
            'Extension belongs to another current source')
    require(cert['from_counts']==counts,'Extension belongs to another actual residual profile')
    h=histogram(m,counts);height=max(h);deficit=[height-x for x in h]
    require(cert['histogram']==h and cert['deficit']==deficit,'Invented missing phase visits')
    result,cleanup=symbolic(m,counts,cert['program'])
    require(cert['result_counts']==result and cert['cleanup_by_answer']==cleanup,'Wrong actual extension effect')
    for s,a in enumerate(m['q']):
        for t,b in enumerate(m['q']):
            require(a!=b or result[s]==result[t],'Full future not established')
    uses=sum(x['op']=='V' for x in cert['program']);steps=sum(x.get('count',0) for x in cert['program'])
    require(cert['minimum_additional_V']==len(h)*height-sum(h)==uses,'Not the exact minimum added V count')
    require(cert['minimum_additional_T']==(len(h) if any(deficit[1:]) else 0)==steps,'Not the exact minimum added T count')
    return uses,steps


class StaticPhasePort:
    """The declared simulator device. Its phase tuple never changes here."""
    def __init__(self,m,phases):
        require(len(phases)==len(m['q']) and all(abs(abs(z)-1)<1e-12 for z in phases),'Wrong phase domain')
        self.model=o.fingerprint(m);self.owner=object();self._phases=tuple(complex(z) for z in phases)

    def forward(self,live):
        require(live.model_hash==self.model,'Different source at the contact')
        n=live.n;wdim=live.wdim;adim=live.adim
        for record,matrix in list(live._branches.items()):
            out=np.zeros_like(matrix)
            for row in range(live.size):
                s=row%n;w=(row//n)%wdim;tail=row//(n*wdim)
                out[s+n*((w^live.m['f'][s])+wdim*tail)]=self._phases[s]*matrix[row]
            live._branches[record]=out


@dataclass(frozen=True)
class Boundary:
    carrier: object
    phase_owner: object
    answer_access: object
    model: str
    profile: tuple


class LiveOrbit:
    """One retained S,W,O,D,E carrier. No method retries by preparing S/D/E.

    Full maps and ideal maps are audits, not planner inputs. Active controller
    memory is the counts modulo a question-only phase and the bound answer
    access. Encapsulation is functional; arbitrary Python code is not sandboxed.
    """
    def __init__(self,m,port):
        self.m=json.loads(json.dumps(m));self.model_hash=o.fingerprint(m)
        require(port.model==self.model_hash,'Wrong physical port model')
        self._port=port;self._owner=port.owner;self._carrier=object();self._answer=None
        self.n=len(m['q']);self.wdim=1<<m['work_bits'];self.adim=1<<max(m['q']).bit_length()
        self.data_dim=4;self.input_dim=self.n*self.data_dim
        self.size=self.n*self.wdim*self.adim*self.data_dim
        matrix=np.zeros((self.size,self.input_dim),complex)
        for d in range(self.data_dim):
            for s in range(self.n):matrix[s+self.n*self.wdim*self.adim*d,s+self.n*d]=1
        self._branches={None:matrix};self._ideal=np.eye(self.input_dim,dtype=complex)
        self._h=[0]*f.cyclic_model(m)[1];self._work=[0]*self.n;self._shift=0
        self.V_calls=0;self.T_calls=0;self.copy_calls=0;self.read_calls=0

    @property
    def _counts(self):
        # Expanded only for checking/application. The controller keeps one
        # cyclic histogram, not a history or a table of unknown phases.
        return to_counts(self.m,self._h)

    def _source(self,u):
        for a,matrix in list(self._branches.items()):
            blocks=matrix.reshape(-1,self.n,self.input_dim)
            self._branches[a]=np.einsum('st,btc->bsc',u,blocks).reshape(self.size,self.input_dim)

    def _probe(self):
        require(self._port.owner is self._owner,'Source table does not establish the same phase-bearing contact')
        self._port.forward(self)
        self._h[0]+=1
        for s in range(self.n):self._work[s]^=self.m['f'][s]
        self.V_calls+=1

    def _tick(self,count):
        t=self.m['permutations']['T'];inverse=np.argsort(t).tolist()
        p=np.zeros((self.n,self.n));p[t,np.arange(self.n)]=1
        for _ in range(count):
            self._source(p);self._h=self._h[1:]+self._h[:1]
            self._work=[self._work[inverse[s]] for s in range(self.n)]
            self.T_calls+=1;self._shift=(self._shift+1)%f.cyclic_model(self.m)[1]

    def _copy(self,decoder):
        require(self._answer is None and self.copy_calls==0,'No new answer copy over the acquired record')
        for a,matrix in list(self._branches.items()):
            out=np.zeros_like(matrix)
            for row in range(self.size):
                s=row%self.n;w=(row//self.n)%self.wdim;o0=(row//(self.n*self.wdim))%self.adim
                d=row//(self.n*self.wdim*self.adim)
                out[s+self.n*(w+self.wdim*((o0^decoder.get(str(w),0))+self.adim*d))]=matrix[row]
            self._branches[a]=out
        self.copy_calls+=1

    def _clean(self,cleanup):
        for a,matrix in list(self._branches.items()):
            out=np.zeros_like(matrix)
            for row in range(self.size):
                s=row%self.n;w=(row//self.n)%self.wdim;tail=row//(self.n*self.wdim);o0=tail%self.adim
                out[s+self.n*((w^cleanup.get(str(o0),0))+self.wdim*tail)]=matrix[row]
            self._branches[a]=out
        for s,a in enumerate(self.m['q']):self._work[s]^=cleanup[str(a)]
        require(self._shift==0 and not any(self._work),'Working carrier did not return')

    def _read(self):
        require(self._answer is None and list(self._branches)==[None],'No repeated preparation/measurement of q')
        matrix=self._branches[None];branches={}
        for a in sorted(set(self.m['q'])):
            out=matrix.copy()
            for row in range(self.size):
                if (row//(self.n*self.wdim))%self.adim!=a:out[row]=0
            if np.any(out):branches[a]=out
        self._branches=branches;self._answer=object();self.read_calls+=1

    def boundary(self):
        require(self._answer is not None and self._shift==0 and not any(self._work),'No acquired ready boundary')
        return Boundary(self._carrier,self._owner,self._answer,self.model_hash,tuple(self._h))

    def _check_boundary(self,boundary):
        actual=self.boundary()
        require(boundary.carrier is actual.carrier and boundary.phase_owner is actual.phase_owner
                and boundary.answer_access is actual.answer_access and boundary.model==actual.model
                and boundary.profile==actual.profile,'Not an application to this live boundary')

    def start(self,observables):
        require(self._answer is None and self.V_calls==0,'This carrier has already acquired; do not restart it')
        plan=f.optimal(self.m,observables);f.verify(self.m,observables,plan)
        for j,k in enumerate(plan['powers']):
            self._probe()
            if j==0:self._copy(plan['computed']['decoder'])
            self._tick(k)
        self._clean(plan['computed']['cleanup_by_answer']);self._read()
        floor=min(self._h);self._h=[x-floor for x in self._h]
        return plan

    def can_read(self,observables):
        self.boundary()
        counts=self._counts
        return all(counts[s]==counts[t] for s,t in f.edges(self.m,observables))

    def upgrade(self,boundary,observables,certificate=None):
        self._check_boundary(boundary)
        f.edges(self.m,observables)  # cross-q requests cannot be repaired after q was measured
        if self.can_read(observables):return {'kind':'reuse','additional_V':0,'additional_T':0}
        require(self._port.owner is boundary.phase_owner,
                'Strengthening requires the same phase-bearing contact; old safe readings do not')
        counts=to_counts(self.m,list(boundary.profile))
        cert=certificate if certificate is not None else full_upgrade(self.m,counts)
        uses,steps=verify_upgrade(self.m,counts,cert)
        for command in cert['program']:
            if command['op']=='V':self._probe()
            else:self._tick(command['count'])
        self._clean(cert['cleanup_by_answer']);floor=min(self._h);self._h=[x-floor for x in self._h]
        require(self.can_read(observables),'Upgraded boundary does not serve its current recipient')
        return {'kind':'extended','additional_V':uses,'additional_T':steps,'certificate':cert}

    def source_action(self,name):
        self.boundary();require(name in f.CONTROLS,'Unavailable continuation')
        u=f.CONTROLS[name];counts=self._counts
        for s in range(self.n):
            for t in range(self.n):
                if u[s,t]!=0:require(self.m['q'][s]==self.m['q'][t] and counts[s]==counts[t],
                                    'Continuation changes an unestablished relative phase')
        self._source(u);self._ideal=np.kron(np.eye(self.data_dim),u)@self._ideal

    def work(self,gate,port_index):
        """Actual W_a(G) followed by correction from the already-read O."""
        self.boundary();require(port_index in (0,1),'Wrong live data port')
        require(gate.shape==(2,2) and np.max(abs(gate.conj().T@gate-np.eye(2)))<1e-12,'Bad working action')
        u=np.kron(np.eye(2),gate) if port_index==0 else np.kron(gate,np.eye(2))
        for a,matrix in list(self._branches.items()):
            shaped=matrix.reshape(self.data_dim,-1,self.input_dim)
            out=np.einsum('pq,qrc->prc',u,shaped).reshape(self.size,self.input_dim)
            for row in range(self.size):
                s=row%self.n;o0=(row//(self.n*self.wdim))%self.adim
                d=row//(self.n*self.wdim*self.adim)
                out[row]*=(-1)**((self.m['q'][s]^o0)*((d>>port_index)&1))
            self._branches[a]=out
        self._ideal=np.kron(u,np.eye(self.n))@self._ideal

    def audit_maps(self):
        self.boundary();result={}
        for a,matrix in self._branches.items():
            indices=[s+self.n*self.wdim*(a+self.adim*d) for d in range(self.data_dim) for s in range(self.n)]
            allowed=set(indices)
            require(max((float(np.max(abs(matrix[row]))) for row in range(self.size) if row not in allowed),default=0)<1e-12,
                    'Actual output disagrees with ready-work/retained-answer boundary')
            result[a]=matrix[indices,:]
        return result

    def audit_ideal(self):
        return {a:np.kron(np.eye(self.data_dim),np.diag([int(q==a) for q in self.m['q']]))@self._ideal
                for a in sorted(set(self.m['q']))}
