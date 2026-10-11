#!/usr/bin/env python3
from copy import deepcopy
import json,time
import numpy as np
import orbit_return as o
import horizon_phase_memory as h
import continuation_resource_choice as c

OUT=o.ROOT/'Research/Artifacts/returning-attempt-20260916/resource-choice'


def run():
    start=time.perf_counter();OUT.mkdir(parents=True,exist_ok=True);m=h.model(o.read_source())
    retained_request={'horizon':3,'error':.2,'error_scope':'joint_record_source_reference',
        'can_receive_E_and_port':True,'future_port_queries':3,'preparation_queries':46,'classical_values':48}
    release_request=retained_request|{'can_receive_E_and_port':False,'future_port_queries':0}
    retained=c.choose(m,retained_request);released=c.choose(m,release_request)
    assert retained['route']=='keep_access' and retained['preparation_queries']==0
    assert released['route']=='release_access' and released['preparation_queries']==46
    assert released['future_queries']==0
    requests={'keep':retained_request,'release':release_request,
              'insufficient_probe_budget':release_request|{'preparation_queries':45},
              'insufficient_record_capacity':release_request|{'classical_values':47},
              'exact_but_no_port':release_request|{'error':0},
              'conditional_instead_of_joint':release_request|{'error_scope':'each_normalized_record'},
              'memory_but_no_future_calls':retained_request|{'future_port_queries':0}}
    selections={name:c.choose(m,req) for name,req in requests.items()}
    for name in ('insufficient_probe_budget','insufficient_record_capacity','exact_but_no_port','conditional_instead_of_joint'):
        assert selections[name]['route']=='unresolved'
    assert selections['memory_but_no_future_calls']['route']=='release_access'

    rng=np.random.default_rng(91653);executions=[];release_model_ids=set();forbidden_calls=[]
    for dimension in (1,2,4):
        basis=np.linalg.qr(rng.normal(size=(dimension,dimension))+1j*rng.normal(size=(dimension,dimension)))[0]
        port=h.CommutingPhasePort(m,basis,rng.uniform(-3,3,dimension),rng.uniform(-3,3,dimension))
        keep=c.Handoff(m,retained,port);direct=np.eye(2*dimension,dtype=complex)
        for action in ['H_source','V','S_source','V','H_source','V']:
            keep.step(None,action);direct=h.word_unitary(port,[action])@direct
        retained_error=max(float(np.max(abs(keep.source_effect(q)-direct.conj().T@np.kron(np.eye(dimension),q)@direct)))
                           for q in (h.f.I,h.f.X,h.f.Y,h.f.Z))
        assert retained_error<1e-12 and keep.remaining[None]==0

        release=c.Handoff(m,released,port);release_model_ids.add(release.model)
        def removed_access(*args):
            forbidden_calls.append('attempt')
            raise AssertionError('The receiver attempted to use the released port')
        saved_forward=port.forward;port.forward=removed_access
        for y in release.words:
            for action in (['H_source','V','S_source','V','V'] if y%2 else ['V','H_source','V','S_source','V']):
                release.step(y,action)
        assert all(x==0 for x in release.remaining.values()) and release.port is None and not forbidden_calls
        port.forward=saved_forward
        norm_error,raw,compiled=h.comparison(port,46+1,release.released._acquisition,release.words)
        assert norm_error<=released['error_bound']+1e-12
        cq_error=0.
        for q in (h.f.I,h.f.X,h.f.Y,h.f.Z):
            expected=sum(k.conj().T@np.kron(np.eye(dimension),q)@k for k in compiled.values())
            cq_error=max(cq_error,float(np.max(abs(release.source_effect(q)-expected))))
        assert cq_error<1e-12
        executions.append({'E_dimension':dimension,'same_selection_before_hidden_law':True,
            'retained_calls':3,'retained_acquisition_calls':0,'retained_full_input_error':retained_error,
            'released_preparation_calls':46,'released_future_unknown_calls':0,
            'released_logical_calls_per_branch':3,'released_remaining':0,
            'all_input_dilation_error':norm_error,'announced_bound':released['error_bound'],
            'released_output_operator_error':cq_error,'active_receiver_quantum_dimension':2})
    assert len(release_model_ids)==1

    refused=[]
    def reject(name,fn):
        try:fn()
        except (ValueError,AssertionError,KeyError):refused.append(name)
        else:raise AssertionError('Accepted '+name)
    reject('using the released ability after its horizon',lambda:release.step(0,'V'))
    reject('using retained port beyond the granted resource',lambda:keep.step(None,'V'))
    forged=deepcopy(released);forged['request']['horizon']=4
    reject('request changed but the old application copied',lambda:c.Handoff(m,forged,port))
    forged=deepcopy(released);forged['request']['classical_values']=47
    reject('insufficient receiver encoded as an admitted selection',lambda:c.Handoff(m,forged,port))
    forged=deepcopy(retained);forged['request']['can_receive_E_and_port']=False
    reject('name of retained mode without the actual receiver resource',lambda:c.Handoff(m,forged,port))
    before=port.forward;port.forward=removed_access
    reject('unresolved demand triggers no speculative acquisition',lambda:c.Handoff(m,selections['insufficient_probe_budget'],port))
    assert not forbidden_calls
    port.forward=before
    old_owner=port.owner;port.owner=object()
    reject('another live port substituted for the retained occurrence',lambda:keep.step(None,'H_source'))
    port.owner=old_owner
    result={'schema':'vi.continuation-resource-choice-checks.v1','model':m,'selections':selections,'executions':executions,
        'rejected_applications':refused,'new_QPU_jobs':0,'seconds':time.perf_counter()-start,
        'limits':'Selection among retained contact and fresh sine-window release only; unresolved is not impossible. Joint-output guarantee, no postselection guarantee.'}
    (OUT/'checks.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({'routes':{name:s['route'] for name,s in selections.items()},'executions':executions,'refused':refused,'seconds':result['seconds']},indent=2))


if __name__=='__main__':run()
