#!/usr/bin/env python3
"""Common occurrence: independent finite oracle, live port and quantum audit."""
import argparse
from collections import Counter,deque
from copy import deepcopy
import io
import itertools
import json
from pathlib import Path
import subprocess
import time

import numpy as np
from qiskit import qpy,ClassicalRegister
from qiskit_aer import AerSimulator

import resident_joint_goals as j
import resident_joint_goals_sdk as sdk
import resident_goal_synthesis as s
from resident_goal_synthesis_checks import InstrumentPort,RetainingFirstPort
from resident_raw_reply_checks import fixture
from resident_stream_checks import operators
from resident_goal_instrument_audit import interpret,expand
import whole_word_admission as a
from environment import write


def values(mask):return [(mask>>i)&1 for i in range(8)]


def query(source,masks,*,occurrence='exit',recipient=None):
    if recipient is None:recipient=[int(code==2**len(masks)-1) for code in range(2**len(masks))]
    return j.request(source,[values(m) for m in masks],occurrence,recipient)


def direct_graph(support):
    root=tuple((x,x) for x in support);nodes=[root];ids={root:0};edges=[];todo=deque([root])
    while todo:
        K=todo.popleft();row=[]
        for b in (0,1):
            image=tuple(sorted(set((old,4*(1^(now>>2)^b)+2*((now>>1)&1)+b) for old,now in K)))
            if image not in ids:ids[image]=len(nodes);nodes.append(image);todo.append(image)
            row.append(ids[image])
        edges.append(row)
    return nodes,edges


def direct_rank(edges,terminal):
    # Separate attractor recurrence, not a call to either production solver.
    done={i:0 for i in range(len(edges)) if terminal>>i&1};level=0
    while True:
        new={i for i,row in enumerate(edges) if i not in done and all(k in done for k in row)}
        if not new:return done.get(0)
        level+=1
        done.update({i:level for i in new})


def finite(source):
    states=list(itertools.product((0,1),repeat=3))
    assert values(254)==[int(r or f or l) for r,f,l in states]
    assert values(239)==[int((not r) or f or l) for r,f,l in states]
    assert values(238)==[int(f or l) for r,f,l in states]
    lookup=[];terminals=[]
    for r in (0,1):
        nodes,edges=direct_graph(list(range(4*r,4*r+4)))
        lookup.append({t:direct_rank(edges,t) for t in range(1<<len(nodes))})
        terminals.append([sum(1<<i for i,K in enumerate(nodes) if len({(m>>now)&1 for _,now in K})==1)
                          for m in range(256)])
    def bound(masks):
        answers=[]
        for r in (0,1):
            t=terminals[r][masks[0]]
            for m in masks[1:]:t &= terminals[r][m]
            answers.append(lookup[r][t])
        return max(answers) if all(x is not None for x in answers) else None
    single=[m for m in range(256) if bound([m]) is not None]
    assert len(single)==48
    counts=Counter();certified=0
    for left,right in itertools.product(range(256),repeat=2):
        rank=bound([left,right]);counts[str(rank)]+=1
        vs=[values(left),values(right)]
        independent=lambda r,l:all(v[4*r+l]==v[4*r+2+l] for v in vs)
        criterion=independent(0,1) and independent(1,1) and (independent(0,0) or independent(1,0))
        assert criterion==(rank is not None)
        if left in single and right in single:
            for r in (0,1):
                cert=j.synthesize(source,list(range(4*r,4*r+4)),query(source,[left,right]))
                assert cert['worst_case_contacts']==lookup[r][terminals[r][left]&terminals[r][right]]
                certified+=1
    assert sum(n for k,n in counts.items() if k!='None')==1792
    triples=0;triple_costs=Counter()
    for masks in itertools.product(single,repeat=3):
        ok=bound(masks) is not None
        assert ok==all(bound(pair) is not None for pair in itertools.combinations(masks,2))
        triples+=ok;triple_costs[str(bound(masks))]+=1
    assert triples==2*32**3-16**3==61440
    assert [triple_costs[str(n)] for n in (0,1,2)]==[4**3,3*16**3-2*8**3-4**3,2*32**3-4*16**3+2*8**3]
    preference={}
    for memory in ('first','agreement'):
        obs=source['goal']['observation'][memory]
        K=[[i for i,x in enumerate(obs) if tuple(x)==v] for v in sorted(set(map(tuple,obs)))]
        for occurrence in ('entry','exit'):
            ranks=[s.synthesize(source,k,s.request(source,values(102),occurrence))['worst_case_contacts'] for k in K]
            preference[memory+':'+occurrence]=max(ranks) if all(x is not None for x in ranks) else None
    assert preference=={'first:entry':None,'first:exit':1,'agreement:entry':0,'agreement:exit':0}
    return {'all_ordered_binary_question_pairs':65536,'individually_sure_pairs':48**2,
            'common_endpoint_pairs':1792,'separately_sure_but_not_jointly_sure':512,
            'pair_minimum_costs':dict(counts),'production_bundle_certificates_checked':certified,
            'individually_sure_triples_examined':48**3,'common_endpoint_triples':triples,
            'triple_minimum_costs':dict(triple_costs),
            'pairwise_sufficiency_verified_for_all_these_triples':True,
            'First_Agreement_question_102_costs':preference}


