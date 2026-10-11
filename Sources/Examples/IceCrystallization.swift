import VerificationIsIdentification

// Legacy interface coordinates for chosen questions about ice. Matter §5
// separates the local ice rule, shared-edge compatibility, global count and
// probability law. These coordinates do not encode a phase diagram or
// an append-only history of thermally eliminated configurations.

/// A legacy SystemCrystallizes witness. Its Never coordinate does not
/// derive a unique oxygen lattice, physical ground state or retention law.
public struct IceOxygen: SystemCrystallizes {
    public typealias Sigma       = Three // supplied coordinate
    public typealias Left        = Cell<
        Never,
        Never
    > // supplied coordinate
    public typealias Right       = Cell<
        Never,
        Never
    >
    public typealias Cache       = Grew<
        Never,
        Never
    > // supplied coordinate
    public typealias SolutionSet = Never // supplied coordinate
    public typealias Equality    = Verdict<Never> // supplied coordinate
}

/// A legacy unequal-sided coordinate. Its failure to conform to Unique
/// does not calculate the number of compatible ice configurations or entropy.
public struct IceHydrogen {
    public typealias SolutionSet = Cell<
        Three,
        Never
    > // supplied coordinate
}
// The legacy coordinate's projections are incompatible with Unique.
