#!/usr/bin/env python3
"""A finite certificate lifecycle joining CS3, VC35 and Projection AI6.

Certificates establish conditional statements in a supplied family of Boolean
functions, with a fixed shared interpretation of input positions and bit values.
They do not certify that interpretation, family adequacy or observation provenance.
"""
from copy import deepcopy
from itertools import combinations, product
from pathlib import Path
import json
import sys

from learning_coverage import version_space


class Refused(ValueError):
    pass


def require(condition, reason):
    if not condition:
        raise Refused(reason)


def context(family, evidence, query):
    require(isinstance(family, (tuple, list)) and len(family) > 0, 'empty family')
    require(all(isinstance(row, (tuple, list)) for row in family), 'malformed family')
    n = len(family[0])
    require(n > 0 and all(len(row) == n and all(type(v) is int and v in (0, 1) for v in row) for row in family), 'invalid Boolean table')
    rows = tuple(tuple(row) for row in family)
    require(len(set(rows)) == len(rows), 'duplicate family rows')
    require(type(query) is int and 0 <= query < n, 'invalid query')
    require(isinstance(evidence, (tuple, list)) and all(isinstance(e, (tuple, list)) and len(e) == 2 for e in evidence), 'malformed evidence')
    require(all(type(i) is int and 0 <= i < n and type(v) is int and v in (0, 1) for i, v in evidence), 'invalid evidence')
    require(len({i for i, v in evidence}) == len(evidence), 'duplicate evidence key')
    observed = tuple(sorted(tuple(e) for e in evidence))
    compatible = version_space(rows, observed)
    require(bool(compatible), 'inconsistent model and observations')
    return tuple(sorted(rows)), observed, tuple(sorted(compatible))


def issue(family, evidence, query):
    family, evidence, compatible = context(family, evidence, query)
    answers = {row[query] for row in compatible}
    require(len(answers) == 1, 'unresolved answer')
    return {'format': 'vi.finite-question.v1', 'family': [list(row) for row in family],
            'evidence': [list(e) for e in evidence], 'query': query,
            'compatible': [list(row) for row in compatible], 'answer': next(iter(answers))}


def verify(certificate):
    require(type(certificate) is dict and set(certificate) == {'format', 'family', 'evidence', 'query', 'compatible', 'answer'}, 'invalid certificate fields')
    require(certificate['format'] == 'vi.finite-question.v1', 'unsupported certificate format')
    require(type(certificate['answer']) is int, 'invalid answer type')
    rebuilt = issue(certificate['family'], certificate['evidence'], certificate['query'])
    require(rebuilt == certificate, 'certificate does not replay')
    return certificate['answer']


def reuse(certificate, family, evidence, query):
    answer = verify(certificate)
    require(query == certificate['query'] and type(query) is int, 'question changed')
    family, evidence, compatible = context(family, evidence, query)
    require(len(family[0]) == len(certificate['family'][0]), 'input arity changed')
    certified_scope = {tuple(row) for row in certificate['compatible']}
    require(set(compatible) <= certified_scope, 'current alternatives exceed certified scope')
    # The answer is inherited by restriction. No actual source is an input.
    return answer


def finite_audit():
    universe = tuple(product(range(2), repeat=2))
    contexts = []
    for size in range(1, 5):
        for family in combinations(universe, size):
            for values in product((None, 0, 1), repeat=2):
                evidence = tuple((i, v) for i, v in enumerate(values) if v is not None)
                if version_space(family, evidence):
                    contexts.append((family, evidence))
    issued = transfers = refused = 0
    for family, evidence in contexts:
        for query in range(2):
            try:
                certificate = issue(family, evidence, query)
            except Refused:
                assert len({row[query] for row in version_space(family, evidence)}) > 1
                continue
            issued += 1
            assert verify(certificate) == certificate['answer']
            old_scope = set(version_space(family, evidence))
            for new_family, new_evidence in contexts:
                new_scope = set(version_space(new_family, new_evidence))
                try:
                    answer = reuse(certificate, new_family, new_evidence, query)
                except Refused:
                    assert not new_scope <= old_scope
                    refused += 1
                    continue
                assert new_scope <= old_scope
                assert all(row[query] == answer for row in new_scope)
                transfers += 1
    return {'consistent_contexts': len(contexts), 'issued_certificates': issued,
            'restriction_transfers': transfers, 'out_of_scope_refusals': refused}


def demo():
    full = tuple(product(range(2), repeat=2))
    constants = ((0, 0), (1, 1))
    observed = ((0, 0),)
    first = issue(full, observed, 0)
    assert reuse(first, full, observed, 0) == 0
    assert reuse(first, full, ((0, 0), (1, 1)), 0) == 0
    conditional_second = issue(constants, observed, 1)
    assert verify(conditional_second) == 0
    # This certificate is a valid conditional claim, but an actual source 01
    # is not in its declared family. The same first observation cannot detect
    # that misspecification. The verifier is not given the actual source index.
    actual = (0, 1)
    assert actual not in constants and actual[0] == 0 and actual[1] != conditional_second['answer']
    reasons = []
    attempts = [lambda: reuse(first, full, observed, 1),
                lambda: reuse(conditional_second, full, observed, 1),
                lambda: reuse(conditional_second, constants, ((0, 0), (1, 1)), 1),
                lambda: issue(full, observed, 1)]
    for attempt in attempts:
        try:
            attempt()
        except Refused as error:
            reasons.append(str(error))
        else:
            raise AssertionError('unsafe lifecycle step was accepted')
    repaired = issue(full, ((0, 0), (1, 1)), 1)
    assert repaired['answer'] == 1 and reuse(repaired, full, ((0, 0), (1, 1)), 1) == 1
    corruptions = []
    for key, value in (('answer', 1), ('compatible', [[0, 0]]), ('query', -1),
                       ('format', 'other'), ('evidence', [[0, 0], [0, 1]])):
        bad = deepcopy(first)
        bad[key] = value
        corruptions.append(bad)
    for bad in corruptions:
        try:
            verify(bad)
        except Refused:
            continue
        raise AssertionError('corrupt certificate was accepted')
    return {'first': first, 'conditional_second': conditional_second, 'after_new_observation': repaired,
            'refusals': reasons, 'corruption_refusals': len(corruptions),
            'actual_outside_conditional_family': list(actual),
            'scope': 'Reuse by restriction is sufficient, not necessary. Other valid extensions require new verification. No certificate proves its model matches reality.'}


def main():
    result = {'audit': finite_audit(), 'lifecycle': demo()}
    path = Path(__file__).parent / 'Reports' / 'scoped_certificate.json'
    encoded = json.dumps(result, indent=2) + '\n'
    if '--write' in sys.argv: path.write_text(encoded)
    assert path.read_text() == encoded
    print('certificate lifecycle: ' + json.dumps(result['audit']))
    print('certificate lifecycle: reuse, restriction, model widening, changed question and new evidence replay; five corruptions refused')


if __name__ == '__main__': main()
