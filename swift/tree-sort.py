#!/usr/bin/env python3
# tree-sort.py — induce the documentation tree from the type lattice.
#
# THE BRANCHING LAW (Law.swift §1+§T, lifted to the node, guaranteed by §6 "the
# law obeys the law"): a node's place is the MOVE it makes, read off the types —
# never assigned by hand.
#   opens an associatedtype, axis-only lineage   -> AXIS    (the clean spine)
#   touches exactly one sub-axis                  -> THEOREM (hangs on that axis)
#   touches >= 2 sub-axes (intersect)             -> BRIDGE  (the web)
#   Pair/Σ-rooted, no sub-axis                    -> MEDIUM (markers) | KERNEL
#   the two undefined terms                        -> SEED   (Pair, Null)
#
# The induced architecture (verified against DocC):
#   LANDING (Theory.md ## Topics) = the SPINE — seed, markers, kernel, the four
#     axes that carry private theorems, the pure generators, the floor, the
#     projection, the witnesses. One clean tree.
#   EACH PAPER PAGE (Papers/*.md ## Topics) = a ROUTE — the WEB bridges it proves
#     (Order Is Object §F). This curates the web off the landing and adds the
#     paper->symbol back-edges, with zero orphans and zero DocC warnings.
#
# Modes:  (default) audit + diff vs current curation · --emit print · --write apply
# Σ is the trunk, not a branch: it is excluded from every intersect count.

import json, re, sys, os

HERE = os.path.dirname(os.path.abspath(__file__))
GRAPH = os.path.join(HERE, ".build/arm64-apple-macosx/symbolgraph/Theory.symbols.json")
DOCC = os.path.join(HERE, "Sources/Theory/Theory.docc")
MODE = sys.argv[1].lstrip("-") if len(sys.argv) > 1 else "audit"

G = json.load(open(GRAPH))
sym = {s["identifier"]["precise"]: s for s in G["symbols"]}
title = {p: s["names"]["title"] for p, s in sym.items()}
kind = {p: s["kind"]["identifier"] for p, s in sym.items()}
pid_of = {t: p for p, t in title.items()}
line_of = {p: s.get("location", {}).get("position", {}).get("line", 1 << 30) for p, s in sym.items()}
file_of = {p: os.path.basename(s.get("location", {}).get("uri", "")) for p, s in sym.items()}

protos = [p for p in sym if kind[p] == "swift.protocol"]
structs = [p for p in sym if kind[p] == "swift.struct"]
SEED = {p for p in protos if title[p] in ("Pair", "Null")}

# --- opens an axis: target of a requirementOf edge from an associatedtype ---
opens = {r["target"] for r in G["relationships"]
         if r["kind"] == "requirementOf" and kind.get(r["source"]) == "swift.associatedtype"}

# --- direct parents: typeIdentifiers before the first `where` ---
def parents(p):
    out = []
    for f in sym[p]["declarationFragments"]:
        if f["kind"] == "keyword" and f["spelling"] == "where":
            break
        if f["kind"] == "typeIdentifier" and f.get("preciseIdentifier") in sym:
            out.append(f["preciseIdentifier"])
    return out
par = {p: parents(p) for p in protos}

# --- axes: declares an associatedtype, lineage is axis-only (rooted, not seed) ---
axis = set()
chg = True
while chg:
    chg = False
    for p in protos:
        if p in axis or p in SEED or p not in opens:
            continue
        if (not par[p]) or all(x in axis for x in par[p]):
            axis.add(p); chg = True

_anc = {}
def anc(p):
    if p not in _anc:
        _anc[p] = set()
        for q in par[p]:
            _anc[p].add(q); _anc[p] |= anc(q)
    return _anc[p]

ROOT = pid_of["HasSigma"]
def real_closure(p):
    return {q for q in anc(p) if q in axis} - {ROOT}

_dep = {}
def depth(p):
    if p not in _dep:
        _dep[p] = 0 if not par[p] else 1 + max(depth(q) for q in par[p])
    return _dep[p]

