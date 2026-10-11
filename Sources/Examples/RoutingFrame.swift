import VerificationIsIdentification

public enum DirectOutputFrame: Close {}
public enum CrossedOutputFrame: Close {}

public enum RouteByThirdEqualityQuestion: Close {}

/// A data-only consumer assembled from the existing projections. M65 proves
/// that it also computes the equality-controlled rule on two-content triples.
public typealias SwapFirstTwoTriple<I: Pair> = JointEvidence<
    SequentialReading<SecondEvidenceImage<I, BeamSpace, SaturationEncoding, SecondProjection>,
        FirstEvidenceImage<I.Right, BeamSpace, SaturationEncoding, FirstProjection>>,
    JointEvidence<FirstEvidenceImage<I, BeamSpace, SaturationEncoding, FirstProjection>,
        SequentialReading<SecondEvidenceImage<I, BeamSpace, SaturationEncoding, SecondProjection>,
            SecondEvidenceImage<I.Right, BeamSpace, SaturationEncoding, SecondProjection>>>>
where I.Right: Pair, I.Left: Structure, I.Right.Left: Structure, I.Right.Right: Structure

/// Columns: distinct, first=second, first=third, second=third, all equal.
public typealias TriplePatternProfile<D: Structure, AB: Structure, AC: Structure,
    BC: Structure, All: Structure> = Paired<D, Paired<AB, Paired<AC, Paired<BC, All>>>>

public typealias FirstMarkerProfile = TriplePatternProfile<Never, Never, Never, Never, Never>
public typealias SecondMarkerProfile = TriplePatternProfile<Lit1, Never, Lit1, Lit1, Never>
public typealias ThirdMarkerProfile = TriplePatternProfile<Lit2, Lit1, Never, Lit1, Never>
public typealias TripleMarkerProfiles = CandidateFork<CandidateLeaf<FirstMarkerProfile>,
    CandidateFork<CandidateLeaf<SecondMarkerProfile>, CandidateLeaf<ThirdMarkerProfile>>>

public typealias SelectFirstMarkerProfile = SelectCandidateLeft<SelectCandidateLeaf<FirstMarkerProfile>,
    CandidateFork<CandidateLeaf<SecondMarkerProfile>, CandidateLeaf<ThirdMarkerProfile>>>
public typealias SelectSecondMarkerProfile = SelectCandidateRight<CandidateLeaf<FirstMarkerProfile>,
    SelectCandidateLeft<SelectCandidateLeaf<SecondMarkerProfile>, CandidateLeaf<ThirdMarkerProfile>>>
public typealias SelectThirdMarkerProfile = SelectCandidateRight<CandidateLeaf<FirstMarkerProfile>,
    SelectCandidateRight<CandidateLeaf<SecondMarkerProfile>, SelectCandidateLeaf<ThirdMarkerProfile>>>

/// Transpose three selected marker profiles into five predicted outputs.
/// The certificate domain uses the existing finite SelectCandidate grammar.
/// Arbitrary Pair conformances do not establish membership in that grammar.
public enum TriplePatternImages<A: Pair, B: Pair, C: Pair>: Pair
where A.Left == TripleMarkerProfiles, B.Left == A.Left, C.Left == A.Left,
      A.Right: Pair, B.Right: Pair, C.Right: Pair,
      A.Right.Right: Pair, B.Right.Right: Pair, C.Right.Right: Pair,
      A.Right.Right.Right: Pair, B.Right.Right.Right: Pair, C.Right.Right.Right: Pair,
      A.Right.Right.Right.Right: Pair, B.Right.Right.Right.Right: Pair, C.Right.Right.Right.Right: Pair,
      A.Right.Left: Structure, B.Right.Left: Structure, C.Right.Left: Structure,
      A.Right.Right.Left: Structure, B.Right.Right.Left: Structure, C.Right.Right.Left: Structure,
      A.Right.Right.Right.Left: Structure, B.Right.Right.Right.Left: Structure, C.Right.Right.Right.Left: Structure,
      A.Right.Right.Right.Right.Left: Structure, B.Right.Right.Right.Right.Left: Structure, C.Right.Right.Right.Right.Left: Structure,
      A.Right.Right.Right.Right.Right: Structure, B.Right.Right.Right.Right.Right: Structure, C.Right.Right.Right.Right.Right: Structure {
    public typealias Left = AddressTriple<A, B, C>
    public typealias Right = TriplePatternProfile<
        AddressTriple<A.Right.Left, B.Right.Left, C.Right.Left>,
        AddressTriple<A.Right.Right.Left, B.Right.Right.Left, C.Right.Right.Left>,
        AddressTriple<A.Right.Right.Right.Left, B.Right.Right.Right.Left, C.Right.Right.Right.Left>,
        AddressTriple<A.Right.Right.Right.Right.Left, B.Right.Right.Right.Right.Left, C.Right.Right.Right.Right.Left>,
        AddressTriple<A.Right.Right.Right.Right.Right, B.Right.Right.Right.Right.Right, C.Right.Right.Right.Right.Right>
    >
}

