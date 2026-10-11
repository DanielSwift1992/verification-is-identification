#!/usr/bin/env python3
"""Exact finite priors, branch information and permitted-question costs.

Probabilities and expected costs use Fraction. Logarithmic entropy values use
floating point with explicit tolerances. No thermodynamic interpretation is
inferred from these finite probability models.
"""
from fractions import Fraction
from functools import lru_cache
from itertools import product
import json
import sys
from math import ceil, inf, isfinite, log2
from pathlib import Path

from closed_information import entropy, equal, pushed, mutual
from operational_quotient import partitions


def condition(prior, reading):
    masses = pushed(dict(enumerate(prior)), lambda x: reading[x])
    branches = []
    for value, mass in masses.items():
        posterior = {x: p / mass for x, p in enumerate(prior) if reading[x] == value and p}
        divergence = sum(float(p) * log2(float(p / prior[x])) for x, p in posterior.items())
        branches.append({'reading': value, 'mass': mass, 'posterior': posterior,
                         'entropy': entropy(posterior), 'divergence': divergence})
    return branches


def optimal_questions(questions, target, prior, accounting=None):
    """Optimal decision trees for nondestructive, noiseless binary questions.

    Runtime policies contain only a question index, observation branches and
    terminal answers. The full table and prior are used during synthesis.
    """
    n = len(target)
    assert len(prior) == n and all(p > 0 for p in prior) and sum(prior) == 1
    assert all(len(q) == n and all(b in (0, 1) for b in q) for q in questions)

    @lru_cache(None)
    def solve(support):
        if accounting is not None:
            accounting['supports'] = accounting.get('supports', 0) + 1
        answers = {target[x] for x in support}
        if len(answers) == 1:
            leaf = {'answer': next(iter(answers))}
            return 0, Fraction(0), leaf, leaf
        best_worst = best_mean = inf
        worst_policy = mean_policy = None
        mass = sum(prior[x] for x in support)
        for i, question in enumerate(questions):
            if accounting is not None:
                accounting['partition_entries'] = accounting.get('partition_entries', 0) + 2 * len(support)
            zero = tuple(x for x in support if question[x] == 0)
            one = tuple(x for x in support if question[x] == 1)
            if not zero or not one:
                continue
            left, right = solve(zero), solve(one)
            if not isfinite(left[0]) or not isfinite(right[0]):
                continue
            worst = 1 + max(left[0], right[0])
            mean = 1 + sum(prior[x] for x in zero) / mass * left[1] + sum(prior[x] for x in one) / mass * right[1]
            if worst < best_worst:
                best_worst = worst
                worst_policy = {'question': i, 'zero': left[2], 'one': right[2]}
            if mean < best_mean:
                best_mean = mean
                mean_policy = {'question': i, 'zero': left[3], 'one': right[3]}
        return best_worst, best_mean, worst_policy, mean_policy

    worst, mean, worst_policy, mean_policy = solve(tuple(range(n)))
    return {'worst': worst, 'mean': mean, 'worst_policy': worst_policy, 'mean_policy': mean_policy}


def transcripts(questions, target, policy):
    paths = []
    for original in range(len(target)):
        node, path = policy, []
        while 'question' in node:
            reading = questions[node['question']][original]
            path.append((node['question'], reading))
            node = node['one' if reading else 'zero']
            assert len(path) < len(target)
        assert node['answer'] == target[original]
        paths.append(tuple(path))
    return tuple(paths)


def replay(questions, target, prior, policy):
    lengths = tuple(map(len, transcripts(questions, target, policy)))
    return max(lengths), sum(p * length for p, length in zip(prior, lengths))


def transcript_information(prior, paths):
    distribution = pushed(dict(enumerate(prior)), lambda x: paths[x])
    average = 0
    for original, path in enumerate(paths):
        previous_mass, gain = Fraction(1), 0.0
        for length in range(1, len(path) + 1):
            mass = sum(prior[x] for x, candidate in enumerate(paths)
                       if candidate[:length] == path[:length])
            gain -= log2(float(mass / previous_mass))
            previous_mass = mass
        equal(gain, -log2(float(distribution[path])))
        average += float(prior[original]) * gain
    equal(average, entropy(distribution))
    return average


def closed_observation(prior, reading):
    # Source, memory and readiness phase all belong to the whole. The first
    # step records a reading, the next returns to the prepared state. Readiness
    # prevents interpreting the blank initial memory as an acquired answer.
    worlds = tuple(product(range(len(prior)), range(2), range(2)))
    transition = {(x, memory, phase): (x, memory ^ reading[x], phase ^ 1)
                  for x, memory, phase in worlds}
    assert set(transition) == set(transition.values())
    assert all(transition[transition[w]] == w for w in worlds)
    prepared = {(x, 0, 0): p for x, p in enumerate(prior)}
    recorded = pushed(prepared, transition.__getitem__)
    assert pushed(recorded, transition.__getitem__) == prepared
    equal(entropy(prepared), entropy(recorded))
    assert all(phase == 1 and memory == reading[x] for x, memory, phase in recorded)
    equal(mutual(recorded, lambda w: w[0], lambda w: (w[1], w[2])),
          entropy(pushed(recorded, lambda w: w[1])))
    return entropy(prepared), entropy(recorded), len(worlds)


