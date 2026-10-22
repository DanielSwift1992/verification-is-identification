#!/usr/bin/env python3
"""Archive law: preserve declared bytes; forbid live where-reader dependencies."""
import hashlib
import json
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
ARCHIVE = Path('Checks/Archive/WhereV2')
REVISION = 'cd5c55750b4639e15136ded0592920c573ad89ce'
READER_SHA256 = '3beed68f0ec30c7a2ca233b9754adfeb905a1502146129211bd4b51c62c67185'
RECORDED_READER_SHA256 = '9d64a7db35ca82eb043f82702d8386dcc389cd7e90218f7ed6084c7317ed4088'
RECEIPT_COUNT = 207
# Literal sibling paths and the common Python/Node path-building spellings.
# The gate component must end here: a module named gateway is not a gate path.
LIVE_PATHS = [
    re.compile(r'''\.\.[/\\]+gate(?![\w.-])'''),
    re.compile(r'''\b[A-Za-z_]\w*\s*\.\s*(?:parent(?:\s*\.\s*parent)*|parents\s*\[\s*\d+\s*\])\s*(?:/\s*|\.\s*joinpath\s*\(\s*)['"]gate(?![\w.-])'''),
    re.compile(r'''\bpath\s*\.\s*(?:join|resolve)\s*\(\s*[\w.$]+\s*,\s*(?:['"]\.\.(?:[/\\]\.\.)*['"]\s*,\s*)+['"]gate(?![\w.-])'''),
]
ARCHIVE_IMPLEMENTATION = {
    'Checks/archived-where.py', 'Checks/archived-where-test.py',
    str(ARCHIVE / 'judge-cli.js'), str(ARCHIVE / 'judge-where.js'),
}


MANIFEST_KEYS = {
    'schema', 'state', 'vi_before_revision', 'origin', 'consumers',
    'related_native_consumers', 'documentation_provenance',
    'recorded_reader_sha256', 'recorded_reader_provenance', 'recorded_reader_receipts',
}
RECEIPT_KEYS = {
    'path', 'sha256', 'matching_pointer_count', 'json_pointer_parent', 'key_suffix',
}


def safe_parent_pointer(value):
    if not isinstance(value, str):
        return False
    # Only JSON container names, never encoded path components or escapes.
    return value == '' or (value.startswith('/') and all(
        re.fullmatch(r'\w+', part) for part in value.split('/')[1:]))


def check(root):
    errors = []
    manifest_path = ARCHIVE / 'manifest.json'
    try:
        manifest = json.loads((root / manifest_path).read_text())
    except (OSError, ValueError) as error:
        return [f'{manifest_path}: unread archive manifest: {error}']
    if not isinstance(manifest, dict) or set(manifest) != MANIFEST_KEYS:
        return [f'{manifest_path}: invalid manifest fields; expected the closed key set']
    origin = manifest.get('origin', {})
    if origin.get('revision') != REVISION or origin.get('sha256') != READER_SHA256:
        errors.append(f'{manifest_path}: frozen reader identity changed')
    if manifest.get('recorded_reader_sha256') != RECORDED_READER_SHA256:
        errors.append(f'{manifest_path}: recorded receipt-reader identity changed')
    receipts = manifest.get('recorded_reader_receipts', [])
    if not isinstance(receipts, list):
        return errors + [f'{manifest_path}: invalid receipt address list']
    paths = [item.get('path') if isinstance(item, dict) and isinstance(item.get('path'), str)
             else '' for item in receipts]
    if len(receipts) != RECEIPT_COUNT or len(set(paths)) != RECEIPT_COUNT:
        errors.append(f'{manifest_path}: expected {RECEIPT_COUNT} distinct receipt addresses')
    for item in receipts:
        if (not isinstance(item, dict) or set(item) != RECEIPT_KEYS
                or not isinstance(item['path'], str) or not isinstance(item['sha256'], str)
                or type(item['matching_pointer_count']) is not int
                or item['matching_pointer_count'] < 1):
            errors.append(f'{manifest_path}: invalid recorded receipt address fields')
            continue
        path = Path(item['path'])
        if (not path.is_relative_to('Research/Artifacts') or '..' in path.parts
                or not re.fullmatch(r'[0-9a-f]{64}', item.get('sha256', ''))
                or not safe_parent_pointer(item.get('json_pointer_parent'))
                or item.get('key_suffix') not in {'gate/bin/judge-where.js', 'ibm-resident-acquisition-20260915/source/external/judge-where.js'}):
            errors.append(f'{manifest_path}: invalid recorded receipt address: {path}')
    reader = ARCHIVE / 'judge-where.js'
    if not (root / reader).is_file() or hashlib.sha256((root / reader).read_bytes()).hexdigest() != READER_SHA256:
        errors.append(f'{reader}: frozen reader bytes changed')
    consumers = manifest.get('consumers', {})
    if len(consumers) != 42 or 'Checks/README.md' in consumers:
        errors.append(f'{manifest_path}: expected 42 frozen executable consumers, got {len(consumers)}')
    for name, identity in (consumers | manifest.get("related_native_consumers", {})).items():
        file = root / name
        if not file.is_file() or hashlib.sha256(file.read_bytes()).hexdigest() != identity['frozen_sha256']:
            errors.append(f'{name}: frozen consumer bytes changed; revise the archive declaration explicitly')
    candidates = sorted(file for file in (root / 'Checks').rglob('*') if file.suffix in {'.js', '.py', '.sh'} and file.is_file())
    for file in candidates:
        text = file.read_text()
        violations = {match.start() for pattern in LIVE_PATHS for match in pattern.finditer(text)}
        violations.update(match.start() for match in re.finditer('VI_WHERE_' + 'JUDGE', text))
        for offset in sorted(violations):
            line = text.count('\n', 0, offset) + 1
            errors.append(f'{file.relative_to(root)}:{line}: live sibling reader or reader override is forbidden; use the frozen local archive')
        for line, content in enumerate(text.splitlines(), 1):
            if ('judge-where.js' in content and str(file.relative_to(root)) not in consumers
                    and str(file.relative_to(root)) not in ARCHIVE_IMPLEMENTATION):
                errors.append(f'{file.relative_to(root)}:{line}: undeclared archived-reader consumer')
    return errors


def main():
    errors = check(ROOT)
    if errors:
        print('\n'.join(errors), file=sys.stderr)
        return 1
    print(f'archive-where: 42 frozen executable consumers + 1 native; archive {REVISION}; distinct recorded reader in {RECEIPT_COUNT} receipt addresses; all Checks JS/Python/shell scanned; bytes hold')
    return 0


if __name__ == '__main__':
    sys.exit(main())
