#!/usr/bin/env python3
"""The map is data; coverage is total, and the portable census follows types."""
import hashlib
import json
import os
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parent.parent
TOOLS = ROOT / ".build/debug/Tools"


def map_text(entries):
    return ('public enum GrammarScopes {\n'
            'public static let format = "vi-scope-map/1"\n'
            'public static let entries: [(String, String)] = [\n'
            + ''.join('(' + json.dumps(p) + ', ' + json.dumps(s) + '),\n' for p, s in entries)
            + ']\n}\n')


subprocess.run(["swift", "build", "--product", "Tools"], cwd=ROOT, check=True,
               stdout=subprocess.DEVNULL)
with tempfile.TemporaryDirectory(prefix="vi-scopes-") as tmp:
    root = Path(tmp)
    env = dict(os.environ, VI_THEORY_PATH=str(ROOT))
    exported = root / "policy.json"
    subprocess.run([str(TOOLS), "grammar", "--export-policy", str(exported)], check=True)
    assert exported.read_bytes() == (ROOT / "Checks/Grammar/policy.json").read_bytes(), "stale policy census"
    world = root / "Prepared/Dictionary"
    world.mkdir(parents=True)
    source = world / "Page.swift"
    scope_map = root / "scopes.swift"
    receipt = root / "receipt.json"
    base = [("Prepared", "DemoScope"), ("Prepared/Dictionary", "SurfaceScope")]

    def ask(entries, body="public typealias Width = U512\n", portable=True, suffix=""):
        scope_map.write_text(map_text(entries) + suffix)
        source.write_text(body)
        args = [str(TOOLS), "grammar", "--scope-map", "scopes.swift", "--receipt", "receipt.json"]
        if portable:
            args += ["--portable"]
        p = subprocess.run(args + ["Prepared"], cwd=root, env=env,
                           capture_output=True, text=True, timeout=240)
        # A typed refusal leaves its mirror for a reader; the law has read it.
        import shutil
        for line in p.stdout.splitlines():
            if line.startswith("scratch kept at "):
                shutil.rmtree(line.removeprefix("scratch kept at "), ignore_errors=True)
        return p

    for entries in (base, list(reversed(base)), base + [base[0]]):
        assert ask(entries).returncode == 0, "longest prefix or identical duplicate"
        r = json.loads(receipt.read_text())
        assert r["files"] == {"Prepared/Dictionary/Page.swift": "SurfaceScope"}
        assert r["scope_map_sha256"] == hashlib.sha256(scope_map.read_bytes()).hexdigest()
    for entries, reason in [
        ([("Prepared/Dict", "ToolsScope")], "uncovered source path"),
        (base + [("Prepared", "ToolsScope")], "conflicting equal prefixes"),
        ([("Prepared", "InventedScope")], "unknown scope"),
        ([("../Prepared", "DemoScope")], "non-relative source path"),
        ([], "empty"),
    ]:
        p = ask(entries)
        assert p.returncode == 1 and reason in p.stdout, (reason, p.stdout[-1000:])
    assert ask(base, suffix="public let ignored = 1").returncode == 1, "unread map syntax"
    scope_map.write_text(map_text(base).replace('"Prepared"', '"Prepared\\(run())"'))
    p = subprocess.run([str(TOOLS), "grammar", "--portable", "--scope-map", "scopes.swift", "Prepared"],
                       cwd=root, env=env, capture_output=True)
    assert p.returncode == 1, "Swift interpolation is not metadata"

    vectors = [
        ("SurfaceScope", "public typealias Width = U512\n", 0),
        ("DemoScope", "public typealias Width = U512\n", 1),
        ("SurfaceScope", 'public typealias Word = Other.spelled\n', 1),
        ("DemoScope", 'public typealias Word = Other.spelled\n', 0),
        ("DemoScope", 'public enum Page { public typealias Width = U1 }\n', 1),
        ("ToolsScope", 'actor Uninvited {}\n', 1),
        ("SystemScope", 'public enum Witness {\npublic static var count: Int { 1 }\n}\n', 0),
        ("SystemScope", 'public enum Witness {\npublic static var mutable: Int { 1 }\n}\n', 1),
        ("ToolsScope", '// actor Uninvited {}\npublic enum Page {\npublic static let text = "actor U512"\n}\n', 0),
    ]
    # Astra's R1/R2: closed-block state and raw escapes must not leak.
    vectors += [
        ('ToolsScope', '/* \\/*/ actor Uninvited {} */\n', 1),
        ('ToolsScope', 'public enum A {\npublic typealias Marker = GrammarExempt\n}\npublic enum B {\nactor Uninvited {}\n}\n', 1),
        ('ToolsScope', 'func f() { let x = 1 }\nCall { A; B }\n', 0),
        ('ToolsScope', 'public enum A {\npublic typealias Marker = Ordinary\n}\npublic enum B {\nactor Uninvited {}\n}\n', 1),
        ("ToolsScope", 'public enum Page {\npublic static let text = "a \\(call("actor /*", [1, 2]))"\n}\n', 0),
    ]
    for scope, body, wanted in vectors:
        entries = [("Prepared", scope)]
        for portable in (True, False):
            p = ask(entries, body, portable)
            assert p.returncode == wanted, (scope, body, portable, p.stdout[-1800:])
    print("scope-map: coverage, boundaries, order, conflicts, closed format, digest and 14 compiler/port controls hold")
