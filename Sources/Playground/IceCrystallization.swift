import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// A DOMAIN — crystallization of ice. [Matter §5]
//
//   Σ         molecular configurations on a finite lattice
//   PAIR      adjacent molecular arrangement (two bonded molecules)
//   COMPARE   energy comparison: is configuration x lower-energy than y?
//   NULL      featureless lattice (all sites equivalent)
//   I1        finite lattice → finitely many configs        ✓
//   I2        Hamiltonian fixed at constant T                 ✓
//   I3        excluded configs stay excluded (Boltzmann)      ✓
//   A4        unique ground state Ih — depends on the encoding:
//               oxygen positions   → |S| = 1   (conforms)
//               hydrogen positions → |S| > 1   (Pauling residual entropy)
//   |S|       computed in the Instances target: W = 18, 148, 2970, … → Lieb 1.5396
// ═══════════════════════════════════════════════════════════════

/// Ice under the OXYGEN encoding crystallizes: the oxygen lattice has a unique
/// ground state Ih, so `|S| = 1`. The type checker certifies it by accepting
/// this conformance. The `Instances` target then computes `|S|` under the
/// hydrogen encoding and recovers the residual entropy from it. [Matter §5]
public struct IceOxygen: SystemCrystallizes {
    public typealias Sigma       = Three              // configurations on a finite lattice (I1)
    public typealias Left        = Cell<Never, Never> // the configuration pair COMPARE reads
    public typealias Right       = Cell<Never, Never>
    public typealias Cache       = Grew<Never, Never> // excluded configs ACCUMULATE — append-only (I3, Boltzmann)
    public typealias SolutionSet = Never              // unique ground state Ih: |S| = 1
    public typealias Equality    = Verdict<Never>     // energy comparison: lower or not (decidable, A3)
}

/// Ice under the HYDROGEN encoding carries a residual entropy: the two-in/two-out
/// ice rule leaves `W ≈ (3/2)^N` configurations, so `|S| > 1`. The solution set
/// is a genuine `Pair` of survivors, the case `Unique` excludes. [Matter §5]
public struct IceHydrogen {
    public typealias SolutionSet = Cell<Three, Never> // |S| > 1: the ice-rule manifold (Pauling)
}
// `extension IceHydrogen: SystemCrystallizes {}` is rejected: SolutionSet is not
// Unique. Same water, two encodings, two verdicts — the lens fixes |S| (Matter §5).
// The Instances target computes that |S| = W exactly (18, 148, 2970, …) and its entropy.
