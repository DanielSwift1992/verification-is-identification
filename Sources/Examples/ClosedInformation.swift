import VerificationIsIdentification

/// S.Right names the actual local successor in the supplied law graph.
/// Ready and recorded forms are the two phases of one closed exchange.
/// Left exposes the local form and all of this model's remaining record.
/// Right is the next complete phase, not a newly supplied local law. [M70]
public enum ReadyLawState<S: Pair>: Pair
where S.Right: Structure {
    public typealias Left = Paired<S, Never>
    public typealias Right = RecordedLawState<S>
}

/// The displayed successor can merge sources. The resident record retains
/// S, so the whole exchange returns to the same prepared source.
/// This inverse also retracts the displayed local result. [M70]
public enum RecordedLawState<S: Pair>: Pair
where S.Right: Structure {
    public typealias Left = Paired<S.Right, Paired<S, Never>>
    public typealias Right = ReadyLawState<S>
}

/// Recover preparation from the recorded fields alone. No earlier source
/// parameter is supplied. This is a decoder on the shown record shape;
/// admission of that record still requires the actual local law. [M70]
public enum ReadPreparedLawSource<O: Pair>: Pair
where O.Right: Pair, O.Right.Left: Structure, O.Right.Right == Never {
    public typealias Left = O
    public typealias Right = Paired<O.Right.Left, Never>
}

/// The previous whole is a recoverable component of the next record. This
/// models an increasing history, with no fixed finite capacity assertion.
public enum RetainedWhole<Before: Structure, Event: Structure>: Permanent {
    public typealias Left = Before
    public typealias Right = Paired<Before, Event>
}

/// Two actual swap applications return the selected fields. Their explicit
/// record retains both operation addresses and both results. The final
/// record recovers the initial record through its two retention legs.
/// These are constructed record relations, not evidence that a symbolic
/// application has physically occurred. [M55; Liquid LQ13]
public enum RecordedSwapReturn<A: Structure, B: Structure>: Null {
    public typealias Source = Paired<A, B>
    public typealias Before = Paired<Never, Source>
    public typealias First = SwapBoundaryReading<Source>
    public typealias Second = SwapBoundaryReading<Paired<B, A>>
    public typealias Return = SequentialReading<First, Second>
    public typealias FirstRecord = RetainedWhole<Before,
        Paired<First.Predicate, First.Answer>>.Right
    public typealias After = RetainedWhole<FirstRecord,
        Paired<Second.Predicate, Second.Answer>>.Right
    public typealias Left = AddressTriple<
        Return.Answer, After.Left.Left, After.Right.Right>
    public typealias Right = AddressTriple<Source, Before, Source>
}

/// Record both orders of disjoint applications on their full paired source.
/// Each event retains the lifted application, including its input, output
/// and addressed projections. Identical local rules can then have different
/// first occurrences. The final answers and recovered sources agree. [M67]
public enum RecordedIndependentOrders<F: PredicateReading, G: PredicateReading>: Null
where F.Sigma == G.Sigma, F.Encoding == G.Encoding,
      F.Left: Structure, G.Left: Structure, F.Answer: Structure, G.Answer: Structure {
    public typealias Source = Paired<F.Left, G.Left>
    public typealias FirstAtSource = PairedApplication<
        F, IdentityReading<G.Left, G.Sigma, G.Encoding>>
    public typealias SecondAfterFirst = PairedApplication<
        IdentityReading<F.Answer, F.Sigma, F.Encoding>, G>
    public typealias SecondAtSource = PairedApplication<
        IdentityReading<F.Left, F.Sigma, F.Encoding>, G>
    public typealias FirstAfterSecond = PairedApplication<
        F, IdentityReading<G.Answer, G.Sigma, G.Encoding>>
    public typealias FirstThenSecond = SequentialReading<FirstAtSource, SecondAfterFirst>
    public typealias SecondThenFirst = SequentialReading<SecondAtSource, FirstAfterSecond>
    public typealias FirstRecord = RetainedWhole<
        RetainedWhole<Source, FirstAtSource>.Right, SecondAfterFirst>
    public typealias SecondRecord = RetainedWhole<
        RetainedWhole<Source, SecondAtSource>.Right, FirstAfterSecond>
    public typealias Left = Paired<FirstRecord.Right.Left.Left, FirstThenSecond.Answer>
    public typealias Right = Paired<SecondRecord.Right.Left.Left, SecondThenFirst.Answer>
}

