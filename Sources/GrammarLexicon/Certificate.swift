import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// CERTIFICATE places the grammar check on the lattice's coordinates.
//
// Permission Is Existence states the grammar in prose. This file writes its
// coordinates as conformances, and the build checks the relations those conformances
// name (IiI §5). The coordinates, read off the machinery around this file: Σ is
// spellings over a finite vocabulary (I1, the registry is a census, finite by
// construction). COMPARE is one buildExpression constraint check on one atom, granted
// or refused (EiF Thm 3). The record is the carried mirror, which only accumulates
// statements (I3).
//
// A file's verdict comes from the linter's reading law: the finite registry, the walk
// over the file in stream order, and the mirror that compiles or refuses with its
// address. The check's negative controls test that law. The witnesses below are
// constant types whose axes are the floor `Never`, and `Never` meets every marker. So
// the type checker accepting them checks the projection relations of `Permanent`,
// `Decidable` and `Unique`. The verdict of one run and the count of its candidates
// belong to the reading law (V=I U1–U2c).
//
// The certificate rides into every scratch package beside the vocabulary it
// describes, so each run of the check compiles these relations in the same build that
// carries the verdict.
// ═══════════════════════════════════════════════════════════════

/// This is two sides held by one boundary: the local `Pair` cell the witnesses below build on.
public enum Spelling<
    L,
    R
>: Close {}
extension Spelling: Pair {
    public typealias Left = L
    public typealias Right = R
}

/// The mirror after one more statement: the new state holds the old whole plus the
/// statement, so `Right.Left == Left`, a non-trivial `Permanent`. The carried record
/// only grows (I3).
public enum MirrorGrows<Before>: Close {}
extension MirrorGrows: Pair {
    public typealias Left = Before
    public typealias Right = Spelling<
        Before,
        Never
    >     // Right.Left == Left ✓
}
extension MirrorGrows: Permanent {}

/// The check on one atom, granted or refused. Its output side is the floor `Never`,
/// which is a `Pair`, so the conformance checks `Decidable`'s relation `Right: Pair`.
/// That the check halts with one of two answers is a property of the linter's
/// buildExpression reading (EiF Thm 3).
public enum GrantCheck<OnAtom>: Close {}
extension GrantCheck: Pair {
    public typealias Left = OnAtom
    public typealias Right = Never      // floor
}
extension GrantCheck: Decidable {}

/// The grammar check's coordinates as one declared system. Its axes are the floor or
/// a constant witness over it, so the conformance checks the relations
/// `SystemCrystallizes` names: an append-only cache, membership read through
/// `Decidable`, and a `Unique` solution coordinate. A compiling mirror shows every
/// spelling of its file granted in this vocabulary, and that fact comes from the
/// linter's run (Permission Is Existence PE4).
public enum SpellingGate: Close {}
extension SpellingGate: SystemCrystallizes {
    public typealias Sigma       = Never                  // spellings over the finite registry (I1)
    public typealias Left        = Never                  // the (atom, place) each COMPARE reads
    public typealias Right       = Never
    public typealias Cache       = MirrorGrows<Never>     // the carried mirror — append-only (I3)
    public typealias SolutionSet = Never                  // the floor, Unique by Never's conformance
    public typealias Equality    = GrantCheck<Never>      // granted, or not
}

/// The same walk with the grant table removed: grant everything, and passing reads no
/// constraint of the vocabulary — the free generation of Program Is Path PiP7, the
/// language model's row of the table. Its solution coordinate is a `Spelling` pair.
public enum UngatedWalk: Close {}
extension UngatedWalk: Open {
    public typealias SolutionSet = Spelling<
        Never,
        Never
    > // Spelling declares no Unique conformance
}
// `extension UngatedWalk: SystemCrystallizes {}` is rejected because `Spelling`
// declares no `Unique`. The refusal is nominal and marks the row of the table. What
// passing tells a reader comes from the grant table: under the finite vocabulary a
// passing file has every spelling granted, under the universal one passing constrains
// nothing.
