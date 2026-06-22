// ═══════════════════════════════════════════════════════════════
// Interference Is Intelligence (Mechanism).
//
// V=I gave the loop; IiI proved its efficiency rises. This gives the
// MECHANISM of the rise: COMPARE resolves into three independent axes —
// Z (outcome), X (structure), Y (order) — and intelligence is the
// constructive interference of COMPAREs along the Y-axis, the agent's sole
// freedom (§5.25). The order carries zero identification bits at its own
// level yet sets the total count, so optimizing it is intelligence.
//
// Pure types (§0′). The structural core only: the three-axis split and the
// three grades of identity. The quantitative core — interference counting,
// the speedup hierarchy, certificate complexity, self-correction — is
// analytic (rates and expectations), so it stays prose, as with E1. [InI]
// ═══════════════════════════════════════════════════════════════

/// COMPARE resolves into three independent projections.
/// - term Z: the outcome, one bit (the ``Decidable`` verdict).
/// - term X: the structure, the recursive form it walks to the first divergence (``OperationsClosed``).
/// - term Y: the order, which COMPARE runs next (``OrderIsOnlyFreedom``).
/// Z and X are fixed by the inputs. Y is the agent's choice on a disjoint input, so
/// the three are independent. [InI S1]
public protocol ThreeAxesOfCompare: Decidable, OperationsClosed, OrderIsOnlyFreedom {}

/// Intelligence is the interference pattern of the loop's own COMPAREs: the
/// efficiency gain η rises (``IntelligenceRises``) entirely along the Y-axis, the
/// order (``OrderIsOnlyFreedom``), as saturation teaches the optimal sequence.
/// Constructive interference of comparisons is the mechanism, a property of the
/// ordering rather than a heuristic added on top. [InI S5, S6]
public protocol InterferenceIsIntelligence: IntelligenceRises, OrderIsOnlyFreedom {}

/// "X is Y" has three grades: Z-identity (same outcome), X-identity (same
/// structure), Y-identity (interchangeable under every order). V=I's |S|=1 delivers
/// the strongest: f* is the unique survivor whatever the order
/// (``PassIsIdentification`` over ``OrderIsOnlyFreedom``), so every "is" the series
/// proves is a Y-identity. [InI S10]
public protocol IsIsYIdentity: PassIsIdentification, OrderIsOnlyFreedom {}

// ───────────────────────────────────────────────────────────────
// The quantitative core (S3, S4, S5a–b, S6a–c, S7, S8) — recorded, not type-level.
//
// S3 interference theorem (total COMPAREs minimised by maximal constructive
// interference), S4 speedup hierarchy (Z / Z+X / Z+X+Y bounds), S5a trajectory-
// information invariance (Σ h_k = log₂|S₀|, the same content however ordered), S5b
// certificate complexity cert(τ), S6c self-correction (η<1 → dissipation →
// learning → η↑: the suboptimality of the ordering is itself the exploration), S7
// three-way complementarity, S8 MBQC isomorphism — all turn on rates,
// expectations, and a cross-domain analogy. They are analytic, not structural, so
// they stay prose, as the E1 instrument stays empirical, outside the types.
// ───────────────────────────────────────────────────────────────