/// Two actual retention legs recover their earlier occurrences through the
/// same second projection. Their recovered answers retain the supplied
/// zero/successor contrast. Identifying the later carriers would therefore
/// identify these unequal constructors. No later inequality is a premise.
/// The scope is this fixed decoder, not every Pair used as a transition. [M55]
public enum RetainedOccurrenceContrast<
    Fresh: Pair,
    Earlier: Pair,
    N: IntegerValued
>: Null
where Fresh.Left == Never, Earlier.Left == Succ<N>,
      Fresh.Right: Pair, Earlier.Right: Pair,
      Fresh.Right.Right == Fresh.Left,
      Earlier.Right.Right == Earlier.Left {
    public typealias Obstruction = ZeroSuccessorDistinction<N>
    public typealias Left = Paired<Fresh.Right.Right, Earlier.Right.Right>
    public typealias Right = Paired<Obstruction.Left, Obstruction.Right>
}

/// X carries its earlier record on Left and current local form on Right.
/// Append that form's actual successor through the existing retained record.
/// Further use requires another admitted record form, without a fixed
/// finite capacity guarantee. [M70]
public typealias ExtendLawRecord<X: Pair> = RetainedWhole<X, X.Right.Right>
where X.Right: Pair, X.Right.Right: Structure

/// Append a successful actual reading while retaining its source and named
/// operation. Projection readings supply the witness in M66's finite family.
/// An arbitrary PredicateReading conformance still requires interpretation.
public typealias WitnessedOccurrence<R: PredicateReading> = RetainedWhole<
    R.Left, Paired<R.Predicate, R.Answer>
>
where R.Left: Structure, R.Predicate: Structure, R.Answer == Lit1

/// Read the prior fields and the recorded answer, omitting which operation
/// supplied it. The answer comes from the actual record's second field. [M66]
public typealias OccurrenceImage<R: PredicateReading> = JointEvidence<
    FirstEvidenceImage<WitnessedOccurrence<R>.Right, R.Sigma, R.Encoding, FirstProjection>,
    SequentialReading<
        SecondEvidenceImage<WitnessedOccurrence<R>.Right, R.Sigma, R.Encoding, SecondProjection>,
        SecondEvidenceImage<WitnessedOccurrence<R>.Right.Right, R.Sigma, R.Encoding, SecondProjection>
    >
>
where R.Left: Structure, R.Predicate: Structure, R.Answer == Lit1

/// Both components belong to the whole. Swapping them resets the first on
/// the restricted input (x, blank), while the second retains x.
public enum InternalSwap<S: Pair>: Pair {
    public typealias Left = S.Right
    public typealias Right = S.Left
}

/// Push eight addressed weights through (a,b,c) -> (a,b XOR c,c).
/// This permutes the 001/011 and 101/111 positions. Weight values are
/// uninterpreted here. Probabilities and binary state labels enter in M32.
public enum ExchangeParityWeights<W: Pair>: Pair
where W.Left: Pair, W.Right: Pair,
      W.Left.Left: Pair, W.Left.Right: Pair,
      W.Right.Left: Pair, W.Right.Right: Pair,
      W.Left.Left.Left: Structure, W.Left.Left.Right: Structure,
      W.Left.Right.Left: Structure, W.Left.Right.Right: Structure,
      W.Right.Left.Left: Structure, W.Right.Left.Right: Structure,
      W.Right.Right.Left: Structure, W.Right.Right.Right: Structure {
    public typealias Left = W
    public typealias Right = Paired<
        MatrixEntries<W.Left.Left.Left, W.Left.Right.Right,
            W.Left.Right.Left, W.Left.Left.Right>,
        MatrixEntries<W.Right.Left.Left, W.Right.Right.Right,
            W.Right.Right.Left, W.Right.Left.Right>>
}

