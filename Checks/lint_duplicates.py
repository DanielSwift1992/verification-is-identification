#!/usr/bin/env python3
"""Exercise the real Swift LawLint CLI; no model of its algorithm is used here.

By default compile just LawLint and its dispatch into a disposable executable.
--tools PATH uses an already built Tools executable instead.
"""
import argparse
import json
import subprocess
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
RULE = 'DUPLICATE INTERSECTION'


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--tools', type=Path)
    parser.add_argument('--report', type=Path)
    args = parser.parse_args()
    records = []
    with tempfile.TemporaryDirectory(prefix='vi-lint-duplicates-') as scratch:
        scratch = Path(scratch)
        if args.tools:
            tools = args.tools.resolve()
        else:
            entry = scratch / 'main.swift'
            entry.write_text('import Foundation\nLint.run(Array(CommandLine.arguments.dropFirst(2)))\n')
            tools = scratch / 'Tools'
            subprocess.run(['swiftc', '-module-cache-path', str(scratch / 'module-cache'),
                            str(ROOT / 'Sources/Tools/Lint.swift'),
                            str(ROOT / 'Sources/Tools/LintDuplicates.swift'), str(entry),
                            '-o', str(tools)], check=True)

        def check(name, sources, *, pairs=(), strict=True, repeat=False):
            directory = scratch / name
            directory.mkdir()
            paths = []
            for filename, contents in sources.items():
                path = directory / filename
                path.write_text(contents)
                paths.append(str(path))
            command = [str(tools), 'lint', *paths]
            if repeat:
                command.extend(paths)
            if strict:
                command.append('--strict')
            result = subprocess.run(command, text=True, capture_output=True)
            output = result.stdout + result.stderr
            found = [line for line in output.splitlines() if RULE in line]
            expected_exit = 1 if pairs and strict else 0
            assert result.returncode == expected_exit, (name, result.returncode, output)
            assert len(found) == len(pairs), (name, found, output)
            for a, b in pairs:
                assert any(a in line and b in line for line in found), (name, a, b, output)
            records.append(dict(name=name, exit=result.returncode, duplicates=len(found), output=output))

        check('literal-order-comments', {
            'First.swift': 'public protocol First: A, B {}\n',
            'Second.swift': 'public protocol Second:\n B, /* outer /* nested */ comment */ A\n{\n// no requirements\n}\n',
        }, pairs=[('First', 'Second')], repeat=True)
        check('ancestor-closure', {
            'Parents.swift': 'public protocol Cache: Finite, Closed { associatedtype Memory: Permanent }\n',
            'First.swift': 'public protocol First: Cache, Result {}\n',
            'Second.swift': 'public protocol Second: Finite, Cache, Closed, Result {}\n',
        }, pairs=[('First', 'Second')])
        check('extra-named-marker', {
            'Markers.swift': 'public protocol Marker {}\n',
            'Children.swift': 'public protocol First: A, B {}\npublic protocol Second: A, B, Marker {}\n',
        })
        check('own-requirements', {'Children.swift': '''
public protocol First: A, B {}
public protocol WithWhere: A, B where Self: C {}
public protocol WithRole: A, B { associatedtype Role: C }
public protocol WithAlias: A, B { typealias Role = C }
'''})
        check('where-inherited', {'Parents.swift': '''
public protocol Constrained: A, B where Self: C {}
public protocol First: A, B {}
public protocol Second: Constrained, A, B {}
'''})
        check('nominal-category-gates', {'Gates.swift': '''
public protocol First: Close {}
public protocol Second: Close {}
public protocol Uses { associatedtype X: First; associatedtype Y: Second }
'''})
        check('allow-only-on-own-head', {'Children.swift': '''
public protocol First: A, B {}
public protocol Allowed: A, B {} // law:allow: reviewed nominal duty
// law:allow: this unrelated comment cannot exempt Second
public protocol Second: A, B {}
'''}, pairs=[('First', 'Second')])
        check('three-members', {'Children.swift': '''
public protocol First: A, B {}
public protocol Second: B, A {}
public protocol Third: A, B {}
'''}, pairs=[('First', 'Second'), ('First', 'Third')])
        check('opaque-imports', {'Children.swift': '''
public protocol First: ImportedA, ImportedB {}
public protocol Second: ImportedC, ImportedB {}
'''})
        check('scopes-and-literals', {'Primitive.swift': '''
/* protocol Fake: A, B {} */
let text = "protocol Fake: A, B {}"
let escaped = "\\\" protocol Fake: A, B {}"
let raw = #"protocol Fake: A, B {}"#
let multiline = """
protocol Fake: A, B {}
"""
let rawMultiline = ##"""
protocol Fake: A, B {}
"""##
public enum Outer { public protocol Nested: A, B {} }
public protocol First: A, B {}
'''})
        check('literal-is-not-empty', {'Primitive.swift': '''
public protocol First: A, B {}
public protocol Second: A, B { "not a requirement, but not empty" }
'''})
        check('conditional-file-opaque', {'Children.swift': '''
#if FIRST
public protocol First: A, B {}
#else
public protocol Second: A, B {}
#endif
'''})
        check('ambiguous-ancestor', {
            'Parents.swift': 'public protocol Parent: A, B {}\n',
            'Other.swift': 'public protocol Parent: C, D {}\n',
            'Children.swift': 'public protocol First: Parent, X {}\npublic protocol Second: Parent, X {}\n',
        })
        check('cyclic-ancestor', {'Children.swift': '''
public protocol A: B { associatedtype Role: C }
public protocol B: A { associatedtype Role: C }
public protocol First: A, C {}
public protocol Second: A, C {}
'''})
        check('report-mode', {'Children.swift': 'public protocol First: A, B {}\npublic protocol Second: A, B {}\n'},
              pairs=[('First', 'Second')], strict=False)
        check('existing-rename-rule', {'Children.swift': 'public protocol Renamed: Parent {}\n'}, strict=False)
        assert 'RENAME' in records[-1]['output'], records[-1]
    if args.report:
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(json.dumps(dict(status='PASS', controls=records), indent=2) + '\n')
    print(f'LawLint duplicate controls PASS: {len(records)} cases')


if __name__ == '__main__':
    main()
