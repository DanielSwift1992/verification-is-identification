#!/usr/bin/env python3
"""Current-root acquisition synthesis and independent serialized-gate audit."""
from copy import deepcopy
from itertools import product
import io
import json
from pathlib import Path
import sys
import time
import numpy as np
from qiskit import qpy
from qiskit.quantum_info import Operator
from qiskit_aer import AerSimulator
import acquisition_future_synthesis as s

OUT = s.source_reader.ROOT / 'Research/Artifacts/acquisition-future-synthesis-20260916'


def lift(local, wires, width):
    result = np.zeros((2**width, 2**width), complex)
    for col in range(2**width):
        j = sum(((col >> wire)&1) << i for i, wire in enumerate(wires))
        base = col & ~sum(1 << wire for wire in wires)
        for i in range(2**len(wires)):
            row = base | sum(((i >> bit)&1) << wire for bit, wire in enumerate(wires))
            result[row, col] = local[i, j]
    return result


def read_gate_instrument(q):
    """Does not read the proposed contact word, source tables or decoder."""
    width = q.num_qubits; size = 2**(width-1); probe = width-1
    start = np.zeros((2*size, size), complex); start[:size] = np.eye(size)
    rows = [(start, [0]*q.num_clbits)]
    def visit(body, active, wires, cbits):
        for ins in body.data:
            op = ins.operation
            qs = [wires[body.find_bit(q).index] for q in ins.qubits]
            cs = [cbits[body.find_bit(c).index] for c in ins.clbits]
            if op.name == 'if_else':
                bit, wanted = op.condition; index = cbits[body.find_bit(bit).index]
                after = []
                for k, bits in active:
                    branch = 0 if bits[index] == wanted else 1
                    after += visit(op.blocks[branch], [(k, bits)], qs, cs) if branch < len(op.blocks) else [(k, bits)]
                active = after
            elif op.name == 'measure':
                assert qs == [probe], 'Acquisition read a retained source wire'
                after = []
                for k, bits in active:
                    for bit in (0, 1):
                        p = np.diag([int(((i >> probe)&1) == bit) for i in range(2*size)])
                        copied = list(bits); copied[cs[0]] = bit
                        after.append((p @ k, copied))
                active = after
            else:
                assert op.name in ('cx', 'x')
                u = lift(Operator(op).data, qs, width)
                active = [(u @ k, bits) for k, bits in active]
        return active
    rows = visit(q, rows, list(range(width)), list(range(q.num_clbits)))
    assert all(not np.any(k[size:]) for k, _ in rows)
    result = {tuple(bits): k[:size] for k, bits in rows}
    assert len(result) == len(rows)
    return result


def future_witnesses(query, size):
    vocabulary = s.paulis(size.bit_length()-1)
    for label, witness in query['closure']['basis'].items():
        actual = vocabulary[witness['terminal']]
        for name in reversed(witness['word']): actual = s.dual(query['future_gates'][name], actual)
        assert s.equal(actual, witness['sign'] * vocabulary[label])


