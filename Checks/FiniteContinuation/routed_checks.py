#!/usr/bin/env python3
"""Independent matrices, source-identity failures, and continuing execution."""
import argparse
from collections import Counter
from copy import deepcopy
import hashlib
import json
from pathlib import Path
import tempfile
import uuid

import numpy as np
from environment import rows,write,load
from environment_checks import P,Port,operator,same,requested_operator
from routed import RoutedEnvironment,words
from build_from_source import ROOT,HERE,run


def route_operator(program,goals,world,separate=None,drift=None):
    a,b=world;out=P['I']
    for index,op in enumerate(program):
        if drift and index==drift[0]:a,b=drift[1]
        if op['kind']=='A':g=P[separate or a]
        elif op['kind']=='slot':
            middle=op.get('middle',goals[op['goal']]['word'] if 'goal' in op else None)
            g=P[b]@operator([[g] for g in middle])@P[a]
        else:g=P[op['value']]
        out=g@out
    return out


class RoutedPort(Port):
    def __init__(self,*args,**kwargs):
        super().__init__(*args,**kwargs)
        self.first_handle='A-'+uuid.uuid4().hex
        self.separate_handle=self.first_handle
        self.wrong_separate=None;self.drift=None
        self.data_A=0;self.data_F=0

    def reentry_binding(self):
        return {'resident':self.resident,'slot_first':self.first_handle,'separate_first':self.separate_handle}

    def apply(self,native,token,epoch):
        if 'route' not in native:
            self.data_F+=1
            return super().apply(native,token,epoch)
        assert self.target is not None
        u=route_operator(native['route'],[],self.world,self.wrong_separate,self.drift)
        self.state=np.kron(u,P['I'])@self.state
        self.expected=np.kron(self.target,P['I'])@self.expected
        error=float(np.max(np.abs(np.outer(self.state,self.state.conj())-np.outer(self.expected,self.expected.conj()))))
        self.max_error=max(self.max_error,error)
        assert error<1e-10,'The actual route fails the independently fixed target'
        self.data_A+=sum(op['kind']=='A' for op in native['route'])
        self.data_F+=sum(op['kind']=='slot' for op in native['route'])
        self.applications+=1;self.target=None
        return {'token':token,'epoch':epoch,'resident':self.resident,'applied':True}


