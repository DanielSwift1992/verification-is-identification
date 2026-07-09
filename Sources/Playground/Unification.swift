import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// WHAT THE LATTICE ALLOWS — unification by conformance.
//
// Quantum measurement, ice, the Higgs vacuum, and the packing of this
// package's own generated code are different domains. Each declared its
// V=I structure and the type checker certified it a crystallizing system.
// So they are now ONE structure: anything written over
// `SystemCrystallizes` applies to all of them at once, and a
// non-instance is excluded by the compiler.
//
// The four typealiases below compile — three physics and the package's
// own form, one lattice. `CrystallizingDomain<…>` over a degenerate
// domain would not compile.
// ═══════════════════════════════════════════════════════════════

/// A construction valid over ANY certified crystallizing domain. Build or
/// prove once here. Every conforming domain plugs in for free. A new physical
/// instance added tomorrow slots in with no change here.
public struct CrystallizingDomain<
    D: SystemCrystallizes
> {
    public typealias Instance = D
}

public typealias QuantumCrystal = CrystallizingDomain<QuantumMeasurement>
public typealias IceCrystal     = CrystallizingDomain<IceOxygen>
public typealias HiggsCrystal   = CrystallizingDomain<HiggsGaugeInvariant>
public typealias FormCrystal    = CrystallizingDomain<PackingUnderCost>
