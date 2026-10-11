#!/usr/bin/env python3
"""Offline reuse boundary for an acquired Pauli key. No cloud, no new oracle.

Source-derived ideal acquisition bits determine a shared key (q,p,u), not A/B.
SDK matrices check the independently proved parametric recovery formula.
"""
import argparse
import hashlib
from itertools import product
import json
from pathlib import Path

from build_from_source import HERE, ROOT, run


def construct(reading):
    cells={}
    for i,(q,p,k) in enumerate(reading['observations']):
        name=f'{q}{p}{k}'
        cell=cells.setdefault(name,{'key':[q,p,p^q^k],'family':[]})
        cell['family'].append(i)
    assert len(cells)==8 and all(len(c['family'])==2 for c in cells.values())
    return {'schema':'vi.reusable-phase-key.v1','request':reading['request'],
            'source_sha256':reading['source_sha256'],'cells':cells}


def independent_checks(reading,proposal):
    import numpy as np
    from qiskit import QuantumCircuit
    from qiskit.quantum_info import Operator,Pauli
    paulis={a:Pauli(a).to_matrix() for a in 'IXYZ'}
    x,y,z=[paulis[a] for a in 'XYZ'];identity=paulis['I']
    def phase(theta):
        c=QuantumCircuit(1);c.rz(theta,0);return Operator(c).data
    c=QuantumCircuit(1);c.h(0);h=Operator(c).data
    s=phase(np.pi/2)
    def same_channel(a,b):
        return bool(np.allclose(np.kron(a,a.conj()),np.kron(b,b.conj()),atol=1e-10,rtol=0))
    def recovery(key,t,theta):
        # Runtime receives only this shared key and the requested operation.
        q,p,u=key
        m=np.linalg.matrix_power(x,p)@np.linalg.matrix_power(z,q)
        return phase(((-1)**t)*2*u*theta)@m.conj().T
    angles=[-np.sqrt(2),-.731,0.,np.pi/4,np.pi/2,np.pi,2*np.pi+.27]
    counts={'independent_acquisition_bits':0,'parametric_recovery_instances':0,
            'same_key_channel_pairs':0,'composed_payload_steps':0}
    for i,(a,b) in enumerate(reading['worlds']):
        a,b=paulis[a],paulis[b];observed=[]
        for middle,prep,out in [(identity,x,x),(identity,z,z),(s,x,y)]:
            v=b@middle@a;rho=(identity+prep)/2
            mean=float(np.trace(out@v@rho@v.conj().T).real)
            assert np.isclose(abs(mean),1,atol=1e-10,rtol=0)
            observed.append(int(mean<0));counts['independent_acquisition_bits']+=1
        assert observed==reading['observations'][i]
        key=proposal['cells'][''.join(map(str,observed))]['key']
        for t,theta in product((0,1),angles):
            desired=np.linalg.matrix_power(x,t)@phase(theta)
            actual=b@desired@a
            assert same_channel(recovery(key,t,theta)@actual,desired)
            counts['parametric_recovery_instances']+=1
        # One acquired key is reused at every step; no fresh probe or reset of
        # the live payload occurs between the corrected operations.
        wanted=identity;actual=identity
        for j in range(17):
            t=j%2;theta=(j-8)*np.sqrt(2)/7
            desired=np.linalg.matrix_power(x,t)@phase(theta)
            wanted=desired@wanted
            actual=recovery(key,t,theta)@b@desired@a@actual
            assert same_channel(actual,wanted)
            counts['composed_payload_steps']+=1
    for cell in proposal['cells'].values():
        i,j=cell['family'];a,b=[paulis[v] for v in reading['worlds'][i]]
        aa,bb=[paulis[v] for v in reading['worlds'][j]]
        for t,theta in product((0,1),angles):
            target=np.linalg.matrix_power(x,t)@phase(theta)
            assert same_channel(b@target@a,bb@target@aa)
            counts['same_key_channel_pairs']+=1
        assert not same_channel(b@h@a,bb@h@aa),'H must expose the unmeasured ambiguity'

    # A fresh H X/Z contact reads v xor w and splits every remaining pair.
    for cell in proposal['cells'].values():
        replies=[]
        for i in cell['family']:
            a,b=[paulis[v] for v in reading['worlds'][i]];v=b@h@a
            mean=float(np.trace(z@v@(identity+x)/2@v.conj().T).real)
            replies.append(int(mean<0))
        assert set(replies)=={0,1}
    # Arbitrary known unitaries outside the claimed class are not admitted by
    # numerical convenience. All these generic test matrices expose ambiguity.
    rejected=0
    for j in range(1,12):
        c=QuantumCircuit(1);c.u(.13*j,.21*j,-.37*j,0);u=Operator(c).data
        assert not same_channel(z@u@z,u);rejected+=1
    return {**counts,'H_exposes_all_eight_remaining_pairs':True,
            'one_additional_H_probe_identifies_each_pair':True,
            'generic_outside_class_examples':rejected,
            'interpretation':'SDK checks are finite instances of the report proof, not a proof over all angles; no QPU data.'}


def build(output):
    if output.exists():raise ValueError('Use a new output directory')
    output.mkdir(parents=True)
    reading=json.loads(run(['node',HERE/'reuse_scope_court.js','read']))
    proposal=construct(reading)
    def write(name,value):(output/name).write_text(json.dumps(value,indent=2)+'\n')
    write('source-reading.json',reading);write('proposal.json',proposal)
    certificate=output/'Applications.swift'
    checked=json.loads(run(['node',HERE/'reuse_scope_court.js','check',output/'proposal.json',certificate]))
    native=run([ROOT/'.build/arm64-apple-macosx/debug/Tools','judge','where',certificate])
    assert '32 equalities' in native and 'THE WHERE holds' in native
    (output/'native-court.log').write_text(native)
    independent=independent_checks(reading,proposal)
    current=json.loads(run(['node',HERE/'reuse_scope_court.js','read']))
    assert current==reading,'Current source changed before publication'
    result={'schema':'vi.reusable-phase-result.v1','source_sha256':reading['source_sha256'],
            'implementation_sha256':{p.name:hashlib.sha256(p.read_bytes()).hexdigest()
                for p in [Path(__file__),HERE/'reuse_scope_court.js']},
            'cells':proposal['cells'],'court':checked,'native_court':native.strip(),
            'independent':independent,
            'law':{'target':'X^t Rz(theta)','key':['q','p','u'],
                   'recovery_after_payload':'Rz((-1)^t * 2*u*theta) (X^p Z^q)^dagger',
                   'maximal_exact_reuse_class':'Z U Z = scalar * U, equivalently diagonal or antidiagonal U'},
            'limits':['Fixed reusable Pauli A/B, trusted ideal probes and controlled middle slot.',
                      'Live output recovery admits known phase rotations, unlike the earlier terminal Pauli-only consumer.',
                      'The key comes from all three ideal acquisitions, not the two-bit terminal answer.',
                      'Type applications certify the finite key; the parametric law uses the separate algebraic proof.',
                      'Global phase is ignored for ordinary channel calls, not coherent controlled unknown oracles.',
                      'No physical drift, noise bound or new hardware run established.']}
    write('result.json',result)
    return result


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output',required=True,type=Path)
    r=build(parser.parse_args().output.resolve())
    print(json.dumps({'cells':len(r['cells']),'native_court':r['native_court'],
                      'independent':r['independent']},indent=2))
