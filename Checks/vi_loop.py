#!/usr/bin/env python3
"""A scoped VI acquisition loop and an exact small strategy comparison.

The policy sees its program and observation history, never the actual row index.
The source and prepared memory are internal parts of a finite joint model.
This is a noiseless fixed-model experiment, not a trained-AI benchmark.
"""
from fractions import Fraction
from itertools import permutations, product
from pathlib import Path
from copy import deepcopy
import json
import sys

from entropy_questions import optimal_questions
from scoped_certificate import Refused, issue, reuse, require


def models():
    nine_queries = ((0,1,1,1,1,0,0,0,0), (0,1,0,0,0,1,0,0,0),
                    (0,0,1,0,1,0,1,0,0), (0,1,0,0,1,0,0,1,0),
                    (0,0,1,1,0,0,0,0,1))
    return [
        {'name': 'two_independent_bits', 'family': tuple(product(range(2), repeat=2)), 'sensors': (0,1), 'goal': (0,1)},
        {'name': 'declared_constant_family', 'family': ((0,0),(1,1)), 'sensors': (0,1), 'goal': (1,)},
        {'name': 'xor_from_components', 'family': tuple((a,b,a^b) for a,b in product(range(2), repeat=2)), 'sensors': (0,1), 'goal': (2,)},
        {'name': 'nine_source_counterexample', 'family': tuple(zip(*nine_queries)), 'sensors': tuple(range(5)), 'goal': tuple(range(5))},
    ]


def compile_policy(model, strategy, order=None):
    """All family rows are hypotheses. No distinguished actual row is supplied."""
    family, sensors, goal = model['family'], model['sensors'], model['goal']
    target = tuple(tuple(row[q] for q in goal) for row in family)
    queries = tuple(tuple(row[q] for row in family) for q in sensors)
    work = {'supports': 0, 'partition_entries': 0}
    if strategy == 'optimal':
        result = optimal_questions(queries, target, (Fraction(1,len(family)),)*len(family), work)
        policy = result['mean_policy']
    else:
        def visit(support, remaining):
            work['supports'] += 1
            answers = {target[x] for x in support}
            if len(answers) == 1:
                return {'answer': next(iter(answers))}
            if strategy == 'random':
                chosen = remaining[0]
            else:
                # Uniform posterior: maximize binary answer entropy by the
                # most balanced split. Exact integer comparison; ties by index.
                scores = []
                for i in remaining:
                    work['partition_entries'] += len(support)
                    ones = sum(queries[i][x] for x in support)
                    scores.append((min(ones,len(support)-ones),-i,i))
                chosen = max(scores)[2]
            work['partition_entries'] += 2*len(support)
            zero = tuple(x for x in support if queries[chosen][x] == 0)
            one = tuple(x for x in support if queries[chosen][x] == 1)
            rest = tuple(i for i in remaining if i != chosen)
            # A constant reading is inferable already and needs no source call.
            if not zero or not one:
                return visit(support,rest)
            return {'question': chosen, 'zero': visit(zero,rest), 'one': visit(one,rest)}
        policy = visit(tuple(range(len(family))), tuple(order) if order is not None else tuple(range(len(sensors))))
    require(policy is not None, 'no policy resolves this task')
    return policy, work


def policy_action(program, evidence, sensors):
    """Observation-only control: no source index, true answer or hidden state."""
    node = program
    while 'question' in node:
        local = node['question']
        require(type(local) is int and 0 <= local < len(sensors), 'undeclared sensor')
        q = sensors[local]
        if q not in evidence:
            return q, None
        node = node['one' if evidence[q] else 'zero']
    require(set(node) == {'answer'}, 'invalid policy leaf')
    return None, tuple(node['answer'])


