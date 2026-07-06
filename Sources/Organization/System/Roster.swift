import VerificationIsIdentification

// Chain names a counted cons-list as a type, defined locally.
// Length is the Peano count the compiler folds as the list type-checks.
public protocol Chain {
    associatedtype Length: IntegerValued
}

// ═══════════════════════════════════════════════════════════════
// THE ROSTER, COUNTED BY THE COMPILER: body, count, as types.
//
// A list operation does not run here. The roster is a TYPE: every employee composed into a
// `body`, the way the framework builds a structure from `Pair`. The compiler folds it as it
// type-checks, so the headcount is `count` (VerificationIsIdentification), computed by the type
// checker and never authored.
//
// Finding the one element that UNIQUELY passes a test is a different thing from reading a count:
// that is the framework's `Unique` crystallization (|S| = 1), already the owner gate
// (Identification.swift). A find-first-matching over an unordered list would need a "not yet
// matched" test, the negation the type system does not give, so a predicate search lives at that
// monotone, crystallizing boundary. [V=I §5.22]
// ═══════════════════════════════════════════════════════════════

// ── The company, composed through `body` ──
//
// The whole roster, every access, and the department/rank/site partitions are each one type,
// composed through `@StructureBuilder` (GeneratedTeam.swift, private/gen_org.py): the body
// folds the leaves into a `Paired` chain, and `count` (VerificationIsIdentification) reads its
// size, the role `Length`/`Proven`/`Hire` used to carry. Three category protocols, one per
// shape; `Open` is a protocol per Law §0″, so each instance (`Company`, `FinanceTeam`, …)
// conforms to one of these rather than writing `: Open` directly.

/// This names the whole company as one type: every employee a leaf in the body. `Company.count`
/// is the headcount, folded out as it compiles. [IiI §3]
public protocol Roster: Open {}

/// This names one partition of the company: every member verified to share a property
/// (department, rank, or work arrangement) by the `Verified…` marker each leaf is
/// (Filtering.swift). `count` is the partition's headcount.
public protocol Team: Open {}

/// This gives every proved access in the company as one type: each leaf a `VerifiedView`
/// (Filtering.swift), so the body type-checks only when every access is genuinely authorized.
/// `count` is read off the type, the green build IS the audit.
public protocol AccessLedger: Open {}
