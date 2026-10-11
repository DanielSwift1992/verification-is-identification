#!/usr/bin/env python3
"""Independent branch semantics and refusals for generic boundary composition.

No QPU calls. The full branch matrices cover arbitrary retained input and any
external reference by linear extension. Fixture parameters are audit inputs,
never inputs of the recipe planner.
"""
from copy import deepcopy
from dataclasses import replace
import io
import itertools
import json
from pathlib import Path
import time

import numpy as np
from qiskit import ClassicalRegister, qpy
from qiskit_aer import AerSimulator
from qiskit_aer.library import save_density_matrix

import resident_boundary_composition as c
from resident_goal_instrument_audit import interpret
from resident_raw_reply_checks import fixture
from resident_stream_checks import operators

OUT = c.s.ROOT/'Research/Artifacts/resident-boundary-composition-20260915'


def question(source, masks, occurrence='exit', recipient=None):
    if recipient is None:
        recipient = [i.bit_count() & 1 for i in range(2**len(masks))]
    return c.joint.request(source, [[(m>>i)&1 for i in range(8)] for m in masks], occurrence, recipient)


def canonical(q, ports):
    inverse = [ports.index(i) for i in range(5)]
    result = q.copy_empty_like()
    result.compose(q, qubits=inverse, inplace=True)
    return result


def direct(source, ks, requests, events, prefix):
    maps = operators(source['goal']['raw'], ks)
    output = np.eye(16, dtype=complex)
    r, history, stage, fields, entry = 0, [], 0, [], None
    Z = np.kron(c.a.I, np.kron(c.a.Z, np.eye(4)))
    for event in events:
        if event['kind'] == 'contact':
            bit = event['reply']
            gate, = maps[r, bit]
            output = gate @ output
            r = 1 ^ r ^ bit
            history.append(bit)
            if len(history) == prefix:
                entry = 4*r+2*history[0]+history[-1]
        else:
            assert entry is not None and stage < len(requests)
            current = 4*r+2*history[0]+history[-1]
            request = requests[stage]
            which = entry if request['occurrence'] == 'entry' else current
            assert request['questions'][len(fields)][which] == event['bit']
            fields.append(event['bit'])
            if len(fields) == len(request['questions']):
                code = sum(bit<<i for i, bit in enumerate(fields))
                if request['recipient'][code]:
                    output = Z @ output
                fields = []
                stage += 1
                entry = current
    assert stage == len(requests) and not fields and len(history) >= prefix
    return output, 4*r+2*history[0]+history[-1]


def branch_audit(source, q, ports, ks, requests, prefix, cut):
    normalized = canonical(q, ports)
    branches = interpret(normalized)
    total = np.zeros((16, 16), complex)
    maximum, by_event = 0., {}
    memory = next(reg for reg in normalized.cregs if reg.name == cut._memory.name)
    for branch in branches:
        expected, current = direct(source, ks, requests, branch['events'], prefix)
        assert np.max(abs(branch['map'][1::2])) < 1e-12
        actual = branch['map'][::2]
        maximum = max(maximum, float(np.max(abs(actual-expected))))
        code = sum(branch['bits'][normalized.find_bit(bit).index]<<i for i, bit in enumerate(memory))
        assert current in cut.contract['supports'][code]
        key = tuple((e['kind'], e.get('reply', e.get('bit'))) for e in branch['events'])
        assert key not in by_event
        by_event[key] = actual
        total += actual.conj().T @ actual
    assert maximum < 1e-11
    completeness = float(np.max(abs(total-np.eye(16))))
    assert completeness < 1e-11
    return {'branches': len(branches), 'operator_residual': maximum,
            'completeness_residual': completeness}, by_event


def refusals(source, service):
    names = []
    def no(name, action):
        try:
            action()
        except (ValueError, KeyError, TypeError):
            names.append(name)
            return
        raise AssertionError('Accepted '+name)
    assembly = c.Assembly(source, service)
    cut = assembly.prepare_first()
    good = c.recipe(source, cut.contract, question(source, [170]))
    before = c.digest_circuit(assembly.program(cut))
    unavailable = c.recipe(source, cut.contract, question(source, [170], 'entry'))
    assert not unavailable['applicable']
    no('historical answer not acquired', lambda: assembly.extend(cut, unavailable))
    bad = deepcopy(good)
    bad['input']['supports'][0] = bad['input']['supports'][0][:1]
    no('unmeasured input alternative deleted', lambda: assembly.extend(cut, bad))
    bad = deepcopy(good)
    bad['query']['occurrence'] = 'entry'
    no('answer moved to a different occurrence', lambda: assembly.extend(cut, bad))
    bad = deepcopy(good)
    bad['certificates'][0]['nodes'][0]['next'].reverse()
    no('contact successor substituted', lambda: assembly.extend(cut, bad))
    bad = deepcopy(good)
    bad['query']['recipient'] = [1, 0]
    no('receiver changed after proof', lambda: assembly.extend(cut, bad))
    no('copied descriptor is not the current construction right', lambda: assembly.extend(replace(cut), good))
    other = c.Assembly(source, service)
    foreign = other.prepare_first()
    no('same-looking boundary of another instance', lambda: assembly.extend(foreign, good))
    no('same-named physical port relabelled', lambda: assembly.extend(replace(cut, _ports=(0, 2, 1, 3, 4)), good))
    assert c.digest_circuit(assembly.program(cut)) == before
    new = assembly.extend(cut, good)
    no('used boundary reused independently', lambda: assembly.extend(cut, good))
    no('initial acquisition repeated at a later boundary', lambda: assembly.prepare_first())
    no('old recipe not rebound to its actual new input', lambda: assembly.extend(new, good))
    # The recipe verifier must work without the search implementation.
    future = c.recipe(source, new.contract, question(source, [204], 'entry'))
    search = c.joint.synthesize
    c.joint.synthesize = lambda *args, **kwargs: (_ for _ in ()).throw(AssertionError('Verifier repeated search'))
    try:
        c.verify_recipe(source, future)
        assembly.extend(new, future)
    finally:
        c.joint.synthesize = search
    tampered = c.Assembly(source, service)
    current = tampered.prepare_first()
    model = c.recipe(source, current.contract, question(source, [204]))
    tampered._q.z(current._ports[3])
    no('unreported operation after boundary', lambda: tampered.extend(current, model))
    forged = c.Assembly(source, service)
    current = forged.prepare_first()
    current._schema['supports'][0] = current._schema['supports'][0][:1]
    no('mutable boundary content replaced', lambda: forged.program(current))
    return {'cases': names, 'refusals_before_append_preserve_program': True,
            'verification_and_execution_do_not_call_search': True}


