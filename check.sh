#!/usr/bin/env bash
# Every law this repository holds itself to, in Checks/Laws.swift.
#
# Court reads the declared law roster once. This runner receives its projection;
# it does not read Swift or maintain a second profile or scheduling partition.
#
#   ./check.sh --list       print the registered laws without executing them
#   ./check.sh              every law
#   ./check.sh --skip law   every law but the grammar mirror
#   ./check.sh --only law   the grammar mirror alone
#   ./check.sh --research-only  historical finite experiments, not type proofs
#   ./check.sh --only ablation  optional audit of the saved deletion experiment
#
# The mirror checks one distinct, read-back carrier per discovered input path
# and compiles its emitted formations. Source byte coverage and reference
# bindings remain reader debt (Contracts/Checks/grammar-reader-v1.md). CI runs
# this child build in its own job. Checks/Laws.swift names what both jobs run.
set -uo pipefail
cd "$(dirname "$0")"
# the verdict law may keep a receipt for inputs that did not change
# (Checks/verdict.sh); a direct run of that law keeps none
export VERDICT_RECEIPT=1
# A prepared binary belongs to this invocation, never a previous shell run.
unset VI_CHECK_BUILD_BIN
. Checks/build-tools.sh
run_input_key=""

MODE_LIST=""
MODE_SKIP=""
MODE_ONLY=""
MODE_RESEARCH=""
MODE_PROFILE=""
while [ $# -gt 0 ]; do
    case "$1" in
        --list) MODE_LIST="yes"; shift ;;
        --profile) MODE_PROFILE="$2"; shift 2 ;;
        --skip) MODE_SKIP="$2"; shift 2 ;;
        --only) MODE_ONLY="$2"; shift 2 ;;
        --research-only) MODE_RESEARCH="yes"; shift ;;
        *) echo "check.sh: unknown argument $1" >&2; exit 2 ;;
    esac
done

# A law that reads only a committed tree is named here; a run with work in
# progress names it as not asked and holds the rest. The current SDK artifact
# law reproduces its declared source inputs; it can also inspect a working tree.
NEEDS_CLEAN=""

# Bind the roster projection and execution to the same source snapshot.
run_input_key=$(vi_check_source_key) || exit 1

# This list is a Court roster projection, not an authored second registry.
# Build/transport/execution are physical-runner debt T0084, not relation proofs.
registry_args=(--only "$MODE_ONLY")
[ "$MODE_RESEARCH" != yes ] || registry_args+=(--research-only)
[ -z "$MODE_PROFILE" ] || registry_args+=(--select-profile "$MODE_PROFILE")
registry_path=$(mktemp "${TMPDIR:-/tmp}/vi-laws.XXXXXX") || exit 2
if ! python3 Checks/profiles.py --project "${registry_args[@]}" >"$registry_path"; then
    rm -f "$registry_path"
    exit 2
fi
LAWS=()
while IFS= read -r entry; do LAWS+=("$entry"); done <"$registry_path"
rm -f "$registry_path"
projection_input_key=$(vi_check_source_key) || exit 1
if [ "$projection_input_key" != "$run_input_key" ]; then
    echo "Checks/Laws.swift:1: inputs changed while Court projected the law roster" >&2
    exit 1
fi

if [ "$MODE_LIST" = "yes" ]; then
    if [ -n "$MODE_ONLY$MODE_SKIP$MODE_RESEARCH" ]; then
        echo "check.sh: --list cannot be combined with check selection" >&2
        exit 2
    fi
    for entry in "${LAWS[@]}"; do
        tag="${entry%%|*}"
        rest="${entry#*|}"
        printf '%s|%s\n' "$tag" "${rest#*|}"
    done
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
# These laws read the completed build and source tree; SwiftPM and graph
# writers stay barriers. New laws run serially until their reads are reviewed.
check_jobs=${VI_CHECK_JOBS:-3}
case "$check_jobs" in
    [1-9]|[1-5][0-9]|6[0-4]) ;;
    *) echo "check.sh: VI_CHECK_JOBS must be 1..64" >&2; exit 2 ;;
esac
check_tmp=""
queued_tags=()
queued_pids=()
check_cleanup() {
    for pid in "${queued_pids[@]+"${queued_pids[@]}"}"; do
        kill "$pid" 2>/dev/null || true
    done
    for pid in "${queued_pids[@]+"${queued_pids[@]}"}"; do
        wait "$pid" 2>/dev/null || true
    done
    [ -z "$check_tmp" ] || rm -rf "$check_tmp"
}
trap check_cleanup EXIT
ask_law() {
    local law_tag="$1" law_said="$2" law_cmd="$3" law_started law_status=0
    export VI_CHECK_LAW="$law_tag"
    echo "── $law_tag: $law_said"
    law_started=$SECONDS
    echo "   started: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
    eval "$law_cmd" || law_status=$?
    if [ "$law_status" -eq 0 ] && [ "$law_tag" = build ]; then
        VI_CHECK_BUILD_BIN=$(swift build --show-bin-path) || law_status=$?
        [ "$law_status" -ne 0 ] || export VI_CHECK_BUILD_BIN
    fi
    echo "   elapsed: $((SECONDS - law_started))s; exit: $law_status"
    return "$law_status"
}
flush_laws() {
    local i
    for ((i=0; i<${#queued_pids[@]}; i++)); do
        if ! wait "${queued_pids[$i]}"; then
            failed+=("${queued_tags[$i]}")
        fi
        cat "$check_tmp/${queued_tags[$i]}.log"
    done
    queued_tags=()
    queued_pids=()
}
for entry in "${LAWS[@]}"; do
    tag="${entry%%|*}"
    rest="${entry#*|}"
    group="${rest%%|*}"
    rest="${rest#*|}"
    said="${rest%%|*}"
    cmd="${rest#*|}"
    [ -n "$MODE_ONLY" ] && [ "$tag" != "$MODE_ONLY" ] && continue
    [ -n "$MODE_SKIP" ] && [ "$tag" = "$MODE_SKIP" ] && continue
    if [[ " $NEEDS_CLEAN " == *" $tag "* ]] && [ -n "$(git status --porcelain)" ]; then
        flush_laws
        echo "── $tag: $said"
        echo "   not asked: this law reads a committed tree, and yours has work in it"
        skipped+=("$tag")
        continue
    fi
    if [ "$group" = parallel ]; then
        if [ -z "$check_tmp" ]; then
            check_tmp=$(mktemp -d "${TMPDIR:-/tmp}/vi-check.XXXXXX") || exit 1
        fi
        ask_law "$tag" "$said" "$cmd" >"$check_tmp/$tag.log" 2>&1 &
        queued_tags+=("$tag")
        queued_pids+=("$!")
        if [ "${#queued_pids[@]}" -ge "$check_jobs" ]; then flush_laws; fi
    else
        flush_laws
        if ! ask_law "$tag" "$said" "$cmd"; then failed+=("$tag"); fi
    fi
done
flush_laws

if [ -n "$run_input_key" ]; then
    run_final_key=$(vi_check_source_key) || exit 1
    if [ "$run_final_key" != "$run_input_key" ]; then
        echo "check.sh: build inputs changed during this run; the shared build does not check this tree" >&2
        failed+=("build")
    fi
fi
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
if [ -n "$MODE_ONLY$MODE_SKIP$MODE_PROFILE" ]; then
    echo "✓ SELECTED LAWS HOLD; this is not a full gate (--only ${MODE_ONLY:-none}, --skip ${MODE_SKIP:-none}, --profile ${MODE_PROFILE:-none})"
else
    echo "✓ ALL LAWS HOLD"
fi