def guards(source):
    result=[]
    def reject(name,fn):
        try:fn()
        except (ValueError,AssertionError,KeyError):result.append(name);return
        raise AssertionError('Accepted '+name)
    bad=j.synthesize(source,[0,1,2,3],query(source,[254,239]))
    assert bad['worst_case_contacts'] is None
    c=deepcopy(bad);c['nodes'][0]['rank']=1;c['worst_case_contacts']=1;c.pop('obstruction_kind')
    reject('maximum of separate ranks presented as a common rank',lambda:j.verify(source,c))
    c=deepcopy(bad);c['nodes'][0]['answers']=[1,1];c['nodes'][0]['code']=3;c['nodes'][0]['recipient']=1;c['nodes'][0]['rank']=0
    reject('two earlier true answers presented at the same endpoint',lambda:j.verify(source,c))
    good=j.synthesize(source,[0,1],query(source,[254,239]))
    c=deepcopy(good);c['members'][1]=s.synthesize(source,[0,1],s.request(source,values(239),'entry'))
    reject('one member silently changed to a different occurrence',lambda:j.verify(source,c))
    c=deepcopy(good);target=next(row for row in c['nodes'] if row['answers'] is not None);target['recipient']^=1
    reject('same tuple routed to another recipient',lambda:j.verify(source,c))
    c=deepcopy(good);c['members'][0]=s.synthesize(source,[0],s.request(source,values(254),'exit'))
    reject('member uses a privately narrowed source class',lambda:j.verify(source,c))
    c=deepcopy(good);c['query']['endpoint']='Each answer can use its own preferred stopping point.'
    reject('common endpoint replaced by separate endpoints',lambda:j.verify(source,c))
    reject('missing tuple member',lambda:j.request(source,[],'exit',[0]))
    recipient_only=j.synthesize(source,[0,1,2,3],query(source,[240,204],recipient=[0,1,0,1]))
    assert recipient_only['worst_case_contacts'] is None
    unknown_pair=j.synthesize(source,[0,1,2,3],query(source,[204,51]))
    known_conjunction=s.synthesize(source,[0,1,2,3],s.request(source,values(0),'exit'))
    assert unknown_pair['worst_case_contacts'] is None and known_conjunction['worst_case_contacts']==0
    return {'rejections':result,'known_recipient_bit_does_not_determine_the_requested_tuple':True,
            'constant_conjunction_does_not_determine_its_two_arguments':True}