def acquire(model, program, source, budget, retention):
    """Two identical requests about ONE unchanged internal source.

    source is used only at the environment's read and by the external audit.
    Clearing accessible memory between requests does not merge whole histories.
    The outer audit below includes source, local states and phase in one whole.
    """
    family, sensors, goal = model['family'], model['sensors'], model['goal']
    evidence, cache, trace = {}, {}, []
    counters = {'source_calls':0, 'new_records':0, 'completed_requests':0,
                'settled_answer_events':0, 'issue_checks':0, 'reuse_checks':0,
                'checker_table_cells':0, 'policy_dispatches':0}
    requests = []
    def snapshot(event):
        trace.append({'event':event, 'evidence':sorted(evidence.items()),
                      'certified_questions':sorted(cache), 'counters':dict(counters)})
    snapshot('prepared')
    for request in range(2):
        if request and retention == 'none':
            evidence, cache = {}, {}
        elif request and retention == 'evidence':
            cache = {}
        calls_before = counters['source_calls']
        snapshot('request')
        while True:
            answers = []
            for q in goal:
                try:
                    if q in cache:
                        counters['reuse_checks'] += 1
                        counters['checker_table_cells'] += 2*len(family)*len(family[0])
                        a = reuse(cache[q], family, tuple(evidence.items()), q)
                    else:
                        counters['issue_checks'] += 1
                        counters['checker_table_cells'] += len(family)*len(family[0])
                        c = issue(family, tuple(evidence.items()), q)
                        a = c['answer']
                        if retention == 'certificate': cache[q] = c
                    answers.append(a)
                except Refused as error:
                    # Only uncertainty is a request for another reading.
                    # Malformed contexts or invalid certificates remain failures.
                    if str(error) != 'unresolved answer': raise
                    answers.append(None)
            if all(a is not None for a in answers):
                counters['completed_requests'] += 1
                counters['settled_answer_events'] += len(goal)
                requests.append({'complete':True, 'answers':answers,
                                 'calls':counters['source_calls']-calls_before})
                break
            if counters['source_calls']-calls_before == budget:
                requests.append({'complete':False, 'answers':answers,
                                 'calls':counters['source_calls']-calls_before})
                break
            counters['policy_dispatches'] += 1
            q, claimed = policy_action(program,evidence,sensors)
            require(q is not None, 'policy stopped before its answers were certified')
            require(q not in evidence and q in sensors, 'invalid acquisition action')
            # The sole source access of the learner. The policy chose q first.
            outcome = family[source][q]
            evidence[q] = outcome
            counters['source_calls'] += 1
            counters['new_records'] += 1
            snapshot('observe')
        snapshot('complete' if requests[-1]['complete'] else 'budget')
    # This audit has privileged access; its assertions never steer the learner.
    for r in requests:
        assert all(a is None or a == family[source][q] for q,a in zip(goal,r['answers']))
    counters['retained_records'] = len(evidence)
    counters['stored_certificates'] = len(cache)
    return {'metrics':counters, 'requests':requests, 'trace':trace}


def closed_audit(runs):
    """Each prepared trajectory is completed to a disjoint finite cycle.

    Internal source, prepared random tape (if used), phase and accumulated local
    history distinguish states. Recovery is an abstract whole transition, not a
    physical circuit implementation or an extra sensor available to the policy.
    """
    successors = {}
    for origin, run in enumerate(runs):
        # origin enumerates source AND internal policy tape, not an agent input.
        history = ()
        states = []
        for snapshot in run['trace']:
            history += (json.dumps(snapshot, sort_keys=True),)
            states.append((origin,history))
        for before, after in zip(states,states[1:]+states[:1]):
            successors[before] = after
    assert set(successors) == set(successors.values())
    return len(successors)


