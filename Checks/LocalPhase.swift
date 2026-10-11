import VerificationIsIdentification
import Examples

// Every edge of the admitted three-stage table is checked under both
// branch involutions. The phase letters and payload are arbitrary.
enum LocalPhaseBranchesReturn<L: Structure, R: Structure, V: Structure>: Null {
    typealias C = Paired<L, R>
    typealias X = LocalPhaseWorld<ReversibleExperiment.A, C, V>
    typealias Y = LocalPhaseWorld<ReversibleExperiment.Signal, C, V>
    typealias Z = LocalPhaseWorld<ReversibleExperiment.B, C, V>
    typealias AX = LocalPhaseFirst<X>
    typealias AY = LocalPhaseFirst<Y>
    typealias AZ = LocalPhaseFirst<Z>
    typealias BX = LocalPhaseSecond<X>
    typealias BY = LocalPhaseSecond<Y>
    typealias BZ = LocalPhaseSecond<Z>
    typealias Left = Paired<LocalPhaseFirst<AX.Answer>.Answer,
        Paired<LocalPhaseFirst<AY.Answer>.Answer,
        Paired<LocalPhaseFirst<AZ.Answer>.Answer,
        Paired<LocalPhaseSecond<BX.Answer>.Answer,
        Paired<LocalPhaseSecond<BY.Answer>.Answer, LocalPhaseSecond<BZ.Answer>.Answer>>>>>
    typealias Right = Paired<X, Paired<Y, Paired<Z, Paired<X, Paired<Y, Z>>>>>
}

// These are the six ACTUAL successive states of the feedback law. Every
// intermediate input is checked by composition. Covering all six stage/phase
// states establishes the complete finite cycle, not merely a return from x0.
enum LocalPhaseClosedCycle<V: Structure>: Null {
    typealias X0 = LocalPhaseAtZero<ReversibleExperiment.A, V>.Step
    typealias Y1 = LocalPhaseAtOne<X0.Answer.Left, V>.Step
    typealias Z0 = LocalPhaseAtZero<Y1.Answer.Left, V>.Step
    typealias Z1 = LocalPhaseAtOne<Z0.Answer.Left, V>.Step
    typealias Y0 = LocalPhaseAtZero<Z1.Answer.Left, V>.Step
    typealias X1 = LocalPhaseAtOne<Y0.Answer.Left, V>.Step
    typealias Path = FollowedPair<FollowedPair<FollowedPair<
        FollowedPair<FollowedPair<X0, Y1>, Z0>, Z1>, Y0>, X1>
    typealias Left = Paired<Path.Right,
        Paired<Y1.Left, Paired<Z0.Left, Paired<Z1.Left, Paired<Y0.Left, X1.Left>>>>>
    typealias Right = Paired<Path.Left,
        Paired<LocalPhaseWorld<ReversibleExperiment.Signal, LocalPhaseOne, V>,
        Paired<LocalPhaseWorld<ReversibleExperiment.B, LocalPhaseZero, V>,
        Paired<LocalPhaseWorld<ReversibleExperiment.B, LocalPhaseOne, V>,
        Paired<LocalPhaseWorld<ReversibleExperiment.Signal, LocalPhaseZero, V>,
            LocalPhaseWorld<ReversibleExperiment.A, LocalPhaseOne, V>>>>>>
}

// The inverse action is selected by the OUTPUT phase. Applying the forward
// phase table at the output would choose the wrong inverse branch.
enum LocalPhaseInverseBranches<V: Structure>: Null {
    typealias C = LocalPhaseClosedCycle<V>
    typealias Left = Paired<LocalPhaseFirst<C.X0.Answer>.Answer,
        Paired<LocalPhaseSecond<C.Y1.Answer>.Answer,
        Paired<LocalPhaseFirst<C.Z0.Answer>.Answer,
        Paired<LocalPhaseSecond<C.Z1.Answer>.Answer,
        Paired<LocalPhaseFirst<C.Y0.Answer>.Answer, LocalPhaseSecond<C.X1.Answer>.Answer>>>>>
    typealias Right = Paired<C.X0.Left, Paired<C.Y1.Left,
        Paired<C.Z0.Left, Paired<C.Z1.Left, Paired<C.Y0.Left, C.X1.Left>>>>>
}

