import VerificationIsIdentification
import Examples

// All twelve source positions are carried by one actual selected-law question.
enum StarObservationGrid<V: Structure>: Null {
    typealias S = LocalStarStage
    typealias Z = Never
    typealias One = Lit1
    typealias Two = Lit2
    typealias Three = Examples.Succ<Lit2>
    typealias C0 = LocalStarTrace0<S.Center, V>.Reading
    typealias C1 = LocalStarTrace1<S.Center, V>.Reading
    typealias C2 = LocalStarTrace2<S.Center, V>.Reading
    typealias A0 = LocalStarTrace0<S.A, V>.Reading
    typealias A1 = LocalStarTrace1<S.A, V>.Reading
    typealias A2 = LocalStarTrace2<S.A, V>.Reading
    typealias B0 = LocalStarTrace0<S.B, V>.Reading
    typealias B1 = LocalStarTrace1<S.B, V>.Reading
    typealias B2 = LocalStarTrace2<S.B, V>.Reading
    typealias D0 = LocalStarTrace0<S.C, V>.Reading
    typealias D1 = LocalStarTrace1<S.C, V>.Reading
    typealias D2 = LocalStarTrace2<S.C, V>.Reading
    typealias Left = Paired<Paired<C0.Answer, Paired<C1.Answer, C2.Answer>>,
        Paired<Paired<A0.Answer, Paired<A1.Answer, A2.Answer>>,
        Paired<Paired<B0.Answer, Paired<B1.Answer, B2.Answer>>,
            Paired<D0.Answer, Paired<D1.Answer, D2.Answer>>>>>
    typealias AtCenter = Paired<Paired<Z, Paired<One, One>>,
        Paired<Paired<Z, Paired<Two, Two>>, Paired<Z, Paired<Three, Three>>>>
    typealias AtA = Paired<Paired<One, Paired<Z, Two>>,
        Paired<Paired<One, Paired<One, One>>, Paired<One, Paired<One, Z>>>>
    typealias AtB = Paired<Paired<Two, Paired<Two, Z>>,
        Paired<Paired<Two, Paired<Z, Three>>, Paired<Two, Paired<Two, Two>>>>
    typealias AtC = Paired<Paired<Three, Paired<Three, Three>>,
        Paired<Paired<Three, Paired<Three, Z>>, Paired<Three, Paired<Z, One>>>>
    typealias Right = Paired<AtCenter, Paired<AtA, Paired<AtB, AtC>>>

    enum OneQuestion: Null {
        typealias All = Paired<C0.Predicate, Paired<C0.Predicate, C0.Predicate>>
        typealias Left = Paired<Paired<C0.Predicate, Paired<C1.Predicate, C2.Predicate>>,
            Paired<Paired<A0.Predicate, Paired<A1.Predicate, A2.Predicate>>,
            Paired<Paired<B0.Predicate, Paired<B1.Predicate, B2.Predicate>>,
                Paired<D0.Predicate, Paired<D1.Predicate, D2.Predicate>>>>>
        typealias Right = Paired<All, Paired<All, Paired<All, All>>>
    }
}

// Current stage and one continuation fail to distinguish these two phases.
// Their next continuation positively separates 1 and 0 in the same question.
enum StarShortTraceCollision<V: Structure>: Null {
    typealias Grid = StarObservationGrid<V>
    typealias X = Grid.A1
    typealias Y = Grid.A2
    typealias Left = Paired<X.Current.Answer, X.Next.Answer>
    typealias Right = Paired<Y.Current.Answer, Y.Next.Answer>
    typealias Separation = SuccessorZeroBoundary<X.Last, Y.Last, Never>
}

enum StarObservationIgnoresPayload<A: Structure, B: Structure>: Null {
    typealias Left = StarObservationGrid<A>.Left
    typealias Right = StarObservationGrid<B>.Left
}

