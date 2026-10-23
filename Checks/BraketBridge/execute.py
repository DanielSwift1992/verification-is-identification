#!/usr/bin/env python3
"""One local terminal execution from a checked VI acquisition.

This explicit provider realizes Uniform2 with two entangled control/shadow
pairs. Its reduced controls have the declared independent uniform classical
law. It creates the public parity record and reads the actual CZ resident.
There is no hidden source row, oracle answer, host sampling or new planner.
No arbitrary QASM input, cloud submission or live quantum-state output.
"""

import sys as _evidence_sys
from pathlib import Path as _EvidencePath
_evidence_sys.path.insert(0, str(_EvidencePath(__file__).resolve().parents[1]))
import hardware_runs as _runs
_runs.configure(required=(__name__ == "__main__"))
import argparse
from collections import Counter
import hashlib
import json
from pathlib import Path
import sys
import uuid
from time import perf_counter

from build import HERE, ROOT, run_bounded
from prepare import prepare
from runtime import require, load_json, write_json, public_terminal_shape, decode_runtime

PREPARATIONS = {
    'zero': (), 'one': ('x',), 'plus': ('h',), 'minus': ('x', 'h'),
    'plus_i': ('h', 's'), 'minus_i': ('h', 's', 's', 's'),
}
DATA = 0
CONTROLS = {0: 1, 1: 2}
SHADOWS = {0: 3, 1: 4}
RECORD = 5


def unique_named(items):
    require(isinstance(items, list), 'missing named export list')
    result = {}
    for item in items:
        require(isinstance(item, dict) and type(item.get('name')) is str
                and item['name'] not in result, 'invalid/duplicate named export')
        result[item['name']] = item
    return result


def terminal_job(documents, request_name, preparation, shots):
    """Lower only this admitted source; route selection already came from Swift."""
    require(type(shots) is int and 1 <= shots <= 4096, 'shots must be in [1,4096]')
    require(preparation in PREPARATIONS, 'unsupported payload preparation')
    sources, plans, requests = (documents[n] for n in ('sources.json', 'continuations.json', 'requests.json'))
    require(sources.get('schema') == 'vi.braket.sources.v1' and sources.get('control_count') == 4
            and plans.get('schema') == 'vi.braket.continuations.v1'
            and requests.get('schema') == 'vi.acquisition.requests.v1', 'wrong checked export scope')
    models = unique_named(sources['models'])
    plans = unique_named(plans['plans'])
    requests = unique_named(requests['requests'])
    require(request_name in requests, 'request not in current checked root')
    request = requests[request_name]
    require(request['backend'] == 'terminal_measurement' and request['action'] in ('skip', 'acquire'),
            'request has no supported terminal continuation; no SDK job submitted')
    model, selected = models[request['before']], models[request['selected']]
    plan = plans[request['selected']]
    require(plan['exact'] is True and plan['loss_numerator'] == 0
            and model['question'] == selected['question'] == plan['question'],
            'question or exact continuation binding changed')
    require(selected['operations'] == model['operations'], 'selected continuation changed the source')
    require(model['acquisitions'] == [[0, 1]], 'provider admits only the actual parity record')
    rows = model['rows']
    require(len(rows) == 16 and {r['index'] for r in rows} == set(range(16)), 'incomplete public source law')
    require(all(type(r['weight']) is int and r['weight'] == (1 if r['index'] in (0,4,8,12) else 0)
                for r in rows), 'provider cannot realize this joint law')
    execution = plan['execution']
    analyzer = public_terminal_shape(execution)
    # A real, separate shadow is retained for each control: no host latent bits.
    lines = ['OPENQASM 3.0;', 'qubit[6] q;']
    for control in (0, 1):
        lines += ['h q[{}];'.format(CONTROLS[control]),
                  'cnot q[{}], q[{}];'.format(CONTROLS[control], SHADOWS[control])]
    # Copy parity before the source acts. Later terminal readout of this record
    # commutes with the admitted controlled-Z path (controls are not modified).
    lines += ['cnot q[1], q[5];', 'cnot q[2], q[5];']
    lines += ['{} q[0];'.format(gate) for gate in PREPARATIONS[preparation]]
    cells = {}
    for op in model['operations']:
        gate = op.get('gate')
        if gate in ('h', 's'):
            require(set(op) == {'gate'}, 'unexpected fields on source gate')
            lines.append('{} q[0];'.format(gate))
        elif gate in ('z', 'retained_z'):
            require(set(op) == ({'gate', 'control', 'cell'} if gate == 'retained_z' else {'gate', 'control'}),
                    'unexpected fields on controlled source gate')
            require(type(op['control']) is int and op['control'] in CONTROLS, 'unsupported control')
            wire = CONTROLS[op['control']]
            lines.append('cz q[{}], q[0];'.format(wire))
            if gate == 'retained_z':
                require(type(op['cell']) is int and op['cell'] >= 0 and not cells,
                        'this provider admits one resident producer')
                cells[op['cell']] = (wire, op['control'])
        else:
            require(False, 'source operation/lifetime is not admitted by this provider')
    contact = None
    if request['action'] == 'acquire':
        require(request.get('contact_id') == 'first-current-resident'
                and request.get('cell') in cells and request['contacts'] == 1,
                'contact is not the actual resident producer')
        contact, coordinate = cells[request['cell']]
        require(selected['acquisitions'] == [[coordinate]] + model['acquisitions'],
                'contact does not refine this record')
    else:
        require(request['selected'] == request['before'] and request['contacts'] == 0,
                'skip must use the unchanged source')
    width = 1 + (contact is not None)
    require(execution['input_records'] == ['r{}'.format(i) for i in range(width)]
            and set(execution['by_record']) == {format(i, '0{}b'.format(width)) for i in range(1 << width)},
            'incomplete execution for real record outcomes')
    lines += ['{} q[0];'.format(gate) for gate in analyzer]
    measured = [RECORD, DATA] if contact is None else [RECORD, contact, DATA]
    lines.insert(2, 'bit[{}] out;'.format(len(measured)))
    lines += ['out[{}] = measure q[{}];'.format(i, wire) for i, wire in enumerate(measured)]
    qasm = '\n'.join(lines) + '\n'
    # Decoder descriptor is created by this very source producer, not supplied
    # by an arbitrary caller who can substitute another wire or source label.
    identity = hashlib.sha256(qasm.encode()).hexdigest()
    descriptor = {'execution': execution, 'data_wire': DATA, 'record_wire': RECORD,
                  'contact_wire': contact, 'measured_wires': measured, 'qasm_sha256': identity}
    # Same recipe is not the same occurrence. A result from an earlier run of
    # identical QASM must not be mistaken for the newly acquired record.
    return {'id': uuid.uuid4().hex, 'qasm': qasm, 'shots': shots}, descriptor, request