// The two constant choices exhaust nonterminal policies at the quiet input.
// Their complete prepared orbits are x0/y1 and x0/x1, both outside stage B.
enum LocalPhaseBlindOrbits<V: Structure>: Null {
    typealias X = LocalPhaseWorld<ReversibleExperiment.A, LocalPhaseZero, V>
    typealias A = LocalPhaseFirst<X>
    typealias B = LocalPhaseSecond<X>
    typealias Left = Paired<Paired<A.Answer, LocalPhaseFirst<A.Answer>.Answer>,
        Paired<B.Answer, LocalPhaseSecond<B.Answer>.Answer>>
    typealias Right = Paired<
        Paired<LocalPhaseWorld<ReversibleExperiment.Signal, LocalPhaseOne, V>, X>,
        Paired<LocalPhaseWorld<ReversibleExperiment.A, LocalPhaseOne, V>, X>>
}

// Changing hidden payload cannot be a hidden action-selection input.
enum LocalPhaseChoiceIgnoresPayload<A: Structure, B: Structure>: Null {
    typealias X = LocalPhaseWorld<ReversibleExperiment.A, LocalPhaseZero, A>
    typealias Y = LocalPhaseWorld<ReversibleExperiment.Signal, LocalPhaseZero, B>
    typealias Left = LocalPhaseControlInput<X>.Answer
    typealias Right = LocalPhaseControlInput<Y>.Answer
}

enum LocalPhaseAnswersOriginal<V: Structure>: Null {
    typealias F = LocalPhaseFindsOriginal<V>
    typealias Left = Paired<F.Answer, F.Right.Left>
    typealias Right = Paired<V, Paired<ExperimentSignal, V>>
}

// Both nonconstant programs preserve the same independently named initial
// question and admit exactly the same final decoder. Their phase at the
// readout differs, but that distinction is unnecessary for this answer.
enum LocalPhaseProgramsShareDecoder<V: Structure>: Null {
    typealias Fast = LocalPhaseFindsOriginal<V>
    typealias Slow = LocalPhaseOppositeFindsOriginal<V>
    typealias Left = Paired<Fast.Left, Paired<Fast.Observation.Answer, Fast.Right>>
    typealias Right = Paired<Slow.Left, Paired<Slow.Observation.Answer, Slow.Right>>
}

// The added phase carries no initial answer distinction: both initial
// payloads give the same full control input, but their original targets differ.
typealias LocalPhaseInitialZero = LocalPhaseWorld<ReversibleExperiment.A, LocalPhaseZero, Never>
typealias LocalPhaseInitialOne = LocalPhaseWorld<ReversibleExperiment.A, LocalPhaseZero, Lit1>
enum LocalPhaseEqualInitialEvidence: Null {
    typealias Left = LocalPhaseControlInput<LocalPhaseInitialZero>.Answer
    typealias Right = LocalPhaseControlInput<LocalPhaseInitialOne>.Answer
}
typealias LocalPhaseInitialTargetsDiffer = ZeroSuccessorBoundary<
    LocalPhaseTarget<LocalPhaseInitialZero>, LocalPhaseTarget<LocalPhaseInitialOne>, Never>

enum LocalPhaseTransportKeepsAnswer<V: Structure>: Null {
    typealias Old = LocalPhaseFindsOriginal<V>
    typealias New = RenamedPhaseFindsOriginal<V>
    typealias Left = Paired<Old.Left, Paired<Old.Observation.Answer, Old.Right>>
    typealias Right = Paired<New.Left, Paired<New.Observation.Answer, New.Right>>
}

// The admitted phases are canonical pairs. Their coordinate change has an
// actual inverse, without equating an arbitrary nominal Pair shell to a tuple.
enum LocalPhaseCoordinatesReturn<S: Structure, L: Structure, R: Structure,
    V: Structure>: Null {
    typealias First = RenameLocalPhase<S, Paired<L, R>, V>
    typealias Second = RenameLocalPhase<First.Answer.Left, First.Answer.Right.Left, V>
    typealias Left = Second.Answer
    typealias Right = First.Left
}

