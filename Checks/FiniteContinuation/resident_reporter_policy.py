#!/usr/bin/env python3
"""Acquire a reporter policy from paired records, not hidden true labels.

Local-only fixed reporter family: repeated probes preserve the same true
branch, are conditionally IID, and have p01+p10 <= 1. The orientation
condition is a model premise, not inferred from anonymous records.
"""
import argparse
from copy import deepcopy
from functools import lru_cache
import hashlib
import json
import math
from pathlib import Path
import subprocess

from qiskit import QuantumCircuit,ClassicalRegister,qpy
from qiskit.circuit.classical import expr
from qiskit_aer import AerSimulator

import resident_repeated_read as repeated
from environment import write,digest

admission=repeated.wire.admission
PAD=1e-12


@lru_cache(maxsize=2)
def current(key):return json.loads(repeated.wire.goal.run(['node',repeated.wire.goal.HERE/'resident_reporter_policy_court.js','read']))


def validate(source):
    key=tuple((p,digest(repeated.wire.goal.ROOT/p)) for p in sorted(source['source_sha256']))
    if dict(key)!=source['source_sha256']:raise ValueError('Reporter policy source changed')
    key+=tuple((str(p),digest(p)) for p in [repeated.wire.goal.HERE/'resident_reporter_policy_court.js',repeated.wire.goal.HERE/'resident_repeated_read_court.js',repeated.wire.goal.HERE/'court_bridge.js'])
    if current(key)!=source:raise ValueError('Not the current policy reading')
    repeated.validate(source['repeated'])
    for threshold,name in enumerate(['AnyOne','Majority','AllOne'],1):
        if any(row['answer']!=int(sum(row['votes'])>=threshold) for row in source['policies'][name]):
            raise ValueError('The bounded Boolean lowering no longer denotes the source reading')


def bernoulli_interval(k,n,alpha):
    return [max(0.,1-admission.upper_binomial(n-k,n,alpha)),min(1.,admission.upper_binomial(k,n,alpha))]


def parameter_region(record):
    """Only measured pair counts and the declared orientation enter inversion."""
    if record.get('orientation')!='p01+p10<=1':raise ValueError('Anonymous records do not fix their true-bit orientation')
    counts=record['pair_counts'];n=record['shots'];alpha=record['alpha']
    if set(counts)!={'00','01','10','11'} or any(type(v) is not int or v<0 for v in counts.values()) or sum(counts.values())!=n or type(n)is not int or n<=0 or not 0<alpha<1:
        raise ValueError('Invalid measured pair occurrence')
    # Do not treat the two reports as independent samples of the mean.
    m=bernoulli_interval(counts['10']+counts['11'],n,alpha/4)
    s=bernoulli_interval(counts['11'],n,alpha/4)
    c=[max(0.,s[0]-m[1]**2-PAD),min(.25,s[1]-m[0]**2+PAD)]
    if c[1]<c[0]:return {'kind':'incompatible_moments','mean':m,'second_moment':s}
    p=[max(0.,.5-math.sqrt(c[1])-PAD),min(.5,.5-math.sqrt(c[0])+PAD)]
    a=[max(0.,p[0]+m[0]-.5-PAD),min(1.,p[1]+m[1]-.5+PAD)]
    b=[max(0.,p[0]-m[1]+.5-PAD),min(1.,p[1]-m[0]+.5+PAD)]
    if a[0]>a[1] or b[0]>b[1]:return {'kind':'incompatible_moments','mean':m,'second_moment':s}
    return {'kind':'region','mean':m,'second_moment':s,'covariance':c,'single_average':p,'p01':a,'p10':b,
        'confidence_failure':alpha,'scope':'Outer confidence region under the stated fixed conditional-IID, uniform-branch, oriented model.'}


def word_likelihood(interval,k):
    """Bounds x^k(1-x)^(3-k) on a closed interval, including its peak."""
    lo,hi=interval
    if not 0<=lo<=hi<=1 or k not in range(4):raise ValueError('Invalid likelihood interval')
    f=lambda x:x**k*(1-x)**(3-k)
    values=[f(lo),f(hi)]
    if lo<=k/3<=hi:values.append(f(k/3))
    return [max(0.,min(values)-PAD),min(1.,max(values)+PAD)]


