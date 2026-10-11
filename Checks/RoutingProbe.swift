import VerificationIsIdentification
import Examples

// This checks all coordinate contents allowed by the constructor, not just
// twenty-four concrete instances. Binary permutation scope is stated in VC74.
enum RoutingReconstruction<A: Pair, C: Pair, B: Pair, D: Pair>: Null
where A.Left: Structure, A.Right: Structure, C.Left: Structure, C.Right: Structure,
      B.Left: Structure, B.Right: Structure, D.Left: Structure, D.Right: Structure {
    typealias I = BoundaryWorking<A, C, B, D>
    typealias Left = AcquiredRouting<I>.Answer
    typealias Right = BoundaryWorking<Paired<A.Left, A.Right>, Paired<C.Left, C.Right>, Paired<B.Left, B.Right>, Paired<D.Left, D.Right>>
}

enum RoutingInitialProbePair: Null {
    typealias Left = RoutingProbeImages<IdentityRouting>.Answer
    typealias Right = Paired<BoundaryWorking<Never, Never, Lit1, Lit1>, BoundaryWorking<Never, Lit1, Never, Lit1>>
}
enum RoutingDecoderHasOnlyImages: Null {
    typealias Left = AcquiredRouting<IdentityRouting>.Right.Left
    typealias Right = FactOf<RoutingProbeImages<IdentityRouting>>
}

typealias RoutingExchange = ExchangeFirstImage<IdentityRouting>.Answer
typealias RoutingSwap = SwapBoundaryReading<IdentityRouting>.Answer
typealias RoutingOneProbeCoincides = JoinedVerdict<FirstRoutingProbe<IdentityRouting>, FirstRoutingProbe<RoutingExchange>>
// The omitted second image positively separates the same two permutations.
typealias RoutingSecondBitZero = FirstEvidenceImage<SecondRoutingProbe<IdentityRouting>.Answer.Left, BeamSpace, SaturationEncoding, SecondRoutingProbeQuestion>
typealias RoutingSecondBitOne = FirstEvidenceImage<SecondRoutingProbe<RoutingExchange>.Answer.Left, BeamSpace, SaturationEncoding, SecondRoutingProbeQuestion>
typealias RoutingOneProbeObstruction = ZeroSuccessorBoundary<RoutingSecondBitZero, RoutingSecondBitOne, Never>

enum RoutingSameBehaviorDifferentWord: Null {
    typealias Left = RoutingCoordinates<ExchangeFirstImage<RoutingExchange>.Answer>.Answer
    typealias Right = RoutingCoordinates<IdentityRouting>.Answer
}

// Both images still decode to a permutation when the mechanism changes
// between probes. Payload validity therefore cannot certify stationarity.
typealias RoutingMixedImages = Paired<FirstRoutingProbe<IdentityRouting>.Answer, SecondRoutingProbe<RoutingExchange>.Answer>
enum RoutingMixedRecordLooksValid: Null {
    typealias Left = RoutingFromProbeImages<RoutingMixedImages>.Answer
    typealias Right = RoutingCoordinates<RoutingExchange>.Answer
}

// The derivation canonicalizes coordinates; it does not recover nominal
// identity of the supplied mechanism or the route taken to build it.
enum NominalIdentityRouting: Pair {
    typealias Left = IdentityRouting.Left
    typealias Right = IdentityRouting.Right
}
enum RoutingDifferentSourceSameFact: Null {
    typealias Left = FactOf<RoutingProbeImages<NominalIdentityRouting>>
    typealias Right = FactOf<RoutingProbeImages<IdentityRouting>>
}

#if ROUTING_ONE_PROBE_RECOVERS_ALL
enum RejectedRoutingSingle: Null {
    typealias Left = RoutingCoordinates<IdentityRouting>.Answer
    typealias Right = RoutingCoordinates<RoutingExchange>.Answer
}
#endif
#if ROUTING_MIXED_ACTUAL_MECHANISMS
typealias RejectedRoutingMixed = JointEvidence<FirstRoutingProbe<IdentityRouting>, SecondRoutingProbe<RoutingExchange>>
#endif
#if ROUTING_WRONG_ACQUIRED_SOURCE
typealias RejectedRoutingSource = AnswerOnRefinement<RoutingFromProbes<IdentityRouting>, AcquireAnswer<RoutingProbeImages<RoutingExchange>>>
#endif
#if ROUTING_SWAPPED_PROBE_ORDER
enum RejectedRoutingOrder: Null {
    typealias I = RoutingProbeImages<IdentityRouting>.Answer
    typealias Left = RoutingFromProbeImages<Paired<I.Right, I.Left>>.Answer
    typealias Right = IdentityRouting
}
#endif
#if ROUTING_COORDINATES_ARE_MECHANISM
enum RejectedRoutingIdentity: Null {
    typealias Left = AcquiredRouting<NominalIdentityRouting>.Answer
    typealias Right = NominalIdentityRouting
}
#endif
#if ROUTING_BEHAVIOR_RECOVERS_WORD
enum RejectedRoutingWord: Null {
    typealias Left = OperationSequence<FirstFieldsOperation, FirstFieldsOperation>
    typealias Right = IdentityOperation
}
#endif
#if ROUTING_ONE_IMAGE_IS_TWO
typealias RejectedRoutingMissing = AnswerOnRefinement<RoutingFromProbes<IdentityRouting>, AcquireAnswer<FirstRoutingProbe<IdentityRouting>>>
#endif

// A resident two-position schedule makes the change internal to one whole.
// Both readings have exactly this same whole source, yet use different laws.
typealias RoutingResidentSchedule = Paired<IdentityRouting, RoutingExchange>
typealias RoutingScheduleFirst = DecodeRefinedEvidence<FirstEvidenceImage<RoutingResidentSchedule, BeamSpace, SaturationEncoding, RoutingQuestion>, FirstRoutingProbe<IdentityRouting>>
typealias RoutingScheduleSecond = DecodeRefinedEvidence<SecondEvidenceImage<RoutingResidentSchedule, BeamSpace, SaturationEncoding, RoutingQuestion>, SecondRoutingProbe<RoutingExchange>>
typealias RoutingScheduledImages = JointEvidence<RoutingScheduleFirst, RoutingScheduleSecond>
enum RoutingOneWholeCanHideLawChange: Null {
    typealias Left = FactOf<RoutingScheduledImages>
    typealias Right = FactOf<RoutingProbeImages<RoutingExchange>>
}

#if ROUTING_ONE_WHOLE_PROVES_STATIONARITY
enum RejectedRoutingStationarity: ReadingFactors {
    typealias Left = DecodeRefinedEvidence<FirstEvidenceImage<RoutingResidentSchedule, BeamSpace, SaturationEncoding, RoutingQuestion>, RoutingCoordinates<IdentityRouting>>
    typealias Observation = RoutingScheduledImages
    typealias Right = RoutingFromProbeImages<Observation.Answer>
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Predicate = RoutingQuestion
    typealias Answer = Left.Answer
}
#endif
