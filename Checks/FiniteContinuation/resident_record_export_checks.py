#!/usr/bin/env python3
"""Targeted acquired-choice routing checks; no cloud or new calibration."""
import argparse
from copy import deepcopy
import io
import json
from pathlib import Path
import time
from unittest.mock import patch

from qiskit import qpy
from qiskit.circuit import CircuitInstruction, IfElseOp
from qiskit_aer import AerSimulator

import resident_record_export as export
import resident_adaptive_checkpoint_checks as previous
from environment import write, digest


def routing_identity():
    # For every incoming scratch/choice state and every measurement branch,
    # the SAME quantum branch map is executed; only its destination differs.
    # This finite classical identity therefore also holds for arbitrary
    # unnormalised quantum inputs, environments and reference systems.
    rows = []
    for old_reply in (0, 1):
        for old_choice in (0, 1):
            for outcome in (0, 1):
                left = {'reply': old_reply, 'choice': old_choice}
                right = dict(left)
                left['reply'] = outcome
                left['choice'] = left['reply']
                right['choice'] = outcome
                right['reply'] = right['choice']
                assert left == right == {'reply': outcome, 'choice': outcome}
                rows.append({'incoming': [old_reply, old_choice], 'outcome': outcome,
                             'common_runtime': left,
                             'old_measurement_only_export': 0,
                             'new_measurement_only_export': outcome})
    return {'branches': rows, 'scope': 'Exact classical assignment identity at the pair boundary. '
            'The measurement-only export column is a model of the documented interface, not observed IBM data.'}


def run(output):
    start = time.perf_counter()
    output.mkdir(parents=True, exist_ok=False)
    root = export.joint.cost.policy.repeated.wire.goal.ROOT
    oldpath = root/'Research/Artifacts/resident-joint-cost-20260915/joint-cost-checkpoint.qpy'
    oldhash = digest(oldpath)
    sourcepath = root/'Research/Artifacts/resident-stopped-read-20260915/stopped-reading.json'
    source = json.loads(sourcepath.read_text())
    with patch.object(AerSimulator, 'run', side_effect=AssertionError('New calibration requested')):
        session = export.joint.JointCostCheckpoint(source, (.8, .99), root/'Research/Artifacts/resident-orientation-word-20260915')
        packet = session.request()
        original = session.working_body(packet)
        with oldpath.open('rb') as stream:
            saved, = qpy.load(stream)
        session.admit(packet, saved)
        adapter = export.MeasuredChoiceCheckpoint(session)
        device = adapter.working_body(packet)
        adapter.admit(packet, device)

    identity = routing_identity()
    before, after = export.events(original), export.events(device)
    assert [(r['name'], r['qubits'], r['label']) for r in before] == [(r['name'], r['qubits'], r['label']) for r in after]
    assert len(original.data) == len(device.data)
    with (output/'measured-choice-checkpoint.qpy').open('wb') as stream:
        qpy.dump(device, stream)
    with (output/'measured-choice-checkpoint.qpy').open('rb') as stream:
        restored, = qpy.load(stream)
    adapter.admit(packet, restored)

    rows = []
    for pair in [(.8, .99), (.010000000000000009, .19999999999999996), (0., 0.), (1., 1.)]:
        if pair in [(0., 0.), (1., 1.)]:
            body, _ = previous.fixture(source, packet, pair)
            body = export.lower_acquired_choice(body)
        else:
            session.saved.pair = pair
            body = adapter.working_body(packet)
            adapter.admit(packet, body)
        rows.append(previous.live(source, packet, body, pair, 2026092900+100*len(rows),
                                  shots=48, ideal=pair in [(0., 0.), (1., 1.)]))
    session.saved.pair = (.8, .99)
    tighter = session.request(joint_risk=.295)
    other = adapter.working_body(tighter)
    adapter.admit(tighter, other)
    rows.append(previous.live(source, tighter, other, (.8, .99), 2026093500, shots=48))

    refusals = []
    def no(name, action):
        try:
            action()
        except (ValueError, AssertionError):
            refusals.append(name)
            return
        raise AssertionError('Accepted '+name)

    no('runtime-only Store is not a measured export', lambda: export.export_schema(original))
    bad = device.copy()
    bad.store(bad.clbits[3], False)
    no('retained choice overwritten after acquisition', lambda: adapter.admit(packet, bad))
    bad = device.copy()
    bad.measure(4, 3)
    no('second measurement changes the retained occurrence', lambda: adapter.admit(packet, bad))
    bad = device.copy()
    index = device.metadata['record_export']['measurement_path'][0]
    item = bad.data[index]
    bad.data[index] = CircuitInstruction(item.operation, (bad.qubits[0],), item.clbits)
    no('choice reads a different quantum carrier', lambda: adapter.admit(packet, bad))
    index = device.metadata['continuation_control_index']
    # Rebuild this negative fixture: replacing a control-flow instruction
    # in-place panics in this installed SDK's block-reference bookkeeping.
    # The actual producer/lowering never uses that mutation path.
    bad = device.copy_empty_like()
    for i, item in enumerate(device.data):
        if i == index:
            op = IfElseOp((bad.clbits[3], 1), *item.operation.blocks)
            bad.append(op, item.qubits, item.clbits)
        else:
            bad.append(item)
    no('same measured bit selects the wrong continuation', lambda: adapter.admit(packet, bad))
    badpacket = deepcopy(packet)
    badpacket['next']['1']['cost_reading']['request'][0]['x'] = [0, 1]
    no('old export attached to a changed question', lambda: adapter.admit(badpacket, device))
    no('old AnyOne body for the stricter Majority goal', lambda: adapter.admit(tighter, device))
    assert digest(oldpath) == oldhash
    session.saved.check()
    result = {'schema': 'vi.measured-choice-export.v1', 'assignment_identity': identity,
              'readout': export.export_schema(device), 'remaining_limitations': export.limitations(device),
              'same_quantum_instructions_and_measurement_count': True,
              'sdk': rows, 'full_joint_states_checked': sum(r['full_joint_states_checked'] for r in rows),
              'maximum_joint_state_error': max(r['maximum_joint_state_error'] for r in rows),
              'refusals': refusals, 'old_QPY_sha256': oldhash, 'old_QPY_unchanged': True,
              'new_QPY_sha256': digest(output/'measured-choice-checkpoint.qpy'),
              'joint_error_upper_unchanged': packet['joint_error_upper'],
              'expected_report_reads_upper_unchanged': packet['expected_report_reads_upper'],
              'implementation_sha256': digest(Path(export.__file__)), 'checks_sha256': digest(Path(__file__)),
              'new_calibrations': 0, 'new_QPU_jobs': 0, 'full_repository_regression': False,
              'seconds': time.perf_counter()-start}
    write(output/'audit.json', result)
    write(output/'joint-reading.json', packet)
    return result


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    result = run(parser.parse_args().output.resolve())
    print(json.dumps({k: result[k] for k in ['full_joint_states_checked', 'maximum_joint_state_error',
                     'seconds', 'refusals', 'remaining_limitations']}, indent=2))
