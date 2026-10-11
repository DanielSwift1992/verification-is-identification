#!/usr/bin/env python3
"""Derive continuation admission from actual instruments and future questions.

Finite four-retained-qubit/Clifford-question fragment. The extra joint reader
requires coherent access before measurement; it is NOT a rewrite licensed by
the old measured-contact interface alone. No service calls or QPU submission.
"""
import hashlib
import io
import itertools
import json
from pathlib import Path
import time

import numpy as np
from qiskit import QuantumCircuit, ClassicalRegister, qpy
from qiskit.circuit.library import HGate, RYGate
from qiskit.quantum_info import Clifford, Pauli, Operator

import returning_attempt_learning as learning
from returning_attempt_sdk import Ports, schedule
from returning_attempt_sdk_checks import read_instrument, projector
from resident_goal_instrument_audit import expand

ROOT = Path(__file__).resolve().parents[2]
PARENT = ROOT/'Research/Artifacts/returning-attempt-20260916/sdk'
OUT = ROOT/'Research/Artifacts/returning-attempt-20260916/admission'


def pauli(word):
    """Human label order A,B,D,E (opposite the SDK printed tensor order)."""
    assert len(word) == 4 and set(word) <= set('IXYZ')
    return Pauli(word[::-1]).to_matrix()


WORDS = [''.join(x) for x in itertools.product('IXYZ', repeat=4)]
MATRICES = {w:pauli(w) for w in WORDS}
TARGET = expand(HGate().to_matrix(), [2], 4)
TARGET = expand(RYGate(2*np.arctan2(4,3)).to_matrix(), [3], 4) @ TARGET


def verified_parent():
    manifest = json.loads((PARENT/'manifest.json').read_text())
    for name, expected in manifest['sha256'].items():
        assert hashlib.sha256((ROOT/name).read_bytes()).hexdigest() == expected, name
    return len(manifest['sha256'])


def joint_reader(source, certificate):
    """Keep the probe coherent through two XOR contacts, read only a at end.

    Each coherent contact is XOR followed by the original CZ(P,D) disturbance;
    the additional coherent-return contact CZ(P,D) undoes it without measuring.
    Scratch P is not reset between contacts. No direct read of law_a is used.
    """
    schedule(source, certificate)
    q = QuantumCircuit(5)
    record = ClassicalRegister(1,'actual_control'); q.add_register(record)
    for name in ('B','Parity'):
        if name == 'Parity': q.cx(1,0)
        q.cx(2,0)
        q.cz(0,3)  # device disturbance
        q.cz(0,3)  # extra accessible coherent return, not a classical reply
    q.measure(0,record[0]); q.reset(0)
    q.barrier(label='joint_return')
    for gate,target in ((HGate(),3),(RYGate(2*np.arctan2(4,3)),4)):
        q.append(gate,[target]); q.cz(1,target)
        with q.if_test((record[0],1)): q.z(target)
    q.barrier(label='joint_worked')
    q.metadata={'schema':'vi.returning-joint-reader.v1','source':learning.fingerprint(source),
                'additional_access':['coherent_B','coherent_Parity','coherent_return','final_measure'],
                'scope':'Coherent XOR ports before mandatory measurement; not old measured-only interface.'}
    return q


def residual_instrument(q):
    """Move the known desired unitary out of the output coordinate frame."""
    rows = read_instrument(q,Ports())
    return [(tuple(row['bits']), TARGET.conj().T @ row['map']) for row in rows]


def adjoint(operators, observable):
    return sum(k.conj().T @ observable @ k for _,k in operators)


def maximal_questions(operators):
    """Verify the complete Pauli basis is diagonal under this actual channel.

    Because this basis spans all operators, fixed columns describe the FULL
    fixed space, not just a sample of successful observables.
    """
    kept=[]; lost=[]
    for word, matrix in MATRICES.items():
        image = adjoint(operators,matrix)
        if np.max(abs(image-matrix)) < 1e-11: kept.append(word)
        elif np.max(abs(image)) < 1e-11: lost.append(word)
        else: raise ValueError('Pauli action is not a 0/1 projection: this constructor cannot classify it')
    assert len(kept)+len(lost)==256
    return {'fixed_dimension':len(kept),'fixed_words':kept,'killed_words':lost}


def full_record_obstruction(operators, word):
    """Two states give the SAME entire quantum/classical output instrument.

    A failed passive reading alone would not exclude a record-dependent
    decoder. This equality excludes every decoder of the available output.
    """
    observable=MATRICES[word]
    plus=(np.eye(16)+observable)/16
    minus=(np.eye(16)-observable)/16
    residual=max(float(np.max(abs(k@plus@k.conj().T-k@minus@k.conj().T)))
                 for _,k in operators)
    assert residual < 1e-11
    return {'word':word,'input_pair':'(I ± P)/16','full_record_branch_residual':residual,
            'desired_probabilities':[1,0],
            'scope':'Identical unnormalised retained state in every actual classical branch; any output-only decoder fails.'}


