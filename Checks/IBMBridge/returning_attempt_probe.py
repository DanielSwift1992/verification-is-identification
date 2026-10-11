#!/usr/bin/env python3
"""One bounded Open experiment separating return, learned use, and echo.

All circuit/analysis choices are frozen before submission. No automatic retry.
The harness prepares device law bits; the SAME controller never receives them.
"""
import argparse
from collections import Counter
import fcntl
import io
import itertools
import json
from pathlib import Path
import sys
import uuid

import numpy as np
from qiskit import QuantumCircuit, ClassicalRegister, transpile, qpy
from qiskit.circuit.library import HGate, IGate
from qiskit_ibm_runtime import SamplerV2, RuntimeEncoder
from qiskit_ibm_runtime.utils.validations import validate_isa_circuits
from qiskit_aer import AerSimulator

from pilot import service_open, sha, utc, versions, require, compact_active
from resident_joint_confirmation import choose_path, place, mcm, canonical_mcm, inventory
from classical_boundary_probe import aer_form

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT/'Checks/FiniteContinuation'))
import returning_attempt_learning as learning
from returning_attempt_sdk import ReturningAssembly, Ports
from returning_attempt_sdk_checks import read_instrument, projector
from resident_goal_instrument_audit import expand

ART = ROOT/'Research/Artifacts/returning-attempt-20260916/hardware'
NIGHT = ROOT/'Research/Artifacts/returning-attempt-20260916/hardware-ledger.json'
SHOTS, CAP = 32, 30
VARIANTS = ('correct', 'omit_return', 'ignore_learning', 'echo')


def read(p): return json.loads(p.read_text())
def write(p, value): p.write_text(json.dumps(value, indent=2)+'\n')


def engine():
    files = [Path(__file__), ROOT/'Checks/IBMBridge/pilot.py',
             ROOT/'Checks/IBMBridge/resident_joint_confirmation.py',
             ROOT/'Checks/IBMBridge/classical_boundary_probe.py',
             ROOT/'Checks/FiniteContinuation/returning_attempt_sdk.py',
             ROOT/'Checks/FiniteContinuation/returning_attempt_sdk_checks.py',
             ROOT/'Checks/FiniteContinuation/returning_attempt_learning.py',
             ROOT/'Checks/FiniteContinuation/resident_goal_instrument_audit.py']
    return {str(p.relative_to(ROOT)): sha(p.read_bytes()) for p in files}


def core(source, certificate, variant):
    assembly = ReturningAssembly(source)
    if variant == 'echo':
        assembly.echo(HGate()); assembly.echo(IGate(), later=True)
        return assembly.program()
    assembly.acquire(certificate)
    assembly.apply(HGate()); assembly.apply(IGate(), later=True)
    original = assembly.program()
    result = original.copy_empty_like()
    conditional = 0
    for item in original.data:
        if item.operation.name == 'if_else':
            conditional += 1
            if variant == 'omit_return' and conditional <= 2: continue
            if variant == 'ignore_learning' and conditional > 2: continue
        result.append(item)
    return result


def expected(variant, b=0, p=0):
    a = b ^ p
    h = expand(HGate().to_matrix(), [2], 4)
    z = np.diag([1, -1]) if a else np.eye(2)
    zd, ze = expand(z, [2], 4), expand(z, [3], 4)
    law = np.eye(16) if variant == 'echo' else projector(a, b)
    if variant == 'omit_return': return h @ zd @ law
    if variant == 'ignore_learning': return ze @ zd @ h @ law
    return h @ law


