#!/usr/bin/env python3
"""Decode the declared joint recipient question, including stochastic records."""
import json
from collections import defaultdict
import bounded_open_experiment as io


def analyze(private, art):
    plan, _ = io.load(private)
    status = io.read(art / 'status.json')
    io.require(status['status'] == 'DONE', 'Missing completed result')
    for file, key in [('raw-result.json', 'raw_sha256'), ('provider-result.txt', 'provider_raw_sha256')]:
        io.require(io.sha((private / file).read_bytes()) == status[key], 'Evidence changed')
    io.require(len(status['rows']) == len(plan['PUBs']), 'Wrong result size')
    rows = []
    for row, entry in zip(status['rows'], plan['PUBs']):
        io.require(all(row[k] == v for k, v in entry.items()), 'Source/result mismatch')
        expected_registers = {'actual_a', 'witness', 'retired_source_check'}
        if row['measures_request']: expected_registers.add('actual_arrival')
        io.require(set(row['registers']) == expected_registers,
                   'Wrong record boundary')
        counts = defaultdict(int)
        for key, n in row['counts'].items():
            values = key.split()
            io.require(len(values) == len(row['registers']), 'Missing joint register')
            d = {name: int(value, 2) for name, value in zip(row['registers'], values)}
            record = d['actual_a']; w = d['witness']
            parity = ((w >> 1) ^ (w >> 2)) & 1
            target = record if row['basis'] == 'XX' else 0
            counts['shots'] += n
            counts['record_one'] += n * record
            if row['measures_request']:
                counts['request_one'] += n * d['actual_arrival']; counts['request_shots'] += n
            counts['retired_source_zero'] += n * (d['retired_source_check'] == 0)
            counts['B_as_prepared'] += n * ((w & 1) == int(row['prepared_b'] == '-'))
            counts['data_even'] += n * (parity == 0)
            counts['requested_target_correct'] += n * (parity == target)
            if row['prepared_a'] != '+' and row['acquires_a']:
                counts['record_matches_preparation'] += n * (record == int(row['prepared_a']))
        n = counts['shots']
        io.require(n == row['shots'] == plan['shots_each'], 'Wrong shot count')
        rows.append({**entry, **dict(counts),
                     'data_parity': 2 * counts['data_even'] / n - 1,
                     'requested_target_score': 2 * counts['requested_target_correct'] / n - 1,
                     'B_preservation_score': 2 * counts['B_as_prepared'] / n - 1})
    summaries = []
    for key in dict.fromkeys((r['arm'], r['prepared_a'], r['prepared_b']) for r in rows):
        rr = [r for r in rows if (r['arm'], r['prepared_a'], r['prepared_b']) == key]
        n = sum(r['shots'] for r in rr)
        s = {'arm': key[0], 'prepared_a': key[1], 'prepared_b': key[2], 'shots': n,
             'record_one_fraction': sum(r['record_one'] for r in rr) / n,
             'request_one_fraction': (sum(r.get('request_one', 0) for r in rr)/n
                                      if all(r['measures_request'] for r in rr) else None),
             'retired_source_zero_fraction': sum(r['retired_source_zero'] for r in rr) / n,
             'B_preservation_score': sum(r['B_preservation_score'] * r['shots'] for r in rr) / n}
        if key[1] != '+' and all(r['acquires_a'] for r in rr):
            s['record_matches_preparation'] = sum(r['record_matches_preparation'] for r in rr) / n
        for basis in ('XX', 'ZZ'):
            rb = [r for r in rr if r['basis'] == basis]
            bn = sum(r['shots'] for r in rb)
            io.require(bn > 0, 'Missing exit question')
            s[basis] = sum(r['data_parity'] * r['shots'] for r in rb) / bn
            s[basis + '_requested_target_score'] = sum(r['requested_target_score'] * r['shots'] for r in rb) / bn
        summaries.append(s)
    return {'schema': 'vi.relative-memory-handoff-analysis.v1', 'job_id': status['job_id'],
            'rows': rows, 'summaries': summaries, 'shots': sum(r['shots'] for r in rows),
            'scope': 'All-shot descriptive values. XX requested score includes the same-shot actual acquired bit; '
                     'raw XX and record marginal remain separate. No trusted source-reset measurement, '
                     'postselection, arbitrary-input hardware guarantee or model-independent causal attribution.'}


if __name__ == '__main__':
    import relative_memory_handoff_probe as p
    print(json.dumps(analyze(p.PRIVATE, p.ART), indent=2))
