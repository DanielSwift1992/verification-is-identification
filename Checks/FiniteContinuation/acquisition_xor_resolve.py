#!/usr/bin/env python3
"""Construct a single-read XOR instrument by elimination, not word search.

The exact rule assumes the existing phase-free coherent contact contract.
A negative certificate excludes only this rule's grammar. General measured
programs, nonlinear decoders and different coherent access remain separate.
"""
import acquisition_future_synthesis as core

require = core.require
RULE = 'same-source/same-probe phase-free XOR composition, one final read'


def validate(columns, target):
    require(target and all(type(v) is int and v in (0, 1) for v in target),
            'Complete binary target required')
    require(all(len(c) == len(target) and all(type(v) is int and v in (0, 1) for v in c)
                for c in columns), 'Wrong binary contact columns')


def eliminate(columns, target):
    """GF(2) row elimination with a tracked separating row on failure.

Column zero is a CLASSICAL decoder offset, not a free physical contact.
All later columns are actual declared contacts. Free variables are zero;
this choice proves existence but is not a minimum-weight solution.
"""
    validate(columns, target)
    width = len(columns) + 1
    rows = [[1 | sum(c[i] << (j+1) for j, c in enumerate(columns)), bit, 1 << i]
            for i, bit in enumerate(target)]
    pivots = []; rank = 0
    for col in range(width):
        pivot = next((i for i in range(rank, len(rows)) if (rows[i][0] >> col) & 1), None)
        if pivot is None: continue
        rows[rank], rows[pivot] = rows[pivot], rows[rank]
        for i in range(len(rows)):
            if i != rank and (rows[i][0] >> col) & 1:
                rows[i] = [a ^ b for a, b in zip(rows[i], rows[rank])]
        pivots.append(col); rank += 1
    bad = next((r for r in rows if r[0] == 0 and r[1]), None)
    if bad is not None:
        return {'kind': 'outside_affine_span',
                'separator': [(bad[2] >> i) & 1 for i in range(len(target))]}
    coefficients = [0] * width
    for i, col in enumerate(pivots): coefficients[col] = rows[i][1]
    return {'kind': 'decomposition', 'offset': coefficients[0], 'selected': coefficients[1:]}


def check_identity(columns, target, proof):
    """Check a produced witness directly; never repeat elimination or search."""
    validate(columns, target)
    if proof['kind'] == 'decomposition':
        require(set(proof) == {'kind', 'offset', 'selected'}, 'Wrong decomposition fields')
        bits = [proof['offset']] + proof['selected']
        require(len(bits) == len(columns)+1 and all(type(v) is int and v in (0, 1) for v in bits),
                'Bad decomposition coefficients')
        require(all((bits[0] + sum(c[i]*b for c, b in zip(columns, bits[1:]))) % 2 == t
                    for i, t in enumerate(target)), 'Contacts do not produce the independent question')
    else:
        require(proof['kind'] == 'outside_affine_span' and set(proof) == {'kind', 'separator'},
                'Unknown rule certificate')
        y = proof['separator']
        require(len(y) == len(target) and all(type(v) is int and v in (0, 1) for v in y),
                'Wrong separating row')
        require(sum(y) % 2 == 0 and
                all(sum(a*b for a, b in zip(y, c)) % 2 == 0 for c in columns) and
                sum(a*b for a, b in zip(y, target)) % 2 == 1,
                'No separation from the affine contact span')
    return proof['kind']


def construct(spec, query):
    core.validate_request(spec, query)
    proof = eliminate(list(spec['contacts'].values()), query['values'])
    result = {'schema': 'vi.acquisition-xor-rule.v1', 'interface': spec['id'],
              'request': query['id'], 'rule': RULE, 'algebra': proof}
    if proof['kind'] != 'decomposition':
        result['kind'] = 'outside_rule'
    else:
        word = [name for name, bit in zip(spec['contacts'], proof['selected']) if bit]
        if len(word) > 1 and not spec['coherent_between_contacts']:
            result['kind'] = 'coherent_access_missing'
        else:
            result['kind'] = 'constructed'
            result['plan'] = core.propose(spec, query, word, [False]*(len(word)-1)+[True] if word else [])
    verify(spec, query, result)
    return result


def verify(spec, query, result):
    core.validate_request(spec, query)
    require(result['schema'] == 'vi.acquisition-xor-rule.v1' and result['rule'] == RULE and
            result['interface'] == spec['id'] and result['request'] == query['id'],
            'Rule applied at a different boundary')
    proof = result['algebra']
    check_identity(list(spec['contacts'].values()), query['values'], proof)
    if proof['kind'] == 'outside_affine_span':
        require(result['kind'] == 'outside_rule' and 'plan' not in result, 'False universal impossibility or plan')
        return {'constructed': False, 'reason': 'outside_single_probe_XOR_rule'}
    word = [name for name, bit in zip(spec['contacts'], proof['selected']) if bit]
    if len(word) > 1 and not spec['coherent_between_contacts']:
        require(result['kind'] == 'coherent_access_missing' and 'plan' not in result, 'Unavailable coherent composition')
        return {'constructed': False, 'reason': 'this_decomposition_needs_coherent_access'}
    require(result['kind'] == 'constructed', 'Missing producing plan')
    plan = result['plan']; cuts = [False]*(len(word)-1)+[True] if word else []
    require(plan['word'] == word and plan['read_after'] == cuts, 'Plan is not the composed rule')
    require(core.verify(spec, query, plan)['admitted'], 'Constructed plan fails the requested future')
    # Stronger than checking only the requested observables: each actual
    # branch IS the requested projector, with only an output-label offset.
    ps = core.projectors(query['values'])
    for raw, k in core.instrument(spec, word, cuts).items():
        a = (raw[0] if raw else 0) ^ proof['offset']
        require(core.equal(k, ps[a]), 'Not the full projective instrument')
    return {'constructed': True, 'full_projective_instrument': True,
            'contacts': len(word), 'readings': int(bool(word)), 'word_search_used': False,
            'cost_optimality_claimed': False}


def resolve(spec, query, fallback_bound=2):
    """Rule first; explicit bounded search only for a genuinely remaining case."""
    rule = construct(spec, query)
    if rule['kind'] == 'constructed':
        return {'route': 'xor_rule', 'rule_result': rule, 'plan': rule['plan']}
    if fallback_bound is None:
        return {'route': 'rule_inapplicable', 'rule_result': rule}
    search = core.synthesize(spec, query, max_contacts=fallback_bound)
    return {'route': 'bounded_search', 'rule_result': rule, 'search': search,
            **({'plan': search['plan']} if search['kind'] == 'found' else {})}


def compile_result(source, spec, query, result):
    require(verify(spec, query, result)['constructed'], 'No constructed program')
    return core.compile_plan(source, spec, query, result['plan'])
