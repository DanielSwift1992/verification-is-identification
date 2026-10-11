#!/usr/bin/env python3
"""Same-carrier frame transport, an all-word obstruction, independent QPY."""
from copy import deepcopy
from itertools import permutations,product
import json
import subprocess
import time

import numpy as np
from qiskit import QuantumCircuit,ClassicalRegister,qpy
from qiskit.circuit.library import DiagonalGate

import orbit_return as o
import orbit_future as f
import orbit_live_upgrade as u
import orbit_live_upgrade_checks as old
import orbit_frame_transport as t

OUT=o.ROOT/'Research/Artifacts/returning-attempt-20260916/frame-orbit'


def raw_circuit(phases):
    q=QuantumCircuit(8);record=ClassicalRegister(1,'retained_answer');q.add_register(record)
    def oracle():
        q.append(DiagonalGate(list(phases)),[0,1,2]);q.cx(1,3);q.cx(2,4);q.cx(1,4)
    def tick(k):
        for _ in range(k):q.cx(0,1);q.x(0)
    oracle();q.cx(3,5);q.cx(4,5);tick(2);oracle();tick(2)
    q.x(3);q.x(4);q.measure(5,record[0]);q.barrier(label='same_acquired_carrier')
    q.h(6);q.cz(2,6);q.cz(5,6)
    q.swap(0,1);q.h(0)
    q.s(7);q.cz(2,7);q.cz(5,7);q.barrier(label='use_in_changed_frame')
    q.swap(0,1);q.barrier(label='known_inverse_frame')
    tick(1);oracle();tick(2);oracle();tick(1);q.x(3);q.x(4)
    q.swap(0,1);q.barrier(label='transported_full_boundary')
    return q


