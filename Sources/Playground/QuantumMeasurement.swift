import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// A DOMAIN plugged into the V=I lattice — quantum measurement.
//
// This target is APPLICATION code: it USES VerificationIsIdentification, it is not part of
// the law. A physical domain declares its V=I structure by conforming.
// If it compiles, the type checker has CERTIFIED that the domain
// satisfies the axioms it claims — no runtime, the proof IS the build.
// This is how you plug your own object into the game. [Matter §5]
//
//   V=I       quantum measurement
//   ───       ──────────────────────────────────────────────
//   Σ         states in a finite-dimensional Hilbert space H
//   COMPARE   projective measurement: eigenvalue matches or not
//   PAIR      composite system (tensor product H₁ ⊗ H₂)
//   NULL      vacuum / ground state
//   I1        dim(H) < ∞ → finitely many outcomes
//   I2        measurement operator fixed during measurement
//   I3        a recorded result is permanent (decoherence)
//   |S| = 1   non-degenerate eigenvalue → unique eigenstate
// ═══════════════════════════════════════════════════════════════

/// Projective measurement on a finite-dimensional, non-degenerate system
/// IS a crystallizing system (A1–A4, Matter §5): each measurement
/// monotonically eliminates eigenstates (A1) and cannot be retracted
/// (A2, decoherence) until one eigenstate remains (A4, |S|=1). The
/// successful build is the certificate.
public struct QuantumMeasurement: SystemCrystallizes {
    public typealias Sigma       = Three              // H — a finite-dimensional state space
    public typealias Left        = Cell<Never, Never> // a measurement branch …
    public typealias Right       = Cell<Never, Never> // … bottoming at the ground state (NULL)
    public typealias Cache       = Grew<Never, Never> // recorded outcomes ACCUMULATE — append-only (I3, decoherence)
    public typealias SolutionSet = Never              // surviving eigenstates → one (|S|=1, non-degenerate)
    public typealias Equality    = Verdict<Never>     // projective measurement: matches or not (decidable, I2)
}

/// A measurement of a DEGENERATE eigenvalue: its eigenspace holds several
/// eigenstates, so `|S| > 1`. The measurement returns the eigenvalue yet cannot
/// identify the state, the case `Unique` excludes. [Matter §5]
public struct DegenerateMeasurement {
    public typealias SolutionSet = Cell<Three, Never> // |S| > 1: a degenerate eigenspace
}
// `extension DegenerateMeasurement: SystemCrystallizes {}` is rejected: SolutionSet
// is not Unique. The Instances target counts the degeneracy (hydrogen n=2 → n² = 4).
