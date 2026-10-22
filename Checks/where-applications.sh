#!/usr/bin/env bash
# The where court judges a gated head where it is applied, so every
# application of one is read, or refused by name at its line. A typealias
# whose right side names a gated head applies it in turn. In the world an
# application is read as a use on one line, as the right side of a typealias
# at file scope or in a presented conformer's table, or in a gate's where
# clause; a use across lines, a parenthesized metatype, a local or member
# alias, and a parameter's type, of the gated head or of an alias that
# applies it, each bind a demand the court does not judge. A definitions
# file is read for its typealiases alone, so its parameterless alias of a
# gated application, its gate of a head the world names, and its gated
# protocol that the world's conformer reaches each bind the world unjudged.
# Each world holds a bad demand beside a good claim, the compiler refuses
# it, and the court gives no verdict and names the place instead of
# holding the file. The control applies the gated head only where the court
# reads it: the compiler accepts it and the court admits it.
set -euo pipefail
cd "$(dirname "$0")/.."

applications_tmp=$(mktemp -d "${TMPDIR:-/tmp}/vi-where-applications.XXXXXX")
trap 'rm -rf "$applications_tmp"' EXIT

. Checks/build-tools.sh
applications_bin=$(vi_check_tools_bin)

# applications_world <world> <compiler errors> <court refusal>: the world,
# with its definitions file when there is one, is refused by the compiler
# for exactly these errors, and the court exits 2 with exactly this line on
# stderr and nothing on stdout.
applications_world() {
    local world="$1" errors="$2" verdict="$3"
    local files=("Checks/where-applications/$world.swift")
    [ -f "Checks/where-applications/$world-definitions.swift" ] \
        && files+=("Checks/where-applications/$world-definitions.swift")
    if swiftc -typecheck -module-cache-path "$applications_tmp/cache" "${files[@]}" \
        >"$applications_tmp/$world-swift.log" 2>&1; then
        echo "where-applications: Swift accepted $world.swift" >&2
        exit 1
    fi
    if [ "$(grep -E "^Checks/where-applications/$world(-definitions)?\.swift:[0-9]+:[0-9]+: error: " \
        "$applications_tmp/$world-swift.log" | sed -E 's/^[^ ]+ //' | sort)" != "$(printf '%s\n' "$errors" | sort)" ]; then
        cat "$applications_tmp/$world-swift.log"
        echo "where-applications: Swift did not refuse $world.swift for the expected reasons" >&2
        exit 1
    fi
    local said=0
    "$applications_bin/Tools" judge where "${files[@]}" \
        >"$applications_tmp/$world.out" 2>"$applications_tmp/$world.err" || said=$?
    if [ "$said" -ne 2 ] || [ -s "$applications_tmp/$world.out" ] \
        || [ "$(cat "$applications_tmp/$world.err")" != "$verdict" ]; then
        cat "$applications_tmp/$world.out" "$applications_tmp/$world.err"
        echo "where-applications: the court did not name the unread application in $world.swift" >&2
        exit 1
    fi
}

demand="error: global function 'need' requires that 'Bad' conform to 'Required'"
unread="where this court reads no use and no certificate"
at() { echo "✗ THE WHERE: cannot read line $2 of 'Checks/where-applications/$1.swift': '$3' applies a gated head in"; }
applications_world across "$demand" \
    "$(at across 17 Use) a use written across lines, which this court reads on one line"
applications_world parenthesized "$demand" "$(at parenthesized 15 Use) a place $unread"
applications_world local "$demand" "$(at local 16 Use) a place $unread"
applications_world member "$demand" "$(at member 15 Use) a place $unread"
applications_world parameter "$demand" "$(at parameter 15 Use) a place $unread"
applications_world wrapped "$demand" "$(at wrapped 16 Wrap) a place $unread"
applications_world lent-claim "$demand" \
    "✗ THE WHERE: cannot read 'Claim': 'Checks/where-applications/lent-claim-definitions.swift' defines it as an application of a gated head, and this court judges certificates in the world it reads"
applications_world lent-gate "$demand" \
    "✗ THE WHERE: cannot read the gate 'Use: Admitted' in 'Checks/where-applications/lent-gate-definitions.swift': this court judges the gates of the world it reads, and 'Checks/where-applications/lent-gate.swift' names 'Use'"
applications_world lent-protocol "error: type 'Witness' does not conform to protocol 'Balanced'
error: 'Balanced' requires the types 'Witness.Left' (aka 'Good') and 'Witness.Right' (aka 'Bad') be equivalent" \
    "✗ THE WHERE: cannot read 'Balanced': it reaches 'Balanced', a gated protocol of 'Checks/where-applications/lent-protocol-definitions.swift', and this court judges the gated protocols of the world it reads"

# The control: every application stands where the court reads it.
control=(Checks/where-applications/admitted.swift Checks/where-applications/admitted-definitions.swift)
if ! swiftc -typecheck -module-cache-path "$applications_tmp/cache" "${control[@]}" \
    >"$applications_tmp/admitted-swift.log" 2>&1; then
    cat "$applications_tmp/admitted-swift.log"
    echo "where-applications: Swift refused the control" >&2
    exit 1
fi
if ! "$applications_bin/Tools" judge where "${control[@]}" >"$applications_tmp/admitted.log" 2>&1 \
    || ! grep -q "^✓ THE WHERE holds: 0 equalities and 4 memberships judged across 2 uses" "$applications_tmp/admitted.log"; then
    cat "$applications_tmp/admitted.log"
    echo "where-applications: the court did not admit the control" >&2
    exit 1
fi
python3 Checks/where-nested-applications.py "$applications_bin/Tools"
python3 Checks/where-application-names.py "$applications_bin/Tools"
echo "✓ where-applications: nine applications the court does not read are named, the compiler refuses each world, the control's applications are read and admitted"
