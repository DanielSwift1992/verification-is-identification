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

# These controls reach module-plan validation after digest admission; they do
# not claim anything about Swift semantics. The temporary suite identity is
# local to this process and never accepted by the production command.
names_root, names_suite = contract.load_contract(HERE.parent / 'Contracts/Court/context-names-v1/contract.json')
with tempfile.TemporaryDirectory(prefix='vi-module-contract-tests-') as tmp:
    target = Path(tmp) / 'contract'
    shutil.copytree(names_root, target)
    manifest = target / 'contract.json'
    for mutation in ('omitted-module-file', 'changed-module-owner', 'overlapping-source', 'escaping-module', 'no-context'):
        value = copy.deepcopy(names_suite)
        value['suite'] = 'local-test.module-plan/1'
        case = value['cases'][0]
        if mutation == 'omitted-module-file': case['compiler']['modules'][0]['files'] = []
        if mutation == 'changed-module-owner': case['compiler']['modules'][0]['name'] = 'Other'
        if mutation == 'overlapping-source': case['compiler']['files'] += case['compiler']['modules'][0]['files']
        if mutation == 'escaping-module': case['compiler']['modules'][0]['name'] = '../Other'
        if mutation == 'no-context': case['args'] = []
        manifest.write_text(json.dumps(value))
        contract.SUITE_HASHES[value['suite']] = contract.digest(manifest)
        try:
            contract.load_contract(manifest)
        except ValueError:
            check(True, 'module plan refuses ' + mutation)
        else:
            check(False, 'module plan refuses ' + mutation)
    del contract.SUITE_HASHES['local-test.module-plan/1']

    # Even a positive Court reply and successful primary compilation cannot
    # hide a prerequisite compiler failure. Only the physical executor is
    # replaced here; the ordinary command, manifest reader and reporter run.
    import contextlib
    import io
    import sys
    value = copy.deepcopy(names_suite)
    value['suite'] = 'local-test.module-failure/1'
    value['cases'] = [value['cases'][0]]
    manifest.write_text(json.dumps(value))
    contract.SUITE_HASHES[value['suite']] = contract.digest(manifest)
    original_run, original_argv = contract.run, sys.argv
    def module_failure(argv, root, timeout):
        result = dict(argv=argv, exit=0, stdout='', stderr='', seconds=0)
        if '-emit-module' in argv:
            result.update(exit=1, stderr='Kit.swift:1:1: error: failed prerequisite\n')
        elif '-typecheck' not in argv:
            result['stdout'] = '✓ THE WHERE holds: 1 equalities and 0 memberships judged across 0 uses, the certificates, and the gated conformers, source-replayed definition reductions (canon v4).\n'
        return result
    report = target / 'observed.json'
    try:
        contract.run = module_failure
        sys.argv = ['court-contract.py', '--manifest', str(manifest), '--command-json', json.dumps([sys.executable]),
                    '--implementation-id', 'physical failure control', '--compiler', 'injected-swiftc', '--report', str(report)]
        with contextlib.redirect_stdout(io.StringIO()):
            status = contract.main()
    finally:
        contract.run, sys.argv = original_run, original_argv
        del contract.SUITE_HASHES['local-test.module-failure/1']
    observed = json.loads(report.read_text())
    check(status == 1 and not observed['passed'], 'failed prerequisite cannot become a successful suite')
    row = observed['results'][0]
    check(row['actual']['exit'] == 0 and row['compiler']['exit'] == 0 and row['compiler_modules'][0]['exit'] == 1
          and any('prerequisite module' in text for text in row['mismatches']), 'prerequisite failure survives successful neighbors')
print(f'court-contract reader: {checks} checks including source-bound module delivery')

