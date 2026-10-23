#!/usr/bin/env python3
"""A finite boundary policy and a historical, shrinking debt ledger.

The caller supplies ROOT, CONFIG and POLICY_SHA256. Policy data belongs to
the checked repository; this implementation does not name its consumers.
"""
import argparse
from collections import Counter
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys


def digest(value):
    return hashlib.sha256(json.dumps(value, sort_keys=True, ensure_ascii=True).encode()).hexdigest()


def text_identity(text):
    return re.sub(r'\b(?:[0-9a-fA-F]{64}|[0-9a-fA-F]{40})\b', '<opaque-digest>', text)


def identity(row):
    kept = {field: row[field] for field in ('path', 'channel', 'name', 'text', 'occurrence')}
    kept['text'] = text_identity(kept['text'])
    return digest(kept)


def git(*arguments):
    return subprocess.check_output(['git', '-C', str(ROOT), *arguments], stderr=subprocess.PIPE)


def policy_value(data):
    policy = {field: value for field, value in data.items() if field != 'exceptions'}
    policy['declarations'] = [
        {**{field: value for field, value in row.items() if field not in ('line', 'text')},
         'text': text_identity(row['text'])} for row in data['declarations']]
    return policy


def reseal_command():
    return 'python3 ' + CONFIG.removesuffix('.json') + '.py --policy-digest'


def validate_policy(data):
    if digest(policy_value(data)) != POLICY_SHA256:
        raise ValueError(CONFIG + ':1: boundary policy changed; review vocabulary, scope and declarations, then reseal POLICY_SHA256 using `' + reseal_command() + '`')


def load():
    data = json.loads((ROOT / CONFIG).read_text(encoding='utf-8'))
    validate_policy(data)
    return data


def in_scope(path, scopes):
    return any(path == prefix or path.startswith(prefix.rstrip('/') + '/') for prefix in scopes)


def selected_words(data, path, text):
    words = set()
    for selector in data['vocabulary']:
        if 'paths' in selector and not in_scope(path, selector['paths']):
            continue
        for match in re.finditer(selector['pattern'], text):
            words.add(match.group(selector.get('group', 0)))
    return sorted(words)


def findings(data, revision=None, overlays=None, selected=None):
    overlays = overlays or {}
    if selected is not None:
        raw_paths = b'\0'.join(path.encode('utf-8') for path in selected)
    elif revision:
        raw_paths = git('ls-tree', '-r', '-z', '--name-only', revision, '--', *data['scope'])
    else:
        raw_paths = git('ls-files', '-z', '--cached', '--others', '--exclude-standard', '--', *data['scope'])
    paths = {path.decode('utf-8') for path in raw_paths.split(b'\0') if path}
    paths.update(overlays)
    fixtures = {row['path'] for row in data['fixtures']}
    occurrences = Counter()
    result = []
    for name in sorted(paths):
        if not in_scope(name, data['scope']):
            raise ValueError(name + ':1: overlay is outside the declared scope')
        if name == CONFIG:
            continue
        if name in overlays:
            content = overlays[name]
            if content is None:
                continue
        elif revision:
            content = git('show', revision + ':' + name)
        else:
            path = ROOT / name
            if path.is_symlink():
                raise ValueError(name + ':1: boundary cannot read a symbolic link as an owned file')
            if not path.is_file():
                continue
            content = path.read_bytes()
        rows = [('path', 1, name)]
        if b'\0' not in content:
            try:
                decoded = content.decode('utf-8')
            except UnicodeDecodeError as error:
                line = content[:error.start].count(b'\n') + 1
                raise ValueError(f'{name}:{line}: boundary cannot decode text as UTF-8 at byte {error.start}') from error
            rows.extend(('text', line, text.strip()) for line, text in enumerate(decoded.splitlines(), 1))
        if name in fixtures:
            continue
        for channel, line, text in rows:
            for word in selected_words(data, name, text):
                key = (name, channel, word, text_identity(text))
                occurrences[key] += 1
                result.append(dict(path=name, channel=channel, line=line, name=word,
                                   text=text, occurrence=occurrences[key]))
    return result


def require_complete_history():
    if git('rev-parse', '--is-shallow-repository').strip() != b'false':
        raise ValueError(CONFIG + ':1: boundary history is shallow; fetch the complete history before judging retired entries')


def historical_limits():
    require_complete_history()
    revisions = git('log', '--full-history', '--format=%H', 'HEAD', '--', CONFIG).decode().splitlines()
    seen = set()
    for revision in revisions:
        try:
            raw = git('show', revision + ':' + CONFIG)
        except subprocess.CalledProcessError:
            continue
        checksum = hashlib.sha256(raw).hexdigest()
        if checksum in seen:
            continue
        seen.add(checksum)
        previous = json.loads(raw)
        yield revision, previous


