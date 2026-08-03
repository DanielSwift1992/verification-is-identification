#!/usr/bin/env bash
# Every law this repository holds itself to, in one list.
#
# The list used to live twice, once in .github/workflows/docs.yml and once in
# whoever remembered it before a push. A push that ran five of the six went
# green on the desk and red on the runner, twice in two days. So the list
# lives here, and both callers read it: a person runs `./check.sh`, and the
# workflow runs the same file.
#
#   ./check.sh              every law
#   ./check.sh --skip law   every law but the grammar mirror
#   ./check.sh --only law   the grammar mirror alone
#
# The mirror carries every source file through a second compiler and takes
# minutes, so CI runs it in a job of its own and this file is how both jobs
# name what they run. A law that is added here is added for everybody.
set -uo pipefail
cd "$(dirname "$0")"

MODE_SKIP=""
MODE_ONLY=""
while [ $# -gt 0 ]; do
    case "$1" in
        --skip) MODE_SKIP="$2"; shift 2 ;;
        --only) MODE_ONLY="$2"; shift 2 ;;
        *) echo "check.sh: unknown argument $1" >&2; exit 2 ;;
    esac
done

# The second judge checks out HEAD into a worktree, so it answers only over a
# committed tree. A run with work in progress says so and holds the rest.
NEEDS_CLEAN="judge"

# tag | what it holds | how to ask
LAWS=(
"build|the package builds and its tests pass|swift build && swift test"
"census|the declaration count per target|swift run Tools census"
"voice|the prose holds at its pins|swift run Tools voice"
"readme|the numbers are counted, not remembered|swift run Tools readme"
"rules|a rule is one substitution|swift run Tools lint Sources/DynamicsDemo/Rules.swift --strict"
"topics|the Topics tree equals the type lattice|swift package --allow-writing-to-package-directory tree-sort check"
"ablation|the ablation page names the premises the lattice declares|swift build --product Tools >/dev/null && GRAPH=\$(find .build -name VerificationIsIdentification.symbols.json | head -1) && .build/debug/Tools ablate \"\$GRAPH\" --check"
"judge|the second judge agrees with the compiler|swift run Tools judge diff 200"
"light|the second judge reads the conditional grammar|swift run Tools judge where Sources/Examples/Light.swift"
"ladder|the second judge counts the Rydberg ladder|swift run Tools judge where Sources/Examples/RydbergLadder.swift Sources/VerificationIsIdentification/Primitive.swift"
"grants|the second judge reads the grant world|swift run Tools judge where Sources/Examples/Grants.swift"
"law|the grammar carries every source file|swift run Tools grammar"
)

failed=()
skipped=()
for entry in "${LAWS[@]}"; do
    tag="${entry%%|*}"
    rest="${entry#*|}"
    said="${rest%%|*}"
    cmd="${rest#*|}"
    [ -n "$MODE_ONLY" ] && [ "$tag" != "$MODE_ONLY" ] && continue
    [ -n "$MODE_SKIP" ] && [ "$tag" = "$MODE_SKIP" ] && continue
    if [ "$tag" = "$NEEDS_CLEAN" ] && [ -n "$(git status --porcelain)" ]; then
        echo "── $tag: $said"
        echo "   not asked: this law reads a committed tree, and yours has work in it"
        skipped+=("$tag")
        continue
    fi
    echo "── $tag: $said"
    if ! eval "$cmd"; then
        failed+=("$tag")
    fi
done

if [ ${#failed[@]} -gt 0 ]; then
    echo "✗ RED: ${failed[*]}"
    exit 1
fi
if [ ${#skipped[@]} -gt 0 ]; then
    echo "✓ EVERY LAW ASKED HOLDS, and ${skipped[*]} waits for a committed tree"
    exit 0
fi
echo "✓ ALL LAWS HOLD"
