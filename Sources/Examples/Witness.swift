import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// WITNESSES names concrete inhabitants that make the proof bite.
//
// Never is the TRIVIAL fixpoint: every marker is true there because
// Left == Right == Never. The types below are NON-trivial: they
// satisfy the marker relations with distinct sides, yet every one of
// them presses down to Never as its floor (the §4 base case, the zero).
//
// The compiler checking these conformances IS the verification that
// the theory has real models, not only the empty one. Break a marker
// relation and its witness stops compiling.
// ═══════════════════════════════════════════════════════════════

/// This is the raw act of distinction with two named sides: a reusable `Pair`.
///
/// The building block every other witness is assembled from: ``Grew``, ``Shrank``,
/// ``Path``, and ``Verdict`` all package their sides as a `Cell`.
public struct Cell<
    L,
    R
>: Pair {
    public typealias Left = L
    public typealias Right = R
}

// ── IntegerValued: the Peano chain, floored at Never (zero) ──
// Never is 0. Succ<N> is n+1, its predecessor Right = N is again a
// count in a finite expression ending at Never. The open bound on N also
// accepts cyclic conformers, so it does not prove finite depth (§4).
/// The successor: `n+1` as a non-trivial witness for `IntegerValued`.
///
/// `Succ<N>` is one step above its predecessor `N`. The chain bottoms out at
/// `Never` (zero, aliased ``Zero``). ``Three`` is `Succ<Succ<Succ<Never>>>`.
/// The finite Never/Succ grammar gives this interpretation. An arbitrary
/// IntegerValued predecessor need not reach the floor. [EiF EF10]
public struct Succ<
    N: IntegerValued
>: Pair, IntegerValued {
    public typealias Left = Never        // the unit step
    public typealias Right = N           // the predecessor, a smaller count
}
/// This is Zero: the floor of the count, which is `Never`. The base case every ``Succ`` chain ends at.
public typealias Zero = Never
/// This is Three: `Succ<Succ<Succ<Never>>>`. A worked count three steps above ``Zero``.
public typealias Three = Succ<Succ<Succ<Never>>>

// ── Permanent: accumulation. after = (before, delta), Left ≠ Right ──
/// This makes accumulation concrete: a non-trivial witness for `Permanent`.
///
/// The after-state `Right = Cell<Before, Delta>` holds the whole before-state
/// plus an increment, so `Right.Left == Before`. Distinct sides, real growth,
/// not the trivial `Never` fixpoint.
public struct Grew<
    Before,
    Delta
>: Pair, Permanent {
    public typealias Left = Before
    public typealias Right = Cell<
        Before,
        Delta
    >     // Right.Left == Left ✓
}

// ── Monotone: elimination. before = (after, removed). Permanent's mirror ──
/// This makes elimination concrete: a non-trivial witness for `Monotone`.
///
/// The before-state `Left = Cell<After, Removed>` holds the after-state plus what
/// was dropped, so `Left.Left == After`. The mirror of ``Grew``: same `Cell`, sides flipped.
public struct Shrank<
    After,
    Removed
>: Pair, Monotone {
    public typealias Left = Cell<
        After,
        Removed
    >     // Left.Left == Right ✓
    public typealias Right = After
}

// ── MetricProperty: two legs (a→b)(b→c) sharing the endpoint b ──
/// Two legs share one endpoint, satisfying the addressed `MetricProperty` seam.
///
/// `Left = Cell<A, B>` and `Right = Cell<B, C>` meet at `B`, so
/// `Left.Right == Right.Left == B`. This is a shared-field diagram.
/// It asserts neither equal leg lengths nor that B bisects the interval A to C.
/// G2d obtains the metric bound when its fields are the actual disjoint
/// difference partitions; a diagram of arbitrary vertices does not suffice.
public struct Path<
    A,
    B,
    C
>: Pair, MetricProperty {
    public typealias Left = Cell<
        A,
        B
    >
    public typealias Right = Cell<
        B,
        C
    >              // Left.Right == Right.Left == B ✓
}

// ── Measurable: a chosen Null output ──
/// A fixed-output family satisfying Measurable's addressed shape.
///
/// Left names Input while Right is always Never. It does not calculate
/// a property of Input or bind a physical measurement to that source.
public struct Measured<Input>: Pair, Measurable {
    public typealias Left = Input
    public typealias Right = Never                   // the determined value, collapsed
}

// ── Decidable: a chosen Pair output ──
/// A paired output shape satisfying Decidable, without a membership reader.
///
/// Left names Elem and Right is Cell<Never,Never>. The two fields alone
/// do not choose a verdict or establish a terminating membership procedure.
public struct Verdict<Elem>: Pair, Decidable {
    public typealias Left = Elem
    public typealias Right = Cell<
        Never,
        Never
    >      // a two-sided verdict
}

// ── Axes carry real, non-trivial dimensions ──
// A concrete agent whose Distance is an actual count (Three, not Never)
// and whose Alpha is an actual measured value. The §2 pins bite here.
/// This is an agent carrying real coordinates: a non-trivial witness for `HasDistance` and `HasAlpha`.
///
/// `Distance = Three` is an actual count, not the `Never` floor. `Alpha = Measured<Three>`
/// supplies the fixed-output Measurable shape at input Three. These satisfy
/// the declared axis constraints without implementing a measurement law.
public struct ConcreteAgent: HasDistance, HasAlpha {
    public typealias Sigma = Cell<
        Never,
        Never
    >
    public typealias Distance = Three                // : IntegerValued ✓
    public typealias Alpha = Measured<Three>         // : Measurable ✓
}

// Unique equates two sides and fixes their common Left projection. Never
// is one conformer, not the only nominal type with this relation. The
// existing EqualSidesWitness in Checks also conforms while remaining a
// distinct type. Candidate cardinality needs a stated support. [V=I U1–U2]