def run():
    started = time.perf_counter(); source = s.source_reader.read_source(); spec = s.interface(source)
    n = spec['size']; vocabulary = s.paulis(n.bit_length()-1)
    control = [row['Control'] for row in source['rows']]
    assert np.array_equal(np.diag((np.eye(n)-vocabulary['IZI'])/2), [r['ProbeB'] for r in source['rows']])
    h_b = {'numerator': s.code(vocabulary['IXI'] + vocabulary['IZI']), 'norm_squared': 2}
    s_b = {'numerator': s.code(np.diag([1j if (j >> 1)&1 else 1 for j in range(n)])), 'norm_squared': 1}
    questions = {
        'answer_only': s.request(spec, control, ['III']),
        'B_Z_now': s.request(spec, control, ['IZI']),
        'B_X_now': s.request(spec, control, ['IXI']),
        'B_Z_after_allowed_H': s.request(spec, control, ['IZI'], {'H_B': h_b}),
        'B_Z_after_H_S_words': s.request(spec, control, ['IZI'], {'H_B': h_b, 'S_B': s_b}),
        'full_source_after_reading': s.request(spec, control, list(vocabulary)),
        'another_question_B': s.request(spec, [r['ProbeB'] for r in source['rows']], list(vocabulary)),
        'another_question_parity': s.request(spec, [r['ProbeParity'] for r in source['rows']], list(vocabulary)),
        'constant_answer': s.request(spec, [0]*n, list(vocabulary)),
        'unread_residue': s.request(spec, [r['Residue'] for r in source['rows']], ['III'])}
    searches = {}; original_admission = {}; circuits = []; operator_checks = 0
    for name, query in questions.items():
        future_witnesses(query, n)
        old = s.propose(spec, query, ['ProbeB', 'ProbeParity'], [True, True])
        original_admission[name] = old
        result = s.synthesize(spec, query, max_contacts=2); searches[name] = result
        if result['kind'] == 'found':
            plan = result['plan']; s.verify(spec, query, plan)
            q = s.compile_plan(source, spec, query, plan)
            buf = io.BytesIO(); qpy.dump(q, buf); buf.seek(0); restored, = qpy.load(buf)
            actual = read_gate_instrument(restored)
            expected = s.instrument(spec, plan['word'], plan['read_after'])
            assert actual.keys() == expected.keys()
            assert all(s.equal(actual[r], expected[r]) for r in actual)
            for bits, k in actual.items():
                if np.any(k):
                    a = s.decode_record(spec, query, plan, sum(bit << i for i, bit in enumerate(bits)))
                    assert s.equal(k @ s.projectors(query['values'])[a], k)
            operator_checks += len(actual); circuits.append(restored)
    assert all(original_admission[k]['derived']['admitted'] for k in ('answer_only', 'B_Z_now'))
    assert all(not original_admission[k]['derived']['admitted'] for k in
               ('B_X_now', 'B_Z_after_allowed_H', 'B_Z_after_H_S_words', 'full_source_after_reading'))
    assert original_admission['B_Z_after_allowed_H']['derived']['continuation']['word'] == ['H_B']
    assert [len(questions[k]['closure']['basis']) for k in ('B_Z_now', 'B_Z_after_allowed_H', 'B_Z_after_H_S_words')] == [2, 3, 4]
    assert all(searches[k]['plan']['read_after'] == [False, True] for k in
               ('answer_only', 'B_X_now', 'B_Z_after_allowed_H', 'full_source_after_reading'))
    assert searches['another_question_B']['plan']['word'] == ['ProbeB']
    assert searches['another_question_parity']['plan']['word'] == ['ProbeParity']
    assert searches['constant_answer']['plan']['word'] == []
    assert searches['unread_residue']['kind'] == 'not_found_within_bound'

    # Match the synthesized all-source instrument to the already frozen native
    # hardware candidate, on C=1 after undoing its specified data unitary.
    # This does not use observed counts or assert current physical correctness.
    sys.path.insert(0, str(s.source_reader.ROOT/'Checks/IBMBridge'))
    import relative_acquisition as native
    q_native, final = native.core()
    h = native.old.HGate().to_matrix(); phase = native.old.SGate().to_matrix()
    undo = native.old.expand((h @ (h @ phase @ h)).conj().T, [2], 4)
    chosen = searches['full_source_after_reading']['plan']
    selected = s.instrument(spec, chosen['word'], chosen['read_after'])
    native_residual = 0.
    for k, (c, a) in native.rows(q_native, final):
        if not c: continue
        actual = undo @ k[16:, 16:]
        target = native.old.expand(selected[(a,)], [3, 1, 0], 4)
        scalar = np.vdot(target, actual)/np.vdot(target, target)
        native_residual = max(native_residual, float(np.max(abs(actual-scalar*target))), float(abs(abs(scalar)-1)))
    assert native_residual < 1e-12

    classical = s.interface(source, coherent=False)
    classical_q = s.request(classical, control, ['IXI'])
    missing = s.synthesize(classical, classical_q, max_contacts=2)
    assert missing['kind'] == 'not_found_within_bound'
    classical_answer = s.synthesize(classical, s.request(classical, control, ['III']), max_contacts=2)
    assert classical_answer['plan']['read_after'] == [True, True]

    # The raw integer read by a working decoder has IBM/Qiskit little-endian
    # register semantics; the displayed string order is not the trace order.
    b_only = s.request(spec, [r['ProbeB'] for r in source['rows']], ['III'])
    b_old = s.propose(spec, b_only, ['ProbeB', 'ProbeParity'], [True, True])
    b_circuit = s.compile_plan(source, spec, b_only, b_old)
    from qiskit import QuantumCircuit
    working_shots = 0
    for label in range(n):
        prepared = QuantumCircuit(4)
        for bit in range(3):
            if (label >> bit)&1: prepared.x(bit)
        for reg in b_circuit.cregs: prepared.add_register(reg)
        prepared.compose(b_circuit, inplace=True)
        result = AerSimulator(max_parallel_threads=1).run(prepared, shots=8, memory=True,
                                                         seed_simulator=91680+label).result()
        assert result.success
        for raw in result.get_memory():
            actual_answer = s.decode_record(spec, b_only, b_old, int(raw.replace(' ', ''), 2))
            assert actual_answer == source['rows'][label]['ProbeB']
            working_shots += 1

    # A concrete future distinction, independently evaluated as a probability.
    p = np.zeros(n, complex); p[0] = p[2] = 1/np.sqrt(2)
    rho = np.outer(p, p.conj())
    old_maps = s.instrument(spec, ['ProbeB', 'ProbeParity'], [True, True])
    new_maps = s.instrument(spec, ['ProbeB', 'ProbeParity'], [False, True])
    event = (np.eye(n)+vocabulary['IXI'])/2
    probabilities = [float(np.trace(event @ sum(k @ rho @ k.conj().T for k in maps.values())).real)
                     for maps in (old_maps, new_maps)]
    assert np.max(abs(np.array(probabilities)-[.5, 1])) < 1e-12

    refused = []
    def reject(name, action):
        try: action()
        except (ValueError, AssertionError): refused.append(name); return
        raise AssertionError('Accepted '+name)
    query = questions['B_X_now']; plan = searches['B_X_now']['plan']
    bad = deepcopy(plan); bad['read_after'][0] = True
    reject('same answer but destructive early measurement', lambda: s.verify(spec, query, bad))
    bad = deepcopy(plan); bad['derived']['decoder']['0'] = 1
    reject('invented decoded answer', lambda: s.verify(spec, query, bad))
    reject('changed promised future', lambda: s.verify(spec, questions['B_Z_now'], plan))
    bad_q = deepcopy(questions['B_Z_after_allowed_H']); bad_q['closure']['basis'].pop('IXI')
    reject('omitted pulled-back direction', lambda: s.validate_request(spec, bad_q))
    reject('coherent word without coherent access', lambda: s.propose(classical, classical_q, plan['word'], [False, True]))
    fake = deepcopy(spec); fake['contacts']['ProbeB'] = control
    fake['id'] = s.fingerprint({k: v for k, v in fake.items() if k != 'id'})
    fake_q = s.request(fake, control, ['III']); fake_plan = s.synthesize(fake, fake_q)['plan']
    reject('self-consistent fake source contact', lambda: s.compile_plan(source, fake, fake_q, fake_plan))
    bad = deepcopy(plan); bad['word'][0] = 'unavailable'
    reject('unavailable contact', lambda: s.verify(spec, query, bad))
    reject('wrong acquired register width', lambda: s.decode_record(spec, query, plan, 4))

    OUT.mkdir(parents=True, exist_ok=True)
    with (OUT/'synthesized.qpy').open('wb') as f: qpy.dump(circuits, f)
    result = {'schema': 'vi.acquisition-future-synthesis-audit.v1', 'source': source, 'interface': spec,
              'questions': questions, 'searches': searches, 'old_process_admission': original_admission,
              'classical_only_B_X': missing, 'classical_only_answer': classical_answer,
              'B_Xplus_probabilities_old_new': probabilities, 'rejected_mutations': refused,
              'serialized_circuits': len(circuits), 'full_branch_maps_compared': operator_checks,
              'working_decoder_Aer_shots': working_shots,
              'frozen_native_active_request_residual_up_to_branch_phase': native_residual,
              'input_dimension': n, 'SDK_instrument_residual': 0,
              'seconds': time.perf_counter()-started, 'new_QPU_jobs': 0,
              'scope': 'Declared phase-free finite contact model bound to the current Swift source. '
                       'All-input operator identities and finite future closure; bounded fixed-word search. '
                       'Not physical acquisition of the contact law, not a general Swift theorem or hardware confirmation.'}
    (OUT/'audit.json').write_text(json.dumps(result, indent=2)+'\n')
    return {k: result[k] for k in ('serialized_circuits', 'full_branch_maps_compared', 'working_decoder_Aer_shots', 'rejected_mutations',
                                  'B_Xplus_probabilities_old_new', 'seconds', 'new_QPU_jobs')}


if __name__ == '__main__': print(json.dumps(run(), indent=2))
