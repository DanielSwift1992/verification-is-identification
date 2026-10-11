"""Exact finite minimax acquisition with a priced boundary between batches.

The task, admissible actions and deterministic reusable contacts are inputs.
No world index, quantum matrix, connector-specific strategy or learned answer
enters the constructor. A batch is chosen before any of its replies arrives.
All contacts in it must refer to the same unchanged source. This is not a
stochastic-shot optimizer or a model of an actual cloud queue distribution.
"""
from fractions import Fraction as F
from functools import lru_cache
from itertools import combinations


def synthesize_batches(problem, *, round_price, probe_price=1, module_price=0, initial=None):
    prices=tuple(F(x) for x in (round_price,probe_price,module_price))
    if any(x<0 for x in prices):raise ValueError('Nonnegative resource prices required')
    latency,contact,module=prices
    valid=tuple(frozenset(row) for row in problem['valid'])
    probes=problem['probes']
    initial=tuple(range(len(valid))) if initial is None else tuple(sorted(initial))
    if not initial or len(set(initial))!=len(initial) or any(type(i) is not int or not 0<=i<len(valid) for i in initial):
        raise ValueError('Invalid nonempty source family')
    if len({p['id'] for p in probes})!=len(probes):raise ValueError('Duplicate contact')
    for p in probes:
        if len(p['replies'])!=len(valid) or any(type(x) is not int for x in p['replies']):
            raise ValueError('Contact table does not cover source family')
        if type(p['module_uses']) is not int or p['module_uses']<0:
            raise ValueError('Invalid module-use price multiplier')

    # Deterministic repeats add no distinction, so a round is a nonempty subset.
    subsets=[]
    for size in range(1,len(probes)+1):
        for indices in combinations(range(len(probes)),size):
            uses=sum(probes[i]['module_uses'] for i in indices)
            subsets.append((indices,latency+contact*size+module*uses,uses))

    @lru_cache(None)
    def solve(belief):
        common=set.intersection(*(set(valid[i]) for i in belief))
        if common:return F(0),{'kind':'act','action':min(common),'cost':'0'}
        if all(not valid[i] for i in belief):
            return F(0),{'kind':'unavailable','cost':'0',
                         'reason':'No action in the declared catalog works for this family'}

        # Equal partitions yield exactly the same continuation problem. Keep
        # the cheapest actual batch producing each partition at this belief.
        options={}
        for indices,cost,uses in subsets:
            groups={}
            for world in belief:
                replies=tuple(probes[i]['replies'][world] for i in indices)
                groups.setdefault(replies,[]).append(world)
            if len(groups)<2:continue
            partition=tuple(sorted(tuple(g) for g in groups.values()))
            order=(cost,len(indices),uses,tuple(probes[i]['id'] for i in indices))
            if partition not in options or order<options[partition][0]:
                options[partition]=(order,indices,groups)
        best=None
        for order,indices,groups in options.values():
            branches={};child_costs=[]
            for replies,group in sorted(groups.items()):
                cost,node=solve(tuple(group))
                if cost is None:break
                branches[','.join(map(str,replies))]=node;child_costs.append(cost)
            else:
                cost=order[0]+max(child_costs)
                rank=(cost,*order[1:])
                if best is None or rank<best[0]:
                    best=(rank,{'kind':'batch','probes':[probes[i]['id'] for i in indices],
                                'branches':branches,'cost':str(cost),'batch_cost':str(order[0])})
        if best is None:
            return None,{'kind':'insufficient','cost':None,
                         'reason':'Available contacts cannot establish an admissible continuation'}
        return best[0][0],best[1]

    cost,tree=solve(initial)
    return {'schema':'vi.finite-batched-plan.v1','initial':list(initial),
            'prices':dict(zip(('round','probe','module'),map(str,prices))),
            'cost':None if cost is None else str(cost),'tree':tree,
            'searched_families':solve.cache_info().currsize,
            'scope':'Worst-case additive acquisition cost; excludes subsequent action and noise'}


def execute_batches(program,read_batch):
    """One call returns the whole selected batch; no within-batch adaptation."""
    node=program['tree'];history=[]
    while node['kind']=='batch':
        requested=list(node['probes']);replies=read_batch(requested)
        if not isinstance(replies,dict) or set(replies)!=set(requested):
            raise ValueError('Batch reply is missing, duplicated or foreign')
        if any(type(replies[p]) is not int for p in requested):
            raise ValueError('Noninteger deterministic reply')
        key=','.join(str(replies[p]) for p in requested)
        if key not in node['branches']:raise ValueError('Out-of-contract joint reply')
        history.append({'probes':requested,'replies':dict(replies)})
        node=node['branches'][key]
    return {**node,'history':history}
