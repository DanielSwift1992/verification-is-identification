#!/usr/bin/env python3
"""Independent bounded-goal oracle, certificate refusals and a live local port."""
import argparse
from collections import Counter
from copy import deepcopy
import io
import json
from pathlib import Path
import subprocess
import time

import numpy as np
from qiskit import qpy
from qiskit_aer import AerSimulator

import resident_goal_synthesis as s
import resident_goal_synthesis_sdk as sdk
from resident_raw_reply_checks import fixture, initial_quantum
from resident_stream_checks import operators, apply
import whole_word_admission as a
from environment import write, digest


def query(source,mask,when='exit'):
    return s.request(source,[(mask>>i)&1 for i in range(8)],when)


def oracle(query,support,budget):
    # Independent direct recurrence, retaining the original occurrence.
    def step(state,b):
        r,f,l=map(int,format(state,'03b'))
        return 4*(1^r^b)+2*f+b
    def go(pairs,left):
        side=0 if query['occurrence']=='entry' else 1
        if len({query['values'][pair[side]] for pair in pairs})==1:
            return True
        if left==0:
            return False
        return all(go([(old,step(now,b)) for old,now in pairs],left-1) for b in (0,1))
    return go([(i,i) for i in support],budget)


def finite(source):
    supports=[sorted(4*r+i for i in range(4) if mask>>i&1) for r in (0,1) for mask in range(1,16)]
    counts=Counter(); full=Counter(); tests=0; max_nodes=0; no_bound=Counter()
    for mask in range(256):
        for when in ('entry','exit'):
            q=query(source,mask,when); whole=[]
            for support in supports:
                cert=s.synthesize(source,support,q); rank=cert['worst_case_contacts']; tests+=1
                expected=next((n for n in range(4) if oracle(q,support,n)),None)
                assert rank==expected
                counts[(when,str(rank))]+=1; max_nodes=max(max_nodes,len(cert['nodes']))
                if len(support)==4:
                    whole.append(rank)
                    if rank is None: no_bound[(when,cert['obstruction_kind'])]+=1
            global_rank=max(whole) if all(n is not None for n in whole) else None
            full[(when,str(global_rank))]+=1
            if when=='exit':
                v=q['values']
                free=lambda r,l:v[4*r+l]==v[4*r+2+l]
                condition=free(0,1) and free(1,1) and (free(0,0) or free(1,0))
                assert condition==(global_rank is not None)
    assert full[('entry','0')]==4 and full[('entry','None')]==252
    assert [full[('exit',str(n))] for n in (0,1,2)]==[4,28,16]
    return {'questions':256,'occurrence_modes':2,'nonempty_supports_retaining_R':30,
            'certificates_and_independent_bounded_oracle':tests,'maximum_reachable_graph_nodes':max_nodes,
            'all_support_costs':{str(k):v for k,v in counts.items()},
            'full_continue_domain_costs':{str(k):v for k,v in full.items()},
            'full_fiber_obstructions':{str(k):v for k,v in no_bound.items()},
            'exit_closed_form_verified_on_every_question':True}


def guards(source):
    bad=[]
    def reject(name,call):
        try:call()
        except (ValueError,AssertionError,KeyError):bad.append(name);return
        raise AssertionError('Accepted '+name)
    good=s.synthesize(source,[0,1,2,3],query(source,21))
    c=deepcopy(good); c['query']['occurrence']='entry'
    reject('new-state answer relabelled as an old-state answer',lambda:s.verify(source,c))
    c=deepcopy(good); c['nodes'][0]['next'][0]=c['nodes'][0]['next'][1]
    reject('reply successor replaced',lambda:s.verify(source,c))
    c=deepcopy(good); c['nodes'][0]['pairs'].pop()
    reject('unmeasured initial alternative removed',lambda:s.verify(source,c))
    c=deepcopy(good); c['nodes'][0]['rank']=1;c['worst_case_contacts']=1
    reject('two-contact minimum shortened',lambda:s.verify(source,c))
    c=deepcopy(good); i=next(i for i,r in enumerate(c['nodes']) if r['answer'] is not None); c['nodes'][i]['answer']^=1
    reject('terminal decoder replaced',lambda:s.verify(source,c))
    c=deepcopy(good); c['nodes'][0]['relative']^=1
    reject('source quantum selector changed',lambda:s.verify(source,c))
    c=s.synthesize(source,[0,1,2,3],query(source,136)); c['obstruction_kind']='no_answer_on_any_finite_transcript'
    reject('lack of a uniform bound promoted to absolute non-recovery',lambda:s.verify(source,c))
    c=s.synthesize(source,[0,1,2,3],query(source,136)); c['nodes'][0]['obstructing_reply']=0
    reject('obstruction points to an answerable successor',lambda:s.verify(source,c))
    reject('source control not available',lambda:s.synthesize(source,[0,4],query(source,21)))
    reject('empty support makes an answer vacuous',lambda:s.synthesize(source,[],query(source,21)))
    c=deepcopy(source); c['goal']['operations']['reply0'][0]=0
    reject('invented current source law',lambda:s.validate_source(c))
    c=query(source,21);c['allowed_change']='Replace the retained data with a known preparation.'
    reject('consumer allows a different physical operation',lambda:s.synthesize(source,[0,1,2,3],c))
    return bad