def live(source):
    cases=[]
    for theta,phi in ((1.3,-.8),(1.45,.91)):
        _,maps,_=fixture(theta,phi);success=0;refusal=0;costs=Counter()
        for seed in range(48):
            for Port in (InstrumentPort,RetainingFirstPort):
                port=Port(source,maps,seed);actor=j.Continuation(source,port)
                before=port._rho.copy();n=port._contacts;receivers=len(port._recipients)
                reply=actor.perform_bundle(query(source,[254,239]))
                if Port is InstrumentPort:
                    assert not reply['executed'] and np.array_equal(before,port._rho)
                    assert port._contacts==n and len(port._recipients)==receivers;refusal+=1
                else:
                    r,f,l=port._r,port._history[0],port._history[-1]
                    assert reply['executed'] and reply['answers']==[int(r or f or l),int((not r) or f or l)]
                    assert reply['recipient']==int(f or l) and len(port._recipients)==receivers+1
                    assert reply['contacts']==port._contacts-n<=1
                    costs[reply['contacts']]+=1;success+=1
        cases.append({'fixture':[theta,phi],'common_First_successes':success,'unchanged_Continue_refusals':refusal,
                      'actual_contact_counts':dict(costs)})
    # Ambiguous completion must also remain blocked in the joint consumer.
    _,maps,_=fixture(1.3,-.8);port=RetainingFirstPort(source,maps,193);actor=j.Continuation(source,port)
    original=port.recipient
    def lost(bit):original(bit);raise RuntimeError('Recipient happened; confirmation lost')
    port.recipient=lost
    try:actor.perform_bundle(query(source,[254,239]))
    except RuntimeError:pass
    else:raise AssertionError('Lost recipient looked confirmed')
    n=port._contacts;rho=port._rho.copy();receivers=len(port._recipients)
    try:actor.perform_bundle(query(source,[254,239]))
    except ValueError:pass
    else:raise AssertionError('Ambiguous joint recipient was retried')
    assert port._contacts==n and len(port._recipients)==receivers and np.array_equal(rho,port._rho)
    return {'cases':cases,'uncertain_joint_recipient_not_repeated':True}


def separate_occurrences(source):
    _,maps,_=fixture(1.3,-.8)
    for seed in range(256):
        port=InstrumentPort(source,maps,seed)
        if (port._r,port._history[0],port._history[-1])!=(0,0,0):continue
        actor=s.Continuation(source,port)
        earlier=actor.perform(s.request(source,values(239),'exit'))
        later=actor.perform(s.request(source,values(254),'exit'))
        if (port._r,port._history[0],port._history[-1])!=(1,0,0):continue
        assert earlier['answer']==later['answer']==1
        assert earlier['contacts']==0 and later['contacts']==1
        return {'fixture':[1.3,-.8],'seed':seed,'actual_reply_history':port._history,
                'earlier_monitor':[0,0,0],'later_monitor':[1,0,0],
                'earlier_q_minus':1,'later_q_plus':1,'q_minus_at_later_monitor':0,
                'scope':'One actual local quantum port and acquired replies. Hidden monitor fields are inspected only by this audit, not supplied to the actor.'}
    raise AssertionError('No actual local trajectory realized the declared counterexample')


