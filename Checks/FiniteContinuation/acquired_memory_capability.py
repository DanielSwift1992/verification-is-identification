#!/usr/bin/env python3
"""Acquire a continuation capability without learning the hidden memory frame.

The policy receives one opaque contact from a producing family, never its kind
or basis. Measurements act on a temporary source probe; the original unknown
source is protected by two real swaps and restored. All paths are represented
as unnormalized Kraus maps, so arbitrary input and reference correlations are
part of the verification, not assumptions about a chosen basis preparation.
"""
from copy import deepcopy
import numpy as np

import orbit_return as o
import memory_future_admission as f

require=o.require
PLUS=np.array([1,1],complex)/np.sqrt(2)


def initial(dimension):return np.kron(PLUS[:,None],np.eye(2*dimension))


def source_probe_swap(dimension):
    swap=np.zeros((4*dimension,4*dimension),complex)
    for p in (0,1):
        for e in range(dimension):
            for s in (0,1):swap[p+2*e+2*dimension*s,s+2*e+2*dimension*p]=1
    return swap


INITIAL=initial(2)
SWAP_SP=source_probe_swap(2)


def model(source):
    return {'schema':'vi.unknown-framed-memory-capability.v1','source':source,
            'source_domain':'A=B=0, live C is S, persistent E is an arbitrary declared finite carrier',
            'family':'either commuting U0^4=I and U1=U0 R with R^2=I, or U0^4=I and U1^4=-I; unknown operators',
            'probe_access':'one independent Xplus P, coherent Swap(S,P), X measurement of S, recorded-Z correction on P',
            'future':'words in the same V, H_source, S_source; terminal source readings'}


class HiddenFrameDevice:
    def __init__(self,m,kind,basis):
        require(kind in ('common_factor','phase_memory','rotating_memory'),'No producing contact for that family')
        require(basis.shape==(2,2) and np.max(abs(basis.conj().T@basis-f.I))<1e-12,'Not one fixed unitary memory frame')
        self.model=o.fingerprint(m);self.owner=object()
        self.dimension=2
        transform=np.kron(basis,f.I)
        self._unitary=transform@f.controlled(f.contacts(kind))@transform.conj().T
        self._unitary.setflags(write=False)

    def forward(self,carrier):
        require(carrier.shape[0] in (2*self.dimension,4*self.dimension),'Wrong physical S/E carrier')
        return (self._unitary if len(carrier)==2*self.dimension else np.kron(f.I,self._unitary))@carrier


class HiddenRelationDevice(HiddenFrameDevice):
    """Producing spectra for two operator-relation families, arbitrary finite E.

    Low-memory: U0 and R share a hidden basis, with fourth-root and sign spectra.
    General-memory: U0 and U1 have independent hidden bases, with fourth powers
    I and -I. Neither basis, the roots nor the branch kind enter the policy.
    """
    def __init__(self,m,roots0,basis0,*,signs=None,roots1=None,basis1=None):
        dimension=len(roots0)
        require(dimension>0 and all(type(x) is int and 0<=x<4 for x in roots0),'Not a fourth-root spectrum')
        def unitary_basis(b):
            require(b.shape==(dimension,dimension) and np.max(abs(b.conj().T@b-np.eye(dimension)))<1e-12,
                    'Not a fixed finite memory basis')
        unitary_basis(basis0)
        u0=basis0@np.diag([1j**x for x in roots0])@basis0.conj().T
        if signs is not None:
            require(roots1 is None and basis1 is None and len(signs)==dimension and all(x in (-1,1) for x in signs),
                    'Not the common-frame binary-relative construction')
            r=basis0@np.diag(signs)@basis0.conj().T;u1=u0@r
        else:
            require(roots1 is not None and len(roots1)==dimension and
                    all(type(x) is int and 0<=x<4 for x in roots1),'Missing opposite-fourth-power construction')
            unitary_basis(basis1)
            u1=np.exp(1j*np.pi/4)*basis1@np.diag([1j**x for x in roots1])@basis1.conj().T
        self.model=o.fingerprint(m);self.owner=object();self.dimension=dimension
        self._unitary=np.zeros((2*dimension,2*dimension),complex)
        for s,u in enumerate((u0,u1)):
            self._unitary[s::2,s::2]=u
        self._unitary.setflags(write=False)


