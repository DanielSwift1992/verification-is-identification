import VerificationIsIdentification

/// Two actual first-address readings share the same paired source.
public enum JointFirstReply<S: Pair>: PredicateReading
where S.Left: Pair, S.Right: Pair, S.Left.Left: Pair, S.Right.Left: Pair,
      S.Left.Left.Left: Structure, S.Right.Left.Left: Structure {
    public typealias FirstChannel = FirstEvidenceImage<S, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias SecondChannel = SecondEvidenceImage<S, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias First = SequentialReading<FirstChannel, PhaseLawProbe0<S.Left>>
    public typealias Second = SequentialReading<SecondChannel, PhaseLawProbe0<S.Right>>
    public typealias Actual = JointEvidence<First, Second>
    public typealias Left = S
    public typealias Right = Actual.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
}

/// Acquire a joint reply, move both input tables by the same actual Z,
/// then acquire the next joint reply beside the retained first record.
/// The tuple fields can be arbitrary: interpretation as bijections and even
/// relative action is M64a's family, not a consequence of mere Pair shape.
public enum JointReplyAcquisition<A: Structure, B: Structure, C: Structure,
    D: Structure, E: Structure, F: Structure, G: Structure, H: Structure>: Close {
    public typealias Initial = Paired<BoundaryWorking<A, B, C, D>, BoundaryWorking<E, F, G, H>>
    public typealias First = RecordReading<JointFirstReply<Initial>>
    public enum Change: Pair {
        public typealias X = FourLeafShortPhaseWord<A, B, C, D>
        public typealias Y = FourLeafShortPhaseWord<E, F, G, H>
        public typealias Left = Paired<X.Left, Y.Left>
        public typealias Right = Paired<X.Right, Y.Right>
    }
    public typealias Move = StepBeside<Change, First.Right.Right>
    public typealias Second = RecordReading<JointFirstReply<Change.Right>>
    public typealias Finish = StepBeside<Second, First.Right.Right>
    public typealias Path = FollowedPair<FollowedPair<First, Move>, Finish>
    public typealias Run = StepBeside<Path, FourLeafReplyTable>

    public enum Memory: PredicateReading {
        public typealias Left = Run.Right
        public typealias Trace = FirstEvidenceImage<Left, BeamSpace, SaturationEncoding, FirstProjection>
        public typealias Old = SequentialReading<Trace,
            SecondEvidenceImage<Trace.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
        public typealias NewTrace = SequentialReading<Trace,
            FirstEvidenceImage<Trace.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
        public typealias New = SequentialReading<NewTrace,
            SecondEvidenceImage<NewTrace.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
        public typealias Table = SecondEvidenceImage<Left, BeamSpace, SaturationEncoding, SecondProjection>
        public typealias Actual = JointEvidence<JointEvidence<Old, New>, Table>
        public typealias Right = Actual.Answer
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = Actual.Predicate
        public typealias Answer = Right
    }

    public enum RecordedPairs: Null {
        public typealias Left = Paired<Memory.Answer.Left.Left.Answer, Memory.Answer.Left.Right.Answer>
        public typealias Right = Paired<Paired<A, E>, Paired<B, F>>
    }
    public enum CurrentSource: Null {
        public typealias Left = Path.Right.Left.Left
        public typealias Right = Paired<BoundaryWorking<B, A, D, C>, BoundaryWorking<F, E, H, G>>
    }
}

