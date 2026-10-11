#!/usr/bin/env python3
"""Choose a measurement boundary from an independent question and its future.

Scope: finite phase-free XOR contacts, a returned binary probe, projective
questions, and a Pauli future closed under declared Clifford conjugations.
The search is bounded; an empty search is not an impossibility certificate.
No hardware client and no special branch for the B/parity example.
"""
from itertools import product
import numpy as np
import orbit_return as source_reader

require = source_reader.require
fingerprint = source_reader.fingerprint
I2 = np.eye(2, dtype=complex)
X = np.array([[0, 1], [1, 0]], complex)
Y = np.array([[0, -1j], [1j, 0]], complex)
Z = np.diag([1, -1]).astype(complex)


def equal(a, b):
    # Producing matrices below contain integers and dyadic rationals only.
    return np.array_equal(a, b)


def code(matrix):
    return [[[float(v.real), float(v.imag)] for v in row] for row in matrix]


def matrix(value):
    return np.array([[complex(*v) for v in row] for row in value])


def paulis(n):
    out = {}
    for letters in product('IXYZ', repeat=n):
        m = np.ones((1, 1), complex)
        for letter in letters: m = np.kron(m, dict(zip('IXYZ', (I2, X, Y, Z)))[letter])
        out[''.join(letters)] = m
    return out


def interface(source, fields=('ProbeB', 'ProbeParity'), coherent=True):
    require(source == source_reader.read_source(), 'Not the current Swift source reading')
    size = len(source['rows'])
    require(size > 1 and size & (size - 1) == 0, 'Need a finite qubit carrier')
    tables = {name: [row[name] for row in source['rows']] for name in fields}
    require(tables and all(type(v) is int and v in (0, 1) for f in tables.values() for v in f), 'Not a binary contact')
    body = {'source': fingerprint(source), 'size': size, 'contacts': tables,
            'coherent_between_contacts': coherent,
            'contact_contract': 'Phase-free XOR into the same binary probe; source ports retained.',
            'probe_contract': 'Prepared zero, Z measurement, actual-record X return to zero.'}
    return {**body, 'id': fingerprint(body)}


def validate_interface(spec):
    require(spec['id'] == fingerprint({k: v for k, v in spec.items() if k != 'id'}), 'Contact interface changed')


def projectors(values):
    require(values and all(type(v) is int and v in (0, 1) for v in values), 'Complete binary question required')
    return [np.diag([int(v == a) for v in values]).astype(complex) for a in (0, 1)]


def dual(gate, observable):
    n = matrix(gate['numerator']); d = gate['norm_squared']
    require(type(d) is int and 0 < d <= len(n) and d & (d-1) == 0 and
            set(n.flat) <= {0, 1, -1, 1j, -1j} and
            equal(n.conj().T @ n, d * np.eye(len(n))), 'Not a producing dyadic Clifford unitary')
    return (n.conj().T @ observable @ n) / d


def close_future(size, terminals, gates):
    vocabulary = paulis(size.bit_length() - 1)
    require(terminals and all(t in vocabulary for t in terminals), 'Unknown terminal question')
    identity = 'I' * (size.bit_length() - 1)
    found = {t: {'terminal': t, 'word': [], 'sign': 1} for t in dict.fromkeys([identity] + terminals)}
    pending = list(found)
    transitions = {}
    while pending:
        label = pending.pop(0); transitions[label] = {}
        for name, gate in gates.items():
            transformed = dual(gate, vocabulary[label])
            matches = [(t, sign) for t, m in vocabulary.items() for sign in (1, -1) if equal(transformed, sign*m)]
            require(len(matches) == 1, 'Future left the declared finite Pauli fragment')
            target, sign = matches[0]; transitions[label][name] = [target, sign]
            if target not in found:
                w = found[label]
                found[target] = {'terminal': w['terminal'], 'word': [name] + w['word'], 'sign': sign*w['sign']}
                pending.append(target)
    return {'basis': found, 'transitions': transitions}


def request(spec, values, terminals, gates=None):
    validate_interface(spec); require(len(values) == spec['size'], 'Question refers to a different carrier')
    projectors(values)
    gates = gates or {}
    body = {'interface': spec['id'], 'values': list(values), 'terminals': list(terminals),
            'future_gates': gates, 'closure': close_future(spec['size'], terminals, gates),
            'target': 'Joint acquired answer and all declared future readings after ideal projective acquisition.'}
    return {**body, 'id': fingerprint(body)}


def validate_request(spec, query):
    require(query == request(spec, query['values'], query['terminals'], query['future_gates']),
            'The request or its pulled-back future changed')


