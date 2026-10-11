#!/usr/bin/env python3
"""Select a stable memory interface from explicitly promised future readings.

Reuse the existing saturation proof. This stronger contract preserves immediate
readings after every reply word. It is not asserted to be the least memory for
eventual solvability, nor does building its table acquire its physical value.
"""
from copy import deepcopy

import resident_boundary_composition as c


def model(source, questions):
    c.s.validate_source(source)
    c.s.require(type(questions) is list and 1 <= len(questions) <= 256, 'A finite future catalogue is required')
    for row in questions:
        c.s.request(source, row, 'exit')
    relative = source['goal']['observation']['continue']
    return {'states': source['goal']['states'],
            'observation': [[relative[i][0]]+[row[i] for row in questions] for i in range(8)],
            'operations': source['goal']['operations'], 'source': c.a.fingerprint(source),
            'scope': 'Actual contact selector and all declared readings after every finite reply word.'}


def boundary(source, classes):
    size = max(classes)+1
    width = max(1, (size-1).bit_length())
    return c.schema(source, [[i for i, cls in enumerate(classes) if cls == j] for j in range(2**width)])


def derive(source, questions):
    table = model(source, questions)
    proof = c.goal.saturate.synthesize(table)
    result = {'schema': 'vi.future-boundary.v1', 'questions': deepcopy(questions),
              'model': table, 'certificate': proof, 'boundary': boundary(source, proof['classes'])}
    verify(source, result)
    return result


def verify(source, value):
    c.s.require(set(value) == {'schema', 'questions', 'model', 'certificate', 'boundary'} and
                value['schema'] == 'vi.future-boundary.v1', 'Unknown future-boundary contract')
    c.s.require(value['model'] == model(source, value['questions']), 'Future promise changed')
    summary = c.goal.saturate.verify(value['model'], value['certificate'])
    c.s.require(value['boundary'] == boundary(source, value['certificate']['classes']),
                'Boundary is not the constructed future-reading quotient')
    return summary
