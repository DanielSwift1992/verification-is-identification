#!/usr/bin/env python3
"""Synthetic archives exercise the offline analyser, without QPU submissions.

These fixtures are deliberately generated, never hardware evidence. Temporary
files vanish after the check. The SDK encodes/decodes actual BitArray objects.
"""
import json
from pathlib import Path
from tempfile import TemporaryDirectory

from qiskit.primitives.containers import BitArray, DataBin, PrimitiveResult, SamplerPubResult
from qiskit_ibm_runtime import RuntimeEncoder

from analyse_hardware import analyse, digest
from model import WORLDS, problem
from noisy import Evidence


def write(path,value):path.write_text(json.dumps(value,indent=2)+'\n')


def fixture(path,*,wrong_validation=False,acquisition_errors=0):
    assert 0<=acquisition_errors<=4
    p=problem(('t',),'terminal','X')
    spec={'cases':[{'episode':str(i),'fixture':list(w)} for i,w in enumerate(WORLDS)],
          'backend':'SYNTHETIC-NO-QPU','wire':45,'family_alpha':'1/100',
          'per_episode_alpha':'1/1600','assumed_conditional_probe_error_upper_bound':'1/5',
          'max_acquisition_rounds':4,'batch_shots':16,'validation_shots':256}
    write(path/'campaign.json',spec)
    engines={str(i):Evidence(p,episode=str(i),alpha='1/1600',epsilon='1/5',max_shots=64)
             for i in range(16)}
    for index in range(3):
        kind='acquisition' if index<2 else 'validation'
        shots=16 if kind=='acquisition' else 256
        job_id=f'SYNTHETIC-{index}'
        tag=f'synthetic-round-{index}'
        descriptors=[];pubs=[];rows=[]
        before=json.loads(json.dumps({key:e.export() for key,e in engines.items()}))
        for key,e in engines.items():
            decision=e.decision()
            if kind=='acquisition':
                assert decision['kind']=='probe'
                bit=next(q for q in p['probes'] if q['id']==decision['probe'])['replies'][int(key)]
                reads=[({'probe':decision['probe']},bit)]
            else:
                assert decision['kind']=='act'
                correction=int(decision['execution']['sign']==-1)
                reads=[({'target_bit':b,'action':decision['action'],'execution':decision['execution']},
                        b^correction^wrong_validation) for b in (0,1)]
            for fields,bit in reads:
                n=len(descriptors)
                d={'episode':key,'kind':kind,'round':index,'pub':n,'tag':tag,**fields}
                descriptors.append(d)
                samples=[str(bit)]*shots
                if kind=='acquisition':samples=[str(1-bit)]*acquisition_errors+samples[acquisition_errors:]
                pubs.append(SamplerPubResult(DataBin(c=BitArray.from_samples(samples)),
                                            metadata={'circuit_metadata':d}))
                from collections import Counter
                row={**d,'batch_id':job_id+':'+str(n),'shots':shots,'counts':dict(Counter(samples))}
                rows.append(row)
                if kind=='acquisition':
                    e.acquire({k:row[k] for k in ('episode','batch_id','probe','shots','counts')})
        round_path=path/f'round-{index:02}';round_path.mkdir()
        plan={'round':index,'kind':kind,'tag':tag,'shots':shots,'descriptors':descriptors,
              'decisions_before':before,'campaign_sha256':digest(path/'campaign.json'),
              'previous_results':{str(f.relative_to(path)):digest(f) for f in path.glob('round-*/hardware-result.json')}}
        write(round_path/'plan.json',plan)
        write(round_path/'ledger.json',{'job_id':job_id})
        (round_path/'raw-result.json').write_text(json.dumps(PrimitiveResult(pubs),cls=RuntimeEncoder))
        write(round_path/'hardware-result.json',{'kind':kind,'status':'DONE','job_id':job_id,
             'rows':rows,'raw_sha256':digest(round_path/'raw-result.json'),
             'usage_after':{'usage_remaining_seconds':100-index},
             'metrics':{'timestamps':{'created':'2026-09-14T00:00:00Z','running':'2026-09-14T00:00:01Z',
                                      'finished':'2026-09-14T00:00:02Z'},
                        'usage':{'qpu_charge_time_seconds':1}}})


def checks():
    with TemporaryDirectory(prefix='vi-synthetic-analysis-') as tmp:
        path=Path(tmp);fixture(path)
        result=analyse(path)
        assert result['summary']['correct_logical_actions']==16
        assert result['summary']['acquisition_shots']==512
        assert result['summary']['validation_correct']==8192
        assert result['summary']['all_32_descriptive_validation_checks_pass']
        assert {e['retained_source_count'] for e in result['episodes']}=={4}

        def rejected(name,file,mutate):
            target=path/file;original=target.read_bytes()
            data=json.loads(original);mutate(data);write(target,data)
            try:
                try:analyse(path)
                except (AssertionError,ValueError,KeyError):return name
                raise RuntimeError('Accepted '+name)
            finally:target.write_bytes(original)

        failures=[
            rejected('missing acquired prefix','round-01/plan.json',lambda d:d['previous_results'].clear()),
            rejected('wrong data-selected second probe','round-01/plan.json',
                     lambda d:d['descriptors'][0].update(probe='A:Z:Z')),
            rejected('forged selected continuation','round-02/plan.json',
                     lambda d:d['decisions_before']['0']['decision'].update(action='forged')),
            rejected('duplicate validation occurrence','round-02/plan.json',
                     lambda d:d['descriptors'].__setitem__(1,d['descriptors'][0])),
            rejected('different provider job','round-02/ledger.json',lambda d:d.update(job_id='other')),
            rejected('modified raw counts','round-02/hardware-result.json',
                     lambda d:d['rows'][0].update(counts={'0':128,'1':128})),
        ]
    with TemporaryDirectory(prefix='vi-synthetic-failing-validation-') as tmp:
        path=Path(tmp);fixture(path,wrong_validation=True)
        result=analyse(path)
        assert result['summary']['correct_logical_actions']==16
        assert result['summary']['validation_correct']==0
        assert not result['summary']['all_32_descriptive_validation_checks_pass']
    return {'scope':'Synthetic analyser test, zero hardware submissions',
            'ideal_episodes':16,'retained_sources_per_episode':4,
            'detected_archive_errors':failures,
            'valid_logical_selection_does_not_hide_failed_physical_validation':True}


if __name__=='__main__':print(json.dumps(checks(),indent=2))
