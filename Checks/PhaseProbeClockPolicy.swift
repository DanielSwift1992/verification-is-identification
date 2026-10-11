import VerificationIsIdentification
import Examples

#if !LOCAL_PHASE_PROBE_USES_FACT_BEFORE_CLOCK_RETURN && !LOCAL_PHASE_PROBE_CLOCK_RETURN_IS_WHOLE_RETURN
// Kept in the positive pass; the two refusal branches have their own
// concrete sources and do not need to repeat this generic application proof.
enum ProbeAcquiredClockPolicyWorks<A: Structure, B: Structure,
    C: Structure, D: Structure>: Null {
    typealias P = ProbeAcquiredPhaseClockPolicy<A, B, C, D>
    typealias Left = Paired<P.ActualPhaseAndClock.Left, P.RetainsActualFactsAndProbes.Left>
    typealias Right = Paired<P.ActualPhaseAndClock.Right, P.RetainsActualFactsAndProbes.Right>
}
#endif

enum ProbeReplyLeavesInitialClockUnidentified: Null {
    typealias E = PhaseProbeClockExperiment
    typealias Left = E.Zero.Fact
    typealias Right = E.One.Fact
}

#if LOCAL_PHASE_PROBE_USES_FACT_BEFORE_CLOCK_RETURN
enum RejectedPhaseProbeBeforeClockReturn: Null {
    typealias V = BoundaryWorking<RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11>
    typealias E = PhaseProbeClockExperiment.One
    typealias C = PhaseCyclingContacts<RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11>
    typealias M = PhaseCyclingContacts<RoutingAddress11, RoutingAddress01,
        RoutingAddress00, RoutingAddress10>
    typealias Root = PhaseClockPolicyRoot<RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11, E.First.Right.Left.Right,
        C.AtTwo, M.AtTwo, E.Fact>
    // The decoder legitimately selects its zero-bit branch. The false claim
    // is that this already gives the requested current phase action.
    typealias Early = PhaseProbeDrivenRun<E.First, Root.Selected<Root.SelectDirect>, V>
    typealias Left = Early.Right.Left.Left.Left.Left
    typealias Right = C.P.Q1.Right
}
#endif

#if LOCAL_PHASE_PROBE_CLOCK_RETURN_IS_WHOLE_RETURN
enum RejectedPhaseProbeWholeReturn: Null {
    typealias E = PhaseProbeClockExperiment.One
    typealias Left = E.Right.Left
    typealias Right = E.Left
}
#endif
