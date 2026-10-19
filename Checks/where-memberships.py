#!/usr/bin/env python3
"""Independent Swift controls for the membership reader's declared boundary."""
import argparse
import re
from pathlib import Path
import subprocess
import tempfile

parser = argparse.ArgumentParser()
parser.add_argument('--tools', required=True)
args = parser.parse_args()
tools = str(Path(args.tools).resolve())

# Match the compiler-failure boundary used by Checks/verdict.sh.
INCOMPLETE = re.compile(
    r'Stack dump:|please submit a bug report|Assertion failed|cannot build rewrite system|'
    r'rule (length|count) limit exceeded|reasonable time', re.IGNORECASE)

COMMON = '''public protocol Setting {{}}
public protocol Required: Setting {{}}
public enum Atom: Setting {{}}
public enum Marked: Required {{}}
{declarations}
public protocol Admitted {{}}
public enum Use<T> {{}}
extension Use: Admitted where T: Required {{}}
{aliases}
func need<T: Admitted>(_: T.Type) {{}}
func demand() {{ need(Use<{member}>.self) }}
'''

# The compiler validates each positive independently and must reject each
# negative for the stated requirement, not for an unrelated syntax failure.
CASES = [
    ('plain-good', 'public enum Box: Required {}', '', 'Box', True, 0, ''),
    ('plain-bad', 'public enum Box: Setting {}', '', 'Box', False, 1, 'Required'),
    ('generic-good', 'public enum Box<T>: Required {}', '', 'Box<Atom>', True, 2, ''),
    ('generic-bad', 'public enum Box<T>: Setting {}', '', 'Box<Atom>', False, 2, 'Required'),
    ('refinement-good', 'public protocol Child: Required {}\npublic enum Box<T>: Child {}', '', 'Box<Atom>', True, 2, ''),
    ('extension-good', 'public enum Box<T>: Setting {}\nextension Box: Required {}', '', 'Box<Atom>', True, 2, ''),
    ('bounded-good', 'public enum Box<T: Required>: Required {}', '', 'Box<Marked>', True, 2, ''),
    ('bounded-bad', 'public enum Box<T: Required>: Required {}', '', 'Box<Atom>', False, 2, 'Required'),
    ('alias-good', 'public enum Box<T>: Required {}', 'public typealias Pick = Box<Atom>', 'Pick', True, 2, ''),
    ('alias-bad', 'public enum Box<T>: Setting {}', 'public typealias Pick = Box<Atom>', 'Pick', False, 2, 'Required'),
    ('field-good', 'public enum Box<T>: Required {}\npublic enum Holder: Setting { public typealias Pick = Box<Atom> }', '', 'Holder.Pick', True, 2, ''),
    ('field-bad', 'public enum Box<T>: Setting {}\npublic enum Holder: Setting { public typealias Pick = Box<Atom> }', '', 'Holder.Pick', False, 2, 'Required'),
]

with tempfile.TemporaryDirectory(prefix='vi-memberships-') as temporary:
    root = Path(temporary)
    for name, declarations, aliases, member, compiler_ok, court_exit, requirement in CASES:
        path = root / (name + '.swift')
        path.write_text(COMMON.format(declarations=declarations, aliases=aliases, member=member))
        compiled = subprocess.run(['swiftc', '-typecheck', '-module-cache-path', str(root / 'cache'), str(path)], text=True, capture_output=True)
        assert not INCOMPLETE.search(compiled.stdout + compiled.stderr), (name, 'compiler did not complete', compiled.stdout, compiled.stderr)
        if compiler_ok:
            assert compiled.returncode == 0 and not compiled.stderr, (name, compiled.stderr)
        else:
            assert compiled.returncode == 1 and 'error:' in compiled.stderr and requirement in compiled.stderr, (name, compiled.stderr)
            errors = [line for line in compiled.stderr.splitlines() if ': error:' in line]
            # The invalid constrained argument also leaves need<T> uninferred.
            # Keep that known consequence separate from the required error.
            assert errors and any(requirement in line for line in errors), (name, errors)
            assert all(requirement in line or (name == 'bounded-bad' and
                       "error: generic parameter 'T' could not be inferred" in line)
                       for line in errors), (name, errors)
        judged = subprocess.run([tools, 'judge', 'where', str(path)], text=True, capture_output=True)
        assert judged.returncode == court_exit, (name, judged.returncode, judged.stdout, judged.stderr)
        if court_exit == 2:
            resolved = 'Box<Marked>' if name == 'bounded-good' else 'Box<Atom>'
            expected = (f"✗ THE WHERE: cannot judge membership of '{resolved}' in 'Required' "
                        f"required by 'Use<{member}>': generic applicability is not established by this membership reader\n")
            assert judged.stdout == '' and judged.stderr == expected, (name, judged.stdout, judged.stderr, expected)
        elif court_exit == 1:
            assert judged.stderr == '' and "'Box: Setting' does not carry it [Admitted]" in judged.stdout, (name, judged.stdout, judged.stderr)
        else:
            assert judged.stderr == '' and '1 memberships judged' in judged.stdout, (name, judged.stdout, judged.stderr)
    # A conditional conformance is already a gated nested application; the
    # new boundary must not promote either branch into a membership verdict.
    for name, member, compiler_ok in [('conditional-good', 'Box<Marked>', True), ('conditional-bad', 'Box<Atom>', False)]:
        path = root / (name + '.swift')
        path.write_text(COMMON.format(declarations='public enum Box<T>: Setting {}\nextension Box: Required where T: Required {}', aliases='', member=member))
        compiled = subprocess.run(['swiftc', '-typecheck', '-module-cache-path', str(root / 'cache'), str(path)], text=True, capture_output=True)
        assert not INCOMPLETE.search(compiled.stdout + compiled.stderr), (name, 'compiler did not complete', compiled.stdout, compiled.stderr)
        assert compiled.returncode == (0 if compiler_ok else 1), (name, compiled.stderr)
        if compiler_ok:
            assert not compiled.stderr, (name, compiled.stderr)
        else:
            errors = [line for line in compiled.stderr.splitlines() if ': error:' in line]
            assert errors and all('Required' in line for line in errors), (name, compiled.stderr)
        judged = subprocess.run([tools, 'judge', 'where', str(path)], text=True, capture_output=True)
        assert judged.returncode == 2 and not judged.stdout, (name, judged.stdout, judged.stderr)
        assert judged.stderr.startswith('✗ THE WHERE: cannot read line ') and str(path) in judged.stderr, (name, judged.stderr)
        assert judged.stderr.endswith(f"'Use<{member}>' contains a gated application outside the root this court judges\n"), (name, judged.stderr)
print('✓ where-memberships: 14 compiler controls; plain membership judged, generic and conditional membership explicitly unread')
