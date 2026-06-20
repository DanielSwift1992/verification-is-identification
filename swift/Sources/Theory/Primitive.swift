// ═══════════════════════════════════════════════════════
// §2.5 Unity — One act of distinction.
//
// PAIR is the sole structural primitive.
// NULL is its fixpoint: where Left == Right.
//
// Every structure in Σ is a finite binary tree of Pair,
// terminating at Null. The meta-pattern of the theory:
// every theorem that says "A = B" is Null at that level.
//
// The Swift compiler checking `where Left == Right`
// IS verification. The constraint holding IS identification.
// The compiler IS the V=I loop.
//
// ── PROTOCOL CREATION RULES (summary — canonical form: Law.swift) ──
//
// Only two operations exist:
//
//   EXPAND   — associatedtype adds an axis (degree of freedom)
//   COMPRESS — where clause removes a degree of freedom
//
// A valid protocol does at least one of:
//
//   1. associatedtype  — expand (new axis)
//   2. where           — compress (constrain an axis)
//   3. inherit from 2+ — intersect (A ∩ B < A, B)
//
// `protocol X: Y {}` (single parent, no where, no axis)
// is a rename, not a claim. Zero information added.
//
// At the meta-level, these rules ARE Pair/Null:
//   associatedtype = Pair  (two sides: type and protocol)
//   where X == Y   = Null  (sides collapse)
//   where X: M     = partial Null (axis constrained)
// ═══════════════════════════════════════════════════════

/// The act of distinction: two sides, one boundary. The sole structural primitive.
/// Every structure in the lattice is a finite binary tree of ``Pair`` terminating
/// at ``Null``. [EiF C5]
///
/// - term Left: one side of the distinction.
/// - term Right: the other side.
///
/// > Note: ``Pair`` is the one thing the lattice rests on, and the one thing no
/// > protocol derives. Trace any type up its parents (§5 of ``Law``) and it ends
/// > here: an entry in no library, certified by no game.
public protocol Pair {
    associatedtype Left
    associatedtype Right
}

/// The fixpoint of ``Pair``: distinction self-terminates when the two sides close.
/// The constraint `where Left == Right` *is* the boundary. Its inhabitant is
/// `Never`: uninhabited, because nothing remains to be distinguished. [EiF C5]
///
/// > Note: Every theorem that says "A = B" is ``Null`` at that level. The compiler
/// > checking `where Left == Right` is the verification; the constraint holding is
/// > the identification. The compiler is the V=I loop.
public protocol Null: Pair where Left == Right {}

// Never IS Null: the uninhabited type is the fixpoint
// where nothing remains to be distinguished.
extension Never: Null {
    public typealias Left = Never
    public typealias Right = Never
}
