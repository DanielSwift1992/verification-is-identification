
// ═══════════════════════════════════════════════════════
// Markers names functions on spaces, rooted in primitives.
//
// Each marker IS a function, not a tag (Law §3): the function is
// a RELATION between the sides, written as a `where`. Strip the
// `where` and opposites (Permanent/Monotone) collapse to one type.
//
// Applied to axes via `where`:
//   `where Cache: Permanent` = "Cache accumulates: after ⊇ before"
//   `where SolutionSet: Monotone` = "S shrinks: after ⊆ before"
//
// Never satisfies all markers: the fixpoint IS
// the endpoint of every function.
// ═══════════════════════════════════════════════════════

/// This is convergence to one: all distinctions resolve. `|S| = 1`.
///
/// The fixpoint of elimination, shrunk by ``Monotone`` to a point at
/// ``Null``. An intersect of the two, not a rename of either. [V=I R4]
///
/// > Note: This is what verification delivers: a solution set of size one.
/// > Identification *is* this collapse. ``IdentityCollapse`` names the same point
/// > from the solution-set side.
public protocol Unique: Monotone, Null {}

/// This is accumulation: after ⊇ before. It only grows.
///
/// `Right` unfolds to contain `Left`: `Right = (Left, delta)`, so the later
/// state holds the earlier whole plus an increment. The relation, not a tag:
/// strip the `where` and ``Permanent`` collapses into its mirror ``Monotone``. [V=I I3]
public protocol Permanent: Pair
where Right: Pair, Right.Left == Left {}

/// This is elimination: after ⊆ before. Shrinks toward ``Null``. Mirror of ``Permanent``.
///
/// `Left` unfolds to contain `Right`: `Left = (Right, removed)`, so the earlier
/// state holds the later whole plus what was dropped. Verification runs this way:
/// each `COMPARE` peels a candidate off until one survives. [V=I §5.22]
public protocol Monotone: Pair
where Left: Pair, Left.Left == Right {}

/// Decision: membership is computable, in or out, every time.
///
/// The output side branches two ways: `Right` is a `Pair`, the verdict
/// `(in \| out)`. A predicate that always halts with one of two answers. [EiF Thm 3]
public protocol Decidable: Pair
where Right: Pair {}

/// Triangle inequality holds: `d(a,c) ≤ d(a,b) + d(b,c)`.
///
/// Two legs share a midpoint: `Left = (a,b)`, `Right = (b,c)`, joined where
/// `Left.Right == Right.Left`. The shared point `b` is what makes the detour
/// cost at least the direct path: this is what makes a difference a distance. [DiC G2]
public protocol MetricProperty: Pair
where Left: Pair, Right: Pair, Left.Right == Right.Left {}

/// Distance takes integer values only. Discretization carries the continuous
/// onto the lattice.
///
/// A chain: the predecessor `Right` is again a count, and the floor is ``Null``
/// (zero). Every value presses down to that floor in finitely many unit steps,
/// so distance is a count of steps, a cost. [DiC G2c]
public protocol IntegerValued: Pair
where Right: IntegerValued {}

/// This is computable from structure alone: input maps to one determined value.
///
/// The output side settles: `Right` is ``Null``, collapsed to a point. One
/// input, one answer, fixed by the structure. [EiF C3]
public protocol Measurable: Pair
where Right: Null {}

// Never IS the fixpoint of all functions: every relation holds when
// both sides are Never (Left == Right == Never). Monotone and Null
// arrive via Unique (Unique: Monotone, Null), so they are not relisted:
// - Unique (Monotone ∩ Null): Left: Pair ✓, Left.Left == Right ✓, Never == Never ✓
// - Permanent:       Right=Never: Pair ✓, Right.Left == Left  (Never == Never) ✓
// - Decidable:       Right=Never: Pair ✓
// - MetricProperty:  Left.Right == Right.Left (Never == Never) ✓
// - IntegerValued:   Right=Never: IntegerValued ✓ (Never is zero)
// - Measurable:      Right=Never: Null ✓
extension Never: Unique, Permanent, Decidable,
    MetricProperty, IntegerValued, Measurable {}

