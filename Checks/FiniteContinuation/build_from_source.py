#!/usr/bin/env python3
"""Read the current Swift root, search outside it, return row applications.

The existing JS court reads the source; the existing native court checks the
result too. No new parser, credentials, IBM submission or hardware claim.
"""
import argparse
import json
from pathlib import Path
import subprocess

from planner import synthesize

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]


def run(args):
    r=subprocess.run(list(map(str,args)),cwd=ROOT,check=True,capture_output=True,text=True,timeout=30)
    return r.stdout


def build(directory):
    directory=directory.resolve()
    if directory.exists():raise ValueError('Use a new directory; retain previous acquired/proof artifacts')
    directory.mkdir(parents=True)
    source=json.loads(run(['node',HERE/'court_bridge.js','read']))
    p=source['model'];plan=synthesize(p)
    used_probes=set();used_actions=set()
    def visit(node):
        if node['kind']=='act':used_actions.add(node['action'])
        elif node['kind']=='probe':
            used_probes.add(node['probe'])
            for child in node['branches'].values():visit(child)
        else:raise ValueError('The fixed full T/X request was not resolved')
    visit(plan['tree'])
    program={'schema':'vi.finite-continuation.program.v1',
             'scope':'Current FinitePauliTXSource; exact ideal fixed reusable modules only',
             'request':{'connector':['t'],'consumer':'terminal','axis':'X','old_neutral_XZ_record':None},
             'contacts':[{k:v for k,v in q.items() if k!='replies'} for q in p['probes'] if q['id'] in used_probes],
             'continuations':{k:p['actions'][k] for k in sorted(used_actions)},'plan':plan}
    proposed=directory/'proposal.json';proposed.write_text(json.dumps(program,indent=2)+'\n')
    certificate=directory/'Applications.swift'
    proof=json.loads(run(['node',HERE/'court_bridge.js','check',proposed,certificate]))
    assert proof['source_sha256']==source['source_sha256'],'Root changed during construction'
    native=ROOT/'.build/arm64-apple-macosx/debug/Tools'
    log=run([native,'judge','where',certificate])
    assert '17 equalities' in log and 'THE WHERE holds' in log
    (directory/'native-court.log').write_text(log)

    # Separate interpretation audit: reconstruct complex SDK matrices for the
    # source law read from Swift, not the Python producer's own table.
    from audit import sdk_tables,audit_tree
    independent={**p,'valid':tuple(frozenset(row) for row in p['valid']),
                 'probes':[{**q,'replies':tuple(q['replies'])} for q in p['probes']]}
    rows,replies=sdk_tables(independent)
    audit_tree(plan,rows,replies)
    report={'schema':'vi.current-root-continuation.v1','source_root':'FinitePauliTXSource',
            'proof':proof,'native_court':log.strip(),
            'independent_semantics':{'source_rows':16,'probe_readings':160,'all_source_paths_checked':True},
            'limits':['The T/Pauli physical interpretation is declared and independently matrix-checked, not derived by the type judge.',
                      'The finite query minimum is not proved by these 17 row equalities.',
                      'No noisy outcome is promoted to an exact acquired bit.',
                      'The already submitted IBM campaign remains its separately frozen implementation.']}
    (directory/'source-reading.json').write_text(json.dumps(source,indent=2)+'\n')
    (directory/'proof.json').write_text(json.dumps(report,indent=2)+'\n')
    # Publish only after both current-source applications and interpretation.
    (directory/'program.json').write_text(json.dumps(program,indent=2)+'\n')
    return report


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--output',required=True,type=Path)
    args=parser.parse_args();print(json.dumps(build(args.output),indent=2))
