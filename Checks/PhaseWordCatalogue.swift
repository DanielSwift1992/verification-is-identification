import VerificationIsIdentification
import Examples

// These four preparations locate an input point by one internal marker.
// All results below are actual coupled-word outputs, before the resident U
// readout is supplied. They do not pretend that the phase is already observed.
enum PhaseWordPointActions<K: Structure>: Null {
    typealias P0 = FourLeafJointCatalogue<Lit1, Never, Never, Never, K>
    typealias P1 = FourLeafJointCatalogue<Never, Lit1, Never, Never, K>
    typealias P2 = FourLeafJointCatalogue<Never, Never, Lit1, Never, K>
    typealias P3 = FourLeafJointCatalogue<Never, Never, Never, Lit1, K>
    typealias M0 = FourLeafPhaseMark0
    typealias M1 = FourLeafPhaseMark1
    typealias M2 = FourLeafPhaseMark2
    typealias M3 = FourLeafPhaseMark3
    typealias Left = BoundaryWorking<
        Paired<BoundaryWorking<P0.I.Answer.Right.Left, P1.I.Answer.Right.Left, P2.I.Answer.Right.Left, P3.I.Answer.Right.Left>,
            Paired<BoundaryWorking<P0.W.Answer.Right.Left, P1.W.Answer.Right.Left, P2.W.Answer.Right.Left, P3.W.Answer.Right.Left>,
                BoundaryWorking<P0.WW.Answer.Right.Left, P1.WW.Answer.Right.Left, P2.WW.Answer.Right.Left, P3.WW.Answer.Right.Left>>>,
        Paired<BoundaryWorking<P0.Z.Answer.Right.Left, P1.Z.Answer.Right.Left, P2.Z.Answer.Right.Left, P3.Z.Answer.Right.Left>,
            Paired<BoundaryWorking<P0.ZW.Answer.Right.Left, P1.ZW.Answer.Right.Left, P2.ZW.Answer.Right.Left, P3.ZW.Answer.Right.Left>,
                BoundaryWorking<P0.ZWW.Answer.Right.Left, P1.ZWW.Answer.Right.Left, P2.ZWW.Answer.Right.Left, P3.ZWW.Answer.Right.Left>>>,
        Paired<BoundaryWorking<P0.WZ.Answer.Right.Left, P1.WZ.Answer.Right.Left, P2.WZ.Answer.Right.Left, P3.WZ.Answer.Right.Left>,
            Paired<BoundaryWorking<P0.WZW.Answer.Right.Left, P1.WZW.Answer.Right.Left, P2.WZW.Answer.Right.Left, P3.WZW.Answer.Right.Left>,
                BoundaryWorking<P0.WZWW.Answer.Right.Left, P1.WZWW.Answer.Right.Left, P2.WZWW.Answer.Right.Left, P3.WZWW.Answer.Right.Left>>>,
        Paired<BoundaryWorking<P0.WWZ.Answer.Right.Left, P1.WWZ.Answer.Right.Left, P2.WWZ.Answer.Right.Left, P3.WWZ.Answer.Right.Left>,
            Paired<BoundaryWorking<P0.WWZW.Answer.Right.Left, P1.WWZW.Answer.Right.Left, P2.WWZW.Answer.Right.Left, P3.WWZW.Answer.Right.Left>,
                BoundaryWorking<P0.WWZWW.Answer.Right.Left, P1.WWZWW.Answer.Right.Left, P2.WWZWW.Answer.Right.Left, P3.WWZWW.Answer.Right.Left>>>>
    typealias Right = BoundaryWorking<
        Paired<BoundaryWorking<M0, M1, M2, M3>, Paired<BoundaryWorking<M2, M1, M3, M0>, BoundaryWorking<M3, M1, M0, M2>>>,
        Paired<BoundaryWorking<M1, M0, M3, M2>, Paired<BoundaryWorking<M1, M2, M0, M3>, BoundaryWorking<M1, M3, M2, M0>>>,
        Paired<BoundaryWorking<M3, M0, M2, M1>, Paired<BoundaryWorking<M0, M2, M3, M1>, BoundaryWorking<M2, M3, M0, M1>>>,
        Paired<BoundaryWorking<M2, M0, M1, M3>, Paired<BoundaryWorking<M3, M2, M1, M0>, BoundaryWorking<M0, M3, M1, M2>>>>
}

enum PhaseJointKeepsCenterAndContext<A: Structure, B: Structure,
                                     C: Structure, D: Structure, K: Structure>: Null {
    typealias Words = FourLeafJointCatalogue<A, B, C, D, K>
    typealias Left = Paired<
        Paired<Words.WZWW.Answer.Left, Words.WZWW.Answer.Right.Right>,
        Paired<Words.WWZWW.Answer.Left, Words.WWZWW.Answer.Right.Right>>
    typealias Right = Paired<Paired<FourLeafCenter, K>, Paired<FourLeafCenter, K>>
}

#if LOCAL_PHASE_WORD_DIRECTION_REVERSED
enum RejectedPhaseWordWrongDirection: Null {
    typealias W = FourLeafJointW<Lit1, Never, Never, Never, Never>
    typealias Left = W.Answer.Right.Left
    typealias Right = FourLeafPhaseMark3
}
#endif

#if LOCAL_PHASE_WORD_CENTER_IS_COMPLETE
enum RejectedPhaseWordStageReturnIsWholeReturn: Null {
    typealias W = FourLeafJointW<Lit1, Never, Never, Never, Never>
    typealias Left = W.Left
    typealias Right = W.Answer
}
#endif
