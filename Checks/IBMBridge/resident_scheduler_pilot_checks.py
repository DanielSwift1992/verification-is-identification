#!/usr/bin/env python3
"""Bounded offline checks of timing admission and the surviving SPAM ambiguity."""
from copy import deepcopy
from fractions import Fraction as F
import io
import json
from pathlib import Path
import tempfile
from unittest.mock import patch

from qiskit import QuantumCircuit, qpy
from qiskit.circuit import Instruction
from qiskit_ibm_runtime.options import SamplerOptions

import resident_scheduler_pilot as p


def checks():
    rejected = []
    def reject(name, thunk):
        try:
            thunk()
        except (ValueError, TypeError):
            rejected.append(name)
            return
        raise AssertionError('Should reject: '+name)

    view = {'dt_seconds': 4e-9, 'timing_constraints': {'granularity': 1, 'pulse_alignment': 1, 'acquire_alignment': 1}}
    assert [p.exact_ticks(x,view) for x in (32,1380,2000)] == [8,345,500]
    reject('fractional cycle needs a separate rounding proof', lambda:p.exact_ticks(33,view))
    aligned = deepcopy(view); aligned['timing_constraints']['pulse_alignment'] = 16
    reject('integer cycles alone do not establish target alignment', lambda:p.exact_ticks(32,aligned))
    reject('zero clock scale', lambda:p.exact_ticks(32,{'dt_seconds': 0}))
    typed = QuantumCircuit(2,1)
    p.d.ns_delay(typed,2000,0)
    with typed.if_test((typed.clbits[0],1)):
        p.d.ns_delay(typed,32,1)
    lowered, inventory = p.lower_durations(typed,view)
    assert [i['output_dt'] for i in inventory] == [500,8]
    stream=io.BytesIO(); qpy.dump(lowered,stream); stream.seek(0)
    loaded,=qpy.load(stream)
    assert loaded == lowered and p.body_signature(loaded) == p.body_signature(lowered)
    wrong=QuantumCircuit(1); wrong.delay(2000,0,unit='ns')
    reject('numeric ns is not the submitted dt representation', lambda:p.body_signature(wrong))
    fake=QuantumCircuit(1,1); op=Instruction('measure_2',1,1,[]); op.definition=QuantumCircuit(1,1); op.definition.x(0)
    fake.append(op,[0],[0])
    reject('named measurement with a hidden different body', lambda:p.body_signature(fake))

    # Synthetic schedule, not IBM data. Deliberately keeps controller and both
    # branches; a parse must never become a proof of equal C storage age.
    rows=['main,barrier,Qubit 16,10,0,barrier',
          'then,x_3,Qubit 3,12,8,play', 'else,barrier,Qubit 3,20,0,barrier',
          'main,broadcast,Hub,21,5,broadcast','main,receive,Receive,26,2,receive',
          'main,measure_16,Qubit 16,28,8,play','main,measure_16,AWGR1_16,36,32,capture']
    a=p.parse_timing(rows); b=p.parse_timing('\n'.join(rows))
    assert a['rows']==b['rows'] and a['branches']==['else','main','then']
    assert a['equal_C_age_established'] is False
    reject('nested timing payload',lambda:p.parse_timing([rows]))
    reject('list item contains multiple rows',lambda:p.parse_timing(['\n'.join(rows)]))
    reject('truncated schedule row',lambda:p.parse_timing(['main,measure_16,Qubit 16,1,2']))
    reject('fractional server cycles require another parser',lambda:p.parse_timing(['main,x_3,Qubit 3,1.5,2,play']))
    reject('negative server cycle',lambda:p.parse_timing(['main,x_3,Qubit 3,-1,2,play']))
    reject('empty schedule',lambda:p.parse_timing(''))
    missing=p.schedule_evidence({},4e-9); assert not missing['available']
    malformed=p.schedule_evidence({'compilation': {'scheduler_timing': {'timing': 'bad'}}},4e-9)
    assert malformed['raw']=='bad' and 'parse_error' in malformed and not malformed['equal_C_age_established']
    existing={'experimental': {'execution': {'stretch_values': True}, 'other': 123},'execution': {'init_qubits': True}}
    merged=p.timing_options(existing)
    assert existing['experimental']['execution']=={'stretch_values': True}
    assert merged['experimental']=={'execution': {'stretch_values': True,'scheduler_timing': True},'other':123}
    assert merged['execution']==existing['execution']
    SamplerOptions(**p.options('offline-validation'))

    # Check no-run transitions without constructing a service or accessing IBM.
    class Backend: pass
    class Service:
        def active_instance(self): return 'test-only-open'
        def backend(self,name): assert name=='ibm_kingston'; return Backend()
        def jobs(self,**kwargs): return []
    plan={'implementation':p.implementation(),'versions':p.versions(),'source_sha256':{},
          'instance':'test-only-open','backend':'ibm_kingston','tag':'test-only-tag','qpy_sha256':'test-only-hash'}
    with tempfile.TemporaryDirectory() as tmp:
        path=Path(tmp)
        with patch.object(p,'load',return_value=(plan,[])), patch.object(p,'source_material',return_value=({'source_sha256':{}},[],[])), \
             patch.object(p,'service_open',return_value=Service()), patch.object(p,'target_view',return_value={'operational':True,'status':'maintenance'}), \
             patch.object(p,'SamplerV2',side_effect=AssertionError('Must not construct a submitting sampler')):
            result=p.submit(path)
            assert result['submitted'] is False and not (path/'ledger.json').exists()
            p.dump(path/'ledger.json',{'tag':plan['tag'],'qpy_sha256':plan['qpy_sha256'],'status':'intent'})
            reject('uncertain submission with no identified job must not retry',lambda:p.submit(path))
            ledger={'tag':plan['tag'],'qpy_sha256':plan['qpy_sha256'],'job_id':'already-sent','status':'submitted'}
            p.dump(path/'ledger.json',ledger)
            assert p.submit(path)==ledger

    return {'negative_cases':rejected, 'negative_count':len(rejected),
        'positive': ['exact ns-to-dt including branch and QPY round-trip',
                    'both documented schedule representations, all branches retained',
                    'missing/malformed schedule never grants physical age',
                    'experimental options merged; local SDK options accepted',
                    'maintenance and existing/uncertain intent never create another job']}


