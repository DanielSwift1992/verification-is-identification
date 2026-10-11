#!/usr/bin/env python3
"""Source-derived boundary controls and horizon admission using one acquisition.

No cloud calls. Choices act on the complete local E before the WHOLE word.
This executable fragment uses tau=I/2; the report proves a more general CPTP
transport statement. It does not certify arbitrary drift or preservation of E.
"""
import argparse
from collections import Counter
from copy import deepcopy
from fractions import Fraction
from functools import lru_cache
from itertools import combinations_with_replacement
import json
from pathlib import Path
import subprocess

import numpy as np
from qiskit.quantum_info import DensityMatrix, Kraus, SuperOp

import whole_word_admission as a
from build_from_source import ROOT, HERE, run
from environment import digest, write
from planner import synthesize


def compose(later, earlier):
    return [b @ c for b in later for c in earlier]


def prepare(tau, p):
    """General A_p Kraus construction, used by the independent theorem audit."""
    if not 0 <= p <= 1: raise ValueError('Invalid preparation weight')
    if not np.allclose(tau, tau.conj().T) or not np.isclose(np.trace(tau), 1):
        raise ValueError('Invalid preparation state')
    weights, vectors = np.linalg.eigh(tau)
    if min(weights) < -1e-12: raise ValueError('Preparation is not positive')
    m = len(tau)
    return [np.sqrt(1-p)*np.eye(m)] + [
        np.sqrt(p*max(w, 0))*np.outer(vectors[:, i], np.eye(m)[j])
        for i, w in enumerate(weights) for j in range(m)]


def distribution(tree):
    """Interpret a finite Pauli/private-fair-choice expression, not its name."""
    if set(tree) == {'pauli'} and tree['pauli'] in a.NAMES:
        return {tree['pauli']: Fraction(1)}
    if set(tree) != {'choice'} or len(tree['choice']) != 2:
        raise ValueError('Not an executable choice tree')
    out = Counter()
    for branch in tree['choice']:
        for p, w in distribution(branch).items(): out[p] += w/2
    return dict(out)


def decode(recipe):
    if recipe['target'] != 'E' or recipe['placement'] != 'before_complete_word':
        raise ValueError('Unsupported boundary or register')
    weights = distribution(recipe['tree'])
    # This equality is checked against the actual tree. A name such as Half
    # never supplies an assumed reset rate to the admission rule.
    p = 4*weights.get('X', Fraction(0))
    if not 0 <= p <= 1 or any(weights.get(k, Fraction(0)) != p/4 for k in ('Y', 'Z')) or weights.get('I', 0) != 1-3*p/4:
        raise ValueError('This choice is not isotropic boundary preparation')
    ks = [np.sqrt(float(w))*a.P[a.NAMES.index(k)] for k, w in weights.items()]
    direct = SuperOp(Kraus(ks)).data
    expected = SuperOp(Kraus(prepare(a.I/2, float(p)))).data
    if not np.allclose(direct, expected, atol=1e-12):
        raise ValueError('Choice semantics do not implement the preparation channel')
    # One nonidentity Pauli control is one declared cost unit. This is not
    # pulse duration; random-bit generation and hardware overhead are excluded.
    return p, 1-weights.get('I', 0), ks


@lru_cache(maxsize=2)
def current_reading(key):
    return json.loads(run(['node', HERE/'memory_boundary_court.js', 'read']))


def validate_reading(data):
    key = tuple((n, digest(ROOT/n)) for n in sorted(data['source_sha256']))
    if dict(key) != data['source_sha256']: raise ValueError('Boundary root changed')
    key += tuple((str(p), digest(p)) for p in [HERE/'memory_boundary_court.js', HERE/'whole_word_frame.js', HERE/'joint_return_court.js', HERE/'contact_court.js', HERE/'court_bridge.js'])
    if data != current_reading(key): raise ValueError('Recipes not read from the current root')
    for r in data['recipes'].values(): decode(r)


