#!/usr/bin/env python3
"""Independent SDK channels, persistent memory, refusal and accuracy checks.

No cloud, no shots, no fitted diamond distance. A normalized Choi trace distance
below is only a lower witness; upper bounds come from a full-channel mixture.
"""
import argparse
from copy import deepcopy
from fractions import Fraction
import json
from pathlib import Path

import numpy as np
from qiskit.quantum_info import Operator,Kraus,SuperOp,Choi
from qiskit.circuit.library import HGate,SGate,CZGate

from environment import write,digest
from build_from_source import ROOT,HERE
from joint_returns import choose,validate,bound,fraction,pair

I=np.eye(2,dtype=complex);H=Operator(HGate()).data;S=Operator(SGate()).data
Z=S@S;X=H@Z@H;Y=1j*X@Z;CZ=Operator(CZGate()).data
PLUS=np.array([1,1],complex)/np.sqrt(2)
REPLACE=[np.kron(I,np.outer(PLUS,np.eye(2)[i])) for i in range(2)]


def op(word):
    u=I.copy()
    for g in word:u={'h':H,'s':S}[g]@u
    return u


def module_operator(source,model,side):
    u=np.eye(4,dtype=complex)
    primitive={'cz':CZ,'h':np.kron(H,I),'s':np.kron(S,I),'memory_s':np.kron(I,S)}
    for g in source['modules'][model][side]:u=primitive[g]@u
    return u


def unitary(u):return SuperOp(Operator(u)).data


def step(operation,probability):
    gate=operation['gate']
    if gate=='cz':return unitary(CZ)
    if gate=='refresh':
        q=float(probability)
        return SuperOp(Kraus([np.sqrt(1-q)*np.eye(4)]+[np.sqrt(q)*k for k in REPLACE])).data
    u={'h':H,'s':S}[gate]
    return unitary(np.kron(u,I) if operation['target']=='D' else np.kron(I,u))


def channel(operations,q):
    result=np.eye(16,dtype=complex)
    for operation in operations:result=step(operation,q)@result
    return result


def evolve(s,rho):return (s@rho.reshape(-1,order='F')).reshape(rho.shape,order='F')


def reduced(s):
    # Domain D only, with freshly prepared E=|+>. Tensor order D,E.
    cols=[];e=np.outer(PLUS,PLUS.conj())
    for j in range(2):
        for i in range(2):
            x=np.zeros((2,2),complex);x[i,j]=1
            y=evolve(s,np.kron(x,e)).reshape(2,2,2,2)
            cols.append(np.einsum('aibi->ab',y).reshape(-1,order='F'))
    return np.stack(cols,axis=1)


def trace_distance(a,b):return float(np.sum(np.abs(np.linalg.eigvalsh((a-b+a.conj().T-b.conj().T)/2)))/2)


