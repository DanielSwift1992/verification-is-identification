#!/usr/bin/env python3
"""Secondary readings of frozen QPU counts; no network or new execution.

Keeps three questions distinct: Bell-sector weight, member selection, and
record-conditioned terminal reading. Two mathematical completions concern ONLY
the three pooled correlators, not the full recorded joint distribution.
"""
import argparse
from fractions import Fraction as F
import hashlib
import json
from pathlib import Path


def number(x):return {'fraction':str(x),'value':float(x)}


def main():
    import numpy as np
    from qiskit.quantum_info import Statevector,DensityMatrix,Pauli,partial_trace
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--input',type=Path,required=True)
    parser.add_argument('--output',type=Path,required=True)
    args=parser.parse_args()
    data=json.loads(args.input.read_text())
    observations=data['observations'];correlations={};virtual={}
    assert len(observations)==9
    for row in observations:
        p,b=row['policy'],row['basis'];counts=row['record_then_out_counts']
        assert row['shots']==sum(counts.values())==1024
        total,adjusted=0,0
        for key,n in counts.items():
            record,out=key.split(':')
            assert len(record)==len(out)==2 and set(record+out)<={'0','1'}
            sign=1 if out[0]==out[1] else -1
            total+=sign*n
            correction=-1 if b in ('XX','ZZ') and record[0]=='1' else 1
            adjusted+=correction*sign*n
        correlations[p,b]=F(total,1024)
        if p=='ignore_reply':virtual[b]=F(adjusted,1024)
    sector={}
    for policy in ('acquired','ignore_reply','invert_reply'):
        x,y,z=[correlations[policy,b] for b in ('XX','YY','ZZ')]
        s,d=(1-y)/2,(x+z)/2
        sector[policy]={'sector_weight':number(s),'member_difference':number(d),
                        'conditional_99pct_sector_interval':[float(s)-.0605,float(s)+.0605],
                        'conditional_99pct_difference_interval':[float(d)-.121,float(d)+.121]}
    virtual_b=(1+virtual['XX']-virtual['YY']+virtual['ZZ'])/4
    physical_b=sum((correlations['acquired',b]*(1 if b!='YY' else -1) for b in ('XX','YY','ZZ')),F(1))/4

    # Verify the observable pullback with the official Pauli matrices.
    Y=Pauli('Y').to_matrix()
    for name,sign in [('X',-1),('Y',1),('Z',-1)]:
        op=Pauli(name).to_matrix()
        assert np.allclose(Y@op@Y,sign*op)

    x,y,z=[correlations['ignore_reply',b] for b in ('XX','YY','ZZ')]
    probabilities=[(1+x-y+z)/4,(1-x+y+z)/4,(1+x+y-z)/4,(1-x-y-z)/4]
    assert all(p>=0 for p in probabilities) and sum(probabilities)==1
    # This is a constructive separable decomposition, not just a numerical PPT test.
    white=1-abs(x)-abs(y)-abs(z)
    assert white>=0
    bell=np.array([[1,0,0,1],[1,0,0,-1],[0,1,1,0],[0,1,-1,0]],dtype=complex)/np.sqrt(2)
    rho=DensityMatrix(sum(float(p)*np.outer(v,v.conj()) for p,v in zip(probabilities,bell)))
    pure=Statevector(sum(np.sqrt(float(p))*phase*v for p,phase,v in
                         zip(probabilities,[1,1j,1j,1],bell)))
    for state in (rho,pure):
        for basis,expected in zip(('XX','YY','ZZ'),(x,y,z)):
            assert np.isclose(state.expectation_value(Pauli(basis)),float(expected))
    assert np.allclose(partial_trace(pure,[0]).data,np.eye(2)/2)
    completions={name:{b:float(np.real(state.expectation_value(Pauli(b))))
                        for b in ('XX','YY','ZZ','XZ','ZX')}
                 for name,state in [('separable_bell_diagonal',rho),('pure_maximally_entangled',pure)]}
    result={'schema':'vi.ibm.reading-scope.v1','job_id':data['job_id'],
            'source_observations_sha256':hashlib.sha256(args.input.read_bytes()).hexdigest(),
            'sector_and_member':sector,
            'virtual_terminal_reading':{'correlations':{k:number(v) for k,v in virtual.items()},
                'bell_score':number(virtual_b),'physical_correction_score':number(physical_b),
                'difference_from_physical':number(virtual_b-physical_b),
                'scope':'Secondary terminal reading of the same ignore_reply shots; no physical correction retroactively occurred. No precision advantage claimed.'},
            'pooled_correlator_completions':{'bell_probabilities':[number(p) for p in probabilities],
                'separable_white_noise_weight':number(white),'observable_values':completions,
                'scope':'Same THREE POOLED correlators only. Not the complete joint record, not an identification of actual hardware state.'},
            'hardware_jobs_submitted':0}
    args.output.parent.mkdir(parents=True,exist_ok=True)
    args.output.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))


if __name__=='__main__':main()
