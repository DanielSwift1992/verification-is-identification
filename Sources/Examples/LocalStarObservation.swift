import VerificationIsIdentification

/// All three applications are derived at the actual current working source.
/// Their fixed expressions and their actual instances occupy separate fields.
/// This view grants the selector no extra reading of the source or its answer.
public enum LocalStarApplicationRoot<S: Pair, C: Pair, V: Structure>: Pair
where S.Right: Pair, S.Right.Right: Pair, S.Right.Left: Structure,
      S.Right.Right.Left: Structure, S.Right.Right.Right: Structure,
      C.Right: Pair, C.Right.Right: Pair, C.Right.Left: Structure,
      C.Right.Right.Left: Structure, C.Right.Right.Right: Structure {
    public typealias First = LocalStarStep0<S, C, V>
    public typealias Second = LocalStarStep1<S, C, V>
    public typealias Third = LocalStarStep2<S, C, V>
    public typealias Catalogue = CandidateFork<CandidateLeaf<First>,
        CandidateFork<CandidateLeaf<Second>, CandidateLeaf<Third>>>
    public typealias Expression = Paired<First.Predicate, Paired<Second.Predicate, Third.Predicate>>
    public typealias Left = LocalPhaseWorld<S, C, V>
    public typealias Right = Paired<Expression, Catalogue>
    public typealias Select0 = SelectCandidateLeft<SelectCandidateLeaf<First>,
        CandidateFork<CandidateLeaf<Second>, CandidateLeaf<Third>>>
    public typealias Select1 = SelectCandidateRight<CandidateLeaf<First>,
        SelectCandidateLeft<SelectCandidateLeaf<Second>, CandidateLeaf<Third>>>
    public typealias Select2 = SelectCandidateRight<CandidateLeaf<First>,
        SelectCandidateRight<CandidateLeaf<Second>, SelectCandidateLeaf<Third>>>
}

/// The paths are derived from a catalogue, and do not depend on its payloads.
public typealias LocalStarAddressRoot = LocalStarApplicationRoot<LocalStarStage.Center, LocalStarPhase.Zero, Never>
public typealias LocalStarAddressProgram = Paired<LocalStarAddressRoot.Select0.Address,
    Paired<LocalStarAddressRoot.Select1.Address, LocalStarAddressRoot.Select2.Address>>
public typealias LocalStarInverseAddressProgram = Paired<LocalStarAddressRoot.Select2.Address,
    Paired<LocalStarAddressRoot.Select0.Address, LocalStarAddressRoot.Select1.Address>>

/// The three clauses choose the actual catalogue leaf. The program contains
/// addresses, rather than operation names to match against another application.
public typealias LocalStarSelected0<S: Pair, V: Structure> = SelectedLocalApplication<
    LocalStarApplicationRoot<S, LocalStarPhase.Zero, V>,
    LocalStarInput<S, LocalStarPhase.Zero, V, LocalStarAddressProgram>,
    LocalPolicyAtZero<LocalStarAddressProgram>, LocalStarApplicationRoot<S, LocalStarPhase.Zero, V>.Select0>
where S.Right: Pair, S.Right.Right: Pair, S.Right.Left: Structure,
      S.Right.Right.Left: Structure, S.Right.Right.Right: Structure
public typealias LocalStarSelected1<S: Pair, V: Structure> = SelectedLocalApplication<
    LocalStarApplicationRoot<S, LocalStarPhase.One, V>,
    LocalStarInput<S, LocalStarPhase.One, V, LocalStarAddressProgram>,
    LocalStarChoose1<LocalStarAddressProgram>, LocalStarApplicationRoot<S, LocalStarPhase.One, V>.Select1>
where S.Right: Pair, S.Right.Right: Pair, S.Right.Left: Structure,
      S.Right.Right.Left: Structure, S.Right.Right.Right: Structure
public typealias LocalStarSelected2<S: Pair, V: Structure> = SelectedLocalApplication<
    LocalStarApplicationRoot<S, LocalStarPhase.Two, V>,
    LocalStarInput<S, LocalStarPhase.Two, V, LocalStarAddressProgram>,
    LocalStarChoose2<LocalStarAddressProgram>, LocalStarApplicationRoot<S, LocalStarPhase.Two, V>.Select2>
where S.Right: Pair, S.Right.Right: Pair, S.Right.Left: Structure,
      S.Right.Right.Left: Structure, S.Right.Right.Right: Structure