def mathematical_checks(reading,actions):
    ops=[operator([[g] for g in c['word']]) for c in reading['goals']]
    transition_checks=0
    for gate,table in reading['transitions'].items():
        op=operator([[gate.lower()]]) if gate in ('H','S') else P[gate]
        for i,j in enumerate(table):assert same(op@ops[i],ops[j]);transition_checks+=1
    for i,(a,b) in enumerate(reading['worlds']):
        assert same(P[a],ops[reading['separate'][i]])
        for c in range(24):assert same(P[b]@ops[c]@P[a],ops[reading['slots'][c][i]])
    programs=0;negative_rows=0
    for action in actions.values():
        support=0
        for i,world in enumerate(reading['worlds']):
            actual=route_operator(action['program'],reading['goals'],world)
            if same(actual,ops[action['goal']]):support|=1<<i
            else:negative_rows+=1
            programs+=1
        assert support==action['support']
    all_words,search=words(reading)
    neutral_improvements=[];phase_minima=[];blind=[]
    h=next(g['id'] for g in reading['goals'] if g['word']==['h'])
    for key in sorted({tuple(k) for k in reading['keys']}):
        family=sum(1<<i for i,k in enumerate(reading['keys']) if tuple(k)==key)
        for g in reading['goals']:
            available=[r for r in all_words.values() if r['goal']==g['id'] and family&~r['support']==0]
            preserves_z=same(ops[g['id']]@P['Z']@ops[g['id']].conj().T,P['Z'])
            if not preserves_z:
                assert any(r['resources']['A']==1 and r['resources']['F']==2 for r in available)
                assert not any(r['resources']['A']==0 for r in available)
                assert not any(r['resources']['A']==1 and r['resources']['F']==1 for r in available)
                phase_minima.append({'key':key,'goal':g['id'],'A_minimum':1,'F_minimum_at_one_A':2})
    for neutral in sorted({tuple(k[:2]) for k in reading['keys']}):
        family=sum(1<<i for i,k in enumerate(reading['keys']) if tuple(k[:2])==neutral)
        goals=[]
        for g in reading['goals']:
            candidates=[r for r in all_words.values() if r['goal']==g['id'] and r['resources']['A']==1 and r['resources']['F']==2 and family&~r['support']==0]
            # A fixed-point-free permutation of the three Pauli AXES is a
            # three-cycle. Ignore its signs only for this axis classification.
            fixed=sum(same(ops[g['id']]@P[axis]@ops[g['id']].conj().T,P[axis]) for axis in 'XYZ')
            assert bool(candidates)==(fixed==0)
            if candidates:
                route=min(candidates,key=lambda r:r['resources']['known_gates'])
                goals.append({'goal':g['id'],'word':g['word'],'program':route['program']})
                # Direct algebraic construction with L=R=U²; physical order
                # G_R, A, G_L. It needs N, but never the remaining u or v.
                u=ops[g['id']];l=u@u
                for i in rows(family):
                    a,b=[P[s] for s in reading['worlds'][i]];n=b@a
                    gl=n.conj().T@b@l@a
                    assert same(gl@a@gl,u)
        assert len(goals)==8 and h not in [g['goal'] for g in goals]
        neutral_improvements.append({'neutral_key':neutral,'remaining_sources':len(rows(family)),'goals':goals})
    for g in reading['goals']:
        candidates=[r for r in all_words.values() if r['goal']==g['id'] and r['support']==65535]
        # Pareto reduction legitimately removes the exact 2A/2F word when
        # this target admits a cheaper one. Check the bound in the retained
        # frontier and the explicit, universal construction separately.
        assert any(r['resources']['A']<=2 and r['resources']['F']<=2 for r in candidates)
        universal=[{'kind':'A'}, {'kind':'slot','goal':g['id']},
                   {'kind':'slot','goal':0}, {'kind':'A'}]
        for world in reading['worlds']:
            assert same(route_operator(universal,reading['goals'],world),ops[g['id']])
        blind.append({'goal':g['id'],'A':2,'F':2})
    return {'generator_compositions':transition_checks,'actual_route_source_pairs':programs,
            'outside_support_rows_really_fail':negative_rows,'phase_minimum_cases':len(phase_minima),
            'blind_all_source_routes':len(blind),'neutral_improvements':neutral_improvements,
            'search_cross_check':search}


def life(base_dir,extension,reading,output):
    summary=[];logs=[]
    phase={'kind':'phase','theta':.173,'t':0};h={'kind':'clifford','middle':['h']}
    for price in ('acquire','one_A','two_A','old_access'):
        a_count=f_count=probe_count=0
        for i,world in enumerate(reading['worlds']):
            with tempfile.TemporaryDirectory(prefix='vi-route-life-') as tmp:
                journal=Path(tmp)/'record.json';env=RoutedEnvironment(base_dir,extension,journal,price);port=RoutedPort(world,i)
                port.expect(phase);env.perform(phase,port)
                before=env.state;before_counts=(port.probes,port.data_A,port.data_F)
                port.expect(h);result=env.perform(h,port)
                resources=(port.probes-before_counts[0],port.data_A-before_counts[1],port.data_F-before_counts[2])
                expected={'acquire':(1,0,1),'old_access':(1,0,1),'one_A':(0,1,2),'two_A':(0,2,1)}[price]
                assert resources==expected,(price,world,resources)
                if price in ('one_A','two_A'):assert env.state==before and env.state.bit_count()==2
                else:assert env.state.bit_count()==1
                a_count+=resources[1];f_count+=resources[2];probe_count+=resources[0]
                saved=env.state;env=RoutedEnvironment(base_dir,extension,journal,price);assert env.state==saved
                port.expect(h);second=env.perform(h,port)
                if price in ('one_A','two_A'):assert env.state==before and second['probes']==0
                else:assert second['probes']==0
                # Known changes transport the whole family, then every goal
                # is served without changing what the consumer requested.
                port.change(['X','I']);env.change('known_A_X')
                for goal in reading['goals']:
                    request={'kind':'clifford','middle':goal['word']}
                    port.expect(request);env.perform(request,port)
                    assert reading['worlds'].index(port.world) in rows(env.state)
                logs.append({'price':price,'initial_source_index':i,'first_H':result,
                             'first_H_resources':resources,'retained_before':before,'retained_after':saved,
                             'tasks':port.applications,'maximum_state_error':port.max_error})
        summary.append({'price':price,'sources':16,'first_H_total_probes':probe_count,'first_H_total_data_A':a_count,'first_H_total_data_F':f_count})
    # Expensive observations: work can begin from the full, uncalibrated family.
    with tempfile.TemporaryDirectory(prefix='vi-route-blind-') as tmp:
        env=RoutedEnvironment(base_dir,extension,Path(tmp)/'record.json','one_A');port=RoutedPort(['Y','X'])
        port.expect(h);result=env.perform(h,port)
        assert result['probes']==0 and env.state==65535 and port.data_A==2 and port.data_F==2
        blind={'result':result,'resources':{'A':port.data_A,'F':port.data_F},'remaining_sources':16}
    write(output/'lifecycle.json',logs)
    return {'prices':summary,'tasks':sum(r['tasks'] for r in logs),'uncalibrated_start':blind,
            'maximum_state_error':max(r['maximum_state_error'] for r in logs)}


