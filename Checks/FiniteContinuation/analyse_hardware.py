#!/usr/bin/env python3
"""Rebuild adaptive decisions from official raw SDK bits, then score holdout use.

Offline, no network. Fixture settings are inspected only AFTER the controller's
decision has been reconstructed from acquired receipts.
"""
import argparse
from collections import Counter
from datetime import datetime
from fractions import Fraction as F
import hashlib
import json
from pathlib import Path

from model import WORLDS, problem
from noisy import Evidence


def digest(path):return hashlib.sha256(path.read_bytes()).hexdigest()


def replay_acquired_prefix(directory,p,*,allow_pending=False):
    """Verify archived acquisitions and reconstruct their still-admissible family.

    p is a declared model, never a realized fixture. Pending final jobs add no
    evidence. All completed preceding results must be present and bound.
    """
    from qiskit_ibm_runtime import RuntimeDecoder
    spec=json.loads((directory/'campaign.json').read_text())
    engines={c['episode']:Evidence(p,episode=c['episode'],alpha=spec['per_episode_alpha'],
                                  epsilon=spec['assumed_conditional_probe_error_upper_bound'],
                                  max_shots=spec['max_acquisition_rounds']*spec['batch_shots'])
             for c in spec['cases']}
    jobs=[];measurements=[];validation=[];transition_counts=[];previous={};collected=None;pending=None
    plans=sorted(directory.glob('round-*/plan.json'))
    assert 0<len(plans)<=spec['max_acquisition_rounds']+1
    for round_index,planfile in enumerate(plans):
        path=planfile.parent;plan=json.loads(planfile.read_text())
        ledger=json.loads((path/'ledger.json').read_text())
        assert plan['round']==round_index and path.name==f'round-{round_index:02}'
        assert plan['kind'] in ('acquisition','validation')
        assert plan['kind']!='validation' or round_index==len(plans)-1
        assert digest(directory/'campaign.json')==plan['campaign_sha256']
        assert plan['previous_results']==previous, 'Incomplete acquired-history binding'
        assert all(digest(directory/f)==h for f,h in plan['previous_results'].items())
        before={key:e.decision() for key,e in engines.items()}
        for key,e in engines.items():
            assert e.export()==plan['decisions_before'][key], 'Plan not derived from this acquired prefix'
        if not (path/'hardware-result.json').exists():
            assert allow_pending and round_index==len(plans)-1, 'Missing completed acquisition'
            pending={'round':round_index,'job_id':ledger.get('job_id')};break
        collected=json.loads((path/'hardware-result.json').read_text())
        assert collected['status']=='DONE' and collected['kind']==plan['kind']
        assert collected['job_id']==ledger['job_id']
        assert digest(path/'raw-result.json')==collected['raw_sha256']
        previous[str((path/'hardware-result.json').relative_to(directory))]=digest(path/'hardware-result.json')
        raw=json.loads((path/'raw-result.json').read_text(),cls=RuntimeDecoder)
        assert len(raw)==len(plan['descriptors'])==len(collected['rows'])
        if plan['kind']=='acquisition':
            expected={(key,d['probe']) for key,d in before.items() if d['kind']=='probe'}
            actual=[(d['episode'],d['probe']) for d in plan['descriptors']]
            assert len(actual)==len(set(actual)) and set(actual)==expected
            assert plan['shots']==spec['batch_shots']
        else:
            expected={(key,bit) for key,d in before.items() if d['kind']=='act' for bit in (0,1)}
            actual=[(d['episode'],d['target_bit']) for d in plan['descriptors']]
            assert len(actual)==len(set(actual)) and set(actual)==expected
            assert plan['shots']==spec['validation_shots']
        for index,(pub,d,saved) in enumerate(zip(raw,plan['descriptors'],collected['rows'])):
            assert d['kind']==plan['kind'] and d['round']==round_index and d['pub']==index
            assert d['tag']==plan['tag'] and all(saved[k]==v for k,v in d.items())
            assert saved['batch_id']==collected['job_id']+':'+str(index) and saved['shots']==plan['shots']
            assert pub.metadata['circuit_metadata']==d and set(pub.data.keys())=={'c'}
            bits=pub.data.c.get_bitstrings();counts=dict(Counter(bits))
            assert len(bits)==plan['shots'] and not set(bits)-{'0','1'}
            assert counts==saved['counts']
            key=d['episode'];e=engines[key]
            if plan['kind']=='acquisition':
                assert before[key]['kind']=='probe' and before[key]['probe']==d['probe']
                receipt={'episode':key,'batch_id':collected['job_id']+':'+str(index),
                         'probe':d['probe'],'shots':len(bits),'counts':counts}
                e.acquire(receipt)
                measurements.append(receipt)
            else:
                decision=before[key]
                assert decision['kind']=='act' and decision['action']==d['action']
                assert decision['execution']==d['execution']
                correction=int(d['execution']['sign']==-1)
                correct=sum((int(bit)^correction)==d['target_bit'] for bit in bits)
                validation.append({'episode':key,'target_bit':d['target_bit'],
                                   'chosen_action':d['action'],'shots':len(bits),'raw_counts':counts,
                                   'correct':correct,'frequency':correct/len(bits)})
        stamps={k:datetime.fromisoformat(v) for k,v in collected['metrics']['timestamps'].items()}
        jobs.append({'id':collected['job_id'],'kind':plan['kind'],'round':plan['round'],
                     'shots':len(raw)*plan['shots'],'raw_sha256':collected['raw_sha256'],
                     'created_at':stamps['created'].isoformat(),
                     'queue_seconds':(stamps['running']-stamps['created']).total_seconds(),
                     'running_seconds':(stamps['finished']-stamps['running']).total_seconds(),
                     'free_charge_seconds':collected['metrics']['usage']['qpu_charge_time_seconds']})
        transition_counts.append({'round':plan['round'],'kind':plan['kind'],
                                  'next':dict(Counter(e.decision().get('probe',e.decision()['kind']) for e in engines.values()))})
    return {'spec':spec,'engines':engines,'jobs':jobs,'measurements':measurements,
            'validation':validation,'round_transitions':transition_counts,'last_result':collected,
            'pending':pending,'verified_results':previous}


