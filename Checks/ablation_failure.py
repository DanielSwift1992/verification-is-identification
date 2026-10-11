#!/usr/bin/env python3
"""Inject build failures into an isolated ablation package, never the workspace.

The stand-in build command exercises report publication and source restoration.
It does not claim to test Swift's type checker. Real compiler probes are separate.
"""
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def run_case(tool, mode):
    with tempfile.TemporaryDirectory(prefix='vi-ablation-fault-') as temp:
        root = Path(temp)
        (root / 'Package.swift').write_text('// Isolated fault fixture. No real build is run.\n')
        source = root / 'Sources' / 'VerificationIsIdentification' / 'Core.swift'
        source.parent.mkdir(parents=True)
        original = 'public protocol Pair {}\npublic protocol Probe: Pair {}\n'
        source.write_text(original)
        page = root / 'Research' / 'ablation' / 'current.md'
        page.parent.mkdir(parents=True)
        page.write_text('previous report\n')
        symbols = [dict(identifier=dict(precise=name), names=dict(title=name),
                        kind=dict(identifier='swift.protocol'),
                        location=dict(uri=source.as_uri(), position=dict(line=line)))
                   for line, name in enumerate(('Pair', 'Probe'))]
        graph = root / 'fixture.symbols.json'
        graph.write_text(json.dumps(dict(symbols=symbols, relationships=[
            dict(kind='conformsTo', source='Probe', target='Pair')])) )
        commands = root / 'bin'
        commands.mkdir()
        fake_swift = commands / 'swift'
        fake_swift.write_text('''#!/usr/bin/env python3
import os
from pathlib import Path
import sys
count_file = Path('.build-count')
count = int(count_file.read_text()) + 1 if count_file.exists() else 1
count_file.write_text(str(count))
mode = os.environ['VI_ABLATION_FAULT']
source = Path('Sources/VerificationIsIdentification/Core.swift')
if count == 1 and mode == 'concurrent':
    source.write_text(source.read_text() + '// external edit\\n')
if count == 2:
    assert source.read_text() == 'public protocol Pair {}\\npublic protocol Probe {}\\n'
    if mode == 'disk':
        print('error: no space left on device', file=sys.stderr)
        sys.exit(1)
    if mode == 'crash':
        print('error: emit-module command failed with exit code 139', file=sys.stderr)
        sys.exit(1)
    if mode == 'type':
        print('Core.swift:2:1: error: cannot find type \\'Pair\\' in scope', file=sys.stderr)
        sys.exit(1)
''')
        fake_swift.chmod(0o755)
        environment = dict(os.environ, PATH=str(commands) + os.pathsep + os.environ['PATH'],
                           VI_ABLATION_FAULT=mode)
        result = subprocess.run([str(tool), 'ablate', str(graph)], cwd=root, env=environment,
                                stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True,
                                timeout=30)
        if mode == 'type':
            require(result.returncode == 0, result.stdout)
            require('| fails |' in page.read_text(), 'type refusal not published')
            require(source.read_text() == original, 'type probe not restored')
            require(not list((root / '.build' / 'ablation-recovery').glob('*')),
                    'successful probe retained a recovery copy')
        else:
            require(result.returncode != 0, 'infrastructure or concurrent edit accepted')
            expected_diagnostic = dict(disk='no space left', crash='exit code 139',
                                       concurrent='source changed outside')[mode]
            require(expected_diagnostic in result.stdout, result.stdout)
            require(page.read_text() == 'previous report\n', 'failed run replaced the report')
            expected = original + '// external edit\n' if mode == 'concurrent' else original
            require(source.read_text() == expected, 'failed probe damaged source or external edit')
            backups = list((root / '.build' / 'ablation-recovery').glob('*/Core.swift'))
            require(len(backups) == 1 and backups[0].read_text() == original,
                    'failed run has no complete recovery copy')
        expected_count = '1' if mode == 'concurrent' else '3' if mode == 'type' else '2'
        require((root / '.build-count').read_text() == expected_count,
                'a failed run continued to another probe')
        print(f'ablation faults: {mode} handled, source and report verified')


if __name__ == '__main__':
    executable = Path(sys.argv[1]).resolve()
    for fault in ('disk', 'crash', 'concurrent', 'type'):
        run_case(executable, fault)
