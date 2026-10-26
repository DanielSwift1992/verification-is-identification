#!/usr/bin/env python3
"""Repeat the finite Swift/Lean fixture correspondence observations, not a proof.
Normally only writes beneath --output. --freeze also writes the two declared U11 observation artifacts.
This helper is not a CI or repository gate.
"""
import argparse
import hashlib
import json
from pathlib import Path
import shutil
import subprocess
import time

parser = argparse.ArgumentParser()
parser.add_argument('--output', required=True, type=Path)
parser.add_argument('--freeze', action='store_true', help='write the initial frozen observations')
args = parser.parse_args()
project = Path(__file__).resolve().parents[2]
u11 = project / "U11"
repo = project.parents[1]
out = args.output.resolve()
if out.exists() and any(out.iterdir()):
    raise SystemExit('Output must be absent or empty; existing observations are not overwritten')
out.mkdir(parents=True, exist_ok=True)
subprocess.run(['df', '-h', '/System/Volumes/Data'], check=True)
if shutil.disk_usage('/System/Volumes/Data').free < 5 * 1024 ** 3:
    raise SystemExit('STOP: less than 5 GiB free')
sources = sorted((repo / 'Sources/Court').glob('*.swift'))
record_sources = sorted((repo / 'Sources/ContinuationRecord').glob('*.swift'))
inputs = sources + record_sources + [repo / 'Sources/Notation/Primitive.swift',
                   repo / 'Contracts/Court/continuation-relations-v1/repeat-cases.swift',
                   repo / 'Contracts/Court/continuation-relations-v1/contract.json']
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
before = {str(p.relative_to(repo)): sha(p) for p in inputs}
base = '07a4c7fd' # resolved below to a full Git object identity
base = subprocess.check_output(['git', '-C', str(repo), 'rev-parse', base], text=True).strip()
for p in inputs:
    rel = str(p.relative_to(repo))
    pinned = subprocess.check_output(['git', '-C', str(repo), 'show', base + ':' + rel])
    if hashlib.sha256(pinned).hexdigest() != before[rel]:
        raise SystemExit('Source differs from declared contract pin: ' + rel)
cache = out / 'module-cache'
probe = out / 'fixture-probe'
module = out / 'record-module'
module.mkdir()
module_cmd = ['swiftc', '-emit-library', '-static', '-emit-module', '-module-name', 'ContinuationRecord', '-module-cache-path', str(cache), *[str(p) for p in record_sources], '-emit-module-path', str(module/'ContinuationRecord.swiftmodule'), '-o', str(module/'libContinuationRecord.a')]
cmd = ['swiftc', '-I', str(module), '-L', str(module), '-lContinuationRecord', '-module-cache-path', str(cache),
       *[str(p.relative_to(repo)) for p in sources],
       'Proofs/U5/U11/Tools/FixtureProbe.swift', '-o', str(probe)]
start = time.monotonic()
subprocess.run(module_cmd, cwd=repo, check=True)
subprocess.run(cmd, cwd=repo, check=True)
subprocess.run([str(probe), str(repo), str(out / 'observed')], check=True)
observed = out / 'observed'
for a, b in [(observed / 'ContractCases.lean', u11 / 'ContractCases.lean'),
             (observed / 'observations.json', u11 / 'Evidence/contract-observations.json')]:
    if args.freeze:
        b.write_bytes(a.read_bytes())
    if a.read_bytes() != b.read_bytes():
        raise SystemExit('Observation differs from frozen artifact: ' + b.name)
assert before == {str(p.relative_to(repo)): sha(p) for p in inputs}, 'input changed during run'
subprocess.run(['lake', 'build', 'U11.Soundness'], cwd=project, check=True)
subprocess.run(['lake', 'env', 'lean', str(observed / 'ContractCases.lean')], cwd=project, check=True)
rows = json.loads((observed / 'observations.json').read_text())
receipt = dict(sourceRevision=base, sourceSHA256=before,
               driverSHA256=sha(u11 / 'Tools/FixtureProbe.swift'),
               swiftVersion=subprocess.check_output(['swiftc', '--version'], text=True).strip(),
               seconds=round(time.monotonic() - start, 3),
               observations=len(rows), normalizedCertificates=sum(r['scope'].startswith('Swift and Lean') for r in rows), accepted=sum(r['accepted'] for r in rows),
               rejected=sum(not r['accepted'] for r in rows),
               leanSHA256=sha(observed / 'ContractCases.lean'),
               observationSHA256=sha(observed / 'observations.json'),
               archiveSHA256={p.name: sha(p) for p in sorted(observed.glob('*.json'))
                              if p.name != 'observations.json'},
               inputsUnchanged=True, frozenArtifactsMatch=True, leanKernelChecked=True,
               claim='Finite correspondence observations; not a proof of the Swift reader, exporter or checker.')
(out / 'receipt.json').write_text(json.dumps(receipt, ensure_ascii=False, indent=2) + '\n')
# Only this helper's regenerable build products; preserve all observations/receipt.
shutil.rmtree(cache)
probe.unlink()
shutil.rmtree(module)
print(json.dumps({k: receipt[k] for k in ['observations', 'accepted', 'rejected', 'inputsUnchanged', 'frozenArtifactsMatch']}))
