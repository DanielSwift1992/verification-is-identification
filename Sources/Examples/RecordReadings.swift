import VerificationIsIdentification

public enum RecordRoutes<
    Whole: Pair,
    Requested: PredicateReading,
    Documentation: ReadingFactors,
    Audit: ReadingFactors
>: RootedRecordReadings
where Requested.Left == Whole.Left,
      Documentation.Left == Requested, Audit.Left == Requested {
    public typealias Root = Whole
    public typealias Reference = Requested
    public typealias Left = Documentation
    public typealias Right = Audit
}

// No equality between the two final answers is requested from the caller.
public enum RecordReadingResults<R: RootedRecordReadings>: VerdictIsInvariant {
    public typealias Left = R.Left.Right
    public typealias Right = R.Right.Right
    public typealias Sigma = R.Reference.Sigma
    public typealias Encoding = R.Reference.Encoding
    public typealias Predicate = R.Reference.Predicate
    public typealias Answer = R.Reference.Answer
}
