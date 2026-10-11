#!/usr/bin/env python3
"""Independent directed binomial tails and exact rational bounds for this occurrence.

No beta-quantile routine, simulator, acquisition or hardware call is used.
The statistical model premises are not inferred by this numerical audit.
"""
import argparse
from decimal import Decimal,localcontext,ROUND_FLOOR,ROUND_CEILING
from fractions import Fraction as F
from itertools import product
import json
from math import isqrt
from pathlib import Path
import time

from environment import write,digest


def decimal_bound(x,rounding,precision=65):
    with localcontext() as c:
        c.prec=precision;c.rounding=rounding
        return Decimal(x.numerator)/Decimal(x.denominator)


def display_interval(bounds):
    return [str(decimal_bound(bounds[0],ROUND_FLOOR)),str(decimal_bound(bounds[1],ROUND_CEILING))]


def tail(n,k,q,side,rounding):
    # The input floating endpoint is represented exactly as a finite decimal.
    # All summands are positive; directed arithmetic bounds every operation.
    with localcontext() as c:
        c.prec=80;c.rounding=rounding
        q=Decimal.from_float(q);one=1-q
        if side=='le':
            term=one**n;total=term
            for i in range(k):term=term*(n-i)/(i+1)*q/one;total+=term
        else:
            term=q**n;total=term
            for i in range(n,k,-1):term=term*i/(n-i+1)*one/q;total+=term
        return total


def check_tails(record,witness):
    n=record['shots'];counts=record['pair_counts'];alpha=Decimal(str(record['alpha']))/4;rows=[]
    for name,k,interval in [('mean',counts['10']+counts['11'],witness['mean_interval']),('second_moment',counts['11'],witness['second_moment_interval'])]:
        for endpoint,q,side in [('lower',interval[0],'ge'),('upper',interval[1],'le')]:
            lo=tail(n,k,q,side,ROUND_FLOOR);hi=tail(n,k,q,side,ROUND_CEILING)
            assert 0<=lo<=hi<=alpha,(name,endpoint,lo,hi,alpha)
            rows.append({'moment':name,'count':k,'trials':n,'endpoint':endpoint,'endpoint_exact_binary_float':q,
                'binomial_event':f'K {"<=" if side=="le" else ">="} {k}','tail_interval':[str(lo),str(hi)],'tail_budget':str(alpha)})
    return rows


def source_risk(rows,a,b):
    total=F(0)
    for truth,p in enumerate((a,b)):
        for row in rows:
            if row['answer']==truth:continue
            mass=F(1,2)
            for vote in row['votes']:mass*=p if vote!=truth else 1-p
            total+=mass
    return total


