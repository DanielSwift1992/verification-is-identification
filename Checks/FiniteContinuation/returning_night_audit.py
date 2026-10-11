#!/usr/bin/env python3
"""Read-only integration audit of frozen night evidence; writes a NEW package.

Never invokes any prior run()/main() writer. No provider connection, simulator
job or full Swift build. Frozen positive court failures are reported as such.
"""
from collections import Counter
from datetime import datetime,timezone
import hashlib,json,subprocess,sys,time
from pathlib import Path
import numpy as np
from qiskit import qpy
from qiskit.circuit.library import HGate,RYGate
from qiskit_ibm_runtime import RuntimeDecoder
import orbit_return as o
import returning_attempt_learning as l
import returning_attempt_sdk as sdk
import returning_attempt_sdk_checks as sc
import returning_attempt_arrival as arrival
import returning_attempt_arrival_checks as ac
import acquired_memory_capability as memory
import acquired_memory_capability_checks as mc
import horizon_phase_memory_checks as hc

ROOT=o.ROOT;BASE=ROOT/'Research/Artifacts/returning-attempt-20260916'


def read(p):return json.loads(p.read_text())
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()


def manifests():
    paths=[];files={};entries=0
    for p in sorted(BASE.rglob('*manifest*.json')):
        hashes=read(p).get('sha256')
        if not isinstance(hashes,dict):continue
        paths.append(str(p.relative_to(ROOT)))
        for name,wanted in hashes.items():
            f=Path(name);f=f if f.is_absolute() else ROOT/f
            assert sha(f)==wanted,(p,name)
            key=str(f.resolve());assert key not in files or files[key]==wanted
            files[key]=wanted;entries+=1
    return {'manifests':len(paths),'entries':entries,'distinct_files':len(files),'paths':paths},files


def hardware():
    ledger=read(BASE/'hardware-ledger.json');assert len(ledger['jobs'])==2
    cases=[]
    for folder,private,late in (('hardware','ibm-returning-attempt-20260916',False),
                               ('arrival-hardware','ibm-arrival-boundary-20260916',True)):
        status=read(BASE/folder/'status.json');plan=read(BASE/folder/'plan.json')
        raw=ROOT/'private'/private/'raw-result.json';assert sha(raw)==status['raw_sha256']
        assert sha(ROOT/'private'/private/'isa.qpy')==plan['qpy_sha256']
        actual=json.loads(raw.read_text(),cls=RuntimeDecoder)
        assert len(actual)==len(status['rows'])==len(plan['PUBs'])==32
        totals=Counter();counters={}
        for pub,row in zip(actual,status['rows']):
            witness=pub.data.witness.get_bitstrings();assert len(witness)==32
            if row['variant']=='echo':
                # The allocated scratch register is never measured in echo.
                # Published records explicitly mark this absence, not a probe.
                if 'actual_replies' in pub.data.keys():assert set(pub.data.actual_replies.get_bitstrings())<={'00'}
                replies=['--' if late else '']*32
            else:replies=pub.data.actual_replies.get_bitstrings()
            if late:
                requests=pub.data.actual_arrival.get_bitstrings()
                records=Counter(f'{c} {r} {w}' for c,r,w in zip(requests,replies,witness))
                c=row['prepared_arrival'];variant=row['variant'];basis=row['basis']
                totals['arrival_agreement']+=sum(int(r)==c for r in requests)
                if c==0:totals['absent_arrival_agreement']+=sum(r=='0' for r in requests)
                key=(c,variant,basis);bzero=sum(int(w,2)&1==0 for w in witness)
                even=sum(((int(w,2)>>1)&1)==((int(w,2)>>2)&1) for w in witness)
                counters.setdefault(key,Counter()).update(shots=32,even=even)
                assert bzero==row['B_zero'] and even==row['data_even']
            else:
                records=Counter(f'{r} {w}' for r,w in zip(replies,witness))
                even=sum(int(w,2).bit_count()%2==0 for w in witness)
                assert even==row['even']
            assert records==row['counts'],'Per-shot return differs from published joint counts'
            totals['shots']+=32
        assert totals['shots']==1024
        result={'job_id':status['job_id'],'status':status['status'],'raw_sha256':sha(raw),
                'all_joint_per_shot_counts_equal':True,'PUBs':32,**totals}
        if late:
            result['XX_by_prepared_request_and_variant']={str(key[:2]):2*v['even']/v['shots']-1
                for key,v in counters.items() if key[2]=='XX'}
            assert all(v<0 for key,v in result['XX_by_prepared_request_and_variant'].items() if 'echo' not in key)
            assert totals['arrival_agreement']==1021 and totals['absent_arrival_agreement']==512
        cases.append(result)
    assert all(j['status']=='DONE' for j in ledger['jobs'])
    assert [j['job_id'] for j in ledger['jobs']]==[x['job_id'] for x in cases]
    spent=sum(j['free_seconds_before']-j['free_seconds_after'] for j in ledger['jobs'])
    assert spent==6
    return {'jobs':cases,'total_shots':2048,'observed_free_seconds_spent':spent,
            'free_seconds_after_last_job':ledger['jobs'][-1]['free_seconds_after'],
            'pending_jobs_in_ledger':0,'new_jobs_in_this_audit':0}


