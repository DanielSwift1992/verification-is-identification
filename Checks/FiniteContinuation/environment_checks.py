#!/usr/bin/env python3
"""Independent semantics and whole-life executions of the local environment.

Only this fixture knows the actual A/B. It carries one two-qubit state through
the complete task stream; acquisition uses fresh separate preparations.
"""
import argparse
from copy import deepcopy
from itertools import product
import hashlib
import json
from pathlib import Path
import random
import tempfile
import uuid

import numpy as np
from qiskit import QuantumCircuit
from qiskit.quantum_info import Operator, Pauli

from environment import Environment, ROOT, HERE, load, rows, to_mask, instructions, write
from build_from_source import run

P = {a:Pauli(a).to_matrix() for a in 'IXYZ'}


def operator(gates):
    c = QuantumCircuit(1)
    for gate in gates:
        if gate[0] == 'rz':
            c.rz(gate[1],0)
        else:
            getattr(c,gate[0])(0)
    return Operator(c).data


def same(a,b):
    return np.allclose(np.kron(a,a.conj()),np.kron(b,b.conj()),atol=1e-10,rtol=0)


def requested_operator(request):
    # Independent caller meaning. Do not let emitted target instructions
    # choose what the audit will consider a successful answer.
    c=QuantumCircuit(1)
    if request['kind']=='phase':
        c.rz(request['theta'],0)
        if request['t']:c.x(0)
    else:
        for g in request['middle']:getattr(c,g)(0)
    return Operator(c).data


def classify(matrix):
    values = [a for a,p in P.items() if same(matrix,p)]
    assert len(values) == 1
    return values[0]


def actual_bit(world, contact):
    a,b = [P[s] for s in world]
    v = b@operator([[g] for g in contact['middle']])@a
    rho = (P['I']+P[contact['prep']])/2
    e = float(np.trace(P[contact['read']]@v@rho@v.conj().T).real)
    assert np.isclose(abs(e),1,rtol=0,atol=1e-10)
    return int(e < 0)  # raw measurement; NOT divided by the ideal sign


def semantic_audit(reading,bundle):
    contacts = {p['id']:p for p in reading['probes']}
    for p in contacts.values():
        assert [actual_bit(w,p) for w in reading['worlds']] == p['replies']
    edge_count = 0
    for e in reading['edges']:
        old = reading['worlds'][e['before']]
        new = [classify(P[d]@P[a]) for a,d in zip(old,e['delta'])]
        assert new == reading['worlds'][e['after']]
        edge_count += 1
    task_answers = {}
    channels = 0
    for task in reading['tasks']:
        if task['id'] == 'phase':
            answers=[]
            for w in reading['worlds']:
                a,b=[P[s] for s in w]
                sign=lambda v,p:int(np.trace(p@v@p@v.conj().T).real < 0)
                key=[sign(b@a,P['X']),sign(b@a,P['Z']),sign(a,P['Z'])]
                answers.append('key:'+''.join(map(str,key)))
            requests=[{'kind':'phase','theta':float(angle),'t':t} for t,angle in
                      product((0,1),(.137,np.sqrt(2),-np.pi/4,np.pi,0.0))]
        else:
            u=operator([[g] for g in task['middle']])
            answers=['pauli:'+classify(P[b]@u@P[a]@u.conj().T) for a,b in reading['worlds']]
            requests=[{'kind':'clifford','middle':task['middle']}]
        assert answers == task['answers']
        task_answers[task['id']] = answers
        for request in requests:
            for i,(a,b) in enumerate(reading['worlds']):
                native=instructions(bundle,request,answers[i])
                target,correction=requested_operator(request),operator(native['correction'])
                assert same(operator(native['target']),target)
                assert same(correction@P[b]@operator(native['target'])@P[a],target)
                channels += 1
    # Exhaust all current source members, not just one successful transcript.
    executions=0
    for task_id,request in bundle['requests'].items():
        policy=bundle['policies'][request['class']]
        answers=task_answers[task_id]
        for state in bundle['states']:
            depths=[]
            for world in rows(state):
                current=state;depth=0
                while policy[str(current)]['kind']=='probe':
                    node=policy[str(current)]
                    bit=contacts[node['probe']]['replies'][world]
                    current=node['next'][bit];depth+=1
                    assert depth <= 4 and world in rows(current)
                assert policy[str(current)]['action']==answers[world]
                depths.append(depth);executions+=1
            assert max(depths)==policy[str(state)]['depth']
    return {'independent_probe_entries':len(contacts)*16,'independent_transition_edges':edge_count,
            'native_recovery_channels':channels,'all_source_task_continuations':executions}


