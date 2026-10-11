import VerificationIsIdentification
import Examples

typealias TransportStep = RoutingModuleExchange<IdentityRouting, Never, Lit1>
typealias TransportOldEvidence = AnswerFromAcquiredObservation<ResidentRoutingFactors<IdentityRouting, Never, Lit1>>
typealias TransportEndpoint = QuestionOnObservation<TransportStep.Right, RoutingCoordinates<IdentityRouting>>
typealias TransportLaw = FutureOnEvidence<TransportStep, TransportEndpoint, TransportOldEvidence>

enum TransportLawFromOldEvidence<H: Structure, J: Structure>: Null {
    typealias P = RoutingModuleExchange<IdentityRouting, H, J>
    typealias F = QuestionOnObservation<P.Right, RoutingCoordinates<IdentityRouting>>
    typealias G = AnswerFromAcquiredObservation<ResidentRoutingFactors<IdentityRouting, H, J>>
    typealias Left = FutureOnEvidence<P, F, G>.Answer
    typealias Right = IdentityRouting
}
enum TransportDecoderOmitsModuleState<H: Structure, J: Structure>: Null {
    typealias P = RoutingModuleExchange<IdentityRouting, H, J>
    typealias F = QuestionOnObservation<P.Right, RoutingCoordinates<IdentityRouting>>
    typealias G = AnswerFromAcquiredObservation<ResidentRoutingFactors<IdentityRouting, H, J>>
    typealias Left = FutureOnEvidence<P, F, G>.Right
    typealias Right = TransportLaw.Right
}

typealias TransportActualStateChanges = ZeroSuccessorBoundary<SecondEvidenceImage<TransportStep.SourceStep.Left.Left, BeamSpace, SaturationEncoding, SuppliedInputQuestion>, SecondEvidenceImage<TransportStep.SourceStep.Answer.Left, BeamSpace, SaturationEncoding, SuppliedInputQuestion>, Never>
enum TransportOldStateIsInReserve: Null {
    typealias Left = TransportStep.SourceStep.Answer.Right
    typealias Right = TransportStep.SourceStep.Left.Left.Right
}

enum TransportTwoStepsReuseOneEvidence<H: Structure, J: Structure>: Null {
    typealias P = RoutingModuleExchange<IdentityRouting, H, J>
    typealias Q = RoutingModuleExchange<IdentityRouting, J, H>
    typealias Path = JoinedTransition<P, Q>
    typealias F = QuestionOnObservation<Path.Right, RoutingCoordinates<IdentityRouting>>
    typealias G = AnswerFromAcquiredObservation<ResidentRoutingFactors<IdentityRouting, H, J>>
    typealias Left = FutureOnEvidence<Path, F, G>.Answer
    typealias Right = IdentityRouting
}

enum TransportApplicationAfterChange<A: Structure, C: Structure, B: Structure, D: Structure, H: Structure, J: Structure>: Null {
    typealias X = BoundaryWorking<A, C, B, D>
    typealias P = TransitionBesideInput<RoutingModuleExchange<IdentityRouting, H, J>, X>
    typealias Q = RoutingApplication<IdentityRouting, X, Route00<X>, Route01<X>, Route10<X>, Route11<X>>
    typealias F = QuestionOnObservation<P.Right, Q>
    typealias G = EvidenceBesideInput<AnswerFromAcquiredObservation<ResidentRoutingFactors<IdentityRouting, H, J>>, X>
    typealias Left = FutureOnEvidence<P, F, G>.Answer
    typealias Right = X
}

// A different internal exchange replaces the routing itself from a resident
// reserve. The old routing is retained. Closure alone does not keep its law.
enum TransportFirstSignatureBitQuestion: Close {}
typealias TransportCrossRoute = CrossBoundaryImage<IdentityRouting>.Answer
typealias TransportReplacement = ExchangeRoutingWithReserve<IdentityRouting, Never, TransportCrossRoute>
typealias TransportReplacementOther = ExchangeRoutingWithReserve<IdentityRouting, Never, IdentityRouting>
enum TransportOldFactsCannotSeeReserve: Null {
    typealias Left = FactOf<ResidentRoutingFactors<IdentityRouting, Never, TransportCrossRoute>.Observation>
    typealias Right = FactOf<ResidentRoutingFactors<IdentityRouting, Never, IdentityRouting>.Observation>
}
typealias TransportReplacementSeparates = ZeroSuccessorBoundary<FirstEvidenceImage<TransportReplacementOther.Answer.Left.Left.Left.Left, BeamSpace, SaturationEncoding, TransportFirstSignatureBitQuestion>, FirstEvidenceImage<TransportReplacement.Answer.Left.Left.Left.Left, BeamSpace, SaturationEncoding, TransportFirstSignatureBitQuestion>, Never>

