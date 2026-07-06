// THE LAW names how every protocol in Σ must be written.
//
// The canonical statement is the doc-comment below: it renders as the ``Law``
// page and is the single source of truth. Primitive, Core, VI, IiI: every
// Theory file enacts it. The compiler enforces the checkable subset. `Tools
// grammar` carries §0′/§S4/§S22 per file, per scope. `Tools lint` checks the
// cross-file rest (§1 RENAME, §2 OPEN AXIS, PROVENANCE), run automatically by
// the LawCheck plugin on Organization and by hand elsewhere. What neither
// reaches is checked by review. The law is written in the thing it governs,
// it is itself Pair and Null all the way down (§6).

/// How every protocol in the lattice must be written: the grammar the whole
/// theory speaks.
///
/// Every protocol is built from one seed by one of two moves, grounded on one
/// floor, and the law that governs this is itself written in the seed it grows
/// from. The ``Law`` symbol is its anchor. The sections below are its statement.
///
/// - term Seed: one act, *distinction* (``Pair``). One fixpoint: ``Null``.
/// - term Move: two directions: *expand* (add an axis), *compress* (close one).
/// - term Floor: every space is finite: width (``Pair``) × depth (``Null``).
///
/// ## §0 · The seed and its fixpoint
///
/// The lattice grows from one act, ``Pair`` (a distinction), and closes at its
/// fixpoint ``Null``. Everything reduces to them. They are primitive here, the
/// lattice starts from them, but not arbitrary: Existence Is Finite shows they are
/// the only foundation determinacy allows, below the floor. A term that reduces to
/// neither is foreign and is rejected (§6).
///
/// - ``Pair``: one act of distinction: two sides, one boundary
///   (`associatedtype Left`, `associatedtype Right`).
/// - ``Null``: the fixpoint of ``Pair``: the boundary closes, `Left == Right`.
///   Its inhabitant is `Never`, uninhabited, nothing left to split.
///
/// ## §0′ · Pure types
///
/// The medium is the type system and nothing else. There is no runtime, no
/// values, ever. You read a fact by asking the type checker: *does `X`
/// conform? what is `X.SolutionSet`?*, not by computing a value.
///
/// > Important: A method that *returns* the claim is a value, that is runtime,
/// > and it is wrong here. The claim **is** the conformance. Reading it is the
/// > type checker's job, not a function's. That purity is the point: a type
/// > query is simple and total.
///
/// | Allowed | Forbidden |
/// | --- | --- |
/// | `protocol`, `extension` (conformance only) | `func`, `case` |
/// | `typealias`, `associatedtype` | stored or computed `var` |
/// | `where` clauses | `init`, `subscript`, `operator` |
/// | `enum` whose only members are `typealias` | `struct`, `class` (instantiable) |
///
/// ## §0″ · Concrete types
///
/// A concrete type is always an `enum`: caseless (`Close`) when it is a phantom
/// point in the lattice, or with a `Body` (`Open`) when it composes other types.
/// `struct` and `class` are forbidden: they can be instantiated.
///
/// - term `<>` lives on `enum` only. Protocols parameterize through `associatedtype`.
///   A generic parameter on a protocol would be `<>` on a protocol, impossible in Swift,
///   and the reason `associatedtype` exists.
/// - term Name over angle brackets. If a generic instantiation is used more than once,
///   give it a `typealias`. Write `Never` instead of `Cell<Never, Never>` when the
///   Pair floor suffices. Raw `<>` is allowed only when no simpler name exists.
/// - term Angles open like a tree. One bare argument stays inline (`Succ<Prev.Length>`).
///   From the second argument, or the first constraint in the list, the angles open:
///   each argument on its own line, the closing `>` on its own. The indent then shows the
///   nesting the way a `body`'s braces already do, and the brackets read as the tree they
///   spell, uniform for any eye, whatever language it came from.
/// - term Supplementary information has one home. `where` heads its own line, always,
///   after a generic list, after a conformance list, in a `for`, and so do `var` and
///   `typealias` inside a declaration. What may sit in two places gets hunted in both.
///   One home ends the hunt, and the eye lands where it expects. Modifiers (`public`,
///   `static`) are transparent: they stand before the word without taking its line. A
///   `body`'s statements keep their freedom: nobody hunts inside a body, §S7 reads it
///   whole, and packing its leaves is what keeps a long spell from becoming one-story
///   sprawl. The grammar enforces the home as a name: an atom out of place is carried as
///   `Midline` and `Midline` is granted nothing.
///
/// ## §1 · Two moves, and you must make one
///
/// ```swift
/// associatedtype Distance   // EXPAND:   open a degree of freedom
/// where X == Y              // COMPRESS: close it to a point   (→ Null)
/// where X: SomeMarker       // COMPRESS: pin it to a property  (→ partial Null)
/// protocol P: A, B          // COMPRESS: intersect, keep only what A and B share
/// ```
///
/// There is no third move. Close, pin, and intersect are all forms of compress:
/// each narrows the space. Every protocol is one or more of these two moves.
///
/// > Warning: The **rename** is forbidden: one parent, no axis, no `where`:
/// > `protocol Renamed: Parent {}` makes no move and adds nothing (`Renamed`
/// > and `Parent` are one space under two names). Test it: delete the protocol.
/// > If nothing breaks that a parent did not already guarantee, it was a rename.
/// > The linter rejects this form on every build.
///
/// ## §2 · Every axis gets a dimension
///
/// A bare `associatedtype X` is a *free* axis: dimensionless, hence infinite.
/// To give it a dimension is to constrain it with `where`. Every axis opened by
/// *expand* must be closed by *compress* in at least one protocol. Opening and
/// closing may live apart. Where a dimension is pinned carries the claim's
/// **status**:
///
/// - term Inline (`associatedtype X: M`): *definitional*, true by what `X` is.
///   It opens and dimensions in one act.
/// - term Theorem (`where X: M`): *derived*, proven to hold under the dynamics,
///   in the protocol that earns it.
///
/// Pinning a derived property inline collapses its theorem into an axiom. So the
/// *absence* of an inline pin is itself a claim: "proven here, not assumed."
///
/// > Tip: **The placement test.** A constraint is definitional (inline) if no
/// > valid inhabitant of the axis *could* violate it, it cuts only the
/// > impossible. It is derived (theorem) if a valid inhabitant *could* violate
/// > it and the dynamics prove it does not. `Law: Pair` (every law is a
/// > structure) → inline. `Cache: Permanent` (a cache could be mutable, I3
/// > forbids it) → theorem.
///
/// ## §3 · A function is expressed, never tagged
///
/// A marker names a function on a space, and a function is a ``Pair`` whose two
/// sides are *related*: the relation **is** the function, written as a `where`.
/// A marker with an empty body is a tag: a rename of ``Pair``, forbidden.
/// ``Permanent`` and ``Monotone`` are mirror images, and the `where` is the only
/// thing that tells them apart:
///
/// ```swift
/// protocol Permanent: Pair where Right: Pair, Right.Left == Left {}  // after ⊇ before
/// protocol Monotone:  Pair where Left: Pair,  Left.Left  == Right {} // after ⊆ before
/// ```
///
/// Strip the `where` and the two opposites collapse to the same empty type.
///
/// > Tip: **Parent or pin.** A marker attaches two ways, and the choice is itself a
/// > claim. Make it a *parent* (`protocol P: Decidable`) when the protocol itself is
/// > that thing: P *is* the decision, the measurement. Make it a *pin*
/// > (`where Axis: Decidable`) when P itself is not, but one of its axes is. The
/// > test: does the marker describe the protocol's own ``Pair``, or one of its axes?
///
/// ## §4 · Finite = width × depth
///
/// Finite means both are bounded, not just one. Width is bounded by the shape
/// itself: a ``Pair`` has exactly two sides, never infinitely many. Depth is
/// bounded because every ``Pair``-chain has to reach `Never`, the floor where it
/// stops. An infinite structure never reaches a floor, so the compiler has no type
/// for it. Drop the floor and you have the infinite binary tree. Drop ``Pair`` and
/// you have a node with infinitely many children. Both must close.
///
/// ## §5 · Nothing floats
///
/// Trace any protocol up its parents: it must reach ``Pair``. Trace any structure
/// down: it must reach ``Null``. Markers root in ``Pair`` or ``Null``. Axes root
/// in the one space-root ``HasSigma``. Theorems root in markers and axes. A
/// protocol that reaches neither is rejected.
///
/// ## §6 · The law obeys the law
///
/// The law is written in ``Pair`` and ``Null``:
///
/// | Construct | Reading |
/// | --- | --- |
/// | `associatedtype` | ``Pair``, two sides: the name and its protocol |
/// | `where X == Y` | ``Null``, the two sides close |
/// | `where X: M` | partial ``Null``, the side is pinned |
///
/// Even the two moves are a ``Pair`` (expand or compress) whose ``Null`` is
/// "no net change": the forbidden rename of §1. The test for any *new* rule:
/// state it in ``Pair``/``Null``. If it cannot be said in those terms, it is
/// foreign, do not add it.
///
/// ## §T · Translation: any theorem → types
///
/// The algorithm that turns a published theorem into a protocol. A theorem is
/// *premises ⟹ conclusion*. Fill four slots, then render.
///
/// | Slot | Becomes |
/// | --- | --- |
/// | **quantities**: what it is about | one axis each (`associatedtype`), pinned by a marker |
/// | **premises**: what it assumes | parent protocols (intersect) |
/// | **conclusion**: what it proves | a `where` pinning the fixpoint where the freedom collapses |
/// | **move**: at least one, per §1 | expand / compress (close, pin, or intersect) |
///
/// > Important: The conclusion is **mandatory**. A theorem without its
/// > conclusion-fixpoint is only its premises, the trap that once left two of
/// > Verification Is Identification's theorems half-stated. Worked example: ``AtomBasis`` pins
/// > `where CompositionalNorm == Distance`, the equation that *is* "an atom is
/// > where the two norms coincide."
///
/// How a freedom stands to its collapse picks the marker:
///
/// | Marker | The freedom… |
/// | --- | --- |
/// | ``Unique`` / ``Null`` | is *at* the fixpoint (`Left == Right`) |
/// | ``Monotone`` | shrinks *to* it (toward ``Null``) |
/// | ``Permanent`` | grows *from* it (accumulating) |
/// | ``Measurable`` | resolves to one point (a determined value) |
/// | ``Decidable`` | forks: two fixpoints (in \| out) |
/// | ``IntegerValued`` | a ladder of fixpoints (Peano, floored at ``Null``) |
/// | ``MetricProperty`` | a path *between* two (through a shared midpoint) |
///
/// Coverage is full exactly when every quantity is pinned, premises are parents,
/// the conclusion-fixpoint is present, and at least one move is made. Then the
/// compiler's conformance check *is* the proof.
///
/// ## §T′ · Translation: everyday constructs → types
///
/// §T translates theorems; this table translates the constructs ordinary code
/// reaches for. Each row is exhibited in this package, not proposed. The test
/// before writing any runtime: does the construct *decide* something? Then it
/// moves into types. Does it only *carry* bytes across the world's edge? Then it
/// stays at a named door.
///
/// | Ordinary construct | Becomes | Exhibited by |
/// | --- | --- | --- |
/// | `class` / instance | an empty `enum`: the type is the value | every atom |
/// | a stored field | an `associatedtype`, pinned by conformance | `Person`'s axes |
/// | `if` on data | a conditional conformance: the branch is a `where` | `Login`, `SecretPage` |
/// | `switch` over cases | one marker protocol per case (SurfaceLaw §S25) | the scope tokens |
/// | an `\|\|` of rules | two overloads: resolution is the disjunction (§S27) | `buildExpression` pairs |
/// | a runtime validation | a constraint at a builder door | the grammar's schema |
/// | a mutable flag | a recorded fact carried as a name | `Midline`, `Declares` |
/// | a lookup table / array | a census body the reader walks | `Alphabet.lexemes` |
/// | a loop that builds | a result-builder fold | `StructureBuilder` |
/// | a string identity | `typeName`, read off the type | every rendered page |
/// | a pure function's call | a generic type applied to its argument | `Succ<N>`, `PageSlug<X>` |
///
/// What never translates: contact with the world. Reading a file, emitting a
/// file, invoking the compiler, these stay as functions, few and named, at the
/// package's doors (Play Is Proof PP15: the gate is given, not self-certified).
/// The census keeps the running count of both kinds, per target.
///
/// ## §7 · The tree obeys the law
///
/// The page that documents the lattice branches by the same move the lattice
/// makes. §6 forces it: the law lives in ``Pair`` and ``Null``, so the *tree of
/// the law* does too. Every node (a Topics group, a page, a route) earns its
/// place by the move it makes, never by a hand-picked theme (that is the §1
/// rename, read one level up).
///
/// | A node that… | is a… | and lives… |
/// | --- | --- | --- |
/// | opens an axis (`associatedtype`), axis-only lineage | generator | on the **spine**, the landing |
/// | pins one axis (`where` on one) | theorem | under that axis |
/// | intersects two or more axes | bridge | in the **web**, carried by its paper |
/// | makes no move | rename | nowhere, it is removed |
///
/// The generators are the only clean partition: a thin **spine** of axes
/// (*Basis Is Residue*, turned on the framework). The bridges are a **web**, most
/// of the lattice, and they form a *cone*: the deeper a theorem sits, the more
/// axes it weaves, until the capstones braid nearly all of them at once. A web is
/// *ordered*, not branched: premise before conclusion, by distance from the seed.
/// It is *carried*: each paper lists the bridges it proves, because a walk
/// through the lattice is itself a certified object (*Order Is Object*). Territory
/// on the landing. Routes in the papers.
///
/// > Note: This organization is *induced*, not arranged. Spine and routes are read
/// > off the types, each symbol placed by its move, and a checker holds the page
/// > equal to what the types dictate, as the linter holds every protocol to §1. The
/// > tree is ``Pair`` and ``Null`` all the way up, as a protocol is all the way down.
public enum Law {}
