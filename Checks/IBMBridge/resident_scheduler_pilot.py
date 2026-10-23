#!/usr/bin/env python3
"""One Open-only timing pilot: six frozen drafts and two unchanged old bodies.

No local schedule is promoted to physical timing. prepare is read-only on IBM;
submit is explicit, at most once, and requires active Kingston. collect stores
the full provider result before reading any optional schedule. No main sample.
"""

import sys as _evidence_sys
from pathlib import Path as _EvidencePath
_evidence_sys.path.insert(0, str(_EvidencePath(__file__).resolve().parents[1]))
import hardware_runs as _runs
_runs.configure(required=(__name__ == "__main__"))
import argparse
from copy import deepcopy
import csv
import fcntl
from fractions import Fraction as F
import io
import json
from pathlib import Path
import re
import uuid

from qiskit import QuantumCircuit, qpy
from qiskit.circuit.classical import expr
from qiskit_ibm_runtime import RuntimeEncoder, SamplerV2
from qiskit_ibm_runtime.utils.validations import validate_isa_circuits

import resident_context_design as d
import resident_feedback as f
import resident_wire_audit as w
from pilot import service_open, sha, utc, versions

ROOT = _runs.owned(__file__).resolve().parents[2]
DRAFT = ROOT/'Research/Artifacts/resident-context-design-20260915'
OLD = _runs.path('ibm-resident-boundary-20260915')
SHOTS, MAX_SECONDS = 128, 30
OLD_KEYS = (('Baseline11', 'Z'), ('Toggle00', 'Z'))
HEADER = ['Branch', 'Instruction', 'Channel', 'T0', 'Duration', 'Pulse']


def require(value, message):
    if not value:
        raise ValueError(message)


def dump(path, data):
    path.write_text(json.dumps(_runs.bind_receipt(data, destination=path), indent=2)+'\n')


def timing_options(existing):
    result = deepcopy(existing)
    experimental = result.setdefault('experimental', {})
    execution = experimental.setdefault('execution', {})
    require(isinstance(execution, dict), 'experimental.execution must be a mapping')
    execution['scheduler_timing'] = True
    return result


def options(tag):
    return timing_options({'default_shots': SHOTS, 'max_execution_time': MAX_SECONDS,
        'environment': {'job_tags': [tag]}, 'execution': {'init_qubits': True},
        'twirling': {'enable_gates': False, 'enable_measure': False},
        'dynamical_decoupling': {'enable': False}})


def target_view(backend):
    status = backend.status()
    return {'at': utc(), 'backend': backend.name, 'operational': status.operational,
        'status': status.status_msg, 'pending_jobs': status.pending_jobs,
        'num_qubits': backend.num_qubits, 'dt_seconds': backend.dt,
        'timing_constraints': backend.configuration().timing_constraints}


def exact_ticks(ns, view):
    """This pilot admits exact conversion only; it never relabels a number.

    A general bounded-rounding adapter is not needed by these 17 literals.
    min_length applies to pulses, not automatically to delays. We use the
    stronger granularity/alignment checks here as a conservative pilot scope.
    """
    dt = F(str(view['dt_seconds']))
    require(dt > 0 and F(str(ns)) >= 0, 'Invalid physical duration or clock scale')
    ticks = F(str(ns))*F(1, 10**9)/dt
    require(ticks.denominator == 1, 'Physical duration needs unsupported rounding')
    limits = view['timing_constraints']
    for name in ('granularity', 'pulse_alignment', 'acquire_alignment'):
        multiple = limits.get(name, 1)
        require(type(multiple) is int and multiple > 0, 'Invalid target alignment')
        require(ticks.numerator % multiple == 0, 'Delay violates pilot alignment scope')
    return ticks.numerator


def lower_durations(body, view, path=(), inventory=None):
    if inventory is None:
        inventory = []
    result = body.copy_empty_like()
    for i, item in enumerate(body.data):
        op = item.operation
        if op.name == 'delay':
            require(op.unit == 'expr' and isinstance(op.duration, expr.Value), 'Unbound delay literal')
            v = op.duration.value
            require(v.unit() == 'ns', 'Expected original typed ns draft')
            n = exact_ticks(v.value(), view)
            inventory.append({'path': list(path+(i,)), 'input_ns': v.value(),
                              'output_dt': n, 'dt_seconds': view['dt_seconds'], 'rounding_error_ns': 0})
            result.delay(n, item.qubits[0], unit='dt')
        elif getattr(op, 'blocks', ()):
            result.append(op.replace_blocks([lower_durations(b, view, path+(i,j), inventory)[0]
                for j,b in enumerate(op.blocks)]), item.qubits, item.clbits)
        else:
            result.append(item)
    return result, inventory