def probe_episode(device,matrix,contacts):
    """Uses Xplus P, reads S in X, returns old S and P=Xplus on each branch."""
    require(contacts in (1,4),'Unavailable acquisition episode')
    dimension=device.dimension;swap=source_probe_swap(dimension)
    live=swap@matrix
    for _ in range(contacts):live=device.forward(live)
    result={}
    for answer in (0,1):
        projector=(f.I+(-1)**answer*f.X)/2
        branch=np.kron(np.eye(2*dimension),projector)@live
        branch=swap@branch
        if answer:branch=np.kron(f.Z,np.eye(2*dimension))@branch
        result[answer]=branch
    return result


def ready_map(matrix):
    """Contract a factor proven ready, never postselect an unknown probe."""
    embedding=initial(matrix.shape[1]//2);result=embedding.conj().T@matrix
    require(np.max(abs(matrix-embedding@result))<1e-12,'Probe did not return on the full input')
    return result


class Acquisition:
    def __init__(self,m,port):
        require(type(port) in (HiddenFrameDevice,HiddenRelationDevice) and port.model==o.fingerprint(m),
                'Need the producing current-family contact, not a family label')
        self.model=deepcopy(m);self.port=port;self.owner=port.owner
        self._done=False;self.full_branches={};self.costs={}

    def acquire(self):
        require(not self._done,'No fresh preparation over the retained carrier')
        require(self.port.owner is self.owner,'Another acquisition occurrence')
        # Both outcomes of the physical instrument exist in this representation;
        # the policy never examines hidden amplitudes to choose its branch.
        modes=probe_episode(self.port,initial(self.port.dimension),4)
        for h,matrix in modes.items():
            if h==1:
                key=(1,None);self.full_branches[key]=ready_map(matrix)
                self.costs[key]={'V':4,'swaps':2,'reads':1,'probe_supply':1}
            else:
                for z,branch in probe_episode(self.port,matrix,1).items():
                    key=(0,z);self.full_branches[key]=ready_map(branch)
                    self.costs[key]={'V':5,'swaps':4,'reads':2,'probe_supply':1}
        self._done=True
        return LearnedContinuation(self)


class LearnedContinuation:
    """The active carrier is chosen by h alone; a stored z belongs to this input.

    A classical branch has output dimension two (source only), represented by
    its Kraus maps from the original SE input. Quantum branches keep SE. The
    discarded E is never read or prepared by this controller.
    """
    def __init__(self,acquisition):
        require(type(acquisition) is Acquisition and acquisition._done,
                'A continuation needs the actual completed acquisition')
        self.model=deepcopy(acquisition.model);self.port=acquisition.port;self.owner=acquisition.owner
        self.dimension=self.port.dimension
        self.costs=deepcopy(acquisition.costs)
        self.branches={};self.future_V={};self.steps=0
        for key,matrix in acquisition.full_branches.items():
            h,z=key
            if h==1:self.branches[key]=[matrix.copy()]
            else:self.branches[key]=[matrix[2*e:2*e+2,:].copy() for e in range(self.dimension)]
            self.future_V[key]=0

    def step(self,name):
        require(self.port.owner is self.owner and self.port.model==o.fingerprint(self.model),
                'Continuation is not bound to this same device occurrence')
        require(name in ('V','H_source','S_source'),'No acquired implementation of this new access')
        for key,maps in list(self.branches.items()):
            h,z=key
            if name=='V' and h==1:
                self.branches[key]=[self.port.forward(k) for k in maps];self.future_V[key]+=1
            else:
                gate=(f.Z if z else f.I) if name=='V' else (f.H if name=='H_source' else f.S)
                if h==1:gate=np.kron(np.eye(self.dimension),gate)
                self.branches[key]=[gate@k for k in maps]
        self.steps+=1

    def source_effect(self,effect):
        require(effect.shape==(2,2),'Read an actual source effect')
        result=np.zeros((2*self.dimension,2*self.dimension),complex)
        for (h,z),maps in self.branches.items():
            output_effect=np.kron(np.eye(self.dimension),effect) if h==1 else effect
            result+=sum(k.conj().T@output_effect@k for k in maps)
        return result

    def audit_after(self,word):
        """Fork mathematical maps for alternative checks, not a physical clone."""
        other=object.__new__(LearnedContinuation)
        other.model=deepcopy(self.model);other.port=self.port;other.owner=self.owner
        other.dimension=self.dimension
        other.costs=deepcopy(self.costs);other.future_V=deepcopy(self.future_V);other.steps=self.steps
        other.branches={key:[k.copy() for k in maps] for key,maps in self.branches.items()}
        for name in word:other.step(name)
        return other
