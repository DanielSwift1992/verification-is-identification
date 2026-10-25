#!/usr/bin/env python3
"""Run the versioned finite CLI contract against a supplied implementation.

The command is an argv array, never shell source. Expectations live in the
versioned manifest, separately from observed results. No output is accepted
on the strength of an exit code alone.
"""
from collections import Counter
from pathlib import Path
import argparse
import hashlib
import json
import re
import subprocess
import sys
import tempfile
import time


if __name__ == '__main__' and len(sys.argv) > 1 and sys.argv[1] == '--roster':
    ROOT=Path(__file__).resolve().parents[1]
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--tools',required=True)
    args=parser.parse_args(sys.argv[2:])
    manifest=ROOT/'Contracts/Court/roster-v1/contract.json'
    contract=json.loads(manifest.read_text())
    for case in contract['cases']:
        source=manifest.parent/case['input']
        assert hashlib.sha256(source.read_bytes()).hexdigest()==case['sha256'],case['id']
        result=subprocess.run([args.tools,'judge','roster',str(source),'--protocol',case['protocol']],capture_output=True,text=True)
        answer=json.loads(result.stdout)
        assert answer['schema']=='vi.court.roster/1' and not result.stderr,case['id']
        assert answer['outcome']==case['outcome'],(case['id'],answer['diagnostics'])
        assert [r['name'] for r in answer['records']]==case['records'],case['id']
        assert result.returncode==({'holds':0,'not-established':1}.get(case['outcome'],2)),case['id']
        if answer['outcome'] not in ('holds','empty'):
            assert any(str(source)+':' in d for d in answer['diagnostics']),case['id']
        else:
            with tempfile.TemporaryDirectory(prefix='vi-roster-replay-') as tmp:
                receipt=Path(tmp)/'response.json';receipt.write_text(result.stdout)
                replay=subprocess.run([args.tools,'judge','roster-replay',str(receipt),str(source),'--protocol',case['protocol']],capture_output=True,text=True)
                assert replay.returncode==result.returncode and replay.stdout==result.stdout,(case['id'],replay.stdout,replay.stderr)
        print('roster observation:',case['id'],answer['outcome'])
    print('Court roster observations: %d/%d'%(len(contract['cases']),len(contract['cases'])))

    replay_ref=contract['replay_cases']
    replay_path=manifest.parent/replay_ref['file']
    assert hashlib.sha256(replay_path.read_bytes()).hexdigest()==replay_ref['sha256']
    replay_cases=json.loads(replay_path.read_text())
    source=manifest.parent/replay_cases['input']
    assert hashlib.sha256(source.read_bytes()).hexdigest()==replay_cases['sha256']
    original=subprocess.run([args.tools,'judge','roster',str(source),'--protocol',replay_cases['protocol']],capture_output=True,text=True)
    assert original.returncode==0 and not original.stderr
    for case in replay_cases['cases']:
        proposed=json.loads(original.stdout)
        for edit in case.get('edits',[]):
            target=proposed
            for key in edit['path'][:-1]: target=target[key]
            target[edit['path'][-1]]=edit['value']
        text=json.dumps(proposed,ensure_ascii=False)
        if 'replace_text' in case:
            old,new=case['replace_text']; assert old in text
            text=text.replace(old,new)
        with tempfile.TemporaryDirectory(prefix='vi-roster-scalar-') as tmp:
            receipt=Path(tmp)/'response.json';receipt.write_text(text,encoding='utf-8')
            result=subprocess.run([args.tools,'judge','roster-replay',str(receipt),str(source),'--protocol',replay_cases['protocol']],capture_output=True,text=True)
            answer=json.loads(result.stdout)
            assert not result.stderr and answer['outcome']==case['outcome'],(case['id'],answer,result.stderr)
            assert [row['name'] for row in answer['records']]==case['records'],case['id']
            assert result.returncode==(0 if case['outcome']=='holds' else 2),case['id']
            if case['outcome']=='holds': assert result.stdout==original.stdout,case['id']
            else:
                assert any(str(receipt)+':1:' in d for d in answer['diagnostics']),(case['id'],answer)
                if 'diagnostic_contains' in case: assert any(case['diagnostic_contains'] in d for d in answer['diagnostics']),(case['id'],answer)
        print('roster replay observation:',case['id'],case['outcome'])
    print('Roster replay observations: %d/%d'%(len(replay_cases['cases']),len(replay_cases['cases'])))

    reading=contract['reading_cases']
    reading_path=manifest.parent/reading['file']
    assert hashlib.sha256(reading_path.read_bytes()).hexdigest()==reading['sha256']
    reading_cases=json.loads(reading_path.read_text())['cases']
    for case in reading_cases:
        with tempfile.TemporaryDirectory(prefix='vi-reading-address-') as tmp:
            paths=[]
            for name,text in case['files']:
                source=Path(tmp)/name
                source.write_bytes(text.encode('utf-8'))
                paths.append(str(source))
            result=subprocess.run([args.tools,'judge','roster',*paths,'--protocol',case['protocol']],capture_output=True,text=True)
            answer=json.loads(result.stdout)
            assert answer['outcome']==case['outcome'],(case['id'],answer)
            assert [row['name'] for row in answer['records']]==case['records'],case['id']
            assert result.returncode==({'holds':0,'not-established':1}.get(case['outcome'],2)),case['id']
            assert not result.stderr,case['id']
            if 'diagnostic' in case:
                expected=str(Path(tmp)/case['diagnostic'])
                assert len(answer['diagnostics'])==1 and answer['diagnostics'][0].startswith(expected),(case['id'],answer['diagnostics'])
            else:
                assert not answer['diagnostics'],case['id']
            print('reading address observation:',case['id'],answer['outcome'],*answer['diagnostics'])
    print('Reading address observations: %d/%d'%(len(reading_cases),len(reading_cases)))

    # These transformations reference the owner record once, never a copied roster.
    variants=json.loads((ROOT/'Contracts/Checks/law-record-controls.json').read_text())
    original=(ROOT/variants['source']).read_text()
    for case in variants['controls']:
        text=original + case['append'] if 'append' in case else original.replace(case['old'],case['new'],1)
        assert text!=original,case['id']
        with tempfile.TemporaryDirectory(prefix='vi-law-record-') as tmp:
            source=Path(tmp)/'Laws.swift';source.write_text(text)
            result=subprocess.run([args.tools,'judge','roster',str(source),'--protocol',variants['protocol']],capture_output=True,text=True)
            answer=json.loads(result.stdout)
            assert answer['outcome']==case['outcome'],(case['id'],answer['diagnostics'])
            assert result.returncode!=0 and any(str(source)+':' in d for d in answer['diagnostics']),case['id']
            print('law record observation:',case['id'],answer['outcome'])
    import importlib.util
    spec=importlib.util.spec_from_file_location('physical_host',ROOT/'Checks/profiles.py')
    host=importlib.util.module_from_spec(spec);spec.loader.exec_module(host)
    # Compiler checks the LawText obligation. Missing explicit Command is a
    # stricter Court-reader requirement: Swift can infer it from Command == Self.
    for case in variants['compiler_controls']:
        text=original.replace(case['old'],case['new'],1)
        assert text!=original,case['id']
        with tempfile.TemporaryDirectory(prefix='vi-law-compiler-') as tmp:
            source=Path(tmp)/'Checks'/'Laws.swift';source.parent.mkdir();source.write_text(text)
            result=subprocess.run(['swiftc','-typecheck',str(source)],capture_output=True,text=True)
            assert (result.returncode==0)==(case['exit']=='holds'),(case['id'],result.stderr)
            if result.returncode:
                assert str(source)+':' in result.stderr,(case['id'],result.stderr)
                try:
                    host.roster(Path(tmp))
                except ValueError as error:
                    assert 'compiler refused registry' in str(error) and 'Checks/Laws.swift:' in str(error),(case['id'],str(error))
                else:
                    raise AssertionError('bootstrap accepted an untyped command carrier')
            print('compiler observation:',case['id'],case['exit'],result.stderr.splitlines()[0] if result.stderr else '')
    baseline_result=subprocess.run([args.tools,'judge','roster',str(ROOT/variants['source']),'--protocol',variants['protocol']],capture_output=True,text=True)
    assert baseline_result.returncode==0,baseline_result.stdout
    baseline=host.records(json.loads(baseline_result.stdout))
    for case in variants['selection_controls']:
        text=original.replace(case['old'],case['new'],1)
        assert text!=original,case['id']
        with tempfile.TemporaryDirectory(prefix='vi-law-caption-') as tmp:
            source=Path(tmp)/'Laws.swift';source.write_text(text)
            result=subprocess.run([args.tools,'judge','roster',str(source),'--protocol',variants['protocol']],capture_output=True,text=True)
            answer=json.loads(result.stdout)
            assert result.returncode==0 and answer['outcome']=='holds',(case['id'],answer['diagnostics'])
            try:
                rows=host.records(answer)
            except ValueError as error:
                assert 'refusal' in case and case['refusal'] in str(error) and str(source)+':' in str(error),(case['id'],str(error))
                print('selection refusal:',str(error))
            else:
                assert 'refusal' not in case,case['id']
                chosen=host.selected(rows,profile=case.get('profile'))
                assert case['same_selection_as_source'],case['id']
                expected=host.selected(baseline,profile=case.get('profile'))
                identity=lambda rows:[tuple(row[key] for key in ('record','name','description','command','profile_normal','group_normal')) for row in rows]
                assert identity(chosen)==identity(expected),case['id']
                if 'normal' in case:
                    assert all(row['profile_normal']==case['normal'] for row in chosen),case['id']
            print('selection observation:',case['id'])
    sys.exit(0)


