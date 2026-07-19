import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// Quantum measurement at the TYPE LEVEL: degeneracy decides identification.
//
// A projective measurement IDENTIFIES the eigenstate exactly when the measured
// eigenvalue is non-degenerate: its eigenspace is one-dimensional, |S| = 1. A
// degenerate eigenvalue leaves an eigenspace of dimension g > 1, the measurement
// returns the eigenvalue yet cannot say which eigenstate. The encoding (which
// observables are read) fixes |S|, as the oxygen/hydrogen lens did for ice.
// Hydrogen's n=2 level is four-fold degenerate (n² = 4): energy alone leaves
// |S| = 4, and the complete set of commuting observables lifts it to |S| = 1. [Matter §5]
// ═══════════════════════════════════════════════════════════════

/// This is One: the eigenspace dimension a non-degenerate eigenvalue collapses to. [Matter §5]
public typealias One = Succ<Never>

/// An eigenspace carries its dimension on the framework's `IntegerValued` ladder. [Matter §5]
public protocol Eigenspace { associatedtype Dimension: IntegerValued }

/// This is the empty space: the dimension floors at `Never`, the zero of the ladder. [Matter §5]
public enum NoEigenstate: Eigenspace {
public typealias Dimension = Never }

/// This is one more eigenstate sharing the measured eigenvalue, lifts the dimension by one. [Matter §5]
public struct Eigenstate<
    Rest: Eigenspace
>: Eigenspace {
public typealias Dimension = Succ<Rest.Dimension> }

/// This is a measurement that IDENTIFIES exactly when the eigenvalue is non-degenerate: a
/// one-dimensional eigenspace. The compiler reduces `Dimension` and admits only
/// ``One``, so a degenerate level cannot claim to identify its state. [Matter §5]
public protocol IdentifyingMeasurement {}
extension Eigenstate: IdentifyingMeasurement
where Dimension == One {}

/// This is an identification certified by the type checker: it forms only over a
/// non-degenerate eigenvalue. [Matter §5]
public enum Identified<
    Measurement: IdentifyingMeasurement
> {}

// A non-degenerate eigenvalue: a one-dimensional eigenspace identifies its state.
public typealias NonDegenerate = Identified<Eigenstate<NoEigenstate>>     // Dimension One ✓

// Hydrogen's n=2 level under the energy-only encoding: four-fold degenerate
// (n² = 4, the 2s state and the three 2p states share one energy). |S| = 4 > 1,
// the dimension the type checker reduces the chain to.
public typealias HydrogenLevel2 = Eigenstate<Eigenstate<Eigenstate<Eigenstate<NoEigenstate>>>>

// Build with -DSHOW_REJECT to make the compiler refuse identification on the
// degenerate level (Dimension Four ≠ One) and the degenerate crystal (|S| > 1).
#if SHOW_REJECT
public typealias DegenerateIdentifies = Identified<HydrogenLevel2>   // Dimension Four ≠ One — refused
extension DegenerateMeasurement: SystemCrystallizes {}               // SolutionSet not Unique — refused
#endif