/// The current stage and its two conditional continuations along actual A,B.
/// This is a question at the initial source. It does not claim that these
/// future observations have already been acquired by an internal instrument.
public enum TwoStepStageTrace<A: PredicateReading, B: PredicateReading>: PredicateReading
where A.Answer == B.Left, A.Sigma == BeamSpace, B.Sigma == BeamSpace,
      A.Encoding == SaturationEncoding, B.Encoding == SaturationEncoding,
      A.Left: Pair, A.Left.Left: Pair, A.Left.Left.Left: Structure,
      A.Answer: Pair, A.Answer.Left: Pair, A.Answer.Left.Left: Structure,
      B.Answer: Pair, B.Answer.Left: Pair, B.Answer.Left.Left: Structure {
    public typealias Current = LocalStageImage<A.Left>
    public typealias Next = SequentialReading<A, LocalStageImage<A.Answer>>
    public typealias Last = SequentialReading<SequentialReading<A, B>, LocalStageImage<B.Answer>>
    public typealias Actual = JointEvidence<Current, JointEvidence<Next, Last>>
    public typealias Left = A.Left
    public typealias Right = Paired<Current.Answer, Paired<Next.Answer, Last.Answer>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
    public enum Endpoints: Null {
        public typealias Left = Paired<TwoStepStageTrace.Left, TwoStepStageTrace.Right>
        public typealias Right = Paired<Actual.Left, Actual.Answer>
    }
}

/// Each clause follows the same selected law twice. Intermediate stages are
/// derived from its first result; the next row uses its actual next phase.
public enum LocalStarTrace0<S: Pair, V: Structure>: Close
where S.Left: Structure, S.Right: Pair, S.Right.Left: Pair,
      S.Right.Right: Pair, S.Right.Right.Left: Structure, S.Right.Right.Right: Structure,
      S.Right.Left.Left: Structure, S.Right.Left.Right: Pair,
      S.Right.Left.Right.Right: Pair, S.Right.Left.Right.Right.Left: Pair,
      S.Right.Left.Right.Left: Structure, S.Right.Left.Right.Right.Right: Structure,
      S.Right.Left.Right.Right.Left.Left: Structure {
    public typealias First = LocalStarSelected0<S, V>
    public typealias Second = LocalStarSelected1<First.Answer.Left, V>
    public typealias Reading = TwoStepStageTrace<First, Second>
}
public enum LocalStarTrace1<S: Pair, V: Structure>: Close
where S.Left: Structure, S.Right: Pair, S.Right.Right: Pair,
      S.Right.Left: Structure, S.Right.Right.Right: Structure,
      S.Right.Right.Left: Pair, S.Right.Right.Left.Left: Structure,
      S.Right.Right.Left.Right: Pair, S.Right.Right.Left.Right.Right: Pair,
      S.Right.Right.Left.Right.Left: Structure, S.Right.Right.Left.Right.Right.Left: Structure,
      S.Right.Right.Left.Right.Right.Right: Pair,
      S.Right.Right.Left.Right.Right.Right.Left: Structure {
    public typealias First = LocalStarSelected1<S, V>
    public typealias Second = LocalStarSelected2<First.Answer.Left, V>
    public typealias Reading = TwoStepStageTrace<First, Second>
}
public enum LocalStarTrace2<S: Pair, V: Structure>: Close
where S.Left: Structure, S.Right: Pair, S.Right.Right: Pair,
      S.Right.Left: Structure, S.Right.Right.Left: Structure,
      S.Right.Right.Right: Pair, S.Right.Right.Right.Left: Structure,
      S.Right.Right.Right.Right: Pair, S.Right.Right.Right.Right.Left: Pair,
      S.Right.Right.Right.Right.Right: Pair,
      S.Right.Right.Right.Right.Right.Left: Structure, S.Right.Right.Right.Right.Right.Right: Structure,
      S.Right.Right.Right.Right.Left.Left: Structure {
    public typealias First = LocalStarSelected2<S, V>
    public typealias Second = LocalStarSelected0<First.Answer.Left, V>
    public typealias Reading = TwoStepStageTrace<First, Second>
}