/// Every prepared pattern retains the same law address in its actual source.
public typealias TriplePatternSources<L: Structure> = TriplePatternProfile<
    Paired<L, AddressTriple<Never, Lit1, Lit2>>,
    Paired<L, AddressTriple<Never, Never, Lit1>>,
    Paired<L, AddressTriple<Never, Lit1, Never>>,
    Paired<L, AddressTriple<Never, Lit1, Lit1>>,
    Paired<L, AddressTriple<Never, Never, Never>>
>

/// Checks the finite equations of M65 against a source-bound observation.
/// The expected table is computed from the three actual selection paths.
/// The global interpretation theorem additionally needs the stated symmetry
/// family; neither this equality nor a supplied law address proves it.
public enum TriplePatternCertificate<L: Structure, R: PredicateReading, A: CandidateRemoval, B: CandidateRemoval, C: CandidateRemoval>: Null
where R.Left == TriplePatternSources<L>, R.Sigma == BeamSpace,
      R.Encoding == SaturationEncoding,
      A.Left == TripleMarkerProfiles, B.Left == A.Left, C.Left == A.Left,
      A.Right: Pair, B.Right: Pair, C.Right: Pair,
      A.Right.Right: Pair, B.Right.Right: Pair, C.Right.Right: Pair,
      A.Right.Right.Right: Pair, B.Right.Right.Right: Pair, C.Right.Right.Right: Pair,
      A.Right.Right.Right.Right: Pair, B.Right.Right.Right.Right: Pair, C.Right.Right.Right.Right: Pair,
      A.Right.Left: Structure, B.Right.Left: Structure, C.Right.Left: Structure,
      A.Right.Right.Left: Structure, B.Right.Right.Left: Structure, C.Right.Right.Left: Structure,
      A.Right.Right.Right.Left: Structure, B.Right.Right.Right.Left: Structure, C.Right.Right.Right.Left: Structure,
      A.Right.Right.Right.Right.Left: Structure, B.Right.Right.Right.Right.Left: Structure, C.Right.Right.Right.Right.Left: Structure,
      A.Right.Right.Right.Right.Right: Structure, B.Right.Right.Right.Right.Right: Structure, C.Right.Right.Right.Right.Right: Structure,
      R.Answer == TriplePatternImages<A, B, C>.Right {
    public typealias Left = R.Answer
    public typealias Right = TriplePatternImages<A, B, C>.Right

    /// Once all five equations hold, the distinct-marker row identifies
    /// the selected positions. Acquisition need retain only that signature.
    public typealias Record = SequentialReading<R,
        FirstEvidenceImage<R.Answer, BeamSpace, SaturationEncoding, RoutedOutputQuestion>>

    /// The supplied data selections follow the certificate's actual paths.
    public typealias Use<X: Pair, P: CandidateRemoval, Q: CandidateRemoval, T: CandidateRemoval> =
        ReadTripleThroughPaths<FactOf<Record>, X, P, Q, T>
    where X.Right: Pair, X.Left: Structure, X.Right.Left: Structure, X.Right.Right: Structure,
          P.Left == TripleDataCandidates<X>, Q.Left == P.Left, T.Left == P.Left,
          P.Right: Structure, Q.Right: Structure, T.Right: Structure,
          P.Address == A.Address, Q.Address == B.Address, T.Address == C.Address
}

