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

// ── Cost is path length: a 3-token path costs exactly 3 ──

/// This is a construction of three tokens. `Path = Three` is a real count and `Distance == Path`, so the
/// cost the compiler reads off the type IS the path length: three. Witnesses `CostIsPathLength`.
public struct CountedPath: CostIsPathLength {
    public typealias Sigma = Cell<
        Never,
        Never
    >
    public typealias Path = Three                  // : IntegerValued, three tokens
    public typealias Distance = Three              // == Path, the cost is the length
}

// ── Reach is path: the HORN made concrete: one atom, a finite walk in an open reach ──

/// This gives the HORN as a model: a basis of ONE atom (`Succ<Never>`, the successor) and a path of
/// length three reached over it. The basis is finite, the reach is open, every walk is counted. This is
/// exactly Basis Is Residue's B8b ("ℕ-under-+: one atom, every numeral") that the paper left as
/// prose, here it compiles. Witnesses `ReachIsPath`.
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
// The capstone's deepest claim is the gap between GatedConstruction (sound, |S|=1) and
// FreeGeneration (total, |S|>1). Its essence is one coordinate: SolutionSet: Unique. These two
// witnesses isolate exactly that coordinate, and the #if proves the compiler NAMES it.

/// This gives two distinct survivors: a candidate set that was never cut to one. `|S| = 2`, not `Unique`.
public enum LeftSurvivor {}
/// This is the other survivor.
public enum RightSurvivor {}
/// This is the uncut candidate set: a `Pair` with two different sides, conforming no fixpoint marker.
public enum TwoSurvivors: Pair {
    public typealias Left = LeftSurvivor
    public typealias Right = RightSurvivor
}

/// This is a GATED solver: it crystallizes to one survivor. `SolutionSet = Never` is `Unique`
/// (|S|=1), so it conforms `ExactlyOneSurvives`, the gate `GatedConstruction` carries. It identifies.
public struct GatedSolver: ExactlyOneSurvives {
    public typealias Left = Never
    public typealias Right = Never
    public typealias Sigma = Cell<
        Never,
        Never
    >
    public typealias Equality = Verdict<Never>     // a real two-way test
    public typealias SolutionSet = Never           // : Unique, collapsed to one
}

/// A FREE babbler: a finite, decidable system that still holds two survivors. It has a solution
/// set (`HasSolutions`) but never cut it to one (`SolutionSet = TwoSurvivors`, not `Unique`).
/// This is the language model's coordinate: total, ungated. It conforms generation, not the gate.
public struct FreeBabbler: EqualityDecidable, HasSolutions {
    public typealias Left = Never
    public typealias Right = Never
    public typealias Sigma = Cell<
        Never,
        Never
    >
    public typealias Equality = Verdict<Never>
    public typealias SolutionSet = TwoSurvivors    // |S| = 2, proposed, not identified
}

#if HALLUCINATE
// Build with -DHALLUCINATE and this fails: the compiler NAMES the missing coordinate: a free
// generation cannot be gated without the uniqueness it does not have (TwoSurvivors is not Unique).
// That refusal IS "hallucination is the ungated generator", checked, not asserted. [PiP · Gen GD9]
extension FreeBabbler: ExactlyOneSurvives {}
#endif
