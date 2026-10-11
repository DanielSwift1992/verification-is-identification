#!/usr/bin/env python3
"""Bounded QA of the ordinary execution door (never imported by that door)."""
import argparse
import copy
import json
import math
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
from unittest.mock import patch

import execute
import oracle
import prepare as prepared
from build import HERE, ROOT, run_bounded
from runtime import CheckFailure, load_json, write_json, require


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--cache', type=Path, default=ROOT/'private/braket-prepared')
    p.add_argument('--output', type=Path, required=True)
    a = p.parse_args()
    a.output = a.output.resolve()
    require(not a.output.exists(), 'QA output must be new')
    a.output.mkdir(parents=True)
    docs, receipt = prepared.prepare(a.cache)
    inputs = prepared.snapshot()
    refusals = []

    def rejects(name, f):
        try:
            f()
        except (CheckFailure, FileNotFoundError):
            refusals.append(name)
        else:
            raise AssertionError('accepted: '+name)

    for name in ('AcquireState', 'NoPortX', 'WithdrawnX'):
        rejects(name, lambda n=name: execute.terminal_job(docs, n, 'plus', 32))
    for what in ('law', 'question', 'producer', 'record', 'unsupported-operation'):
        changed = copy.deepcopy(docs)
        model = next(m for m in changed['sources.json']['models'] if m['name'] == 'LiveXBefore')
        if what == 'law': model['rows'][0]['weight'] = 2
        if what == 'question': model['question'] = 'Y'
        if what == 'producer':
            next(r for r in changed['requests.json']['requests'] if r['name'] == 'AcquireX')['cell'] = 9
        if what == 'record': model['acquisitions'] = [[0]]
        if what == 'unsupported-operation': model['operations'].append({'gate':'reset'})
        rejects(what, lambda d=changed: execute.terminal_job(d, 'AcquireX', 'plus', 32))

    job, descriptor, _ = execute.terminal_job(docs, 'AcquireX', 'plus', 8)
    # Physical order differs from QASM emission order. Every logical outcome
    # must decode identically after an honest wire/bit permutation.
    wires = descriptor['measured_wires']
    counts = {format(i, '03b'): 1 for i in range(8)}
    raw = {'id':job['id'], 'shots':8, 'values':[], 'measured_qubits':wires, 'measurement_counts':counts}
    baseline = execute.decode_result(job, descriptor, raw)
    other_job, other_descriptor, _ = execute.terminal_job(docs, 'AcquireX', 'plus', 8)
    require(other_job['qasm'] == job['qasm'], 'occurrence test changed the recipe')
    rejects('old-occurrence-same-recipe', lambda: execute.decode_result(other_job, other_descriptor, raw))
    changed_job = dict(job, qasm=job['qasm'].replace('cz q[2]', 'cz q[3]'))
    rejects('different-memory-circuit', lambda: execute.decode_result(changed_job, descriptor, raw))
    reordered = copy.deepcopy(raw)
    reordered['measured_qubits'] = list(reversed(wires))
    reordered['measurement_counts'] = {b[::-1]: n for b,n in counts.items()}
    require(execute.decode_result(job, descriptor, reordered) == baseline, 'bit-order transport changed answer')
    for what in ('job', 'shots', 'extra-wire', 'bool-wire', 'negative-count', 'partial-batch'):
        bad = copy.deepcopy(raw)
        if what == 'job': bad['id'] = 'other-source'
        if what == 'shots': bad['shots'] = 9
        if what == 'extra-wire': bad['measured_qubits'][0] = 4
        if what == 'bool-wire': bad['measured_qubits'][-1] = False
        if what == 'negative-count': bad['measurement_counts']['000'] = -1
        if what == 'partial-batch': bad['measurement_counts'].pop('000')
        rejects(what, lambda b=bad: execute.decode_result(job, descriptor, b))

    # A damaged cached export is refused before source construction or SDK.
    with tempfile.TemporaryDirectory() as tmp:
        entry = Path(tmp)
        for name in (*prepared.EXPORTS, 'ready.json', 'build-manifest.json'):
            shutil.copyfile(Path(receipt['directory'])/name, entry/name)
        prepared.validate_entry(entry, inputs)
        with (entry/'continuations.json').open('a') as f: f.write(' ')
        rejects('modified-cached-export', lambda: prepared.validate_entry(entry, inputs))
    real_digest = prepared.digest
    def changed_digest(path):
        return 'changed' if path.name == 'AcquisitionCases.swift' else real_digest(path)
    with patch.object(prepared, 'digest', changed_digest):
        require(prepared.cache_key(prepared.snapshot()) != prepared.cache_key(inputs), 'source change reused old key')
    def unrelated_digest(path):
        return 'changed' if path.name in ('oracle.py','CoherentCases.swift','runtime_checks.py') else real_digest(path)
    with patch.object(prepared, 'digest', unrelated_digest):
        require(prepared.snapshot() == inputs, 'unrelated regression/mode invalidated compilation')
    # This runs in a fresh process so this QA module's oracle import cannot hide
    # a production dependency. No simulator gets executed in this import check.
    clean = run_bounded([sys.executable, '-c',
        "import sys; sys.path.insert(0, sys.argv[1]); import execute; "
        "assert not ({'oracle','experiment','acquisition_experiment'} & set(sys.modules))", HERE], 15)
    require(clean.returncode == 0, 'runtime imports fixture/oracle: '+clean.stdout)

    # Independent literal matrices supply expectations only in this QA layer.
    jobs, contexts = [], []
    for name in ('AcquireX','AcquireY','AcquireZ','RotatedX','RotatedY','RotatedZ'):
        for state in execute.PREPARATIONS:
            j, d, request = execute.terminal_job(docs, name, state, 512)
            model = next(m for m in docs['sources.json']['models'] if m['name'] == request['before'])
            ideal_ops = [op for op in model['operations'] if op['gate'] in ('h','s')]
            _, ideal = oracle.literal_unitaries(ideal_ops, 0, 4)
            rho = oracle.output_density(ideal, oracle.STATES[state])
            observable = oracle.PAULIS[model['question']]
            expectation = sum(observable[i][k]*rho[k][i] for i in range(2) for k in range(2)).real
            probability = (1+expectation)/2
            jobs.append(j)
            contexts.append((name, state, j, d, request, probability))
    require(len({j['id'] for j in jobs}) == len(jobs), 'duplicate job identity')
    tolerance = math.sqrt(math.log(2*len(jobs)/0.01)/(2*512))
    write_json(a.output/'precommit.json', {'jobs':len(jobs), 'shots':512, 'family_alpha':0.01,
        'absolute_tolerance':tolerance, 'retry':'one batch, no retry-until-pass'})
    write_json(a.output/'jobs.json', {'schema':'vi.braket.jobs.v1','jobs':jobs})
    completed = run_bounded([sys.executable,HERE/'runner.py','--jobs',a.output/'jobs.json',
                             '--output',a.output/'raw.json'], 90)
    (a.output/'runner.log').write_text(completed.stdout)
    require(completed.returncode == 0, 'SDK QA failed')
    raw = {r['id']:r for r in load_json(a.output/'raw.json')['jobs']}
    checks = []
    for name, state, j, d, request, expected in contexts:
        result = execute.decode_result(j,d,raw[j['id']])
        observed = result['answer_counts'].get('0',0)/512
        require(abs(expected-observed) <= tolerance, 'wrong terminal distribution: '+name+'/'+state)
        if expected in (0,1):
            require(observed == expected, 'ideal eigenstate output was not deterministic')
        checks.append({'request':name,'input':state,'contacts':request['contacts'],
                       'expected_zero':expected,'observed_zero':observed})
    report = {'status':'passed', 'checked_build':receipt, 'refusals':refusals,
              'sampling_checks':checks, 'ordinary_import_excludes_oracle':True,
              'wire_order_transport':True, 'source_invalidation':True,
              'unrelated_QA_excluded_from_key':True}
    write_json(a.output/'result.json', report)
    print(json.dumps({'status':'passed','refusals':len(refusals),'sampling_checks':len(checks),
                      'output':str(a.output)},indent=2))


if __name__ == '__main__':
    main()