def run():
    started=time.perf_counter();OUT.mkdir(parents=True,exist_ok=True)
    source=o.read_source();m=o.model(source)
    phases=np.exp(1j*np.array([.12,-.23,.45,-.78,.38,1.14,-2.17,.63]))
    actual=t.FramedOrbit(m,u.StaticPhasePort(m,phases));actual.start([f.pauli('IXI')])
    prior=actual.boundary();carrier=prior.prior.carrier;answer=prior.prior.answer_access
    before_counts=actual.counts();before_cert=t.solve_closed_word(m,before_counts)
    assert (before_cert['minimum_V'],before_cert['minimum_T'])==(2,4)
    actual.work(old.H,0);actual.change_frame();moved=actual.boundary();moved_counts=actual.counts()
    assert actual.can_read([f.pauli('IIX')]) and not actual.can_read([f.pauli('IXI')])
    obstruction=t.solve_closed_word(m,moved_counts)
    assert obstruction['kind']=='no_closed_forward_word'
    objection=t.verify_closed_word(m,moved_counts,obstruction)
    assert objection['impossible_in_declared_word_language']
    # Independent explicit reason for this case: rows 0 and 1 already agree,
    # hence a closed suffix must have g[k]=g[k-1] for every k; rows 0 and 2
    # still disagree and a constant g cannot change that.
    assert moved_counts[0]==moved_counts[1] and moved_counts[0]!=moved_counts[2]
    actual.source_action('H_C');actual.work(old.S,1)
    extension=actual.strengthen(moved,[f.pauli('IXI')])
    assert (extension['additional_V'],extension['additional_T'],extension['additional_Swap'])==(2,4,2)
    assert actual.boundary().swapped and actual.boundary().prior.carrier is carrier
    assert actual.boundary().prior.answer_access is answer
    assert (actual._live.V_calls,actual._live.T_calls,actual.swap_calls)==(4,8,3)
    assert (actual._live.copy_calls,actual._live.read_calls)==(1,1)
    audit=old.compare_maps(actual.audit_maps(),actual.audit_ideal())
    assert max(audit.values())<1e-12
    q=raw_circuit(phases)
    with (OUT/'ActualFrameTransport.qpy').open('wb') as handle:qpy.dump(q,handle)
    with (OUT/'ActualFrameTransport.qpy').open('rb') as handle:restored=qpy.load(handle)[0]
    independent=old.independent_branches(restored)
    sdk=max(float(np.max(abs(actual.audit_maps()[a]-independent[a]))) for a in independent)
    assert sdk<1e-12
    actual.work(old.H,0)
    reuse=actual.strengthen(actual.boundary(),[f.pauli('IXI'),f.pauli('IIX')])
    assert reuse=={'kind':'reuse','additional_V':0,'additional_T':0,'additional_Swap':0}
    assert max(old.compare_maps(actual.audit_maps(),actual.audit_ideal()).values())<1e-12

    # Exhaust all 24 known permutations on the four positions in both fibers.
    # An independently enumerated nonnegative histogram 0..1 decides these
    # instances; the certificates prove the negative ones for ANY word length.
    permutation_rows=[]
    for p in permutations(range(4)):
        permutation=list(p)+[4+x for x in p];counts=t.transported(before_counts,permutation)
        cert=t.solve_closed_word(m,counts);t.verify_closed_word(m,counts,cert)
        finite=[]
        for g in product(range(2),repeat=4):
            added=u.to_counts(m,list(g));result=[[x+y for x,y in zip(a,b)] for a,b in zip(counts,added)]
            if all(result[s]==result[4*(s//4)] for s in range(8)):finite.append(sum(g))
        assert bool(finite)==(cert['kind']=='closed_forward_word')
        if finite:assert min(finite)==cert['minimum_V']
        permutation_rows.append({'permutation':list(p),'kind':cert['kind'],
                                 'minimum_V':cert.get('minimum_V')})
    positive=sum(x['kind']=='closed_forward_word' for x in permutation_rows)
    assert positive==8

    # Other lengths and independently permuted q-fibers exercise the shared
    # suffix constraint. Even old counts guarantee inherited scratch readiness.
    rng=np.random.default_rng(170916);general=[]
    for length in range(2,8):
        mm={'schema':m['schema'],'source':f'frame-fixture-{length}',
            'q':[a for a in (0,1) for _ in range(length)],
            'f':[2*a+z%2 for a in (0,1) for z in range(length)],'work_bits':2,
            'elementary_contacts_per_oracle':1,
            'permutations':{'T':[a*length+(z+1)%length for a in (0,1) for z in range(length)]},
            'oracle_contract':m['oracle_contract']}
        for k in range(12):
            h=[2*int(x) for x in rng.integers(0,3,length)]
            pp=[int(z)+a*length for a in (0,1) for z in rng.permutation(length)]
            counts=t.transported(u.to_counts(mm,h),pp);cert=t.solve_closed_word(mm,counts)
            verified=t.verify_closed_word(mm,counts,cert)
            general.append({'length':length,'h':h,'permutation':pp,'certificate':cert,'verified':verified})

    rejected=[]
    def reject(name,call):
        try:call()
        except (ValueError,AssertionError,KeyError):rejected.append(name)
        else:raise AssertionError('Accepted '+name)
    weak=t.FramedOrbit(m,u.StaticPhasePort(m,phases));weak.start([f.pauli('IXI')])
    old_boundary=weak.boundary();weak.change_frame();now=weak.boundary()
    reject('untransported old boundary',lambda:weak.strengthen(old_boundary,[f.pauli('IXI')]))
    reject('wrong coherence control after frame change',lambda:weak.source_action('H_B'))
    weak.swap_available=False
    assert weak.strengthen(now,[f.pauli('IIX')])['kind']=='reuse'
    before={a:k.copy() for a,k in weak.audit_maps().items()}
    reject('missing actual inverse frame access',lambda:weak.strengthen(now,[f.pauli('IXI')]))
    assert all(np.array_equal(before[a],k) for a,k in weak.audit_maps().items())
    weak.swap_available=True;weak._live._port=u.StaticPhasePort(m,phases)
    reject('new phase port behind same table',lambda:weak.strengthen(now,[f.pauli('IXI')]))
    reject('different carrier with identical frame',lambda:weak.strengthen(moved,[f.pauli('IXI')]))
    bad=deepcopy(obstruction);bad['cycle']=[]
    reject('empty impossibility declaration',lambda:t.verify_closed_word(m,moved_counts,bad))
    bad=deepcopy(obstruction);bad['cycle']=bad['cycle'][:-1]
    reject('unclosed equation witness',lambda:t.verify_closed_word(m,moved_counts,bad))
    reject('obstruction applied before actual swap',lambda:t.verify_closed_word(m,before_counts,obstruction))
    bad=deepcopy(before_cert);bad['added_histogram']=[x+1 for x in bad['added_histogram']]
    reject('nonminimal profile called optimal',lambda:t.verify_closed_word(m,before_counts,bad))

    result={'schema':'vi.live-frame-transport.v1','retained_input_dimension':32,
        'before_swap_admitted_question':'X_B','after_swap_admitted_question':'X_C',
        'restricted_word_obstruction':objection,'same_carrier_and_answer':True,
        'strengthening':extension,'costs':{'total_V':4,'total_T':8,'actual_Swap':3,'extra_transport_Swap':2},
        'actual_intervening_work':['corrected H on D','Swap_BC','H_C','corrected S on E'],
        'full_instrument':audit,'independent_measured_QPY_residual':sdk,
        'copy_count':actual._live.copy_calls,'answer_read_count':actual._live.read_calls,
        'later_reuse':reuse,'permutations':{'tested':24,'suffix_possible':positive,'suffix_impossible':24-positive},
        'general_instances':len(general),'rejected_applications':rejected,
        'new_QPU_jobs':0,'seconds':time.perf_counter()-started,
        'scope':'Fixed closed forward V/T suffix obstruction. Known invertible frame transport on same live carrier is constructive, not a universal recovery or hardware result.'}
    court=subprocess.run(['node',str(o.ROOT/'Checks/FiniteContinuation/orbit_frame_court.js'),'check',str(OUT)],
                         check=True,capture_output=True,text=True)
    result['Swift_JS_court']=json.loads(court.stdout)
    for name,value in [('checks.json',result),('model.json',m),('obstruction.json',obstruction),
                       ('permutations.json',permutation_rows),('general-cases.json',general)]:
        (OUT/name).write_text(json.dumps(value,indent=2)+'\n')
    print(json.dumps({k:result[k] for k in ('full_instrument','independent_measured_QPY_residual','permutations','general_instances','rejected_applications','seconds')},indent=2))


if __name__=='__main__':run()