# An immutable suite name binds the exact manifest bytes, including its case set.
# New normative expectations require a new release and a deliberate registry entry.
SUITE_HASHES = {
    "vi.court.context-binding-replay/2": "4dcabb44bc13b5111625c549ffd8b260b0a6259a10641f451e877b0db720756d",
    "vi.court.questions/0.4-resolution3": "4544c4183e0ce70094b3c5de3deb9951053c50b347519aaea7efe48739f72c81",
    "vi.court.questions/0.5-resolution3": "d584957cba593fb813d92197fbc77ed9eee92a9788590c7b46990db420764e88",
    "vi.court.context-owners/3": "6ef0c0b9cbbb199b1bcce1e3d2f6e81f89b2f5fdc6f0b337294c2bff786c9e22",
    "vi.court.context-owner-members/2": "df45b6b08e08d21003b1a195ea711ffafb6b9939170697e225e9f8a27ded4960",
    "vi.court.context-names/3": "576e004f53b94d5a69f1dcead7a5a5f7634b829c18740a2322563bfc00a8dce2",
    "vi.court.context-owner-views/2": "1c6c0485f43269a98ca0a6009ba04a8b0d206a239d7affe56ea9605939ac92ed",
    "vi.court.context-resolution/3": "fb9b66517c481617f992870e877d7f4892a02498ec7998996595cd663e51855a",
    "vi.court.context-extension-owners/1": "c36394bfea20c0e1dfd1cbc3d8757d905bf3f041e9131980e0fb0d015530d82a",
    "vi.court.context-names/2": "ec65323d307ec205e11443383fd72786e54d22d0b0ffbbe318541f82d8e7a10c",
    "vi.court.context-binding-replay/1": "570b4cd1ee89e2c5532442a3edeec1f49b2b0d6e989bde70c2cc98c1d1ce4e1c",
    "vi.court.context-owners/2": "f53b4d488bbdbcad35bcb863627c76aeb16301eb193a9d7c5853b10521130bbb",
    "vi.court.context-owner-members/1": "01015a4443c5c2f139f7fd5536e10ec84cd96fb678ace3cf731f3699b42ff606",
    "vi.court.context-owner-views/1": "751472c985299887876b81c274930345d1e3888c0bb91a5d624a6f6f4840ed7e",
    "vi.court.context-owners/1": "5a3956c85e957008c1657b0ca507042ecc42c73aea7bc2f57468a7ba13b8eed8",
    "vi.court.context-names/1": "775a7afe429e3e21b0d96d6f3573b6c0940fe618d88150cc5405e1a855a46230",
    "vi.court.questions/0.5": "505cfa1aa409ae98f8666437330084d85c105e963b6f705490565a78603e3808",
    "vi.court.questions/0.4": "25c7b65d5dc27f1a669139061f3b166c47897a460f3967b65d99d1c30ee8b47d",
    "vi.court.questions/0.3": "85386b2809b8d36a8f74c59df6c8a6768ee10747b3850b1e2c4bf123cdf746ef",
    "vi.court.questions/0.2": "89803c35cccd5f1c3cf8f2cc451a60e08b7a82d8195b6289f9c3475eb71a54c9",
    "vi.court.questions/0.1": "f6092c3c2bcfed822ee8aef878bb2b0d42c2756ec4fc002026d6d5a9fdfd54e6",
}


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def within(root, name):
    path = (root / name).resolve()
    if not path.is_relative_to(root):
        raise ValueError(f"input escapes contract directory: {name}")
    return path


