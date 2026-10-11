import VerificationIsIdentification
import Examples

#if !LOCAL_PHASE_INTERFACE_REUSES_INITIAL_CLOCK && !LOCAL_PHASE_INTERFACE_DROPS_AUXILIARY_CHANGE && !LOCAL_PHASE_INTERFACE_CUBE_IS_WHOLE_RETURN && !LOCAL_PHASE_INTERFACE_SWAPS_LOGICAL_ACTION
enum ReusableInterfaceWholeEndpoints<A: Structure, B: Structure, C: Structure, D: Structure,
    E: Structure, F: Structure, G: Structure, H: Structure>: Null {
    typealias R = UnobservedClockReturn<A, B, C, D, E, F, G, H>
    typealias M = UnobservedClockInterface<A, B, C, D, E, F, G, H>
    typealias Left = Paired<
        Paired<R.AtZero.Endpoints.Left, Paired<R.AtOne.Endpoints.Left, R.AtTwo.Endpoints.Left>>,
        Paired<M.AtZero.Endpoints.Left, Paired<M.AtOne.Endpoints.Left, M.AtTwo.Endpoints.Left>>>
    typealias Right = Paired<
        Paired<R.AtZero.Endpoints.Right, Paired<R.AtOne.Endpoints.Right, R.AtTwo.Endpoints.Right>>,
        Paired<M.AtZero.Endpoints.Right, Paired<M.AtOne.Endpoints.Right, M.AtTwo.Endpoints.Right>>>
}

enum ReusableInterfaceCube<A: Structure, B: Structure, C: Structure, D: Structure,
    E: Structure, F: Structure, G: Structure, H: Structure>: Null {
    typealias R = ReusablePhaseInterface<A, B, C, D, E, F, G, H>
    typealias Left = Paired<R.CubeWholeOutputs.Left, R.CubeWorkingReturn.Left>
    typealias Right = Paired<R.CubeWholeOutputs.Right, R.CubeWorkingReturn.Right>
}

// The two orders are both admitted, with their respective actual answers.
enum ReusableInterfaceMixedOrders<A: Structure, B: Structure, C: Structure, D: Structure,
    E: Structure, F: Structure, G: Structure, H: Structure>: Null {
    typealias R = ReusablePhaseInterface<A, B, C, D, E, F, G, H>
    typealias Left = Paired<Paired<R.MWZero.Right.Answer,
        Paired<R.MWOne.Right.Answer, R.MWTwo.Right.Answer>>,
        Paired<R.WMZero.Right.Answer, Paired<R.WMOne.Right.Answer, R.WMTwo.Right.Answer>>>
    typealias MW = BoundaryWorking<D, C, B, A>
    typealias WM = BoundaryWorking<B, A, D, C>
    typealias Right = Paired<Paired<MW, Paired<MW, MW>>, Paired<WM, Paired<WM, WM>>>
}

// The existing constructor covers arbitrary finite, source-compatible joins.
// No equality between the final image and source observation is supplied here.
enum ReusableInterfaceComposition<P: CommutingTransition, Q: CommutingTransition>: Null
where P.Right == Q.Left, Q.Right.Answer: Structure {
    typealias Path = JoinedTransition<P, Q>
    typealias Left = Path.ImageStep.Answer
    typealias Right = Path.Right.Answer
}
#endif

enum ReusableInterfaceFixture: Close {
    typealias M = UnobservedInterfaceSquares<RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11, RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11>
    typealias Next = UnobservedInterfaceSquares<RoutingAddress01, RoutingAddress10,
        RoutingAddress00, RoutingAddress11, RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11>
    typealias R = ReusablePhaseInterface<RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11, RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11>
}

#if LOCAL_PHASE_INTERFACE_REUSES_INITIAL_CLOCK
enum RejectedInterfaceInitialClock: Pair {
    typealias P = ReusableInterfaceFixture
    typealias Path = JoinedTransition<P.M.Zero, P.Next.Zero>
    typealias Left = Path.SourceStep.Left
    typealias Right = Path.SourceStep.Answer
}
#endif

#if LOCAL_PHASE_INTERFACE_DROPS_AUXILIARY_CHANGE
enum RejectedInterfaceMissingAuxiliaryChange: Pair {
    typealias P = ReusableInterfaceFixture
    // The working phase and reached clock match; only the auxiliary residue
    // was substituted by its old value. The exact full source seam rejects it.
    typealias Path = JoinedTransition<P.M.Two, P.Next.Zero>
    typealias Left = Path.SourceStep.Left
    typealias Right = Path.SourceStep.Answer
}
#endif

#if LOCAL_PHASE_INTERFACE_CUBE_IS_WHOLE_RETURN
enum RejectedInterfaceCubeWholeReturn: Null {
    typealias Path = ReusableInterfaceFixture.R.CubeZero
    typealias Left = Path.SourceStep.Answer
    typealias Right = Path.SourceStep.Left
}
#endif

#if LOCAL_PHASE_INTERFACE_SWAPS_LOGICAL_ACTION
enum RejectedInterfaceWrongImage: CommutingTransition {
    typealias P = ReusableInterfaceFixture.M.Zero
    typealias SourceStep = P.SourceStep
    // An identical operation address cannot certify a different phase action.
    typealias ImageStep = PhasePathReading<FourLeafPhaseWord<RoutingAddress00,
        RoutingAddress01, RoutingAddress10, RoutingAddress11>, InterfaceFirstPhaseOperation>
    typealias Left = P.Left
    typealias Right = P.Right
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Operation = InterfaceFirstPhaseOperation
}
#endif
