import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// A DOMAIN names the Higgs mechanism. [Matter §5]
//
//   Σ               field configurations φ
//   COMPARE         energy test: V(φ) at a candidate minimum
//   crystallization symmetry breaking: symmetric minimum → asymmetric vacuum
//   I2              V(φ) fixed (the Lagrangian does not change)   ✓
//   I3              the vacuum does not return to the symmetric state ✓
//   A4              the vacuum manifold is degenerate, encoding-dependent:
//                     field components → |S| > 1 (Goldstone directions)
//                     gauge-invariant  → |φ| = v ≈ 246 GeV, |S| = 1
// ═══════════════════════════════════════════════════════════════

/// This is the Higgs vacuum under the GAUGE-INVARIANT encoding: |φ| = v is the
/// unique minimum → |S| = 1 → a crystallizing system. Certified by the
/// build. Same physics as the field-component view, opposite verdict:
/// exactly the ice lesson: the lens, not the target, fixes |S|.
public struct HiggsGaugeInvariant: SystemCrystallizes {
    public typealias Sigma       = Three              // field configurations
    public typealias Left        = Cell<
        Never,
        Never
    >
    public typealias Right       = Cell<
        Never,
        Never
    >
    public typealias Cache       = Grew<
        Never,
        Never
    > // broken-symmetry history ACCUMULATES, irreversible (I3)
    public typealias SolutionSet = Never              // |φ| = v, the unique minimum (|S| = 1)
    public typealias Equality    = Verdict<Never>     // V(φ) energy test (decidable)
}

/// This is the Higgs vacuum under the FIELD-COMPONENT encoding: the vacuum manifold holds
/// three Goldstone directions, so `|S| > 1`. Same vacuum as the gauge-invariant
/// view, opposite verdict: the lens fixes |S|, the case `Unique` excludes. [Matter §5]
public struct HiggsFieldComponents {
    public typealias SolutionSet = Cell<
        Three,
        Never
    > // |S| > 1: the Goldstone manifold
}
// `extension HiggsFieldComponents: SystemCrystallizes {}` is rejected: SolutionSet
// is not Unique. The Instances target counts the Goldstones (SU(2)×U(1) → U(1): 3).
