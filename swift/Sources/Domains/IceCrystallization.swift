import Theory

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
// ═══════════════════════════════════════════════════════════════

/// Ice under the OXYGEN encoding: the oxygen lattice has a unique ground
/// state (Ih) → |S| = 1 → a crystallizing system. Certified by the build.
public struct IceOxygen: SystemCrystallizes {
    public typealias Sigma = Three        // configurations on a finite lattice
    public typealias Left = Never
    public typealias Right = Never
    public typealias Cache = Never        // excluded configs — append-only (I3)
    public typealias SolutionSet = Never  // unique ground state Ih (|S| = 1)
    public typealias Equality = Never     // energy comparison (decidable)
}

/// Ice under the HYDROGEN encoding: hydrogen positions are degenerate —
/// Pauling residual entropy, |S| > 1. It is NOT a crystallizing system; its
/// solution set does not collapse to one.
public struct IceHydrogen {
    public typealias SolutionSet = Cell<Three, Never>   // |S| > 1 — not Unique
}
// Adding `extension IceHydrogen: SystemCrystallizes {}` makes the compiler
// reject it — SolutionSet does not conform to Unique. Same physical system,
// two encodings, two verdicts: the encoding determines |S| (Matter §5).
