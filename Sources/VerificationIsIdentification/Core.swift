
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

/// A fixed point of the addressed elimination relation. The two sides
/// agree at a type T whose own Left is T: Left == Right and Left.Left == Left.
/// This constrains projections, not the cardinality of a candidate domain.
/// Multiple nominal conformers can satisfy it. Relating this coordinate
/// to R4 requires an explicit candidate interpretation. [V=I U1–U2]
public protocol Unique: Monotone, Null {}

/// This is accumulation: after ⊇ before. It only grows.
///
/// `Right` unfolds to contain `Left`: `Right = (Left, delta)`, so the later
/// state contains the earlier whole plus an increment. The relation, not a tag:
/// strip the `where` and ``Permanent`` collapses into its mirror ``Monotone``. [V=I I3]
/// The represented object must be specified: retaining a history representation
/// does not establish recovery from its current-state projection. Nor does
/// this relation supply an internal instrument that reads the retained axis.
/// Matter M50 separates these obligations within the same whole.
/// Recoverable rearrangement can instead be expressed by ``ReadingFactors``
/// without this literal append layout. M54 derives joint recovery from a
/// complete set of local temporal witnesses.
/// Strict growth additionally needs a well-founded record interpretation.
/// M55 exhibits an admitted recursive record with equal endpoints.
public protocol Permanent: Pair
where Right: Pair, Right.Left == Left {}

/// The earlier shape contains the later shape together with a remainder.
///
/// `Left.Left == Right` mirrors ``Permanent``. For a fixed game, sound
/// retained constraints from its examples shrink the interpreted working
/// set or leave it unchanged. The exact solution set remains fixed.
/// A singleton conclusion needs a witness over the declared candidate domain.
/// [V=I §5.22] [V=I U1–U2]
public protocol Monotone: Pair
where Left: Pair, Left.Left == Right {}

/// A paired output shape used for a decision interface. [EiF Thm 3]
///
/// The checked constraint supplies `Right: Pair`. It does not restrict that
/// pair to two verdicts or establish a terminating membership procedure.
/// Those properties require the actual reading law and its declared domain.
public protocol Decidable: Pair
where Right: Pair {}

/// Two addressed legs share one endpoint. [DiC G2]
///
/// `Left = (a,b)` and `Right = (b,c)` are joined by their common b.
/// This protocol has no distance values, addition or ordering relation.
/// The triangle inequality belongs to G2's specified symmetric-difference
/// metric. This endpoint constraint proves neither that inequality nor equal legs.
public protocol MetricProperty: Pair
where Left: Pair, Right: Pair, Left.Right == Right.Left {}

/// A recursive Right axis. A finite expression in the specified Never/Succ
/// grammar can interpret it as a unary count. This open protocol itself
/// supplies no terminal, unit-step constraint on Left, or finite depth.
/// CyclicNumeral in Checks/FiniteBoundary.swift is an admitted cycle. [EiF EF10]
public protocol IntegerValued: Pair
where Right: IntegerValued {}

/// The output carries equality of its two addressed sides: Right is Null.
/// This constrains one represented result. It supplies neither a reading
/// law from Left nor agreement between separate results with the same input.
/// Actual application constructors must establish that dependence. [EiF EF10]
public protocol Measurable: Pair
where Right: Null {}

// Never IS the fixpoint of all functions: every relation is true when
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

/// This is Σ: the space of all structures. The root axis every other axis is inside.
///
/// Σ is the one free dimension everything else is carved from: solutions,
/// library, cache, distance, and encoding are all sub-spaces of it.
public protocol HasSigma {
    associatedtype Sigma
}

/// This names the solution set: the candidates that survive verification.
///
/// A coordinate beside ``HasSigma``. Its representation must specify what
/// counts as a candidate and as membership. ``Unique`` constrains this type's
/// projections, so a singleton interpretation needs additional support. [V=I U1]
public protocol HasSolutions: HasSigma {
    associatedtype SolutionSet
}

/// This names the library coordinate for accumulated certified knowledge.
///
/// The application supplies a representation of entries in `Sigma` and a
/// sound retaining update. ``HasBasis`` and ``HasSaturation`` name the
/// generating-set and fixed-point coordinates. Conditional saturation requires
/// a common finite rule interpretation and eventual solution and insertion
/// of every class. [IiI §2–§3] [V=I §5.26 CS1]
public protocol HasLibrary: HasSigma {
    associatedtype Library
}

/// This names the coordinate for recorded comparison answers.
///
/// The application supplies `Cache`'s record representation and access law.
/// Retained sound answers serve later comparisons under CS2's key coverage
/// and selection premises. [V=I §5.26 CS2]
public protocol HasCache: HasSigma {
    associatedtype Cache
}

/// This names the coordinate used for a structural distance count.
///
/// ``IntegerValued`` gives `Distance` a recursive Right axis. Finite
/// `Never`/`Succ` constructions give a unary count under their stated
/// interpretation. The application's reading relates that count to edit
/// distance, with physical cost assumptions stated separately. [DiC G2c] [EiF EF10]
public protocol HasDistance: HasSigma {
    associatedtype Distance: IntegerValued
}

/// This names the encoding: the agent's perspective on the target. A sub-space of ``HasSigma``.
///
/// Perspective is a choice of encoding, and the encoding fixes what is reachable:
/// it bounds the scope of every search the agent can run.
/// A declaration certificate applies to behavior through an established
/// relation to its implementation. This coordinate alone supplies no such
/// relation or acquisition. [SiG SG3]
public protocol HasEncoding: HasSigma {
    associatedtype Encoding
}

/// This names the alignment result alongside the distance coordinate.
///
/// ``Measurable`` requires `Alpha` to have a ``Null`` output, whose two sides
/// agree. The application constructs the reading that relates this result
/// to distance, loss and the sampled region. [GA] [EiF EF10]
public protocol HasAlpha: HasDistance {
    associatedtype Alpha: Measurable
}

/// This names the coordinate for a library's generating set.
///
/// ``BasisIsFinite`` constrains `Basis: IntegerValued`, a recursive Right axis.
/// The application must relate it to a generating set of the library.
/// Finite generation and termination of a basis search need their own
/// witnesses. [IiI §3] [EiF EF10] [Basis B6–B8] [Law §2]
public protocol HasBasis: HasLibrary {
    associatedtype Basis
}

/// This names the library's fixed-point coordinate.
///
/// ``LibrarySaturates`` states `Library == SaturatedLibrary` with
/// `Library: Permanent`. For a common finite rule domain, sound retaining
/// insertions give full class coverage when every class is eventually solved
/// and inserted. Full coverage permits different raw entries.
/// [IiI §3] [V=I §5.26 CS1]
public protocol HasSaturation: HasLibrary {
    associatedtype SaturatedLibrary
}

// ═══════════════════════════════════════════════════════
// V=I at the type level.
//
// This interface equates Left == SolutionSet == Right.
//
// The compiler checks these axes. Theorem 2 additionally needs
// membership, a singleton interpretation and target adequacy.
// ═══════════════════════════════════════════════════════

/// Identifies three represented axes: Left == SolutionSet == Right.
/// The compiler verifies those equalities. They do not themselves bind a
/// passing candidate, its membership evidence or the intended target to
/// these axes. Theorem 2 needs those premises and a singleton domain. [V=I U2]
public protocol IdentityCollapse: Null, HasSolutions
where Left == SolutionSet {}
