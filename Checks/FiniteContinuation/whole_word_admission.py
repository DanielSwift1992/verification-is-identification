#!/usr/bin/env python3
"""Whole-word frame and scoped, sampled admission on a constructed local source.

This is not an IBM calibration or a new parser. Exact frame relations come
from the existing court; CPTP/coverage/statistical arguments are separate.
Only the simulator's complete, fixed DE channel supplies the temporal link.
"""
import argparse
from copy import deepcopy
from functools import lru_cache
import hashlib
import json
from pathlib import Path
import subprocess

import numpy as np
from scipy.special import betaincinv
from qiskit.quantum_info import Operator,Kraus,SuperOp,DensityMatrix

from environment import digest,write
from build_from_source import ROOT,HERE,run
from joint_returns import choose,validate,check_source
from planner import synthesize

I=np.eye(2,dtype=complex);X=np.array([[0,1],[1,0]],complex)
Y=np.array([[0,-1j],[1j,0]],complex);Z=np.diag([1.,-1.]).astype(complex)
H=(X+Z)/np.sqrt(2);S=np.diag([1.,1j]);P=(I,X,Y,Z);NAMES=('I','X','Y','Z')


def fingerprint(value):
    return hashlib.sha256(json.dumps(value,sort_keys=True,separators=(',',':')).encode()).hexdigest()


def channel_digest(ks):
    # The complete CP map, not a nonunique choice of Kraus coordinates.
    a=np.asarray(SuperOp(Kraus(ks)).data,dtype=np.complex128)
    return hashlib.sha256(a.tobytes()).hexdigest()


def blocks(ks,u):
    m=ks[0].shape[1]//2;out=ks[0].shape[0]//2
    assert all(k.shape==(2*out,2*m) for k in ks) and Kraus(ks).is_cptp(atol=1e-10)
    normalized=[(np.kron(u.conj().T,np.eye(out))@k).reshape(2,out,2,m) for k in ks]
    bs=[[np.einsum('ij,iajb->ab',p.conj(),k)/2 for k in normalized] for p in P]
    gamma=sum((b.conj().T@b for branch in bs[1:] for b in branch),np.zeros((m,m),complex))
    assert np.linalg.eigvalsh(gamma).min()>-1e-10 and np.linalg.eigvalsh(gamma).max()<1+1e-10
    return bs,gamma


def twirled(ks,u,frames=None):
    m=ks[0].shape[1]//2;out=ks[0].shape[0]//2
    if frames is None:
        pairs=[(p,u@p@u.conj().T) for p in P]
    else:
        pairs=[(P[NAMES.index(f['before'])],P[NAMES.index(f['after'])]) for f in frames]
    # Discard the seed at the interface. Kraus alternatives are not an
    # extra classical output; no operation is inserted inside W.
    return [np.kron(post,np.eye(out))@k@np.kron(pre,np.eye(m))/2 for pre,post in pairs for k in ks]


def apply(ks,rho,reference=1):
    return sum((np.kron(k,np.eye(reference))@rho@np.kron(k.conj().T,np.eye(reference)) for k in ks),
               np.zeros((ks[0].shape[0]*reference,)*2,complex))


def bell_memory(tau):
    # Tensor order D,E,R_D. E may itself be a reduced state of another reference.
    m=len(tau);rho=np.zeros((2,m,2,2,m,2),complex)
    for d in range(2):
        for e in range(2):rho[d,:,d,e,:,e]=tau/2
    return rho.reshape(4*m,4*m)


def bell_failure(ks,u,tau):
    out=ks[0].shape[0]//2
    normalized=[np.kron(u.conj().T,np.eye(out))@k for k in ks]
    rho=apply(normalized,bell_memory(tau),2)
    return float(np.clip(1-np.trace(bell_memory(np.eye(out))@rho).real,0,1))


def upper_binomial(failures,n,alpha):
    if type(n) is not int or type(failures) is not int or not 0<=failures<=n or n<=0 or not 0<alpha<1:
        raise ValueError('Invalid fixed-binomial evidence')
    if failures==n:return 1.
    # One-sided Clopper-Pearson. Numerical endpoint padded upward; exact
    # coverage belongs to the beta-quantile formula, not floating arithmetic.
    return min(1.,float(betaincinv(failures+1,n-failures,1-alpha))+1e-12)


def ideal(word):
    u=I.copy()
    for g in word:u={'h':H,'s':S}[g]@u
    return u


@lru_cache(maxsize=2)
def current_frames(key):return json.loads(run(['node',HERE/'whole_word_frame.js','read']))


