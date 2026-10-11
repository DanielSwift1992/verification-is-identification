#!/usr/bin/env python3
"""Verify Store elimination against actual circuits, not intended recipe names."""
from dataclasses import replace
import hashlib
import io
import itertools
import json
from pathlib import Path
import time

import numpy as np
from qiskit import QuantumCircuit, ClassicalRegister, qpy
from qiskit.circuit.classical import expr
from qiskit_aer import AerSimulator
from qiskit_aer.library import save_density_matrix

import resident_record_lowering as lowering
import resident_boundary_composition as c
import resident_reusable_ability as reuse
import resident_future_boundary as future
from resident_boundary_composition_checks import question, canonical, branch_audit
from resident_boundary_symbolic import read_words, audit as symbolic_source
from resident_goal_instrument_audit import interpret
from resident_raw_reply_checks import fixture

OUT = c.s.ROOT/'Research/Artifacts/resident-record-lowering-20260916'


def event_key(row):
    return tuple((e['kind'], e.get('reply', e.get('bit'))) for e in row['events'])


def compare(source, product, ports, service):
    original = {tuple(row['events']): row for row in read_words(source, ports, service)}
    target = read_words(product.circuit, ports, service)
    assert len(target) == len(original)
    reverse_fibers = {}
    for row in target:
        before = original[tuple(row['events'])]
        assert row['word'] == before['word']
        assert product.decode(row['bits']) == before['bits']
        reverse_fibers.setdefault(tuple(before['bits']), set()).add(tuple(row['bits']))
    ambiguous = [(old, sorted(new)) for old, new in reverse_fibers.items() if len(new) > 1]
    # The reverse factor is a construction if it exists, or two concrete
    # histories refuting it. No separate trusted/unsupported device flag.
    exposure = {'old_classical_outputs':len(reverse_fibers),
                'new_classical_outputs':len({tuple(row['bits']) for row in target}),
                'maximum_new_records_per_old_record':max(map(len, reverse_fibers.values())),
                'new_record_factors_through_old':not ambiguous,
                'reverse_reading': [{'old':list(old), 'new':list(next(iter(new)))}
                                    for old,new in reverse_fibers.items()] if not ambiguous else None,
                'counterexample':{'old':list(ambiguous[0][0]),
                                  'new_a':list(ambiguous[0][1][0]),
                                  'new_b':list(ambiguous[0][1][1])} if ambiguous else None}
    old = {event_key(b): b for b in interpret(canonical(source, ports))}
    new = interpret(canonical(product.circuit, ports))
    assert len(new) == len(old)
    error = 0.
    for branch in new:
        expected = old[event_key(branch)]
        error = max(error, float(np.max(abs(branch['map']-expected['map']))))
        assert product.decode(branch['bits']) == expected['bits']
    assert error < 1e-11
    return {'formal_branches': len(target), 'literal_instrument_words_equal': True,
            'all_original_classical_fields_recovered': True,
            'classical_output_scope':exposure,
            'full_operator_residual': error}, new


def execute(product, ports, branches, shots=32):
    q = product.circuit.copy()
    save_density_matrix(q, list(ports[1:]), label='retained', pershot=True)
    exact = {tuple(b['bits']): b for b in branches}
    assert len(exact) == len(branches)
    result = AerSimulator(method='statevector', max_parallel_threads=1).run(
        q, shots=shots, memory=True, seed_simulator=916203).result()
    assert result.success
    worst = 0.
    for memory, matrix in zip(result.get_memory(), result.data()['retained']):
        number = int(memory.replace(' ', ''), 2)
        bits = tuple((number >> i) & 1 for i in range(q.num_clbits))
        assert bits in exact
        v = exact[bits]['map'][::2, 0]
        expected = np.outer(v, v.conj())/np.vdot(v, v).real
        worst = max(worst, float(np.max(abs(matrix.data-expected))))
    assert worst < 1e-11
    return {'shots': shots, 'retained_state_residual': worst}


def extra_history(product, ports, service, memory_name):
    groups = {}
    for row in read_words(product.circuit, ports, service):
        first = next(bit for kind, bit in row['events'] if kind == 'contact')
        assert row['bits'][0] == first
        code = product.register(memory_name, row['bits'])
        groups.setdefault(code, {}).setdefault(first, row['bits'])
    witnesses = [{'same_Last_code': code, 'first_zero_record': rows[0], 'first_one_record': rows[1]}
                 for code, rows in sorted(groups.items()) if set(rows) == {0,1}]
    assert witnesses
    return {'First_is_still_readable_from_physical_record_zero': True,
            'same_interface_different_retained_history': witnesses,
            'not_physical_erasure_and_not_equivalence_for_unrestricted_future_readings': True}


