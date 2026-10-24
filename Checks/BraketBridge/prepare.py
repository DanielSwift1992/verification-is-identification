#!/usr/bin/env python3
"""Reuse checked acquisition exports in the trusted local workspace.

Content hashes detect changed build inputs/artifacts, not forged proofs or
physical device validity. No SDK, fixture, oracle or cloud call is needed.
"""

import sys as _evidence_sys
from pathlib import Path as _EvidencePath
_evidence_sys.path.insert(0, str(_EvidencePath(__file__).resolve().parents[1]))
import hardware_runs as _runs
_runs.configure(required=False)
import argparse
import fcntl
import hashlib
import json
import os
from pathlib import Path
import platform
import shutil
import sys
from time import perf_counter

from build import HERE, ROOT, compilation_sources, notation_sources, run_bounded
from runtime import require, load_json, write_json

EXPORTS = ('sources.json', 'continuations.json', 'requests.json')
STEPS = ('versions', 'fresh-notation-library', 'fresh-core-library', 'compile-proposal', 'derive-and-export',
         'compile-row-applications', 'export-checked-continuation')


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def snapshot():
    core, common, exporter = compilation_sources('acquisition')
    paths = notation_sources() + core + common + [exporter, HERE/'build.py', HERE/'prepare.py', HERE/'runtime.py', _runs.owned(_runs.__file__)]
    compiler = shutil.which('swiftc')
    require(compiler is not None, 'swiftc is unavailable')
    version = run_bounded([compiler, '--version'], 15)
    require(version.returncode == 0, 'cannot identify Swift compiler')
    return {
        'schema': 'vi.braket.prepare-inputs.v1', 'mode': 'acquisition',
        'sources': {_runs.address(p, ROOT): digest(p) for p in paths},
        'compiler': str(_runs.owned(compiler).resolve()), 'compiler_sha256': digest(_runs.owned(compiler)),
        'compiler_version': version.stdout, 'platform': platform.platform(),
        'python': sys.version, 'python_executable': sys.executable,
        'toolchain_environment': {k: os.environ.get(k) for k in
            ('SDKROOT', 'MACOSX_DEPLOYMENT_TARGET', 'DEVELOPER_DIR', 'TOOLCHAINS')},
    }


def cache_key(inputs):
    return hashlib.sha256(json.dumps(inputs, sort_keys=True).encode()).hexdigest()


def validate_entry(directory, inputs):
    seal = load_json(directory/'ready.json')
    require(seal.get('inputs') == inputs, 'cached build inputs differ from current inputs')
    require(set(seal.get('exports', {})) == set(EXPORTS), 'incomplete checked export set')
    require(all(digest(directory/name) == value for name, value in seal['exports'].items()),
            'cached checked export changed; do not use it')
    manifest = load_json(directory/'build-manifest.json')
    require(digest(directory/'build-manifest.json') == seal.get('manifest_sha256'),
            'cached build manifest changed')
    require(manifest.get('status') == 'passed' and manifest.get('scope') == 'checked-exports'
            and manifest.get('mode') == 'acquisition', 'not a successful checked-export build')
    require(tuple(s['name'] for s in manifest['steps']) == STEPS
            and all(s['returncode'] == 0 for s in manifest['steps']), 'missing checked build step')
    core, common, exporter = compilation_sources('acquisition')
    expected = {_runs.address(p, ROOT): inputs['sources'][_runs.address(p, ROOT)]
                for p in notation_sources() + core + common + [exporter, HERE/'build.py', _runs.owned(_runs.__file__)]}
    require(manifest['source_sha256'] == expected, 'build did not use these exact sources')
    return {name: load_json(directory/name) for name in EXPORTS}


def prepare(cache):
    started = perf_counter()
    inputs = snapshot()
    key = cache_key(inputs)
    cache = cache.resolve()
    if _runs.contains(cache):
        directory = cache/key
        require((directory/'ready.json').is_file(),
                'archived prepared inputs do not match the current compiler/sources; pass --cache DIR outside the evidence store for a fresh build')
        documents = validate_entry(directory, inputs)
        return documents, {'cache_hit': True, 'key': key,
                           'directory': _runs.address(directory, ROOT), 'read_only': True,
                           'seconds': perf_counter()-started}
    cache.mkdir(parents=True, exist_ok=True)
    directory = cache/key
    # Refuse concurrent writers instead of waiting behind an unbounded build.
    with (cache/(key+'.lock')).open('a') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        hit = directory.exists()
        if not hit:
            result = run_bounded([sys.executable, HERE/'build.py', *_runs.arguments(), '--acquisition',
                                  '--prepare-only', '--output', directory], 300)
            require(result.returncode == 0, 'checked build failed; inspect ' + str(directory/'logs'))
            require(snapshot() == inputs, 'inputs changed during preparation; no cache seal written')
            write_json(directory/'ready.json', _runs.bind_receipt({
                'inputs': inputs, 'exports': {n: digest(directory/n) for n in EXPORTS},
                'manifest_sha256': digest(directory/'build-manifest.json')}, destination=directory/'ready.json'))
        require((directory/'ready.json').is_file(),
                'incomplete cache entry; preserve diagnostics and use a new --cache directory')
        documents = validate_entry(directory, inputs)
        require(snapshot() == inputs, 'inputs changed during cache validation')
    return documents, {'cache_hit': hit, 'key': key, 'directory': str(directory),
                       'seconds': perf_counter()-started}


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--cache', type=_runs.owned)
    a = p.parse_args()
    a.cache = a.cache if a.cache is not None else _runs.prepared('braket-prepared')
    _, receipt = prepare(a.cache)
    print(json.dumps(_runs.bind_receipt(receipt), indent=2))


if __name__ == '__main__':
    main()
