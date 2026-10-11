import VerificationIsIdentification

/// Change the two phase coordinates while retaining the stage and payload.
/// This is built from the existing independent readings and field exchange.
public typealias RenameLocalPhase<S: Structure, C: Pair, V: Structure> = PairedApplication<
    IdentityReading<S, BeamSpace, SaturationEncoding>,
    PairedApplication<SwapBoundaryReading<C>, IdentityReading<V, BeamSpace, SaturationEncoding>>>
where C.Left: Structure, C.Right: Structure

/// Both actual primitives commute with this phase representation change.
/// No equality of the output worlds is supplied by the caller.
public enum RenameLocalPhaseFirst<S: Pair, C: Pair, V: Structure>: CommutingTransition
where S.Right: Pair, S.Right.Left: Structure, C.Left: Structure, C.Right: Structure {
    public typealias Left = RenameLocalPhase<S, C, V>
    public typealias SourceStep = LocalPhaseFirst<Left.Left>
    public typealias Right = RenameLocalPhase<SourceStep.Answer.Left,
        SourceStep.Answer.Right.Left, V>
    public typealias ImageStep = LocalPhaseFirst<Left.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Operation = FirstProjection
}

public enum RenameLocalPhaseSecond<S: Pair, C: Pair, V: Structure>: CommutingTransition
where S.Right: Pair, S.Right.Right: Structure, C.Left: Structure, C.Right: Structure {
    public typealias Left = RenameLocalPhase<S, C, V>
    public typealias SourceStep = LocalPhaseSecond<Left.Left>
    public typealias Right = RenameLocalPhase<SourceStep.Answer.Left,
        SourceStep.Answer.Right.Left, V>
    public typealias ImageStep = LocalPhaseSecond<Left.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Operation = SecondProjection
}

/// Reconstruct the original selection from the actual new local input.
/// The source adapter is used by the proof; the decoder receives only the
/// changed phase head and changed resident table, not the whole source.
public enum RenamedPhaseZeroChoice<S: Structure, V: Structure, J: Pair>: ReadingFactors
where J.Left: Structure, J.Right: Structure {
    public typealias Change = RenameLocalPhase<S, LocalPhaseZero, V>
    public typealias OldInput = LocalPhaseProgramInput<Change.Left, J>
    public typealias NewInput = LocalPhaseProgramInput<Change.Answer, SwapBoundaryReading<J>.Answer>
    public typealias Left = DecodeRefinedEvidence<OldInput, LocalPolicyAtZero<J>>
    public typealias Observation = DecodeRefinedEvidence<Change, NewInput>
    public typealias Right = LocalPolicyAtOne<NewInput.Answer.Right>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = AcquisitionChoice
    public typealias Answer = Left.Answer
}

public enum RenamedPhaseOneChoice<S: Structure, V: Structure, J: Pair>: ReadingFactors
where J.Left: Structure, J.Right: Structure {
    public typealias Change = RenameLocalPhase<S, LocalPhaseOne, V>
    public typealias OldInput = LocalPhaseProgramInput<Change.Left, J>
    public typealias NewInput = LocalPhaseProgramInput<Change.Answer, SwapBoundaryReading<J>.Answer>
    public typealias Left = DecodeRefinedEvidence<OldInput, LocalPolicyAtOne<J>>
    public typealias Observation = DecodeRefinedEvidence<Change, NewInput>
    public typealias Right = LocalPolicyAtZero<NewInput.Answer.Right>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = AcquisitionChoice
    public typealias Answer = Left.Answer
}

/// The two-step procedure in the changed phase coordinates. The initial
/// representation change is explicit; the command bound starts after that
/// mapped preparation. The original question is still named before it.
public enum RenamedPhaseFindsOriginal<V: Structure>: ReadingFactors {
    public typealias Change = RenameLocalPhase<ReversibleExperiment.A, LocalPhaseZero, V>
    public typealias Program = SwapBoundaryReading<LocalPhaseTable>.Answer
    public typealias First = LocalPhaseFirst<Change.Answer>
    public typealias Second = LocalPhaseSecond<First.Answer>
    public typealias Path = SequentialReading<First, Second>

    public enum ActualChoices: Null {
        public typealias AtOne = LocalPolicyAtOne<Program>
        public typealias AtZero = LocalPolicyAtZero<Program>
        public typealias Left = Paired<
            Paired<LocalPhaseProgramInput<First.Left, Program>.Answer, First.Predicate>,
            Paired<LocalPhaseProgramInput<Second.Left, Program>.Answer, Second.Predicate>>
        public typealias Right = Paired<Paired<AtOne.Left, AtOne.Answer>,
            Paired<AtZero.Left, AtZero.Answer>>
    }

    public typealias Left = LocalPhaseTarget<Change.Left>
    public typealias Observation = SequentialReading<SequentialReading<Change, Path>,
        LocalPhaseWindow<Path.Answer>>
    public typealias Right = SecondEvidenceImage<Observation.Answer,
        BeamSpace, SaturationEncoding, BetaQuestion>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = BetaQuestion
    public typealias Answer = Left.Answer
}

/// The longer word aaab reaches the same working endpoint as ab. Its order
/// comes from the actual resident tape, whose consumed heads stay in the past.
/// The source question reads the original working payload through its field;
/// it is not defined as the execution's answer.
public enum ResidentPaddedPhaseFindsOriginal<V: Structure>: ReadingFactors {
    public typealias Start = LocalPhaseWorld<ReversibleExperiment.A, LocalPhaseZero, V>
    public typealias A = LocalPhaseFirst<Start>
    public typealias B = LocalPhaseFirst<A.Answer>
    public typealias C = LocalPhaseFirst<B.Answer>
    public typealias D = LocalPhaseSecond<C.Answer>
    public typealias Tape = Paired<FirstProjection, Paired<FirstProjection,
        Paired<FirstProjection, Paired<SecondProjection, Never>>>>
    public typealias First = ResidentBoundaryCommand<A, Tape, Never>
    public typealias Second = ResidentBoundaryCommand<B,
        First.Answer.Right.Left, First.Answer.Right.Right>
    public typealias Third = ResidentBoundaryCommand<C,
        Second.Answer.Right.Left, Second.Answer.Right.Right>
    public typealias Fourth = ResidentBoundaryCommand<D,
        Third.Answer.Right.Left, Third.Answer.Right.Right>
    public typealias Path = SequentialReading<SequentialReading<
        SequentialReading<First, Second>, Third>, Fourth>
    public typealias InitialWorking = FirstEvidenceImage<Path.Left,
        BeamSpace, SaturationEncoding, FirstProjection>
    public typealias FinalWorking = FirstEvidenceImage<Path.Answer,
        BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Left = DecodeRefinedEvidence<InitialWorking, LocalPhaseTarget<Start>>
    public typealias Observation = SequentialReading<Path,
        DecodeRefinedEvidence<FinalWorking, LocalPhaseWindow<D.Answer>>>
    public typealias Right = SecondEvidenceImage<Observation.Answer,
        BeamSpace, SaturationEncoding, BetaQuestion>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = BetaQuestion
    public typealias Answer = Left.Answer
}
