import VerificationIsIdentification
import Examples

// Input 2 was not queried during acquisition. The selected catalogue action
// is now applied to this independently prepared input.
enum FourLeafNewProbeAfterLearning: Null {
    typealias R = FourLeafRecoveredWords<Never, Never, Lit1, Never>
    typealias Left = Paired<Paired<Paired<Paired<R.I.Right.Right.Left, R.W.Right.Right.Left>, R.WW.Right.Right.Left>, Paired<Paired<R.Z.Right.Right.Left, R.ZW.Right.Right.Left>, R.ZWW.Right.Right.Left>>, Paired<Paired<Paired<R.WZ.Right.Right.Left, R.WZW.Right.Right.Left>, R.WZWW.Right.Right.Left>, Paired<Paired<R.WWZ.Right.Right.Left, R.WWZW.Right.Right.Left>, R.WWZWW.Right.Right.Left>>>
    typealias Right = Paired<Paired<Paired<Paired<FourLeafPhaseMark2, FourLeafPhaseMark3>, FourLeafPhaseMark0>, Paired<Paired<FourLeafPhaseMark3, FourLeafPhaseMark0>, FourLeafPhaseMark2>>, Paired<Paired<Paired<FourLeafPhaseMark2, FourLeafPhaseMark3>, FourLeafPhaseMark0>, Paired<Paired<FourLeafPhaseMark1, FourLeafPhaseMark1>, FourLeafPhaseMark1>>>
}

enum FourLeafReuseRetainsFacts: Null {
    typealias R = FourLeafRecoveredWords<Never, Never, Lit1, Never>
    typealias Left = Paired<Paired<Paired<Paired<R.I.Right.Right.Right.Right.Right.Right.Left.Left, R.W.Right.Right.Right.Right.Right.Right.Left.Left>, R.WW.Right.Right.Right.Right.Right.Right.Left.Left>, Paired<Paired<R.Z.Right.Right.Right.Right.Right.Right.Left.Left, R.ZW.Right.Right.Right.Right.Right.Right.Left.Left>, R.ZWW.Right.Right.Right.Right.Right.Right.Left.Left>>, Paired<Paired<Paired<R.WZ.Right.Right.Right.Right.Right.Right.Left.Left, R.WZW.Right.Right.Right.Right.Right.Right.Left.Left>, R.WZWW.Right.Right.Right.Right.Right.Right.Left.Left>, Paired<Paired<R.WWZ.Right.Right.Right.Right.Right.Right.Left.Left, R.WWZW.Right.Right.Right.Right.Right.Right.Left.Left>, R.WWZWW.Right.Right.Right.Right.Right.Right.Left.Left>>>
    typealias Right = Paired<Paired<Paired<Paired<FourLeafAcquiredLaw.I.Observation.Answer, FourLeafAcquiredLaw.W.Observation.Answer>, FourLeafAcquiredLaw.WW.Observation.Answer>, Paired<Paired<FourLeafAcquiredLaw.Z.Observation.Answer, FourLeafAcquiredLaw.ZW.Observation.Answer>, FourLeafAcquiredLaw.ZWW.Observation.Answer>>, Paired<Paired<Paired<FourLeafAcquiredLaw.WZ.Observation.Answer, FourLeafAcquiredLaw.WZW.Observation.Answer>, FourLeafAcquiredLaw.WZWW.Observation.Answer>, Paired<Paired<FourLeafAcquiredLaw.WWZ.Observation.Answer, FourLeafAcquiredLaw.WWZW.Observation.Answer>, FourLeafAcquiredLaw.WWZWW.Observation.Answer>>>
}

// A weaker question can require no law acquisition: every permutation leaves
// an all-equal source unchanged. This does not identify which action was used.
enum FourLeafConstantPhaseNeedsNoLaw<A: Structure>: Null {
    typealias R = PhaseWordCatalogue<A, A, A, A>
    typealias Left = Paired<Paired<Paired<Paired<R.I.Right, R.W.Right>, R.WW.Right>, Paired<Paired<R.Z.Right, R.ZW.Right>, R.ZWW.Right>>, Paired<Paired<Paired<R.WZ.Right, R.WZW.Right>, R.WZWW.Right>, Paired<Paired<R.WWZ.Right, R.WWZW.Right>, R.WWZWW.Right>>>
    typealias Right = Paired<Paired<Paired<Paired<BoundaryWorking<A, A, A, A>, BoundaryWorking<A, A, A, A>>, BoundaryWorking<A, A, A, A>>, Paired<Paired<BoundaryWorking<A, A, A, A>, BoundaryWorking<A, A, A, A>>, BoundaryWorking<A, A, A, A>>>, Paired<Paired<Paired<BoundaryWorking<A, A, A, A>, BoundaryWorking<A, A, A, A>>, BoundaryWorking<A, A, A, A>>, Paired<Paired<BoundaryWorking<A, A, A, A>, BoundaryWorking<A, A, A, A>>, BoundaryWorking<A, A, A, A>>>>
}

#if LOCAL_PHASE_REUSE_IGNORES_LEARNED_LAW
enum RejectedFourLeafReuseOtherLaw: Pair {
    typealias R = FourLeafRecoveredRoot<FourLeafAcquiredLaw.I.Right,
        Never, Lit1, Never, Never>
    typealias Wrong = R.Run<R.Root.SelectW>
    typealias Left = Wrong.Left
    typealias Right = Wrong.Right
}
#endif

