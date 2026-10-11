#!/usr/bin/env python3
"""Offline independent SDK semantics, depth bounds and a finite benchmark.

No device credentials, IBM API, sampler, noise model or measured QPU data.
All exact claims concern the declared noiseless reusable-module family.
"""
import argparse
import copy
from functools import lru_cache
from itertools import combinations, product
import json
from pathlib import Path
import time

import numpy as np
from qiskit import QuantumCircuit
from qiskit.quantum_info import Operator, Pauli

import model
from planner import execute, synthesize

PAULIS = {a:Pauli(a).to_matrix() for a in 'IXYZ'}


@lru_cache(None)
def unitary(word):
    circuit = QuantumCircuit(1)
    for gate in word:
        getattr(circuit,gate)(0)
    return Operator(circuit).data


def same_channel(a,b):
    return np.allclose(abs(np.trace(a.conj().T @ b)),2,atol=1e-10,rtol=0)


def sdk_tables(p):
    """Reconstruct support independently of the model's Bloch arithmetic.

    Test ALL permitted corrections and frames, including combinations omitted
    by the producer. An empty row is therefore checked against the full menu.
    """
    u=unitary(tuple(p['connector']))
    cliffords={tuple(w):unitary(tuple(w)) for w in model.CLIFFORD.values()}
    assert len(cliffords)==24
    assert all(not same_channel(a,b) for a,b in combinations(cliffords.values(),2))
    assert all(any(same_channel(a@b,c) for c in cliffords.values())
               for a,b in product(cliffords.values(),repeat=2))
    frames={'bare':{():np.eye(2)},
            'pauli_frame':{tuple(w):unitary(tuple(w)) for w in model.PAULI_WORDS.values()},
            'clifford_frame':cliffords}.get(p['consumer'],{})
    rows=[]; replies={q['id']:[] for q in p['probes']}
    for aa,bb in p['worlds']:
        a,b=PAULIS[aa],PAULIS[bb]
        actual=b@u@a
        good=set()
        if p['consumer']=='terminal':
            target=u.conj().T@PAULIS[p['axis']]@u
            for read,sign in product('XYZ',(1,-1)):
                observed=actual.conj().T@(sign*PAULIS[read])@actual
                if np.allclose(observed,target,atol=1e-10,rtol=0):
                    good.add(f'read:{sign:+}:{read}')
        else:
            for cw,c in cliffords.items():
                for fw,f in frames.items():
                    if same_channel(c@actual,f@u):
                        good.add('correct:'+','.join(cw)+'|frame:'+','.join(fw))
        rows.append(frozenset(good))
        for probe in p['probes']:
            circuit={'A':a,'B':b,'neutral':b@a,'current':actual}[probe['path']]
            rho=(np.eye(2)+PAULIS[probe['prep']])/2
            mean=np.trace(PAULIS[probe['read']]@circuit@rho@circuit.conj().T).real
            assert np.isclose(abs(mean),1,atol=1e-10,rtol=0)
            replies[probe['id']].append(0 if mean>0 else 1)
    assert tuple(rows)==p['valid'], 'Producer and independent action semantics disagree'
    assert set.union(*(set(row) for row in rows))==set(p['actions'])
    # Keys are not certificates of the native instructions they name.
    for key,action in p['actions'].items():
        if action['kind']=='live':
            assert key=='correct:'+','.join(action['correction'])+'|frame:'+','.join(action['frame'])
            assert action['physical_gates']==len(action['correction'])
        else:
            assert action['kind']=='terminal'
            assert key==f'read:{action["sign"]:+}:{action["read"]}'
            assert action['physical_gates']==0
    for probe in p['probes']:
        assert tuple(replies[probe['id']])==probe['replies']
    return tuple(rows), replies


def common_action(rows,belief):
    return set.intersection(*(set(rows[i]) for i in belief))


def leaf_allowed(rows,belief):
    return bool(common_action(rows,belief)) or all(not rows[i] for i in belief)


def depth_bound(rows,replies,initial):
    """Separate Boolean bounded-tree search; no costs or synthesized plan."""
    @lru_cache(None)
    def possible(belief,depth):
        if leaf_allowed(rows,belief):
            return True
        if depth==0:
            return False
        for answers in replies.values():
            groups=[tuple(i for i in belief if answers[i]==r) for r in (0,1)]
            if all(groups) and all(possible(g,depth-1) for g in groups):
                return True
        return False
    for k in range(len(initial)+1):
        if possible(tuple(initial),k):
            return k
    return None


