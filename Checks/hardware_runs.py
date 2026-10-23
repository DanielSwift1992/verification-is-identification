#!/usr/bin/env python3
"""Explicit, read-only inputs from a caller-supplied evidence catalogue."""
import argparse
from functools import wraps
import hashlib
import json
from pathlib import Path, PurePosixPath
import re
import sys

_STORE = None
_PREPARED_CACHE = None
_WORK = None


class EvidenceError(ValueError):
    pass


def relative_name(name):
    path = PurePosixPath(name)
    if (not name or path.is_absolute() or '..' in path.parts or '\\' in name
            or re.match(r'^[A-Za-z]:', name)):
        raise EvidenceError('evidence input must be relative to the supplied hardware-runs folder')
    return path.as_posix()


class EvidencePath(type(Path())):
    def open(self, mode='r', buffering=-1, encoding=None, errors=None, newline=None):
        if mode not in ('r', 'rb', 'rt'):
            raise EvidenceError('evidence inputs are read-only; choose a separate explicit output directory')
        store = configure()
        store.verify(self)
        return super().open(mode, buffering, encoding, errors, newline)

    def mkdir(self, mode=0o777, parents=False, exist_ok=False):
        if exist_ok and self.is_dir():
            return
        self._immutable()

    def _immutable(self, *args, **kwargs):
        raise EvidenceError('evidence inputs are read-only; pass --work DIR for a new run or choose a separate explicit output directory')

    touch = unlink = rename = replace = rmdir = chmod = _immutable


class Evidence:
    def __init__(self, runs, manifest):
        self.root = Path(runs).resolve()
        self.manifest = Path(manifest).resolve()
        if not self.root.is_dir():
            raise EvidenceError('pass the hardware-runs folder of the evidence store with --runs DIR')
        raw = self.manifest.read_bytes()
        self.manifest_sha256 = hashlib.sha256(raw).hexdigest()
        data = json.loads(raw)
        self.files = {}
        self.reads = {}
        for row in data['files']:
            path = relative_name(row['path'])
            if not path.startswith('hardware-runs/'):
                continue
            name = relative_name(path[len('hardware-runs/'):])
            if name in self.files or not re.fullmatch('[0-9a-f]{64}', row['sha256']):
                raise EvidenceError('invalid or duplicate evidence identity: ' + name)
            self.files[name] = row
        if not self.files:
            raise EvidenceError('the supplied manifest declares no hardware-runs files')

    def name(self, path):
        try:
            return relative_name(Path(path).resolve().relative_to(self.root).as_posix())
        except ValueError as error:
            raise EvidenceError('input escapes the supplied hardware-runs folder') from error

    def verify(self, path):
        name = self.name(path)
        if name not in self.files:
            raise EvidenceError('file is not declared by the supplied manifest: ' + name)
        row = self.files[name]
        # Use a plain Path here: EvidencePath.open delegates this verification.
        raw = Path(path).read_bytes()
        if hashlib.sha256(raw).hexdigest() != row['sha256'] or len(raw) != row['bytes']:
            raise EvidenceError('evidence SHA-256 or size differs from MANIFEST.json: ' + name)
        ref = {'path': name, 'sha256': row['sha256']}
        self.reads[name] = ref
        return ref

    def path(self, name):
        name = relative_name(name)
        result = EvidencePath(self.root / name)
        self.name(result)  # Includes a symlink escape check.
        if not result.exists():
            raise EvidenceError('missing evidence input: ' + name)
        if result.is_file():
            self.verify(result)
        return result

    def verify_all(self):
        for name in self.files:
            self.verify(self.root / name)
        return len(self.files)


def configure(required=True):
    global _STORE, _PREPARED_CACHE, _WORK
    if _STORE is not None:
        return _STORE
    parser = argparse.ArgumentParser(add_help=False, allow_abbrev=False)
    parser.add_argument('--runs', type=Path)
    parser.add_argument('--manifest', type=Path)
    parser.add_argument('--prepared-cache', type=Path)
    parser.add_argument('--work', type=Path)
    parser.add_argument('--check-evidence', action='store_true')
    args, remaining = parser.parse_known_args()
    if not args.runs and not args.manifest and not args.prepared_cache and not args.work and not args.check_evidence and not required:
        return None
    if not args.runs and not args.manifest and any(x in remaining for x in ('-h', '--help')):
        parser.print_help()
        print('Supply both evidence arguments for command-specific help; --check-evidence verifies hashes without SDK imports or hardware calls.')
        raise SystemExit(0)
    if not args.runs or not args.manifest:
        parser.error('pass --runs DIR (the hardware-runs folder of the evidence store) and --manifest FILE (its MANIFEST.json); no implicit evidence directory')
    try:
        _STORE = Evidence(args.runs, args.manifest)
    except (OSError, ValueError, KeyError, TypeError) as error:
        parser.error('evidence input: ' + str(error))
    _PREPARED_CACHE = args.prepared_cache.resolve() if args.prepared_cache else None
    if _PREPARED_CACHE is not None and _PREPARED_CACHE.is_relative_to(_STORE.root):
        parser.error('--prepared-cache must be outside the read-only evidence store')
    _WORK = args.work.resolve() if args.work else None
    if _WORK is not None and _WORK.is_relative_to(_STORE.root):
        parser.error('--work must be outside the read-only evidence store')
    sys.argv[1:] = remaining
    if args.check_evidence:
        try:
            count = _STORE.verify_all()
        except (OSError, ValueError) as error:
            parser.error('evidence input: ' + str(error))
        print(json.dumps({'evidence_files_verified': count, 'manifest_sha256': _STORE.manifest_sha256,
                          'network_or_hardware_calls': False}))
        raise SystemExit(0)
    return _STORE


