import VerificationIsIdentification
import Examples

enum ClosingStageExchange: Null {
    typealias S = ReversibleExperiment
    typealias X = LocalStageClosing<S.A>
    typealias Y = LocalStageClosing<S.Signal>
    typealias Z = LocalStageClosing<S.B>
    typealias Left = Paired<Paired<X.Answer, Paired<Y.Answer, Z.Answer>>,
        Paired<LocalStageClosing<X.Answer>.Answer,
            Paired<LocalStageClosing<Y.Answer>.Answer, LocalStageClosing<Z.Answer>.Answer>>>
    typealias Right = Paired<Paired<S.B, Paired<S.Signal, S.A>>,
        Paired<S.A, Paired<S.Signal, S.B>>>
}

// Complete coverage of the canonical two-phase carrier under both candidates.
// Phase equality is not smuggled into their common stage calibration.
enum ClosingCandidatesAreInvolutions<V: Structure>: Null {
    typealias S = ReversibleExperiment
    typealias OX0 = LocalPhaseMacroClosing<S.A, LocalPhaseZero, V>
    typealias OX1 = LocalPhaseMacroClosing<S.A, LocalPhaseOne, V>
    typealias OY0 = LocalPhaseMacroClosing<S.Signal, LocalPhaseZero, V>
    typealias OY1 = LocalPhaseMacroClosing<S.Signal, LocalPhaseOne, V>
    typealias OZ0 = LocalPhaseMacroClosing<S.B, LocalPhaseZero, V>
    typealias OZ1 = LocalPhaseMacroClosing<S.B, LocalPhaseOne, V>
    typealias NX0 = LocalPhaseUnflippedClosing<S.A, LocalPhaseZero, V>
    typealias NX1 = LocalPhaseUnflippedClosing<S.A, LocalPhaseOne, V>
    typealias NY0 = LocalPhaseUnflippedClosing<S.Signal, LocalPhaseZero, V>
    typealias NY1 = LocalPhaseUnflippedClosing<S.Signal, LocalPhaseOne, V>
    typealias NZ0 = LocalPhaseUnflippedClosing<S.B, LocalPhaseZero, V>
    typealias NZ1 = LocalPhaseUnflippedClosing<S.B, LocalPhaseOne, V>
    typealias All = Paired<OX0.Left, Paired<OX1.Left, Paired<OY0.Left,
        Paired<OY1.Left, Paired<OZ0.Left, OZ1.Left>>>>>
    typealias Left = Paired<
        Paired<LocalPhaseMacroClosing<OX0.Answer.Left, OX0.Answer.Right.Left, V>.Answer,
        Paired<LocalPhaseMacroClosing<OX1.Answer.Left, OX1.Answer.Right.Left, V>.Answer,
        Paired<LocalPhaseMacroClosing<OY0.Answer.Left, OY0.Answer.Right.Left, V>.Answer,
        Paired<LocalPhaseMacroClosing<OY1.Answer.Left, OY1.Answer.Right.Left, V>.Answer,
        Paired<LocalPhaseMacroClosing<OZ0.Answer.Left, OZ0.Answer.Right.Left, V>.Answer,
            LocalPhaseMacroClosing<OZ1.Answer.Left, OZ1.Answer.Right.Left, V>.Answer>>>>>,
        Paired<LocalPhaseUnflippedClosing<NX0.Answer.Left, NX0.Answer.Right.Left, V>.Answer,
        Paired<LocalPhaseUnflippedClosing<NX1.Answer.Left, NX1.Answer.Right.Left, V>.Answer,
        Paired<LocalPhaseUnflippedClosing<NY0.Answer.Left, NY0.Answer.Right.Left, V>.Answer,
        Paired<LocalPhaseUnflippedClosing<NY1.Answer.Left, NY1.Answer.Right.Left, V>.Answer,
        Paired<LocalPhaseUnflippedClosing<NZ0.Answer.Left, NZ0.Answer.Right.Left, V>.Answer,
            LocalPhaseUnflippedClosing<NZ1.Answer.Left, NZ1.Answer.Right.Left, V>.Answer>>>>>>
    typealias Right = Paired<All, All>
}

enum ClosingFeedbackSeparates<V: Structure>: Null {
    typealias W = LocalClosingFeedbackWitness<V>
    typealias Left = Paired<
        Paired<LocalStageImage<W.Old.Answer>.Answer, LocalStageImage<W.New.Answer>.Answer>,
        Paired<LocalStageImage<W.OldNext.Answer>.Answer, LocalStageImage<W.NewNext.Answer>.Answer>>
    typealias Right = Paired<Paired<ExperimentQuiet, ExperimentQuiet>,
        Paired<ExperimentSignal, ExperimentQuiet>>
    typealias SameInitial = LocalClosingImagesAgree<ReversibleExperiment.A, LocalPhaseZero, V>
    typealias OldPhase = LocalStarPhaseImage<W.Old.Answer>
    typealias NewPhase = LocalStarPhaseImage<W.New.Answer>
    typealias PhaseBoundary = SuccessorZeroBoundary<OldPhase, NewPhase, Never>

    enum OriginalPayloadStillAgrees: Null {
        typealias Left = LocalPhaseTarget<W.OldPath.Answer>.Answer
        typealias Right = LocalPhaseTarget<W.NewPath.Answer>.Answer
    }
}

#if LOCAL_PHASE_CLOSING_SUBSTITUTES_COMPLETE_CONTACT
enum RejectedClosingFullReplacement: Null {
    typealias W = LocalClosingFeedbackWitness<Never>
    typealias Left = W.Old.Answer
    typealias Right = W.New.Answer
}
#endif

#if LOCAL_PHASE_CLOSING_SUBSTITUTES_UNDER_FEEDBACK
enum RejectedClosingFeedbackReplacement: Null {
    typealias W = ClosingFeedbackSeparates<Never>
    typealias Left = LocalStageImage<W.W.OldNext.Answer>.Answer
    typealias Right = LocalStageImage<W.W.NewNext.Answer>.Answer
}
#endif
