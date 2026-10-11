import VerificationIsIdentification

/// Read the first field now and after each of three supplied transitions.
/// The question is constructed independently of its later acquisition.
public enum FourFirstFields<A: PredicateReading, B: PredicateReading,
    C: PredicateReading>: PredicateReading
where A.Answer == B.Left, B.Answer == C.Left,
      A.Sigma == BeamSpace, B.Sigma == BeamSpace, C.Sigma == BeamSpace,
      A.Encoding == SaturationEncoding, B.Encoding == SaturationEncoding, C.Encoding == SaturationEncoding,
      A.Left: Pair, A.Left.Left: Structure, A.Answer: Pair, A.Answer.Left: Structure,
      B.Answer: Pair, B.Answer.Left: Structure, C.Answer: Pair, C.Answer.Left: Structure {
    public typealias Q0 = FirstEvidenceImage<A.Left, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Q1 = FirstEvidenceImage<A.Answer, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Q2 = FirstEvidenceImage<B.Answer, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Q3 = FirstEvidenceImage<C.Answer, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias AB = FollowedPair<A, B>
    public typealias ABC = FollowedPair<AB, C>
    public typealias Actual = JointEvidence<Q0, JointEvidence<FollowedPair<A, Q1>,
        JointEvidence<FollowedPair<AB, Q2>, FollowedPair<ABC, Q3>>>>
    public typealias Left = Actual.Left
    public typealias Right = Actual.Answer
    public typealias Sigma = Actual.Sigma
    public typealias Encoding = Actual.Encoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
}

/// Read only the four retained facts from their actual final addresses.
/// The working source and consumed command tape do not enter this image.
public enum FourFirstFieldFacts<W: Pair>: PredicateReading
where W.Left: Pair, W.Left.Right: Structure,
      W.Left.Left: Pair, W.Left.Left.Right: Structure,
      W.Left.Left.Left: Pair, W.Left.Left.Left.Right: Structure,
      W.Left.Left.Left.Left: Pair, W.Left.Left.Left.Left.Right: Structure {
    public typealias P0 = FirstEvidenceImage<W, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias P1 = FollowedPair<P0,
        FirstEvidenceImage<P0.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias P2 = FollowedPair<P1,
        FirstEvidenceImage<P1.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias P3 = FollowedPair<P2,
        FirstEvidenceImage<P2.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias F0 = FollowedPair<P0,
        SecondEvidenceImage<P0.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias F1 = FollowedPair<P1,
        SecondEvidenceImage<P1.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias F2 = FollowedPair<P2,
        SecondEvidenceImage<P2.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias F3 = FollowedPair<P3,
        SecondEvidenceImage<P3.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Actual = JointEvidence<F0, JointEvidence<F1, JointEvidence<F2, F3>>>
    public typealias Left = W
    public typealias Right = Actual.Answer
    public typealias Sigma = Actual.Sigma
    public typealias Encoding = Actual.Encoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
}

/// The decoder receives facts and the fixed expressions of the three actions.
/// A, B and C here are expressions, not the source-dependent applications.
public enum FourFirstFieldAnswers<A, B, C, M: Pair>: PredicateReading
where M.Left: HasVerdict, M.Right: Pair, M.Right.Left: HasVerdict,
      M.Right.Right: Pair, M.Right.Right.Left: HasVerdict, M.Right.Right.Right: HasVerdict,
      M.Left.Sigma == BeamSpace, M.Right.Left.Sigma == BeamSpace,
      M.Right.Right.Left.Sigma == BeamSpace, M.Right.Right.Right.Sigma == BeamSpace,
      M.Left.Encoding == SaturationEncoding, M.Right.Left.Encoding == SaturationEncoding,
      M.Right.Right.Left.Encoding == SaturationEncoding, M.Right.Right.Right.Encoding == SaturationEncoding,
      M.Left.Answer: Structure, M.Right.Left.Answer: Structure,
      M.Right.Right.Left.Answer: Structure, M.Right.Right.Right.Answer: Structure {
    public typealias F0 = ReadRecordedAnswer<M.Left>
    public typealias F1 = ReadRecordedAnswer<M.Right.Left>
    public typealias F2 = ReadRecordedAnswer<M.Right.Right.Left>
    public typealias F3 = ReadRecordedAnswer<M.Right.Right.Right>
    public typealias Left = M
    public typealias Right = Paired<F0.Answer, Paired<F1.Answer, Paired<F2.Answer, F3.Answer>>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = OperationSequence<F0.Predicate,
        OperationSequence<OperationSequence<A, F1.Predicate>,
        OperationSequence<OperationSequence<OperationSequence<A, B>, F2.Predicate>,
        OperationSequence<OperationSequence<OperationSequence<A, B>, C>, F3.Predicate>>>>
    public typealias Answer = Right
}

/// Four records surround three actual working transitions. The seven command
/// expressions are resident initially and move into the retained past. The
/// final answer factors through the acquired facts, without reusing the source
/// as an extra decoder argument or asking the caller for that final equality.
public enum AcquiredFourFirstFields<A: PredicateReading, B: PredicateReading,
    C: PredicateReading>: ReadingFactors
