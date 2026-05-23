"""
V=I pipeline — §4 inner half + §3.6 R4 check.

Pipeline (§5.5): ENCODE → VALIDATE(basis) → EXTRACT → COMPILE → EXECUTE.
R4 check (§3.6): enumerate F, count |S| extensionally (§3.3).
I3: append-only comparison graph threads through all stages (§2.3).
"""

import json
from pathlib import Path

from grammar import feature_rules, name_rule
from representation import (
    encode_grid, basis_valid, compile_check, grid_shape, decode_grid,
    execute, write_equations, FEATURE_NAMES,
)
from engine import extract_rule, resolve_ambiguous


# ── §4.1–4.2  Encode + basis gate ────────────────────────────────────

def build_examples(task):
    """Encode grids to atoms (§4.1) + validate basis (§4.2)."""
    examples = []
    for pair in task["train"]:
        inp, out = encode_grid(pair["input"]), encode_grid(pair["output"])
        if not basis_valid(inp, out):
            return None, "REJECT(basis)"
        examples.append((inp, out))
    return examples, None


# ── §4.3–4.6  Extraction ─────────────────────────────────────────────

def extract_discovered_rule(examples, task, graph=None):
    """Equations → extract consistent features → resolve ambiguous (§4.3–4.6)."""
    unambiguous, ambiguous, background = write_equations(
        examples, task["train"], graph)
    prelim = extract_rule(unambiguous, background, FEATURE_NAMES)
    resolved = resolve_ambiguous(ambiguous, prelim)
    return extract_rule(unambiguous + resolved, background, FEATURE_NAMES)


# ── §3.6  R4: |S| in F ───────────────────────────────────────────────

def _observed_ranks(task):
    """Set of rank values actually occurring in training grids."""
    from representation import encode_grid, value_rank
    ranks = set()
    for pair in task["train"]:
        cells = encode_grid(pair["input"])
        for c in cells:
            ranks.add(value_rank(c, cells))
    return ranks


def _count_S(F, examples, task, graph=None):
    """§3.6: |S| counted extensionally — distinct decoded test outputs.

    Two rules producing identical test output are one element of S (§3.3).
    """
    test = task["test"][0]
    ir, ic = grid_shape(test["input"])
    or_, oc = grid_shape(test["output"])
    cells = encode_grid(test["input"])

    seen = set()
    for rule in F:
        if not compile_check(rule, examples, task["train"], graph)[0]:
            continue
        out = tuple(execute(rule, cells, or_, oc, ir, ic, graph))
        if out not in seen:
            seen.add(out)
    return len(seen)


# ── §5 Saturation ────────────────────────────────────────────────────

def saturation(s_size, f_size):
    """§5 remark: 1 − |S|/|F|. Maximum when |S|=1."""
    if f_size is None or f_size <= 0:
        return None
    return 1.0 - s_size / f_size


# ── §5.5  Full pipeline ──────────────────────────────────────────────

def identify_task(name, task, graph=None):
    """§5.5: ENCODE → VALIDATE → EXTRACT → COMPILE → EXECUTE + R4 check."""

    # §4.1–4.2 — encode + basis gate
    examples, reject = build_examples(task)
    if reject:
        return {"task": name, "status": reject, "theorem2": False}

    # §4.3–4.6 — extract rule from training data
    rule = extract_discovered_rule(examples, task, graph)

    # §4.7 — compile gate
    passed, fail_k = compile_check(rule, examples, task["train"], graph)
    if not passed:
        return {"task": name,
                "status": f"REJECT(compile, example {fail_k})",
                "theorem2": False}

    # §3.6 — R4: |S| in F
    F = feature_rules(_observed_ranks(task))
    s_size = _count_S(F, examples, task, graph)
    f_size = len(F)
    sat = saturation(s_size, f_size)

    if s_size > 1:
        return {"task": name, "status": f"|S|={s_size}>1",
                "F": f_size, "S": s_size, "saturation": sat,
                "f_extracted": name_rule(rule), "theorem2": False}

    # §4.8 — execute on test
    test = task["test"][0]
    ir, ic = grid_shape(test["input"])
    or_, oc = grid_shape(test["output"])
    pred = decode_grid(
        execute(rule, encode_grid(test["input"]), or_, oc, ir, ic, graph),
        or_, oc)
    ok = pred == test["output"]

    return {
        "task": name,
        "status": "PASS" if ok else "MISMATCH",
        "F": f_size, "S": 1, "saturation": sat,
        "f_star": name_rule(rule),
        "test_ok": ok,
        "theorem2": ok and s_size == 1,
    }


# ── Manifest ──────────────────────────────────────────────────────────

def corpus_metrics(records):
    n = len(records)
    t2 = sum(1 for r in records if r.get("theorem2"))
    return {"n": n, "theorem2": t2, "coverage": t2 / n if n else 0.0}


def write_manifest(records, path=None, graph=None):
    path = Path(path or Path(__file__).parent / "pass_manifest.json")
    payload = {
        "schema": "vi-pass/v3",
        "theorem2": "PASS + |S|=1 in F → f' = f* (Theorem 2, §5)",
        "note_F": "F = all feature-conjunction rules (§3.3). "
                  "|S| counted extensionally (distinct test outputs).",
        "records": records,
        "corpus": corpus_metrics(records),
    }
    if graph is not None:
        payload["I3_pairs"] = len(graph)
    path.write_text(json.dumps(payload, indent=2) + "\n")
    return path