def analyse(directory):
    p=problem(('t',),'terminal','X');replay=replay_acquired_prefix(directory,p)
    spec=replay['spec'];engines=replay['engines'];jobs=replay['jobs']
    measurements=replay['measurements'];validation=replay['validation']
    transition_counts=replay['round_transitions'];collected=replay['last_result']
    assert jobs and jobs[-1]['kind']=='validation','No completed post-acquisition validation'
    episodes=[]
    for case in spec['cases']:
        key=case['episode'];e=engines[key];decision=e.decision()
        # The actual fixture is only used here, after replay of the data-driven
        # choice. Runtime selection above receives no realized-world index.
        world=WORLDS.index(tuple(case['fixture']))
        probe_errors=0
        for row in measurements:
            if row['episode']==key:
                ideal=next(q for q in p['probes'] if q['id']==row['probe'])['replies'][world]
                probe_errors+=row['counts'].get(str(1-ideal),0)
        episodes.append({'episode':key,'fixture':case['fixture'],'decision':decision,
                         'logical_action_valid':decision.get('action') in p['valid'][world],
                         'acquisition_errors_relative_to_configured_ideal':probe_errors,
                         'retained_source_count':len(e.family())})
    correct=sum(r['correct'] for r in validation);n=sum(r['shots'] for r in validation)
    result={'schema':'vi.finite-adaptive-hardware-analysis.v1','scope':'Actual IBM counts, replayed offline',
            'backend':spec['backend'],'physical_wire':spec['wire'],'jobs':jobs,
            'round_transitions':transition_counts,'measurements':measurements,
            'episodes':episodes,'validation':validation,
            'summary':{'episodes':len(episodes),'resolved':sum(e['decision']['kind']=='act' for e in episodes),
                       'correct_logical_actions':sum(e['logical_action_valid'] for e in episodes),
                       'acquisition_shots':sum(row['shots'] for row in measurements),
                       'acquisition_errors':sum(e['acquisition_errors_relative_to_configured_ideal'] for e in episodes),
                       'validation_shots':n,'validation_correct':correct,
                       'validation_success_fraction':str(F(correct,n)),
                       'validation_success_frequency':correct/n,
                       'minimum_individual_validation_frequency':min(r['frequency'] for r in validation),
                       'all_32_descriptive_validation_checks_pass':len(validation)==32 and all(r['frequency']>=.90 for r in validation),
                       'charged_free_seconds':sum(j['free_charge_seconds'] for j in jobs),
                       'free_remaining_seconds':collected['usage_after']['usage_remaining_seconds']},
            'risk_scope':{'family_alpha':spec['family_alpha'],'assumed_error_upper_bound':spec['assumed_conditional_probe_error_upper_bound'],
                          'noise_bound_independently_established':False,
                          'claim':'Uniform stopping-time guarantee for logical selection IF the declared conditional acquisition-error bound holds; no unconditional physical accuracy certificate.'},
            'limitations':['Deliberately configured Pauli modules; no unknown hardware process tomography.',
                           'Two validation inputs per configuration; not arbitrary-input channel certification.',
                           'Choices made on the host between QPU jobs, not autonomous in-QPU learning.',
                           'Ordinary adaptive frame tracking can make the same logical choices.']}
    return result


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--input',required=True,type=Path)
    parser.add_argument('--output',required=True,type=Path)
    args=parser.parse_args();result=analyse(args.input)
    args.output.parent.mkdir(parents=True,exist_ok=True)
    args.output.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({'summary':result['summary'],'jobs':result['jobs'],'round_transitions':result['round_transitions']},indent=2))