def instrument(spec, word, read_after):
    """Actual unnormalized maps from composing contacts, reads and probe repair."""
    validate_interface(spec); n = spec['size']
    require(len(word) == len(read_after) and (not word or read_after[-1]), 'Missing final acquisition')
    require(all(type(v) is bool for v in read_after), 'Nonliteral measurement boundary')
    require(spec['coherent_between_contacts'] or all(read_after), 'Coherent access was not supplied')
    start = np.zeros((2*n, n), complex); start[:n] = np.eye(n)
    rows = {(): start}
    for name, observe in zip(word, read_after):
        require(name in spec['contacts'], 'Unavailable contact')
        f = spec['contacts'][name]
        u = np.zeros((2*n, 2*n), complex)
        for col in range(2*n): u[(col % n) + n*((col // n) ^ f[col % n]), col] = 1
        rows = {r: u @ k for r, k in rows.items()}
        if observe:
            after = {}
            for record, k in rows.items():
                for bit in (0, 1):
                    # Project P=bit and apply X_P^bit, retaining the actual bit.
                    reset = np.zeros((2*n, 2*n), complex)
                    reset[:n, bit*n:(bit+1)*n] = np.eye(n)
                    after[record+(bit,)] = reset @ k
            rows = after
    require(all(not np.any(k[n:]) for k in rows.values()), 'Probe not returned')
    result = {r: k[:n] for r, k in rows.items()}
    require(equal(sum(k.conj().T @ k for k in result.values()), np.eye(n)), 'Incomplete acquired instrument')
    return result


def assess(spec, query, word, read_after):
    validate_request(spec, query)
    rows = instrument(spec, word, read_after); ps = projectors(query['values'])
    decoder = {}
    for record, k in rows.items():
        effect = k.conj().T @ k
        if not np.any(effect): continue
        matches = [a for a, p in enumerate(ps) if equal(p @ effect @ p, effect)]
        if len(matches) != 1:
            return {'admitted': False, 'reason': 'answer_not_determined', 'record': list(record)}
        decoder[''.join(map(str, record))] = matches[0]
    vocabulary = paulis(spec['size'].bit_length() - 1)
    for a, p in enumerate(ps):
        chosen = [k for r, k in rows.items() if decoder.get(''.join(map(str, r))) == a]
        for label, witness in query['closure']['basis'].items():
            observable = vocabulary[label]
            actual = sum((k.conj().T @ observable @ k for k in chosen), np.zeros_like(p))
            expected = p @ observable @ p
            if not equal(actual, expected):
                return {'admitted': False, 'reason': 'future_distinguished', 'answer': a,
                        'direction': label, 'continuation': witness,
                        'operator_difference': code(actual - expected), 'decoder': decoder}
    return {'admitted': True, 'decoder': decoder, 'future_dimension': len(query['closure']['basis']),
            'contacts': len(word), 'readings': sum(read_after), 'probe_returned': True}


def propose(spec, query, word, read_after):
    return {'interface': spec['id'], 'request': query['id'], 'word': list(word), 'read_after': list(read_after),
            'derived': assess(spec, query, word, read_after)}


def verify(spec, query, plan):
    require(plan['interface'] == spec['id'] and plan['request'] == query['id'], 'Plan applies to another boundary')
    derived = assess(spec, query, plan['word'], plan['read_after'])
    require(plan['derived'] == derived, 'Claimed admission or decoder does not follow from the actual process')
    return derived


def decode_record(spec, query, plan, register_value):
    """Only the actually returned register enters the working decoder."""
    proof = verify(spec, query, plan)
    require(proof['admitted'], 'No applicable acquired answer')
    width = proof['readings']
    require(type(register_value) is int and 0 <= register_value < 2**width, 'Wrong acquired register width')
    key = ''.join(str((register_value >> i)&1) for i in range(width))
    require(key in proof['decoder'], 'Record outside the declared instrument; no guessed answer')
    return proof['decoder'][key]


def synthesize(spec, query, max_contacts=3):
    require(type(max_contacts) is int and 1 <= max_contacts <= 4, 'Search must be explicitly bounded')
    checked = 0
    for length in range(max_contacts+1):
        admitted = []
        for word in product(spec['contacts'], repeat=length):
            cuts = ([()] if length == 0 else product((False, True), repeat=length-1)
                    if spec['coherent_between_contacts'] else [(True,)*(length-1)])
            for prefix in cuts:
                plan = propose(spec, query, word, (*prefix, True) if length else ()); checked += 1
                if plan['derived']['admitted']: admitted.append(plan)
        if admitted:
            admitted.sort(key=lambda p: (p['derived']['readings'], p['word']))
            return {'kind': 'found', 'checked_candidates': checked, 'least_contacts_within_grammar': length,
                    'plan': admitted[0], 'all_at_least_contact_depth': admitted,
                    'scope': 'Fixed words and chosen measurement boundaries; no general adaptive-strategy lower bound.'}
    return {'kind': 'not_found_within_bound', 'checked_candidates': checked, 'max_contacts': max_contacts}


def compile_plan(source, spec, query, plan):
    """Gate lowering comes from contact tables, never from the expected answer."""
    from qiskit import QuantumCircuit, ClassicalRegister
    require(source == source_reader.read_source() and spec['source'] == fingerprint(source), 'Current source changed')
    require(spec == interface(source, tuple(spec['contacts']), spec['coherent_between_contacts']),
            'The proposed contact tables are not produced by this source')
    require(verify(spec, query, plan)['admitted'], 'No applicable process')
    n = spec['size'].bit_length()-1; probe = n
    q = QuantumCircuit(n+1)
    raw = ClassicalRegister(sum(plan['read_after']), 'actual_records') if any(plan['read_after']) else None
    if raw is not None: q.add_register(raw)
    slot = 0
    for name, observe in zip(plan['word'], plan['read_after']):
        table = spec['contacts'][name]; constant = table[0]
        slopes = [table[1 << i] ^ constant for i in range(n)]
        require(all(table[s] == (constant ^ (sum(((s >> i)&1)*slopes[i] for i in range(n)) % 2))
                    for s in range(2**n)), 'This SDK lowering requires an affine XOR contact')
        if constant: q.x(probe)
        for i, bit in enumerate(slopes):
            if bit: q.cx(i, probe)
        if observe:
            q.measure(probe, raw[slot])
            with q.if_test((raw[slot], 1)): q.x(probe)
            slot += 1
    q.metadata = {'interface': spec['id'], 'request': query['id'], 'plan': fingerprint(plan),
                  'decoder_of_actual_records': plan['derived']['decoder'],
                  'decoder_bit_order': 'raw register bit 0 first, then increasing index; chronological readings',
                  'source_quantum_wires_retained': list(range(n)), 'probe_returned_zero': probe}
    return q
