import VerificationIsIdentification

// Legacy interface coordinates for two questions about the Higgs field.
// Matter §5 proves a unique radial minimum and one pointwise doublet orbit
// under a specified potential and SU(2) action. These declarations do not
// determine the complete gauge-field configuration or its history.

/// A legacy SystemCrystallizes witness for the intended radial question.
/// The scalar minimum and its pointwise orbit identification are proved in
/// Matter §5. SolutionSet=Never does not contain those relations.
public struct HiggsGaugeInvariant: SystemCrystallizes {
    public typealias Sigma       = Three // supplied coordinate
    public typealias Left        = Cell<
        Never,
        Never
    >
    public typealias Right       = Cell<
        Never,
        Never
    >
    public typealias Cache       = Grew<
        Never,
        Never
    > // supplied retaining or pair shape
    public typealias SolutionSet = Never // legacy interface coordinate
    public typealias Equality    = Verdict<Never> // supplied coordinate
}

/// A legacy coordinate with unequal projections. Its failed Unique
/// conformance is not a count of field configurations or gauge orbits.
public struct HiggsFieldComponents {
    public typealias SolutionSet = Cell<
        Three,
        Never
    > // supplied retaining or pair shape
}
// `extension HiggsFieldComponents: SystemCrystallizes {}` is rejected: SolutionSet
// has unequal projections. Higgs.swift separately checks a supplied count of three.
