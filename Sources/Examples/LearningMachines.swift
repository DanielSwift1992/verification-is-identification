import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// LEARNING MACHINES names domains, the projection made live. [Projection]
//
// These are illustrative declarations with historical architecture names.
// The compiler checks their chosen coordinates. It does not execute a
// learning process or infer properties of actual neural systems.
// In particular, Never axes are uninhabited and provide no observed
// memory update, output coverage or empirical accuracy measurement.
// See Projection AI6–AI7 for the separate semantic obligations.
// ═══════════════════════════════════════════════════════════════

/// Historical self-play-shaped conformance using uninhabited axes.
/// This declaration has no generator, checker implementation or learning loop.
/// It witnesses the supplied type relation, not empirical self-play or
/// retention of accessible records. [Projection §7]
public struct CertifiedSelfPlay: SystemCrystallizes {
    public typealias Sigma = Never
    public typealias Left = Never
    public typealias Right = Never
    public typealias Cache = Never        // declared uninhabited cache coordinate
    public typealias SolutionSet = Never  // declared uninhabited solution coordinate
    public typealias Equality = Never     // declared equality coordinate
}

/// A toy non-Unique coordinate, not an implementation of a language model.
/// Its selected SolutionSet has no authority over the capabilities of
/// statistical proposal combined with a real verifier. [Projection §7]
public struct LanguageModel {
    public typealias SolutionSet = Cell<
        Three,
        Never
    >   // deliberately non-Unique toy coordinate
}
// Adding `extension LanguageModel: SystemCrystallizes {}` does not satisfy
// the required coordinates. This is a fact about this particular toy type.
// A richer implementation can provide a different relation and a checker.
// Neither conformance nor its absence proves runtime soundness, coverage,
// reproducibility or learning performance without the corresponding
// semantic and operational witnesses. [Projection AI1, AI6]