def decode_result(job, descriptor, result):
    require(hashlib.sha256(job['qasm'].encode()).hexdigest() == descriptor['qasm_sha256'],
            'source circuit changed after its decoder was bound')
    require(result['id'] == job['id'] and result['shots'] == job['shots'], 'result belongs to another job')
    wires = result['measured_qubits']
    require(isinstance(wires, list) and all(type(w) is int for w in wires)
            and len(wires) == len(descriptor['measured_wires'])
            and set(wires) == set(descriptor['measured_wires']), 'missing/extra/duplicate measured wire')
    require(result['values'] == [], 'terminal result must contain actual shots only')
    data = wires.index(descriptor['data_wire'])
    record = wires.index(descriptor['record_wire'])
    contact = None if descriptor['contact_wire'] is None else wires.index(descriptor['contact_wire'])
    answers, records, replies = Counter(), Counter(), Counter()
    require(isinstance(result['measurement_counts'], dict), 'missing measured counts')
    for bits, count in result['measurement_counts'].items():
        require(type(bits) is str and len(bits) == len(wires) and set(bits) <= {'0', '1'}
                and type(count) is int and count >= 0, 'invalid measured counts')
        reply = None if contact is None else int(bits[contact])
        value = decode_runtime(descriptor['execution'], bits[record], int(bits[data]), reply)
        answers[str(value)] += count
        records[bits[record]] += count
        if reply is not None:
            replies[str(reply)] += count
    require(sum(answers.values()) == job['shots'], 'incomplete shot batch')
    return {'answer_counts': dict(answers), 'public_record_counts': dict(records),
            'contact_reply_counts': dict(replies), 'shots': job['shots']}


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--request', required=True, help='Checked request, e.g. AcquireX, AcquireY, RotatedY')
    p.add_argument('--input', choices=PREPARATIONS, default='plus')
    p.add_argument('--shots', type=int, default=256)
    p.add_argument('--cache', type=_runs.owned)
    p.add_argument('--output', type=_runs.owned, required=True, help='New directory for actual execution records')
    a = p.parse_args()
    a.cache = a.cache if a.cache is not None else _runs.prepared('braket-prepared')
    a.output = a.output.resolve()
    started = perf_counter()
    implementation = {name: hashlib.sha256((HERE/name).read_bytes()).hexdigest()
                      for name in ('execute.py', 'runtime.py', 'runner.py')}
    require(not a.output.exists(), 'output must be a new directory')
    require(1 <= a.shots <= 4096, 'shots must be in [1,4096]')
    documents, receipt = prepare(a.cache)
    job, descriptor, request = terminal_job(documents, a.request, a.input, a.shots)
    a.output.mkdir(parents=True)
    write_json(a.output/'jobs.json', _runs.bind_receipt({'schema': 'vi.braket.jobs.v1', 'jobs': [job]}, destination=a.output/'jobs.json'))
    run = run_bounded([sys.executable, HERE/'runner.py', '--jobs', a.output/'jobs.json',
                       '--output', a.output/'raw-result.json'], 90)
    (a.output/'runner.log').write_text(run.stdout)
    require(run.returncode == 0, 'local SDK failed; inspect runner.log; no result accepted')
    raw = load_json(a.output/'raw-result.json')
    require(raw['schema'] == 'vi.braket.results.v1' and raw['status'] == 'completed'
            and raw['backend'] == 'braket_dm' and len(raw['jobs']) == 1, 'wrong execution scope')
    answer = decode_result(job, descriptor, raw['jobs'][0])
    require(all(hashlib.sha256((HERE/name).read_bytes()).hexdigest() == value
                for name,value in implementation.items()), 'runtime code changed during execution')
    report = {'schema': 'vi.braket.terminal-run.v1', 'request': request,
              'preparation': a.input, 'checked_build': receipt, 'answer': answer,
              'provider': 'uniform-two-control parity/CZ resident; local only',
              'implementation_sha256': implementation,
              'initial_record_measurements': 1,
              'additional_resident_measurements': request['contacts'],
              'job_id': job['id'], 'qasm_sha256': descriptor['qasm_sha256'], 'package_versions': raw['package_versions'],
              'seconds': perf_counter()-started,
              'scope': 'sampled classical output; no returned quantum state or hardware validation'}
    write_json(a.output/'result.json', _runs.bind_receipt(report, destination=a.output/'result.json'))
    print(json.dumps(_runs.bind_receipt(report), indent=2))


if __name__ == '__main__':
    main()
