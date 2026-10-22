#!/usr/bin/env python3
"""Exercise archive boundaries in a disposable tree, never the real archive."""
import importlib.util
import json
from pathlib import Path
import shutil
import tempfile

spec = importlib.util.spec_from_file_location('archive_law', Path(__file__).with_name('archived-where.py'))
law = importlib.util.module_from_spec(spec)
spec.loader.exec_module(law)
with tempfile.TemporaryDirectory(prefix='vi-archive-controls-') as tmp:
    root = Path(tmp)
    manifest = json.loads((law.ROOT / law.ARCHIVE / 'manifest.json').read_text())
    manifest_path = law.ARCHIVE / 'manifest.json'
    reader_path = law.ARCHIVE / 'judge-where.js'
    names = (list(manifest['consumers']) + list(manifest['related_native_consumers'])
             + list(manifest['documentation_provenance']) + list(law.ARCHIVE_IMPLEMENTATION)
             + [str(manifest_path), str(reader_path)])
    for name in set(names):
        target = root / name
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(law.ROOT / name, target)
    assert not law.check(root), law.check(root)
    count = 0

    def refused(label, needle):
        global count
        errors = law.check(root)
        assert any(needle in error for error in errors), errors
        print(f'NEG {label} -> REFUSED: ' + next(error for error in errors if needle in error))
        count += 1

    # Concatenation keeps the control definitions from being live path literals.
    probes = [
        ('Checks/FiniteContinuation/new-live.js', 'require("../' + 'gate/bin/tool");\n', 'nested JS sibling'),
        ('Checks/IBMBridge/new_probe.py', "JUDGE = ROOT." + "parent / 'gate/bin/gate-judge'\n", 'nested Python ROOT.parent'),
        ('Checks/new_probe.py', "JUDGE = '../" + "gate/bin/tool'\n", 'top-level Python sibling'),
        ('Checks/Other/new_probe.js', "const judge = path.join(root, '..', " + "'gate', 'bin', 'gate-judge');\n", 'Node path.join sibling'),
        ('Checks/Other/new_probe.sh', '#!/bin/sh\nexec ../' + 'gate/bin/gate-judge\n', 'nested shell sibling'),
        ('Checks/Other/cd_probe.sh', 'cd ../' + 'gate && pwd\n', 'shell cd without trailing slash'),
        ('Checks/Other/env_probe.sh', 'GATE=../' + 'gate\n', 'shell assignment at end of line'),
        ('Checks/Other/multi_probe.js', "path.join(__dirname, '..', '..', " + "'gate');\n", 'Node multiple parent arguments'),
        ('Checks/Other/resolve_probe.js', "path.resolve(d, '../..', " + "'gate');\n", 'Node combined parent argument'),
        ('Checks/Other/template_probe.js', 'const p = `${root}/../' + 'gate`;\n', 'Node template string'),
        ('Checks/Other/parents_probe.py', "ROOT.parents[2] / " + "'gate'\n", 'Python indexed parent'),
        ('Checks/Other/joinpath_probe.py', "ROOT.parent.joinpath(" + "'gate')\n", 'Python parent joinpath'),
    ]
    for name, content, label in probes:
        probe = root / name
        probe.parent.mkdir(parents=True, exist_ok=True)
        probe.write_text(content)
        refused(label, f'{name}:')
        probe.unlink()
    gateway = root / 'Checks/Other/gateway-control.js'
    gateway.write_text("require('../gateway.js');\nrequire('../gate.js');\nrequire('../gate-tools');\n"
                       "path.join(root, '..', 'gateway');\npath.resolve(root, '..', 'gate-tools');\n")
    assert not law.check(root), law.check(root)
    print('POS neighboring module names -> ACCEPTED: gateway, gate.js and gate-tools are not a gate component')
    gateway.unlink()

    file = root / 'Checks/FiniteContinuation/court_bridge.js'
    before = file.read_bytes()
    file.write_bytes(before + b'\n// VI_WHERE_' + b'JUDGE\n')
    refused('environment override', 'reader override')
    file.write_bytes(before)

    reader = root / reader_path
    before = reader.read_bytes()
    reader.write_bytes(before + b'\n')
    refused('reader mutation', 'frozen reader bytes changed')
    reader.write_bytes(before)

    file = root / 'Checks/four-contact-court.js'
    before = file.read_bytes()
    file.write_bytes(before + b'\n')
    refused('consumer mutation', 'frozen consumer bytes changed')
    file.write_bytes(before)

    undeclared = root / 'Checks/Other/new-archive-consumer.js'
    undeclared.write_text('require("../Archive/WhereV2/judge-' + 'where.js");\n')
    refused('undeclared archive consumer', 'undeclared archived-reader consumer')
    undeclared.unlink()

    declaration = root / manifest_path
    before = declaration.read_bytes()
    manifest['recorded_reader_sha256'] = law.READER_SHA256
    declaration.write_text(json.dumps(manifest))
    refused('receipt-reader identity substitution', 'recorded receipt-reader identity changed')
    declaration.write_bytes(before)
    manifest = json.loads(before)
    manifest['recorded_reader_receipts'].pop()
    declaration.write_text(json.dumps(manifest))
    refused('missing receipt address', 'expected 207 distinct receipt addresses')
    declaration.write_bytes(before)

    for label, changes in [
        ('legacy machine-specific pointer', {'json_pointer': '/source/~1' + 'Users~1example~1reader'}),
        ('machine-specific parent key', {'json_pointer_parent': '/source/~1' + 'Users~1example~1reader'}),
        ('home-relative encoded parent', {'json_pointer_parent': '/source/~0~1Projects~1gate'}),
        ('encoded user parent without leading separator', {'json_pointer_parent': '/source/Users~1example~1Projects'}),
        ('extra receipt field', {'source_key': '/' + 'Users/example/reader'}),
        ('absolute suffix', {'key_suffix': '/' + 'example/reader'}),
        ('invalid pointer escape', {'json_pointer_parent': '/source/~2invalid'}),
    ]:
        changed = json.loads(before)
        changed['recorded_reader_receipts'][0].update(changes)
        declaration.write_text(json.dumps(changed))
        refused(label, 'invalid recorded receipt address')
        declaration.write_bytes(before)

    changed = json.loads(before)
    changed['source_key'] = '/' + 'Users/example/reader'
    declaration.write_text(json.dumps(changed))
    refused('extra top-level field', 'invalid manifest fields')
    declaration.write_bytes(before)

    readme = root / 'Checks/README.md'
    readme.write_text(readme.read_text() + '\nDocumentation may be corrected without changing the frozen executables.\n')
    assert not law.check(root), law.check(root)
    print('POS Checks/README.md correction -> ACCEPTED: original hash is provenance, not a frozen executable')
    assert not law.check(root), law.check(root)
print(f'archive-where controls: {count}/{count} refused; gateway and documentation accepted; restored executable baseline holds')
