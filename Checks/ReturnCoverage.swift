import VerificationIsIdentification
import Examples

#if !LOCAL_PHASE_RETURN_COVERAGE_IGNORES_REPEAT && !LOCAL_PHASE_RETURN_COVERAGE_MERGES_SOURCES && !LOCAL_PHASE_RETURN_COVERAGE_IDENTIFIES_GENERATOR && !LOCAL_PHASE_RETURN_COVERAGE_USES_CURRENT_TARGET
enum ReturnCoverageActualEvidence: Null {
    typealias C = ReturnCoverageCalibration
    typealias Left = AddressTriple<C.ObservedTargets.Left, C.AcquiredTargetRelations.Left,
        Paired<C.SameEchoBitsDifferentEvidence.Left, C.Decisions.Left>>
    typealias Right = AddressTriple<C.ObservedTargets.Right, C.AcquiredTargetRelations.Right,
        Paired<C.SameEchoBitsDifferentEvidence.Right, C.Decisions.Right>>
}

enum ReturnCoverageHasActualAmbiguity: Null {
    typealias C = ReturnCoverageCalibration
    typealias O = EchoOrbitCalibration
    typealias Left = AddressTriple<C.RepetitionStillHasTwoSources.Left,
        Paired<O.Q22.Read.Answer, O.Q23.Read.Answer>,
        Paired<C.RepeatDecision22.Read.Answer, C.RepeatDecision23.Read.Answer>>
    typealias Right = AddressTriple<C.RepetitionStillHasTwoSources.Right,
        Paired<Lit1, Never>, Paired<EchoUndetermined, EchoUndetermined>>
}

enum ReturnCoverageAllowsChangingLossyGenerators: Null {
    typealias C = ChangingReturnCoverage
    typealias Left = Paired<C.SameAvailablePositiveRecord.Left, C.ActualTargetsAndAnswer.Left>
    typealias Right = Paired<C.SameAvailablePositiveRecord.Right, C.ActualTargetsAndAnswer.Right>
}

enum ReturnCoverageRetainsPrivateTargetValues: Null {
    typealias C = ChangingReturnCoverage
    typealias Left = AddressTriple<C.Rounds.F0.Answer.Right, C.Rounds.F1.Answer.Right,
        C.Rounds.F2.Answer.Right>
    typealias Right = AddressTriple<RoutingAddress00, RoutingAddress10, RoutingAddress01>
}

enum ReturnCoverageKeepsLaboratory<K: Structure>: Null {
    typealias Path = StepBeside<ChangingReturnCoverage.Decision, K>
    typealias Left = Path.Right.Right
    typealias Right = K
}
#endif

#if LOCAL_PHASE_RETURN_COVERAGE_IGNORES_REPEAT
enum RejectedReturnCoverageIgnoresRepeat: Null {
    typealias Left = ReturnCoverageCalibration.RepeatDecision23.Read.Answer
    typealias Right = EchoEqual
}
#endif

#if LOCAL_PHASE_RETURN_COVERAGE_MERGES_SOURCES
enum RejectedReturnCoverageMergesSources: Null {
    typealias Left = EchoOrbitCalibration.Q22.Read.Answer
    typealias Right = EchoOrbitCalibration.Q23.Read.Answer
}
#endif

// The same positive transmitted record permits distinct first generator
// actions at input0. That record does not identify the generator law.
#if LOCAL_PHASE_RETURN_COVERAGE_IDENTIFIES_GENERATOR
enum RejectedReturnCoverageIdentifiesGenerator: Null {
    typealias Left = EchoOrbitCalibration.R33_0.NextValue.Answer
    typealias Right = ChangingReturnCoverage.Move0.Answer
}
#endif

// A retained earlier target is not the final current target.
#if LOCAL_PHASE_RETURN_COVERAGE_USES_CURRENT_TARGET
enum RejectedReturnCoverageUsesCurrentTarget: Null {
    typealias C = ReturnCoverageCalibration
    typealias Left = C.Full.Samples.T0.Answer
    typealias Right = C.FullRounds.Right.Left.Left.Left.Right.Left
}
#endif
