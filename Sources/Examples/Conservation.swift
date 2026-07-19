import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// Conservation laws as relations names which processes are allowed. A reaction is
// allowed exactly when its conserved quantities CLOSE across the arrow: baryon
// in == baryon out, charge in == charge out. The relation is the function (Law
// §3), and the closing is Null (Law §6, `where X == Y`).
//
// Each side accumulates its quantities by the counting fold: concrete sums, no
// generic addition. The compiler verifies the balance and proves the headline:
// p → e⁺ + π⁰ conserves charge but violates baryon number, so the PROTON IS
// STABLE, the reason its lifetime exceeds 10³⁴ years.
// ═══════════════════════════════════════════════════════════════

/// This names a reaction side, accumulating baryon number and charge on the IntegerValued
/// ladder. Each particle is a cons-cell that adds its quantum numbers.
public protocol Side {
    associatedtype Baryon: IntegerValued
    associatedtype Charge: IntegerValued
    static var label: String { get }
}

/// This is the empty side: both quantities floor at `Never` (zero).
public enum Nothing: Side {
    public typealias Baryon = Never
    public typealias Charge = Never
    public static let label = ""
}

/// This is a proton on the side: baryon +1, charge +1.
public struct Proton<
    Rest: Side
>: Side {
    public typealias Baryon = Succ<Rest.Baryon>
    public typealias Charge = Succ<Rest.Charge>
    public static var label: String { "p " + Rest.label }
}

/// This is a positron on the side: baryon 0, charge +1.
public struct Positron<
    Rest: Side
>: Side {
    public typealias Baryon = Rest.Baryon
    public typealias Charge = Succ<Rest.Charge>
    public static var label: String { "e⁺ " + Rest.label }
}

/// This is a neutral pion on the side: baryon 0, charge 0.
public struct Pion0<
    Rest: Side
>: Side {
    public typealias Baryon = Rest.Baryon
    public typealias Charge = Rest.Charge
    public static var label: String { "π⁰ " + Rest.label }
}

/// This is a Δ⁺ baryon on the side: baryon +1, charge +1.
public struct DeltaPlus<
    Rest: Side
>: Side {
    public typealias Baryon = Succ<Rest.Baryon>
    public typealias Charge = Succ<Rest.Charge>
    public static var label: String { "Δ⁺ " + Rest.label }
}

/// This names a reaction whose conserved quantities close across the arrow: baryon and
/// charge in equal baryon and charge out. The `where ==` is the conservation
/// law, and a process that breaks it cannot be built.
public protocol Conserved {
    static var reaction: String { get }
}
public enum Reaction<
    Reactants: Side,
    Products: Side
> {}
extension Reaction: Conserved
    where Reactants.Baryon == Products.Baryon, Reactants.Charge == Products.Charge {
    public static var reaction: String { Reactants.label + "→ " + Products.label }
}

/// This names an allowed process, certified by the type checker: it forms only when the
/// reaction conserves every quantity.
public enum Allowed<
    Process: Conserved
> {}

/// This gives Δ⁺ → p + π⁰ : baryon 1 → 1, charge 1 → 1, conserved, a real decay.
public let allowedReactions: [Conserved.Type] = [
    Reaction<
        DeltaPlus<Nothing>,
        Proton<Pion0<Nothing>>
    >.self,
]

// Build with -DSHOW_FORBIDDEN: p → e⁺ + π⁰ conserves charge (1 = 1) but violates
// baryon number (1 ≠ 0). The proton cannot decay — it is stable.
#if SHOW_FORBIDDEN
typealias ProtonDecay = Allowed<Reaction<
    Proton<Nothing>,
    Positron<Pion0<Nothing>>
>>
#endif
