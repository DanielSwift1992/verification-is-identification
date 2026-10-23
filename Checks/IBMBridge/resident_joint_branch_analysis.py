#!/usr/bin/env python3
"""Additive branch analysis for the already submitted common-endpoint job.

No cloud calls or sender. The original contrast is retained. h(a) always uses
the full PUB denominator. Bounds concern average conditional expectations,
not an assumed fixed IID hardware channel.
"""

import sys as _evidence_sys
from pathlib import Path as _EvidencePath
_evidence_sys.path.insert(0, str(_EvidencePath(__file__).resolve().parents[1]))
import hardware_runs as _runs
_runs.configure(required=(__name__ == "__main__"))
import argparse
from collections import Counter
import hashlib
import itertools
import json
import math
from pathlib import Path
import time

import numpy as np
from qiskit.quantum_info import Pauli

import resident_joint_confirmation as p

OUT=p.ROOT/'Research/Artifacts/resident-joint-branch-analysis-20260915'
ALPHA=.01
FAMILY=60  # 10 scores on each of 4 PUBs and 2 predeclared pooled variants.


def estimates(counts,n):
    p.s.require(type(n)is int and n>0 and sum(counts.values())==n,'Incomplete full sample')
    mass=[0]*4;signed=[0]*4
    for word,k in counts.items():
        p.s.require(type(k)is int and k>=0 and type(word)is str and len(word)==5 and
                    word[2]==' ' and set(word[:2]+word[3:])<={'0','1'},'Malformed joint count')
        a=int(word[:2],2);z=(-1)**word[3:].count('1');mass[a]+=k;signed[a]+=k*z
    scores={**{'p'+str(a):mass[a]/n for a in range(4)},
            **{'h'+str(a):signed[a]/n for a in range(4)},
            'h_non3':sum(signed[:3])/n,'w':sum(p.WEIGHTS[a]*signed[a] for a in range(4))/n}
    intervals={}
    for name,mean in scores.items():
        lo,hi=(0,1) if name.startswith('p') else (-1,1)
        radius=(hi-lo)*math.sqrt(math.log(2*FAMILY/ALPHA)/(2*n))
        intervals[name]={'center':mean,'radius':radius,'interval':[max(lo,mean-radius),min(hi,mean+radius)]}
    return {'shots':n,'counts':dict(sorted(counts.items())),'tuple_counts':mass,'signed_counts':signed,
            'scores':scores,'uncertainty':intervals}


def summarize(rows):
    p.s.require(len(rows)==4 and [r['index'] for r in rows]==list(range(4)) and
                [r['variant'] for r in rows]==list(p.ORDER),'Wrong fixed experiment rows')
    by_pub=[]
    for row in rows:
        p.s.require(row['shots']==p.SHOTS,'Wrong predeclared PUB size')
        v=estimates(row['counts'],row['shots'])
        p.s.require(abs(v['scores']['w']-row['mean'])<1e-14,'Original contrast changed')
        by_pub.append({'index':row['index'],'variant':row['variant'],**v})
    pooled={}
    for variant in ('correct','ignore'):
        counts=Counter()
        for row in by_pub:
            if row['variant']==variant:counts.update(row['counts'])
        pooled[variant]=estimates(counts,2*p.SHOTS)
    residuals={}
    for name,sign in [(f'h{a}',p.WEIGHTS[a]) for a in range(4)]+[('h_non3',1)]:
        c=pooled['correct']['uncertainty'][name];i=pooled['ignore']['uncertainty'][name]
        mean=c['center']-sign*i['center'];radius=c['radius']+i['radius']
        residuals[name]={'correct_minus_prescribed_ignore':mean,'radius':radius,
                         'interval':[max(-2,mean-radius),min(2,mean+radius)],
                         'zero_excluded':abs(mean)>radius}
    return {'per_PUB':by_pub,'pooled':pooled,'conditional_sign_residuals':residuals,
            'original_contrast':pooled['correct']['scores']['w']-pooled['ignore']['scores']['w'],
            'receiver_identified':False,
            'reason':'Even exact agreement leaves the code-1 receiver invisible to this final measurement. Confidence is not channel identification.'}


