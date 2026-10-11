#!/usr/bin/env python3
"""A fixed resident interpreter and exact continuation-relative memory checks.

The rational observable closure is exact in a 64-dimensional invariant
grammar: program/clock diagonal blocks times data/service Pauli operators.
It does not decide arbitrary quantum-program measurements or hidden hardware.
"""
import argparse
from collections import deque
from copy import deepcopy
from fractions import Fraction as F
from functools import lru_cache
from itertools import product
import json
from pathlib import Path
import subprocess

import numpy as np
from qiskit import QuantumCircuit
from qiskit.circuit.library import UnitaryGate
from qiskit.quantum_info import DensityMatrix, Kraus, Operator

import whole_word_admission as a
import memory_boundary as boundary
from build_from_source import HERE, ROOT, run
from environment import digest, write

KEYS = tuple(product(range(2), range(2), a.NAMES, a.NAMES))
INDEX = {k: i for i, k in enumerate(KEYS)}
N = len(KEYS)


def basis_matrix(key):
    p, c, d, e = key
    proj = np.zeros((4, 4)); proj[2*p+c, 2*p+c] = 1
    return np.kron(proj, np.kron(a.P[a.NAMES.index(d)], a.P[a.NAMES.index(e)]))


def matrix(v):
    return sum((float(x)*basis_matrix(k) for k, x in zip(KEYS, v) if x), np.zeros((16, 16), complex))


def query(axis):
    if axis == 'program_Z': return tuple(F((-1)**p if d == e == 'I' else 0) for p, c, d, e in KEYS)
    if axis == 'clock_Z': return tuple(F((-1)**c if d == e == 'I' else 0) for p, c, d, e in KEYS)
    return tuple(F(int(d == axis and e == 'I')) for p, c, d, e in KEYS)


class Span:
    def __init__(self): self.rows = {}

    def residual(self, vector):
        v = list(vector)
        for pivot, row in sorted(self.rows.items()):
            if v[pivot]:
                q = v[pivot]; v = [x-q*y for x, y in zip(v, row)]
        return tuple(v)

    def add(self, vector):
        v = self.residual(vector)
        pivot = next((i for i, x in enumerate(v) if x), None)
        if pivot is None: return False
        self.rows[pivot] = tuple(x/v[pivot] for x in v)
        return True


def push(vector, transitions):
    out = [F(0)]*N
    for i, x in enumerate(vector):
        if x:
            for j, weight in transitions[i]: out[j] += weight*x
    return tuple(out)


def maps(reading):
    incoming = {(r['program'], r['next_clock']): r for r in reading['rows']}
    if len(incoming) != 4: raise ValueError('Step does not permute all resident control addresses')
    tick = []; reopen = []; cz = np.diag([1, 1, 1, -1])
    for p, c, d, e in KEYS:
        row = incoming[p, c]; dd = row['pullback'][d]; ee = reading['memory_pullback'][e]
        tick.append([(INDEX[p, row['clock'], dd['axis'], ee['axis']], F(dd['sign']*ee['sign']))])
        # CZ conjugation involves only Gaussian integers, exactly representable
        # here. No epsilon-based rank or approximate operator identification.
        got = cz@np.kron(a.P[a.NAMES.index(d)], a.P[a.NAMES.index(e)])@cz
        candidates = [(x, y, s) for x, y, s in product(a.NAMES, a.NAMES, (1, -1))
                      if np.array_equal(got, s*np.kron(a.P[a.NAMES.index(x)], a.P[a.NAMES.index(y)]))]
        if len(candidates) != 1: raise ValueError('CZ did not have an exact Pauli image')
        x, y, s = candidates[0]; reopen.append([(INDEX[p, c, x, y], F(s))])
    return {'tick': tick, 'reopen_service': reopen}


def renewal_map(name):
    out = []
    for i, (p, c, d, e) in enumerate(KEYS):
        if name == 'service_uniform': terms = [(i, F(1))] if e == 'I' else []
        elif name == 'service_dephase': terms = [(i, F(1))] if e in ('I', 'Z') else []
        elif name == 'program_uniform': terms = [(INDEX[q, c, d, e], F(1, 2)) for q in range(2)]
        elif name == 'clock_uniform': terms = [(INDEX[p, q, d, e], F(1, 2)) for q in range(2)]
        elif name == 'data_uniform': terms = [(i, F(1))] if d == 'I' else []
        elif name == 'program_dephase': terms = [(i, F(1))]
        elif name == 'coordinated_PC': terms = [(i, F(1, 2)), (INDEX[1-p, 1-c, d, e], F(1, 2))]
        else: raise ValueError('Unknown renewal constructor')
        out.append(terms)
    return out


