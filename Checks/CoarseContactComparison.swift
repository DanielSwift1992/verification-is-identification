import VerificationIsIdentification
import Examples

#if !COARSE_FOUR_AGREEMENTS && !COARSE_CHANGING_SENSOR
// The contact meanings are derived from the existing words, including
// the direction of the pullback, rather than from their names.
enum CoarseViewsUseTheActualContactWords<A: Structure, B: Structure,
    C: Structure, D: Structure>: Null {
    typealias S = BoundaryWorking<A, B, C, D>
    typealias V = CoarseContactViews<S>
    typealias Left = V.All
    typealias Right = BoundaryWorking<S, BoundaryWorking<C, B, D, A>,
        BoundaryWorking<B, A, D, C>, BoundaryWorking<D, A, C, B>>
}
enum ConstantSensorPassesAllSixConditionalImplications<A: Structure>: Null {
    typealias S = BoundaryWorking<A, A, A, A>
    typealias Left = Paired<Paired<CoarseAgreement01<S>.Left, CoarseAgreement02<S>.Left>,
        BoundaryWorking<CoarseAgreement03<S>.Left, CoarseAgreement12<S>.Left,
            CoarseAgreement13<S>.Left, CoarseAgreement23<S>.Left>>
    typealias Right = Paired<Paired<S, S>, BoundaryWorking<S, S, S, S>>
}
enum FirstThreeCoarseAgreementsLeaveAnotherSensorValueFree<A: Structure,
    B: Structure>: Null {
    typealias V = CoarseContactViews<BoundaryWorking<A, A, A, B>>
    typealias Left = Paired<Paired<V.I.Left.Left, V.I.Left.Right>,
        Paired<Paired<V.W.Left.Left, V.W.Left.Right>, Paired<V.Z.Left.Left, V.Z.Left.Right>>>
    typealias Right = Paired<Paired<A, A>, Paired<Paired<A, A>, Paired<A, A>>>
}
enum FourthContactReadsThePreviouslyMissedContrast<A: Structure,
    B: Structure>: Null {
    typealias V = CoarseContactViews<BoundaryWorking<A, A, A, B>>
    typealias Left = Paired<V.ZW.Left.Left, V.ZW.Left.Right>
    typealias Right = Paired<B, A>
}
enum ChangingNonconstantSensorsCanAlwaysAgree<A: Structure,
    B: Structure>: Null {
    typealias P = CoarseContactViews<BoundaryWorking<A, A, B, A>>
    typealias Q = CoarseContactViews<BoundaryWorking<B, A, A, A>>
    typealias R = CoarseContactViews<BoundaryWorking<A, B, A, A>>
    typealias Left = BoundaryWorking<Paired<P.I.Left.Left, P.I.Left.Right>,
        Paired<Q.W.Left.Left, Q.W.Left.Right>, Paired<P.Z.Left.Left, P.Z.Left.Right>,
        Paired<R.ZW.Left.Left, R.ZW.Left.Right>>
    typealias Right = BoundaryWorking<Paired<A, A>, Paired<A, A>, Paired<A, A>, Paired<A, A>>
}
#endif

#if COARSE_FOUR_AGREEMENTS
enum RejectedFourAgreementsForTheUnresolvedDistinctPair: Null {
    typealias S = BoundaryWorking<Never, Never, Never, Examples.Succ<Never>>
    typealias P = CoarseAgreement01<S>
    typealias Left = P.Left
    typealias Right = P.Right
}
#endif

#if COARSE_CHANGING_SENSOR
enum RejectedDifferentSensorsAreTheSameFourReadingProfile: Null {
    typealias A = Never
    typealias B = Examples.Succ<A>
    typealias P = CoarseContactViews<BoundaryWorking<A, A, B, A>>
    typealias Q = CoarseContactViews<BoundaryWorking<B, A, A, A>>
    typealias Left = Paired<Q.W.Left.Left, Q.W.Left.Right>
    typealias Right = Paired<P.W.Left.Left, P.W.Left.Right>
}
#endif
