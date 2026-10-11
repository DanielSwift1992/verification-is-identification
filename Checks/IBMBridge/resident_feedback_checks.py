#!/usr/bin/env python3
"""Offline audit of the frozen dynamic-circuit packet and once-only sender."""
import argparse
from copy import deepcopy
import json
from pathlib import Path
import tempfile

import resident_feedback as f

REFUSALS=0
def reject(fn):
    global REFUSALS
    try:fn()
    except (AssertionError,ValueError):REFUSALS+=1;return
    raise AssertionError('Invalid packet was accepted')


def replace_instruction(c,index,op):
    # Rebuild instead of in-place replacement of a QPY control-flow block.
    # The SDK's Rust block ownership can reject direct c.data[index] mutation.
    changed=c.copy_empty_like()
    for j,ins in enumerate(c.data):
        changed.append(op if j==index else ins.operation,
                       [changed.qubits[c.find_bit(q).index] for q in ins.qubits],
                       [changed.clbits[c.find_bit(q).index] for q in ins.clbits])
    return changed


def run(directory):
    global REFUSALS
    REFUSALS=0
    from qiskit import QuantumCircuit
    from qiskit.circuit import IfElseOp
    plan,circuits=f.load(directory,True);source=f.current_source()
    # Independent analytic ideal distribution for both measured eigenstates.
    for c in circuits:
        p=f.ideal(c);expected={k:(.25 if c.metadata['variant']=='WrongWrite11' else .5 if k[0]=='0' else 0.) for k in ('00','01','10','11')}
        assert max(abs(p[k]-expected[k]) for k in expected)<1e-10
    c=circuits[0].copy();index=next(i for i,v in enumerate(c.data) if v.operation.name=='if_else')
    ins=c.data[index];body=ins.operation.blocks[0].copy_empty_like()
    # Preserve shape and condition, replace the actual feedback operation.
    body.id(0)
    c=replace_instruction(c,index,ins.operation.replace_blocks([body]))
    original=f.signature(circuits[0]);changed=f.signature(c)
    assert original!=changed
    reject(lambda: compare_manifest(c,plan,0))
    assert max(abs(f.ideal(c)[k]-f.ideal(circuits[0])[k]) for k in ('00','01','10','11'))>.1
    c=circuits[0].copy();ins=c.data[index]
    c=replace_instruction(c,index,IfElseOp((c.clbits[1],1),ins.operation.blocks[0]))
    reject(lambda:f.manifest(c,plan['physical_D_R_P']))
    c=circuits[0].copy();c.metadata=deepcopy(c.metadata);c.metadata['probe']='Y'
    reject(lambda: compare_manifest(c,plan,0))
    # Signature recursively records bodies, operands, registers, and parameters.
    assert original['instructions'][index]['condition']=={'bits':[0],'value':1}
    # Control source and measurement-label mutations cannot be silently lowered.
    fake=deepcopy(source);fake['probes']['Z']['records']=[1,0]
    reject(lambda:f.source_adapter.validate(fake))
    fake=deepcopy(source);fake['rows'][0]['actions']['Install1']=[0,0]
    reject(lambda:f.source_adapter.validate(fake))

    class Status:operational=True;status_msg='active'
    class Backend:
        def status(self):return Status()
    class Job:
        def job_id(self):return 'offline-sample-job'
    class Service:
        def __init__(self):self.matches=[]
        def active_instance(self):return plan['instance']
        def usage(self):return {'usage_remaining_seconds':580}
        def backend(self,name):assert name==plan['backend'];return Backend()
        def jobs(self,**kw):assert kw['job_tags']==[plan['tag']];return self.matches
    class Sampler:
        def __init__(self,*,mode,options):assert options==plan['options']
        def run(self,cs,shots):
            nonlocal sends
            assert shots==f.SHOTS and cs is circuits
            assert f.read(active/'ledger.json')['status']=='intent'
            sends+=1
            if fail:raise RuntimeError('Simulated transport loss after submission intent')
            return Job()
    service=Service();sends=0;fail=False
    with tempfile.TemporaryDirectory(prefix='vi-resident-once-') as t:
        active=Path(t)
        first=f.send_once(active,service,plan,circuits,Sampler)
        second=f.send_once(active,service,plan,circuits,Sampler)
        assert first==second and sends==1
    fail=True
    with tempfile.TemporaryDirectory(prefix='vi-resident-uncertain-') as t:
        active=Path(t)
        try:f.send_once(active,service,plan,circuits,Sampler)
        except RuntimeError:pass
        else:raise AssertionError('Fault injection did not fire')
        assert f.read(active/'ledger.json')['status']=='intent' and sends==2
        reject(lambda:f.send_once(active,service,plan,circuits,Sampler));assert sends==2
        service.matches=[Job()]
        result=f.send_once(active,service,plan,circuits,Sampler)
        assert result['status']=='recovered' and sends==2
    # Fixed all-outcome analysis, including an ideal negative-control example.
    rows=[]
    for v,a in f.CASES:
        counts={k:256 for k in ('00','01','10','11')} if v=='WrongWrite11' else {'00':512,'01':512}
        rows.append({'variant':v,'probe':a,'shots':1024,'counts':counts})
    analysis=f.analyse(rows);assert analysis['all_correct_minus_wrong_lower_positive']
    bad=deepcopy(rows);bad[0]['counts']['00']-=1;reject(lambda:f.analyse(bad))
    result={'prepared_circuits_checked':len(circuits),'source_bound':True,'dynamic_body_and_condition_tampering_rejected':True,
            'runtime_refusals':REFUSALS,'simulated_sender_calls':sends,'real_sender_calls':0,
            'uncertain_submission_never_resent':True,'ideal_contrast_bounds':analysis['correct_minus_wrong_intervals'],
            'test_sha256':f.sha(Path(__file__).read_bytes()),'plan_sha256':f.sha((directory/'plan.json').read_bytes())}
    f.write(directory/'offline-audit.json',result);return result


def compare_manifest(c,plan,index):
    assert json.loads(json.dumps(f.manifest(c,plan['physical_D_R_P'])))==plan['manifests'][index]


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--input',type=Path,required=True)
    print(json.dumps(run(p.parse_args().input.resolve()),indent=2))
