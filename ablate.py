#!/usr/bin/env python3
# Ablation over the core lattice: cut one declared premise, rebuild, record
# what the compiler refuses. The declared graph says every arrow matters;
# this measures which arrows the build actually leans on. A premise whose
# cut builds green is STRUCTURALLY DECORATIVE FOR THE COMPILER: the words
# still carry meaning for a reader, but no type in the module needs the
# arrow to exist. That wording is deliberate: the compiler measures
# structure, never logical necessity.
#
# Usage: python3 ablate.py [N]     # ablate the first N premises (default all)
# Writes ATLAS_ABLATION.md next to this file. Restores every file it cuts.
import re, subprocess, sys, time, pathlib, datetime

HERE = pathlib.Path(__file__).parent
CORE = HERE / "Sources" / "VerificationIsIdentification"
LIMIT = int(sys.argv[1]) if len(sys.argv) > 1 else None

def build():
    r = subprocess.run(["swift", "build", "--target", "VerificationIsIdentification"],
                       cwd=HERE, capture_output=True, text=True)
    return r.returncode == 0, r.stderr

premises = []
for f in sorted(CORE.glob("*.swift")):
    text = f.read_text()
    for m in re.finditer(r"^public protocol (\w+): ([\w, ]+?)(\s*(?:where|\{))",
                         text, re.M):
        for parent in [p.strip() for p in m.group(2).split(",") if p.strip()]:
            premises.append((f, m.group(1), parent))
if LIMIT:
    premises = premises[:LIMIT]

ok, err = build()
if not ok:
    sys.exit("the tree does not build before any cut; fix that first")

rows, t0 = [], time.time()
for f, proto, parent in premises:
    kept = f.read_text()
    # cut one parent from the inheritance list, keeping the rest intact
    def drop(m):
        parents = [p.strip() for p in m.group(2).split(",") if p.strip() != parent]
        head = f"public protocol {m.group(1)}"
        return (head + (": " + ", ".join(parents) if parents else "") + m.group(3))
    cut = re.sub(r"^public protocol (" + proto + r"): ([\w, ]+?)(\s*(?:where|\{))",
                 drop, kept, count=1, flags=re.M)
    if cut == kept:
        rows.append((proto, parent, "uncut", []))
        continue
    f.write_text(cut)
    green, err = build()
    f.write_text(kept)
    broken = sorted(set(re.findall(r"error: .*?'(\w+)'", err)))[:12] if not green else []
    rows.append((proto, parent, "decorative" if green else "load-bearing", broken))
    print(f"{proto}: {parent} -> {'green' if green else f'{len(broken)} names break'}")

green_ok, _ = build()
out = ["# Atlas ablation: declared against measured",
       "",
       f"Measured {len(rows)} premises in {time.time()-t0:.0f}s on "
       f"{datetime.date.today()}. Each row cuts one declared arrow and rebuilds",
       "the core module. `load-bearing` means the compiler refused the tree",
       "without the arrow, and the names it named are listed. `decorative`",
       "means the build stayed green: the arrow is structurally decorative",
       "for the compiler, which measures structure, never logical necessity;",
       "the prose case for such an arrow rests on the papers alone.",
       "",
       "| claim | premise | measured | breaks |",
       "|---|---|---|---|"]
for proto, parent, verdict, broken in rows:
    out.append(f"| {proto} | {parent} | {verdict} | {', '.join(broken)} |")
out.append("")
out.append(f"The tree builds green after every restoration: {green_ok}.")
(HERE / "ATLAS_ABLATION.md").write_text("\n".join(out) + "\n")
print(f"wrote ATLAS_ABLATION.md, tree green after restore: {green_ok}")
