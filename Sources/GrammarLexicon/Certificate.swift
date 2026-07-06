import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// CERTIFICATE states the grammar as the system it claims to be.
//
// Permission Is Existence states it in prose. This file states it as a conformance,
// and the build is the certificate (IiI §5). The linter's coordinates, read off the
// machinery around this file: Σ is spellings over a finite vocabulary (I1, the registry
// is a census, finite by construction). COMPARE is one buildExpression constraint
// check, granted or not, always an answer (EiF Thm 3). The record is the carried
// mirror, which only accumulates statements (I3). |S| is the verdicts a spelling can
// land on. A legal file has exactly one: the mirror that compiles IS the file
// identified in this vocabulary (V=I Thm 2), so the gate crystallizes.
//
// The certificate rides into every scratch package beside the vocabulary it
// certifies: each run of the check re-proves that the checker is a crystallizing
// system, in the same build that carries the verdict.
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

/// The check on one atom: granted, or not. The output side branches two ways, so
/// every question the schema asks halts with one answer, a non-trivial `Decidable`
/// (EiF Thm 3).
public enum GrantCheck<OnAtom>: Close {}
extension GrantCheck: Pair {
    public typealias Left = OnAtom
    public typealias Right = Never      // floor
}
extension GrantCheck: Decidable {}

/// The schema's gate crystallizes: a source file under a finite vocabulary has
/// exactly one verdict, and the mirror that compiles IS the file identified
/// (Permission Is Existence PE4 · V=I Thm 2). The type checker certifies the claim by
/// accepting this conformance.
public enum SpellingGate: Close {}
extension SpellingGate: SystemCrystallizes {
    public typealias Sigma       = Never                  // spellings over the finite registry (I1)
    public typealias Left        = Never                  // the (atom, place) each COMPARE reads
    public typealias Right       = Never
    public typealias Cache       = MirrorGrows<Never>     // the carried mirror — append-only (I3)
    public typealias SolutionSet = Never                  // the one verdict: |S| = 1
    public typealias Equality    = GrantCheck<Never>      // granted, or not
}

/// The same walk with the gate removed does NOT crystallize: grant everything and any
/// text passes, so passing identifies nothing — `|S| > 1`, the free generation of
/// Program Is Path PiP7, the language model's row of the table.
public enum UngatedWalk: Close {}
extension UngatedWalk: Open {
    public typealias SolutionSet = Spelling<
        Never,
        Never
    > // |S| > 1: NOT Null, so not Unique
}
// `extension UngatedWalk: SystemCrystallizes {}` is rejected: SolutionSet is not
// Unique. One stream, two vocabularies — the schema's finite one identifies, the
// universal one cannot. The grant table fixes |S|, exactly as the encoding fixes it
// everywhere else.
