#!/usr/bin/env python3
"""Bounded, Open-only diagnosis of the frozen absent-arrival failure.

The old experiment is immutable. Four contexts are compared on the same
physical sites. Product inputs distinguish the two Bell partners; reported
server schedules expose (but do not remove) duration confounding.
No repair is selected from this sample. No automatic retry or resubmission.
"""
import argparse
from collections import Counter
import fcntl
import io
import itertools
import json
from pathlib import Path
import sys

import numpy as np
from qiskit import QuantumCircuit, ClassicalRegister, qpy, transpile
from qiskit.quantum_info import Statevector, Operator
from qiskit_aer import AerSimulator
from qiskit_ibm_runtime import RuntimeEncoder, SamplerV2
from qiskit_ibm_runtime.utils.validations import validate_isa_circuits

from pilot import service_open, sha, utc, versions, require, compact_active
from resident_joint_confirmation import place, canonical_mcm, inventory
from resident_scheduler_pilot import schedule_evidence
from classical_boundary_probe import aer_form
import arrival_boundary_probe as old

ROOT = Path(__file__).resolve().parents[2]
ART = ROOT/'Research/Artifacts/arrival-failure-localization-20260916'
PRIVATE = ROOT/'private/ibm-arrival-localization-20260916'
OLD = ROOT/'Research/Artifacts/returning-attempt-20260916/arrival-hardware'
TAG = 'vi-arrival-localization-20260916-a'
ARMS = ('conditional', 'slots_only', 'slots_no_reset', 'echo')
SHOTS = 64
CAP = 30


def read(p): return json.loads(p.read_text())
def write(p, value): p.write_text(json.dumps(value, indent=2)+'\n')


def contexts():
    old.verify_parent(OLD/'manifest.json')
    result = {}
    for arm in ('conditional', 'echo'):
        with (OLD/(arm+'-core.qpy')).open('rb') as handle:
            result[arm], = qpy.load(handle)
    for arm in ('slots_only', 'slots_no_reset'):
        q = result['conditional'].copy_empty_like()
        for item in result['conditional'].data:
            if item.operation.name == 'if_else': continue
            if arm == 'slots_no_reset' and item.operation.name == 'reset': continue
            q.append(item)
        result[arm] = q
    return result


def boundary_input(name, spectator=None):
    """Desired D,R state when the arrival is read, not before the prefix."""
    q = QuantumCircuit(2)
    if name == 'Bell': q.h(0); q.cx(0, 1)
    elif name == 'D':
        q.h(0)
        if spectator: q.x(1)
    elif name == 'R':
        q.h(1)
        if spectator: q.x(0)
    else: raise ValueError(name)
    return q


def preparation(name, spectator):
    q = QuantumCircuit(6)
    q.x(1); q.h(2)  # The old A=1, B=+ fixture, C=P=0.
    q.compose(boundary_input(name, spectator), [3, 4], inplace=True)
    # U3=H S H is the unchanged old service prefix. Its inverse prepares
    # the requested state AT the exposed boundary, without changing the core.
    q.h(3); q.sdg(3); q.h(3)
    return q


def core_check(core, final):
    """All AB D R inputs, restricted only to actual prepared C=0 and P=0."""
    u3 = old.expand(old.HGate().to_matrix() @ old.SGate().to_matrix()
                    @ old.HGate().to_matrix(), [2], 5)
    wanted = u3[:, :16]
    count = 0; residual = 0.; norm = np.zeros((16, 16), complex)
    for matrix, bits in old.native_rows(core, final):
        actual = matrix[:, :16]
        if np.linalg.norm(actual) < 1e-12: continue
        require(bits == [0, 0, 0], 'Unexpected acquired record on C=0')
        phase = np.vdot(wanted, actual)/16
        residual = max(residual, float(np.max(abs(actual-phase*wanted))),
                       float(abs(abs(phase)-1)))
        norm += actual.conj().T @ actual; count += 1
    require(count == 1 and residual < 1e-11 and
            np.max(abs(norm-np.eye(16))) < 1e-11, 'Not the same absent-arrival action')
    return {'full_C0_input_dimension': 16, 'operator_residual': residual,
            'returned_P_zero': True, 'ideal_nonzero_record': [0, 0, 0]}


def witness(core, final, name, spectator, basis):
    q = transpile(preparation(name, spectator), basis_gates=['rz','sx','x','id','cz'],
                  optimization_level=0)
    for reg in core.cregs: q.add_register(reg)
    q.compose(core, inplace=True)
    tail = QuantumCircuit(6)
    tail.h(final[2])  # B_X is an additional diagnostic, always retained.
    for axis, wire in zip(basis, (final[3], final[4])):
        if axis == 'Y': tail.sdg(wire)
        if axis in ('X','Y'): tail.h(wire)
    tail = transpile(tail, basis_gates=['rz','sx','x','id','cz'], optimization_level=0)
    q.compose(tail, inplace=True)
    output = ClassicalRegister(3, 'witness'); q.add_register(output)
    q.measure([final[2], final[3], final[4]], output)
    return q


