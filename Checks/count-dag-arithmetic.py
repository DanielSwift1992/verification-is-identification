#!/usr/bin/env python3
"""Independent integer expectations for the finite count capacity suite.

This does not run a court or interpret Swift getters. It reads the fixture's
explicit aliases as arithmetic and checks the D65 relations against the pinned
original page. Structural equality and reader limits remain contract cases.
"""
from functools import lru_cache
from pathlib import Path
import json
import re

ROOT = Path(__file__).resolve().parents[1] / 'Contracts/Court/v0.2'


def term(text):
    tokens = re.findall(r'[A-Za-z_]\w*|[<>,]', text)
    if ''.join(tokens) != re.sub(r'\s+', '', text):
        raise ValueError('not a fixture arithmetic term: ' + text)
    index = 0
    def read():
        nonlocal index
        name = tokens[index]; index += 1
        args = []
        if index < len(tokens) and tokens[index] == '<':
            index += 1
            while True:
                args.append(read())
                if tokens[index] == '>': index += 1; break
                assert tokens[index] == ','; index += 1
        return name, tuple(args)
    result = read()
    assert index == len(tokens)
    return result


def aliases(text):
    result = {}
    for match in re.finditer(r'^\s*(?:public )?typealias (\w+)(?:<([^>]+)>)?\s*=\s*([^\n]+)', text, re.M):
        name, params, body = match.groups()
        parameters = tuple(p.split(':')[0].strip() for p in params.split(',')) if params else ()
        # All arithmetic definitions used by this suite are complete on a line.
        try: value = term(body)
        except (ValueError, IndexError, AssertionError): continue
        result[name] = parameters, value
    return result


def evaluator(definitions):
    @lru_cache(None)
    def value(expression, environment=()):
        name, args = expression
        bindings = dict(environment)
        if name in bindings:
            assert not args
            return bindings[name]
        if name == 'Unit': assert not args; return 1
        if name == 'Never': assert not args; return 0
        if name == 'Plus':
            assert len(args) == 2
            return value(args[0], environment) + value(args[1], environment)
        params, body = definitions[name]
        assert len(params) == len(args)
        return value(body, tuple(zip(params, (value(a, environment) for a in args))))
    return value


def main():
    expected = json.loads((ROOT / 'arithmetic.json').read_text())
    primitives = aliases((ROOT / 'fixtures/Primitive.swift').read_text())
    total = 0
    derived_d65 = None
    for name, readings in expected.items():
        if name == 'provenance': continue
        definitions = primitives | aliases((ROOT / 'fixtures' / (name + '.swift')).read_text())
        evaluate = evaluator(definitions)
        actual = {}
        for ident in readings:
            if ident in definitions:
                params, (head, args) = definitions[ident]
                assert not params and head == 'Reading' and len(args) == 2
                actual[ident] = [evaluate(arg) for arg in args]
            else:
                assert name == 'equal-count-different-shape' and ident == 'Probe'
                actual[ident] = [evaluate(definitions[field][1]) for field in ['Left', 'Answer']]
        assert actual == readings, (name, actual, readings)
        total += len(readings)
        if name == 'gate-d65': derived_d65 = actual
    original = (ROOT / 'origins/gate-bench-palette.swift').read_text()
    definitions = primitives | aliases(original)
    evaluate = evaluator(definitions)
    ids = re.findall(r'^// gate-unsupported: (\w+) \|', original, re.M)
    mapping = expected['provenance']['mapping']
    assert set(mapping) == set(ids) and len(ids) == 26
    covered = []
    for ident in ids:
        _, (kind, args) = definitions[ident]
        numbers = [evaluate(a) for a in args]
        if kind == 'Grey':
            x, y, z, lo, hi, xlo, xhi = numbers
            pairs = [[25*z, 27*y+lo], [28*y, 25*z+hi], [25*x, 23*y+xlo], [24*y, 25*x+xhi]]
        elif kind == 'GreyFloor':
            x, y, z, lo, hi = numbers
            pairs = [[x, y], [25*z, 27*y+lo], [28*y, 25*z+hi]]
        elif kind == 'TowardBlue':
            y, z, margin = numbers; pairs = [[25*z, 28*y+1+margin]]
        elif kind == 'TowardWarm':
            y, z, margin = numbers; pairs = [[27*y, 25*z+1+margin]]
        else: raise AssertionError(kind)
        assert all(a == b for a, b in pairs), (ident, pairs)
        assert [derived_d65[name] for name in mapping[ident]] == pairs, ident
        covered.extend(mapping[ident])
    assert len(covered) == len(set(covered)) == 66 and set(covered) == set(derived_d65)
    print(f'count arithmetic: {total} exact pairs; all 26 original D65 IDs cover 66 relations')


if __name__ == '__main__':
    main()
