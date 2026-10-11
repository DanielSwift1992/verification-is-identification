#!/usr/bin/env python3
"""Six source-bound diagnostic drafts; no account, submission or time claim.

Two preparations and three surrounding programs. Matching the explicit
padding is NOT a certificate of equal physical age across dynamic blocks.
The question is a context contrast, not full preparation/readout tomography.
"""
import argparse
from collections import defaultdict
from copy import deepcopy
from fractions import Fraction as F
import json
import io
import math
from pathlib import Path
import time

from qiskit import QuantumCircuit, ClassicalRegister, qpy
from qiskit.circuit import Duration, Instruction
from qiskit.circuit.classical import expr
from qiskit_ibm_runtime.circuit import MidCircuitMeasure

import resident_feedback as f
import resident_wire_audit as w

CONTEXTS = ('idle', 'measure_D', 'measure_D_then_control_P')
WIRES = [23, 16, 3]


def ns_delay(body, amount, wire):
    # In installed Qiskit 2.5.2 the numeric Delay(..., unit='ns') path
    # loses its unit through QPY. A typed literal carries the unit itself.
    body.delay(expr.lift(Duration.ns(amount)), wire)


def zero_time_projection(body, path=(), durations=None):
    """Forget time ONLY for the independently calculated ideal quantum map.

    The original time literals remain mandatory in admission's separate
    inventory and in circuit equality. This is not a noise/timing model.
    """
    if durations is None:
        durations = []
    result = body.copy_empty_like()
    for i, item in enumerate(body.data):
        op = item.operation
        if op.name == 'delay':
            if op.unit != 'expr' or not isinstance(op.duration, expr.Value):
                raise ValueError('Draft delay must have an explicit typed duration')
            value = op.duration.value
            if value.unit() != 'ns':
                raise ValueError('Draft delay changed physical units')
            durations.append({'path': list(path+(i,)), 'unit': value.unit(), 'value': value.value()})
            result.delay(0, item.qubits[0], unit='dt')
        elif getattr(op, 'blocks', ()):
            blocks = [zero_time_projection(b, path+(i,j), durations)[0] for j,b in enumerate(op.blocks)]
            result.append(op.replace_blocks(blocks), item.qubits, item.clbits)
        else:
            result.append(item)
    return result, durations


def measurement_ABI_form(body):
    """QPY restores MidCircuitMeasure as its ordinary named instruction.

    Normalize only that documented extension instruction, retaining ports,
    labels, empty parameters and absent definition. Other operations retain
    SDK equality, including typed time literals and branch conditions.
    """
    result = body.copy_empty_like()
    for item in body.data:
        op = item.operation
        if op.name == 'measure_2':
            if (type(op) not in (Instruction, MidCircuitMeasure) or op.num_qubits != 1 or
                    op.num_clbits != 1 or op.params or op.definition is not None):
                raise ValueError('Unsupported mid-measurement representation')
            result.append(Instruction('measure_2', 1, 1, [], label=op.label), item.qubits, item.clbits)
        elif getattr(op, 'blocks', ()):
            result.append(op.replace_blocks([measurement_ABI_form(b) for b in op.blocks]), item.qubits, item.clbits)
        else:
            result.append(item)
    return result


def delay_roundtrip_check(output):
    rows = []
    for n, unit in [(32, 'dt'), (32, 'ns'), (2000, 'ns'), (.032, 'us')]:
        q = QuantumCircuit(1)
        q.delay(n, 0, unit=unit)
        buf = io.BytesIO()
        qpy.dump(q, buf)
        row = {'input': {'duration': n, 'unit': unit}}
        try:
            buf.seek(0)
            loaded, = qpy.load(buf)
            row.update(restored={'duration': loaded.data[0].operation.duration, 'unit': loaded.data[0].operation.unit},
                       equal=q == loaded)
        except Exception as error:
            row.update(load_error=type(error).__name__+': '+str(error), equal=False)
        rows.append(row)
        if unit == 'ns' and n == 2000:
            (output/'untyped-2000ns-unsafe.qpy').write_bytes(buf.getvalue())
    typed = QuantumCircuit(1)
    ns_delay(typed, 2000, 0)
    buf = io.BytesIO()
    qpy.dump(typed, buf)
    (output/'typed-2000ns.qpy').write_bytes(buf.getvalue())
    buf.seek(0)
    restored, = qpy.load(buf)
    assert typed == restored
    return {'numeric_delay_trials': rows, 'typed_2000ns_survives_QPY': True,
            'scope': 'Serialization test only. dt has no assigned physical duration here.'}