public typealias TripleDataCandidates<X: Pair> = CandidateFork<CandidateLeaf<X.Left>,
    CandidateFork<CandidateLeaf<X.Right.Left>, CandidateLeaf<X.Right.Right>>>
where X.Right: Pair

/// Read supplied data positions beside a fact. The certificate's Use alias
/// additionally fixes these paths and the exact law-record type.
public enum ReadTripleThroughPaths<F: HasVerdict & Structure, X: Pair, P: CandidateRemoval,
    Q: CandidateRemoval, T: CandidateRemoval>: PredicateReading
where F.Sigma == BeamSpace, F.Encoding == SaturationEncoding,
      X.Right: Pair, X.Left: Structure, X.Right.Left: Structure, X.Right.Right: Structure,
      P.Left == TripleDataCandidates<X>, Q.Left == P.Left, T.Left == P.Left,
      P.Right: Structure, Q.Right: Structure, T.Right: Structure {
    public typealias Left = Paired<F, X>
    public typealias Answer = AddressTriple<P.Right, Q.Right, T.Right>
    public typealias Right = Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RoutedOutputQuestion
}

/// M65: swap the first two fields when the third matches either of them.
/// These two clauses bind the match to the actual source coordinates.
public enum ThirdMatchesFirst<A: Structure, B: Structure>: PredicateReading {
    public typealias Left = AddressTriple<A, B, A>
    public typealias Answer = AddressTriple<B, A, A>
    public typealias Right = Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RouteByThirdEqualityQuestion
}

public enum ThirdMatchesSecond<A: Structure, B: Structure>: PredicateReading {
    public typealias Left = AddressTriple<A, B, B>
    public typealias Answer = AddressTriple<B, A, B>
    public typealias Right = Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RouteByThirdEqualityQuestion
}

/// One no-match family in the finite Never/Succ numeral interpretation.
/// Zero, one and a double successor are distinct, so the source is retained.
/// Together with the match clauses this supplies witnesses, not a total
/// equality decision procedure for arbitrary Structure conformances.
public enum ThirdOutsideZeroOne<P: IntegerValued>: PredicateReading {
    public typealias Left = AddressTriple<Never, Lit1, Succ<Succ<P>>>
    public typealias Answer = Left
    public typealias Right = Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RouteByThirdEqualityQuestion
}

/// The module routing and the instrument's output connection are separate
/// components of one source. Both frames report the same two probe questions
/// in the same record format. The frame is absent from the fact payload.
public enum ProbeThroughDirectFrame<I: Pair>: PredicateReading
where I.Left: Pair, I.Right: Pair,
      I.Left.Left: Pair, I.Left.Right: Pair, I.Right.Left: Pair, I.Right.Right: Pair,
      I.Left.Left.Left: Structure, I.Left.Left.Right: Structure,
      I.Left.Right.Left: Structure, I.Left.Right.Right: Structure,
      I.Right.Left.Left: Structure, I.Right.Left.Right: Structure,
      I.Right.Right.Left: Structure, I.Right.Right.Right: Structure {
    public typealias Left = Paired<I, DirectOutputFrame>
    public typealias Right = RoutingProbeImages<I>.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RoutingProbeImages<I>.Predicate
    public typealias Answer = Right
}