def check_channels(source):
    maximum=0.;mixtures=0;exact=0;min_bad_eigenvalue=0.;examples=[]
    paulis={'I':I,'X':X,'Z':Z,'XZ':X@Z}
    gates={'CZ':CZ,'H':np.kron(H,I),'S':np.kron(S,I),'MemoryS':np.kron(I,S)}
    for name,profile in source['primitives'].items():
        interpreted=np.zeros((4,4),complex)
        for i,block in enumerate(profile['blocks']):
            projector=np.zeros((2,2),complex);projector[i,i]=1
            interpreted+=np.kron((1j**block['phase'])*paulis[block['word']]@op(profile['ideal']),projector)
        assert np.max(np.abs(interpreted-gates[name]))<1e-12,('Wrong primitive interpretation',name)
    # Program construction is independently spelled out here, not read from
    # the producer's emitted gate list as the definition of the correct action.
    for name,offer in source['offers'].items():
        if name=='Replace':continue
        for goal in source['goals']:
            packet=choose(source,goal['word'],[name],[1,1])
            ops=validate(source,packet,goal['word'],[name],[1,1])
            actual=channel(ops,fraction(offer['rate']))
            mem=Z if offer['model']=='JointMoving' else I
            ideal=unitary(np.kron(op(goal['word']),mem))
            # Independent block expansion T2 (U_D x I_E) T1.
            a=module_operator(source,offer['model'],'A');b=module_operator(source,offer['model'],'B')
            q=float(fraction(offer['rate']));refresh=SuperOp(Kraus([np.sqrt(1-q)*np.eye(4)]+[np.sqrt(q)*k for k in REPLACE])).data
            t1=unitary(a)@refresh@unitary(a)
            t2=unitary(a@b)@refresh@unitary(a@b)
            independent=t2@unitary(np.kron(op(goal['word']),I))@t1
            error=float(np.max(np.abs(actual-independent)));assert error<1e-11
            maximum=max(maximum,error)
            e=bound(offer)
            if not e:
                error=float(np.max(np.abs(actual-ideal)));assert error<1e-11
                maximum=max(maximum,error);exact+=1
            else:
                actual_choi=Choi(SuperOp(actual)).data;ideal_choi=Choi(SuperOp(ideal)).data
                bad=(actual_choi-float(1-e)*ideal_choi)/float(e)
                assert Choi(bad).is_cptp(atol=1e-9)
                smallest=float(np.linalg.eigvalsh(bad).min());min_bad_eigenvalue=min(min_bad_eigenvalue,smallest)
                witness=trace_distance(actual_choi/4,ideal_choi/4)
                assert witness<=float(e)+1e-10;mixtures+=1
                if goal['word']==['h']:examples.append({'offer':name,'upper_bound':pair(e),'normalized_Choi_trace_lower_witness':witness})
    return {'primitive_interpretations':len(gates),'exact_joint_channels':exact,'full_channel_mixtures':mixtures,'maximum_matrix_error':maximum,
            'smallest_bad_Choi_eigenvalue':min_bad_eigenvalue,'H_bounds':examples}


def memory_witness(source):
    p=choose(source,['h'],['Keep'],[0,1]);keep=channel(p['execution'],Fraction(0))
    r=choose(source,['h'],['Replace'],[1,1]);reset=channel(r['execution'],Fraction(1))
    isolated=reduced(unitary(CZ));dz=(unitary(I)+unitary(Z))/2
    assert np.max(np.abs(isolated-dz))<1e-12
    # One reset before an isolated call gives exactly the same reduced map.
    reset_first=SuperOp(Kraus(REPLACE)).data
    assert np.max(np.abs(reduced(unitary(CZ)@reset_first)-isolated))<1e-12
    ideal=unitary(H);depol=(unitary(I)+unitary(X)+unitary(Y)+unitary(Z))/4
    assert np.max(np.abs(reduced(keep)-ideal))<1e-12
    assert np.max(np.abs(reduced(reset)-depol))<1e-12
    cj=lambda s:Choi(SuperOp(s)).data/2
    distance=trace_distance(cj(reduced(reset)),cj(ideal));assert abs(distance-.75)<1e-12
    # A moving environment is a positive case, not an identity-return claim.
    moving=choose(source,['h'],['Moving'],[0,1]);s=channel(moving['execution'],Fraction(0))
    initial=np.kron(np.array([[1,0],[0,0]],complex),np.outer(PLUS,PLUS.conj()))
    final=evolve(s,initial);second=evolve(s,final)
    e_x=float(np.trace(final@np.kron(I,X)).real);assert abs(e_x+1)<1e-12
    assert np.max(np.abs(second-initial))<1e-12
    return {'isolated_A_in_both_modes':'complete Z dephasing','retained_word':'H channel',
            'replaced_word':'complete depolarization','replaced_H_half_diamond':distance,
            'why_exact_distance':'The relative channel is a Pauli mixture with total nonidentity weight 3/4; its Bell outputs are orthogonal.',
            'moving_environment_X_expectation_after_one':e_x,'two_moving_H_words_restore_the_fixture':True}


