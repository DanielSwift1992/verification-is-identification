import VerificationIsIdentification
import Examples

enum PhaseCyclingBridgeClosure<A: Structure, B: Structure,
    C: Structure, D: Structure>: Null {
    typealias Contacts = PhaseCyclingContacts<A, B, C, D>
    typealias P = PhaseCyclingBridge<A, B, C, D>
    typealias Left = Paired<Contacts.ActualInverseClauses.Left,
        Paired<Contacts.NormalizedPhaseAction.Left, Paired<P.Right, P.Corrected.Right>>>
    typealias Right = Paired<Contacts.ActualInverseClauses.Right,
        Paired<Contacts.NormalizedPhaseAction.Right,
            Paired<P.ActualEndpoint.Right, P.RepairedEndpoint.Right>>>
}

#if LOCAL_PHASE_CYCLING_CLOCK_RETURN_IS_BRIDGE
enum RejectedCyclingClockReturnAsBridge: Null {
    typealias P = PhaseCyclingBridge<Never, Lit1, Never, Never>
    typealias Left = P.Right
    typealias Right = P.Corrected.Right
}
#endif

#if LOCAL_PHASE_CYCLING_REUSES_OLD_CLAUSE
enum RejectedCyclingPreviousClockClause: Pair {
    typealias P = PhaseCyclingBridge<RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11>
    typealias Wrong = FollowedPair<P.BeforeThird,
        PhaseCyclingContacts<RoutingAddress11, RoutingAddress00,
            RoutingAddress10, RoutingAddress01>.AtZero>
    typealias Left = Wrong.Left
    typealias Right = Wrong.Right
}
#endif
