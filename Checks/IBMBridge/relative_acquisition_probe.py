#!/usr/bin/env python3
"""Compare acquisition with the final actual source, and memory with its future."""

import sys as _evidence_sys
from pathlib import Path as _EvidencePath
_evidence_sys.path.insert(0, str(_EvidencePath(__file__).resolve().parents[1]))
import hardware_runs as _runs
_runs.configure(required=(__name__ == "__main__"))
import argparse
import io
import json
from pathlib import Path
from qiskit import QuantumCircuit,ClassicalRegister,transpile,qpy
from qiskit_aer import AerSimulator
from pilot import service_open,require,compact_active
from resident_joint_confirmation import place
from classical_boundary_probe import aer_form
import relative_acquisition as relative
import arrival_failure_localization as diag
import arrival_boundary_probe as old
import bounded_open_experiment as cloud

ROOT=old.ROOT
PRIVATE=_runs.work('ibm-relative-acquisition-20260916')
ART=ROOT/'Research/Artifacts/relative-acquisition-20260916/attempt-1'
TAG='vi-relative-acquisition-1-20260916'
ARMS=('two_readings','one_reading','echo')

def witness(core,final,a,b,basis):
    q=QuantumCircuit(6)
    if a:q.x(1)
    if b=='+':q.h(2)
    elif b=='1':q.x(2)
    else:require(b=='0','Unknown B preparation')
    q.h(3);q.cx(3,4);q.x(5)
    q=transpile(q,basis_gates=['rz','sx','x','id','cz'],optimization_level=0)
    for reg in core.cregs:q.add_register(reg)
    q.compose(core,inplace=True)
    tail=QuantumCircuit(6)
    tail.h(final[3]);tail.h(final[3]);tail.sdg(final[3]);tail.h(final[3])
    tail.h(final[2])
    if basis=='XX':tail.h(final[3]);tail.h(final[4])
    tail=transpile(tail,basis_gates=['rz','sx','x','id','cz'],optimization_level=0)
    q.compose(tail,inplace=True)
    w=ClassicalRegister(3,'witness');source=ClassicalRegister(1,'source_check')
    q.add_register(w,source)
    q.measure([final[2],final[3],final[4]],w);q.measure(final[1],source[0])
    return q

def check_witness(q,arm,a,b):
    q=aer_form(compact_active(q))
    result=AerSimulator(max_parallel_threads=1).run(q,shots=32,memory=True,seed_simulator=160917).result()
    require(result.success,'Ideal witness failed')
    def read(value,name):
        reg=next(r for r in q.cregs if r.name==name)
        return sum(((value>>q.find_bit(bit).index)&1)<<i for i,bit in enumerate(reg))
    for sample in result.get_memory():
        v=int(sample.replace(' ',''),2);w=read(v,'witness')
        require(read(v,'actual_arrival')==1 and read(v,'source_check')==a,'Source/request relation lost')
        require(((w>>1)&1)==((w>>2)&1),'Data continuation failed')
        if arm!='two_readings' and b=='+':require((w&1)==0,'Preserved B coherence lost')
        if arm=='two_readings':
            r=read(v,'actual_replies');require(((r&1)^((r>>1)&1))==a,'Joint acquired law changed')
            if b!='+':require((r&1)==int(b),'Point B reading changed')
        if arm=='one_reading':require(read(v,'actual_a')==a,'Direct relative reading changed')

def prepare():
    require(not (PRIVATE/'plan.json').exists(),'Already prepared')
    cert=relative.certificate();new,final=relative.core();oldcores=diag.contexts()
    cores={'two_readings':oldcores['conditional'],'one_reading':new,'echo':oldcores['echo']}
    for arm in ('two_readings','echo'):old.operator_check(cores[arm],final,'conditional' if arm=='two_readings' else 'echo')
    cases=[(a,'+',basis,arm) for a in (0,1) for basis in ('XX','ZZ') for arm in ARMS]
    cases += [(1,b,'ZZ',arm) for b in ('0','1') for arm in ('two_readings','one_reading')]
    base=cloud.read(diag.OLD/'plan.json');service=service_open();backend=service.backend(base['backend'])
    qs=[]
    for a,b,basis,arm in cases:
        q=witness(cores[arm],final,a,b,basis)
        q.metadata={'tag':TAG,'pub_index':len(qs),'arm':arm,'prepared_a':a,'prepared_b':b,
                    'prepared_arrival':1,'basis':basis,'ideal_B_X':1 if arm!='two_readings' and b=='+' else 0,
                    'ideal_data_parity':1,'ideal_acquired_a':None if arm=='echo' else a}
        q=place(q,base['path'],backend.num_qubits)
        buf=io.BytesIO();qpy.dump(q,buf);buf.seek(0);restored,=qpy.load(buf)
        check_witness(restored,arm,a,b)
        qs.append(q)
    plan={'schema':'vi.relative-acquisition-probe.v1','attempt':1,'tag':TAG,'shots_each':128,
          'path':base['path'],'final_layout':final,'relative_instrument_certificate':cert,
          'analysis':'All shots. Compare acquired A to outgoing measured A, outgoing A to preparation, '
                     'and acquired A to preparation separately; final source readout is not a trusted oracle. '
                     'Also B_X and Bell XX/ZZ. Main balanced cells A=0/1,B=+ across 3 arms; '
                     'B=0/1 cells diagnose original individual readings. No timing attribution, '
                     'postselection, arbitrary-state hardware certification or claim of using only the old classical probe catalogue.'}
    dependencies=[_runs.owned(__file__),_runs.owned(relative.__file__),_runs.owned(old.__file__),_runs.owned(diag.__file__),ROOT/'Checks/IBMBridge/classical_boundary_probe.py']
    return cloud.freeze(PRIVATE,ART,qs,plan,service,backend,dependencies)

if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('stage',choices=['prepare','submit','collect']);stage=p.parse_args().stage
    print(json.dumps(_runs.bind_receipt(prepare() if stage=='prepare' else getattr(cloud,stage)(PRIVATE,ART)),indent=2))
