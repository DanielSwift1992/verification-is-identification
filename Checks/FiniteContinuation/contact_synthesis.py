#!/usr/bin/env python3
"""Synthesize an inserted contact from current VI operations; offline only.

The caller exposes A [middle] B and no individual A/B ports. Old observations
read the neutral channel. Search sees all possibilities, never the realized
fixture. The SDK independently tests compositions and the resulting procedure.
"""
import argparse
from itertools import combinations,product
import json
from pathlib import Path
import subprocess
from tempfile import TemporaryDirectory

from build_from_source import HERE,ROOT,run
from planner import synthesize


def write(path,data):path.write_text(json.dumps(data,indent=2)+'\n')


def construct(reading):
    p=reading['model'];neutral={q['prep']:q for q in p['probes'] if not q['middle']}
    cases=[]
    for old in product((0,1),repeat=2):
        family=[i for i in range(16) if all(neutral[a]['replies'][i]==b for a,b in zip('XZ',old))]
        unavailable=synthesize({**p,'probes':list(neutral.values())},family)
        assert unavailable['tree']['kind']=='insufficient'
        witness=next((i,j) for i,j in combinations(family,2) if not set(p['valid'][i])&set(p['valid'][j]))
        candidates=[]
        for q in p['probes']:
            plan=synthesize({**p,'probes':[q]},family)
            if plan['tree']['kind']=='probe' and all(n['kind']=='act' for n in plan['tree']['branches'].values()):
                candidates.append((q,plan))
        assert candidates,'No single-contact solution found in the generated closure'
        q,plan=min(candidates,key=lambda item:(item[0]['control_gates'],item[0]['module_uses'],item[0]['id']))
        descriptor={k:v for k,v in q.items() if k!='replies'}
        proposal={'schema':'vi.composed-contact-proposal.v1',
                  'request':{'connector':['t'],'consumer':'terminal','axis':'X','port':'A middle B'},
                  'old_memory':list(old),'family':family,'contact':descriptor,
                  'branches':{bit:{'family':[i for i in family if str(q['replies'][i])==bit],
                                   'action':node['action'],'execution':p['actions'][node['action']]}
                              for bit,node in plan['tree']['branches'].items()}}
        cases.append({'proposal':proposal,'old_indistinguishable_pair':list(witness),
                      'old_plan':unavailable,'candidate_count':len(candidates)})
    return cases


def structural_checks(reading,cases):
    """Check the analytic kernel criterion and changes of contact location."""
    import numpy as np
    from qiskit import QuantumCircuit
    from qiskit.quantum_info import Operator,Pauli
    paulis={a:Pauli(a).to_matrix() for a in 'IXYZ'}
    gates={}
    for g in ('h','s','t'):
        c=QuantumCircuit(1);getattr(c,g)(0);gates[g]=Operator(c).data
    centralizers={g:[a for a,p in paulis.items() if np.isclose(
        abs(np.trace(u.conj().T@p.conj().T@u@p)),2,atol=1e-10,rtol=0)] for g,u in gates.items()}
    assert centralizers=={'h':['I','Y'],'s':['I','Z'],'t':['I','Z']}
    counts=[]
    for case in cases:
        good=[];family=case['proposal']['family'];p=reading['model']
        h_only=[q for q in p['probes'] if set(q['middle'])<= {'h'}]
        assert synthesize({**p,'probes':h_only},family)['tree']['kind']=='insufficient'
        for q in p['probes']:
            groups=[[i for i in family if q['replies'][i]==b] for b in (0,1)]
            works=all(group and set.intersection(*(set(p['valid'][i]) for i in group)) for group in groups)
            criterion=set((q['prep'],q['read']))=={'X','Y'}
            assert bool(works)==criterion,'The independently stated axis criterion failed'
            if works:good.append(q['id'])
        assert len(good)==16
        counts.append({'old_memory':case['proposal']['old_memory'],'adequate_contacts':good})
    x,y,z=[paulis[a] for a in 'XYZ'];s,t,h=[gates[g] for g in ('s','t','h')]
    plus=(np.eye(2)+x)/2
    inside=x@s@x;outside=x@x@s
    assert np.isclose(np.trace(y@inside@plus@inside.conj().T).real,-1)
    assert np.isclose(np.trace(y@outside@plus@outside.conj().T).real,1)
    payload=x@t@x;input_state=t.conj().T@plus@t
    wrong_success=(1+np.trace(x@payload@input_state@payload.conj().T).real)/2
    assert np.isclose(wrong_success,.5)
    assert np.allclose([np.trace(z@u@plus@u.conj().T).real for u in [h,z@h@z]],[1,-1])
    return {'scope':'Exact-model structural checks with independent complex matrices; no hardware',
            'projective_Pauli_centralizers':centralizers,'criterion':'prep/read unordered pair equals {X,Y}',
            'classified_contacts':72,'classification_by_old_memory':counts,
            'all_H_only_contacts_still_insufficient_on_each_old_fiber':True,
            'wrong_placement_on_XX':{'inside_probe_bit':1,'outside_probe_bit':0,
                                    'wrong_action_plus_success_probability':float(wrong_success)},
            'remaining_II_ZZ_sources_are_distinguished_by_later_H_contact':True}


