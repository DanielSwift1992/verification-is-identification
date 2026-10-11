#!/usr/bin/env python3
"""An actual retained prefix, live uses, later strengthening, no fresh input."""
from copy import deepcopy
from itertools import combinations_with_replacement
import json
import subprocess
import time

import numpy as np
from qiskit import QuantumCircuit,ClassicalRegister,qpy
from qiskit.circuit.library import DiagonalGate
from qiskit.quantum_info import Operator

import orbit_return as o
import orbit_future as f
import orbit_live_upgrade as u

OUT=o.ROOT/'Research/Artifacts/returning-attempt-20260916/live-orbit'
H=(f.X+f.Z)/np.sqrt(2);S=np.diag([1,1j])


def compare_maps(actual,wanted):
    assert set(actual)==set(wanted);worst=0.;complete=0
    for a,k in actual.items():
        target=wanted[a];at=tuple(np.argwhere(abs(target)>1e-12)[0]);z=k[at]/target[at]
        worst=max(worst,float(abs(abs(z)-1)),float(np.max(abs(k-z*target))))
        complete=complete+k.conj().T@k
    return {'operator_residual_up_to_record_phase':worst,
            'completeness_residual':float(np.max(abs(complete-np.eye(complete.shape[0]))))}


def raw_circuit(phases,suffix_phases=None,intervention='H_B'):
    q=QuantumCircuit(8);record=ClassicalRegister(1,'acquired_answer');q.add_register(record)
    def oracle(values):
        q.append(DiagonalGate(list(values)),[0,1,2]);q.cx(1,3);q.cx(2,4);q.cx(1,4)
    def tick(k):
        for _ in range(k):q.cx(0,1);q.x(0)
    oracle(phases);q.cx(3,5);q.cx(4,5);tick(2);oracle(phases);tick(2)
    q.x(3);q.x(4);q.measure(5,record[0]);q.barrier(label='actual_ready_prefix')
    if intervention=='H_B':q.h(1)
    elif intervention=='Swap_BC':q.swap(1,0)
    else:assert intervention=='I'
    q.h(6);q.cz(2,6);q.cz(5,6)  # W_a(H), actual retained answer correction
    q.s(7);q.cz(2,7);q.cz(5,7)
    q.barrier(label='two_live_recipients_then_new_requirement')
    tick(1);oracle(phases if suffix_phases is None else suffix_phases)
    tick(2);oracle(phases if suffix_phases is None else suffix_phases);tick(1)
    q.x(3);q.x(4);q.barrier(label='upgraded_same_carrier')
    return q


def independent_branches(q):
    """Execute QPY unitary segments separated by the ACTUAL middle read."""
    live=np.zeros((256,32),complex)
    for e in range(2):
        for d in range(2):
            for s in range(8):live[s+64*d+128*e,s+8*d+16*e]=1
    rows={None:live};segment=QuantumCircuit(8);reads=0
    def flush():
        nonlocal rows,segment
        if segment.data:
            operator=Operator(segment).data
            rows={a:operator@k for a,k in rows.items()};segment=QuantumCircuit(8)
    for instruction in q.data:
        gate=instruction.operation;wires=[q.find_bit(bit).index for bit in instruction.qubits]
        if gate.name=='barrier':continue
        if gate.name=='measure':
            assert wires==[5] and reads==0;flush();matrix=rows.pop(None);reads+=1
            for a in (0,1):
                branch=matrix.copy()
                for index in range(256):
                    if ((index>>5)&1)!=a:branch[index]=0
                rows[a]=branch
        else:segment.append(gate,wires)
    flush();assert reads==1
    result={}
    for a,matrix in rows.items():
        indices=[s+32*a+64*d+128*e for e in range(2) for d in range(2) for s in range(8)]
        assert max(np.max(abs(matrix[index])) for index in range(256) if index not in set(indices))<1e-12
        result[a]=matrix[indices,:]
    return result


def probability(maps,state,observable):
    effect=np.kron(np.eye(4),(np.eye(8)+observable)/2)
    return sum(float(np.vdot(k@state,effect@(k@state)).real) for k in maps.values())


