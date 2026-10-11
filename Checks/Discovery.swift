import VerificationIsIdentification
import Examples

// M39: both sources expose the same first two letters, while the third
// depends on their actual continuation. These are constructor reductions;
// the arbitrary-length entropy proof remains in the paper.
enum ShiftSourcesAgreeOnSecondLetter<X: Pair, Y: Pair>: Null
where X.Left: Structure, X.Right: Structure {
    typealias Left = SwapBoundaryReading<Paired<X, Y>>.Answer.Left
    typealias Right = TwistedPairShift<X, Y>.Answer.Left
}

enum PlainShiftThirdLetter<X: Pair, Y: Pair>: Null {
    typealias First = SwapBoundaryReading<Paired<X, Y>>
    typealias Second = SequentialReading<First, SwapBoundaryReading<First.Answer>>
    typealias Left = Second.Answer.Left
    typealias Right = X
}

enum TwistedShiftThirdLetter<X: Pair, Y: Pair>: Null
where X.Left: Structure, X.Right: Structure, Y.Left: Structure, Y.Right: Structure {
    typealias Left = DoubleTwistedPairShift<X, Y>.Answer.Left
    typealias Right = SwapBoundaryReading<X>.Answer
}

enum TwistedShiftFourStepsReturn<A: Structure, B: Structure, C: Structure, D: Structure>: Null {
    typealias FirstTwo = DoubleTwistedPairShift<Paired<A, B>, Paired<C, D>>
    typealias Four = SequentialReading<FirstTwo,
        DoubleTwistedPairShift<FirstTwo.Answer.Left, FirstTwo.Answer.Right>>
    typealias Left = Four.Answer
    typealias Right = Paired<Paired<A, B>, Paired<C, D>>
}

typealias ShiftZero = Paired<Never, ExperimentSignal>
typealias ShiftOne = Paired<ExperimentSignal, Never>
typealias PlainZeroStep = SwapBoundaryReading<Paired<ShiftZero, ShiftZero>>
typealias PlainZeroTwoSteps = SequentialReading<PlainZeroStep, SwapBoundaryReading<PlainZeroStep.Answer>>

#if DISCOVERY_PLAIN_SHIFT_ADMITS_001
enum RejectedPlainShift001: Null {
    typealias Left = PlainZeroTwoSteps.Answer.Left
    typealias Right = ShiftOne
}
#endif

#if DISCOVERY_TWISTED_SHIFT_ADMITS_000
enum RejectedTwistedShift000: Null {
    typealias Left = DoubleTwistedPairShift<ShiftZero, ShiftZero>.Answer.Left
    typealias Right = ShiftZero
}
#endif

// Different origins actually merge, not just their observed answer names.
enum FirstQuestionMergesBC: Null {
    typealias Left = TrapExperiment.B.Right.Left
    typealias Right = TrapExperiment.C.Right.Left
}

enum SecondQuestionMergesAC: Null {
    typealias Left = TrapExperiment.A.Right.Right
    typealias Right = TrapExperiment.C.Right.Right
}

// The actually computed second answers still agree after the first merger.
enum TrapTraceStillAgrees: Null {
    typealias Left = TwoQuestionTrace<TrapExperiment.B>.Right
    typealias Right = TwoQuestionTrace<TrapExperiment.C>.Right
}

enum RepairedAFirstAnswer: Null {
    typealias Left = TwoQuestionTrace<ReversibleExperiment.A>.Left
    typealias Right = ExperimentSignal
}

enum RepairedBSecondAnswer: Null {
    typealias Left = TwoQuestionTrace<ReversibleExperiment.B>.Right
    typealias Right = ExperimentSignal
}

enum RepairedCSecondAnswer: Null {
    typealias Left = TwoQuestionTrace<ReversibleExperiment.C>.Right
    typealias Right = ExperimentQuiet
}

#if FALSE_PAIR_SEPARATOR
enum RejectedPairSeparator: Null {
    typealias Left = TrapExperiment.A.Right.Left.Left
    typealias Right = TrapExperiment.B.Right.Left.Left
}
#endif