enum RenamedPhaseChoiceIgnoresHiddenSource<S: Structure, T: Structure,
    A: Structure, B: Structure, J: Pair>: Null
where J.Left: Structure, J.Right: Structure {
    typealias X = RenamedPhaseZeroChoice<S, A, J>
    typealias Y = RenamedPhaseZeroChoice<T, B, J>
    typealias Left = Paired<X.Observation.Answer, X.Right>
    typealias Right = Paired<Y.Observation.Answer, Y.Right>
}

// Changing phase coordinates without transporting the table chooses ba,
// rather than ab. Its two-step endpoint is the nonready middle stage.
enum LocalPhaseUnpairedChangeMissesWindow<V: Structure>: Null {
    typealias First = LocalPhaseAtOne<ReversibleExperiment.A, V>.Step
    typealias Second = LocalPhaseAtZero<First.Answer.Left, V>.Step
    typealias Path = SequentialReading<First, Second>
    typealias Left = Path.Answer
    typealias Right = LocalPhaseWorld<ReversibleExperiment.Signal, LocalPhaseOne, V>
}

// Removing aa preserves the working endpoint, acquired answer and decoder.
// The larger resident tape/past is not thereby identified with the short run.
enum PaddedPhaseKeepsWorkingAnswer<V: Structure>: Null {
    typealias P = ResidentPaddedPhaseFindsOriginal<V>
    typealias S = LocalPhaseFindsOriginal<V>
    typealias Left = Paired<P.Path.Answer.Left, Paired<P.Answer,
        Paired<P.Observation.Answer, P.Right>>>
    typealias Right = Paired<S.Path.Answer, Paired<S.Answer,
        Paired<S.Observation.Answer, S.Right>>>
}

// Positions two and four repeat the entire working state, not just a coarse
// sensor value. The fixed phase-only table therefore receives one input.
enum PaddedPhaseRepeatsAvailableInput<V: Structure, J: Pair>: Null {
    typealias P = ResidentPaddedPhaseFindsOriginal<V>
    typealias Left = Paired<P.Second.Left.Left,
        LocalPhaseProgramInput<P.Second.Left.Left, J>.Answer>
    typealias Right = Paired<P.Fourth.Left.Left,
        LocalPhaseProgramInput<P.Fourth.Left.Left, J>.Answer>
}

// The resident construction does provide the missing distinction. Both
// consumed instructions and the final empty pending word are actual fields.
enum PaddedPhaseRetainsOrder<V: Structure>: Null {
    typealias P = ResidentPaddedPhaseFindsOriginal<V>
    typealias Left = Paired<
        Paired<P.Second.Left.Right.Left.Left, P.Fourth.Left.Right.Left.Left>,
        P.Path.Answer.Right>
    typealias Right = Paired<Paired<FirstProjection, SecondProjection>,
        Paired<Never, Paired<SecondProjection, Paired<FirstProjection,
            Paired<FirstProjection, Paired<FirstProjection, Never>>>>>>
}

// Undoing the actual working involution and moving back the last stored head
// restores the larger initial whole. No instruction or old past was erased.
enum PaddedPhaseResidentStepsReturn<V: Structure>: Null {
    typealias P = ResidentPaddedPhaseFindsOriginal<V>
    typealias A = P.First.Answer
    typealias B = P.Fourth.Answer
    typealias UndoA = Paired<LocalPhaseFirst<A.Left>.Answer,
        Paired<Paired<A.Right.Right.Left, A.Right.Left>, A.Right.Right.Right>>
    typealias UndoB = Paired<LocalPhaseSecond<B.Left>.Answer,
        Paired<Paired<B.Right.Right.Left, B.Right.Left>, B.Right.Right.Right>>
    typealias Left = Paired<UndoA, UndoB>
    typealias Right = Paired<P.First.Left, P.Fourth.Left>
}