def channel_ambiguity():
    """Exact polynomial coefficients for every unitary, then affine channels.

    A unitary's rotated Bloch Z component is an arbitrary t in [-1,1].
    Comparing constant and t coefficient proves equality for all t, rather
    than sampling finitely many rotation angles.
    """
    scale,mu=F(5,6),F(13,20)
    effects=((F(2,5),F(9,10)),(F(7,20),F(19,20)))
    probabilities=(F(1,5),F(4,5),F(1,4),F(3,4),F(2,5),F(3,5))
    rows=[]
    for r in probabilities:
        r_b=F(1,2)+scale*(r-F(1,2))
        require_state=(0<=r<=1 and 0<=r_b<=1)
        assert require_state and all(0<=v<=1 for e in effects for v in e)
        polynomials=[]
        for state,(m0,m1) in zip((r,r_b),effects):
            polynomials.append(((m0+m1)/2,(m0-m1)*(1-2*state)/2))
        assert polynomials[0]==polynomials[1]
        rows.append({'A_p1':str(r),'B_p1':str(r_b),'unitary_response_constant':str(polynomials[0][0]),
                     'unitary_response_t_coefficient':str(polynomials[0][1])})
    # z -> gain*z + shift: all channels below are established CPTP examples.
    # reset_plus is nonunital but has zero Z shift, so this measurement cannot
    # distinguish it. Merely adding a nonunitary/nonunital command is insufficient.
    channels={'identity':(F(1),F(0)), 'dephasing_Z':(F(1),F(0)),
              'depolarizing_half':(F(1,2),F(0)), 'reset_zero':(F(0),F(1)),
              'reset_plus':(F(0),F(0)), 'amplitude_damping_third':(F(2,3),F(1,3))}
    results={}
    for name,(gain,shift) in channels.items():
        gaps=[]
        for r in probabilities:
            z=1-2*r; z_b=scale*z
            m_a=(effects[0][0]-effects[0][1])/2
            m_b=(effects[1][0]-effects[1][1])/2
            pa=mu+m_a*(gain*z+shift); pb=mu+m_b*(gain*z_b+shift)
            expected=(1/scale-1)*m_a*shift
            assert pb-pa==expected
            gaps.append(str(pb-pa))
        results[name]={'B_minus_A':gaps[0],'independent_of_all_six_preparations':len(set(gaps))==1}
    return {'scope':'Exact model counterexample; no inference of Kingston preparation or readout.',
            'unitary_polynomials':rows,'known_channel_examples':results}


if __name__=='__main__':
    print(json.dumps({'adapter':checks(),'theory':channel_ambiguity()},indent=2))
