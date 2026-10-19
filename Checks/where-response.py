#!/usr/bin/env python3
"""Exercise addressed judgments and admission against the actual native command."""
import argparse
import copy
import json
from pathlib import Path
import subprocess
import tempfile

parser = argparse.ArgumentParser()
parser.add_argument('--tools', type=Path, required=True)
parser.add_argument('--report', type=Path)
args = parser.parse_args()
tools = args.tools.resolve()
checks = []
root = Path(tempfile.mkdtemp(prefix='vi-where-response-'))


def call(command, *paths):
    p = subprocess.run([str(tools), 'judge', command, *map(str, paths)], capture_output=True, text=True)
    return {'exit': p.returncode, 'stdout': p.stdout, 'stderr': p.stderr}


def req(identity, name='Good', kind='certificate', line=None):
    return {'id': identity, 'application': {'kind': kind, 'name': name, **({'line': line} if line is not None else {})}}


def batch(text, requests=None):
    return {'schema': 'vi.where.requests/1', 'question': 'vi.where.selected-applications/1',
            'world': {'name': 'world.swift', 'text': text}, 'definitions': [],
            'requests': requests if requests is not None else [req('good')]}


world = '''enum A {}
enum B {}
enum Match<L, R> {}
protocol Admitted {}
extension Match: Admitted where L == R {}
typealias Good = Match<A, A>
'''


def write(name, value):
    p = root / name
    p.write_text(json.dumps(value, ensure_ascii=False))
    return p


def check(name, value, expected, admission=False):
    source = write(name + '-request.json', value)
    result = call('where-report', source)
    assert result['exit'] == 0 and not result['stderr'], (name, result)
    report = json.loads(result['stdout'])
    assert [(x['id'], x['outcome']) for x in report['results']] == expected, (name, report)
    assert all(x['application'] == q['application'] and x['source'] == 'world.swift'
               for x, q in zip(report['results'], value['requests'])), (name, report)
    response = write(name + '-response.json', report)
    admitted = call('where-admit', source, response)
    assert admitted['exit'] == (0 if admission else 1), (name, admitted)
    checks.append({'case': name, 'results': expected, 'admission': admission})
    return source, response, report


source, response, good = check('holds', batch(world), [('good', 'holds')], True)
check('mixed-refusal', batch(world + 'typealias Bad = Match<A, B>\n', [req('good'), req('bad', 'Bad')]),
      [('good', 'holds'), ('bad', 'not-established')])
check('missing-certificate', batch(world, [req('missing', 'Absent')]), [('missing', 'open')])
check('alias', batch(world + 'typealias Pass<X> = Match<X, X>\ntypealias Via = Pass<A>\n', [req('via', 'Via')]),
      [('via', 'holds')], True)
check('nested-neighbor', batch(world + 'typealias Hidden = Optional<Match<A, B>>\n', [req('good'), req('hidden', 'Hidden')]),
      [('good', 'unsupported'), ('hidden', 'unsupported')])
check('conditional', batch(world + '#if FLAG\nenum Excluded {}\n#endif\n'), [('good', 'unsupported')])
check('unread-conjunct', batch(world + 'protocol Plain {}\nprotocol Other {}\nextension Match: Plain where L: Plain & Other {}\n'),
      [('good', 'unsupported')])
