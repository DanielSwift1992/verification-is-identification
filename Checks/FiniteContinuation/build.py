#!/usr/bin/env python3
"""Build a finite acquisition/continuation program from a public request.

No hidden module choice, QPU access or actual measurement is an input. The
output is an abstract executable tree for planner.execute and a declared
contact interface; it is not yet an IBM hardware job or Swift certificate.
"""
import argparse
import json
from pathlib import Path

from model import GATES, compatible_with_old_memory, problem
from planner import synthesize


def build(connector,consumer,axis,old_memory=None):
    p=problem(tuple(connector),consumer,axis)
    initial=None if old_memory is None else compatible_with_old_memory(old_memory)
    plan=synthesize(p,initial)
    used_probes,used_actions=set(),set()

    def gather(node):
        if node['kind']=='act':
            used_actions.add(node['action'])
        if node['kind']=='probe':
            used_probes.add(node['probe'])
            for child in node['branches'].values():
                gather(child)
    gather(plan['tree'])
    return {'schema':'vi.finite-continuation.program.v1',
            'scope':'Two fixed reusable Pauli modules, ideal trusted Pauli probes, declared Clifford correction/consumer catalog.',
            'request':{'connector':list(connector),'consumer':consumer,'axis':axis,
                       'old_neutral_XZ_record':old_memory},
            'contacts':[{k:v for k,v in probe.items() if k!='replies'}
                        for probe in p['probes'] if probe['id'] in used_probes],
            'continuations':{key:p['actions'][key] for key in sorted(used_actions)},
            'plan':plan}


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--connector',nargs='*',choices=tuple(GATES),default=[])
    parser.add_argument('--consumer',choices=('bare','pauli_frame','clifford_frame','terminal'),required=True)
    parser.add_argument('--axis',choices=('X','Y','Z'),default='Z')
    parser.add_argument('--old-memory',choices=('00','01','10','11'))
    parser.add_argument('--output',type=Path,required=True)
    args=parser.parse_args()
    memory=None if args.old_memory is None else list(map(int,args.old_memory))
    result=build(args.connector,args.consumer,args.axis,memory)
    args.output.parent.mkdir(parents=True,exist_ok=True)
    args.output.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({'request':result['request'],'resource_bounds':result['plan']['tree']['cost'],
                      'output':str(args.output)},indent=2))