enum ControllerStepRecoversBothInputs<
    Before: Pair,
    Scene: Pair,
    Memory: Pair
>: Null
where Scene.Left == Before.Left, Memory.Left == Before.Right,
      Scene.Right: Structure, Memory.Right: Structure {
    typealias Left = RecordedControllerStep<Before, Scene, Memory>.Right.Left
    typealias Right = Before
}

enum ControllerStepComputesScene<
    Before: Pair,
    Scene: Pair,
    Memory: Pair
>: Null
where Scene.Left == Before.Left, Memory.Left == Before.Right,
      Scene.Right: Structure, Memory.Right: Structure {
    typealias Left = RecordedControllerStep<Before, Scene, Memory>.Right.Right.Left
    typealias Right = Scene.Right
}

enum ControllerStepComputesMemory<
    Before: Pair,
    Scene: Pair,
    Memory: Pair
>: Null
where Scene.Left == Before.Left, Memory.Left == Before.Right,
      Scene.Right: Structure, Memory.Right: Structure {
    typealias Left = RecordedControllerStep<Before, Scene, Memory>.Right.Right.Right
    typealias Right = Memory.Right
}

#if CONTROLLER_WRONG_SCENE_INPUT
enum RejectedControllerScene: Null {
    typealias Left = RecordedControllerStep<
        Paired<TrapExperiment.A, ExperimentQuiet>,
        Paired<TrapExperiment.B, TrapExperiment.Signal>,
        Paired<ExperimentQuiet, ExperimentSignal>
    >.Right.Left
    typealias Right = Paired<TrapExperiment.A, ExperimentQuiet>
}
#endif

#if CONTROLLER_WRONG_MEMORY_INPUT
enum RejectedControllerMemory: Null {
    typealias Left = RecordedControllerStep<
        Paired<TrapExperiment.A, ExperimentQuiet>,
        Paired<TrapExperiment.A, TrapExperiment.Signal>,
        Paired<ExperimentSignal, ExperimentQuiet>
    >.Right.Left
    typealias Right = Paired<TrapExperiment.A, ExperimentQuiet>
}
#endif

#if FALSE_REPAIRED_BRANCH
enum RejectedRepairedBranch: Null {
    typealias Left = TwoQuestionTrace<ReversibleExperiment.B>.Right
    typealias Right = TwoQuestionTrace<ReversibleExperiment.C>.Right
}
#endif

enum RecordedQuestionRecoversSource<S: Pair>: Null
where S.Right: Pair, S.Right.Left: Structure {
    typealias Left = RecordedFirstQuestion<S>.Right.Left
    typealias Right = S
}

enum RecordedQuestionComputesCurrent<S: Pair>: Null
where S.Right: Pair, S.Right.Left: Structure {
    typealias Left = RecordedFirstQuestion<S>.Right.Right
    typealias Right = S.Right.Left
}

#if FALSE_WHOLE_HISTORY_MERGER
enum RejectedWholeHistoryMerger: Null {
    typealias Left = RecordedFirstQuestion<TrapExperiment.B>.Right.Left
    typealias Right = RecordedFirstQuestion<TrapExperiment.C>.Right.Left
}
#endif

enum OriginalAnswerSurvives<C: Pair>: Null
where C.Left: Pair, C.Left.Right: Pair {
    typealias Left = AdvanceQuestionTag<C>.Right
    typealias Right = C.Right
}

// The declared question is whether the original state was A. Quiet tags no.
// B and C may merge in their current scene while retaining that same answer.
enum SameQuestionMerge: Null {
    typealias Left = AdvanceQuestionTag<Paired<TrapExperiment.B, ExperimentQuiet>>.Right
    typealias Right = AdvanceQuestionTag<Paired<TrapExperiment.C, ExperimentQuiet>>.Right
}