def operations():
    result={}
    q=QuantumCircuit(4);q.h(0);result['H_A']=q
    q=QuantumCircuit(4);q.h(1);result['H_B']=q
    q=QuantumCircuit(4);q.s(1);result['S_B']=q
    q=QuantumCircuit(4);q.swap(0,1);result['Swap_AB']=q
    q=QuantumCircuit(4);q.cx(0,1);result['CX_AB']=q
    return result


OPS = operations()


def pullback(word, name):
    # A Clifford maps one Pauli to a signed Pauli. Signs do not affect linear
    # span membership; the witness probability is computed independently below.
    value = Pauli(word[::-1]).evolve(Clifford(OPS[name]),frame='h')
    value.phase=0
    return value.to_label()[::-1]


def future_questions(initial, contacts):
    for w in initial: assert w in MATRICES
    for name in contacts: assert name in OPS
    proof={w:{'terminal':w,'word':[]} for w in ['IIII']+list(initial)}
    queue=list(proof);cursor=0
    while cursor<len(queue):
        word=queue[cursor];cursor+=1
        for name in contacts:
            pulled=pullback(word,name)
            if pulled not in proof:
                proof[pulled]={'terminal':proof[word]['terminal'],'word':[name]+proof[word]['word']}
                queue.append(pulled)
    certificate={'initial':list(initial),'contacts':list(contacts),'closure':proof}
    verify_future(certificate)
    return certificate


def verify_future(certificate):
    """Check generation witnesses AND closure, without doing a second search."""
    rows=certificate['closure'];contacts=certificate['contacts']
    assert 'IIII' in rows and set(certificate['initial']) <= set(rows)
    for word, witness in rows.items():
        assert witness['terminal'] in certificate['initial']+['IIII']
        actual=witness['terminal']
        for name in reversed(witness['word']):
            assert name in contacts
            actual=pullback(actual,name)
        assert actual==word
        for name in contacts:assert pullback(word,name) in rows
    return True


def counterexample(operators, word, witness):
    # Evaluate an actual continuation and state, including Pauli signs. This
    # is stronger than returning "unsupported": it exhibits different answers.
    v=np.eye(16,dtype=complex)
    for name in witness['word']:v=Operator(OPS[name]).data @ v
    observable=v.conj().T @ MATRICES[witness['terminal']] @ v
    rho=(np.eye(16)+observable)/16
    effect=(np.eye(16)+MATRICES[witness['terminal']])/2
    after=sum(k@rho@k.conj().T for _,k in operators)
    intended=float(np.trace(effect@v@rho@v.conj().T).real)
    observed=float(np.trace(effect@v@after@v.conj().T).real)
    assert abs(intended-observed) > 1e-10
    return {'lost_reading':word,**witness,'state':'(I + V† P_terminal V)/16',
            'desired_probability':intended,'candidate_probability':observed,
            'scope':'All-outcome retained channel in the known target frame; no postselection.'}


def admit(operators, certificate):
    verify_future(certificate)
    for word,witness in certificate['closure'].items():
        if np.max(abs(adjoint(operators,MATRICES[word])-MATRICES[word])) > 1e-11:
            return {'admitted':False,'counterexample':counterexample(operators,word,witness)}
    return {'admitted':True,'preserved_future_dimension':len(certificate['closure'])}


ACCESS={
    'separate':{'measured_B','measured_Parity','work'},
    'joint':{'coherent_B','coherent_Parity','coherent_return','final_measure','work'},
    'echo':{'work'},
}


def candidates(instruments, certificate, available):
    result={}
    for name,ops in instruments.items():
        missing=sorted(ACCESS[name]-set(available))
        result[name]=({'admitted':False,'unavailable_contacts':missing} if missing else admit(ops,certificate))
    return result