def oracle_operator(source,query,maps,events):
    current=np.eye(16,dtype=complex)
    cx=np.array([[1,0,0,0],[0,0,0,1],[0,0,1,0],[0,1,0,0]])
    for matrix,wires in [(a.H,[2]),(cx,[2,3]),(a.H,[1]),(cx,[1,0])]:current=expand(matrix,wires,4)@current
    ops=operators(source['goal']['raw'],maps);r=0;history=[];entry=None;snapshots={};bits=[]
    for event in events:
        if event['kind']=='contact':
            s.require(not bits,'A service contact occurred between tuple members')
            b=event['reply'];K,=ops[r,b];current=K@current;r=1^r^b;history.append(b)
            if len(history)==3:
                entry=4*r+2*history[0]+history[-1];snapshots['joint_entry']=current.copy()
        else:
            s.require(event['goal']==len(bits),'Tuple member order changed')
            now=4*r+2*history[0]+history[-1]
            at=entry if query['occurrence']=='entry' else now
            bit=query['questions'][len(bits)][at]
            s.require(event['bit']==bit,'Actual record is not an answer at the common occurrence')
            if not bits:snapshots['joint_endpoint']=current.copy()
            bits.append(bit)
    s.require(len(bits)==len(query['questions']),'Incomplete joint output')
    snapshots['joint_recorded']=current.copy();code=sum(v<<i for i,v in enumerate(bits))
    if query['recipient'][code]:current=np.kron(a.I,np.kron(a.Z,np.eye(4)))@current
    snapshots['joint_used']=current.copy()
    return current,snapshots


def quantum(source,output):
    result=[];worst=0.;sample_worst=0.;sampled=0
    for fixture_id,(theta,phi) in enumerate(((1.3,-.8),(1.45,.91))):
        service,maps,_=fixture(theta,phi)
        configurations=[('first',[254,239],[0,0,0,1]),('continue',[240,21],[0,1,1,0])]
        if fixture_id==0:
            configurations.append(('first',[1<<i for i in range(8)],[(code>>4)&1 for code in range(256)]))
        for memory,masks,recipient in configurations:
            request=query(source,masks,recipient=recipient)
            production,info=sdk.build(source,service,request,memory=memory)
            buf=io.BytesIO();qpy.dump(production,buf);buf.seek(0);loaded,=qpy.load(buf)
            sdk.admit(source,service,request,loaded,memory=memory)
            (output/f'joint-{memory}-{len(masks)}-{fixture_id}.qpy').write_bytes(buf.getvalue())
            q,_=sdk.build(source,service,request,memory=memory,snapshot=True)
            branches=interpret(q);total=np.zeros((16,16),complex);error=0.
            for branch in branches:
                target,points=oracle_operator(source,request,maps,branch['events'])
                actual=branch['map'][::2,:];total+=actual.conj().T@actual
                error=max(error,float(np.max(abs(actual-target))))
                for label,matrix in points.items():error=max(error,float(np.max(abs(branch['snapshots'][label]-matrix))))
            s.require(error<1e-11 and np.max(abs(total-np.eye(16)))<1e-11,'Complete common instrument changed')
            worst=max(worst,error)
            traced=q.copy_empty_like();record=ClassicalRegister(sum(x.operation.name=='measure' for x in q.data),'audit_records');traced.add_register(record)
            k=0
            for item in q.data:
                traced.append(item)
                if item.operation.name=='measure':traced.store(record[k],item.clbits[0]);k+=1
            trajectories=interpret(traced);by_bits={tuple(b['bits']):b for b in trajectories}
            assert len(by_bits)==len(trajectories)
            run=AerSimulator(method='statevector',max_parallel_threads=1).run(traced,shots=64,memory=True,seed_simulator=8400+len(result)).result()
            assert run.success;sample_error=0.
            for shot,word in enumerate(run.get_memory()):
                number=int(word.replace(' ',''),2);bits=tuple((number>>i)&1 for i in range(traced.num_clbits))
                s.require(bits in by_bits,'SDK record is outside the independent joint instrument')
                for name,matrix in by_bits[bits]['snapshots'].items():
                    v=matrix[:,0];p=np.vdot(v,v).real;assert p>0
                    wanted=np.outer(v,v.conj())/p
                    sample_error=max(sample_error,float(np.max(abs(run.data()[name][shot].data-wanted))));sampled+=1
            assert sample_error<1e-11;sample_worst=max(sample_worst,sample_error)
            result.append({'memory':memory,'questions':len(masks),'fixture':[theta,phi],'source_contact_bound':info['bound'],
                           'branches':len(branches),'full_operator_residual':error,'Aer_shots':64,
                           'Aer_state_residual':sample_error,'QPY_admitted':True,'classical_bits':q.num_clbits})
    no,proof=sdk.build(source,service,query(source,[254,239]),memory='continue')
    assert no is None and not proof['applicable']
    changed=query(source,masks,recipient=[0,0,0,0])
    bad,_=sdk.build(source,service,changed,memory=memory,snapshot=True);bad.metadata=q.metadata
    try:sdk.admit(source,service,request,bad,memory=memory,snapshot=True)
    except ValueError:pass
    else:raise AssertionError('Wrong recipient admitted')
    differences=[];actual_instrument={};target_instrument={}
    for branch in interpret(bad):
        target,_=oracle_operator(source,request,maps,branch['events'])
        actual=branch['map'][::2,:]
        differences.append(float(np.max(abs(actual-target))))
        code=sum(e['bit']<<e['goal'] for e in branch['events'] if e['kind']=='answer')
        av,tv=actual.reshape(-1),target.reshape(-1)
        actual_instrument[code]=actual_instrument.get(code,0)+np.outer(av,av.conj())
        target_instrument[code]=target_instrument.get(code,0)+np.outer(tv,tv.conj())
    assert max(differences)>1e-3
    # A Kraus matrix difference alone might be only a branch-global phase.
    # Sum Choi blocks at the ACTUALLY returned tuple, forgetting hidden paths.
    choi_difference=max(float(np.linalg.norm(actual_instrument[k]-target_instrument[k])) for k in actual_instrument)
    assert choi_difference>1e-3
    return {'cases':result,'maximum_operator_residual':worst,'Aer_checkpoint_states':sampled,
            'maximum_Aer_state_residual':sample_worst,'unsupported_bundle_emits_no_circuit':True,
            'wrong_recipient_refused_even_when_tuple_is_correct':True,'wrong_recipient_operator_residual':max(differences),
            'wrong_recipient_Choi_difference_after_grouping_by_returned_tuple':choi_difference}


