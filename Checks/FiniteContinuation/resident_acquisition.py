#!/usr/bin/env python3
"""Source-bound selective instruments for the resident continuation.

SDK execution and a finite exact observable-closure check. This is not a
general VI kernel, arbitrary instrument compiler, or hardware calibration.
"""
import argparse
from collections import deque
from copy import deepcopy
from fractions import Fraction as F
from functools import lru_cache
from itertools import product
import json
from pathlib import Path
import subprocess

import numpy as np
from qiskit.quantum_info import DensityMatrix, Kraus, Operator

import resident_memory as r
import whole_word_admission as a
from build_from_source import HERE, ROOT, run
from environment import digest, write


@lru_cache(maxsize=2)
def current_source(key):
    return json.loads(run(['node', HERE/'resident_acquisition_court.js', 'read']))


def validate(reading):
    key = tuple((n, digest(ROOT/n)) for n in sorted(reading['source_sha256']))
    if dict(key) != reading['source_sha256']: raise ValueError('Acquisition root changed')
    key += tuple((str(p), digest(p)) for p in [HERE/'resident_acquisition_court.js', HERE/'resident_program_court.js', HERE/'court_bridge.js'])
    if current_source(key) != reading: raise ValueError('Not the current acquisition reading')
    r.validate(reading['interpreter'])
    for axis, probe in reading['probes'].items():
        if axis != probe['observable'] or probe['records'] != [0, 1]:
            raise ValueError('Projector record interpretation changed')


def control_table(reading, action):
    table = {tuple(row['input']): tuple(row['actions'][action]) for row in reading['rows']}
    if set(table) != set(product(range(2), repeat=2)):
        raise ValueError('Incomplete current control carrier')
    return table


def relative_table(reading, action):
    """The conclusion is computed from all four source rows, not required."""
    out = {}
    for (p, c), (pp, cc) in control_table(reading, action).items():
        parity, after = p ^ c, pp ^ cc
        if parity in out and out[parity] != after:
            raise ValueError(f'{action} distinguishes two representatives of one relative state')
        out[parity] = after
    return out


def transition_kraus(table, size):
    # Permutations stay coherent. A noninjective write uses a physical CP
    # measure-and-prepare control channel, with discarded input in its dilation.
    matrices = []
    for old, new in table.items():
        k = np.zeros((size, size), complex); k[new, old] = 1; matrices.append(k)
    return [sum(matrices)] if len(set(table.values())) == size else matrices


def control(reading, action, *, reduced=False):
    if reduced: return transition_kraus(relative_table(reading, action), 2)
    table = control_table(reading, action)
    return transition_kraus({2*p+c: 2*pp+cc for (p,c),(pp,cc) in table.items()}, 4)


def instrument(reading, axis, mode, bit, *, reduced=False):
    if axis not in reading['probes'] or mode not in ('Toggle', 'Write', 'Install') or bit not in (0,1):
        raise ValueError('Unsupported source instrument')
    probe = reading['probes'][axis]
    sign = (-1)**probe['records'].index(bit)
    q = a.P[a.NAMES.index(probe['observable'])]
    projector = (a.I+sign*q)/2
    return [np.kron(k, projector if reduced else np.kron(projector, a.I))
            for k in control(reading, mode+str(bit), reduced=reduced)]


def branch_map(reading, axis, mode, bit):
    # Exact Heisenberg action on the existing invariant rational grammar.
    table = control_table(reading, mode+str(bit)); sigma = reading['probes'][axis]['observable']
    sign = F((-1)**reading['probes'][axis]['records'].index(bit)); result = []
    for p, c, d, e in r.KEYS:
        terms = []
        if d in ('I', sigma):
            for (pp, cc), target in table.items():
                if target == (p,c):
                    terms.extend([(r.INDEX[pp,cc,d,e], F(1,2)),
                                  (r.INDEX[pp,cc,sigma if d=='I' else 'I',e], sign/2)])
        result.append(terms)
    return result


def selective_space(reading, modes=('Toggle','Install'), *, service=False):
    actions = {k:v for k,v in r.maps(reading['interpreter']).items() if service or k=='tick'}
    for mode, axis, b in product(modes, reading['probes'], range(2)):
        actions[f'{axis}:{mode}:{b}'] = branch_map(reading, axis, mode, b)
    space=r.Span(); queue=deque(); basis=[]
    def add(v, question, word):
        if space.add(v):
            item={'vector':v,'question':question,'word':word};basis.append(item);queue.append(item)
    for q in ('I','X','Y','Z'): add(r.query(q),q,[])
    while queue:
        item=queue.popleft()
        for action,mapping in actions.items(): add(r.push(item['vector'],mapping),item['question'],[action]+item['word'])
    for item in basis:
        for mapping in actions.values(): assert not any(space.residual(r.push(item['vector'],mapping)))
    decisions={name:all(r.push(item['vector'],r.renewal_map(name))==item['vector'] for item in basis) for name in r.RENEWALS}
    return {'dimension':len(basis),'maximum_witness_depth':max(len(v['word']) for v in basis),
            'renewals':decisions,'actions':list(actions),
            'basis':[{'question':v['question'],'word':v['word'],'vector':[[i,str(x)] for i,x in enumerate(v['vector']) if x]} for v in basis],
            'scope':'All finite selective transcripts and final D observables, including their unnormalized probability weights.'}