/// Derive two facts from already accessible joint records. P and Q read
/// their actual stored payloads; no new external acquisition is represented.
/// The instances below use the existing first/second projection constructors.
public enum ReplyChannelFacts<M: Pair, P: PredicateReading, Q: PredicateReading>: PredicateReading
where M.Left: Pair, M.Right == FourLeafReplyTable,
      M.Left.Left: HasVerdict & Structure, M.Left.Right: HasVerdict & Structure,
      M.Left.Left.Sigma == BeamSpace, M.Left.Right.Sigma == BeamSpace,
      M.Left.Left.Encoding == SaturationEncoding, M.Left.Right.Encoding == SaturationEncoding,
      P.Left == M.Left.Left.Answer, Q.Left == M.Left.Right.Answer,
      P.Sigma == BeamSpace, Q.Sigma == BeamSpace,
      P.Encoding == SaturationEncoding, Q.Encoding == SaturationEncoding,
      P.Answer: Structure, Q.Answer: Structure {
    public typealias Facts = FirstEvidenceImage<M, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias FirstFact = SequentialReading<Facts,
        FirstEvidenceImage<M.Left, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias SecondFact = SequentialReading<Facts,
        SecondEvidenceImage<M.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias First = SequentialReading<
        SequentialReading<FirstFact, ReadRecordedAnswer<M.Left.Left>>, P>
    public typealias Second = SequentialReading<
        SequentialReading<SecondFact, ReadRecordedAnswer<M.Left.Right>>, Q>
    public typealias Table = SecondEvidenceImage<M, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Actual = JointEvidence<JointEvidence<ObserveRecordedFact<First>,
        ObserveRecordedFact<Second>>, Table>
    public typealias Left = M
    public typealias Right = Actual.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
}

/// Exactly the old twelve-law decoder is used on each channel's projected
/// acquired replies. The output is a pair of normalization words A,B,
/// interpreted as B composed with inverse A, not as a unique word name.
public enum PairedReplyWords<M: Pair, AR: PredicateReading, AC: PredicateReading,
    BR: PredicateReading, BC: PredicateReading>: PredicateReading
where M.Left: Pair, M.Right == FourLeafReplyTable,
      M.Left.Left: HasVerdict & Structure, M.Left.Right: HasVerdict & Structure,
      M.Left.Left.Answer: Pair, M.Left.Right.Answer: Pair,
      M.Left.Left.Answer.Left: Structure, M.Left.Left.Answer.Right: Structure,
      M.Left.Right.Answer.Left: Structure, M.Left.Right.Answer.Right: Structure,
      M.Left.Left.Sigma == BeamSpace, M.Left.Right.Sigma == BeamSpace,
      M.Left.Left.Encoding == SaturationEncoding, M.Left.Right.Encoding == SaturationEncoding,
      AR.Left == Paired<M.Left.Left.Answer.Left, FourLeafReplyTable>, AR.Answer: Structure,
      AC.Left == Paired<M.Left.Right.Answer.Left, AR.Answer>, AC.Answer: Structure,
      BR.Left == Paired<M.Left.Left.Answer.Right, FourLeafReplyTable>, BR.Answer: Structure,
      BC.Left == Paired<M.Left.Right.Answer.Right, BR.Answer>, BC.Answer: Structure,
      AR.Sigma == BeamSpace, AC.Sigma == BeamSpace, BR.Sigma == BeamSpace, BC.Sigma == BeamSpace,
      AR.Encoding == SaturationEncoding, AC.Encoding == SaturationEncoding,
      BR.Encoding == SaturationEncoding, BC.Encoding == SaturationEncoding {
    public typealias FirstFacts = ReplyChannelFacts<M,
        FirstEvidenceImage<M.Left.Left.Answer, BeamSpace, SaturationEncoding, FirstProjection>,
        FirstEvidenceImage<M.Left.Right.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias SecondFacts = ReplyChannelFacts<M,
        SecondEvidenceImage<M.Left.Left.Answer, BeamSpace, SaturationEncoding, SecondProjection>,
        SecondEvidenceImage<M.Left.Right.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias First = SequentialReading<FirstFacts, FourLeafReplyDecoder<FirstFacts.Answer, AR, AC>>
    public typealias Second = SequentialReading<SecondFacts, FourLeafReplyDecoder<SecondFacts.Answer, BR, BC>>
    public typealias Actual = JointEvidence<First, Second>
    public typealias Left = M
    public typealias Right = Actual.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
}