def expected(source, prepared, context):
    result = {format(i, '04b'): 0. for i in range(16)}
    for b in (0, 1):
        action = 'Toggle'+str(b if context == CONTEXTS[2] else 0)
        p, c = f.source_adapter.control_table(source, action)[0, prepared]
        result[f'{p}{c}{b}{b}'] += .5
    return result


def circuit(source, prepared, context, padding_ns, snapshot):
    if prepared not in (0, 1) or context not in CONTEXTS:
        raise ValueError('Unsupported diagnostic question')
    if type(padding_ns) is not int or padding_ns < 0:
        raise ValueError('Nominal padding must be a nonnegative integer in ns')
    x_ns = round(snapshot['x:16']['duration_seconds']*1e9)
    m_ns = round(snapshot['measure_2:23']['duration_seconds']*1e9)
    p_ns = round(snapshot['x:3']['duration_seconds']*1e9)
    out = ClassicalRegister(4, 'out')
    logical = QuantumCircuit(3)
    logical.add_register(out)
    for q in range(3):
        logical.reset(q)
    # H_D up to a global phase, expressed in the old snapshot's gate alphabet.
    logical.rz(math.pi/2, 0)
    logical.sx(0)
    logical.rz(math.pi/2, 0)
    if prepared:
        logical.x(1)
    else:
        ns_delay(logical, x_ns, 1)
    logical.barrier()
    ns_delay(logical, padding_ns, 1)
    if context == CONTEXTS[0]:
        ns_delay(logical, m_ns, 0)
        ns_delay(logical, p_ns, 2)
    else:
        logical.append(MidCircuitMeasure(), [0], [out[0]])
        if context == CONTEXTS[2]:
            with logical.if_test((out[0], 1)) as otherwise:
                logical.x(2)
            with otherwise:
                ns_delay(logical, p_ns, 2)
        else:
            ns_delay(logical, p_ns, 2)
    logical.barrier()
    # The endpoint of the question comes BEFORE the terminal D/P reads.
    logical.measure(1, out[2])
    logical.barrier()
    if context == CONTEXTS[0]:
        logical.measure(0, out[0])
    logical.measure(0, out[1])
    logical.measure(2, out[3])
    # Explicit physical address view, not a compiled 156-qubit backend ISA.
    result = QuantumCircuit(24)
    result.add_register(out)
    result.compose(logical, qubits=WIRES, clbits=list(out), inplace=True)
    result.metadata = {
        'schema': 'vi.C-context-draft.v1', 'prepared_C': prepared, 'context': context,
        'source_sha256': source['source_sha256'], 'physical_D_C_P': WIRES,
        'nominal_padding_ns': padding_ns, 'historical_durations_ns': {'C_X': x_ns, 'D_measure_2': m_ns, 'P_X': p_ns},
        'register_order': 'P C D b',
        'b_occurrence': 'after_C_readout' if context == CONTEXTS[0] else 'before_C_readout',
        'question': 'C result by nominal preparation and complete surrounding program',
        'equal_physical_age_established': False, 'submission_ready': False,
        'scope': 'Source-bound physical-address draft. Not current-backend ISA, pulse schedule, calibrated preparation, or hardware observation.'}
    return result


