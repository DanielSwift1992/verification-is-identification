#!/usr/bin/env python3
# provenance.py — every claim carries a resolvable address.
#
# tree-sort.py guards STRUCTURE (Topics == the type lattice). This guards the
# PROVENANCE LAYER tree-sort ignores: the [Tag §x] addresses in /// comments.
#   1. every provenance tag resolves to a paper in the Sources.md legend
#   2. every paper in the legend is CONNECTED: routed (carries a web route) OR
#      cited (a tag points to it) OR below the floor (the ground, EiF).
#
# A provenance tag is the TRAILING bracket of a /// line: `... [Tag ...]` at EOL
# (comment-style §3: the tag is last). Math notation like `E[τ_sat] = ...` is
# mid-line and is never matched.
#
# Modes:  (default) audit · --check (exit 1 on dangling tag or disconnected paper)

import re, sys, os, glob

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(HERE, "Sources/Theory")
DOCC = os.path.join(SRC, "Theory.docc")
SOURCES_MD = os.path.join(DOCC, "Sources.md")
MODE = sys.argv[1].lstrip("-") if len(sys.argv) > 1 else "audit"

BELOW_FLOOR = {"EiF"}   # the ground: argued below the protocol floor, no route of its own

# --- legend: tag -> paper doc (col 1 may carry several `tags` split by ·) ---
tag2paper, paper_tags = {}, {}
for line in open(SOURCES_MD):
    m = re.match(r"\|\s*(`[^|]+`)\s*\|\s*\[([^\]]+)\]\(doc:([^)]+)\)", line)
    if not m:
        continue
    tags = re.findall(r"`([^`]+)`", m.group(1))
    paper = m.group(3)
    for t in tags:
        tag2paper[t] = paper
    paper_tags[paper] = tags
LEGEND = set(tag2paper)

# --- provenance tags in code: the trailing bracket of a /// line ---
TAG_RE = re.compile(r"(?:^|\s)\[([^\]]+)\]\s*$")
cited, dangling = {}, []
for f in sorted(glob.glob(os.path.join(SRC, "*.swift"))):
    for i, line in enumerate(open(f), 1):
        s = line.strip()
        if not s.startswith("///"):
            continue
        m = TAG_RE.search(s[3:].rstrip())
        if not m:
            continue
        first = re.split(r"[\s,;]", m.group(1).strip())[0]
        if first in LEGEND:
            cited[tag2paper[first]] = cited.get(tag2paper[first], 0) + 1
        else:
            dangling.append((os.path.basename(f), i, m.group(1)))

# --- routed papers: a Papers/X.md that carries a web route ---
routed = {os.path.basename(p)[:-3] for p in glob.glob(os.path.join(DOCC, "Papers", "*.md"))
          if "### Theorems this paper proves" in open(p).read()}

papers = set(tag2paper.values())
def connected(pp):
    return pp in routed or cited.get(pp) or bool(set(paper_tags[pp]) & BELOW_FLOOR)
disconnected = [pp for pp in sorted(papers) if not connected(pp)]

# ============================ report ============================
if MODE == "check":
    ok = True
    if dangling:
        ok = False
        print("✗ DANGLING provenance tags (no paper prefix / unknown tag):")
        for fn, ln, c in dangling:
            print(f"    {fn}:{ln}  [{c}]")
    if disconnected:
        ok = False
        print("✗ DISCONNECTED papers (in legend, no route and not cited):", disconnected)
    if ok:
        print(f"✓ provenance sound: {len(LEGEND)} tags / {len(papers)} papers — every address resolves, every paper connected.")
        sys.exit(0)
    sys.exit(1)

else:  # audit
    print(f"LEGEND: {len(LEGEND)} tags -> {len(papers)} papers\n")
    print("PER-PAPER  (routed = carries a web route · cited = #provenance addresses):")
    for pp in sorted(papers):
        flags = []
        if pp in routed: flags.append("routed")
        if cited.get(pp): flags.append(f"cited×{cited[pp]}")
        if set(paper_tags[pp]) & BELOW_FLOOR: flags.append("below-floor")
        print(f"  {pp:34} [{'/'.join(paper_tags[pp]):12}] {' '.join(flags) or '— DISCONNECTED'}")
    print("\ndangling provenance tags:", dangling or "none")
