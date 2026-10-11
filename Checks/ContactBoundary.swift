import VerificationIsIdentification
import Examples

#if !LOCAL_PHASE_CONTACT_BOUNDARY_FLAT && !LOCAL_PHASE_CONTACT_BOUNDARY_HIDDEN && !LOCAL_PHASE_CONTACT_BOUNDARY_INTERIOR && !LOCAL_PHASE_CONTACT_BOUNDARY_ALTERNATION && !LOCAL_PHASE_CONTACT_BOUNDARY_PRODUCT_AB && !LOCAL_PHASE_CONTACT_BOUNDARY_PRODUCT_AC && !LOCAL_PHASE_CONTACT_BOUNDARY_ONLY_FIRST && !LOCAL_PHASE_CONTACT_BOUNDARY_ONLY_SECOND
enum ConditionalBoundarySurvives<T: Null>: Null
where T.Left: Pair, T.Left.Left: Structure {
    typealias Left = AliasActivatesBoundary<T>.Left
    typealias Right = AliasActivatesBoundary<T>.Right
}

enum SharedPathCloses<T: Null>: Null
where T.Left: Pair, T.Left.Left: Pair, T.Left.Left.Right: Structure {
    typealias Left = SharedEntryForcesHiddenAgreement<T>.Left
    typealias Right = SharedEntryForcesHiddenAgreement<T>.Right
}

enum FreeBoundaryAdmitsNewPartner: Null {
    typealias Free = UncoupledBoundary<Never, Never, Lit1>
    typealias Left = Free.Right
    typealias Right = BoundaryWorking<Never, Never, Never, Lit1>
}

enum ClosedContactInterface<P: Pair, Q: Pair>: Null
where P.Left == Q, Q.Left == P, P.Right == P, Q.Right == Q {
    typealias J = ClosedBoundaryJoin<P, Q>
    typealias Left = Paired<J.CommonBoundary.Left, J.PreservedRows.Left>
    typealias Right = Paired<J.CommonBoundary.Right, J.PreservedRows.Right>
}

enum JoinedRecordKeepsBothSides<K: Structure>: Null {
    typealias J = ClosedBoundaryNodes.Joined
    typealias R = StepBeside<RecordReading<J.Joint>, K>
    typealias Left = Paired<R.Right.Left.Left, R.Right.Right>
    typealias Right = Paired<J.Whole, K>
}

enum SharedBoundaryRetainsDifferentInteriors: Null {
    typealias J = ClosedBoundaryNodes
    typealias Left = Paired<J.Joined.CommonBoundary.Left, J.DifferentInteriors.Left>
    typealias Right = Paired<J.Joined.CommonBoundary.Right, J.DifferentInteriors.Right>
}

enum ConditionalExchangesReachActualPath<T: Null>: Null
where T.Left: Pair, T.Left.Left: Pair, T.Left.Left.Right: Pair,
      T.Left.Left.Right.Left: Structure {
    typealias C = AlternatingBoundaryClosure<T>
    typealias A = AlternatingBoundaryPath<T.Left>
    typealias B = AlternatingBoundaryPath<T.Right>
    typealias Left = Paired<C.Left, C.Right>
    typealias Right = Paired<A.Answer, B.Answer>
}

enum UnmergedEntriesKeepDistinctAnswers: Null {
    typealias Left = OpenAlternatingBoundary.TerminalContrast.Left
    typealias Right = OpenAlternatingBoundary.TerminalContrast.Right
}

enum ProductDoesNotSelectEitherOldIdentity: Null {
    typealias P = AlternativeBoundaryProduct
    typealias Left = Paired<P.Product.ComponentsSurvive.Left, P.BothContrasts.Left>
    typealias Right = Paired<P.Product.ComponentsSurvive.Right, P.BothContrasts.Right>
}

