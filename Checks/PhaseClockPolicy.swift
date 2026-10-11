import VerificationIsIdentification
import Examples

#if !LOCAL_PHASE_CLOCK_POLICY_IGNORES_ACQUIRED_BIT && !LOCAL_PHASE_CLOCK_POLICY_REUSES_OLD_RECORD
// This generic obligation is checked in the positive pass. Each refusal
// below then checks its concrete changed premise without redoing this proof.
enum AcquiredClockPolicyWorks<A: Structure, B: Structure,
    C: Structure, D: Structure>: Null {
    typealias P = AcquiredPhaseClockPolicy<A, B, C, D>
    typealias Left = Paired<P.ActualPhase.Left, P.ClockAndRecordedBit.Left>
    typealias Right = Paired<P.ActualPhase.Right, P.ClockAndRecordedBit.Right>
}
#endif

enum ClockBitIsCurrentOnly: Null {
    typealias P = AcquiredPhaseClockPolicy<Never, Lit1, Never, Never>
    typealias Left = P.Zero.Fact
    typealias Right = P.One.Fact
}

// A weaker prepared-input question needs no correction or clock readout:
// both raw Q clauses take the marked b input to a at every current clock.
enum PreparedPhaseWithoutClockReadout: Null {
    typealias C = PhaseCyclingContacts<Never, Lit1, Never, Never>
    typealias Left = Paired<C.AtZero.Right.Left,
        Paired<C.AtOne.Right.Left, C.AtTwo.Right.Left>>
    typealias Right = Paired<FourLeafPhaseMark0,
        Paired<FourLeafPhaseMark0, FourLeafPhaseMark0>>
}

#if LOCAL_PHASE_CLOCK_POLICY_IGNORES_ACQUIRED_BIT
enum RejectedClockPolicyWrongSelection: Pair {
    typealias P = AcquiredPhaseClockPolicy<RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11>.Two
    typealias Wrong = P.Selected<P.SelectDirect>
    typealias Left = Wrong.Left
    typealias Right = Wrong.Right
}
#endif

#if LOCAL_PHASE_CLOCK_POLICY_REUSES_OLD_RECORD
enum RejectedClockPolicyStaleRecord: Null {
    typealias P = ClockBitIsCurrentOnly.P
    typealias Left = Paired<Paired<P.Contacts.AtTwo.Left, P.One.Fact>, P.Two.Program>
    typealias Right = P.Two.Selected<P.Two.SelectPrefix>.Left
}
#endif