def operator_check(q, final, variant):
    rows = read_instrument(q, Ports(), final_layout=final, checkpoints=False)
    require(len(rows) == (1 if variant == 'echo' else 4), 'Unexpected instrument branches')
    error = 0.
    seen = set()
    for row in rows:
        bits = tuple(row['bits']); require(bits not in seen, 'Duplicate public instrument branch'); seen.add(bits)
        want = expected(variant, *bits) if bits else expected(variant)
        actual = row['map']
        phase = np.vdot(want, actual)/np.vdot(want, want)
        error = max(error, float(np.max(abs(actual-phase*want))), abs(abs(phase)-1))
    require(error < 1e-10, 'ISA changed the full conditional operator')
    return {'branches':len(rows), 'phase_insensitive_operator_residual':error,
            'input_dimension':16, 'probe_returns_zero':True}


def lower(q):
    native = transpile(q, basis_gates=['rz','sx','x','id','cz','reset'],
                       coupling_map=[[i,j] for i in range(5) for j in range(5) if abs(i-j)==1],
                       initial_layout=list(range(5)), layout_method='trivial', routing_method='sabre',
                       optimization_level=1, seed_transpiler=91652, num_processes=1)
    return mcm(native), native.layout.final_index_layout()


def witness(core, final, a, b, basis):
    start = QuantumCircuit(5)
    if a: start.x(1)
    if b: start.x(2)
    start.h(3); start.cx(3,4)
    start = transpile(start, basis_gates=['rz','sx','x','id','cz'], optimization_level=0)
    for reg in core.cregs: start.add_register(reg)
    start.compose(core, inplace=True)
    out = ClassicalRegister(2, 'witness'); start.add_register(out)
    tail = QuantumCircuit(5)
    for label, wire in zip(basis, (final[3], final[4])):
        if label == 'X': tail.h(wire)
    tail = transpile(tail, basis_gates=['rz','sx','x','id','cz'], optimization_level=0)
    start.compose(tail, inplace=True)
    start.measure([final[3],final[4]], out)
    return start


def ideal_sign(variant, a, basis):
    if variant == 'ignore_learning': return (-1)**a
    if variant == 'omit_return' and basis == 'ZX': return (-1)**a
    return 1


def local(q, variant, a, b, basis):
    result = AerSimulator(max_parallel_threads=1).run(aer_form(q), shots=8, memory=True,
                                                    seed_simulator=91653).result()
    require(result.success, 'Local witness failed')
    regs = {r.name:r for r in q.cregs}
    def number(record, name):
        return sum(((record >> q.find_bit(bit).index)&1)<<i for i,bit in enumerate(regs[name]))
    for record in result.get_memory():
        value = int(record.replace(' ',''),2)
        parity = number(value,'witness').bit_count() % 2
        require((-1)**parity == ideal_sign(variant,a,basis), 'Wrong hardware contrast')
        if variant != 'echo':
            require(number(value,'actual_replies') == b + 2*(a^b), 'Actual reply lost')
    return 8


def options(tag):
    return {'default_shots':SHOTS,'max_execution_time':CAP,'environment':{'job_tags':[tag]},
            'execution':{'init_qubits':True},'twirling':{'enable_gates':False,'enable_measure':False},
            'dynamical_decoupling':{'enable':False}}


