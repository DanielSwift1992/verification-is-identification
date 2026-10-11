#!/usr/bin/env python3
"""S3/S5/S11/S12: local splits, instance certificates and adaptive policies.

The existing optimizer synthesizes policies. Independent enumeration of all
reduced-tree depth vectors checks global costs and their joint attainability.
All queries are static, total and free of state changes; each costs one call.
"""
from copy import deepcopy
from fractions import Fraction
from functools import lru_cache
from itertools import combinations, permutations, product
from math import inf, isfinite, log2
from pathlib import Path
import json
import sys

from entropy_questions import optimal_questions, replay, transcripts
from operational_quotient import partitions


def depth_vectors(queries, target, allowed=None):
    """Every attainable depth vector, not just a minimizing tree."""
    n = len(target)

    @lru_cache(None)
    def visit(support):
        if len({target[x] for x in support}) == 1:
            return {tuple(0 if x in support else -1 for x in range(n))}
        result = set()
        for i, query in enumerate(queries):
            zero = tuple(x for x in support if not query[x])
            one = tuple(x for x in support if query[x])
            if not zero or not one:
                continue
            for left, right in product(visit(zero), visit(one)):
                result.add(tuple(1 + max(left[x], right[x]) if x in support else -1
                                 for x in range(n)))
        return result

    if allowed is None:
        return visit(tuple(range(n)))
    result = set()
    for i in allowed:
        zero = tuple(x for x in range(n) if not queries[i][x])
        one = tuple(x for x in range(n) if queries[i][x])
        if zero and one:
            for left, right in product(visit(zero), visit(one)):
                result.add(tuple(1 + max(left[x], right[x]) for x in range(n)))
    return result


def certificates(queries, target):
    values = []
    for x in range(len(target)):
        sufficient = []
        for size in range(len(queries) + 1):
            for keys in combinations(range(len(queries)), size):
                if all(target[y] == target[x] or any(queries[i][y] != queries[i][x] for i in keys)
                       for y in range(len(target))):
                    sufficient.append(size)
            if sufficient:
                break
        values.append(min(sufficient, default=inf))
    return tuple(values)


def optimal_vector_costs(vectors, prior):
    return (min((max(v) for v in vectors), default=inf),
            min((sum(p * d for p, d in zip(prior, v)) for v in vectors), default=inf))


def audit_small():
    cases = vectors_count = certificate_gaps = 0
    queries = tuple((0,) + tail for tail in product(range(2), repeat=3) if any(tail))
    priors = ((Fraction(1, 4),) * 4,
              (Fraction(1, 2), Fraction(1, 4), Fraction(1, 8), Fraction(1, 8)))
    for mask in range(1 << len(queries)):
        vocabulary = tuple(q for i, q in enumerate(queries) if mask >> i & 1)
        for target in partitions(4):
            vectors = depth_vectors(vocabulary, target)
            cert = certificates(vocabulary, target)
            if vectors:
                # Each x has SOME correct tree attaining its certificate.
                # This does not imply that ONE tree attains all of them.
                assert cert == tuple(min(v[x] for v in vectors) for x in range(4))
                certificate_gaps += cert not in vectors
            else:
                assert inf in cert
            vectors_count += len(vectors)
            for prior in priors:
                answer = optimal_questions(vocabulary, target, prior)
                assert optimal_vector_costs(vectors, prior) == (answer['worst'], answer['mean'])
                if vectors:
                    assert replay(vocabulary, target, prior, answer['worst_policy'])[0] == answer['worst']
                    assert replay(vocabulary, target, prior, answer['mean_policy'])[1] == answer['mean']
                cases += 1
    return {'prior_models': cases, 'distinct_tree_depth_vectors': vectors_count,
            'feasible_models_with_no_joint_certificate_policy': certificate_gaps}


