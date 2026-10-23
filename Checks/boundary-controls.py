#!/usr/bin/env python3
"""Executable counterexamples for the shared boundary law.

Changed bytes are isolated overlays. The three-commit fixture exercises real
Git history; it is not a worktree or copy of either checked repository.
"""
from collections import Counter
import copy
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys
import tempfile


def controls(law):
    root = law.ROOT
    data = law.load()
    actual = law.findings(data)
    ceiling = {law.identity(row) for row in law.findings(data, data['baseline_revision'])}
    history = list(law.historical_limits())
    assert not law.assess(data, actual, ceiling, history)
    print('CONTROL original: holds')
    with tempfile.TemporaryDirectory(prefix='boundary-controls-') as directory:
        temporary = Path(directory)
        def view(path, content):
            staged = temporary / 'inputs' / path
            staged.parent.mkdir(parents=True, exist_ok=True)
            staged.write_bytes(content)
            changed = law.findings(data, overlays={path: staged.read_bytes()}, selected=[path])
            return [entry for entry in actual if entry['path'] != path] + changed

        def refuses(label, rows, expected, ledger=data, limits=history, bound=ceiling):
            errors = law.assess(ledger, rows, bound, limits)
            assert any((expected in message for message in errors)), (label, errors)
            print('CONTROL ' + label + ': refused')
            for message in errors:
                print('  ' + message)
        word = data['probe_names'][0]
        for prefix in data['scope']:
            path = prefix + '/BoundaryProbe.swift' if not Path(prefix).suffix else prefix
            content = (root / path).read_bytes() if (root / path).is_file() else b''
            content += ('\n// ' + word + '\n').encode()
            rows = view(path, content)
            refuses('new-in-' + prefix, rows, path + ':')
        for (index, word) in enumerate(data['probe_names'][1:], 1):
            path = data['scope'][0] + '/BoundaryName' + str(index) + '.swift'
            if Path(data['scope'][0]).suffix:
                path = next((scope for scope in data['scope'] if not Path(scope).suffix)) + '/BoundaryName' + str(index) + '.swift'
            refuses('another-declared-name-' + str(index), view(path, ('// ' + word + '\n').encode()), 'new boundary occurrence')
        for probe in data['behavior_probes']:
            path = probe['path']
            content = (root / path).read_bytes() if (root / path).is_file() else b''
            rows = view(path, content + b'\n' + probe['text'].encode() + b'\n')
            refuses('new-behavior-' + path, rows, 'new boundary occurrence')
        for probe in data['positive_probes']:
            rows = view(probe['path'], probe['text'].encode())
            assert not law.assess(data, rows, ceiling, history), probe
            print('CONTROL ordinary-or-owned: holds; ' + probe['path'] + ': ' + probe['text'])
        undecodable = next((scope for scope in data['scope'] if not Path(scope).suffix)) + '/BoundaryEncoding.swift'
        try:
            view(undecodable, b'// \xff\n' + data['probe_names'][0].encode())
        except ValueError as error:
            assert undecodable + ':1:' in str(error) and 'UTF-8' in str(error)
            print('CONTROL invalid-utf8: refused\n  ' + str(error))
        else:
            raise AssertionError('invalid text hid a named occurrence')
        binary_rows = view(undecodable, b'\x00' + data['probe_names'][0].encode())
        assert not law.assess(data, binary_rows, ceiling, history)
        print('CONTROL nul-payload-is-not-text: holds (filename is still checked)')
        if data['fixtures']:
            fixture_path = data['fixtures'][0]['path']
            try:
                view(fixture_path, b'// \xff\n')
            except ValueError as error:
                assert fixture_path + ':1:' in str(error) and 'UTF-8' in str(error)
                print('CONTROL fixture-invalid-utf8: refused\n  ' + str(error))
            else:
                raise AssertionError('a fixture exemption hid undecodable text')
        declaration = next((row for row in data['declarations'] if row['channel'] == 'text'))
        changed = (root / declaration['path']).read_bytes().splitlines(keepends=True)
        changed[declaration['line'] - 1] = changed[declaration['line'] - 1].rstrip(b'\r\n') + b' revised\n'
        refuses('edited-declaration-needs-review', view(declaration['path'], b''.join(changed)), 'reseal the declaration')
        shifted = b'\n' + (root / declaration['path']).read_bytes()
        refuses('moved-address-has-command', view(declaration['path'], shifted), '--refresh-addresses')
        forged = copy.deepcopy(data)
        path = next((scope for scope in data['scope'] if not Path(scope).suffix)) + '/BoundaryDeclared.swift'
        rows = view(path, ('// ' + data['probe_names'][0] + '\n').encode())
        forged['declarations'] += [dict(entry, **{'class': 'reference', 'reason': 'claimed navigation'}) for entry in rows if entry['path'] == path]
        try:
            law.validate_policy(forged)
        except ValueError as error:
            assert 'policy changed' in str(error)
            print('CONTROL self-declared-reference: refused\n  ' + str(error))
        else:
            raise AssertionError('a new reference was self-authorized')
        print('CONTROL approved-reference-set: holds (' + str(len(data['declarations'])) + ' exact occurrences)')
        counts = Counter(((entry['path'], entry['line'], entry['channel']) for entry in actual))
        identities = Counter((entry['path'], entry['channel'], entry['name'], law.text_identity(entry['text'])) for entry in actual)
        row = next(entry for entry in data['exceptions'] if entry['channel'] == 'text' and counts[entry['path'], entry['line'], entry['channel']] == 1 and identities[entry['path'], entry['channel'], entry['name'], law.text_identity(entry['text'])] == 1)
        legacy = next((entry for entry in data['exceptions'] if law.identity(entry) == law.identity(row)))
        content = (root / row['path']).read_bytes().splitlines(keepends=True)
        content[row['line'] - 1] = b'\n'
        removed = view(row['path'], b''.join(content))
        refuses('removed-source-kept-ledger', removed, 'stale boundary ledger')
        reduced = copy.deepcopy(data)
        reduced['exceptions'] = [entry for entry in reduced['exceptions'] if law.identity(entry) != law.identity(row)]
        assert not law.assess(reduced, removed, ceiling, history)
        print('CONTROL removed-source-and-entry: holds')
        refuses('removed-entry-kept-source', actual, 'new boundary occurrence', ledger=reduced)
        path = next((scope for scope in data['scope'] if not Path(scope).suffix)) + '/BoundaryGrowth.swift'
        rows = view(path, ('// ' + data['probe_names'][0] + '\n').encode())
        grown = copy.deepcopy(data)
        grown['exceptions'] += [dict(entry, task=legacy['task'], reason='negative control') for entry in rows if entry['path'] == path]
        refuses('new-source-added-to-ledger', rows, 'cannot grow beyond its frozen source', ledger=grown)
        receipt = next((entry for entry in actual if entry['channel'] == 'text' and re.search('\\b[0-9a-f]{64}\\b', entry['text'])), None)
        if receipt:
            source = (root / receipt['path']).read_text()
            changed = re.sub('\\b[0-9a-f]{64}\\b', lambda match: ('0' if match[0] != '0' * 64 else '1') * 64, source)
            assert not law.assess(data, view(receipt['path'], changed.encode()), ceiling, history)
            print('CONTROL opaque-carrier-digest-change: holds (byte validity belongs to the carrier contract)')
        fixture = temporary / 'history'
        fixture.mkdir()

        def git(*args):
            subprocess.run(['git', '-C', str(fixture), *args], check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        git('init', '-q')
        git('config', 'user.name', 'Boundary control')
        git('config', 'user.email', 'boundary@example.invalid')
        git('config', 'commit.gpgsign', 'false')
        hooks = fixture / 'empty-hooks'
        hooks.mkdir()
        git('config', 'core.hooksPath', str(hooks))
        record = fixture / law.CONFIG
        record.parent.mkdir(parents=True, exist_ok=True)
        for (label, entries) in [('seed', [legacy]), ('retire', []), ('restore', [legacy])]:
            record.write_text(json.dumps({**data, 'exceptions': entries, 'declarations': []}) + '\n')
            git('add', law.CONFIG)
            git('commit', '-qm', label)
        saved = law.ROOT
        try:
            law.ROOT = fixture
            limits = list(law.historical_limits())
        finally:
            law.ROOT = saved
        refuses('committed-restoration', [row], 'restores a retired occurrence', ledger={**data, 'exceptions': [legacy], 'declarations': []}, limits=limits, bound={law.identity(row)})
        unrecognized = {**data, 'exceptions': [], 'declarations': [], 'vocabulary': []}
        candidate = {**data, 'exceptions': [legacy], 'declarations': []}
        assert not law.assess(candidate, [row], {law.identity(row)}, [('before-policy-extension', unrecognized)])
        print('CONTROL reviewed-policy-extension: holds for existing frozen source')
        retired = {**data, 'exceptions': [], 'declarations': []}
        refuses('retirement-survives-policy-extension', [row], 'restores a retired occurrence', ledger=candidate, limits=[('before-extension', retired), ('extended-policy', unrecognized)], bound={law.identity(row)})
        renamed = {**legacy, 'name': 'a refined match spelling'}
        refuses('retirement-survives-renamed-match', [renamed], 'restores a retired occurrence', ledger={**candidate, 'exceptions': [renamed]}, limits=[('before-extension', retired)], bound={law.identity(renamed)})
        refuses('new-cohort-still-needs-frozen-source', [row], 'cannot grow beyond its frozen source', ledger=candidate, limits=[('before-extension', unrecognized)], bound=set())
        shallow = temporary / 'shallow-history'
        subprocess.run(['git', 'clone', '--quiet', '--depth', '1', fixture.as_uri(), str(shallow)], check=True)
        saved = law.ROOT
        try:
            law.ROOT = shallow
            try:
                list(law.historical_limits())
            except ValueError as error:
                assert 'history is shallow' in str(error), str(error)
                print('CONTROL shallow-history: refused\n  ' + str(error))
            else:
                raise AssertionError('a truncated history was accepted')
        finally:
            law.ROOT = saved
        if data['fixtures']:
            path = data['fixtures'][0]['path']
            rows = view(path, ('// ' + data['probe_names'][0] + '\n').encode())
            assert not law.assess(data, rows, ceiling, history)
            print('CONTROL declared-fixture: holds')
    print('BOUNDARY CONTROLS GREEN')