def independent_sdk(reading,cases):
    import numpy as np
    from qiskit import QuantumCircuit
    from qiskit.primitives import StatevectorSampler
    from qiskit.quantum_info import Operator,Pauli
    from audit import depth_bound,fixed_bound
    paulis={a:Pauli(a).to_matrix() for a in 'IXYZ'}
    t_c=QuantumCircuit(1);t_c.t(0);t=Operator(t_c).data
    p=reading['model'];worlds=p['worlds'];independent={};samples=[]
    target=t.conj().T@paulis['X']@t
    for q in p['probes']:
        middle=QuantumCircuit(1)
        for gate in q['middle']:getattr(middle,gate)(0)
        c=Operator(middle).data;bits=[]
        rho=(np.eye(2)+paulis[q['prep']])/2
        for a,b in worlds:
            actual=paulis[b]@c@paulis[a]
            expectation=np.trace(paulis[q['read']]@actual@rho@actual.conj().T).real
            assert np.isclose(abs(expectation),1,atol=1e-10,rtol=0)
            bits.append(0 if expectation>0 else 1)
        assert bits==q['replies'],'Type-composed contact disagrees with complex SDK matrices'
        independent[q['id']]=tuple(bits)
    actual_rows=[]
    for a,b in worlds:
        actual=paulis[b]@t@paulis[a]
        valid=set()
        for axis,sign in product('XYZ',(1,-1)):
            if np.allclose(actual.conj().T@(sign*paulis[axis])@actual,target,atol=1e-10,rtol=0):
                valid.add(f'read:{sign:+}:{axis}')
        actual_rows.append(frozenset(valid))
    assert tuple(actual_rows)==tuple(frozenset(r) for r in p['valid'])
    for case in cases:
        i,j=case['old_indistinguishable_pair']
        a,b=worlds[i];c,d=worlds[j]
        u=paulis[b]@paulis[a];v=paulis[d]@paulis[c]
        assert np.allclose(abs(np.trace(u.conj().T@v)),2,atol=1e-10,rtol=0)
        assert not actual_rows[i]&actual_rows[j]

    # Complementary outcomes have the same partition. Separate bounded-tree
    # search uses independently rebuilt matrices, not the type reader's table.
    partitions={}
    for name,bits in independent.items():
        key=min(bits,tuple(1-b for b in bits))
        partitions.setdefault(key,name)
    columns={name:bits for bits,name in partitions.items()}
    full=list(range(16))
    target_depth=depth_bound(tuple(actual_rows),columns,full)
    target_fixed=fixed_bound(tuple(actual_rows),columns,full)
    identity_rows=tuple(frozenset([str(i)]) for i in full)
    identify_depth=depth_bound(identity_rows,columns,full)
    identify_fixed=fixed_bound(identity_rows,columns,full)

    # A controller receives only acquired bits. The fixture closure implements
    # the SAME two modules for old contacts, the generated contact and payload.
    sampler=StatevectorSampler(seed=3914)
    def prepare(c,axis):
        if axis in 'XY':c.h(0)
        if axis=='Y':c.s(0)
    def measure(c,axis):
        if axis=='Y':c.sdg(0)
        if axis in 'XY':c.h(0)
        c.measure(0,0)
    def module(c,label):
        if label!='I':getattr(c,label.lower())(0)
    def sample(c):
        counts=sampler.run([c],shots=1).result()[0].data.c.get_counts()
        assert sum(counts.values())==1
        return int(next(iter(counts)))
    for i,(a,b) in enumerate(worlds):
        receipts=[]
        def contact(descriptor):
            c=QuantumCircuit(1,1);prepare(c,descriptor['prep']);module(c,a)
            for g in descriptor['middle']:getattr(c,g)(0)
            module(c,b);measure(c,descriptor['read']);bit=sample(c)
            receipts.append({'contact':descriptor,'reply':bit});return bit
        old=[contact({'middle':[],'prep':axis,'read':axis}) for axis in 'XZ']
        selected=next(c['proposal'] for c in cases if c['proposal']['old_memory']==old)
        bit=contact(selected['contact']);branch=selected['branches'][str(bit)]
        assert branch['action'] in actual_rows[i]
        for target_bit in (0,1):
            c=QuantumCircuit(1,1)
            if target_bit:c.x(0)
            c.h(0);c.tdg(0);module(c,a);c.t(0);module(c,b)
            measure(c,branch['execution']['read'])
            raw=sample(c);answer=raw^int(branch['execution']['sign']==-1)
            assert answer==target_bit
        samples.append({'fixture_for_auditor_only':[a,b],'receipts':receipts,
                        'action':branch['action'],'retained_sources':branch['family'],'validation_correct':2})
    return {'scope':'Independent local SDK only, no QPU and no device-noise model',
            'contact_rows_checked':len(p['probes'])*len(worlds),'payload_observable_equalities':16,
            'independent_binary_partitions':len(columns),
            'minimum_contacts_from_no_memory':{'target_adaptive':target_depth,'target_fixed':target_fixed,
                'complete_identification_adaptive':identify_depth,'complete_identification_fixed':identify_fixed},
            'single_shot_acquisition_samples':48,'single_shot_validation_samples':32,'episodes':samples}


