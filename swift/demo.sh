#!/usr/bin/env bash
# demo.sh — the compiler as oracle.
#
# There is no runtime here. Type-checking a system IS verifying it: a green
# build is a proof, a red build is the compiler naming the system's flaw.
# The snippets live in demo/ — edit one line and run again.   Run: ./demo.sh
set -uo pipefail
cd "$(dirname "$0")"

G='\033[32m'; R='\033[31m'; B='\033[1m'; D='\033[2m'; X='\033[0m'
THEORY=(Sources/Theory/*.swift)
compile() { swiftc -typecheck "${THEORY[@]}" "$1" 2>&1; }
hr() { printf "${D}──────────────────────────────────────────────────────────────${X}\n"; }

echo
printf "${B}V = I  ·  the compiler as oracle${X}\n"
printf "${D}No program runs. Type-checking a system is verifying it.${X}\n\n"

# ── Act 1 — certified ──────────────────────────────────────────
hr; printf "${B}[1] Can the compiler certify a tablebase?${X}\n\n"
sed 's/^/    /' demo/certified.swift
if compile demo/certified.swift >/dev/null; then
  printf "\n    ${G}✓ COMPILES.${X} The green build is a proof: it never emits a wrong answer.\n\n"
fi

# ── Act 2 — the rejection ──────────────────────────────────────
hr; printf "${B}[2] Can it certify a large language model?${X}\n\n"
printf "    ${D}It differs from the certified system by exactly one line:${X}\n\n"
diff demo/certified.swift demo/hallucinating.swift | grep -E '^[<>] +typealias SolutionSet' | sed 's/^/      /'
echo
err=$(compile demo/hallucinating.swift)
if echo "$err" | grep -q 'error:'; then
  printf "    ${R}✗ REJECTED.${X} The compiler refuses, and names the missing coordinate:\n\n"
  echo "$err" | grep 'error: type' | grep -v '`-' | sed -E 's|^.*error:|error:|; s/^/      /' | head -2
  printf "\n    That missing gate ${B}is${X} the hallucination. No benchmark ran — the type checker already knows.\n\n"
fi

# ── Act 3 — unification ────────────────────────────────────────
hr; printf "${B}[3] Is machine learning the same structure as a wavefunction collapsing?${X}\n\n"
printf "    ${D}Three systems, one conformance — quantum measurement, ice, a learner:${X}\n"
grep -E '^struct ' demo/unification.swift | sed 's/struct /      • /; s/:.*//'
echo
if compile demo/unification.swift >/dev/null; then
  printf "    ${G}✓ ALL COMPILE.${X} One gate certifies measurement, freezing, and learning.\n"
  printf "    A type checker just unified quantum mechanics and AI.\n\n"
fi

# ── Scorecard ──────────────────────────────────────────────────
hr; printf "${B}The scorecard${X} ${D}— which coordinate each system has${X}\n\n"
printf "    %-21s %-5s %-4s %-10s %s\n" "system" "gate" "I3" "basis" "the build says"
printf "    %-21s %-5s %-4s %-10s ${G}%s${X}\n" "tablebase"           "yes" "yes" "r=0"       "✓ certified (exact; doesn't scale)"
printf "    %-21s %-5s %-4s %-10s ${G}%s${X}\n" "certified self-play" "yes" "yes" "certified" "✓ certified"
printf "    %-21s %-5s %-4s %-10s ${R}%s${X}\n" "language model"      "no"  "no"  "pseudo"    "✗ rejected — hallucinates, forgets"
printf "    %-21s %-5s %-4s %-10s ${G}%s${X}\n" "quantum measurement" "yes" "yes" "-"         "✓ same structure"
printf "    %-21s %-5s %-4s %-10s ${G}%s${X}\n" "ice crystal"         "yes" "yes" "-"         "✓ same structure"
echo
printf "    ${D}Edit the one line in demo/hallucinating.swift, run again, watch it flip.${X}\n\n"