def historical_identities(previous, row):
    # A reviewed policy extension can recognize old source for the first
    # time. It cannot restore an occurrence recognized and retired under an
    # earlier policy. Exact declarations may become debt after review.
    if not in_scope(row['path'], previous['scope']):
        return set()
    if row['path'] in {entry['path'] for entry in previous['fixtures']}:
        return set()
    # Selector refinements can change the spelling of the matched name
    # (for example, a longer repository address). Replay the earlier
    # selector on the exact source occurrence instead of comparing names.
    return {identity({**row, 'name': word}) for word in selected_words(previous, row['path'], row['text'])}


def assess(data, actual, ceiling, history):
    errors = []
    allowed = {}
    historical = [(revision, previous,
                   {identity(row) for row in previous['exceptions'] + previous['declarations']})
                  for revision, previous in history]
    for row in data['exceptions']:
        key = identity(row)
        address = row['path'] + ':' + str(row['line'])
        if key in allowed:
            errors.append(CONFIG + ':1: duplicate ledger entry for ' + address)
        allowed[key] = row
        if not row.get('task') or not row.get('reason'):
            errors.append(address + ': boundary exception has no removal task or reason')
        elif row['task'] not in data['removal_tasks']:
            errors.append(address + ': boundary exception names an undeclared removal task')
        if key not in ceiling:
            errors.append(address + ': boundary ledger cannot grow beyond its frozen source; ' + row['name'])
        for revision, previous, limit in historical:
            if key not in limit and historical_identities(previous, row) - limit:
                errors.append(address + ': boundary ledger restores a retired occurrence from ' + revision + '; ' + row['name'])
                break
    for row in data['declarations']:
        key = identity(row)
        address = row['path'] + ':' + str(row['line'])
        if key in allowed:
            errors.append(CONFIG + ':1: duplicate declared occurrence for ' + address)
        if row.get('class') not in data['declaration_classes'] or not row.get('reason'):
            errors.append(address + ': reference has no declared class or reason')
        allowed[key] = row
    current = {identity(row): row for row in actual}
    for key, row in current.items():
        address = row['path'] + ':' + str(row['line'])
        if key not in allowed:
            errors.append(address + ': new boundary occurrence: ' + row['name'])
        elif row['line'] != allowed[key]['line']:
            errors.append(address + ': boundary address moved; run python3 ' + CONFIG.removesuffix('.json') + '.py --refresh-addresses for ' + row['name'])
    declaration_keys = {identity(row) for row in data['declarations']}
    for key, row in allowed.items():
        if key not in current:
            address = row['path'] + ':' + str(row['line'])
            if key in declaration_keys:
                errors.append(address + ': declared reference changed or removed; review and reseal the declaration using `' + reseal_command() + '`; ' + row['name'])
            else:
                errors.append(address + ': stale boundary ledger; delete the entry for ' + row['name'])
    return errors


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--policy-digest', action='store_true', help='print the candidate seal; does not approve or edit it')
    parser.add_argument('--refresh-addresses', action='store_true', help='update only line numbers; never add an exception')
    args = parser.parse_args()
    if args.policy_digest:
        data = json.loads((ROOT / CONFIG).read_text(encoding='utf-8'))
        print(digest(policy_value(data)))
        return 0
    data = load()
    actual = findings(data)
    ceiling = {identity(row) for row in findings(data, data['baseline_revision'])}
    history = list(historical_limits())
    if args.refresh_addresses:
        current = {identity(row):row for row in actual}
        for row in data['exceptions'] + data['declarations']:
            if identity(row) in current:
                row['line'] = current[identity(row)]['line']
        errors = assess(data, actual, ceiling, history)
        if not errors:
            (ROOT / CONFIG).write_text(json.dumps(data, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')
    else:
        errors = assess(data, actual, ceiling, history)
    if errors:
        print('\n'.join(errors))
        return 1
    print('BOUNDARY HOLDS: ' + str(len(data['exceptions'])) + ' debt occurrences, ' + str(len(data['declarations'])) + ' declared references/inputs, ' + str(len(data['fixtures'])) + ' declared fixture files; ledger did not grow')
    return 0



def run():
    try:
        return main()
    except (ValueError, OSError, KeyError, TypeError, subprocess.CalledProcessError) as error:
        print(CONFIG + ':1: boundary refused: ' + str(error), file=sys.stderr)
        return 1
