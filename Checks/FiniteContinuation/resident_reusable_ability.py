#!/usr/bin/env python3
"""Reusable checked compositions, with an explicit remaining-memory reading.

The entry is a recipe, never an owned physical instance. Its source-call cost
is retained when it is given a reusable name. Search happens when discovering
the entry; application rechecks its existing proof against the current input.
"""
from copy import deepcopy

import resident_boundary_composition as c


def represented_boundary(source, presentation='direct'):
    values = c.presentations(source)['views'][presentation]
    codes = [row[0]+2*row[1] for row in values]
    return c.schema(source, [[i for i, code in enumerate(codes) if code == j] for j in range(4)])


def price(compiled):
    ranks = [cert['worst_case_contacts'] if cert else None for cert in compiled['certificates']]
    bound = max(rank for rank in ranks if rank is not None)
    answers = len(compiled['query']['questions'])
    return {'source_calls_by_input_code': ranks, 'source_calls_upper_bound': bound,
            'measurement_slots_in_emitted_program': bound+answers,
            'answer_measurements': answers,
            'memory_recoding_source_calls': 0,
            'model': 'Opaque source calls; measurement slots include inactive padded slots. '
                     'Not duration, QPU billing or all classical work.'}


def discover(source, boundary, query, exit_boundary=None):
    compiled = c.recipe(source, boundary, query)
    c.s.require(compiled['applicable'], 'No reusable uniformly bounded ability for this input')
    raw = c.output_schema(source, compiled)
    target = boundary if exit_boundary is None else exit_boundary
    result = {'schema': 'vi.reusable-ability.v1', 'recipe': compiled,
              'remaining_memory': c.recoding(source, raw, target), 'price': price(compiled)}
    verify(source, result)
    return result


def verify(source, value):
    c.s.require(set(value) == {'schema', 'recipe', 'remaining_memory', 'price'} and
                value['schema'] == 'vi.reusable-ability.v1', 'Unknown ability')
    compiled = value['recipe']
    c.s.require(c.verify_recipe(source, compiled), 'A refused program is not an ability')
    c.verify_recoding(source, value['remaining_memory'])
    c.s.require(value['remaining_memory']['input'] == c.output_schema(source, compiled),
                'Remaining memory is not read from the actual program exit')
    c.s.require(value['price'] == price(compiled), 'The name erased execution cost')
    return True


def apply(assembly, cut, value):
    verify(assembly.source, value)
    c.s.require(cut.contract == value['recipe']['input'], 'Ability needs another input boundary')
    next_cut = assembly.extend(cut, value['recipe'])
    return assembly.recode(next_cut, value['remaining_memory'])


class Library:
    """Content-addressed recipes, returned as data for the next builder."""
    def __init__(self, source):
        c.s.validate_source(source)
        self.source = deepcopy(source)
        self._entries = {}

    def add(self, value):
        verify(self.source, value)
        key = c.a.fingerprint(value)
        self._entries[key] = deepcopy(value)
        return key

    def find(self, boundary, query):
        c.validate_schema(self.source, boundary)
        c.joint.validate_request(self.source, query)
        found = []
        for key, value in self._entries.items():
            verify(self.source, value)
            if value['recipe']['input'] == boundary and value['recipe']['query'] == query:
                found.append((value['price']['source_calls_upper_bound'], key, deepcopy(value)))
        return min(found, key=lambda row: (row[0], row[1]))[2] if found else None
