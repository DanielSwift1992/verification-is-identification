import VerificationIsIdentification
import Examples

// Two separately prepared probe families. Their sequential use still needs
// the reserve-focus construction; this verifies what each actual probe records.
enum FourLeafPointFacts: Null {
    typealias P = FourLeafFirstProbe<Never>
    typealias Q = FourLeafSecondProbe<Never>
    typealias A = RoutingAddress00
    typealias B = RoutingAddress01
    typealias C = RoutingAddress10
    typealias D = RoutingAddress11
    typealias Left = BoundaryWorking<
        Paired<Paired<P.I.Answer.Right.Answer, Q.I.Answer.Right.Answer>,
            Paired<Paired<P.W.Answer.Right.Answer, Q.W.Answer.Right.Answer>, Paired<P.WW.Answer.Right.Answer, Q.WW.Answer.Right.Answer>>>,
        Paired<Paired<P.Z.Answer.Right.Answer, Q.Z.Answer.Right.Answer>,
            Paired<Paired<P.ZW.Answer.Right.Answer, Q.ZW.Answer.Right.Answer>, Paired<P.ZWW.Answer.Right.Answer, Q.ZWW.Answer.Right.Answer>>>,
        Paired<Paired<P.WZ.Answer.Right.Answer, Q.WZ.Answer.Right.Answer>,
            Paired<Paired<P.WZW.Answer.Right.Answer, Q.WZW.Answer.Right.Answer>, Paired<P.WZWW.Answer.Right.Answer, Q.WZWW.Answer.Right.Answer>>>,
        Paired<Paired<P.WWZ.Answer.Right.Answer, Q.WWZ.Answer.Right.Answer>,
            Paired<Paired<P.WWZW.Answer.Right.Answer, Q.WWZW.Answer.Right.Answer>, Paired<P.WWZWW.Answer.Right.Answer, Q.WWZWW.Answer.Right.Answer>>>>
    typealias Right = BoundaryWorking<
        Paired<Paired<A, B>, Paired<Paired<C, B>, Paired<D, B>>>,
        Paired<Paired<B, A>, Paired<Paired<B, C>, Paired<B, D>>>,
        Paired<Paired<D, A>, Paired<Paired<A, C>, Paired<C, D>>>,
        Paired<Paired<C, A>, Paired<Paired<D, C>, Paired<A, D>>>>
}

enum FourLeafFactDoesNotRevealWord<R: Structure, T: Structure>: Null {
    typealias Left = FourLeafFirstProbe<R>.I.Answer.Right
    typealias Right = FourLeafFirstProbe<T>.WZW.Answer.Right
}

// W fixes phase 1, so substituting it for I here could preserve the entire
// working answer. The source's selected law is nevertheless an actual input.
enum FourLeafWrongWordCanHaveSameEndpoint<R: Structure>: Null {
    typealias K = FourLeafLawContext<FourLeafLawAddresses.I, R>
    typealias Root = FourLeafWordRoot<Never, Lit1, Never, Never, K>
    typealias Left = Root.Words.I.Answer
    typealias Right = Root.Words.W.Answer
}

#if LOCAL_PHASE_WORD_IGNORES_RESIDENT_ADDRESS
enum RejectedFourLeafWrongResidentWord: Pair {
    typealias K = FourLeafLawContext<FourLeafLawAddresses.I, Never>
    typealias Root = FourLeafWordRoot<Never, Lit1, Never, Never, K>
    typealias Wrong = Root.Selected<Root.SelectW>
    typealias Left = Wrong.Left
    typealias Right = Wrong.Answer
}
#endif