where A.Answer == B.Left, B.Answer == C.Left,
      A.Sigma == BeamSpace, B.Sigma == BeamSpace, C.Sigma == BeamSpace,
      A.Encoding == SaturationEncoding, B.Encoding == SaturationEncoding, C.Encoding == SaturationEncoding,
      A.Predicate: Structure, B.Predicate: Structure, C.Predicate: Structure,
      A.Left: Pair, A.Left.Left: Structure, A.Answer: Pair, A.Answer.Left: Structure,
      B.Answer: Pair, B.Answer.Left: Structure, C.Answer: Pair, C.Answer.Left: Structure {
    public typealias Question = FourFirstFields<A, B, C>
    public typealias Q0 = Question.Q0
    public typealias Q1 = Question.Q1
    public typealias Q2 = Question.Q2
    public typealias Q3 = Question.Q3
    public typealias R0 = RetainingRecordedReading<Q0>
    public typealias R1 = ExperimentReadingBeside<A, FactOf<Q0>>
    public typealias R2 = ExperimentReadingBeside<RetainingRecordedReading<Q1>, FactOf<Q0>>
    public typealias R3 = ExperimentReadingBeside<ExperimentReadingBeside<B, FactOf<Q1>>, FactOf<Q0>>
    public typealias R4 = ExperimentReadingBeside<
        ExperimentReadingBeside<RetainingRecordedReading<Q2>, FactOf<Q1>>, FactOf<Q0>>
    public typealias R5 = ExperimentReadingBeside<
        ExperimentReadingBeside<ExperimentReadingBeside<C, FactOf<Q2>>, FactOf<Q1>>, FactOf<Q0>>
    public typealias R6 = ExperimentReadingBeside<ExperimentReadingBeside<
        ExperimentReadingBeside<RetainingRecordedReading<Q3>, FactOf<Q2>>, FactOf<Q1>>, FactOf<Q0>>
    public typealias Tape = Paired<R0.Predicate, Paired<R1.Predicate, Paired<R2.Predicate,
        Paired<R3.Predicate, Paired<R4.Predicate, Paired<R5.Predicate, Paired<R6.Predicate, Never>>>>>>>
    public typealias Past1 = Paired<R0.Predicate, Never>
    public typealias Past2 = Paired<R1.Predicate, Past1>
    public typealias Past3 = Paired<R2.Predicate, Past2>
    public typealias Past4 = Paired<R3.Predicate, Past3>
    public typealias Past5 = Paired<R4.Predicate, Past4>
    public typealias Past6 = Paired<R5.Predicate, Past5>
    public typealias Past7 = Paired<R6.Predicate, Past6>
    public typealias First = ResidentBoundaryCommand<R0, Tape, Never>
    public typealias Second = ResidentBoundaryCommand<R1, Tape.Right, Past1>
    public typealias Third = ResidentBoundaryCommand<R2, Tape.Right.Right, Past2>
    public typealias Fourth = ResidentBoundaryCommand<R3, Tape.Right.Right.Right, Past3>
    public typealias Fifth = ResidentBoundaryCommand<R4, Tape.Right.Right.Right.Right, Past4>
    public typealias Sixth = ResidentBoundaryCommand<R5, Tape.Right.Right.Right.Right.Right, Past5>
    public typealias Seventh = ResidentBoundaryCommand<R6, Tape.Right.Right.Right.Right.Right.Right, Past6>
    public enum Path: PredicateReading {
        public typealias Left = Paired<A.Left, Paired<Tape, Never>>
        public typealias Right = Paired<Paired<Paired<Paired<Paired<C.Answer,
            FactOf<Q3>>, FactOf<Q2>>, FactOf<Q1>>, FactOf<Q0>>, Paired<Never, Past7>>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = OperationSequence<OperationSequence<OperationSequence<
            OperationSequence<OperationSequence<OperationSequence<R0.Predicate, R1.Predicate>,
            R2.Predicate>, R3.Predicate>, R4.Predicate>, R5.Predicate>, R6.Predicate>
        public typealias Answer = Right
        public enum Seams: Null {
            public typealias Left = Paired<Path.Left, Paired<First.Answer, Paired<Second.Answer,
                Paired<Third.Answer, Paired<Fourth.Answer, Paired<Fifth.Answer, Paired<Sixth.Answer, Seventh.Answer>>>>>>>
            public typealias Right = Paired<First.Left, Paired<Second.Left, Paired<Third.Left,
                Paired<Fourth.Left, Paired<Fifth.Left, Paired<Sixth.Left, Paired<Seventh.Left, Path.Right>>>>>>>
        }
    }
    public typealias Initial = FirstEvidenceImage<Path.Left, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Left = DecodeRefinedEvidence<Initial, Question>
    public typealias Observation = FollowedPair<Path, FourFirstFieldFacts<Path.Answer>>
    public typealias Right = FourFirstFieldAnswers<A.Predicate, B.Predicate, C.Predicate, Observation.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Left.Predicate
    public typealias Answer = Left.Answer
}