enum ChangedSceneSameQuestion: Null {
    typealias Left = AdvanceQuestionTag<Paired<TrapExperiment.B, ExperimentQuiet>>.Left
    typealias Right = TrapExperiment.A
}

#if RETARGETED_ORIGINAL_QUESTION
enum RejectedRetargetedQuestion: Null {
    typealias Left = AdvanceQuestionTag<Paired<TrapExperiment.B, ExperimentQuiet>>.Right
    typealias Right = ExperimentSignal
}
#endif

// For the question "was the origin C?", these candidate labels differ.
// They annotate the verifier's possibilities, not the observer's memory.
typealias OriginBForCQuestion = Paired<TrapExperiment.B, Never>
typealias OriginCForCQuestion = Paired<TrapExperiment.C, Lit1>
typealias AfterBForCQuestion = AdvanceQuestionTag<OriginBForCQuestion>
typealias AfterCForCQuestion = AdvanceQuestionTag<OriginCForCQuestion>
typealias ObserveAfterB = FirstEvidenceImage<AfterBForCQuestion.Left, BeamSpace, SaturationEncoding, AlphaQuestion>
typealias ObserveAfterC = FirstEvidenceImage<AfterCForCQuestion.Left, BeamSpace, SaturationEncoding, AlphaQuestion>
enum SameActualReadingLeavesDifferentRequiredAnswers: Null {
    typealias Left = ObserveAfterB
    typealias Right = ObserveAfterC
}
typealias DifferentRequiredOriginalAnswers = ZeroSuccessorBoundaryPairClass<
    Paired<AfterBForCQuestion.Right, AfterCForCQuestion.Right>, Never>

#if DISCOVERY_TARGET_TAG_AS_MEMORY
typealias CandidateAnswerTag = SecondEvidenceImage<AfterCForCQuestion, BeamSpace, SaturationEncoding, AlphaQuestion>
typealias RejectedTargetTagAsMemory = SequentialReading<ObserveAfterC, CandidateAnswerTag>
#endif

// Independently declared origins for "was the origin A?" after initial quiet.
typealias DiscoveryOriginA = Paired<TrapExperiment.A, Lit1>
typealias DiscoveryOriginB = Paired<TrapExperiment.B, Never>
typealias DiscoveryOriginC = Paired<TrapExperiment.C, Never>
typealias DiscoveryParents = CandidateFork<CandidateLeaf<DiscoveryOriginA>,
    CandidateFork<CandidateLeaf<DiscoveryOriginB>, CandidateLeaf<DiscoveryOriginC>>>

// Quiet deliberately overapproximates the actual successor support: B/no is
// unused. B and C both reach A/no, and may reuse that one child occurrence.
typealias DiscoveryQuietRow = Paired<TrapExperiment.A, Never>
typealias DiscoverySignalRow = Paired<TrapExperiment.Signal, Lit1>
typealias DiscoveryQuietSupport = CandidateFork<CandidateLeaf<DiscoveryQuietRow>,
    CandidateLeaf<DiscoveryOriginB>>
typealias DiscoverySignalSupport = CandidateLeaf<DiscoverySignalRow>

typealias DiscoveryFirstAction<X: Pair> = SelectCandidateLeft<
    SelectCandidateLeaf<X.Right.Left>, CandidateLeaf<X.Right.Right>> where X.Right: Pair
typealias DiscoverySecondAction<X: Pair> = SelectCandidateRight<
    CandidateLeaf<X.Right.Left>, SelectCandidateLeaf<X.Right.Right>> where X.Right: Pair
typealias DiscoveryQuietBranch = SelectCandidateLeft<
    SelectCandidateLeaf<Paired<ExperimentQuiet, DiscoveryQuietSupport>>,
    CandidateLeaf<Paired<ExperimentSignal, DiscoverySignalSupport>>>
typealias DiscoverySignalBranch = SelectCandidateRight<
    CandidateLeaf<Paired<ExperimentQuiet, DiscoveryQuietSupport>>,
    SelectCandidateLeaf<Paired<ExperimentSignal, DiscoverySignalSupport>>>
