#!/usr/bin/env python3
"""Independent finite live and exact-rational audit of sufficient joint cost."""
import argparse
from copy import deepcopy
from fractions import Fraction as F
import json
from pathlib import Path
import time
from unittest.mock import patch

from qiskit_aer import AerSimulator
import resident_joint_cost as joint
import resident_adaptive_checkpoint_checks as previous
import resident_numerical_bounds_checks as exact
from environment import write, digest


def run(output):
    start = time.perf_counter()
    root = joint.cost.policy.repeated.wire.goal.ROOT
    source = json.loads((root/'Research/Artifacts/resident-stopped-read-20260915/stopped-reading.json').read_text())
    with patch.object(AerSimulator, 'run', side_effect=AssertionError('New acquisition requested')):
        session = joint.JointCostCheckpoint(source, (.8, .99), root/'Research/Artifacts/resident-orientation-word-20260915')
        packet = session.request()
        device = session.working_body(packet)
        session.admit(packet, device)
        tighter = session.request(joint_risk=.295)
        assert tighter['selected_readings'] == ['Majority', 'Majority']
        assert session.request(joint_risk=.29)['kind'] == 'needs_evidence'
    assert packet['selected_readings'] == ['AnyOne', 'AnyOne']
    assert packet['minimum_expected_cost']
    assert packet['expected_report_reads_upper'] < 12.78
    assert packet['joint_error_upper'] < .30
    assert packet['expected_reads_coefficients'] == [18, -18, 6]

    witness = packet['first']['cost_reading']['least_favourable']
    rates, geometry = exact.exact_rates(source['cost'], witness)
    proof = []
    for plan, decision in zip(packet['catalogue'], packet['dominance']):
        a, b = plan['first_reading'], plan['suffix_reading']
        sa = [1-2*x for x in rates[a]]
        sb = [1-2*x for x in rates[b]]
        error = [F(3, 4)*(1-sa[i]**2*sb[i]**2) for i in [0, 1]]
        assert error[1] <= F.from_float(plan['joint_error_upper'])
        delta = [x-y for x, y in zip(packet['expected_reads_coefficients'], plan['expected_reads_coefficients'])]
        corner_deltas = [delta[0]+delta[1]*F.from_float(m)+delta[2]*F.from_float(s)
                         for m in witness['mean_interval'] for s in witness['second_moment_interval']]
        if decision['reason'] == 'excluded by compatible reporter':
            assert error[0] > F(3, 10)
        else:
            assert decision['reason'] == 'chosen expected cost no larger throughout moment rectangle'
            assert max(corner_deltas) <= 0
        proof.append({'first': a, 'suffix': b, 'joint_error_interval': exact.display_interval(error),
                      'reason': decision['reason'],
                      'largest_exact_chosen_minus_alternative_expected_cost': str(max(corner_deltas))})
    assert len(proof) == 16
    expected = [18-18*F.from_float(m)+6*F.from_float(s)
                for m in witness['mean_interval'] for s in witness['second_moment_interval']]
    assert max(expected) <= F.from_float(packet['expected_report_reads_upper'])
    # An entire physical rectangle here: t is real, a,b nonnegative even at
    # their worst physical constraints. No incompatible corner is used for
    # the pointwise comparison; proving dominance on the rectangle is stronger.
    rows = []
    for pair in [(.8, .99), (.010000000000000009, .19999999999999996)]:
        session.saved.pair = pair
        q = session.working_body(packet)
        session.admit(packet, q)
        rows.append(previous.live(source, packet, q, pair, 2026092700+100*len(rows)))
    for pair in [(0., 0.), (1., 1.)]:
        q, _ = previous.fixture(source, packet, pair)
        rows.append(previous.live(source, packet, q, pair, 2026092800+100*len(rows), ideal=True))
    session.saved.pair = (.8, .99)
    refusals = []

    def no(name, action):
        try:
            action()
        except (ValueError, AssertionError):
            refusals.append(name)
            return
        raise AssertionError('Accepted ' + name)

    wrong = deepcopy(packet)
    wrong['first']['cost_reading']['selected']['modes'] = ['Single']*3
    no('unselected cheaper reading with copied guarantee', lambda: session.working_body(wrong))
    wrong = deepcopy(packet)
    wrong['expected_report_reads_upper'] = 6
    no('unpaid expected cost', lambda: session.working_body(wrong))
    wrong = deepcopy(packet)
    wrong['required_joint_error'] = .295
    no('stricter goal attached to the old AnyOne execution', lambda: session.working_body(wrong))
    wrong = deepcopy(packet)
    wrong['next']['1']['cost_reading']['request'][0]['x'] = [0, 1]
    no('changed next goal under the old body', lambda: session.admit(wrong, device))
    bad = device.copy()
    bad.x(0)
    no('additional physical action under unchanged metadata', lambda: session.admit(packet, bad))
    no('explicitly unresolved request cannot execute', lambda: session.working_body(session.request(joint_risk=.29)))
    algebra = previous.joint_algebra(source, packet)
    assert algebra['cases'][0]['joint_half_diamond_error'] < packet['joint_error_upper']
    session.saved.check()
    result = {'selected': packet, 'exact_sixteen_plan_certificate': proof,
              'expected_cost_extrema': exact.display_interval((min(expected), max(expected))),
              'tighter_goal_selected': tighter['selected_readings'],
              'sdk': rows, 'joint_algebra': algebra, 'refusals': refusals,
              'full_joint_states_checked': sum(r['full_joint_states_checked'] for r in rows),
              'maximum_joint_state_error': max(r['maximum_joint_state_error'] for r in rows),
              'new_acquisitions': 0, 'new_QPU_jobs': 0, 'full_repository_regression': False,
              'implementation_sha256': digest(Path(joint.__file__)),
              'check_sha256': digest(Path(__file__)), 'seconds': time.perf_counter()-start}
    write(output/'audit.json', result)
    return result


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    result = run(args.output.resolve())
    print(json.dumps({key: result[key] for key in
                     ['full_joint_states_checked', 'maximum_joint_state_error', 'seconds',
                      'refusals', 'joint_algebra', 'expected_cost_extrema']}))
