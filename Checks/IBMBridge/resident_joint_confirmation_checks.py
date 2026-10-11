#!/usr/bin/env python3
"""Offline checks for the bounded common-endpoint hardware adapter."""
from copy import deepcopy
import io
import json
from pathlib import Path
import tempfile
import time
from unittest.mock import patch

import numpy as np
from qiskit import QuantumCircuit, qpy
from qiskit.circuit import Instruction, Measure
from qiskit.primitives.containers import BitArray, DataBin
from qiskit_aer import AerSimulator

import resident_joint_confirmation as p


def ordinary_measurements(c):
    out=c.copy_empty_like()
    for item in c.data:
        op=item.operation
        if op.name=='measure_2':p.validate_mcm(op);op=Measure(label=op.label)
        elif op.name=='if_else':op=op.replace_blocks([ordinary_measurements(b) for b in op.blocks])
        out.append(op,item.qubits,item.clbits)
    return out


def run():
    before=time.perf_counter();rejected=[];rows=[]
    def reject(name,fn):
        try:fn()
        except (ValueError,TypeError):rejected.append(name);return
        raise AssertionError('Accepted '+name)

    for variant in ('correct','ignore'):
        original,expanded,source,info=p.logical(variant)
        expected,_=p.expected_instrument(original)
        core,final=p.lower_core(expanded);core=p.mcm(core)
        buf=io.BytesIO();qpy.dump(core,buf);buf.seek(0);loaded,=qpy.load(buf)
        assert p.canonical_mcm(loaded)==p.canonical_mcm(core)
        actual,branches=p.native_instrument(loaded,final)
        error=max(float(np.max(abs(actual[k]-expected[k]))) for k in expected)
        assert error<1e-10
        # The final physical permutation is part of the application, not a
        # decorative layout name. Keeping the old addresses changes the map.
        try:wrong,_=p.native_instrument(loaded,list(range(5)))
        except ValueError:rejected.append(variant+':discarded final physical layout')
        else:
            assert max(np.max(abs(wrong[k]-expected[k])) for k in expected)>1e-3
            rejected.append(variant+':discarded final physical layout')
        circuit=ordinary_measurements(p.add_witness(loaded,final))
        result=AerSimulator(method='statevector',max_parallel_threads=1).run(
            circuit,shots=p.SHOTS,memory=True,seed_simulator=150920+len(rows)).result()
        assert result.success
        returned=next(r for r in circuit.cregs if r.name=='joint_answers')
        witness=next(r for r in circuit.cregs if r.name=='witness')
        def strings(reg):
            indices=[circuit.find_bit(b).index for b in reg]
            return [''.join(str((int(word.replace(' ',''),2)>>i)&1) for i in indices[::-1]) for word in result.get_memory()]
        data=DataBin(joint_answers=BitArray.from_samples(strings(returned),num_bits=2),witness=BitArray.from_samples(strings(witness),num_bits=2))
        sample=p.read_samples(data);assert sample['tuple_00_count']==0
        rows.append({'variant':variant,'full_QPY_instrument_residual':error,'branches':branches,
                     'Aer_shots':p.SHOTS,'Aer_mean':sample['mean']})
    assert rows[0]['Aer_mean']-rows[1]['Aer_mean']>.2

    # All 16 measured tuple/witness words verify sign and shot alignment.
    for code in range(4):
        for w in range(4):
            data=DataBin(joint_answers=BitArray.from_samples([format(code,'02b')]*p.SHOTS,num_bits=2),
                         witness=BitArray.from_samples([format(w,'02b')]*p.SHOTS,num_bits=2))
            assert p.read_samples(data)['mean']==p.WEIGHTS[code]*(-1)**w.bit_count()
    words=[format(i%4,'02b') for i in range(p.SHOTS)]
    data=DataBin(joint_answers=BitArray.from_samples(words,num_bits=2),witness=BitArray.from_samples(words,num_bits=2))
    assert p.read_samples(data)['mean']==-.5
    shifted=DataBin(joint_answers=data.joint_answers,witness=BitArray.from_samples(words[2:]+words[:2],num_bits=2))
    assert p.read_samples(shifted)['mean']==.5
    # Equal marginal counts do not preserve the paired statistic.
    assert data.witness.get_counts()==shifted.witness.get_counts()
    reject('missing measured tuple',lambda:p.read_samples(DataBin(witness=data.witness)))
    reject('wrong shot count',lambda:p.read_samples(DataBin(joint_answers=BitArray.from_samples(['00']),witness=data.witness)))
    fake=Instruction('measure_2',1,1,[]);fake.definition=QuantumCircuit(1,1);fake.definition.x(0)
    reject('named MCM with another body',lambda:p.validate_mcm(fake))
    reject('MCM with unexpected parameter',lambda:p.validate_mcm(Instruction('measure_2',1,1,[.5])))
    reject('MCM on another number of ports',lambda:p.validate_mcm(Instruction('measure_2',2,1,[])))

    frozen={'schema':'vi.ibm.common-endpoint-confirmation.v1','instance_plan':'open','backend':'ibm_kingston',
            'shots':p.SHOTS,'max_execution_seconds':p.MAX_SECONDS,'order':list(p.ORDER),
            'tag':'test-budget','options':p.options('test-budget')}
    for field,value in (('max_execution_time',600),('default_shots',4096)):
        changed=deepcopy(frozen);changed['options'][field]=value
        with patch.object(p,'read',return_value=changed):
            reject('changed actual sampler '+field,lambda:p.load(Path('/unused-offline-budget-test')))

    # No SDK client is allowed to submit in these transport failure cases.
    class Status:
        operational=True;status_msg='maintenance'
    class Backend:
        def status(self):return Status()
    class Service:
        def active_instance(self):return 'test-only-open'
        def backend(self,name):return Backend()
        def jobs(self,**kwargs):return []
    plan={'schema':'vi.ibm.common-endpoint-confirmation.v1','implementation':{},'versions':{},
          'source_sha256':{},'instance':'test-only-open','backend':'test-backend',
          'tag':'test-only-tag','qpy_sha256':'test-only-hash'}
    with tempfile.TemporaryDirectory() as tmp:
        folder=Path(tmp)
        with patch.object(p,'load',return_value=(plan,[])),patch.object(p,'implementation',return_value={}),\
             patch.object(p,'versions',return_value={}),patch.object(p.s,'reading',return_value={'source_sha256':{}}),\
             patch.object(p,'service_open',return_value=Service()),\
             patch.object(p,'SamplerV2',side_effect=AssertionError('Forbidden sender')):
            assert p.submit(folder)['submitted'] is False and not (folder/'ledger.json').exists()
            p.dump(folder/'ledger.json',{'tag':plan['tag'],'qpy_sha256':plan['qpy_sha256'],'status':'intent'})
            reject('uncertain send cannot be repeated',lambda:p.submit(folder))
            ledger={'tag':plan['tag'],'qpy_sha256':plan['qpy_sha256'],'status':'submitted','job_id':'existing'}
            p.dump(folder/'ledger.json',ledger);assert p.submit(folder)==ledger
            ledger['qpy_sha256']='another-circuit';p.dump(folder/'ledger.json',ledger)
            reject('wrong submitted bytes',lambda:p.submit(folder))
    result={'cases':rows,'rejected':rejected,'paired_record_sign_cases':16,
            'same_marginals_do_not_determine_witness':True,'seconds':time.perf_counter()-before,
            'scope':'Offline adapter/ISA checks. No hardware result or statistical guarantee.'}
    p.dump(p.ART/'adapter-audit.json',result)
    print(json.dumps(result,indent=2))


if __name__=='__main__':run()