def memory_frontiers(source):
    """Compare the existing source readings on the same complete question set."""
    report={}; admitted={}; immediate={}
    for basis,reading in source['goal']['observation'].items():
        supports=[[i for i,x in enumerate(reading) if tuple(x)==value]
                  for value in sorted(set(map(tuple,reading)))]
        counts=Counter(); admitted[basis]=set(); immediate[basis]=set()
        for mask in range(256):
            for occurrence in ('entry','exit'):
                q=query(source,mask,occurrence)
                ranks=[s.synthesize(source,k,q)['worst_case_contacts'] for k in supports]
                bound=max(ranks) if all(x is not None for x in ranks) else None
                counts[(occurrence,str(bound))]+=1
                if occurrence=='exit' and bound is not None:
                    admitted[basis].add(mask)
                    if bound==0:immediate[basis].add(mask)
        report[basis]={'classes':len(supports),'question_costs':{str(k):v for k,v in counts.items()}}
    assert len(admitted['first'])==256 and len(admitted['agreement'])==60
    assert admitted['agreement']==admitted['continue']|immediate['agreement']
    assert len(immediate['agreement'])==len(immediate['first'])==16
    return {'source_readings':report,
            'agreement_exit_questions_are_continue_questions_union_immediate_agreement_questions':True,
            'scope':'Same 256 binary questions, every class of each existing reading; no new contact.'}


def universal_memory(source):
    """Every classical partition with available R; no claim of free acquisition."""
    def partitions(items):
        if not items:
            yield ()
            return
        first,*rest=items
        for partition in partitions(rest):
            yield ((first,),)+partition
            for i,block in enumerate(partition):
                yield partition[:i]+((first,)+block,)+partition[i+1:]
    halves=[list(partitions(list(range(4*r,4*r+4)))) for r in (0,1)]
    assert list(map(len,halves))==[15,15]
    # Compute once for the 30 possible classes; combine the actual certified
    # minima for every partition and every question independently of the
    # proposed simple necessary/sufficient condition.
    ranks={}
    for r in (0,1):
        for mask in range(1,16):
            block=tuple(4*r+i for i in range(4) if mask>>i&1)
            ranks[block]=[s.synthesize(source,list(block),query(source,q))['worst_case_contacts']
                          for q in range(256)]
    valid=[]; capacities=Counter(); examined=0
    for left in halves[0]:
        for right in halves[1]:
            partition=tuple(sorted(left+right)); examined+=1
            works=all(all(ranks[block][q] is not None for block in partition) for q in range(256))
            keeps_first=all(len({(x>>1)&1 for x in block})==1 for block in partition)
            assert works==keeps_first
            capacities[(len(partition),works)]+=1
            if works:valid.append(partition)
    smallest=min(map(len,valid)); minimal=[p for p in valid if len(p)==smallest]
    assert examined==225 and len(valid)==16 and smallest==4
    assert minimal==[((0,1),(2,3),(4,5),(6,7))]
    return {'candidate_partitions_retaining_R':examined,'all_exit_questions_per_partition':256,
            'universally_sufficient_partitions':len(valid),'minimum_classes':smallest,
            'unique_minimal_partition':[list(b) for b in minimal[0]],
            'sufficient_iff_each_class_already_determines_First':True,
            'partition_counts':{str(k):v for k,v in capacities.items()},
            'scope':'Classical readings of the given eight states and existing contact. First must be retained/acquired before it is lost; this does not restore it from Continue.'}


