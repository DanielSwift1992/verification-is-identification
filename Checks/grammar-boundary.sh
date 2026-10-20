#!/usr/bin/env bash
# A scope in the grammar's registry names a directory (or one file), and the
# name ends at a path component. The same source file is carried under
# `Sources/Court/`, a registered scope, and holds; moved to `Sources/CourtRoom/`,
# a neighbour whose name merely begins with the registered prefix, it is absent
# from the registry, so the mirror spells a scope no block type answers to and
# does not build. Before the boundary, the neighbour was read as the court's
# own and held: a scope granted by the spelling of a name, not by the directory.
set -euo pipefail
cd "$(dirname "$0")/.."

boundary_tmp=$(mktemp -d "${TMPDIR:-/tmp}/vi-grammar-boundary.XXXXXX")
trap 'rm -rf "$boundary_tmp"' EXIT

if ! swift build --product Tools >"$boundary_tmp/build.log" 2>&1; then
    cat "$boundary_tmp/build.log"
    exit 1
fi
boundary_bin=$(swift build --show-bin-path)
boundary_theory=$PWD

# boundary_world <directory> <expected exit> <expected line>: one file under the
# directory, the grammar run from the world's root against this theory, and the
# verdict's exit and line.
boundary_world() {
    local directory="$1" expected_exit="$2" expected_line="$3"
    local world="$boundary_tmp/world-$(echo "$directory" | tr '/' '_')"
    mkdir -p "$world/$directory"
    cp "Checks/grammar-boundary/Neighbour.swift" "$world/$directory/Neighbour.swift"
    local said=0
    (cd "$world" && VI_THEORY_PATH="$boundary_theory" "$boundary_bin/Tools" grammar) \
        >"$boundary_tmp/$(basename "$world").out" 2>&1 || said=$?
    if [ "$said" -ne "$expected_exit" ]; then
        echo "grammar-boundary: $directory exited $said, expected $expected_exit" >&2
        cat "$boundary_tmp/$(basename "$world").out" >&2
        exit 1
    fi
    if ! grep -qF -- "$expected_line" "$boundary_tmp/$(basename "$world").out"; then
        echo "grammar-boundary: $directory did not say: $expected_line" >&2
        cat "$boundary_tmp/$(basename "$world").out" >&2
        exit 1
    fi
    # a refusal keeps the mirror's scratch for a reader; this law has read it
    local kept
    kept=$(sed -n 's/^scratch kept at //p' "$boundary_tmp/$(basename "$world").out")
    [ -n "$kept" ] && rm -rf "$kept"
    return 0
}

boundary_world "Sources/Court" 0 \
    "✓ THE GRAMMAR holds: 1 file(s) carried, and every verdict object builds."
boundary_world "Sources/CourtRoom" 1 \
    "THE GRAMMAR: the mirror does not build"
if ! grep -q "Sources_CourtRoom_Neighbour_swift" "$boundary_tmp/world-Sources_CourtRoom.out"; then
    echo "grammar-boundary: the refusal does not name the neighbour's carried object" >&2
    cat "$boundary_tmp/world-Sources_CourtRoom.out" >&2
    exit 1
fi
echo "grammar-boundary: a registered scope ends at a path component; the neighbour by prefix is absent, not the court's"