def fixed_bound(rows,replies,initial):
    for k in range(len(replies)+1):
        for names in combinations(replies,k):
            groups={}
            for i in initial:
                groups.setdefault(tuple(replies[n][i] for n in names),[]).append(i)
            if all(leaf_allowed(rows,g) for g in groups.values()):
                return k,list(names)
    return None,None


def fixed_resource_bound(rows,probes,initial,k):
    """Small separate enumeration of uses among minimum-depth fixed designs."""
    best=None
    for chosen in combinations(probes,k):
        groups={}
        for i in initial:
            groups.setdefault(tuple(p['replies'][i] for p in chosen),[]).append(i)
        if all(leaf_allowed(rows,g) for g in groups.values()):
            cost=sum(p['module_uses'] for p in chosen)
            if best is None or cost<best:
                best=cost
    return best


def audit_tree(plan,rows,replies):
    def visit(node,belief):
        assert belief
        if node['kind']=='act':
            assert all(node['action'] in rows[i] for i in belief), 'Invalid continuation'
        elif node['kind']=='unavailable':
            assert all(not rows[i] for i in belief), 'False impossibility'
        elif node['kind']=='insufficient':
            assert depth_bound(rows,replies,belief) is None
        else:
            assert node['kind']=='probe' and node['probe'] in replies
            answers=replies[node['probe']]
            groups={str(r):tuple(i for i in belief if answers[i]==r) for r in (0,1)}
            groups={k:g for k,g in groups.items() if g}
            assert set(node['branches'])==set(groups), 'Missing or invented reachable branch'
            for r,g in groups.items():
                visit(node['branches'][r],g)
    visit(plan['tree'],tuple(plan['initial']))


def audit_program(program,expected_request):
    """Bind an exported program to the caller's fixed public question.

    Recheck actual native instruction fields and the entire initial family.
    A program cannot narrow its family to the secret source or substitute its
    own easier output question and then self-certify against that substitution.
    """
    assert program['schema']=='vi.finite-continuation.program.v1'
    assert program['request']==expected_request, 'Substituted caller question'
    r=expected_request
    p=model.problem(tuple(r['connector']),r['consumer'],r['axis'])
    initial=(tuple(range(16)) if r['old_neutral_XZ_record'] is None else
             model.compatible_with_old_memory(r['old_neutral_XZ_record']))
    assert tuple(program['plan']['initial'])==initial, 'Narrowed source family'
    rows,replies=sdk_tables(p)
    for key,action in program['continuations'].items():
        assert key in p['actions'] and action==p['actions'][key], 'Substituted instruction body'
    allowed={q['id']:{k:v for k,v in q.items() if k!='replies'} for q in p['probes']}
    contacts={q['id']:q for q in program['contacts']}
    assert len(contacts)==len(program['contacts'])
    assert all(key in allowed and value==allowed[key] for key,value in contacts.items())

    def references(node):
        if node['kind']=='act':
            assert node['action'] in program['continuations']
        elif node['kind']=='probe':
            assert node['probe'] in contacts
            for child in node['branches'].values():
                references(child)
    references(program['plan']['tree'])
    audit_tree(program['plan'],rows,replies)


def summarize(p,plan,rows,replies):
    audit_tree(plan,rows,replies)
    lower=depth_bound(rows,replies,tuple(plan['initial']))
    assert lower==(None if plan['tree']['cost'] is None else plan['tree']['cost'][0])
    fixed,names=fixed_bound(rows,replies,plan['initial'])
    transcripts=[]
    for i in plan['initial']:
        # ONLY this fixture knows the actual world. The runtime sees one reply
        # per requested probe; it does not receive i, A, B, or a target answer.
        result=execute(plan,lambda probe:replies[probe][i])
        transcripts.append({'world':list(p['worlds'][i]), 'result':result,
                            'execution':p['actions'].get(result.get('action'))})
    return {'minimum_adaptive_queries':lower,'minimum_fixed_queries':fixed,
            'one_minimum_fixed_probe_set':names,'resource_bounds':plan['tree']['cost'],
            'unsupported_worlds':sum(not rows[i] for i in plan['initial']),
            'possible_worlds':len(plan['initial']), 'plan':plan, 'executions':transcripts}