def samples(q, ports, shots=64):
    audited = q.copy_empty_like()
    measurements = sum(item.operation.name == 'measure' for item in q.data)
    records = ClassicalRegister(measurements, 'audit_actual_records')
    audited.add_register(records)
    j = 0
    for item in q.data:
        audited.append(item)
        if item.operation.name == 'measure':
            audited.store(records[j], item.clbits[0])
            j += 1
    save_density_matrix(audited, list(ports[1:]), label='continued', pershot=True)
    model = canonical(audited, ports)
    exact = {tuple(b['bits']): b for b in interpret(model)}
    result = AerSimulator(method='statevector', max_parallel_threads=1).run(
        audited, shots=shots, memory=True, seed_simulator=915201).result()
    assert result.success
    maximum = 0.
    for record, saved in zip(result.get_memory(), result.data()['continued']):
        value = int(record.replace(' ', ''), 2)
        bits = tuple((value>>i)&1 for i in range(audited.num_clbits))
        assert bits in exact
        v = exact[bits]['map'][::2, 0]
        expected = np.outer(v, v.conj()) / np.vdot(v, v).real
        maximum = max(maximum, float(np.max(abs(saved.data-expected))))
    assert maximum < 1e-11
    return {'shots': shots, 'retained_state_residual': maximum}


def run():
    before = time.perf_counter()
    source = c.s.reading()
    queries = [question(source, [254, 239], recipient=[0, 0, 0, 1]),
               question(source, [204], 'entry'), question(source, [170], 'exit')]
    cases = []
    fixtures = [(1.3, -.8), (1.45, .91)]
    for theta, phi in fixtures:
        service, ks, _ = fixture(theta, phi)
        paired = []
        for presentation, ports in [('direct', (0, 1, 2, 3, 4)), ('turned', (2, 4, 0, 1, 3))]:
            assembly = c.Assembly(source, service)
            cut = assembly.prepare_first(presentation=presentation, ports=ports)
            old_cuts = []
            for query in queries:
                old_cuts.append(cut)
                compiled = c.recipe(source, cut.contract, query)
                assert compiled['applicable']
                cut = assembly.extend(cut, compiled)
            q = assembly.program(cut)
            audit, events = branch_audit(source, q, ports, ks, queries, 3, cut)
            paired.append(events)
            stream = io.BytesIO()
            qpy.dump(q, stream)
            stream.seek(0)
            restored, = qpy.load(stream)
            restored_audit, _ = branch_audit(source, restored, ports, ks, queries, 3, cut)
            audit['QPY_round_trip_residual'] = restored_audit['operator_residual']
            audit['local_execution'] = samples(restored, ports)
            audit.update(fixture=[theta, phi], presentation=presentation, ports=list(ports),
                         prepared_once=True, requests=len(queries),
                         initial_memory_bits=old_cuts[0].contract['memory_width'],
                         output_memory_bits=cut.contract['memory_width'])
            cases.append(audit)
        assert paired[0].keys() == paired[1].keys()
        assert max(np.max(abs(paired[0][k]-paired[1][k])) for k in paired[0]) < 1e-11
    result = {'schema': 'vi.boundary-composition-audit.v1', 'cases': cases,
              'guards': refusals(source, fixture(*fixtures[0])[0]),
              'source_sha256': source['source_sha256'], 'seconds': time.perf_counter()-before,
              'scope': 'Program composition, two source-derived memory presentations and port placements. Full branch semantics, not QPU accuracy or arbitrary live cloud handoff.',
              'new_QPU_jobs': 0}
    OUT.mkdir(exist_ok=True)
    (OUT/'audit.json').write_text(json.dumps(result, indent=2)+'\n')
    print(json.dumps(result, indent=2))
    return result


if __name__ == '__main__':
    run()
