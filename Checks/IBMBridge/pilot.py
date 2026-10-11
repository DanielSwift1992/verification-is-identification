#!/usr/bin/env python3
"""Fixed three-case pilot on IBM Open. No paid instance or automatic retry.

The existing checked VI producer/decoder is reused. Qiskit changes the circuit
representation and hardware layout, not the meaning of the acquired record.
"""
import argparse
from collections import Counter
from datetime import datetime, timezone
import fcntl
import hashlib
import importlib.metadata
import io
import json
from pathlib import Path
import sys
import uuid

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
BRIDGE = ROOT / 'Checks/BraketBridge'
sys.path.insert(0, str(BRIDGE))
from execute import terminal_job, decode_result
from prepare import prepare
from runtime import require, load_json, write_json, decode_runtime

CASES = (('AcquireZ', 'plus', 0), ('AcquireZ', 'minus', 1), ('AcquireY', 'plus_i', 1))
SHOTS = 256
MAX_SECONDS = 30
KEY = Path.home() / '.config/vi/ibm-open-api-key'
CONFIG = Path.home() / '.config/vi/ibm-open.json'


def sha(data):
    return hashlib.sha256(data).hexdigest()


def utc():
    return datetime.now(timezone.utc).isoformat()


def versions():
    return {x: importlib.metadata.version(x) for x in ('qiskit', 'qiskit-ibm-runtime', 'qiskit-aer')}


def implementation():
    return {str(p.relative_to(ROOT)): sha(p.read_bytes()) for p in
            (Path(__file__), BRIDGE/'execute.py', BRIDGE/'runtime.py', BRIDGE/'prepare.py')}


def service_open():
    from qiskit_ibm_runtime import QiskitRuntimeService
    require(KEY.is_file() and KEY.stat().st_mode & 0o077 == 0, 'key missing or not owner-only')
    cfg = load_json(CONFIG)
    service = QiskitRuntimeService(channel='ibm_quantum_platform', token=KEY.read_text().strip(),
                                  instance=cfg['crn'])
    instances = service.instances()
    selected = [i for i in instances if i['crn'] == cfg['crn']]
    require(len(selected) == 1 and selected[0]['plan'] == 'open'
            and selected[0].get('pricing_type') == 'free', 'refusing non-free/non-Open instance')
    require(service.active_instance() == cfg['crn'], 'wrong active instance')
    return service


def lower(job, descriptor):
    from qiskit import qasm3
    require(sha(job['qasm'].encode()) == descriptor['qasm_sha256'], 'source/decoder changed')
    # cnot is the Braket spelling; cx is the OpenQASM standard gate name.
    source = job['qasm'].replace('OPENQASM 3.0;', 'OPENQASM 3.0;\ninclude "stdgates.inc";')
    source = source.replace('cnot ', 'cx ')
    circuit = qasm3.loads(source)
    require(circuit.num_qubits == 6 and len(circuit.cregs) == 1
            and circuit.cregs[0].name == 'out', 'wrong source registers')
    measurements = {}
    for ins in circuit.data:
        if ins.operation.name == 'measure':
            c = circuit.find_bit(ins.clbits[0]).index
            require(c not in measurements, 'repeated measurement destination')
            measurements[c] = circuit.find_bit(ins.qubits[0]).index
    require([measurements[i] for i in range(circuit.num_clbits)] == descriptor['measured_wires'],
            'source measurement order differs from decoder')
    circuit.metadata = {'vi_case_id': job['id'], 'vi_source_sha256': descriptor['qasm_sha256']}
    return circuit


def signature(circuit):
    return {'qubits': circuit.num_qubits, 'clbits': circuit.num_clbits,
            'cregs': [(r.name, len(r)) for r in circuit.cregs], 'metadata': circuit.metadata,
            'global_phase': float(circuit.global_phase),
            'instructions': [(i.operation.name, [float(p) for p in i.operation.params],
                              [circuit.find_bit(q).index for q in i.qubits],
                              [circuit.find_bit(c).index for c in i.clbits]) for i in circuit.data]}


