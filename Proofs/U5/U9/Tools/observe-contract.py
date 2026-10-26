#!/usr/bin/env python3
"""Finite Swift/Lean observations for T0120, not a theorem of the bridge.
Run with Swift 6.3.3, own TMPDIR/cache and the shared lockf held by the caller.
Only --output is written. Does not run the repository gates or CI.
"""
import argparse
import hashlib
import json
from pathlib import Path
import shutil
import subprocess
import time

p = argparse.ArgumentParser()
p.add_argument('--output', required=True, type=Path)
a = p.parse_args()
repo = Path(__file__).resolve().parents[4]
project = repo / 'Proofs/U5'
out = a.output.resolve()
if out.exists() and any(out.iterdir()):
    raise SystemExit('Output must be absent or empty; historical receipts are not overwritten')
out.mkdir(parents=True, exist_ok=True)
subprocess.run(['df', '-h', '/'], check=True)
if shutil.disk_usage('/').free < 5 * 1024**3:
    raise SystemExit('STOP: less than 5 GiB free')
base = '07a4c7fdd83f8d79ec0d4ed4111286de33ed1b8f'
core = sorted((repo / 'Sources/ContinuationRecord').glob('*.swift'))
court = sorted((repo / 'Sources/Court').glob('*.swift'))
contract = repo / 'Contracts/Court/continuation-relations-v1'
inputs = core + court + [repo / 'Sources/Notation/Primitive.swift',
    contract / 'image-cases.swift', contract / 'agreement-cases.swift', contract / 'contract.json']
sha = lambda path: hashlib.sha256(path.read_bytes()).hexdigest()
before = {str(path.relative_to(repo)): sha(path) for path in inputs}
for path in inputs:
    raw = subprocess.check_output(['git', '-C', str(repo), 'show', base + ':' + str(path.relative_to(repo))])
    if hashlib.sha256(raw).hexdigest() != before[str(path.relative_to(repo))]:
        raise SystemExit('Input differs from declared base: ' + str(path.relative_to(repo)))
version = subprocess.check_output(['swiftc', '--version'], text=True).strip()
if '6.3.3' not in version:
    raise SystemExit('Expected declared Swift 6.3.3')
probe_source = project / 'U9/Tools/FixtureProbe.swift'
started = time.monotonic()
lib = out / 'libContinuationRecord.dylib'
module = out / 'ContinuationRecord.swiftmodule'
probe = out / 'fixture-probe'
subprocess.run(['swiftc', '-emit-module', '-emit-library', '-module-name', 'ContinuationRecord',
    *map(str, core), '-o', str(lib), '-emit-module-path', str(module)], check=True)
subprocess.run(['swiftc', '-I', str(out), '-L', str(out), '-lContinuationRecord',
    '-Xlinker', '-rpath', '-Xlinker', str(out), *map(str, court), str(probe_source),
    '-o', str(probe)], check=True)
subprocess.run([str(probe), str(repo), str(out / 'observed')], check=True)
rows = {}
for section, namespace in [('image','U9'),('agreement','U10')]:
    generated = out / 'observed' / (section + '-ContractCases.lean')
    subprocess.run(['lake','env','lean',str(generated)], cwd=project, check=True)
    frozen = project / namespace / 'ContractCases.lean'
    if frozen.exists() and generated.read_bytes() != frozen.read_bytes():
        raise SystemExit('Observation differs from frozen Lean artifact: ' + namespace)
    observed = out / 'observed' / (section + '-observations.json')
    frozen_rows = project / namespace / 'Evidence/contract-observations.json'
    if frozen_rows.exists() and observed.read_bytes() != frozen_rows.read_bytes():
        raise SystemExit('Observation differs from frozen Swift artifact: ' + namespace)
    values = json.loads(observed.read_text())
    rows[section] = dict(contractCases=len(json.loads((contract / 'contract.json').read_text())[section]['cases']),
        observations=len(values), readingOnly=sum(r['layer']=='Swift reading only' for r in values),
        normalized=sum(r['layer']=='normalized certificate' for r in values),
        accepted=sum(r['accepted'] for r in values), rejected=sum(not r['accepted'] for r in values),
        leanSHA256=sha(generated), observationsSHA256=sha(observed))
after = {str(path.relative_to(repo)): sha(path) for path in inputs}
if before != after:
    raise SystemExit('Source changed during qualification')
receipt = dict(sourceRevision=base, sourceSHA256=before, inputsUnchanged=True,
    driverSHA256=sha(probe_source), helperSHA256=sha(Path(__file__)), swiftVersion=version,
    binarySHA256={"fixture-probe":sha(probe),"libContinuationRecord":sha(lib)},
    seconds=round(time.monotonic()-started,3), cases=rows,
    archiveSHA256={path.name:sha(path) for path in sorted((out/'observed').glob('*.json'))
        if not path.name.endswith('observations.json')},
    claim='Finite correspondence of normalized certificates; not a proof of Swift, its reader, exporter, JSON, or toolchain.')
(out/'receipt.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n')
print(json.dumps(rows,ensure_ascii=False))
