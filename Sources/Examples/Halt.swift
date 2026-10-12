import VerificationIsIdentification

/// The conserved square gives one answer to both of its source readings.
/// The constructor retains their source addresses and shared model.
/// Its answer equality follows from the square and its fixed image step. [Halt HF9]
public enum ConservedStepReadings<Step: ConservedReadingStep>: EncodingForgets {
    public typealias Left = Step.Left
    public typealias Right = Step.Right
    public typealias Sigma = Step.Sigma
    public typealias Encoding = Step.Encoding
    public typealias Predicate = Step.Left.Predicate
    public typealias Answer = Step.Left.Answer
    public typealias LeftSource = Step.Left.Left
    public typealias RightSource = Step.Right.Left
    public typealias SharedImage = Step.Left.Answer
}