def macro_obstruction(reading,bundle):
    """Sanity checks of a separately proved all-word covariance statement."""
    z=P['Z'];h=operator([['h']]);primitive_checks=0;words_checked=0
    monomials=[requested_operator({'kind':'phase','theta':float(a),'t':t})
               for t,a in product((0,1),(0,.137,-np.sqrt(2),np.pi/2,np.pi))]
    middle=[operator([[g] for g in t['middle']]) for t in reading['tasks'][1:]]
    phase=reading['tasks'][0]['answers'];rng=random.Random(190733)
    for key in sorted(set(phase)):
        i,j=[i for i,k in enumerate(phase) if k==key]
        a,b=[P[s] for s in reading['worlds'][i]]
        aa,bb=[P[s] for s in reading['worlds'][j]]
        assert same(aa,z@a) and same(bb,b@z)
        slots=[(b@c@a,bb@c@aa) for c in middle]
        controls=[(g,g) for g in monomials]
        for first,second in slots+controls:
            assert same(second,z@first@z);primitive_checks+=1
        for _ in range(32):
            first=second=P['I']
            for _ in range(rng.randrange(1,21)):
                v,w=rng.choice(slots+controls)
                first=v@first;second=w@second
            assert same(second,z@first@z)
            assert not (same(first,h) and same(second,h))
            words_checked+=1
        family=to_mask([i,j]);hc=bundle['requests']['clifford:h']['class']
        assert bundle['policies'][hc][str(family)]['depth']==1
        # Scope-changing positive counterexample: a free external H after a
        # neutral pass makes the extra bit unnecessary. That H is not an
        # available external control in the obstruction's interface.
        m=b@a;assert same(bb@aa,m)
        assert same(h@m.conj().T@(b@a),h)
        assert same(h@m.conj().T@(bb@aa),h)
    return {'primitive_covariances':primitive_checks,'sample_fixed_macros':words_checked,
            'old_key_fibers_requiring_one_H_probe':8,'external_H_bypass_examples':8,
            'proof_scope':'Arbitrary fixed words follow by covariance induction, not by this finite sample. '
                          'Outside controls are monomial; no intermediate measurement, ancillary processing, '
                          'or free external H is assumed.'}


class Port:
    def __init__(self, world, seed=0):
        self.world=list(world)
        self.resident='local-'+uuid.uuid4().hex
        rng=np.random.default_rng(seed)
        self.state=rng.normal(size=4)+1j*rng.normal(size=4)
        self.state/=np.linalg.norm(self.state)
        self.expected=self.state.copy()
        self.probes=0;self.applications=0;self.max_error=0.0
        self.target=None

    def expect(self,request):
        self.target=requested_operator(request)

    def probe(self, descriptor, token, epoch):
        self.probes+=1
        return {'token':token,'epoch':epoch,'resident':self.resident,'contact':descriptor['id'],'bit':actual_bit(self.world,descriptor)}

    def apply(self, native, token, epoch):
        a,b=[P[s] for s in self.world]
        u,d=operator(native['target']),operator(native['correction'])
        assert self.target is not None and same(u,self.target)
        self.state=np.kron(d@b@u@a,P['I'])@self.state
        self.expected=np.kron(self.target,P['I'])@self.expected
        actual=np.outer(self.state,self.state.conj())
        expected=np.outer(self.expected,self.expected.conj())
        error=float(np.max(np.abs(actual-expected)))
        self.max_error=max(error,self.max_error)
        assert error<1e-10
        self.applications+=1
        self.target=None
        return {'token':token,'epoch':epoch,'resident':self.resident,'applied':True}

    def change(self,delta):
        self.world=[classify(P[d]@P[a]) for a,d in zip(self.world,delta)]


