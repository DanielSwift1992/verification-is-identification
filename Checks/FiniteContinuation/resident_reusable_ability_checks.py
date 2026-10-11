#!/usr/bin/env python3
"""Repeat discovered abilities and expose the price of a closed memory view."""
from copy import deepcopy
import json
import time

import resident_reusable_ability as r
from resident_boundary_composition_checks import question, branch_audit, samples
from resident_raw_reply_checks import fixture

OUT = r.c.s.ROOT/'Research/Artifacts/resident-reusable-ability-20260915'


def run():
    started = time.perf_counter()
    source = r.c.s.reading()
    query = question(source, [170])
    direct = r.represented_boundary(source)
    turned = r.represented_boundary(source, 'turned')
    learned = r.discover(source, direct, query)
    library = r.Library(source)
    identifier = library.add(learned)
    # Contents may be persisted and loaded; no ownership right is serialized.
    loaded = json.loads(json.dumps(learned))
    assert library.add(loaded) == identifier
    cases = []
    service, kraus, _ = fixture(1.3, -.8)
    for presentation, ports in [('direct', (0, 1, 2, 3, 4)), ('turned', (2, 4, 0, 1, 3))]:
        assembly = r.c.Assembly(source, service)
        cut = assembly.prepare_first(presentation=presentation, ports=ports)
        if cut.contract != direct:
            cut = assembly.recode(cut, r.c.recoding(source, cut.contract, direct))
        original_search = r.c.joint.synthesize
        r.c.joint.synthesize = lambda *a, **k: (_ for _ in ()).throw(AssertionError('Repeated synthesis'))
        try:
            for _ in range(3):
                found = library.find(cut.contract, query)
                assert found == learned
                cut = r.apply(assembly, cut, found)
                assert cut.contract == direct
        finally:
            r.c.joint.synthesize = original_search
        q = assembly.program(cut)
        audit, _ = branch_audit(source, q, ports, kraus, [query]*3, 3, cut)
        audit.update(presentation=presentation, ports=list(ports), repetitions=3,
                     interface_memory_bits=cut.contract['memory_width'],
                     total_allocated_classical_bits=q.num_clbits,
                     local_execution=samples(q, ports, 64))
        cases.append(audit)
    assembly = r.c.Assembly(source, service)
    cut = assembly.prepare_first()
    before = assembly.program(cut)
    attempted = []
    def no(name, fn):
        try:
            fn()
        except (ValueError, KeyError, TypeError):
            attempted.append(name)
            return
        raise AssertionError('Accepted '+name)
    bad = deepcopy(learned)
    bad['price']['source_calls_upper_bound'] = 0
    no('rename erased the source-call price', lambda: library.add(bad))
    bad = deepcopy(learned)
    bad['remaining_memory']['mapping'] = [None]*len(bad['remaining_memory']['mapping'])
    no('unread remaining memory', lambda: r.apply(assembly, cut, bad))
    bad = deepcopy(learned)
    bad['remaining_memory']['input'] = direct
    no('memory reading substituted another exit', lambda: r.apply(assembly, cut, bad))
    singleton = r.c.schema(source, [[i] for i in range(8)])
    no('full source invented from First', lambda: r.c.recoding(source, direct, singleton))
    assert r.c.digest_circuit(before) == r.c.digest_circuit(assembly.program(cut))

    # Acquisition has made Last known. Recode to First discards that fact,
    # while preserving universal bounded solvability of future exit queries.
    raw_cut = assembly.extend(cut, learned['recipe'])
    retained = r.c.recipe(source, raw_cut.contract, query)
    assert max(c['worst_case_contacts'] for c in retained['certificates'] if c) == 0
    closed_cut = assembly.recode(raw_cut, learned['remaining_memory'])
    forgotten = r.c.recipe(source, closed_cut.contract, query)
    assert max(c['worst_case_contacts'] for c in forgotten['certificates'] if c) == 1
    # Full-state memory at this exit needs no new source call; its content was
    # already acquired. This is a second valid output contract, not a repair
    # by pretending the initial First boundary contained Last.
    full = r.discover(source, direct, query, singleton)
    assert full['price'] == learned['price']
    current_last = r.c.recipe(source, singleton, query)
    assert all(c['worst_case_contacts'] == 0 for c in current_last['certificates'])
    for mask in range(256):
        all_exit = r.c.recipe(source, direct, question(source, [mask]))
        assert all(c['worst_case_contacts'] in (0, 1) for c in all_exit['certificates'])

    result = {'schema': 'vi.reusable-ability-audit.v1', 'ability_id': identifier,
              'stored_recipe_price': learned['price'], 'cases': cases,
              'negative_cases': attempted, 'repeat_search_disabled': True,
              'cost_boundary': {'Last_after_retaining_acquired_memory': 0,
                               'Last_after_normalizing_to_First': 1,
                               'full_monitor_output_bits': 3,
                               'full_monitor_extra_acquisition_cost_at_this_exit': 0,
                               'First_exit_tables_with_bound_at_most_one': 256},
              'source_sha256': source['source_sha256'], 'seconds': time.perf_counter()-started,
              'scope': 'Reusable construction recipes and source-call price. '
                       'Persistent interface bits are not total allocated scratch bits. '
                       'No QPU execution and no optimality claim for normalized sequences.'}
    OUT.mkdir(exist_ok=True)
    (OUT/'ability.json').write_text(json.dumps(learned, indent=2)+'\n')
    (OUT/'audit.json').write_text(json.dumps(result, indent=2)+'\n')
    print(json.dumps(result, indent=2))


if __name__ == '__main__':
    run()