def choose(source,record):
    validate(source);region=parameter_region(record)
    base={'record_sha256':admission.fingerprint(record),'source':admission.fingerprint(source),'region':region}
    if region['kind']!='region':return {**base,'kind':'needs_evidence'}
    rows=[];chosen=[]
    for k in range(4):
        zero=word_likelihood(region['p01'],k)
        one=word_likelihood([1-region['p10'][1],1-region['p10'][0]],k)
        answer=1 if one[0]>zero[1] else 0 if zero[0]>one[1] else None
        chosen.append(answer);rows.append({'ones':k,'true0_likelihood':zero,'true1_likelihood':one,'answer':answer})
    matches=[name for name,table in source['policies'].items() if all(row['answer']==chosen[sum(row['votes'])] for row in table)]
    if len(matches)!=1:return {**base,'kind':'needs_evidence','likelihood_rows':rows}
    name=matches[0];risk=sum(math.comb(3,k)*rows[k]['true0_likelihood' if chosen[k] else 'true1_likelihood'][1] for k in range(4))/2
    return {**base,'kind':'act','policy':name,'likelihood_rows':rows,'logical_error_upper':min(1.,risk+PAD),
        'scope':'This candidate is Bayes-optimal among all three-vote decoders for every model in the outer region; one next logical step and uniform true branch. Not a global multi-step optimum.'}


def policy_expression(name,a,b,c):
    if name=='Majority':return repeated.majority(a,b,c)
    if name=='AllOne':return expr.logic_and(expr.logic_and(a,b),c)
    if name=='AnyOne':
        ab=expr.bit_xor(expr.bit_xor(a,b),expr.logic_and(a,b))
        return expr.bit_xor(expr.bit_xor(ab,c),expr.logic_and(ab,c))
    raise ValueError('Not a current bounded candidate')


def main_word(source,angles):
    q=QuantumCircuit(4);w=repeated.wire.Wire(q,source['repeated']['wire'],repeated.wire.plan(source['repeated']['wire']))
    w.append(angles);w.rectify();q.metadata={'boundary':w.boundary()};return q


def calibration_circuit(source,pair):
    # The current wire makes the actual true branch uniform for every logical
    # input. No measurement of that hidden bit is supplied to the estimator.
    main=main_word(source,[[0,1]]);q=QuantumCircuit(5);q.add_register(*main.cregs)
    reports=ClassicalRegister(2,'reports');q.add_register(reports);found=0
    for item in main.data:
        if item.operation.name=='measure':
            retiring=main.find_bit(item.qubits[0]).index
            for bit in reports:
                q.reset(4);q.cx(retiring,4)
                q.append(repeated.readout.classical_report_channel(*pair),[4]);q.measure(4,bit);q.reset(4)
            found+=1;break
        q.append(item.operation,[main.find_bit(b).index for b in item.qubits],list(item.clbits))
    if found!=1:raise ValueError('Current logical acquisition disappeared')
    q.metadata={'source':admission.fingerprint(source),'actual_report_reads':2,
        'scope':'One actual wire branch, two report probes; separate calibration occurrence. No true-branch field is exported.'}
    return q


def compile_policy(main,source,pair,policy):
    validate(source)
    if policy not in source['policies']:raise ValueError('Unknown candidate')
    device=repeated.compile_reports(main,source['repeated'],pair)
    q=device.copy_empty_like();pending=False;measures=0;replaced=0
    for item in device.data:
        if item.operation.name=='measure':measures+=1;pending=measures%3==0
        if pending and item.operation.name=='store':
            # The owned repeated-read constructor puts its decoder here,
            # after the third acquired report and before the wire consumes it.
            q.store(device.cregs[2][0],policy_expression(policy,device.cregs[3][0],device.cregs[3][1],device.cregs[2][0]))
            pending=False;replaced+=1
        else:q.append(item)
    if replaced!=device.metadata['logical_steps']:raise ValueError('The current decoding boundary changed')
    q.metadata={**device.metadata,'policy_source':admission.fingerprint(source),'selected_policy':policy}
    return q


