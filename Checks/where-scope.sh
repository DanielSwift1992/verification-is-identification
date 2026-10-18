#!/usr/bin/env bash
# The where court resolves every name in one scope, the file's. A name it
# resolves there is declared once, and a declaration it reads sits outside
# every body. A second declaration of a court-read name in a function body,
# of a form the court reads or not (an enum, a typealias, a generic
# parameter), rebinds it where a use sits, and an enum nested in a namespace
# can stand for a file-scope name the court does not read. A name bound
# outside the file rebinds a file-scope name inside a type or an extension
# body, so a use there is refused; and a block under `#if true` is compiled,
# so only a block under a plain flag is omitted. Each such world holds a
# real bad demand beside a good neighbour, the compiler refuses it, and the
# court gives no verdict and names the name, the use or the condition and
# its line instead of holding the file. A member a definitions file writes
# for a conformer of the world is the conformer's, and the court refuses the
# certificate it rebinds, as the compiler does. The control keeps what a body
# may declare, and a block under a plain flag, readable: the compiler
# accepts it and the court admits it.
set -euo pipefail
cd "$(dirname "$0")/.."

scope_tmp=$(mktemp -d "${TMPDIR:-/tmp}/vi-where-scope.XXXXXX")
trap 'rm -rf "$scope_tmp"' EXIT

if ! swift build --product Tools >"$scope_tmp/build.log" 2>&1; then
    cat "$scope_tmp/build.log"
    exit 1
fi
scope_bin=$(swift build --show-bin-path)

# scope_world <world> <compiler errors> <court refusal>: the compiler
# refuses the world for exactly these errors, and the court exits 2 with
# exactly this line on stderr and nothing on stdout.
scope_world() {
    local world="$1" errors="$2" verdict="$3"
    if swiftc -typecheck -module-cache-path "$scope_tmp/cache" \
        "Checks/where-scope/$world.swift" >"$scope_tmp/$world-swift.log" 2>&1; then
        echo "where-scope: Swift accepted $world.swift" >&2
        exit 1
    fi
    local said=0
    "$scope_bin/Tools" judge where "Checks/where-scope/$world.swift" \
        >"$scope_tmp/$world.out" 2>"$scope_tmp/$world.err" || said=$?
    if [ "$said" -ne 2 ] || [ -s "$scope_tmp/$world.out" ]; then
        cat "$scope_tmp/$world.out" "$scope_tmp/$world.err"
        echo "where-scope: the where court did not refuse to read $world.swift" >&2
        exit 1
    fi
    python3 - "$world" "$scope_tmp/$world-swift.log" "$scope_tmp/$world.err" "$errors" "$verdict" <<'PY'
from pathlib import Path
import re, sys
world, swift_log, court_log, errors, verdict = sys.argv[1:]
pattern = re.compile(r"^Checks/where-scope/" + re.escape(world) + r"\.swift:\d+:\d+: (error: .*)$")
said = [m.group(1) for m in map(pattern.match, Path(swift_log).read_text().splitlines()) if m]
if sorted(said) != sorted(errors.split("\n")):
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
scope_world nested "error: global function 'need' requires that 'Plain' conform to 'Required'" \
    "✗ THE WHERE: cannot read line 20: the enum 'Plain' is declared inside a body, and this court reads declarations at file scope"
scope_world rebound "error: global function 'need' requires that 'Good' (aka 'Bad') conform to 'Required'" \
    "✗ THE WHERE: cannot read 'Good': it is declared at lines 10 and 17, $no_scope_rule"
scope_world generic "error: type 'Good' does not conform to protocol 'Setting'
error: generic parameter 'T' could not be inferred" \
    "✗ THE WHERE: cannot read 'Good': it is declared at lines 9 and 15, $no_scope_rule"
scope_world outside "error: type 'Element' does not conform to protocol 'Setting'
error: generic parameter 'T' could not be inferred" \
    "✗ THE WHERE: cannot read line 20: the use 'Use<Element>' sits in the body of a type or an extension, whose members this court does not read"
scope_world conditional "error: type 'Good' does not conform to protocol 'Setting'
error: generic parameter 'T' could not be inferred" \
    "✗ THE WHERE: cannot read line 18: '#if true' is not a plain compilation flag, and this court omits only a block a compilation without its flag skips"

# The lent world: the compiler reads both files and refuses the demand; the
# court reads the definitions file's extension as Owner's, binds `Left` to
# the bad setting inside Owner and refuses the certificate.
if swiftc -typecheck -module-cache-path "$scope_tmp/cache" Checks/where-scope/lent-definitions.swift \
    Checks/where-scope/lent.swift >"$scope_tmp/lent-swift.log" 2>&1; then
    echo "where-scope: Swift accepted lent.swift" >&2
    exit 1
fi
if [ "$(grep -E '^Checks/where-scope/lent(-definitions)?\.swift:[0-9]+:[0-9]+: error: ' "$scope_tmp/lent-swift.log" | sed -E 's/^[^ ]+ //')" \
    != "error: global function 'need' requires that 'Owner.Left' (aka 'Bad') conform to 'Required'" ]; then
    cat "$scope_tmp/lent-swift.log"
    echo "where-scope: Swift did not refuse lent.swift for the rebound Left" >&2
    exit 1
fi
scope_said=0
"$scope_bin/Tools" judge where Checks/where-scope/lent.swift Checks/where-scope/lent-definitions.swift \
    >"$scope_tmp/lent.out" 2>"$scope_tmp/lent.err" || scope_said=$?
if [ "$scope_said" -ne 1 ] || [ -s "$scope_tmp/lent.err" ] \
    || [ "$(cat "$scope_tmp/lent.out")" != "✗ 'Owner.Claim = Use<Owner.Left>' requires the type 'T' (aka 'Bad') conform to 'Required', and 'Bad: Setting' does not carry it [Admitted]" ]; then
    cat "$scope_tmp/lent.out" "$scope_tmp/lent.err"
    echo "where-scope: the court did not read the lent member inside its conformer" >&2
    exit 1
fi

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
if ! grep -q "^✓ THE WHERE holds: 0 equalities and 2 memberships judged across 1 uses" "$scope_tmp/admitted.log"; then
    cat "$scope_tmp/admitted.log"
    echo "where-scope: the control was not judged beside its nested declarations" >&2
    exit 1
fi
echo "✓ where-scope: six rebound, nested or unread names are named at their lines, a lent member binds inside its conformer, the compiler refuses each world, a body's own declarations read"
