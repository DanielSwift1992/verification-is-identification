#!/usr/bin/env python3
"""A bounded current-root joint meter/write/relative-return executor.

Raw digits remain internal. The returned bit is physically acquired from
post-write PC parity. No universal instrument compiler or extra VI kernel.
"""
import argparse
from copy import deepcopy
from functools import lru_cache
from hashlib import sha256
from itertools import product
import json
from pathlib import Path
import subprocess

import numpy as np
from qiskit.quantum_info import Operator

import resident_classical as m
import resident_memory as r
import whole_word_admission as a
from build_from_source import ROOT,HERE,run
from environment import digest,write


@lru_cache(maxsize=2)
def current_source(key): return json.loads(run(['node',HERE/'resident_framed_court.js','read']))


def validate(reading):
    key=tuple((n,digest(ROOT/n)) for n in sorted(reading['source_sha256']))
    if dict(key)!=reading['source_sha256']: raise ValueError('Framed contact root changed')
    key+=tuple((str(p),digest(p)) for p in [HERE/'resident_framed_court.js',HERE/'resident_classical_court.js',HERE/'court_bridge.js'])
    if current_source(key)!=reading: raise ValueError('Not the current joint contact reading')
    m.validate(reading['service'])
    if {tuple(row['input']) for row in reading['rows']}!=set(product((0,1),repeat=2)): raise ValueError('Incomplete frame carrier')
    for row in reading['rows']:
        for branches in row['frames'].values():
            if {x['raw'] for x in branches}!={0,1}: raise ValueError('Meter branches not binary bijections')
            for x in branches:
                if x['after']!=[x['raw'],row['input'][1]] or x['returned']!=x['after']:
                    raise ValueError('Raw write or post-write return address detached')


def relative_table(reading,frame):
    if frame not in ('Program','Clock'): raise ValueError('Unknown meter frame')
    table={}
    for row in reading['rows']:
        p,c=row['input']
        for b,item in enumerate(row['frames'][frame]):
            q=item['returned'];key=(p^c,b);value=q[0]^q[1]
            if key in table and table[key]!=value: raise ValueError('Joint return does not descend through relative control')
            table[key]=value
    return table


def raw_instrument(reading,axis,frame,y):
    if frame not in ('Program','Clock') or y not in (0,1): raise ValueError('Unsupported raw instrument')
    # The parity meter is followed by resetting P to its own raw y. The two
    # Kraus labels discard old P while preserving coherence on C until the
    # subsequent actual relative-return contact.
    out=[np.zeros((16,16),complex) for _ in (0,1)]
    for row in reading['rows']:
        p,c=row['input']
        for b,item in enumerate(row['frames'][frame]):
            if item['raw']!=y: continue
            pc=np.zeros((4,4));pp,cc=item['after'];pc[2*pp+cc,2*p+c]=1
            out[p]+=np.kron(pc,np.kron(a.I,m.projector(reading['service'],axis,b)))
    return out


def post_parity(t):
    return np.kron(np.diag([int(p^c==t) for p,c in product((0,1),repeat=2)]),np.eye(4))


def instrument(reading,axis,frame,t,*,kind='full',control=None):
    if t not in (0,1): raise ValueError('Invalid returned relative bit')
    table=relative_table(reading,frame)
    if kind=='full': return [post_parity(t)@k for y in (0,1) for k in raw_instrument(reading,axis,frame,y)]
    if kind not in ('relative','classical'): raise ValueError('Unknown resident carrier')
    if kind=='classical' and control not in (0,1): raise ValueError('No acquired classical control')
    result=[]
    for old in ((control,) if kind=='classical' else (0,1)):
        for b in (0,1):
            if table[old,b]!=t: continue
            g=np.kron(a.I,m.projector(reading['service'],axis,b))
            if kind=='relative':
                rr=np.zeros((2,2));rr[t,old]=1;g=np.kron(rr,g)
            result.append(g)
    return result


