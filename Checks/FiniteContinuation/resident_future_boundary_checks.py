#!/usr/bin/env python3
"""Use future promises to retain a cheaper continuation at the same bit width."""
from copy import deepcopy
import json
import time

import resident_future_boundary as f
import resident_reusable_ability as reuse
from resident_boundary_composition_checks import question, branch_audit, samples
from resident_boundary_symbolic import audit as word_audit
from resident_raw_reply_checks import fixture

OUT = f.c.s.ROOT/'Research/Artifacts/resident-future-boundary-20260915'


def run():
    began = time.perf_counter()
    source = f.c.s.reading()
    service, kraus, _ = fixture(1.3, -.8)
    initial = reuse.represented_boundary(source)
    catalogues = {'first': [204], 'last': [170], 'both': [204,170],
                  'common_pair': [254,239], 'all_binary': list(range(256))}
    contracts = {name:f.derive(source, [[(mask>>i)&1 for i in range(8)] for mask in masks])
                 for name,masks in catalogues.items()}
    assert [f.verify(source, contracts[name])['final_classes'] for name in catalogues] == [4,4,8,6,8]
    cases = []
    for name in ['last', 'common_pair']:
        query = question(source, catalogues[name])
        wanted = contracts[name]['boundary']
        first = reuse.discover(source, initial, query, wanted)
        later = reuse.discover(source, wanted, query)
        assert later['price']['source_calls_upper_bound'] == 0
        library = reuse.Library(source)
        library.add(first); library.add(later)
        assembly = f.c.Assembly(source, service)
        cut = assembly.prepare_first(presentation='turned', ports=(2,4,0,1,3))
        cut = assembly.recode(cut, f.c.recoding(source, cut.contract, initial))
        synth = f.c.joint.synthesize
        f.c.joint.synthesize = lambda *a, **k: (_ for _ in ()).throw(AssertionError('Reused builder searched'))
        try:
            selected_prices = []
            for _ in range(4):
                ability = library.find(cut.contract, query)
                assert ability is not None
                selected_prices.append(ability['price']['source_calls_upper_bound'])
                cut = reuse.apply(assembly, cut, ability)
        finally:
            f.c.joint.synthesize = synth
        assert selected_prices == [1,0,0,0]
        circuit = assembly.program(cut)
        checked, _ = branch_audit(source, circuit, cut._ports, kraus, [query]*4, 3, cut)
        checked.update(catalogue=name, selected_contact_bounds=selected_prices,
                       interface_states=f.verify(source, contracts[name])['final_classes'],
                       interface_bits=cut.contract['memory_width'],
                       formal_words=word_audit(assembly, cut, [query]*4),
                       local_execution=samples(circuit, cut._ports, 64))
        cases.append(checked)

    # Choosing Last at the same two-bit budget really relinquishes First.
    last = contracts['last']['boundary']
    missing = f.c.recipe(source, last, question(source, [204]))
    assert not missing['applicable']
    assert all(cert['obstruction_kind'] == 'no_common_answer_on_any_finite_transcript'
               for cert in missing['certificates'] if cert)
    bad = deepcopy(contracts['common_pair'])
    bad['certificate']['classes'][1] = bad['certificate']['classes'][0]
    try:
        f.verify(source, bad)
    except ValueError:
        refused = True
    else:
        raise AssertionError('Undocumented merging accepted')
    output = {'schema':'vi.future-boundary-audit.v1',
              'minimal_stable_states':{name:f.verify(source,v)['final_classes'] for name,v in contracts.items()},
              'cases':cases, 'First_not_recoverable_from_Last':True,
              'unjustified_merge_refused':refused,
              'source_sha256':source['source_sha256'], 'seconds':time.perf_counter()-began,
              'scope':'Least autonomous refinement for declared immediate future readings; '
                      'not least memory for eventual acquisition. No QPU call.'}
    OUT.mkdir(exist_ok=True)
    (OUT/'contracts.json').write_text(json.dumps(contracts,indent=2)+'\n')
    (OUT/'audit.json').write_text(json.dumps(output,indent=2)+'\n')
    print(json.dumps(output,indent=2))


if __name__ == '__main__':
    run()
