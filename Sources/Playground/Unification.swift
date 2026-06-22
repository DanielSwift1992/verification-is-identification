import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// WHAT THE LATTICE ALLOWS — unification by conformance.
//
// Quantum measurement, ice, and the Higgs vacuum are different physics.
// Each declared its V=I structure and the type checker certified it a
// crystallizing system. So they are now ONE structure: anything written
// over `SystemCrystallizes` applies to all of them at once, and a
// non-instance is excluded by the compiler.
//
// The three typealiases below compile — three physics, one lattice.
// `CrystallizingDomain<…>` over a degenerate domain would not compile.
// ═══════════════════════════════════════════════════════════════

/// A construction valid over ANY certified crystallizing domain. Build or
/// prove once here; every conforming domain plugs in for free. Add a new
/// physical instance tomorrow and it slots in with no change here.
public struct CrystallizingDomain<D: SystemCrystallizes> {
    public typealias Instance = D
}

public typealias QuantumCrystal = CrystallizingDomain<QuantumMeasurement>
public typealias IceCrystal     = CrystallizingDomain<IceOxygen>
public typealias HiggsCrystal   = CrystallizingDomain<HiggsGaugeInvariant>
