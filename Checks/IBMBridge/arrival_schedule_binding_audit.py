#!/usr/bin/env python3
"""Offline, family-scoped admission check for returned scheduler evidence.

No provider, RuntimeDecoder or shot statistics are used to classify timings.
This is not a general equivalence proof between circuits and pulse schedules.
"""

import sys as _evidence_sys
from pathlib import Path as _EvidencePath
_evidence_sys.path.insert(0, str(_EvidencePath(__file__).resolve().parents[1]))
import hardware_runs as _runs
_runs.configure(required=(__name__ == "__main__"))
import csv
import io
import json
from pathlib import Path
from qiskit import qpy

ROOT=_runs.owned(__file__).resolve().parents[2]
PRIVATE=_runs.path('ibm-arrival-localization-20260916')
ART=ROOT/'Research/Artifacts/arrival-failure-localization-20260916'


def classify(reset, scratch, conditional_cz):
    if conditional_cz and reset and scratch:return 'conditional'
    if not conditional_cz and reset and scratch:return 'slots_only'
    if not conditional_cz and not reset and scratch:return 'slots_no_reset'
    if not conditional_cz and not reset and not scratch:return 'echo'
    return 'unclassified'


def source_signature(q):
    signature={'reset':False,'scratch':False,'conditional_cz':False}
    def walk(body,wires,inside=False):
        for item in body.data:
            op=item.operation;qs=[wires[body.find_bit(b).index] for b in item.qubits]
            if op.name=='reset' and qs==[14]:signature['reset']=True
            if op.name=='measure_2' and qs==[14]:signature['scratch']=True
            if op.name=='cz' and inside:signature['conditional_cz']=True
            for block in getattr(op,'blocks',()):walk(block,qs,True)
    walk(q,list(range(q.num_qubits)))
    return signature


def timing_signature(raw):
    lines=raw.splitlines() if isinstance(raw,str) else raw
    rows=[next(csv.reader([x])) for x in lines if x.strip()]
    assert rows and all(len(x)==6 for x in rows)
    flags={'reset':any(x[1]=='reset_14' for x in rows),
           'scratch':any(x[1]=='measure_2_14' for x in rows),
           'conditional_cz':any(x[0]!='main' and x[1].startswith('cz_') for x in rows)}
    return flags


def audit():
    p=json.loads((PRIVATE/'provider-result.txt').read_text())
    assert p['__type__']=='PrimitiveResult'
    pubs=p['__value__']['pub_results']
    with (PRIVATE/'isa.qpy').open('rb') as f:qs=qpy.load(f)
    assert len(qs)==len(pubs)==40
    rows=[]
    for i,(q,pub) in enumerate(zip(qs,pubs)):
        assert pub['__type__']=='SamplerPubResult'
        metadata=pub['__value__']['metadata']
        assert metadata['circuit_metadata']==q.metadata
        source=source_signature(q)
        raw=metadata['compilation']['scheduler_timing']['timing']
        returned=timing_signature(raw)
        wanted=classify(**source);got=classify(**returned)
        assert wanted==q.metadata['arm']
        rows.append({'pub_index_zero_based':i,'source_arm':wanted,'returned_schedule_arm':got,
                     'source_features':source,'returned_features':returned,
                     'consistent':source==returned})
    groups=[]
    for start in range(0,40,4):
        block=rows[start:start+4]
        groups.append({'pub_indices':list(range(start,start+4)),
                       'returned_order':[r['returned_schedule_arm'] for r in block],
                       'same_four_arm_multiset':sorted(r['source_arm'] for r in block)==
                                                sorted(r['returned_schedule_arm'] for r in block)})
    mismatch=[r['pub_index_zero_based'] for r in rows if not r['consistent']]
    return {'schema':'vi.arrival-schedule-binding-audit.v1','job_id':'dal8qok62pvc739qjtv0',
            'pubs':40,'mismatch_count':len(mismatch),'mismatched_indices':mismatch,
            'provider_circuit_metadata_matches_submitted':True,
            'checked_before_RuntimeDecoder':True,'rows':rows,'groups':groups,
            'timing_admitted_for_causal_analysis':not mismatch,
            'limits':'Family-scoped structural incompatibility in returned metadata. Does not establish '
                     'whether measurement arrays were reordered, or why the older hardware result failed. '
                     'Do not silently permute timings or measurement data to obtain a preferred result.'}


def require_current_binding():
    result=audit()
    if not result['timing_admitted_for_causal_analysis']:
        raise ValueError('Returned schedule/PUB binding failed: '+str(result['mismatch_count'])+' of 40; no timing-derived follow-up')
    return result


if __name__=='__main__':
    result=audit();print(json.dumps(_runs.bind_receipt(result),indent=2))