/// This internal output connection exchanges the first two reported ports.
/// It applies the same exchange to both complete probe images.
public enum ProbeThroughCrossedFrame<I: Pair>: PredicateReading
where I.Left: Pair, I.Right: Pair,
      I.Left.Left: Pair, I.Left.Right: Pair, I.Right.Left: Pair, I.Right.Right: Pair,
      I.Left.Left.Left: Structure, I.Left.Left.Right: Structure,
      I.Left.Right.Left: Structure, I.Left.Right.Right: Structure,
      I.Right.Left.Left: Structure, I.Right.Left.Right: Structure,
      I.Right.Right.Left: Structure, I.Right.Right.Right: Structure {
    public typealias Left = Paired<I, CrossedOutputFrame>
    public typealias Right = Paired<ExchangeFirstImage<FirstRoutingProbe<I>.Answer>.Answer, ExchangeFirstImage<SecondRoutingProbe<I>.Answer>.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RoutingProbeImages<I>.Predicate
    public typealias Answer = Right
}

/// Moving the first-two-output exchange from the module's routing to the
/// instrument leaves both observed images unchanged. The generic equality
/// follows from coordinate transport, without equating either actual source.
public enum RoutingFrameAgreement<I: Pair>: VerdictIsInvariant
where I.Left: Pair, I.Right: Pair,
      I.Left.Left: Pair, I.Left.Right: Pair, I.Right.Left: Pair, I.Right.Right: Pair,
      I.Left.Left.Left: Structure, I.Left.Left.Right: Structure,
      I.Left.Right.Left: Structure, I.Left.Right.Right: Structure,
      I.Right.Left.Left: Structure, I.Right.Left.Right: Structure,
      I.Right.Right.Left: Structure, I.Right.Right.Right: Structure {
    public typealias Left = ProbeThroughCrossedFrame<I>
    public typealias Right = ProbeThroughDirectFrame<ExchangeFirstImage<I>.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Left.Predicate
    public typealias Answer = Left.Answer
}

public enum PairRelationQuestion: Close {}

/// Two addressed pairs read through one resident direct frame. The image
/// uses their coordinate representations, without equating nominal carriers.
public enum SharedDirectPairFrame<P: Pair>: PredicateReading
where P.Left: Pair, P.Right: Pair,
      P.Left.Left: Structure, P.Left.Right: Structure,
      P.Right.Left: Structure, P.Right.Right: Structure {
    public typealias Left = Paired<P, DirectOutputFrame>
    public typealias Right = Paired<Paired<P.Left.Left, P.Left.Right>, Paired<P.Right.Left, P.Right.Right>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = PairRelationQuestion
    public typealias Answer = Right
}

/// The same unknown orientation acts on both pairs. Its actual application
/// exchanges both sets of coordinates. No temporal order is introduced.
public enum SharedCrossedPairFrame<P: Pair>: PredicateReading
where P.Left: Pair, P.Right: Pair,
      P.Left.Left: Structure, P.Left.Right: Structure,
      P.Right.Left: Structure, P.Right.Right: Structure {
    public typealias Left = Paired<P, CrossedOutputFrame>
    public typealias Right = Paired<SwapBoundaryReading<P.Left>.Answer, SwapBoundaryReading<P.Right>.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = PairRelationQuestion
    public typealias Answer = Right
}

/// Crossing preserves an established pair equality. Applied to equal
/// crossed images, the same constructor proves equality of their decodings.
/// DoubleSwapReturn supplies the recovery of each coordinate pair. [M59]
public enum SharedFrameAgreement<C: Null>: Null
where C.Left: Pair, C.Right: Pair,
      C.Left.Left: Structure, C.Left.Right: Structure,
      C.Right.Left: Structure, C.Right.Right: Structure {
    public typealias Left = SwapBoundaryReading<C.Left>.Answer
    public typealias Right = SwapBoundaryReading<C.Right>.Answer
}

/// The two frame connections differ inside this source. The image uses
/// the same record vocabulary as the two shared-frame readings.
public enum MixedPairFrame<P: Pair>: PredicateReading
where P.Left: Pair, P.Right: Pair,
      P.Left.Left: Structure, P.Left.Right: Structure,
      P.Right.Left: Structure, P.Right.Right: Structure {
    public typealias Left = Paired<P, Paired<DirectOutputFrame, CrossedOutputFrame>>
    public typealias Right = Paired<Paired<P.Left.Left, P.Left.Right>, SwapBoundaryReading<P.Right>.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = PairRelationQuestion
    public typealias Answer = Right
}

