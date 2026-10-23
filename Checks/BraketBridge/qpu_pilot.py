#!/usr/bin/env python3
"""Bounded three-task hardware pilot; explicit prepare/submit/collect stages.

Uses existing AWS credentials and S3 bucket only. No bucket/IAM creation,
reservation, hybrid job, paid simulator, or automatic new-task retry.
Ordinary local execute.py remains cloud-free. A persisted clientToken is
reused after an uncertain submission; polling can never create a task.
"""

import sys as _evidence_sys
from pathlib import Path as _EvidencePath
_evidence_sys.path.insert(0, str(_EvidencePath(__file__).resolve().parents[1]))
import hardware_runs as _runs
_runs.configure(required=(__name__ == "__main__"))
import argparse
from collections import Counter
from datetime import datetime, timezone
from decimal import Decimal
import fcntl
import hashlib
from importlib import metadata
import json
import math
from pathlib import Path
import sys

from build import HERE, ROOT, run_bounded
from execute import terminal_job, decode_result
from prepare import prepare, snapshot, cache_key
from runtime import require, load_json, write_json, decode_runtime

DEVICE = 'arn:aws:braket:us-west-1::device/qpu/rigetti/Cepheus-1-108Q'
REGION = 'us-west-1'
TASK_PRICE = Decimal('0.30')
SHOT_PRICE = Decimal('0.000425')
SHOTS = 256
CASES = [('AcquireZ', 'plus', 0), ('AcquireZ', 'minus', 1), ('AcquireY', 'plus_i', 1)]
PRICE_DATE = '2026-09-14'
PRICE_SOURCE = 'https://aws.amazon.com/braket/pricing/'


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def utc():
    return datetime.now(timezone.utc).isoformat()


def clients(profile):
    import boto3
    from botocore.config import Config
    config = Config(connect_timeout=5, read_timeout=15, retries={'max_attempts': 0})
    session = boto3.Session(profile_name=profile, region_name=REGION)
    return (session.client('braket', config=config), session.client('s3', config=config),
            session.client('sts', config=config))


def cost():
    return TASK_PRICE + SHOTS*SHOT_PRICE


def validate_budget(budget):
    # Leave >= $1 for ancillary S3 requests/storage and tax. No bill is inferred
    # from this reserve; only the three listed on-demand QPU calls are emitted.
    require(budget.is_finite() and Decimal('0') < budget <= Decimal('5'), 'pilot cap must be at most $5')
    require(len(CASES)*cost() + Decimal('1') <= budget, 'three tasks plus reserve exceed authorization')


def capabilities(client):
    device = client.get_device(deviceArn=DEVICE)
    require(device['deviceStatus'] == 'ONLINE', 'selected QPU is not online')
    cap = json.loads(device['deviceCapabilities'])
    action = cap['action']['braket.ir.openqasm.program']
    require({'h','s','x','cnot','cz'} <= set(action['supportedOperations']), 'source operations unavailable')
    require(cap['paradigm']['qubitCount'] >= 6 and not action['requiresAllQubitsMeasurement'], 'unsupported qubits/readout')
    low, high = cap['service']['shotsRange']
    require(low <= SHOTS <= high, 'unsupported shot count')
    return device


