import VerificationIsIdentification

/// A uniform verdict constructs two factorizations through one actual fact
/// decoder. No equality of the decoder applications is supplied. [VI VC60]
public enum SharedFactFromVerdict<C: VerdictIsInvariant>: SharedDecoder
where C.Left.Left: Structure, C.Right.Left: Structure {
    public typealias Left = AcquireAnswer<C.Left>
    public typealias Right = AcquireAnswer<C.Right>
}

/// The local common fact keeps its context and question. Both actual sources
/// and the resident context remain distinct fields in the complete record.
public typealias CommonFactConstruction<
    H: Structure,
    C: VerdictIsInvariant
> = RetainedConstruction<H, C.Left.Left, C.Right.Left, FactOf<C.Left>>
where C.Left.Left: Structure, C.Right.Left: Structure

/// The necessary verdict is derived from the shared decoder, then the same
/// existing construction supplies a canonical common fact. [VI VC60]
public typealias CommonFactFromSharedDecoder<
    H: Structure,
    S: SharedDecoder
> = CommonFactConstruction<H, AnswersThroughSharedDecoder<S>>
where S.Left.Left.Left: Structure, S.Right.Left.Left: Structure

/// Two realizations can use different memories and decoders. Sharing one
/// actual source reading forces agreement of their other source answers.
public typealias CommonAnswerAcrossRealizations<
    S: SharedDecoder,
    T: SharedDecoder
> = JoinedVerdict<S.Right.Left, T.Right.Left>
where S.Left.Left == T.Left.Left

/// Both ends of a positive constructor distinction are tied to answers of
/// the same question and context. This is not an arbitrary inequality test.
public typealias ZeroSuccessorBoundary<
    L: PredicateReading,
    R: PredicateReading,
    N: IntegerValued
> = ZeroSuccessorDistinction<N>
where L.Sigma == R.Sigma, L.Encoding == R.Encoding,
      L.Predicate == R.Predicate,
      L.Answer == Never, R.Answer == Succ<N>

public typealias SuccessorZeroBoundary<
    L: PredicateReading,
    R: PredicateReading,
    N: IntegerValued
> = InternalSwap<ZeroSuccessorBoundary<R, L, N>>
where L.Sigma == R.Sigma, L.Encoding == R.Encoding,
      L.Predicate == R.Predicate,
      L.Answer == Succ<N>, R.Answer == Never

/// A failed common-answer request can itself leave a source-bound record.
/// Its event contains the channel address and the ordered obstruction. It
/// has no HasVerdict conformance claiming to be an answer to that question.
public typealias ZeroSuccessorBoundaryRecord<
    H: Structure,
    L: PredicateReading,
    R: PredicateReading,
    N: IntegerValued
> = RetainedConstruction<H, L.Left, R.Left, Paired<ChannelOf<L>, ZeroSuccessorBoundary<L, R, N>>>
where L.Left: Structure, R.Left: Structure,
      L.Sigma == R.Sigma, L.Encoding == R.Encoding,
      L.Predicate == R.Predicate,
      L.Answer == Never, R.Answer == Succ<N>

public typealias SuccessorZeroBoundaryRecord<
    H: Structure,
    L: PredicateReading,
    R: PredicateReading,
    N: IntegerValued
> = RetainedConstruction<H, L.Left, R.Left, Paired<ChannelOf<L>, SuccessorZeroBoundary<L, R, N>>>
where L.Left: Structure, R.Left: Structure,
      L.Sigma == R.Sigma, L.Encoding == R.Encoding,
      L.Predicate == R.Predicate,
      L.Answer == Succ<N>, R.Answer == Never

/// This restricted interface reports failure without its orientation. The
/// complete boundary record still retains the ordered obstruction. [VI VC61]
public typealias ZeroSuccessorBoundaryImage<
    L: PredicateReading,
    R: PredicateReading,
    N: IntegerValued
> = AddressedRepresentation<ChannelOf<L>, Never>
where L.Sigma == R.Sigma, L.Encoding == R.Encoding,
      L.Predicate == R.Predicate,
      L.Answer == Never, R.Answer == Succ<N>

public typealias SuccessorZeroBoundaryImage<
    L: PredicateReading,
    R: PredicateReading,
    N: IntegerValued
> = ZeroSuccessorBoundaryImage<R, L, N>
where L.Sigma == R.Sigma, L.Encoding == R.Encoding,
      L.Predicate == R.Predicate,
      L.Answer == Succ<N>, R.Answer == Never
