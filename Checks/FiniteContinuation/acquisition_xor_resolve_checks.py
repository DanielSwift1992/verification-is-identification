#!/usr/bin/env python3
"""Independent GF(2) oracle, current-root applications and serialized instruments."""
from copy import deepcopy
from itertools import product
from pathlib import Path
from unittest.mock import patch
import argparse
import io
import json
import time
import numpy as np
from qiskit import qpy
import acquisition_xor_resolve as r
from acquisition_future_synthesis_checks import read_gate_instrument


def run(out):
    started = time.perf_counter(); core = r.core
    algebra_cases = 0
    # Complete enumeration of all 4-row, 2-contact binary problems. Brute
    # force is an independent TEST oracle, never part of the new constructor.
    tables = list(product((0, 1), repeat=4))
    for c0, c1, target in product(tables, repeat=3):
        proof = r.eliminate([c0, c1], target)
        r.check_identity([c0, c1], target, proof)
        brute = any(all((d+x*a+y*b) % 2 == t for x, y, t in zip(c0, c1, target))
                    for d, a, b in product((0, 1), repeat=3))
        assert (proof['kind'] == 'decomposition') == brute
        algebra_cases += 1
    # Construction is not tied to the previous four-contact search bound.
    columns = [[(i >> bit)&1 for i in range(64)] for bit in range(6)]
    target = [i.bit_count() % 2 for i in range(64)]
    six = r.eliminate(columns, target); r.check_identity(columns, target, six)
    assert sum(six['selected']) == 6
    # Gaussian pivot order is not a minimum-contact claim.
    x = [0, 1, 0, 1]; y = [0, 0, 1, 1]; xy = [a^b for a, b in zip(x, y)]
    nonoptimal = r.eliminate([x, y, xy], xy)
    assert sum(nonoptimal['selected']) == 2  # The last column alone also works.

    source = core.source_reader.read_source(); spec = core.interface(source)
    control = [row['Control'] for row in source['rows']]
    full = list(core.paulis(3)); v = core.paulis(3)
    h_b = {'numerator': core.code(v['IXI']+v['IZI']), 'norm_squared': 2}
    queries = {
        'A_full_future': core.request(spec, control, full),
        'not_A_full_future': core.request(spec, [a^1 for a in control], full),
        'A_Z_after_H': core.request(spec, control, ['IZI'], {'H_B': h_b}),
        'B_full_future': core.request(spec, spec['contacts']['ProbeB'], full),
        'constant_zero': core.request(spec, [0]*8, full),
        'constant_one': core.request(spec, [1]*8, full),
    }
    constructed = {}; circuits = []; branch_count = 0
    for name, query in queries.items():
        with patch.object(core, 'synthesize', side_effect=AssertionError('Unexpected word search')):
            result = r.resolve(spec, query)
        assert result['route'] == 'xor_rule'
        rule = result['rule_result']
        with patch.object(r, 'eliminate', side_effect=AssertionError('Verifier repeated elimination')):
            r.verify(spec, query, rule)
        q = r.compile_result(source, spec, query, rule)
        buf = io.BytesIO(); qpy.dump(q, buf); buf.seek(0); restored, = qpy.load(buf)
        maps = read_gate_instrument(restored); ps = core.projectors(query['values'])
        for raw, k in maps.items():
            if np.any(k):
                a = core.decode_record(spec, query, rule['plan'], sum(bit << i for i, bit in enumerate(raw)))
                assert np.array_equal(k, ps[a])
            branch_count += 1
        circuits.append(restored); constructed[name] = result
    assert constructed['A_full_future']['plan']['word'] == ['ProbeB', 'ProbeParity']
    assert constructed['not_A_full_future']['plan']['derived']['decoder'] == {'0': 1, '1': 0}

    # Outside this linear rule does not mean the question is unknowable.
    conjunction = [row['ProbeB'] & row['ProbeParity'] for row in source['rows']]
    nonlinear_q = core.request(spec, conjunction, ['III'])
    nonlinear = r.resolve(spec, nonlinear_q)
    assert nonlinear['rule_result']['kind'] == 'outside_rule'
    assert nonlinear['route'] == 'bounded_search' and nonlinear['search']['kind'] == 'found'
    assert nonlinear['plan']['read_after'] == [True, True]
    nonlinear_full = r.resolve(spec, core.request(spec, conjunction, full))
    assert nonlinear_full['search']['kind'] == 'not_found_within_bound'
    # Classical access also remains useful for weaker requested futures.
    classical = core.interface(source, coherent=False)
    classical_q = core.request(classical, control, ['III'])
    classical_result = r.resolve(classical, classical_q)
    assert classical_result['rule_result']['kind'] == 'coherent_access_missing'
    assert classical_result['search']['kind'] == 'found'
    residue_q = core.request(spec, [row['Residue'] for row in source['rows']], ['III'])
    residue = r.resolve(spec, residue_q, fallback_bound=None)
    assert residue['route'] == 'rule_inapplicable'

    refused = []
    def reject(name, action):
        try: action()
        except (ValueError, AssertionError): refused.append(name); return
        raise AssertionError('Accepted '+name)
    query = queries['A_full_future']; good = constructed['A_full_future']['rule_result']
    bad = deepcopy(good); bad['algebra']['selected'][0] = 0
    reject('missing cancelling contact', lambda: r.verify(spec, query, bad))
    bad = deepcopy(good); bad['algebra']['offset'] = 1
    reject('unearned complement of the answer', lambda: r.verify(spec, query, bad))
    bad = deepcopy(nonlinear['rule_result']); bad['algebra']['separator'] = [0]*8
    reject('unsupported obstruction', lambda: r.verify(spec, nonlinear_q, bad))
    weak_q = core.request(spec, control, ['III']); bad = r.construct(spec, weak_q)
    bad['plan'] = core.propose(spec, weak_q, ['ProbeB', 'ProbeParity'], [True, True])
    assert bad['plan']['derived']['admitted']
    reject('answer-correct early reading is not the constructed full instrument', lambda: r.verify(spec, weak_q, bad))
    fake = deepcopy(spec); fake['contacts']['ProbeB'] = control
    fake['id'] = core.fingerprint({k: v for k, v in fake.items() if k != 'id'})
    fq = core.request(fake, control, full); fr = r.construct(fake, fq)
    reject('self-consistent fabricated source column', lambda: r.compile_result(source, fake, fq, fr))

    out.mkdir(parents=True, exist_ok=True)
    with (out/'constructed.qpy').open('wb') as f: qpy.dump(circuits, f)
    result = {'schema': 'vi.acquisition-xor-resolve-audit.v1', 'source': source,
              'interface': spec, 'queries': queries, 'constructed': constructed,
              'exhaustive_algebra_cases': algebra_cases, 'six_contact_certificate': six,
              'nonminimum_weight_example': nonoptimal, 'nonlinear_answer_fallback': nonlinear,
              'nonlinear_full_future_fallback': nonlinear_full, 'classical_access_fallback': classical_result,
              'residue_rule_obstruction': residue, 'rejected_mutations': refused,
              'serialized_circuits': len(circuits), 'full_branch_maps': branch_count,
              'operator_residual': 0, 'new_QPU_jobs': 0, 'seconds': time.perf_counter()-started}
    (out/'audit.json').write_text(json.dumps(result, indent=2)+'\n')
    return {k: result[k] for k in ('exhaustive_algebra_cases', 'serialized_circuits', 'full_branch_maps',
                                  'operator_residual', 'rejected_mutations', 'new_QPU_jobs', 'seconds')}


if __name__ == '__main__':
    parser = argparse.ArgumentParser(); parser.add_argument('--out', type=Path, required=True)
    print(json.dumps(run(parser.parse_args().out), indent=2))