def native_court(out):
    executable=ROOT.parent/'gate/bin/gate-judge';rows=[]
    for folder in ('reflection-memory','frame-orbit','live-orbit','future-orbit'):
        previous=read(BASE/folder/'native-court.json')
        assert sha(executable)==previous.get('native_binary_sha256',previous.get('binary_sha256'))
        for row in previous['rows']:
            p=ROOT/row['file'];assert sha(p)==row['sha256']
            reply=subprocess.run([str(executable),'judge','where',str(p)],capture_output=True,text=True,timeout=15)
            assert reply.returncode==row['exit_code'],(folder,row['file'],reply.stdout)
            rows.append({'file':row['file'],'exit_code':reply.returncode,'output':reply.stdout,
                         'agrees_with_last_local_result':True})
    # Do not confuse the gate binary with the DIFFERENT native Tools binary
    # named in the original learning manifest. Compare both actual readers.
    old=BASE/'learning/ReturningAttempt.swift'
    reply=subprocess.run([str(executable),'judge','where',str(old)],capture_output=True,text=True,timeout=15)
    failed=sum(line.startswith('✗') for line in reply.stdout.splitlines())
    assert reply.returncode==1 and failed==16
    rows.append({'file':str(old.relative_to(ROOT)),'exit_code':1,'output':reply.stdout,
        'failed_equalities':failed,'limitation':'This gate binary cannot read the positive generic file; it is not the original learning binary.'})
    original=ROOT/'.build/arm64-apple-macosx/debug/Tools'
    assert sha(original)==read(BASE/'learning/manifest.json')['sha256'][str(original.relative_to(ROOT))]
    original_rows=[]
    for row in rows:
        p=ROOT/row['file'];expected=1 if 'Rejected' in p.name else 0
        reply=subprocess.run([str(original),'judge','where',str(p)],capture_output=True,text=True,timeout=15)
        assert reply.returncode==expected,(row['file'],reply.stdout)
        original_rows.append({'file':row['file'],'exit_code':reply.returncode,'output':reply.stdout})
    for p in sorted((BASE/'learning').glob('RejectedReturningAttempt-*.swift')):
        reply=subprocess.run([str(original),'judge','where',str(p)],capture_output=True,text=True,timeout=15)
        assert reply.returncode==1
        original_rows.append({'file':str(p.relative_to(ROOT)),'exit_code':reply.returncode,'output':reply.stdout})
    result={'gate_binary_sha256':sha(executable),'gate_cases':rows,
            'original_learning_binary_sha256':sha(original),'original_learning_binary_cases':original_rows,
            'original_learning_pass_reproduced_with_its_actual_binary':True,'full_Swift_build':False}
    (out/'native-court.json').write_text(json.dumps(result,indent=2)+'\n')
    return {'gate_files':len(rows),'gate_passing_files':sum(r['exit_code']==0 for r in rows),
            'expected_negative_files':sum('Rejected' in r['file'] for r in rows),
            'gate_binary_positive_limitations':[r['file'] for r in rows if r['exit_code'] and 'Rejected' not in r['file']],
            'original_learning_binary_files':len(original_rows),
            'original_learning_binary_positive_passes':sum(r['exit_code']==0 for r in original_rows),
            'original_learning_binary_expected_refusals':sum(r['exit_code']==1 for r in original_rows),
            'original_learning_check_reproduced':True}


def core_learning():
    source=l.read_source();cert=read(BASE/'learning/one-call-ability-certificate.json');l.verify(source,cert)
    batch=read(BASE/'learning/batch-five-certificate.json');l.verify_batch(source,batch)
    for row in range(8):
        port=l.LocalPort(source,row);ability,knowledge=l.learn(source,port,cert)
        assert port.mode=='ready' and port.operator==l.I and port.reserve==0
        ability.apply(port,l.X);assert port.operator==l.X
        port.new_payload();ability.apply(port,l.ROTATION);assert port.operator==l.ROTATION
        assert len(knowledge.support)==2
        port=l.LocalPort(source,row);gates=[l.X,l.ROTATION,l.Z,l.I,l.ROTATION]
        result,ability,knowledge=l.execute_batch(source,port,batch,gates)
        assert result==gates and ability is not None and port.mode=='ready'
    return {'current_source':l.fingerprint(source),'devices':8,'fresh_inputs_per_acquired_ability':2,'five_goal_policy_executed_on_all_devices':True}


