import VerificationIsIdentification
import Examples

#if !LOCAL_PHASE_REDUCTION_ERASES_WW && !LOCAL_PHASE_REDUCTION_PRESERVES_INTERMEDIATE
enum PhaseReductionAllClocks<A: Structure, B: Structure, C: Structure,
    D: Structure, R: Structure>: Null {
    typealias P = PhaseBasisReduction<A, B, C, D, R>
    typealias Left = Paired<P.Zero.Endpoints.Left,
        Paired<P.One.Endpoints.Left, P.Two.Endpoints.Left>>
    typealias Right = Paired<P.Zero.Endpoints.Right,
        Paired<P.One.Endpoints.Right, P.Two.Endpoints.Right>>
}

// A nonidentity prefix changes the actual inputs of both replacement paths.
// No equality between the two final composites is required from the caller.
enum PhaseReductionInsideContext<A: Structure, B: Structure, C: Structure,
    D: Structure, R: Structure>: Null {
    typealias Before = WorkingPhaseW<A, B, C, D, PhaseBridgeClock.Zero, R>
    typealias Mid = PhaseBasisReduction<D, B, A, C, R>
    typealias After = WorkingPhaseW<D, A, C, B, PhaseBridgeClock.Zero, R>
    typealias Use = EndpointSubstitution<Before, Mid.Zero.PP,
        Mid.Profile.Zero.Row1.W, After>
    typealias Left = Use.Left
    typealias Right = Use.Right
}
#endif

#if LOCAL_PHASE_REDUCTION_ERASES_WW
enum RejectedPhaseReductionErasesWW: Null {
    typealias P = PhaseBasisReduction<RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11, Never>
    typealias Left = P.Zero.PWP.Right
    typealias Right = P.Profile.Zero.I.Right
}
#endif

#if LOCAL_PHASE_REDUCTION_PRESERVES_INTERMEDIATE
enum RejectedPhaseReductionSameIntermediate: Null {
    typealias P = PhaseBasisProfile<RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11, Never>
    // PP and WPW agree at the end, but their first macro contacts do not.
    typealias Left = P.Zero.Row0.I.Right
    typealias Right = P.Zero.W.Right
}
#endif

