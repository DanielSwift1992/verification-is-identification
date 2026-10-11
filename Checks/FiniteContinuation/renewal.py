#!/usr/bin/env python3
"""Refresh only the lost key distinctions under explicit transition relations.

The producer receives current-type readings, an old acquired key and the
admitted relation. It never receives a realized old or new module pair.
"""
import argparse
import hashlib
from itertools import product
import json
from pathlib import Path

from build_from_source import HERE,ROOT,run
from planner import synthesize,execute


def construct(reading):
    actions={f'key:{q}{p}{u}':{'physical_gates':0} for q,p,u in product((0,1),repeat=3)}
    valid=[['key:'+''.join(map(str,k))] for k in reading['keys']]
    # Duplicated and sign-complemented contacts supply the same partition.
    # Keep a shortest native representative, deriving all rows from the court.
    distinct={}
    for probe in sorted(reading['probes'],key=lambda p:(p['control_gates'],p['id'])):
        bits=tuple(probe['replies']);partition=min(bits,tuple(1-b for b in bits))
        distinct.setdefault(partition,probe)
    problem={'valid':valid,'actions':actions,'probes':list(distinct.values())}
    cases=[]
    for profile,changes in reading['profiles'].items():
        for old_key in product((0,1),repeat=3):
            old=[i for i,k in enumerate(reading['keys']) if k==list(old_key)]
            edges=[e for e in reading['edges'] if e['before'] in old and e['delta'] in changes]
            family=sorted({e['after'] for e in edges})
            cases.append({'schema':'vi.phase-key-renewal.v1','request':'refresh full monomial recovery key',
                          'source_sha256':reading['source_sha256'],'profile':profile,'allowed_changes':changes,
                          'old_key':list(old_key),'old_family':old,'family':family,
                          'plan':synthesize(problem,family)})
    return cases


def independent_checks(reading,cases):
    import numpy as np
    from qiskit import QuantumCircuit
    from qiskit.quantum_info import Pauli,Operator
    from audit import depth_bound,fixed_bound
    pauli={a:Pauli(a).to_matrix() for a in 'IXYZ'};identity=pauli['I'];x=pauli['X']
    same=lambda a,b:np.allclose(np.kron(a,a.conj()),np.kron(b,b.conj()),atol=1e-10,rtol=0)
    def rz(theta):
        c=QuantumCircuit(1);c.rz(theta,0);return Operator(c).data
    replies={}
    for p in reading['probes']:
        c=QuantumCircuit(1)
        for g in p['middle']:getattr(c,g)(0)
        middle=Operator(c).data;rho=(identity+pauli[p['prep']])/2;column=[]
        for a,b in reading['worlds']:
            v=pauli[b]@middle@pauli[a]
            expectation=float(np.trace(pauli[p['read']]@v@rho@v.conj().T).real)
            assert np.isclose(abs(expectation),1,atol=1e-10,rtol=0)
            column.append(int(expectation<0))
        assert column==p['replies']
        bit_tuple=tuple(column);key=min(bit_tuple,tuple(1-b for b in bit_tuple))
        replies.setdefault(key,tuple(column))
    columns={str(i):c for i,c in enumerate(replies.values())}
    for e in reading['edges']:
        before=reading['worlds'][e['before']];after=reading['worlds'][e['after']]
        for old,new,d in zip(before,after,e['delta']):
            assert same(pauli[d]@pauli[old],pauli[new])
    # The key labels here come from an independent reading of Pauli matrices.
    keys=[]
    for a,b in reading['worlds']:
        a,b=pauli[a],pauli[b];m=b@a
        sign=lambda v,p:int(np.trace(p@v@p@v.conj().T).real<0)
        keys.append([sign(m,pauli['X']),sign(m,pauli['Z']),sign(a,pauli['Z'])])
    assert keys==reading['keys']
    valid=tuple(frozenset(['key:'+''.join(map(str,k))]) for k in keys)
    by_id={p['id']:p['replies'] for p in reading['probes']}
    summary={};applications=0
    expected={'known_A_X':0,'paired_Z':0,'same_Pauli':1,'A_only':2,'B_only':2,'one_unspecified_module':3,'arbitrary':3}
    for case in cases:
        family=case['family'];depth=depth_bound(valid,columns,family);fixed,_=fixed_bound(valid,columns,family)
        count=len({tuple(keys[i]) for i in family})
        lower=(count-1).bit_length()
        assert depth==fixed==lower==expected[case['profile']]==case['plan']['tree']['cost'][0]
        summary.setdefault(case['profile'],{'remaining_keys':count,'remaining_sources':len(family),
                                           'adaptive_minimum':depth,'fixed_minimum':fixed,'old_keys_checked':0})['old_keys_checked']+=1
        if case['profile']=='known_A_X':
            q0,p0,u0=case['old_key']
            assert all(keys[i]==[q0,p0^1,u0^1] for i in family)
        for i in family:
            result=execute(case['plan'],lambda p:by_id[p][i])
            assert result['action'] in valid[i]
            q,p,u=map(int,result['action'][4:]);m=np.linalg.matrix_power(x,p)@np.linalg.matrix_power(pauli['Z'],q)
            a,b=[pauli[v] for v in reading['worlds'][i]]
            for t,theta in product((0,1),(.37,np.pi/4,-np.sqrt(2))):
                target=np.linalg.matrix_power(x,t)@rz(theta)
                correction=rz((-1)**t*2*u*theta)@m.conj().T
                assert same(correction@b@target@a,target);applications+=1

    # Each truthful reading can belong to a different source occurrence.
    ix={tuple(w):i for i,w in enumerate(reading['worlds'])}
    source_sequence=[ix[('I','I')],ix[('I','X')],ix[('I','I')]]
    chosen=[next(p for p in reading['probes'] if p['middle']==middle and p['prep']==prep)
            for middle,prep in [([], 'X'),([], 'Z'),(['s'],'X')]]
    mixed=[p['replies'][i] for p,i in zip(chosen,source_sequence)]
    q,p,k=mixed;invented=[q,p,p^q^k]
    assert mixed==[0,1,0] and invented==[0,1,1] and invented!=keys[source_sequence[-1]]
    # Changing only after the last successful test also evades any finite
    # pre-use validation. This is an exact witness, not a simulated frequency.
    t=rz(np.pi/4);actual=pauli['X']@t@pauli['X']
    assert not same(actual,t)
    plus=(identity+x)/2;input_state=t.conj().T@plus@t
    stale_success=float((1+np.trace(x@actual@input_state@actual.conj().T).real)/2)
    assert np.isclose(stale_success,.5)
    return {'profile_minima':summary,'source_transition_edges_checked':len(reading['edges']),
            'independent_probe_entries':len(reading['probes'])*16,'corrected_live_channels_checked':applications,
            'mixed_epoch_witness':{'sources':[['I','I'],['I','X'],['I','I']],
                                   'truthful_bits':mixed,'inferred_key':invented,'actual_last_key':keys[source_sequence[-1]]},
            'post_test_change_witness':{'old':['I','I'],'new':['X','X'],
                                         'old_T_X_readout_success_probability':stale_success},
            'limits':'Ideal finite epochs and explicitly granted change relations; no hardware, no acquired evidence of temporal stability.'}