RENEWALS = ('service_uniform', 'service_dephase', 'program_uniform', 'clock_uniform', 'data_uniform', 'program_dephase', 'coordinated_PC')


def closure(reading, actions=('tick',), questions=('X', 'Y', 'Z')):
    action_maps = maps(reading)
    if not actions or len(set(actions)) != len(actions) or any(x not in action_maps for x in actions):
        raise ValueError('Unsupported future-contact scope')
    if not questions or len(set(questions)) != len(questions) or any(x not in ('X', 'Y', 'Z', 'program_Z', 'clock_Z') for x in questions):
        raise ValueError('Unsupported terminal question scope')
    space = Span(); basis = []; queue = deque()

    def add(v, axis, word):
        if space.add(v):
            item = {'vector': v, 'question': axis, 'word': word}
            basis.append(item); queue.append(item)
            if len(basis) > N: raise AssertionError('Finite dimension exceeded')

    for axis in ('I',)+tuple(questions): add(query(axis), axis, [])
    while queue:
        item = queue.popleft()
        for action in actions:
            add(push(item['vector'], action_maps[action]), item['question'], [action]+item['word'])
    # An actual fixed point, not merely no growth for a chosen depth budget.
    for item in basis:
        for action in actions:
            assert not any(space.residual(push(item['vector'], action_maps[action])))
    decisions = {}
    for name in RENEWALS:
        transform = renewal_map(name)
        witness = next((item for item in basis if push(item['vector'], transform) != item['vector']), None)
        decisions[name] = {'allowed': witness is None}
        if witness:
            delta = tuple(x-y for x, y in zip(push(witness['vector'], transform), witness['vector']))
            decisions[name]['witness'] = {'question': witness['question'], 'word': witness['word'],
                'observable_delta': [[i, str(x)] for i, x in enumerate(delta) if x]}
    encoded_basis = [{'question': r['question'], 'word': r['word'],
                      'vector': [[i, str(x)] for i, x in enumerate(r['vector']) if x]} for r in basis]
    result = {'schema': 'vi.resident-continuation-observables.v1', 'future_actions': list(actions),
              'terminal_questions': list(questions), 'ambient_dimension': N,
              'dimension': len(basis), 'maximum_witness_depth': max(len(r['word']) for r in basis),
              'basis': encoded_basis, 'renewals': decisions, 'source': a.fingerprint(reading),
              'implementation_sha256': digest(Path(__file__)), 'scope': reading['scope']}
    return result


def at(operator, register):
    return np.kron(np.eye(2**register), np.kron(operator, np.eye(2**(3-register))))


def circuit(reading):
    # SDK little-endian wires E=0,D=1,C=2,P=3; matrix tensor order P,C,D,E.
    q = QuantumCircuit(4, name='resident_tick')
    for row in reading['rows']:
        g = {'h': a.H, 's': a.S}[row['gate']]
        q.append(UnitaryGate(g).control(2, ctrl_state=row['program']+2*row['clock']), [3, 2, 1])
    q.x(2); q.z(0)
    return q


@lru_cache(maxsize=2)
def current_source(key): return json.loads(run(['node', HERE/'resident_program_court.js', 'read']))


def validate(reading):
    key = tuple((n, digest(ROOT/n)) for n in sorted(reading['source_sha256']))
    if dict(key) != reading['source_sha256']: raise ValueError('Resident source changed')
    key += tuple((str(p), digest(p)) for p in [HERE/'resident_program_court.js', HERE/'joint_return_court.js', HERE/'contact_court.js', HERE/'court_bridge.js'])
    if current_source(key) != reading: raise ValueError('Resident rule not read from the current root')
    if boundary.distribution(reading['renewal']) != {k: F(1, 4) for k in a.NAMES}:
        raise ValueError('Actual service renewal differs from the declared map')
    if reading['coordinated_PC'] != [['I', 'I'], ['X', 'X']]:
        raise ValueError('Coordinated operation does not have one common choice')
    if reading['reopen_blocks'] != [{'word': 'I', 'phase': 0}, {'word': 'Z', 'phase': 0}]:
        raise ValueError('Presented service contact is not the implemented CZ')
    if sorted((row['program'], row['clock'], row['next_clock']) for row in reading['rows']) != [(p, c, 1-c) for p, c in product(range(2), repeat=2)]:
        raise ValueError('Presented clock is not the implemented permutation')
    for row in reading['rows']:
        g = {'h': a.H, 's': a.S}[row['gate']]
        for axis in a.NAMES:
            v = row['pullback'][axis]
            if not np.allclose(g.conj().T@a.P[a.NAMES.index(axis)]@g, v['sign']*a.P[a.NAMES.index(v['axis'])], atol=1e-12):
                raise ValueError('Presented instruction does not match the actual matrix interpretation')
    for axis in a.NAMES:
        v = reading['memory_pullback'][axis]
        if not np.array_equal(a.Z@a.P[a.NAMES.index(axis)]@a.Z, v['sign']*a.P[a.NAMES.index(v['axis'])]):
            raise ValueError('Presented memory action differs from its execution')


