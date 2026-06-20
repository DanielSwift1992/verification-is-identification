// ═══════════════════════════════════════════════════════════════
// The Solvability Criterion (Specification) — paper E2.
//
// The framework delegates one thing — the encoder — and proves the rest.
// This document takes the delegation seriously: the delegated slot is not a
// void, it is TYPED. A grammar that solves the domain must reach the rules
// (coverage C1), pin them from few examples (discrimination C2), compress
// (C3), anchor held-out rules in training balls (C4a), route to them (C4b),
// and find a certifiable rule in the ball within budget (C5). Together they
// convert "can it be solved" into a specification: a conditional theorem
// whose SAFETY half is fully proven and whose COMPLETENESS half is budget-
// and certifiability-bound, with the antecedent — a grammar meeting the
// conditions — the entire open problem, stated exactly.
//
// Pure types (§0′). The type signature of a solver. [Spec]
// ═══════════════════════════════════════════════════════════════

/// The delegated encoder slot is TYPED, not void: five conditions a grammar
/// must meet to solve the domain. REACH the rules (C1 coverage,
/// ``HasEncoding``), pin them from few examples (C2 = R4,
/// ``ExactlyOneSurvives``), COMPRESS (C3 = ``CompressionCriterion``), and ANCHOR
/// eval rules within training balls (C4a = ``BallSaturation``, with routing C4b
/// and within-ball certifiability C5 carried by the same stack). Distinct
/// failure modes over one dependency chain — EMPTY, |S|>1, flat, no-anchor,
/// BUDGET. [Spec C1-C5]
public protocol EncoderConditions: HasEncoding, ExactlyOneSurvives, CompressionCriterion, BallSaturation {}

/// If the encoder meets the ``EncoderConditions`` C1–C5, a V=I agent is
/// certified-SAFE unconditionally — every PASS is f* (``PassIsIdentification``,
/// Theorem 2, independent of how the candidate was found), never a wrong answer —
/// and certified-COMPLETE only within budget and C5. Safety is proven;
/// completeness rests on enumerating the ball, bounded by certifiability, and is
/// NOT claimed unconditionally. The two halves of "solve", split exactly. [Spec E2.1]
///
/// > Note: Safety and completeness part ways here. PASS is always correct on
/// > structural grounds alone; whether the agent finds a PASS at all is the
/// > budget-bound half, and only that half can fail.
public protocol ConditionalSolving: EncoderConditions, PassIsIdentification {}

/// Any non-memorizing solver must be two-layer: an encoder over an r>0
/// ball-router. ALL irreducible difficulty is the construction of E* (perception,
/// abstraction, the priors); the backend of ``ConditionalSolving`` is
/// proven-safe and invariant to the attack. The difficulty of the domain and the
/// ``ScopeBoundedByEncoding`` scope of V=I are disjoint by construction —
/// difficulty localizes to the encoder, safety holds around it. [Spec E2.4, E2.5]
public protocol DifficultyIsEncoder: ConditionalSolving, ScopeBoundedByEncoding {}

// ───────────────────────────────────────────────────────────────
// §5 (the encoder regress — two floors) — recorded, ties to Play PP15.
//
// The comparison SUBSTRATE (PAIR/NULL/COMPARE) is floored by the postulate
// (V=I §0) — but it carries NO perceptual content (§5.21). PERCEPTION (the
// feature grammar) is delegated all the way down to an agent-given base and is
// only CONDITIONALLY derivable above it (the crystallization tower, terminating
// at the first metrically-uniform level, O19/G12). So: the postulate floors the
// medium; perception is the standing debt, closable above its base up to where
// the domain stops compressing — a measurable number. Same floor PP15 names.
// ───────────────────────────────────────────────────────────────