def compact_active(circuit):
    """For ideal local validation only: discard unused hardware wire labels."""
    from qiskit import QuantumCircuit
    active = sorted({circuit.find_bit(q).index for ins in circuit.data for q in ins.qubits})
    remap = {old:new for new,old in enumerate(active)}
    compact = QuantumCircuit(len(active))
    for reg in circuit.cregs:
        compact.add_register(reg)
    compact.global_phase = circuit.global_phase
    compact.metadata = circuit.metadata
    for ins in circuit.data:
        compact.append(ins.operation,[remap[circuit.find_bit(q).index] for q in ins.qubits],
                       [circuit.find_bit(c).index for c in ins.clbits])
    return compact


def normalize(case, counts):
    width = len(case['descriptor']['measured_wires'])
    require(isinstance(counts, dict), 'counts are missing')
    require(all(type(k) is str and len(k) == width and set(k) <= {'0','1'}
                and type(v) is int and v >= 0 for k,v in counts.items()), 'invalid IBM counts')
    # IBM strings are out[n-1]...out[0]; the VI decoder consumes out[0]...out[n-1].
    return {'id':case['job']['id'], 'shots':case['job']['shots'], 'values':[],
            'measured_qubits':case['descriptor']['measured_wires'],
            'measurement_counts':{k[::-1]:v for k,v in counts.items()}}


def summarize(case, counts):
    normalized = normalize(case, counts)
    decoded = decode_result(case['job'], case['descriptor'], normalized)
    answer = {'case':case['name']+'/'+case['preparation'], 'expected_bit':case['expected_bit'],
              'observed':decoded, 'correct_count':decoded['answer_counts'].get(str(case['expected_bit']),0)}
    if case['request']['action'] == 'acquire':
        d = normalized['measured_qubits'].index(case['descriptor']['data_wire'])
        r = normalized['measured_qubits'].index(case['descriptor']['record_wire'])
        before = Counter()
        for bits,count in normalized['measurement_counts'].items():
            before[str(decode_runtime(case['before_execution'],bits[r],int(bits[d])))] += count
        answer['same_samples_without_extra_record'] = dict(before)
    return answer


def read_plan(directory, current=True):
    from qiskit import qpy
    p = load_json(directory/'plan.json')
    require(p['schema'] == 'vi.ibm.pilot.v1' and p['shots'] == SHOTS
            and p['max_seconds'] == MAX_SECONDS and len(p['cases']) == 3, 'wrong pilot scope')
    require(p['qpy_sha256'] == sha((directory/'isa.qpy').read_bytes()), 'compiled payload changed')
    if current:
        require(p['implementation'] == implementation(), 'pilot implementation changed')
        require(p['versions'] == versions(), 'runtime version changed')
        docs, receipt = prepare(ROOT/'private/ibm-prepared')
        require(receipt['key'] == p['checked_build']['key'], 'checked VI root changed')
        for case, (name,preparation,bit) in zip(p['cases'], CASES):
            job,desc,req = terminal_job(docs,name,preparation,SHOTS)
            require(case['job']['qasm'] == job['qasm'] and case['descriptor'] == desc
                    and case['request'] == req and case['expected_bit'] == bit
                    and case['name'] == name and case['preparation'] == preparation, 'case changed')
    circuits = qpy.load(io.BytesIO((directory/'isa.qpy').read_bytes()))
    require(len(circuits) == len(p['cases']), 'compiled circuit count changed')
    for case,circuit in zip(p['cases'],circuits):
        require(circuit.metadata == lower(case['job'],case['descriptor']).metadata,
                'compiled circuit occurrence mismatch')
    return p,circuits


