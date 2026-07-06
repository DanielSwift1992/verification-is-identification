import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// The Higgs mechanism at the TYPE LEVEL: the encoding fixes the degeneracy.
//
// Electroweak SU(2)×U(1) breaks to the photon's U(1): of four generators one
// stays unbroken and three break, so the vacuum manifold carries three Goldstone
// directions, the modes eaten by W⁺, W⁻, Z. On the field-component encoding the
// vacuum IS that three-dimensional manifold, |S| > 1; on the gauge-invariant
// |φ| = v it is a single point, |S| = 1. Same vacuum, two lenses, two verdicts:
// the ice lesson in field theory. [Matter §5]
// ═══════════════════════════════════════════════════════════════

/// A symmetry carries its count of broken generators, its Goldstone directions,
/// on the framework's `IntegerValued` ladder. [Matter §5]
public protocol BrokenSymmetry { associatedtype Goldstones: IntegerValued }

/// This is a fully unbroken symmetry: no Goldstone direction, the count floors at `Never`. [Matter §5]
public enum Unbroken: BrokenSymmetry {
public typealias Goldstones = Never }

/// This is one more broken generator, adds one Goldstone direction (`Succ`). [Matter §5]
public struct Broken<
    Rest: BrokenSymmetry
>: BrokenSymmetry {
public typealias Goldstones = Succ<Rest.Goldstones> }

/// This is electroweak breaking: three generators break, so three Goldstone directions
/// remain, the type checker reduces the chain to `Three`. [Matter §5]
public typealias Electroweak = Broken<Broken<Broken<Unbroken>>>

/// The electroweak Goldstone count is exactly three: the compiler admits the
/// conformance only when the chain reduces to `Three`, the W⁺/W⁻/Z count. [Matter §5]
public protocol ThreeGoldstones {}
extension Broken: ThreeGoldstones
where Goldstones == Three {}

/// This is a Goldstone count certified by the type checker: it forms only when the
/// symmetry breaks into exactly three directions. [Matter §5]
public enum Counted<
    Symmetry: ThreeGoldstones
> {}
public typealias ElectroweakGoldstones = Counted<Electroweak>   // Goldstones == Three ✓

// Build with -DSHOW_REJECT to make the compiler refuse a wrong Goldstone count
// (two ≠ three) and the field-component crystal (|S| > 1).
#if SHOW_REJECT
public typealias WrongGoldstoneCount = Counted<Broken<Broken<Unbroken>>>   // only two, refused
extension HiggsFieldComponents: SystemCrystallizes {}                      // SolutionSet not Unique, refused
#endif
