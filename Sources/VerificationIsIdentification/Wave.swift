import Swift

// ═══════════════════════════════════════════════════════════════
// WAVE pins the two claims of Interference Is Substitution: adding waves is
// rewriting a bag of contributions, and what a detector reads is that bag's
// normal form. The paper's worked instance is light — a dark fringe, crossed
// polarizers, the two-slit node — but the claims stand for any presented law
// whose contributions carry a cyclic remainder, so they live here, beside the
// presented half of the dynamics axis.
// ═══════════════════════════════════════════════════════════════

/// Interference is substitution: a wave is a finite bag of contributions, each
/// a magnitude with a cyclic remainder for its phase, and superposition never
/// computes: it rewrites. The one rule finds two contributions of equal
/// magnitude and opposite phase and removes the pair. The rule is a triple of
/// the presented class, so every step is judged and the whole calculus is the
/// dynamics medium, instantiated in optics. Builds on ``PresentedLaw``: the law is the
/// annihilation dictionary, written whole. [IiS 2]
public protocol InterferenceIsSubstitution: PresentedLaw {
    associatedtype Contribution
}

/// Darkness is a normal form: rewriting terminates because every step removes
/// a pair, and independent removals commute, so each bag settles to one
/// residue, and a detector reads that residue, never the history. A dark
/// fringe is the bag that settles to nothing: emptiness reached, not measured.
/// Builds on ``InterferenceIsSubstitution``: the observable is what the
/// rewriting leaves. [IiS 3]
public protocol DarknessIsNormalForm: InterferenceIsSubstitution {
    associatedtype Observed
}