enum TwoAntecedentsCloseSharedChain<A: Null, B: Null>: Null
where A.Left: Pair, B.Left: Pair,
      A.Left.Left: Structure, B.Left.Right: Structure,
      A.Right.Left == B.Left.Right {
    typealias J = JoinedConditionalBoundary<A, B>
    typealias Left = J.Left
    typealias Right = J.Right
}

enum PackedPremiseKeepsJointContent<T: Null>: Null
where T.Left: Pair, T.Left.Left: Pair, T.Left.Right: Pair,
      T.Left.Left.Left: Structure, T.Left.Right.Right: Structure,
      T.Right.Left.Left == T.Left.Right.Right {
    typealias J = PackedConditionalBoundary<T>
    typealias Left = Paired<J.Left, J.Right>
    typealias Right = Paired<T.Left.Left.Left, T.Right.Right.Right>
}

enum EachLoneAntecedentPreservesTerminalContrast: Null {
    typealias M = ConditionalChainMissingOne
    typealias Left = Paired<M.FirstInputIdentity.Left,
        Paired<M.SecondInputIdentity.Left, M.BothTerminalContrasts.Left>>
    typealias Right = Paired<M.FirstInputIdentity.Right,
        Paired<M.SecondInputIdentity.Right, M.BothTerminalContrasts.Right>>
}

enum BothAntecedentsHaveNonzeroRealization: Null {
    typealias G = ClosedConditionalChain
    typealias Left = Paired<G.SameOuterReadings.Left, G.SameOuterReadings.Right>
    typealias Right = Paired<Paired<Lit1, Lit1>, Paired<Lit1, Lit1>>
}
#endif

#if LOCAL_PHASE_CONTACT_BOUNDARY_ONLY_FIRST
enum RejectedContactBoundaryOnlyFirst: Null {
    typealias G = ConditionalChainMissingOne.FirstOnly
    typealias Left = G.C.Answer
    typealias Right = G.D.Answer
}
#endif

#if LOCAL_PHASE_CONTACT_BOUNDARY_ONLY_SECOND
enum RejectedContactBoundaryOnlySecond: Null {
    typealias G = ConditionalChainMissingOne.SecondOnly
    typealias Left = G.C.Answer
    typealias Right = G.D.Answer
}
#endif

#if LOCAL_PHASE_CONTACT_BOUNDARY_FLAT
enum RejectedContactBoundaryFlat: Null {
    typealias Coupled = FunctionalBoundaryReading<Never, Never>
    typealias Left = Coupled.Answer.Right
    typealias Right = Paired<Never, Lit1>
}
#endif

#if LOCAL_PHASE_CONTACT_BOUNDARY_ALTERNATION
enum RejectedContactBoundaryAlternation: Null {
    typealias Left = OpenAlternatingBoundary.ARead.Answer
    typealias Right = OpenAlternatingBoundary.BRead.Answer
}
#endif

#if LOCAL_PHASE_CONTACT_BOUNDARY_PRODUCT_AB
enum RejectedContactBoundaryProductAB: Null {
    typealias Left = AlternativeBoundaryProduct.ABFirst.Answer
    typealias Right = AlternativeBoundaryProduct.ABSecond.Answer
}
#endif

#if LOCAL_PHASE_CONTACT_BOUNDARY_PRODUCT_AC
enum RejectedContactBoundaryProductAC: Null {
    typealias Left = AlternativeBoundaryProduct.ACFirst.Answer
    typealias Right = AlternativeBoundaryProduct.ACSecond.Answer
}
#endif

#if LOCAL_PHASE_CONTACT_BOUNDARY_HIDDEN
enum RejectedContactBoundaryHidden: Null {
    typealias Left = SeparatedHiddenPaths.First.Answer
    typealias Right = SeparatedHiddenPaths.Second.Answer
}
#endif

#if LOCAL_PHASE_CONTACT_BOUNDARY_INTERIOR
enum RejectedContactBoundaryInterior: Null {
    typealias Left = ClosedBoundaryNodes.PrivateGReply.Answer
    typealias Right = ClosedBoundaryNodes.PrivateHReply.Answer
}
#endif
