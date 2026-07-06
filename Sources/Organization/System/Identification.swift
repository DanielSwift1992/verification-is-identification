import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// ACCESS IS IDENTIFICATION names the showcase read through V=I's kernel.
//
// Policy.swift writes the gates; this file says what they MEAN. A gate is a
// decidable test over the roster, and the question V=I asks of any test is: how
// many candidates pass? The answer is the gate's whole nature.
//
//   Σ         the roster: a finite directory of principals (I1)
//   PAIR      a (principal, document) access the test reads
//   COMPARE   the gate's where-clause: does this principal satisfy it?
//   NULL      no access: the floor where the distinction ends
//   I1        finite roster → finitely many accesses to weigh          ✓
//   I2        the policy is fixed: the where-clauses do not move        ✓
//   I3        a proved access stands: the audit is append-only          ✓
//   A4        a unique holder, and whether it holds is the gate:
//               owner-gate  (Of.Owner == Who)  → |S| = 1   (conforms)
//               department-gate   (Who.Home == Of.Home) → |S| > 1 (refused)
//
// When exactly one principal passes, to verify the access IS to identify the
// holder: "may delete" and "is the owner" are one fact (V=I Thm 2). When many
// pass, the check names no one, the same |S| > 1 the framework refuses
// everywhere else. The build is the certificate. [IiI §5]
// ═══════════════════════════════════════════════════════════════

// The witnesses these conformances use (`Cell`, `Audited`, `Outcome`) live in
// Witnesses.swift names the concrete structures the markers bite on.

// ── The two readings of the policy ──

/// An owner-gated action crystallizes: exactly one principal, the owner, passes
/// `Of.Owner == Who` (Policy.swift `Delete`), so `|S| = 1`. To verify the right is
/// to identify the holder, and the type checker certifies it by accepting this
/// conformance. This is `Delete` read as V=I Thm 2. [IiI §5]
public enum OwnerGate: Close {}
extension OwnerGate: SystemCrystallizes {
    public typealias Sigma       = Never              // the roster: a finite directory (I1)
    public typealias Left        = Never              // the (principal, doc) access COMPARE reads
    public typealias Right       = Never
    public typealias Cache       = EmptyAudit         // the audit accumulates, append-only (I3)
    public typealias SolutionSet = Never              // the lone owner: |S| = 1
    public typealias Equality    = Outcome<Never>     // owner-match: you are, or you are not
}

/// A department-gated action does NOT crystallize: the whole department passes
/// `Who.Home == Of.Home` (Policy.swift `View`), so `|S| > 1`: the solution set is
/// a genuine `Pair` of survivors, the case `Unique` excludes. Passing the view-check
/// names no one in particular. This is `View` read as the |S| > 1 the framework refuses. [IiI §5]
public enum DepartmentGate: Close {}
extension DepartmentGate: Open {
    public typealias SolutionSet = Cell<
        Never,
        Never
    > // |S| > 1: NOT Null, so not Unique
}
// `extension DepartmentGate: SystemCrystallizes {}` is rejected: SolutionSet is not Unique.
// Same policy, two gates: ownership identifies, membership does not. The lens fixes |S|,
// exactly as the oxygen/hydrogen encodings split the same ice (Matter §5).