typealias DiscoveryQuietMember = SelectCandidateLeft<
    SelectCandidateLeaf<DiscoveryQuietRow>, CandidateLeaf<DiscoveryOriginB>>

typealias DiscoveryTakeA = SelectCandidateLeft<SelectCandidateLeaf<DiscoveryOriginA>,
    CandidateFork<CandidateLeaf<DiscoveryOriginB>, CandidateLeaf<DiscoveryOriginC>>>
typealias DiscoveryTakeB = SelectCandidateRight<Never,
    SelectCandidateLeft<SelectCandidateLeaf<DiscoveryOriginB>, CandidateLeaf<DiscoveryOriginC>>>
typealias DiscoveryTakeC = SelectCandidateRight<Never,
    SelectCandidateRight<Never, SelectCandidateLeaf<DiscoveryOriginC>>>
typealias DiscoveryCoverA = CoverDiscoverySuccessor<DiscoveryQuietSupport,
    DiscoverySignalSupport, DiscoveryTakeA, DiscoveryFirstAction<TrapExperiment.A>,
    DiscoverySignalBranch, SelectCandidateLeaf<DiscoverySignalRow>>
typealias DiscoveryCoverB = CoverDiscoverySuccessor<DiscoveryQuietSupport,
    DiscoverySignalSupport, DiscoveryTakeB, DiscoveryFirstAction<TrapExperiment.B>,
    DiscoveryQuietBranch, DiscoveryQuietMember>
typealias DiscoveryCoverC = CoverDiscoverySuccessor<DiscoveryQuietSupport,
    DiscoverySignalSupport, DiscoveryTakeC, DiscoveryFirstAction<TrapExperiment.C>,
    DiscoveryQuietBranch, DiscoveryQuietMember>
typealias DiscoveryCoveredNode = CoveredDiscoverySuccessors<DiscoveryParents,
    DiscoveryQuietSupport, DiscoverySignalSupport, Paired<Never, Never>,
    SequentialReading<DiscoveryCoverA, SequentialReading<DiscoveryCoverB, DiscoveryCoverC>>>

// Terminal obligations read the preserved tags in the verifier's supports.
// Both quiet rows, including the unused overapproximation, require no.
// The signal branch requires yes. This is not one common-answer join of both
// branches, and these projections are not readings available to the observer.
typealias DiscoveryTerminalTag<X: Pair> = SecondEvidenceImage<
    X, BeamSpace, SaturationEncoding, AlphaQuestion>
typealias DiscoveryQuietTerminal = CoveredJoin<
    CoveredLeaf<DiscoveryTerminalTag<DiscoveryQuietRow>>,
    CoveredLeaf<DiscoveryTerminalTag<DiscoveryOriginB>>>
typealias DiscoveryQuietTerminalCovered = CheckedCoverage<
    DiscoveryQuietTerminal, DiscoveryQuietSupport>
typealias DiscoverySignalTerminal = CoveredLeaf<DiscoveryTerminalTag<DiscoverySignalRow>>
enum DiscoverySignalTerminalCoversItsSupport: Null {
    typealias Left = DiscoverySignalTerminal.Candidates
    typealias Right = DiscoverySignalSupport
}
typealias DifferentDiscoveryLeafAnswers = ZeroSuccessorBoundaryPairClass<
    Paired<DiscoveryQuietTerminal.Answer, DiscoverySignalTerminal.Answer>, Never>

// The finite constructor proof proposes a table. Admission additionally reads
// all three actual source rows, without trusting the supplied proof grammar.
typealias DiscoveryProposed = AnsweredDiscoveryNode<DiscoveryParents,
    DiscoveryQuietSupport, DiscoverySignalSupport, Paired<Never, Never>, DiscoveryCoveredNode>
typealias DiscoveryAnswered = FirstDiscoveryDecision<DiscoveryOriginA,
    DiscoveryOriginB, DiscoveryOriginC, DiscoveryProposed>
