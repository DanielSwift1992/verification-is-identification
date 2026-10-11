#!/usr/bin/env python3
"""Descriptive analysis of the predeclared 32-PUB returning-attempt pilot.

No postselection, repeated sampling, remote call, or IID confidence claim.
The raw per-shot return remains in the private frozen artifact.
"""
from collections import Counter
from fractions import Fraction
import hashlib
import json
from pathlib import Path

ROOT=Path(__file__).resolve().parents[2]
ART=ROOT/'Research/Artifacts/returning-attempt-20260916/hardware'
PRIVATE=ROOT/'private/ibm-returning-attempt-20260916'


def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()


def run():
    plan=json.loads((ART/'plan.json').read_text())
    status=json.loads((ART/'status.json').read_text())
    assert status['status']=='DONE' and len(status['rows'])==len(plan['PUBs'])==32
    assert sha(PRIVATE/'raw-result.json')==status['raw_sha256']
    assert sha(PRIVATE/'isa.qpy')==plan['qpy_sha256']
    seen=set();individual=[]
    for row,planned in zip(status['rows'],plan['PUBs']):
        for key in ('tag','variant','law_a','law_b','basis','ideal_sign','path','final_layout'):
            assert row[key]==planned[key]
        key=(row['law_a'],row['law_b'],row['basis'],row['variant'])
        assert key not in seen;seen.add(key)
        assert sum(row['counts'].values())==row['shots']==32
        even=0;reply_agreement=0
        for record,count in row['counts'].items():
            reply,witness=record.split(' ')
            assert len(witness)==2 and set(witness)<=set('01') and count>0
            even+=count*(int(witness,2).bit_count()%2==0)
            if row['variant']=='echo':assert reply==''
            else:
                assert len(reply)==2 and set(reply)<=set('01')
                reply_agreement+=count*(int(reply,2)==row['law_b']+2*(row['law_a']^row['law_b']))
        assert even==row['even']
        if row['variant']!='echo':assert reply_agreement==row['ideal_reply_agreement']
        mean=Fraction(2*even,32)-1
        assert float(mean)==row['parity_expectation']
        individual.append({k:row[k] for k in ('law_a','law_b','variant','basis','shots','even','ideal_sign')}
                          | {'observed_mean':str(mean),'predicted_sign_seen':mean*row['ideal_sign']>0})
    groups=[]
    for a in (0,1):
        for variant in ('correct','omit_return','ignore_learning','echo'):
            row={'law_a':a,'variant':variant}
            chosen=[r for r in status['rows'] if r['law_a']==a and r['variant']==variant]
            for basis in ('XZ','ZX'):
                xs=[r for r in chosen if r['basis']==basis]
                n=sum(r['shots'] for r in xs);even=sum(r['even'] for r in xs)
                row[basis]={'even':even,'shots':n,'mean':str(Fraction(2*even,n)-1)}
            row['reply_agreement']=(None if variant=='echo' else
                {'correct':sum(r['ideal_reply_agreement'] for r in chosen),'shots':128})
            groups.append(row)
    def mean(variant,basis,a=1):
        return Fraction(next(g for g in groups if g['law_a']==a and g['variant']==variant)[basis]['mean'])
    contrasts={'correct_minus_omit_return_ZX_a1':str(mean('correct','ZX')-mean('omit_return','ZX')),
               'correct_minus_ignore_learning_XZ_a1':str(mean('correct','XZ')-mean('ignore_learning','XZ')),
               'correct_minus_ignore_learning_ZX_a1':str(mean('correct','ZX')-mean('ignore_learning','ZX'))}
    overall=[]
    for variant in ('correct','omit_return','ignore_learning','echo'):
        xs=[r for r in status['rows'] if r['variant']==variant]
        overall.append({'variant':variant,'same_parity':sum(r['even'] for r in xs),'shots':256,
                        'average_unsigned_target_correlation':str(Fraction(sum(2*r['even']-32 for r in xs),256))})
    out={'schema':'vi.returning-attempt-result-analysis.v1','job_id':status['job_id'],
         'source_status_sha256':sha(ART/'status.json'),'source_plan_sha256':sha(ART/'plan.json'),
         'raw_result_sha256':status['raw_sha256'],'QPY_sha256':plan['qpy_sha256'],
         'all_32_PUBs_accounted_for':True,'total_shots':1024,
         'individual':individual,'by_law_a_and_variant':groups,'predeclared_contrasts':contrasts,
         'overall_descriptive':overall,'point_estimate_sign_matches':sum(r['predicted_sign_seen'] for r in individual),
         'metrics':status['metrics'],'free_seconds_after':status['free_seconds_after'],
         'scope':'Point estimates from every shot, no postselection. Distinct variants have different depth, '
                 'feedforward and output layouts. Descriptive contrasts, not process tomography, '
                 'IID guarantee, demonstrated entanglement, isolated error cause or advantage of learning over echo.'}
    (ART/'analysis.json').write_text(json.dumps(out,indent=2)+'\n')
    print(json.dumps({'groups':groups,'contrasts':contrasts,'all_predicted_signs':out['point_estimate_sign_matches'],
                      'metrics':out['metrics'],'overall':overall},indent=2))


if __name__=='__main__':run()
