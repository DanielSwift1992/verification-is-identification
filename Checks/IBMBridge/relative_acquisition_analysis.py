#!/usr/bin/env python3
"""All-shot relational decoder: preparation, outgoing source, acquired law.

Keeps these three readings distinct. An outgoing measurement is not promoted
to a trusted value of the source. No postselection or noise-model fitting.
"""

import sys as _evidence_sys
from pathlib import Path as _EvidencePath
_evidence_sys.path.insert(0, str(_EvidencePath(__file__).resolve().parents[1]))
import hardware_runs as _runs
_runs.configure(required=(__name__ == "__main__"))
from collections import defaultdict
import json
import bounded_open_experiment as io

def analyze(run_dir,art):
    plan,_=io.load(run_dir);status=io.read(art/'status.json')
    io.require(status['status']=='DONE','Missing completed result')
    for file,key in [('raw-result.json','raw_sha256'),('provider-result.txt','provider_raw_sha256')]:
        io.require(io.sha((run_dir/file).read_bytes())==status[key],'Evidence changed')
    rows=[]
    for row,entry in zip(status['rows'],plan['PUBs']):
        io.require(all(row[k]==v for k,v in entry.items()),'Source/result mismatch')
        count=defaultdict(int);records=[]
        for key,n in row['counts'].items():
            values=key.split();io.require(len(values)==len(row['registers']),'Missing register')
            d={name:int(value,2) for name,value in zip(row['registers'],values)}
            w=d['witness'];source=d['source_check'];request=d['actual_arrival']
            answer=d.get('actual_a')
            if row['arm']=='two_readings':
                r=d['actual_replies'];answer=(r&1)^((r>>1)&1)
            if row['arm']=='echo':answer=None
            count['shots']+=n;count['B_zero']+=n*((w&1)==0)
            count['data_even']+=n*(((w>>1)&1)==((w>>2)&1))
            count['source_matches_preparation']+=n*(source==row['prepared_a'])
            count['request_matches_preparation']+=n*(request==row['prepared_arrival'])
            if answer is not None:
                count['answer_matches_preparation']+=n*(answer==row['prepared_a'])
                count['answer_matches_outgoing_source']+=n*(answer==source)
            records.append({'request':request,'source':source,'answer':answer,'witness':w,'count':n})
        n=count['shots'];io.require(n==row['shots']==plan['shots_each'],'Wrong shot count')
        rows.append({**entry,**dict(count),'B_X':2*count['B_zero']/n-1,
                     'data_parity':2*count['data_even']/n-1,'decoded_joint_records':records})
    main=[]
    for arm in dict.fromkeys(r['arm'] for r in rows):
        for c in sorted({r['prepared_arrival'] for r in rows}):
            for a in (0,1):
                rr=[r for r in rows if r['arm']==arm and r['prepared_a']==a
                    and r['prepared_b']=='+' and r['prepared_arrival']==c]
                if not rr:continue
                n=sum(r['shots'] for r in rr)
                summary={'arm':arm,'prepared_arrival':c,'prepared_a':a,'shots':n,
                         'B_X':sum(r['B_X']*r['shots'] for r in rr)/n,
                         'source_matches_preparation':sum(r['source_matches_preparation'] for r in rr)/n,
                         'request_matches_preparation':sum(r['request_matches_preparation'] for r in rr)/n}
                for field in ('answer_matches_preparation','answer_matches_outgoing_source'):
                    if all(field in r for r in rr):summary[field]=sum(r[field] for r in rr)/n
                for basis in ('XX','ZZ'):
                    rb=[r for r in rr if r['basis']==basis]
                    if rb:summary[basis]=sum(r['data_parity']*r['shots'] for r in rb)/sum(r['shots'] for r in rb)
                main.append(summary)
    return {'schema':'vi.relative-acquisition-analysis.v1','job_id':status['job_id'],
            'rows':rows,'main_B_plus':main,'shots':sum(r['shots'] for r in rows),
            'scope':'Descriptive all-shot fractions and means; distinct source, preparation and acquired readings. '
                    'No trusted final-source assumption, process-fidelity claim or causal localization to a single component.'}

if __name__=='__main__':
    import relative_acquisition_probe as p
    print(json.dumps(_runs.bind_receipt(analyze(p.PRIVATE,p.ART)),indent=2))
