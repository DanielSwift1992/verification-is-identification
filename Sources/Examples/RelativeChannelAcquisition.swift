import VerificationIsIdentification

public enum RemainingChannelMatchQuestion: Close {}

/// Decode a relation using just the two acquired facts. The old fact holds
/// the first reply of each channel; the new fact holds the second K reply.
public enum RemainingMatchFromFacts<F: HasVerdict & Structure,
    N: HasVerdict & Structure>: PredicateReading
where F.Answer: Pair, F.Answer.Left: Structure, N.Answer: Structure,
      F.Sigma == BeamSpace, N.Sigma == BeamSpace,
      F.Encoding == SaturationEncoding, N.Encoding == SaturationEncoding {
    public typealias Left = Paired<F, N>
    public typealias Old = FirstEvidenceImage<Left, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias New = SecondEvidenceImage<Left, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias OldReplies = SequentialReading<Old, ReadRecordedAnswer<F>>
    public typealias Target = SequentialReading<OldReplies,
        FirstEvidenceImage<F.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Fresh = SequentialReading<New, ReadRecordedAnswer<N>>
    public typealias Actual = JointEvidence<Target, Fresh>
    public typealias Right = Actual.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RemainingChannelMatchQuestion
    public typealias Answer = Right
}

/// Two fixed two-entry channel tables. A point reading is a projection of
/// the actual resident table. No shared-image property is declared here.
public enum RelativeChannelAcquisition<S: Pair, H: Structure>: Close
where S.Left: Pair, S.Right: Pair,
      S.Left.Left: Structure, S.Left.Right: Structure,
      S.Right.Left: Structure, S.Right.Right: Structure {
    public typealias HTable = FirstEvidenceImage<S, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias KTable = SecondEvidenceImage<S, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias H0 = SequentialReading<HTable,
        FirstEvidenceImage<S.Left, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias K0 = SequentialReading<KTable,
        FirstEvidenceImage<S.Right, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias K1 = SequentialReading<KTable,
        SecondEvidenceImage<S.Right, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias TwoReplies = JointEvidence<H0, K0>
    public enum DirectMatch: PredicateReading {
        public typealias Actual = JointEvidence<H0, K1>
        public typealias Left = S
        public typealias Right = Actual.Answer
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = RemainingChannelMatchQuestion
        public typealias Answer = Right
    }
    public typealias Root = Paired<S, H>
    public typealias Old = ArchiveProfileRead<Root, TwoReplies>
    public typealias Fresh = ArchiveProfileRead<Old.Right, K1>
    public typealias Actual = FollowedPair<Old, Fresh>
    public typealias Result = Fresh.Right
    public typealias F = FactOf<TwoReplies>
    public typealias N = FactOf<K1>
    public typealias Memory = Paired<Paired<H, F>, N>
    public typealias Saved = SecondEvidenceImage<Result, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Earlier = SequentialReading<Saved,
        FirstEvidenceImage<Memory, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias FirstFact = SequentialReading<Earlier,
        SecondEvidenceImage<Memory.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias NewFact = SequentialReading<Saved,
        SecondEvidenceImage<Memory, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Facts = JointEvidence<FirstFact, NewFact>
    public typealias Decoder = RemainingMatchFromFacts<F, N>
    public typealias Decoded = SequentialReading<Facts, Decoder>
    public enum Endpoint: Null {
        public typealias Left = Paired<Actual.Left, Actual.Right>
        public typealias Right = Paired<Root, Paired<S, Memory>>
    }
    public enum MatchFactors: ReadingFactors {
        public typealias Left = ReadFirstProfileSource<Result, DirectMatch>
        public typealias Observation = Facts
        public typealias Right = Decoder
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = Left.Predicate
        public typealias Answer = Left.Answer
    }
}