/// The remaining admitted frame combination: crossed first, direct second.
/// Together the two shared and two mixed clauses cover the I/S frame pair.
public enum ReversedMixedPairFrame<P: Pair>: PredicateReading
where P.Left: Pair, P.Right: Pair,
      P.Left.Left: Structure, P.Left.Right: Structure,
      P.Right.Left: Structure, P.Right.Right: Structure {
    public typealias Left = Paired<P, Paired<CrossedOutputFrame, DirectOutputFrame>>
    public typealias Right = Paired<SwapBoundaryReading<P.Left>.Answer, Paired<P.Right.Left, P.Right.Right>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = PairRelationQuestion
    public typealias Answer = Right
}

public enum SecondPairReaddressing: Close {}

public enum RelativeFrameQuestion: Close {}

/// Read parity of the two reported probe orientations. P is an actual
/// application to those coordinates; its operation name alone proves no law.
/// The binary I/S proof uses the three parity constructors in WitnessTransfer.
public enum RelativeProbeBit<R: PredicateReading, P: PredicateReading>: PredicateReading
where R.Answer: Pair, R.Answer.Left: Pair, R.Answer.Right: Pair,
      R.Answer.Left.Left: Structure, R.Answer.Right.Left: Structure,
      P.Left == Paired<R.Answer.Left.Left, R.Answer.Right.Left>,
      P.Answer: Pair, R.Sigma == P.Sigma, R.Encoding == P.Encoding {
    public typealias Left = R.Left
    public typealias Right = P.Answer.Left
    public typealias Sigma = R.Sigma
    public typealias Encoding = R.Encoding
    public typealias Predicate = RelativeFrameQuestion
    public typealias Answer = Right
}

/// Correct a relative crossing in the reported second pair. Its original
/// source and resident frame remain in the preceding reading. [Matter M60]
public enum ReaddressSecondPair<I: Pair>: PredicateReading
where I.Left: Structure, I.Right: Pair,
      I.Right.Left: Structure, I.Right.Right: Structure {
    public typealias Left = I
    public typealias Right = Paired<I.Left, SwapBoundaryReading<I.Right>.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = SecondPairReaddressing
    public typealias Answer = Right
}

/// One correction works on arbitrary new data for the direct/crossed case.
/// It is tied to the actual mixed reading, without a final-image premise.
public enum MixedFrameCorrection<P: Pair>: Null
where P.Left: Pair, P.Right: Pair,
      P.Left.Left: Structure, P.Left.Right: Structure,
      P.Right.Left: Structure, P.Right.Right: Structure {
    public typealias Reading = MixedPairFrame<P>
    public typealias Path = SequentialReading<Reading, ReaddressSecondPair<Reading.Answer>>
    public typealias Left = Path.Answer
    public typealias Right = SharedDirectPairFrame<P>.Answer
}

/// The same relative correction yields a common crossed frame in the
/// crossed/direct case. Absolute orientation still need not be identified.
public enum ReversedMixedFrameCorrection<P: Pair>: Null
where P.Left: Pair, P.Right: Pair,
      P.Left.Left: Structure, P.Left.Right: Structure,
      P.Right.Left: Structure, P.Right.Right: Structure {
    public typealias Reading = ReversedMixedPairFrame<P>
    public typealias Path = SequentialReading<Reading, ReaddressSecondPair<Reading.Answer>>
    public typealias Left = Path.Answer
    public typealias Right = SharedCrossedPairFrame<P>.Answer
}

public enum FrameConnectionExchange: Close {}