def ideal(name, spectator, basis):
    rho = Statevector.from_instruction(boundary_input(name, spectator))
    paulis = {'X': np.array([[0,1],[1,0]]), 'Y': np.array([[0,-1j],[1j,0]]),
              'Z': np.diag([1,-1])}
    d, r = (paulis[x] for x in basis)
    return {'D': float(rho.expectation_value(Operator(np.kron(np.eye(2), d))).real),
            'R': float(rho.expectation_value(Operator(np.kron(r, np.eye(2)))).real),
            'DR': float(rho.expectation_value(Operator(np.kron(r, d))).real), 'B': 1.}


def exact_serialized(q, prediction):
    # Independent simulator reads the WHOLE serialized witness, including
    # its prep, physical placement and terminal basis rotations.
    c = aer_form(compact_active(q))
    c = c.remove_final_measurements(inplace=False)
    c.save_density_matrix()
    result = AerSimulator(method='density_matrix', max_parallel_threads=1).run(c).result()
    rho = np.asarray(result.data(0)['density_matrix'])
    active = sorted({q.find_bit(bit).index for item in q.data for bit in item.qubits})
    terminal = {q.find_bit(item.clbits[0]).index:active.index(q.find_bit(item.qubits[0]).index)
                for item in q.data if item.operation.name == 'measure'}
    reg = next(r for r in q.cregs if r.name == 'witness')
    bits = [terminal[q.find_bit(bit).index] for bit in reg]
    def mean(indices):
        return float(sum(rho[i,i].real * (-1)**sum((i >> bits[j]) & 1 for j in indices)
                         for i in range(len(rho))))
    got = {name:mean(indices) for name,indices in
           {'B':[0], 'D':[1], 'R':[2], 'DR':[1,2]}.items()}
    require(max(abs(got[k]-prediction[k]) for k in prediction) < 1e-10,
            'Serialized physical witness changes ideal predictions')
    return got


def options():
    return {'default_shots':SHOTS, 'max_execution_time':CAP,
            'environment':{'job_tags':[TAG]}, 'execution':{'init_qubits':True},
            'twirling':{'enable_gates':False,'enable_measure':False},
            'dynamical_decoupling':{'enable':False},
            'experimental':{'execution':{'scheduler_timing':True}}}


def prepare():
    require(not (PRIVATE/'plan.json').exists(), 'Already prepared: no overwrite')
    cores = contexts(); old_plan = read(OLD/'plan.json')
    path = old_plan['path']; final = old_plan['PUBs'][0]['final_layout']
    checks = {name:core_check(q, final) for name,q in cores.items()}
    service = service_open(); backend = service.backend(old_plan['backend'])
    status = backend.status()
    require(status.operational and status.status_msg == 'active', 'Backend unavailable')
    cases = [(name,s,b) for name,s in itertools.product(('D','R'),(0,1))
             for b in (('XZ','YZ') if name == 'D' else ('ZX','ZY'))]
    cases += [('Bell', None, b) for b in ('XX','ZZ')]
    qs = []; entries = []
    # Contexts interleaved; this does not establish stationarity or IID.
    for name,spectator,basis in cases:
        for arm in ARMS:
            q = witness(cores[arm], final, name, spectator, basis)
            entry = {'tag':TAG, 'arm':arm, 'input_at_arrival':name,
                     'spectator':spectator, 'basis':basis, 'prepared_arrival':0,
                     'path':path, 'final_layout':final,
                     'ideal':ideal(name,spectator,basis)}
            q.metadata = entry; q = place(q,path,backend.num_qubits)
            validate_isa_circuits([q], backend.target)
            buf = io.BytesIO(); qpy.dump(q,buf); buf.seek(0); restored, = qpy.load(buf)
            require(canonical_mcm(q) == canonical_mcm(restored), 'QPY changed circuit')
            exact_serialized(restored, entry['ideal'])
            qs.append(q); entries.append(entry)
    require(len(qs) == 40, 'Unexpected budget')
    PRIVATE.mkdir(parents=True, exist_ok=True); ART.mkdir(parents=True, exist_ok=True)
    with (PRIVATE/'isa.qpy').open('wb') as handle: qpy.dump(qs,handle)
    p = {'schema':'vi.arrival-failure-localization.v1','at':utc(),'tag':TAG,
         'backend':backend.name,'instance':service.active_instance(),'plan':'open',
         'qpy_sha256':sha((PRIVATE/'isa.qpy').read_bytes()),'script_sha256':sha(Path(__file__).read_bytes()),
         'versions':versions(),'old_manifest_sha256':sha((OLD/'manifest.json').read_bytes()),
         'shots_each':SHOTS,'total_shots':len(qs)*SHOTS,'cap_seconds':CAP,
         'options':options(),'dt':backend.dt,'PUBs':entries,'operator_checks':checks,
         'inventory':{arm:inventory(q) for arm,q in cores.items()},
         'analysis':'All shots, no postselection. Product X/Y readings locate endpoint phase behavior; '
                    'spectator 0/1 changes test context dependence; Bell XX/ZZ connects to the old failure. '
                    'conditional vs slots_only removes false guards but may change elapsed time. '
                    'slots_only vs slots_no_reset removes resets but may change elapsed time. '
                    'echo is shorter. Read provider schedules; no equal-time or pulse-error attribution '
                    'is inferred from logical identity. No correction fitted or applied to this sample.'}
    write(PRIVATE/'plan.json',p); write(ART/'plan.json',{k:v for k,v in p.items() if k!='instance'})
    return {'prepared':True,'PUBs':len(qs),'shots':p['total_shots'],'checks':checks}