/// The existing recording construction as an application: keep its source
/// beside the acquired fact. Its operation expression retains which question
/// is recorded; an undifferentiated record opcode would permit another reading.
public enum RetainingRecordedReading<R: PredicateReading>: PredicateReading
where R.Left: Structure {
    public typealias Actual = JointEvidence<
        IdentityReading<R.Left, R.Sigma, R.Encoding>, ObserveRecordedFact<R>>
    public typealias Left = R.Left
    public typealias Right = Paired<R.Left, FactOf<R>>
    public typealias Sigma = R.Sigma
    public typealias Encoding = R.Encoding
    public typealias Predicate = OperationSequence<RecordReadingOperation, R.Predicate>
    public typealias Answer = Right
    public enum Endpoints: Null {
        public typealias Left = Paired<RetainingRecordedReading.Left, RetainingRecordedReading.Right>
        public typealias Right = Paired<Actual.Left, Actual.Answer>
    }
}

/// An explicit endpoint interface to the existing ReadingBesideInput product.
/// Its field and operation equations are derived here, so the five-step proof
/// need not repeatedly expand the same nested projection expressions.
public enum ExperimentReadingBeside<R: PredicateReading, C: Structure>: PredicateReading
where R.Left: Structure, R.Answer: Structure {
    public typealias Actual = ReadingBesideInput<R, C>
    public typealias Left = Paired<R.Left, C>
    public typealias Right = Paired<R.Answer, C>
    public typealias Sigma = R.Sigma
    public typealias Encoding = R.Encoding
    public typealias Predicate = OperationSequence<R.Predicate, SuppliedInputQuestion>
    public typealias Answer = Right
    public enum Endpoints: Null {
        public typealias Left = Paired<ExperimentReadingBeside.Left,
            Paired<ExperimentReadingBeside.Right, ExperimentReadingBeside.Predicate>>
        public typealias Right = Paired<Actual.Left, Paired<Actual.Answer, Actual.Predicate>>
    }
}

/// Read only the three retained facts, through their actual ordered addresses.
/// The current working carrier, command tape and consumed commands stay outside
/// this observation, without being deleted from its complete source.
public enum ThreeStageFacts<W: Pair>: PredicateReading
where W.Left: Pair, W.Left.Right: Structure, W.Left.Left: Pair,
      W.Left.Left.Right: Structure, W.Left.Left.Left: Pair,
      W.Left.Left.Left.Right: Structure {
    public typealias Working = FirstEvidenceImage<W, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias FirstPair = FirstEvidenceImage<Working.Answer, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias SecondPair = FirstEvidenceImage<FirstPair.Answer, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias F0 = DecodeRefinedEvidence<Working,
        SecondEvidenceImage<Working.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias F1 = DecodeRefinedEvidence<DecodeRefinedEvidence<Working, FirstPair>,
        SecondEvidenceImage<FirstPair.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias F2 = DecodeRefinedEvidence<DecodeRefinedEvidence<
        DecodeRefinedEvidence<Working, FirstPair>, SecondPair>,
        SecondEvidenceImage<SecondPair.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Actual = JointEvidence<F0, JointEvidence<F1, F2>>
    public typealias Left = W
    public typealias Right = Paired<W.Left.Right, Paired<W.Left.Left.Right, W.Left.Left.Left.Right>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
    public enum Endpoints: Null {
        public typealias Left = Paired<ThreeStageFacts.Left, ThreeStageFacts.Right>
        public typealias Right = Paired<Actual.Left, Actual.Answer>
    }
}

/// The ordered facts answer the original three-position question for the
/// supplied two-step law. Operation expressions specify that question; they
/// are not hidden parameters naming the original working configuration.
public enum ThreeStageAnswers<A, B, M: Pair>: PredicateReading
where M.Left: HasVerdict, M.Right: Pair, M.Right.Left: HasVerdict,
      M.Right.Right: HasVerdict, M.Left.Sigma == BeamSpace,
      M.Right.Left.Sigma == BeamSpace, M.Right.Right.Sigma == BeamSpace,
      M.Left.Encoding == SaturationEncoding,
      M.Right.Left.Encoding == SaturationEncoding,
      M.Right.Right.Encoding == SaturationEncoding,
      M.Left.Answer: Structure, M.Right.Left.Answer: Structure,
      M.Right.Right.Answer: Structure {
    public typealias First = ReadRecordedAnswer<M.Left>
    public typealias Second = ReadRecordedAnswer<M.Right.Left>
    public typealias Third = ReadRecordedAnswer<M.Right.Right>
    public typealias Left = M
    public typealias Right = Paired<First.Answer, Paired<Second.Answer, Third.Answer>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = OperationSequence<First.Predicate,
        OperationSequence<OperationSequence<A, Second.Predicate>,
            OperationSequence<OperationSequence<A, B>, Third.Predicate>>>
    public typealias Answer = Right
}

