import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// WITNESSES — concrete inhabitants that make the proof bite.
//
// Never is the TRIVIAL fixpoint: every marker holds there because
// Left == Right == Never. The types below are NON-trivial — they
// satisfy the marker relations with distinct sides — yet every one of
// them presses down to Never as its floor (the §4 base case, the zero).
//
// The compiler checking these conformances IS the verification that
// the theory has real models, not only the empty one. Break a marker
// relation and its witness stops compiling.
// ═══════════════════════════════════════════════════════════════

/// The raw act of distinction with two named sides: a reusable `Pair`.
///
/// The building block every other witness is assembled from: ``Grew``, ``Shrank``,
/// ``Path``, and ``Verdict`` all package their sides as a `Cell`.
public struct Cell<L, R>: Pair {
    public typealias Left = L
    public typealias Right = R
}

// ── IntegerValued: the Peano chain, floored at Never (zero) ──
// Never is 0. Succ<N> is n+1 — its predecessor Right = N is again a
// count. Every number presses down to Never: this IS finite depth (§4).
/// The successor: `n+1` as a non-trivial witness for `IntegerValued`.
///
/// `Succ<N>` is one step above its predecessor `N`. The chain bottoms out at
/// `Never` (zero, aliased ``Zero``). ``Three`` is `Succ<Succ<Succ<Never>>>`.
/// Every count presses down to the floor in finitely many steps — finite depth, made concrete.
public struct Succ<N: IntegerValued>: Pair, IntegerValued {
    public typealias Left = Never        // the unit step
    public typealias Right = N           // the predecessor — a smaller count
}
/// Zero: the floor of the count, which is `Never`. The base case every ``Succ`` chain ends at.
public typealias Zero = Never
/// Three: `Succ<Succ<Succ<Never>>>`. A worked count three steps above ``Zero``.
public typealias Three = Succ<Succ<Succ<Never>>>

// ── Permanent: accumulation. after = (before, delta), Left ≠ Right ──
/// Accumulation made concrete: a non-trivial witness for `Permanent`.
///
/// The after-state `Right = Cell<Before, Delta>` holds the whole before-state
/// plus an increment, so `Right.Left == Before`. Distinct sides, real growth —
/// not the trivial `Never` fixpoint.
public struct Grew<Before, Delta>: Pair, Permanent {
    public typealias Left = Before
    public typealias Right = Cell<Before, Delta>     // Right.Left == Left ✓
}

// ── Monotone: elimination. before = (after, removed). Permanent's mirror ──
/// Elimination made concrete: a non-trivial witness for `Monotone`.
///
/// The before-state `Left = Cell<After, Removed>` holds the after-state plus what
/// was dropped, so `Left.Left == After`. The mirror of ``Grew``: same `Cell`, sides flipped.
public struct Shrank<After, Removed>: Pair, Monotone {
    public typealias Left = Cell<After, Removed>     // Left.Left == Right ✓
    public typealias Right = After
}

// ── MetricProperty: two legs (a→b)(b→c) sharing the midpoint b ──
/// Two legs through a shared midpoint: a non-trivial witness for `MetricProperty`.
///
/// `Left = Cell<A, B>` and `Right = Cell<B, C>` meet at `B`, so
/// `Left.Right == Right.Left == B`. The shared point is what forces the triangle inequality.
public struct Path<A, B, C>: Pair, MetricProperty {
    public typealias Left = Cell<A, B>
    public typealias Right = Cell<B, C>              // Left.Right == Right.Left == B ✓
}

// ── Measurable: settles to one value (Right is Null) ──
/// One input, one settled value: a non-trivial witness for `Measurable`.
///
/// `Left = Input` varies. `Right = Never` is `Null`, the determined value
/// collapsed to a point. The structure fixes the answer with no room for choice.
public struct Measured<Input>: Pair, Measurable {
    public typealias Left = Input
    public typealias Right = Never                   // the determined value, collapsed
}

// ── Decidable: the verdict branches two ways (in | out) ──
/// A two-way verdict on an element: a non-trivial witness for `Decidable`.
///
/// `Left = Elem` is the element under test. `Right = Cell<Never, Never>` is the
/// `Pair` that branches `(in \| out)`. Membership always resolves to one side.
public struct Verdict<Elem>: Pair, Decidable {
    public typealias Left = Elem
    public typealias Right = Cell<Never, Never>      // a two-sided verdict
}

// ── Axes carry real, non-trivial dimensions ──
// A concrete agent whose Distance is an actual count (Three, not Never)
// and whose Alpha is an actual measured value. The §2 pins bite here.
/// An agent carrying real coordinates: a non-trivial witness for `HasDistance` and `HasAlpha`.
///
/// `Distance = Three` is an actual count, not the `Never` floor. `Alpha = Measured<Three>`
/// is an actual settled value. The §2 axis pins (`IntegerValued`, `Measurable`) bite here,
/// proving the axes have models with genuine dimension.
public struct ConcreteAgent: HasDistance, HasAlpha {
    public typealias Sigma = Cell<Never, Never>
    public typealias Distance = Three                // : IntegerValued ✓
    public typealias Alpha = Measured<Three>         // : Measurable ✓
}

// Unique needs no non-trivial witness: convergence to ONE is exactly
// the collapse to a single point — Never is its only inhabitant. The
// branching markers (Permanent, Decidable, Metric…) have rich models;
// the one that converges has just the fixpoint. That asymmetry is real:
// distinction has many shapes, agreement has one.