def validate(source, candidate, snapshot):
    m = candidate.metadata
    expected_body = circuit(source, m['prepared_C'], m['context'], m['nominal_padding_ns'], snapshot)
    projection, durations = zero_time_projection(candidate)
    wanted_projection, wanted_durations = zero_time_projection(expected_body)
    if (candidate.metadata != expected_body.metadata or measurement_ABI_form(candidate) != measurement_ABI_form(expected_body) or
            durations != wanted_durations or f.signature(projection) != f.signature(wanted_projection)):
        raise ValueError('The actual diagnostic body or its question changed')
    ops = w.flatten(projection)
    reads = [(i, op) for i, op in enumerate(ops) if op['name'] in ('measure', 'measure_2')]
    c_reads = [(i, op) for i, op in reads if op['qubits'] == [16]]
    assert len(c_reads) == 1
    i, c_read = c_reads[0]
    assert c_read['clbits'] == [2] and not c_read['conditions']
    before = [op for k, op in reads if k < i]
    assert len(before) == (0 if m['context'] == CONTEXTS[0] else 1)
    if before:
        assert before[0]['name'] == 'measure_2' and before[0]['qubits'] == [23]
    assert all(op['qubits'] == [3] for op in ops if op['conditions'])
    assert not any(op['name'] in ('cz', 'cx', 'store') for op in ops)
    ideal, traces = w.diagnostic_ideal(projection)
    want = expected(source, m['prepared_C'], m['context'])
    error = max(abs(ideal[k]-want[k]) for k in want)
    assert error < 1e-12 and all(t['ideal_C'] == m['prepared_C'] for t in traces)
    return {'prepared_C': m['prepared_C'], 'context': m['context'],
            'ideal_probabilities': ideal, 'independent_ideal_residual': error,
            'explicit_measurements_before_C': before,
            'typed_durations': durations, 'register_routes': w.route(projection)}


def final_flip_nonidentifiability():
    # Two valid diagonal qubit preparations/readout effects, same exact
    # observations even after a known perfect X before each final readout.
    # No numerical fitting or noisy hardware data enter this witness.
    original = [(F(1,5), F(4,5)), (F(1,4), F(3,4)), (F(2,5), F(3,5))]
    shifted = [tuple(F(1,2)+F(5,6)*(r-F(1,2)) for r in pair) for pair in original]
    effects = [(F(2,5), F(9,10)), (F(7,20), F(19,20))]
    rows = []
    for e, context in enumerate(CONTEXTS):
        for s in (0, 1):
            for flip in (0, 1):
                ps = []
                for state, (m0, m1) in zip([original[e][s], shifted[e][s]], effects):
                    r = 1-state if flip else state
                    assert 0 <= r <= 1 and 0 <= m0 <= m1 <= 1
                    ps.append(m0*(1-r)+m1*r)
                assert ps[0] == ps[1]
                rows.append({'context': context, 'preparation': s, 'final_X': flip, 'both_P_one': str(ps[0])})
    assert original != shifted and effects[0] != effects[1]
    return {'rows': rows, 'readout_diagonals': [[str(v) for v in p] for p in effects],
            'prepared_P_one': [[[str(v) for v in p] for p in model] for model in [original, shifted]],
            'scope': 'Exact counterexample to separating preparation from readout using these 12 probabilities, even with known final X and context-independent readout in each model. Not a fit to IBM data.'}


def observed_review_check():
    root = f.ROOT
    prior = w.read(root/'Research/Artifacts/resident-wire-audit-20260915/audit.json')
    assert all(w.digest(root/n) == h for n, h in prior['original_packet_sha256'].items())
    folder = root/'private/ibm-resident-boundary-20260915'
    with (folder/'isa.qpy').open('rb') as stream:
        circuits = qpy.load(stream)
    arrays = w.raw_arrays(folder/'raw-result.json')
    groups = defaultdict(lambda: {'shots': 0, 'C_one': 0})
    for body, array in zip(circuits, arrays):
        assert body.metadata == array['metadata']
        names = tuple(op['name'] for op in w.flatten(body) if 16 in op['qubits'] and op['name'] != 'barrier')
        groups[names]['shots'] += len(array['ints'])
        groups[names]['C_one'] += sum((v >> 2) & 1 for v in array['ints'])
    assert groups[('reset','measure')] == {'shots': 2048, 'C_one': 1538}
    assert groups[('reset','x','reset','measure')] == {'shots': 2048, 'C_one': 1410}
    assert groups[('reset','x','measure')] == {'shots': 12288, 'C_one': 10202}
    plan = w.read(folder/'plan.json')
    assert plan['target_snapshot']['reset:16']['error'] is None
    return {'groups': [{'C_operations': list(k), **v} for k, v in groups.items()],
            'reset_error': None, 'reset_error_known': False,
            'reset_error_was_not_converted_to_zero_in_saved_packet': True,
            'original_files_verified': len(prior['original_packet_sha256'])}