def failure_checks(base_dir,extension,reading,actions,output):
    rejected=[];h={'kind':'clifford','middle':['h']};phase={'kind':'phase','theta':.73,'t':0}
    def fail(name,fn):
        try:fn()
        except (AssertionError,ValueError,KeyError,AttributeError):rejected.append(name)
        else:raise AssertionError('Accepted '+name)
    with tempfile.TemporaryDirectory(prefix='vi-route-negative-') as tmp:
        journal=Path(tmp)/'record.json';env=RoutedEnvironment(base_dir,extension,journal,'one_A');port=RoutedPort(['I','I'])
        port.expect(phase);env.perform(phase,port)
        port.separate_handle='another-module'
        fail('missing same-A binding before any payload contact',lambda:env.perform(h,port))
        assert port.data_A==0 and port.applications==1
        port.separate_handle=port.first_handle;port.wrong_separate='X';port.expect(h)
        # A lying adapter with the same LABEL is not detected by its label.
        # Its actual channel fails the independent semantic audit and leaves
        # an unresolved operation, rather than receiving a successful receipt.
        fail('different actual A despite the old label: channel counterexample',lambda:env.perform(h,port))
        env=RoutedEnvironment(base_dir,extension,journal,'one_A')
        fail('no automatic repeat after a partially executed failing word',lambda:env.perform(h,port))
        fail('reuse of a journal under a different resource policy',lambda:RoutedEnvironment(base_dir,extension,journal,'acquire'))
    # Exhibit a same-name source change inside a previously valid word.
    goal=next(g['id'] for g in reading['goals'] if g['word']==['h'])
    keymask=sum(1<<i for i,k in enumerate(reading['keys']) if k==[0,0,0])
    candidate=next(r for r in actions.values() if r['goal']==goal and r['resources']['A']==1 and keymask&~r['support']==0)
    target=requested_operator(h);witness=None
    for index in range(1,len(candidate['program'])):
        for world in reading['worlds']:
            changed=route_operator(candidate['program'],reading['goals'],['I','I'],drift=(index,world))
            if not same(changed,target):witness={'change_before_atom':index,'old':['I','I'],'new':world,'program':candidate['program']};break
        if witness:break
    assert witness
    write(output/'within-word-change.json',witness)
    return {'rejected':rejected,'unannounced_change_counterexample':True,
            'warning':'Software labels do not establish hidden physical source identity; the incorrect adapter is a counterexample, not automatically diagnosed hardware.'}


def main(base_dir,extension,output):
    if output.exists():raise ValueError('Use a new output directory')
    output.mkdir(parents=True)
    reading=json.loads((extension/'source-reading.json').read_text());actions=json.loads((extension/'routes.json').read_text())['actions']
    result={'mathematics':mathematical_checks(reading,actions),'execution':life(base_dir,extension,reading,output),
            'failures':failure_checks(base_dir,extension,reading,actions,output),
            'auditor_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest()}
    write(output/'result.json',result)
    return result


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--base',required=True,type=Path);p.add_argument('--input',required=True,type=Path);p.add_argument('--output',required=True,type=Path)
    a=p.parse_args();r=main(a.base.resolve(),a.input.resolve(),a.output.resolve())
    print(json.dumps({'mathematics':{k:v for k,v in r['mathematics'].items() if k!='neutral_improvements'},'execution':r['execution'],'failures':r['failures']},indent=2))
