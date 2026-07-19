import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// WITNESSES names the concrete structures the V=I markers bite on, in org terms.
//
// The framework's markers (`Permanent`, `Decidable`, …) are relations on `Pair`.
// To conform an org concept to one, you supply a concrete structure that satisfies
// the relation. These three are reused across the V=I readings (Identification,
// Saturation, ForcedDistribution). Each is a finite tree of `Pair` floored at
// `Never` (no-access). They carry distinct sides, so the relations are true for real,
// not only at the trivial empty fixpoint.
// ═══════════════════════════════════════════════════════════════

/// This gives two sides held by one boundary: the reusable `Pair` the rest are built from.
public enum Cell<
    L,
    R
>: Close {}
extension Cell: Pair {
    public typealias Left = L
    public typealias Right = R
}

/// The audit after one grant: the new state holds the old whole plus an entry,
/// so `Right.Left == Left`. A non-trivial `Permanent`: the record only grows. [I3]
public enum Audited<Before>: Close {}
extension Audited: Pair {
    public typealias Left = Before
    public typealias Right = Cell<
        Before,
        Never
    >     // Right.Left == Left ✓
}
extension Audited: Permanent {}

/// This is the audit before anything is recorded: the floor every `Audited` chain starts from.
/// Named once because every append-only `Cache`/`Library` in the System reads through it.
public typealias EmptyAudit = Audited<Never>

/// The gate's verdict on one principal: in, or out. The output side branches two
/// ways, so this is a non-trivial `Decidable`: every check halts with one answer. [EiF Thm 3]
public enum Outcome<Who>: Close {}
extension Outcome: Pair {
    public typealias Left = Who
    public typealias Right = Never      // floor
}
extension Outcome: Decidable {}
