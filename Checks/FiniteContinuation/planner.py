"""Finite minimax constructor, independent of quantum matrices.

Input is a public family, permitted actions with their applicability sets, and
deterministic probes. No actual family member is available to the search.
"""
from functools import lru_cache


def synthesize(problem, initial=None):
    valid, actions, probes = problem['valid'], problem['actions'], problem['probes']
    initial = tuple(range(len(valid))) if initial is None else tuple(sorted(initial))
    if not initial or len(set(initial)) != len(initial) or any(i < 0 or i >= len(valid) for i in initial):
        raise ValueError('Invalid nonempty family')

    @lru_cache(None)
    def solve(belief):
        common = set.intersection(*(set(valid[i]) for i in belief))
        if common:
            key = min(common, key=lambda a:(actions[a]['physical_gates'], a))
            return {'kind':'act','action':key, 'cost':(0,0,actions[key]['physical_gates'])}
        if all(not valid[i] for i in belief):
            return {'kind':'unavailable','cost':(0,0,0),
                    'reason':'No catalog action works even with full identification'}
        best = None
        for p in probes:
            groups = {}
            for i in belief:
                groups.setdefault(p['replies'][i], []).append(i)
            if len(groups) < 2:
                continue
            branches = {str(r):solve(tuple(group)) for r,group in sorted(groups.items())}
            if any(v['kind'] == 'insufficient' for v in branches.values()):
                continue
            # Query depth is the globally optimized resource. The other two
            # components are bounds and deterministic tie-breaks, NOT a claim
            # of global multiobjective optimality (maxima need not co-occur).
            cost = (1+max(v['cost'][0] for v in branches.values()),
                    p['module_uses']+max(v['cost'][1] for v in branches.values()),
                    max(v['cost'][2] for v in branches.values()))
            node = {'kind':'probe','probe':p['id'],'branches':branches,'cost':cost}
            if best is None or (cost,p['id']) < (best['cost'],best['probe']):
                best = node
        if best is None:
            return {'kind':'insufficient','cost':None,
                    'reason':'No available probe tree guarantees an admissible continuation'}
        return best

    tree = solve(initial)
    return {'tree':tree,'initial':list(initial),'searched_beliefs':solve.cache_info().currsize}


def execute(plan, read_probe, budget=None):
    """Runtime input is a probe callback, never a hidden world or target answer.

    Budget exhaustion means not established, not impossible. A no-action leaf
    means unavailable in the declared catalog, not forbidden by physics.
    """
    node, transcript = plan['tree'], []
    while node['kind'] == 'probe':
        if budget is not None and len(transcript) >= budget:
            return {'kind':'needs_evidence','transcript':transcript}
        reply = read_probe(node['probe'])
        if type(reply) is not int or str(reply) not in node['branches']:
            raise ValueError('Probe returned an out-of-contract reply')
        transcript.append([node['probe'],reply])
        node = node['branches'][str(reply)]
    return {**node,'transcript':transcript}