def force_root(queries, target, prior, root):
    branches = []
    for value in (0, 1):
        support = tuple(x for x in range(len(target)) if queries[root][x] == value)
        assert support
        mass = sum(prior[x] for x in support)
        local = optimal_questions(tuple(tuple(q[x] for x in support) for q in queries),
                                  tuple(target[x] for x in support), tuple(prior[x] / mass for x in support))
        branches.append((mass, local))
    policies = {objective + '_policy': {'question': root,
                 'zero': branches[0][1][objective + '_policy'],
                 'one': branches[1][1][objective + '_policy']} for objective in ('mean', 'worst')}
    return {'worst': 1 + max(b[1]['worst'] for b in branches),
            'mean': 1 + sum(mass * b['mean'] for mass, b in branches), **policies}


def refinement_audit():
    # S11: richer observations dominate coarser ones when the future query
    # vocabulary, static source and costs are unchanged. Neither observation
    # needs to be a binary available query; these are initial readouts.
    checks = 0
    all_parts = list(partitions(4))
    vocabularies = ((), ((0, 0, 1, 1),), ((0, 0, 1, 1), (0, 1, 0, 1)),
                    ((0, 0, 0, 1), (0, 0, 1, 0), (0, 1, 0, 0)))
    for queries, target in product(vocabularies, all_parts):
        for fine, coarse in product(all_parts, repeat=2):
            if any(fine[x] == fine[y] and coarse[x] != coarse[y] for x, y in product(range(4), repeat=2)):
                continue
            def remaining(readout):
                worst, total = 0, Fraction(0)
                for label in set(readout):
                    support = tuple(x for x in range(4) if readout[x] == label)
                    local = optimal_questions(tuple(tuple(q[x] for x in support) for q in queries),
                                              tuple(target[x] for x in support), (Fraction(1, len(support)),) * len(support))
                    worst = max(worst, local['worst'])
                    total += Fraction(len(support), 4) * local['mean']
                return worst, total
            f, c = remaining(fine), remaining(coarse)
            assert f[0] <= c[0] and f[1] <= c[1]
            checks += 1
    return checks


def random_order_audit():
    queries = ((0, 1, 1, 1, 1, 0, 0), (0, 1, 1, 0, 0, 1, 0), (0, 0, 0, 1, 1, 0, 1))
    target = (1, 0, 0, 0, 0, 0, 0)
    counts = []
    for order in permutations(range(3)):
        support = set(range(7))
        used = 0
        for i in order:
            if len({target[x] for x in support}) == 1:
                break
            support = {x for x in support if queries[i][x] == queries[i][0]}
            used += 1
        counts.append(used)
    tail = Fraction(0)
    for k in range(3):
        subsets = tuple(combinations(range(3), k))
        unresolved = sum(any(target[x] != target[0] and all(queries[i][x] == queries[i][0] for i in keys)
                             for x in range(7)) for keys in subsets)
        tail += Fraction(unresolved, len(subsets))
    assert tail == Fraction(sum(counts), len(counts)) == Fraction(8, 3)
    assert certificates(queries, target)[0] == 2
    # Clairvoyant immediate-elimination greedy uniquely chooses A, then needs
    # B and C. B,C suffice in two. A is the unique first maximum, no tie issue.
    eliminated = [sum(f[x] != f[0] for x in range(7)) for f in queries]
    assert eliminated == [4, 3, 3]
    remaining = {x for x in range(7) if queries[0][x] == queries[0][0]}
    assert remaining == {0, 5, 6}
    assert all(len({target[x] for x in remaining if queries[i][x] == 0}) == 2 for i in (1, 2))
    return {'queries': queries, 'target': target, 'actual': 0,
            'greedy_actual_path': [0, 1, 2], 'short_certificate': [1, 2],
            'random_permutation_mean': str(tail)}


