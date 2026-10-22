#!/usr/bin/env bash
# A name has one supported lexical owner. v0.4 keeps qualified nested enums
# separate from file-scope names; the nested negative is now a false membership.
# Local rebinding, unread local type forms, ambiguous declarations and qualified
# extensions remain refusals. Generic scopes, operators, conditional blocks and
# attributes retain their compiler-backed positive/negative controls.
# These legacy CLI calls carry no source context: a borrowed extension still
# cannot establish ownership by its spelling. Context admission has its own
# positive and missing/conflicting twins in Contracts/Court/v0.4.
set -euo pipefail
cd "$(dirname "$0")/.."

scope_tmp=$(mktemp -d "${TMPDIR:-/tmp}/vi-where-scope.XXXXXX")
trap 'rm -rf "$scope_tmp"' EXIT

. Checks/build-tools.sh
scope_bin=$(vi_check_tools_bin)

# scope_world <world> <compiler errors> <court refusal>: the compiler
# refuses the world for the named errors, allowing the optional inference
# cascade in three named worlds; the court exits 2 with exactly this line
# on stderr and nothing on stdout.
scope_world() {
    local world="$1" errors="$2" verdict="$3" expected="${4:-2}"
    local compiled=0
    swiftc -typecheck -module-cache-path "$scope_tmp/cache" \
        "Checks/where-scope/$world.swift" >"$scope_tmp/$world-swift.log" 2>&1 || compiled=$?
    if [ "$compiled" -eq 0 ]; then
        echo "where-scope: Swift accepted $world.swift" >&2
        exit 1
    elif [ "$compiled" -ne 1 ]; then
        cat "$scope_tmp/$world-swift.log"
        echo "where-scope: Swift exited $compiled for $world.swift, not an ordinary typecheck refusal" >&2
        exit 1
    fi
    local said=0
    "$scope_bin/Tools" judge where "Checks/where-scope/$world.swift" \
        >"$scope_tmp/$world.out" 2>"$scope_tmp/$world.err" || said=$?
    local answer="$scope_tmp/$world.err" other="$scope_tmp/$world.out"
    if [ "$expected" -eq 1 ]; then answer="$scope_tmp/$world.out"; other="$scope_tmp/$world.err"; fi
    if [ "$said" -ne "$expected" ] || [ -s "$other" ]; then
        cat "$scope_tmp/$world.out" "$scope_tmp/$world.err"
        echo "where-scope: the where court did not refuse to read $world.swift" >&2
        exit 1
    fi
    python3 - "$world" "$scope_tmp/$world-swift.log" "$answer" "$errors" "$verdict" <<'PY'
from pathlib import Path
import re, sys
world, swift_log, court_log, errors, verdict = sys.argv[1:]
pattern = re.compile(r"^Checks/where-scope/" + re.escape(world) + r"\.swift:\d+:\d+: (error: .*)$")
said = [m.group(1) for m in map(pattern.match, Path(swift_log).read_text().splitlines()) if m]
expected = errors.split("\n")
# The invalid Use argument is the required error. Some compiler versions
# also report that the enclosing call cannot infer T; this is not another
# premise of these scope fixtures. Keep every other expected error exact.
if world in {"generic", "outside", "conditional"}:
    cascade = "error: generic parameter 'T' could not be inferred"
    expected.remove(cascade)
    if cascade in said:
        said.remove(cascade)
if sorted(said) != sorted(expected):
    print(Path(swift_log).read_text())
    raise SystemExit(f"where-scope: Swift did not refuse {world}.swift for the expected reasons")
if Path(court_log).read_text().splitlines() != [verdict]:
    print(Path(court_log).read_text())
    raise SystemExit(f"where-scope: the court did not name the declarations it cannot scope in {world}.swift")
PY
}

no_scope_rule="and this court has no scope rule to choose between them"
scope_world shadowed "error: global function 'need' requires that 'Bad' conform to 'Required'" \
    "✗ THE WHERE: cannot read 'Bad': it is declared at lines 9 and 16, $no_scope_rule"
# Nested enum names are read by v0.4. The file-scope Plain is still not Required;
# reading Namespace.Plain must never make this false application hold.
scope_world nested "error: global function 'need' requires that 'Plain' conform to 'Required'" \
    "✗ 'Use<Plain>' requires the type 'T' (aka 'Plain') conform to 'Required', and no conformer of that name is presented [Admitted]" 1
scope_world rebound "error: global function 'need' requires that 'Good' (aka 'Bad') conform to 'Required'" \
    "✗ THE WHERE: cannot read 'Good': it is declared at lines 10 and 17, $no_scope_rule"
scope_world generic "error: type 'Good' does not conform to protocol 'Setting'
error: generic parameter 'T' could not be inferred" \
    "✗ THE WHERE: cannot read 'Good': it is declared at lines 9 and 15, $no_scope_rule"
scope_world deep "error: global function 'need' requires that 'Good' conform to 'Required'" \
    "✗ THE WHERE: cannot read 'Good': it is declared at lines 11 and 20, $no_scope_rule"
scope_world arrow "error: global function 'need' requires that 'Good' conform to 'Required'" \
    "✗ THE WHERE: cannot read 'Good': it is declared at lines 10 and 18, $no_scope_rule"
scope_world operator "error: global function 'need' requires that 'Good' conform to 'Required'" \
    "✗ THE WHERE: cannot read 'Good': it is declared at lines 12 and 19, $no_scope_rule"