def body_signature(c):
    """Existing wire/condition signature plus an ordered physical-time axis."""
    durations = []
    def walk(body, path):
        for i, item in enumerate(body.data):
            op = item.operation
            if op.name == 'delay':
                require(op.unit == 'dt' and type(op.duration) is int and op.duration >= 0,
                        'Submitted pilot duration must be integer dt')
                durations.append({'path': list(path+(i,)), 'unit': op.unit, 'value': op.duration})
            for j,b in enumerate(getattr(op, 'blocks', ())):
                walk(b, path+(i,j))
    walk(c, ())
    # Validate the MCM extension ABI, including the absence of a forged definition.
    d.measurement_ABI_form(c)
    return {'body': f.signature(c), 'durations': durations}


def parse_timing(raw):
    """Strict syntax reading, not a proof of source-to-pulse correspondence."""
    if type(raw) is str:
        lines, representation = raw.splitlines(), 'multiline-string'
    elif type(raw) is list and all(type(x) is str and '\n' not in x and '\r' not in x for x in raw):
        lines, representation = raw, 'list-of-lines'
    else:
        raise ValueError('Unsupported scheduler timing representation')
    rows = []
    for line_no, line in enumerate(lines):
        if not line.strip():
            continue
        fields = [x.strip() for x in next(csv.reader([line], strict=True))]
        if fields == HEADER and not rows and line_no == 0:
            continue
        require(len(fields) == 6 and all(fields), 'Incomplete schedule row')
        require(re.fullmatch(r'\d+', fields[3]) and re.fullmatch(r'\d+', fields[4]),
                'Schedule time must be nonnegative integer cycles')
        branch, instruction, channel, start, duration, pulse = fields
        rows.append({'line': line_no, 'branch': branch, 'instruction': instruction,
            'channel': channel, 'start_dt': int(start), 'duration_dt': int(duration), 'pulse': pulse})
    require(rows, 'Empty scheduler timing')
    return {'representation': representation, 'rows': rows,
            'branches': sorted({r['branch'] for r in rows}),
            'source_to_schedule_correspondence_established': False,
            'equal_C_age_established': False}


def schedule_evidence(metadata, dt):
    try:
        raw = metadata['compilation']['scheduler_timing']['timing']
    except (KeyError, TypeError):
        return {'available': False, 'equal_C_age_established': False}
    result = {'available': True, 'raw': raw, 'provider_dt_seconds': dt,
              'equal_C_age_established': False}
    try:
        result['parsed'] = parse_timing(raw)
        # Preserve all branches/channels. C rows are only a browsing aid, not
        # selected evidence from which an unproved preparation endpoint is inferred.
        result['C_rows'] = [r for r in result['parsed']['rows'] if
            r['channel'] == 'Qubit 16' or r['channel'].startswith('AWGR') and
            r['channel'].endswith('_16')]
    except (ValueError, csv.Error) as error:
        result['parse_error'] = str(error)
    return result


def source_material():
    receipt = w.read(DRAFT/'receipt.json')
    for name,h in receipt['sha256'].items():
        require(sha((ROOT/name).read_bytes()) == h, 'Frozen input changed: '+name)
    source = f.current_source()
    require(sha((OLD/'isa.qpy').read_bytes()) == w.read(OLD/'plan.json')['qpy_sha256'], 'Old ISA changed')
    drafts = qpy.load(io.BytesIO((DRAFT/'six-context-drafts.qpy').read_bytes()))
    old = qpy.load(io.BytesIO((OLD/'isa.qpy').read_bytes()))
    bridges = []
    for key in OLD_KEYS:
        matches = [(i,c) for i,c in enumerate(old) if (c.metadata['variant'], c.metadata['probe']) == key]
        require(len(matches) == 1, 'Missing old bridge')
        bridges.append(matches[0])
    return source, drafts, bridges


@_runs.include_reader
def implementation():
    paths = [_runs.owned(__file__), _runs.owned(d.__file__), _runs.owned(f.__file__), _runs.owned(w.__file__),
             _runs.owned(f.source_adapter.__file__), _runs.owned(f.resident.__file__)]
    return {_runs.address(p, ROOT): sha(p.read_bytes()) for p in paths}


