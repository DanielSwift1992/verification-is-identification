import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// LEARNING MACHINES as domains — the projection made live. [Projection]
//
// A learning system is located by which coordinates it has. The gate
// coordinate is, at the type level, |S|=1 (SolutionSet collapses to one —
// Unique). A machine WITH the gate (and I3) conforms to the certified
// lattice; a machine WITHOUT it cannot — and the compiler names the missing
// coordinate. The same conformance gate that certified quantum measurement
// now separates a certified learner from a hallucinating one.
// ═══════════════════════════════════════════════════════════════

/// Certified self-play (this series): gate ✓, I3 ✓, certified basis. The
/// solution set collapses to one (|S|=1), the cache is append-only — all
/// coordinates present, so it conforms to the crystallizing lattice. Certified
/// by the build. [Projection AI6]
public struct CertifiedSelfPlay: SystemCrystallizes {
    public typealias Sigma = Never
    public typealias Left = Never
    public typealias Right = Never
    public typealias Cache = Never        // I3 — append-only record
    public typealias SolutionSet = Never  // gate — |S| = 1, the verdict collapses
    public typealias Equality = Never     // decidable verifier
}

/// A large language model: gate ✗, I3 ✗, uncertified basis. It is a generator
/// in pure liquid — its solution set never collapses to one (no gate → |S|>1 →
/// it emits the guess as if certified = hallucination).
public struct LanguageModel {
    public typealias SolutionSet = Cell<Three, Never>   // |S| > 1 — no gate, never Unique
}
// Adding `extension LanguageModel: SystemCrystallizes {}` is REJECTED by the
// compiler: SolutionSet does not conform to Unique. No gate = no |S|=1 = the
// machine cannot tell a proof from a guess. The missing coordinate is named,
// exactly as the degenerate eigenvalue was (QuantumMeasurement). Give it a gate
// and I3 (CertifiedSelfPlay) and the same flow becomes a machine that answers
// or stays silent — never a confident lie.