def rewrite_hazards():
    """An if writes its own condition; a later measurement overwrites a source.

    Both old and new values must remain distinct. Include the else arm and
    conditional measurement, so static substitution cannot read an absent bit.
    """
    cases = []
    for x, y in itertools.product((0, 1), repeat=2):
        q = QuantumCircuit(3)
        source = ClassicalRegister(2, 'source')
        saved = ClassicalRegister(2, 'saved')
        answer = ClassicalRegister(1, 'answer')
        q.add_register(source, saved, answer)
        if x: q.x(0)
        if y: q.x(1)
        q.measure([0, 1], source)
        q.store(saved, source)
        with q.if_test((source[0], 1)) as otherwise:
            q.store(source[0], False)
            q.x(2)
            q.measure(1, source[1])
        with otherwise:
            q.store(source[0], True)
        q.reset(0)
        q.measure(0, source[0])
        with q.if_test((saved[0], 1)): q.x(2)
        q.measure(2, answer[0])
        product = lowering.lower(q)
        result = AerSimulator().run(product.circuit, shots=16, memory=True).result()
        assert result.success
        for memory in result.get_memory():
            number = int(memory.replace(' ', ''), 2)
            bits = [(number >> i) & 1 for i in range(product.circuit.num_clbits)]
            assert product.register('source', bits) == 2*y
            assert product.register('saved', bits) == x+2*y
            assert product.register('answer', bits) == 0
        cases.append([x, y])
    return cases


def refusals():
    cases = []
    def reject(name, q, **kwargs):
        try: lowering.lower(q, **kwargs)
        except ValueError: cases.append(name)
        else: raise AssertionError('Accepted '+name)
    q = QuantumCircuit(1, 1); q.global_phase = .2
    reject('unrepresented block phase', q)
    q = QuantumCircuit(1, 1); q.delay(8, 0)
    reject('unknown timing instruction', q)
    q = QuantumCircuit(1, 1); q.measure(0, 0); q.measure(0, 0)
    reject('record storage budget exceeded', q, max_records=1)
    q = QuantumCircuit(1); reg = ClassicalRegister(2, 'r'); q.add_register(reg)
    q.store(reg, expr.add(reg, 1))
    reject('unadmitted arithmetic', q)
    q = QuantumCircuit(1); q.add_var('external', expr.lift(False))
    reject('non-register variable', q)
    return cases


def run():
    began = time.perf_counter()
    source = c.s.reading()
    cases = []
    OUT.mkdir(exist_ok=True)
    for theta, phi in [(1.3, -.8), (1.45, .91)]:
        service, ks, _ = fixture(theta, phi)
        for presentation, ports in [('direct', (0,1,2,3,4)), ('turned', (2,4,0,1,3))]:
            for mode in ('mixed', 'last'):
                assembly = c.Assembly(source, service)
                cut = assembly.prepare_first(presentation=presentation, ports=ports)
                if mode == 'mixed':
                    queries = [question(source, [254,239], recipient=[0,0,0,1]),
                               question(source, [204], 'entry'), question(source, [170])]
                    for query in queries: cut = assembly.extend(cut, c.recipe(source, cut.contract, query))
                else:
                    query = question(source, [170]); queries = [query]*4
                    wanted = future.derive(source, query['questions'])['boundary']
                    for query in queries:
                        cut = reuse.apply(assembly, cut, reuse.discover(source, cut.contract, query, wanted))
                original = assembly.program(cut)
                symbolic_source(assembly, cut, queries)
                branch_audit(source, original, ports, ks, queries, 3, cut)
                product = lowering.lower(original)
                # The actual serialized program is checked again, not just an
                # in-memory AST prior to the SDK representation boundary.
                buffer = io.BytesIO(); qpy.dump(product.circuit, buffer)
                payload = buffer.getvalue(); buffer.seek(0)
                restored, = qpy.load(buffer)
                product = replace(product, circuit=restored)
                checked, branches = compare(original, product, ports, assembly._service)
                checked.update(fixture=[theta,phi], presentation=presentation, mode=mode,
                               source_classical_bits=original.num_clbits,
                               immutable_record_bits=restored.num_clbits,
                               stores_removed=product.stores_removed,
                               boolean_nodes=len(product.readings.nodes),
                               local_execution=execute(product, ports, branches),
                               QPY_sha256=hashlib.sha256(payload).hexdigest())
                if mode == 'last':
                    checked['extra_history'] = extra_history(product, ports, assembly._service, cut._memory.name)
                name = 'case'+str(len(cases))
                (OUT/(name+'.qpy')).write_bytes(payload)
                (OUT/(name+'-reading.json')).write_text(json.dumps({
                    'nodes':product.readings.nodes, 'outputs':product.outputs,
                    'original_registers':product.original_registers,
                    'QPY_sha256':checked['QPY_sha256']}, indent=2)+'\n')
                cases.append(checked)
    simple = c.Assembly(source, fixture(1.3, -.8)[0])
    simple_cut = simple.prepare_first(contacts=1)
    simple_source = simple.program(simple_cut)
    exact_exposure, _ = compare(simple_source, lowering.lower(simple_source),
                                 simple_cut._ports, simple._service)
    assert exact_exposure['classical_output_scope']['new_record_factors_through_old']
    assert len(exact_exposure['classical_output_scope']['reverse_reading']) == 2
    result = {'schema':'vi.immutable-record-lowering-audit.v1', 'cases':cases,
              'positive_reverse_reading':exact_exposure,
              'rewrite_hazards':rewrite_hazards(), 'refusals':refusals(),
              'seconds':time.perf_counter()-began, 'new_QPU_jobs':0,
              'scope':'Same ideal decoded instrument, retained input and external reference; '
                      'same literal words for every common service substitution. '
                      'Records are retained, not physically erased. IBM acceptance untested.'}
    (OUT/'audit.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))


if __name__ == '__main__': run()
