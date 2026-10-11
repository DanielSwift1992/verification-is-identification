"""Exact, finite comparison model; no hardware or state-vector simulation.

One reusable unknown Pauli A, one reusable unknown Pauli B, and a declared
connector U: the payload experiences B U A, while the requested action is U.
Matrices are exact Bloch actions over Q(sqrt(2)), with global phase quotiented.
The independent SDK auditor reconstructs actual two-dimensional unitaries.
"""
from collections import deque
from fractions import Fraction as F
from functools import lru_cache
from itertools import product


def scalar(a=0, b=0):
    return (F(a), F(b))


ZERO, ONE = scalar(), scalar(1)


def add(x, y):
    return (x[0] + y[0], x[1] + y[1])


def mul(x, y):
    return (x[0]*y[0] + 2*x[1]*y[1], x[0]*y[1] + x[1]*y[0])


def matrix(rows):
    return tuple(x if isinstance(x, tuple) else scalar(x) for row in rows for x in row)


@lru_cache(None)
def mm(a, b):
    return tuple(add(add(mul(a[3*i], b[j]), mul(a[3*i+1], b[3+j])),
                     mul(a[3*i+2], b[6+j])) for i in range(3) for j in range(3))


def transpose(a):
    return tuple(a[3*j+i] for i in range(3) for j in range(3))


I = matrix([[1,0,0],[0,1,0],[0,0,1]])
half_root = scalar(0, F(1,2))
GATES = {
    'x': matrix([[1,0,0],[0,-1,0],[0,0,-1]]),
    'y': matrix([[-1,0,0],[0,1,0],[0,0,-1]]),
    'z': matrix([[-1,0,0],[0,-1,0],[0,0,1]]),
    'h': matrix([[0,0,1],[0,-1,0],[1,0,0]]),
    's': matrix([[0,-1,0],[1,0,0],[0,0,1]]),
    'sdg': matrix([[0,1,0],[-1,0,0],[0,0,1]]),
    't': matrix([[half_root,scalar(0,-F(1,2)),0],
                 [half_root,half_root,0],[0,0,1]]),
}
PAULI_WORDS = {'I': (), 'X': ('x',), 'Y': ('y',), 'Z': ('z',)}
WORLDS = tuple(product(PAULI_WORDS, repeat=2))
AXES = 'XYZ'


def word_action(word):
    result = I
    for gate in word:
        result = mm(GATES[gate], result)
    return result


def clifford_library():
    # Complete closure, not a depth cutoff. Unit cost per declared native gate.
    words = {I: ()}
    queue = deque([I])
    while queue:
        state = queue.popleft()
        for gate in ('x','y','z','h','s','sdg'):
            successor = mm(GATES[gate], state)
            if successor not in words:
                words[successor] = words[state] + (gate,)
                queue.append(successor)
    assert len(words) == 24
    return words


CLIFFORD = clifford_library()
PAULI = {word_action(w): w for w in PAULI_WORDS.values()}


def probes(connector):
    """Only ideal SINGLE-SHOT deterministic probes for every admitted world.

    Each trial prepares a fresh +Pauli eigenstate; the unknown payload is not
    probed. Local A/B, neutral joint B A, and current joint B U A are available.
    A/B must remain the same fixed reusable modules throughout the episode.
    """
    candidates = []
    for path in ('A','B','neutral','current'):
        actions = []
        for a, b in WORLDS:
            aa, bb = word_action(PAULI_WORDS[a]), word_action(PAULI_WORDS[b])
            actions.append({'A': aa, 'B': bb, 'neutral': mm(bb,aa),
                            'current': mm(mm(bb,connector),aa)}[path])
        for prep, read in product(range(3), repeat=2):
            entries = [m[3*read+prep] for m in actions]
            if not all(e in (ONE, scalar(-1)) for e in entries):
                continue
            candidates.append({'id': f'{path}:{AXES[prep]}:{AXES[read]}',
                               'path': path, 'prep': AXES[prep], 'read': AXES[read],
                               'replies': tuple(0 if e == ONE else 1 for e in entries),
                               'module_uses': 1 if path in ('A','B') else 2})
    return candidates


def problem(connector_word, consumer, axis='Z', probe_paths=None):
    """Fixed output contract. No realized-world argument crosses this API.

    A terminal action is a signed Pauli reading, not delivery of a live state.
    Live consumers declare which frame metadata they can actually accept.
    """
    if consumer not in ('bare','pauli_frame','clifford_frame','terminal'):
        raise ValueError('Unknown consumer')
    if axis not in AXES:
        raise ValueError('Unknown target observable')
    u = word_action(connector_word)
    rows = []
    catalog = {}
    frames = {'bare': {I: ()}, 'pauli_frame': PAULI,
              'clifford_frame': CLIFFORD}.get(consumer, {})
    for a, b in WORLDS:
        m = mm(mm(word_action(PAULI_WORDS[b]), u), word_action(PAULI_WORDS[a]))
        residual = mm(m, transpose(u))
        valid = set()
        if consumer == 'terminal':
            q = AXES.index(axis)
            required = tuple(residual[3*i+q] for i in range(3))
            for read, sign in product(range(3), (1,-1)):
                candidate = tuple(scalar(sign if i == read else 0) for i in range(3))
                if candidate == required:
                    key = f'read:{sign:+}:{AXES[read]}'
                    catalog[key] = {'kind':'terminal','read': AXES[read],
                                    'sign':sign, 'physical_gates':0}
                    valid.add(key)
        else:
            for c, cw in CLIFFORD.items():
                remaining = mm(c, residual)
                if remaining in frames:
                    fw = frames[remaining]
                    key = 'correct:' + ','.join(cw) + '|frame:' + ','.join(fw)
                    catalog[key] = {'kind':'live','correction': list(cw),
                                    'frame':list(fw),'physical_gates':len(cw)}
                    valid.add(key)
        rows.append(frozenset(valid))
    available = probes(u)
    if probe_paths is not None:
        available = [p for p in available if p['path'] in probe_paths]
    return {'connector':list(connector_word), 'consumer':consumer, 'axis':axis,
            'worlds':WORLDS, 'valid':tuple(rows), 'actions':catalog,
            'probes':available}


def neutral_memory(a, b):
    """Test fixture helper only. Two actually performed old joint probes."""
    m = mm(word_action(PAULI_WORDS[b]),word_action(PAULI_WORDS[a]))
    return tuple(0 if m[3*i+i] == ONE else 1 for i in (0,2))


def compatible_with_old_memory(memory):
    if len(memory) != 2 or any(type(x) is not int or x not in (0,1) for x in memory):
        raise ValueError('Expected exactly two acquired bits')
    return tuple(i for i,(a,b) in enumerate(WORLDS) if neutral_memory(a,b) == tuple(memory))