/// Exchange the two resident frame connections while retaining the data.
/// On the I/S mixed clauses this changes both absolute orientations.
public enum ExchangeFrameConnections<W: Pair>: PredicateReading
where W.Left: Structure, W.Right: Pair,
      W.Right.Left: Structure, W.Right.Right: Structure {
    public typealias Left = W
    public typealias Right = Paired<W.Left, Paired<W.Right.Right, W.Right.Left>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = FrameConnectionExchange
    public typealias Answer = Right
}

/// The reference configuration for the requested alignment: read both data
/// pairs through the actual first connection. This specifies the question.
public enum CommonFirstFrameSource<W: Pair>: PredicateReading
where W.Left: Structure, W.Right: Pair, W.Right.Left: Structure {
    public typealias Left = W
    public typealias Right = Paired<W.Left, W.Right.Left>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = PairRelationQuestion
    public typealias Answer = Right
}

/// Decode a zero relative fact and a new image pair. No original source,
/// absolute frame or probe orientation appears in this decoder's input.
public enum SharedFrameFactDecoder<I: Pair>: PredicateReading
where I.Left: HasVerdict, I.Left.Answer == Never,
      I.Left.Sigma == BeamSpace, I.Left.Encoding == SaturationEncoding,
      I.Left.Predicate == RelativeFrameQuestion, I.Right: Pair {
    public typealias Left = I
    public typealias Right = I.Right
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = PairRelationQuestion
    public typealias Answer = Right
}

/// The other decoder clause crosses the second image using a one fact.
/// A fact's later applicability is established by the source-bound replay.
public enum MixedFrameFactDecoder<I: Pair>: PredicateReading
where I.Left: HasVerdict, I.Left.Answer == Lit1,
      I.Left.Sigma == BeamSpace, I.Left.Encoding == SaturationEncoding,
      I.Left.Predicate == RelativeFrameQuestion,
      I.Right: Pair, I.Right.Left: Structure, I.Right.Right: Pair,
      I.Right.Right.Left: Structure, I.Right.Right.Right: Structure {
    public typealias Left = I
    public typealias Right = ReaddressSecondPair<I.Right>.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = PairRelationQuestion
    public typealias Answer = Right
}

/// Acquire a mixed relative fact, exchange the resident connections, then
/// align arbitrary new data through that old fact and the new images. [M64]
/// The independent source question reads both pairs through the new first
/// connection. No equality of final answers is required from the caller.
public enum MixedFrameReplayAfterExchange<P: Pair>: ReadingFactors
where P.Left: Pair, P.Right: Pair,
      P.Left.Left: Structure, P.Left.Right: Structure,
      P.Right.Left: Structure, P.Right.Right: Structure {
    public typealias Probe = Paired<Paired<Never, Lit1>, Paired<Never, Lit1>>
    public typealias Acquisition = AcquireAnswer<RelativeProbeBit<MixedPairFrame<Probe>, ZeroOneParity>>
    public typealias Change = StepBeside<ExchangeFrameConnections<MixedPairFrame<P>.Left>, Acquisition.Record.Right>
    public typealias Whole = Change.Right
    public typealias CurrentSource = FirstEvidenceImage<Whole, BeamSpace, SaturationEncoding, PairRelationQuestion>
    public typealias CurrentImage = DecodeRefinedEvidence<CurrentSource, ReversedMixedPairFrame<P>>
    public typealias Archive = SecondEvidenceImage<Whole, BeamSpace, SaturationEncoding, RelativeFrameQuestion>
    public typealias OldFact = DecodeRefinedEvidence<Archive, SecondEvidenceImage<Acquisition.Record.Right, BeamSpace, SaturationEncoding, RelativeFrameQuestion>>
    public typealias Reference = DecodeRefinedEvidence<CurrentSource, CommonFirstFrameSource<CurrentSource.Answer>>
    public typealias Left = DecodeRefinedEvidence<Reference, SharedCrossedPairFrame<P>>
    public typealias Observation = JointEvidence<OldFact, CurrentImage>
    public typealias Right = MixedFrameFactDecoder<Observation.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = PairRelationQuestion
    public typealias Answer = Left.Answer
}
