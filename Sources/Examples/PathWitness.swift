import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// WITNESSES for Program Is Path names concrete inhabitants that make the capstone bite.
//
// The LawCheck plugin already proved every protocol in Path.swift is a genuine MOVE (no
// rename, every axis closed). These witnesses prove the second thing a theorem owes: that
// it has a MODEL, distinct-sided, not only the trivial Never fixpoint. Break a where-clause
// in Path.swift and the matching witness here stops compiling.
//
// Reuses the Peano chain (``Succ``/``Three``), ``Cell``, ``Grew`` (a real Permanent), and
// ``Verdict`` (a real Decidable) from Witness.swift.
// ═══════════════════════════════════════════════════════════════

// ── Emission accumulates: a path that really grows (Permanent, distinct sides) ──

/// A construction whose path accumulates: `Grew` is a non-trivial `Permanent`, so the emitted
/// path holds its whole prefix plus the new token. Witnesses `EmissionAccumulates`.
public struct EmittingPath: EmissionAccumulates {
    public typealias Sigma = Cell<
        Never,
        Never
    >
    public typealias Path = Grew<
        Never,
        Never
    >     // after ⊇ before, a real accumulation
}

// ── Two coordinates carry the same three-successor numeral ──

/// Both coordinates use the same concrete three-successor numeral. This
/// witnesses their equality, without recording three actual emissions or
/// deriving a physical charge. PiP3 separates these meanings.
public struct CountedPath: CostIsPathLength {
    public typealias Sigma = Cell<
        Never,
        Never
    >
    public typealias Path = Three                  // chosen numeral coordinate
    public typealias Distance = Three              // equal to that coordinate
}

// ── Reach is path: the HORN made concrete: one atom, a finite walk in an open reach ──

/// Concrete finite numeral coordinates for Basis and Path. The interface
/// does not bind a path's tokens to the basis or establish an infinite reach.
/// Those claims use the explicit finite-list grammar of PiP1.
public struct HollowReach: ReachIsPath {
    public typealias Sigma = Cell<
        Never,
        Never
    >
    public typealias Library = Cell<
        Never,
        Never
    >
    public typealias Basis = Succ<Never>           // ONE atom, the finite generating set
    public typealias Path = Three                  // a finite walk in the infinite reach
}

// ── The gate that distinguishes construction from hallucination ──
//
// These legacy witnesses isolate the Unique projection constraint. Its refusal
// does not prove a candidate count or a behavioral property of a generator.
// V=I U2–U2b supplies actual singleton and assignment proofs. PiP7 distinguishes
// correctness of an admitted choice from uniqueness of the admissible choice.

/// One nominal label used in a two-sided interface countermodel.
public enum LeftSurvivor {}
/// This is the other survivor.
public enum RightSurvivor {}
/// This is the uncut candidate set: a `Pair` with two different sides, conforming no fixpoint marker.
public enum TwoSurvivors: Pair {
    public typealias Left = LeftSurvivor
    public typealias Right = RightSurvivor
}

/// A legacy ExactlyOneSurvives witness with SolutionSet=Never. Its coordinates
/// satisfy the interface, without supplying candidate coverage or membership.
public struct GatedSolver: ExactlyOneSurvives {
    public typealias Left = Never
    public typealias Right = Never
    public typealias Sigma = Cell<
        Never,
        Never
    >
    public typealias Equality = Verdict<Never>     // declared paired answer
    public typealias SolutionSet = Never           // satisfies Unique's equations
}

/// An interface witness whose solution coordinate has unequal projections.
/// It cannot satisfy Unique for that coordinate. The name FreeBabbler does not
/// make the witness a language-model implementation or establish its behavior.
public struct FreeBabbler: EqualityDecidable, HasSolutions {
    public typealias Left = Never
    public typealias Right = Never
    public typealias Sigma = Cell<
        Never,
        Never
    >
    public typealias Equality = Verdict<Never>
    public typealias SolutionSet = TwoSurvivors    // unequal nominal projections
}

#if HALLUCINATE
// The historical flag rejects TwoSurvivors under Unique's equalities. It is an
// interface incompatibility test, not a demonstration of hallucination. [PiP7]
extension FreeBabbler: ExactlyOneSurvives {}
#endif
