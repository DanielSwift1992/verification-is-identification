#!/usr/bin/env python3
"""Read-only independent byte/register/wire audit of the two frozen night jobs.

No IBM client, network, new job, or mutation of the original packets. Raw
ndarrays are decoded without RuntimeDecoder/BitArray counts. The diagnostic
QPY is interpreted as three separate one-qubit branch states, since it has
no entangling gates; this does not reuse either experiment's ideal reader.
"""
import argparse
import base64
from collections import Counter
from fractions import Fraction
from hashlib import sha256
import io
from itertools import combinations,product
import json
import math
from pathlib import Path
import zlib

import numpy as np
from qiskit import qpy

ROOT=Path(__file__).resolve().parents[2]
I=np.eye(2,dtype=complex);X=np.array([[0,1],[1,0]],complex)
SX=np.array([[1+1j,1-1j],[1-1j,1+1j]])/2


def digest(path):return sha256(path.read_bytes()).hexdigest()
def read(path):return json.loads(path.read_text())
def write(path,value):path.parent.mkdir(parents=True,exist_ok=True);path.write_text(json.dumps(value,indent=2)+'\n')


def raw_arrays(path):
    obj=read(path);assert obj['__type__']=='PrimitiveResult';out=[]
    for pub in obj['__value__']['pub_results']:
        assert pub['__type__']=='SamplerPubResult';p=pub['__value__'];db=p['data']
        assert db['__type__']=='DataBin';db=db['__value__']
        assert db['field_names']==['out'] and db['shape']==[]
        ba=db['fields']['out'];assert ba['__type__']=='BitArray';ba=ba['__value__']
        ar=ba['array'];assert ar['__type__']=='ndarray'
        uncompressed=zlib.decompress(base64.b64decode(ar['__value__'],validate=True))
        assert uncompressed[:6]==b'\x93NUMPY'
        values=np.load(io.BytesIO(uncompressed),allow_pickle=False)
        assert values.dtype==np.uint8 and values.ndim==2 and values.shape==(1024,1)
        width=ba['num_bits'];assert width in (2,4)
        ints=[int(row[0])&((1<<width)-1) for row in values]
        counts=Counter(format(x,f'0{width}b') for x in ints)
        out.append({'metadata':p['metadata']['circuit_metadata'],'width':width,
                    'ints':ints,'counts':dict(counts),'array_sha256':sha256(values.tobytes()).hexdigest()})
    return out


def flatten(c):
    result=[]
    def walk(block,qs,cs,conditions):
        for item in block.data:
            op=item.operation
            q=[qs[block.find_bit(x).index] for x in item.qubits]
            cb=[cs[block.find_bit(x).index] for x in item.clbits]
            if op.name=='if_else':
                bit,value=op.condition;assert not hasattr(bit,'size');condition=(cs[block.find_bit(bit).index],int(value))
                for index,b in enumerate(op.blocks):
                    assert index in (0,1)
                    walk(b,q,cb,conditions+[(condition[0],condition[1] if index==0 else 1-condition[1])])
            else:result.append({'name':op.name,'qubits':q,'clbits':cb,'params':[float(x) for x in op.params],
                                'conditions':conditions})
    walk(c,list(range(c.num_qubits)),list(range(c.num_clbits)),[])
    return result


def route(c):
    assert len(c.cregs)==1 and c.cregs[0].name=='out'
    reg=c.cregs[0];index={c.find_bit(bit).index:i for i,bit in enumerate(reg)}
    reads={}
    for item in flatten(c):
        if item['name'] not in ('measure','measure_2'):continue
        assert not item['conditions'] and len(item['clbits'])==len(item['qubits'])==1
        j=index[item['clbits'][0]];assert j not in reads
        reads[j]={'physical_qubit':item['qubits'][0],'instruction':item['name'],'register':'out','register_bit':j}
    assert set(reads)==set(range(reg.size));return reads


def diagnostic_ideal(c):
    steps=flatten(c);reads=route(c);register=c.cregs[0]
    clindex={c.find_bit(bit).index:i for i,bit in enumerate(register)}
    wires={3,16,23};distributions={};clock_traces=[]
    for b in (0,1):
        rho={q:np.diag([1.,0.]).astype(complex) for q in wires};terminal={};clock_ops=[]
        for item in steps:
            op=item['name'];qs=item['qubits']
            if op=='barrier':continue
            assert len(qs)==1 and qs[0] in wires
            assert all(clindex[j]==0 for j,value in item['conditions'])
            if any(b!=value for j,value in item['conditions']):continue
            q=qs[0]
            if q==16:
                assert not item['conditions'];clock_ops.append({'name':op,'params':item['params']})
            if op=='reset':rho[q]=np.trace(rho[q])*np.diag([1.,0.]);continue
            if op in ('measure','measure_2'):
                j=clindex[item['clbits'][0]]
                if j==0:
                    p=np.diag([int(b==0),int(b==1)]);rho[q]=p@rho[q]@p
                else:terminal[j]=q
                continue
            if op in ('delay','id'):g=I
            elif op=='x':g=X
            elif op=='sx':g=SX
            elif op=='rz':
                angle=item['params'][0];g=np.diag([np.exp(-.5j*angle),np.exp(.5j*angle)])
            else:raise AssertionError('Diagnostic no longer separable: '+op)
            rho[q]=g@rho[q]@g.conj().T
        assert terminal=={1:23,2:16,3:3}
        assert abs(np.trace(rho[16])-1)<1e-12 and abs(np.trace(rho[3])-1)<1e-12
        want=int(np.real(rho[16][1,1])>.5)
        assert abs(np.real(rho[16][want,want])-1)<1e-12
        clock_traces.append({'acquired_b':b,'actual_QPY_clock_operations':clock_ops,'ideal_C':want})
        for p,cbit,d in product((0,1),repeat=3):
            probability=float((rho[3][p,p]*rho[16][cbit,cbit]*rho[23][d,d]).real)
            distributions[f'{p}{cbit}{d}{b}']=probability
    assert abs(sum(distributions.values())-1)<1e-12
    assert clock_traces[0]['ideal_C']==clock_traces[1]['ideal_C']
    return distributions,clock_traces


