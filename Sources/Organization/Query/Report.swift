import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// THE STANDING REPORT names questions the compiler answers, re-proved every build.
//
// Every binding here is a query the compiler resolves by V=I's only two operations:
// COMPARE (type equality) and projection (reading an associated type) [V=I §2.5].
// The file recompiles on every build, so the report cannot drift from the system:
// it IS the system, re-proved. Change the policy so a stated fact stops holding, and
// the report stops compiling: drift becomes a build error, not a stale document.
//
// This is the system, not its rendering: no `label`, no string. A fact here is a TYPE:
// a projection (`FinanceVault.Owner`) or a where-clause that cannot form when it fails
// (``OwnedFromWithin``). The render layer reads the names off these types (View/Reading.swift),
// the report does not reach toward rendering. Drift becomes a build error, not a stale page.
// ═══════════════════════════════════════════════════════════════

// ── Standing invariants (the type is well-formed ONLY if the fact is true) ──

/// This names a standing invariant: a fact the report re-proves every build. Conforming types are
/// the proofs. Gathering them as ``Invariant`` keeps them as types, not erased to `Any`.
/// `Open`, not `Close` (Law §0″: `Close` must be a concrete enum, not a protocol), the same
/// shape as ``Employee``: a leaf that does not customize `body`, so it counts as one.
public protocol Invariant: Open {}

/// A document is owned-from-within when its owner sits in its own department.
/// `where D.Owner.Home == D.Home` is a COMPARE: cross-department ownership cannot
/// form this type. [the data-residency invariant, proved structurally]
public enum OwnedFromWithin<
    D: Owned
>: Invariant
where D.Owner.Home == D.Home {}

/// A document is manager-led when its owner holds admin. `where D.Owner.Rank: CanAdmin`
/// is the marker check: a document whose owner is not a manager cannot form this type.
public enum LedByManager<
    D: Owned
>: Invariant
where D.Owner.Rank: CanAdmin {}

/// This is a report composed through `body`: the category ``StandingReport`` conforms to, rather
/// than writing `: Open` directly (Law §0″: `Open` is a protocol).
public protocol Report: Open {}

/// This is the standing report as one type: every invariant proved this build, composed through
/// the body. Each element holds only if its where-clause does, so the type forms only when
/// the whole report is true. Change the policy so a stated fact stops holding and this
/// stops compiling: drift is a build error.
public enum StandingReport: Report {
    @StructureBuilder
    public static var body: some Structure {
        OwnedFromWithin<FinanceVault>.self
        OwnedFromWithin<EngineeringRepo>.self
        LedByManager<FinanceVault>.self
        LedByManager<EngineeringRepo>.self
    }
}

// ── What KIND of question a query is (the org's algebra IS the framework's) ──

/// A department lookup as a `Measurable`: one input (a document), one settled answer.
public enum DepartmentOf<
    D: Doc
>: Close {}
extension DepartmentOf: Measurable {
    public typealias Left = D
    public typealias Right = Never
}
