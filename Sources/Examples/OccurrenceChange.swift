import VerificationIsIdentification

/// Record a question before a supplied source step and another at its actual
/// output. No invariant answer or autonomous image law is required. The step
/// itself is recorded so that the original source and both occasions survive.
public enum RecordAcrossOccurrences<B: PredicateReading, T: PredicateReading,
    A: PredicateReading, H: Structure>: Close
where B.Left == T.Left, A.Left == T.Answer,
      B.Left: Structure, T.Answer: Structure,
      B.Answer: Structure, A.Answer: Structure,
      B.Sigma == BeamSpace, T.Sigma == BeamSpace, A.Sigma == BeamSpace,
      B.Encoding == SaturationEncoding, T.Encoding == SaturationEncoding,
      A.Encoding == SaturationEncoding {
    public typealias Root = Paired<B.Left, H>
    public typealias Source = FirstEvidenceImage<Root, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias BeforeReading = DecodeRefinedEvidence<Source, B>
    public typealias BeforeRecord = RecordReading<BeforeReading>
    public typealias SavedRoot = FirstEvidenceImage<BeforeRecord.Right, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias OriginalSource = SequentialReading<SavedRoot, Source>
    public typealias Move = DecodeRefinedEvidence<OriginalSource, T>
    public typealias MoveRecord = RecordReading<Move>
    public typealias MoveFact = SecondEvidenceImage<MoveRecord.Right, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias NewSource = SequentialReading<MoveFact, ReadRecordedAnswer<FactOf<Move>>>
    public typealias AfterReading = DecodeRefinedEvidence<NewSource, A>
    public typealias AfterRecord = RecordReading<AfterReading>
    public typealias Actual = FollowedPair<FollowedPair<BeforeRecord, MoveRecord>, AfterRecord>
    public typealias Result = AfterRecord.Right
    public typealias Earlier = FirstEvidenceImage<Result, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias FirstRecord = SequentialReading<Earlier,
        FirstEvidenceImage<MoveRecord.Right, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias BeforeFact = SequentialReading<FirstRecord,
        SecondEvidenceImage<BeforeRecord.Right, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias AfterFact = SecondEvidenceImage<Result, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Facts = JointEvidence<BeforeFact, AfterFact>
    public typealias Memory = Facts.Answer
    public enum Endpoints: Null {
        public typealias Left = Paired<Actual.Left, Actual.Right>
        public typealias Right = Paired<Root, Result>
    }
    public enum OnlyTheTwoAcquiredFacts: Null {
        public typealias Left = Memory
        public typealias Right = Paired<FactOf<B>, FactOf<A>>
    }
    public enum OriginalRootSurvives: Null {
        public typealias Left = Result.Left.Left.Left
        public typealias Right = Root
    }
}

/// The facts contain duplicated parity bits produced by the existing binary
/// clauses. The same relative-bit reader compares their actual first fields.
/// P must be an admitted parity clause for this pair, not a matching name.
public typealias JointChangeFromFacts<M: Pair, P: PredicateReading> =
    RelativeProbeBit<TwoRecordedAnswers<M>, P>
where M.Left: HasVerdict, M.Right: HasVerdict,
      M.Left.Sigma == M.Right.Sigma, M.Left.Encoding == M.Right.Encoding,
      M.Left.Answer: Pair, M.Right.Answer: Pair,
      M.Left.Answer.Left: Structure, M.Right.Answer.Left: Structure,
      P.Left == Paired<M.Left.Answer.Left, M.Right.Answer.Left>,
      P.Answer: Pair, P.Sigma == M.Left.Sigma, P.Encoding == M.Left.Encoding

/// The old raw pair and the later raw pair occupy different source fields.
/// The actual Right contact advances to the latter; nothing requires their
/// replies, probes or instrument configurations to be the same.
public enum PairedOccurrenceAcquisition<P: PredicateReading, Q: PredicateReading,
    C: Structure, H: Structure>: Close
where P.Left: Structure, Q.Left: Structure,
      P.Answer: Structure, Q.Answer: Structure,
      P.Sigma == BeamSpace, Q.Sigma == BeamSpace,
      P.Encoding == SaturationEncoding, Q.Encoding == SaturationEncoding {
    public typealias Next = Paired<Q.Left, C>
    public typealias Initial = Paired<P.Left, Next>
    public typealias RawBefore = FirstEvidenceImage<Initial, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Before = DecodeRefinedEvidence<RawBefore, P>
    public typealias Step = SecondEvidenceImage<Initial, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias RawAfter = FirstEvidenceImage<Next, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias After = DecodeRefinedEvidence<RawAfter, Q>
    public typealias Acquisition = RecordAcrossOccurrences<Before, Step, After, H>
}