def fisher_two_sided(k,n,l,m):
    # Exact integer hypergeometric weights; no asymptotic standard errors.
    total=k+l;lo=max(0,total-m);hi=min(n,total)
    observed=math.comb(n,k)*math.comb(m,l)
    numerator=sum(w for j in range(lo,hi+1) if (w:=math.comb(n,j)*math.comb(m,total-j))<=observed)
    return float(Fraction(numerator,math.comb(n+m,total)))


def stationary_diagnostic(rows):
    pairs=[]
    for desired in (0,1):
        selected=[x for x in rows if x['ideal_C']==desired]
        for x,y in combinations(selected,2):
            p=fisher_two_sided(x['observed_C_one'],1024,y['observed_C_one'],1024)
            pairs.append({'intended_C':desired,'left':x['case'],'right':y['case'],
                          'C_one_counts':[x['observed_C_one'],y['observed_C_one']],
                          'two_sided_exact_p':p})
    assert len(pairs)==72
    for p in pairs:p['bonferroni_72_p']=min(1.,72*p['two_sided_exact_p'])
    return {'scope':'Exploratory test of one context-independent memoryless Bernoulli C readout probability per intended C, including perfect intended preparations. Not the primary predeclared endpoint, and not a microscopic cause test.',
            'family_size':72,'alpha':.01,'pairs':pairs,
            'rejected_at_family_alpha':[p for p in pairs if p['bonferroni_72_p']<.01]}


def audit(output):
    all_rows={};original_hashes={};deep_rows=[]
    for label,dirname in [('feedback','ibm-resident-acquisition-20260915'),('boundary','ibm-resident-boundary-20260915')]:
        directory=ROOT/'private'/dirname
        original_hashes.update({str(p.relative_to(ROOT)):digest(p) for p in directory.rglob('*') if p.is_file()})
        plan=read(directory/'plan.json');hardware=read(directory/'hardware-result.json')
        assert hardware['status']=='DONE' and digest(directory/'raw-result.json')==hardware['raw_sha256']
        assert digest(directory/'isa.qpy')==plan['qpy_sha256']
        arrays=raw_arrays(directory/'raw-result.json')
        with (directory/'isa.qpy').open('rb') as stream:circuits=qpy.load(stream)
        assert len(arrays)==len(circuits)==len(hardware['rows'])
        old={(x['variant'],x['probe']):x for x in hardware['rows']}
        ideals={(x['variant'],x['probe']):x['ideal_probabilities'] for x in read(directory/'ideal-validation.json')}
        results=[]
        for array,c in zip(arrays,circuits):
            assert array['metadata']==c.metadata and array['width']==c.cregs[0].size
            key=(c.metadata['variant'],c.metadata['probe'])
            assert array['counts']==old[key]['counts']
            wiring=route(c);entry={'case':':'.join(key),'width':array['width'],'raw_counts_equal_collector':True,
                                 'raw_array_sha256':array['array_sha256'],'register_routes':wiring}
            if label=='boundary':
                assert [wiring[j]['physical_qubit'] for j in range(4)]==[23,23,16,3]
                distribution,traces=diagnostic_ideal(c)
                err=max(abs(distribution[k]-ideals[key][k]) for k in distribution);assert err<1e-10
                zero=1024-sum((x>>2)&1 for x in array['ints']);desired=traces[0]['ideal_C']
                original_count=hardware['analysis']['cases'][':'.join(key)]['questions']['clock']['count']
                assert original_count==(1024-zero if desired else zero)
                entry.update({'independent_ideal_max_residual':err,'C_preparation_trace':traces,
                              'ideal_C':desired,'observed_C_zero':zero,'observed_C_one':1024-zero,
                              'observed_C_agreement':original_count})
                deep_rows.append(entry)
            else:
                assert all(x['physical_qubit']==23 for x in wiring.values())
            results.append(entry)
        all_rows[label]={'job_id':hardware['job_id'],'circuits':len(circuits),'shots':1024*len(circuits),'cases':results}
    statistics=stationary_diagnostic(deep_rows)
    assert all(digest(ROOT/n)==h for n,h in original_hashes.items())
    result={'schema':'vi.resident-wire-audit.v1','raw_byte_and_QPY_audit':all_rows,
            'exploratory_stationary_channel_test':statistics,'original_packet_sha256':original_hashes,
            'original_packets_unchanged':True,'network_calls':0,'new_QPU_jobs':0,
            'implementation_sha256':digest(Path(__file__))}
    write(output/'audit.json',result);return result


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    result=audit(p.parse_args().output.resolve())
    print(json.dumps({'jobs':{k:{q:v[q] for q in ('job_id','circuits','shots')} for k,v in result['raw_byte_and_QPY_audit'].items()},
                      'packets_unchanged':result['original_packets_unchanged'],
                      'stationary_channel_rejections':result['exploratory_stationary_channel_test']['rejected_at_family_alpha']},indent=2))
