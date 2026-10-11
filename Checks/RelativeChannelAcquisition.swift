import VerificationIsIdentification
import Examples

#if !CHANNEL_UNREAD_MATCH && !CHANNEL_MISSING_REPLY
// This family does not assume a closed common image. The third response
// may be A or a genuinely different C without changing the first records.
enum TwoRepliesDoNotReadTheRemainingChannelEntry<A: Structure, B: Structure,
    C: Structure, H: Structure>: Null {
    typealias P = RelativeChannelAcquisition<Paired<Paired<A, B>, Paired<B, A>>, H>
    typealias Q = RelativeChannelAcquisition<Paired<Paired<A, B>, Paired<B, C>>, H>
    typealias Left = P.F
    typealias Right = Q.F
}
enum ActualThirdReplySuppliesTheMissingMatchRelation<A: Structure, B: Structure,
    C: Structure, D: Structure, H: Structure>: Null {
    typealias P = RelativeChannelAcquisition<Paired<Paired<A, B>, Paired<C, D>>, H>
    typealias Left = P.MatchFactors.Left.Answer
    typealias Right = P.Decoded.Answer
}
enum AcquiringTheThirdReplyRetainsBothTablesAndOldHistory<A: Structure,
    B: Structure, C: Structure, D: Structure, H: Structure>: Null {
    typealias S = Paired<Paired<A, B>, Paired<C, D>>
    typealias P = RelativeChannelAcquisition<S, H>
    typealias Left = P.Actual.Right
    typealias Right = Paired<S, Paired<Paired<H, P.F>, P.N>>
}
enum UnreadHEntryDoesNotEnterTheMatchDecoder<A: Structure, B: Structure,
    C: Structure, D: Structure, E: Structure, H: Structure>: Null {
    typealias P = RelativeChannelAcquisition<Paired<Paired<A, B>, Paired<C, D>>, H>
    typealias Q = RelativeChannelAcquisition<Paired<Paired<A, E>, Paired<C, D>>, H>
    typealias Left = Paired<P.Facts.Answer, P.Decoder.Answer>
    typealias Right = Paired<Q.Facts.Answer, Q.Decoder.Answer>
}
enum TheSwappedCommonCarrierHasAnActualMatch<A: Structure, B: Structure,
    H: Structure>: Null {
    typealias P = RelativeChannelAcquisition<Paired<Paired<A, B>, Paired<B, A>>, H>
    typealias Left = P.Decoded.Answer.Left
    typealias Right = P.Decoded.Answer.Right
}
#endif

#if CHANNEL_UNREAD_MATCH
enum RejectedTwoRepliesEstablishTheUnmeasuredMatch: Null {
    typealias A = Never
    typealias B = Examples.Succ<A>
    typealias C = Examples.Succ<B>
    typealias P = RelativeChannelAcquisition<Paired<Paired<A, B>, Paired<B, C>>, Never>
    typealias Left = P.DirectMatch.Answer.Left
    typealias Right = P.DirectMatch.Answer.Right
}
#endif

#if CHANNEL_MISSING_REPLY
enum RejectedOldRecordSuppliesTheFreshChannelReply: Null {
    typealias A = Never
    typealias B = Examples.Succ<A>
    typealias P = RelativeChannelAcquisition<Paired<Paired<A, B>, Paired<B, A>>, Never>
    typealias Invalid = SequentialReading<P.FirstFact, P.Decoder>
    typealias Left = Invalid.Answer
    typealias Right = P.DirectMatch.Answer
}
#endif