def prepare(directory):
    require(not (directory/'plan.json').exists(), 'Frozen plan already exists')
    source = learning.read_source(); certificate = learning.synthesize(source)
    service = service_open(); backend = service.backend('ibm_marrakesh')
    require(backend.status().status_msg == 'active', 'Chosen backend not active')
    path, score = choose_path(backend)
    ART.mkdir(parents=True,exist_ok=True); directory.mkdir(parents=True,exist_ok=True)
    tag = 'vi-returning-attempt-'+uuid.uuid4().hex[:12]
    cores = {}; checks = {}
    for variant in VARIANTS:
        native, final = lower(core(source, certificate, variant))
        checks[variant] = operator_check(native, final, variant)
        with (ART/(variant+'-core.qpy')).open('wb') as f: qpy.dump(native, f)
        cores[variant] = native, final
    circuits=[]; rows=[]
    # Interleave variants in each law/basis block, without adaptive data selection.
    for a,b,basis,variant in itertools.product((0,1),(0,1),('XZ','ZX'),VARIANTS):
        native, final = cores[variant]
        small = witness(native,final,a,b,basis)
        local(small,variant,a,b,basis)
        metadata={'tag':tag,'variant':variant,'law_a':a,'law_b':b,'basis':basis,
                  'ideal_sign':ideal_sign(variant,a,basis),'path':path,'final_layout':final,
                  'scope':'Prepared fixed law, actual replies, retained two-data Bell witness; no device tomography.'}
        small.metadata=metadata
        q=place(small,path,backend.num_qubits)
        validate_isa_circuits([q],backend.target)
        stream=io.BytesIO();qpy.dump(q,stream);stream.seek(0);restored,=qpy.load(stream)
        require(canonical_mcm(restored)==canonical_mcm(q) and restored.metadata==q.metadata,'QPY changed')
        local(compact_active(restored),variant,a,b,basis)
        circuits.append(q); rows.append({**metadata,'inventory':inventory(q)})
    with (directory/'isa.qpy').open('wb') as f:qpy.dump(circuits,f)
    plan={'schema':'vi.returning-attempt-hardware.v1','at':utc(),'tag':tag,'backend':backend.name,
          'instance':service.active_instance(),'source':learning.fingerprint(source),'engine':engine(),
          'versions':versions(),'path':path,'path_calibration_score':score,'shots_each':SHOTS,
          'total_shots':len(circuits)*SHOTS,'cap':CAP,'options':options(tag),
          'qpy_sha256':sha((directory/'isa.qpy').read_bytes()),'operator_checks':checks,'PUBs':rows,
          'analysis':'All raw joint records without postselection. Per PUB parity expectation for X_D Z_E or Z_D X_E; '
                     'show a=0 and a=1 separately. Correct and echo ideal +1; ignore_learning ideal (-1)^a in both; '
                     'omit_return ideal (-1)^a for ZX and +1 for XZ. Compare correct/omitted/echo, not success-only histories. '
                     'Counts are descriptive; no IID or full device-channel certification. No automatic retries.'}
    require(plan['total_shots'] == 1024, 'Shot budget changed')
    write(directory/'plan.json',plan);write(ART/'plan.json',{k:v for k,v in plan.items() if k!='instance'})
    return {'prepared':True,'backend':backend.name,'path':path,'PUBs':len(circuits),
            'shots':plan['total_shots'],'cap_seconds':CAP,'operator_checks':checks}


def load(directory):
    p=read(directory/'plan.json')
    require(p['engine']==engine() and p['versions']==versions() and p['source']==learning.fingerprint(learning.read_source()),
            'Frozen implementation/source changed')
    require(p['options']==options(p['tag']) and p['shots_each']==SHOTS and p['cap']==CAP and p['total_shots']==1024,
            'Execution contract changed')
    require(sha((directory/'isa.qpy').read_bytes())==p['qpy_sha256'],'Frozen QPY changed')
    with (directory/'isa.qpy').open('rb') as f:qs=qpy.load(f)
    require(len(qs)==32 and all(q.metadata=={k:v for k,v in row.items() if k!='inventory'}
                              for q,row in zip(qs,p['PUBs'])),'Wrong PUB/record origin')
    return p,qs


