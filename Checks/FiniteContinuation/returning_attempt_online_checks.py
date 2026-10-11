#!/usr/bin/env python3
"""Exact online bounds, whole-catalogue lower proof, actual streamed execution."""
from collections import Counter
from copy import deepcopy
from fractions import Fraction as F
import json
import time

import returning_attempt_learning as learning
import returning_attempt_online as online
import returning_boundary_admission as boundary

OUT=learning.ROOT/'Research/Artifacts/returning-attempt-20260916/online'


def run():
    start=time.perf_counter();source=learning.read_source()
    upper=online.upper_certificate();upper_summary=online.verify_upper(upper)
    lower=online.lower_certificate(source);lower_summary=online.verify_lower(source,lower)
    tickets=Counter(online.select_threshold(i) for i in range(431))
    assert tickets==dict(online.WEIGHTS)
    # Every fixed horizon has precisely the same optimal expected ratio.
    for n in range(1,101):
        expect=sum(F(w,431)*online.threshold_cost(n,t) for t,w in online.WEIGHTS)
        assert expect==online.RANDOM_RATIO*online.offline(n)
    # Deterministic lower bound: first one-call goal occurs at n*. Before it
    # goals cost >=2; learning a needs two distinct useful returning probes.
    # Verify that no first probe alone settles a, including all actual outcomes.
    initial=tuple(range(8));one_probe=[]
    for p in lower['probes']:
        for reply,post in learning.successors(source,initial,p).items():
            assert learning.shared_control(source,post) is None
            one_probe.append({'probe':p,'reply':reply,'compatible':list(post)})
    assert min(F(2*n+3,online.offline(n)) for n in range(1,101))==F(11,8)
    # Analytic tail n>=5: (2n+3)/(n+4)=2-5/(n+4), increasing from 13/9.
    assert F(13,9)>F(11,8)
    future=boundary.future_questions(['II'+x+y for x in 'IXYZ' for y in 'IXYZ'],[])
    stronger=boundary.future_questions(['IXII'],['Swap_AB'])
    runtime_cases=[]
    representative=[0,54,126,222,350]
    for actual in range(8):
        for mode,ticket in [('deterministic',None)]+[('randomized',t) for t in representative]:
            port=learning.LocalPort(source,actual,reserve=2)
            runner=online.OnlineReturning(source,port,future,mode=mode,ticket=ticket)
            for n in range(1,17):
                gate=(learning.X,learning.ROTATION,learning.Z)[(n-1)%3]
                result=runner.arrive(gate)
                assert port.operator==gate and port.mode=='ready'
                assert result['commands']==online.threshold_cost(n,runner.threshold)
                if mode=='deterministic':assert result['commands']<=online.DETERMINISTIC_RATIO*online.offline(n)
            runtime_cases.append({'law':actual,'mode':mode,'ticket':ticket,'threshold':runner.threshold,
                                  'tasks':16,'commands':runner.cost(),'remaining_reserve':port.reserve})
        # The future contract rules learning out. Compare against the SAME
        # admissible offline language: 2N, not the unavailable N+4 comparator.
        port=learning.LocalPort(source,actual,reserve=2)
        runner=online.OnlineReturning(source,port,stronger)
        assert not runner.can_acquire and runner.threshold is None
        for n in range(1,7):
            runner.arrive(learning.ROTATION)
            assert port.operator==learning.ROTATION and runner.cost()==online.offline(n,False)
        assert port.reserve==2
    negatives=[]
    def reject(name,fn):
        try:fn()
        except (ValueError,AssertionError):negatives.append(name)
        else:raise AssertionError('Accepted '+name)
    bad=deepcopy(upper);bad['random_ratio']='7/6'
    reject('optimistic random bound',lambda:online.verify_upper(bad))
    bad=deepcopy(lower);bad['probes'].remove('Residue')
    reject('omitted allowed probe',lambda:online.verify_lower(source,bad))
    bad=deepcopy(lower);bad['nodes'][bad['root']]['value']='9'
    reject('unsupported lower potential',lambda:online.verify_lower(source,bad))
    reject('outside ticket domain',lambda:online.select_threshold(431))
    # Stopping at the first acquired one-call task observes the private policy.
    # Such an adaptive horizon is outside the expected guarantee's contract.
    adaptive=sum(F(w,431)*F(online.threshold_cost(t+1 if t is not None else 1000,t),
                           online.offline(t+1 if t is not None else 1000)) for t,w in online.WEIGHTS)
    assert adaptive>online.RANDOM_RATIO
    # Also explicit per-run risk: a first-task buy costs 5 while offline uses 2.
    assert F(online.threshold_cost(1,0),online.offline(1))==F(5,2)
    # Requiring eventual acquisition changes the objective. Replacing the
    # never branch with a finite T retains a slightly weaker expected bound.
    deadline=100
    finite_ratio=online.RANDOM_RATIO+F(3*81,431*(deadline+5))
    for n in range(1,2*deadline+1):
        cost=sum(F(w,431)*online.threshold_cost(n,deadline if t is None else t) for t,w in online.WEIGHTS)
        assert cost<=finite_ratio*online.offline(n)
    assert sum(F(w,431)*online.threshold_cost(deadline+1,deadline if t is None else t)
               for t,w in online.WEIGHTS)==finite_ratio*online.offline(deadline+1)
    OUT.mkdir(parents=True,exist_ok=True)
    result={'schema':'vi.returning-online-checks.v1','source':learning.fingerprint(source),
            'upper':upper_summary,'lower':lower_summary,'one_probe_cannot_buy_one_call':one_probe,
            'stream_cases':runtime_cases,'streamed_tasks':len(runtime_cases)*16+8*6,
            'negative_checks':negatives,'adaptive_horizon_counterexample_expected_ratio':str(adaptive),
            'random_first_task_path_ratio':'5/2','runtime_seconds':time.perf_counter()-start,
            'eventual_acquisition_example':{'fallback_threshold':deadline,'upper_ratio':str(finite_ratio),
                                          'not_claimed_optimal_under_this_extra_requirement':True},
            'scope':'Exact command costs in the old measured-contact catalogue. No QPU cost claim; random bound is expectation for fixed horizon/law.'}
    for name,value in [('upper-certificate.json',upper),('lower-certificate.json',lower),('checks.json',result)]:
        (OUT/name).write_text(json.dumps(value,indent=2)+'\n')
    print(json.dumps({k:result[k] for k in ('upper','lower','streamed_tasks','negative_checks',
                                         'adaptive_horizon_counterexample_expected_ratio','runtime_seconds')},indent=2))


if __name__=='__main__':run()
