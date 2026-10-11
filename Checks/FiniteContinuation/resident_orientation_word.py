#!/usr/bin/env python3
"""Requested whole rotations without determining the reporter's orientation.

The canonical representative is a calculation on an unordered model pair,
not a calibration claim that the physical reporter is better than random.
Only complete three-step words are admitted by the resulting packet.
"""
import argparse
from copy import deepcopy
from functools import lru_cache
from fractions import Fraction
import json
from pathlib import Path
import subprocess

from qiskit import qpy

import resident_reporter_policy as policy
from environment import write,digest

admission=policy.admission


@lru_cache(maxsize=2)
def current(key):return json.loads(policy.repeated.wire.goal.run(['node',policy.repeated.wire.goal.HERE/'resident_orientation_word_court.js','read']))


def validate(source):
    key=tuple((p,digest(policy.repeated.wire.goal.ROOT/p)) for p in sorted(source['source_sha256']))
    if dict(key)!=source['source_sha256']:raise ValueError('Orientation-word source changed')
    key+=tuple((str(p),digest(p)) for p in [policy.repeated.wire.goal.HERE/'resident_orientation_word_court.js',policy.repeated.wire.goal.HERE/'resident_reporter_policy_court.js',policy.repeated.wire.goal.HERE/'court_bridge.js'])
    if current(key)!=source:raise ValueError('Not the current whole-word reading')
    policy.validate(source['policy'])
    for row in source['errors']:
        a,b,c=row['errors']
        if (row['x'],row['z'])!=(b^c,a^b):raise ValueError('The bounded rotation realization no longer applies')
    if source['selectors']!={'Z':[1,0,0],'X':[0,0,1]}:raise ValueError('The rotation placement changed')


def requests(source,values):
    validate(source)
    if not isinstance(values,(tuple,list)) or not 1<=len(values)<=21:raise ValueError('One through twenty-one complete rotation words required')
    out=[]
    for value in values:
        if not isinstance(value,dict) or set(value)!={'x','z'}:
            raise ValueError('A complete requested Rx(x) Rz(z) word is required')
        out.append({axis:policy.repeated.wire.angle(value[axis]) for axis in ['x','z']})
    return out


def expand(source,values):
    out=[]
    for r in requests(source,values):
        for i in range(3):
            a=Fraction(1,2)+sum(source['selectors'][axis.upper()][i]*Fraction(*r[axis]) for axis in ['x','z'])
            # Density-output rotations are periodic modulo 2*pi. Keep the
            # already supported rational-angle range; no arbitrary new gate.
            a=(a+1)%2-1
            out.append(policy.repeated.wire.angle([a.numerator,a.denominator]))
    return out


def macro_error(r):
    if not 0<=r<=.5:raise ValueError('Use the canonical risk interval, not an oriented device claim')
    return 3*r*(1-r)


def decide(source,record,wanted,risk):
    validate(source);wanted=requests(source,wanted)
    if record.get('orientation')!='unoriented':raise ValueError('This record must retain both possible orientations')
    # Every physical pair has a representative with a+b<=1. Invoking the
    # old moment inversion for that REPRESENTATIVE asserts nothing about
    # which member is the actual physical reporter.
    representative_record={**record,'orientation':'p01+p10<=1'}
    region=policy.parameter_region(representative_record)
    base={'record_sha256':admission.fingerprint(record),'source':admission.fingerprint(source),
        'request':wanted,'required_word_error':risk,'canonical_region':region,
        'scope':'Only the requested complete three-step words. The physical reporter orientation remains undetermined.'}
    if region['kind']!='region':return {**base,'kind':'needs_evidence'}
    reflected={'p01':[1-region['p10'][1],1-region['p10'][0]],'p10':[1-region['p01'][1],1-region['p01'][0]]}
    candidates=[]
    for name,table in source['policy']['policies'].items():
        upper=0.
        for row in table:
            k=sum(row['votes'])
            interval=region['p01'] if row['answer'] else [1-region['p10'][1],1-region['p10'][0]]
            upper+=policy.word_likelihood(interval,k)[1]/2
        # These three source readings are monotone thresholds. On the
        # canonical model P(Y=1|B=1)>=P(Y=1|B=0), so each has risk <=1/2.
        upper=min(.5,upper+policy.PAD);one=macro_error(upper)
        candidates.append({'canonical_policy':name,'canonical_primitive_error_upper':upper,
            'physical_rotation_error_upper':one,'physical_word_error_upper':min(.75,.75*(1-(1-2*upper)**(2*len(wanted)))+policy.PAD)})
    selected=min(candidates,key=lambda r:(r['physical_word_error_upper'],r['canonical_policy']))
    return {**base,'reflected_region':reflected,'candidates':candidates,'selected':selected,
        'kind':'act' if selected['physical_word_error_upper']<=risk else 'needs_evidence',
        'confidence_failure':record['alpha']}


