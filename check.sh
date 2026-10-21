#!/usr/bin/env bash
# Every law this repository holds itself to, in one list.
#
# The list used to live twice, once in .github/workflows/docs.yml and once in
# whoever remembered it before a push. A push that ran five of the six went
# green on the desk and red on the runner, twice in two days. So the list
# lives here, and both callers read it: a person runs `./check.sh`, and the
# workflow runs the same file.
#
#   ./check.sh --list       print the registered laws without executing them
#   ./check.sh              every law
#   ./check.sh --skip law   every law but the grammar mirror
#   ./check.sh --only law   the grammar mirror alone
#   ./check.sh --research-only  historical finite experiments, not type proofs
#   ./check.sh --only ablation  optional audit of the saved deletion experiment
#
# The mirror carries every source file through a second compiler and takes
# minutes, so CI runs it in a job of its own and this file is how both jobs
# name what they run. A law that is added here is added for everybody.
set -uo pipefail
cd "$(dirname "$0")"
# the verdict law may keep a receipt for inputs that did not change
# (Checks/verdict.sh); a direct run of that law keeps none
export VERDICT_RECEIPT=1

MODE_LIST=""
MODE_SKIP=""
MODE_ONLY=""
MODE_RESEARCH=""
while [ $# -gt 0 ]; do
    case "$1" in
        --list) MODE_LIST="yes"; shift ;;
        --skip) MODE_SKIP="$2"; shift 2 ;;
        --only) MODE_ONLY="$2"; shift 2 ;;
        --research-only) MODE_RESEARCH="yes"; shift ;;
        *) echo "check.sh: unknown argument $1" >&2; exit 2 ;;
    esac
done

# A law that reads only a committed tree is named here; a run with work in
# progress names it as not asked and holds the rest. The two that did, the
# differential judge and the artifacts law, moved with the company to the
# showcase package (T-0015).
NEEDS_CLEAN=""

# tag | what it holds | how to ask
LAWS=(
"build|the package builds and its tests pass|swift build && swift test"
"verdict|finite verdict certificates hold and broken premises are refused|bash Checks/verdict.sh"
)

# These programs explore finite models and preserve earlier counterexamples.
# They are not the implementation or proof authority for the type relations.
# They run only when explicitly selected. Publishing the theory does not
# depend on replaying a finite experiment.
RESEARCH=(
"question|discovery preserves a fixed question about the original state|python3 Checks/verdict_discovery_audit.py"
"controller|an internal controller uses observations and its whole completion preserves origins|python3 Checks/internal_controller_audit.py"
"finite|finite members, finite candidate spaces and finite towers have separate bounds|python3 Checks/finite_scope.py"
"cache|truth, accessible storage and semantic cache growth obey separate laws|python3 Checks/cache_law.py"
"entropy|conditional information and admissible questions obey separate bounds|python3 Checks/entropy_questions.py"
"transcript|attainable experiments certify excess distinctions and query costs|python3 Checks/transcript_partitions.py"
"learning|retention, class coverage, dispatch and prediction have separate premises|python3 Checks/learning_coverage.py"
"progress|relative certificates separate record novelty from question completion|python3 Checks/learning_progress.py"
"strategy|local query gain, instance certificates and adaptive policy optima have distinct witnesses|python3 Checks/query_strategy.py"
"wrapper|scoped checking separates soundness, coverage, trial laws and retained history|python3 Checks/gate_wrapper.py"
"scope|finite certificates replay within their stated question and candidate scope|python3 Checks/scoped_certificate.py"
"loop|internal acquisition, scoped reuse and equal-budget strategies replay|python3 Checks/vi_loop.py"
"selfplay|synthetic information, internal measurement and reversible reuse obey distinct bounds|python3 Checks/self_play_information.py"
"reflection|internal inspection and universal Boolean evaluation have separate boundaries|python3 Checks/self_inspection.py"
"sampling|countable coverage, critical moments and internal IID windows obey separate bounds|python3 Checks/sampling_boundary.py"
"stationarity|stationary retention, prepared growth and entropy preservation have distinct premises|python3 Checks/stationary_memory.py"
"arrow|exact reversible transport and repeated coarse updating have different entropy laws|python3 Checks/time_entropy.py"
"basis|bounded composition, generator residue and macro expansion preserve explicit budgets|python3 Checks/bounded_basis.py"
"context|component certificates remain valid only within their declared reuse scope|python3 Checks/context_reuse.py"
"transport|a question survives compatible coded transfers inside a declared whole|python3 Checks/semantic_transport.py"
"discovery|finite discovery policies and impossibility certificates replay correctly|python3 Checks/discovery_audit.py"
"dynamics|closed dynamics, memory and global compatibility obey their boundaries|python3 Checks/closed_dynamics.py"
"information|closed finite models distinguish retention, correlation and entropy|python3 Checks/closed_information.py"
"quotient|finite operational quotients obey their declared boundaries|python3 Checks/operational_quotient.py"
"saturation|future-reading witnesses certify the coarsest autonomous refinement|python3 Checks/saturation_audit.py"
)

