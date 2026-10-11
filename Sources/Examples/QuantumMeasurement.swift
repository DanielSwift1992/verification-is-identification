import VerificationIsIdentification

// Legacy interface coordinates for an ideal quantum measurement. Matter §5
// proves the rank-one conditional-output statement from an actual projector
// and update rule. These coordinates do not supply that physical model.

/// A SystemCrystallizes interface witness. Its chosen coordinates do not
/// provide a Hilbert space, projector, measurement instrument or retention
/// law. The post-measurement ray statement needs Matter §5's premises.
public struct QuantumMeasurement: SystemCrystallizes {
    public typealias Sigma       = Three // supplied coordinate
    public typealias Left        = Cell<
        Never,
        Never
    > // supplied retaining or pair shape
    public typealias Right       = Cell<
        Never,
        Never
    > // supplied retaining or pair shape
    public typealias Cache       = Grew<
        Never,
        Never
    > // supplied retaining or pair shape
    public typealias SolutionSet = Never // legacy interface coordinate
    public typealias Equality    = Verdict<Never> // supplied coordinate
}

/// A legacy coordinate with unequal projections. It cannot satisfy Unique.
/// That refusal does not compute an eigenspace dimension or count its rays.
public struct DegenerateMeasurement {
    public typealias SolutionSet = Cell<
        Three,
        Never
    > // supplied retaining or pair shape
}
// `extension DegenerateMeasurement: SystemCrystallizes {}` is rejected: SolutionSet
// has unequal projections. Quantum.swift separately checks dimension expressions.