def run(output):
    start=time.perf_counter();output.mkdir(parents=True,exist_ok=True)
    source=s.reading();s.validate_source(source);write(output/'source-reading.json',source)
    result={'finite':finite(source),'guards':guards(source),'live':live(source),'quantum':quantum(source,output),
            'separate_occurrences':separate_occurrences(source),'new_QPU_jobs':0}
    selected=[j.synthesize(source,K,query(source,masks)) for K,masks in
              [([0,1,2,3],[254,239]),([4,5,6,7],[254,239]),([0,1],[254,239]),
               ([2,3],[254,239]),([4,5],[254,239]),([6,7],[254,239]),([0,1,2,3],[240,21])]]
    write(output/'certificates.json',selected)
    court=json.loads(s.run(['node',s.HERE/'resident_joint_goals_court.js',output]))
    native=s.ROOT/'.build/arm64-apple-macosx/debug/Tools'
    message=s.run([native,'judge','where',output/'ResidentCommonEndpoint.swift'])
    assert f"{court['equalities']} equalities" in message and 'THE WHERE holds' in message
    for negative in court['negatives']:
        check=subprocess.run([str(native),'judge','where',str(output/negative['file'])],text=True,capture_output=True,timeout=30)
        assert check.returncode==1 and 'requires the types' in check.stdout+check.stderr
    court['native']=message.strip();write(output/'court.json',court)
    result['courts']=court;result['seconds']=time.perf_counter()-start
    write(output/'audit.json',result)
    return result


if __name__=='__main__':
    cli=argparse.ArgumentParser(description=__doc__);cli.add_argument('--output',type=Path,required=True)
    result=run(cli.parse_args().output.resolve())
    print(json.dumps({'finite':result['finite'],'operator_residual':result['quantum']['maximum_operator_residual'],
                      'seconds':result['seconds']},indent=2))
