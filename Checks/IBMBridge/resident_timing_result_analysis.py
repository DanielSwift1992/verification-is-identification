#!/usr/bin/env python3
"""Analyze the returned fixed timing pilot; no cloud client and no submissions.

Counts remain exploratory. Schedule ages refer to a matched common barrier in
the provider's reported schedule, not a new measurement of physical fidelity.
"""
import hashlib
import json
import math
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
INPUT = ROOT/'private/ibm-context-timing-20260915'
OUT = ROOT/'Research/Artifacts/resident-timing-result-20260916'


def load(path):
    return json.loads(path.read_text())


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def require(value, reason):
    if not value:
        raise ValueError(reason)


def timing(row, expected):
    rows = row['schedule']['parsed']['rows']
    main = [r for r in rows if r['branch'] == 'main']
    def selected(instruction, pulse=None):
        return [r for r in main if r['instruction'] == instruction and
                (pulse is None or r['pulse'] == pulse)]
    def interval(values):
        require(values, 'Missing source-to-schedule landmark')
        return [min(r['start_dt'] for r in values),
                max(r['start_dt']+r['duration_dt'] for r in values)]
    read = interval(selected('measure_16', 'play'))
    capture = interval(selected('measure_16', 'capture'))
    # This six-program family has one explicit reset per role, a D preparation
    # via sx, and optional X on C. INIT and FINI are separate provider actions.
    landmarks = [interval(selected('reset_'+str(q)))[1] for q in (3,16,23)]
    landmarks.append(interval(selected('sx_23','play'))[1])
    if expected:
        landmarks.append(interval(selected('x_16','play'))[1])
    else:
        require(not selected('x_16'), 'C0 received an unrequested explicit X')
    end = max(landmarks)
    barriers = [set(r['start_dt'] for r in main if r['instruction']=='barrier' and
                    r['channel']=='Qubit '+str(q)) for q in (3,16,23)]
    common = sorted(t for t in set.intersection(*barriers) if end <= t < read[0])
    require(common and common[0] == end, 'No common post-preparation boundary at matched landmarks')
    origin = common[0]
    mcm = selected('measure_2_23','capture')
    return {'origin_dt':origin, 'readout_play_dt':read, 'readout_capture_dt':capture,
            'origin_to_readout_start_dt':read[0]-origin,
            'origin_to_capture_start_dt':capture[0]-origin,
            'D_mid_capture_dt':interval(mcm) if mcm else None,
            'provider_schedule_only':True}


def run():
    report = load(INPUT/'hardware-result.json')
    plan = load(INPUT/'plan.json')
    require(report['job_id']=='dakn5lgmhr3c73eah950' and report['status']=='DONE', 'Wrong pilot occurrence')
    require(digest(INPUT/'raw-result.json')==report['raw_sha256'], 'Raw result changed')
    require(digest(INPUT/'isa.qpy')==plan['qpy_sha256'], 'Submitted program changed')
    require(len(report['rows'])==len(plan['cases'])==8, 'Pilot coverage changed')
    alpha = .05
    epsilon = math.sqrt(math.log(2*8/alpha)/(2*128))
    output = []
    for index,(row,case) in enumerate(zip(report['rows'],plan['cases'])):
        require(row['name']==case['name'] and sum(row['counts'].values())==row['shots']==128,
                'Returned row or shot count differs')
        correct = sum(n for bits,n in row['counts'].items() if int(bits[1])==case['expected_C'])
        require(correct==row['C_correct'], 'Classical output bit was misread')
        p = correct/128
        entry = {'name':row['name'], 'expected_C':case['expected_C'], 'correct':correct,
                 'shots':128, 'fraction':p, 'simultaneous_interval':[max(0,p-epsilon),min(1,p+epsilon)]}
        if index < 6:
            entry['timing']=timing(row,case['expected_C'])
            entry['timing']['origin_to_readout_start_ns'] = (
                entry['timing']['origin_to_readout_start_dt']*plan['target']['dt_seconds']*1e9)
            require((entry['timing']['D_mid_capture_dt'] is None)==row['name'].startswith('idle:'),
                    'Actual intermediate measurement not distinguished')
        output.append(entry)
    zero,one = output[:3],output[3:6]
    require([r['timing']['origin_to_readout_start_dt'] for r in zero]==[500,500,507],
            'Unexpected reported C0 timing')
    require([r['timing']['origin_to_readout_start_dt'] for r in one]==[500,500,507],
            'Unexpected reported C1 timing')
    require(all(r['simultaneous_interval'][1]<.5 for r in zero), 'Cannot claim weak C0 response for all contexts')
    result = {'schema':'vi.scheduler-result-analysis.v1', 'job_id':report['job_id'], 'rows':output,
              'schedule_dt_seconds':plan['target']['dt_seconds'],
              'feedback_extra_age_ns':7*plan['target']['dt_seconds']*1e9,
              'interval_contract':{'alpha':alpha,'simultaneous_means':8,'radius':epsilon,
                  'scope':'Supplementary exploratory Hoeffding/Azuma bounds for average conditional '
                          'correct-bit probabilities in these executed shots. No IID, stationarity, '
                          'causal attribution or future fidelity assumption. Not the original acceptance test.'},
              'metrics':report['metrics'], 'source_files_sha256':{
                  str(p.relative_to(ROOT)):digest(p) for p in
                  [INPUT/'hardware-result.json',INPUT/'raw-result.json',INPUT/'plan.json',INPUT/'isa.qpy',Path(__file__)]},
              'new_jobs':0, 'physical_reset_cause_identified':False,
              'equal_reported_age_idle_and_measure_D':True,
              'equal_reported_age_all_three_contexts':False}
    OUT.mkdir(exist_ok=True)
    (OUT/'analysis.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({'rows':output,'feedback_extra_age_ns':result['feedback_extra_age_ns'],
                      'simultaneous_radius':epsilon},indent=2))


if __name__ == '__main__':
    run()
