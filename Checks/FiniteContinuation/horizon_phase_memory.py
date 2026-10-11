#!/usr/bin/env python3
"""A finite-horizon classical continuation for arbitrary commuting phases.

The port's common frame/spectra construct the model; only forward() is used
by acquisition. The planner reads the requested horizon and error, not them.
Operator matrices are verifier semantics, not descriptions exposed to the
physical controller. The error bound is for the joint unconditioned record
and data output, NOT for every normalized postselected branch.
"""
from math import sin,cos,pi,ceil,log2
import numpy as np
import orbit_return as o
import memory_future_admission as f


def model(source):
    return {'schema':'vi.horizon-phase-memory.v1','source':source,
        'domain':'live source qubit with arbitrary finite E and arbitrary external correlations',
        'relation':'fixed U1=U0 R, U0 and R unitary and commuting; unrestricted spectra',
        'access':'forward V, protected swap, known coherent integer controls, finite Fourier read',
        'future':'record-selected finite source words with a declared maximum number of V calls',
        'error':'trace distance of joint classical record and source/reference output, before postselection'}


def weights(n):
    o.require(type(n) is int and n>=1,'Positive spectral width required')
    return np.sqrt(2/(n+1))*np.sin(pi*(np.arange(n)+1)/(n+1))


def rms(n):return 2*sin(pi/(2*(n+1)))


def plan(m,horizon,error):
    o.require(type(horizon) is int and horizon>=1,'Finite positive horizon required')
    o.require(0<error<1,'Nontrivial trace-distance tolerance required')
    n=1
    while horizon*rms(n)>error:n+=1
    result={'schema':'vi.horizon-phase-plan.v1','model':o.fingerprint(m),
        'horizon':horizon,'tolerance':error,'spectral_width':n,'readout_values':n+1,
        'forward_queries':n-1,'record_bits':ceil(log2(n+1)),
        'bound':horizon*rms(n)}
    verify(m,result);return result


def verify(m,p):
    o.require(p['schema']=='vi.horizon-phase-plan.v1' and p['model']==o.fingerprint(m),'Different current contract')
    n=p['spectral_width'];weights(n)
    o.require(type(p['horizon']) is int and p['horizon']>=1 and 0<p['tolerance']<1,'Bad future obligation')
    o.require(p['readout_values']==n+1 and p['forward_queries']==n-1,'Readout alias or hidden query price')
    o.require(p['record_bits']==ceil(log2(n+1)),'Wrong finite record size')
    o.require(abs(p['bound']-p['horizon']*rms(n))<1e-14 and p['bound']<=p['tolerance'],'Unsupported error promise')
    return p['bound']


class CommutingPhasePort:
    def __init__(self,m,basis,common_angles,relative_angles):
        basis=np.array(basis,complex);d=len(common_angles)
        o.require(d>0 and len(relative_angles)==d and basis.shape==(d,d),'Bad producing dimensions')
        o.require(np.max(abs(basis.conj().T@basis-np.eye(d)))<1e-12,'Not a unitary frame')
        self.model=o.fingerprint(m);self.owner=object();self.dimension=d
        self._u0=basis@np.diag(np.exp(1j*np.array(common_angles)))@basis.conj().T
        self._r=basis@np.diag(np.exp(1j*np.array(relative_angles)))@basis.conj().T
        self._v=np.kron(self._u0,np.diag([1,0]))+np.kron(self._u0@self._r,np.diag([0,1]))
        for x in (self._u0,self._r,self._v):x.flags.writeable=False

    def forward(self,matrix):return self._v@matrix