def benchmark():
    records, traced = [], None
    for model in models():
        rows, sensors = model['family'], model['sensors']
        for strategy, retention, label in (
            ('random','none','random_order'), ('greedy','none','greedy_entropy'),
            ('optimal','none','optimal_mean'), ('optimal','evidence','optimal_with_evidence'),
            ('optimal','certificate','optimal_with_certificates')):
            orders = tuple(permutations(range(len(sensors)))) if strategy == 'random' else (None,)
            programs = [compile_policy(model,strategy,order) for order in orders]
            for budget in range(len(sensors)+1):
                runs = [acquire(model,program,x,budget,retention)
                        for program,work in programs for x in range(len(rows))]
                means = {key: str(sum(Fraction(r['metrics'][key],len(runs)) for r in runs))
                         for key in runs[0]['metrics']}
                work_mean = {key:str(sum(Fraction(w[key],len(programs)) for p,w in programs))
                             for key in programs[0][1]}
                records.append({'model':model['name'], 'strategy':label, 'budget_per_request':budget,
                    'exact_runs':len(runs), 'mean':means, 'compilation_mean':work_mean,
                    'all_requests_complete':all(all(q['complete'] for q in r['requests']) for r in runs),
                    'max_calls_per_request':max(q['calls'] for r in runs for q in r['requests']),
                    'closed_whole_states':closed_audit(runs)})
                assert all(q['calls'] <= budget for r in runs for q in r['requests'])
                if budget == len(sensors):
                    assert records[-1]['all_requests_complete']
                    if retention != 'none': assert all(r['requests'][1]['calls'] == 0 for r in runs)
                    if model['name'] == 'xor_from_components' and retention == 'certificate':
                        traced = runs[-1]
    # Independently known full-budget costs, including the strict greedy gap.
    def row(name,strategy):
        return next(r for r in records if r['model']==name and r['strategy']==strategy and
                    r['budget_per_request']==(5 if name=='nine_source_counterexample' else 2))
    assert Fraction(row('nine_source_counterexample','optimal_mean')['mean']['source_calls']) == Fraction(20,3)
    assert Fraction(row('nine_source_counterexample','greedy_entropy')['mean']['source_calls']) > Fraction(20,3)
    assert Fraction(row('xor_from_components','optimal_with_certificates')['mean']['source_calls']) == 2
    assert Fraction(row('xor_from_components','optimal_mean')['mean']['source_calls']) == 4
    # Instrumentation cannot change the policy or its mathematical optimum.
    m=models()[-1]; queries=tuple(zip(*m['family'])); target=tuple(m['family']); prior=(Fraction(1,9),)*9
    stats={}
    assert optimal_questions(queries,target,prior,stats) == optimal_questions(queries,target,prior)
    refusals = 0
    for bad in ({'answer':(0,)}, {'question':99,'zero':{},'one':{}}):
        try: acquire(models()[2],bad,0,2,'none')
        except Refused: refusals += 1
        else: raise AssertionError('bad policy accepted')
    return {'assumptions':'Fixed adequate noiseless Boolean family, uniform actual source, static source across two identical requests; all sensors cost one call. Optimal means minimum expected calls to full completion, not maximum success probability at each truncated budget. Random means exact uniform permutation, represented by an internal prepared tape.',
            'accounting':'Metrics sum two requests. completed_requests and settled_answer_events count successful request events, not novel semantic facts. new_records counts writes including reacquisition; retained_records counts final distinct sensor records. checker_table_cells counts input table volume per semantic pass, not CPU instructions. Compilation is charged once per prepared policy; supports and partition_entries describe only that algorithm, not total runtime or energy. JSON, hashing, allocation, target scans, prior arithmetic and setup costs are not included.',
            'closure':'Closed cycle checks establish a finite abstract joint permutation on trajectory histories. Preparation, program, family and enough history are premises. Recovery removes accessible progress. No permanent learning, locality or thermodynamic cost theorem follows.',
            'rows':records,'demonstration':traced,'negative_policy_refusals':refusals}


def markdown(result):
    lines=['# VI acquisition loop: exact finite comparison','',result['assumptions'],'',
           'Each row below gives two requests at the full sensor budget. Lower-budget rows and traces are in the JSON report.','',
           '| Model | Strategy | Source calls | New records | Completed requests | Certificate issue / reuse checks | Compiler supports / partition entries |',
           '|---|---|---:|---:|---:|---:|---:|']
    for r in result['rows']:
        if r['budget_per_request'] != (5 if r['model']=='nine_source_counterexample' else 2):continue
        m,w=r['mean'],r['compilation_mean']
        lines.append('| '+ ' | '.join((r['model'],r['strategy'],m['source_calls'],m['new_records'],m['completed_requests'],m['issue_checks']+' / '+m['reuse_checks'],w['supports']+' / '+w['partition_entries']))+' |')
    lines += ['',result['accounting'],'',result['closure'],'',
              'Retaining evidence already eliminates the second acquisition. Cached certificates do not reduce source calls further here, and their scope checks can increase computational work. These runs demonstrate conditional answer reuse, not a general speed advantage for a gate architecture.','']
    return '\n'.join(lines)


def main():
    result=benchmark()
    base=Path(__file__).parent/'Reports'/'vi_loop'
    for suffix,encoded in (('.json',json.dumps(result,indent=2)+'\n'),('.md',markdown(result))):
        path=base.with_suffix(suffix)
        if '--write' in sys.argv:path.write_text(encoded)
        assert path.read_text()==encoded, 'saved VI loop report changed'
    print('VI loop: %s model/strategy/budget rows; %s exact runs; source-only environment, two requests, scope checks and closed histories pass' % (len(result['rows']),sum(r['exact_runs'] for r in result['rows'])))
    print('VI loop: two malformed policies refused; retained evidence and certificates compared separately')


if __name__=='__main__':main()
