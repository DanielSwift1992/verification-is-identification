#!/usr/bin/env python3
"""Exact polynomial certificates for the acquired-memory query boundary.

The general amplitude-degree/positivity argument is proved in the report.
Here rational polynomial arithmetic verifies root annihilators, attainment,
normalization, actual protected-probe symbolic execution, and correspondence
to the frozen producing acquisition. No search cutoff is a lower bound.
"""
from fractions import Fraction as F
from pathlib import Path
from copy import deepcopy
import json
import time

import numpy as np
from qiskit import qpy

import orbit_return as o
import acquired_memory_capability as a

OUT=o.ROOT/'Research/Artifacts/returning-attempt-20260916/memory-query-bound'


def poly(values):
    result=tuple(F(x) for x in values)
    while len(result)>1 and result[-1]==0:result=result[:-1]
    return result or (F(0),)


ZERO=poly([0]);ONE=poly([1]);Z=poly([0,1])


def add(x,y):return poly([(x[i] if i<len(x) else 0)+(y[i] if i<len(y) else 0) for i in range(max(len(x),len(y)))])
def scale(x,c):return poly([c*v for v in x])


def mul(x,y):
    result=[F(0)]*(len(x)+len(y)-1)
    for i,c in enumerate(x):
        for j,d in enumerate(y):result[i+j]+=c*d
    return poly(result)


def division(x,y):
    assert y!=ZERO;rem=list(x);quot=[F(0)]*max(1,len(x)-len(y)+1)
    while len(rem)>=len(y) and poly(rem)!=ZERO:
        power=len(rem)-len(y);c=rem[-1]/y[-1];quot[power]+=c
        for i,v in enumerate(y):rem[i+power]-=c*v
        rem=list(poly(rem))
    return poly(quot),poly(rem)


def derivative(x):return poly([i*c for i,c in enumerate(x)][1:])
def gcd(x,y):
    while y!=ZERO:x,y=y,division(x,y)[1]
    return scale(x,1/x[-1])
def value(x,z):return sum(complex(c)*z**i for i,c in enumerate(x))
def encoded(x):return [str(c) for c in x]


def matrix(rows):return [[poly([v]) for v in row] for row in rows]


def mm(left,right):
    return [[sum_poly([mul(left[i][j],right[j][k]) for j in range(len(right))])
             for k in range(len(right[0]))] for i in range(len(left))]


def sum_poly(items):
    result=ZERO
    for x in items:result=add(result,x)
    return result


def symbolic_policy():
    # P is prepared as the unnormalized vector (1,1); contraction by (1,1)/2
    # cancels this common normalization. Measurement projectors remain exact.
    start=matrix([[1,0],[0,1],[1,0],[0,1]])
    swap=matrix([[1,0,0,0],[0,0,1,0],[0,1,0,0],[0,0,0,1]])
    query=matrix(np.eye(4,dtype=int).tolist());query[1][1]=query[3][3]=Z
    reset=matrix(np.diag([1,1,-1,-1]).tolist())
    def episode(carrier,count):
        live=mm(swap,carrier)
        for _ in range(count):live=mm(query,live)
        result={}
        for answer in (0,1):
            sign=(-1)**answer
            projector=matrix([[F(1,2),F(sign,2),0,0],[F(sign,2),F(1,2),0,0],
                              [0,0,F(1,2),F(sign,2)],[0,0,F(sign,2),F(1,2)]])
            branch=mm(swap,mm(projector,live))
            if answer:branch=mm(reset,branch)
            assert branch[:2]==branch[2:], 'P was not returned symbolically'
            result[answer]=branch
        return result
    modes=episode(start,4);frontier={'quantum':modes[1]}
    for z,branch in episode(modes[0],1).items():frontier['classical_'+str(z)]=branch
    def amplitude(branch):
        ready=[[scale(add(branch[i][j],branch[i+2][j]),F(1,2)) for j in range(2)] for i in range(2)]
        assert ready[0][1]==ready[1][0]==ZERO and ready[0][0]==ready[1][1]
        return ready[0][0]
    return {name:amplitude(k) for name,k in frontier.items()},{h:amplitude(k) for h,k in modes.items()}


