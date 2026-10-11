import VerificationIsIdentification
import Examples

#if !JOINED_CONTINUATION_HISTORY && !JOINED_CONTINUATION_CURRENT
enum AJoinedInputDerivesAgreementForTheSuppliedSuffix<A: Pair, B: Pair, R: PredicateReading>: Null
where A.Left == B.Left, R.Left == A.Left,
      R.Sigma == BeamSpace, R.Encoding == SaturationEncoding {
    typealias C = JoinedContinuation<A, B, R>
    typealias Left = C.SameAnswer.Left
    typealias Right = C.SameAnswer.Right
}

enum BothOriginalSourcesSurviveTheCommonSuffix<A: Pair, B: Pair, R: PredicateReading>: Null
where A.Left == B.Left, R.Left == A.Left,
      R.Sigma == BeamSpace, R.Encoding == SaturationEncoding {
    typealias C = JoinedContinuation<A, B, R>
    typealias Left = C.RetainedSources.Left
    typealias Right = C.RetainedSources.Right
}

enum CurrentAgreementAndPrivateContrastCoexist<K: Structure, V: Structure>: Null {
    typealias C = JoinedRoots<K, V>
    typealias Left = Paired<C.CurrentAgreement.Left, C.PreservedContrast.Left>
    typealias Right = Paired<C.CurrentAgreement.Right, C.PreservedContrast.Right>
}

enum AConcreteSuffixPreservesTheOriginalPrivateContrast: Null {
    typealias Roots = JoinedRoots<Paired<Never, Examples.Succ<Never>>, Never>
    typealias R = SecondEvidenceImage<Roots.A.Left, BeamSpace, SaturationEncoding, SecondProjection>
    typealias C = JoinedContinuation<Roots.A, Roots.B, R>
    typealias Left = Paired<Paired<C.PathA.Answer, C.PathB.Answer>,
        Paired<C.RecordA.Right.Left.Right.Right, C.RecordB.Right.Left.Right.Right>>
    typealias Right = Paired<Paired<Examples.Succ<Never>, Examples.Succ<Never>>,
        Paired<Never, Examples.Succ<Never>>>
}

enum CurrentAgreementCanPrecedeAnActualFutureContrast: Null {
    typealias C = UnjoinedVisibleRoots
    typealias Left = Paired<C.CurrentAgreement.Left, C.FutureContrast.Left>
    typealias Right = Paired<C.CurrentAgreement.Right, C.FutureContrast.Right>
}
#endif

#if JOINED_CONTINUATION_HISTORY
enum RejectedJoinedAnswersIdentifyTheRetainedHistory: Null {
    typealias Roots = JoinedRoots<Never, Never>
    typealias Left = Roots.PrivateA.Answer
    typealias Right = Roots.PrivateB.Answer
}
#endif

#if JOINED_CONTINUATION_CURRENT
enum RejectedCurrentAgreementDeterminesTheFuture: Null {
    typealias Left = UnjoinedVisibleRoots.FutureA.Answer
    typealias Right = UnjoinedVisibleRoots.FutureB.Answer
}
#endif
