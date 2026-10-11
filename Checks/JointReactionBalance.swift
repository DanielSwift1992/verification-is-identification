import VerificationIsIdentification
import Examples

#if !REACTION_BALANCE_EMPTY && !REACTION_BALANCE_SINGLE_LOSS
enum AJointRemovalUsesBothActualPredecessors<A: IntegerValued, B: IntegerValued>: Null {
    typealias P = StartEventBalance<Examples.Succ<A>, Examples.Succ<B>>
    typealias R = RemovalEventBalance<P, A, B>
    typealias Left = Paired<R.Event.Left, Paired<R.Left, R.Right>>
    typealias Right = Paired<P.Left, Paired<Paired<A, B>, P.Right>>
}

enum BirthsAndRemovalComposeFromTheSameActualCounts<A: IntegerValued, B: IntegerValued>: Null {
    typealias P = UnbalancedBirthPrefix<A, B>
    typealias Left = P.CurrentAndLedger.Left
    typealias Right = P.CurrentAndLedger.Right
}

enum ACompleteBalancedReactionCanRetainItsOccurrence<A: IntegerValued, B: IntegerValued>: Null {
    typealias R = RemovalEventBalance<StartEventBalance<Examples.Succ<A>, Examples.Succ<B>>, A, B>
    typealias Left = Paired<R.RecordedEvent.Right.Left, R.RecordedEvent.Right.Right.Answer>
    typealias Right = Paired<R.Event.Left, Paired<A, B>>
}

enum ReturningTheCountersDoesNotEraseTheBirthLedger: Null {
    typealias P = SensingEventBalance<ReferenceEventBalance<StartEventBalance<Never, Never>>>
    typealias R = RemovalEventBalance<P, Never, Never>
    typealias Left = Paired<R.Left, R.Right>
    typealias Right = Paired<Paired<Never, Never>, Paired<Examples.Succ<Never>, Examples.Succ<Never>>>
}

enum OneSidedLossHasADifferentActualResult: Null {
    typealias Left = Paired<JointCountRemoval<Never, Never>.Answer,
        FirstCountLoss<Never, Examples.Succ<Never>>.Answer>
    typealias Right = Paired<Paired<Never, Never>, Paired<Never, Examples.Succ<Never>>>
}
#endif

#if REACTION_BALANCE_EMPTY
enum RejectedZeroDifferenceDoesNotSupplyBothReactants: Null {
    typealias R = RemovalEventBalance<StartEventBalance<Never, Never>, Never, Never>
    typealias Left = R.Left
    typealias Right = Paired<Never, Never>
}
#endif

#if REACTION_BALANCE_SINGLE_LOSS
enum RejectedIndependentLossIsTheSameJointReaction: Null {
    typealias Left = FirstCountLoss<Never, Examples.Succ<Never>>.Answer
    typealias Right = JointCountRemoval<Never, Never>.Answer
}
#endif