LAWS+=(
"census|the declaration count per target|swift run Tools census"
"voice|lexical counts do not exceed their authored pins|swift run Tools voice"
"readme|the numbers are counted, not remembered|swift run Tools readme"
"renames|empty intersections have one name; duplicate controls refuse|swift run Tools lint Sources/VerificationIsIdentification --docc Sources/VerificationIsIdentification/VerificationIsIdentification.docc --strict && python3 Checks/lint_duplicates.py --tools .build/debug/Tools"
"topics|the Topics tree equals the type lattice|swift package --allow-writing-to-package-directory tree-sort check"
"families|every paper part has an owner and its readers reject lost addresses|swift run Tools papers && python3 Checks/paper_families.py --tools .build/debug/Tools --graph auto"
"light|the second judge names the claims of Light it does not read, and the rest holds|bash Checks/where-light.sh"
"ladder|the ladder's count readings agree and its nominal refusals stand|bash Checks/rydberg.sh"
"grants|the second judge reads the grant world|swift run Tools judge where Sources/Examples/Grants.swift"
"alias|a claim through an alias meets the gate its definition names|bash Checks/where-alias.sh"
"extension|a conformance stated in an extension is worn and judged|bash Checks/where-extension.sh"
"conditional|a conditional conformance is read as a gate or refused by name|bash Checks/where-conditional.sh"
"memberships|generic membership is explicitly unread while plain membership is judged|bash Checks/where-memberships.sh"
"lexical|a form the reader does not recognise is refused by name|bash Checks/where-lexical.sh"
"scope|a name has one supported lexical owner or is refused by name|bash Checks/where-scope.sh"
"applications|every application of a gated head is read or refused by name|bash Checks/where-applications.sh"
"court|the judge builds as a library a consumer links|bash Checks/court-library.sh"
"response|requested where applications have addressed outcomes and complete admission coverage|bash Checks/where-response.sh"
"contract|the named finite court contract matches its complete fixtures|bash Checks/court-contract.sh"
"profiles|named check profiles preserve the declared coverage|python3 Checks/profiles-test.py"
"ci|CI diagnostics preserve failed checks and quote their output safely|python3 Checks/ci-check-test.py"
"quotes|a quote of a sibling paper is that paper's sentence|swift run Tools quotes"
"law|the grammar carries every source file|swift run Tools grammar"
"boundary|registered and external scope maps keep component boundaries, coverage and compiler grants|bash Checks/grammar-boundary.sh && python3 Checks/grammar-scopes.py && python3 Checks/grammar-chunks.py"
)

RESEARCH+=(
"ablation-faults|tooling recovers from simulated I/O and compiler failures|swift build --product Tools >/dev/null && python3 Checks/ablation_failure.py .build/debug/Tools"
)

if [ "$MODE_RESEARCH" = "yes" ]; then
    LAWS=("${RESEARCH[@]}")
elif [ "$MODE_ONLY" = "ablation" ]; then
    LAWS=("ablation|the saved deletion experiment matches the current premise list|swift build --product Tools >/dev/null && .build/debug/Tools ablate --self-test && swift package dump-symbol-graph >/dev/null 2>&1 && GRAPH=\$(find .build -name VerificationIsIdentification.symbols.json | head -1) && .build/debug/Tools ablate \"\$GRAPH\" --check")
fi

if [ "$MODE_LIST" = "yes" ]; then
    if [ -n "$MODE_ONLY$MODE_SKIP$MODE_RESEARCH" ]; then
        echo "check.sh: --list cannot be combined with check selection" >&2
        exit 2
    fi
    printf '%s\n' "${LAWS[@]}"
    exit 0
fi

if [ -n "$MODE_ONLY" ]; then
    found=""
    for entry in "${LAWS[@]}"; do
        [ "${entry%%|*}" = "$MODE_ONLY" ] && found="yes"
    done
    if [ -z "$found" ]; then
        echo "check.sh: no selected check named $MODE_ONLY; finite experiments use --research-only" >&2
        exit 2
    fi
fi

failed=()
skipped=()
for entry in "${LAWS[@]}"; do
    tag="${entry%%|*}"
    rest="${entry#*|}"
    said="${rest%%|*}"
    cmd="${rest#*|}"
    [ -n "$MODE_ONLY" ] && [ "$tag" != "$MODE_ONLY" ] && continue
    [ -n "$MODE_SKIP" ] && [ "$tag" = "$MODE_SKIP" ] && continue
    if [[ " $NEEDS_CLEAN " == *" $tag "* ]] && [ -n "$(git status --porcelain)" ]; then
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
    echo "◐ PARTIAL: every law asked holds, but ${skipped[*]} was not asked (it reads a committed tree, and yours has work in it)."
    echo "  This is not a green verdict. Commit or stash the work, then run ./check.sh again."
    exit 3
fi
if [ "$MODE_RESEARCH" = "yes" ]; then
    echo "✓ RESEARCH EXPERIMENTS REPLAY; this is not a type-proof verdict"
    exit 0
fi
echo "✓ ALL LAWS HOLD"
