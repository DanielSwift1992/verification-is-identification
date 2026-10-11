#!/usr/bin/env python3
"""Choose sufficient joint accuracy before minimizing expected report cost.

Six logical steps, one uniform current reading per three-step block, the
same suffix reading in both acquired branches. Existing sources and SDK
constructors; no new Swift axiom, acquisition, or physical reporter family.
"""
import argparse
from copy import deepcopy
from itertools import product
import json
from pathlib import Path

from qiskit import qpy
import resident_adaptive_checkpoint as adaptive
from environment import write, digest

stopped = adaptive.stopped
cost = stopped.cost


def corners(coefficients, witness):
    a, b, c = coefficients
    return [a + b*m + c*s for m in witness['mean_interval']
            for s in witness['second_moment_interval']]


class JointCostCheckpoint:
    def __init__(self, source, pair, artifact):
        stopped.validate(source)
        self.source = deepcopy(source)
        self.saved = cost.SavedCostView(source['cost'], pair, artifact)

    def stage(self, wanted, reading):
        # Reuse the current evidence reader; the old optimizer's selected
        # plan and its fixed-cost minimality assertion are not copied.
        evidence = self.saved.request(wanted, .99)
        if len(evidence['request']) != 1 or evidence['kind'] != 'act':
            raise ValueError('One complete orientation block per stage is required')
        r = evidence['candidates'][reading]['witness_primitive_error']
        contraction = max(0., 1 - 2*r - 4e-12)
        packet = {key: deepcopy(evidence[key]) for key in
                  ['source', 'record_sha256', 'request', 'least_favourable',
                   'confidence_failure', 'candidates']}
        packet.update(kind='act', selected={
            'modes': [reading]*3,
            'physical_report_reads': 3*self.source['cost']['report_counts'][reading],
            'error_upper': min(.75, .75*(1-contraction**2)+4e-12),
            'bound_kind': 'One uniform complete orientation block'},
            scope='Explicit current reading for a joint goal; no inherited fixed-cost optimality claim.')
        return stopped.select(self.source, packet)

    def request(self, first=adaptive.FIRST, next_requests=adaptive.NEXT, *, joint_risk=.30):
        self.saved.check()
        if set(next_requests) != {'0', '1'} or not 0 < joint_risk < 1:
            raise ValueError('Both acquired replies and a joint-output tolerance are required')
        plans = []
        for a, b in product(self.source['candidates'], repeat=2):
            start = self.stage(first, a)
            branches = {key: self.stage(next_requests[key], b) for key in ['0', '1']}
            refined = adaptive.retained_block_bound(start, branches)
            assert refined is not None
            assert branches['0']['expected_reads_coefficients'] == branches['1']['expected_reads_coefficients']
            coefficients = [x+y for x, y in zip(start['expected_reads_coefficients'],
                                               branches['0']['expected_reads_coefficients'])]
            values = corners(coefficients, start['cost_reading']['least_favourable'])
            plans.append({'first_reading': a, 'suffix_reading': b,
                          'first': start, 'next': branches, 'refinement': refined,
                          'joint_error_upper': refined['joint_error_upper'],
                          'compatible_witness_error': refined['compatible_witness_joint_error'],
                          'expected_reads_coefficients': coefficients,
                          'expected_report_reads_interval': [min(values)-1e-11, max(values)+1e-11],
                          'maximum_report_reads': start['maximum_report_reads'] + branches['0']['maximum_report_reads']})
        feasible = [p for p in plans if p['joint_error_upper'] <= joint_risk]
        base = {'source': cost.admission.fingerprint(self.source),
                'evidence_occurrence': self.saved.origin, 'required_joint_error': joint_risk,
                'catalogue': plans}
        if not feasible:
            return {**base, 'kind': 'needs_evidence'}
        chosen = min(feasible, key=lambda p: (p['expected_report_reads_interval'][1],
                                              p['joint_error_upper'], p['first_reading'], p['suffix_reading']))
        witness = chosen['first']['cost_reading']['least_favourable']
        dominance = []
        for plan in plans:
            differences = [a-b for a, b in zip(chosen['expected_reads_coefficients'], plan['expected_reads_coefficients'])]
            if plan['compatible_witness_error']-1e-10 > joint_risk:
                reason = 'excluded by compatible reporter'
            elif max(corners(differences, witness)) <= 0:
                reason = 'chosen expected cost no larger throughout moment rectangle'
            else:
                reason = 'minimum expected cost not established'
            dominance.append({'first_reading': plan['first_reading'],
                              'suffix_reading': plan['suffix_reading'], 'reason': reason})
        return {**base, 'kind': 'act', 'first': chosen['first'], 'next': chosen['next'],
                'selected_readings': [chosen['first_reading'], chosen['suffix_reading']],
                'joint_error_upper': chosen['joint_error_upper'],
                'expected_report_reads_upper': chosen['expected_report_reads_interval'][1],
                'expected_reads_coefficients': chosen['expected_reads_coefficients'],
                'maximum_report_reads': chosen['maximum_report_reads'],
                'checkpoint_owner': 1, 'final_owner': 0, 'dominance': dominance,
                'minimum_expected_cost': all(x['reason'] != 'minimum expected cost not established' for x in dominance),
                'scope': 'Six logical steps; one uniform current reading per block, common suffix reading in both actual branches. Minimal expected cost only in this sixteen-plan family and only when the displayed dominance/exclusion evidence establishes it.'}

    def check(self, packet):
        if packet.get('kind') != 'act':
            raise ValueError('The acquired evidence does not admit this joint request')
        first = packet['first']['cost_reading']['request']
        nxt = {b: packet['next'][b]['cost_reading']['request'] for b in ['0', '1']}
        if packet != self.request(first, nxt, joint_risk=packet['required_joint_error']) or packet['kind'] != 'act':
            raise ValueError('No applicable sufficient-accuracy joint-cost reading')

    def working_body(self, packet):
        self.check(packet)
        first = stopped.compile_stopped(self.source, self.saved.pair, packet['first'])
        branches = {b: stopped.compile_stopped(self.source, self.saved.pair, packet['next'][b]) for b in ['0', '1']}
        return adaptive.AdaptiveCheckpoint.assemble(self.source, packet, first, branches)

    def admit(self, packet, candidate):
        expected = self.working_body(packet)
        if (candidate.metadata != expected.metadata or candidate != expected or
                cost.policy.repeated.work.ordered_bindings(candidate) != cost.policy.repeated.work.ordered_bindings(expected)):
            raise ValueError('Joint-cost execution does not have the acquired goal or actual ports')
        return candidate


def prepare(output):
    output.mkdir(parents=True, exist_ok=True)
    root = cost.policy.repeated.wire.goal.ROOT
    source = json.loads((root/'Research/Artifacts/resident-stopped-read-20260915/stopped-reading.json').read_text())
    session = JointCostCheckpoint(source, (.8, .99), root/'Research/Artifacts/resident-orientation-word-20260915')
    packet = session.request()
    q = session.working_body(packet)
    session.admit(packet, q)
    write(output/'joint-reading.json', packet)
    with (output/'joint-cost-checkpoint.qpy').open('wb') as stream:
        qpy.dump(q, stream)
    return {'selected_readings': packet['selected_readings'],
            'joint_error_upper': packet['joint_error_upper'],
            'expected_report_reads_upper': packet['expected_report_reads_upper'],
            'maximum_report_reads': packet['maximum_report_reads'],
            'minimum_expected_cost_in_sixteen_plan_family': packet['minimum_expected_cost'],
            'QPY_sha256': digest(output/'joint-cost-checkpoint.qpy')}


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    print(json.dumps(prepare(parser.parse_args().output.resolve())))
