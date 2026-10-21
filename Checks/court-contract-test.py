#!/usr/bin/env python3
"""Adversarial checks for the conformance reader, not for Swift semantics."""
import copy
import importlib.util
import json
from pathlib import Path
import shutil
import tempfile

HERE = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location('contract', HERE / 'court-contract.py')
contract = importlib.util.module_from_spec(spec)
spec.loader.exec_module(contract)
root, data = contract.load_contract(HERE.parent / 'Contracts/Court/v0.1/contract.json')
checks = 0


def check(value, name):
    global checks
    if not value:
        raise RuntimeError(name)
    checks += 1


for case in data['cases']:
    expected = case['expected']
    if 'lines' not in expected['stderr']:
        continue
    actual = {'exit': expected['exit'], 'stdout': '\n'.join(expected['stdout']['lines']) + ('\n' if expected['stdout']['lines'] else ''),
              'stderr': '\n'.join(expected['stderr']['lines']) + ('\n' if expected['stderr']['lines'] else '')}
    check(not contract.mismatches(actual, expected), case['id'] + ' positive')
    for channel in ('stdout', 'stderr'):
        changed = dict(actual)
        changed[channel] += 'unexpected verdict\n'
        check(bool(contract.mismatches(changed, expected)), case['id'] + ' extra output')
    changed = dict(actual, exit=(expected['exit'] + 1) % 3)
    check(bool(contract.mismatches(changed, expected)), case['id'] + ' exit mismatch')

rule = {'lines': ['left', 'right'], 'unordered': True}
check(contract.channel_matches('right\nleft\n', rule), 'independent order')
check(not contract.channel_matches('left\nleft\n', rule), 'duplicate cannot replace omitted branch')
check(not contract.channel_matches('left\nright\n\n', rule), 'extra blank line')
missing = next(c for c in data['cases'] if c['id'] == 'count-missing-file')['expected']
check(not contract.mismatches({'exit': 2, 'stdout': '', 'stderr': '✗ COUNT unresolved: intentionally-absent.swift: No such file or directory\n'}, missing), 'addressed input error')
check(bool(contract.mismatches({'exit': 2, 'stdout': '', 'stderr': '✗ COUNT unresolved: unrelated.swift: No such file or directory\n'}, missing)), 'wrong input address')
check(bool(contract.mismatches({'exit': 2, 'stdout': '', 'stderr': '✗ COUNT unresolved: intentionally-absent.swift outside the finite fragment\n'}, missing)), 'unsupported cannot replace input error')
check(bool(contract.mismatches({'error': 'TimeoutExpired'}, missing)), 'timeout cannot count as refusal')
check(bool(contract.mismatches({'error': 'FileNotFoundError'}, missing)), 'missing executable cannot count as input error')

check(contract.channel_matches('left\r\nright\r\n', rule), 'CRLF transport')
for separator in ['\r', '\v', '\f', '\u0085', '\u2028', '\u2029']:
    check(not contract.channel_matches('left' + separator + 'right\n', rule), 'non-line-feed separator')
    check(not contract.channel_matches('✗ COUNT unresolved: intentionally-absent.swift' + separator + ': No such file or directory\n', missing['stderr']), 'regex separator')

with tempfile.TemporaryDirectory(prefix='vi-contract-tests-') as tmp:
    target = Path(tmp) / 'contract'
    shutil.copytree(root, target)
    manifest = target / 'contract.json'
    original = manifest.read_text()
    for mutation in ('duplicate', 'empty', 'missing-present', 'changed-input', 'unbound-input', 'subset', 'version', 'expectation'):
        modified = json.loads(original)
        if mutation == 'duplicate': modified['cases'].append(copy.deepcopy(modified['cases'][0]))
        if mutation == 'empty': modified['cases'] = []
        if mutation == 'subset': modified['cases'] = modified['cases'][:-1]
        if mutation == 'version': modified['versions']['response'] = 'different/1'
        if mutation == 'expectation': modified['cases'][0]['expected']['exit'] = 2
        if mutation == 'missing-present': (target / modified['missing_files'][0]).write_text('unexpected')
        if mutation == 'changed-input': (target / next(iter(modified['files']))).write_text('changed')
        if mutation == 'unbound-input': modified['cases'][0]['files'] = ['fixtures/unbound.swift']
        manifest.write_text(json.dumps(modified))
        try:
            contract.load_contract(manifest)
        except (ValueError, OSError):
            check(True, mutation)
        else:
            check(False, mutation)
        shutil.rmtree(target)
        shutil.copytree(root, target)

print(f'court-contract reader: {checks} adversarial and control checks passed')

