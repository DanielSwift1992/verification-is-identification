#!/usr/bin/env python3
"""Build/run orchestration only. The finite continuation planner is Swift.

No dependency installation, cloud call, credentials, or general Swift parser.
"""

import sys as _evidence_sys
from pathlib import Path as _EvidencePath
_evidence_sys.path.insert(0, str(_EvidencePath(__file__).resolve().parents[1]))
import hardware_runs as _runs
_runs.configure(required=False)
import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import signal
import subprocess
import sys
import time
from datetime import datetime, timezone

HERE = _runs.owned(__file__).resolve().parent
ROOT = HERE.parent.parent

def utc():
    return datetime.now(timezone.utc).isoformat()

def run_bounded(command, timeout, cwd=ROOT):
    """Kill the subprocess group on timeout, including compiler children."""
    with subprocess.Popen([str(x) for x in command], cwd=str(cwd),
                          stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                          text=True, start_new_session=True) as process:
        try:
            output, _ = process.communicate(timeout=timeout)
        except BaseException:
            try:
                os.killpg(process.pid, signal.SIGKILL)
            except ProcessLookupError:
                pass
            process.communicate()
            raise
        return subprocess.CompletedProcess(command, process.returncode, output)

def notation_sources():
    return sorted((ROOT / "Sources/Notation").glob("*.swift"))

