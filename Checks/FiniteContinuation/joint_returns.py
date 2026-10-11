#!/usr/bin/env python3
"""Source-derived joint return admission. Offline; no empirical error claim.

A model offer specifies two full-DE convex mixtures: retained versus replaced
memory inside each return. The all-retained branch is checked by existing type
constructors. Exact mixture weight then supplies a composable channel bound.
"""
import argparse
from fractions import Fraction
from functools import lru_cache
import json
from pathlib import Path
import subprocess

from build_from_source import ROOT,HERE,run
from environment import write,digest
from planner import synthesize


def fraction(x):
    if not isinstance(x,(list,tuple)) or len(x)!=2 or any(type(i) is not int for i in x):
        raise ValueError('An exact numerator and denominator are required')
    if x[1]<=0 or not 0<=x[0]<=x[1]:raise ValueError('Probability outside [0,1]')
    return Fraction(*x)


def pair(x):return [x.numerator,x.denominator]


def program(source,model,word,placement):
    if model not in ('JointKeep','JointMoving'):raise ValueError('Unknown joint action')
    if placement not in ('JointBetweenPairs','JointEveryCall'):raise ValueError('Unknown insertion boundary')
    if any(g not in ('h','s') for g in word):raise ValueError('Unknown middle action')
    # Right-to-left A F_I F_U A, physically executed left-to-right here.
    ops=[];occurrence=0
    def module(side):
        for primitive in source['modules'][model][side]:
            if primitive=='cz':ops.append({'gate':'cz','memory':'E','data':'D'})
            elif primitive=='memory_s':ops.append({'gate':'s','target':'E'})
            elif primitive in ('h','s'):ops.append({'gate':primitive,'target':'D'})
            else:raise ValueError('Unsupported primitive in actual source trace')
    def a():
        nonlocal occurrence
        occurrence+=1
        if placement=='JointEveryCall' or occurrence in (2,4):
            ops.append({'gate':'refresh','boundary':occurrence,'memory':'E'})
        module('A')
    def b():
        module('B')
    a();a();ops.extend({'gate':g,'target':'D'} for g in word);b();a();b();a()
    return ops


def bound(offer):
    q=fraction(offer['rate'])
    if offer['placement']!='JointBetweenPairs':return Fraction(1)
    # Both actual returns have CPTP bad branches on the SAME full D,E.
    # Composition gives an ideal branch of weight (1-q)^2, without tracing E.
    return 1-(1-q)**2


@lru_cache(maxsize=4)
def current_reading(fingerprints):
    return json.loads(run(['node',HERE/'joint_return_court.js','read']))


def check_source(source):
    actual=tuple((n,digest(ROOT/n)) for n in sorted(source['source_sha256']))
    if dict(actual)!=source['source_sha256']:raise ValueError('Current joint source changed')
    helpers=tuple((str(p),digest(p)) for p in [HERE/'joint_return_court.js',HERE/'court_bridge.js',HERE/'contact_court.js'])
    if source!=current_reading(actual+helpers):raise ValueError('Reading is not derived from the current root')


def packet_for(source,name,word,prior):
    offer=source['offers'][name];e=bound(offer)
    return {'kind':'act','offer':name,'question':word,'execution':program(source,offer['model'],word,offer['placement']),
            'source_sha256':source['source_sha256'],'error_bound':pair(e),
            'accumulated_bound':pair(1-(1-prior)*(1-e)),'price':offer['cost'],
            'scope':'full_DE_CPTP_mixture','environment_S_power':2 if offer['model']=='JointMoving' else 0}


def history_weight(source,history):
    # A generic diamond bound does NOT imply the stronger convex-decomposition
    # premise needed for a product bound. Derive that weight from each actual
    # earlier admitted construction; never accept an arbitrary prior epsilon.
    previous=Fraction(0)
    for packet in history:
        if packet.get('question') not in [g['word'] for g in source['goals']]:raise ValueError('Unknown prior question')
        expected=packet_for(source,packet['offer'],packet['question'],previous)
        if packet!=expected:raise ValueError('History is not a sequence of current full-channel mixtures')
        previous=fraction(expected['accumulated_bound'])
    return previous