def build(output):
    if output.exists():raise ValueError('Use a new output directory')
    output.mkdir(parents=True)
    write=lambda p,v:p.write_text(json.dumps(v,indent=2)+'\n')
    reading=json.loads(run(['node',HERE/'renewal_court.js','read']))
    cases=construct(reading);proofs=[]
    # One bounded JS process reads the active source once and verifies all
    # applications. Native checks still consume each actually emitted proof.
    write(output/'cases.json',cases)
    js="""const fs=require('node:fs'),path=require('node:path');
const court=require('./Checks/FiniteContinuation/renewal_court.js');
const dir=process.argv[1],data=court.current();const cases=JSON.parse(fs.readFileSync(path.join(dir,'cases.json')));
let result=[];for(let i=0;i<cases.length;i++){const checked=court.check(data,cases[i]);
const name=String(i).padStart(2,'0');fs.writeFileSync(path.join(dir,name+'.swift'),checked.source);
const {source,...report}=checked;result.push({name,...report});}console.log(JSON.stringify(result));"""
    checked=json.loads(run(['node','-e',js,output]))
    for case,c in zip(cases,checked):
        assert c['source_sha256']==reading['source_sha256']
        log=run([ROOT/'.build/arm64-apple-macosx/debug/Tools','judge','where',output/(c['name']+'.swift')])
        assert f"{c['verdict']['judged']} equalities" in log and 'THE WHERE holds' in log
        proofs.append({'profile':case['profile'],'old_key':case['old_key'],'court':c,'native':log.strip()})
    audit=independent_checks(reading,cases)
    assert json.loads(run(['node',HERE/'renewal_court.js','read']))==reading
    result={'schema':'vi.key-renewal-result.v1','source_sha256':reading['source_sha256'],
            'implementation_sha256':{p.name:hashlib.sha256(p.read_bytes()).hexdigest()
                 for p in [Path(__file__),HERE/'renewal_court.js']},
            'cases':len(cases),'equalities_per_court':sum(c['court']['verdict']['judged'] for c in proofs),
            'proofs':proofs,'audit':audit}
    write(output/'source-reading.json',reading);write(output/'result.json',result)
    return result


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',required=True,type=Path)
    result=build(p.parse_args().output.resolve())
    print(json.dumps({k:result[k] for k in ('cases','equalities_per_court','audit')},indent=2))
