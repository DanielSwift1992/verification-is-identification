#!/usr/bin/env python3
"""Exact attainable transcript partitions of finite deterministic query trees.

Sources remain unchanged by queries. Priors have full support. A policy stops
when its target is fixed; further queries can only worsen both objectives.
Partition/cost arithmetic is exact; logarithms are reported to float tolerance.
"""
from fractions import Fraction
from copy import deepcopy
from functools import lru_cache
from itertools import product
import json
from math import inf
from pathlib import Path
import sys

from closed_information import entropy, equal
from entropy_questions import optimal_questions, replay, transcripts
from operational_quotient import partitions


def blocks(labels, support=None):
    if support is None:
        support = range(len(labels))
    groups = {}
    for x in support:
        groups.setdefault(labels[x], []).append(x)
    return tuple(sorted(tuple(group) for group in groups.values()))


def partition_entropy(partition, prior):
    return entropy({block: sum(prior[x] for x in block) for block in partition})


def attainable(questions, target, prior):
    """For each attainable reduced-tree leaf partition, cheapest mean policy.

    Distinct paths reaching equal answers stay distinct blocks. In particular,
    merging terminal answer labels is not erasing an earlier transcript split.
    """
    n = len(target)
    assert n and len(prior) == n and all(p > 0 for p in prior) and sum(prior) == 1
    assert all(len(q) == n and set(q) <= {0, 1} for q in questions)

    @lru_cache(None)
    def solve(support):
        if len({target[x] for x in support}) == 1:
            return {(support,): (Fraction(0), {'answer': target[support[0]]})}
        result = {}
        mass = sum(prior[x] for x in support)
        for i, question in enumerate(questions):
            zero = tuple(x for x in support if question[x] == 0)
            one = tuple(x for x in support if question[x] == 1)
            if not zero or not one:
                continue
            weight = sum(prior[x] for x in zero) / mass
            for left, (left_cost, left_policy) in solve(zero).items():
                for right, (right_cost, right_policy) in solve(one).items():
                    partition = tuple(sorted(left + right))
                    cost = 1 + weight * left_cost + (1 - weight) * right_cost
                    if partition not in result or cost < result[partition][0]:
                        result[partition] = (cost, {'question': i, 'zero': left_policy, 'one': right_policy})
        return result

    return solve(tuple(range(n)))


def zero_excess_possible(questions, target):
    """Independent class-preserving recursion; no probabilities or entropies."""
    @lru_cache(None)
    def safe(support):
        classes = blocks(target, support)
        if len(classes) == 1:
            return True
        for question in questions:
            if any(len({question[x] for x in block}) != 1 for block in classes):
                continue
            zero = tuple(x for x in support if question[x] == 0)
            one = tuple(x for x in support if question[x] == 1)
            if zero and one and safe(zero) and safe(one):
                return True
        return False

    return safe(tuple(range(len(target))))


def frontier(options, target, prior):
    h_target = partition_entropy(blocks(target), prior)
    rows = [{'partition': partition, 'mean': mean, 'excess': partition_entropy(partition, prior) - h_target,
             'policy': policy} for partition, (mean, policy) in options.items()]
    # Exact costs; entropy comparisons are numerical at this explicit tolerance.
    return sorted((row for row in rows if not any(
        other['mean'] <= row['mean'] and other['excess'] <= row['excess'] + 1e-12
        and (other['mean'] < row['mean'] or other['excess'] < row['excess'] - 1e-12)
        for other in rows)), key=lambda row: (row['mean'], row['excess'], row['partition']))


def audit_options(questions, target, prior, options):
    target_blocks = blocks(target)
    assert (target_blocks in options) == zero_excess_possible(questions, target)
    old = optimal_questions(questions, target, prior)
    assert min((value[0] for value in options.values()), default=inf) == old['mean']
    for partition, (mean, policy) in options.items():
        paths = transcripts(questions, target, policy)
        assert blocks(paths) == partition
        assert replay(questions, target, prior, policy)[1] == mean
        assert all(len({target[x] for x in block}) == 1 for block in partition)
        h_trace = partition_entropy(partition, prior)
        h_target = partition_entropy(target_blocks, prior)
        conditional = 0.0
        for answer_block in target_blocks:
            mass = sum(prior[x] for x in answer_block)
            distribution = {block: sum(prior[x] for x in block) / mass
                            for block in partition if block[0] in answer_block}
            conditional += float(mass) * entropy(distribution)
        equal(h_trace, h_target + conditional)
        assert conditional >= -1e-12
        assert (partition == target_blocks) == all(len({paths[x] for x in block}) == 1 for block in target_blocks)
        if partition == target_blocks:
            equal(conditional, 0)


