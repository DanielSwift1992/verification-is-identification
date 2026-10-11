#!/usr/bin/env python3
"""Acquire the requested two-epoch event on the same retained quantum memory.

The old single-body confidence interval is not a premise of this decision.
Only its source-derived executable body is reused. This is one prespecified
local joint calibration, with the existing full-coverage and binomial tools.
"""
import argparse
from collections import Counter
from copy import deepcopy
import json
from pathlib import Path

from qiskit import QuantumCircuit, ClassicalRegister, qpy
from qiskit.circuit.classical import expr
from qiskit_aer import AerSimulator

import resident_failure_evidence as single
from environment import write, digest


def joint_body(source, selection, service, budget):
    main = single.body(source, selection, service, budget); q = QuantumCircuit(5)
    outputs = [single.append_epoch(q, main, 'epoch'+str(i)) for i in range(2)]
    joint = ClassicalRegister(1, 'joint_completed'); q.add_register(joint)
    q.reset(0)
    with q.if_test(expr.logic_and(outputs[0][0], outputs[1][0])):
        q.x(0)
    q.measure(0, joint[0]); q.reset(0)
    q.metadata = {'source': single.admission.fingerprint(source),
        'selection': single.admission.fingerprint(selection), 'body_budget': budget, 'epochs': 2,
        'joint_question': 'Both actually measured completion outputs are 1',
        'quantum_boundary': 'The same D,E,M,Ref enter, cross both epochs and remain unmeasured.',
        'new_QPU_jobs': 0}
    single.completion.flat.check_flat_fragment(q)
    return q


def readout(q):
    names = ('epoch0_completed', 'epoch1_completed', 'joint_completed')
    result = {}
    for name in names:
        reg, = [reg for reg in q.cregs if reg.name == name]
        if len(reg) != 1:
            raise ValueError('One acquired flag per declared occurrence required')
        result[name] = q.find_bit(reg[0]).index
    if len(set(result.values())) != 3:
        raise ValueError('The two occurrences and joint readout must be distinct')
    return result


def covering_joint(source, selection, service, budget):
    main = joint_body(source, selection, service, budget); q = single.covering_preparation()
    q.add_register(*main.cregs)
    for item in main.data:
        q.append(item.operation, [main.find_bit(bit).index for bit in item.qubits], list(item.clbits))
    q.metadata = {**main.metadata, 'preparation': single.coverage()}
    single.completion.flat.check_flat_fragment(q)
    return q


class LocalJointEvidence(single.LocalEvidence):
    def binding(self):
        return {**super().binding(), 'question': 'Both completion flags after two epochs on the same M',
            'joint_implementation_sha256': digest(Path(__file__)),
            'scope': 'Constructed fixed complete local service. Three Bell pairs prepare calibration DEM once; no intervening preparation between the two epochs. Ideal acquired outputs.'}

    def decision(self, record):
        packet = super().decision(record)
        packet['scope'] = 'Joint failure of two epochs on arbitrary incoming DEM/reference. The single-body statistical bound is not a premise.'
        return packet

    def acquire_next(self, output):
        self.check()
        if len(self.budgets) != 1 or self.records:
            raise ValueError('One prespecified joint calibration only')
        budget = self.budgets[0]; q = covering_joint(self.source, self.selection, self.service, budget)
        output.mkdir(parents=True, exist_ok=True); path = output/'joint-calibration.qpy'
        if path.exists():
            raise ValueError('Joint occurrence already exists')
        with path.open('wb') as stream:
            qpy.dump(q, stream)
        with path.open('rb') as stream:
            restored, = qpy.load(stream)
        if q != restored or single.work.ordered_bindings(q) != single.work.ordered_bindings(restored):
            raise ValueError('Joint preparation, ports or control changed')
        seed = 2026091517
        result = AerSimulator(method='statevector', max_parallel_threads=1).run(
            restored, shots=self.shots, memory=True, seed_simulator=seed).result()
        if not result.success:
            raise ValueError('Joint acquisition failed')
        positions = readout(restored); counts = Counter(); words = []
        for text in result.get_memory():
            word = int(text.replace(' ', ''), 2); words.append(word)
            bits = [(word >> positions[name]) & 1 for name in positions]
            if bits[2] != (bits[0] & bits[1]):
                raise ValueError('Actual joint record does not match its two acquired inputs')
            counts[''.join(map(str, bits[:2]))] += 1
        record = {'binding': deepcopy(self.origin), 'budget': budget, 'shots': self.shots,
            'failures': self.shots-counts['11'], 'alpha': self.alpha, 'epoch_pair_counts': dict(counts),
            'simulation_seed': seed, 'QPY_sha256': digest(path),
            'raw_records_sha256': single.admission.fingerprint(words), 'readout_positions': positions,
            'new_QPU_jobs': 0}
        self.records.append(deepcopy(record)); write(output/'joint-calibration.json', record)
        return record

    def working_body(self, packet):
        self.check()
        if packet['kind'] != 'act' or sum(self.decision(record) == packet for record in self.records) != 1:
            raise ValueError('No current acquired joint guarantee')
        return joint_body(self.source, self.selection, self.service, packet['budget'])


def acquire(output):
    directory = single.completion.goal.ROOT/'Research/Artifacts/resident-completion-20260915'
    source = json.loads((directory/'completion-reading.json').read_text())
    selection = json.loads((directory/'plans.json').read_text())['reachable']
    from resident_contact_memory_checks import service_fixture
    service, _ = service_fixture(1.3, -.8, .71)
    session = LocalJointEvidence(source, selection, service, budgets=(16,), shots=8192, alpha=.01, risk=.01)
    record = session.acquire_next(output); packet = session.decision(record)
    write(output/'joint-decision.json', packet)
    if packet['kind'] == 'act':
        with (output/'joint-working-body.qpy').open('wb') as stream:
            qpy.dump(session.working_body(packet), stream)
    return session, record, packet


if __name__ == '__main__':
    p = argparse.ArgumentParser(description=__doc__); p.add_argument('--output', type=Path, required=True)
    _, record, packet = acquire(p.parse_args().output.resolve())
    print(json.dumps({'counts': record['epoch_pair_counts'], 'kind': packet['kind'],
                      'joint_failure_upper': packet['failure_probability_upper']}))