def prepare(directory):
    require(not (directory/'plan.json').exists(), 'Plan already frozen')
    source, drafts, bridges = source_material()
    service = service_open(); backend = service.backend('ibm_kingston')
    view = target_view(backend)
    require(view['num_qubits'] == 156, 'Changed backend size')
    directory.mkdir(parents=True, exist_ok=True)
    isa, cases = [], []
    for draft in drafts:
        md = draft.metadata
        require(md['source_sha256'] == source['source_sha256'], 'Draft belongs to another VI root')
        # The typed draft is already in native gates on explicit physical wires.
        # Padding idle address space requires no optimization or routing.
        lowered, inventory = lower_durations(draft, view)
        circuit = QuantumCircuit(backend.num_qubits)
        for reg in lowered.cregs:
            circuit.add_register(reg)
        circuit.compose(lowered, qubits=list(range(lowered.num_qubits)), clbits=list(circuit.clbits), inplace=True)
        circuit.metadata = deepcopy(md)
        ideal, _ = w.diagnostic_ideal(circuit)
        expected = d.expected(source, md['prepared_C'], md['context'])
        error = max(abs(ideal[k]-expected[k]) for k in expected)
        require(error < 1e-12, 'Lowered body changed the source answer')
        isa.append(circuit)
        cases.append({'kind': 'new-context', 'name': f"{md['context']}:C{md['prepared_C']}",
            'expected_C': md['prepared_C'], 'duration_conversion': inventory,
            'ideal_probabilities': ideal, 'ideal_residual': error})
    for index,circuit in bridges:
        isa.append(circuit)  # Preserve metadata and every old instruction, no transpile.
        ideal,_ = w.diagnostic_ideal(circuit)
        cases.append({'kind': 'unchanged-old-bridge', 'name': ':'.join(
            (circuit.metadata['variant'], circuit.metadata['probe'])), 'old_pub_index': index,
            'old_qpy_sha256': sha((OLD/'isa.qpy').read_bytes()),
            'expected_C': 1 if circuit.metadata['variant'] == 'Baseline11' else 0,
            'duration_conversion': [], 'ideal_probabilities': ideal})
    require(len(isa) == 8, 'Pilot scope expanded')
    validate_isa_circuits(isa, backend.target)
    buf = io.BytesIO(); qpy.dump(isa, buf); data = buf.getvalue()
    restored = qpy.load(io.BytesIO(data))
    for before,after in zip(isa,restored):
        require(d.measurement_ABI_form(before) == d.measurement_ABI_form(after), 'QPY semantic drift')
        require(body_signature(before) == body_signature(after), 'QPY time or wire drift')
    tag = 'vi-context-timing-'+uuid.uuid4().hex
    plan = {'schema': 'vi.ibm.context-timing.v1', 'created_at': utc(), 'tag': tag,
        'backend': backend.name, 'instance': service.active_instance(), 'instance_plan': 'open',
        'shots': SHOTS, 'max_seconds': MAX_SECONDS, 'total_shots': SHOTS*len(isa),
        'options': options(tag), 'target': view, 'versions': versions(), 'implementation': implementation(),
        'qpy_sha256': sha(data), 'source_sha256': source['source_sha256'], 'cases': cases,
        'signatures': [body_signature(c) for c in isa],
        'analysis': {'primary': 'Acquire server schedules for these eight complete programs.',
            'counts': 'Exploratory pilot only; no causal or future-fidelity acceptance decision.',
            'main_sample_authorized_by_this_plan': False,
            'C_reference': 'Common post-preparation boundary, not reset-end versus X-end. Must map from returned schedule.',
            'C_endpoint': 'Readout pulse start and acquisition window reported separately.',
            'equal_C_age_established': False, 'no_postselection': True, 'no_automatic_retry': True}}
    (directory/'isa.qpy').write_bytes(data)
    dump(directory/'plan.json', plan)
    return {'prepared': True, 'circuits': len(isa), 'shots': SHOTS*len(isa),
            'delays_converted_exactly': sum(len(c['duration_conversion']) for c in cases),
            'target': view, 'submitted': False}


def load(directory):
    p = w.read(directory/'plan.json')
    require(p['schema'] == 'vi.ibm.context-timing.v1' and p['shots'] == SHOTS and
        p['max_seconds'] == MAX_SECONDS and p['total_shots'] == 8*SHOTS and
        p['instance_plan'] == 'open' and p['backend'] == 'ibm_kingston' and
        p['options'] == options(p['tag']), 'Pilot execution scope changed')
    require(p['qpy_sha256'] == sha((directory/'isa.qpy').read_bytes()), 'Payload changed')
    circuits = qpy.load(io.BytesIO((directory/'isa.qpy').read_bytes()))
    require(len(circuits) == len(p['cases']) == 8, 'Case count changed')
    require(json.loads(json.dumps([body_signature(c) for c in circuits])) == p['signatures'], 'Body or timing changed')
    return p, circuits