def validate_frames(data):
    key=tuple((n,digest(ROOT/n)) for n in sorted(data['frame_source_sha256']))
    if dict(key)!=data['frame_source_sha256']:raise ValueError('Current frame root changed')
    key+=tuple((str(p),digest(p)) for p in [HERE/'whole_word_frame.js',HERE/'joint_return_court.js',HERE/'court_bridge.js'])
    if current_frames(key)!=data:raise ValueError('Frame reading not derived from the current root')
    check_source(data['source'])
    # Independently connect the computed control profile to SDK matrices.
    basis={'I':I,'X':X,'Z':Z,'XZ':X@Z}
    for name,profile in data['controls'].items():
        for b in profile:
            if not np.allclose(1j**b['phase']*basis[b['word']],P[NAMES.index(name)],atol=1e-12):
                raise ValueError('Control name does not match its actual computed operation')


class LocalWord:
    """An explicit complete local channel and its private-output frame.

    Equal hashes bind the constructed simulator, not physical device stability.
    The simulator prepares the entire declared E on each calibration shot.
    No hardware receipt can enter this constructor as a law assertion.
    """
    def __init__(self,frames,*,model='Moving',word=('h',),residual_sine=.02,tau=None):
        validate_frames(frames)
        if model not in ('Keep','Moving') or not 0<=residual_sine<=1:raise ValueError('Unsupported local source')
        self.frames=deepcopy(frames);self.word=list(word);self.model=model
        matches=[r for r in frames['rows'] if r['question']==self.word]
        if len(matches)!=1:raise ValueError('Question outside the checked control catalogue')
        self.frame=deepcopy(matches[0]['frames']);self.u=ideal(self.word)
        packet=choose(frames['source'],self.word,[model],[1,1])
        self.body=[o for o in validate(frames['source'],packet,self.word,[model],[1,1]) if o['gate']!='refresh']
        a=np.eye(4,dtype=complex)
        for o in self.body:
            if o['gate']=='cz':g=np.diag([1,1,1,-1])
            else:g=np.kron({'h':H,'s':S}[o['gate']],I) if o['target']=='D' else np.kron(I,{'h':H,'s':S}[o['gate']])
            a=g@a
        # Concrete coherent residual at the word boundary, before frame close.
        v=np.sqrt(1-residual_sine**2)*I-1j*residual_sine*X
        self.ks=[np.kron(v,I)@a]
        self.tau=np.array(I/2 if tau is None else tau,dtype=complex)
        if self.tau.shape!=(2,2) or not np.allclose(self.tau,self.tau.conj().T) or not np.isclose(np.trace(self.tau),1) or np.linalg.eigvalsh(self.tau).min()<-1e-12:
            raise ValueError('Invalid actual calibration preparation')
        self.wrapped=twirled(self.ks,self.u,self.frame)
        self.origin=self.binding();self.records=[]

    def binding(self):
        return {'scope':'constructed_fixed_complete_DE_channel','carrier':[2,2],
                'law_sha256':channel_digest(self.ks),'interface_sha256':channel_digest(self.wrapped),
                'question':self.word,'frame':self.frame,'body':self.body,
                'tau_sha256':hashlib.sha256(self.tau.tobytes()).hexdigest(),
                'source_sha256':self.frames['frame_source_sha256'],
                'seed_output':'absent','implementation_sha256':digest(Path(__file__))}

    def check(self):
        validate_frames(self.frames)
        if self.binding()!=self.origin:raise ValueError('Source, preparation, boundary or actual interface changed')

    def acquire(self,*,n=4096,alpha=.01,simulation_seed=20260915):
        self.check()
        if self.records:raise ValueError('One fixed acquisition; no repeated search for a favourable interval')
        if type(n) is not int or n<=0 or not 0<alpha<1:raise ValueError('Invalid acquisition design')
        probability=bell_failure(self.wrapped,self.u,self.tau)
        raw=np.random.default_rng(simulation_seed).random(n)<probability
        record={'schema':'vi.local-fixed-channel-bell.v1','binding':deepcopy(self.origin),
                'shots':n,'failures':int(raw.sum()),'alpha':alpha,
                'raw_bit_sha256':hashlib.sha256(np.packbits(raw).tobytes()).hexdigest(),
                'simulation_seed':simulation_seed,
                'statistics':'Fixed IID simulation law, one prespecified binomial interval; not retrospective IBM martingale evidence.'}
        self.records.append(deepcopy(record));return record

    def decision(self,record,*,tolerance,question=None,seed_output=False,prior=()):
        self.check()
        if record not in self.records:raise ValueError('Evidence was not acquired from this current constructed interface')
        if question is not None and question!=self.word:raise ValueError('A different question needs its own application')
        if seed_output:raise ValueError('This averaged interface does not export the seed')
        if not 0<=tolerance<=1:raise ValueError('Invalid consumer tolerance')
        eigen=float(np.linalg.eigvalsh(self.tau).min())
        if eigen<=1e-12:return {'kind':'needs_coverage','reason':'Calibration does not cover the complete E carrier'}
        upper=upper_binomial(record['failures'],record['shots'],record['alpha'])
        # In this constructed local executor the wrapper, preparations and
        # analyzer are the specified ideal matrices, and the same full map is
        # reused. No caller-provided physical zeta or temporal flag is accepted.
        epsilon=min(1.,upper/eigen)
        def application(limit,number):
            total=1-(1-epsilon)**number
            # Worst-case primitive count: body, one constructed residual,
            # and two external Pauli controls. No free direct U is added.
            admitted={'whole_word_private_frame':{'physical_gates':len(self.body)+3}} if total<=limit else {}
            policy=synthesize({'valid':[list(admitted)],'actions':admitted,'probes':[]})['tree']
            return {'kind':'act' if policy['kind']=='act' else 'needs_evidence','tolerance':limit,
                'bell_failure_upper':upper,'coverage_min_eigenvalue':eigen,'one_use_bound':epsilon,
                'total_bound':total,'use_number':number,'binding':deepcopy(self.origin),
                'evidence_sha256':fingerprint(record),'alpha':record['alpha'],
                'scope':'Product family U x arbitrary CPTP memory; full constructed DE and arbitrary reference; private fresh uniform frames.'}
        for index,p in enumerate(prior):
            if p!=application(p['tolerance'],index+1) or p['kind']!='act':
                raise ValueError('Prior use not derived from the same admitted instrument')
        return application(tolerance,len(prior)+1)

    def execute(self,record,packet,rho,*,prior=()):
        expected=self.decision(record,tolerance=packet['tolerance'],prior=prior)
        if packet!=expected or packet['kind']!='act':raise ValueError('No current admissible application')
        if rho.shape[0]!=rho.shape[1] or rho.shape[0]%4:raise ValueError('Wrong complete carrier/reference')
        if not np.allclose(rho,rho.conj().T) or not np.isclose(np.trace(rho),1) or np.linalg.eigvalsh(rho).min()<-1e-10:
            raise ValueError('Invalid input state')
        reference=rho.shape[0]//4
        return DensityMatrix(rho).evolve(Kraus([np.kron(k,np.eye(reference)) for k in self.wrapped])).data