class UnorientedEvidence:
    def __init__(self,source,pair,wanted,*,shots=32768,alpha=.01,risk=.5,seed=2026091561):
        validate(source)
        if len(pair)!=2 or any(not 0<=x<=1 for x in pair):raise ValueError('Invalid complete local reporter')
        if type(shots)is not int or not 1<=shots<=131072 or not 0<alpha<1 or not 0<risk<1:raise ValueError('Invalid fixed goal or acquisition design')
        self.word_source=deepcopy(source);self.source=deepcopy(source['policy']);self.pair=tuple(pair)
        self.wanted=requests(source,wanted);self.shots=shots;self.alpha=alpha;self.risk=risk;self.seed=seed;self.records=[];self.origin=self.binding()

    def binding(self):
        validate(self.word_source)
        if self.source!=self.word_source['policy']:raise ValueError('The underlying policy source was replaced')
        mirror=(1-self.pair[1],1-self.pair[0])
        orbit=min(self.pair,mirror)
        return {'source':admission.fingerprint(self.word_source),'reporter_orbit_sha256':admission.fingerprint(orbit),
            'shots':self.shots,'alpha':self.alpha,'seed':self.seed,'orientation':'unoriented',
            'request':deepcopy(self.wanted),'required_word_error':self.risk,
            'implementation_sha256':digest(Path(__file__)),'policy_implementation_sha256':digest(Path(policy.__file__)),
            'device_scope':'Constructed fixed local conditionally IID reporter with a preserved true branch, modulo one global branch reflection for the complete word. No orientation premise and no hardware grant.'}

    def check(self):
        if self.binding()!=self.origin:raise ValueError('Current source, device, goal or acquisition changed')

    def acquire(self,output):
        # Reuse the actual measured-pair acquisition, not its oriented decision.
        return policy.LocalReporterEvidence.acquire(self,output)

    def decision(self,record):
        self.check()
        if record not in self.records:raise ValueError('This occurrence was not acquired from the current source')
        return decide(self.word_source,record,self.wanted,self.risk)

    def working_body(self,packet):
        self.check()
        if packet.get('kind')!='act' or sum(self.decision(r)==packet for r in self.records)!=1:raise ValueError('No applicable acquired whole-word guarantee')
        angles=expand(self.word_source,self.wanted)
        q=policy.compile_policy(policy.main_word(self.source,angles),self.source,self.pair,packet['selected']['canonical_policy'])
        q.metadata={**q.metadata,'whole_rotation_source':admission.fingerprint(self.word_source),'requested_rotation_pairs':deepcopy(self.wanted),
            'word_evidence':admission.fingerprint(packet),'physical_word_error_upper':packet['selected']['physical_word_error_upper'],
            'orientation':'Unknown; no primitive correctness claim follows from this whole-word packet.'}
        return q

    def admit(self,packet,candidate):
        expected=self.working_body(packet)
        if candidate.metadata!=expected.metadata or candidate!=expected or policy.repeated.work.ordered_bindings(candidate)!=policy.repeated.work.ordered_bindings(expected):
            raise ValueError('The actual body no longer realizes this acquired complete word')
        return candidate


def build(output):
    output.mkdir(parents=True,exist_ok=True)
    r=json.loads(policy.repeated.wire.goal.run(['node',policy.repeated.wire.goal.HERE/'resident_orientation_word_court.js','build',output]))
    native=policy.repeated.wire.goal.ROOT/'.build/arm64-apple-macosx/debug/Tools'
    text=policy.repeated.wire.goal.run([native,'judge','where',output/'ResidentOrientationWord.swift'])
    assert f"{r['equalities']} equalities" in text and 'THE WHERE holds' in text
    for entry in r['negatives']:
        p=subprocess.run([str(native),'judge','where',str(output/entry['file'])],capture_output=True,text=True,timeout=30)
        assert p.returncode==1 and 'requires the types' in p.stdout+p.stderr
    r['native']=text.strip();write(output/'build.json',r);return r


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    print(json.dumps(build(p.parse_args().output.resolve())))
