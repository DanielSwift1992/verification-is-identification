import VerificationIsIdentification
import Examples

#if !LOCAL_PHASE_PRIMITIVE_CORE_IS_TARGET && !LOCAL_PHASE_PRIMITIVE_RETURN_IS_IDENTITY && !LOCAL_PHASE_Q_COMMUTES_WITH_W_SQUARED
enum PrimitivePhaseActualPaths<A: Structure, B: Structure, C: Structure,
    D: Structure, P: Structure>: Null {
    typealias Core = PrimitivePhaseReturnCore<A, B, C, D>
    typealias T = PrimitivePhaseReturn<A, B, C, D, P>
    typealias Left = Paired<Paired<Core.AtZero.Endpoints.Left,
        Paired<Core.AtOne.Endpoints.Left, Core.AtTwo.Endpoints.Left>>,
        Paired<T.AtZero.Endpoints.Left, Paired<T.AtOne.Endpoints.Left, T.AtTwo.Endpoints.Left>>>
    typealias Right = Paired<Paired<Core.AtZero.Endpoints.Right,
        Paired<Core.AtOne.Endpoints.Right, Core.AtTwo.Endpoints.Right>>,
        Paired<T.AtZero.Endpoints.Right, Paired<T.AtOne.Endpoints.Right, T.AtTwo.Endpoints.Right>>>
}

// The target is the existing independent q construction, not T's output
// renamed as its own specification. The complete arbitrary context returns.
enum PrimitivePhaseWholeResult<A: Structure, B: Structure, C: Structure,
    D: Structure, P: Structure>: Null {
    typealias T = PrimitivePhaseReturn<A, B, C, D, P>
    typealias Target = PhaseAlignmentObstruction<A, B, C, D>.Q1.Right
    typealias Left = Paired<T.ZeroPath.Right, Paired<T.OnePath.Right, T.TwoPath.Right>>
    typealias Right = Paired<Paired<Paired<Target, PhaseBridgeClock.Zero>, P>,
        Paired<Paired<Paired<Target, PhaseBridgeClock.One>, P>,
            Paired<Paired<Target, PhaseBridgeClock.Two>, P>>>
}

// Same complete input and output as the 83-contact macro path, on all
// three clocks and arbitrary payloads. This is not equality of traces.
enum PrimitivePhaseAgreesWithMacro<A: Structure, B: Structure, C: Structure, D: Structure,
    E: Structure, F: Structure, G: Structure, H: Structure>: Null {
    typealias T = PrimitivePhaseReturn<A, B, C, D, BoundaryWorking<E, F, G, H>>
    typealias N = RestoredPhaseInterface<A, B, C, D, E, F, G, H>
    typealias Left = Paired<Paired<T.ZeroPath.Left, T.ZeroPath.Right>,
        Paired<Paired<T.OnePath.Left, T.OnePath.Right>, Paired<T.TwoPath.Left, T.TwoPath.Right>>>
    typealias Right = Paired<Paired<N.ZeroPath.Left, N.ZeroPath.Right>,
        Paired<Paired<N.OnePath.Left, N.OnePath.Right>, Paired<N.TwoPath.Left, N.TwoPath.Right>>>
}

enum PrimitivePhaseRepeat<A: Structure, B: Structure, C: Structure,
    D: Structure, P: Structure>: Null {
    typealias First = PrimitivePhaseReturn<A, B, C, D, P>
    typealias Second = PrimitivePhaseReturn<B, C, A, D, P>
    typealias Third = PrimitivePhaseReturn<C, A, B, D, P>
    typealias Zero = FollowedPair<FollowedPair<First.AtZero, Second.AtZero>, Third.AtZero>
    typealias One = FollowedPair<FollowedPair<First.AtOne, Second.AtOne>, Third.AtOne>
    typealias Two = FollowedPair<FollowedPair<First.AtTwo, Second.AtTwo>, Third.AtTwo>
    typealias Left = Paired<Zero.Right, Paired<One.Right, Two.Right>>
    typealias Right = Paired<Zero.Left, Paired<One.Left, Two.Left>>
}
#endif

enum PrimitivePhaseFixture: Close {
    typealias A = RoutingAddress00
    typealias B = RoutingAddress01
    typealias C = RoutingAddress10
    typealias D = RoutingAddress11
    typealias Core = PrimitivePhaseReturnCore<A, B, C, D>
    typealias T = PrimitivePhaseReturn<A, B, C, D, BoundaryWorking<A, B, C, D>>
}

#if LOCAL_PHASE_PRIMITIVE_CORE_IS_TARGET
enum RejectedPrimitiveCoreAsTarget: Null {
    typealias F = PrimitivePhaseFixture
    typealias Left = F.Core.ZeroPath.Right.Left
    typealias Right = PhaseAlignmentObstruction<F.A, F.B, F.C, F.D>.Q1.Right
}
#endif

#if LOCAL_PHASE_PRIMITIVE_RETURN_IS_IDENTITY
enum RejectedPrimitiveReturnAsIdentity: Null {
    typealias T = PrimitivePhaseFixture.T.AtZero
    typealias Left = T.Right
    typealias Right = T.Left
}
#endif

// The obstruction left after cancelling arbitrary intermediate powers of w
// in the three-working-Q argument. It is witnessed by actual word outputs.
#if LOCAL_PHASE_Q_COMMUTES_WITH_W_SQUARED
enum RejectedPhaseQCommutesWithWSquared: Null {
    typealias F = PrimitivePhaseFixture
    typealias QWW = FollowedPair<PhaseAlignmentObstruction<F.A, F.B, F.C, F.D>.Q1,
        PhaseWordCatalogue<F.B, F.C, F.A, F.D>.WW>
    typealias WWQ = FollowedPair<PhaseWordCatalogue<F.A, F.B, F.C, F.D>.WW,
        PhaseAlignmentObstruction<F.C, F.B, F.D, F.A>.Q1>
    typealias Left = QWW.Right
    typealias Right = WWQ.Right
}
#endif
