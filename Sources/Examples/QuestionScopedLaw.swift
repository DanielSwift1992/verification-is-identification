import VerificationIsIdentification

/// The prepared argument is inside the source. The four admitted calibration
/// witnesses derive this answer by applying Route00/01/10/11 to that argument.
public enum FirstSelectionProbe<C: Null>: PredicateReading
where C.Right: Pair, C.Right.Left: Structure, C.Right.Right: Structure {
    public typealias Left = Paired<C.Left, RoutingProbeP>
    public typealias Right = C.Right.Left
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RoutedValueQuestion
    public typealias Answer = Right
}

/// The same resident law acts on separately supplied data. The old prepared
/// probe remains in the whole and is not substituted for the new argument.
public enum SelectionWithResidentProbe<C: Null, X: Structure, R: PredicateReading>: PredicateReading
where C.Right: Pair, C.Right.Left: Structure, C.Right.Right: Structure,
      R.Left == Paired<C.Left, X>, R.Sigma == BeamSpace,
      R.Encoding == SaturationEncoding, R.Predicate == RoutedValueQuestion {
    public typealias Left = Paired<FirstSelectionProbe<C>.Left, X>
    public typealias Right = R.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RoutedValueQuestion
    public typealias Answer = Right
}

public typealias RowRepeatedData<A: Structure, B: Structure> = BoundaryWorking<A, A, B, B>

public typealias SelectionProbeMemory<C: Null, X: Structure> = ReadingBesideInput<
    AcquireAnswer<FirstSelectionProbe<C>>.Observation, X
>
where C.Right: Pair, C.Right.Left: Structure, C.Right.Right: Structure

/// The record chooses the first row. Neither its column nor a law identity
/// is an argument. The source-bound factor separately supplies authenticity.
public enum FirstRowFromRecord<M: Pair>: PredicateReading
where M.Left: HasVerdict, M.Left.Answer == Never,
      M.Left.Sigma == BeamSpace, M.Left.Encoding == SaturationEncoding,
      M.Left.Predicate == RoutedValueQuestion,
      M.Right: Pair, M.Right.Left: Pair {
    public typealias Left = M
    public typealias Right = M.Right.Left.Left
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RoutedValueQuestion
    public typealias Answer = Right
}

public enum SecondRowFromRecord<M: Pair>: PredicateReading
where M.Left: HasVerdict, M.Left.Answer == Lit1,
      M.Left.Sigma == BeamSpace, M.Left.Encoding == SaturationEncoding,
      M.Left.Predicate == RoutedValueQuestion,
      M.Right: Pair, M.Right.Right: Pair {
    public typealias Left = M
    public typealias Right = M.Right.Right.Left
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RoutedValueQuestion
    public typealias Answer = Right
}

/// Four admitted clauses, two shared decoders. Each body derives equality
/// from its actual Route application on the repeated-row data family.
public enum RowSelection00<A: Structure, B: Structure>: ReadingFactors {
    public typealias X = RowRepeatedData<A, B>
    public typealias Left = SelectionWithResidentProbe<SelectionCalibration00, X, Route00<X>>
    public typealias Observation = SelectionProbeMemory<SelectionCalibration00, X>
    public typealias Right = FirstRowFromRecord<Observation.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RoutedValueQuestion
    public typealias Answer = Left.Answer
}
public enum RowSelection01<A: Structure, B: Structure>: ReadingFactors {
    public typealias X = RowRepeatedData<A, B>
    public typealias Left = SelectionWithResidentProbe<SelectionCalibration01, X, Route01<X>>
    public typealias Observation = SelectionProbeMemory<SelectionCalibration01, X>
    public typealias Right = FirstRowFromRecord<Observation.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RoutedValueQuestion
    public typealias Answer = Left.Answer
}
public enum RowSelection10<A: Structure, B: Structure>: ReadingFactors {
    public typealias X = RowRepeatedData<A, B>
    public typealias Left = SelectionWithResidentProbe<SelectionCalibration10, X, Route10<X>>
    public typealias Observation = SelectionProbeMemory<SelectionCalibration10, X>
    public typealias Right = SecondRowFromRecord<Observation.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RoutedValueQuestion
    public typealias Answer = Left.Answer
}
public enum RowSelection11<A: Structure, B: Structure>: ReadingFactors {
    public typealias X = RowRepeatedData<A, B>
    public typealias Left = SelectionWithResidentProbe<SelectionCalibration11, X, Route11<X>>
    public typealias Observation = SelectionProbeMemory<SelectionCalibration11, X>
    public typealias Right = SecondRowFromRecord<Observation.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RoutedValueQuestion
    public typealias Answer = Left.Answer
}

/// A constant data argument supports one answer across all four clauses.
public enum ConstantSelectionEvidence<A: Structure>: Null {
    public typealias X = RowRepeatedData<A, A>
    public typealias Left = BoundaryWorking<Route00<X>.Answer, Route01<X>.Answer, Route10<X>.Answer, Route11<X>.Answer>
    public typealias Right = X
}

/// This decoder accepts the constant input alone, without a law fact.
public enum ConstantSelectionAnswer<A: Structure>: PredicateReading {
    public typealias Left = RowRepeatedData<A, A>
    public typealias Right = A
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RoutedValueQuestion
    public typealias Answer = Right
}