class InstrumentPort:
    """Private test service. Only checkpoint/contact/recipient reach the actor."""
    def __init__(self,source,ks,seed):
        self.source_id=a.fingerprint(source); self._source=source; self._maps=operators(source['goal']['raw'],ks)
        self._rho=initial_quantum(); self._r=0;self._history=[]; self._rng=np.random.default_rng(seed)
        self._carrier=object();self._contacts=0;self._recipients=[]
        for _ in range(3):self.contact(self._r)

    def checkpoint(self):
        return {'basis':'continue','value':[self._r,0]}

    def contact(self,relative):
        assert relative==self._r
        branches=[apply(self._maps[relative,b],self._rho) for b in (0,1)]
        probs=np.array([np.trace(x).real for x in branches]); assert abs(probs.sum()-1)<1e-10
        b=int(self._rng.choice(2,p=probs/probs.sum()))
        self._rho=branches[b]/probs[b];self._r=1^relative^b;self._history.append(b);self._contacts+=1
        return b

    def recipient(self,bit):
        assert type(bit)is int and bit in (0,1)
        if bit:
            z=np.kron(a.I,np.kron(a.Z,np.eye(4)));self._rho=z@self._rho@z
        self._recipients.append(bit)


class RetainingFirstPort(InstrumentPort):
    """Choose before acquisition to retain the actual first returned bit."""
    def __init__(self,source,ks,seed):
        self._first_record=None
        super().__init__(source,ks,seed)

    def contact(self,relative):
        bit=super().contact(relative)
        if self._first_record is None:self._first_record=bit
        return bit

    def checkpoint(self):
        assert self._first_record in (0,1)
        return {'basis':'first','value':[self._r,self._first_record]}


def acquired_first_memory(source):
    _,ks,_=fixture(1.3,-.8); chosen={}
    for seed in range(64):
        port=RetainingFirstPort(source,ks,seed)
        key=tuple(port.checkpoint()['value'])
        chosen.setdefault(key,seed)
        if len(chosen)==4:break
    assert len(chosen)==4
    calls=0;goals=0
    for key,seed in chosen.items():
        port=RetainingFirstPort(source,ks,seed);actor=s.Continuation(source,port)
        assert len(actor.support)==2 and port._first_record==port._history[0]
        n=port._contacts
        # The next Last is not supplied by the checkpoint. It is acquired.
        result=actor.perform(query(source,170,'exit'))
        assert result['contacts']==1 and port._contacts==n+1 and len(actor.support)==1
        assert result['answer']==port._history[-1]; calls+=1
        # Newly submitted questions then share this actual full boundary.
        for mask in range(256):
            state=4*port._r+2*port._history[0]+port._history[-1]
            result=actor.perform(query(source,mask,'entry'))
            assert result['executed'] and result['contacts']==0 and result['answer']==((mask>>state)&1)
            goals+=1
        assert port._contacts==n+1
    return {'acquired_First_classes':4,'renewing_service_contacts':calls,
            'subsequent_new_questions_without_another_contact':goals,
            'scope':'First is recorded from the actual contact return before it can be discarded, not read from a hidden history at upgrade time.'}


def runtime(source):
    costs=Counter(); checked=0; refused=0; traces=[]
    specs=[query(source,240,'entry'),query(source,21),query(source,170,'entry'),query(source,204,'entry')]
    for fixture_index,(theta,phi) in enumerate(((1.3,-.8),(1.45,.91))):
        _,ks,_=fixture(theta,phi)
        for seed in range(96):
            port=InstrumentPort(source,ks,1000*fixture_index+seed); actor=s.Continuation(source,port)
            carrier=port._carrier; events=[]
            for index,q in enumerate(specs):
                entry=4*port._r+2*port._history[0]+port._history[-1]
                before=port._rho.copy(); n=port._contacts; old_support=list(actor.support)
                reply=actor.perform(q); after=4*port._r+2*port._history[0]+port._history[-1]
                assert after in actor.support and port._carrier is carrier
                if index==3:
                    assert not reply['executed'] and port._contacts==n and np.array_equal(port._rho,before)
                    assert actor.support==old_support and reply['certificate']['obstruction_kind']=='no_answer_on_any_finite_transcript'
                    refused+=1
                else:
                    wanted=q['values'][entry if q['occurrence']=='entry' else after]
                    assert reply['executed'] and reply['answer']==wanted
                    assert reply['contacts']==port._contacts-n
                    if index in (0,2):assert reply['contacts']==0
                    costs[(index,reply['contacts'])]+=1;checked+=1
                events.append({k:v for k,v in reply.items() if k!='certificate'})
            if seed<2:traces.append({'fixture':fixture_index,'events':events})
    assert costs[(1,1)]>0 and costs[(1,2)]>0
    return {'episodes':192,'successful_new_requests':checked,'unchanged_live_refusals':refused,
        'service_contacts_by_goal':{str(k):v for k,v in costs.items()},'example_traces':traces,
        'scope':'Goals are passed to the actor after the previous goal finishes. The same private live density operator and reference persist; no LLM or true-state read in the actor.'}


