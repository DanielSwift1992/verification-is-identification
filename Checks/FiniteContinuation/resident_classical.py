#!/usr/bin/env python3
"""Service acquisition, followed by owned classical control of quantum D,E.

An execution adapter for the current Swift root. The control bit is derived
from an actual Install record and subsequent acts, never an initial argument.
The finite rational checker is specific to this Pauli/control fragment.
"""
import argparse
from collections import deque
from copy import deepcopy
from fractions import Fraction as F
from functools import lru_cache
from hashlib import sha256
from itertools import product
import json
from pathlib import Path
import subprocess

import numpy as np
from qiskit.quantum_info import Operator

import resident_acquisition as m
import resident_memory as r
import whole_word_admission as a
from build_from_source import HERE, ROOT, run
from environment import digest, write


@lru_cache(maxsize=2)
def current_source(key):
    return json.loads(run(['node', HERE/'resident_classical_court.js', 'read']))


def validate(reading):
    key=tuple((n,digest(ROOT/n)) for n in sorted(reading['source_sha256']))
    if dict(key)!=reading['source_sha256']: raise ValueError('Classical service root changed')
    key+=tuple((str(p),digest(p)) for p in [HERE/'resident_classical_court.js',HERE/'resident_acquisition_court.js',HERE/'resident_program_court.js',HERE/'court_bridge.js'])
    if current_source(key)!=reading: raise ValueError('Not the current service reading')
    m.validate(reading['acquisition'])
    if reading['quantum_ports']!=['ResidentDataPort','ResidentServicePort'] or reading['payload']!=reading['quantum_ports'][0]:
        raise ValueError('Unsupported ordered quantum ports')
    for axis,probe in reading['probes'].items():
        if probe!={'port':reading['quantum_ports'][1],'question':'ResidentAcquisitionRoot.Probe'+axis}:
            raise ValueError('Service acquisition address changed')


def projector(reading,axis,bit):
    if axis not in reading['probes'] or bit not in (0,1): raise ValueError('Unsupported service question')
    probe=reading['acquisition']['probes'][axis]
    return (a.I+(-1)**probe['records'].index(bit)*a.P[a.NAMES.index(probe['observable'])])/2


def instrument(reading,axis,mode,bit,*,relative=False):
    if mode not in ('Toggle','Install'): raise ValueError('This service interface admits Toggle and Install')
    measured=np.kron(a.I,projector(reading,axis,bit))
    return [np.kron(k,measured) for k in m.control(reading['acquisition'],mode+str(bit),reduced=relative)]


def compression():
    """PCDE -> RDE: discard PC coherence, retain every D,E matrix element."""
    result=[]
    for p,c in product((0,1),repeat=2):
        k=np.zeros((2,4));k[p^c,2*p+c]=1
        result.append(np.kron(k,np.eye(4)))
    return result


def gate_at(reading,bit):
    matches=[row for row in reading['controls'] if row['bit']==bit]
    if len(matches)!=1: raise ValueError('Missing unique relative instruction')
    row=matches[0]
    return np.kron({'JointHLabel':a.H,'JointSLabel':a.S}[row['gate']],a.P[a.NAMES.index(reading['memory_action'][1:])]),row['next']


def relative_tick(reading):
    out=np.zeros((8,8),complex)
    for bit in (0,1):
        g,nxt=gate_at(reading,bit);k=np.zeros((2,2));k[nxt,bit]=1;out+=np.kron(k,g)
    return out


def quantum_reopen(reading):
    if reading['reopen']!='JointCZLabel': raise ValueError('Unsupported service contact')
    return np.diag([1,1,1,-1])


def reopen(reading,*,full=False):
    return np.kron(np.eye(4) if full else np.eye(2),quantum_reopen(reading))


def branch_map(reading,axis,mode,bit):
    table=m.control_table(reading['acquisition'],mode+str(bit))
    probe=reading['acquisition']['probes'][axis];sigma=probe['observable']
    sign=F((-1)**probe['records'].index(bit));result=[]
    for p,c,d,e in r.KEYS:
        terms=[]
        if e in ('I',sigma):
            for (pp,cc),target in table.items():
                if target==(p,c):
                    terms.extend([(r.INDEX[pp,cc,d,e],F(1,2)),
                                  (r.INDEX[pp,cc,d,sigma if e=='I' else 'I'],sign/2)])
        result.append(terms)
    return result


