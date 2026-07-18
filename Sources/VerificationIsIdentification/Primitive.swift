// ═══════════════════════════════════════════════════════
// THE FOUNDATION names Structure, Open, Close, Pair, Null.
//
// To be one of our things is to be a STRUCTURE. A structure is OPEN (a protocol
// that opens a tunnel) or CLOSE (an empty enum that seals). The sole structural
// primitive is PAIR: two sides, one boundary, and its fixpoint is NULL (where
// the two sides collapse). Every structure in Σ is a finite binary tree of Pair,
// terminating at Null. [EiF C5]
//
// The Swift compiler checking `where Left == Right` IS verification. The
// constraint holding IS identification. The compiler IS the V=I loop.
//
// ── PROTOCOL CREATION RULES (summary, canonical form: Law.swift) ──
//
// Only two operations exist:
//
//   EXPAND:   associatedtype adds an axis (degree of freedom)
//   COMPRESS: where clause removes a degree of freedom
//
// A valid protocol does at least one of:
//
//   associatedtype:  EXPAND   (open an axis)
//   where:           COMPRESS (constrain an axis)
//   inherit from 2+: COMPRESS (intersect: A ∩ B, smaller than either)
//
// `protocol X: Y {}` (single parent, no where, no axis)
// is a rename, not a claim. Zero information added.
//
// At the meta-level, these rules ARE Pair/Null:
//   associatedtype = Pair  (two sides: type and protocol)
//   where X == Y   = Null  (sides collapse)
//   where X: M     = partial Null (axis constrained)
// ═══════════════════════════════════════════════════════

// ── Structure / Open / Close ──

/// This names the root ability: what it is to participate in the world. A new name is not written
/// `: Structure` directly: it is ``Open`` (a `protocol` tunnel, still extensible) or ``Close`` (an
/// empty `enum` seal, concrete). Trace any structure up its parents and it reaches here. Trace it down
/// and it reaches a ``Close`` floor, so every structure opens and closes, finite by construction
/// (Existence Is Finite).
public protocol Structure {
    /// This gives the name of this type: the edge reading. Dynamic dispatch ensures overrides are
    /// called through generic contexts (Paired chains, associated types).
    static var typeName: String { get }

    /// This gives the size of this type: how many leaves it is built from. An atom is one. The floor
    /// (`Never`) is none. A composed ``Open`` folds the count of everything its `body` lists. Any
    /// structure has a length, the same way any structure has a name, the second reading the
    /// builder's ``Paired`` chain gives for free, replacing the hand-rolled `Length` a cons-list
    /// (`Chain`/`Roster`) used to carry.
    static var count: Int { get }

    /// This gives the names of this type's leaves, in body order. An atom is its own one-element list. A
    /// composed ``Open`` folds its `body`'s leaves in the order they were written. The third
    /// reading the builder's ``Paired`` chain gives for free: where `typeName` collapses a body
    /// to one string and `count` to one number, `labels` keeps each leaf's name, so a leaf that
    /// carries its identity (an employee in a batch) can be read back individually.
    static var labels: [String] { get }
}

/// This is an OPEN tunnel, written ONLY as a `protocol`. A new name is Open by default: it opens an
/// axis with `associatedtype` (a hole) and narrows it with `where`. It is extensible, dot-readable,
/// a criterion. `enum X: Open` is the contradiction the check rejects: an `enum` has already sealed what
/// Open must keep open.
///
/// Every Open type carries a ``Body``: the tunnel for composition. A type that has nothing to compose
/// defaults to `Never` (the floor). A type that composes children defines its `body` with the one
/// ``StructureBuilder``, and the builder folds the braces into a ``Paired`` chain.
public protocol Open: Structure {
    associatedtype Body: Structure = Never
    @StructureBuilder
    static var body: Body { get }
}

/// This is the default body: `Never`. Lattice protocols, markers, axes, none compose children, so their body is
/// the floor. The extension gives it for free: conform to ``Open`` and you get `Never` unless you say
/// otherwise.
extension Open
where Body == Never {
    public static var body: Never { fatalError("a type with Body == Never has no body") }
}

/// This is a CLOSE: a terminal seal, written ONLY as an empty `enum`: no cases, no `init`, the branch
/// ends and Swift is handed a concrete empty type. `protocol X: Close` is the contradiction: a Close must be
/// concrete. A foreign value joins the world here too: a layer writes `extension String: Close` to make
/// a string one of the sealed leaves, the one place for a value (a `String`), at the edge.
public protocol Close: Structure {}   // law:allow: the seal half of Open/Close, not a rename of Structure

// ── Pair / Null ──