def exact_rates(source,witness):
    m=F.from_float(witness['mean_interval'][1]);s=F.from_float(witness['second_moment_interval'][0]);square=s-m*m
    assert square>0;scale=10**32;k=isqrt(square.numerator*scale*scale//square.denominator)
    low=F(k,scale);high=F(k+1,scale);assert low*low<=square<high*high
    a=(m-high,m-low);b=(1-m-high,1-m-low)
    assert 0<=a[0]<=a[1]<=1 and 0<=b[0]<=b[1]<=1 and a[1]+b[1]<=1
    rates={}
    for name,rows in source['candidates'].items():
        # Monotone source truth tables justify endpoint evaluation in both
        # conditional error probabilities, without reusing polynomial code.
        assert all(r['answer']<=t['answer'] for r in rows for t in rows if all(x<=y for x,y in zip(r['votes'],t['votes'])))
        rates[name]=(source_risk(rows,a[0],b[0]),source_risk(rows,a[1],b[1]))
    assert rates['Majority'][1]<min(rates[name][0] for name in ['AnyOne','AllOne'])
    return rates,{'sqrt_bracket':display_interval((low,high)),'canonical_p01':display_interval(a),'canonical_p10':display_interval(b),
        'source_risks':{name:display_interval(interval) for name,interval in rates.items()}}


def contrasts(rates,upper):return {name:1-2*interval[0 if upper else 1] for name,interval in rates.items()}


def word_error(modes,c):
    isotropic=F(1);partial=F(3);nonisotropic=0
    for i in range(0,len(modes),3):
        block=modes[i:i+3];a,b,d=[c[x] for x in block]
        if len(set(block))==1:isotropic*=a*a
        else:partial=a*b+a*d+b*d;nonisotropic+=1
    assert nonisotropic<=1
    return (3-isotropic*partial)/4


def lower_by_upgrades(m,c):
    s=c['Single'];t=c['Majority'];spectra=[(s*s,)*3,(s*t,s*t,s*s),(t*t,s*t,s*t),(t*t,)*3];maximum={}
    for n3 in range(m+1):
        for n2 in range(m-n3+1):
            for n1 in range(m-n3-n2+1):
                counts=[m-n3-n2-n1,n1,n2,n3];k=n1+2*n2+3*n3;trace=F(0)
                for axis in range(3):
                    value=F(1)
                    for j,n in enumerate(counts):value*=spectra[j][axis]**n
                    trace+=value
                maximum[k]=max(maximum.get(k,F(0)),trace)
    return {k:max(F(0),(3-trace)/4) for k,trace in maximum.items()}


def run(output):
    start=time.perf_counter();root=Path(__file__).resolve().parents[2];base=root/'Research/Artifacts'
    verified={}
    for name in ['resident-orientation-word','resident-reading-cost','resident-stopped-read','resident-adaptive-checkpoint']:
        receipt=json.loads((base/f'{name}-20260915/receipt.json').read_text());assert all(digest(root/p)==v for p,v in receipt['sha256'].items());verified[name]=len(receipt['sha256'])
    cost_dir=base/'resident-reading-cost-20260915';source=json.loads((cost_dir/'cost-reading.json').read_text())
    packets=[json.loads((cost_dir/f'plan-{risk}.json').read_text()) for risk in ['0.6','0.5','0.35']]
    witness=packets[0]['least_favourable'];assert all(p['least_favourable']==witness for p in packets)
    record=json.loads((base/'resident-orientation-word-20260915/audit-paired-acquisition.json').read_text())
    tails=check_tails(record,witness);rates,geometry=exact_rates(source,witness);low=contrasts(rates,False);high=contrasts(rates,True)
    lower=lower_by_upgrades(2,high);costs=[]
    for packet in packets:
        selected=packet['selected'];modes=selected['modes'];interval=(word_error(modes,high),word_error(modes,low))
        assert interval[1]<=F.from_float(selected['error_upper'])<=F(str(packet['required_error']))
        assert all(bound>F(str(packet['required_error'])) for k,bound in lower.items() if k<selected['upgraded_steps'])
        assert all(F.from_float(value)<=lower[int(k)] for k,value in packet['lower_by_upgraded_steps'].items())
        costs.append({'required_error':packet['required_error'],'physical_reads':selected['physical_report_reads'],
            'exact_witness_error_interval':display_interval(interval),'published_upper_bounds_the_interval':True,'all_cheaper_fixed_plans_excluded_with_rationals':True})
    assert min(lower.values())>F(1,5)
    expected=[]
    for risk in ['0.6','0.5','0.35']:
        packet=json.loads((base/f'resident-stopped-read-20260915/plan-{risk}.json').read_text());a,b,c=packet['expected_reads_coefficients']
        corners=[a+b*F.from_float(m)+c*F.from_float(s) for m in witness['mean_interval'] for s in witness['second_moment_interval']]
        bounds=packet['expected_report_reads_interval'];assert F.from_float(bounds[0])<=min(corners)<=max(corners)<=F.from_float(bounds[1])
        expected.append({'required_error':float(risk),'exact_rectangle_extrema':display_interval((min(corners),max(corners))),'published_interval_encloses':True})
    packet=json.loads((base/'resident-adaptive-checkpoint-20260915/joint-reading.json').read_text())
    joint=(F(3,4)*(1-high['Majority']**4),F(3,4)*(1-low['Majority']**4))
    assert joint[1]<=F.from_float(packet['joint_error_upper'])<F(3,10)
    result={'input_receipt_entries_verified':verified,'directed_binomial_tails':tails,'exact_corner_geometry':geometry,
        'fixed_cost_bounds':costs,'strict_point_two_excluded_in_fixed_catalogue':True,
        'minimum_over_all_fixed_plans_lower':str(decimal_bound(min(lower.values()),ROUND_FLOOR)),
        'expected_stopped_cost_bounds':expected,'adaptive_joint_error_interval':display_interval(joint),
        'published_adaptive_bound_encloses':True,'arithmetic':'Exact integers and fractions; 80-digit directed positive Decimal tail sums; integer-isqrt rational bracket at denominator 10^32.',
        'new_device_calibrations':0,'new_QPU_jobs':0,'seconds':time.perf_counter()-start,'check_sha256':digest(Path(__file__)),
        'scope':'Independent arithmetic audit of this frozen occurrence and these selected constructions. It verifies numerical enclosures, not the physical IID/memory premises or the implementation of Python arithmetic itself.'}
    write(output/'audit.json',result);return result


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True);args=p.parse_args()
    args.output.mkdir(parents=True,exist_ok=True);r=run(args.output.resolve())
    print(json.dumps({k:r[k] for k in ['seconds','adaptive_joint_error_interval','fixed_cost_bounds','minimum_over_all_fixed_plans_lower']}))
