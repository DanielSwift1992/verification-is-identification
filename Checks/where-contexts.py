#!/usr/bin/env python3
"""Deliver the declared scientific source roster; no Swift source parsing.

Physical context transport and digest stamping remain T0105-C.
"""
import argparse
import hashlib
import json
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument('name', choices=('Light', 'RydbergLadder', 'Grants'))
parser.add_argument('--write', action='store_true')
parser.add_argument('--project')
parser.add_argument('--output')
args = parser.parse_args()
path = Path(__file__).with_name('where-contexts') / (args.name + '.json')
context = json.loads(path.read_text())
for row in context['sources']:
    digest = hashlib.sha256(Path(row['input']).read_bytes()).hexdigest()
    if args.write:
        row['sha256'] = digest
    elif row['sha256'] != digest:
        raise SystemExit(f"{path}:{row['source']}: input digest changed; repair: python3 Checks/where-contexts.py {args.name} --write")
if args.write:
    path.write_text(json.dumps(context, indent=2) + '\n')
if args.project:
    if not args.output:
        parser.error('--project requires --output')
    row = context['sources'][0]
    row['input'] = row['source'] = args.project
    row['sha256'] = hashlib.sha256(Path(args.project).read_bytes()).hexdigest()
if args.output:
    Path(args.output).write_text(json.dumps(context, indent=2) + '\n')
for row in context['sources']:
    print(row['input'])