class LocalContinuation:
    """Own the simulated state and the actual applications made to it.

    No caller-supplied past epsilon/history enters step(). This is a local
    quantum-state lifecycle, not a persistent external-device journal.
    """
    def __init__(self,source,record,rho,*,tolerance):
        self.source=source;self.record=deepcopy(record);self.tolerance=tolerance
        self._state=np.array(rho,complex,copy=True);self._history=[]

    def step(self):
        p=self.source.decision(self.record,tolerance=self.tolerance,prior=self._history)
        if p['kind']=='act':
            following=self.source.execute(self.record,p,self._state,prior=self._history)
            self._state=following;self._history.append(deepcopy(p))
        return p

    def snapshot(self):return self._state.copy(),deepcopy(self._history)


def build(directory):
    directory.mkdir(parents=True,exist_ok=True)
    proof=json.loads(run(['node',HERE/'whole_word_frame.js','build',directory]))
    native=ROOT/'.build/arm64-apple-macosx/debug/Tools'
    log=run([native,'judge','where',directory/'WholeWordFrames.swift'])
    assert f"{proof['equalities']} equalities" in log and 'THE WHERE holds' in log
    for r in proof['negatives']:
        v=subprocess.run([str(native),'judge','where',str(directory/r['file'])],capture_output=True,text=True,timeout=30)
        assert v.returncode==1 and 'requires the types' in v.stdout+v.stderr
    proof['native']=log.strip()
    proof['implementation_sha256']={str(p.relative_to(ROOT)):digest(p) for p in
        [Path(__file__),HERE/'whole_word_frame.js',HERE/'joint_returns.py',HERE/'joint_return_court.js',HERE/'planner.py',HERE/'court_bridge.js']}
    proof['artifact_sha256']={n:digest(directory/n) for n in ['WholeWordFrames.swift','frame-reading.json']}
    write(directory/'build.json',proof);return proof


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',required=True,type=Path)
    result=build(p.parse_args().output.resolve())
    print(json.dumps({'equalities':result['equalities'],'refusals_each_court':len(result['negatives'])},indent=2))