class FramedProcess:
    """Owns one state. Raw y and service eigenlabel b are not API answers."""
    def __init__(self,reading,state,*,rng=None):
        self.reading=deepcopy(reading);validate(self.reading)
        self._state=np.array(state,complex,copy=True)
        if self._state.ndim!=2 or self._state.shape[0]!=self._state.shape[1] or len(self._state)%16:
            raise ValueError('Expected full PCDE/reference state')
        if not np.allclose(self._state,self._state.conj().T) or not np.isclose(np.trace(self._state),1) or np.linalg.eigvalsh(self._state).min() < -1e-10:
            raise ValueError('Invalid density')
        self._reference=len(state)//16;self._kind='full';self._control=None
        self._history=[];self._released=False;self._source=a.fingerprint(reading)
        self._rng=np.random.default_rng() if rng is None else rng
        self._implementation={str(p):digest(p) for p in [Path(__file__),HERE/'resident_classical.py',HERE/'resident_memory.py',HERE/'whole_word_admission.py']}
        self._seal()

    def _content(self):
        return a.fingerprint({'source':self.reading,'history':self._history,'kind':self._kind,'control':self._control,
                              'reference':self._reference,'state':sha256(np.ascontiguousarray(self._state).tobytes()).hexdigest()})

    def _seal(self): self._sealed=self._content()

    def check(self):
        if self._released: raise ValueError('State already transferred')
        validate(self.reading)
        if self._source!=a.fingerprint(self.reading) or self._sealed!=self._content(): raise ValueError('Owned source, state or history changed')
        if any(digest(Path(p))!=h for p,h in self._implementation.items()): raise ValueError('Joint contact implementation changed')
        bit=None
        for event in self._history:
            if 'relative_return' in event: bit=event['relative_return']['value']
            elif event.get('action')=='tick' and bit is not None: bit=m.gate_at(self.reading['service'],bit)[1]
        if bit!=self._control: raise ValueError('Current control is not derived from acquired returns')

    def tick(self):
        self.check();s=self.reading['service']
        if self._kind=='full': g=Operator(r.circuit(s['acquisition']['interpreter'])).data
        elif self._kind=='relative': g=m.relative_tick(s)
        else:g=m.gate_at(s,self._control)[0]
        self._state=a.apply([g],self._state,self._reference)
        if self._control is not None:self._control=m.gate_at(s,self._control)[1]
        self._history.append({'action':'tick'});self._seal()

    def reopen(self):
        self.check();s=self.reading['service']
        g=m.quantum_reopen(s) if self._kind=='classical' else m.reopen(s,full=self._kind=='full')
        self._state=a.apply([g],self._state,self._reference);self._history.append({'action':'reopen'});self._seal()

    def acquire(self,axis,frame='Program'):
        self.check()
        branches=[a.apply(instrument(self.reading,axis,frame,t,kind=self._kind,control=self._control),self._state,self._reference) for t in (0,1)]
        t,state,p=m.sample(branches,self._rng);self._state=state;self._control=t
        record={'value':t,'question':'post_write_relative_control','axis':axis,'frame':frame,
                'conditional_probability':p,'source':self._source,'ordinal':len(self._history)}
        self._history.append({'relative_return':record});self._seal();return deepcopy(record)

    def _transfer(self,state,kind):
        out=object.__new__(FramedProcess)
        out.__dict__=deepcopy({k:v for k,v in self.__dict__.items() if k not in ('_rng','_state')})
        out._rng=self._rng;out._state=state.copy();out._kind=kind
        out._history.append({'transfer':kind});out._seal();self._state=None;self._released=True
        return out

    def relative(self):
        self.check()
        if self._kind!='full': raise ValueError('Relative transfer requires full owner')
        return self._transfer(a.apply(m.compression(),self._state,self._reference),'relative')

    def classicalize(self):
        self.check()
        if self._kind=='classical' or self._control is None: raise ValueError('Need an actual relative return before classical control')
        count=4 if self._kind=='full' else 2;n=4*self._reference
        return self._transfer(np.trace(self._state.reshape(count,n,count,n),axis1=0,axis2=2),'classical')

    def snapshot(self):
        self.check();return self._state.copy(),deepcopy(self._history)

    def control_record(self):
        self.check()
        if self._control is None: raise ValueError('Relative control has not been acquired')
        return self._control


def build(directory):
    directory.mkdir(parents=True,exist_ok=True)
    proof=json.loads(run(['node',HERE/'resident_framed_court.js','build',directory]))
    native=ROOT/'.build/arm64-apple-macosx/debug/Tools';log=run([native,'judge','where',directory/'ResidentFramed.swift'])
    assert f"{proof['equalities']} equalities" in log and 'THE WHERE holds' in log
    for item in proof['negatives']:
        got=subprocess.run([str(native),'judge','where',str(directory/item['file'])],capture_output=True,text=True,timeout=30)
        assert got.returncode==1 and 'requires the types' in got.stdout+got.stderr
    proof['native']=log.strip();proof['implementation_sha256']={str(p.relative_to(ROOT)):digest(p) for p in [Path(__file__),HERE/'resident_framed_court.js']}
    write(directory/'build.json',proof);return proof


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    result=build(p.parse_args().output.resolve());print(json.dumps({'equalities':result['equalities'],'refusals_each_court':len(result['negatives'])}))