scope_world outside "error: type 'Element' does not conform to protocol 'Setting'
error: generic parameter 'T' could not be inferred" \
    "✗ THE WHERE: cannot read line 20: the use 'Use<Element>' sits in the body of a type or an extension, whose members this court does not read"
scope_world conditional "error: type 'Good' does not conform to protocol 'Setting'
error: generic parameter 'T' could not be inferred" \
    "✗ THE WHERE: cannot read line 18: '#if true' is not a plain compilation flag, and this court omits only a block a compilation without its flag skips"

# scope_pair <world> <compiler error> <court refusal>: a world beside its
# definitions file, <world>-definitions.swift. The compiler, given both
# files, refuses the world for exactly this error, and the court, given the
# same files, exits 2 with exactly this line on stderr and nothing on stdout.
scope_pair() {
    local world="$1" error="$2" verdict="$3"
    if swiftc -typecheck -module-cache-path "$scope_tmp/cache" "Checks/where-scope/$world.swift" \
        "Checks/where-scope/$world-definitions.swift" >"$scope_tmp/$world-swift.log" 2>&1; then
        echo "where-scope: Swift accepted $world.swift beside its definitions" >&2
        exit 1
    fi
    if [ "$(grep -E "^Checks/where-scope/$world(-definitions)?\.swift:[0-9]+:[0-9]+: error: " "$scope_tmp/$world-swift.log" \
        | sed -E 's/^[^ ]+ //')" != "$error" ]; then
        cat "$scope_tmp/$world-swift.log"
        echo "where-scope: Swift did not refuse $world.swift for the expected reason" >&2
        exit 1
    fi
    local said=0
    "$scope_bin/Tools" judge where "Checks/where-scope/$world.swift" "Checks/where-scope/$world-definitions.swift" \
        >"$scope_tmp/$world.out" 2>"$scope_tmp/$world.err" || said=$?
    if [ "$said" -ne 2 ] || [ -s "$scope_tmp/$world.out" ] || [ "$(cat "$scope_tmp/$world.err")" != "$verdict" ]; then
        cat "$scope_tmp/$world.out" "$scope_tmp/$world.err"
        echo "where-scope: the court did not refuse to read $world.swift beside its definitions" >&2
        exit 1
    fi
}

# A definitions file that extends a type of the world is one this court
# cannot place: the extension may not be the world's type, and its member
# may not reach the world.
cannot_place="and this court cannot tell that the extension is this world's type, or that its members reach this file"
scope_pair lent "error: global function 'need' requires that 'Owner.Left' (aka 'Bad') conform to 'Required'" \
    "✗ THE WHERE: cannot read 'Owner': 'Checks/where-scope/lent-definitions.swift' extends it at line 4, $cannot_place"
scope_pair private-target "error: global function 'need' requires that 'Left' conform to 'Required'" \
    "✗ THE WHERE: cannot read 'Left': 'Checks/where-scope/private-target-definitions.swift' extends it at line 5, $cannot_place"

# An extension's owner is read in full: a qualified owner is not resolved,
# and an alias is not followed to its type, so each is refused.
scope_pair qualified "error: global function 'need' requires that 'Owner.Left' (aka 'Bad') conform to 'Required'" \
    "✗ THE WHERE: cannot read line 4: the extension of 'main.Owner' names its type through a qualifier, which this court does not resolve"
scope_pair aliased "error: global function 'need' requires that 'Owner.Left' (aka 'Bad') conform to 'Required'" \
    "✗ THE WHERE: cannot read 'Other': it is a typealias, extended at line 5, and this court does not follow an extension through an alias to its type"

# A where clause that spells `repeat` opens no loop: the class body beneath
# it is a type's body, where a member inherited from the definitions file
# rebinds the name of the use.
scope_pair pack "error: global function 'need' requires that 'Owner<repeat each T>.Element' (aka 'Bad') conform to 'Required'" \
    "✗ THE WHERE: cannot read line 21: the use 'Use<Element>' sits in the body of a type or an extension, whose members this court does not read"
# A comparison opens no bracket: the class after it is a type, and its body
# is a type's body.
scope_pair comparison "error: global function 'need' requires that 'Owner.Element' (aka 'Bad') conform to 'Required'" \
    "✗ THE WHERE: cannot read line 23: the use 'Use<Element>' sits in the body of a type or an extension, whose members this court does not read"

# The control: what a body may declare reads, the compiler accepts, the court admits.
if ! swiftc -typecheck -module-cache-path "$scope_tmp/cache" \
    Checks/where-scope/admitted.swift >"$scope_tmp/admitted-swift.log" 2>&1; then
    cat "$scope_tmp/admitted-swift.log"
    echo "where-scope: Swift refused the control" >&2
    exit 1
fi
if ! "$scope_bin/Tools" judge where Checks/where-scope/admitted.swift >"$scope_tmp/admitted.log" 2>&1; then
    cat "$scope_tmp/admitted.log"
    echo "where-scope: the where court refused the control" >&2
    exit 1
fi
if ! grep -q "^✓ THE WHERE holds: 0 equalities and 4 memberships judged across 3 uses" "$scope_tmp/admitted.log"; then
    cat "$scope_tmp/admitted.log"
    echo "where-scope: the control was not judged beside its nested declarations" >&2
    exit 1
fi
python3 Checks/where-tokens.py "$scope_bin/Tools"
echo "✓ where-scope: eleven rebound, nested or unread names and four foreign extensions are named, the compiler refuses each world, a body's own declarations read"