# The new release must be bound as a whole too. A port cannot report success
# after silently dropping a large case or replacing its arithmetic premise.
capacity_root, capacity = contract.load_contract(HERE.parent / 'Contracts/Court/v0.2/contract.json')
with tempfile.TemporaryDirectory(prefix='vi-capacity-contract-tests-') as tmp:
    target = Path(tmp) / 'contract'
    for mutation in ('positive', 'subset', 'expectation', 'changed-input', 'changed-arithmetic'):
        shutil.copytree(capacity_root, target)
        manifest = target / 'contract.json'
        modified = copy.deepcopy(capacity)
        if mutation == 'subset': modified['cases'] = modified['cases'][:-1]
        if mutation == 'expectation': modified['cases'][0]['expected']['exit'] = 2
        if mutation == 'changed-input': (target / modified['cases'][0]['files'][0]).write_text('changed')
        if mutation == 'changed-arithmetic': (target / 'arithmetic.json').write_text('{}')
        if mutation in ('subset', 'expectation'): manifest.write_text(json.dumps(modified))
        try:
            contract.load_contract(manifest)
        except (ValueError, OSError):
            check(mutation != 'positive', 'capacity ' + mutation)
        else:
            check(mutation == 'positive', 'capacity ' + mutation)
        shutil.rmtree(target)
print(f'court-contract reader: {checks} checks passed across both releases')

# A text checkout must not silently rewrite the byte-bound CRLF input into LF.
lines_root, lines_contract = contract.load_contract(HERE.parent / 'Contracts/Court/v0.3/contract.json')
with tempfile.TemporaryDirectory(prefix='vi-lines-contract-tests-') as tmp:
    target = Path(tmp) / 'contract'
    shutil.copytree(lines_root, target)
    fixture = target / 'fixtures/where-good-crlf.swift'
    raw = fixture.read_bytes()
    check(b'\r\n' in raw, 'line suite carries literal CRLF bytes')
    fixture.write_bytes(raw.replace(b'\r\n', b'\n'))
    try:
        contract.load_contract(target / 'contract.json')
    except ValueError:
        check(True, 'rewritten source bytes refused before judging')
    else:
        check(False, 'rewritten source bytes refused before judging')
print(f'court-contract reader: {checks} checks passed across three releases')

# Context and frozen stages are complete inputs too, not optional CLI decoration.
context_root, context_contract = contract.load_contract(HERE.parent / 'Contracts/Court/v0.4/contract.json')
for relative in ('fixtures/G-context.json', 'stages/context-g.json'):
    # Select the frozen context by its actual argv binding, not by a naming convention.
    if relative.endswith('G-context.json'):
        row = next(c for c in context_contract['cases'] if '--context' in c['args'])
        relative = row['args'][row['args'].index('--context') + 1]
    with tempfile.TemporaryDirectory(prefix='vi-context-contract-tests-') as tmp:
        target = Path(tmp) / 'contract'
        shutil.copytree(context_root, target)
        (target / relative).write_text('{}\n')
        try:
            contract.load_contract(target / 'contract.json')
        except ValueError:
            check(True, 'changed complete context/stage is refused')
        else:
            check(False, 'changed complete context/stage is refused')
_, sources_suite = contract.load_contract(HERE.parent / 'Contracts/Court/v0.5/contract.json')
expected = next(c['expected'] for c in sources_suite['cases'] if c['id'] == 'D-holds')
response = expected['response']
path = next(iter(response['results']))
answer = dict(schema='vi.court.sources/1', question='where', inputs=response['inputs'], outcome='holds',
              results=[dict(path=path, source=path, outcome='holds', equalities=1, memberships=0,
                            readings=0, unchecked=[], diagnostics=[])], diagnostics=[])
def structured(value):
    return dict(exit=0, stderr='', stdout=json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(',', ':')) + '\n')
check(not contract.mismatches(structured(answer), expected), 'source response positive')
for mutation in ('zero', 'missing', 'digest', 'extra', 'duplicate', 'outcome'):
    value = copy.deepcopy(answer)
    if mutation == 'zero': value['results'][0]['equalities'] = 0
    if mutation == 'missing': value['results'] = []
    if mutation == 'digest': value['inputs'][0]['sha256'] = '0' * 64
    if mutation == 'extra': value['extra'] = 1
    if mutation == 'duplicate': value['results'] *= 2
    if mutation == 'outcome': value['results'][0]['outcome'] = 'empty'
    check(bool(contract.mismatches(structured(value), expected)), 'source response rejects ' + mutation)
print(f'court-contract reader: {checks} checks passed across five releases')