def load():
    p = read(PRIVATE/'plan.json')
    require(p['tag']==TAG and p['options']==options() and p['versions']==versions() and
            p['script_sha256']==sha(Path(__file__).read_bytes()), 'Frozen executor changed')
    require(sha((PRIVATE/'isa.qpy').read_bytes())==p['qpy_sha256'], 'Frozen circuit changed')
    with (PRIVATE/'isa.qpy').open('rb') as handle: qs=qpy.load(handle)
    require(len(qs)==40 and [q.metadata for q in qs]==p['PUBs'], 'PUB correspondence changed')
    return p,qs


def submit():
    p,qs = load(); service=service_open()
    require(service.active_instance()==p['instance'], 'Different instance')
    with (PRIVATE/'submit.lock').open('a') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX|fcntl.LOCK_NB)
        require(not (PRIVATE/'submission.json').exists(), 'Intent exists; do not resubmit')
        quota=service.usage()['usage_remaining_seconds']; require(quota>=CAP, 'Free quota unavailable')
        backend=service.backend(p['backend']); status=backend.status()
        require(status.operational and status.status_msg=='active', 'Backend unavailable')
        validate_isa_circuits(qs, backend.target)
        intent={'tag':TAG,'at':utc(),'status':'intent','qpy_sha256':p['qpy_sha256'],
                'total_shots':p['total_shots'],'cap_seconds':CAP,'free_seconds_before':quota}
        write(PRIVATE/'submission.json',intent)
        job=SamplerV2(mode=backend,options=p['options']).run(qs,shots=SHOTS)
        intent.update(job_id=job.job_id(),status='submitted')
        write(PRIVATE/'submission.json',intent); write(ART/'submission.json',intent)
        return intent


def collect():
    p,qs=load(); sent=read(PRIVATE/'submission.json')
    require(sent.get('job_id'), 'Uncertain intent: recover by tag, never resubmit')
    service=service_open(); require(service.active_instance()==p['instance'], 'Different instance')
    job=service.job(sent['job_id']); require(TAG in job.tags and job.backend().name==p['backend'], 'Wrong job')
    status=job.status(); report={'at':utc(),'job_id':job.job_id(),'status':status}
    if status=='DONE':
        result=job.result(); require(len(result)==len(qs), 'Incomplete result')
        write(PRIVATE/'raw-result.json',json.loads(json.dumps(result,cls=RuntimeEncoder)))
        rows=[]
        for q,pub,remote_entry in zip(qs,result,job.inputs['pubs']):
            remote=remote_entry[0] if isinstance(remote_entry,(tuple,list)) else remote_entry.circuit
            require(canonical_mcm(remote)==canonical_mcm(q) and pub.metadata['circuit_metadata']==q.metadata,
                    'Returned origin mismatch')
            w=pub.data.witness.get_bitstrings(); c=pub.data.actual_arrival.get_bitstrings()
            r=pub.data.actual_replies.get_bitstrings()
            require(len(w)==len(c)==len(r)==SHOTS, 'Wrong sample size')
            values=[int(x,2) for x in w]
            def mean(indices):
                return sum((-1)**sum((x>>i)&1 for i in indices) for x in values)/SHOTS
            rows.append({**q.metadata,'shots':SHOTS,'counts':dict(Counter(' '.join(x) for x in zip(c,r,w))),
                         'means':{n:mean(i) for n,i in {'B':[0],'D':[1],'R':[2],'DR':[1,2]}.items()},
                         'arrival_zero':sum(x=='0' for x in c),
                         'schedule':schedule_evidence(pub.metadata,p['dt'])})
        report.update(rows=rows,raw_sha256=sha((PRIVATE/'raw-result.json').read_bytes()))
    if status in ('ERROR','CANCELLED'): report['error']=job.error_message()
    if status in ('DONE','ERROR','CANCELLED'):
        report.update(metrics=job.metrics(),free_seconds_after=service.usage()['usage_remaining_seconds'])
    write(PRIVATE/'status.json',report); write(ART/'status.json',report)
    return {k:v for k,v in report.items() if k!='rows'}


if __name__=='__main__':
    parser=argparse.ArgumentParser(); parser.add_argument('stage',choices=['prepare','submit','collect'])
    print(json.dumps(globals()[parser.parse_args().stage](),indent=2))