def acquire(m,port,n):
    """Physically execute the integer program on the SAME live source.

    Wires indexed S + 2*(E + d*(P + 2*T)). Initial P,T are zero;
    T is prepared with known sine weights. Original S goes into P. For each
    k the comparison t>k toggles S, one V is called, then S is restored.
    No source or memory eigenbasis is read by the acquisition algorithm.
    """
    o.require(type(port) is CommutingPhasePort and port.model==o.fingerprint(m),'No producing relation for this port')
    d=port.dimension;D=n+1;c=weights(n);size=4*d*D
    live=np.zeros((size,2*d),complex)
    for t,ct in enumerate(c):live[4*d*t:4*d*t+2*d]=ct*np.eye(2*d)
    def swap(matrix):
        out=np.zeros_like(matrix)
        for row in range(size):
            s=row%2;e=(row//2)%d;p=(row//(2*d))%2;t=row//(4*d)
            out[p+2*(e+d*(s+2*t))]=matrix[row]
        return out
    def toggle(matrix,k):
        out=np.zeros_like(matrix)
        for row in range(size):
            s=row%2;t=row//(4*d)
            out[row-s+(s^int(t>k))]=matrix[row]
        return out
    live=swap(live)
    for k in range(n-1):
        live=toggle(live,k)
        for start in range(0,size,2*d):live[start:start+2*d]=port.forward(live[start:start+2*d])
        live=toggle(live,k)
    live=swap(live)
    fourier=np.exp(-2j*pi*np.outer(np.arange(D),np.arange(D))/D)/np.sqrt(D)
    live=(fourier@live.reshape(D,-1)).reshape(size,2*d)
    branches={}
    for y in range(D):
        block=live[4*d*y:4*d*(y+1)]
        o.require(np.max(abs(block[2*d:]))<1e-12,'Protected register did not return to zero')
        branches[y]=block[:2*d]
    # Measuring T then shifting its actual y to zero returns the workspace.
    return branches


def expected(port,n):
    c=weights(n);D=n+1;common=np.linalg.matrix_power(port._u0,n-1)
    return {y:common@sum(c[t]*np.exp(-2j*pi*y*t/D)*np.linalg.matrix_power(port._r,t)
                          for t in range(n))/np.sqrt(D) for y in range(D)}


def word_unitary(port,word):
    result=np.eye(2*port.dimension,dtype=complex)
    for name in word:
        if name=='V':result=port.forward(result)
        else:
            o.require(name in ('H_source','S_source'),'Outside declared future')
            result=np.kron(np.eye(port.dimension),f.H if name=='H_source' else f.S)@result
    return result


def compiled_word(y,D,word):
    result=np.eye(2,dtype=complex);phase=np.diag([1,np.exp(2j*pi*y/D)])
    for name in word:
        o.require(name in ('V','H_source','S_source'),'Outside declared future')
        result=(phase if name=='V' else f.H if name=='H_source' else f.S)@result
    return result


class BudgetedContinuation:
    """A consumed future budget accompanies the acquired actual record.

    The Kraus rows below represent reduced quantum outputs of the physical
    instrument. They are not state tomography available to the controller.
    All decisions use y, the plan, and remaining budget only.
    """
    def __init__(self,m,p,port):
        verify(m,p);self.plan=dict(p);self.model=o.fingerprint(m)
        self._acquisition=acquire(m,port,p['spectral_width'])
        d=port.dimension;self.remaining={y:p['horizon'] for y in self._acquisition}
        self.branches={y:[k[2*e:2*e+2].copy() for e in range(d)] for y,k in self._acquisition.items()}
        self.actions={y:[] for y in self.branches}

    def step(self,y,name):
        o.require(y in self.branches,'Not an acquired record')
        o.require(name in ('V','H_source','S_source'),'New access needs a new guarantee')
        if name=='V':
            o.require(self.remaining[y]>0,'Future horizon exhausted; reacquisition or a new bound is required')
            self.remaining[y]-=1
        u=compiled_word(y,self.plan['readout_values'],[name])
        self.branches[y]=[u@k for k in self.branches[y]];self.actions[y].append(name)


def comparison(port,n,acquisition,words):
    """Verifier: common E motion may be included in a dilation then discarded."""
    differences=[];raw={};compiled={}
    for y,k in acquisition.items():
        word=words[y];raw[y]=word_unitary(port,word)@k
        common=np.linalg.matrix_power(port._u0,word.count('V'))
        compiled[y]=np.kron(common,compiled_word(y,n+1,word))@k
        differences.append(raw[y]-compiled[y])
    gram=sum(x.conj().T@x for x in differences)
    return float(np.sqrt(max(0,np.linalg.eigvalsh(gram)[-1]))),raw,compiled
