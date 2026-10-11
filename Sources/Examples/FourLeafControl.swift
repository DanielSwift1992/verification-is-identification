import VerificationIsIdentification

/// The existing four coupled contacts at an arbitrary current stage. The
/// resident selector still receives only the phase and its carried program.
public enum FourLeafControlRoot<O: Structure, A: Structure, B: Structure,
    C: Structure, D: Structure, P: Structure, Q: Structure, R: Structure,
    T: Structure, K: Structure>: Pair {
    public typealias S0 = PairedApplication<FourLeafStage0<O, A, B, C, D>,
        ExperimentReadingBeside<FourLeafPhase0<P, Q, R, T>, K>>
    public typealias S1 = PairedApplication<FourLeafStage1<O, A, B, C, D>,
        ExperimentReadingBeside<FourLeafPhase1<P, Q, R, T>, K>>
    public typealias S2 = PairedApplication<FourLeafStage2<O, A, B, C, D>,
        ExperimentReadingBeside<FourLeafPhase2<P, Q, R, T>, K>>
    public typealias S3 = PairedApplication<FourLeafStage3<O, A, B, C, D>,
        ExperimentReadingBeside<FourLeafPhase3<P, Q, R, T>, K>>
    public typealias Low = CandidateFork<CandidateLeaf<S0>, CandidateLeaf<S1>>
    public typealias High = CandidateFork<CandidateLeaf<S2>, CandidateLeaf<S3>>
    public typealias Catalogue = CandidateFork<Low, High>
    public typealias Expression = FourLeafResidentLibrary
    public typealias Left = LocalPhaseWorld<FourLeafStageLabels<O, A, B, C, D>,
        BoundaryWorking<P, Q, R, T>, K>
    public typealias Right = Paired<Expression, Catalogue>
    public typealias Select0 = SelectCandidateLeft<
        SelectCandidateLeft<SelectCandidateLeaf<S0>, CandidateLeaf<S1>>, High>
    public typealias Select1 = SelectCandidateLeft<
        SelectCandidateRight<CandidateLeaf<S0>, SelectCandidateLeaf<S1>>, High>
    public typealias Select2 = SelectCandidateRight<Low,
        SelectCandidateLeft<SelectCandidateLeaf<S2>, CandidateLeaf<S3>>>
    public typealias Select3 = SelectCandidateRight<Low,
        SelectCandidateRight<CandidateLeaf<S2>, SelectCandidateLeaf<S3>>>
    public enum LibraryMatches: Null {
        public typealias Left = BoundaryWorking<S0.Predicate, S1.Predicate, S2.Predicate, S3.Predicate>
        public typealias Right = Paired<Expression.Left, Expression.Right>
    }
}

/// The stage is carried by the source but is absent from the selector input.
/// FourLeafMarked supplies the same four fixed marker-location clauses used
/// by the center-only acquisition, now at any actual stage source.
public enum FourLeafControlInput<S: Structure, R: PredicateReading, K: Pair>: PredicateReading
where R.Left: Structure, R.Answer: Structure, K.Left: Structure,
      R.Sigma == BeamSpace, R.Encoding == SaturationEncoding {
    public typealias Source = LocalPhaseWorld<S, R.Left, K>
    public typealias Tail = SecondEvidenceImage<Source, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Phase = SequentialReading<Tail,
        FirstEvidenceImage<Tail.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Context = SequentialReading<Tail,
        SecondEvidenceImage<Tail.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Program = SequentialReading<Context,
        FirstEvidenceImage<K, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Actual = JointEvidence<SequentialReading<Phase, R>, Program>
    public typealias Left = Source
    public typealias Right = Actual.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
}

/// Four source-bound clauses of the one resident U. All catalogue addresses
/// come from the existing resident program; K remains an untouched field.
public enum FourLeafControl<O: Structure, A: Structure, B: Structure,
    C: Structure, D: Structure, K: Structure>: Close {
    public typealias Stage = FourLeafStageLabels<O, A, B, C, D>
    public typealias Context = Paired<FourLeafAddressProgram, K>
    public typealias R0 = FourLeafControlRoot<O, A, B, C, D, Lit1, Never, Never, Never, Context>
    public typealias R1 = FourLeafControlRoot<O, A, B, C, D, Never, Lit1, Never, Never, Context>
    public typealias R2 = FourLeafControlRoot<O, A, B, C, D, Never, Never, Lit1, Never, Context>
    public typealias R3 = FourLeafControlRoot<O, A, B, C, D, Never, Never, Never, Lit1, Context>
    public typealias At0 = SelectedLocalApplication<R0,
        FourLeafControlInput<Stage, FourLeafMarked0, Context>,
        Route00<FourLeafAddressProgram>, R0.Select0>
    public typealias At1 = SelectedLocalApplication<R1,
        FourLeafControlInput<Stage, FourLeafMarked1, Context>,
        Route01<FourLeafAddressProgram>, R1.Select1>
    public typealias At2 = SelectedLocalApplication<R2,
        FourLeafControlInput<Stage, FourLeafMarked2, Context>,
        Route10<FourLeafAddressProgram>, R2.Select2>
    public typealias At3 = SelectedLocalApplication<R3,
        FourLeafControlInput<Stage, FourLeafMarked3, Context>,
        Route11<FourLeafAddressProgram>, R3.Select3>
}

/// Four actual U selections rotate five arbitrary stage labels and return
/// phase zero. Each next source is supplied by the preceding selected row.
public enum FourLeafControlRound<O: Structure, A: Structure, B: Structure,
    C: Structure, D: Structure, K: Structure>: PredicateReading {
    public typealias S0 = FourLeafControl<O, A, B, C, D, K>.At0
    public typealias S1 = FourLeafControl<A, O, B, C, D, K>.At1
    public typealias S2 = FourLeafControl<B, O, A, C, D, K>.At2
    public typealias S3 = FourLeafControl<C, O, A, B, D, K>.At3
    public typealias Actual = FollowedPair<FollowedPair<S0, S1>, FollowedPair<S2, S3>>
    public typealias Left = Actual.Left
    public typealias Right = Actual.Answer
    public typealias Sigma = Actual.Sigma
    public typealias Encoding = Actual.Encoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
    public enum Outcome: Null {
        public typealias Left = FourLeafControlRound.Right
        public typealias Right = LocalPhaseWorld<FourLeafStageLabels<D, O, A, B, C>,
            FourLeafPhaseMark0, Paired<FourLeafAddressProgram, K>>
    }
}

/// Five rounds give a twenty-contact return with the actual context retained.
/// This does not reset separately acquired records or identify the whole
/// experiment with its twenty target states.
public enum FourLeafControlCycle<O: Structure, A: Structure, B: Structure,
    C: Structure, D: Structure, K: Structure>: Null {
    public typealias R0 = FourLeafControlRound<O, A, B, C, D, K>
    public typealias R1 = FourLeafControlRound<D, O, A, B, C, K>
    public typealias R2 = FourLeafControlRound<C, D, O, A, B, K>
    public typealias R3 = FourLeafControlRound<B, C, D, O, A, K>
    public typealias R4 = FourLeafControlRound<A, B, C, D, O, K>
    public typealias Path = FollowedPair<FollowedPair<FollowedPair<R0, R1>,
        FollowedPair<R2, R3>>, R4>
    public typealias Left = Path.Left
    public typealias Right = Path.Answer
}