def demo():
    prior = (Fraction(9, 10), Fraction(1, 20), Fraction(1, 20))
    branches = condition(prior, (0, 1, 1))
    initial = entropy(dict(enumerate(prior)))
    conditional = sum(float(b['mass']) * b['entropy'] for b in branches)
    before, after, whole_states = closed_observation(prior, (0, 1, 1))
    rare = next(b for b in branches if b['reading'] == 1)
    assert rare['entropy'] > initial and rare['divergence'] > 1
    equal(conditional, 0.1)

    n = 8
    uniform = (Fraction(1, n),) * n
    membership = tuple(tuple(int(x == i) for x in range(n)) for i in range(n - 1))
    bits = tuple(tuple((x >> i) & 1 for x in range(n)) for i in range(3))
    identity = optimal_questions(membership, tuple(range(n)), uniform)
    binary_identity = optimal_questions(bits, tuple(range(n)), uniform)
    target = tuple(int(x == n - 1) for x in range(n))
    verdict = optimal_questions(membership, target, uniform)
    direct = optimal_questions((target,), target, uniform)
    assert identity['worst'] == verdict['worst'] == 7
    assert identity['mean'] == verdict['mean'] == Fraction(35, 8)
    assert binary_identity['worst'] == binary_identity['mean'] == 3
    assert direct['worst'] == direct['mean'] == 1
    membership_paths = transcripts(membership, target, verdict['mean_policy'])
    direct_paths = transcripts((target,), target, direct['mean_policy'])
    assert len(set(membership_paths)) == n
    membership_information = transcript_information(uniform, membership_paths)
    direct_information = transcript_information(uniform, direct_paths)
    equal(membership_information, 3)
    equal(direct_information, entropy(pushed(dict(enumerate(uniform)), lambda x: target[x])))
    for questions, question_target, solution in (
            (membership, tuple(range(n)), identity), (bits, tuple(range(n)), binary_identity),
            (membership, target, verdict), ((target,), target, direct)):
        assert replay(questions, question_target, uniform, solution['worst_policy'])[0] == solution['worst']
        assert replay(questions, question_target, uniform, solution['mean_policy'])[1] == solution['mean']
    return {'prior': [str(p) for p in prior], 'prior_entropy': initial,
            'branches': [{'reading': b['reading'], 'probability': str(b['mass']),
                          'support': list(b['posterior']), 'posterior': [str(p) for p in b['posterior'].values()],
                          'entropy': b['entropy'], 'information_gain': b['divergence']} for b in branches],
            'mean_conditional_entropy': conditional, 'mutual_information': initial - conditional,
            'whole_states': whole_states, 'whole_entropy_before': before, 'whole_entropy_after': after,
            'eight_states': {'identity_entropy': 3, 'verdict_entropy': entropy(pushed(dict(enumerate(uniform)), lambda x: target[x])),
                             'membership_worst': identity['worst'], 'membership_mean': str(identity['mean']),
                             'binary_coordinate_worst': binary_identity['worst'], 'direct_verdict_worst': direct['worst'],
                             'membership_verdict_transcript_information': membership_information,
                             'direct_verdict_transcript_information': direct_information}}


def markdown(result):
    lines = ['# A narrower support can have a higher posterior entropy', '',
             'Prior over A, B, C: 9/10, 1/20, 1/20. The noiseless question asks whether the source is not A.', '',
             '| Reading | Probability | Remaining sources | Posterior entropy, bits | KL gain, bits |',
             '|---|---|---|---|---|']
    for branch in result['branches']:
        names = ', '.join('ABC'[x] for x in branch['support'])
        lines.append(f"| {branch['reading']} | {branch['probability']} | {names} | {branch['entropy']:.6f} | {branch['information_gain']:.6f} |")
    lines += ['', f"Prior entropy: **{result['prior_entropy']:.6f}** bits. Mean posterior entropy: **{result['mean_conditional_entropy']:.6f}** bits.",
              f"Mutual information: **{result['mutual_information']:.6f}** bits, below one bit despite the rare branch's larger KL gain.",
              f"A **{result['whole_states']}-state** permutation includes source, memory and readiness phase.",
              f"Its joint entropy is **{result['whole_entropy_before']:.6f}** bits before and **{result['whole_entropy_after']:.6f}** after recording.",
              'The next step reverses the recording. Preparation and a finite readout window are explicit.', '',
              '# The same uncertainty permits different experimental costs', '',
              '| Eight equiprobable sources | Worst questions | Mean questions |',
              '|---|---|---|',
              '| Identify source, testing one of the first seven names at a time | 7 | 35/8 |',
              '| Identify source, reading its three binary coordinates | 3 | 3 |',
              '| Ask whether source is the eighth, with only the seven name tests | 7 | 35/8 |',
              '| Ask whether source is the eighth, with that question directly available | 1 | 1 |', '',
              f"Identity entropy is **3** bits. The eighth-source verdict entropy is **{result['eight_states']['verdict_entropy']:.6f}** bits.",
              'With only the seven name tests, every successful verdict transcript also identifies the full source.',
              'A yes to any name test identifies that source; seven negative readings identify the eighth.',
              'Thus a complete transcript carries 3 bits about the source even when the final answer reports only the verdict.',
              'All questions in this comparison are noiseless and nondestructive. The admissible vocabulary changes, not the prior.',
              'These are optimal finite decision-tree costs, not a physical time or heat estimate.', '']
    return '\n'.join(lines)


