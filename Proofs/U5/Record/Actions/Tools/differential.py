#!/usr/bin/env python3
"""Finite T0117 qualification, not a proof of the Swift/Lean correspondence.

Reads only frozen records exported by the real Swift adapter. Compiler products
are explicit arguments. No compiler, source-language reader, gate or CI is run.
"""
import argparse
import copy
import hashlib
import json
from pathlib import Path
import subprocess
import time


def sha(b):
    return hashlib.sha256(b).hexdigest()


def wire(v):
    return json.dumps(v, ensure_ascii=True, separators=(',', ':')).encode()


def run(cmd):
    start = time.perf_counter()
    p = subprocess.run([str(x) for x in cmd], capture_output=True)
    return p.returncode, p.stdout, p.stderr, time.perf_counter() - start


def main():
    parser = argparse.ArgumentParser(__doc__)
    parser.add_argument('--native', type=Path, required=True)
    parser.add_argument('--lean', type=Path, required=True)
    parser.add_argument('--out', type=Path, required=True)
    args = parser.parse_args()
    args.out.mkdir(parents=True, exist_ok=False)
    root = Path(__file__).resolve().parents[3]
    frozen = Path(__file__).resolve().parents[1] / 'Cases/worlds.json'
    corpus = json.loads(frozen.read_bytes())
    contract = root.parents[1] / 'Contracts/Court/continuation-relations-v1/contract.json'
    assert sha(contract.read_bytes()) == corpus['contract_sha256']
    declared = json.loads(contract.read_bytes())['actions']['cases']
    assert [r['request'] for r in declared] == [r['request'] for r in corpus['cases']]
    assert len(declared) == 17
    rows, worlds, proofs = [], {}, {}

    def compare(group, name, world, proof, expected):
        n = run([args.native, 'replay', '--actions', proof, world])
        l = run([args.lean, '--actions', proof, world])
        row = dict(group=group, case=name, expected=expected, native=n[0], lean=l[0],
                   same_stdout=n[1] == l[1], native_seconds=n[3], lean_seconds=l[3],
                   native_diagnostic=n[2].decode(errors='replace').strip().replace(str(args.out), 'qualification'),
                   lean_diagnostic=l[2].decode(errors='replace').strip().replace(str(args.out), 'qualification'),
                   world_sha256=sha(world.read_bytes()), proof_sha256=sha(proof.read_bytes()))
        rows.append(row)
        if n[0] != expected or l[0] != expected or n[1] != l[1]:
            print(json.dumps(row, indent=2))

    dummy = args.out / 'dummy.json'
    dummy.write_bytes(b'{}')
    for row in corpus['cases']:
        name = row['request']
        world = args.out / (name + '.world.json')
        world.write_bytes(row['record'].encode())
        worlds[name] = world
        if row['outcome'] == 'unsupported':
            compare('contract-unread', name, world, dummy, 2)
            continue
        proof = args.out / (name + '.proof.json')
        expected = 0 if row['outcome'] == 'constructed' else 1
        result = run([args.native, '--actions', '--certificate', proof, world])
        assert result[0] == expected, (name, result)
        proofs[name] = proof
        if dummy.read_bytes() == b'{}':
            dummy.write_bytes(proof.read_bytes())
        compare('contract', name, world, proof, expected)
        value = json.loads(proof.read_bytes())
        # Valid transport is deliberately not canonical. Both executables must
        # print precisely these checked bytes, including pre-existing final LF.
        for label, bs in [('compact', wire(value)), ('LF', wire(value) + b'\n'),
                          ('whitespace', b' \n' + json.dumps(value, indent=1).encode() + b' \n'),
                          ('CRLF', json.dumps(value, indent=1).replace('\n', '\r\n').encode() + b'\r\n')]:
            p = args.out / (name + '.' + label + '.json')
            p.write_bytes(bs)
            compare('printing', name + '/' + label, world, p, expected)

    base = json.loads(worlds['CyclicQuestion'].read_bytes())
    malformed = []

    def bad(name, original, edit):
        value = copy.deepcopy(original)
        edit(value)
        malformed.append((name, wire(value)))

    bad('short image', base, lambda v: v['actions'][0]['image'].pop())
    bad('extra image', base, lambda v: v['actions'][0]['image'].append([0]))
    bad('nested image', base, lambda v: v['actions'][0]['image'].__setitem__(0, [[0]]))
    bad('nonleaf image', base, lambda v: v['actions'][0]['image'].__setitem__(0, []))
    bad('unknown image', base, lambda v: v['actions'][0]['image'].__setitem__(0, [1, 1, 1]))
    bad('repeated member', base, lambda v: v['actions'].append(copy.deepcopy(v['actions'][0])))
    bad('unknown member field', base, lambda v: v['actions'][0].__setitem__('label', 'name'))
    bad('missing member address', base, lambda v: v['actions'][0].pop('at'))
    bad('wrong side', base, lambda v: v['actions'][0].__setitem__('at', [2]))
    bad('too deep address', base, lambda v: v['actions'][0].__setitem__('at', [0] * 128))
    bad('unordered members', json.loads(worlds['NoncommutingWords'].read_bytes()), lambda v: v['actions'].reverse())
    bad('empty hidden family', base, lambda v: v.__setitem__('hiddenActions', []))
    bad('null hidden family', base, lambda v: v.__setitem__('hiddenActions', None))
    bad('unread hidden axis', base, lambda v: v.__setitem__('HiddenActions', []))
    two = dict(schema=2, source=[dict(pair=[1, 2]), dict(sort=0), dict(sort=1)], equalities=[],
               observation=dict(place=[0]), question=dict(place=[1]), actions=[dict(at=[], image=[[0], [1]])])
    bad('wrong image sort', two, lambda v: v['actions'][0]['image'].__setitem__(0, [1]))
    bad('schema 1 cannot ignore actions', base, lambda v: v.__setitem__('schema', 1))
    canonical = wire(base)
    malformed += [('BOM', b'\xef\xbb\xbf' + canonical), ('trailing LF', canonical + b'\n'),
                  ('duplicate axis', canonical[:-1] + b',"actions":[]}'),
                  ('invalid UTF8', b'\xff'), ('trailing object', canonical + b'{}')]
    for index, (name, bs) in enumerate(malformed):
        world = args.out / ('bad-world-' + str(index) + '.json')
        world.write_bytes(bs)
        compare('malformed', name, world, proofs['CyclicQuestion'], 2)

    forged = []

    def forge(name, source, edit):
        value = json.loads(proofs[source].read_bytes())
        edit(value)
        forged.append((name, source, wire(value)))

    def dyn(name, source, edit):
        forge(name, source, lambda p: edit(p['dynamics']))

    p = 'PreservesEqualities'
    forge('missing dynamics', p, lambda v: v.pop('dynamics'))
    forge('unread top field', p, lambda v: v.__setitem__('ignored', True))
    forge('wrong format', p, lambda v: v.__setitem__('format', 4))
    forge('substituted record', p, lambda v: v.__setitem__('record', worlds['CyclicQuestion'].read_text()))
    forge('retention in actions', p, lambda v: v.__setitem__('retention', {}))
    dyn('unread dynamics field', p, lambda d: d.__setitem__('ignored', True))
    dyn('missing exact partition', p, lambda d: d.__setitem__('classes', []))
    dyn('wrong partition sort', p, lambda d: d['classes'][0].__setitem__('sort', '99'))
    dyn('missing forests', p, lambda d: d.__setitem__('connections', []))
    dyn('lost forest edge', p, lambda d: d['connections'].__setitem__(0, []))
    dyn('wrong forest edge', p, lambda d: d['connections'][0][0].__setitem__('edge', ['Right']))
    dyn('missing preservation', p, lambda d: d.__setitem__('actions', []))
    dyn('extra preservation', p, lambda d: d['actions'].append(copy.deepcopy(d['actions'][0])))
    dyn('wrong member', p, lambda d: d['actions'][0].__setitem__('member', ['Left']))
    dyn('missing preservation E grounds', p, lambda d: d['actions'][0].__setitem__('preservation', {'preserved': {'_0': []}}))
    dyn('observed equality', p, lambda d: d['actions'][0].__setitem__('preservation', {'preserved': {'_0': [{'observedValues': {}}]}}))
    dyn('false refusal', p, lambda d: d['actions'][0].__setitem__('preservation', {'notPreserved': {'edge': []}}))
    dyn('missing stable view', p, lambda d: d.pop('stable'))
    dyn('empty reached classes', p, lambda d: d['stable'].__setitem__('classes', []))
    dyn('empty representatives', p, lambda d: d['stable'].__setitem__('representatives', []))
    dyn('unknown word', p, lambda d: d['stable']['classes'][0].__setitem__('word', [['Left']]))
    dyn('unknown Question place', p, lambda d: d['stable']['classes'][0].__setitem__('question', ['Left']))
    dyn('wrong reached block', p, lambda d: d['stable']['classes'][0].__setitem__('block', 999))
    dyn('observed reach ground', p, lambda d: d['stable']['classes'][0].__setitem__('basis', {'observedValues': {}}))
    dyn('missing closure', p, lambda d: d['stable'].__setitem__('actions', []))
    dyn('bad target', p, lambda d: d['stable']['actions'][0].__setitem__('targets', [999]))
    dyn('missing image selections', p, lambda d: d['stable']['actions'][0].__setitem__('selections', []))
    dyn('wrong image program', p, lambda d: d['stable']['actions'][0].__setitem__('program', {'pick': {'_0': ['Left']}}))
    dyn('missing decoder selections', p, lambda d: d['stable'].__setitem__('selections', []))
    dyn('wrong decoder program', p, lambda d: d['stable'].__setitem__('decoder', {'pick': {'_0': ['Left']}}))
    dyn('missing empty word', 'CyclicQuestion', lambda d: d['stable']['classes'][0].__setitem__('word', [[], [], []]))
    dyn('wrong reached word', 'CyclicQuestion', lambda d: d['stable']['classes'][1].__setitem__('word', []))
    dyn('unknown refused edge', 'BreaksEqualities', lambda d: d['actions'][0].__setitem__('preservation', {'notPreserved': {'edge': ['Right']}}))
    dyn('false preservation', 'BreaksEqualities', lambda d: d['actions'][0].__setitem__('preservation', {'preserved': {'_0': [{'address': {}}]}}))
    h = 'HiddenCommon'
    dyn('lost H evidence', h, lambda d: d.pop('hiddenActions'))
    dyn('empty H evidence', h, lambda d: d.__setitem__('hiddenActions', []))
    dyn('lost hidden judgment', h, lambda d: d.pop('hidden'))
    dyn('lost observed classes', h, lambda d: d['hidden'].__setitem__('classes', []))
    dyn('wrong inherited closure', h, lambda d: d['hidden'].__setitem__('closureInheritedFromStableView', True))
    dyn('missing common actions', h, lambda d: d['hidden']['conclusion']['common'].__setitem__('actions', []))
    dyn('wrong common program', h, lambda d: d['hidden']['conclusion']['common'].__setitem__('program', {'pick': {'_0': ['Left']}}))
    dyn('wrong outside image', 'HiddenOutside', lambda d: d['hidden']['conclusion']['outside'].__setitem__('image', ['Left']))
    dyn('same disagreement member', 'HiddenDisagreement', lambda d: d['hidden']['conclusion']['disagreement'].__setitem__('right', ['Left']))
    for index, (name, source, bs) in enumerate(forged):
        proof = args.out / ('forged-' + str(index) + '.json')
        proof.write_bytes(bs)
        compare('forged', name, worlds[source], proof, 2)

    # World changes with a matching record string must still fail the semantic
    # judgment, rather than succeed solely because the envelope is self-consistent.
    changed = copy.deepcopy(base)
    changed['actions'][0]['image'] = [[0], [1, 0], [1, 1]]
    world = args.out / 'changed-image.world.json'; world.write_bytes(wire(changed))
    value = json.loads(proofs['CyclicQuestion'].read_bytes()); value['record'] = world.read_text()
    proof = args.out / 'changed-image.proof.json'; proof.write_bytes(wire(value))
    compare('forged', 'changed image with matching record', world, proof, 2)

    failures = [r for r in rows if r['native'] != r['expected'] or r['lean'] != r['expected'] or not r['same_stdout']]
    report = dict(cases=len(rows), failures=failures, groups={g: sum(r['group'] == g for r in rows) for g in sorted({r['group'] for r in rows})},
                  native_sha256=sha(args.native.read_bytes()), lean_sha256=sha(args.lean.read_bytes()),
                  corpus_sha256=sha(frozen.read_bytes()), rows=rows)
    (args.out / 'differential.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps({k: v for k, v in report.items() if k != 'rows'}, indent=2))
    raise SystemExit(bool(failures))


if __name__ == '__main__':
    main()