# markers: used as a constraint (where-clause OR inline associatedtype pin)
constraint = set()
for p, s in sym.items():
    seen = False
    for f in s["declarationFragments"]:
        if f["kind"] == "keyword" and f["spelling"] == "where": seen = True
        if kind[p] == "swift.associatedtype" and f["kind"] == "text" and ":" in f["spelling"]: seen = True
        if seen and f["kind"] == "typeIdentifier" and "preciseIdentifier" in f:
            constraint.add(f["preciseIdentifier"])

def classify(p):
    if p in SEED: return "seed"
    if p in axis: return "axis"
    n = len(real_closure(p))
    if n >= 2: return "bridge"
    if n == 1: return "theorem"
    return "marker" if p in constraint else "kernel"
cls = {p: classify(p) for p in protos}

theorems_on = {a: [] for a in axis}
for p in protos:
    if cls[p] == "theorem":
        theorems_on[next(iter(real_closure(p)))].append(p)

# file -> paper doc page (the route). Foundation files (Core/Primitive/VI) are
# paper 1; Witness/Law have no paper. Spec/Measure/Projection live on the landing.
PAPER = {
    "Primitive.swift": "1_verification_is_identification", "Core.swift": "1_verification_is_identification",
    "VI.swift": "1_verification_is_identification", "IiI.swift": "2_intelligence_is_inevitable",
    "Matter.swift": "3_permanence_is_resistance", "Space.swift": "4_difference_is_distance",
    "Interference.swift": "5_interference_is_intelligence",
    "Gradient.swift": "6_distance_is_cost", "Map.swift": "7_navigation_is_geometry",
    "Strategy.swift": "8_order_is_object", "Dynamics.swift": "9_law_is_target",
    "Play.swift": "10_play_is_proof", "Basis.swift": "B_basis_is_residue",
    "Search.swift": "GA_gradient_is_alignment", "Generation.swift": "GD_proposal_is_order",
    "Liquid.swift": "L_learning_is_liquid",
}
FLOOR_FILES = {"Spec.swift", "Measure.swift"}   # -> landing "The floor"
PROJ_FILES = {"Projection.swift"}               # -> landing "Projection"

def names(ps): return [title[p] for p in ps]
def bullets(ns): return "\n".join(f"- ``{n}``" for n in ns)

# ---- the landing (spine) ----
def landing_topics(trailheads, witness_names):
    g = ["## Topics\n"]
    g.append("### Start here\n\n" + bullets(trailheads) + "\n")
    g.append("### The seed — the two undefined terms\n\n"
             + bullets(sorted(names(SEED))) + "\n")
    g.append("### The medium — markers, the functions on Pair\n\n"
             + bullets(names(sorted((p for p in protos if cls[p] == "marker"), key=depth))) + "\n")
    g.append("### The kernel — the V=I core (Pair / Σ-rooted)\n\n"
             + bullets(names(sorted((p for p in protos if cls[p] == "kernel"), key=depth))) + "\n")
    for aname, role in [("HasSolutions", "Identification"), ("HasCache", "The cache"),
                        ("HasDistance", "The metric"), ("HasEncoding", "The lens")]:
        a = pid_of[aname]
        members = [aname] + names(sorted(theorems_on[a], key=depth))
        g.append(f"### {role} — the {aname} axis\n\n" + bullets(members) + "\n")
    gen = sorted((a for a in axis if not theorems_on[a]), key=lambda x: (0 if x == ROOT else 1, title[x]))
    g.append("### The axes — pure generators\n\n" + bullets(names(gen)) + "\n")
    floor = sorted((p for p in protos if file_of[p] in FLOOR_FILES), key=depth)
    g.append("### The floor — what it delegates, where it stops\n\n" + bullets(names(floor)) + "\n")
    proj = sorted((p for p in protos if file_of[p] in PROJ_FILES), key=depth)
    g.append("### Projection — the framework instantiated on machines\n\n" + bullets(names(proj)) + "\n")
    g.append("### Witnesses — concrete models that make it bite\n\n" + bullets(witness_names) + "\n")
    g.append("### The papers — the routes\n\n- <doc:Sources>\n")
    return "\n".join(g)