def load_contract(path):
    root = path.resolve().parent
    contract = json.loads(path.read_text())
    if contract.get('schema') not in ('vi.court.conformance/1', 'vi.court.conformance/2'):
        raise ValueError('unknown manifest schema')
    expected_hash = SUITE_HASHES.get(contract.get('suite'))
    if expected_hash is None or digest(path) != expected_hash:
        raise ValueError('unregistered or changed manifest for this suite identity')
    cases = contract['cases']
    ids = [case['id'] for case in cases]
    if not cases or len(ids) != len(set(ids)):
        raise ValueError('empty or duplicate case list')
    absent = set(contract['missing_files'])
    for name in absent:
        if within(root, name).exists():
            raise ValueError(f'missing-file control exists: {name}')
    for name, entry in contract['files'].items():
        if digest(within(root, name)) != entry['sha256']:
            raise ValueError(f'fixture hash mismatch: {name}')
    for name, expected in contract.get('stages', {}).items():
        if digest(within(root, name)) != expected:
            raise ValueError(f'frozen case-set hash mismatch: {name}')
    for case in cases:
        if '--bindings' in case['args']:
            index = case['args'].index('--bindings')
            if index + 1 >= len(case['args']) or case['args'][index + 1] not in contract['files']:
                raise ValueError(f"unbound binding certificate: {case['id']}")
        if '--context' in case['args']:
            index = case['args'].index('--context')
            if index + 1 >= len(case['args']) or case['args'][index + 1] not in contract['files']:
                raise ValueError(f"unbound context input: {case['id']}")
        if case['pass'] not in ('where', 'count') or not case['files']:
            raise ValueError(f"invalid pass or empty inputs: {case['id']}")
        if not set(case['files']) <= set(contract['files']) | absent:
            raise ValueError(f"unbound input: {case['id']}")
        compiler = case.get('compiler', {})
        native_files = list(compiler.get('files', case['files']))
        module_names = []
        for module in compiler.get('modules', []):
            if set(module) != {'name', 'files'} or not re.fullmatch(r'[A-Za-z_][A-Za-z_0-9]*', module['name']):
                raise ValueError(f"invalid compiler module: {case['id']}")
            module_names.append(module['name'])
            native_files.extend(module['files'])
        if len(module_names) != len(set(module_names)) or set(native_files) != set(case['files']):
            raise ValueError(f"compiler inputs differ from judged sources: {case['id']}")
        if 'module' in compiler:
            if len(native_files) != len(set(native_files)) or not compiler.get('files'):
                raise ValueError(f"compiler source owners overlap or have no primary: {case['id']}")
            if '--context' not in case['args']:
                raise ValueError(f"compiler module plan has no judged context: {case['id']}")
            context_name = case['args'][case['args'].index('--context') + 1]
            context = json.loads(within(root, context_name).read_bytes())
            owners = {source['input']: source.get('module', source['namespace']) for source in context['sources']}
            plans = compiler.get('modules', []) + [{'name': compiler['module'], 'files': compiler['files']}]
            for module in plans:
                if not re.fullmatch(r'[A-Za-z_][A-Za-z_0-9]*', module['name']):
                    raise ValueError(f"invalid compiler module: {case['id']}")
                if not module['files'] or any(owners.get(name) != module['name'] for name in module['files']):
                    raise ValueError(f"compiler module differs from context owner: {case['id']}")
        if 'response' in case['expected']:
            if contract['schema'] != 'vi.court.conformance/2' or '--report' not in case['args']:
                raise ValueError(f"undeclared structured response: {case['id']}")
            response = case['expected']['response']
            context_path = case['args'][case['args'].index('--context') + 1]
            wanted = [{'path': name, 'sha256': contract['files'][name]['sha256']}
                      for name in sorted(case['files'] + [context_path]
                          + ([case['args'][case['args'].index('--bindings') + 1]] if '--bindings' in case['args'] else []))]
            if response['inputs'] != wanted or response['question'] != case['pass']:
                raise ValueError(f"changed structured question binding: {case['id']}")
            if not set(response['results']) <= set(case['files']):
                raise ValueError(f"result outside source roster: {case['id']}")
            continue
        for channel in ('stdout', 'stderr'):
            rule = case['expected'][channel]
            if ('lines' in rule) == ('line_patterns' in rule):
                raise ValueError(f"ambiguous output rule: {case['id']}")
            for pattern in rule.get('line_patterns', []):
                re.compile(pattern)
    return root, contract