enum StarAcquiredObservationGrid<V: Structure>: Null {
    typealias S = LocalStarStage
    typealias C0 = AcquiredTwoStepStages<LocalStarTrace0<S.Center, V>.First, LocalStarTrace0<S.Center, V>.Second>
    typealias C1 = AcquiredTwoStepStages<LocalStarTrace1<S.Center, V>.First, LocalStarTrace1<S.Center, V>.Second>
    typealias C2 = AcquiredTwoStepStages<LocalStarTrace2<S.Center, V>.First, LocalStarTrace2<S.Center, V>.Second>
    typealias A0 = AcquiredTwoStepStages<LocalStarTrace0<S.A, V>.First, LocalStarTrace0<S.A, V>.Second>
    typealias A1 = AcquiredTwoStepStages<LocalStarTrace1<S.A, V>.First, LocalStarTrace1<S.A, V>.Second>
    typealias A2 = AcquiredTwoStepStages<LocalStarTrace2<S.A, V>.First, LocalStarTrace2<S.A, V>.Second>
    typealias B0 = AcquiredTwoStepStages<LocalStarTrace0<S.B, V>.First, LocalStarTrace0<S.B, V>.Second>
    typealias B1 = AcquiredTwoStepStages<LocalStarTrace1<S.B, V>.First, LocalStarTrace1<S.B, V>.Second>
    typealias B2 = AcquiredTwoStepStages<LocalStarTrace2<S.B, V>.First, LocalStarTrace2<S.B, V>.Second>
    typealias D0 = AcquiredTwoStepStages<LocalStarTrace0<S.C, V>.First, LocalStarTrace0<S.C, V>.Second>
    typealias D1 = AcquiredTwoStepStages<LocalStarTrace1<S.C, V>.First, LocalStarTrace1<S.C, V>.Second>
    typealias D2 = AcquiredTwoStepStages<LocalStarTrace2<S.C, V>.First, LocalStarTrace2<S.C, V>.Second>
    typealias Left = Paired<Paired<C0.Answer, Paired<C1.Answer, C2.Answer>>,
        Paired<Paired<A0.Answer, Paired<A1.Answer, A2.Answer>>,
        Paired<Paired<B0.Answer, Paired<B1.Answer, B2.Answer>>,
            Paired<D0.Answer, Paired<D1.Answer, D2.Answer>>>>>
    typealias Right = StarObservationGrid<V>.Left

    enum OneResidentProgram: Null {
        typealias All = Paired<C0.Tape, Paired<C0.Tape, C0.Tape>>
        typealias Left = Paired<Paired<C0.Tape, Paired<C1.Tape, C2.Tape>>,
            Paired<Paired<A0.Tape, Paired<A1.Tape, A2.Tape>>,
            Paired<Paired<B0.Tape, Paired<B1.Tape, B2.Tape>>,
                Paired<D0.Tape, Paired<D1.Tape, D2.Tape>>>>>
        typealias Right = Paired<All, Paired<All, Paired<All, All>>>
    }
}

enum StarStageDecoderReceivesNoPayload<A: Structure, B: Structure>: Null {
    typealias Left = StarAcquiredObservationGrid<A>.C0.Right
    typealias Right = StarAcquiredObservationGrid<B>.C0.Right
}

// Both applications deliberately have the same label and current answer.
// Their occurrences at the two fixed catalogue addresses remain different.
enum AliasedApplicationRoot: Pair {
    typealias Left = Paired<Never, Never>
    typealias First = FirstEvidenceImage<Left, BeamSpace, SaturationEncoding, AcquisitionChoice>
    typealias Second = SecondEvidenceImage<Left, BeamSpace, SaturationEncoding, AcquisitionChoice>
    typealias Catalogue = CandidateFork<CandidateLeaf<First>, CandidateLeaf<Second>>
    typealias Right = Paired<Paired<First.Predicate, Second.Predicate>, Catalogue>
    typealias Select0 = SelectCandidateLeft<SelectCandidateLeaf<First>, CandidateLeaf<Second>>
    typealias Select1 = SelectCandidateRight<CandidateLeaf<First>, SelectCandidateLeaf<Second>>
    typealias Program = Paired<Select0.Address, Select1.Address>
    typealias Input = PostPairReading<
        FirstEvidenceImage<Left, BeamSpace, SaturationEncoding, FirstProjection>, Program>
    typealias Chosen = SelectedLocalApplication<AliasedApplicationRoot,
        Input, LocalPolicyAtZero<Program>, Select0>
    enum SameLabelsAndAnswers: Null {
        typealias Left = Paired<First.Predicate, First.Answer>
        typealias Right = Paired<Second.Predicate, Second.Answer>
    }
    enum ActualChosenApplication: Null {
        typealias Left = Chosen.Primitive
        typealias Right = First
    }
}