def refusals_and_stream(source):
    rejected=[]
    def reject(name,fn):
        try:fn()
        except (AssertionError,ValueError,KeyError):rejected.append(name)
        else:raise AssertionError('Accepted '+name)
    names=['Replace','Fast','Protected'];word=['h'];tol=[1,100]
    good=choose(source,word,names,tol);assert good['offer']=='Protected'
    for name,mutate in [
        ('budget increased after selection',lambda p:p.update(error_bound=[0,1])),
        ('different insertion boundaries',lambda p:p['execution'].insert(0,{'gate':'refresh','boundary':1,'memory':'E'})),
        ('same name attached to another memory',lambda p:p['execution'][0].update(memory='other-E')),
        ('data-only calibration used as full joint contract',lambda p:p.update(scope='single_call_reduced_D')),
        ('substituted joint memory target',lambda p:p.update(environment_S_power=2)),
    ]:
        p=deepcopy(good);mutate(p);reject(name,lambda p=p:validate(source,p,word,names,tol))
    reject('different requested output',lambda:validate(source,good,['s'],names,tol))
    reject('fast but inaccurate substituted for protected',lambda:validate(source,choose(source,word,['Fast'],[1,10]),word,names,tol))
    reject('unestablished narrow tolerance',lambda:validate(source,choose(source,word,names,[1,1000]),word,names,[1,1000]))
    fake=deepcopy(source);fake['offers']['Fast']['rate']=[0,1]
    reject('zero error inserted beside an unchanged source hash',lambda:choose(fake,word,names,tol))
    fake=deepcopy(source);fake['modules']['JointKeep']['A']=[]
    reject('actual module deleted under an unchanged model name',lambda:choose(fake,word,names,tol))
    moving=choose(source,word,['Moving'],[0,1]);moving['environment_S_power']=0
    reject('moving memory falsely advertised as unchanged',lambda:validate(source,moving,word,['Moving'],[0,1]))
    fake_history=deepcopy(good);fake_history['scope']='only_a_diamond_distance'
    reject('generic error bound substituted for mixture history',lambda:choose(source,word,names,tol,history=[fake_history]))
    # Full D,E reference Choi, retained across repeated physical maps. No
    # new preparation of D or E, and no realized memory state in the chooser.
    actual=np.eye(16,dtype=complex);ideal=np.eye(16,dtype=complex);previous=Fraction(0);log=[];history=[]
    for i in range(3):
        p=choose(source,word,names,[1,100],history=history,total_tolerance=[1,50])
        if i==2:assert p['kind']=='needs_relation';break
        assert p['offer']=='Protected';validate(source,p,word,names,[1,100],history=history,total_tolerance=[1,50])
        history.append(p)
        actual=channel(p['execution'],fraction(source['offers'][p['offer']]['rate']))@actual
        ideal=unitary(np.kron(H,I))@ideal;previous=fraction(p['accumulated_bound'])
        witness=trace_distance(Choi(SuperOp(actual)).data/4,Choi(SuperOp(ideal)).data/4)
        assert witness<=float(previous)+1e-11
        log.append({'step':i+1,'offer':p['offer'],'composed_bound':pair(previous),'Choi_lower_witness':witness})
    # Generic diamond bounds do not admit the product improvement: two
    # coherent rotations with individual distance 1/2 have distance sqrt(3)/2.
    alpha=np.pi/6;v=np.diag(np.exp(1j*np.array([alpha,-alpha])))
    c0=Choi(SuperOp(unitary(I))).data/2
    single=trace_distance(Choi(SuperOp(unitary(v))).data/2,c0)
    double=trace_distance(Choi(SuperOp(unitary(v@v))).data/2,c0)
    assert abs(single-.5)<1e-12 and double>1-(1-single)**2+.1
    return {'rejected':rejected,'stream':log,'third_task':'needs_relation; no contact executed',
            'generic_bound_counterexample':{'single':single,'two_composed':double,'false_product_bound':1-(1-single)**2},
            'scope':'Prior mixture weight is reconstructed from the supplied admitted history. The caller must supply the actual history; this helper does not replace the persistent Environment journal.'}


def main(directory):
    source=json.loads((directory/'source-reading.json').read_text())
    build=json.loads((directory/'build.json').read_text())
    for n,h in build['artifact_sha256'].items():assert digest(directory/n)==h
    for n,h in build['implementation_sha256'].items():assert digest(ROOT/n)==h
    result={'channels':check_channels(source),'memory':memory_witness(source),'admission':refusals_and_stream(source),
            'auditor_sha256':digest(Path(__file__)),'hardware':False}
    write(directory/'audit.json',result);return result


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--input',required=True,type=Path)
    print(json.dumps(main(p.parse_args().input.resolve()),indent=2))