// All four graph positions, both inverse equations, and every projected
// contact are covered. Their cyclic descriptions do not imply infinite K.
enum FourStageCycleReturns<V: Structure>: Null {
    typealias X = LocalStageCycle.X
    typealias Y = LocalStageCycle.Outward
    typealias Z = LocalStageCycle.Z
    typealias R = LocalStageCycle.Returning
    typealias A = LocalStageStep<X, V>
    typealias B = LocalStageStep<A.Answer.Left, V>
    typealias C = LocalStageStep<B.Answer.Left, V>
    typealias D = LocalStageStep<C.Answer.Left, V>
    typealias Path = SequentialReading<SequentialReading<SequentialReading<A, B>, C>, D>
    typealias Left = Paired<Path.Answer, Paired<B.Left, Paired<C.Left, D.Left>>>
    typealias Right = Paired<Path.Left, Paired<Paired<Y, V>, Paired<Paired<Z, V>, Paired<R, V>>>>
}

enum FourStageInverseCoversCarrier: Null {
    typealias X = LocalStageCycle.X
    typealias Y = LocalStageCycle.Outward
    typealias Z = LocalStageCycle.Z
    typealias R = LocalStageCycle.Returning
    typealias Left = Paired<
        Paired<LocalStagePredecessor<LocalStageSuccessor<X>.Answer>.Answer,
            LocalStageSuccessor<LocalStagePredecessor<X>.Answer>.Answer>,
        Paired<Paired<LocalStagePredecessor<LocalStageSuccessor<Y>.Answer>.Answer,
            LocalStageSuccessor<LocalStagePredecessor<Y>.Answer>.Answer>,
        Paired<Paired<LocalStagePredecessor<LocalStageSuccessor<Z>.Answer>.Answer,
            LocalStageSuccessor<LocalStagePredecessor<Z>.Answer>.Answer>,
        Paired<LocalStagePredecessor<LocalStageSuccessor<R>.Answer>.Answer,
            LocalStageSuccessor<LocalStagePredecessor<R>.Answer>.Answer>>>>
    typealias Right = Paired<Paired<X, X>, Paired<Paired<Y, Y>,
        Paired<Paired<Z, Z>, Paired<R, R>>>>
}

enum FourStageUsesAllowedContacts: Null {
    typealias X = LocalStageCycle.X
    typealias Y = LocalStageCycle.Outward
    typealias Z = LocalStageCycle.Z
    typealias R = LocalStageCycle.Returning
    typealias Left = Paired<LocalStageImage<LocalStageSuccessor<X>.Answer>.Answer,
        Paired<LocalStageImage<LocalStageSuccessor<Y>.Answer>.Answer,
        Paired<LocalStageImage<LocalStageSuccessor<Z>.Answer>.Answer,
            LocalStageImage<LocalStageSuccessor<R>.Answer>.Answer>>>
    typealias Right = Paired<X.Left.Left.Right.Left,
        Paired<Y.Left.Left.Right.Right, Paired<Z.Left.Left.Right.Right, R.Left.Left.Right.Left>>>
}

enum FourStageSharesAnswerDecoder<V: Structure>: Null {
    typealias Four = LocalStageFindsOriginal<V>
    typealias Six = LocalPhaseFindsOriginal<V>
    typealias Left = Paired<Four.Answer, Paired<Four.Observation.Answer, Four.Right>>
    typealias Right = Paired<Six.Answer, Paired<Six.Observation.Answer, Six.Right>>
}

enum FourStageMiddleReadingsAgree: Null {
    typealias Left = LocalStageImage<LocalStageCycle.Outward>.Answer
    typealias Right = LocalStageImage<LocalStageCycle.Returning>.Answer
}
typealias FourStageMiddlePositionsDiffer = ZeroSuccessorBoundary<
    LocalStageResidual<LocalStageCycle.Returning>,
    LocalStageResidual<LocalStageCycle.Outward>, Never>

#if LOCAL_PHASE_MERGES_MIDDLE_POSITIONS
// A total reversible lift of a on this four-position carrier would send
// both middle positions to the sole x position. Any inverse would then have
// to identify these positively different residual answers.
enum RejectedFourStageMergedPositions: Null {
    typealias Left = LocalStageResidual<LocalStageCycle.Returning>.Answer
    typealias Right = LocalStageResidual<LocalStageCycle.Outward>.Answer
}
#endif

#if LOCAL_PHASE_REPEATS_STAGE_AS_STATE
// Same current stage y, different next stages z/x under the actual cycle.
enum RejectedFourStageAutonomousImage: Null {
    typealias Left = LocalStageImage<LocalStageSuccessor<LocalStageCycle.Outward>.Answer>.Answer
    typealias Right = LocalStageImage<LocalStageSuccessor<LocalStageCycle.Returning>.Answer>.Answer
}
#endif