def lifecycle(directory,reading,bundle,output):
    logs=[];total_probes=0;total_tasks=0;max_error=0
    phase=lambda theta,t=0:{'kind':'phase','theta':float(theta),'t':t}
    h={'kind':'clifford','middle':['h']}
    # This scenario is not supplied to the compiler. In particular the next
    # H request is unknown while the phase policy is selected.
    for i,world in enumerate(reading['worlds']):
        with tempfile.TemporaryDirectory(prefix='vi-life-') as tmp:
            journal=Path(tmp)/'journal.json';env=Environment(directory,journal);port=Port(world,i)
            events=[]
            def task(request,expected=None):
                nonlocal env
                port.expect(request)
                r=env.perform(request,port)
                if expected is not None:assert r['probes']==expected,(world,r,expected)
                events.append({'request':request,'result':r,'retained_mask':env.state})
                # Restart from acquired events, not a serialized selected mask.
                old=env.state;env=Environment(directory,journal);assert env.state==old
                return r
            def change(profile,delta):
                port.change(delta);env.change(profile)
                events.append({'change':profile,'retained_mask':env.state})
            task(phase(.137),3)
            task(phase(-np.sqrt(2),1),0)
            task(h,1)
            assert env.state.bit_count()==1
            change('known_A_X',['X','I'])
            task(phase(.719,1),0)
            task(h,0)
            change('A_only',[['I','X','Y','Z'][i%4],'I'])
            task(phase(-.231),2)
            assert env.state.bit_count()==1
            task(h,0)  # a key-only memory would need one more contact here
            change('paired_Z',['Z','Z'])
            task(phase(2.13,1),0)
            task(h,1)
            change('arbitrary',[['I','X','Y','Z'][i%4],['I','X','Y','Z'][(i+1)%4]])
            task(phase(.981),3)
            task(h,1)
            assert port.applications==11 and port.probes==11
            cold=sum(env.node(65535,e['request'])['depth'] for e in events if 'request' in e)
            assert cold==28
            total_probes+=port.probes;total_tasks+=port.applications;max_error=max(max_error,port.max_error)
            logs.append({'initial_fixture_index':i,'events':events,'probes':port.probes,
                         'applications':port.applications,'cold_start_probes':cold,'live_state_max_error':port.max_error})
            if i==0:
                write(output/'example-journal.json',json.loads(journal.read_text()))
    # Holdout tasks, repeated profile changes, and fresh angles are generated
    # AFTER compilation. None changes the exact declared primitive model.
    holdout=[]
    rng=random.Random(918207)
    for i,world in enumerate(reading['worlds']):
        with tempfile.TemporaryDirectory(prefix='vi-stream-') as tmp:
            journal=Path(tmp)/'journal.json';env=Environment(directory,journal);port=Port(world,100+i)
            for step in range(40):
                if step and rng.random()<.5:
                    profile=rng.choice(list(reading['profiles']))
                    delta=rng.choice(reading['profiles'][profile])
                    port.change(delta);env.change(profile)
                if rng.random()<.45:
                    request=phase(rng.uniform(-4,4),rng.randrange(2))
                else:
                    task_spec=rng.choice(reading['tasks'][1:])
                    request={'kind':'clifford','middle':task_spec['middle']}
                port.expect(request);env.perform(request,port)
                actual_index=reading['worlds'].index(port.world)
                assert actual_index in rows(env.state)
                if step%7==0:env=Environment(directory,journal)
            holdout.append({'initial_fixture_index':i,'tasks':port.applications,'probes':port.probes,
                            'live_state_max_error':port.max_error})
    write(output/'lifecycle.json',{'structured':logs,'holdout':holdout})
    # The SAME delivered key does not determine the price of the next task.
    after_A_refresh=logs[0]['events'][7]
    assert after_A_refresh['request']['kind']=='phase'
    state=after_A_refresh['retained_mask'];key=after_A_refresh['result']['action']
    compressed=to_mask(i for i,a in enumerate(reading['tasks'][0]['answers']) if a==key)
    hclass=bundle['requests']['clifford:h']['class']
    assert state.bit_count()==1 and compressed.bit_count()==2
    assert bundle['policies'][hclass][str(state)]['depth']==0
    assert bundle['policies'][hclass][str(compressed)]['depth']==1
    write(output/'memory-witness.json',{'same_delivered_phase_key':key,
          'actually_retained_sources':[reading['worlds'][i] for i in rows(state)],
          'sources_if_only_the_key_were_kept':[reading['worlds'][i] for i in rows(compressed)],
          'next_request':h,'retained_family_probe_cost':0,'key_only_probe_cost':1,
          'public_history_prefix':logs[0]['events'][:8]})
    return {'structured_tasks':total_tasks,'structured_probes':total_probes,
            'structured_tasks_per_source':11,'structured_probes_per_source':11,
            'cold_start_probes_per_same_task_stream':28,
            'holdout_tasks':sum(r['tasks'] for r in holdout),'holdout_probes':sum(r['probes'] for r in holdout),
            'max_live_state_error':max([max_error]+[r['live_state_max_error'] for r in holdout])}


