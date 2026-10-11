import VerificationIsIdentification

// Legacy interface coordinates for packing comparisons. Form Is Gauge
// states the actual content-preservation and strict-minimum obligations.
// Historical timings are recorded in Curve, and CodeForm selects fanout 64.
// These coordinates do not encode those measurements or their coverage.

/// A legacy SystemCrystallizes witness for a cost comparison. FiG3–FiG3a
/// requires actual candidate coverage and strict comparisons, with explicit
/// uncertainty when relevant. This declaration supplies neither.
public struct PackingUnderCost: SystemCrystallizes {
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

/// A legacy unequal-sided coordinate. Its rejection under Unique does not
/// prove byte equality. FiG1 gives the ordered-fold preservation argument,
/// whose assumptions must match the actual renderer.
public struct PackingUnderContent {
    public typealias SolutionSet = Cell<
        Three,
        Never
    > // supplied coordinate
}
// The legacy coordinate's projections are incompatible with Unique.