def build(output):
    if output.exists():raise ValueError('Use a new output directory')
    output.mkdir(parents=True)
    reading=json.loads(run(['node',HERE/'contact_court.js','read']))
    cases=construct(reading);proofs=[]
    for case in cases:
        proposal=case['proposal'];name=''.join(map(str,proposal['old_memory']));directory=output/name;directory.mkdir()
        file=directory/'proposal.json';write(file,proposal)
        certificate=directory/'Applications.swift'
        proof=json.loads(run(['node',HERE/'contact_court.js','check',file,certificate]))
        assert proof['source_sha256']==reading['source_sha256']
        log=run([ROOT/'.build/arm64-apple-macosx/debug/Tools','judge','where',certificate])
        assert '10 equalities' in log and 'THE WHERE holds' in log
        (directory/'native-court.log').write_text(log)
        proofs.append({'old_memory':proposal['old_memory'],'proof':proof,'native_court':log.strip()})
    sdk=independent_sdk(reading,cases);structure=structural_checks(reading,cases)
    current=json.loads(run(['node','-e',
        "console.log(JSON.stringify(require('./Checks/FiniteContinuation/contact_court.js').context().fingerprints))"]))
    assert current==reading['source_sha256'],'Current source changed before publication'
    program={'schema':'vi.synthesized-contact-program.v1','request':cases[0]['proposal']['request'],
             'old_contacts':[{'middle':[],'prep':axis,'read':axis} for axis in 'XZ'],
             'cases':[case['proposal'] for case in cases]}
    report={'schema':'vi.contact-synthesis-result.v1','source_sha256':reading['source_sha256'],
            'generated_profiles':reading['generated_clifford_profiles'],
            'generated_contacts':len(reading['model']['probes']),'cases':cases,'proofs':proofs,'sdk':sdk,
            'structural_checks':structure,
            'limits':['Exact, fixed, reusable Pauli modules and trusted preparation/readout.',
                      'One accessible middle slot; no separate calls to A or B.',
                      'The old memory is ideal acquired neutral X/Z, not noisy counts.',
                      'No QPU submission and no modification of the frozen IBM campaign.',
                      'Type equalities check applications; minima also use the separate analytic argument and finite search.']}
    write(output/'source-reading.json',reading);write(output/'result.json',report)
    write(output/'program.json',program)
    return report


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--output',type=Path,required=True)
    args=parser.parse_args();r=build(args.output.resolve())
    print(json.dumps({'profiles':r['generated_profiles'],'contacts':r['generated_contacts'],
                      'chosen_contacts':[c['proposal']['contact'] for c in r['cases']],
                      'sdk':{k:v for k,v in r['sdk'].items() if k!='episodes'}},indent=2))
