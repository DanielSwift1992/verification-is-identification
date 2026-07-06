// ═══════════════════════════════════════════════════════════════
// The Solvability Criterion (Specification).
//
// The framework delegates one thing, the encoder, and proves the rest.
// This document takes the delegation seriously: the delegated slot is not a
// void, it is TYPED. A grammar that solves the domain must reach the rules
// (coverage C1), pin them from few examples (discrimination C2), compress
// (C3), anchor held-out rules in training balls (C4a), route to them (C4b),
// and find a certifiable rule in the ball within budget (C5). Together they
// convert "can it be solved" into a specification: a conditional theorem
// whose SAFETY half is fully proven and whose COMPLETENESS half is budget-
// and certifiability-bound, with the antecedent (a grammar meeting the
// conditions) the entire open problem, stated exactly.
//
// It also names the measured boundary: the load-bearing CONDITIONAL claims,
// modulus (G10), clustering (G12), alignment (α, GA), strategy compression
// (O18), are NOT derivable from I1–I3, but are measurable properties a domain
// has or lacks. The proven core (Theorems 1–5) holds unconditionally; the
// measured core is settled by an instrument, and that instrument is empirical:
// the E1 measurement is empirical: a separate tool, not in these types.
//
// Pure types (§0′). The type signature of a solver. [Spec]
// ═══════════════════════════════════════════════════════════════

/// The delegated encoder slot is TYPED, not void: five conditions a grammar
/// must meet to solve the domain. REACH the rules (C1 coverage,
/// ``HasEncoding``), pin them from few examples (C2 = R4,
/// ``ExactlyOneSurvives``), COMPRESS (C3 = ``CompressionCriterion``), and ANCHOR
/// eval rules within training balls (C4a = ``BallSaturation``, with routing C4b
/// and within-ball certifiability C5 carried by the same stack). Distinct
/// failure modes over one dependency chain: EMPTY, |S|>1, flat, no-anchor,
/// BUDGET. [Spec C1-C5]
public protocol EncoderConditions: HasEncoding, ExactlyOneSurvives, CompressionCriterion, BallSaturation {}

/// If the encoder meets the ``EncoderConditions`` C1–C5, a V=I agent is
/// certified-SAFE unconditionally: every PASS is f* (``PassIsIdentification``,
/// Theorem 2, independent of how the candidate was found), not a wrong answer,
/// and certified-COMPLETE only within budget and C5. Safety is proven.
/// Completeness rests on enumerating the ball, bounded by certifiability, and is
/// NOT claimed unconditionally. The two halves of "solve", split exactly. [Spec E2.1]
///
/// > Note: Safety and completeness part ways here. PASS is always correct on
/// > structural grounds alone. Whether the agent finds a PASS at all is the
/// > budget-bound half, and only that half can fail.
public protocol ConditionalSolving: EncoderConditions, PassIsIdentification {}

/// Any non-memorizing solver must be two-layer: an encoder over an r>0
/// ball-router. ALL irreducible difficulty is the construction of E* (perception,
/// abstraction, the priors). The backend of ``ConditionalSolving`` is
/// proven-safe and invariant to the attack. The difficulty of the domain and the
/// ``ScopeBoundedByEncoding`` scope of V=I are disjoint by construction:
/// difficulty localizes to the encoder, safety holds around it. [Spec E2.4, E2.5]
public protocol DifficultyIsEncoder: ConditionalSolving, ScopeBoundedByEncoding {}

// ── The measured boundary: proven core vs measured core ──

/// The conditional faces the theory cannot derive from I1–I3 are what an
/// instrument measures, per domain. Searchability (clustered ∧ aligned,
/// ``SearchableIffClusteredAndAligned``) and the ``FourthFace``, skill
/// compressibility (O18), are bundled as exactly those properties. This names
/// the proven/measured split: the proven core holds unconditionally, the
/// measured core is a property a domain has or lacks. [Spec]
///
/// > Note: This is the line between the proven core (Theorems 1–5,
/// > ``PassIsIdentification`` and its ancestry) and the measured core. Whether a
/// > domain's faces hold is settled by an instrument, and the instrument is
/// > empirical: a separate measurement tool, not in these types.
public protocol MeasuredGeometry: SearchableIffClusteredAndAligned, FourthFace {}

// ───────────────────────────────────────────────────────────────
// §5 (the encoder regress, two floors): recorded, ties to Play PP15.
//
// The comparison SUBSTRATE (PAIR/NULL/COMPARE) is floored by the postulate
// (V=I §0), but it carries NO perceptual content (§5.21). PERCEPTION (the
// feature grammar) is delegated all the way down to an agent-given base and is
// only CONDITIONALLY derivable above it (the crystallization tower, terminating
// at the first metrically-uniform level, O19/G12). So: the postulate floors the
// medium; perception is the standing debt, closable above its base up to where
// the domain stops compressing, a measurable number. Same floor PP15 names.
// ───────────────────────────────────────────────────────────────