def uncertain_acts(source):
    _,ks,_=fixture(1.3,-.8);results=[]
    for kind in ('contact','recipient'):
        port=InstrumentPort(source,ks,193); actor=s.Continuation(source,port)
        operation=getattr(port,kind)
        def lost_reply(value):
            operation(value)
            raise RuntimeError('The physical operation completed, but its acknowledgement was lost')
        setattr(port,kind,lost_reply)
        q=query(source,21) if kind=='contact' else query(source,255,'entry')
        try:actor.perform(q)
        except RuntimeError:pass
        else:raise AssertionError('The uncertain action appeared completed')
        assert actor.pending and actor.pending['kind']==kind
        contacts=port._contacts; recipients=len(port._recipients); state=port._rho.copy()
        try:actor.perform(q)
        except ValueError:pass
        else:raise AssertionError('An uncertain action was repeated')
        assert port._contacts==contacts and len(port._recipients)==recipients and np.array_equal(port._rho,state)
        results.append({'kind':kind,'actual_act_happened':True,'automatic_repeat_refused':True})
    return results


def sdk_checks(source,output):
    specs=[query(source,240,'entry'),query(source,21),query(source,170,'entry'),query(source,204,'entry')]
    cases=[]
    for index,(theta,phi) in enumerate(((1.3,-.8),(1.45,.91))):
        service,_,_=fixture(theta,phi)
        q,stages=sdk.build(source,service,specs,snapshot=False)
        buf=io.BytesIO();qpy.dump(q,buf); buf.seek(0);loaded,=qpy.load(buf)
        sdk.admit(source,service,specs,loaded)
        (output/f'goal-sequence-{index}.qpy').write_bytes(buf.getvalue())
        audit,_=sdk.build(source,service,specs,snapshot=True)
        result=AerSimulator(method='statevector',max_parallel_threads=1).run(
            audit,shots=128,seed_simulator=73261+index,memory=True).result()
        assert result.success
        cases.append({'fixture':[theta,phi],'shots':128,'qubits':q.num_qubits,'classical_bits':q.num_clbits,
            'goal_bounds':[x.get('bound') for x in stages],'goal_applies':[x['applicable'] for x in stages],
            'measured_counts':result.get_counts(),'QPY_admitted':True,
            'sampled_states_saved_for_independent_channel_audit':list(result.data().keys())})
    return cases


def courts(source,output):
    selected=[s.synthesize(source,K,query(source,m,o)) for K,m,o in
        [([0,1,2,3],240,'entry'),([0,1,2,3],21,'exit'),([4,5,6,7],21,'exit'),
         ([0,2],170,'entry'),([0,2],204,'entry'),([0,1,2,3],136,'exit')]]
    write(output/'selected-certificates.json',selected)
    result=json.loads(s.run(['node',s.HERE/'resident_goal_synthesis_court.js','build',output]))
    native=s.ROOT/'.build/arm64-apple-macosx/debug/Tools'
    text=s.run([native,'judge','where',output/'ResidentGoalSynthesis.swift'])
    assert f"{result['equalities']} equalities" in text and 'THE WHERE holds' in text
    for row in result['negatives']:
        check=subprocess.run([str(native),'judge','where',str(output/row['file'])],capture_output=True,text=True,timeout=30)
        assert check.returncode==1 and 'requires the types' in check.stdout+check.stderr
    result['native']=text.strip(); write(output/'build.json',result)
    return result


def run(output):
    start=time.perf_counter();output.mkdir(parents=True,exist_ok=True)
    source=s.reading();s.validate_source(source);write(output/'synthesis-reading.json',source)
    result={'finite':finite(source),'refusals':guards(source),'live_runtime':runtime(source),
            'uncertain_acts':uncertain_acts(source),
            'memory_frontiers':memory_frontiers(source),
            'universal_memory':universal_memory(source),
            'acquired_first_memory':acquired_first_memory(source),
            'SDK':sdk_checks(source,output),'courts':courts(source,output), 'seconds':time.perf_counter()-start,
            'new_QPU_jobs_from_this_local_suite':0}
    write(output/'audit.json',result)
    return result


if __name__=='__main__':
    cli=argparse.ArgumentParser(description=__doc__);cli.add_argument('--output',type=Path,required=True)
    r=run(cli.parse_args().output.resolve())
    print(json.dumps({'finite_certificates':r['finite']['certificates_and_independent_bounded_oracle'],
        'refusals':len(r['refusals']),'live_episodes':r['live_runtime']['episodes'],
        'court_equalities':r['courts']['equalities'],'seconds':r['seconds']},indent=2))
