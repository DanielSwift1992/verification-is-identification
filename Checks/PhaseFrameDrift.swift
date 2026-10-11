import VerificationIsIdentification
import Examples

#if !LOCAL_PHASE_FRAME_COMMON_CHANGE_IS_HARMLESS
enum PhaseFrameActualPaths<A: Structure, B: Structure, C: Structure,
    D: Structure, R: Structure>: Null {
    typealias F = PhaseFrameDrift<A, B, C, D, R>
    typealias Left = Paired<F.Conjugated.Left, Paired<F.Preserved.Left, F.MixedFacts.Left>>
    typealias Right = Paired<F.Conjugated.Right, Paired<F.Preserved.Right, F.MixedFacts.Right>>
}
#endif

#if LOCAL_PHASE_FRAME_COMMON_CHANGE_IS_HARMLESS
enum RejectedSharedFrameChangePreservesLaw: Null {
    typealias F = PhaseFrameDrift<RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11, Never>
    typealias Left = F.Crossed.Right
    typealias Right = F.Original.Right
}
#endif
