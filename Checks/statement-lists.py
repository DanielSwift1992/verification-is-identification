#!/usr/bin/env python3
"""Checks the hand-kept lists and counts of statements against the statements themselves.

A statement is a line outside a fenced block that begins with a bold label and a title in parentheses,
'**VC15 (The coarsest compatible object relation).**', optionally after Claim, Corollary, Lemma, Theorem
or Proposition. One paper writes '**C4 — Title.**' and that form is read too. A statement written in any
other form is not seen here, so this check compares the lists with the statements of these two forms only.

  the list on a page     a page with statements carries 'Statements on this page:' followed by one line per
                         statement, in the order of the page, each a link to that statement on this page
  the heading            every statement has a heading '### LABEL' on its page, so the link has an anchor
  the parts of a family  a main page whose paper has part pages carries 'Parts in reading order:' followed
                         by one line per part, '- <doc:PART>: FIRST–LAST, N statements.' (or 'ONLY, 1 statement.'),
                         naming the first and the last statement of that part and their number
  the papers by theme    EntryThemes.md names every paper once, '- <doc:PAPER>: N statements.' or
                         '... N statements on P pages.', with the number of statements of the paper and of its
                         pages; a paper without statements of these forms is named without a number

  python3 Checks/statement-lists.py             read the catalogue of this repository, exit 1 on any difference
  python3 Checks/statement-lists.py --selftest  made-up catalogues with planted differences that must be seen
"""
import pathlib
import re
import sys
import tempfile

ROOT = pathlib.Path(__file__).resolve().parents[1]
CATALOGUE = ROOT / 'Sources/VerificationIsIdentification/VerificationIsIdentification.docc'
LABEL = r'[A-Za-z]{1,5}\d+[a-z]*'
STATEMENT = re.compile(r'^\*\*(?:Claim |Corollary |Lemma |Theorem |Proposition )?(' + LABEL + r')\s*\(')
STATEMENT_WITH_DASH = re.compile(r'^\*\*(' + LABEL + r') — ')
HEADING = re.compile(r'^#{2,4}\s+(' + LABEL + r')\s*$')
FENCE = re.compile(r'^ {0,3}(`{3,}|~{3,})')
LIST_START = 'Statements on this page:'
LIST_LINE = re.compile(r'^- <doc:([A-Za-z0-9_]+)#(' + LABEL + r')>: .+$')
PARTS_START = 'Parts in reading order:'
PART_LINE = re.compile(r'^- <doc:([A-Za-z0-9_]+)>: (' + LABEL + r')(?:–(' + LABEL + r'))?, (\d+) statements?\.$')
THEME_NAME = re.compile(r'^- <doc:([A-Za-z0-9_]+)>: ')
THEME_LINE = re.compile(r'^- <doc:([A-Za-z0-9_]+)>: (\d+) statements?(?: on (\d+) pages)?\. ')


def block_after(lines, start):
    """The lines '- ...' that follow each line equal to start, one list per occurrence."""
    blocks = []
    for index, line in enumerate(lines):
        if line.strip() != start:
            continue
        index += 1
        while index < len(lines) and not lines[index].strip():
            index += 1
        block = []
        while index < len(lines) and lines[index].startswith('- '):
            block.append(lines[index].rstrip())
            index += 1
        blocks.append(block)
    return blocks


def lines_outside_fences(text):
    """The lines of a page that are not inside a fenced block, fence lines excluded."""
    kept = []
    open_fence = None
    for line in text.split('\n'):
        mark = FENCE.match(line)
        if open_fence is None and mark:
            open_fence = mark.group(1)
        elif open_fence is not None and mark and mark.group(1)[0] == open_fence[0] and len(mark.group(1)) >= len(open_fence) and line.strip() == mark.group(1):
            open_fence = None
        elif open_fence is None:
            kept.append(line)
    return kept


def read_page(text):
    """The statements, the headings and the list of one page."""
    lines = lines_outside_fences(text)
    statements = []
    headings = set()
    for line in lines:
        found = STATEMENT.match(line) or STATEMENT_WITH_DASH.match(line)
        if found:
            statements.append(found.group(1))
        heading = HEADING.match(line)
        if heading:
            headings.add(heading.group(1))
    listed = None
    blocks = block_after(lines, LIST_START)
    problems = []
    if len(blocks) > 1:
        problems.append('the list of statements is written %d times' % len(blocks))
    if blocks:
        listed = []
        for line in blocks[0]:
            entry = LIST_LINE.match(line)
            if entry is None:
                problems.append('a line of the list is not a link to a statement: ' + line[:80])
            else:
                listed.append((entry.group(1), entry.group(2)))
    return statements, headings, listed, problems


