#!/usr/bin/env python3
"""Reuse a saved paired acquisition to choose a sufficient read allocation.

The confidence rectangle is in the two acquired moments, not independent
worst cases for two conditional device errors. One common physical reporter
attains every candidate's worst contraction whenever that rectangle is
nonempty. Reading cost is optimized in the declared fixed-plan catalogue.
"""
import argparse
from copy import deepcopy
from functools import lru_cache
import json
import math
from pathlib import Path
import subprocess

from qiskit import QuantumCircuit,ClassicalRegister,qpy

import resident_orientation_word as orientation
from environment import write,digest

policy=orientation.policy
admission=orientation.admission
PAD=1e-12


@lru_cache(maxsize=2)
def current(key):return json.loads(policy.repeated.wire.goal.run(['node',policy.repeated.wire.goal.HERE/'resident_reading_cost_court.js','read']))


def validate(source):
    key=tuple((p,digest(policy.repeated.wire.goal.ROOT/p)) for p in sorted(source['source_sha256']))
    if dict(key)!=source['source_sha256']:raise ValueError('Reading-cost source changed')
    key+=tuple((str(p),digest(p)) for p in [policy.repeated.wire.goal.HERE/'resident_reading_cost_court.js',policy.repeated.wire.goal.HERE/'resident_orientation_word_court.js',policy.repeated.wire.goal.HERE/'court_bridge.js'])
    if current(key)!=source:raise ValueError('Not the current reading-cost source')
    orientation.validate(source['orientation'])
    if source['candidates']['Single']!=[{'votes':[0],'answer':0},{'votes':[1],'answer':1}]:raise ValueError('Single-report lowering no longer applies')
    for name,rows in source['candidates'].items():
        if source['report_counts'][name]!=len(rows[0]['votes']):raise ValueError('The claimed read cost changed')


def least_favourable(record):
    if record.get('orientation')!='unoriented':raise ValueError('The saved source must retain both orientations')
    # This inversion is about a canonical representative of an unordered
    # physical pair, never a grant of a physical orientation.
    intervals=policy.parameter_region({**record,'orientation':'p01+p10<=1'})
    m=intervals['mean'];s=intervals['second_moment'];lo=max(m[0],math.sqrt(s[0]));hi=min(m[1],math.sqrt(s[1]))
    if lo<=hi:
        mean=(lo+hi)/2
        return {'kind':'witness','mean_interval':m,'second_moment_interval':s,'mean':mean,'second_moment':mean*mean,
            'canonical_pair':[mean,1-mean],'zero_contraction':True}
    if m[1]**2>=s[0]:return {'kind':'incompatible_moments','mean_interval':m,'second_moment_interval':s}
    t=math.sqrt(s[0]-m[1]**2);a=m[1]-t;b=1-m[1]-t
    if min(a,b)<0 or max(a,b)>1:return {'kind':'incompatible_moments','mean_interval':m,'second_moment_interval':s}
    return {'kind':'witness','mean_interval':m,'second_moment_interval':s,'mean':m[1],'second_moment':s[0],
        'canonical_pair':[a,b],'zero_contraction':False}


def error_rate(name,a,b):
    if name=='Single':return (a+b)/2
    if name=='AnyOne':return (1-(1-a)**3+b**3)/2
    if name=='AllOne':return (a**3+1-(1-b)**3)/2
    if name=='Majority':return (3*a*a-2*a**3+3*b*b-2*b**3)/2
    raise ValueError('Unknown source reading')