def describe(questions, target, prior):
    options = attainable(questions, target, prior)
    audit_options(questions, target, prior, options)
    rows = frontier(options, target, prior)
    return {'questions': questions, 'target': target, 'prior': tuple(map(str, prior)),
            'target_entropy': partition_entropy(blocks(target), prior),
            'attainable_reduced_partitions': len(options),
            'zero_excess': blocks(target) in options,
            'frontier': [{**row, 'mean': str(row['mean'])} for row in rows]}


def demo():
    adaptive = describe(((0, 0, 1, 1), (0, 1, 0, 1)), (0, 0, 1, 2), (Fraction(1, 4),) * 4)
    assert adaptive['zero_excess'] and adaptive['frontier'][0]['mean'] == '3/2'
    # Only the first test factors through the target on the whole source space.
    assert not zero_excess_possible(((0, 0, 1, 1),), (0, 0, 1, 2))
    n = 8
    target = tuple(int(x == n - 1) for x in range(n))
    prior = (Fraction(1, n),) * n
    membership = describe(tuple(tuple(int(x == i) for x in range(n)) for i in range(n - 1)), target, prior)
    direct = describe((target,), target, prior)
    assert membership['attainable_reduced_partitions'] == 1 and not membership['zero_excess']
    assert membership['frontier'][0]['mean'] == '35/8'
    equal(membership['frontier'][0]['excess'], 3 - membership['target_entropy'])
    assert direct['zero_excess'] and direct['frontier'][0]['mean'] == '1'
    # Four tests on five uniform sources: quicker disclosure splits the larger
    # target class; slower disclosure splits the smaller one. No root test is safe.
    tradeoff = describe(((0, 1, 0, 1, 1), (0, 0, 0, 0, 1),
                         (0, 1, 0, 0, 0), (0, 1, 1, 0, 1)),
                        (0, 1, 0, 0, 1), (Fraction(1, 5),) * 5)
    assert not tradeoff['zero_excess']
    assert {row['mean'] for row in tradeoff['frontier']} == {'8/5', '9/5'}
    for row in tradeoff['frontier']:
        expected = 0.4 if row['mean'] == '9/5' else (3 / 5) * entropy({0: Fraction(1, 3), 1: Fraction(2, 3)})
        equal(row['excess'], expected)
    # No attainable partition is coarser than both of these successful ones.
    options = attainable(tradeoff['questions'], tradeoff['target'], (Fraction(1, 5),) * 5)
    fast = ((0, 2), (1, 4), (3,))
    slow = ((0, 2, 3), (1,), (4,))
    assert fast in options and slow in options
    def coarser(candidate, fine):
        return all(any(set(block) <= set(cover) for cover in candidate) for block in fine)
    assert not any(coarser(candidate, fast) and coarser(candidate, slow) for candidate in options)
    return {'adaptive': adaptive, 'membership': membership, 'direct': direct, 'tradeoff': tradeoff}


def markdown(result):
    lines = ['# Distinctions required by the experimental route', '',
             'Exact deterministic verdicts; noiseless, nondestructive binary tests; known finite tables and positive priors.', '',
             'For the complete transcript T and target Z=q(X), H(T)=H(Z)+H(T|Z).',
             'The extra term counts distinctions inside answer classes. It is not a lower bound on final accessible memory.', '',
             '| Experiment | Target entropy, bits | Mean questions for this partition | Extra transcript information, bits | Transcript partition |',
             '|---|---|---|---|---|']
    for name, row in result.items():
        for choice in row['frontier']:
            partition = '{' + ', '.join('{' + ','.join(map(str, block)) + '}' for block in choice['partition']) + '}'
            lines.append(f"| {name} | {row['target_entropy']:.6f} | {choice['mean']} | {choice['excess']:.6f} | {partition} |")
    lines += ['', '## Adaptive zero-excess experiment', '',
              'Four sources A₁, A₂, B, C have target answers A, A, B, C.',
              'Test u=(0,0,1,1) first. A zero answers A; after a one, use v=(0,1,0,1) to distinguish B and C.',
              'Although v distinguishes A₁ from A₂ globally, the controller never asks it in that branch.',
              'Every target class therefore has exactly one complete transcript.',
              'Requiring every vocabulary test to factor through the target globally would incorrectly reject this experiment.', '',
              '## A real cost/disclosure tradeoff', '',
              'Five uniform sources 0,…,4 have target (0,1,0,0,1). Four tests are available:',
              'u=(0,1,0,1,1), name₄=(0,0,0,0,1), name₁=(0,1,0,0,0), v=(0,1,1,0,1).',
              'Ask u first and v only after a one: mean 8/5, splitting the three-source answer class, excess 0.550978 bits.',
              'Ask name₄ first and name₁ only after a zero: mean 9/5, splitting the two-source answer class, excess 0.4 bits.',
              'Separate leaves with the same answer do not merge their complete transcripts.',
              'Every available root test splits a target class, so zero excess is impossible.',
              'The exact optimizer finds both costs on the Pareto frontier; the fastest and least-disclosing policies differ.',
              'There is also no single coarsest attainable transcript partition: any correct common coarsening of',
              'the fast partition {{0,2},{1,4},{3}} and slow partition {{0,2,3},{1},{4}} is the unattainable target partition.', '',
              '## Scope of the certificate', '',
              'The optimizer records every leaf partition attainable by trees that stop when the target becomes fixed,',
              'with the least rational expected query count for that partition. Uninformative queries can be removed.',
              'Queries after a fixed verdict only refine the transcript and increase cost, so cannot improve this frontier.',
              'Policies execute using only question indexes, readings and terminal answers. Full source tables are synthesis premises.',
              'Entropy comparisons use tolerance 1e-12. The zero-excess criterion is exact equality of partitions.',
              'This is a restricted experiment model, not a general lower bound for randomized, noisy or destructive experiments.', '']
    return '\n'.join(lines)


