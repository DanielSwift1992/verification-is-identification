#!/usr/bin/env python3
"""Recompute dynamic observations from raw SDK bitstrings, not collector scores.

Secondary Bell-frame and per-record readings never replace the frozen primary
comparison. The latter retains every shot. No network or hardware submission.
"""

import sys as _evidence_sys
from pathlib import Path as _EvidencePath
_evidence_sys.path.insert(0, str(_EvidencePath(__file__).resolve().parents[1]))
import hardware_runs as _runs
_runs.configure(required=(__name__ == "__main__"))
import argparse
from collections import Counter
from datetime import datetime
from fractions import Fraction
import hashlib
import json
import math
from pathlib import Path

FRAMES={'Phi+':(1,-1,1),'Phi-':(-1,1,1),'Psi+':(1,1,-1),'Psi-':(-1,-1,-1)}
POLICIES=('acquired','ignore_reply','invert_reply')
BASES=('XX','YY','ZZ')


def scalar(value):
    return {'fraction':str(value),'value':float(value)}


def main():
    from qiskit_ibm_runtime import RuntimeDecoder
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--input',type=_runs.input_path,required=True)
    p.add_argument('--output',type=_runs.owned,required=True)
    a=p.parse_args()
    plan=json.loads((a.input/'plan.json').read_text())
    ledger=json.loads((a.input/'ledger.json').read_text())
    collected=json.loads((a.input/'hardware-result.json').read_text())
    raw=(a.input/'raw-result.json').read_bytes()
    assert hashlib.sha256(raw).hexdigest()==collected['raw_result_sha256']
    assert ledger['job_id']==collected['job_id'] and collected['status']=='DONE'
    result=json.loads(raw,cls=RuntimeDecoder)
    assert len(result)==len(plan['order'])==9
    rows={};observations=[]
    for pub,index in zip(result,plan['order']):
        policy,basis=POLICIES[index//3],BASES[index%3]
        m=pub.metadata['circuit_metadata']
        assert (m['experiment'],m['policy'],m['basis'])==(plan['tag'],policy,basis)
        samples=list(zip(pub.data.record.get_bitstrings(),pub.data.out.get_bitstrings()))
        assert len(samples)==plan['shots']==1024
        assert all(len(r)==len(o)==2 and set(r+o)<={'0','1'} for r,o in samples)
        numerator=sum(1 if o[0]==o[1] else -1 for r,o in samples)
        by_record={}
        for key in ('00','01','10','11'):
            selected=[o for r,o in samples if r==key]
            assert selected
            n=sum(1 if o[0]==o[1] else -1 for o in selected)
            by_record[key]={'n':len(selected),'correlation':Fraction(n,len(selected))}
        rows[policy,basis]={'correlation':Fraction(numerator,len(samples)),'by_record':by_record}
        observations.append({'policy':policy,'basis':basis,'shots':len(samples),
                             'record_then_out_counts':dict(Counter(r+':'+o for r,o in samples))})
    scores={}
    for policy in POLICIES:
        c=[rows[policy,b]['correlation'] for b in BASES]
        frames={name:scalar((1+sum(s*v for s,v in zip(signs,c)))/4) for name,signs in FRAMES.items()}
        assert sum(Fraction(v['fraction']) for v in frames.values())==1
        assert float(Fraction(frames['Phi+']['fraction']))==collected['analysis']['policies'][policy]['bell_score']
        branches={}
        for key in ('00','01','10','11'):
            cc=[rows[policy,b]['by_record'][key]['correlation'] for b in BASES]
            branches[key]={'shots_by_basis':{b:rows[policy,b]['by_record'][key]['n'] for b in BASES},
                           'phi_plus_score':scalar((1+cc[0]-cc[1]+cc[2])/4)}
        scores[policy]={'correlations':{b:scalar(rows[policy,b]['correlation']) for b in BASES},
                        'bell_frame_scores':frames,'conditional_record_diagnostics':branches}
    radius=Fraction(str(plan['criteria']['f_radius']))
    exact_radius=.75*math.sqrt(2*math.log(18/plan['criteria']['alpha'])/1024)
    assert float(radius)>=exact_radius
    primary=Fraction(scores['acquired']['bell_frame_scores']['Phi+']['fraction'])
    baseline=Fraction(scores['ignore_reply']['bell_frame_scores']['Phi+']['fraction'])
    delta=primary-baseline
    timestamps={k:datetime.fromisoformat(v) for k,v in collected['metrics']['timestamps'].items()}
    report={'schema':'vi.ibm.dynamic-independent-analysis.v1','scope':'Reanalysis of actual QPU bitstrings',
            'job_id':ledger['job_id'],'backend':plan['backend'],'shots_each':1024,'observations':observations,
            'raw_result_sha256':hashlib.sha256(raw).hexdigest(),'isa_sha256':plan['qpy_sha256'],
            'primary':{'acquired':scalar(primary),'ignore_reply':scalar(baseline),'difference':scalar(delta),
                       'acquired_99pct_lower':scalar(primary-radius),
                       'difference_99pct_lower':scalar(delta-2*radius),
                       'criteria_passed':bool(primary-radius>Fraction(1,2) and delta-2*radius>0)},
            'policies':scores,'queue_seconds':(timestamps['running']-timestamps['created']).total_seconds(),
            'running_seconds':(timestamps['finished']-timestamps['running']).total_seconds(),
            'charged_free_seconds':collected['metrics']['usage']['qpu_charge_time_seconds'],
            'remaining_free_seconds':collected['usage_after']['usage_remaining_seconds'],
            'interpretation_limits':[
                'Intervals condition on independent fixed-law shots within each circuit; no drift or analyzer-bias bound.',
                'Bell-frame scores interpret one state only under the common-state and Pauli-reading contract.',
                'Per-record scores are secondary diagnostics, not covered by the stated primary confidence radius.',
                'No shots are removed from the primary analysis; small negative secondary estimates are not clipped.',
                'The three stabilizers do not determine all matrix coherences or prove separability of the baseline.']}
    a.output.parent.mkdir(parents=True,exist_ok=True)
    a.output.write_text(json.dumps(_runs.bind_receipt(report),indent=2)+'\n')
    print(json.dumps({'job_id':report['job_id'],'primary':report['primary'],
                      'inverted_psi_minus':scores['invert_reply']['bell_frame_scores']['Psi-'],
                      'output':str(a.output)},indent=2))


if __name__=='__main__':main()