# A native module plan remains byte-bound when Court deliberately has no
# source context. The context below belongs to the compiler observation only.
with tempfile.TemporaryDirectory(prefix='vi-native-context-tests-') as tmp:
    target = Path(tmp) / 'contract'
    for mutation in ('positive', 'unbound', 'two-contexts', 'changed-source-hash', 'missing-owner', 'wrong-schema', 'duplicate-owner', 'no-module-plan', 'unknown-failure-stage', 'successful-failure-stage'):
        shutil.copytree(names_root, target)
        value = copy.deepcopy(names_suite)
        value['suite'] = 'local-test.native-context/1'
        value['cases'] = [value['cases'][0]]
        case = value['cases'][0]
        context_name = case['args'][case['args'].index('--context') + 1]
        case['args'] = []
        case['compiler']['context'] = context_name
        if mutation == 'unbound': case['compiler']['context'] = 'absent-context.json'
        if mutation == 'two-contexts': case['args'] = ['--context', context_name]
        if mutation in ('changed-source-hash', 'missing-owner', 'wrong-schema', 'duplicate-owner'):
            context_path = target / context_name
            context = json.loads(context_path.read_text())
            if mutation == 'changed-source-hash': context['sources'][0]['sha256'] = '0' * 64
            elif mutation == 'missing-owner': context['sources'] = context['sources'][:-1]
            elif mutation == 'wrong-schema': context['schema'] = 'unsupported/1'
            else: context['sources'].append(copy.deepcopy(context['sources'][0]))
            context_path.write_text(json.dumps(context))
            value['files'][context_name]['sha256'] = contract.digest(context_path)
        if mutation == 'no-module-plan': del case['compiler']['module']
        if mutation == 'unknown-failure-stage':
            case['compiler'].update(failure_stage='Unprovided', exit=1)
        if mutation == 'successful-failure-stage':
            case['compiler'].update(failure_stage=case['compiler']['modules'][0]['name'], exit=0)
        manifest = target / 'contract.json'
        manifest.write_text(json.dumps(value))
        contract.SUITE_HASHES[value['suite']] = contract.digest(manifest)
        try:
            contract.load_contract(manifest)
        except ValueError:
            check(mutation != 'positive', 'native context ' + mutation)
        else:
            check(mutation == 'positive', 'native context ' + mutation)
        finally:
            del contract.SUITE_HASHES[value['suite']]
            shutil.rmtree(target)

    shutil.copytree(names_root, target)
    value = copy.deepcopy(names_suite)
    value['suite'] = 'local-test.declared-native-failure/1'
    value['cases'] = [value['cases'][0]]
    case = value['cases'][0]
    case['compiler'].update(failure_stage=case['compiler']['modules'][0]['name'], exit=1, diagnostic='addressed')
    case['expected'] = dict(exit=2, outcome_for_this_case='unsupported', stdout=dict(lines=[]), stderr=dict(lines=['outside fragment']))
    manifest = target / 'contract.json'
    manifest.write_text(json.dumps(value))
    contract.SUITE_HASHES[value['suite']] = contract.digest(manifest)
    original_run, original_argv = contract.run, sys.argv
    report = target / 'observed.json'
    try:
        for actual_exit in (1, 0, 2):
            def declared_failure(argv, root, timeout):
                if '-emit-module' in argv:
                    return dict(argv=argv, exit=actual_exit, stdout='', stderr='Kit.swift:1:1: error: failed prerequisite\n' if actual_exit else '', seconds=0)
                return dict(argv=argv, exit=2, stdout='', stderr='outside fragment\n', seconds=0)
            contract.run = declared_failure
            sys.argv = ['court-contract.py', '--manifest', str(manifest), '--command-json', json.dumps([sys.executable]),
                        '--implementation-id', 'declared physical failure control', '--compiler', 'injected-swiftc', '--report', str(report)]
            with contextlib.redirect_stdout(io.StringIO()):
                status = contract.main()
            check((status == 0) == (actual_exit == 1), 'declared native failure requires its exact exit ' + str(actual_exit))
            observed = json.loads(report.read_text())['results'][0]
            check('compiler failure stage' in observed['mismatches'] if actual_exit == 0 else observed['compiler_observation_stage'].startswith('module:'),
                  'declared native failure records its actual stage ' + str(actual_exit))
    finally:
        contract.run, sys.argv = original_run, original_argv
        del contract.SUITE_HASHES[value['suite']]

warning = dict(exit=0, diagnostic='warnings')
check(not contract.compiler_failures(dict(exit=0, stdout='', stderr='World.swift:1:1: warning: notice\n'), warning), 'native success permits a warning')
check(bool(contract.compiler_failures(dict(exit=0, stdout='', stderr='World.swift:1:1: error: hidden failure\n'), warning)), 'native warning allowance cannot hide an error')
print(f'court-contract reader: {checks} checks including context-free native ownership and declared failures')
