#!/usr/bin/env python3
"""The original 27 paired CLI cases and two native publication controls."""
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
    for case in cases:
        if case['id'] not in manifest['native_controls']:
            continue
        request, expected = case['request'], case['expected']
        state.write_text(request['state'], encoding='utf-8')
        rules.write_text(request['dictionary'], encoding='utf-8')
        result = subprocess.run(command + request['arguments'] + ['--file', str(state), '--rules', str(rules)], capture_output=True, text=True)
        refused = expected['refusal'] is not None
        ok = result.returncode == int(refused) and state.read_bytes() == expected['state'].encode('utf-8')
        ok = ok and ((not result.stdout and expected['refusal']['reason_contains'] in result.stderr) if refused else (not result.stderr and result.stdout.startswith(('pressed ', 'no-op: '))))
        results.append((case['id'], ok))
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
