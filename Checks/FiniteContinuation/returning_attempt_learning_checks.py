#!/usr/bin/env python3
"""Bounded exact audit of returning attempts, acquisition, and no-learning echo."""
from copy import deepcopy
from itertools import product
import json
import subprocess
import time

import returning_attempt_learning as r


def main():
    started = time.monotonic()
    court = json.loads(subprocess.run(['node',str(r.ROOT/'Checks/FiniteContinuation/returning_attempt_court.js'),'check'],
                                     capture_output=True,text=True,check=True,timeout=30).stdout)
    source = court['source']
    plan = r.synthesize(source)
    assert r.verify(source, plan) == 2
    admissions = {p:r.admission(p) for p in r.EPISODES}
    assert admissions['B']['admitted'] and admissions['Parity']['admitted']
    assert not admissions['DirectDestructive']['data_preserved']
    assert not admissions['BWithoutReturn']['contact_restored']

    # All safe one-query partitions still contain two different controls,
    # on EVERY reachable branch. Two queries are necessary for a one-call use.
    for p in ('B', 'Parity', 'Residue'):
        for group in r.successors(source, range(8), p).values():
            assert {source['rows'][i]['Control'] for i in group} == {0, 1}
    assert r.synthesize(source, reserve=1)['tree'] is None
    assert r.synthesize(source, catalogue=('DirectDestructive',))['tree'] is None

    # A proof can fail while every fully informed single world has a solution.
    assert all(r.synthesize(source, support=[i], reserve=0)['tree']['rank'] == 0 for i in range(8))
    assert r.synthesize(source, reserve=0, catalogue=())['tree'] is None

    rejections = []
    def no(name, f):
        try: f()
        except ValueError: rejections.append(name)
        else: raise AssertionError('Incorrect acceptance: '+name)

    c=deepcopy(plan);c['tree']['branches'].pop('1')
    no('deleted possible actual reply',lambda:r.verify(source,c))
    c=deepcopy(plan);c['tree']['rank']=1
    no('invented one-episode bound',lambda:r.verify(source,c))
    c=deepcopy(plan);c['tree']['probe']='BWithoutReturn'
    no('data restored but next contact missing',lambda:r.verify(source,c))
    c=deepcopy(plan);c['tree']['branches']['0']['branches']['0']['control']=1
    no('wrong acquired control',lambda:r.verify(source,c))
    c=deepcopy(plan);c['source']='another source'
    no('wrong source binding',lambda:r.verify(source,c))

    # The device, not the executor, receives the true index. Equality of the
    # actual operator proves action on arbitrary data and external reference.
    executions=[]
    for theta in range(8):
        port=r.LocalPort(source,theta)
        ability,knowledge=r.learn(source,port,plan)
        assert port.operator == r.I and port.reserve == 0 and port.mode == 'ready'
        assert len(knowledge.support) == 2
        assert {source['rows'][i]['Residue'] for i in knowledge.support} == {0,1}
        assert all(source['rows'][i]['Control']==ability.control for i in knowledge.support)
        ability.apply(port,r.X)
        assert port.operator == r.X
        port.new_payload()
        ability.apply(port,r.ROTATION)
        assert port.operator == r.ROTATION
        assert sum(e[0]=='probe' for e in port.events) == 2
        assert not any(e[0]=='probe' and e[1]=='Residue' for e in port.events)
        other=r.LocalPort(source,theta)
        no('another instance '+str(theta),lambda:ability.apply(other,r.X))
        executions.append({'row':theta,'acquisition_contacts':2,'return_commands':2,
                           'residue_candidates':len(knowledge.support),'later_tasks':2,'additional_probes':0})

    # Fair comparison of retaining vs discarding knowledge under the same
    # four-token initial reserve; both runs complete the same two data goals.
    costs={}
    for discard in (False,True):
        port=r.LocalPort(source,7,reserve=4)
        ability,knowledge=r.learn(source,port,r.synthesize(source,reserve=4))
        ability.apply(port,r.X);assert port.operator==r.X
        port.new_payload()
        if discard:
            ability,knowledge=r.learn(source,port,r.synthesize(source,reserve=2))
        ability.apply(port,r.ROTATION);assert port.operator==r.ROTATION
        costs['discard' if discard else 'retain']={
            'probes':sum(e[0]=='probe' for e in port.events),'remaining_reserve':port.reserve}
    assert costs == {'retain':{'probes':2,'remaining_reserve':2},'discard':{'probes':4,'remaining_reserve':0}}

    # Memory is a sufficient online update for actual keys, including repeats.
    histories=[(tuple(range(8)),())]
    comparisons=0
    for depth in range(3):
        following=[]
        for support,h in histories:
            for p in ('B','Parity','Residue'):
                for b,post in r.successors(source,support,p).items():
                    full=tuple(i for i,row in enumerate(source['rows'])
                               if all(row[r.EPISODES[q]['field']]==v for q,v in h+((p,b),)))
                    assert post == full
                    following.append((post,h+((p,b),)));comparisons+=1
        histories=following

    # Reply-zero imposture and incomplete physical return have distinct
    # consequences, even when a simple ready label looks correct.
    port=r.LocalPort(source,2)
    reply=port.probe('B')
    assert reply.value==1
    no('work before actual return',lambda:port.work(0,r.X))
    port.repair(reply,faulty_skip_correction=True)
    assert port.mode=='ready' and port.operator==r.Z and port.operator!=r.I
    no('same return consumed twice',lambda:port.repair(reply))
    port=r.LocalPort(source,0,reserve=0)
    no('new attempt with no return reserve',lambda:port.probe('B'))

    # A surviving indistinguishable pair is a proof for every word consisting
    # only of the remaining static query, not just an exhausted finite search.
    obstruction_pairs={}
    for probe in ('B','Parity'):
        pair=next((i,j) for i,j in product(range(8),repeat=2)
                  if source['rows'][i][r.EPISODES[probe]['field']]==source['rows'][j][r.EPISODES[probe]['field']]
                  and source['rows'][i]['Control']!=source['rows'][j]['Control'])
        obstruction_pairs[probe]=pair
        assert r.synthesize(source,catalogue=(probe,),reserve=5)['tree'] is None

    # Crucial alternative: two calls eliminate the unknown phase without any
    # acquisition. No-reserve acquisition failure is NOT global impossibility.
    for theta in range(8):
        for gate in (r.I,r.X,r.Z,r.ROTATION):
            port=r.LocalPort(source,theta,reserve=0)
            r.echo(port,gate)
            assert port.operator == gate
            assert len(port.events)==2 and all(e[0]=='work' for e in port.events)
    choices=[]
    for n in (1,2,4,5,8,11):
        strategy=r.choose_strategy(source,n)
        assert strategy['cost']==min(2*n,4+n)
        for theta in range(8):
            port=r.LocalPort(source,theta)
            gates=[r.X if j%2==0 else r.ROTATION for j in range(n)]
            outputs,ability,knowledge=r.execute_batch(source,port,strategy,gates)
            assert outputs==gates
            assert (ability is not None)==(n>4)
            if ability is not None:
                before=len(port.events)
                port.new_payload();ability.apply(port,r.Z);assert port.operator==r.Z
                assert not any(e[0]=='probe' for e in port.events[before:])
                # Exclude this explicitly additional, post-batch goal below.
                cost_events=port.events[:before]
            else:cost_events=port.events
            actual=sum(e[0] in ('probe','repair','work') for e in cost_events)
            assert actual==strategy['cost']
        choices.append({k:strategy[k] for k in ('task_count','kind','cost')})
    c=deepcopy(r.choose_strategy(source,5));c['tree']['cost']-=1
    no('batch price erased a real command',lambda:r.verify_batch(source,c))

    # Law stability is a declared part of the local source, not established by
    # retaining the same string/owner. An unannounced law change violates it.
    port=r.LocalPort(source,0)
    ability,_=r.learn(source,port,plan)
    port._row['Control']=1  # outside the admitted dynamics, audit only
    ability.apply(port,r.X)
    assert port.operator!=r.X

    return {'source':source,'court_equalities':court['equalities'],
            'court_expected_refusals':court['rejections'],
            'admissions':admissions,'minimum_safe_probes_for_one_call_ability':2,
            'available_residue_contact_was_not_used':True,
            'executions':executions,'retention_comparison':costs,
            'online_update_histories_checked':comparisons,'rejections':rejections,
            'one_call_obstruction_pairs':obstruction_pairs,
            'no_learning_echo_verified_rows_and_goals':32,'batch_choices':choices,
            'unannounced_law_change_not_detected_by_identity_metadata':True,
            'seconds':round(time.monotonic()-started,4),'new_QPU_jobs':0,
            'scope':'Exact constructed finite stationary law family; current Swift rows plus separate exact operator semantics. No empirical hardware law, universal optimality, or security claim.'}


if __name__=='__main__':
    print(json.dumps(main(),indent=2))