enum DiscoveryDerivedAnswerTable: Null {
    typealias Left = DiscoveryAnswered.Answers
    typealias Right = Paired<Never, Lit1>
}

// Carry the same prepared table through the selected actual transition and
// observation. The final decoder receives only observation plus that table.
typealias DiscoveryActionObserved<X: Pair, P: CandidateRemoval> = FollowedPair<
    StepBeside<Paired<X, P.Right>, DiscoveryAnswered.Answers>,
    StepBeside<FirstEvidenceImage<P.Right, BeamSpace, SaturationEncoding,
        AlphaQuestion>, DiscoveryAnswered.Answers>>
where X.Right: Pair, P.Left == DiscoveryActions<X>, P.Right: Pair,
      P.Right == X.Right.Left,
      P.Right.Left: Structure, P.Address == DiscoveryAnswered.Right.Left
typealias DiscoveryFirstObserved<X: Pair> = DiscoveryActionObserved<X, DiscoveryFirstAction<X>>
where X.Right: Pair, X.Right.Left: Pair, X.Right.Left.Left: Structure
typealias DiscoveryReadA = FollowedPair<DiscoveryFirstObserved<TrapExperiment.A>,
    ReadSignalDiscoveryAnswer<DiscoveryAnswered.Answers>>
typealias DiscoveryReadB = FollowedPair<DiscoveryFirstObserved<TrapExperiment.B>,
    ReadQuietDiscoveryAnswer<DiscoveryAnswered.Answers>>
typealias DiscoveryReadC = FollowedPair<DiscoveryFirstObserved<TrapExperiment.C>,
    ReadQuietDiscoveryAnswer<DiscoveryAnswered.Answers>>
enum DiscoveryObservedAnswersMeetOriginalQuestion: Null {
    typealias Left = Paired<DiscoveryReadA.Right, Paired<DiscoveryReadB.Right, DiscoveryReadC.Right>>
    typealias Right = Paired<DiscoveryOriginA.Right, Paired<DiscoveryOriginB.Right, DiscoveryOriginC.Right>>
}

// Positive attack: a freely declared reading can pretend to finish coverage.
// The endpoint-only constructor accepts it and produces a wrong signal answer.
// This fixture must remain accepted there, so a new trust marker cannot hide
// the distinction between an endpoint declaration and source-derived content.
typealias ForgedDiscoverySignalSupport = CandidateLeaf<
    Paired<TrapExperiment.Signal, Never>>
typealias ForgedDiscoveryChildren = DiscoveryChildren<
    DiscoveryQuietSupport, ForgedDiscoverySignalSupport>
enum ForgedDiscoveryCompletion: PredicateReading {
    typealias Left = Paired<Paired<Never, Never>, Paired<DiscoveryParents, ForgedDiscoveryChildren>>
    typealias Answer = Paired<Paired<Never, Never>, Paired<Never, ForgedDiscoveryChildren>>
    typealias Right = Answer
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Predicate = Paired<Never, Never>
}
typealias ForgedDiscoveryProposal = AnsweredDiscoveryNode<DiscoveryParents,
    DiscoveryQuietSupport, ForgedDiscoverySignalSupport, Paired<Never, Never>,
    ForgedDiscoveryCompletion>
typealias ForgedDiscoveryAnswerDiffers = ZeroSuccessorBoundaryPairClass<
    Paired<ReadSignalDiscoveryAnswer<ForgedDiscoveryProposal.Answers>.Right,
        DiscoveryOriginA.Right>, Never>

// The direct gate also admits a correct table with no coverage story at all.
// It derives correctness from this finite source, not the proposal's author.
typealias DiscoveryBareProposal = Paired<DiscoveryParents,
    Paired<Paired<Never, Never>, Paired<Never, Lit1>>>
enum DiscoveryAdmissionNeedsNoCoverageStory: Null {
    typealias Left = FirstDiscoveryDecision<DiscoveryOriginA, DiscoveryOriginB,
        DiscoveryOriginC, DiscoveryBareProposal>.Right
    typealias Right = DiscoveryAnswered.Right
}