def choose(source,word,names,tolerance,*,history=(),total_tolerance=(1,1)):
    check_source(source)
    if not isinstance(word,list) or word not in [g['word'] for g in source['goals']]:
        raise ValueError('Goal outside the current finite source')
    tolerance=fraction(tolerance);prior=history_weight(source,history);total=fraction(total_tolerance)
    if not names or len(set(names))!=len(names):raise ValueError('A nonempty distinct offer set is required')
    admitted={};denied={}
    for name in names:
        offer=source['offers'][name];e=bound(offer);accumulated=1-(1-prior)*(1-e)
        if e<=tolerance and accumulated<=total:
            admitted[name]={'physical_gates':offer['cost']}
        else:denied[name]={'bound':pair(e),'accumulated':pair(accumulated)}
    # Reuse the existing finite selector. One entry denotes the universally
    # quantified source relation, NOT one picked environment state.
    policy=synthesize({'valid':[list(admitted)],'actions':admitted,'probes':[]})['tree']
    if policy['kind']!='act':return {'kind':'needs_relation','denied':denied}
    return packet_for(source,policy['action'],word,prior)


def validate(source,packet,word,names,tolerance,**kw):
    for name,expected in source['source_sha256'].items():
        if digest(ROOT/name)!=expected:raise ValueError('Current joint source changed')
    if packet!=choose(source,word,names,tolerance,**kw):
        raise ValueError('Program, scope, question, budget or actual return offer was substituted')
    if packet['kind']!='act':raise ValueError('No current return relation admits execution')
    return packet['execution']


def build(output):
    if output.exists():raise ValueError('Use a fresh output directory')
    output.mkdir(parents=True)
    certificate=json.loads(run(['node',HERE/'joint_return_court.js','build',output]))
    native=ROOT/'.build/arm64-apple-macosx/debug/Tools'
    log=run([native,'judge','where',output/'JointReturns.swift'])
    assert 'THE WHERE holds' in log and f"{certificate['equalities']} equalities" in log
    for n in certificate['negatives']:
        r=subprocess.run([str(native),'judge','where',str(output/n['file'])],capture_output=True,text=True,timeout=30)
        assert r.returncode==1 and 'requires the types' in r.stdout+r.stderr
    source=json.loads((output/'source-reading.json').read_text())
    assert json.loads(run(['node',HERE/'joint_return_court.js','read']))==source
    cases=[]
    for g in source['goals']:
        for tolerance in ([1,10],[1,100],[1,1000]):
            p=choose(source,g['word'],['Replace','Fast','Protected'],tolerance)
            expected={(1,10):'Fast',(1,100):'Protected',(1,1000):None}[tuple(tolerance)]
            assert p.get('offer')==expected
            cases.append({'question':g['word'],'tolerance':tolerance,'decision':p})
    write(output/'decisions.json',cases)
    result={'certificate':certificate,'native':log.strip(),'admission_cases':len(cases),
       'implementation_sha256':{str(p.relative_to(ROOT)):digest(p) for p in
           [Path(__file__),HERE/'joint_return_court.js',HERE/'planner.py',HERE/'court_bridge.js',HERE/'contact_court.js']},
       'artifact_sha256':{n:digest(output/n) for n in ['source-reading.json','decisions.json','JointReturns.swift']},
       'limits':'Source-declared simulated full-DE mixtures, not measured physical diamond distances or acquired Pauli keys.'}
    write(output/'build.json',result);return result


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',required=True,type=Path)
    r=build(p.parse_args().output.resolve())
    print(json.dumps({'equalities':r['certificate']['equalities'],'refusals_each_court':len(r['certificate']['negatives']),'admission_cases':r['admission_cases']},indent=2))