def serialized():
    results=[];gates=(HGate(),RYGate(2*np.arctan2(4,3)))
    for ports in (sdk.Ports(),sdk.Ports(4,2,0,1,3)):
        for acquired in (True,False):
            p=BASE/'sdk'/f'{"acquired" if acquired else "echo"}-{ports.probe}.qpy'
            with p.open('rb') as handle:q,=qpy.load(handle)
            results.append({'file':str(p.relative_to(ROOT)),**sc.audit(q,ports,gates,acquired=acquired)})
    specs=read(BASE/'arrival/checks.json')['cases']
    for spec in specs:
        name=spec['name'];p=BASE/'arrival'/f'{name}.qpy'
        with p.open('rb') as handle:q,=qpy.load(handle)
        result=ac.audit(q,arrival.ArrivalPorts(**spec['ports']),acquired=spec['acquisition_enabled'],recipient=name!='arrival')
        results.append({'file':str(p.relative_to(ROOT)),**result})
    m=memory.model(o.read_source());rng=np.random.default_rng(91648)
    frames=[mc.f.I,mc.f.H,np.linalg.qr(rng.normal(size=(2,2))+1j*rng.normal(size=(2,2)))[0]]
    p=BASE/'acquired-memory/AcquiredMemoryCapability.qpy'
    with p.open('rb') as handle:circuits=qpy.load(handle)
    descriptions=read(BASE/'acquired-memory/QPY-programs.json');worst=0.
    for q,desc in zip(circuits,descriptions):
        port=memory.HiddenFrameDevice(m,desc['audit_kind'],frames[desc['audit_frame']])
        target=memory.Acquisition(m,port).acquire().audit_after(desc['word'])
        for key,k in mc.independent_instrument(q).items():
            for effect in (mc.f.I,mc.f.X,mc.f.Y,mc.f.Z):
                worst=max(worst,float(np.max(abs(k.conj().T@np.kron(mc.f.I,effect)@k-mc.branch_effects(target,key,effect)))))
    assert len(circuits)==9 and worst<1e-12
    results.append({'file':str(p.relative_to(ROOT)),'circuits':9,'all_input_effect_residual':worst})
    m=hc.h.model(o.read_source());port=hc.h.CommutingPhasePort(m,hc.h.f.H,[.27,-.8],[.17,1.13])
    acquisition=hc.h.acquire(m,port,3)
    words={0:['H_source','V','V'],1:['V'],2:['S_source','V','H_source'],3:['H_source','V']}
    p=BASE/'horizon-memory/HorizonMemory.qpy'
    with p.open('rb') as handle:circuits=qpy.load(handle)
    worst=0.
    for index,q in enumerate(circuits):
        for y,k in hc.read_instrument(q).items():
            wanted=acquisition[y]
            if index:wanted=np.kron(np.eye(2),hc.h.compiled_word(y,4,words[y]))@wanted
            worst=max(worst,float(np.max(abs(k-wanted))))
    assert len(circuits)==2 and worst<1e-12
    results.append({'file':str(p.relative_to(ROOT)),'circuits':2,'full_branch_residual':worst})
    return {'files':len(results),'circuits':20,'operator_checks':results}


def run(out):
    assert not (out/'manifest.json').exists(),'Choose a new output directory; this audit is already frozen'
    started=time.perf_counter();out.mkdir(parents=True,exist_ok=True)
    before,files=manifests();assert before['manifests']>=22
    result={'schema':'vi.returning-night-current-audit.v1','at':datetime.now(timezone.utc).isoformat(),
            'frozen_evidence':before,'current_learning':core_learning(),'serialized_instruments':serialized(),
            'native_court':native_court(out),'hardware':hardware()}
    after,again=manifests();assert again==files and after==before
    result['prior_evidence_unchanged_after_audit']=True;result['seconds']=time.perf_counter()-started
    (out/'checks.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({'frozen_evidence':{k:v for k,v in before.items() if k!='paths'},
        'learning':result['current_learning'],'serialized_files':result['serialized_instruments']['files'],
        'serialized_circuits':20,'court':result['native_court'],'hardware':result['hardware'],
        'prior_evidence_unchanged':True,'seconds':result['seconds']},indent=2))


if __name__=='__main__':run(Path(sys.argv[1]) if len(sys.argv)>1 else BASE/'night-audit')
