import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// The ice rule at the TYPE LEVEL names the residual entropy of ice, settled by
// the compiler. No runtime: the in-count reduces as a typealias, the rule is
// a `where`, and the survivors are the conformances that type-check.
//
// Hydrogen protons obey two-in/two-out: of a vertex's four bonds, exactly two
// point in. The configurations that satisfy it are the solution set |S| the
// hydrogen encoding leaves uncollapsed, Pauling's residual entropy. The oxygen
// encoding collapses to one ground state (|S| = 1, the crystal Ih). The lens
// fixes |S|, and the type checker is what reads it. [Matter §5]
// ═══════════════════════════════════════════════════════════════

/// This is Two: the framework's `IntegerValued` ladder at the value the ice rule pins.
///
/// `Never` is the floor (zero) and `Succ` is the unit step, so `Succ<Succ<Never>>`
/// is the count a valid vertex must reach. [Matter §5]
public typealias Two = Succ<Succ<Never>>

/// This gives a vertex's bonds a running in-count the type checker reduces. The count
/// is an `IntegerValued` ladder, lifted one step per inward proton. [Matter §5]
public protocol Bonds { associatedtype InCount: IntegerValued }

/// This is no bonds remaining: the in-count floors at `Never`, the zero of the ladder. [Matter §5]
public enum Vacuum: Bonds {
public typealias InCount = Never }

/// This is a proton pointing IN, lifts the running count by one step (`Succ`). [Matter §5]
public struct In<
    Rest: Bonds
>: Bonds {
public typealias InCount = Succ<Rest.InCount> }

/// This is a proton pointing OUT, leaves the running count where it was. [Matter §5]
public struct Out<
    Rest: Bonds
>: Bonds {
public typealias InCount = Rest.InCount }

/// The ice rule: a vertex is valid exactly when two protons point in. The
/// compiler reduces `InCount` and admits only the arrangements that reach ``Two``,
/// so a three-in vertex cannot conform and cannot be built. [Matter §5]
public protocol IceVertex {}
extension In:  IceVertex
where InCount == Two {}
extension Out: IceVertex
where InCount == Two {}

/// A survivor of the ice rule: this type forms only over a valid two-in/two-out
/// vertex, so each survivor alias is the type checker certifying one
/// configuration of the hydrogen solution set. [Matter §5]
public enum Survivor<
    Vertex: IceVertex
> {}

// The hydrogen solution set: the six two-in/two-out survivors, C(4,2) = 6. Each
// alias forms only because the compiler reduced its in-count to Two, so the list
// type-checking IS the count: |S| = 6 > 1, the residual-entropy manifold.
public typealias HydrogenSurvivor1 = Survivor<In <In <Out<Out<Vacuum>>>>>
public typealias HydrogenSurvivor2 = Survivor<In <Out<In <Out<Vacuum>>>>>
public typealias HydrogenSurvivor3 = Survivor<In <Out<Out<In <Vacuum>>>>>
public typealias HydrogenSurvivor4 = Survivor<Out<In <In <Out<Vacuum>>>>>
public typealias HydrogenSurvivor5 = Survivor<Out<In <Out<In <Vacuum>>>>>
public typealias HydrogenSurvivor6 = Survivor<Out<Out<In <In <Vacuum>>>>>

// A seventh survivor is impossible: every other arrangement of four bonds has an
// in-count other than Two, so `Survivor<…>` over it does not type-check. The
// compiler enforcing the rule is why |S| is exactly six, not sixteen.
//
// Build with `-DSHOW_REJECT` to make the compiler name both violations:
//   a three-in vertex (the ice rule), and the hydrogen crystal (|S| > 1, the gate).
#if SHOW_REJECT
public typealias RejectedThreeInOneOut = Survivor<In<In<In<Out<Vacuum>>>>>   // in-count Three ≠ Two — refused
extension IceHydrogen: SystemCrystallizes {}                                 // SolutionSet not Unique — refused
#endif
