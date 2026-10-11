"""Anytime evidence for finite continuation under an explicit noise contract.

For every shot, conditional on the complete past and chosen probe, the chance
of reporting the wrong ideal bit is <= epsilon < 1/2. Modules remain fixed.
This is an assumption about acquisition, NOT inferred from a passing sample.
No independence or constant error rate is otherwise required.
"""
from fractions import Fraction as F

from planner import synthesize


class Evidence:
    def __init__(self, problem, *, episode, alpha, epsilon, max_shots):
        self.problem=problem
        self.episode=episode
        self.alpha,self.epsilon=F(alpha),F(epsilon)
        if not isinstance(episode,str) or not episode:
            raise ValueError('An acquisition episode is required')
        if not 0<self.alpha<1 or not 0<self.epsilon<F(1,2):
            raise ValueError('Explicit nontrivial coverage and noise bounds required')
        if type(max_shots) is not int or max_shots<0:
            raise ValueError('Invalid shot budget')
        self.max_shots=max_shots
        self.probes={p['id']:p for p in problem['probes']}
        if not self.probes:
            raise ValueError('This statistical adapter requires a nonempty probe menu')
        # Bonferroni over probe streams, NOT over observations or stopping times.
        # Under true bit b, ((1-eps)/eps)^(#wrong-#right) is a nonnegative
        # supermartingale. At threshold M/alpha, the chance of EVER eliminating
        # a true probe bit is <= alpha/M. Aggregate failure <= alpha.
        self.odds=(1-self.epsilon)/self.epsilon
        limit=F(len(self.probes),1)/self.alpha
        self.margin=0; power=F(1)
        while power<limit:
            self.margin+=1; power*=self.odds
        self.scores={p:0 for p in self.probes}  # ones minus zeroes
        self.excluded={p:set() for p in self.probes}
        self.batches=[]; self.seen=set(); self.shots=0

    def family(self):
        return tuple(i for i in range(len(self.problem['valid']))
                     if all(p['replies'][i] not in self.excluded[key]
                            for key,p in self.probes.items()))

    def decision(self):
        family=self.family()
        common={'family':list(family),'shots':self.shots,'alpha':str(self.alpha),
                'noise_upper_bound':str(self.epsilon),
                'scope':'Risk bound conditional on the declared acquisition contract'}
        if not family:
            return {**common,'kind':'model_conflict'}
        node=synthesize(self.problem,family)['tree']
        if node['kind']=='act':
            return {**common,'kind':'act','action':node['action'],
                    'execution':self.problem['actions'][node['action']]}
        if node['kind']!='probe':
            return {**common,'kind':node['kind']}
        if self.shots>=self.max_shots:
            return {**common,'kind':'needs_evidence','next_probe':node['probe']}
        return {**common,'kind':'probe','probe':node['probe'],
                'remaining_shots':self.max_shots-self.shots}

    def acquire(self, batch):
        """All acquired counts retained. Identical receipts cannot be re-counted.

        The provider adapter must bind these fields to the actual occurrence.
        String equality by itself does not establish a physical common source.
        Decisions are made only at completed batch boundaries.
        """
        if not isinstance(batch,dict) or set(batch)!={'episode','batch_id','probe','shots','counts'}:
            raise ValueError('Invalid acquisition receipt fields')
        if batch['episode']!=self.episode or not isinstance(batch['batch_id'],str) or not batch['batch_id']:
            raise ValueError('Wrong episode or missing acquisition occurrence')
        if batch['batch_id'] in self.seen:
            raise ValueError('Acquisition occurrence already counted')
        d=self.decision()
        if d['kind']!='probe' or batch['probe']!=d['probe']:
            raise ValueError('Receipt is not for the presently requested contact')
        n,counts=batch['shots'],batch['counts']
        if type(n) is not int or not 0<n<=d['remaining_shots']:
            raise ValueError('Invalid or excessive shot count')
        if (not isinstance(counts,dict) or set(counts)-{'0','1'} or
            any(type(v) is not int or v<0 for v in counts.values()) or sum(counts.values())!=n):
            raise ValueError('Invalid counts')
        key=batch['probe']
        self.scores[key]+=counts.get('1',0)-counts.get('0',0)
        score=self.scores[key]
        if score>=self.margin:
            self.excluded[key].add(0)
        if score<=-self.margin:
            self.excluded[key].add(1)
        self.shots+=n; self.seen.add(batch['batch_id'])
        self.batches.append({**batch,'counts':dict(counts)})
        return self.decision()

    def export(self):
        return {'schema':'vi.finite-noisy-evidence.v1','episode':self.episode,
                'alpha':str(self.alpha),'epsilon':str(self.epsilon),
                'max_shots':self.max_shots,'probe_streams':len(self.probes),
                'required_signed_margin':self.margin,'batches':self.batches,
                'decision':self.decision()}
