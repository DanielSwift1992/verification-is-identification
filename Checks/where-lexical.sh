#!/usr/bin/env bash
# What the reader does not recognise is refused by name, never read as code.
# A regular expression literal, a slash in code that opens no comment and
# has no whitespace after it (which is how a bare literal opens, even one
# ending in `\//`), a backquoted
# identifier, a macro outside the built-in ones and an attribute neither
# built in nor declared here as a result builder or a property wrapper can
# each carry or hide a conformance; each world holds a real bad demand beside
# a good neighbour, the compiler refuses it, and the court gives no verdict
# and names the form and its line instead of holding the file. The boundary
# world shows the cost: a division with no space after its slash is refused
# with them, a narrowing of what the court reads, not a verdict. The control keeps the built-in forms and a
# declared property wrapper readable: the compiler accepts it and the court
# admits it.
set -euo pipefail
cd "$(dirname "$0")/.."

lexical_tmp=$(mktemp -d "${TMPDIR:-/tmp}/vi-where-lexical.XXXXXX")
trap 'rm -rf "$lexical_tmp"' EXIT

if ! swift build --product Tools >"$lexical_tmp/build.log" 2>&1; then
    cat "$lexical_tmp/build.log"
    exit 1
fi
lexical_bin=$(swift build --show-bin-path)

# lexical_world <world> <compiler flags> <compiler errors> <court refusal>:
# the compiler refuses the world for exactly these errors, and the court
# exits 2 with exactly this line on stderr and nothing on stdout.
lexical_world() {
    local world="$1" flags="$2" errors="$3" verdict="$4"
    # shellcheck disable=SC2086
    if swiftc -typecheck $flags -module-cache-path "$lexical_tmp/cache" \
        "Checks/where-lexical/$world.swift" >"$lexical_tmp/$world-swift.log" 2>&1; then
        echo "where-lexical: Swift accepted $world.swift" >&2
        exit 1
    fi
    local said=0
    "$lexical_bin/Tools" judge where "Checks/where-lexical/$world.swift" \
        >"$lexical_tmp/$world.out" 2>"$lexical_tmp/$world.err" || said=$?
    if [ "$said" -ne 2 ] || [ -s "$lexical_tmp/$world.out" ]; then
        cat "$lexical_tmp/$world.out" "$lexical_tmp/$world.err"
        echo "where-lexical: the where court did not refuse to read $world.swift" >&2
        exit 1
    fi
    python3 - "$world" "$lexical_tmp/$world-swift.log" "$lexical_tmp/$world.err" "$errors" "$verdict" <<'PY'
from pathlib import Path
import re, sys
world, swift_log, court_log, errors, verdict = sys.argv[1:]
pattern = re.compile(r"^Checks/where-lexical/" + re.escape(world) + r"\.swift:\d+:\d+: (error: .*)$")
said = [m.group(1) for m in map(pattern.match, Path(swift_log).read_text().splitlines()) if m]
if sorted(said) != sorted(errors.split("\n")):
    print(Path(swift_log).read_text())
    raise SystemExit(f"where-lexical: Swift did not refuse {world}.swift for the expected reasons")
if Path(court_log).read_text().splitlines() != [verdict]:
    print(Path(court_log).read_text())
    raise SystemExit(f"where-lexical: the court did not name the form it cannot read in {world}.swift")
PY
}

bad_demand="error: global function 'need' requires that 'Bad' conform to 'Required'"
lexical_world regex "" "$bad_demand" \
    "✗ THE WHERE: cannot read line 15: a regular expression literal is not among the forms this court reads"
lexical_world slashes "-enable-bare-slash-regex" "$bad_demand" \
    "✗ THE WHERE: cannot read line 15: a slash with no whitespace after it may open a regular expression literal, which this court does not read"
lexical_world escaped "-enable-bare-slash-regex" "$bad_demand" \
    "✗ THE WHERE: cannot read line 17: a slash with no whitespace after it may open a regular expression literal, which this court does not read"
lexical_world backquoted "" "$bad_demand" \
    "✗ THE WHERE: cannot read line 14: a backquoted identifier is not among the forms this court reads"
lexical_world attribute "" "error: unknown attribute 'AddsRequired'
$bad_demand" \
    "✗ THE WHERE: cannot read line 16: the attribute '@AddsRequired' is not among the forms this court reads"
lexical_world macro "" "error: no macro named 'makeConformance'
$bad_demand" \
    "✗ THE WHERE: cannot read line 13: the macro '#makeConformance' is not among the forms this court reads"

# The boundary: the compiler accepts a division, and the court names the
# slash it cannot tell from a literal's.
if ! swiftc -typecheck -module-cache-path "$lexical_tmp/cache" \
    Checks/where-lexical/division.swift >"$lexical_tmp/division-swift.log" 2>&1; then
    cat "$lexical_tmp/division-swift.log"
    echo "where-lexical: Swift refused the boundary world" >&2
    exit 1
fi
lexical_said=0
"$lexical_bin/Tools" judge where Checks/where-lexical/division.swift \
    >"$lexical_tmp/division.out" 2>"$lexical_tmp/division.err" || lexical_said=$?
if [ "$lexical_said" -ne 2 ] || [ -s "$lexical_tmp/division.out" ] \
    || [ "$(cat "$lexical_tmp/division.err")" != "✗ THE WHERE: cannot read line 14: a slash with no whitespace after it may open a regular expression literal, which this court does not read" ]; then
    cat "$lexical_tmp/division.out" "$lexical_tmp/division.err"
    echo "where-lexical: the court did not name the slash of the boundary world" >&2
    exit 1