def run():
    began=time.perf_counter();verified=verified_parent()
    source=learning.read_source();cert=learning.synthesize(source)
    instruments={}
    for name,file in [('separate','acquired-0.qpy'),('echo','echo-0.qpy')]:
        with (PARENT/file).open('rb') as f:q,=qpy.load(f)
        instruments[name]=residual_instrument(q)
    for bits,k in instruments['separate']:
        assert np.max(abs(k-projector(a=bits[0]^bits[1],b=bits[0]))) < 1e-11
    assert len(instruments['echo'])==1 and np.max(abs(instruments['echo'][0][1]-np.eye(16))) < 1e-11
    q=joint_reader(source,cert)
    stream=io.BytesIO();qpy.dump(q,stream);payload=stream.getvalue();stream.seek(0)
    restored,=qpy.load(stream)
    instruments['joint']=residual_instrument(restored)
    assert len(instruments['joint'])==2
    for bits,k in instruments['joint']:
        assert np.max(abs(k-projector(a=bits[0]))) < 1e-11
    classified={name:maximal_questions(ops) for name,ops in instruments.items()}
    assert {name:v['fixed_dimension'] for name,v in classified.items()}=={'separate':64,'echo':256,'joint':128}
    # Check every rejected Pauli, not only the illustrative X_A/X_B cases.
    obstructions={name:[full_record_obstruction(instruments[name],w) for w in profile['killed_words']]
                  for name,profile in classified.items()}
    # Forgetting the acquired b in a classical record cannot undo its physical
    # measurement. Coarsen (b,p) to a, retaining all Kraus terms in each fiber.
    coarse={a:[k for bits,k in instruments['separate'] if bits[0]^bits[1]==a] for a in (0,1)}
    regrouped=[((a,),k) for a,ks in coarse.items() for k in ks]
    assert maximal_questions(regrouped)==classified['separate']
    requests={
        'data_only':future_questions(['II'+x+y for x,y in itertools.product('IXYZ',repeat=2)],[]),
        'B_label':future_questions(['IZII'],[]),
        'B_label_after_H':future_questions(['IZII'],['H_B']),
        'B_phase_after_swap':future_questions(['IXII'],['Swap_AB']),
        'all_AB_after_controls':future_questions(['IZII'],['H_A','H_B','S_B','Swap_AB','CX_AB']),
    }
    available=set().union(*ACCESS.values())
    decisions={name:candidates(instruments,r,available) for name,r in requests.items()}
    assert all(v['admitted'] for v in decisions['data_only'].values())
    assert all(v['admitted'] for v in decisions['B_label'].values())
    assert not decisions['B_label_after_H']['separate']['admitted']
    assert decisions['B_label_after_H']['joint']['admitted']
    assert not decisions['B_phase_after_swap']['joint']['admitted']
    assert decisions['B_phase_after_swap']['echo']['admitted']
    assert len(requests['all_AB_after_controls']['closure'])==16
    limited=candidates(instruments,requests['B_label_after_H'],ACCESS['separate'])
    assert not limited['joint']['admitted'] and limited['echo']['admitted']
    negatives=[]
    invalid=json.loads(json.dumps(requests['B_label_after_H']));del invalid['closure']['IXII']
    try:verify_future(invalid)
    except AssertionError:negatives.append('incomplete promised future closure')
    else:raise AssertionError('Lost future not detected')
    # Claiming the coarsened record is the joint reader fails on a current B phase.
    witness=counterexample(regrouped,'IXII',{'terminal':'IXII','word':[]})
    # A classical truth table does not establish a coherent oracle's phase.
    # Z_B is a global phase for each fixed classical law, hence invisible to
    # all such basis-law channel checks. It flips a preserved B-phase question.
    phased=q.copy_empty_like();phased.z(2);phased.compose(q,inplace=True)
    phased_ops=residual_instrument(phased)
    for (_,old),(_,new) in zip(instruments['joint'],phased_ops):
        for a,b in itertools.product((0,1),repeat=2):
            block=projector(a,b)
            assert np.max(abs(new@block-(-1)**b*old@block)) < 1e-11
    phase_access=admit(phased_ops,future_questions(['IXII'],[]))
    assert not phase_access['admitted']
    OUT.mkdir(parents=True,exist_ok=True);(OUT/'joint-reader.qpy').write_bytes(payload)
    output={'schema':'vi.returning-boundary-admission.v1','verified_parent_files':verified,
            'source':learning.fingerprint(source),'classification':classified,
            'full_record_obstructions':obstructions,
            'future_certificates':requests,'admission':decisions,'measured_access_only':limited,
            'classical_coarsening_is_not_coherent_acquisition':witness,'negative_checks':negatives,
            'classical_truth_table_does_not_fix_coherent_access':phase_access,
            'joint_reader_QPY_sha256':hashlib.sha256(payload).hexdigest(),
            'runtime_seconds':time.perf_counter()-began,
            'scope':'Actual finite instruments; full input operators incl references. '
                    'Future closures limited to declared Clifford contacts. Additional coherent access explicit. No QPU job.'}
    (OUT/'checks.json').write_text(json.dumps(output,indent=2)+'\n')
    print(json.dumps({'fixed_dimensions':{n:x['fixed_dimension'] for n,x in classified.items()},
                      'admission':{n:{m:d['admitted'] for m,d in row.items()} for n,row in decisions.items()},
                      'runtime_seconds':output['runtime_seconds'],'coarsening_counterexample':witness},indent=2))


if __name__=='__main__':run()