def submit(directory):
    p,qs=load(directory);service=service_open()
    require(service.active_instance()==p['instance'],'Wrong instance')
    with NIGHT.with_suffix('.lock').open('a') as lock:
        fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
        night=read(NIGHT);jobs=night['jobs'];limits=night['limits']
        require(utc() < night['deadline_utc'],'Night budget expired')
        require(not any(j['tag']==p['tag'] for j in jobs),'Intent already exists; resolve it, do not resubmit')
        require(len(jobs)<limits['max_new_jobs'] and all(j['status'] in ('DONE','ERROR','CANCELLED') for j in jobs),
                'Night job count or active-job limit')
        require(sum(j['total_shots'] for j in jobs)+p['total_shots']<=limits['max_total_shots'] and
                sum(j['cap_seconds'] for j in jobs)+CAP<=limits['max_total_execution_seconds'],'Night resource limit')
        quota=service.usage()['usage_remaining_seconds'];require(quota>=CAP,'Insufficient free quota')
        backend=service.backend(p['backend']);st=backend.status()
        require(st.operational and st.status_msg=='active','Backend not active')
        validate_isa_circuits(qs,backend.target)
        item={'tag':p['tag'],'qpy_sha256':p['qpy_sha256'],'at':utc(),'status':'intent',
              'backend':p['backend'],'total_shots':p['total_shots'],'cap_seconds':CAP,
              'free_seconds_before':quota,'private_directory':str(directory.relative_to(ROOT))}
        jobs.append(item);write(NIGHT,night);write(directory/'submission.json',item)
        job=SamplerV2(mode=backend,options=p['options']).run(qs,shots=SHOTS)
        item.update(job_id=job.job_id(),status='submitted');write(NIGHT,night)
        write(directory/'submission.json',item);write(ART/'submission.json',item)
        return item


def collect(directory):
    p,qs=load(directory);sent=read(directory/'submission.json');require(sent.get('job_id'),'Uncertain send; recover by tag')
    service=service_open();require(service.active_instance()==p['instance'],'Wrong instance')
    job=service.job(sent['job_id']);require(p['tag'] in job.tags and job.backend().name==p['backend'],'Wrong job')
    status=job.status();out={'at':utc(),'job_id':job.job_id(),'status':status}
    if status in ('ERROR','CANCELLED'):out['error']=job.error_message()
    if status=='DONE':
        result=job.result();require(len(result)==len(qs),'Missing PUBs')
        write(directory/'raw-result.json',json.loads(json.dumps(result,cls=RuntimeEncoder)))
        rows=[]
        for pub,q,entry in zip(result,qs,job.inputs['pubs']):
            remote=entry[0] if isinstance(entry,(tuple,list)) else entry.circuit
            require(canonical_mcm(remote)==canonical_mcm(q) and pub.metadata['circuit_metadata']==q.metadata,'Remote origin changed')
            witness=pub.data.witness.get_bitstrings()
            replies=pub.data.actual_replies.get_bitstrings() if q.metadata['variant']!='echo' else ['']*SHOTS
            require(len(witness)==len(replies)==SHOTS,'Shot count changed')
            even=sum(int(x,2).bit_count()%2==0 for x in witness)
            rows.append({**q.metadata,'counts':dict(Counter(r+' '+w for r,w in zip(replies,witness))),
                         'shots':SHOTS,'even':even,'parity_expectation':2*even/SHOTS-1,
                         'ideal_reply_agreement':sum(int(r,2)==q.metadata['law_b']+2*(q.metadata['law_a']^q.metadata['law_b'])
                                                     for r in replies) if q.metadata['variant']!='echo' else None})
        out.update(rows=rows,raw_sha256=sha((directory/'raw-result.json').read_bytes()))
    if status in ('DONE','ERROR','CANCELLED'):
        out.update(metrics=job.metrics(),free_seconds_after=service.usage()['usage_remaining_seconds'])
    with NIGHT.with_suffix('.lock').open('a') as lock:
        fcntl.flock(lock,fcntl.LOCK_EX)
        night=read(NIGHT)
        matching=[j for j in night['jobs'] if j['tag']==p['tag']];require(len(matching)==1,'Missing night intent')
        matching[0]['status']=status
        if 'free_seconds_after' in out:matching[0]['free_seconds_after']=out['free_seconds_after']
        write(NIGHT,night)
    write(directory/'status.json',out);write(ART/'status.json',out)
    return out


if __name__=='__main__':
    parser=argparse.ArgumentParser();parser.add_argument('stage',choices=['prepare','submit','collect'])
    parser.add_argument('--output',type=Path,required=True);args=parser.parse_args()
    print(json.dumps(globals()[args.stage](args.output.resolve()),indent=2))