def prepare_pilot(directory, profile, budget):
    validate_budget(budget)
    require(not directory.exists(), 'pilot directory must be new')
    documents, receipt = prepare(_runs.prepared('braket-prepared'))
    braket, s3, sts = clients(profile)
    device = capabilities(braket)
    account = sts.get_caller_identity()['Account']
    bucket = 'amazon-braket-'+REGION+'-'+account
    s3.head_bucket(Bucket=bucket, ExpectedBucketOwner=account)
    require(s3.get_bucket_location(Bucket=bucket)['LocationConstraint'] == REGION, 'result bucket region differs')
    cases = []
    plans = {p['name']:p for p in documents['continuations.json']['plans']}
    for name, state, expected in CASES:
        job, descriptor, request = terminal_job(documents, name, state, SHOTS)
        cases.append({'job':job, 'descriptor':descriptor, 'request':request, 'input':state,
                      'expected_bit':expected, 'before_execution':plans[request['before']]['execution']})
    directory.mkdir(parents=True)
    write_json(directory/'local-jobs.json', _runs.bind_receipt({'schema':'vi.braket.jobs.v1','jobs':[c['job'] for c in cases]}, destination=directory/'local-jobs.json'))
    local = run_bounded([sys.executable,HERE/'runner.py','--jobs',directory/'local-jobs.json',
                         '--output',directory/'local-results.json'],90)
    (directory/'local.log').write_text(local.stdout)
    require(local.returncode == 0, 'local semantic check failed; hardware plan not sealed')
    local_results = {r['id']:r for r in load_json(directory/'local-results.json')['jobs']}
    for c in cases:
        decoded = decode_result(c['job'], c['descriptor'], local_results[c['job']['id']])
        require(decoded['answer_counts'].get(str(c['expected_bit']),0) == SHOTS,
                'local output disagrees with the independently fixed ideal preparation')
    plan = {'schema':'vi.braket.qpu-pilot.v1', 'prepared_at':utc(), 'profile':profile,
            'device':DEVICE, 'bucket':bucket, 'account':account,
            'prefix':'vi-pilot/'+directory.name, 'budget_usd':str(budget),
            'per_task_usd':str(cost()), 'planned_qpu_usd':str(len(cases)*cost()),
            'price_checked_on':PRICE_DATE, 'price_source':PRICE_SOURCE,
            'checked_build':receipt, 'cases':cases,
            'implementation_sha256':{n:sha(HERE/n) for n in ('qpu_pilot.py','execute.py','runtime.py')},
            'analysis':{'policy':'three fixed tasks, no retry-until-pass; report all outcomes',
                        'nominal_family_alpha':0.01, 'accuracy_events':3,
                        'interval_assumption':'Hoeffding intervals assume independent shots of a stable law; not device-certified',
                        'before_comparison':'same acquired samples, with the extra contact ignored in postprocessing; not a cheaper hardware run'}}
    write_json(directory/'device-before.json', _runs.bind_receipt(device, destination=directory/'device-before.json'))
    write_json(directory/'plan.json', _runs.bind_receipt(plan, destination=directory/'plan.json'))
    write_json(directory/'seal.json', _runs.bind_receipt({'plan_sha256':sha(directory/'plan.json')}, destination=directory/'seal.json'))
    write_json(directory/'ledger.json', _runs.bind_receipt({'schema':'vi.braket.qpu-ledger.v1','entries':{}}, destination=directory/'ledger.json'))
    print(json.dumps(_runs.bind_receipt({'prepared':str(directory),'tasks':len(cases),'qpu_usd':str(len(cases)*cost()),'budget_usd':str(budget)})))


def read_plan(directory, current=True):
    require(load_json(directory/'seal.json')['plan_sha256'] == sha(directory/'plan.json'), 'pilot plan changed')
    plan = load_json(directory/'plan.json')
    validate_budget(Decimal(plan['budget_usd']))
    require(plan['device'] == DEVICE and plan['per_task_usd'] == str(cost()) and len(plan['cases']) == 3,
            'pilot device/cost/scope changed')
    require(all(sha(HERE/n) == value for n,value in plan['implementation_sha256'].items()), 'pilot implementation changed')
    if current:
        require(cache_key(snapshot()) == plan['checked_build']['key'], 'current VI source changed after preparation')
    return plan


def submit(directory):
    from braket.ir.openqasm import Program
    plan = read_plan(directory)
    braket, _, sts = clients(plan['profile'])
    require(sts.get_caller_identity()['Account'] == plan['account'], 'AWS account changed')
    capabilities(braket)
    with (directory/'submission.lock').open('a') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        ledger = load_json(directory/'ledger.json')
        for case in plan['cases']:
            job = case['job']; key = job['id']
            entry = ledger['entries'].get(key)
            if entry and entry.get('task_arn'):
                continue
            if entry is None:
                require((len(ledger['entries'])+1)*cost()+Decimal('1') <= Decimal(plan['budget_usd']), 'budget exhausted')
                entry = {'client_token':key, 'reserved_qpu_usd':str(cost()), 'status':'submitting', 'started_at':utc()}
                ledger['entries'][key] = entry
            # Write the token/reservation before the network request. A resumed
            # attempt uses exactly the same body and token, never a new task ID.
            write_json(directory/'ledger.json', _runs.bind_receipt(ledger, destination=directory/'ledger.json'))
            try:
                reply = braket.create_quantum_task(
                    clientToken=key, deviceArn=DEVICE, action=Program(source=job['qasm']).json(),
                    shots=job['shots'], outputS3Bucket=plan['bucket'], outputS3KeyPrefix=plan['prefix']+'/'+key)
            except Exception as error:
                entry['status']='submission_unconfirmed'
                entry['error_type']=type(error).__name__
                if hasattr(error,'response'):
                    entry['error']=error.response.get('Error',{})
                write_json(directory/'ledger.json', _runs.bind_receipt(ledger, destination=directory/'ledger.json'))
                raise
            entry.update({'task_arn':reply['quantumTaskArn'],'status':'submitted','submitted_at':utc()})
            write_json(directory/'ledger.json', _runs.bind_receipt(ledger, destination=directory/'ledger.json'))
            print(json.dumps(_runs.bind_receipt({'case':case['request']['name']+'/'+case['input'], 'task_arn':entry['task_arn'],
                              'reserved_qpu_usd':str(len(ledger['entries'])*cost())})), flush=True)