def selective_space(reading):
    actions=r.maps(reading['acquisition']['interpreter'])
    for mode,axis,b in product(('Toggle','Install'),reading['probes'],(0,1)):
        actions[f'{axis}:{mode}:{b}']=branch_map(reading,axis,mode,b)
    span=r.Span();queue=deque();basis=[]
    def add(v,q,word):
        if span.add(v):
            item={'vector':v,'question':q,'word':word};basis.append(item);queue.append(item)
    for q in ('I','X','Y','Z'): add(r.query(q),q,[])
    while queue:
        item=queue.popleft()
        for name,mapping in actions.items(): add(r.push(item['vector'],mapping),item['question'],[name]+item['word'])
    for item in basis:
        for mapping in actions.values(): assert not any(span.residual(r.push(item['vector'],mapping)))
    return {'dimension':len(basis),'maximum_witness_depth':max(len(x['word']) for x in basis),'actions':list(actions),
            'renewals':{n:all(r.push(x['vector'],r.renewal_map(n))==x['vector'] for x in basis) for n in r.RENEWALS},
            'basis':[{'question':x['question'],'word':x['word'],'vector':[[i,str(v)] for i,v in enumerate(x['vector']) if v]} for x in basis],
            'scope':'All finite selective service X/Z Toggle/Install, ticks and CZ_DE contacts; terminal D Pauli questions with unnormalized transcript weights.'}


def acquired_control(reading,history):
    """Fold owned acts. No density inspection or guess supplies the seed."""
    bit=None
    for event in history:
        if 'acquisition' in event:
            rec=event['acquisition'];mode=rec['mode'];b=rec['bit']
            if rec['source']!=a.fingerprint(reading) or rec['axis'] not in reading['probes'] or b not in (0,1):
                raise ValueError('Record does not belong to this source')
            table=m.relative_table(reading['acquisition'],mode+str(b))
            if mode=='Install':
                if len(set(table.values()))!=1: raise ValueError('Install did not acquire a common control')
                bit=table[0]
            elif bit is not None: bit=table[bit]
        elif event.get('action')=='tick' and bit is not None: bit=gate_at(reading,bit)[1]
        elif event.get('action')=='reopen' or event.get('transfer')=='classical': pass
        elif event.get('action')!='tick': raise ValueError('Unrecognized owned history')
    if bit is None: raise ValueError('No actual Install acquisition supplies initial control')
    return bit


def sample(branches,rng):
    p=np.array([np.trace(v).real for v in branches])
    if np.min(p)<-1e-10 or not np.isclose(p.sum(),1,atol=1e-10): raise ValueError('Invalid service instrument probabilities')
    p=np.maximum(p,0);p/=p.sum();b=int(rng.choice(2,p=p))
    if p[b]<=0: raise ValueError('Unavailable service branch')
    return b,branches[b]/np.trace(branches[b]).real,float(p[b])


_TRANSFER=object()


