#!/usr/bin/env bash
# lint-law.sh — structural enforcement of THE LAW (Sources/Theory/Law.swift).
#   §0′ PURE TYPES : no runtime, no values — types only.
#   §1  NO RENAME  : no single-parent, empty-body protocol.
# Scans the Swift type tree only (Sources/Theory/*.swift). The .docc catalog is
# prose — it may quote forbidden forms as examples — so it is never scanned.
# Exit non-zero on any violation.
set -uo pipefail
cd "$(dirname "$0")" || exit 2
SRC="Sources/Theory"
fail=0

# ── §0′ purity: forbid value / runtime declarations (// comments stripped first) ──
purity=$(for f in "$SRC"/*.swift; do
  sed 's|//.*||' "$f" \
    | grep -nE '\b(func|var|let|init|subscript|deinit|operator)\b' \
    | sed "s|^|${f##*/}:|"
done)
if [ -n "$purity" ]; then
  echo "✗ §0′ PURE TYPES — runtime/value constructs forbidden (types only):"
  printf '%s\n' "$purity" | sed 's|^|    |'
  fail=1
fi

# ── §1 no-rename: single parent, empty body, no axis, no where ──
renames=$(grep -nE '^[[:space:]]*(public[[:space:]]+)?protocol[[:space:]]+[A-Za-z_][A-Za-z0-9_]*:[[:space:]]*[A-Za-z_][A-Za-z0-9_]*[[:space:]]*\{[[:space:]]*\}[[:space:]]*$' "$SRC"/*.swift \
  | sed "s|$SRC/||")
if [ -n "$renames" ]; then
  echo "✗ §1 RENAME — single-parent empty protocol must expand/compress/intersect:"
  printf '%s\n' "$renames" | sed 's|^|    |'
  fail=1
fi

[ "$fail" -eq 0 ] && echo "✓ THE LAW holds: pure types, no renames."
exit "$fail"