def main():
    questions = tuple((0,) + rest for rest in product(range(2), repeat=3) if any(rest))
    prior = (Fraction(1, 4),) * 4
    cases = witnesses = zero = possible = 0
    for mask in range(1 << len(questions)):
        vocabulary = tuple(q for i, q in enumerate(questions) if mask & (1 << i))
        for target in partitions(4):
            options = attainable(vocabulary, target, prior)
            audit_options(vocabulary, target, prior, options)
            cases += 1
            witnesses += len(options)
            possible += bool(options)
            zero += blocks(target) in options
    assert cases == 1920 and possible == 1575
    print(f'transcripts: {cases} vocabulary/targets, {witnesses} partition witnesses replayed, {zero} zero-excess cases, {possible} feasible')
    # Nonuniform probabilities change entropy and costs, not zero-excess feasibility.
    for prior in ((Fraction(7, 10), Fraction(1, 10), Fraction(1, 10), Fraction(1, 10)),
                  (Fraction(1, 20), Fraction(1, 20), Fraction(1, 10), Fraction(4, 5))):
        vocabulary = ((0, 0, 1, 1), (0, 1, 0, 1), (0, 0, 0, 1))
        for target in partitions(4):
            audit_options(vocabulary, target, prior, attainable(vocabulary, target, prior))
    vocabulary = ((0, 0, 1, 1), (0, 1, 0, 1))
    target = (0, 0, 1, 2)
    prior = (Fraction(1, 4),) * 4
    good = attainable(vocabulary, target, prior)
    mutations = []
    wrong_answer = deepcopy(good)
    partition = blocks(target)
    wrong_answer[partition][1]['zero']['answer'] = 99
    mutations.append(wrong_answer)
    wrong_cost = deepcopy(good)
    mean, policy = wrong_cost[partition]
    wrong_cost[partition] = (mean + 1, policy)
    mutations.append(wrong_cost)
    hidden_query = deepcopy(good)
    hidden_query[partition][1]['question'] = 99
    mutations.append(hidden_query)
    merged_paths = deepcopy(good)
    # A valid but overreading tree cannot certify the coarser target partition.
    merged_paths[partition] = merged_paths.pop(((0,), (1,), (2,), (3,)))
    mutations.append(merged_paths)
    for mutation in mutations:
        try:
            audit_options(vocabulary, target, prior, mutation)
        except (AssertionError, IndexError):
            continue
        raise AssertionError('corrupt transcript certificate accepted')
    print('transcripts: four corrupted certificates refused (answer, cost, undeclared query, merged paths)')
    result = json.loads(json.dumps(demo()))
    root = Path(__file__).parent / 'Reports'
    if '--write' in sys.argv:
        (root / 'transcript_partitions.json').write_text(json.dumps(result, indent=2) + '\n')
        (root / 'transcript_partitions.md').write_text(markdown(result))
    assert result == json.loads((root / 'transcript_partitions.json').read_text())
    assert markdown(result) == (root / 'transcript_partitions.md').read_text()
    print('transcripts: adaptive zero-excess criterion, nonuniform priors, eight-source forced disclosure and saved reports agree')


if __name__ == '__main__':
    main()