def submit(directory):
    p, circuits = load(directory)
    require(p['implementation'] == implementation() and p['versions'] == versions(), 'Adapter changed since freeze')
    source,_,bridges = source_material()
    require(source['source_sha256'] == p['source_sha256'], 'Current VI root changed')
    for c,(_,old) in zip(circuits[-2:], bridges):
        require(d.measurement_ABI_form(c) == d.measurement_ABI_form(old), 'Old bridge altered')
    service = service_open()
    require(service.active_instance() == p['instance'], 'Wrong Open instance')
    with (directory/'submit.lock').open('a') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        ledger_file = directory/'ledger.json'
        if ledger_file.exists():
            ledger = w.read(ledger_file)
            require(ledger['tag'] == p['tag'] and ledger['qpy_sha256'] == p['qpy_sha256'], 'Wrong submission ledger')
            if ledger.get('job_id'):
                return ledger
            jobs = service.jobs(limit=2, job_tags=[p['tag']])
            require(len(jobs) == 1, 'Submission uncertain; no retry permitted')
            ledger.update(job_id=jobs[0].job_id(), status='recovered')
            dump(ledger_file, ledger)
            return ledger
        backend = service.backend(p['backend']); current = target_view(backend)
        dump(directory/'last-target-check.json', current)
        if not current['operational'] or current['status'] != 'active':
            return {'submitted': False, 'reason': 'backend not active', 'target': current}
        require(current['dt_seconds'] == p['target']['dt_seconds'] and
                current['timing_constraints'] == p['target']['timing_constraints'], 'Timing target changed; re-prepare separately')
        require(service.usage()['usage_remaining_seconds'] >= MAX_SECONDS, 'Insufficient free quota')
        validate_isa_circuits(circuits, backend.target)
        sampler = SamplerV2(mode=backend, options=p['options'])
        ledger = {'tag': p['tag'], 'qpy_sha256': p['qpy_sha256'], 'status': 'intent', 'at': utc()}
        dump(ledger_file, ledger)  # An ambiguous run result must never cause another run.
        job = sampler.run(circuits, shots=SHOTS)
        ledger.update(job_id=job.job_id(), status='submitted'); dump(ledger_file, ledger)
        return ledger


def collect(directory):
    p, circuits = load(directory)
    ledger = w.read(directory/'ledger.json')
    require(ledger['tag'] == p['tag'] and ledger['qpy_sha256'] == p['qpy_sha256'], 'Ledger mismatch')
    service = service_open(); require(service.active_instance() == p['instance'], 'Wrong instance')
    job = service.job(ledger['job_id']); state = job.status()
    require(p['tag'] in job.tags and job.backend().name == p['backend'], 'Wrong hardware occurrence')
    if state != 'DONE':
        result = {'job_id': job.job_id(), 'status': state}
        if state in ('ERROR', 'CANCELLED'):
            result['error'] = job.error_message()
        dump(directory/'status.json', result)
        return result
    result = job.result()
    # Save before interpretation, including missing or unsupported timing forms.
    (directory/'raw-result.json').write_text(json.dumps(_runs.bind_receipt(result, destination=directory/'raw-result.json'), cls=RuntimeEncoder, indent=2))
    pubs = job.inputs['pubs']
    require(len(pubs) == len(result) == 8, 'Wrong result cardinality')
    rows = []
    for entry,pub,circuit,case in zip(pubs,result,circuits,p['cases']):
        remote = entry[0] if isinstance(entry, (tuple,list)) else entry.circuit
        require(d.measurement_ABI_form(remote) == d.measurement_ABI_form(circuit), 'Remote circuit changed')
        require(body_signature(remote) == body_signature(circuit), 'Remote duration changed')
        require(pub.metadata.get('circuit_metadata') == circuit.metadata and
            set(pub.data.keys()) == {'out'}, 'Record origin/register mismatch')
        bits = pub.data.out
        require(bits.num_shots == SHOTS and bits.num_bits == 4 and bits.shape == (), 'Wrong recorded sample')
        counts = dict(bits.get_counts()); require(sum(counts.values()) == SHOTS, 'Incomplete sample')
        correct = sum(n for key,n in counts.items() if int(key[1]) == case['expected_C'])
        rows.append({'name': case['name'], 'counts': counts, 'C_correct': correct, 'shots': SHOTS,
            'schedule': schedule_evidence(pub.metadata, p['target']['dt_seconds'])})
    report = {'job_id': job.job_id(), 'status': state, 'at': utc(), 'rows': rows,
        'raw_sha256': sha((directory/'raw-result.json').read_bytes()), 'metrics': job.metrics(),
        'interpretation': p['analysis']}
    dump(directory/'hardware-result.json', report)
    return {'job_id': job.job_id(), 'status': state,
        'rows': [{'name': r['name'], 'C_correct': r['C_correct'], 'shots': SHOTS,
                  'schedule_available': r['schedule']['available']} for r in rows]}


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('stage', choices=('prepare','submit','collect'))
    parser.add_argument('--output', type=_runs.owned, required=True)
    args = parser.parse_args()
    print(json.dumps(_runs.bind_receipt(globals()[args.stage](args.output.resolve())), indent=2))
