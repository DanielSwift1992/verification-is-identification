import VerificationIsIdentification

// A supplied count of broken directions, checked as a successor expression.
// Electroweak chooses three constructors. It does not derive the group or
// its action. Matter §5 supplies the radial and pointwise orbit calculations.
// Gauge-equivalent scalar representatives do not enumerate different full
// physical vacua, and three broken directions are not three extra particles.

/// Names a count of broken directions. Interpreting it physically needs
/// the specified symmetry, action and stabilizer.
public protocol BrokenSymmetry { associatedtype Goldstones: IntegerValued }

/// The terminal zero count in the supplied constructor grammar.
public enum Unbroken: BrokenSymmetry {
public typealias Goldstones = Never }

/// Adds one slot to the count of broken directions. The group-theoretic
/// meaning of that slot must be established separately.
public struct Broken<
    Rest: BrokenSymmetry
>: BrokenSymmetry {
public typealias Goldstones = Succ<Rest.Goldstones> }

/// Supplies three broken-direction slots. The compiler reduces the chosen
/// expression to Three, without deriving it from SU(2) and U(1).
public typealias Electroweak = Broken<Broken<Broken<Unbroken>>>

/// A declared admission marker whose constructor conformance checks Three.
/// This checks the supplied count, not the electroweak particle spectrum.
public protocol ThreeGoldstones {}
extension Broken: ThreeGoldstones
where Goldstones == Three {}

/// Admits the supplied three-direction count conformance. [Matter §5]
public enum Counted<
    Symmetry: ThreeGoldstones
> {}
public typealias ElectroweakGoldstones = Counted<Electroweak>   // Goldstones == Three ✓

// SHOW_REJECT checks Two against Three and an incompatible Unique coordinate.
// It does not compare physical gauge orbits or solve a scalar potential.
#if SHOW_REJECT
public typealias WrongGoldstoneCount = Counted<Broken<Broken<Unbroken>>>   // only two, refused
extension HiggsFieldComponents: SystemCrystallizes {}                      // SolutionSet not Unique, refused
#endif