fi

# The control: the built-in forms read, the compiler accepts, the court admits.
if ! swiftc -typecheck -module-cache-path "$lexical_tmp/cache" \
    Checks/where-lexical/admitted.swift >"$lexical_tmp/admitted-swift.log" 2>&1; then
    cat "$lexical_tmp/admitted-swift.log"
    echo "where-lexical: Swift refused the control" >&2
    exit 1
fi
if ! "$lexical_bin/Tools" judge where Checks/where-lexical/admitted.swift >"$lexical_tmp/admitted.log" 2>&1; then
    cat "$lexical_tmp/admitted.log"
    echo "where-lexical: the where court refused the control" >&2
    exit 1
fi
if ! grep -q "^✓ THE WHERE holds: 0 equalities and 2 memberships judged across 1 uses" "$lexical_tmp/admitted.log"; then
    cat "$lexical_tmp/admitted.log"
    echo "where-lexical: the control was not judged through its built-in forms" >&2
    exit 1
fi
# The lent attribute: a result builder Primitive.swift declares is a form the
# court reads in a world that file is lent to, and not in the world alone.
if ! swiftc -typecheck -module-cache-path "$lexical_tmp/cache" \
    Checks/where-lexical/attribute-lent.swift Sources/VerificationIsIdentification/Primitive.swift \
    >"$lexical_tmp/lent-swift.log" 2>&1; then
    cat "$lexical_tmp/lent-swift.log"
    echo "where-lexical: Swift refused the lent-attribute control" >&2
    exit 1
fi
lexical_said=0
"$lexical_bin/Tools" judge where Checks/where-lexical/attribute-lent.swift \
    >"$lexical_tmp/lent-alone.out" 2>"$lexical_tmp/lent-alone.err" || lexical_said=$?
if [ "$lexical_said" -ne 2 ] || [ -s "$lexical_tmp/lent-alone.out" ] \
    || [ "$(cat "$lexical_tmp/lent-alone.err")" != "✗ THE WHERE: cannot read line 18: the attribute '@StructureBuilder' is not among the forms this court reads" ]; then
    cat "$lexical_tmp/lent-alone.out" "$lexical_tmp/lent-alone.err"
    echo "where-lexical: the court did not name the attribute of the world alone" >&2
    exit 1
fi
if ! "$lexical_bin/Tools" judge where Checks/where-lexical/attribute-lent.swift \
    Sources/VerificationIsIdentification/Primitive.swift >"$lexical_tmp/lent.log" 2>&1; then
    cat "$lexical_tmp/lent.log"
    echo "where-lexical: the where court refused the lent-attribute control" >&2
    exit 1
fi
if ! grep -q "^✓ THE WHERE holds: 0 equalities and 2 memberships judged across 1 uses" "$lexical_tmp/lent.log"; then
    cat "$lexical_tmp/lent.log"
    echo "where-lexical: the lent-attribute control was not judged through its lent builder" >&2
    exit 1
fi
# The boundary of the lent attribute: the lent declaration shows a builder,
# not the Body it built. A gate on that Body meets a declaration outside the
# flat fragment: the court gives no verdict, and the compiler, which reads
# the body, refuses the demand.
if swiftc -typecheck -module-cache-path "$lexical_tmp/cache" \
    Checks/where-lexical/attribute-lent-body.swift Sources/VerificationIsIdentification/Primitive.swift \
    >"$lexical_tmp/lent-body-swift.log" 2>&1; then
    echo "where-lexical: Swift accepted the Body demand of the lent-attribute boundary" >&2
    exit 1
fi
if [ "$(grep -c "^Checks/where-lexical/attribute-lent-body.swift:[0-9]*:[0-9]*: error: global function 'needFlat' requires the types 'some Structure' and 'Never' be equivalent$" "$lexical_tmp/lent-body-swift.log")" -ne 1 ] \
    || [ "$(grep -c "^Checks/where-lexical/attribute-lent-body.swift:[0-9]*:[0-9]*: error: " "$lexical_tmp/lent-body-swift.log")" -ne 1 ]; then
    cat "$lexical_tmp/lent-body-swift.log"
    echo "where-lexical: Swift refused the lent-attribute boundary for another reason" >&2
    exit 1
fi
lexical_said=0
"$lexical_bin/Tools" judge where Checks/where-lexical/attribute-lent-body.swift \
    Sources/VerificationIsIdentification/Primitive.swift \
    >"$lexical_tmp/lent-body.out" 2>"$lexical_tmp/lent-body.err" || lexical_said=$?
if [ "$lexical_said" -ne 2 ] || [ -s "$lexical_tmp/lent-body.out" ] \
    || [ "$(cat "$lexical_tmp/lent-body.err")" != "✗ THE WHERE: unresolved definition reduction: cannot read declaration 'Page': body outside flat-definition fragment" ]; then
    cat "$lexical_tmp/lent-body.out" "$lexical_tmp/lent-body.err"
    echo "where-lexical: the court judged a Body it cannot read, or named another reason" >&2
    exit 1
fi
echo "✓ where-lexical: six unread forms are named at their line, the compiler refuses each world, a division is named at the boundary, the built-in forms read, a lent result builder reads beside its declaration and is named alone, and a Body the builder built stays unread"
