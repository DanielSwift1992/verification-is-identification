import VerificationIsIdentification
import Examples

enum ArbitraryPrivateUpdatesKeepTheVisibleQuestion<
    S: Pair, T: Pair, R: PredicateReading, Q: PredicateReading>: Null
where S.Left: Pair, S.Right: Pair, T.Left: Pair, T.Right: Pair,
      S.Left.Left: Structure, S.Right.Left: Structure,
      S.Left.Left == T.Left.Left, S.Right.Left == T.Right.Left,
      R.Left == S, Q.Left == T, R.Answer: Pair, Q.Answer: Pair,
      R.Answer.Left: Structure, R.Answer.Right: Structure,
      Q.Answer.Left: Structure, Q.Answer.Right: Structure,
      R.Sigma == BeamSpace, Q.Sigma == BeamSpace,
      R.Encoding == SaturationEncoding, Q.Encoding == SaturationEncoding {
    typealias Proof = VisiblePartnerAgreement<S, T, R, Q>
    typealias Left = Proof.Left
    typealias Right = Proof.Right
}
enum FullPartnerExchangeReturns<A: Structure, P: Structure,
    B: Structure, Q: Structure>: Null {
    typealias Left = VisiblePartnerReturn<A, P, B, Q>.Left
    typealias Right = VisiblePartnerReturn<A, P, B, Q>.Right
}
enum IdlePartnerKeepsTheOldAgreement<A: Structure>: Null {
    typealias Left = FreshPartnerContrast<A>.OldReplies.Left
    typealias Right = FreshPartnerContrast<A>.OldReplies.Right
}
enum NewPartnerExposesTheActualPrivateFields<A: Structure>: Null {
    typealias Left = FreshPartnerContrast<A>.NewReplies.Left
    typealias Right = FreshPartnerContrast<A>.NewReplies.Right
}
enum NewContactReturnsTheWholeAndRetainsThePartner<A: Structure>: Null {
    typealias Left = FreshPartnerContrast<A>.ReturnAndPartner.Left
    typealias Right = FreshPartnerContrast<A>.ReturnAndPartner.Right
}

typealias PartnerRootX = Paired<Paired<Never, Never>, Paired<Lit1, Never>>
typealias PartnerRootY = Paired<Paired<Never, Lit1>, Paired<Lit1, Never>>
typealias PartnerSafeX = VisiblePartnerExchange<PartnerRootX, PrivatePartnerFields<PartnerRootX>>
typealias PartnerSafeY = VisiblePartnerExchange<PartnerRootY, PrivatePartnerFields<PartnerRootY>>

#if FRESH_PARTNER_OLD_AGREEMENT_IS_GLOBAL
enum RejectedOldPartnersCertifyEveryPartner: Null {
    typealias Left = FreshPartnerContrast<Never>.NewX.Answer.Left.Left
    typealias Right = FreshPartnerContrast<Never>.NewY.Answer.Left.Left
}
#endif

#if FRESH_PARTNER_VISIBLE_MEANS_WHOLE
enum RejectedVisibleExchangeIdentifiesTheWhole: Null {
    typealias Left = PartnerSafeX.Answer.Left.Right
    typealias Right = PartnerSafeY.Answer.Left.Right
}
#endif

#if FRESH_PARTNER_PRIVATE_SOURCE_SUBSTITUTION
enum RejectedPrivateUpdateFromADifferentSource {
    typealias Forged = VisiblePartnerExchange<PartnerRootX, PrivatePartnerFields<PartnerRootY>>
}
#endif
