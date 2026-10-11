import VerificationIsIdentification

/// These squares classify full images before and after the guarded action.
/// Together they cover every enabled source in the binary fragment. [VI VC51]
public enum RepeatSpectrumClassTransition<I: Pair>: CommutingTransition
where I.Left: IntegerValued, I.Right: Pair,
      I.Left == I.Right.Left, I.Left == I.Right.Right {
    public typealias Left = ReadySpectrumClass<I>
    public typealias Right = ReadySpectrumClass<MatchedSwapImage<I>.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Operation = MatchedSwapOperation
    public typealias SourceStep = MatchedSwapImage<I>
    public typealias ImageStep = RepeatReadyImage<I.Left>
}

public enum ZeroSuccessorSpectrumClassTransition<I: Pair, N: IntegerValued>: CommutingTransition
where I.Left == Never, I.Right: Pair,
      I.Right.Left == Succ<N>, I.Right.Right == Never {
    public typealias Left = ReadySpectrumClass<I>
    public typealias Right = SuccessorBlockedSpectrumClass<MatchedSwapImage<I>.Answer, N>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Operation = MatchedSwapOperation
    public typealias SourceStep = MatchedSwapImage<I>
    public typealias ImageStep = ZeroToSuccessorImage<N>
}

public enum SuccessorZeroSpectrumClassTransition<I: Pair, N: IntegerValued>: CommutingTransition
where I.Left == Succ<N>, I.Right: Pair,
      I.Right.Left == Never, I.Right.Right == Succ<N> {
    public typealias Left = ReadySpectrumClass<I>
    public typealias Right = ZeroBlockedSpectrumClass<MatchedSwapImage<I>.Answer, N>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Operation = MatchedSwapOperation
    public typealias SourceStep = MatchedSwapImage<I>
    public typealias ImageStep = SuccessorToZeroImage<N>
}

/// Source-to-class squares are existing compositions, with no duplicated
/// implementations of either the source action or the class action.
public typealias RepeatClassTransition<B: BeamShape> = ReobservedTransition<
    MatchedSwapTransition<B>,
    RepeatSpectrumClassTransition<FullSpectrumImage<B>>
>
where B.AlphaLevel == B.PaschenLevel, B.AlphaLevel == B.BetaLevel

public typealias ZeroSuccessorClassTransition<B: BeamShape, N: IntegerValued> = ReobservedTransition<
    MatchedSwapTransition<B>,
    ZeroSuccessorSpectrumClassTransition<FullSpectrumImage<B>, N>
>
where B.AlphaLevel == Never, B.BetaLevel == Succ<N>, B.PaschenLevel == Never

public typealias SuccessorZeroClassTransition<B: BeamShape, N: IntegerValued> = ReobservedTransition<
    MatchedSwapTransition<B>,
    SuccessorZeroSpectrumClassTransition<FullSpectrumImage<B>, N>
>
where B.AlphaLevel == Succ<N>, B.BetaLevel == Never, B.PaschenLevel == Succ<N>

/// Agreement with the independently specified source question is derived
/// from the coordinate constructors, not assumed by QuestionOnObservation.
public enum ReadyAlphaFactors<B: BeamShape>: ReadingFactors
where B.AlphaLevel == B.PaschenLevel {
    public typealias Left = SpectrumAlphaSource<B>
    public typealias Observation = ReadyClassReading<B>
    public typealias Right = ReadRecordedAnswer<Observation.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = AlphaQuestion
    public typealias Answer = B.AlphaLevel
}

public enum ZeroBlockedAlphaFactors<B: BeamShape, N: IntegerValued>: ReadingFactors
where B.AlphaLevel == Never, B.PaschenLevel == Succ<N> {
    public typealias Left = SpectrumAlphaSource<B>
    public typealias Observation = ZeroBlockedClassReading<B, N>
    public typealias Right = ReadRecordedAnswer<Observation.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = AlphaQuestion
    public typealias Answer = B.AlphaLevel
}

public enum SuccessorBlockedAlphaFactors<B: BeamShape, N: IntegerValued>: ReadingFactors
where B.AlphaLevel == Succ<N>, B.PaschenLevel == Never {
    public typealias Left = SpectrumAlphaSource<B>
    public typealias Observation = SuccessorBlockedClassReading<B, N>
    public typealias Right = ReadRecordedAnswer<Observation.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = AlphaQuestion
    public typealias Answer = B.AlphaLevel
}

/// Append at the actual endpoint. The original source's guard is not reused
/// as permission at a new source; the new endpoint carries both equalities.
public typealias AppendRepeatClass<
    P: CommutingTransition,
    B: BeamShape
> = JoinedTransition<P, RepeatClassTransition<B>>
where P.Right == ReadyClassReading<B>,
      B.AlphaLevel == B.PaschenLevel, B.AlphaLevel == B.BetaLevel