def make_plan(directory, backend_name):
    from qiskit import qpy, transpile
    from qiskit_aer import AerSimulator
    require(not (directory/'plan.json').exists(), 'plan already exists')
    directory.mkdir(parents=True,exist_ok=True)
    service = service_open()
    usage = service.usage()
    require(usage['usage_remaining_seconds'] >= MAX_SECONDS, 'insufficient Open quota')
    backend = service.backend(backend_name)
    status = backend.status()
    require(status.operational and status.status_msg == 'active', 'backend is not active')
    docs,receipt = prepare(ROOT/'private/ibm-prepared')
    cases,logical = [],[]
    for name,preparation,bit in CASES:
        job,desc,req = terminal_job(docs,name,preparation,SHOTS)
        previous = next(x for x in docs['continuations.json']['plans'] if x['name'] == req['before'])
        case = {'name':name,'preparation':preparation,'expected_bit':bit,
                'job':job,'descriptor':desc,'request':req,'before_execution':previous['execution']}
        cases.append(case)
        logical.append(lower(job,desc))
    isa = transpile(logical,backend=backend,optimization_level=1,seed_transpiler=72419)
    # Check the hardware mapping keeps every output tied to its original wire.
    for case,circuit in zip(cases,isa):
        mapping = circuit.layout.final_index_layout()
        actual = {}
        for ins in circuit.data:
            if ins.operation.name == 'measure':
                cb = circuit.find_bit(ins.clbits[0]).index
                require(cb not in actual,'repeated compiled measurement destination')
                actual[cb] = circuit.find_bit(ins.qubits[0]).index
        expected = {i:mapping[q] for i,q in enumerate(case['descriptor']['measured_wires'])}
        require(actual == expected,'transpiler changed measurement binding')
        case['physical_measured_wires'] = expected
    simulator = AerSimulator()
    compiled_local = transpile([compact_active(c) for c in isa],simulator,optimization_level=0)
    result = simulator.run(compiled_local,shots=SHOTS,seed_simulator=28197).result()
    validation = [summarize(case,dict(result.get_counts(i))) for i,case in enumerate(cases)]
    require(all(x['correct_count'] == SHOTS for x in validation), 'compiled pilot failed ideal validation')
    buffer = io.BytesIO(); qpy.dump(isa,buffer)
    (directory/'isa.qpy').write_bytes(buffer.getvalue())
    write_json(directory/'local-validation.json',validation)
    plan = {'schema':'vi.ibm.pilot.v1','created_at':utc(),'tag':'vi-pilot-'+uuid.uuid4().hex,
            'backend':backend_name,'instance':service.active_instance(),'plan':'open',
            'shots':SHOTS,'max_seconds':MAX_SECONDS,'cases':cases,'checked_build':receipt,
            'qpy_sha256':sha(buffer.getvalue()),'implementation':implementation(),'versions':versions(),
            'usage_before':usage,'backend_status':status.to_dict(),
            'analysis':'Fixed 3 x 256; retain all outcomes. Compare acquired/ignored resident using identical shots. No repeat-until-success.'}
    write_json(directory/'plan.json',plan)
    print(json.dumps({'prepared':True,'backend':backend_name,'cases':3,'shots_each':SHOTS,
                      'local_correct':[x['correct_count'] for x in validation]},indent=2))


def send_once(directory, service, plan, circuits, sampler_factory=None):
    from qiskit_ibm_runtime import SamplerV2
    ledger_path = directory/'ledger.json'
    with (directory/'submit.lock').open('a') as lock:
        fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
        if ledger_path.exists():
            ledger = load_json(ledger_path)
            require(ledger['tag'] == plan['tag'],'wrong submission ledger')
            if ledger.get('job_id'):
                return ledger
            # A lost reply is NOT permission to submit the experiment twice.
            jobs = service.jobs(limit=2,job_tags=[plan['tag']])
            require(len(jobs) == 1,'submission uncertain; reconcile tagged jobs, never automatically resubmit')
            ledger.update(job_id=jobs[0].job_id(),status='recovered',recovered_at=utc())
            write_json(ledger_path,ledger)
            return ledger
        usage = service.usage()
        require(service.active_instance() == plan['instance'],'submission instance changed')
        require(usage['usage_remaining_seconds'] >= MAX_SECONDS,'insufficient remaining free quota')
        backend = service.backend(plan['backend'])
        status = backend.status()
        require(status.operational and status.status_msg == 'active','backend no longer active')
        options = {'max_execution_time':MAX_SECONDS,'default_shots':SHOTS,
                   'environment':{'job_tags':[plan['tag']]},
                   'twirling':{'enable_gates':False,'enable_measure':False}}
        sampler = (sampler_factory or SamplerV2)(mode=backend,options=options)
        ledger = {'tag':plan['tag'],'status':'submission_intent','at':utc(),
                  'backend':plan['backend'],'instance':plan['instance'],'qpy_sha256':plan['qpy_sha256']}
        write_json(ledger_path,ledger)
        job = sampler.run(circuits,shots=SHOTS)
        ledger.update(job_id=job.job_id(),status='submitted')
        write_json(ledger_path,ledger)
        return ledger


