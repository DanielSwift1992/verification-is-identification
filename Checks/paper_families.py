#!/usr/bin/env python3
"""Exercise the actual Swift family, quote, provenance and Topics readers."""
import argparse
import json
from pathlib import Path
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--tools', type=Path, default=ROOT / '.build/debug/Tools')
parser.add_argument('--papers', type=Path, default=ROOT / 'Sources/VerificationIsIdentification/VerificationIsIdentification.docc/Papers')
parser.add_argument('--graph', type=Path)
parser.add_argument('--report', type=Path)
args = parser.parse_args()
TOOLS = args.tools.resolve()
PAPERS = args.papers.resolve()
results = []

def run(name, command, expected=0, diagnostic=None):
    done = subprocess.run([str(TOOLS), *map(str, command)], cwd=ROOT, capture_output=True, text=True)
    output = done.stdout + done.stderr
    okay = done.returncode == expected and (diagnostic is None or diagnostic in output)
    results.append(dict(name=name, code=done.returncode, expected=expected, diagnostic=diagnostic, passed=okay, output=output))
    return done

with tempfile.TemporaryDirectory(prefix='vi-paper-families-') as scratch:
    docc = Path(scratch) / 'test.docc'
    shutil.copytree(PAPERS.parent, docc)
    papers = docc / 'Papers'
    run('complete corpus', ['papers', papers], diagnostic='35 papers, 75 pages, 346 labelled addresses')
    run('quotes in complete corpus', ['quotes', papers])
    run('provenance in complete corpus', ['lint', ROOT / 'Sources/VerificationIsIdentification', '--docc', docc, '--strict'])
    addresses = json.loads(run('actual declarations', ['papers', papers, '--addresses']).stdout)
    selected = {}
    for address in addresses:
        selected.setdefault(address['family'], address)
    def mutation(name, page, replacement, command=None, diagnostic=None):
        path = papers / page
        old = path.read_bytes() if path.exists() else None
        if replacement is None:
            path.unlink()
        else:
            path.write_text(replacement)
        try:
            run(name, command or ['papers', papers], 1, diagnostic)
        finally:
            if old is None:
                path.unlink(missing_ok=True)
            else:
                path.write_bytes(old)
    for family in sorted(selected):
        part = next(p.name for p in sorted(papers.glob(family + '__*.md')))
        mutation('missing part ' + family, part, None, diagnostic='missing member ' + part)
        original = (papers / part).read_text()
        mutation('foreign family ' + family, part, original.replace('<doc:' + family + '>.', '<doc:wrong_family>.', 1), diagnostic='wrong or missing family address')
        a = selected[family]
        content = (papers / a['page']).read_text()
        line = content.splitlines()[a['line'] - 1]
        mutation('duplicate label ' + family, a['page'], content + '\n' + line + '\n', diagnostic='duplicate label')
        mutation('lost declaration ' + family, a['page'], content.replace(line + '\n', '', 1), diagnostic='orphan label heading')
        wrong = next(p.name for p in papers.glob(family + '*.md') if p.name != a['page'])
        mutation('wrong owner ' + family, 'family_probe.md', '# Probe\n\n<doc:' + wrong[:-3] + '#' + a['label'] + '>.\n', diagnostic='wrong owner')
    mutation('unregistered part', 'permanence_is_resistance__unexpected.md', '# Unregistered\n', diagnostic='unregistered part')
    mutation('unregistered link', 'family_probe.md', '# Probe\n\n<doc:learning_is_liquid__missing>.\n', diagnostic='unregistered link')
    example = papers / 'permanence_is_resistance__support_renewal.md'
    original = example.read_bytes()
    example.write_text(example.read_text() + '\n```markdown\n### M99999\n\n**M99999 (example only).**\n```\n')
    run('fenced label is not a declaration', ['papers', papers], diagnostic='346 labelled addresses')
    example.write_bytes(original)
    fake = '\n### M99999\n\n**M99999 (example only).**\n'
    fence_cases = [
        ('long backticks contain short backticks', '````markdown\n```\n' + fake + '````\n', 346),
        ('long tildes contain short tildes', '~~~~markdown\n~~~\n' + fake + '~~~~\n', 346),
        ('wrong fence mark cannot close', '````\n~~~~\n' + fake + '````\n', 346),
        ('closing fence cannot carry info', '```\n```markdown\n' + fake + '```\n', 346),
        ('three spaces admit a fence', '   ```\n' + fake + '   ```\n', 346),
        ('four spaces do not open a fence', '    ```\n' + fake, 347),
        ('backtick info cannot contain backticks', '```bad`info\n' + fake, 347),
        ('longer fence closes', '````\nexample\n`````\n' + fake, 347),
        ('fenced doc links do not resolve', '```\n<doc:learning_is_liquid__missing>\n```\n', 346),
        ('fenced own heading is not a duplicate', '```\n### M64o\n```\n', 346),
    ]
    for name, appendix, count in fence_cases:
        example.write_text(original.decode() + '\n' + appendix)
        run(name, ['papers', papers], diagnostic=str(count) + ' labelled addresses')
    example.write_bytes(original)
    for page in sorted(papers.glob('*__*.md')):
        content = page.read_text()
        setting = next((line for line in content.splitlines() if line.startswith('Required setting: ')), None)
        if setting:
            mutation('missing setting ' + page.name, page.name, content.replace(setting + '\n', '', 1), diagnostic='missing reviewed')
    # A real quote appears in a part, not the original entry. It must pass through
    # that paper's attribution. A scrambled word, wrong family and a cross-block
    # splice must each fail with a quote diagnostic, rather than an I/O refusal.
    quote = 'Keep M64n\'s four source positions and W,Z'
    probe = papers / 'family_probe.md'
    def quote_case(name, text, expected):
        probe.write_text('# Probe\n\n' + text + '\n')
        run(name, ['quotes', papers], expected, 'THE QUOTES hold' if expected == 0 else 'THE QUOTES drift')
        probe.unlink()
    quote_case('quote moved to a part', 'Permanence Is Resistance says: "' + quote + '".', 0)
    quote_case('changed quote', 'Permanence Is Resistance says: "Keep M64n\'s five source positions and W,Z".', 1)
    quote_case('wrong quote family', 'Learning Is Liquid says: "' + quote + '".', 1)
    # Plant separate real source blocks to prove boundaries cannot manufacture a span.
    entry = papers / 'basis_is_residue.md'
    original = entry.read_bytes()
    entry.write_text(entry.read_text() + '\nalpha bravo charlie\n\ndelta echo foxtrot\n')
    quote_case('cross-block splice', 'Basis Is Residue says: "alpha bravo charlie delta echo foxtrot".', 1)
    entry.write_text(original.decode() + '\n```\nalpha bravo charlie\n\ndelta echo foxtrot\n```\n')
    quote_case('a fenced block includes its blank lines', 'Basis Is Residue says: "alpha bravo charlie delta echo foxtrot".', 0)
    entry.write_text(original.decode() + '\n````\nalpha bravo charlie\n```\n\ndelta echo foxtrot\n````\n')
    quote_case('short inner fence remains in the same quote block', 'Basis Is Residue says: "alpha bravo charlie delta echo foxtrot".', 0)
    entry.write_bytes(original)
    part = papers / 'permanence_is_resistance__support_renewal.md'
    original = part.read_bytes()
    part.write_text(part.read_text() + '\nPermanence Is Resistance says: "own words whose content no sibling judges".\n')
    run('same-family attribution excluded', ['quotes', papers])
    part.write_bytes(original)
    for title, family in [('Verdict Is Invariant', 'verdict_is_invariant'), ('Interference Is Substitution', 'interference_is_substitution')]:
        quote_case('added alias refuses ' + family, title + ' says: "invented words whose content the sibling never states".', 1)
    quote_case('Verdict alias finds a moved quote', 'Verdict Is Invariant says: "Keep VC100m\'s carrier and fixed program M".', 0)
    quote_case('Interference alias finds a moved quote', 'Interference Is Substitution says: "The preceding counterexample instantiates Verdict Is Invariant VC15 and VC45".', 0)
    source = Path(scratch) / 'Probe.swift'
    source.write_text('/// Missing result. [Matter M99999]\npublic protocol Probe {}\n')
    run('missing source label', ['lint', source, '--docc', docc, '--strict'], 1, 'PROVENANCE — missing label')
    source.write_text('/// Retained result. [Matter M64o]\npublic protocol Probe {}\n')
    # Cite the real source tree too: the isolated probe cannot supply all legend routes.
    run('source label in a part', ['lint', ROOT / 'Sources/VerificationIsIdentification', source, '--docc', docc, '--strict'])
    if args.graph:
        if str(args.graph) == 'auto':
            graphs = list((ROOT / '.build').glob('*/extracted-symbols/**/VerificationIsIdentification.symbols.json'))
            if not graphs:
                raise SystemExit('No plugin graph: run swift package tree-sort check first')
            graph = max(graphs, key=lambda path: path.stat().st_mtime)
        else:
            graph = args.graph.resolve()
        run('Topics complete', ['tree-sort', graph, docc, 'check'])
        entry = papers / 'learning_is_liquid.md'
        content = entry.read_text()
        mutation('lost Parts curation', entry.name, content.replace('- <doc:learning_is_liquid__medium_contacts>\n', '', 1), ['tree-sort', graph, docc, 'check'], 'Topics DRIFT')
        atlas = docc / 'AtlasArgued.md'
        original = atlas.read_bytes()
        before = {str(p.relative_to(docc)): p.read_bytes() for p in docc.rglob('*.md')}
        run('regeneration once', ['tree-sort', graph, docc, 'write'])
        first = {str(p.relative_to(docc)): p.read_bytes() for p in docc.rglob('*.md')}
        run('regeneration twice', ['tree-sort', graph, docc, 'write'])
        second = {str(p.relative_to(docc)): p.read_bytes() for p in docc.rglob('*.md')}
        results.append(dict(name='regeneration preserves input corpus', passed=before == first))
        results.append(dict(name='regeneration idempotent', passed=first == second and original == atlas.read_bytes()))
        # A lost real record is refused by the regenerated AtlasArgued comparison.
        part = papers / 'verdict_is_invariant__finite_records.md'
        text = part.read_text()
        record = next(line for line in text.splitlines() if line.startswith('> Argues: '))
        mutation('lost Argues occurrence', part.name, text.replace(record + '\n', '', 1), ['tree-sort', graph, docc, 'check'], 'Topics DRIFT')
report = dict(passed=all(r['passed'] for r in results), controls=len(results), results=results)
if args.report:
    args.report.write_text(json.dumps(report, indent=2) + '\n')
for result in results:
    if not result['passed']:
        print('FAIL:', result)
print(('PASS' if report['passed'] else 'FAIL') + ': ' + str(len(results)) + ' actual Swift reader controls')
raise SystemExit(0 if report['passed'] else 1)
