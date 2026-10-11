#!/usr/bin/env python3
"""Synthetic archive and refusal checks; no acquisition or QPU submission."""
import argparse
import json
from pathlib import Path
import shutil
import subprocess
from tempfile import TemporaryDirectory

from analyse_hardware import replay_acquired_prefix
from analyse_hardware_checks import fixture,write
from build_from_source import HERE,ROOT,run
from certify_acquisition import apply_evidence,certify
from noisy import Evidence


def checks():
    refused=[]
    with TemporaryDirectory(prefix='vi-acquisition-application-') as tmp:
        base=Path(tmp);archive=base/'archive';archive.mkdir()
        fixture(archive,acquisition_errors=2)
        out=base/'proof'
        report=certify(archive,out,require_real_campaign=False)
        assert report['scope']=='Explicitly synthetic archive test'
        assert report['summary']['conditional_continuations']==16
        assert report['summary']['acquired_shots']==512
        assert {len(r['proposal']['family']) for r in report['episodes']}=={4}
        assert {r['proof']['verdict']['judged'] for r in report['episodes']}=={5}
        assert all(not r['proof']['verdict']['refusals'] for r in report['episodes'])
        assert {tuple(sorted(b['counts'].values())) for r in report['episodes']
                for b in r['evidence']['batches']}=={(2,14)}
        source=json.loads((out/'source-reading.json').read_text())
        p=source['model'];hashes=source['source_sha256']

        # Actual completed prefixes: a pending job contributes no additional
        # counts. Future directories are removed only inside synthetic copies.
        progression=[]
        for pending_round,expected_family,expected_shots in [(0,16,0),(1,8,16),(2,4,32)]:
            prefix=base/f'prefix-{pending_round}';shutil.copytree(archive,prefix)
            for i in range(pending_round+1,3):shutil.rmtree(prefix/f'round-{i:02}')
            for name in ('hardware-result.json','raw-result.json'):
                (prefix/f'round-{pending_round:02}'/name).unlink()
            replay=replay_acquired_prefix(prefix,p,allow_pending=True)
            assert replay['pending']['round']==pending_round
            assert {len(e.family()) for e in replay['engines'].values()}=={expected_family}
            assert {e.shots for e in replay['engines'].values()}=={expected_shots}
            if pending_round<2:
                r=apply_evidence(replay['engines']['0'],base/f'unresolved-{pending_round}',hashes)
                assert r['outcome']=='needs_evidence' and 'proposal' not in r
                assert not (base/f'unresolved-{pending_round}').exists()
            progression.append({'completed_rounds':pending_round,'shots_per_episode':expected_shots,
                                'retained_sources':expected_family,
                                'decision':replay['engines']['0'].decision()['kind']})

        # A tied finite budget is not converted into an exact bit or action.
        tied=Evidence(p,episode='tied',alpha='1/1600',epsilon='1/5',max_shots=16)
        tied.acquire({'episode':'tied','batch_id':'synthetic-tie','probe':tied.decision()['probe'],
                      'shots':16,'counts':{'0':8,'1':8}})
        tied_result=apply_evidence(tied,base/'tied',hashes)
        assert tied_result['outcome']=='needs_evidence' and 'proposal' not in tied_result
        # Deliberately inject the empty boundary; this is not a claim that
        # this particular contact policy necessarily detects all source drift.
        empty=Evidence(p,episode='empty',alpha='1/1600',epsilon='1/5',max_shots=16)
        empty.excluded[next(iter(empty.excluded))]={0,1}
        empty_result=apply_evidence(empty,base/'empty',hashes)
        assert empty_result['outcome']=='model_conflict' and 'proposal' not in empty_result

        original=report['episodes'][0]['proposal']
        def reject_proposal(name,mutate):
            value=json.loads(json.dumps(original));mutate(value)
            proposal=base/'rejected.json';write(proposal,value)
            try:run(['node',HERE/'court_bridge.js','family',proposal,base/'rejected.swift'])
            except subprocess.CalledProcessError:refused.append(name);return
            raise AssertionError('Accepted '+name)
        reject_proposal('empty family cannot exploit vacuous implication',lambda d:d.update(family=[]))
        reject_proposal('row outside the current source',lambda d:d['family'].append(16))
        reject_proposal('duplicate row in the family',lambda d:d['family'].append(d['family'][-1]))
        reject_proposal('question changed to Z',lambda d:d['request'].update(axis='Z'))
        reject_proposal('different native read under an unchanged label',lambda d:d['execution'].update(read='Z'))
        def wrong_answer(d):
            other=next(a for a in p['actions'] if a!=d['action'])
            d.update(action=other,execution=p['actions'][other])
        reject_proposal('one wrong action for the retained family',wrong_answer)
        def mixed_family(d):
            other=next(i for i,row in enumerate(p['valid']) if d['action'] not in row)
            d['family']=sorted(d['family']+[other])
        reject_proposal('correct only on a subset of retained rows',mixed_family)

        good=(out/'episode-00'/'Applications.swift').read_text()
        bad=good.replace('public typealias SharedContinuation = Paired<QuantumMeasureXQuestion, QBit0>',
                         'public typealias SharedContinuation = Paired<QuantumMeasureXQuestion, QBit1>')
        assert bad!=good
        file=base/'bad-native.swift';file.write_text(bad)
        r=subprocess.run([str(ROOT/'.build/arm64-apple-macosx/debug/Tools'),'judge','where',str(file)],
                         capture_output=True,text=True,timeout=30)
        assert r.returncode==1 and sum(line.startswith('✗ ') for line in r.stdout.splitlines())==4
        refused.append('native court rejects the same changed common answer on four rows')

        # The public archive entry reconstructs C; neither a saved family nor
        # a saved producer decision may override the replayed acquisitions.
        def reject_archive(name,rel,mutate):
            file=archive/rel;original=file.read_bytes();value=json.loads(original)
            mutate(value);write(file,value)
            try:
                try:replay_acquired_prefix(archive,p,allow_pending=True)
                except (AssertionError,ValueError,KeyError):refused.append(name);return
                raise AssertionError('Accepted '+name)
            finally:file.write_bytes(original)
        reject_archive('producer-selected subset cannot replace replayed family','round-02/plan.json',
                       lambda d:d['decisions_before']['0']['decision'].update(family=[0]))
        reject_archive('detached prior acquisition','round-01/plan.json',lambda d:d['previous_results'].clear())
        reject_archive('changed reported counts without matching raw shots','round-02/hardware-result.json',
                       lambda d:d['rows'][0].update(counts={'0':128,'1':128}))
        try:certify(archive,out,require_real_campaign=False)
        except ValueError:refused.append('published output cannot silently be overwritten')
        else:raise AssertionError('Published output overwritten')

    return {'scope':'Synthetic acquisitions only; zero QPU jobs',
            'errors_per_16_shot_batch':2,'progression':progression,
            'conditional_actions':16,'sources_per_action':4,'equalities_per_action':5,
            'js_native_equalities_total':80,'refused':refused,
            'tied_budget':'needs_evidence','empty_family':'model_conflict',
            'real_source_membership_or_noise_assumption_proved':False}


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--output',type=Path)
    args=parser.parse_args();result=checks()
    if args.output:
        args.output.parent.mkdir(parents=True,exist_ok=True);write(args.output,result)
    print(json.dumps(result,indent=2))