def prepare(output):
    start = time.perf_counter()
    output.mkdir(parents=True, exist_ok=False)
    source = f.current_source()
    delay_probe = delay_roundtrip_check(output)
    snapshot = f.read(f.ROOT/'private/ibm-resident-boundary-20260915/plan.json')['target_snapshot']
    bodies = [circuit(source, s, e, 2000, snapshot) for s in (0,1) for e in CONTEXTS]
    checks = [validate(source, body, snapshot) for body in bodies]
    with (output/'six-context-drafts.qpy').open('wb') as stream:
        qpy.dump(bodies, stream)
    with (output/'six-context-drafts.qpy').open('rb') as stream:
        restored = qpy.load(stream)
    for body in restored:
        validate(source, body, snapshot)
    refusals = []
    def no(name, body):
        try:
            validate(source, body, snapshot)
        except (ValueError, AssertionError):
            refusals.append(name)
            return
        raise AssertionError('Accepted '+name)
    bad = bodies[0].copy()
    bad.metadata = deepcopy(bad.metadata)
    bad.metadata['equal_physical_age_established'] = True
    no('nominal equal delay relabelled as physical timing certificate', bad)
    bad = bodies[0].copy()
    bad.metadata = deepcopy(bad.metadata)
    bad.metadata['submission_ready'] = True
    no('uncompiled historical-target draft relabelled as hardware ready', bad)
    bad = bodies[1].copy()
    bad.x(16)
    no('extra C action under unchanged diagnostic question', bad)
    bad = bodies[0].copy_empty_like()
    for item in bodies[0].data:
        if item.operation.name == 'delay':
            bad.delay(int(item.operation.duration.value.value()), item.qubits[0], unit='dt')
        else:
            bad.append(item)
    no('same numeric durations but different units', bad)
    bad = bodies[1].copy_empty_like()
    for item in bodies[1].data:
        if item.operation.name == 'measure_2':
            fake = Instruction('measure_2', 1, 1, [])
            fake.definition = QuantumCircuit(1, 1)
            fake.definition.x(0)
            bad.append(fake, item.qubits, item.clbits)
        else:
            bad.append(item)
    no('different operation hidden behind the measure_2 name', bad)
    result = {'schema': 'vi.context-design-audit.v1', 'ideal_checks': checks,
              'delay_serialization': delay_probe,
              'review_counts': observed_review_check(), 'final_flip_boundary': final_flip_nonidentifiability(),
              'refusals': refusals, 'source_sha256': source['source_sha256'],
              'QPY_sha256': w.digest(output/'six-context-drafts.qpy'),
              'historical_snapshot': snapshot, 'new_QPU_jobs': 0, 'new_calibrations': 0,
              'implementation_sha256': w.digest(Path(__file__)), 'seconds': time.perf_counter()-start,
              'remaining': ['Current backend compilation and layout validation',
                            'Timing basis for intended contrasts, including control-block latency',
                            'Freeze trial order, shot budget, interpretation and statistical endpoint before hardware results'],
              'scope': 'Offline diagnostic design and a finite identifiability boundary; no new hardware observation or full repository regression.'}
    w.write(output/'audit.json', result)
    return result


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    result = prepare(parser.parse_args().output.resolve())
    print(json.dumps({'circuits':len(result['ideal_checks']), 'max_ideal_residual':max(x['independent_ideal_residual'] for x in result['ideal_checks']),
                      'refusals':result['refusals'], 'seconds':result['seconds']},indent=2))