// ═══════════════════════════════════════════════════════
// Axes are degrees of freedom that theorems constrain.
//
// Each `associatedtype` = one free dimension = EXPAND.
// Each `where` on a theory protocol = COMPRESS.
//
// Inheritance among axes reflects containment:
//   Solutions, Library, Cache, Distance, Encoding ⊂ Σ
//   Basis ⊂ Library
//   SaturatedLibrary is the fixpoint of Library
//   Alpha is computed from Distance
// ═══════════════════════════════════════════════════════

/// This is Σ: the space of all structures. The root axis every other axis sits inside.
///
/// Σ is the one free dimension everything else is carved from: solutions,
/// library, cache, distance, and encoding are all sub-spaces of it.
public protocol HasSigma {
    associatedtype Sigma
}

/// This names the solution set: the candidates that survive verification.
///
/// A sub-space of ``HasSigma``. Verification shrinks it. ``IdentityCollapse`` pins it
/// to what identification finds, and ``Unique`` is the case where it holds one.
public protocol HasSolutions: HasSigma {
    associatedtype SolutionSet
}

/// This names the library: accumulated certified knowledge. A sub-space of ``HasSigma``.
///
/// It only grows: entries are certified once and kept. Its generating set is
/// ``HasBasis`` and its fixpoint is ``HasSaturation``.
public protocol HasLibrary: HasSigma {
    associatedtype Library
}

/// This names the comparison cache: every `COMPARE` result, recorded. A sub-space of ``HasSigma``.
///
/// Results are permanent once written, so the cache only accumulates. Each
/// comparison is paid once.
public protocol HasCache: HasSigma {
    associatedtype Cache
}

/// This gives distances between structures in Σ. A sub-space of ``HasSigma``.
///
/// Pinned to a finite count (§2): `Distance` is ``IntegerValued``, a chain of
/// unit steps, and a chain of steps is a cost. The pin is placed on the axis so
/// every downstream theorem inherits it. [DiC G2c]
public protocol HasDistance: HasSigma {
    associatedtype Distance: IntegerValued
}

/// This names the encoding: the agent's perspective on the target. A sub-space of ``HasSigma``.
///
/// Perspective is a choice of encoding, and the encoding fixes what is reachable:
/// it bounds the scope of every search the agent can run.
public protocol HasEncoding: HasSigma {
    associatedtype Encoding
}

/// This gives α, the alignment coefficient, computed from distance: `α = f(W)`.
///
/// The dependency rides on ``HasDistance``. Swift can't type `f`, so `Alpha` is
/// pinned to ``Measurable`` instead: it settles to one computed value (§2). The
/// pin captures the determinacy of α without naming the function. [GA]
public protocol HasAlpha: HasDistance {
    associatedtype Alpha: Measurable
}

/// This names the basis of the library: its generating set. A sub-space of ``HasLibrary``.
///
/// Its finiteness is a result, proven by ``BasisIsFinite``, not a definition,
/// so the axis opens bare here and the constraint lands in the theorem (§2
/// placement: axes stay free, theorems compress). [IiI §3]
public protocol HasBasis: HasLibrary {
    associatedtype Basis
}

/// The saturated library: the fixed point ``HasLibrary`` grows toward.
///
/// A free axis until IiI §3 compresses it with `where Library == SaturatedLibrary`,
/// the moment growth stops adding anything new. ``LibrarySaturates`` is that
/// theorem.
public protocol HasSaturation: HasLibrary {
    associatedtype SaturatedLibrary
}

// ═══════════════════════════════════════════════════════
// V=I at the type level.
//
// Theorem 2 is Null applied to the solution set:
//   Left (what verification examines)
//   == SolutionSet
//   == Right (what identification finds).
//
// Three free axes collapsed to one. The compiler
// checking this conformance IS the V=I loop.
// ═══════════════════════════════════════════════════════

/// Verification is identification: the theorem, at the type level.
///
/// ``Null`` applied to the solution set: `Left` (what verification examines)
/// `== SolutionSet == Right` (what identification finds). Three free axes
/// collapsed to one. [V=I Thm 2]
///
/// > Important: The compiler checking this conformance *is* the V=I loop. When
/// > the constraint holds, verification and identification have been proven the
/// > same act, and ``Unique`` is the point they meet.
public protocol IdentityCollapse: Null, HasSolutions
where Left == SolutionSet {}
