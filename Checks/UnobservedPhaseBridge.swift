import VerificationIsIdentification
import Examples

enum StableUnobservedPhaseBridge<A: Structure, B: Structure,
    C: Structure, D: Structure>: Null {
    typealias U = UnobservedPhaseBridge<A, B, C, D>
    typealias Left = Paired<U.FirstActionWithoutIdentification.Left,
        U.SecondActionWithoutIdentification.Left>
    typealias Right = Paired<U.FirstActionWithoutIdentification.Right,
        U.SecondActionWithoutIdentification.Right>
}

// One independent trace of the actual preparation distinguishes the switch.
enum UnobservedBridgeSwitchWitness: Null {
    typealias Stable = UnobservedPhaseBridge<Never, Lit1, Never, Never>
    typealias Changed = SwitchedUnobservedPhaseBridge<Never, Lit1, Never, Never>
    typealias Left = Paired<Stable.ToFirst1.Right, Changed.Right>
    typealias Right = Paired<FourLeafPhaseMark0, FourLeafPhaseMark1>
}

#if LOCAL_PHASE_UNOBSERVED_BRIDGE_ALLOWS_SWITCH
enum RejectedUnobservedBridgeAfterSwitch: Null {
    typealias Left = UnobservedBridgeSwitchWitness.Stable.ToFirst1.Right
    typealias Right = UnobservedBridgeSwitchWitness.Changed.Right
}
#endif

#if LOCAL_PHASE_UNOBSERVED_BRIDGE_IDENTIFIES_LAW
enum RejectedUnobservedBridgeAsIdentification: Null {
    typealias P = PhaseAlignmentObstruction<RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11>
    typealias Left = P.Q1.Right
    typealias Right = P.Q2.Right
}
#endif