#if LAWTRANSPORT_ROUTING_FREEZES_MODULE
enum RejectedTransportModule: Null {
    typealias Left = TransportStep.SourceStep.Left.Left
    typealias Right = TransportStep.SourceStep.Answer.Left
}
#endif
#if LAWTRANSPORT_SKIPS_ACTUAL_TRANSITION
typealias RejectedTransportSkip = AnswerOnRefinement<ResidentRoutingFactors<IdentityRouting, Lit1, Never>, TransportOldEvidence>
#endif
#if LAWTRANSPORT_WRONG_ENDPOINT
typealias RejectedTransportEndpoint = FutureOnEvidence<TransportStep, QuestionOnObservation<TransportStep.Left, RoutingCoordinates<IdentityRouting>>, TransportOldEvidence>
#endif
#if LAWTRANSPORT_WRONG_INITIAL_EVIDENCE
typealias RejectedTransportEvidence = FutureOnEvidence<TransportStep, TransportEndpoint, AnswerFromAcquiredObservation<ResidentRoutingFactors<IdentityRouting, Lit1, Never>>>
#endif
#if LAWTRANSPORT_WRONG_PATH_SEAM
typealias RejectedTransportSeam = JoinedTransition<TransportStep, TransportStep>
#endif
#if LAWTRANSPORT_ERASES_OPERATION_WORD
enum RejectedTransportWord: Null {
    typealias Left = TransportLaw.Predicate
    typealias Right = RoutingQuestion
}
#endif
#if LAWTRANSPORT_REPLACEMENT_PRESERVES_LAW
enum RejectedTransportReplacement: Null {
    typealias Left = RoutingCoordinates<TransportReplacement.Left.Left.Left>.Answer
    typealias Right = RoutingCoordinates<TransportReplacement.Answer.Left.Left>.Answer
}
#endif
#if LAWTRANSPORT_NEW_INPUT_MISSING
typealias TransportData = BoundaryWorking<Never, Lit1, Never, Lit1>
typealias TransportWithData = TransitionBesideInput<TransportStep, TransportData>
typealias TransportOutput = RoutingApplication<IdentityRouting, TransportData, Route00<TransportData>, Route01<TransportData>, Route10<TransportData>, Route11<TransportData>>
typealias RejectedTransportInput = FutureOnEvidence<TransportWithData, QuestionOnObservation<TransportWithData.Right, TransportOutput>, TransportOldEvidence>
#endif

enum TransportReplacementTwiceRecoversWhole<I: Structure, H: Structure, J: Structure>: Null {
    typealias Left = ExchangeRoutingWithReserve<J, H, I>.Answer
    typealias Right = ExchangeRoutingWithReserve<I, H, J>.Left
}
enum TransportExchangeApplicationAfterChange<A: Structure, C: Structure, B: Structure, D: Structure, H: Structure, J: Structure>: Null {
    typealias I = ExchangeFirstImage<IdentityRouting>.Answer
    typealias X = BoundaryWorking<A, C, B, D>
    typealias P = TransitionBesideInput<RoutingModuleExchange<I, H, J>, X>
    typealias Q = RoutingApplication<I, X, Route01<X>, Route00<X>, Route10<X>, Route11<X>>
    typealias F = QuestionOnObservation<P.Right, Q>
    typealias G = EvidenceBesideInput<AnswerFromAcquiredObservation<ResidentRoutingFactors<I, H, J>>, X>
    typealias Left = FutureOnEvidence<P, F, G>.Answer
    typealias Right = BoundaryWorking<C, A, B, D>
}

enum TransportLawRecordSurvivesReplacement<I: Structure, H: Structure, J: Structure, R: Structure>: Null {
    typealias Step = StepBeside<ExchangeRoutingWithReserve<I, H, J>, R>
    typealias Left = Step.Right.Right
    typealias Right = Step.Left.Right
}
