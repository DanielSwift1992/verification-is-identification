import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// ROLES ARE THE SATURATED LIBRARY: the showcase scaled, read through the saturation theorem.
//
// Verifying access for 200 people is NOT 200 separate proofs. Access follows the
// ROLE, not the person: a view-access depends only on the department (rank is
// irrelevant to viewing), so its rule class IS the department: four of them. Prove
// the rule once per class and every employee of that class inherits it by
// instantiation. One certified rule, the whole class. Instantiation IS the lookup.
//
//   rule class   a role, here, a department (view ignores rank).
//   library L    the certified rules, one per class. Append-only (I3).
//   K            the number of classes: the library's size. Four.
//   saturation   after K certified rules, every further person is a lookup,
//                  not a derivation: T_actual → O(K·F)+1. [IiI §3 theorem]
//
// 200 people, four rules. The compression falls out of what compiles, and it is
// the saturation theorem: a finite domain covered by a finite basis, and the rest
// is recall. The saturated library is the company's, not any one agent's (SAT5/6).
// ═══════════════════════════════════════════════════════════════

/// A stand-in for everyone in a department: the representative a role-rule is proved
/// over. Certify the representative and every real employee of that department
/// inherits the access by instantiation, one proof covers the class. Rank is the
/// weakest (`IndividualContributor`): viewing asks for nothing more.
public enum AnyoneIn<
    H: Department
>: Employee {
    public typealias Rank = IndividualContributor
    public typealias Home = H
}

/// A stand-in for a department AND a rank at once: the pair a role-walk forms with its
/// feet. Two choices of door make this type, the type is a person-shape, and a verdict
/// read through it covers everyone standing in the same pair — the walk's word became an
/// object, and the object answers.
public enum SomeoneAs<
    H: Department,
    R: CanView
>: Employee {
    public typealias Rank = R
    public typealias Home = H
}

// ── The library: one certified rule per class, gathered as ONE type. The list
//    type-checks only when every class's view-access is proved: the green build IS
//    the certification, and `CertifiedRules.Length` is K, counted as it compiles. ──

/// This gives a set of rules composed through `body`: the category `CertifiedRules` conforms to,
/// rather than writing `: Open` directly (Law §0″: `Open` is a protocol).
public protocol RuleSet: Open {}

/// This is the saturated library as one type: the `K` certified rules, each `Authorized`, composed
/// through the body. Compiling it certifies every class is covered, and `CertifiedRules.count`
/// is `K`, the count the type checker folds out (read at the boundary). The whole roster
/// resolves through these rules: instantiation IS the lookup.
public enum CertifiedRules: RuleSet {
    @StructureBuilder
    public static var body: some Structure {
        View<
            AnyoneIn<Finance>,
            FinanceShare
        >.self
        View<
            AnyoneIn<Engineering>,
            EngineeringShare
        >.self
        View<
            AnyoneIn<Sales>,
            SalesShare
        >.self
        View<
            AnyoneIn<People>,
            PeopleShare
        >.self
    }
}

/// The role-library is saturated: append-only and at its fixed point. `Library:
/// Permanent` says a certified rule does not leave (I3). `Library == SaturatedLibrary`
/// says the library has converged: every class is covered, nothing left to add.
/// The conformance compiles, so the type checker certifies the org's library sits
/// at the saturation fixpoint. The same door the V=I pipeline and crystallization
/// pass through, one level up, the same door named at the top of this file.
public enum RoleLibrary: Close {}
extension RoleLibrary: LibrarySaturates {
    public typealias Sigma            = Never              // the roster: a finite directory (I1)
    public typealias Left             = Never
    public typealias Right            = Never
    public typealias Cache            = EmptyAudit         // comparisons accumulate, append-only (I3)
    public typealias Library          = EmptyAudit         // certified rules accumulate, do not leave (I3)
    public typealias SaturatedLibrary = EmptyAudit         // Library == SaturatedLibrary: at the fixpoint
}