def collect(directory):
    from qiskit_ibm_runtime import RuntimeEncoder
    plan,circuits = read_plan(directory,current=False)
    # Collection may repair provider decoding without changing the submitted
    # payload. The VI source producer and answer decoder must still match.
    current = implementation()
    for name,digest in plan['implementation'].items():
        if name.startswith('Checks/BraketBridge/'):
            require(current[name] == digest,'VI source/decoder implementation changed')
    ledger = load_json(directory/'ledger.json')
    require(ledger['tag'] == plan['tag'] and ledger['qpy_sha256'] == plan['qpy_sha256'], 'ledger mismatch')
    service = service_open()
    require(service.active_instance() == plan['instance'],'collection instance mismatch')
    job = service.job(ledger['job_id'])
    require(job.job_id() == ledger['job_id'] and plan['tag'] in job.tags
            and job.backend().name == plan['backend'], 'remote job identity mismatch')
    status = job.status()
    if status != 'DONE':
        report = {'job_id':job.job_id(),'status':status,'backend':plan['backend']}
        if status in ('ERROR','CANCELLED'): report['error'] = job.error_message()
        write_json(directory/'status.json',report)
        print(json.dumps(report,indent=2)); return
    pubs = job.inputs['pubs']
    require(len(pubs) == len(circuits),'wrong returned program count')
    for pub,circuit in zip(pubs,circuits):
        source = pub[0] if isinstance(pub,(list,tuple)) else pub.circuit
        require(signature(source) == signature(circuit),'remote program differs from submitted circuit')
    result = job.result()
    require(len(result) == 3,'wrong result count')
    (directory/'raw-result.json').write_text(json.dumps(result,cls=RuntimeEncoder,indent=2))
    summaries = []
    for case,pub in zip(plan['cases'],result):
        require(pub.metadata.get('circuit_metadata') == lower(case['job'],case['descriptor']).metadata,
                'result metadata belongs to another circuit')
        bits = pub.data.out
        require(bits.num_shots == SHOTS and bits.num_bits == len(case['descriptor']['measured_wires']),
                'wrong returned shot shape')
        summaries.append(summarize(case,dict(bits.get_counts())))
    report = {'schema':'vi.ibm.pilot-result.v1','job_id':job.job_id(),'status':'DONE',
              'backend':plan['backend'],'instance_plan':'open','collected_at':utc(),
              'cases':summaries,'metrics':job.metrics(),'usage_after':service.usage(),
              'collector_implementation':current,
              'scope':'Physical QPU observations, not ideal-hardware proof or quantum advantage.'}
    write_json(directory/'hardware-result.json',report)
    write_json(directory/'status.json',{'job_id':job.job_id(),'status':'DONE','backend':plan['backend']})
    print(json.dumps(report,indent=2,default=str))


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('stage',choices=['prepare','submit','collect'])
    p.add_argument('--output',type=Path,required=True)
    p.add_argument('--backend',default='ibm_kingston')
    a = p.parse_args(); directory = a.output.resolve()
    if a.stage == 'prepare': make_plan(directory,a.backend)
    elif a.stage == 'submit':
        plan,circuits = read_plan(directory)
        print(json.dumps(send_once(directory,service_open(),plan,circuits),indent=2))
    else: collect(directory)


if __name__ == '__main__': main()