def collect(directory):
    from braket.tasks import GateModelQuantumTaskResult
    plan = read_plan(directory, current=False)
    braket, s3, _ = clients(plan['profile'])
    ledger = load_json(directory/'ledger.json')
    summaries = []
    for case in plan['cases']:
        job=case['job']; key=job['id']; entry=ledger['entries'].get(key,{})
        if not entry.get('task_arn'):
            summaries.append({'case':case['request']['name']+'/'+case['input'],'status':entry.get('status','not_submitted')})
            continue
        task = braket.get_quantum_task(quantumTaskArn=entry['task_arn'])
        # SDK metadata contains datetimes; persist their ISO-compatible string
        # representation while preserving the raw result body separately.
        write_json(directory/(key+'-task.json'), _runs.bind_receipt(json.loads(json.dumps(task,default=str)), destination=directory/(key+'-task.json')))
        require(task['quantumTaskArn'] == entry['task_arn'] and task['deviceArn'] == DEVICE
                and task['shots'] == job['shots'] and task['outputS3Bucket'] == plan['bucket'], 'task/source metadata mismatch')
        item={'case':case['request']['name']+'/'+case['input'], 'status':task['status']}
        if task['status'] == 'FAILED': item['failure_reason']=task.get('failureReason')
        if task['status'] != 'COMPLETED':
            summaries.append(item); continue
        require(task['outputS3Directory'].startswith(plan['prefix']+'/'+key+'/'), 'wrong result occurrence prefix')
        path=directory/(key+'-raw.json')
        if not path.exists():
            obj=s3.get_object(Bucket=plan['bucket'],Key=task['outputS3Directory']+'/results.json',ExpectedBucketOwner=plan['account'])
            body=obj['Body'].read(8*1024*1024+1)
            require(len(body) <= 8*1024*1024, 'unexpectedly large pilot result')
            path.write_bytes(body)
        result=GateModelQuantumTaskResult.from_string(path.read_text())
        require(result.task_metadata.id == entry['task_arn'] and result.task_metadata.deviceId == DEVICE
                and result.task_metadata.shots == job['shots'], 'result belongs to another cloud task')
        require(result.additional_metadata.action.source == job['qasm'], 'returned action differs from submitted source')
        normalized={'id':key,'shots':result.task_metadata.shots,'values':[],
                    'measured_qubits':result.measured_qubits,'measurement_counts':dict(result.measurement_counts)}
        decoded=decode_result(job,case['descriptor'],normalized)
        correct=decoded['answer_counts'].get(str(case['expected_bit']),0)
        accuracy=correct/SHOTS
        epsilon=math.sqrt(math.log(2*3/0.01)/(2*SHOTS))
        item.update({'expected_bit':case['expected_bit'],'observed':decoded,
                     'correct_count':correct,'accuracy':accuracy,
                     'nominal_simultaneous_interval':[max(0,accuracy-epsilon),min(1,accuracy+epsilon)]})
        if case['request']['action'] == 'acquire':
            wires=normalized['measured_qubits']; d=wires.index(case['descriptor']['data_wire']); r=wires.index(case['descriptor']['record_wire'])
            before=Counter()
            for bits,count in normalized['measurement_counts'].items():
                before[str(decode_runtime(case['before_execution'],bits[r],int(bits[d])))] += count
            item['same_samples_without_extra_record']=dict(before)
            item['observed_accuracy_gain']=accuracy-before.get(str(case['expected_bit']),0)/SHOTS
        summaries.append(item)
    report={'schema':'vi.braket.qpu-pilot-results.v1','collected_at':utc(),'device':DEVICE,
            'reserved_qpu_usd':str(len(ledger['entries'])*cost()),'analysis':plan['analysis'],
            'cases':summaries, 'all_completed':all(c['status']=='COMPLETED' for c in summaries),
            'scope':'actual QPU shots; counts are observations, not a proof of ideal hardware or quantum advantage'}
    write_json(directory/'hardware-result.json', _runs.bind_receipt(report, destination=directory/'hardware-result.json'))
    print(json.dumps(_runs.bind_receipt(report),indent=2))


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('stage',choices=('prepare','submit','collect'))
    p.add_argument('--directory',type=_runs.owned,required=True)
    p.add_argument('--profile',default='braket-user')
    p.add_argument('--budget-usd',type=Decimal)
    a=p.parse_args(); directory=a.directory.resolve()
    if a.stage == 'prepare':
        require(a.budget_usd is not None, 'prepare requires an authorized budget')
        prepare_pilot(directory,a.profile,a.budget_usd)
    elif a.stage == 'submit': submit(directory)
    else: collect(directory)


if __name__ == '__main__': main()