def ideal():
    q,_,source,_=p.logical('ignore');_,rho=p.expected_instrument(q)
    assert source['source_sha256']==p.read(p.ART/'plan.json')['source_sha256'], 'Current model differs from the submitted root'
    identity=np.eye(16);X=Pauli('IXII').to_matrix();Y=Pauli('YIII').to_matrix();Z=Pauli('IZII').to_matrix()
    def distribution(table):
        result=np.zeros((4,2,2))
        for a in range(4):
            r=Z@rho[a]@Z if table[a] else rho[a]
            for x,y in itertools.product((0,1),repeat=2):
                result[a,x,y]=float(np.trace((identity+(-1)**x*X)@(identity+(-1)**y*Y)@r).real/4)
        p.s.require(result.min()>-1e-12 and abs(result.sum()-1)<1e-12,'Invalid ideal distribution')
        return result
    tables={'ignore':[0,0,0,0],'correct':[0,0,0,1],'always_Z':[1,1,1,1],
            'wrong_only_at_code_1':[0,1,0,1]}
    models={}
    for name,table in tables.items():
        # The independent SDK branch interpreter checks this receiver too;
        # it is never submitted as a new hardware program here.
        request=p.joint.request(source,[[(m>>i)&1 for i in range(8)] for m in (254,239)],'exit',table)
        circuit,_=p.sdk.build(source,p.fixture(1.3,-.8)[0],request,memory='first')
        _,actual=p.expected_instrument(circuit)
        for a in range(4):
            expected=Z@rho[a]@Z if table[a] else rho[a]
            p.s.require(np.max(abs(actual[a]-expected))<1e-12,'Receiver map differs from direct conjugation')
        dist=distribution(table)
        h=[float(np.trace(X@Y@actual[a]).real) for a in range(4)]
        models[name]={'receiver':table,'h':h,'w':sum(p.WEIGHTS[a]*h[a] for a in range(4)),
                      'joint_probabilities':dist.tolist()}
    assert abs(models['always_Z']['w']+models['ignore']['w'])<1e-12
    assert models['always_Z']['w']>models['correct']['w']
    blind=np.max(abs(distribution(tables['correct'])-distribution(tables['wrong_only_at_code_1'])))
    state_difference=float(np.linalg.norm(Z@rho[1]@Z-rho[1]))
    assert blind<1e-13 and state_difference>.1
    classes={}
    for table in itertools.product((0,1),repeat=4):
        key=tuple(np.round(distribution(table).reshape(-1),12))
        classes.setdefault(key,[]).append(list(table))
    assert len(classes)==4
    symbolic=p.read(OUT/'symbolic.json')
    assert set(symbolic['exact_zero_polynomials'].values())=={'0'}
    assert set(symbolic['per_history_exact_zero_polynomials'])=={'0010','0100'}
    assert all(set(v.values())=={'0'} for v in symbolic['per_history_exact_zero_polynomials'].values())
    assert abs(symbolic['numeric_branch_mass']-float(np.trace(rho[1]).real))<1e-12
    assert abs(symbolic['numeric_state_difference_Frobenius']-state_difference)<1e-12
    return {'models':models,'observational_classes_for_16_I_Z_tables':list(classes.values()),
            'blind_branch':{'code':1,'mass':float(np.trace(rho[1]).real),
                'complete_available_distribution_residual':float(blind),'retained_state_Frobenius_difference':state_difference,
                'exact_zero_polynomials':symbolic['exact_zero_polynomials'],
                'per_history_exact_zero_polynomials':symbolic['per_history_exact_zero_polynomials']},
            'scope':'Declared source fixture and preparation. Not a characterization of the unknown device.'}


def checks():
    # Full denominator, including a=0; no successful-branch postselection.
    v=estimates({'00 00':64,'01 00':64,'10 01':64,'11 11':64},256)
    assert v['scores']=={'p0':.25,'p1':.25,'p2':.25,'p3':.25,
                          'h0':.25,'h1':.25,'h2':-.25,'h3':.25,'h_non3':.25,'w':0.}
    rows=[]
    for i,variant in enumerate(p.ORDER):
        counts={'10 01':64,'11 11':192} if variant=='ignore' else {'10 01':64,'11 10':192}
        scores=estimates(counts,256)
        rows.append({'index':i,'variant':variant,'counts':counts,'shots':256,'mean':scores['scores']['w']})
    good=summarize(rows)
    assert all(x['correct_minus_prescribed_ignore']==0 for x in good['conditional_sign_residuals'].values())
    # Always Z still passes a positive aggregate contrast, fails branch 2.
    for row in rows:
        if row['variant']=='correct':
            row['counts']={'10 00':64,'11 10':192};row['mean']=estimates(row['counts'],256)['scores']['w']
    bad=summarize(rows)
    assert bad['original_contrast']>good['original_contrast']>0
    assert bad['conditional_sign_residuals']['h2']['zero_excluded']
    assert bad['receiver_identified'] is False
    return {'full_denominator_checked':True,'always_Z_positive_contrast_not_accepted_as_identification':True,
            'branch_residual_detects_synthetic_wrong_receiver':True}


def run(result_path):
    before=time.perf_counter();OUT.mkdir(exist_ok=True)
    output={'schema':'vi.joint-branch-addendum.v1','at':p.utc(),'ideal':ideal(),'checks':checks(),
        'uncertainty_contract':{'family_size':FAMILY,'alpha':ALPHA,
            'target':'Average E[score_i | preceding records] in each fixed sequence, not an unidentified stationary channel.',
            'assumptions':'Bounded scores; fixed sample sizes and index grouping. No IID requirement. No optional-stopping extension.',
            'simultaneous_scope':'10 named scores for 4 PUBs and 2 predeclared pooled variants; residual intervals follow by interval arithmetic.',
            'signed_half_width_at_512':2*math.sqrt(math.log(2*FAMILY/ALPHA)/(2*512))},
        'new_QPU_jobs':0,'original_QPY_sha256':p.read(p.ART/'plan.json')['qpy_sha256']}
    if result_path.exists():
        hardware=p.read(result_path)
        assert hardware['status']=='DONE' and hardware['job_id']==p.read(p.ART/'submission.json')['job_id']
        raw=result_path.parent/'raw-result.json'
        assert raw.is_file() and hashlib.sha256(raw.read_bytes()).hexdigest()==hardware['raw_sha256']
        output['hardware']=summarize(hardware['rows'])
        assert abs(output['hardware']['original_contrast']-hardware['contrast'])<1e-14
        output['hardware_origin']={'job_id':hardware['job_id'],'raw_sha256':hardware['raw_sha256']}
    else:output['hardware']={'available':False,'last_status':p.read(p.ART/'status.json')}
    output['seconds']=time.perf_counter()-before;p.dump(OUT/'analysis.json',output)
    print(json.dumps(_runs.bind_receipt({'ideal':output['ideal'],'uncertainty':output['uncertainty_contract'],
                      'hardware_available':result_path.exists(),'seconds':output['seconds']}),indent=2))


if __name__=='__main__':
    cli=argparse.ArgumentParser(description=__doc__)
    cli.add_argument('--result',type=_runs.input_path,required=True,help='Result file relative to the supplied hardware-runs folder; its SHA-256 must be declared in MANIFEST.json')
    run(cli.parse_args().result)