/// Group actual source weights into the two slices to add for each pair
/// marginal. The four-entry matrix shape is reused as a plain count table.
/// This constructor selects operands. It neither adds them nor normalizes.
public enum ThreeBitMarginalOperands<W: Pair>: Pair
where W.Left: Pair, W.Right: Pair,
      W.Left.Left: Pair, W.Left.Right: Pair,
      W.Right.Left: Pair, W.Right.Right: Pair,
      W.Left.Left.Left: Structure, W.Left.Left.Right: Structure,
      W.Left.Right.Left: Structure, W.Left.Right.Right: Structure,
      W.Right.Left.Left: Structure, W.Right.Left.Right: Structure,
      W.Right.Right.Left: Structure, W.Right.Right.Right: Structure {
    public typealias Left = W
    public typealias WithoutFirst = Paired<
        MatrixEntries<W.Left.Left.Left, W.Left.Left.Right,
            W.Left.Right.Left, W.Left.Right.Right>,
        MatrixEntries<W.Right.Left.Left, W.Right.Left.Right,
            W.Right.Right.Left, W.Right.Right.Right>>
    public typealias WithoutMiddle = Paired<
        MatrixEntries<W.Left.Left.Left, W.Left.Left.Right,
            W.Right.Left.Left, W.Right.Left.Right>,
        MatrixEntries<W.Left.Right.Left, W.Left.Right.Right,
            W.Right.Right.Left, W.Right.Right.Right>>
    public typealias WithoutLast = Paired<
        MatrixEntries<W.Left.Left.Left, W.Left.Right.Left,
            W.Right.Left.Left, W.Right.Right.Left>,
        MatrixEntries<W.Left.Left.Right, W.Left.Right.Right,
            W.Right.Left.Right, W.Right.Right.Right>>
    public typealias Right = AddressTriple<WithoutFirst, WithoutMiddle, WithoutLast>
}

/// Rotate three resident fields. This is one finite tape transformation,
/// without a claim of independent randomness or a physical transcript.
public enum RotateThree<T: Pair>: Pair
where T.Left: Structure, T.Right: Pair,
      T.Right.Left: Structure, T.Right.Right: Structure {
    public typealias Left = T.Right.Left
    public typealias Right = Paired<T.Right.Right, T.Left>
}

/// Move the next resident field into the accessible cache pair. Pair shape
/// supplies the field, not a probability law or an infinite memory resource.
public enum ExposeNext<T: Pair>: Pair
where T.Left: Structure, T.Right: Pair,
      T.Right.Left: Structure, T.Right.Right: Structure {
    public typealias Left = Paired<T.Left, T.Right.Left>
    public typealias Right = T.Right.Right
}

/// Rewind one exposure by splitting the cache pair. Field recovery is
/// structural, without identifying a nominal wrapper with its contents.
public enum RewindExposure<T: Pair>: Pair
where T.Left: Pair, T.Left.Left: Structure,
      T.Left.Right: Structure, T.Right: Structure {
    public typealias Left = T.Left.Left
    public typealias Right = Paired<T.Left.Right, T.Right>
}

/// Visible compression and its residual remain inside one representation.
/// Recovery is of the three coordinates, not equality of nominal wrappers.
public enum BeamWithResidual<B: BeamShape>: Pair {
    public typealias Left = EyeImage<B>
    public typealias Right = B.PaschenLevel
}

