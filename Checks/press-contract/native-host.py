#!/usr/bin/env python3
"""Declared native cases from both Press suites, plus publication controls."""
import importlib.util
import json
from pathlib import Path
import subprocess
import sys
import tempfile

root = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location('contract', root / 'Checks/press-contract.py')
contract = importlib.util.module_from_spec(spec)
spec.loader.exec_module(contract)
manifest, cases = contract.load_contract(root / 'Contracts/Press/v0.1/contract.json')
command = json.loads(sys.argv[1])
results = []
with tempfile.TemporaryDirectory(prefix='press-native-') as tmp:
    directory = Path(tmp)
    state = directory / 'state.swift'
    rules = directory / 'rules.swift'
    manifests = [(manifest, cases), contract.load_contract(root / 'Contracts/Press/v0.2/contract.json')]
    for suite, observations in manifests:
        for case in observations:
            if case['id'] not in suite.get('native_controls', []):
                continue
            request, expected = case['request'], case['expected']
            state.write_bytes(request['state'].encode('utf-8'))
            rules.write_bytes(request['dictionary'].encode('utf-8'))
            paths = {request.get('statePath', 'state.swift'): str(state), request.get('dictionaryPath', 'rules.swift'): str(rules)}
            args = command + request['arguments'] + ['--file', str(state), '--rules', str(rules)]
            inputs = {rules: rules.read_bytes()}
            for index, definition in enumerate(request.get('definitions', [])):
                path = directory / ('definition-' + str(index) + '.swift')
                path.write_bytes(definition['text'].encode('utf-8'))
                paths[definition['path']] = str(path)
                inputs[path] = path.read_bytes()
                args += ['--definitions', str(path)]
            result = subprocess.run(args, capture_output=True, text=True)
            refused = expected['refusal'] is not None
            ok = result.returncode == int(refused) and state.read_bytes() == expected['state'].encode('utf-8')
            if refused:
                address = expected['refusal']['address']
                reason = expected['refusal']['reason_contains']
                for original, actual in paths.items():
                    address = address.replace(original, actual)
                    reason = reason.replace(original, actual)
                ok = ok and not result.stdout and reason in result.stderr and address in result.stderr
            else:
                ok = ok and not result.stderr and result.stdout.startswith(('pressed ', 'no-op: '))
            ok = ok and all(path.read_bytes() == data for path, data in inputs.items())
            results.append((suite['suite'] + '/' + case['id'], ok))
    state.write_text('extension Words {\n public static var typeName: String { "𐐀" }\n}\n', encoding='utf-8')
    result = subprocess.run(command + ['rubout', 'Words', '--file', str(state), '--rules', str(directory / 'absent.swift')], capture_output=True, text=True)
    results.append(('literal-does-not-read-dictionary', result.returncode == 0 and '{ "" }' in state.read_text() and not result.stderr))
    case = cases[0]
    state.write_text(case['request']['state'], encoding='utf-8')
    rules.write_text(case['request']['dictionary'], encoding='utf-8')
    directory.chmod(0o555)
    try:
        result = subprocess.run(command + ['TurnOn', '--file', str(state), '--rules', str(rules)], capture_output=True, text=True)
        results.append(('atomic-write-denied', result.returncode == 1 and not result.stdout and bool(result.stderr) and state.read_bytes() == case['request']['state'].encode()))
    finally:
        directory.chmod(0o755)
for name, ok in results:
    print(('PASS ' if ok else 'FAIL ') + name)
if len(sys.argv) > 2:
    Path(sys.argv[2]).write_text(json.dumps(results, indent=2) + '\n')
print(str(sum(ok for _, ok in results)) + '/' + str(len(results)))
sys.exit(0 if all(ok for _, ok in results) else 1)
