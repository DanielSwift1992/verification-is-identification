#!/usr/bin/env python3
"""Targeted checks for the independent byte/wire reader and exact contrasts."""
import argparse
import base64
from collections import Counter
import io
import json
from pathlib import Path
import tempfile
import zlib

import numpy as np
from qiskit import qpy
from scipy.stats import fisher_exact

import resident_wire_audit as w


def run(output):
    values=np.resize(np.array([4,4,4,8,3,3,1,15,0,7],dtype=np.uint8),1024).reshape(1024,1)
    buf=io.BytesIO();np.save(buf,values,allow_pickle=False)
    wrapped={'__type__':'PrimitiveResult','__value__':{'pub_results':[{'__type__':'SamplerPubResult','__value__':{
        'metadata':{'circuit_metadata':{}},'data':{'__type__':'DataBin','__value__':{'field_names':['out'],'shape':[],
        'fields':{'out':{'__type__':'BitArray','__value__':{'num_bits':4,'array':{'__type__':'ndarray','__value__':base64.b64encode(zlib.compress(buf.getvalue())).decode()}}}}}}}}]}}
    with tempfile.TemporaryDirectory(prefix='vi-wire-decoder-') as temp:
        p=Path(temp)/'raw.json';p.write_text(json.dumps(wrapped));decoded=w.raw_arrays(p)[0]
        assert decoded['ints']==[int(x) for x in values[:,0]]
        assert decoded['counts']==dict(Counter(format(int(x),'04b') for x in values[:,0]))
    directory=w.ROOT/'private/ibm-resident-boundary-20260915'
    with (directory/'isa.qpy').open('rb') as stream:circuits=qpy.load(stream)
    base=next(c for c in circuits if (c.metadata['variant'],c.metadata['probe'])==('Baseline11','Z'))
    # Remove C preparation. The independent branch calculation must reveal
    # the change rather than inheriting a desired bit from circuit metadata.
    changed=base.copy_empty_like()
    for ins in base.data:
        qs=[base.find_bit(q).index for q in ins.qubits];cs=[base.find_bit(b).index for b in ins.clbits]
        if ins.operation.name=='x' and qs==[16]:continue
        changed.append(ins.operation,qs,cs)
    before,_=w.diagnostic_ideal(base);after,traces=w.diagnostic_ideal(changed)
    assert traces[0]['ideal_C']==0 and max(abs(before[k]-after[k]) for k in before)>.99
    bad=base.copy_empty_like()
    for ins in base.data:
        qs=[base.find_bit(q).index for q in ins.qubits];cs=[base.find_bit(b).index for b in ins.clbits]
        if ins.operation.name=='measure' and cs==[2]:qs=[3]
        bad.append(ins.operation,qs,cs)
    refused=False
    try:w.diagnostic_ideal(bad)
    except AssertionError:refused=True
    assert refused
    report=w.read(output/'audit.json');pairs=report['exploratory_stationary_channel_test']['pairs'];maximum=0.
    for p in pairs:
        k,l=p['C_one_counts'];want=fisher_exact([[k,1024-k],[l,1024-l]]).pvalue
        error=abs(want-p['two_sided_exact_p']);assert error<1e-12;maximum=max(maximum,error)
    assert w.fisher_two_sided(0,10,0,10)==1 and w.fisher_two_sided(10,10,10,10)==1
    result={'nonuniform_packed_samples_checked':1024,'source_preparation_removal_detected':True,
            'wrong_physical_measurement_wire_rejected':True,'exact_Fisher_pairs_crosschecked':len(pairs),
            'maximum_Fisher_difference_from_SciPy':maximum,'new_QPU_jobs':0,
            'audit_sha256':w.digest(output/'audit.json'),'check_sha256':w.digest(Path(__file__))}
    w.write(output/'checks.json',result);return result


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    print(json.dumps(run(p.parse_args().output.resolve()),indent=2))