def main():
    cases = branch_increases = 0
    for a in range(1, 19):
        for b in range(1, 20 - a):
            prior = (Fraction(a, 20), Fraction(b, 20), Fraction(20 - a - b, 20))
            initial = entropy(dict(enumerate(prior)))
            for reading in product(range(2), repeat=3):
                branches = condition(prior, reading)
                conditional = sum(float(row['mass']) * row['entropy'] for row in branches)
                average_gain = sum(float(row['mass']) * row['divergence'] for row in branches)
                equal(initial - conditional, average_gain)
                assert -1e-12 <= average_gain <= 1 + 1e-12
                for branch in branches:
                    assert set(branch['posterior']) <= set(range(3))
                    equal(branch['divergence'], -log2(float(branch['mass'])))
                    branch_increases += branch['entropy'] > initial + 1e-12
                closed_observation(prior, reading)
                cases += 1
    assert cases == 1368 and branch_increases > 0
    print(f'entropy: {cases} prior/questions, {branch_increases} entropy-increasing branches, all 12-state whole permutations preserve entropy')

    joints = 0
    for counts in product(range(9), repeat=4):
        if sum(counts) != 8:
            continue
        joint = {state: Fraction(count, 8) for state, count in zip(product(range(2), repeat=2), counts)}
        information = mutual(joint, lambda s: s[0], lambda s: s[1])
        h_reading = entropy(pushed(joint, lambda s: s[1]))
        assert -1e-12 <= information <= h_reading + 1e-12 <= 1 + 2e-12
        joints += 1
    assert joints == 165
    print('entropy: all 165 binary joint tables obey the one-bit mean information bound without an independence premise')

    # Seven binary partitions of four states, ignoring complementary naming.
    questions = tuple((0,) + rest for rest in product(range(2), repeat=3) if any(rest))
    uniform = (Fraction(1, 4),) * 4
    cases = possible = 0
    for mask in range(1 << len(questions)):
        vocabulary = tuple(q for i, q in enumerate(questions) if mask & (1 << i))
        for target in partitions(4):
            result = optimal_questions(vocabulary, target, uniform)
            # Independent feasibility criterion: all differently answered pairs
            # must be separated. With nondestructive queries, reading the entire
            # vocabulary is then a sufficient preset experiment.
            separable = all(target[x] == target[y] or any(q[x] != q[y] for q in vocabulary)
                            for x, y in product(range(4), repeat=2))
            assert isfinite(result['worst']) == separable
            if separable:
                assert result['worst'] >= ceil(log2(len(set(target))))
                h_target = entropy(pushed(dict(enumerate(uniform)), lambda x: target[x]))
                assert float(result['mean']) + 1e-12 >= h_target
                assert replay(vocabulary, target, uniform, result['worst_policy'])[0] == result['worst']
                assert replay(vocabulary, target, uniform, result['mean_policy'])[1] == result['mean']
                transcript_information(uniform, transcripts(vocabulary, target, result['mean_policy']))
                possible += 1
            cases += 1
    assert cases == 1920
    print(f'questions: {cases} vocabularies/targets, {possible} exact policies replay and satisfy information lower bounds')

    # Two basis values at five positions give 32 selection rules, exceeding
    # the proposed comparison between four atom-pair keys and log2(|F|)=5.
    rules = tuple(product(range(2), repeat=5))
    coordinate_tests = tuple(tuple(rule[i] for rule in rules) for i in range(5))
    atom_tests = tuple((int(a == b),) * len(rules) for a, b in product(range(2), repeat=2))
    target = tuple(range(len(rules)))
    prior = (Fraction(1, len(rules)),) * len(rules)
    coordinates = optimal_questions(coordinate_tests, target, prior)
    assert coordinates['worst'] == coordinates['mean'] == log2(len(rules)) == 5 > 2 ** 2
    assert not isfinite(optimal_questions(atom_tests, target, prior)['worst'])
    assert replay(coordinate_tests, target, prior, coordinates['mean_policy']) == (5, Fraction(5))
    print('questions: atom equality keys do not bound uncertainty about 32 five-position selection rules')

    result = demo()
    root = Path(__file__).parent / 'Reports'
    if '--write' in sys.argv:
        (root / 'entropy_questions.json').write_text(json.dumps(result, indent=2) + '\n')
        (root / 'entropy_questions.md').write_text(markdown(result))
    assert result == json.loads((root / 'entropy_questions.json').read_text())
    assert markdown(result) == (root / 'entropy_questions.md').read_text()
    print('questions: rare evidence, restricted seven-step search and one-step verdict reports agree with the model')


if __name__ == '__main__':
    main()
