#!/usr/bin/env python3
"""Finite construction, obstruction, full instruments, and coherent alternative."""
from copy import deepcopy
import json
import subprocess
import time

import numpy as np

import coarse_acquisition as c
import returning_attempt_learning as learning

OUT=c.ROOT/'Research/Artifacts/returning-attempt-20260916/coarse'


def verify_instrument(model, rows):
    wanted=c.projectors(model);seen=set();complete=np.zeros((len(model['q']),len(model['q'])),complex)
    worst=0.
    for answer,record,matrix in rows:
        assert answer not in seen;seen.add(answer)
        worst=max(worst,float(np.max(abs(matrix-wanted[answer]))))
        complete+=matrix.conj().T@matrix
    assert seen==set(wanted) and worst<1e-12 and np.max(abs(complete-np.eye(len(model['q']))))<1e-12
    return {'answers':len(rows),'projector_ranks':[int(np.trace(k).real) for k in wanted.values()],
            'full_operator_residual':worst,'probability_complete':True}


def distinguishability(rows, i, j):
    n=rows[0][2].shape[1]
    plus=np.zeros(n,complex);plus[i]=plus[j]=1/np.sqrt(2)
    minus=plus.copy();minus[j]*=-1
    rho0=np.outer(plus,plus.conj());rho1=np.outer(minus,minus.conj())
    distance=sum(np.linalg.norm(k@(rho0-rho1)@k.conj().T,ord='nuc')/2 for _,_,k in rows)
    return float(distance)


def all_measured(model):
    n=len(model['q']);fibers={}
    for i,q in enumerate(model['q']):
        word=tuple(f[i] for f in model['probes'].values())
        if word not in fibers:fibers[word]=[q,np.zeros((n,n))]
        assert fibers[word][0]==q
        fibers[word][1][i,i]=1
    return [(q,word,k) for word,(q,k) in fibers.items()]