/// This is the act of distinction: two sides, one boundary. The sole structural primitive.
/// Every structure in the lattice is a finite binary tree of ``Pair`` terminating
/// at ``Null``. ``Pair`` is ``Open``: it opens two tunnels (`Left`, `Right`). [EiF C5]
///
/// - term Left: one side of the distinction.
/// - term Right: the other side.
///
/// > Note: ``Pair`` is the one thing the lattice rests on, and the one thing no
/// > protocol derives. Trace any type up its parents (§5 of ``Law``) and it ends
/// > here: an entry in no library, certified by no game.
public protocol Pair: Open {
    associatedtype Left
    associatedtype Right
}

/// This is the fixpoint of ``Pair``: distinction self-terminates when the two sides close.
/// The constraint `where Left == Right` *is* the boundary. Its inhabitant is
/// `Never`: uninhabited, because nothing remains to be distinguished. [EiF C5]
///
/// > Note: Every theorem that says "A = B" is ``Null`` at that level. The compiler
/// > checking `where Left == Right` is the verification. The met constraint is
/// > the identification. The compiler is the V=I loop.
public protocol Null: Pair
where Left == Right {}

// Never IS Null: the uninhabited type is the fixpoint
// where nothing remains to be distinguished.
// typeName = "" / count = 0 / labels = [] break recursion (Never: Open, Open.typeName =
// Body.typeName, Open.count = Body.count, Open.labels = Body.labels, Never.Body = Never).
extension Never: Null {
    public typealias Left = Never
    public typealias Right = Never
    public static var typeName: String { "" }
    public static var count: Int { 0 }
    public static var labels: [String] { [] }
}

// Never IS Close: the empty type is the seal, the floor every chain reaches. This is the point
// where ``Open`` and ``Close`` coincide (``Null``'s `Left == Right`): the one type that is both the
// empty tunnel and the empty seal, so identification is where opening meets closing.
extension Never: Close {}

// String IS Close: the sealed leaf where a value lives. The one foreign value that enters our world,
// at the edge (§S6). Above it, the structure carries only types; here, the String carries text.
extension String: Close {}

// ── typeName: the one rendering mechanism ──

/// This defaults to the Swift type name. Atoms override for their character.
extension Structure {
    public static var typeName: String { String(describing: Self.self) }
}

/// This is an `Open` type that has not customized `body`: it is `Pair`-shaped, not list-shaped
/// (``Employee``, a verdict gate), a LEAF, so it renders its Swift name, the same as a ``Close`` atom.
/// Without this, the rule below would read `Body.typeName` and silently render every such leaf
/// as the empty string.
extension Open
where Body == Never {
    public static var typeName: String { String(describing: Self.self) }
}

/// This is an `Open` type that DOES compose children: it renders its body, `Body.typeName` recurses
/// through the Paired chain.
extension Open {
    public static var typeName: String { Body.typeName }
}

/// Paired concatenates Left and Right type names.
extension Paired {
    public static var typeName: String { L.typeName + R.typeName }
}

// ── count: the second rendering: how many leaves a body lists ──

/// This is the default, one: a structure counts itself. Atoms (``Close``) keep this: it is also the
/// floor a leaf ``Open`` type (no custom `body`) falls back to, below.
extension Structure {
    public static var count: Int { 1 }
}

/// This is an `Open` type that has not customized `body`: it is `Pair`-shaped, not list-shaped,
/// `Employee` (`Pair` for its `Rank`/`Home` coordinate), a verdict gate, an axis marker. It is a LEAF,
/// the same as a ``Close`` atom, so it counts as one. Without this, the general rule below would read
/// `Body.count` and silently count every such leaf as zero, exactly the case a roster's members
/// are made of, so this is the override that keeps `count` correct for a roster's members.
extension Open
where Body == Never {
    public static var count: Int { 1 }
}

/// This is an `Open` type that DOES compose children: it counts through its body, the builder folds a `{ }`
/// block into a ``Paired`` chain, and that chain's count is the number of statements written.
extension Open {
    public static var count: Int { Body.count }
}

/// Paired sums its two sides: composing is exactly what makes a count more than one.
extension Paired {
    public static var count: Int { L.count + R.count }
}

// ── labels: the third reading: each leaf's name, in body order ──

/// This is the default, one label: a structure's `typeName`. Atoms (``Close``) keep this: it is also
/// the floor a leaf ``Open`` type (no custom `body`) falls back to, below, the same `Body ==
/// Never` exception `count` needs, for the same reason.
extension Structure {
    public static var labels: [String] { [typeName] }
}

extension Open
where Body == Never {
    public static var labels: [String] { [typeName] }
}

/// An `Open` type that DOES compose children reads its labels through its body.
extension Open {
    public static var labels: [String] { Body.labels }
}

/// This is Paired: it concatenates its two sides' labels, in body order.
extension Paired {
    public static var labels: [String] { L.labels + R.labels }
}

