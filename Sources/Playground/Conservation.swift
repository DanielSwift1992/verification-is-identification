import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// Conservation laws as relations — which processes are allowed? A reaction is
// allowed exactly when its conserved quantities CLOSE across the arrow: baryon
// in == baryon out, charge in == charge out. The relation is the function (Law
// §3); the closing is Null (Law §6, `where X == Y`).
//
// Each side accumulates its quantities by the counting fold — concrete sums, no
// generic addition. The compiler verifies the balance and proves the headline:
// p → e⁺ + π⁰ conserves charge but violates baryon number, so the PROTON IS
// STABLE — the reason its lifetime exceeds 10³⁴ years.
// ═══════════════════════════════════════════════════════════════

/// A reaction side, accumulating baryon number and charge on the IntegerValued
/// ladder. Each particle is a cons-cell that adds its own quantum numbers.
public protocol Side {
    associatedtype Baryon: IntegerValued
    associatedtype Charge: IntegerValued
    static var label: String { get }
}

/// The empty side: both quantities floor at `Never` (zero).
public enum Nothing: Side {
    public typealias Baryon = Never
    public typealias Charge = Never
    public static let label = ""
}

/// A proton on the side: baryon +1, charge +1.
public struct Proton<Rest: Side>: Side {
    public typealias Baryon = Succ<Rest.Baryon>
    public typealias Charge = Succ<Rest.Charge>
    public static var label: String { "p " + Rest.label }
}

/// A positron on the side: baryon 0, charge +1.
public struct Positron<Rest: Side>: Side {
    public typealias Baryon = Rest.Baryon
    public typealias Charge = Succ<Rest.Charge>
    public static var label: String { "e⁺ " + Rest.label }
}

/// A neutral pion on the side: baryon 0, charge 0.
public struct Pion0<Rest: Side>: Side {
    public typealias Baryon = Rest.Baryon
    public typealias Charge = Rest.Charge
    public static var label: String { "π⁰ " + Rest.label }
}

/// A Δ⁺ baryon on the side: baryon +1, charge +1.
public struct DeltaPlus<Rest: Side>: Side {
    public typealias Baryon = Succ<Rest.Baryon>
    public typealias Charge = Succ<Rest.Charge>
    public static var label: String { "Δ⁺ " + Rest.label }
}

/// A reaction whose conserved quantities close across the arrow — baryon and
/// charge in equal baryon and charge out. The `where ==` is the conservation
/// law, and a process that breaks it cannot be built.
public protocol Conserved { static var reaction: String { get } }
public enum Reaction<Reactants: Side, Products: Side> {}
extension Reaction: Conserved
    where Reactants.Baryon == Products.Baryon, Reactants.Charge == Products.Charge {
    public static var reaction: String { Reactants.label + "→ " + Products.label }
}

/// An allowed process, certified by the type checker: it forms only when the
/// reaction conserves every quantity.
public enum Allowed<Process: Conserved> {}

/// Δ⁺ → p + π⁰ : baryon 1 → 1, charge 1 → 1 — conserved, a real decay.
public let allowedReactions: [Conserved.Type] = [
    Reaction<DeltaPlus<Nothing>, Proton<Pion0<Nothing>>>.self,
]

// Build with -DSHOW_FORBIDDEN: p → e⁺ + π⁰ conserves charge (1 = 1) but violates
// baryon number (1 ≠ 0). The proton cannot decay — it is stable.
#if SHOW_FORBIDDEN
typealias ProtonDecay = Allowed<Reaction<Proton<Nothing>, Positron<Pion0<Nothing>>>>
#endif