class Resident:
    """Same complete step for every program; no per-tick program read by host."""
    def __init__(self, reading, rho, *, actions=('tick',)):
        self.reading = deepcopy(reading); validate(self.reading)
        self._state = np.array(rho, complex, copy=True)
        if self._state.ndim != 2 or len(self._state) % 16 or self._state.shape[0] != self._state.shape[1]:
            raise ValueError('Invalid complete resident carrier/reference')
        if not np.allclose(self._state, self._state.conj().T) or not np.isclose(np.trace(self._state), 1) or np.linalg.eigvalsh(self._state).min() < -1e-10:
            raise ValueError('Invalid resident state')
        self._tick = Operator(circuit(reading)).data
        self._reopen = np.kron(np.eye(4), np.diag([1, 1, 1, -1]))
        self._origin = a.fingerprint(reading); self._tick_hash = a.channel_digest([self._tick])
        self._reopen_hash = a.channel_digest([self._reopen])
        self._released = False
        self._history = []; self.set_scope(actions)

    def check(self):
        if self._released: raise ValueError('Resident state was transferred to its reduced continuation')
        validate(self.reading)
        if self._origin != a.fingerprint(self.reading) or self._tick_hash != a.channel_digest([self._tick]) or self._reopen_hash != a.channel_digest([self._reopen]):
            raise ValueError('Current interpreter changed')

    def set_scope(self, actions, questions=('X', 'Y', 'Z')):
        self.check()
        self._certificate = closure(self.reading, tuple(actions), tuple(questions))

    def certificate(self):
        self.check(); return deepcopy(self._certificate)

    def evolve(self, ks):
        ref = len(self._state)//16
        self._state = DensityMatrix(self._state).evolve(Kraus([np.kron(k, np.eye(ref)) for k in ks])).data

    def step(self, action='tick'):
        self.check()
        if action not in self._certificate['future_actions']: raise ValueError('Action outside the established continuation scope')
        self.evolve([self._tick if action == 'tick' else self._reopen])
        self._history.append({'action': action})

    def renew(self, name, certificate=None):
        self.check()
        # An old certificate cannot authorize a different source or a newly
        # enlarged family of continuations. No separately stored trust flag.
        current = closure(self.reading, tuple(self._certificate['future_actions']), tuple(self._certificate['terminal_questions']))
        if current != self._certificate or (certificate is not None and certificate != current):
            raise ValueError('Renewal certificate no longer applies')
        if name not in current['renewals'] or not current['renewals'][name]['allowed']:
            raise ValueError('Renewal changes an allowed future answer')
        if name == 'program_dephase': ks = [at(a.I, 0)/np.sqrt(2), at(a.Z, 0)/np.sqrt(2)]
        elif name == 'service_dephase': ks = [at(a.I, 3)/np.sqrt(2), at(a.Z, 3)/np.sqrt(2)]
        elif name == 'coordinated_PC':
            ks = [at(a.P[a.NAMES.index(p)], 0)@at(a.P[a.NAMES.index(c)], 1)/np.sqrt(2)
                  for p, c in self.reading['coordinated_PC']]
        else:
            reg = {'program_uniform': 0, 'clock_uniform': 1, 'data_uniform': 2, 'service_uniform': 3}[name]
            ks = [at(a.P[a.NAMES.index(k)], reg)*np.sqrt(float(w))
                  for k, w in boundary.distribution(self.reading['renewal']).items()]
        self.evolve(ks); self._history.append({'renewal': name, 'certificate': a.fingerprint(current)})

    def snapshot(self):
        self.check(); return self._state.copy(), deepcopy(self._history)

    def reduce(self):
        self.check()
        result = ReducedResident(self.reading, self._certificate, self._state, self._history)
        self._released = True
        self._state = None
        return result