/// Current and next first-coordinate observations under internal swap. This
/// is a mathematical trace, with no free physical recording device asserted.
public enum SwapWindow<S: Pair>: Pair {
    public typealias Left = S.Left
    public typealias Right = InternalSwap<S>.Left
}

/// Two equalities compose only when they name the same intermediate type.
public enum GluedEqualities<F: Null, G: Null>: Null
where F.Right == G.Left {
    public typealias Left = F.Left
    public typealias Right = G.Right
}

/// A supplied answer recovery also recovers that answer beside its actual
/// evidence. Both fields use the same observation, with no new acquisition.
/// For an identity question this recovers the source-image graph. [VI VC9]
public typealias AnswerWithItsEvidence<F: ReadingFactors> = JointEvidenceFromMemory<
    F,
    QuestionOnObservation<
        F.Observation,
        IdentityReading<F.Observation.Answer, F.Sigma, F.Encoding>
    >
>
where F.Answer: Structure, F.Observation.Answer: Structure

/// A zero input, a claimed answer and a recurring tail. With a binary Claim,
/// the local equation claim = input OR next.claim accepts both zero and one.
/// Every finite unfolding still reads a zero input. The one claim therefore
/// has recursive support but no positive input witness. [VI VC23]
public enum ZeroInputClaimTail<Claim: Structure>: Pair {
    public typealias Left = Never
    public typealias Right = Paired<Claim, ZeroInputClaimTail<Claim>>
}

/// One strict budget step in the concrete Never/Succ numeral grammar.
/// Arbitrary IntegerValued conformances need a separate termination argument.
public enum SpendSuccessor<P: IntegerValued>: Pair {
    public typealias Left = VerificationIsIdentification.Succ<P>
    public typealias Right = P
}

/// Pair both raw records and their decoded fact collections. Interpreting
/// the latter pair by set union retains old facts without counting duplicates.
public enum AppendedCacheReading<Before: Pair, Event: Pair>: Pair
where Before.Left: Structure, Before.Right: Structure,
      Event.Left: Structure, Event.Right: Structure {
    public typealias Left = Paired<Before.Left, Event.Left>
    public typealias Right = Paired<Before.Right, Event.Right>
}

/// Construct the Permanent cache relation from an explicit append. The caller
/// supplies the structural frame, not CachePermanent. Correctness of inserted
/// facts and the union interpretation remain separate semantic obligations.
public enum CacheByAppending<
    Frame: StructuresFinite,
    Before: Pair,
    Event: Pair
>: CachePermanent
where Frame: OperationsClosed,
      Before.Left: Structure, Before.Right: Structure,
      Event.Left: Structure, Event.Right: Structure {
    public typealias Left = Frame.Left
    public typealias Right = Frame.Right
    public typealias Sigma = Frame.Sigma
    public typealias Reading = AppendedCacheReading<Before, Event>
    public typealias RawStep = RetainedWhole<Before.Left, Event.Left>
    public typealias Cache = RetainedWhole<Before.Right, Event.Right>
}

/// The resident law address is retained. Each endpoint contains two mutually
/// recoverable copies of its value. This derives agreement within each state
/// for any supplied reading, without requiring preservation across states.
/// Reading this Pair as a history retains both endpoints in one object.
public enum MutualRecordUpdate<R: PredicateReading>: Pair
where R.Left: Structure, R.Answer: Structure, R.Predicate: Structure {
    public typealias Left = Paired<R.Predicate, Paired<R.Left, R.Left>>
    public typealias Right = Paired<R.Predicate, Paired<R.Answer, R.Answer>>
}

public enum ConstantResetQuestion: Close {}

/// A declared non-preserving current-state law. It is used to test whether
/// mutual endpoint records imply preservation, not to assert a physical reset
/// without a residual. Its complete represented history retains the input.
public enum ConstantResetReading<X: Structure>: PredicateReading {
    public typealias Left = X
    public typealias Right = Never
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = ConstantResetQuestion
    public typealias Answer = Right
}