class LearningResident:
    """Owns the state; acquire receives a question/mode, never an answer bit."""
    def __init__(self, reading, state, *, reduced=False):
        self.reading=deepcopy(reading);validate(self.reading)
        self.reduced=reduced;self.dim=4 if reduced else 16
        self._state=np.array(state,complex,copy=True)
        if self._state.ndim!=2 or self._state.shape[0]!=self._state.shape[1] or len(self._state)%self.dim:
            raise ValueError('Invalid resident carrier/reference')
        if not np.allclose(self._state,self._state.conj().T) or not np.isclose(np.trace(self._state),1) or np.linalg.eigvalsh(self._state).min() < -1e-10:
            raise ValueError('Invalid resident state')
        self._reference=len(state)//self.dim;self._history=[];self._released=False
        self._origin=a.fingerprint(reading)
        self._implementation={str(p):digest(p) for p in [Path(__file__),HERE/'resident_memory.py',HERE/'whole_word_admission.py']}
        self._tick = (r.reduction(reading['interpreter'],r.closure(reading['interpreter']))[2]
                      if reduced else Operator(r.circuit(reading['interpreter'])).data)
        self._tick_hash=a.channel_digest([self._tick])

    def check(self):
        if self._released: raise ValueError('State already transferred')
        validate(self.reading)
        if self._origin!=a.fingerprint(self.reading) or self._tick_hash!=a.channel_digest([self._tick]):
            raise ValueError('Live interpreter changed')
        if any(digest(Path(p))!=h for p,h in self._implementation.items()): raise ValueError('Live implementation changed')

    def tick(self):
        self.check();self._state=DensityMatrix(self._state).evolve(Operator(np.kron(self._tick,np.eye(self._reference)))).data
        self._history.append({'action':'tick'})

    def acquire(self, axis, mode='Toggle', *, rng=None):
        self.check()
        # Enumerate actual CP branches, choose according to the current state,
        # and apply the same branch to the resident data and control. No law,
        # hidden program label, desired outcome, or postselected retry input.
        branches=[a.apply(instrument(self.reading,axis,mode,b,reduced=self.reduced),self._state,self._reference) for b in (0,1)]
        probabilities=np.array([np.trace(v).real for v in branches])
        if np.min(probabilities)<-1e-10 or not np.isclose(probabilities.sum(),1,atol=1e-10):
            raise ValueError('Instrument probabilities invalid')
        probabilities=np.maximum(probabilities,0);probabilities/=probabilities.sum()
        rng = np.random.default_rng() if rng is None else rng
        b=int(rng.choice(2,p=probabilities))
        if probabilities[b]<=0: raise ValueError('Unavailable branch selected')
        self._state=branches[b]/np.trace(branches[b]).real
        record={'axis':axis,'mode':mode,'bit':b,'conditional_probability':float(probabilities[b]),
                'ordinal':len(self._history),'source':self._origin}
        self._history.append({'acquisition':record})
        return deepcopy(record)

    def reduce(self):
        self.check()
        if self.reduced: raise ValueError('Already relative')
        # Restrict future contacts to those whose complete branch maps descend.
        for mode,b in product(('Toggle','Install'),range(2)): relative_table(self.reading,mode+str(b))
        _,ks,_=r.reduction(self.reading['interpreter'],r.closure(self.reading['interpreter']))
        next_owner=LearningResident(self.reading,a.apply(ks,self._state,self._reference),reduced=True)
        next_owner._history=deepcopy(self._history)+[{'transfer':'relative'}]
        self._state=None;self._released=True
        return next_owner

    def snapshot(self):
        self.check();return self._state.copy(),deepcopy(self._history)


def build(directory):
    directory.mkdir(parents=True,exist_ok=True)
    proof=json.loads(run(['node',HERE/'resident_acquisition_court.js','build',directory]))
    native=ROOT/'.build/arm64-apple-macosx/debug/Tools'
    log=run([native,'judge','where',directory/'ResidentAcquisition.swift'])
    assert f"{proof['equalities']} equalities" in log and 'THE WHERE holds' in log
    for item in proof['negatives']:
        got=subprocess.run([str(native),'judge','where',str(directory/item['file'])],capture_output=True,text=True,timeout=30)
        assert got.returncode==1 and 'requires the types' in got.stdout+got.stderr
    proof['native']=log.strip();proof['implementation_sha256']={str(p.relative_to(ROOT)):digest(p) for p in [Path(__file__),HERE/'resident_acquisition_court.js']}
    write(directory/'build.json',proof);return proof


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    result=build(p.parse_args().output.resolve());print(json.dumps({'equalities':result['equalities'],'refusals_each_court':len(result['negatives'])}))