def reduction(reading, certificate):
    """A physical CPTP representation sufficient for this question family.

    Its observable algebra can have more dimensions than the minimal linear
    continuation space: retained classical populations are extra information.
    This is not a general minimal-Hilbert-space realization algorithm.
    """
    current = closure(reading, tuple(certificate['future_actions']), tuple(certificate['terminal_questions']))
    if current != certificate: raise ValueError('Reduction uses a different continuation family')
    if any(q not in ('X', 'Y', 'Z') for q in certificate['terminal_questions']):
        raise ValueError('Parity representation does not retain separate program/clock labels')
    keep_service = not certificate['renewals']['service_uniform']['allowed']
    gates = {}
    for row in reading['rows']:
        parity = row['program'] ^ row['clock']
        if row['next_clock'] != 1-row['clock']: raise ValueError('Clock does not advance by the established rule')
        if parity in gates and gates[parity] != row['gate']: raise ValueError('Relative control is not sufficient')
        gates[parity] = row['gate']
    v = np.zeros((4, 4), complex)
    for parity, gate in gates.items():
        v[2*(1-parity):2*(1-parity)+2, 2*parity:2*parity+2] = {'h': a.H, 's': a.S}[gate]
    if keep_service: v = np.kron(v, a.Z)
    dim = 8 if keep_service else 4
    compression = []
    for p, c in product(range(2), repeat=2):
        dephase_service = certificate['renewals']['service_dephase']['allowed']
        for efixed in ([None] if keep_service and not dephase_service else range(2)):
            k = np.zeros((dim, 16), complex)
            for d, e in product(range(2), repeat=2):
                if efixed is None or e == efixed:
                    k[((p ^ c)*2+d)*2+e if keep_service else (p ^ c)*2+d, ((p*2+c)*2+d)*2+e] = 1
            compression.append(k)
    if not Kraus(compression).is_cptp(atol=1e-12): raise ValueError('Compression is not a channel')
    return keep_service, compression, v


class ReducedResident:
    def __init__(self, reading, certificate, state, history):
        self.reading = deepcopy(reading); self._certificate = deepcopy(certificate)
        keep, compression, self._tick = reduction(reading, certificate)
        self.keep_service = keep; self.dimension = 8 if keep else 4
        self._reference = len(state)//16
        self._state = a.apply(compression, state, self._reference)
        self._history = deepcopy(history)+[{'transfer_to_relative_control': True, 'service_retained': keep}]
        self._reopen = np.kron(np.eye(2), np.diag([1, 1, 1, -1])) if keep else None
        self._origin = a.fingerprint(reading); self._tick_hash = a.channel_digest([self._tick])
        self._reopen_hash = a.channel_digest([self._reopen]) if keep else None

    def step(self, action='tick'):
        validate(self.reading)
        if a.fingerprint(self.reading) != self._origin or a.channel_digest([self._tick]) != self._tick_hash or (self.keep_service and a.channel_digest([self._reopen]) != self._reopen_hash):
            raise ValueError('Reduced source changed')
        if action not in self._certificate['future_actions']:
            raise ValueError('New contact requires a new retained-memory justification')
        op = self._tick if action == 'tick' else self._reopen
        if op is None: raise ValueError('Service register was not retained')
        self._state = DensityMatrix(self._state).evolve(Operator(np.kron(op, np.eye(self._reference)))).data
        self._history.append({'action': action})

    def snapshot(self): return self._state.copy(), deepcopy(self._history)


def build(directory):
    directory.mkdir(parents=True, exist_ok=True)
    proof = json.loads(run(['node', HERE/'resident_program_court.js', 'build', directory]))
    native = ROOT/'.build/arm64-apple-macosx/debug/Tools'
    log = run([native, 'judge', 'where', directory/'ResidentInterpreter.swift'])
    assert f"{proof['equalities']} equalities" in log and 'THE WHERE holds' in log
    for item in proof['negatives']:
        p = subprocess.run([str(native), 'judge', 'where', str(directory/item['file'])], capture_output=True, text=True, timeout=30)
        assert p.returncode == 1 and 'requires the types' in p.stdout+p.stderr
    proof['native'] = log.strip()
    proof['implementation_sha256'] = {str(p.relative_to(ROOT)): digest(p) for p in
        [Path(__file__), HERE/'resident_program_court.js', HERE/'memory_boundary.py', HERE/'whole_word_admission.py']}
    write(directory/'build.json', proof)
    return proof


if __name__ == '__main__':
    p = argparse.ArgumentParser(description=__doc__); p.add_argument('--output', required=True, type=Path)
    result = build(p.parse_args().output.resolve())
    print(json.dumps({'equalities': result['equalities'], 'refusals_each_court': len(result['negatives'])}))
