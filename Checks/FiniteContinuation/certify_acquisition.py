#!/usr/bin/env python3
"""Return a replayed acquisition family to the current type-level source.

Public entry accepts an archive, never a user-selected subset or answer. Raw
acquisitions are replayed through the existing statistical method. One chosen
action must then pass exact current-row applications for the complete family.
No cloud operations. These certificates do not assert real-source membership.
"""
import argparse
import hashlib
import json
from pathlib import Path

from analyse_hardware import replay_acquired_prefix
from build_from_source import HERE,ROOT,run


def write(path,data):path.write_text(json.dumps(data,indent=2)+'\n')
def digest(path):return hashlib.sha256(path.read_bytes()).hexdigest()


def archive_identity(directory):
    files=[directory/'campaign.json']
    for p in sorted(directory.glob('round-*')):
        files.extend(p/name for name in ('plan.json','ledger.json','raw-result.json','hardware-result.json') if (p/name).exists())
    return {str(p.relative_to(directory)):digest(p) for p in files}


def apply_evidence(e,directory,source_hashes):
    """Generic boundary: uncertainty stays in e; only a conditional action is proved."""
    decision=e.decision();family=list(e.family())
    snapshot=e.export()
    if not family:return {'outcome':'model_conflict','evidence':snapshot}
    if decision['kind']!='act':
        outcome='needs_evidence' if decision['kind'] in ('probe','needs_evidence') else decision['kind']
        return {'outcome':outcome,'evidence':snapshot}
    proposal={'schema':'vi.current-family-proposal.v1',
              'request':{'connector':['t'],'consumer':'terminal','axis':'X'},
              'family':family,'action':decision['action'],'execution':decision['execution']}
    directory.mkdir(parents=True)
    file=directory/'proposal.json';write(file,proposal)
    certificate=directory/'Applications.swift'
    proof=json.loads(run(['node',HERE/'court_bridge.js','family',file,certificate]))
    if proof['source_sha256']!=source_hashes:raise ValueError('Current type source changed during application')
    log=run([ROOT/'.build/arm64-apple-macosx/debug/Tools','judge','where',certificate])
    if f"{len(family)+1} equalities" not in log or 'THE WHERE holds' not in log:
        raise ValueError('Native court did not accept every retained row')
    (directory/'native-court.log').write_text(log)
    return {'outcome':'conditional_continuation','evidence':snapshot,'proposal':proposal,
            'proposal_sha256':digest(file),'proof':proof,'native_court':log.strip(),
            'condition':'The actual fixed source belongs to the complete replayed retained family.'}


def certify(directory,output,*,require_real_campaign=True):
    if output.exists():raise ValueError('Use a new output directory')
    if require_real_campaign:
        from hardware import campaign
        campaign(directory,current=True)  # Frozen request, implementation and free scope; no network.
    identity=archive_identity(directory)
    source=json.loads(run(['node',HERE/'court_bridge.js','read']));p=source['model']
    # Validate the declared physical interpretation independently, before using
    # its current rows to interpret records from the earlier frozen adapter.
    from audit import sdk_tables
    sdk_tables({**p,'valid':tuple(frozenset(x) for x in p['valid']),
                'probes':[{**q,'replies':tuple(q['replies'])} for q in p['probes']]})
    replay=replay_acquired_prefix(directory,p,allow_pending=True)
    output.mkdir(parents=True)
    episodes=[]
    for index,(episode,e) in enumerate(replay['engines'].items()):
        row=apply_evidence(e,output/f'episode-{index:02}',source['source_sha256'])
        episodes.append({'episode':episode,**row})
    if identity!=archive_identity(directory):raise ValueError('Acquisition prefix changed during certification; no result published')
    current=json.loads(run(['node','-e',
        "console.log(JSON.stringify(require('./Checks/FiniteContinuation/court_bridge.js').context().fingerprints))"]))
    if current!=source['source_sha256']:raise ValueError('Current type source changed; no result published')
    write(output/'source-reading.json',source)
    report={'schema':'vi.acquired-family-continuations.v1',
            'scope':'Actual acquired archive' if require_real_campaign else 'Explicitly synthetic archive test',
            'source_root':'FinitePauliTXSource','source_sha256':source['source_sha256'],
            'bridge_sha256':{str(p.relative_to(ROOT)):digest(p) for p in (
                HERE/'certify_acquisition.py',HERE/'analyse_hardware.py',HERE/'court_bridge.js',
                HERE/'noisy.py',ROOT/'.build/arm64-apple-macosx/debug/Tools')},
            'acquired_archive_sha256':identity,'pending':replay['pending'],
            'episodes':episodes,'summary':{
                'episodes':len(episodes),
                'conditional_continuations':sum(r['outcome']=='conditional_continuation' for r in episodes),
                'needs_evidence':sum(r['outcome']=='needs_evidence' for r in episodes),
                'model_conflicts':sum(r['outcome']=='model_conflict' for r in episodes),
                'acquired_shots':sum(e.shots for e in replay['engines'].values())},
            'coverage':{'family_alpha':replay['spec']['family_alpha'],
                        'assumed_conditional_error_upper_bound':replay['spec']['assumed_conditional_probe_error_upper_bound'],
                        'noise_assumption_independently_established':False,
                        'statement':'If the declared acquisition condition holds, the probability of ever publishing a logically unsuitable continuation is at most family_alpha. This is not an execution-error or posterior-truth probability.'},
            'not_established':['Actual source membership by the type checker','Physical execution accuracy',
                               'Applicability after an unaccounted source change']}
    write(output/'result.json',report)
    return report


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--input',type=Path,required=True);parser.add_argument('--output',type=Path,required=True)
    args=parser.parse_args();report=certify(args.input.resolve(),args.output.resolve())
    print(json.dumps({'summary':report['summary'],'pending':report['pending'],'coverage':report['coverage']},indent=2))