def squared_modulus(x):
    # Coefficients here are real rational. On |z|=1, conjugate(z)=z^-1.
    result={}
    for i,c in enumerate(x):
        for j,d in enumerate(x):result[i-j]=result.get(i-j,F(0))+c*d
    return {k:v for k,v in result.items() if v}


def annihilator(task):
    q=poly([1,0,0,0,1])
    if task=='mode_C':return q
    if task=='classical_0':return mul(q,poly([1,1]))
    if task=='classical_1':return mul(q,poly([-1,1]))
    raise ValueError('Not the declared exact capability question')


def certificate(model,task):
    root_polynomial=annihilator(task)
    result={'schema':'vi.acquired-memory-query-bound.v1','model':o.fingerprint(model),'task':task,
            'forbidden_root_annihilator':encoded(root_polynomial),'minimum_forward_queries':len(root_polynomial)-1,
            'scope':'Finite exact adaptive quantum protocols; phase-dependent access only through individual forward V queries; finite independent ancillas and known instruments allowed.'}
    verify(model,result);return result


def verify(model,cert):
    o.require(cert['schema']=='vi.acquired-memory-query-bound.v1' and cert['model']==o.fingerprint(model),
              'Not this current acquired-memory task')
    required=annihilator(cert['task']);presented=poly(cert['forbidden_root_annihilator'])
    o.require(presented==required,'Missing forbidden implementation or wrong question')
    o.require(gcd(presented,derivative(presented))==ONE,'Root count includes repeated points')
    o.require(cert['minimum_forward_queries']==len(presented)-1,'Degree bound and claimed query price differ')
    return cert['minimum_forward_queries']


def count_queries(q,bits):
    def visit(body,wires,cbits):
        count=0
        for ins in body.data:
            op=ins.operation;qs=[wires[body.find_bit(x).index] for x in ins.qubits]
            cs=[cbits[body.find_bit(x).index] for x in ins.clbits]
            if op.name=='unitary':count+=1
            elif op.name=='if_else':
                bit,wanted=op.condition;index=cbits[body.find_bit(bit).index]
                branch=0 if bits[index]==wanted else 1
                if branch<len(op.blocks):count+=visit(op.blocks[branch],qs,cs)
        return count
    return visit(q,list(range(q.num_qubits)),list(range(q.num_clbits)))


