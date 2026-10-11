import VerificationIsIdentification

/// Coordinates for E(a,b,c,d)=(a+d,b+d,c+d). Finite expressions from
/// SensorDark and the four increments compute source and response together.
/// An arbitrary conformance to this open interface is not that derivation.
public protocol SpectralSample: PredicateReading
where Sigma == SpectralSpace, Encoding == SpectralEncoding,
      Predicate == SpectralImageQuestion,
      Left: Pair, Left.Left: Pair, Left.Right: Pair,
      Left.Left.Left: IntegerValued, Left.Left.Right: IntegerValued,
      Left.Right.Left: IntegerValued, Left.Right.Right: IntegerValued,
      Answer: Pair, Answer.Right: Pair,
      Answer.Left: IntegerValued,
      Answer.Right.Left: IntegerValued, Answer.Right.Right: IntegerValued {}

public enum SpectralSpace: Close {}
public enum SpectralEncoding: Close {}
public enum SpectralImageQuestion: Close {}
public enum FourthChannelEncoding: Close {}
public enum FourthChannelQuestion: Close {}

public enum SensorDark: SpectralSample {
    public typealias Left = Paired<Paired<Never, Never>, Paired<Never, Never>>
    public typealias Answer = Paired<Never, Paired<Never, Never>>
    public typealias Right = Answer
    public typealias Sigma = SpectralSpace
    public typealias Encoding = SpectralEncoding
    public typealias Predicate = SpectralImageQuestion
}

public enum SensorAddA<P: SpectralSample>: SpectralSample {
    public typealias Left = Paired<
        Paired<Succ<P.Left.Left.Left>, P.Left.Left.Right>, P.Left.Right
    >
    public typealias Answer = Paired<Succ<P.Answer.Left>, P.Answer.Right>
    public typealias Right = Answer
    public typealias Sigma = P.Sigma
    public typealias Encoding = P.Encoding
    public typealias Predicate = P.Predicate
}

public enum SensorAddB<P: SpectralSample>: SpectralSample {
    public typealias Left = Paired<
        Paired<P.Left.Left.Left, Succ<P.Left.Left.Right>>, P.Left.Right
    >
    public typealias Answer = Paired<
        P.Answer.Left, Paired<Succ<P.Answer.Right.Left>, P.Answer.Right.Right>
    >
    public typealias Right = Answer
    public typealias Sigma = P.Sigma
    public typealias Encoding = P.Encoding
    public typealias Predicate = P.Predicate
}

public enum SensorAddC<P: SpectralSample>: SpectralSample {
    public typealias Left = Paired<
        P.Left.Left, Paired<Succ<P.Left.Right.Left>, P.Left.Right.Right>
    >
    public typealias Answer = Paired<
        P.Answer.Left, Paired<P.Answer.Right.Left, Succ<P.Answer.Right.Right>>
    >
    public typealias Right = Answer
    public typealias Sigma = P.Sigma
    public typealias Encoding = P.Encoding
    public typealias Predicate = P.Predicate
}

public enum SensorAddD<P: SpectralSample>: SpectralSample {
    public typealias Left = Paired<
        P.Left.Left, Paired<P.Left.Right.Left, Succ<P.Left.Right.Right>>
    >
    public typealias Answer = Paired<
        Succ<P.Answer.Left>,
        Paired<Succ<P.Answer.Right.Left>, Succ<P.Answer.Right.Right>>
    >
    public typealias Right = Answer
    public typealias Sigma = P.Sigma
    public typealias Encoding = P.Encoding
    public typealias Predicate = P.Predicate
}

/// The second instrument reads the retained source, not the coarse image.
public enum FourthChannelReading<P: SpectralSample>: PredicateReading {
    public typealias Left = P.Left
    public typealias Answer = P.Left.Right.Right
    public typealias Right = Answer
    public typealias Sigma = P.Sigma
    public typealias Encoding = FourthChannelEncoding
    public typealias Predicate = FourthChannelQuestion
}

/// Generic equality follows from the increments without an answer premise.
public typealias MixedSpectralVerdict<P: SpectralSample> = JoinedVerdict<
    SensorAddC<SensorAddB<SensorAddA<P>>>, SensorAddD<P>
>