member = '''protocol Required {}
protocol Other {}
enum Atom {}
enum Box<T>: Required {}
enum Plain: Other {}
enum Use<T> {}
protocol Admitted {}
extension Use: Admitted where T: Required {}
'''
check('generic-member', batch(member + 'typealias Good = Use<Box<Atom>>\n'), [('good', 'unsupported')])
check('missing-member-grounds', batch(member + 'typealias Good = Use<Absent>\n'), [('good', 'open')])
check('member-not-established', batch(member + 'typealias Good = Use<Plain>\n'), [('good', 'not-established')])
check('cycle', batch(world.replace('Match<A, A>', 'Match<Loop, A>') + 'typealias Loop = Loop\n'), [('good', 'unsupported')])
check('duplicate-parameters', batch(world + 'protocol Plain {}\nenum Duplicate<T, T>: Plain {}\n'), [('good', 'unsupported')])
check('use', batch(world + 'Match<A, A>.self\n', [req('use', 'Match<A, A>', 'use', 7)]), [('use', 'holds')], True)
check('missing-use', batch(world + 'Match<A, A>.self\n', [req('use', 'Match<A, A>', 'use', 8)]), [('use', 'open')])
check('invalid-use-address', batch(world, [req('use', 'Match<A, A>', 'use', 0)]), [('use', 'input-error')])
conformer = '''enum A {}
enum B {}
protocol Root {}
protocol Same: Root where L == R { associatedtype L; associatedtype R }
enum Good: Same { typealias L = A; typealias R = A }
enum Bad: Same { typealias L = A; typealias R = B }
'''
check('conformers', batch(conformer, [req('yes', 'Good', 'conformer'), req('no', 'Bad', 'conformer')]),
      [('yes', 'holds'), ('no', 'not-established')])
check('missing-conformer', batch(conformer, [req('missing', 'Missing', 'conformer')]), [('missing', 'open')])
check('unknown-selector', batch(world, [req('unknown', 'Good', 'not-a-reader-kind')]), [('unknown', 'unsupported')])
check('mixed-coverage', batch(world, [req('good'), req('missing', 'Absent')]), [('good', 'holds'), ('missing', 'open')])
check('no-obligations', batch('typealias Good = A\n'), [('good', 'open')])



# B1: a missing protocol can hide an inherited gated obligation.
missing_direct = conformer.replace('enum Good: Same', 'enum Good: Same, Absent')
check('missing-direct-protocol', batch(missing_direct, [req('target', 'Good', 'conformer')]), [('target', 'open')])
missing_inherited = conformer.replace('Same: Root', 'Same: Absent')
check('missing-inherited-protocol', batch(missing_inherited, [req('target', 'Good', 'conformer')]), [('target', 'open')])
revealed = missing_inherited.replace('protocol Root {}', 'protocol Root {}\nprotocol Absent: Root where L == B { associatedtype L }')
check('revealed-inherited-obligation', batch(revealed, [req('target', 'Good', 'conformer')]), [('target', 'not-established')])
check('missing-gate-protocol', batch(world.replace('protocol Admitted {}\n', '')), [('good', 'open')])
check('missing-member-ancestor', batch(member.replace('protocol Required {}', 'protocol Required: Absent {}') + 'typealias Good = Use<Plain>\n'), [('good', 'open')])
check('missing-wearer-protocol', batch(member.replace('Plain: Other', 'Plain: Other, Absent') + 'typealias Good = Use<Plain>\n'), [('good', 'open')])
# A declaration of conformance alone does not discharge the wearer's gated conditions.
for name in ['Good', 'Bad']:
    dependent = conformer + 'enum Use<T> {}\nprotocol Admitted {}\nextension Use: Admitted where T: Same {}\ntypealias Claim = Use<' + name + '>\n'
    check('dependent-membership-' + name, batch(dependent, [req('claim', 'Claim')]), [('claim', 'unsupported')])