def closed_policy_window(queries, target, policy):
    """Finite whole with internal source and history, completed to a cycle.

    This is an abstract permutation on the listed reachable configurations,
    not a circuit-level cost model or an indefinitely retaining memory.
    """
    paths = transcripts(queries, target, policy)
    horizon = max(map(len, paths))
    permutation, starts, finals = {}, [], []
    for x in range(len(target)):
        history, node = (), policy
        start = (x, history)
        starts.append(start)
        for tick in range(horizon):
            before = (x, history)
            if 'question' in node:
                i = node['question']  # Depends only on the internal history.
                outcome = queries[i][x]
                history += ((i, outcome),)
                node = node['one' if outcome else 'zero']
            else:
                history += ((-1, node['answer']),)  # Internal terminal padding.
            permutation[before] = (x, history)
        assert node['answer'] == target[x]
        finals.append((x, history))
        permutation[finals[-1]] = start  # Explicit recovery step after the window.
    assert set(permutation) == set(permutation.values())
    for start, final in zip(starts, finals):
        state = start
        for tick in range(horizon):
            state = permutation[state]
        assert state == final and permutation[state] == start
    return {'states': len(permutation), 'prepared_starts': len(starts),
            'internal_steps_before_recovery': horizon,
            'scope': 'One prepared acquisition window. Source, history and phase are internal; recovery resets accessible history.'}


def demo():
    n = 9
    queries = ((0, 1, 1, 1, 1, 0, 0, 0, 0),
               (0, 1, 0, 0, 0, 1, 0, 0, 0),
               (0, 0, 1, 0, 1, 0, 1, 0, 0),
               (0, 1, 0, 0, 1, 0, 0, 1, 0),
               (0, 0, 1, 1, 0, 0, 0, 0, 1))
    target, prior = tuple(range(n)), (Fraction(1, n),) * n
    vectors = depth_vectors(queries, target)
    optimal = optimal_questions(queries, target, prior)
    assert optimal_vector_costs(vectors, prior) == (optimal['worst'], optimal['mean']) == (4, Fraction(10, 3))
    rows = []
    for i, query in enumerate(queries):
        forced = force_root(queries, target, prior, i)
        forced_vectors = depth_vectors(queries, target, (i,))
        assert optimal_vector_costs(forced_vectors, prior) == (forced['worst'], forced['mean'])
        for objective in ('mean', 'worst'):
            actual = replay(queries, target, prior, forced[objective + '_policy'])
            assert actual[objective == 'mean'] == forced[objective]
        p = Fraction(sum(query), n)
        rows.append({'root': i, 'split': [n - sum(query), sum(query)],
                     'answer_entropy': -float(p) * log2(float(p)) - float(1-p) * log2(float(1-p)),
                     **forced})
    assert rows[0]['answer_entropy'] > max(r['answer_entropy'] for r in rows[1:])
    assert (rows[0]['worst'], rows[0]['mean']) == (5, Fraction(31, 9))
    # Replay refuses a wrong leaf and an undeclared query: costs alone are
    # insufficient to validate a purported policy witness.
    bad = deepcopy(optimal['mean_policy'])
    leaf = bad
    while 'question' in leaf:
        leaf = leaf['zero']
    leaf['answer'] = 999
    for policy in (bad, {'question': 99, 'zero': {}, 'one': {}}):
        try:
            replay(queries, target, prior, policy)
        except (AssertionError, IndexError):
            continue
        raise AssertionError('bad strategy witness accepted')
    triple = ((1, 0, 0), (0, 1, 0), (0, 0, 1))
    three_vectors = depth_vectors(triple, (0, 1, 2))
    cert = certificates(triple, (0, 1, 2))
    assert cert == (1, 1, 1) and cert not in three_vectors
    assert optimal_vector_costs(three_vectors, (Fraction(1, 3),) * 3) == (2, Fraction(5, 3))
    # S12: each XOR input alone is independent of the target, but both suffice.
    bits, xor = ((0, 0, 1, 1), (0, 1, 0, 1)), (0, 1, 1, 0)
    assert all(sorted(xor[x] for x in range(4) if bit[x] == value) == [0, 1]
               for bit in bits for value in (0, 1))
    parity = optimal_questions(bits, xor, (Fraction(1, 4),) * 4)
    assert parity['worst'] == parity['mean'] == 2
    return {'greedy_root': {'queries': queries, 'target': target, 'prior': tuple(map(str, prior)),
                            'rows': rows, 'depth_vectors': len(vectors), 'optimal': optimal,
                            'closed_optimal': closed_policy_window(queries, target, optimal['worst_policy']),
                            'closed_greedy_root': closed_policy_window(queries, target, rows[0]['worst_policy'])},
            'certificate_gap': {'queries': triple, 'certificates': cert, 'attainable_depth_vectors': sorted(three_vectors)},
            'clairvoyant_greedy': random_order_audit(),
            'xor_preparation': {'queries': bits, 'target': xor, 'single_query_target_information': 0, 'joint_target_information': 1, 'policy': parity['mean_policy']}}