# ---- per-paper web routes ----
def paper_topics():
    by = {}
    for p in protos:
        if cls[p] == "bridge" and file_of[p] in PAPER:
            by.setdefault(PAPER[file_of[p]], []).append(p)
    out = {}
    for doc, ps in by.items():
        ordered = sorted(ps, key=lambda x: line_of[x])
        out[doc] = "## Topics\n\n### Theorems this paper proves\n\n" + bullets(names(ordered)) + "\n"
    return out

orphan = [title[p] for p in protos if cls[p] == "bridge"
          and file_of[p] not in PAPER and file_of[p] not in FLOOR_FILES | PROJ_FILES]

# ---- read current curation (trailheads + witnesses are preserved manual) ----
def parse_groups(md):
    groups, cur = {}, None
    for line in md.split("## Topics", 1)[-1].splitlines():
        h = re.match(r"^###\s+(.*)", line)
        if h: cur = h.group(1).strip(); groups[cur] = []
        m = re.match(r"^-\s+``([A-Za-z0-9_]+)``", line)
        if m and cur: groups[cur].append(m.group(1))
    return groups

theory_md_path = os.path.join(DOCC, "Theory.md")
cur_groups = parse_groups(open(theory_md_path).read())
trailheads = cur_groups.get("Start here", ["PassIsIdentification", "SystemCrystallizes", "Matter", "PlayIsProof"])
witness_names = next((v for k, v in cur_groups.items() if k.startswith("Witnesses")), sorted(names(structs)))

LAND = landing_topics(trailheads, witness_names)
PAPERS = paper_topics()

# ============================ apply / emit / audit ============================
def target(path, topics_block):
    txt = open(path).read()
    idx = txt.rfind("\n## Topics")          # the generated block is the final section
    head = (txt[:idx] if idx != -1 else txt).rstrip()
    if not head.strip():                     # guard: never blank out a file's prose
        raise SystemExit(f"refusing to write empty-prose file (would delete content): {path}")
    return head + "\n\n" + topics_block.rstrip() + "\n"

def each_file():
    yield theory_md_path, LAND
    for doc, block in PAPERS.items():
        yield os.path.join(DOCC, "Papers", doc + ".md"), block

if MODE == "write":
    for path, block in each_file():
        new = target(path, block)   # read + compute BEFORE truncating (eval order matters)
        open(path, "w").write(new)
    print(f"wrote landing + {len(PAPERS)} paper routes."
          + (f"  ORPHANS: {orphan}" if orphan else "  (no orphans)"))

elif MODE == "check":  # the invariant: Topics must equal what the types induce
    drift = [os.path.basename(p) for p, b in each_file() if open(p).read() != target(p, b)]
    if drift or orphan:
        print("✗ Topics DRIFT from the type lattice:", drift or "", "ORPHANS:" if orphan else "", orphan or "")
        sys.exit(1)
    print("✓ Topics in sync with the type lattice (spine + routes induced, no orphans).")

elif MODE == "emit":
    print("════════ LANDING (Theory.md) ════════\n")
    print(LAND)
    for doc, block in sorted(PAPERS.items()):
        print(f"\n════════ Papers/{doc}.md ════════\n")
        print(block)
    print("orphan web bridges:", orphan or "NONE")

else:  # audit
    from collections import Counter, defaultdict
    c = Counter(cls.values())
    print("CLASSIFICATION:", dict(c), "| total", len(protos))
    web = c["bridge"]; print(f"bridges = {web}/{len(protos)} = {100*web//len(protos)}% of protocols")
    print("\nTHE CONE — arity vs dependency-depth:")
    byar = defaultdict(list)
    for p in protos:
        if cls[p] in ("theorem", "bridge"): byar[len(real_closure(p))].append(p)
    for a in sorted(byar):
        ps = byar[a]
        print(f"  arity {a}: {len(ps):2}  avg depth {sum(depth(x) for x in ps)/len(ps):.1f}")
    print("\nPER-PAPER ROUTE SIZES (web bridges curated under each paper):")
    for doc, block in sorted(PAPERS.items()):
        print(f"  {doc:34} {block.count('- ``')} bridges")
    print("orphan web bridges:", orphan or "NONE")