// The construction permits arbitrary answer types, including a constant
// question. No binary-answer distinction is assumed by the decision gate.
typealias GenericFirstDecision<Y: Structure, N: Structure> = FirstDiscoveryDecision<
    Paired<TrapExperiment.A, Y>, Paired<TrapExperiment.B, N>,
    Paired<TrapExperiment.C, N>,
    Paired<CandidateFork<CandidateLeaf<Paired<TrapExperiment.A, Y>>,
        CandidateFork<CandidateLeaf<Paired<TrapExperiment.B, N>>,
            CandidateLeaf<Paired<TrapExperiment.C, N>>>>,
        Paired<Paired<Never, Never>, Paired<N, Y>>>>
enum GenericFirstDecisionRecovers<Y: Structure, N: Structure>: Null {
    typealias Left = GenericFirstDecision<Y, N>.RecoversOriginalAnswers.Left
    typealias Right = AddressTriple<Y, N, N>
}

enum ForgedDiscoveryActionSelection: CandidateRemoval {
    typealias Left = DiscoveryActions<TrapExperiment.B>
    typealias Right = TrapExperiment.Signal
    typealias Remainder = Never
    typealias Address = Paired<Never, Never>
}

#if DISCOVERY_FORGED_ACTION_SELECTION
typealias RejectedForgedDiscoveryAction = DiscoveryActionObserved<
    TrapExperiment.B, ForgedDiscoveryActionSelection>
#endif

#if DISCOVERY_FORGED_COMPLETION
typealias RejectedForgedDiscoveryCompletion = FirstDiscoveryDecision<
    DiscoveryOriginA, DiscoveryOriginB, DiscoveryOriginC, ForgedDiscoveryProposal>
#endif

#if DISCOVERY_DIRECT_CONFLICTING_QUESTION
// The actual quiet observation cannot recover distinct required B/C answers.
typealias ConflictingDiscoveryParents = CandidateFork<CandidateLeaf<DiscoveryOriginA>,
    CandidateFork<CandidateLeaf<OriginBForCQuestion>, CandidateLeaf<OriginCForCQuestion>>>
typealias ConflictingDiscoveryProposal = Paired<ConflictingDiscoveryParents,
    Paired<Paired<Never, Never>, Paired<Never, Lit1>>>
typealias RejectedDirectDiscoveryConflict = FirstDiscoveryDecision<
    DiscoveryOriginA, OriginBForCQuestion, OriginCForCQuestion, ConflictingDiscoveryProposal>
#endif

#if DISCOVERY_DIRECT_WRONG_SOURCE
// A table for one observation pattern cannot be transported by row count.
typealias WrongSignalOrigin = Paired<TrapExperiment.C, Lit1>
typealias WrongSignalParents = CandidateFork<CandidateLeaf<WrongSignalOrigin>,
    CandidateFork<CandidateLeaf<DiscoveryOriginB>, CandidateLeaf<DiscoveryOriginC>>>
typealias WrongSignalProposal = Paired<WrongSignalParents,
    Paired<Paired<Never, Never>, Paired<Never, Lit1>>>
typealias RejectedDirectDiscoverySource = FirstDiscoveryDecision<
    WrongSignalOrigin, DiscoveryOriginB, DiscoveryOriginC, WrongSignalProposal>
#endif

#if DISCOVERY_DECODER_WRONG_OBSERVATION
typealias RejectedDiscoveryObservationDecoder = FollowedPair<
    DiscoveryFirstObserved<TrapExperiment.B>, ReadSignalDiscoveryAnswer<DiscoveryAnswered.Answers>>
#endif

#if DISCOVERY_EXECUTES_OTHER_ACTION
// Even an equal output for C does not permit replacing the certified action.
typealias RejectedDiscoveryExecutedAction = DiscoveryActionObserved<
    TrapExperiment.C, DiscoverySecondAction<TrapExperiment.C>>
#endif