def compilation_sources(mode):
    """The actual compiler inputs, shared by fresh builds and local reuse."""
    core = sorted((ROOT / 'Sources/VerificationIsIdentification').glob('*.swift'))
    common = [ROOT/'Sources/Examples/QuantumContinuation.swift', HERE/'Adapter.swift', HERE/'Cases.swift']
    if mode == 'coherent':
        common += [ROOT/'Sources/Examples/QuantumCoherentControl.swift', HERE/'CoherentAdapter.swift', HERE/'CoherentCases.swift']
        exporter = HERE/'CoherentExport.swift'
    elif mode == 'acquisition':
        common += [HERE/'Planner.swift', ROOT/'Sources/Examples/QuantumAcquisition.swift', HERE/'AcquisitionAdapter.swift', HERE/'AcquisitionCases.swift']
        exporter = HERE/'AcquisitionExport.swift'
    else:
        common += [HERE/'Planner.swift', HERE/'Extra.swift']
        exporter = HERE/'Export.swift'
    return core, common, exporter

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=_runs.owned)
    parser.add_argument('--acquisition', action='store_true',
                        help='Build the source-bound terminal-acquisition extension')
    parser.add_argument('--coherent', action='store_true',
                        help='Build exact coherent data/joint continuation witnesses')
    parser.add_argument('--prepare-only', action='store_true',
                        help='Produce checked exports; do not run SDK or research regressions')
    args = parser.parse_args()
    if args.acquisition and args.coherent:
        parser.error('--acquisition and --coherent are separate scopes')
    prefix = 'braket-coherent-' if args.coherent else ('braket-acquisition-' if args.acquisition else 'braket-bridge-')
    if args.output is None:
        parser.error('pass --output DIR for new build artifacts; archived evidence is read-only')
    out = args.output.resolve()
    if out.exists() and any(out.iterdir()):
        raise SystemExit('Output directory must be new or empty: ' + str(out))
    out.mkdir(parents=True, exist_ok=True)
    logs = out / 'logs'; logs.mkdir()
    lib = out / 'library'; lib.mkdir()
    mode = 'coherent' if args.coherent else ('acquisition' if args.acquisition else 'continuation')
    core, common, exporter = compilation_sources(mode)
    inputs = notation_sources() + core + common + [exporter, HERE/'build.py', _runs.owned(_runs.__file__)]
    if not args.prepare_only:
        inputs += sorted(HERE.glob('*.swift')) + sorted(HERE.glob('*.py')) + [HERE/'run.sh']
    hashes = {_runs.address(p, ROOT): hashlib.sha256(p.read_bytes()).hexdigest() for p in inputs}
    manifest = {'schema':'vi.braket.build.v1','started_at':utc(), 'output':str(out),
                'mode':mode, 'scope':'checked-exports' if args.prepare_only else 'research-regression',
                'python':sys.executable,'source_sha256':hashes,'steps':[], 'status':'running'}
    def step(name, command, timeout=90):
        start=time.monotonic()
        try:
            result=run_bounded(command, timeout)
        except subprocess.TimeoutExpired as e:
            (logs/(name+'.log')).write_text(str(e))
            raise RuntimeError(name+' infrastructure timeout (not a proof of refusal)')
        (logs/(name+'.log')).write_text(result.stdout)
        manifest['steps'].append({'name':name,'seconds':time.monotonic()-start,'returncode':result.returncode})
        print(name+': '+str(result.returncode), flush=True)
        if result.returncode:
            raise RuntimeError(name+' failed; see '+str(logs/(name+'.log')))
    def save():
        (out/'build-manifest.json').write_text(json.dumps(_runs.bind_receipt(manifest, destination=out/'build-manifest.json'),indent=2)+'\n')
    try:
        step('versions',['swiftc','--version'])
        if not args.prepare_only:
            step('sdk-preflight',[sys.executable,'-c','import braket.devices; import braket.ir.openqasm; import importlib.metadata as m; print(m.version("amazon-braket-sdk")); print(m.version("amazon-braket-default-simulator"))'])
        step('fresh-notation-library',['swiftc','-emit-library','-emit-module','-parse-as-library',
            '-module-name','Notation',*notation_sources(),'-emit-module-path',lib/'Notation.swiftmodule',
            '-o',lib/'libNotation.dylib'])
        step('fresh-core-library',['swiftc','-emit-library','-emit-module','-parse-as-library',
            '-module-name','VerificationIsIdentification','-I',lib,'-L',lib,'-lNotation',
            '-Xlinker','-rpath','-Xlinker',lib,*core,'-emit-module-path',lib/'VerificationIsIdentification.swiftmodule',
            '-o',lib/'libVerificationIsIdentification.dylib'])
        flags=['swiftc','-I',lib,'-L',lib,'-lVerificationIsIdentification','-lNotation','-Xlinker','-rpath','-Xlinker',lib]
        step('compile-proposal',[*flags,*common,exporter,'-o',out/'export'])
        step('derive-and-export',[out/'export',out])
        certificates=out/('CoherentCertificates.swift' if args.coherent else 'Certificates.swift')
        consumer=out/('CheckedCoherentExport.swift' if args.coherent else 'CheckedExport.swift')
        step('compile-row-applications',[*flags,*common,certificates,consumer,'-o',out/'checked-export'])
        step('export-checked-continuation',[out/'checked-export',out if args.coherent else out/'continuations.json'])
        static=HERE/('coherent_static_checks.py' if args.coherent else ('acquisition_static_checks.py' if args.acquisition else 'static_checks.py'))
        if not args.prepare_only:
            step('static-adversaries',[sys.executable,static,'--artifacts',out,'--library',lib],timeout=240)
            step('independent-oracle',[sys.executable,HERE/'oracle.py','--self-check'])
            if args.acquisition:
                step('measurement-capability',[sys.executable,HERE/'acquisition_capability_probe.py','--output',out/'measurement-capability.json','--python',sys.executable])
            experiment=HERE/('coherent_experiment.py' if args.coherent else ('acquisition_experiment.py' if args.acquisition else 'experiment.py'))
            step('braket-experiment',[sys.executable,experiment,'--artifacts',out,'--python',sys.executable],timeout=240)
        changed=[p for p,h in hashes.items() if hashlib.sha256((ROOT/p).read_bytes()).hexdigest()!=h]
        if changed:
            raise RuntimeError('Inputs changed during build: '+str(changed))
        manifest['status']='passed'; manifest['completed_at']=utc()
        save()
        print('Artifacts: '+str(out))
    except Exception as e:
        manifest['status']='failed';manifest['failure']=str(e);manifest['completed_at']=utc();save()
        raise

if __name__=='__main__':
    main()
