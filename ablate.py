#!/usr/bin/env python3
# Which premises the build needs. Cut one declared premise, rebuild the
# core module, record the result, restore the file. The Atlas draws every
# dependency; this table says which ones the build fails without. An arrow the build passes without still
# carries meaning for a reader: the compiler only says that no type needs
# it. The papers, not this table, argue those arrows.
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
    sys.exit("the module does not build before any cut; fix that first")

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
    rows.append((proto, parent, "builds green" if green else "build fails", broken))
    print(f"{proto}: {parent} -> {'builds green' if green else f'build fails ({len(broken)} names)'}")

green_ok, _ = build()
out = ["# Which premises the build needs",
       "",
       f"Cut {len(rows)} premises one at a time in {time.time()-t0:.0f}s on "
       f"{datetime.date.today()}. Each row cuts one declared premise, rebuilds",
       "the core module, and restores the file. `build fails` lists the names",
       "the compiler refused without the premise. `builds green` says the module",
       "compiles without it: the premise still carries meaning for a reader, and",
       "the papers, not this table, argue it.",
       "",
       "| claim | premise | cut result | names refused |",
       "|---|---|---|---|"]
for proto, parent, verdict, broken in rows:
    out.append(f"| {proto} | {parent} | {verdict} | {', '.join(broken)} |")
out.append("")
out.append(f"The module builds green after the last restoration: {green_ok}.")
(HERE / "ATLAS_ABLATION.md").write_text("\n".join(out) + "\n")
print(f"wrote ATLAS_ABLATION.md, tree green after restore: {green_ok}")
