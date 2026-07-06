import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// THE QUERY names the policy, asked of the compiler. A query is part of the system, and the system
// is types: this file has no `label`, no string, no erasure. It answers whether an access is
// authorized with the conformance itself. The render layer reads these verdicts into rows
// (View/Reader.swift); it depends on this, never the reverse.
//
// The mechanism is `decide` (View/Reader.swift): a gate is a V=I `Decidable` exactly when its
// rule holds (``Authorized`` for access, ``MeetsOfficeMinimum`` for the office minimum, both
// Policy-side), and `decide` picks the constrained overload at a CONCRETE site. So
// `decide(View<Alice, FinanceVault>.self)` is `true` and the denials are `false`, both settled
// at compile time. (A generic body cannot re-resolve it, so the readings call it concretely,
// the named slice directly, the roster through the saturated role coordinate below.)
// ═══════════════════════════════════════════════════════════════

/// This names a role coordinate: a (rank, department) pair, the same `PAIR(Rank, Home)` shape an
/// employee is. `decide` on a role representative is a compile-time verdict every employee
/// of that role inherits (saturation): instantiation IS the lookup. [IiI §3]
public enum Role<
    R: CanView,
    H: Department
>: Employee {
    public typealias Rank = R
    public typealias Home = H
}