def check(catalogue):
    """Every difference between the hand-kept lists and counts and the statements, as lines of text."""
    papers = catalogue / 'Papers'
    differences = []
    count = {}
    pages = sorted(papers.glob('*.md'))
    for page in pages:
        name = page.stem
        text = page.read_text()
        statements, headings, listed, problems = read_page(text)
        count[name] = len(statements)
        differences += [name + ': ' + problem for problem in problems]
        repeated = sorted(set(label for label in statements if statements.count(label) > 1))
        if repeated:
            differences.append(name + ': a label is given to two statements: ' + ', '.join(repeated))
        if statements and listed is None:
            differences.append(name + ': the page has statements and no list of them')
        if listed is not None:
            foreign = [label for target, label in listed if target != name]
            if foreign:
                differences.append(name + ': the list links to another page for ' + ', '.join(foreign))
            labels = [label for target, label in listed]
            if labels != statements:
                missing = [label for label in statements if label not in labels]
                extra = [label for label in labels if label not in statements]
                detail = 'missing ' + ', '.join(missing) if missing else 'not on the page ' + ', '.join(extra) if extra else 'the order differs or a label repeats'
                differences.append(name + ': the list does not match the statements (' + detail + ')')
        without_heading = [label for label in statements if label not in headings]
        if without_heading:
            differences.append(name + ': no heading for ' + ', '.join(without_heading))
    statements_of = {page.stem: read_page(page.read_text())[0] for page in pages}
    for page in pages:
        name = page.stem
        if '__' in name:
            continue
        parts = [other for other in statements_of if other.startswith(name + '__')]
        blocks = block_after(lines_outside_fences(page.read_text()), PARTS_START)
        if len(blocks) != (1 if parts else 0):
            differences.append('%s: the paper has %d part pages and the list of parts is written %d times' % (name, len(parts), len(blocks)))
        named = []
        for line in (blocks[0] if blocks else []):
            found = PART_LINE.match(line)
            if found is None:
                differences.append(name + ': a line of the list of parts is not in the form of a part line: ' + line[:80])
                continue
            part, first, last, number = found.group(1), found.group(2), found.group(3) or found.group(2), int(found.group(4))
            named.append(part)
            if part not in parts:
                differences.append(name + ': a part line names a page that is not a part of this paper: ' + part)
                continue
            own = statements_of[part]
            if number != len(own):
                differences.append('%s: the part %s is said to have %d statements and has %d' % (name, part, number, len(own)))
            if not own or first != own[0] or last != own[-1]:
                differences.append('%s: the part %s is said to run %s–%s and its statements do not begin and end so' % (name, part, first, last))
        unnamed = [part for part in parts if statements_of[part] and named.count(part) != 1]
        if blocks and unnamed:
            differences.append(name + ': parts not named exactly once in the list of parts: ' + ', '.join(unnamed))
    papers_named = []
    themes = catalogue / 'EntryThemes.md'
    for line in (lines_outside_fences(themes.read_text()) if themes.exists() else []):
        named_paper = THEME_NAME.match(line)
        if not named_paper:
            continue
        paper = named_paper.group(1)
        papers_named.append(paper)
        if paper not in count:
            differences.append('EntryThemes: a line names a paper that does not exist: ' + paper)
            continue
        family = [name for name in count if name == paper or name.startswith(paper + '__')]
        total = sum(count[name] for name in family)
        found = THEME_LINE.match(line)
        if found is None:
            if total:
                differences.append('EntryThemes: %s has %d statements and its line gives no number in the expected form' % (paper, total))
            continue
        number, page_number = int(found.group(2)), found.group(3)
        if number != total:
            differences.append('EntryThemes: %s is said to have %d statements and has %d' % (paper, number, total))
        if page_number is not None and int(page_number) != len(family):
            differences.append('EntryThemes: %s is said to have %s pages and has %d' % (paper, page_number, len(family)))
        if page_number is None and len(family) != 1:
            differences.append('EntryThemes: %s has %d pages and the line does not say so' % (paper, len(family)))
    if themes.exists():
        for paper in sorted(name for name in count if '__' not in name):
            if papers_named.count(paper) != 1:
                differences.append('EntryThemes: the paper %s is named %d times' % (paper, papers_named.count(paper)))
    return differences, sum(count.values()), len(pages)


