import VerificationIsIdentification

/// The same component question is asked at two addresses of one actual
/// resident pair. These constructors supply the component-reading laws.
public enum BoundaryFirstAlpha<P: Pair>: PredicateReading
where P.Left: BeamShape {
    public typealias Left = P
    public typealias Right = P.Left.AlphaLevel
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = AlphaQuestion
    public typealias Answer = Right
}

public enum BoundarySecondAlpha<P: Pair>: PredicateReading
where P.Right: BeamShape {
    public typealias Left = P
    public typealias Right = P.Right.AlphaLevel
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = AlphaQuestion
    public typealias Answer = Right
}

/// Transfer an existing observation and its actual decoder across a supplied
/// agreement on the same resident source. No new observation is constructed.
/// Agreement supplies correctness, not the participant's discovery of it.
public enum AnswerThroughAgreement<
    C: VerdictIsInvariant,
    F: ReadingFactors
>: ReadingFactors
where C.Left == F.Left, C.Right.Left == F.Left.Left {
    public typealias Left = C.Right
    public typealias Observation = F.Observation
    public typealias Right = F.Right
    public typealias Sigma = C.Sigma
    public typealias Encoding = C.Encoding
    public typealias Predicate = C.Predicate
    public typealias Answer = C.Answer
}

/// One prepared reading of the first application is sufficient under the
/// source-bound agreement. The existing relation retains the whole source.
public typealias PreparedCommonTrace<
    T: ObservationTrace,
    C: VerdictIsInvariant
> = PreparedTraceExtension<T, C.Left>
where T.Left: Structure, T.Left == C.Left.Left,
      C.Right.Left == T.Left

/// The second answer uses exactly the memory decoder of the acquired first
/// reading. Source agreement does not substitute another actual trace.
public typealias CommonAnswerFromTrace<
    T: ExtendedObservationTrace,
    C: VerdictIsInvariant
> = AnswerThroughAgreement<C, LastAnswerFromTrace<T>>
where T.Reading == C.Left, C.Right.Left == T.Left