def run():
    start=time.perf_counter();OUT.mkdir(parents=True,exist_ok=True)
    source=o.read_source();m=o.model(source)
    phases=np.exp(1j*np.array([.17,-.42,.73,1.14,-2.01,.26,.31,-.87]))
    physical=u.StaticPhasePort(m,phases);live=u.LiveOrbit(m,physical)
    prefix=live.start([f.pauli('IXI')]);boundary=live.boundary()
    assert list(boundary.profile)==[1,0,1,0]
    assert live.can_read([f.pauli('IXI')]) and not live.can_read([f.pauli('IIX')])
    carrier=boundary.carrier;answer=boundary.answer_access
    live.source_action('H_B');live.work(H,0);live.work(S,1)
    # This OLD boundary is still applicable: the performed continuations
    # commute with its actual phase profile. No blanket stale-status invalidation.
    extension=live.upgrade(boundary,[f.pauli('IIX')])
    assert (extension['additional_V'],extension['additional_T'])==(2,4)
    assert (live.V_calls,live.T_calls,live.copy_calls,live.read_calls)==(4,8,1,1)
    assert live.boundary().carrier is carrier and live.boundary().answer_access is answer
    assert u.histogram(m,live._counts)==[0,0,0,0]
    actual=live.audit_maps();wanted=live.audit_ideal();maps=compare_maps(actual,wanted)
    assert max(maps.values())<1e-12

    q=raw_circuit(phases)
    with (OUT/'ActualPrefixAndUpgrade.qpy').open('wb') as handle:qpy.dump(q,handle)
    with (OUT/'ActualPrefixAndUpgrade.qpy').open('rb') as handle:restored=qpy.load(handle)[0]
    sdk=independent_branches(restored)
    sdk_error=max(float(np.max(abs(actual[a]-sdk[a]))) for a in actual)
    assert sdk_error<1e-12

    # Same acquired record and now zero residual profile can serve another
    # actual data action; no further unknown-oracle work is required.
    live.work(H,0);reuse=live.upgrade(live.boundary(),[f.pauli('IXI'),f.pauli('IIX')])
    assert reuse=={'kind':'reuse','additional_V':0,'additional_T':0}
    assert max(compare_maps(live.audit_maps(),live.audit_ideal()).values())<1e-12
    assert (live.V_calls,live.copy_calls,live.read_calls)==(4,1,1)

    # A different earlier optimal question can leave a more expensive phase
    # profile: V V has h=(2,0,0,0), requiring six more visits for full recovery.
    diagonal=u.LiveOrbit(m,u.StaticPhasePort(m,phases));diagonal.start([f.pauli('IZI')])
    expensive=diagonal.upgrade(diagonal.boundary(),[f.pauli('IIX')])
    assert (expensive['additional_V'],expensive['additional_T'])==(6,4)
    assert max(compare_maps(diagonal.audit_maps(),diagonal.audit_ideal()).values())<1e-12

    # Independent numerical/finite check of minimal nonnegative completions.
    # Two q-cycles, arbitrary old visit profiles with entries 0..2. Only profiles
    # whose prior workspace can be cleaned from q represent ready boundaries.
    finite_cases=0
    for length in range(2,6):
        mm={'schema':m['schema'],'source':f'upgrade-fixture-{length}',
            'q':[a for a in (0,1) for _ in range(length)],
            'f':[2*a+(z%2) for a in (0,1) for z in range(length)],'work_bits':2,
            'elementary_contacts_per_oracle':1,
            'permutations':{'T':[a*length+(z+1)%length for a in (0,1) for z in range(length)]},
            'oracle_contract':m['oracle_contract']}
        from itertools import product
        for h in product(range(3),repeat=length):
            counts=[[0]*(2*length) for _ in range(2*length)];work=[]
            for a in (0,1):
                for z in range(length):
                    w=0
                    for r,multiplicity in enumerate(h):
                        counts[a*length+z][a*length+(z+r)%length]=multiplicity
                        if multiplicity%2:w^=mm['f'][a*length+(z+r)%length]
                    work.append(w)
            if any(len(set(work[a*length:(a+1)*length]))!=1 for a in (0,1)):continue
            cert=u.full_upgrade(mm,counts);uses,steps=u.verify_upgrade(mm,counts,cert)
            # Exhaust possible UNIFORM final heights below and at the candidate;
            # unlike the constructor this checks inequalities coordinate-wise.
            candidate=next(height for height in range(max(h)+1) if all(height>=v for v in h))
            assert uses==sum(candidate-v for v in h)
            assert all(v==candidate for v in u.histogram(mm,cert['result_counts']))
            finite_cases+=1

    # Equal F/q/T do not establish equal phase-bearing contact on later use.
    signs=np.ones(8,complex);signs[0]=-1
    good=independent_branches(raw_circuit(signs));changed=independent_branches(raw_circuit(signs,np.ones(8)))
    cplus=np.zeros(32,complex);cplus[0]=cplus[1]=1/np.sqrt(2)
    good_p=probability(good,cplus,f.pauli('IIX'));changed_p=probability(changed,cplus,f.pauli('IIX'))
    assert abs(good_p-1)<1e-12 and abs(changed_p)<1e-12
    # A source permutation that did not commute with the retained phase frame
    # cannot be silently inserted before the SAME untransported suffix.
    swapped=independent_branches(raw_circuit(signs,intervention='Swap_BC'))
    swapped_p=probability(swapped,cplus,f.pauli('IXI'));assert abs(swapped_p)<1e-12

    # Genuine fine measurement loses an unknown sign even if its complete
    # classical outcome is kept. No later common contact can separate identical
    # CQ inputs. The same full restoring continuation is included here.
    bplus=np.zeros(32,complex);bplus[0]=bplus[2]=1/np.sqrt(2)
    bminus=bplus.copy();bminus[2]*=-1
    lost=0.
    for a,k in good.items():
        for b in (0,1):
            p=np.kron(np.eye(4),np.diag([int(((s>>1)&1)==b) for s in range(8)]))
            l=k@p;v=l@bplus;w=l@bminus
            lost=max(lost,float(np.max(abs(np.outer(v,v.conj())-np.outer(w,w.conj())))))
    assert lost<1e-12

    rejected=[]
    def reject(name,fn):
        try:fn()
        except (ValueError,AssertionError,KeyError):rejected.append(name)
        else:raise AssertionError('Accepted '+name)
    fresh=u.LiveOrbit(m,u.StaticPhasePort(m,phases))
    reject('declared boundary before actual acquisition',lambda:fresh.boundary())
    fresh.start([f.pauli('IXI')]);small=fresh.boundary();cert=u.full_upgrade(m,fresh._counts)
    reject('unaccounted swap changes the residual frame',lambda:fresh.source_action('Swap_BC'))
    reject('fresh carrier substituted for the retained one',lambda:fresh.upgrade(boundary,[f.pauli('IIX')]))
    bad=deepcopy(cert);bad['minimum_additional_V']=1
    reject('invented cheap upgrade',lambda:fresh.upgrade(small,[f.pauli('IIX')],bad))
    bad=deepcopy(cert);bad['cleanup_by_answer']['0']=0
    reject('answer kept but scratch not restored',lambda:fresh.upgrade(small,[f.pauli('IIX')],bad))
    reject('prefix overwritten by fresh acquisition',lambda:fresh.start([f.pauli('IIX')]))
    reject('lost inter-answer coherence requested after read',lambda:fresh.upgrade(small,[f.pauli('XII')]))
    fresh._port=u.StaticPhasePort(m,phases)
    # Replacing the query port did not act on the retained S. A question already
    # supported by that old boundary still needs no new phase relation.
    replacement_reuse=fresh.upgrade(small,[f.pauli('IXI')])
    assert replacement_reuse=={'kind':'reuse','additional_V':0,'additional_T':0}
    reject('same truth table substituted for actual port',lambda:fresh.upgrade(small,[f.pauli('IIX')]))

    # Apply the combined visit word to the actual Swift root. The independent
    # operator check above establishes that the intervening admitted H_B can
    # commute past the residual phase; no separate fake midpoint is introduced.
    combined_powers=list(prefix['powers'])
    for command in extension['certificate']['program']:
        if command['op']=='V':combined_powers.append(0)
        else:combined_powers[-1]+=command['count']
    assert combined_powers==[2,3,2,1]
    payload={'source':source,'plans':{'actual_prefix_and_extension':{
        'powers':combined_powers,
        'question_edges':[list(pair) for pair in f.edges(m,[f.pauli('IXI'),f.pauli('IIX')])]}}}
    (OUT/'court-input.json').write_text(json.dumps(payload,indent=2)+'\n')
    court=json.loads(subprocess.run(['node',str(o.ROOT/'Checks/FiniteContinuation/orbit_future_court.js'),
        str(OUT/'court-input.json'),str(OUT)],capture_output=True,text=True,check=True,timeout=30).stdout)

    result={'schema':'vi.actual-live-orbit-upgrade.v1','prefix':prefix,
        'extension':extension,'costs':{'prefix_V':2,'prefix_T':4,'additional_V':2,'additional_T':4,
            'total_V':4,'total_T':8,'fresh_full_V':4,'fresh_full_T':4},
        'same_carrier_and_answer_access':True,'retained_input_dimension':32,
        'intervening_operations':['H_B','corrected H on D','corrected S on E'],
        'full_instrument':maps,'independent_midread_QPY_residual':sdk_error,
        'active_phase_profile_after_upgrade':[0,0,0,0],'copy_count':1,'answer_read_count':1,
        'later_work_reuses_same_answer':True,
        'old_safe_question_survives_query_port_replacement':replacement_reuse,
        'earlier_diagonal_choice':{'additional_V':6,'total_V':8},
        'finite_profile_cases':finite_cases,
        'counterexamples':{'different_phase_same_truth_table':{'same_port_Cplus':good_p,'new_port_Cplus':changed_p},
                          'untransported_swap_Bplus':swapped_p,
                          'fine_measured_sign_full_CQ_residual':lost},
        'rejected_applications':rejected,'Swift_bounded_court':court,
        'new_QPU_jobs':0,'seconds':time.perf_counter()-start,
        'scope':'Actual local carrier, repeatable scalar phases, same-cycle words, no fresh input. '
                'Whole branch maps cover arbitrary reference. No universal physical recovery or hardware confirmation.'}
    (OUT/'checks.json').write_text(json.dumps(result,indent=2)+'\n')
    (OUT/'model.json').write_text(json.dumps(m,indent=2)+'\n')
    print(json.dumps({k:v for k,v in result.items() if k not in ('prefix','extension','Swift_bounded_court')},indent=2))


if __name__=='__main__':run()