def select(source,record,wanted,risk):
    validate(source);wanted=orientation.requests(source['orientation'],wanted)
    if not 0<risk<1:raise ValueError('A specified whole-output error bound is required')
    witness=least_favourable(record)
    base={'source':admission.fingerprint(source),'record_sha256':admission.fingerprint(record),'request':wanted,
        'required_error':risk,'least_favourable':witness,'confidence_failure':record['alpha']}
    if witness['kind']!='witness':return {**base,'kind':'needs_evidence'}
    candidates={}
    for name in source['candidates']:
        r=error_rate(name,*witness['canonical_pair']);assert -PAD<=r<=.5+PAD
        candidates[name]={'reports_per_step':source['report_counts'][name],
            'witness_primitive_error':r,'sharp_contraction':max(0.,(1-2*r)**2),
            'contraction_lower':max(0.,(1-2*min(.5,r+PAD))**2-PAD)}
    triple=min((name for name in candidates if candidates[name]['reports_per_step']==3),key=lambda name:(-candidates[name]['contraction_lower'],name))
    m=len(wanted);plans=[];lower_by_count={}
    sharp_s=max(0.,1-2*candidates['Single']['witness_primitive_error']);sharp_t=max(0.,1-2*candidates[triple]['witness_primitive_error'])
    s=max(0.,sharp_s-3*PAD);t=max(0.,sharp_t-3*PAD)
    spectra=lambda x,y:[(x*x,x*x,x*x),(x*y,x*y,x*x),(y*y,x*y,x*y),(y*y,y*y,y*y)]
    exact_spectra=spectra(sharp_s,sharp_t);safe_spectra=spectra(s,t)
    # Enumerate counts of blocks with 0,1,2,3 upgraded logical reads. No
    # exponential search over all candidate names or angle-dependent paths.
    for n3 in range(m+1):
        for n2 in range(m-n3+1):
            for n1 in range(m-n3-n2+1):
                counts=[m-n1-n2-n3,n1,n2,n3];k=n1+2*n2+3*n3
                # Singular-value product bound: even arbitrary alignment of
                # all block error axes cannot exceed this trace at the same
                # physical witness. It covers every placement and candidate.
                trace_upper=sum(math.prod(exact_spectra[j][axis]**counts[j] for j in range(4)) for axis in range(3))
                witness_lower=max(0.,(3-trace_upper)/4-4*PAD)
                lower_by_count[k]=min(lower_by_count.get(k,1.),witness_lower)
                if n1+n2<=1:
                    contraction=s**(2*counts[0])*t**(2*counts[3])
                    partial=sum(safe_spectra[1]) if n1 else sum(safe_spectra[2]) if n2 else 3.
                    upper=min(.75,(3-contraction*partial)/4+4*PAD);bound_kind='exact with at most one anisotropic block, outward padded'
                else:
                    success=math.prod(((1+sum(safe_spectra[j]))/4)**counts[j] for j in range(4))
                    upper=min(1.,1-success+4*PAD);bound_kind='positive correct-action branch mass'
                modes=[name for j,n in enumerate(counts) for _ in range(n) for name in ['Single']*(3-j)+[triple]*j]
                plans.append({'upgraded_steps':k,'block_counts':counts,'modes':modes,
                    'physical_report_reads':3*m+2*k,'error_upper':upper,'bound_kind':bound_kind})
    feasible=[p for p in plans if p['error_upper']<=risk]
    if not feasible:
        obstruction=min(lower_by_count.values())>risk+2*PAD
        return {**base,'kind':'needs_evidence','candidates':candidates,'plans':plans,
            'witness_excludes_all_current_plans':obstruction,'lower_by_upgraded_steps':lower_by_count}
    chosen=min(feasible,key=lambda p:(p['physical_report_reads'],p['error_upper']))
    minimal=all(lower_by_count[k]>risk+2*PAD for k in range(chosen['upgraded_steps']))
    return {**base,'kind':'act','candidates':candidates,'plans':plans,'selected':chosen,
        'cost_minimality':'proved_in_declared_catalogue' if minimal else 'not_established_by_this_lower_bound',
        'lower_by_upgraded_steps':lower_by_count,
        'scope':'Fixed plans; one or three reports may be chosen separately for each logical step. Common stationary conditional-IID reporter; final quantum output with consumed records. No global optimality over other interfaces or history-adaptive schedules.'}


def compile_plan(source,pair,packet):
    validate(source)
    if packet.get('source')!=admission.fingerprint(source) or packet.get('kind')!='act':raise ValueError('Current applicable cost packet required')
    angles=orientation.expand(source['orientation'],packet['request']);modes=packet['selected']['modes']
    if len(modes)!=len(angles):raise ValueError('Partial or missing rotation block')
    main=policy.main_word(source['orientation']['policy'],angles)
    # Reuse the current full-body validation before changing the acquisition
    # schedule. The returned all-triple body is not executed here.
    policy.repeated.compile_reports(main,source['orientation']['policy']['repeated'],pair)
    q=QuantumCircuit(5);q.add_register(*main.cregs);votes=None
    if any(mode!='Single' for mode in modes):
        votes=ClassicalRegister(2,'votes');q.add_register(votes)
        for bit in votes:q.store(bit,False)
    steps=0;reads=0
    for item in main.data:
        if item.operation.name=='measure':
            if item.clbits!=(main.cregs[2][0],):raise ValueError('The acquired field changed')
            retiring=main.find_bit(item.qubits[0]).index;mode=modes[steps]
            bits=[main.cregs[2][0]] if mode=='Single' else [votes[0],votes[1],main.cregs[2][0]]
            if len(bits)!=source['report_counts'][mode]:raise ValueError('The execution does not pay the source read cost')
            for bit in bits:
                q.reset(4);q.cx(retiring,4);q.append(policy.repeated.readout.classical_report_channel(*pair),[4]);q.measure(4,bit);q.reset(4);reads+=1
            if mode!='Single':
                q.store(main.cregs[2][0],policy.policy_expression(mode,votes[0],votes[1],main.cregs[2][0]))
                q.store(votes[0],False);q.store(votes[1],False)
            steps+=1
        else:q.append(item.operation,[main.find_bit(b).index for b in item.qubits],list(item.clbits))
    if reads!=packet['selected']['physical_report_reads'] or steps!=len(angles):raise ValueError('Actual acquisition cost does not match the selected complete word')
    q.metadata={'wire_boundary':main.metadata,'cost_source':admission.fingerprint(source),'evidence':admission.fingerprint(packet),
        'requested_rotation_pairs':packet['request'],'modes':modes,'logical_steps':steps,'physical_report_reads':reads,
        'physical_word_error_upper':packet['selected']['error_upper'],'orientation':'unoriented','new_QPU_jobs':0}
    return q


