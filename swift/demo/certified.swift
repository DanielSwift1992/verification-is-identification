// A CERTIFIED system — a tablebase, or this series' certified self-play.
// It has the gate: its solution set collapses to one (|S| = 1, `Unique`).
// Conforming to `SystemCrystallizes` is a *proof* it never emits a wrong answer.
struct CertifiedSystem: SystemCrystallizes {
    typealias Sigma       = Never
    typealias Left        = Never
    typealias Right       = Never
    typealias Cache       = Never          // I3 — the record is append-only
    typealias Equality    = Never          // a decidable verifier
    typealias SolutionSet = Never          // THE GATE — |S| = 1  (Unique)
}
