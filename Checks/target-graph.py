#!/usr/bin/env python3
"""Check the compiler's target graph and the source import boundary."""
import copy
import json
from pathlib import Path
import re
import subprocess

ROOT = Path(__file__).resolve().parent.parent


def validate(targets, sources, dependencies):
    assert len(dependencies) == 1 and 'https://github.com/swiftlang/swift-docc-plugin' in json.dumps(dependencies), 'Package.swift: vi may take only its documentation plugin; reverse package dependency refused'
    expected = {
        'Notation': set(),
        'Alphabet': {'Notation'},
        'VerificationIsIdentification': {'Notation'},
        'DocumentKit': {'Notation', 'Alphabet'},
        'DocumentKitCertificates': {'DocumentKit', 'VerificationIsIdentification'},
    }
    for name, dependencies in expected.items():
        assert name in targets, 'missing target: ' + name
        actual = {edge[next(iter(edge))][0] for edge in targets[name]['dependencies']}
        assert actual == dependencies, name + ': dependency boundary differs'
    for name, allowed in [('Notation', set()), ('DocumentKit', {'Notation', 'Alphabet'})]:
        for path, text in sources[name].items():
            imports = re.findall(r'^\s*(?:@\w+(?:\([^\n]*?\))?\s+)?import\s+(?:(?:typealias|struct|class|enum|protocol|let|var|func)\s+)?(\w+)', text, re.M)
            assert set(imports) <= allowed, path + ': import outside target boundary'
    for name in ['DocumentKit', 'DocumentKitCertificates']:
        assert targets[name]['pluginUsages'] == [{'plugin': ['LawCheck', None]}], name + ': strict LawCheck absent'
    assert '@_exported import Notation' in (ROOT / 'Sources/VerificationIsIdentification/Exports.swift').read_text()


manifest = json.loads(subprocess.check_output(['swift', 'package', 'dump-package'], cwd=ROOT))
targets = {t['name']: t for t in manifest['targets']}
sources = {name: {str(p.relative_to(ROOT)): p.read_text() for p in (ROOT / 'Sources' / name).glob('*.swift')}
           for name in ['Notation', 'DocumentKit']}
validate(targets, sources, manifest['dependencies'])
for target, dependency in [('Notation', 'Alphabet'), ('DocumentKit', 'VerificationIsIdentification')]:
    broken = copy.deepcopy(targets)
    broken[target]['dependencies'].append({'byName': [dependency, None]})
    try:
        validate(broken, sources, manifest['dependencies'])
    except AssertionError:
        pass
    else:
        raise AssertionError('admitted forbidden edge: ' + target)
for target, module in [('Notation', 'Foundation'), ('DocumentKit', 'VerificationIsIdentification')]:
    broken = copy.deepcopy(sources)
    broken[target]['negative-control.swift'] = 'import ' + module + '\n'
    try:
        validate(targets, broken, manifest['dependencies'])
    except AssertionError:
        pass
    else:
        raise AssertionError('admitted forbidden import: ' + target)
try:
    validate(targets, sources, manifest['dependencies'] + [{'sourceControl': [{'location': 'https://github.com/DanielSwift1992/verification-is-identification-showcase'}]}])
except AssertionError:
    pass
else:
    raise AssertionError('admitted reverse package dependency on showcase')
print('target graph: exact boundaries, reexport, strict plugins; five forbidden twins refused')