class LocalReporterEvidence:
    def __init__(self,source,pair,*,shots=32768,alpha=.01,seed=2026091531):
        validate(source)
        if len(pair)!=2 or any(not 0<=x<=1 for x in pair) or sum(pair)>1:
            raise ValueError('This constructed local family supplies p01+p10<=1')
        if type(shots)is not int or not 1<=shots<=131072 or not 0<alpha<1:raise ValueError('Invalid fixed acquisition design')
        self.source=deepcopy(source);self.pair=tuple(pair);self.shots=shots;self.alpha=alpha;self.seed=seed;self.records=[];self.origin=self.binding()

    def binding(self):
        validate(self.source)
        return {'source':admission.fingerprint(self.source),'reporter_sha256':admission.fingerprint(self.pair),
            'shots':self.shots,'alpha':self.alpha,'seed':self.seed,'orientation':'p01+p10<=1',
            'implementation_sha256':digest(Path(__file__)),'repeated_implementation_sha256':digest(Path(repeated.__file__)),
            'device_scope':'Constructed fixed local reporter, identical conditional independent fresh probe uses; same preserved true bit per pair/triple. No hardware grant.'}

    def check(self):
        if self.binding()!=self.origin:raise ValueError('Source, reporter or evidence design changed')

    def acquire(self,output):
        self.check()
        if self.records:raise ValueError('One prespecified occurrence; no retry search')
        output.mkdir(parents=True,exist_ok=True);path=output/'paired-acquisition.qpy'
        if path.exists():raise ValueError('Acquisition already exists')
        q=calibration_circuit(self.source,self.pair)
        with path.open('wb') as f:qpy.dump(q,f)
        with path.open('rb') as f:restored,=qpy.load(f)
        if q!=restored or repeated.work.ordered_bindings(q)!=repeated.work.ordered_bindings(restored):raise ValueError('Acquisition ports changed')
        result=AerSimulator(method='density_matrix',max_parallel_threads=1).run(restored,shots=self.shots,memory=True,seed_simulator=self.seed).result()
        if not result.success:raise ValueError('Acquisition failed')
        ports=[restored.find_bit(bit).index for bit in restored.cregs[-1]];counts={k:0 for k in ['00','01','10','11']};raw=[]
        for text in result.get_memory():
            word=int(text.replace(' ',''),2);pair=''.join(str((word>>i)&1) for i in ports);counts[pair]+=1;raw.append(pair)
        record={'binding':deepcopy(self.origin),'shots':self.shots,'alpha':self.alpha,'pair_counts':counts,
            'orientation':self.origin['orientation'],'QPY_sha256':digest(path),'raw_record_sha256':admission.fingerprint(raw),
            'measured_report_ports':ports,'new_QPU_jobs':0}
        self.records.append(deepcopy(record));write(output/'paired-acquisition.json',record);return record

    def decision(self,record):
        self.check()
        if record not in self.records:raise ValueError('Not acquired from this current source')
        return choose(self.source,record)

    def working_body(self,packet,angles):
        self.check()
        if packet.get('kind')!='act' or sum(self.decision(r)==packet for r in self.records)!=1:raise ValueError('No applicable acquired policy')
        q=compile_policy(main_word(self.source,angles),self.source,self.pair,packet['policy'])
        q.metadata={**q.metadata,'evidence':admission.fingerprint(packet),'logical_error_upper':packet['logical_error_upper']}
        return q


def build(output):
    output.mkdir(parents=True,exist_ok=True)
    r=json.loads(repeated.wire.goal.run(['node',repeated.wire.goal.HERE/'resident_reporter_policy_court.js','build',output]))
    native=repeated.wire.goal.ROOT/'.build/arm64-apple-macosx/debug/Tools'
    text=repeated.wire.goal.run([native,'judge','where',output/'ResidentReporterPolicy.swift'])
    assert f"{r['equalities']} equalities" in text and 'THE WHERE holds' in text
    for entry in r['negatives']:
        p=subprocess.run([str(native),'judge','where',str(output/entry['file'])],capture_output=True,text=True,timeout=30)
        assert p.returncode==1 and 'requires the types' in p.stdout+p.stderr
    r['native']=text.strip();write(output/'build.json',r);return r


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    print(json.dumps(build(p.parse_args().output.resolve())))
