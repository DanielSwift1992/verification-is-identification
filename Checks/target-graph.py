#!/usr/bin/env python3
"""Check the compiler's target graph and the source import boundary."""
import copy
import json
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parent.parent


def validate(targets, dependencies):
    assert len(dependencies) == 1 and 'https://github.com/swiftlang/swift-docc-plugin' in json.dumps(dependencies), 'Package.swift: vi may take only its documentation plugin; reverse package dependency refused'
    expected = {
        'Notation': set(),
        'Alphabet': {'Notation'},
        'VerificationIsIdentification': {'Notation'},
        'DocumentKit': {'Notation', 'Alphabet'},
        'DocumentKitCertificates': {'DocumentKit', 'VerificationIsIdentification'},
        'ContinuationRecord': set(),
        'RecordCourt': {'ContinuationRecord'},
        'Court': {'ContinuationRecord'},
    }
    for name, dependencies in expected.items():
        assert name in targets, 'missing target: ' + name
        actual = {edge[next(iter(edge))][0] for edge in targets[name]['dependencies']}
        assert actual == dependencies, name + ': dependency boundary differs'
    for name in ['DocumentKit', 'DocumentKitCertificates']:
        assert targets[name]['pluginUsages'] == [{'plugin': ['LawCheck', None]}], name + ': strict LawCheck absent'
    assert '@_exported import Notation' in (ROOT / 'Sources/VerificationIsIdentification/Exports.swift').read_text()


manifest = json.loads(subprocess.check_output(['swift', 'package', 'dump-package'], cwd=ROOT))
targets = {t['name']: t for t in manifest['targets']}
validate(targets, manifest['dependencies'])
for target, dependency in [('Notation', 'Alphabet'), ('DocumentKit', 'VerificationIsIdentification'),
                           ('ContinuationRecord', 'Court'), ('RecordCourt', 'Court')]:
    broken = copy.deepcopy(targets)
    broken[target]['dependencies'].append({'byName': [dependency, None]})
    try:
        validate(broken, manifest['dependencies'])
    except AssertionError:
        pass
    else:
        raise AssertionError('admitted forbidden edge: ' + target)
try:
    validate(targets, manifest['dependencies'] + [{'sourceControl': [{'location': 'https://github.com/DanielSwift1992/verification-is-identification-showcase'}]}])
except AssertionError:
    pass
else:
    raise AssertionError('admitted reverse package dependency on showcase')
# The compiler reads the actual recursively nested SDK sources. No spelling guard judges imports.
subprocess.run(['swift','build','--target','DocumentKit','--explicit-target-dependency-import-check','error'],cwd=ROOT,check=True)
subprocess.run(['swift','build','--target','RecordCourt','--explicit-target-dependency-import-check','error'],cwd=ROOT,check=True)
with tempfile.TemporaryDirectory(prefix='dk-import-boundary-') as directory:
    temp=Path(directory);sources=temp/'Sources/DocumentKit';sources.mkdir(parents=True)
    for original in (ROOT/'Sources/DocumentKit').rglob('*.swift'):
        target=sources/original.relative_to(ROOT/'Sources/DocumentKit');target.parent.mkdir(parents=True,exist_ok=True);target.symlink_to(original)
    binary=Path(subprocess.check_output(['swift','build','--show-bin-path'],cwd=ROOT,text=True).strip())
    package='// swift-tools-version: 5.9\nimport PackageDescription\nlet package = Package(name:"ImportBoundary",platforms:[.macOS("13.0")],dependencies:[.package(name:"VI",path:'+json.dumps(str(ROOT))+')],targets:[.target(name:"BoundaryProbe",dependencies:[.product(name:"Notation",package:"VI"),.product(name:"Alphabet",package:"VI")],path:"Sources/DocumentKit",swiftSettings:[.unsafeFlags(["-I",'+json.dumps(str(binary/'Modules'))+'])])])\n'
    (temp/'Package.swift').write_text(package)
    command=['swift','build','--target','BoundaryProbe','--explicit-target-dependency-import-check','error']
    baseline=subprocess.run(command,cwd=temp,capture_output=True)
    assert baseline.returncode==0,baseline.stderr.decode()+baseline.stdout.decode()
    nested=sources/'Sub/Forbidden.swift';nested.parent.mkdir(exist_ok=True);nested.write_bytes((ROOT/'Contracts/Drawing/BindingControls/forbidden-import.swift').read_bytes())
    # The module exists and ordinary Swift permits it; the dependency policy must reject it.
    ordinary=subprocess.run(command[:-2],cwd=temp,capture_output=True)
    assert ordinary.returncode==0,ordinary.stderr.decode()+ordinary.stdout.decode()
    negative=subprocess.run(command,cwd=temp,capture_output=True)
    diagnostic=negative.stdout+negative.stderr
    assert negative.returncode,diagnostic.decode()
print('target graph: declared edges, reexport and strict plugins; compiler import boundary includes nested source')