def serial(value):
    if isinstance(value, Fraction): return str(value)
    raise TypeError(type(value).__name__)


def markdown(data):
    lines = ['# A locally best question can force a worse search', '',
             'Fixed known table, static source, exact binary readings, unit query cost and uniform prior.', '',
             '## Nine-state witness', '', '| State | A | B | C | D | E |', '|---|---|---|---|---|---|']
    qs = data['greedy_root']['queries']
    for x in range(9): lines.append('| ' + ' | '.join(map(str, [x] + [q[x] for q in qs])) + ' |')
    lines += ['', 'Every row is distinct. The task is to identify the row.', '',
              '| First query | Split | Answer entropy, bits | Best possible worst cost | Best possible mean cost |', '|---|---|---|---|---|']
    for r in data['greedy_root']['rows']:
        lines.append(f"| {'ABCDE'[r['root']]} | {r['split'][0]} / {r['split'][1]} | {r['answer_entropy']:.6f} | {r['worst']} | {r['mean']} |")
    lines += ['', 'A is uniquely most balanced. Even an optimal continuation after A costs 5 in the worst case and 31/9 on average.',
              'Starting with C, D or E permits worst cost 4 and mean 10/3. The objectives are optimized separately.',
              'After A=0, the five remaining rows can only be tested one at a time by the other four queries.',
              'This is a property of the remaining partitions, not merely their cardinality.', '',
              'The JSON stores executable optimal policies and a policy for each forced first query and objective.',
              'Every policy is replayed against every row. Exhaustive reduced-tree depth-vector enumeration independently verifies the minima.', '',
              '## Three-state quantifier gap', '',
              'Each of three identity tests certifies its own target in one query. Certificate vector: (1,1,1).',
              'Every optimal full policy has a permutation of depths (1,2,2), so no single policy attains every instance certificate.', '',
              '## Target information can arrive only after preparation', '',
              'For q=a XOR b on two uniform bits, observing either input alone gives zero mutual information about q.',
              'Observing both settles it. Rejecting all zero-immediate-target-information questions would block every solution.', '',
              '## Scope', '',
              'This demonstrates known decision-tree distinctions inside VI. It is not an empirical claim that greedy heuristics are always poor.',
              'A known query table is a synthesis premise. The runtime policy sees only its stored node and actual query outcomes.',
              'Both worst-optimal and forced-A policies also run inside finite closed permutation windows: 45 and 54 whole configurations.',
              'Source, controller history and clock phase are internal. The next recovery step resets the accessible history.',
              'This is an abstract finite completion, not a physical implementation cost or unlimited retention theorem.',
              'State-changing source actions, learned tables, physical memory costs and thermodynamic conclusions are outside this model.', '']
    return '\n'.join(lines)


def main():
    counts = audit_small()
    counts['refinement_comparisons'] = refinement_audit()
    data = json.loads(json.dumps({'audit': counts, **demo()}, default=serial))
    folder = Path(__file__).parent / 'Reports'
    encoded = json.dumps(data, indent=2) + '\n'
    if '--write' in sys.argv:
        (folder / 'query_strategy.json').write_text(encoded)
        (folder / 'query_strategy.md').write_text(markdown(data))
    assert (folder / 'query_strategy.json').read_text() == encoded
    assert (folder / 'query_strategy.md').read_text() == markdown(data)
    print('strategy: ' + json.dumps(counts))
    print('strategy: unique entropy-greedy root loses under both costs; all saved policies replay; two corrupt policies refused')


if __name__ == '__main__': main()
