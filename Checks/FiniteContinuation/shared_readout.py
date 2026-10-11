"""Local alternative: unknown shared binary detector, acquired jointly.

Conditional on fixed h and unknown theta0,theta1, every chosen stream's
conditional mean is theta[b_p(h)]. Reference preparations have known ideal
labels 0/1 and the SAME detector response. No known numeric error ceiling,
no known detector orientation. This is a different contract from noisy.py.
"""
import math

from planner import synthesize


def intersect(a,b):return (max(a[0],b[0]),min(a[1],b[1]))


class SharedReadout:
    def __init__(self,problem,alpha=.01,max_shots=8192):
        if not 0<alpha<1:raise ValueError('Invalid risk')
        self.problem,self.alpha,self.max_shots=problem,alpha,max_shots
        self.probes={p['id']:p for p in problem['probes']}
        self.names=['reference:0','reference:1',*self.probes]
        self.n={p:0 for p in self.names};self.ones={p:0 for p in self.names}
        self.intervals={p:(0.,1.) for p in self.names}

    def family(self):
        remaining=[]
        for h in range(len(self.problem['valid'])):
            theta=[self.intervals['reference:0'],self.intervals['reference:1']]
            for key,p in self.probes.items():
                b=p['replies'][h]
                theta[b]=intersect(theta[b],self.intervals[key])
            if all(lo<=hi for lo,hi in theta):remaining.append(h)
        return tuple(remaining)

    def decision(self):
        family=self.family()
        if not family:return {'kind':'model_conflict'}
        node=synthesize(self.problem,family)['tree']
        if node['kind']=='act':return {**node,'family':list(family)}
        if sum(self.n.values())>=self.max_shots:return {'kind':'needs_evidence','family':list(family)}
        if node['kind']!='probe':return node
        # A modest policy, not a sample-optimal one. First distinguish the two
        # reference responses, then acquire the question-relevant source probes.
        overlap=intersect(self.intervals['reference:0'],self.intervals['reference:1'])
        if overlap[0]<=overlap[1]:
            key=min(('reference:0','reference:1'),key=lambda p:self.n[p])
        else:key=node['probe']
        return {'kind':'probe','probe':key,'family':list(family)}

    def acquire(self,probe,bits):
        d=self.decision()
        if d['kind']!='probe' or d['probe']!=probe:raise ValueError('Unrequested stream')
        if not bits or any(type(x) is not int or x not in (0,1) for x in bits):raise ValueError('Invalid bits')
        if sum(self.n.values())+len(bits)>self.max_shots:raise ValueError('Shot budget exceeded')
        self.n[probe]+=len(bits);self.ones[probe]+=sum(bits)
        n=self.n[probe];mean=self.ones[probe]/n
        # For every stream and every n use delta=alpha/(M*n*(n+1)).
        # Sum_n 1/[n(n+1)] = 1. The bounded-martingale Hoeffding bound and
        # a union bound give simultaneous coverage, including adaptive stopping.
        radius=math.sqrt(math.log(2*len(self.names)*n*(n+1)/self.alpha)/(2*n))+1e-12
        interval=(max(0.,mean-radius),min(1.,mean+radius))
        self.intervals[probe]=intersect(self.intervals[probe],interval)

    def export(self):
        return {'decision':self.decision(),'shots':sum(self.n.values()),
                'per_stream_shots':self.n,'intervals':self.intervals,
                'alpha':self.alpha,'scope':'Conditional shared-response model; numerical conservative intervals. Local prototype only.'}
