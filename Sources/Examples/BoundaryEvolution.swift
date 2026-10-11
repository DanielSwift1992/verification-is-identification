import VerificationIsIdentification

/// Combine two decoders of one actual memory. The resulting paired answer
/// is derived from the source-bound factors, without another acquisition.
public enum JointEvidenceFromMemory<F: ReadingFactors, G: ReadingFactors>: ReadingFactors
where F.Observation == G.Observation, F.Answer: Structure, G.Answer: Structure {
    public typealias Left = JointEvidence<F.Left, G.Left>
    public typealias Right = JointEvidence<F.Right, G.Right>
    public typealias Observation = F.Observation
    public typealias Sigma = F.Sigma
    public typealias Encoding = F.Encoding
    public typealias Predicate = OperationSequence<F.Predicate, G.Predicate>
    public typealias Answer = Paired<F.Answer, G.Answer>
}

public typealias BoundaryPairReading<P: Pair> = JointEvidence<BoundaryFirstAlpha<P>, BoundarySecondAlpha<P>>
where P.Left: BeamShape, P.Right: BeamShape

/// The same exchange constructor acts on whole components and on their
/// ordered answer image. It retains both fields in opposite positions.
public enum SwapBoundaryReading<P: Pair>: PredicateReading
where P.Left: Structure, P.Right: Structure {
    public typealias Left = P
    public typealias Right = Paired<P.Right, P.Left>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = SwapOperation
    public typealias Answer = Right
}

public enum SwapBoundaryTransition<P: Pair>: CommutingTransition
where P.Left: BeamShape & Structure, P.Right: BeamShape & Structure {
    public typealias Left = BoundaryPairReading<P>
    public typealias Right = BoundaryPairReading<SwapBoundaryReading<P>.Answer>
    public typealias SourceStep = SwapBoundaryReading<P>
    public typealias ImageStep = SwapBoundaryReading<Left.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Operation = SwapOperation
}

/// The common-answer class is unchanged under exchange of the two sides.
/// The source-to-class squares establish where this image action applies.
public enum KeepBoundaryUnderSwap<I>: PredicateReading {
    public typealias Left = I
    public typealias Right = I
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = SwapOperation
    public typealias Answer = Right
}

public enum FirstFieldsOperation: Close {}

/// Exchange the first component's alpha and beta. The former alpha remains
/// in beta, and the second component and the first's hidden field remain.
public enum ExchangedBoundaryFirst<P: Pair>: Pair
where P.Left: BeamShape {
    public typealias Left = SwapVisible<P.Left>
    public typealias Right = P.Right
}

public enum ExchangeBoundaryFirst<P: Pair>: PredicateReading
where P.Left: BeamShape {
    public typealias Left = P
    public typealias Right = ExchangedBoundaryFirst<P>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = FirstFieldsOperation
    public typealias Answer = Right
}

/// The old first alpha is absent from this local image, but retained in the
/// changed source's beta. The square below requires an actual resident zero.
public enum BoundaryFirstZeroImage<I: Pair>: PredicateReading
where I.Right: Structure {
    public typealias Left = I
    public typealias Right = Paired<Never, I.Right>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = FirstFieldsOperation
    public typealias Answer = Right
}

public enum BoundaryFirstZeroTransition<P: Pair>: CommutingTransition
where P.Left: BeamShape, P.Right: BeamShape, P.Left.BetaLevel == Never {
    public typealias Left = BoundaryPairReading<P>
    public typealias Right = BoundaryPairReading<ExchangedBoundaryFirst<P>>
    public typealias SourceStep = ExchangeBoundaryFirst<P>
    public typealias ImageStep = BoundaryFirstZeroImage<Left.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Operation = FirstFieldsOperation
}

/// Read the other coordinate of an ordered image in its original layout.
public enum SecondEvidenceImage<I: Pair, S, E, Q>: PredicateReading {
    public typealias Left = I
    public typealias Right = I.Right
    public typealias Sigma = S
    public typealias Encoding = E
    public typealias Predicate = Q
    public typealias Answer = Right
}

public typealias AgreedBoundaryPairClass<I: Pair> = AgreedMemoryBoundary<JoinedVerdict<
    FirstEvidenceImage<I, BeamSpace, SaturationEncoding, AlphaQuestion>,
    SecondEvidenceImage<I, BeamSpace, SaturationEncoding, AlphaQuestion>
>>
where I.Left == I.Right

public typealias ZeroSuccessorBoundaryPairClass<I: Pair, N: IntegerValued> = ZeroSuccessorMemoryBoundary<
    FirstEvidenceImage<I, BeamSpace, SaturationEncoding, AlphaQuestion>,
    SecondEvidenceImage<I, BeamSpace, SaturationEncoding, AlphaQuestion>, N
>
where I.Left == Never, I.Right == Succ<N>

public typealias SuccessorZeroBoundaryPairClass<I: Pair, N: IntegerValued> = SuccessorZeroMemoryBoundary<
    FirstEvidenceImage<I, BeamSpace, SaturationEncoding, AlphaQuestion>,
    SecondEvidenceImage<I, BeamSpace, SaturationEncoding, AlphaQuestion>, N
>
where I.Left == Succ<N>, I.Right == Never

/// The three clauses cover the binary common-answer classes. Their image
/// action is identical, including at the two opposite failure orientations.
public enum AgreedBoundarySwap<I: Pair>: CommutingTransition
where I.Left: IntegerValued, I.Left == I.Right {
    public typealias Left = AgreedBoundaryPairClass<I>
    public typealias Right = AgreedBoundaryPairClass<SwapBoundaryReading<I>.Answer>
    public typealias SourceStep = SwapBoundaryReading<I>
    public typealias ImageStep = KeepBoundaryUnderSwap<Left.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Operation = SwapOperation
}

public enum ZeroSuccessorBoundarySwap<I: Pair, N: IntegerValued>: CommutingTransition
where I.Left == Never, I.Right == Succ<N> {
    public typealias Left = ZeroSuccessorBoundaryPairClass<I, N>
    public typealias Right = SuccessorZeroBoundaryPairClass<SwapBoundaryReading<I>.Answer, N>
    public typealias SourceStep = SwapBoundaryReading<I>
    public typealias ImageStep = KeepBoundaryUnderSwap<Left.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Operation = SwapOperation
}

public enum SuccessorZeroBoundarySwap<I: Pair, N: IntegerValued>: CommutingTransition
where I.Left == Succ<N>, I.Right == Never {
    public typealias Left = SuccessorZeroBoundaryPairClass<I, N>
    public typealias Right = ZeroSuccessorBoundaryPairClass<SwapBoundaryReading<I>.Answer, N>
    public typealias SourceStep = SwapBoundaryReading<I>
    public typealias ImageStep = KeepBoundaryUnderSwap<Left.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Operation = SwapOperation
}