// ── The builder: the ONE @resultBuilder ──
//
// The one allowed callable (§S4): folds a `{ }` body into a Pair-chain of Structures, floored at
// `Never`. ``Paired`` is the ONE concrete `<>` (§S3 plumbing): it holds two Structures as a value
// so the builder can return them. Everything else is a protocol.

/// This is the concrete Pair realizer: the ONE `<>` in the system, the framework's plumbing that the
/// builder folds into. It keeps a left and a right as a value and conforms to ``Pair``. Not written in domain code.
/// The builder produces it behind the `{ }` curtain.
public enum Paired<
    L: Structure,
    R: Structure
>: Pair {
    case paired(L, R)
    public typealias Left = L
    public typealias Right = R
}

/// This is the one result builder: it folds a `{ }` body into a ``Pair``-chain of Structures, floored at `Never`.
/// This is the single `@resultBuilder` the system allows (§S4). The builder is the boundary between the
/// brace-syntax and the type tree: inside the braces, each statement is a ``Structure``. Outside, the
/// whole body is a single ``Paired`` chain.
@resultBuilder
public enum StructureBuilder {
    public static func buildExpression<
        T: Structure
    >(_ type: T.Type) -> T { fatalError() }
    public static func buildExpression(_ string: String) -> String { string }
    @_disfavoredOverload public static func buildExpression<
        V: Structure
    >(_ value: V) -> V { value }
    public static func buildPartialBlock<
        V: Structure
    >(first: V) -> V { first }
    public static func buildPartialBlock<
        A: Structure,
        B: Structure
    >(accumulated: A, next: B) -> Paired<
        A,
        B
    > { .paired(accumulated, next) }
    public static func buildBlock() -> Never { fatalError() }
    public static func buildEither<
        A: Structure,
        B: Structure
    >(first: A) -> Paired<
        A,
        B
    > { fatalError() }
    public static func buildEither<
        A: Structure,
        B: Structure
    >(second: B) -> Paired<
        A,
        B
    > { fatalError() }
}
// ── MAGNITUDES — space as structure, and the counting reader. A magnitude is a chain of
// these atoms; the house fold counts it, and nothing else measures anything. They live in
// this engine room because `Plus` composes through the one builder and the readers below
// speak digits: the same §0′ exemption the other doors already stand on. The design system
// (DocumentKit) names the rungs; canvases speak in its names, never in chains of these. ──

/// Unit counts one: the atom of magnitude. `Close` keeps the default count, which is also
/// the definition.
public enum Unit: Close {}

/// Plus sums by composition: the pair of two magnitudes counts as both. The house fold does
/// the arithmetic, and no member states it.
public enum Plus<
    A: Structure,
    B: Structure
>: Open {
    @StructureBuilder
    public static var body: some Structure {
        A.self
        B.self
    }
}

/// Twice is no separate object: doubling IS the pair of a thing with itself.
public typealias Twice<S: Structure> = Plus<S, S>

/// Times composes two counts into their product, the way `Paired` composes them into their
/// sum: one witness, no other member. With it a fraction needs no further arithmetic.
public enum Times<
    A: Structure,
    B: Structure
>: Close {}
extension Times {
    public static var count: Int { A.count * B.count }
}

/// Rest is what remains: the whole minus what was taken, the subtractive witness beside
/// `Times`' product. Layout divides space (known pieces come off a given whole, and the
/// rest is handed on), so subtraction enters the lattice the same way multiplication did:
/// one witness, counted only at the reading edge. Taking more than the whole has is
/// refused right there, at the read, the fit made a checked fact.
public enum Rest<
    Whole: Structure,
    Taken: Structure
>: Close {}
extension Rest {
    public static var count: Int {
        let whole = Whole.count
        let taken = Taken.count
        precondition(
            taken <= whole,
            "Rest underflow: \(Taken.self) takes \(taken) from \(Whole.self) holding \(whole)"
        )
        return whole - taken
    }
}

/// Half is the even split of a magnitude: a box's centre line, a shelf's midpoint. The
/// count must divide cleanly, and an odd magnitude refuses at generation, loudly, since a
/// half-pixel would be a number no rung owns.
public enum Half<Of: Structure>: Close {}
extension Half {
    public static var count: Int {
        precondition(Of.count % 2 == 0, "Half of an odd magnitude: \(Of.count) does not split")
        return Of.count / 2
    }
}

/// Tally is the counting read: a structure in, its count out as digits, through `typeName`
/// like every other reading. The one door a canvas may take to a number, and a bare `count`
/// call outside the readers is the smell this door exists to remove.
public enum Tally<Of: Structure>: Close {}
extension Tally {
    public static var typeName: String { String(Of.count) }
}