/// Exchange the module law with its resident reserve. Probe and data survive
/// at the same addresses, and the old law moves into the reserve.
public enum ExchangeSelectionReserve<W: Pair>: PredicateReading
where W.Left: Pair, W.Left.Left: Pair,
      W.Left.Left.Left: Structure, W.Left.Left.Right: Structure,
      W.Left.Right: Structure, W.Right: Structure {
    public typealias Left = W
    public typealias Right = Paired<
        Paired<Paired<W.Right, W.Left.Left.Right>, W.Left.Right>,
        W.Left.Left.Left
    >
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RoutingReserveExchangeOperation
    public typealias Answer = Right
}

public typealias SelectionAfterReserveChange<
    Old: Null, New: Null, X: Structure, R: PredicateReading
> = SequentialReading<
    ExchangeSelectionReserve<Paired<Paired<FirstSelectionProbe<Old>.Left, X>, New.Left>>,
    DecodeRefinedEvidence<
        FirstEvidenceImage<Paired<Paired<FirstSelectionProbe<New>.Left, X>, Old.Left>, BeamSpace, SaturationEncoding, RoutedValueQuestion>,
        SelectionWithResidentProbe<New, X, R>
    >
>
where Old.Right: Pair, Old.Right.Left: Structure, Old.Right.Right: Structure,
      New.Right: Pair, New.Right.Left: Structure, New.Right.Right: Structure,
      R.Left == Paired<New.Left, X>, R.Sigma == BeamSpace,
      R.Encoding == SaturationEncoding, R.Predicate == RoutedValueQuestion

/// Reuse a supplied memory decoder for a question about the specified change.
/// Its correctness across the change is established by the factor below.
public enum SelectionChangeDecoder<R: PredicateReading>: PredicateReading {
    public typealias Left = R.Left
    public typealias Right = R.Answer
    public typealias Sigma = R.Sigma
    public typealias Encoding = R.Encoding
    public typealias Predicate = OperationSequence<RoutingReserveExchangeOperation, R.Predicate>
    public typealias Answer = Right
}

/// 00 changes to the distinct law 01. Repeated-row data still has the same
/// answer through the same old first-probe record. Law equality is not assumed.
public enum RowLawChangePreservesAnswer<A: Structure, B: Structure>: ReadingFactors {
    public typealias X = RowRepeatedData<A, B>
    public typealias World = Paired<RowSelection00<A, B>.Left.Left, RoutingAddress01>
    public typealias Earlier = FactorOnSource<
        RowSelection00<A, B>,
        FirstEvidenceImage<World, BeamSpace, SaturationEncoding, RoutedValueQuestion>
    >
    public typealias Left = SelectionAfterReserveChange<SelectionCalibration00, SelectionCalibration01, X, Route01<X>>
    public typealias Observation = Earlier.Observation
    public typealias Right = SelectionChangeDecoder<Earlier.Right>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Left.Predicate
    public typealias Answer = Left.Answer
}

/// A cross-row replacement can change the answer. Acquire the new row through
/// the existing p probe at the actual endpoint, then reuse that row's decoder.
/// The earlier p fact is not substituted for this acquisition. [VI VC85–VC86]
public enum RowLawChangeReacquiresAnswer<A: Structure, B: Structure>: ReadingFactors {
    public typealias X = RowRepeatedData<A, B>
    public typealias Change = ExchangeSelectionReserve<Paired<RowSelection00<A, B>.Left.Left, RoutingAddress10>>
    public typealias CurrentSource = DecodeRefinedEvidence<Change,
        FirstEvidenceImage<Change.Answer, BeamSpace, SaturationEncoding, RoutedValueQuestion>>
    public typealias AcquiredAfter = FactorOnSource<RowSelection10<A, B>, CurrentSource>
    public typealias Left = SelectionAfterReserveChange<SelectionCalibration00, SelectionCalibration10, X, Route10<X>>
    public typealias Observation = AcquiredAfter.Observation
    public typealias Right = SelectionChangeDecoder<AcquiredAfter.Right>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Left.Predicate
    public typealias Answer = Left.Answer
}

/// Change the law inside an instrument's retained source while
/// preserving its old trace, channel, data and displaced law.
public enum ExchangeObservedSelection<W: Pair>: Pair
where W.Left: Pair, W.Left.Left: Pair, W.Left.Left.Left: Pair,
      W.Left.Left.Left.Left: Structure, W.Left.Left.Left.Right: Structure,
      W.Left.Left.Right: Structure, W.Left.Right: Structure, W.Right: Structure {
    public typealias Left = W
    public typealias Right = Paired<
        Paired<Paired<Paired<W.Right, W.Left.Left.Left.Right>, W.Left.Left.Right>, W.Left.Right>,
        W.Left.Left.Left.Left
    >
}

/// One prepared probe and the replacement law are present initially. The
/// complete path acquires the fact and then changes the actual module law.
public enum ScopedLawResidentRun<A: Structure, B: Structure>: Pair {
    public typealias Probe = FirstSelectionProbe<SelectionCalibration00>
    public typealias Instrument = PreparedTraceExtension<StartObservations<Probe.Left>, Probe>
    public typealias Acquisition = StepBeside<StepBeside<Instrument, RowRepeatedData<A, B>>, RoutingAddress01>
    public typealias Change = ExchangeObservedSelection<Acquisition.Right>
    public typealias Path = FollowedPair<Acquisition, Change>
    public typealias Left = Path.Left
    public typealias Right = Path.Right
}