def channel_matches(text, rule):
    # CRLF is the only permitted transport normalization. VT/CR/Unicode
    # separators cannot hide a required LF-delimited record.
    text = text.replace('\r\n', '\n')
    if any(separator in text for separator in ('\r', '\v', '\f', '\u0085', '\u2028', '\u2029')):
        return False
    if text and not text.endswith('\n'):
        return False
    lines = text[:-1].split('\n') if text else []
    if 'lines' in rule:
        wanted = rule['lines']
        return Counter(lines) == Counter(wanted) if rule.get('unordered') else lines == wanted
    patterns = rule['line_patterns']
    return len(lines) == len(patterns) and all(re.fullmatch(p, line) for p, line in zip(patterns, lines))


def response_mismatches(actual, expected):
    failures = []
    if actual['stderr']:
        failures.append('structured stderr')
    try:
        answer = json.loads(actual['stdout'])
        if set(answer) != {'schema', 'question', 'inputs', 'outcome', 'results', 'diagnostics'}:
            raise ValueError('response fields')
        canonical = json.dumps(answer, ensure_ascii=False, sort_keys=True, separators=(',', ':')) + '\n'
        if actual['stdout'] != canonical:
            failures.append('noncanonical response bytes')
        if answer['schema'] != 'vi.court.sources/1' or answer['question'] != expected['question']:
            failures.append('response identity')
        if answer['inputs'] != expected['inputs']:
            failures.append('original input byte roster')
        if answer['outcome'] != expected['outcome']:
            failures.append('aggregate outcome')
        if not isinstance(answer['diagnostics'], list) or not all(isinstance(s, str) for s in answer['diagnostics']):
            raise ValueError('global diagnostics')
        rows = answer['results']
        if not isinstance(rows, list):
            raise ValueError('results array')
        if [r['path'] for r in rows] != sorted(expected['results']):
            failures.append('source coverage')
        all_diagnostics = list(answer['diagnostics'])
        for row in rows:
            if set(row) != {'path', 'source', 'outcome', 'equalities', 'memberships', 'readings', 'unchecked', 'diagnostics'}:
                raise ValueError('result fields')
            for key in ('equalities', 'memberships', 'readings'):
                if type(row[key]) is not int or row[key] < 0:
                    raise ValueError('result counter')
            for key in ('unchecked', 'diagnostics'):
                if not isinstance(row[key], list) or not all(isinstance(s, str) for s in row[key]):
                    raise ValueError('result addresses/diagnostics')
            count = row['equalities'] + row['memberships'] + row['readings']
            if row['outcome'] == 'holds' and count == 0 or row['outcome'] == 'empty' and count != 0:
                failures.append('empty/holds checked count')
            spec = expected['results'].get(row['path'])
            if spec:
                if row['outcome'] != spec['outcome'] or row['source'] != spec['source']:
                    failures.append('source outcome/address: ' + row['path'])
                if not set(spec.get('unchecked_contain', [])) <= set(row['unchecked']):
                    failures.append('unchecked coverage: ' + row['path'])
                for key, minimum in spec.get('minimum', {}).items():
                    if row[key] < minimum:
                        failures.append('checked count: ' + row['path'])
            all_diagnostics.extend(row['diagnostics'])
        for fragment in expected.get('diagnostics_contain', []):
            if not any(fragment in text for text in all_diagnostics):
                failures.append('missing diagnostic: ' + fragment)
    except (ValueError, TypeError, KeyError, AttributeError) as exc:
        failures.append('invalid structured response: ' + str(exc))
    return failures