#if DISCOVERY_UNLINKED_TERMINALS
// Both swapped supports have a common answer, but these are not the children
// for which the supplied successor coverage was checked.
typealias RejectedUnlinkedDiscoveryTerminals = AnsweredDiscoveryNode<DiscoveryParents,
    DiscoverySignalSupport, DiscoveryQuietSupport, Paired<Never, Never>, DiscoveryCoveredNode>
#endif

#if DISCOVERY_MIXED_TERMINAL_ANSWERS
// A larger support can invalidate a terminal proof. No preferred answer can
// be extracted when its rows retain different required original answers.
typealias DiscoveryMixedTerminal = CandidateFork<CandidateLeaf<DiscoveryQuietRow>,
    CandidateLeaf<Paired<TrapExperiment.B, Lit1>>>
typealias RejectedMixedDiscoveryTerminal = DiscoveryMixedTerminal.OriginalAnswer
#endif

#if DISCOVERY_UNCOVERED_PARENT
typealias RejectedUncoveredDiscoveryParent = CoveredDiscoverySuccessors<DiscoveryParents,
    DiscoveryQuietSupport, DiscoverySignalSupport, Paired<Never, Never>,
    SequentialReading<DiscoveryCoverA, DiscoveryCoverB>>
#endif

#if DISCOVERY_WRONG_SUCCESSOR
// This extra row is in the right branch and has the right original answer,
// but it is not the actual successor of B under the selected first action.
typealias DiscoveryExtraQuietMember = SelectCandidateRight<
    CandidateLeaf<DiscoveryQuietRow>, SelectCandidateLeaf<DiscoveryOriginB>>
typealias RejectedWrongDiscoverySuccessor = CoverDiscoverySuccessor<DiscoveryQuietSupport,
    DiscoverySignalSupport, DiscoveryTakeB, DiscoveryFirstAction<TrapExperiment.B>,
    DiscoveryQuietBranch, DiscoveryExtraQuietMember>
#endif

#if DISCOVERY_CHANGED_ORIGINAL_TARGET
// The successor and observation are correct; only the original answer differs.
typealias RejectedChangedDiscoveryTarget = CoverDiscoverySuccessor<DiscoveryQuietSupport,
    DiscoverySignalSupport, SelectCandidateLeaf<OriginCForCQuestion>,
    DiscoveryFirstAction<TrapExperiment.C>, DiscoveryQuietBranch, DiscoveryQuietMember>
#endif

#if DISCOVERY_WRONG_OBSERVATION_BRANCH
// The right successor/answer row was put under the wrong observable branch.
typealias DiscoveryMisplacedQuiet = CandidateLeaf<DiscoverySignalRow>
typealias DiscoveryMisplacedBranch = SelectCandidateLeft<
    SelectCandidateLeaf<Paired<ExperimentQuiet, DiscoveryMisplacedQuiet>>,
    CandidateLeaf<Paired<ExperimentSignal, Never>>>
typealias RejectedWrongDiscoveryBranch = CoverDiscoverySuccessor<DiscoveryMisplacedQuiet,
    Never, SelectCandidateLeaf<DiscoveryOriginA>, DiscoveryFirstAction<TrapExperiment.A>,
    DiscoveryMisplacedBranch, SelectCandidateLeaf<DiscoverySignalRow>>
#endif

#if DISCOVERY_ACTION_DEPENDS_ON_ORIGIN
// C has the same successor under both actions. Correct rows alone therefore
// cannot detect this illicit choice by hidden origin; the shared address does.
typealias DiscoveryCoverCWithOtherAction = CoverDiscoverySuccessor<DiscoveryQuietSupport,
    DiscoverySignalSupport, DiscoveryTakeC, DiscoverySecondAction<TrapExperiment.C>,
    DiscoveryQuietBranch, DiscoveryQuietMember>
typealias RejectedOriginDependentDiscoveryAction = SequentialReading<DiscoveryCoverA,
    SequentialReading<DiscoveryCoverB, DiscoveryCoverCWithOtherAction>>
#endif