def selftest():
    good_main = '# Main\n\nStatements on this page:\n\n- <doc:main#AA1>: One.\n\nParts in reading order:\n\n- <doc:main__part>: AA2–AA3, 2 statements.\n\n### AA1\n\n**AA1 (One).** Text.\n'
    good_part = '# Part\n\nStatements on this page:\n\n- <doc:main__part#AA2>: Two.\n- <doc:main__part#AA3>: Three.\n\n### AA2\n\n**AA2 (Two).** Text.\n\n```\n**AA9 (inside a fence).** Not a statement.\n```\n\n### AA3\n\n**Theorem AA3 (Three).** Text.\n'
    good_themes = '# Themes\n\n- <doc:main>: 3 statements on 2 pages. First words.\n'
    planted = [
        ('nothing planted', {}, 0),
        ('a statement left out of the list', {'part': good_part.replace('- <doc:main__part#AA3>: Three.\n', '')}, 1),
        ('a listed label that is not on the page', {'part': good_part.replace('#AA3>: Three.', '#AA3>: Three.\n- <doc:main__part#AA4>: Four.')}, 1),
        ('the list in another order', {'part': good_part.replace('- <doc:main__part#AA2>: Two.\n- <doc:main__part#AA3>: Three.\n', '- <doc:main__part#AA3>: Three.\n- <doc:main__part#AA2>: Two.\n')}, 1),
        ('a link to another page', {'part': good_part.replace('<doc:main__part#AA2>', '<doc:main#AA2>')}, 1),
        ('a statement without a heading', {'part': good_part.replace('### AA3\n\n', '')}, 1),
        ('a page with statements and no list', {'part': good_part.replace('Statements on this page:', 'Statements here:')}, 1),
        ('a wrong number in a part line', {'main': good_main.replace('2 statements', '3 statements')}, 1),
        ('a wrong first label in a part line', {'main': good_main.replace('AA2–AA3', 'AA3–AA3')}, 1),
        ('a wrong last label in a part line', {'main': good_main.replace('AA2–AA3', 'AA2–AA2')}, 1),
        ('a part line for a page that does not exist', {'main': good_main.replace('<doc:main__part>', '<doc:main__gone>')}, 2),
        ('a part line in another form', {'main': good_main.replace('2 statements.', 'two statements.')}, 2),
        ('the list of parts gone', {'main': good_main.replace('Parts in reading order:', 'Parts:')}, 1),
        ('a part named twice', {'main': good_main.replace('- <doc:main__part>: AA2–AA3, 2 statements.\n', '- <doc:main__part>: AA2–AA3, 2 statements.\n- <doc:main__part>: AA2–AA3, 2 statements.\n')}, 1),
        ('a themes line in another form', {'themes': good_themes.replace('3 statements on 2 pages', 'three statements')}, 1),
        ('a paper missing from the themes page', {'themes': '# Themes\n'}, 1),
        ('a paper named twice on the themes page', {'themes': good_themes + good_themes.split('\n\n')[1]}, 1),
        ('a wrong number on the themes page', {'themes': good_themes.replace('3 statements', '4 statements')}, 1),
        ('a wrong number of pages on the themes page', {'themes': good_themes.replace('2 pages', '3 pages')}, 1),
        ('a statement added and nothing else changed', {'part': good_part + '\n### AA5\n\n**AA5 (Five).** Text.\n'}, 4),
        ('one label on two statements', {'part': good_part + '\n**AA3 (Three again).** Text.\n'}, 4),
        ('a list line that is not a link', {'part': good_part.replace('- <doc:main__part#AA3>: Three.', '- AA3: Three.')}, 2),
        ('the list written twice', {'part': good_part.replace('### AA2', 'Statements on this page:\n\n- <doc:main__part#AA2>: Two.\n\n### AA2')}, 1),
    ]
    failed = []
    for title, change, expected in planted:
        with tempfile.TemporaryDirectory() as folder:
            catalogue = pathlib.Path(folder)
            (catalogue / 'Papers').mkdir()
            (catalogue / 'Papers/main.md').write_text(change.get('main', good_main))
            (catalogue / 'Papers/main__part.md').write_text(change.get('part', good_part))
            (catalogue / 'EntryThemes.md').write_text(change.get('themes', good_themes))
            differences, total, pages = check(catalogue)
        if len(differences) != expected:
            failed.append('%s: expected %d differences, found %d: %s' % (title, expected, len(differences), differences))
    for line in failed:
        print('FAIL:', line)
    print('selftest %s: %d made-up catalogues' % ('FAILED' if failed else 'passed', len(planted)))
    return 1 if failed else 0


if __name__ == '__main__':
    if '--selftest' in sys.argv:
        sys.exit(selftest())
    differences, total, pages = check(CATALOGUE)
    for line in differences:
        print('DIFFERENCE:', line)
    if differences:
        print('✗ STATEMENT LISTS: %d differences.' % len(differences))
        sys.exit(1)
    print('✓ STATEMENT LISTS: %d statements on %d pages, every list, heading and count agrees.' % (total, pages))
