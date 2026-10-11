import VerificationIsIdentification
import Examples

#if !LOCAL_PHASE_RESIDUE_IS_WHOLE_IDENTITY && !LOCAL_PHASE_SHORT_RESET_PRESERVES_AUX && !LOCAL_PHASE_EQUAL_COUNT_IS_EQUAL_ACTION
enum PhaseResidueActualPaths<A: Structure, B: Structure, C: Structure, D: Structure,
    E: Structure, F: Structure, G: Structure, H: Structure>: Null {
    typealias K = PhaseInterfaceResidue<A, B, C, D, E, F, G, H>
    typealias B29 = PairedPhaseInterface<A, B, C, D, E, F, G, H>
    typealias N = RestoredPhaseInterface<A, B, C, D, E, F, G, H>
    typealias Left = Paired<
        Paired<K.AtZero.Endpoints.Left, Paired<K.AtOne.Endpoints.Left, K.AtTwo.Endpoints.Left>>,
        Paired<Paired<B29.AtZero.Endpoints.Left, Paired<B29.AtOne.Endpoints.Left, B29.AtTwo.Endpoints.Left>>,
            Paired<N.AtZero.Endpoints.Left, Paired<N.AtOne.Endpoints.Left, N.AtTwo.Endpoints.Left>>>>
    typealias Right = Paired<
        Paired<K.AtZero.Endpoints.Right, Paired<K.AtOne.Endpoints.Right, K.AtTwo.Endpoints.Right>>,
        Paired<Paired<B29.AtZero.Endpoints.Right, Paired<B29.AtOne.Endpoints.Right, B29.AtTwo.Endpoints.Right>>,
            Paired<N.AtZero.Endpoints.Right, Paired<N.AtOne.Endpoints.Right, N.AtTwo.Endpoints.Right>>>>
}

enum PhaseRestoredWholeOutputs<A: Structure, B: Structure, C: Structure, D: Structure,
    E: Structure, F: Structure, G: Structure, H: Structure>: Null {
    typealias N = RestoredPhaseInterface<A, B, C, D, E, F, G, H>
    typealias Left = Paired<N.ZeroPath.Right, Paired<N.OnePath.Right, N.TwoPath.Right>>
    typealias Right = Paired<PhaseInterfaceWorld<B, C, A, D, E, F, G, H, PhaseBridgeClock.Zero>,
        Paired<PhaseInterfaceWorld<B, C, A, D, E, F, G, H, PhaseBridgeClock.One>,
            PhaseInterfaceWorld<B, C, A, D, E, F, G, H, PhaseBridgeClock.Two>>>
}

// A weaker input domain really changes what counts as complete restoration.
// Repeating E in q's three moved slots is allowed by the original carrier.
enum PhaseShortResetOnFixedAuxiliary<A: Structure, B: Structure, C: Structure, D: Structure,
    E: Structure, H: Structure>: Null {
    typealias B29 = PairedPhaseInterface<A, B, C, D, E, E, E, H>
    typealias Left = Paired<B29.ZeroPath.Right, Paired<B29.OnePath.Right, B29.TwoPath.Right>>
    typealias Right = Paired<PhaseInterfaceWorld<B, C, A, D, E, E, E, H, PhaseBridgeClock.Zero>,
        Paired<PhaseInterfaceWorld<B, C, A, D, E, E, E, H, PhaseBridgeClock.One>,
            PhaseInterfaceWorld<B, C, A, D, E, E, E, H, PhaseBridgeClock.Two>>>
}
#endif

enum PhaseResidueFixture: Close {
    typealias K = PhaseInterfaceResidue<RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11, RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11>
    typealias B29 = PairedPhaseInterface<RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11, RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11>
    typealias R = ReusablePhaseInterface<RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11, RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11>
}

#if LOCAL_PHASE_RESIDUE_IS_WHOLE_IDENTITY
enum RejectedPhaseResidueWholeIdentity: Null {
    typealias K = PhaseResidueFixture.K.AtZero
    typealias Left = K.Right
    typealias Right = K.Left
}
#endif

#if LOCAL_PHASE_SHORT_RESET_PRESERVES_AUX
enum RejectedPhaseShortResetAuxiliary: Null {
    typealias B29 = PhaseResidueFixture.B29.AtZero
    typealias Left = B29.Right.Right
    typealias Right = B29.Left.Right
}
#endif

#if LOCAL_PHASE_EQUAL_COUNT_IS_EQUAL_ACTION
enum RejectedPhaseEqualCountEqualAction: Null {
    typealias R = PhaseResidueFixture.R
    typealias Left = R.MWZero.SourceStep.Answer
    typealias Right = R.WMZero.SourceStep.Answer
}
#endif