def must_reject(fn):
    try:
        fn()
    except (AssertionError,ValueError):
        return
    raise AssertionError('Expected rejection did not occur')


def run():
    start=time.monotonic()
    cases=[]; cached={}
    # The same constructor receives connector words as data. No training or
    # held-out generalization claim: T and THT are structural transfer cases.
    for word in [(),('h',),('t',),('t','h','t')]:
        for consumer,axis in [('bare','Z'),('pauli_frame','Z'),('clifford_frame','Z'),
                              ('terminal','Z'),('terminal','X')]:
            p=model.problem(word,consumer,axis)
            rows,replies=sdk_tables(p)
            fresh=summarize(p,synthesize(p),rows,replies)
            memories={}
            for memory in product((0,1),repeat=2):
                initial=model.compatible_with_old_memory(memory)
                # Validate the old record against actually reconstructed neutral
                # probes, not merely equality of source labels or a status flag.
                assert tuple(i for i in range(16) if
                    (replies['neutral:X:X'][i],replies['neutral:Z:Z'][i])==memory)==initial
                memories[''.join(map(str,memory))]=summarize(p,synthesize(p,initial),rows,replies)
            local=model.problem(word,consumer,axis,('A','B'))
            local_plan=synthesize(local)
            local_replies={q['id']:replies[q['id']] for q in local['probes']}
            local_result=summarize(local,local_plan,rows,local_replies)
            case={'connector':list(word),'consumer':consumer,'axis':axis,
                  'fresh':fresh,'old_joint_memories':memories,
                  'optimal_local_probe_baseline':{
                      k:local_result[k] for k in ('minimum_adaptive_queries','resource_bounds')},
                  'probes':p['probes']}
            cases.append(case); cached[word,consumer,axis]=(p,rows,replies,fresh,memories)

    # Mutations exercise inference failures, not just parser shape rejection.
    initial=model.compatible_with_old_memory((0,0))
    p,rows,replies,fresh,memories=cached[('t',),'pauli_frame','Z']
    stale=synthesize(model.problem((),'pauli_frame'),initial)
    must_reject(lambda:audit_tree(stale,rows,replies))
    forged=copy.deepcopy(memories['00']['plan'])
    forged['tree']['branches']['1']['action']='correct:|frame:z'
    must_reject(lambda:audit_tree(forged,rows,replies))
    wrong_rejection={'initial':list(initial),'tree':{'kind':'unavailable'}}
    must_reject(lambda:audit_tree(wrong_rejection,rows,replies))
    missing_branch=copy.deepcopy(memories['00']['plan'])
    del missing_branch['tree']['branches']['1']
    must_reject(lambda:audit_tree(missing_branch,rows,replies))
    must_reject(lambda:execute(fresh['plan'],lambda _: {'hidden_world':0}))
    assert execute(fresh['plan'],lambda _:0,budget=0)['kind']=='needs_evidence'
    no_probe=model.problem(('t',),'bare',probe_paths=())
    assert synthesize(no_probe)['tree']['kind']=='insufficient'
    must_reject(lambda:synthesize(p,()))

    # Conventional task-aware frame rules match the found minima. Their query
    # menus are declared explicitly, not crippled to always correct physically.
    ordinary={
        'I_live':((), 'clifford_frame','Z',('neutral:X:X','neutral:Z:Z')),
        'I_terminal_Z':((), 'terminal','Z',('neutral:Z:Z',)),
        'T_live':(('t',), 'clifford_frame','Z',('A:Z:Z','B:Z:Z','neutral:X:X')),
        'T_terminal_Z':(('t',),'terminal','Z',('neutral:Z:Z',)),
    }
    conventional=[]
    for name,(word,consumer,axis,names) in ordinary.items():
        pp,rr,rp,fr,_=cached[word,consumer,axis]
        groups={}
        for i in range(16):
            groups.setdefault(tuple(rp[n][i] for n in names),[]).append(i)
        assert all(common_action(rr,g) for g in groups.values())
        assert len(names)==fr['minimum_adaptive_queries']
        conventional.append({'case':name,'queries':len(names),'matches_constructor':True})
    # Conventional adaptive X rule: A's Z sign chooses the second joint axis.
    _,rr,rp,fr,_=cached[('t',),'terminal','X']
    for first in (0,1):
        second='neutral:X:X' if first==0 else 'neutral:Y:Y'
        for reply in (0,1):
            group=[i for i in range(16) if rp['A:Z:Z'][i]==first and rp[second][i]==reply]
            assert common_action(rr,group)
    assert fr['minimum_adaptive_queries']==2 and fr['minimum_fixed_queries']==3
    conventional.append({'case':'T_terminal_X','queries':2,'matches_constructor':True})

    # An independent Boolean description of the target, checked against actual
    # SDK observables, reveals why two fixed parity queries cannot suffice.
    # A=X^u Z^v, B=X^w Z^z; global phase is immaterial. Wanted reading is
    # X (u=0) or Y (u=1), with sign (-1)^(q xor (u and w)), q=v xor z.
    pp,rr,rp,fr,_=cached[('t',),'terminal','X']
    bit_rows=[]
    for i,(a,b) in enumerate(pp['worlds']):
        u,v=int(a in ('X','Y')),int(a in ('Z','Y'))
        w,z=int(b in ('X','Y')),int(b in ('Z','Y'))
        label=(u,(v^z)^(u&w))
        wanted=f'read:{(-1 if label[1] else 1):+}:{"Y" if u else "X"}'
        assert rr[i]==frozenset([wanted])
        bit_rows.append({'source':[u,v,w,z],'answer':list(label)})
    fixed_uses=fixed_resource_bound(rr,pp['probes'],tuple(range(16)),3)
    assert fixed_uses==4 and fr['resource_bounds'][:2]==(2,3)

    # Adversarial record labels cannot affect the discovered plan, since world
    # names are absent from the planner's input operations.
    renamed=copy.deepcopy(pp)
    renamed['worlds']=tuple('opaque-'+str(i) for i in range(16))
    assert synthesize(renamed)['tree']==fr['plan']['tree']

    from build import build
    exported=build(('t',),'terminal','X')
    expected=copy.deepcopy(exported['request'])
    # JSON round trip tests the actual portable shape, including native bodies.
    exported=json.loads(json.dumps(exported))
    audit_program(exported,expected)
    forged_body=copy.deepcopy(exported)
    forged_body['continuations']['read:+1:X']['read']='Z'
    must_reject(lambda:audit_program(forged_body,expected))
    secret_scope=copy.deepcopy(exported)
    secret_scope['plan']['initial']=[0]
    must_reject(lambda:audit_program(secret_scope,expected))
    substituted_question=copy.deepcopy(exported)
    substituted_question['request']['axis']='Z'
    must_reject(lambda:audit_program(substituted_question,expected))

    return {'schema':'vi.finite-continuation.v1',
            'scope':'Exact ideal fixed Pauli modules; calibrated noiseless probes on fresh preparations; declared Clifford/Pauli consumer interfaces. No QPU experiment.',
            'objective':'Minimum worst-case number of binary probes. Module-use and gate counts are bounds for selected plans, not a global multiobjective optimum.',
            'hardware_jobs_submitted':0,'cases':cases,'ordinary_frame_baselines':conventional,
            'adaptive_X_relation':{'source_bits':'A=X^u Z^v, B=X^w Z^z',
                'sufficient_label':'(u, v xor z xor (u and w))',
                'two_adaptive_probe_module_uses':3,
                'minimum_module_uses_for_three_fixed_probes':fixed_uses,
                'truth_table':bit_rows},
            'checks':{'sdk_case_worlds':len(cases)*16,
                      'audited_plans_including_old_memory_and_local_baseline':len(cases)*6,
                      'negative_and_boundary_checks':11,
                      'export_request_and_native_bodies_checked':True},
            'elapsed_seconds':time.monotonic()-start}


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output',required=True,type=Path)
    args=parser.parse_args()
    result=run()
    args.output.parent.mkdir(parents=True,exist_ok=True)
    args.output.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:v for k,v in result.items() if k!='cases'},indent=2))
    for c in result['cases']:
        print('/'.join(c['connector']) or 'I',c['consumer'],c['axis'],
              'adaptive/fixed/local',c['fresh']['minimum_adaptive_queries'],
              c['fresh']['minimum_fixed_queries'],c['optimal_local_probe_baseline']['minimum_adaptive_queries'],
              'old00',c['old_joint_memories']['00']['minimum_adaptive_queries'],
              'unsupported',c['fresh']['unsupported_worlds'])