class ServiceResident:
    """A full PCDE owner. Future allowed actions are deliberately explicit."""
    def __init__(self,reading,state,*,rng=None):
        self.reading=deepcopy(reading);validate(self.reading)
        self._state=np.array(state,complex,copy=True);self._quantum_dim=16
        if self._state.ndim!=2 or self._state.shape[0]!=self._state.shape[1] or len(self._state)%16:
            raise ValueError('Invalid PCDE/reference carrier')
        if not np.allclose(self._state,self._state.conj().T) or not np.isclose(np.trace(self._state),1) or np.linalg.eigvalsh(self._state).min() < -1e-10:
            raise ValueError('Invalid resident density')
        self._reference=len(state)//16;self._history=[];self._released=False
        self._rng=np.random.default_rng() if rng is None else rng
        self._source=a.fingerprint(reading);self._classical=None
        self._implementation={str(p):digest(p) for p in [Path(__file__),HERE/'resident_acquisition.py',HERE/'resident_memory.py',HERE/'whole_word_admission.py']}
        self._seal()

    def _content(self):
        return a.fingerprint({'source':self.reading,'history':self._history,'relative':self._classical,
                              'dimension':self._quantum_dim,'reference':self._reference,
                              'state':sha256(np.ascontiguousarray(self._state).tobytes()).hexdigest()})

    def _seal(self): self._sealed=self._content()

    def check(self):
        if self._released: raise ValueError('Resident state already transferred')
        validate(self.reading)
        if self._source!=a.fingerprint(self.reading) or self._sealed!=self._content(): raise ValueError('Owned state, record or source changed outside an act')
        if any(digest(Path(p))!=h for p,h in self._implementation.items()): raise ValueError('Resident implementation changed')
        if self._classical is not None and acquired_control(self.reading,self._history)!=self._classical:
            raise ValueError('Classical control lost its acquired source')

    def tick(self):
        self.check()
        if self._classical is None: g=Operator(r.circuit(self.reading['acquisition']['interpreter'])).data
        else: g,self._classical=gate_at(self.reading,self._classical)
        self._state=a.apply([g],self._state,self._reference);self._history.append({'action':'tick'});self._seal()

    def reopen(self):
        self.check();g=reopen(self.reading,full=True) if self._classical is None else quantum_reopen(self.reading)
        self._state=a.apply([g],self._state,self._reference);self._history.append({'action':'reopen'});self._seal()

    def acquire(self,axis,mode='Toggle'):
        self.check()
        if mode not in ('Toggle','Install'): raise ValueError('Unavailable service action')
        if self._classical is None: ks=[instrument(self.reading,axis,mode,b) for b in (0,1)]
        else: ks=[[np.kron(a.I,projector(self.reading,axis,b))] for b in (0,1)]
        branches=[a.apply(k,self._state,self._reference) for k in ks]
        b,state,p=sample(branches,self._rng)
        if self._classical is not None: self._classical=m.relative_table(self.reading['acquisition'],mode+str(b))[self._classical]
        self._state=state
        record={'axis':axis,'mode':mode,'bit':b,'source':self._source,'ordinal':len(self._history),'conditional_probability':p}
        self._history.append({'acquisition':record});self._seal();return deepcopy(record)

    def classicalize(self):
        self.check()
        if self._classical is not None: raise ValueError('Already classical control')
        bit=acquired_control(self.reading,self._history)
        # Actual Install has prepared a known PC pair. Subsequent permitted
        # branches keep it known. Trace PC; keep full DE and any reference.
        n=4*self._reference;state=np.trace(self._state.reshape(4,n,4,n),axis1=0,axis2=2)
        next_owner=ClassicalService(_TRANSFER,self,state,bit)
        self._state=None;self._released=True
        return next_owner

    def snapshot(self):
        self.check();return self._state.copy(),deepcopy(self._history)

    def control_record(self):
        self.check()
        return acquired_control(self.reading,self._history)


class ClassicalService(ServiceResident):
    """Only an actual owner transfer constructs this local continuation."""
    def __init__(self,token,owner,state,bit):
        if token is not _TRANSFER: raise ValueError('Classical control requires owned acquisition transfer')
        owner.check()
        if acquired_control(owner.reading,owner._history)!=bit: raise ValueError('Supplied control is not acquired')
        self.reading=deepcopy(owner.reading);self._source=owner._source;self._implementation=deepcopy(owner._implementation)
        self._reference=owner._reference;self._rng=owner._rng;self._quantum_dim=4
        self._state=state.copy();self._classical=bit;self._released=False
        self._history=deepcopy(owner._history)+[{'transfer':'classical'}];self._seal()


def build(directory):
    directory.mkdir(parents=True,exist_ok=True)
    proof=json.loads(run(['node',HERE/'resident_classical_court.js','build',directory]))
    native=ROOT/'.build/arm64-apple-macosx/debug/Tools'
    log=run([native,'judge','where',directory/'ResidentClassical.swift'])
    assert f"{proof['equalities']} equalities" in log and 'THE WHERE holds' in log
    for item in proof['negatives']:
        got=subprocess.run([str(native),'judge','where',str(directory/item['file'])],capture_output=True,text=True,timeout=30)
        assert got.returncode==1 and 'requires the types' in got.stdout+got.stderr
    proof['native']=log.strip();proof['implementation_sha256']={str(p.relative_to(ROOT)):digest(p) for p in [Path(__file__),HERE/'resident_classical_court.js']}
    write(directory/'build.json',proof);return proof


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    result=build(p.parse_args().output.resolve());print(json.dumps({'equalities':result['equalities'],'refusals_each_court':len(result['negatives'])}))