# B2: retain the owner and source span rather than the first short-name declaration.
local = world + 'protocol Marker {}\nenum First: Marker { typealias Claim = Match<A, A> }\nenum Second: Marker { typealias Claim = Match<A, A> }\n'
_, _, addressed = check('owner-qualified-lines', batch(local, [req('first', 'First.Claim'), req('second', 'Second.Claim')]), [('first', 'holds'), ('second', 'holds')], True)
assert [x['line'] for x in addressed['results']] == [8, 9], addressed
check('global-local-name-boundary', batch(local + 'typealias Claim = Match<A, A>\n', [req('global', 'Claim')]), [('global', 'unsupported')])
extended = world + 'protocol Marker {}\nenum Owner: Marker {}\nextension Owner {\n    typealias Claim = Match<A, A>\n}\n'
_, _, addressed = check('extension-certificate-line', batch(extended, [req('member', 'Owner.Claim')]), [('member', 'holds')], True)
assert addressed['results'][0]['line'] == 10, addressed
multiline = world + 'typealias\n    Claim = Match<A, A>\n'
_, _, addressed = check('multiline-certificate-line', batch(multiline, [req('member', 'Claim')]), [('member', 'holds')], True)
assert addressed['results'][0]['line'] == 7, addressed


def malformed(name, value):
    result = call('where-report', write(name + '.json', value))
    assert result['exit'] == 2 and not result['stdout'], (name, result)
    assert json.loads(result['stderr'])['status'] == 'input-error'
    checks.append({'case': name, 'transport': 'input-error'})


malformed('empty-requests', batch(world, []))
malformed('duplicate-ids', batch(world, [req('same'), req('same')]))
wrong = batch(world); wrong['definitions'] = [wrong['world']]
malformed('duplicate-sources', wrong)
wrong = batch(world); wrong['schema'] = 'later'
malformed('unknown-schema', wrong)
wrong = batch(world); wrong['question'] = 'count'
malformed('different-question', wrong)
missing = call('where-report', root / 'no-such-file.json')
assert missing['exit'] == 2 and not missing['stdout'] and json.loads(missing['stderr'])['status'] == 'input-error'
checks.append({'case': 'missing-request-file', 'transport': 'input-error'})


def reject(name, mutate, expected=source):
    altered = copy.deepcopy(good)
    mutate(altered)
    observed = call('where-admit', expected, write(name + '.json', altered))
    assert observed['exit'] == 1 and observed['stdout'] == 'not-admitted\n', (name, observed)
    checks.append({'case': name, 'admission': False})


reject('omitted-result', lambda r: r['results'].clear())
reject('duplicate-result', lambda r: r['results'].append(r['results'][0]))
reject('wrong-result-id', lambda r: r['results'][0].update(id='another'))
reject('wrong-selector', lambda r: r['results'][0]['application'].update(name='Bad'))
reject('wrong-source-name', lambda r: r['results'][0].update(source='elsewhere.swift'))
reject('wrong-canon', lambda r: r['versions'].update(normalizationCanon=3))
reject('wrong-fragment', lambda r: r['versions'].update(reader='different'))
reject('wrong-question', lambda r: r['versions'].update(question='different'))
reject('wrong-response-schema', lambda r: r.update(schema='later'))
reject('empty-counts', lambda r: r['results'][0].update(equalities=0, memberships=0))
reject('negative-count', lambda r: r['results'][0].update(memberships=-1))
reject('hidden-diagnostic', lambda r: r['results'][0].update(diagnostics=['unread']))
reject('missing-construction', lambda r: r['results'][0].update(construction=None))
changed = batch(world.replace('Match<A, A>', 'Match<A, B>'))
reject('changed-source-same-id', lambda r: None, write('changed-source.json', changed))
# Canonically equivalent Unicode in an unused JSON field still changes input bytes.
nfc = batch(world); nfc['note'] = '\u00e9'
nfd = batch(world); nfd['note'] = 'e\u0301'
nfc_path, _, nfc_report = check('unicode-original', nfc, [('good', 'holds')], True)
observed = call('where-admit', write('unicode-changed.json', nfd), write('unicode-report.json', nfc_report))
assert observed['exit'] == 1
checks.append({'case': 'unicode-byte-binding', 'admission': False})
summary = {'checks': len(checks), 'results': checks, 'scratch': str(root)}
if args.report:
    args.report.write_text(json.dumps(summary, ensure_ascii=False, indent=2) + '\n')
print(f"where-response: {len(checks)} addressed-result and admission controls passed")