def mismatches(actual, expected):
    if actual.get('error'):
        return [actual['error']]
    failures = []
    if actual['exit'] != expected['exit']:
        failures.append('exit')
    if 'response' in expected:
        return failures + response_mismatches(actual, expected['response'])
    for channel in ('stdout', 'stderr'):
        if not channel_matches(actual[channel], expected[channel]):
            failures.append(channel)
    return failures


def run(argv, root, timeout):
    start = time.monotonic()
    try:
        result = subprocess.run(argv, cwd=root, capture_output=True, timeout=timeout)
        return {'argv': argv, 'exit': result.returncode, 'stdout': result.stdout.decode('utf-8', errors='replace'),
                'stderr': result.stderr.decode('utf-8', errors='replace'), 'seconds': round(time.monotonic() - start, 6)}
    except (OSError, subprocess.TimeoutExpired) as exc:
        return {'argv': argv, 'exit': None, 'stdout': '', 'stderr': '',
                'error': type(exc).__name__, 'detail': str(exc),
                'seconds': round(time.monotonic() - start, 6)}


def compiler_failures(actual, expected):
    if actual.get('error'):
        return [actual['error']]
    errors = []
    if actual['exit'] != expected['exit'] or actual['stdout']:
        errors.append('compiler exit/stdout')
    if expected['diagnostic'] == 'none':
        if actual['stderr']:
            errors.append('compiler diagnostic')
    elif expected['diagnostic'] == 'equivalence':
        lines = re.findall(r'^.*:\d+:\d+: error:.*$', actual['stderr'], re.M)
        if len(lines) != 1 or 'requires the types' not in lines[0] or 'be equivalent' not in lines[0]:
            errors.append('compiler equivalence diagnostic')
    elif expected['diagnostic'] == 'addressed':
        if not re.search(r'^.*:\d+:\d+: error:', actual['stderr'], re.M):
            errors.append('compiler addressed diagnostic')
        for fragment in expected.get('diagnostics_contain', []):
            if fragment not in actual['stderr']:
                errors.append('compiler diagnostic: ' + fragment)
    else:
        errors.append('unknown compiler diagnostic expectation')
    return errors


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--manifest', type=Path, default=Path(__file__).resolve().parents[1] / 'Contracts/Court/v0.1/contract.json')
    parser.add_argument('--command-json', required=True, help='JSON argv prefix, e.g. ["/absolute/Tools", "judge"]')
    parser.add_argument('--implementation-id', required=True, help='caller-supplied identity; not proof of a source/binary correspondence')
    parser.add_argument('--compiler', help='optional Swift compiler for the six compiler-backed fixtures')
    parser.add_argument('--report', type=Path)
    parser.add_argument('--timeout', type=float, default=60)
    args = parser.parse_args()
    try:
        command = json.loads(args.command_json)
        if not isinstance(command, list) or not command or not all(isinstance(s, str) and s for s in command):
            raise ValueError('command must be a nonempty array of strings')
        if args.timeout <= 0:
            raise ValueError('timeout must be positive')
        root, contract = load_contract(args.manifest)
        executable = Path(command[0])
        if not executable.is_absolute():
            raise ValueError('command executable must have an absolute path')
        report = {'schema': 'vi.court.conformance-report/1', 'suite': contract['suite'],
                  'manifest_sha256': digest(args.manifest), 'versions': contract['versions'],
                  'implementation_id': args.implementation_id, 'command': command,
                  'executable_sha256': digest(executable),
                  'identity_scope': 'Executable hash and caller label only; wrapper/interpreter dependencies need a separate build receipt.',
                  'compiler_requested': bool(args.compiler), 'results': []}
        with tempfile.TemporaryDirectory(prefix='vi-court-contract-') as tmp:
            for case in contract['cases']:
                actual = run(command + [case['pass']] + case['files'] + case['args'], root, args.timeout)
                failures = mismatches(actual, case['expected'])
                row = {'id': case['id'], 'expected_outcome_for_this_case': case['expected']['outcome_for_this_case'],
                       'actual': actual, 'mismatches': failures}
                if args.compiler and 'compiler' in case:
                    native = Path(tmp) / case['id']
                    native.mkdir()
                    stages = []
                    for module in case['compiler'].get('modules', []):
                        stage = run([args.compiler, '-emit-module', '-module-name', module['name'],
                                     '-I', str(native), '-module-cache-path', tmp + '/cache',
                                     '-emit-module-path', str(native / (module['name'] + '.swiftmodule'))]
                                    + module['files'], root, args.timeout)
                        stages.append(stage)
                        if stage.get('exit') != 0:
                            failures.append('compiler prerequisite module: ' + module['name'])
                            break
                    row['compiler_modules'] = stages
                    module_args = ['-module-name', case['compiler']['module']] if 'module' in case['compiler'] else []
                    compiled = run([args.compiler, '-typecheck', *module_args, '-I', str(native), '-module-cache-path', tmp + '/cache']
                                   + case['compiler'].get('files', case['files']), root, args.timeout)
                    row['compiler'] = compiled
                    failures.extend(compiler_failures(compiled, case['compiler']))
                row['matched'] = not failures
                report['results'].append(row)
                print(('PASS ' if row['matched'] else 'FAIL ') + case['id'] + (': ' + ', '.join(failures) if failures else ''))
        report['passed'] = all(r['matched'] for r in report['results'])
        report['claim'] = 'This implementation matched this finite CLI suite.' if report['passed'] else 'This implementation did not match this finite CLI suite.'
        if args.report:
            args.report.parent.mkdir(parents=True, exist_ok=True)
            args.report.write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')
        print(f"{sum(r['matched'] for r in report['results'])}/{len(report['results'])} cases matched; general equivalence is not established")
        return 0 if report['passed'] else 1
    except (OSError, ValueError, KeyError, TypeError) as exc:
        print(f'court-contract: {exc}', file=sys.stderr)
        return 2


if __name__ == '__main__':
    sys.exit(main())