class SavedCostView:
    """A new question on the frozen occurrence, not a copied old verdict.

    The receipt binds an already established local acquisition; file hashes
    by themselves are not a universal proof that a historical event occurred.
    No simulation or new measurement is performed by this loader.
    """
    def __init__(self,source,pair,artifact):
        self.source=deepcopy(source);self.pair=tuple(pair);self.artifact=Path(artifact).resolve()
        self.receipt=json.loads((self.artifact/'receipt.json').read_text())
        self.record=json.loads((self.artifact/'audit-paired-acquisition.json').read_text())
        self.origin=admission.fingerprint(self.record);self.check()

    def check(self):
        validate(self.source);root=policy.repeated.wire.goal.ROOT
        if any(digest(root/path)!=value for path,value in self.receipt['sha256'].items()):raise ValueError('The frozen acquired occurrence changed')
        if admission.fingerprint(self.record)!=self.origin:raise ValueError('The acquired record was changed in memory')
        b=self.record['binding'];ori=self.source['orientation']
        if b['source']!=admission.fingerprint(ori) or b['implementation_sha256']!=digest(Path(orientation.__file__)) or b['policy_implementation_sha256']!=digest(Path(policy.__file__)):
            raise ValueError('The saved acquisition is not linked to this current source')
        mirror=(1-self.pair[1],1-self.pair[0])
        if admission.fingerprint(min(self.pair,mirror))!=b['reporter_orbit_sha256']:raise ValueError('The actual reporter is outside the acquired orbit')
        path=self.artifact/'audit-paired-acquisition.qpy'
        if digest(path)!=self.record['QPY_sha256']:raise ValueError('The saved measurement body changed')
        with path.open('rb') as f:actual,=qpy.load(f)
        # The same physical paired-acquisition construction has no requested
        # working word or tolerance as an input. This is the projection that
        # permits the old occurrence to answer these new questions.
        expected=[policy.calibration_circuit(ori['policy'],p) for p in [self.pair,mirror]]
        if not any(actual==q and policy.repeated.work.ordered_bindings(actual)==policy.repeated.work.ordered_bindings(q) for q in expected):
            raise ValueError('Saved acquisition does not have the required source and report ports')

    def request(self,wanted,risk):
        self.check();return select(self.source,self.record,wanted,risk)

    def working_body(self,packet):
        self.check()
        if packet!=select(self.source,self.record,packet['request'],packet['required_error']) or packet.get('kind')!='act':raise ValueError('No applicable new reading of the saved occurrence')
        return compile_plan(self.source,self.pair,packet)

    def admit(self,packet,candidate):
        expected=self.working_body(packet)
        if candidate.metadata!=expected.metadata or candidate!=expected or policy.repeated.work.ordered_bindings(candidate)!=policy.repeated.work.ordered_bindings(expected):
            raise ValueError('Actual execution changed after selecting its read cost')
        return candidate


def build(output):
    output.mkdir(parents=True,exist_ok=True)
    r=json.loads(policy.repeated.wire.goal.run(['node',policy.repeated.wire.goal.HERE/'resident_reading_cost_court.js','build',output]))
    native=policy.repeated.wire.goal.ROOT/'.build/arm64-apple-macosx/debug/Tools'
    text=policy.repeated.wire.goal.run([native,'judge','where',output/'ResidentReadingCost.swift'])
    assert f"{r['equalities']} equalities" in text and 'THE WHERE holds' in text
    for entry in r['negatives']:
        p=subprocess.run([str(native),'judge','where',str(output/entry['file'])],capture_output=True,text=True,timeout=30)
        assert p.returncode==1 and 'requires the types' in p.stdout+p.stderr
    r['native']=text.strip();write(output/'build.json',r);return r


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    print(json.dumps(build(p.parse_args().output.resolve())))
