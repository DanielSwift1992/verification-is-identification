#!/usr/bin/env python3
"""Finite qualification of the byte entrance, not a correspondence proof.

Inputs are the frozen T0109 observations. No Swift source is parsed here.
The native product is supplied explicitly; no compiler, gate or CI is invoked.
"""
import argparse
import copy
import hashlib
import json
from pathlib import Path
import statistics
import subprocess
import time


def sha(b):
    return hashlib.sha256(b).hexdigest()


def wire(v):
    return json.dumps(v, ensure_ascii=True, separators=(",", ":")).encode()


def run(cmd):
    start = time.perf_counter()
    p = subprocess.run([str(s) for s in cmd], capture_output=True)
    return p.returncode, p.stdout, p.stderr, time.perf_counter() - start


def main():
    parser = argparse.ArgumentParser(__doc__)
    parser.add_argument("--native", required=True, type=Path)
    parser.add_argument("--lean", required=True, type=Path)
    parser.add_argument("--out", required=True, type=Path)
    args = parser.parse_args()
    args.out.mkdir(parents=True, exist_ok=False)
    root = Path(__file__).resolve().parents[2]
    frozen = root / "Record/Cases/worlds.json"
    corpus = json.loads(frozen.read_text())
    contract = root.parents[1] / "Contracts/Court/continuation-relations-v1/contract.json"
    assert sha(contract.read_bytes()) == corpus["contract_sha256"]
    declared = json.loads(contract.read_bytes())
    expected_cases = [(r["request"], r["outcome"]) for r in declared["cases"]]
    expected_cases += [(r["request"], "constructed" if r["minimum_leaves"] == 0 else "obstructed")
                      for r in declared["retention"]["cases"]]
    assert [(r["request"], r["outcome"]) for r in corpus["cases"]] == expected_cases
    assert len(expected_cases) == 29
    rows, worlds, proofs = [], {}, {}

    def compare(group, name, world, proof, retain, expected):
        flag = ["--retain"] if retain else []
        n = run([args.native, "replay"] + flag + [proof, world])
        l = run([args.lean] + flag + [proof, world])
        row = dict(group=group, case=name, retain=retain, expected=expected,
                   native=n[0], lean=l[0], native_seconds=n[3], lean_seconds=l[3],
                   same_stdout=n[1] == l[1],
                   native_diagnostic=n[2].decode(errors="replace").strip(),
                   lean_diagnostic=l[2].decode(errors="replace").strip(),
                   world_sha256=sha(world.read_bytes()), proof_sha256=sha(proof.read_bytes()))
        rows.append(row)
        if n[0] != expected or l[0] != expected or n[1] != l[1]:
            print(json.dumps(row, indent=2))

    # Generate certificates with the existing RecordCourt, then replay each with
    # both implementations. Eight rows remain explicitly unread counterparts.
    dummy = args.out / "dummy-proof.json"
    dummy.write_bytes(b'{}')
    for row in corpus["cases"]:
        name = row["request"]
        world = args.out / (name + ".world.json")
        world.write_bytes(row["record"].encode())
        worlds[name] = world
        if row["outcome"] == "unsupported":
            continue
        for retain in [False, True]:
            proof = args.out / (name + (".u6" if retain else ".u5") + ".proof.json")
            cmd = [args.native] + (["--retain"] if retain else []) + ["--certificate", proof, world]
            result = run(cmd)
            expected = 0 if retain or row["outcome"] == "constructed" else 1
            assert result[0] == expected, (name, result)
            proofs[name, retain] = proof
            compare("contract", name, world, proof, retain, expected)
    dummy.write_bytes(proofs["AddressIdentity", False].read_bytes())
    for row in corpus["cases"]:
        if row["outcome"] == "unsupported":
            for retain in [False, True]:
                compare("contract", row["request"], worlds[row["request"]], dummy, retain, 2)

    base = worlds["SameSortDifferentPlaces"].read_text()
    equal = worlds["OneEquality"].read_text()
    malformed = [
        ("unknown place", base.replace('"place":[1]', '"place":[1,0]')),
        ("nonleaf", base.replace('"place":[1]', '"place":[]')),
        ("cycle", base.replace('"pair":[1,2]', '"pair":[0,2]')),
        ("shared tree node", base.replace('"pair":[1,2]', '"pair":[1,1]')),
        ("unknown node", base.replace('"pair":[1,2]', '"pair":[1,99]')),
        ("duplicate key", base.replace('"schema":1', '"schema":1,"schema":1')),
        ("escaped duplicate key", base.replace('"schema":1', '"schema":1,"schem\\u0061":1')),
        ("extra bytes", base + '{}'), ("trailing newline", base + '\n'),
        ("BOM", '\ufeff' + base), ("Swift is not record grammar", 'enum World<S> {}'),
        ("unread action", base.replace('"schema":1', '"Actions":[],"schema":1')),
        ("wrong version", base.replace('"schema":1', '"schema":2')),
        ("noncanonical sort", base.replace('"sort":0', '"sort":9')),
        ("unknown source field", base.replace('{"sort":0}', '{"sort":0,"value":0}')),
        ("cross sort E", equal.replace('"sort":0},{"sort":0}', '"sort":0},{"sort":1}')),
        ("observed coincidence", equal.replace('"declared"', '"observedValues"')),
        ("invalid UTF8", b'\xff'),
    ]
    assert len(malformed) == 18
    for i, (name, text) in enumerate(malformed):
        world = args.out / ("malformed-" + str(i) + ".json")
        world.write_bytes(text if isinstance(text, bytes) else text.encode())
        for retain in [False, True]:
            compare("malformed", name, world, dummy, retain, 2)

    plan = json.loads(proofs["SameSortDifferentPlaces", True].read_bytes())
    construction = json.loads(proofs["OneEquality", False].read_bytes())
    forged = []

    def edit(label, original, mutation, world="SameSortDifferentPlaces"):
        value = copy.deepcopy(original)
        mutation(value)
        forged.append((label, wire(value), worlds[world]))

    edit("substituted record", plan, lambda p: p.update(record=equal))
    edit("missing residual", plan, lambda p: p["retention"].update(leaves=[]))
    edit("extra residual", plan, lambda p: p["retention"]["leaves"].append(["Left"]))
    edit("wrong class", plan, lambda p: p["retention"].update(leaves=[["Left"]]))
    edit("forged decoder", plan, lambda p: p["retention"].update(program={"pick": {"_0": []}}))

    def fuse(p):
        o = p["conclusion"]["obstructed"]["_0"]
        o["classes"][0]["leaves"] += o["classes"][1]["leaves"]
        del o["classes"][1]
    edit("forged partition", plan, fuse)
    edit("missing exact class forest", plan,
         lambda p: p["conclusion"]["obstructed"]["_0"]["residue"].update(connections=[]))
    for label, basis in [("observed value proof", {"observedValues": {}}),
                         ("forged E path", {"sourceRelation": {"_0": [{"edge": ["Left"], "reversed": False}]}}),
                         ("forged address identity", {"address": {}})]:
        edit(label, construction,
             lambda p, b=basis: p["conclusion"]["constructed"]["_0"][0].update(basis=b), "OneEquality")
    forged.append(("duplicate certificate key", proofs["SameSortDifferentPlaces", True].read_bytes().replace(
        b'"format" : 8', b'"format" : 8, "format" : 8'), worlds["SameSortDifferentPlaces"]))
    assert len(forged) == 11
    for i, (name, text, world) in enumerate(forged):
        proof = args.out / ("forged-" + str(i) + ".json")
        proof.write_bytes(text)
        for retain in [False, True]:
            compare("forged", name, world, proof, retain, 2)

    # Lead's T0109 review, as named input forms. Two accepted boundary controls
    # and finite E cycles are retained; admission is not equated with refusal.
    v = json.loads(base)
    edge = dict(at=[], left=[0], right=[1], basis="declared")
    extra = []
    def change(name, field, value):
        a = copy.deepcopy(v); a[field] = value
        extra.append((name, wire(a), 2))
    extra += [("number 1.0", base.replace('"schema":1', '"schema":1.0').encode(), 2),
              ("number 1e0", base.replace('"schema":1', '"schema":1e0').encode(), 2),
              ("number -0", base.replace('"sort":0', '"sort":-0').encode(), 2),
              ("number 00", base.replace('"sort":0', '"sort":00').encode(), 2),
              ("number 10^23", base.replace('"sort":0', '"sort":' + str(10**23)).encode(), 2)]
    change("skipped sort", "source", [dict(pair=[1,2]),dict(sort=0),dict(sort=2)])
    change("nonpreorder nodes", "source", [dict(pair=[2,1]),dict(sort=0),dict(sort=0)])
    change("repeated edge address", "equalities", [edge, edge])
    change("out of order E", "equalities", [dict(edge,at=[1]),dict(edge,at=[0])])
    change("side 2", "question", dict(place=[2]))
    extra.append(("escaped declared", equal.replace('"declared"','"decla\\u0072ed"').encode(),2))
    change("empty view pair", "question", dict(pair=[]))
    change("past leaf", "question", dict(place=[1,0]))
    extra += [("space", base.replace(':', ': ', 1).encode(), 2),
              ("tail NUL", base.encode()+b'\x00', 2)]
    change("empty Source", "source", [])
    change("key order", "schema", 1)
    extra[-1] = ("key order", wire(dict(reversed(list(v.items())))), 2)
    change("null view", "question", None)
    extra.append(("empty input", b'', 2))
    change("true in path", "question", dict(place=[True]))
    change("1.0 in path", "question", dict(place=[1.0]))
    root_leaf=dict(schema=1,source=[dict(sort=0)],equalities=[],observation=dict(place=[]),question=dict(place=[]))
    extra.append(("root leaf", wire(root_leaf), 0))
    for depth in [127,128]:
        nodes=[]
        def chain(n):
            at=len(nodes);nodes.append(None)
            if n==0:nodes[at]=dict(sort=0)
            else:
                l=len(nodes);nodes.append(dict(sort=0));r=chain(n-1);nodes[at]=dict(pair=[l,r])
            return at
        chain(depth)
        a=dict(schema=1,source=nodes,equalities=[],observation=dict(place=[1]*depth),question=dict(place=[1]*depth))
        extra.append(("depth " + str(depth),wire(a),0 if depth==127 else 2))
    a=copy.deepcopy(v); a['equalities']=[dict(at=[],left=[0],right=[0],basis='declared')]
    extra.append(("self E",wire(a),1))
    a=copy.deepcopy(v); a['equalities']=[edge,dict(at=[0],left=[1],right=[0],basis='declared')]
    extra.append(("finite E cycle",wire(a),0))
    change("string in path", "question", dict(place=["Right"]))
    change("unknown world field", "Actions", [])
    assert len(extra)==28, len(extra)
    for i,(name,text,expected) in enumerate(extra):
        world=args.out/("lead-"+str(i)+".json");world.write_bytes(text)
        proof=args.out/("lead-"+str(i)+".proof.json")
        if expected!=2:
            for retain in [False,True]:
                flag=["--retain"] if retain else []
                n=run([args.native]+flag+["--certificate",proof,world]);assert n[0]==(0 if retain else expected)
                compare("lead",name,world,proof,retain,0 if retain else expected)
        else:
            for retain in [False,True]:compare("lead",name,world,dummy,retain,2)

    # Synchronize the forged embedded record with the substituted world: the
    # stale E-path still must not become a valid certificate on the other model.
    synchronized=copy.deepcopy(construction);synchronized['record']=base
    proof=args.out/'synchronized-substitution.json';proof.write_bytes(wire(synchronized))
    for retain in [False,True]:compare('substitution','world and envelope changed',worlds['SameSortDifferentPlaces'],proof,retain,2)

    timing={}
    for label,binary,prefix in [('native',args.native,['replay']),('lean',args.lean,[])]:
        cmd=[binary]+prefix+['--retain',proofs['RetainTwoSorts',True],worlds['RetainTwoSorts']]
        samples=[run(cmd) for _ in range(21)]
        assert all(s[0]==0 for s in samples)
        timing[label]=dict(median_seconds=statistics.median(s[3] for s in samples),
                           minimum_seconds=min(s[3] for s in samples), samples_seconds=[s[3] for s in samples])
    failures=[r for r in rows if r['native']!=r['expected'] or r['lean']!=r['expected'] or not r['same_stdout']]
    receipt=dict(schema=1,worlds=len(corpus["cases"]),malformed=len(malformed),forgeries=len(forged),lead_records=len(extra),comparisons=len(rows),
                 failures=len(failures),native_sha256=sha(args.native.read_bytes()),
                 lean_sha256=sha(args.lean.read_bytes()),frozen_worlds_sha256=sha(frozen.read_bytes()),
                 harness_sha256=sha(Path(__file__).read_bytes()),
                 timing_case='RetainTwoSorts with --retain; process startup included; 21 sequential samples',
                 timing=timing, observations=rows)
    (args.out/'receipt.json').write_text(json.dumps(receipt,indent=2)+'\n')
    print(json.dumps({k:v for k,v in receipt.items() if k not in ['observations','timing']},indent=2))
    print('timing medians:',{k:v['median_seconds'] for k,v in timing.items()})
    return 1 if failures else 0


if __name__=='__main__':
    raise SystemExit(main())
