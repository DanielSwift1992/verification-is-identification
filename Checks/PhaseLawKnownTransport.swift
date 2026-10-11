import VerificationIsIdentification
import Examples

enum PhaseFactSurvivesAtNewAddress<A: Structure, B: Structure,
    C: Structure, D: Structure>: Null {
    typealias F = KnownPhaseLawTransport<A, B, C, D>
    typealias Left = Paired<F.Left.Answer, F.Right.Answer>
    typealias Right = Paired<A, A>
}

enum PhaseTransportKeepsFactQuestion<A: Structure, B: Structure,
    C: Structure, D: Structure>: Null {
    typealias F = KnownPhaseLawTransport<A, B, C, D>
    typealias Left = F.Observation.Answer.Left.Predicate
    typealias Right = OperationSequence<FirstProjection, FirstProjection>
}

// Different physical input addresses can query the same reference input.
// These two even initial laws share point 0. After W, current point 2 is
// that same old point 0, so its additional truthful record does not split them.
enum PhaseTransportRepeatedReference: Close {
    typealias I = KnownPhaseLawTransport<RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11>
    typealias Other = KnownPhaseLawTransport<RoutingAddress00, RoutingAddress10,
        RoutingAddress11, RoutingAddress01>
    enum SameTwoRecords: Null {
        typealias Left = Paired<I.Observation.Answer.Left, FactOf<I.Left>>
        typealias Right = Paired<Other.Observation.Answer.Left, FactOf<Other.Left>>
    }
}

#if LOCAL_PHASE_TRANSPORT_USES_IDENTITY_FRAME
enum RejectedPhaseIdentityFrame: Pair {
    typealias F = PhaseTransportRepeatedReference.I
    typealias IdentityFrame = BoundaryWorking<RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11>
    typealias Wrong = EarlierPoint0AtCurrent2<Paired<F.Observation.Answer.Left, IdentityFrame>>
    typealias Left = Wrong.Left
    typealias Right = Wrong.Answer
}
#endif

#if LOCAL_PHASE_TRANSPORT_KEEPS_OLD_ADDRESS
enum RejectedPhaseUnchangedAddress: Null {
    typealias F = PhaseTransportRepeatedReference.I
    typealias Left = F.Observation.Answer.Left.Answer
    typealias Right = F.CurrentLaw.Answer.Left.Left
}
#endif

#if LOCAL_PHASE_TRANSPORT_COUNTS_RAW_ADDRESSES
enum RejectedPhaseRepeatedReferenceAsComplete: Null {
    typealias P = PhaseTransportRepeatedReference
    typealias Left = P.I.CurrentLaw.Answer
    typealias Right = P.Other.CurrentLaw.Answer
}
#endif