def path(name):
    return configure().path(name)


def root():
    return EvidencePath(configure().root)


def input_path(value):
    store = configure()
    candidate = Path(value)
    name = store.name(candidate) if candidate.is_absolute() else relative_name(str(candidate))
    return store.path(name)


def work(name):
    store = configure()
    name = relative_name(name)
    if _WORK is not None:
        return _WORK / name
    # Historical completed runs remain read-only. An unsubmitted destination
    # is not evidence and needs an explicit new work directory before any stage.
    target = EvidencePath(store.root / name)
    store.name(target)
    if not target.exists():
        raise EvidenceError('no archived run at ' + name + '; pass --work DIR outside the evidence store for a prospective new run')
    return target


def prepared(name):
    configure()
    return _PREPARED_CACHE / name if _PREPARED_CACHE is not None else path(name)


def arguments():
    store = configure()
    result = ['--runs', str(store.root), '--manifest', str(store.manifest)]
    if _PREPARED_CACHE is not None:
        result += ['--prepared-cache', str(_PREPARED_CACHE)]
    if _WORK is not None:
        result += ['--work', str(_WORK)]
    return result


def contains(path):
    return _STORE is not None and Path(path).resolve().is_relative_to(_STORE.root)


def owned(*parts):
    path = Path(*parts)
    return EvidencePath(path) if contains(path) else path


def resolve_recorded(name, sha256, source_root, *, corpus_root=None):
    """A saved machine prefix is opaque: resolve run inputs by catalogue hash."""
    store = configure()
    label = PurePosixPath(name)
    base = Path(source_root).resolve()
    corpus_input = Path(corpus_root if corpus_root is not None else source_root)
    corpus = corpus_input.resolve()
    source_dirs = {'Sources', 'Checks', 'Contracts', 'Documentation', 'Research',
                   'Tools', 'Assets', '.build', 'Package.swift', 'check.sh', 'README.md'}
    candidate = Path(name) if label.is_absolute() else base / label
    allowed = False
    # Do not even resolve an old machine path outside the explicit corpus.
    # The unresolved caller root also retains the caller's local path alias.
    in_corpus = any(candidate.is_relative_to(root)
                    for root in (corpus, corpus_input.absolute()))
    if '..' not in label.parts and in_corpus:
        candidate = candidate.resolve()
        if candidate.is_relative_to(corpus):
            parts = candidate.relative_to(corpus).parts
            allowed = bool(parts and parts[0] in source_dirs)
            allowed = allowed or (base.is_relative_to(corpus/'Research') and candidate.is_relative_to(base))
    if allowed:
        if candidate.is_file():
            if hashlib.sha256(candidate.read_bytes()).hexdigest() != sha256:
                raise EvidenceError('recorded corpus source changed: ' + label.as_posix())
            return candidate
    matches = sorted(key for key, row in store.files.items() if row['sha256'] == sha256)
    if not matches:
        raise EvidenceError('no run input with the recorded SHA-256 in supplied MANIFEST.json: ' + sha256)
    return store.path(matches[0])


def rebind_map(entries, source_root):
    return {address(resolve_recorded(name, digest, source_root), source_root): digest
            for name, digest in entries.items()}


def include_reader(function):
    """Existing implementation fingerprints include this newly used reader."""
    @wraps(function)
    def identified(*args, **kwargs):
        result = function(*args, **kwargs)
        return {**result, 'Checks/hardware_runs.py': hashlib.sha256(Path(__file__).read_bytes()).hexdigest()}
    return identified


def address(path, source_root):
    candidate = Path(path).resolve()
    if contains(candidate):
        if candidate.is_file():
            _STORE.verify(candidate)
        return _STORE.name(candidate)
    for output_root in (_WORK, _PREPARED_CACHE):
        if output_root is not None and candidate.is_relative_to(output_root):
            return candidate.relative_to(output_root).as_posix()
    return candidate.relative_to(source_root).as_posix()


def bind_receipt(value, destination=None):
    """Keep raw provider payloads intact; bind new input references by catalogue hash."""
    if _STORE is None or not isinstance(value, dict):
        return value
    # These are existing wire formats, not provenance receipts. Their owner
    # receipts already bind exported bytes; do not silently extend a protocol.
    if destination is not None and Path(destination).name in {
            'raw-result.json', 'jobs.json', 'sources.json',
            'continuations.json', 'requests.json'}:
        return value
    def relocate(item):
        if isinstance(item, dict):
            return {relocate(k): relocate(v) for k, v in item.items()}
        if isinstance(item, list):
            return [relocate(v) for v in item]
        if isinstance(item, tuple):
            return tuple(relocate(v) for v in item)
        if isinstance(item, str) and item.startswith(str(_STORE.root) + '/'):
            return address(Path(item), _STORE.root)
        return item
    result = relocate(value)
    # Existing hashes remain the record: add only input identities not already
    # carried by this result. Never modify a saved receipt or its source bytes.
    encoded = json.dumps(result, default=str)
    missing = [ref for _, ref in sorted(_STORE.reads.items()) if ref['sha256'] not in encoded]
    if missing:
        result = {**result, 'evidence_inputs': missing,
                  'evidence_manifest_sha256': _STORE.manifest_sha256}
    return result


if __name__ == '__main__':
    configure()
