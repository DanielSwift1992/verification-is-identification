import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// The hydrogen spectrum by the selection rule names a real spectroscopy question,
// answered by the type checker. Which transitions emit a spectral line?
//
// An electric-dipole (E1) transition is allowed exactly when the orbital
// angular momentum changes by one step: Δℓ = ±1. The compiler reduces each
// orbital's ℓ on the IntegerValued ladder and admits a line only when the rule
// holds. The headline result falls out: 2s → 1s has Δℓ = 0, so no line exists,
// the 2s state is METASTABLE, the reason it lives ~0.1 s instead of ~1 ns.
// ═══════════════════════════════════════════════════════════════

/// This gives orbital angular momentum on the ladder: s = 0, p = 1, d = 2.
public typealias EllS = Never
public typealias EllP = Succ<Never>
public typealias EllD = Succ<Succ<Never>>

/// This names a hydrogen orbital, carrying its ℓ and a label.
public protocol Orbital {
    associatedtype L: IntegerValued
    static var label: String { get }
}
public enum Orbital1s: Orbital {
    public typealias L = EllS
    public static let label = "1s"
}
public enum Orbital2s: Orbital {
    public typealias L = EllS
    public static let label = "2s"
}
public enum Orbital2p: Orbital {
    public typealias L = EllP
    public static let label = "2p"
}
public enum Orbital3s: Orbital {
    public typealias L = EllS
    public static let label = "3s"
}
public enum Orbital3p: Orbital {
    public typealias L = EllP
    public static let label = "3p"
}
public enum Orbital3d: Orbital {
    public typealias L = EllD
    public static let label = "3d"
}

/// This names a dipole-allowed transition: Δℓ = ±1. The two branches are distinct generic
/// heads (`Lowers`, `Raises`), so each carries one side of the rule without a
/// conformance clash. A transition with any other Δℓ has no such witness.
public protocol DipoleAllowed {
    static var line: String { get }
}

/// This is the Δℓ = −1 branch: the orbital drops one step.
public enum Lowers<
    From: Orbital,
    To: Orbital
> {}
extension Lowers: DipoleAllowed
where From.L == Succ<To.L> {
    public static var line: String { "\(From.label) → \(To.label)" }
}

/// This is the Δℓ = +1 branch: the orbital rises one step.
public enum Raises<
    From: Orbital,
    To: Orbital
> {}
extension Raises: DipoleAllowed
where To.L == Succ<From.L> {
    public static var line: String { "\(From.label) → \(To.label)" }
}

/// This gives the lines the compiler admits: each forms only because its Δℓ reduces to ±1.
public let hydrogenLines: [DipoleAllowed.Type] = [
    Lowers<
        Orbital2p,
        Orbital1s
    >.self,   // Lyman, Δℓ = −1
    Lowers<
        Orbital3p,
        Orbital1s
    >.self,   // Lyman, Δℓ = −1
    Raises<
        Orbital3s,
        Orbital2p
    >.self,   // Balmer, Δℓ = +1
    Lowers<
        Orbital3p,
        Orbital2s
    >.self,   // Balmer, Δℓ = −1
    Lowers<
        Orbital3d,
        Orbital2p
    >.self,   // Balmer, Δℓ = −1
]

// Build with -DSHOW_FORBIDDEN to make the compiler refuse the forbidden lines:
//   2s→1s (Δℓ = 0, why 2s is metastable) and 3d→1s (Δℓ = −2).
#if SHOW_FORBIDDEN
let forbidden2sTo1s: DipoleAllowed.Type = Lowers<
    Orbital2s,
    Orbital1s
>.self   // Δℓ = 0 — refused
let forbidden3dTo1s: DipoleAllowed.Type = Lowers<
    Orbital3d,
    Orbital1s
>.self   // Δℓ = −2 — refused
#endif