/// Three real record constructions surround two supplied working transitions.
/// Five resident commands determine their order and remain in the final past.
/// Each acquisition is tied to its own current source, not relabeled as a
/// repeated read of one unchanged source. [VC97]
public enum AcquiredTwoStepStages<A: PredicateReading, B: PredicateReading>: ReadingFactors
where A.Answer == B.Left, A.Sigma == BeamSpace, B.Sigma == BeamSpace,
      A.Encoding == SaturationEncoding, B.Encoding == SaturationEncoding,
      A.Predicate: Structure, B.Predicate: Structure,
      A.Left: Pair, A.Left.Left: Pair, A.Left.Left.Left: Structure,
      A.Answer: Pair, A.Answer.Left: Pair, A.Answer.Left.Left: Structure,
      B.Answer: Pair, B.Answer.Left: Pair, B.Answer.Left.Left: Structure {
    public typealias Q0 = LocalStageImage<A.Left>
    public typealias Q1 = LocalStageImage<A.Answer>
    public typealias Q2 = LocalStageImage<B.Answer>
    public typealias R0 = RetainingRecordedReading<Q0>
    public typealias R1 = ExperimentReadingBeside<A, FactOf<Q0>>
    public typealias R2 = ExperimentReadingBeside<RetainingRecordedReading<Q1>, FactOf<Q0>>
    public typealias R3 = ExperimentReadingBeside<ExperimentReadingBeside<B, FactOf<Q1>>, FactOf<Q0>>
    public typealias R4 = ExperimentReadingBeside<
        ExperimentReadingBeside<RetainingRecordedReading<Q2>, FactOf<Q1>>, FactOf<Q0>>
    public typealias Tape = Paired<R0.Predicate, Paired<R1.Predicate,
        Paired<R2.Predicate, Paired<R3.Predicate, Paired<R4.Predicate, Never>>>>>
    public typealias First = ResidentBoundaryCommand<R0, Tape, Never>
    public typealias Second = ResidentBoundaryCommand<R1,
        First.Answer.Right.Left, First.Answer.Right.Right>
    public typealias Third = ResidentBoundaryCommand<R2,
        Second.Answer.Right.Left, Second.Answer.Right.Right>
    public typealias Fourth = ResidentBoundaryCommand<R3,
        Third.Answer.Right.Left, Third.Answer.Right.Right>
    public typealias Fifth = ResidentBoundaryCommand<R4,
        Fourth.Answer.Right.Left, Fourth.Answer.Right.Right>
    public enum Path: PredicateReading {
        public typealias Left = Paired<A.Left, Paired<Tape, Never>>
        public typealias Past = Paired<R4.Predicate, Paired<R3.Predicate,
            Paired<R2.Predicate, Paired<R1.Predicate, Paired<R0.Predicate, Never>>>>>
        public typealias Right = Paired<Paired<Paired<Paired<B.Answer, FactOf<Q2>>,
            FactOf<Q1>>, FactOf<Q0>>, Paired<Never, Past>>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = OperationSequence<OperationSequence<OperationSequence<
            OperationSequence<R0.Predicate, R1.Predicate>, R2.Predicate>, R3.Predicate>, R4.Predicate>
        public typealias Answer = Right
        public enum Seams: Null {
            public typealias Left = Paired<Path.Left, Paired<First.Answer,
                Paired<Second.Answer, Paired<Third.Answer, Paired<Fourth.Answer, Fifth.Answer>>>>>
            public typealias Right = Paired<First.Left, Paired<Second.Left,
                Paired<Third.Left, Paired<Fourth.Left, Paired<Fifth.Left, Path.Right>>>>>
        }
    }
    public typealias Initial = FirstEvidenceImage<Path.Left, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Left = DecodeRefinedEvidence<Initial, TwoStepStageTrace<A, B>>
    public typealias Observation = SequentialReading<Path, ThreeStageFacts<Path.Answer>>
    public typealias Right = ThreeStageAnswers<A.Predicate, B.Predicate, Observation.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Left.Predicate
    public typealias Answer = Left.Answer
}