def run():
    started=time.perf_counter();OUT.mkdir(parents=True,exist_ok=True)
    source=c.read_source()
    model=c.model(source,'Question',{'Half':'Half','Low':'Low','High':'High'})
    certificate=c.synthesize(model);checked=c.verify(model,certificate)
    assert checked['possible_in_measured_catalogue'] and checked['worst_case_queries']==2
    assert certificate['tree']['probe']=='Half'
    assert certificate['tree']['branches']['0']['probe']=='Low'
    assert certificate['tree']['branches']['1']['probe']=='High'
    rows=c.measured_instrument(model,certificate['tree'])
    exact=verify_instrument(model,rows)
    # Four independent target values need four leaves. Binary depth<2 has at
    # most two leaves, so this particular attained upper bound is minimal.
    assert len(set(model['q']))==4
    all_rows=all_measured(model)
    before=distinguishability(rows,0,1);after=distinguishability(all_rows,0,1)
    assert abs(before-1)<1e-12 and after==0

    old_source=learning.read_source()
    old=c.model(old_source,'Control',{'B':'ProbeB','Parity':'ProbeParity','Residue':'Residue'})
    obstruction=c.synthesize(old);no=c.verify(old,obstruction)
    assert not no['possible_in_measured_catalogue']
    pairs={name:reason['pair'] for name,reason in obstruction['tree']['reasons'].items()}
    for name,(i,j) in pairs.items():
        assert old['q'][i]==old['q'][j] and old['probes'][name][i]!=old['probes'][name][j]
        f=old['probes'][name]
        first=[(0,b,np.diag([int(x==b) for x in f])) for b in (0,1)]
        assert distinguishability(first,i,j)==0

    coherent_results=[]
    for name,m,contacts in (('adaptive source',model,('Half','Low','High')),
                            ('returning source',old,('B','Parity'))):
        phases={contacts[0]:[i%2 for i in range(len(m['q']))]}
        proper=c.coherent_acquire(m,contacts,phase_exponents=phases)
        assert all(work==0 for _,work,_ in proper['rows'])
        operator=verify_instrument(m,proper['rows'])
        repeated=c.coherent_acquire(m,contacts,phase_exponents=phases,undo='forward')
        assert all(work==0 for _,work,_ in repeated['rows'])
        intended=c.projectors(m)
        # The records and ready workspace are right, but the same-q coherence
        # is phase-flipped. Mere return of work bits is an insufficient test.
        error=max(float(np.max(abs(k-intended[a]))) for a,_,k in repeated['rows'])
        assert error==2
        plus=np.zeros(len(m['q']),complex);plus[0]=plus[1]=1/np.sqrt(2)
        assert m['q'][0]==m['q'][1]
        rho=np.outer(plus,plus.conj())
        retained_probability=sum(float(np.trace(rho@k@rho@k.conj().T).real) for _,_,k in proper['rows'])
        repeated_probability=sum(float(np.trace(rho@k@rho@k.conj().T).real) for _,_,k in repeated['rows'])
        assert abs(retained_probability-1)<1e-12 and abs(repeated_probability)<1e-12
        clean_no_return=c.coherent_acquire(m,contacts,undo='discard')
        assert any(work for _,work,_ in clean_no_return['rows'])
        # A pair separated by the fine joint record but NOT by the question.
        pair=next((i,j) for i in range(len(m['q'])) for j in range(i)
                  if m['q'][i]==m['q'][j] and
                  tuple(m['probes'][f][i] for f in contacts)!=tuple(m['probes'][f][j] for f in contacts))
        lost=distinguishability(clean_no_return['rows'],*pair)
        assert lost==0
        coherent_results.append({'source':name,'oracle_calls':proper['oracle_uses'],
            'workspace_bits':proper['workspace_bits'],'answer_bits':proper['answer_bits'],
            'operator_check':operator,'unknown_phase_example':'first oracle has phase i**(row mod 2)',
            'forward_instead_of_inverse_error':error,'discarded_work_pair':pair,
            'same_question_coherence_probability':{'with_actual_inverse':retained_probability,
                                                   'with_repeated_forward':repeated_probability},
            'discarded_work_trace_distance':lost})

    rejected=[]
    def reject(name,fn):
        try:fn()
        except (ValueError,AssertionError,KeyError):rejected.append(name)
        else:raise AssertionError('Accepted '+name)
    wrong=deepcopy(certificate);wrong['tree']['probe']='Low'
    reject('contact used before its safe boundary',lambda:c.verify(model,wrong))
    wrong=deepcopy(certificate);wrong['tree']['branches']['0']['branches']['0']['answer']=3
    reject('wrong final answer',lambda:c.verify(model,wrong))
    wrong=deepcopy(certificate);del wrong['tree']['branches']['1']
    reject('omitted possible reply',lambda:c.verify(model,wrong))
    wrong=deepcopy(obstruction);del wrong['tree']['reasons']['Residue']
    reject('obstruction omitted a contact',lambda:c.verify(old,wrong))
    wrong=deepcopy(obstruction);wrong['tree']['reasons']['B']['pair']=[0,0]
    reject('invented destructive pair',lambda:c.verify(old,wrong))
    reject('wrong current source',lambda:c.verify(old,certificate))
    reject('one coherent contact declared sufficient',lambda:c.coherent_acquire(old,('B',)))

    court=json.loads(subprocess.run(['node',str(c.ROOT/'Checks/FiniteContinuation/coarse_acquisition_court.js'),
        'check',str(OUT)],capture_output=True,text=True,check=True,timeout=30).stdout)
    for name,value in [('model',model),('certificate',certificate),('old-model',old),('obstruction',obstruction),('court',court)]:
        (OUT/(name+'.json')).write_text(json.dumps(value,indent=2)+'\n')
    result={'schema':'vi.coarse-acquisition-checks.v1','source':learning.fingerprint(source),
            'measured_policy':{**checked,**exact,'depth_is_minimal_for_this_binary_example':True,
                               'adaptive_transcripts':[{'answer':a,'record':record} for a,record,_ in rows]},
            'measuring_all_contacts':{'branches':len(all_rows),'same_question_pair':[0,1],
                                     'adaptive_output_trace_distance':before,'all_contacts_output_trace_distance':after},
            'old_catalogue_obstruction':{**no,'destructive_pairs':pairs},
            'coherent_alternatives':coherent_results,'negative_cases':rejected,
            'Swift_bounded_court':{'equalities':court['equalities'],'expected_rejections':court['rejections']},
            'new_QPU_jobs':0,'runtime_seconds':time.perf_counter()-started,
            'scope':'Static finite declared source basis and contact instruments; operator checks cover arbitrary reference. '
                    'Measured-language obstruction is not a global quantum impossibility. No full Swift build.'}
    (OUT/'checks.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))


if __name__=='__main__':run()
