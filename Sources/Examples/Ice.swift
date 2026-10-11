import VerificationIsIdentification

// The local two-in/two-out rule on a finite In/Out word. Both counters
// are derived from its constructors. Matter §5 proves that the admitted
// four-position words are exactly the six listed cases, and separates this
// local result from shared-edge compatibility and global entropy.

/// This is Two: the framework's `IntegerValued` ladder at the value the ice rule pins.
///
/// `Never` is the floor (zero) and `Succ` is the unit step, so `Succ<Succ<Never>>`
/// is the count a valid vertex must reach. [Matter §5]
public typealias Two = Succ<Succ<Never>>

/// This gives a vertex's bonds a running in-count the type checker reduces. The count
/// is an `IntegerValued` ladder, lifted one step per inward proton. [Matter §5]
public protocol Bonds {
    associatedtype InCount: IntegerValued
    associatedtype OutCount: IntegerValued
}

/// This is no bonds remaining: the in-count floors at `Never`, the zero of the ladder. [Matter §5]
public enum Vacuum: Bonds {
    public typealias InCount = Never
    public typealias OutCount = Never
}

/// This is a proton pointing IN, lifts the running count by one step (`Succ`). [Matter §5]
public struct In<
    Rest: Bonds
>: Bonds {
    public typealias InCount = Succ<Rest.InCount>
    public typealias OutCount = Rest.OutCount
}

/// This is a proton pointing OUT, leaves the running count where it was. [Matter §5]
public struct Out<
    Rest: Bonds
>: Bonds {
    public typealias InCount = Rest.InCount
    public typealias OutCount = Succ<Rest.OutCount>
}

/// Both direction counts must equal Two. In the finite Vacuum/In/Out
/// grammar this also requires exactly four bonds. [Matter §5]
public protocol IceVertex: Bonds
where InCount == Two, OutCount == Two {}
extension In:  IceVertex
where InCount == Two, OutCount == Two {}
extension Out: IceVertex
where InCount == Two, OutCount == Two {}

/// A survivor of the ice rule: this type forms only over a valid two-in/two-out
/// vertex, so each survivor alias is the type checker certifying one
/// configuration of the hydrogen solution set. [Matter §5]
public enum Survivor<
    Vertex: IceVertex
> {}

// All six four-position words with two In and two Out symbols. Their
// completeness follows by choosing two of four positions (Matter §5).
public typealias HydrogenSurvivor1 = Survivor<In <In <Out<Out<Vacuum>>>>>
public typealias HydrogenSurvivor2 = Survivor<In <Out<In <Out<Vacuum>>>>>
public typealias HydrogenSurvivor3 = Survivor<In <Out<Out<In <Vacuum>>>>>
public typealias HydrogenSurvivor4 = Survivor<Out<In <In <Out<Vacuum>>>>>
public typealias HydrogenSurvivor5 = Survivor<Out<In <Out<In <Vacuum>>>>>
public typealias HydrogenSurvivor6 = Survivor<Out<Out<In <In <Vacuum>>>>>

// SHOW_REJECT rejects three In slots and the legacy Unique coordinate.
// The six local words do not enumerate a lattice's global configurations.
#if SHOW_REJECT
public typealias RejectedThreeInOneOut = Survivor<In<In<In<Out<Vacuum>>>>>   // in-count Three ≠ Two — refused
extension IceHydrogen: SystemCrystallizes {}                                 // SolutionSet not Unique — refused
#endif