#if LOCAL_PHASE_FORGETS_WORD_POSITION
// Any shared table that supplies a at the earlier phase-one position cannot
// supply b at its identical later input. The first choice is the premise;
// the second is the refused consequence, not an extra successful premise.
enum RejectedPaddedOneTable<J: Pair>: Null where J.Right == FirstProjection {
    typealias P = ResidentPaddedPhaseFindsOriginal<Never>
    typealias Left = LocalPolicyAtOne<J>.Answer
    typealias Right = P.Fourth.Predicate
}
#endif

#if LOCAL_PHASE_IGNORES_CONTROL_CHANGE
// Correct terminal payload does not make the enlarged whole equal to its
// initial state: its actual pending word and retained past have changed.
enum RejectedPaddedUntouchedControl: Null {
    typealias P = ResidentPaddedPhaseFindsOriginal<Never>
    typealias Left = P.Path.Left.Right
    typealias Right = P.Path.Answer.Right
}
#endif

#if LOCAL_PHASE_RENAMES_ONLY_COORDINATES
enum RejectedPhaseUnchangedTable: ReadingFactors {
    typealias Old = RenamedPhaseZeroChoice<ReversibleExperiment.A, Never, LocalPhaseTable>
    typealias Left = Old.Left
    typealias NewInput = LocalPhaseProgramInput<Old.Change.Answer, LocalPhaseTable>
    typealias Observation = DecodeRefinedEvidence<Old.Change, NewInput>
    typealias Right = LocalPolicyAtOne<LocalPhaseTable>
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Predicate = AcquisitionChoice
    typealias Answer = Left.Answer
}
#endif

#if LOCAL_PHASE_CLAIMS_UNPAIRED_DEADLINE
typealias RejectedPhaseUnpairedDeadline = LocalPhaseWindow<LocalPhaseUnpairedChangeMissesWindow<Never>.Path.Answer>
#endif

#if LOCAL_PHASE_ALTERS_PRIMITIVE
// The operation LABEL agrees with First, while its actual result is Second.
// The output corner of the commuting square must still refuse this claim.
enum PhaseMislabeledPrimitive<W: Pair>: PredicateReading
where W.Left: Pair, W.Left.Right: Pair, W.Left.Right.Right: Structure,
      W.Right: Pair, W.Right.Left: Pair, W.Right.Right: Structure,
      W.Right.Left.Left: Structure, W.Right.Left.Right: Structure {
    typealias Left = W
    typealias Right = LocalPhaseSecond<W>.Answer
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Predicate = FirstProjection
    typealias Answer = Right
}
enum RejectedPhasePrimitiveChange: CommutingTransition {
    typealias Old = RenameLocalPhaseFirst<ReversibleExperiment.A, LocalPhaseZero, Never>
    typealias Left = Old.Left
    typealias Right = Old.Right
    typealias SourceStep = Old.SourceStep
    typealias ImageStep = PhaseMislabeledPrimitive<Left.Answer>
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Operation = FirstProjection
}
#endif

#if LOCAL_PHASE_READS_TOO_EARLY
typealias RejectedPhaseEarlyWindow = LocalPhaseWindow<LocalPhaseFindsOriginal<Never>.First.Answer>
#endif

#if LOCAL_PHASE_REUSES_FORWARD_AS_INVERSE
enum RejectedPhaseForwardInverse: Null {
    typealias C = LocalPhaseClosedCycle<Never>
    typealias Left = C.Y1.Answer
    typealias Right = C.X0.Left
}
#endif

#if LOCAL_PHASE_SELECTS_WITHOUT_PHASE
enum RejectedPhaseIdenticalControlInput: Null {
    typealias X = LocalPhaseWorld<ReversibleExperiment.A, LocalPhaseZero, Never>
    typealias Y = LocalPhaseWorld<ReversibleExperiment.Signal, LocalPhaseOne, Never>
    typealias Left = LocalPhaseControlInput<X>.Answer
    typealias Right = LocalPhaseControlInput<Y>.Answer
}
#endif