def run():
    started=time.perf_counter();OUT.mkdir(parents=True,exist_ok=True)
    source=o.read_source();model=a.model(source)
    frozen=o.ROOT/'Research/Artifacts/returning-attempt-20260916/acquired-memory'
    assert json.loads((frozen/'model.json').read_text())==model
    frontier,modes=symbolic_policy()
    assert modes[0]==poly([F(1,2),0,0,0,F(1,2)])
    assert modes[1]==frontier['quantum']==poly([F(1,2),0,0,0,F(-1,2)])
    assert frontier['classical_0']==poly([F(1,4),F(1,4),0,0,F(1,4),F(1,4)])
    assert frontier['classical_1']==poly([F(1,4),F(-1,4),0,0,F(1,4),F(-1,4)])
    total={}
    for p in frontier.values():
        for k,v in squared_modulus(p).items():total[k]=total.get(k,F(0))+v
    assert {k:v for k,v in total.items() if v}=={0:F(1)}

    certificates={task:certificate(model,task) for task in ('mode_C','classical_0','classical_1')}
    divisibility={}
    for task,p in (('mode_C',modes[0]),('classical_0',frontier['classical_0']),('classical_1',frontier['classical_1'])):
        quotient,remainder=division(p,annihilator(task))
        assert remainder==ZERO and len(quotient)==1
        divisibility[task]={'quotient':encoded(quotient),'remainder':encoded(remainder)}
    assert value(frontier['classical_0'],1)==1 and value(frontier['classical_1'],-1)==1

    # Numerical matrix witness is produced by the actual frozen controller,
    # using scalar members of its SAME broad relation family.
    cases=[];max_error=0.
    for phase in [1+0j,-1+0j]+[np.exp(1j*np.pi/4)*(1j**k) for k in range(4)]:
        if phase in (1,-1):port=a.HiddenRelationDevice(model,[0],np.eye(1),signs=[int(phase.real)])
        else:
            index=min(range(4),key=lambda k:abs(phase-np.exp(1j*np.pi/4)*1j**k))
            port=a.HiddenRelationDevice(model,[0],np.eye(1),roots1=[index],basis1=np.eye(1))
        acquisition=a.Acquisition(model,port);acquisition.acquire();probabilities={}
        for key,matrix in acquisition.full_branches.items():
            name='quantum' if key[0] else 'classical_'+str(key[1]);amplitude=value(frontier[name],phase)
            error=float(np.max(abs(matrix-amplitude*np.eye(2))));max_error=max(max_error,error)
            probabilities[name]=float(np.trace(matrix.conj().T@matrix).real/2)
        assert max_error<1e-12
        cases.append({'phase':[phase.real,phase.imag],'probabilities':probabilities})

    # Read the old serialized actual adaptive tree; do not rerun its writer.
    with (frozen/'AcquiredMemoryCapability.qpy').open('rb') as handle:circuits=qpy.load(handle)
    programs=json.loads((frozen/'QPY-programs.json').read_text());actual_costs=[]
    for q,p in zip(circuits,programs):
        future=p['word'].count('V')
        costs={str((h,z)):count_queries(q,[h,z])-h*future for h,z in ((0,0),(0,1),(1,0))}
        assert list(costs.values())==[5,5,4];actual_costs.append(costs)

    refused=[]
    def reject(name,fn):
        try:fn()
        except (ValueError,AssertionError,KeyError):refused.append(name)
        else:raise AssertionError('Accepted '+name)
    bad=deepcopy(certificates['classical_0']);bad['forbidden_root_annihilator']=encoded(annihilator('mode_C'))
    reject('mode answer reused as a complete working bit',lambda:verify(model,bad))
    bad=deepcopy(certificates['mode_C']);bad['minimum_forward_queries']=3
    reject('degree four claimed attainable in three queries',lambda:verify(model,bad))
    bad=deepcopy(certificates['classical_1']);bad['model']='old premise'
    reject('lower bound transferred to another query contract',lambda:verify(model,bad))

    result={'schema':'vi.exact-acquired-memory-query-cost.v1','model':model,
        'minimum_worst_case_mode_queries':4,'minimum_worst_case_complete_frontier_queries':5,
        'positive_classical_leaf_minimum_queries':5,
        'symbolically_executed_amplitudes':{name:encoded(p) for name,p in frontier.items()},
        'exact_laurent_normalization':{'0':'1'},'annihilator_divisibility':divisibility,
        'frozen_actual_controller_residual':max_error,'frozen_QPY_trees_read':len(circuits),
        'acquisition_query_costs_by_record':actual_costs[0],'scalar_family_cases':cases,
        'refused_claims':refused,'new_QPU_jobs':0,'seconds':time.perf_counter()-started,
        'limits':'Exact mode/working-I-or-Z frontiers in this oracle contract; not all learning, approximate protocols, free higher-power queries, or a minimum for every quantum branch.',
        'primary_method_reference':'https://homepages.cwi.nl/~rdewolf/publ/qc/polynomials.pdf, Lemma 4.1; this one-variable root argument is derived in the report.'}
    for name,obj in (('checks.json',result),('certificates.json',certificates)):
        (OUT/name).write_text(json.dumps(obj,indent=2)+'\n')
    print(json.dumps({k:result[k] for k in ('minimum_worst_case_mode_queries','minimum_worst_case_complete_frontier_queries',
        'positive_classical_leaf_minimum_queries','symbolically_executed_amplitudes','frozen_actual_controller_residual',
        'frozen_QPY_trees_read','acquisition_query_costs_by_record','refused_claims','seconds')},indent=2))


if __name__=='__main__':run()
