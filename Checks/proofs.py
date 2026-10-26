#!/usr/bin/env python3
"""Build the pinned Lean project and audit Lean's output for its declared claims.

Axioms.lean is the single roster, not an axiom detector: the dependencies come
from Lean's #print axioms, including transitive dependencies through imports.
The driver/Lean kernel/toolchain are named premises, not proved by these tests.
"""
from pathlib import Path
import os
import re
import shutil
import subprocess
import sys
import time

PROJECT = Path(__file__).resolve().parents[1] / 'Proofs/U5'
ALLOWED = frozenset({'propext', 'Classical.choice', 'Quot.sound'})
NAME = r'[A-Za-z_][A-Za-z_0-9]*(?:\.[A-Za-z_][A-Za-z_0-9]*)*'
REPORT = re.compile(
    r"'([^'\n]+)' (?:depends on axioms:\s*\[([^\]]*)\]|does not depend on any axioms)")


class Refusal(ValueError):
    pass


def roster(path):
    """Read the finite command carrier; executable Lean declarations stay out."""
    claims = {}
    for line, raw in enumerate(path.read_text(encoding='utf-8').splitlines(), 1):
        text = raw.strip()
        address = f'{path}:{line}'
        if not text or text.startswith('--'):
            continue
        if re.fullmatch(r'import ' + NAME, text):
            continue
        claim = re.fullmatch(r'#print axioms (' + NAME + ')', text)
        if claim is None:
            raise Refusal(f'{address}: unsupported claim-roster command: {text!r}')
        name = claim.group(1)
        if name in claims:
            raise Refusal(f'{address}: duplicate claim {name}; first at {claims[name]}')
        claims[name] = address
    if not claims:
        raise Refusal(f'{path}:1: no declared claims')
    return claims


def audit(claims, text, address):
    """Accept only one complete Lean report for every declaration, no extras."""
    seen = set()
    failures = []
    end = 0
    for report in REPORT.finditer(text):
        if text[end:report.start()].strip():
            failures.append(f'{address}: unrecognized Lean output: '
                            f'{text[end:report.start()].strip()!r}')
        end = report.end()
        name, axioms = report.groups()
        at = claims.get(name, address)
        if name not in claims:
            failures.append(f'{at}: undeclared claim in Lean output: {name}')
        if name in seen:
            failures.append(f'{at}: repeated Lean output for claim {name}')
        seen.add(name)
        dependencies = [] if axioms is None or not axioms.strip() else [
            value.strip() for value in axioms.split(',')]
        forbidden = sorted(set(dependencies) - ALLOWED)
        if forbidden:
            failures.append(f'{at}: claim {name}: forbidden axioms: {", ".join(forbidden)}')
    if text[end:].strip():
        failures.append(f'{address}: unrecognized Lean output: {text[end:].strip()!r}')
    for name, at in claims.items():
        if name not in seen:
            failures.append(f'{at}: claim {name}: missing from #print axioms output')
    if failures:
        raise Refusal('\n'.join(failures))
    return len(seen)


def installation(project):
    return ('Install elan: curl -sSfL https://elan.lean-lang.org/elan-init.sh | '
            'sh -s -- -y --default-toolchain none; export PATH="$HOME/.elan/bin:$PATH"; '
            f'elan toolchain install "$(cat {project / "lean-toolchain"})"')


def run(project=PROJECT, *, output=None, environment=None):
    output = sys.stdout if output is None else output
    environment = dict(os.environ if environment is None else environment)
    started = time.monotonic()
    try:
        toolchain_file = project / 'lean-toolchain'
        toolchain = toolchain_file.read_text(encoding='utf-8').strip()
        version = re.fullmatch(r'leanprover/lean4:v(\d+\.\d+\.\d+(?:-[A-Za-z0-9.]+)?)', toolchain)
        if version is None:
            raise Refusal(f'{toolchain_file}:1: expected a pinned Lean release, got {toolchain!r}')
        # Ignore an inherited elan override; the repository declares its reader.
        environment['ELAN_TOOLCHAIN'] = toolchain
        lake = shutil.which('lake', path=environment.get('PATH', ''))
        if lake is None:
            raise Refusal(f'{toolchain_file}:1: lake is missing. {installation(project)}')
        claims = roster(project / 'Axioms.lean')

        def invoke(arguments):
            print('+ lake ' + ' '.join(arguments), file=output, flush=True)
            result = subprocess.run([lake, *arguments], cwd=project, env=environment,
                                    stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                                    encoding='utf-8', errors='strict')
            print(result.stdout, end='' if result.stdout.endswith('\n') else '\n',
                  file=output, flush=True)
            if result.returncode:
                raise Refusal(f'{project}:1: lake {" ".join(arguments)} exited {result.returncode}')
            return result.stdout

        actual = invoke(['env', 'lean', '--version'])
        if not re.search(r'\bLean \(version ' + re.escape(version.group(1)) + r'(?:,|\))', actual):
            raise Refusal(f'{toolchain_file}:1: reader does not report declared {toolchain}')
        invoke(['build'])
        # Execute the command carrier again: do not mistake a cached build log
        # (or an absent/replayed diagnostic) for the complete audit response.
        response = invoke(['env', 'lean', 'Axioms.lean'])
        count = audit(claims, response, f'{project / "Axioms.lean"}:1')
        print(f'proofs: {count}/{len(claims)} declared claims; '
              'only propext, Classical.choice, Quot.sound; '
              f'elapsed {time.monotonic() - started:.3f}s', file=output, flush=True)
        return 0
    except (Refusal, OSError, UnicodeError) as exc:
        print(f'proofs: REFUSED: {exc}', file=output, flush=True)
        return 1


if __name__ == '__main__':
    sys.exit(run())
