#!/usr/bin/env python3
"""Local statistical boundary checks; no actual hardware measurements."""
import argparse
from fractions import Fraction as F
import json
from pathlib import Path
import random

from model import problem
from noisy import Evidence


def receipt(e,probe,bits,name):
    return {'episode':e.episode,'batch_id':name,'probe':probe,'shots':len(bits),
            'counts':{str(b):bits.count(b) for b in (0,1)}}


def rejects(fn):
    try: fn()
    except ValueError: return
    raise AssertionError('Expected rejection')


def new(p,episode='local',shots=128,alpha='1/100',epsilon='1/5'):
    return Evidence(p,episode=episode,alpha=alpha,epsilon=epsilon,max_shots=shots)


def checks():
    p=problem(('t',),'terminal','X')
    # Check the martingale one-step obligation at all extremal allowed rates.
    eps=F(1,5);odds=(1-eps)/eps
    for conditional_error in (F(0),eps):
        assert conditional_error*odds+(1-conditional_error)/odds<=1

    # Exact finite first-crossing probability for a true-bit stream. This
    # calculation includes every stopping time up to the specified horizon.
    margin=new(p).margin
    mass={0:F(1)}; failure=F(0)
    for _ in range(80):
        nxt={}
        for score,probability in mass.items():
            for step,weight in ((1,eps),(-1,1-eps)):
                if score+step>=margin:
                    failure+=probability*weight
                else:
                    nxt[score+step]=nxt.get(score+step,F(0))+probability*weight
        mass=nxt
    assert failure<=F(1,100)/len(p['probes'])

    e=new(p);probe=e.decision()['probe']; batch=receipt(e,probe,[0]*2,'one')
    e.acquire(batch)
    rejects(lambda:e.acquire(batch))
    bad=receipt(e,probe,[0],'wrong-episode');bad['episode']='foreign'
    rejects(lambda:e.acquire(bad))
    bad=receipt(e,probe,[0],'wrong-probe');bad['probe']='neutral:X:X'
    rejects(lambda:e.acquire(bad))
    bad=receipt(e,probe,[0],'missing-count');bad['shots']=2
    rejects(lambda:e.acquire(bad))
    rejects(lambda:new(p,epsilon='1/2'))
    rejects(lambda:new(p,alpha='0'))

    # A tie never becomes an exact acquisition just because many shots exist.
    tied=new(p,shots=128)
    tied.acquire(receipt(tied,tied.decision()['probe'],[0,1]*64,'tie'))
    assert tied.decision()['kind']=='needs_evidence' and len(tied.family())==16

    # A few early wrong replies are retained, not discarded/reset before retry.
    e=new(p)
    for i,bits in enumerate(([1]*2,[0]*8)):
        e.acquire(receipt(e,e.decision()['probe'],list(bits),str(i)))
    assert e.shots==10 and e.scores['A:Z:Z']==-6

    # Finite noisy support is shared by distinct sources: every finite binary
    # transcript has positive probability at iid error eps in (0,1/2).
    # Confidence exclusion therefore cannot mean zero-error identification.
    assert eps**16>0 and (1-eps)**16>0

    # Same records can arise from a different source and a inverted instrument.
    # Without the noise/source relation the controller can confidently err.
    untrusted=new(p)
    true_world=4  # A=X, B=I: wanted Y; forged observations emulate A=I, B=I.
    fake_world=0
    while untrusted.decision()['kind']=='probe':
        probe=untrusted.decision()['probe']
        ideal=next(q for q in p['probes'] if q['id']==probe)['replies'][fake_world]
        untrusted.acquire(receipt(untrusted,probe,[ideal]*16,str(untrusted.shots)))
    assert untrusted.decision()['action'] not in p['valid'][true_world]

    # Low marginal noise is insufficient: one latent coin flips the whole
    # episode with probability 5%. Repetition then reinforces a wrong answer.
    burst_wrong_probability=F(0)
    for common_flip,probability in ((0,F(19,20)),(1,F(1,20))):
        burst=new(p,episode=f'common-flip-{common_flip}')
        while burst.decision()['kind']=='probe':
            probe=burst.decision()['probe']
            ideal=next(q for q in p['probes'] if q['id']==probe)['replies'][true_world]
            burst.acquire(receipt(burst,probe,[ideal^common_flip]*16,str(burst.shots)))
        if burst.decision()['action'] not in p['valid'][true_world]:
            burst_wrong_probability+=probability
    assert burst_wrong_probability==F(1,20)>F(1,100)

    # Reproducible stress test with a past-dependent, bounded error probability.
    # It is simulated evidence, not a proof of coverage or a hardware noise fit.
    rng=random.Random(2026091401)
    total=errors=abstentions=shots=0
    for world in range(16):
        for trial in range(100):
            e=new(p,episode=f'sim-{world}-{trial}')
            last=0
            while e.decision()['kind']=='probe':
                probe=e.decision()['probe']
                ideal=next(q for q in p['probes'] if q['id']==probe)['replies'][world]
                bits=[]
                for _ in range(min(8,e.decision()['remaining_shots'])):
                    rate=.2 if last else .05
                    last=int(rng.random()<rate)
                    bits.append(ideal^last)
                e.acquire(receipt(e,probe,bits,str(e.shots)))
            d=e.decision();total+=1;shots+=e.shots
            if d['kind']=='act':errors+=d['action'] not in p['valid'][world]
            else:abstentions+=1
    return {'scope':'LOCAL EXACT CHECKS AND SIMULATION ONLY','margin':margin,
            'exact_80_shot_true_bit_crossing_probability':float(failure),
            'per_stream_risk_bound':float(F(1,100)/len(p['probes'])),
            'simulation':{'episodes':total,'wrong_actions':errors,'abstentions':abstentions,
                          'mean_shots':shots/total},
            'common_episode_flip_counterexample':{
                'marginal_flip_probability':'1/20','wrong_continuation_probability':str(burst_wrong_probability),
                'reason':'Low marginal error does not imply a conditional error ceiling after history and adaptive probe choice.'},
            'untrusted_instrument_counterexample':untrusted.export()}


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output',type=Path,required=True)
    args=parser.parse_args();result=checks()
    args.output.parent.mkdir(parents=True,exist_ok=True)
    args.output.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:v for k,v in result.items() if k!='untrusted_instrument_counterexample'},indent=2))