def refusals(directory,reading,bundle):
    tested=[]
    def rejects(name,call):
        try:call()
        except (ValueError,KeyError,AssertionError):tested.append(name)
        else:raise AssertionError('Accepted '+name)
    with tempfile.TemporaryDirectory(prefix='vi-refusal-') as tmp:
        tmp=Path(tmp)
        env=Environment(directory,tmp/'budget.json');port=Port(['I','I'])
        request={'kind':'phase','theta':.73,'t':0}
        port.expect(request)
        result=env.perform(request,port,budget=1)
        assert result['kind']=='needs_evidence' and port.applications==0 and env.state.bit_count()==8
        env=Environment(directory,tmp/'budget.json')
        result=env.perform(request,port,budget=3)
        assert result['kind']=='applied' and port.probes==3
        rejects('unsupported request',lambda:env.perform({'kind':'reset-payload'},port))
        rejects('nonfinite phase',lambda:env.perform({'kind':'phase','theta':float('nan'),'t':0},port))
        rejects('undeclared change',lambda:env.change('anything'))
        rejects('same journal attached to another source handle',lambda:env.perform(request,Port(['I','I'])))
        forged=deepcopy(env.events)
        receipt=next(e for e in forged if e['kind']=='receipt' and 'bit' in e)
        receipt['contact']='A:Z:Z'
        rejects('other acquisition contact',lambda:env.replay(forged))
        forged=deepcopy(env.events)
        next(e for e in forged if e['kind']=='receipt')['epoch']+=1
        rejects('mixed software epochs',lambda:env.replay(forged))
        forged=deepcopy(env.events)
        next(e for e in forged if e['kind']=='receipt')['resident']='another-resident'
        rejects('foreign resident receipt',lambda:env.replay(forged))
        forged=deepcopy(env.events)
        next(e for e in forged if e['kind']=='pending' and e['operation']=='payload')['action']='key:111'
        rejects('substituted continuation',lambda:env.replay(forged))
        forged=deepcopy(env.events)
        j=next(i for i,e in enumerate(forged) if e['kind']=='receipt')
        forged.insert(j+1,deepcopy(forged[j]))
        rejects('duplicate receipt',lambda:env.replay(forged))
        class WrongPort(Port):
            def probe(self,descriptor,token,epoch):
                return {'token':token,'epoch':epoch,'resident':self.resident,'contact':descriptor['id'],'bit':2}
        env=Environment(directory,tmp/'uncertain.json')
        rejects('nonbinary result',lambda:env.perform(request,WrongPort(['I','I'])))
        env=Environment(directory,tmp/'uncertain.json')
        safe=Port(['I','I'])
        rejects('replay after uncertain port outcome',lambda:env.perform(request,safe))
        assert safe.probes==safe.applications==0
        wrong_target=Port(['I','I']);wrong_target.expect(request)
        rejects('self-consistent but wrong target program',lambda:wrong_target.apply({'target':[['h']],'correction':[]},'test',0))
        # Literal whole-fiber status cannot replace a trace of acquisitions.
        rejects('injected selected-family event',lambda:env.replay([{'kind':'state','mask':1}]))
    return {'rejected':tested,'budget_resume_preserved_all_knowledge':True}


def main(directory,output):
    if output.exists():raise ValueError('Use a new audit directory')
    output.mkdir(parents=True)
    bundle,_=load(directory)
    reading=json.loads((directory/'source-reading.json').read_text())
    result={'semantics':semantic_audit(reading,bundle),
            'macro_obstruction':macro_obstruction(reading,bundle),
            'lifecycle':lifecycle(directory,reading,bundle,output),
            'refusals':refusals(directory,reading,bundle),
            'controller_sha256':hashlib.sha256((directory/'controller.json').read_bytes()).hexdigest(),
            'auditor_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
            'limits':'Ideal local two-Pauli model; no QPU and no validation of unknown drift or noise.'}
    write(output/'result.json',result)
    return result


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--input',required=True,type=Path);p.add_argument('--output',required=True,type=Path)
    a=p.parse_args();print(json.dumps(main(a.input.resolve(),a.output.resolve()),indent=2))