#if LOCAL_PHASE_STAR_FORGES_SELECTED_OCCURRENCE
// The forged path has the correct address, label, result and working source,
// but starts from a different catalogue whose first occurrence was replaced.
typealias RejectedStarForgedOccurrence = SelectedLocalApplication<AliasedApplicationRoot,
    AliasedApplicationRoot.Input, LocalPolicyAtZero<AliasedApplicationRoot.Program>,
    SelectCandidateLeft<SelectCandidateLeaf<AliasedApplicationRoot.Second>,
        CandidateLeaf<AliasedApplicationRoot.Second>>>
#endif

// This permutation is harmless for the displayed all-A answer. Its success
// does not establish order-independence for the other admitted preparations.
typealias StarRepeatedStagesAllowReordering = JoinedVerdict<
    StarAcquiredObservationGrid<Never>.A1.Left,
    ThreeStageAnswers<LocalStarTrace1<LocalStarStage.A, Never>.First.Predicate,
        LocalStarTrace1<LocalStarStage.A, Never>.Second.Predicate,
        Paired<StarAcquiredObservationGrid<Never>.A1.Observation.Answer.Right.Right,
            Paired<StarAcquiredObservationGrid<Never>.A1.Observation.Answer.Right.Left,
                StarAcquiredObservationGrid<Never>.A1.Observation.Answer.Left>>>>

#if LOCAL_PHASE_STAR_REORDERS_ACQUIRED_FACTS
enum RejectedStarReorderedFacts: Null {
    typealias F = StarAcquiredObservationGrid<Never>.C0
    typealias Plan = LocalStarTrace0<LocalStarStage.Center, Never>
    typealias M = F.Observation.Answer
    typealias Swapped = Paired<M.Right.Right, Paired<M.Right.Left, M.Left>>
    typealias Wrong = ThreeStageAnswers<Plan.First.Predicate, Plan.Second.Predicate, Swapped>
    enum SameQuestion: ComparedReadings {
        typealias Left = F.Left
        typealias Right = Wrong
    }
    typealias Left = Wrong.Answer
    typealias Right = F.Answer
}
#endif

#if LOCAL_PHASE_STAR_SHORT_TRACE_SUFFICES
enum RejectedStarShortTrace: Null {
    typealias Collision = StarShortTraceCollision<Never>
    typealias Left = Collision.X.Last.Answer
    typealias Right = Collision.Y.Last.Answer
}
#endif

#if LOCAL_PHASE_STAR_USES_UNSELECTED_PRIMITIVE
typealias RejectedStarUnselectedPrimitive = SelectedLocalApplication<
    LocalStarAddressRoot,
    LocalStarInput<LocalStarStage.Center, LocalStarPhase.Zero, Never, LocalStarInverseAddressProgram>,
    LocalPolicyAtZero<LocalStarInverseAddressProgram>, LocalStarAddressRoot.Select0>
#endif

#if LOCAL_PHASE_STAR_ALIASES_FIRST_TWO_OPERATIONS
// The next constructor now binds the actual leaf address, regardless of its
// operation label. Selecting the second leaf cannot satisfy the first address.
typealias RejectedStarFirstSecondAlias = SelectedLocalApplication<
    LocalStarAddressRoot,
    LocalStarInput<LocalStarStage.Center, LocalStarPhase.Zero, Never, LocalStarAddressProgram>,
    LocalPolicyAtZero<LocalStarAddressProgram>, LocalStarAddressRoot.Select1>
#endif

#if LOCAL_PHASE_STAR_CONFUSES_STAGE_PHASE_QUESTION
// Both displayed answers happen to be zero, but their source paths differ.
enum RejectedStarDifferentQuestion: ComparedReadings {
    typealias W = LocalPhaseWorld<LocalStarStage.Center, LocalStarPhase.Zero, Never>
    typealias Left = LocalStageImage<W>
    typealias Right = LocalStarPhaseImage<W>
}
#endif

#if LOCAL_PHASE_STAR_RECORDS_ANOTHER_QUESTION
typealias RejectedStarWrongRecording = ResidentBoundaryCommand<
    RetainingRecordedReading<LocalStarPhaseImage<
        LocalPhaseWorld<LocalStarStage.Center, LocalStarPhase.Zero, Never>>>,
    Paired<RetainingRecordedReading<LocalStageImage<
        LocalPhaseWorld<LocalStarStage.Center, LocalStarPhase.Zero, Never>>>.Predicate, Never>, Never>
#endif