class BoundaryInterface:
    """Constructed transformation of one actual, calibrated LocalWord."""
    def __init__(self, source, record, reading):
        self.source = source
        self.record = deepcopy(record)
        self.reading = deepcopy(reading)
        validate_reading(self.reading)
        self.origin = self.binding()
        self.check()

    def binding(self):
        return {'source': self.source.binding(), 'boundary_reading': a.fingerprint(self.reading),
                'record': a.fingerprint(self.record), 'implementation_sha256': digest(Path(__file__)),
                'question': 'U_on_D_product_arbitrary_CPTP_on_complete_E',
                'seed_output': 'absent', 'placement': 'before_complete_word'}

    def check(self):
        self.source.check()
        validate_reading(self.reading)
        if self.record not in self.source.records:
            raise ValueError('No acquisition from this actual source')
        if not np.allclose(self.source.tau, a.I/2, atol=1e-14, rtol=0):
            raise ValueError('This Pauli recipe prepares I/2, not an arbitrary calibration state')
        if self.binding() != self.origin:
            raise ValueError('Current boundary, word, preparation or evidence changed')

    def options(self):
        self.check()
        e = a.upper_binomial(self.record['failures'], self.record['shots'], self.record['alpha'])
        b = min(1., 2*e)
        out = {}
        for name, recipe in self.reading['recipes'].items():
            p, cost, _ = decode(recipe)
            out[name] = {'preparation_weight': float(p), 'expected_E_controls': float(cost),
                         'one_use_bound': (1-float(p))*b+float(p)*e}
        return e, b, out

    def plan(self, horizon, tolerance, *, past_success=1.):
        # Public planning helper; the state-owning continuation supplies its
        # actual spent history. An external past_success cannot authorize use.
        if type(horizon) is not int or not 1 <= horizon <= 16:
            raise ValueError('Finite planner supports 1..16 whole-word uses')
        if not 0 <= tolerance <= 1 or not 0 <= past_success <= 1:
            raise ValueError('Invalid tolerance or spent certificate')
        e, b, options = self.options()
        names = sorted(options)
        candidates = {}; actions = {}
        # Product bound and additive declared cost depend only on counts.
        # No claim that the actual resulting channels are order-independent.
        for sequence in combinations_with_replacement(names, horizon):
            success = past_success
            for name in sequence: success *= 1-options[name]['one_use_bound']
            if 1-success > tolerance: continue
            key = '|'.join(sequence)
            cost = sum(decode(self.reading['recipes'][name])[1] for name in sequence)
            candidates[key] = {'schedule': list(sequence), 'total_bound': 1-success,
                               'expected_E_controls': float(cost)}
            actions[key] = {'physical_gates': cost}
        selection = synthesize({'valid': [list(actions)], 'actions': actions, 'probes': []})['tree']
        packet = {'kind': 'act' if selection['kind'] == 'act' else 'needs_evidence',
                  'horizon': horizon, 'tolerance': tolerance, 'past_success': past_success,
                  'bell_failure_upper': e, 'unprepared_bound': b, 'options': options,
                  'alpha': self.record['alpha'], 'binding': deepcopy(self.origin),
                  'cost_scope': 'Expected nonidentity E Pauli controls; finite menu, fixed horizon, product-bound certificate.'}
        if selection['kind'] == 'act': packet.update(candidates[selection['action']])
        return packet

    def kraus(self, name):
        self.check()
        _, _, memory = decode(self.reading['recipes'][name])
        # Source is used intact. There is no traversal into source.body and
        # no per-A insertion. These controls have no seed output register.
        return compose(self.source.wrapped, [np.kron(a.I, k) for k in memory])


class BoundaryContinuation:
    """Own the quantum state, spent budget and any remaining committed plan."""
    def __init__(self, interface, rho, *, tolerance):
        self.interface = interface; self.tolerance = tolerance
        self._state = np.array(rho, complex, copy=True)
        if self._state.ndim != 2 or self._state.shape[0] != self._state.shape[1] or self._state.shape[0] % 4:
            raise ValueError('Wrong complete carrier/reference')
        if not np.allclose(self._state, self._state.conj().T) or not np.isclose(np.trace(self._state), 1) or np.linalg.eigvalsh(self._state).min() < -1e-10:
            raise ValueError('Invalid input state')
        self._history = []; self._pending = []; self._plan = None

    def success(self):
        result = 1.
        for p in self._history: result *= 1-p['one_use_bound']
        return result

    def reserve(self, horizon):
        if self._pending: raise ValueError('A still-pending plan cannot be silently replaced')
        packet = self.interface.plan(horizon, self.tolerance, past_success=self.success())
        if packet['kind'] == 'act':
            self._plan = deepcopy(packet); self._pending = list(packet['schedule'])
        return packet

    def step(self):
        if not self._pending: return {'kind': 'needs_plan'}
        self.interface.check()
        expected = self.interface.plan(self._plan['horizon'], self.tolerance, past_success=self._plan['past_success'])
        if expected != self._plan: raise ValueError('Plan no longer follows from the current construction')
        name = self._pending[0]; option = expected['options'][name]
        success = self.success()*(1-option['one_use_bound'])
        if 1-success > self.tolerance: raise ValueError('Spent history exceeds the admitted tolerance')
        ks = self.interface.kraus(name); ref = len(self._state)//4
        following = DensityMatrix(self._state).evolve(Kraus([np.kron(k, np.eye(ref)) for k in ks])).data
        packet = {'kind': 'act', 'recipe': name, **option, 'total_bound': 1-success,
                  'use_number': len(self._history)+1, 'binding': deepcopy(self.interface.origin),
                  'plan_sha256': a.fingerprint(self._plan)}
        self._state = following; self._pending.pop(0); self._history.append(packet)
        return deepcopy(packet)

    def snapshot(self):
        return self._state.copy(), deepcopy(self._history), list(self._pending)


def build(directory):
    directory.mkdir(parents=True, exist_ok=True)
    proof = json.loads(run(['node', HERE/'memory_boundary_court.js', 'build', directory]))
    native = ROOT/'.build/arm64-apple-macosx/debug/Tools'
    log = run([native, 'judge', 'where', directory/'MemoryBoundary.swift'])
    assert f"{proof['equalities']} equalities" in log and 'THE WHERE holds' in log
    for n in proof['negatives']:
        p = subprocess.run([str(native), 'judge', 'where', str(directory/n['file'])], capture_output=True, text=True, timeout=30)
        assert p.returncode == 1 and 'requires the types' in p.stdout+p.stderr
    proof['native'] = log.strip()
    proof['implementation_sha256'] = {str(p.relative_to(ROOT)): digest(p) for p in
        [Path(__file__), HERE/'memory_boundary_court.js', HERE/'whole_word_admission.py', HERE/'planner.py']}
    write(directory/'build.json', proof)
    return proof


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', required=True, type=Path)
    result = build(parser.parse_args().output.resolve())
    print(json.dumps({'equalities': result['equalities'], 'refusals_each_court': len(result['negatives'])}, indent=2))
