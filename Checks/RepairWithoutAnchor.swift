import VerificationIsIdentification
import Examples

#if !REPLICA_TWO_EXCHANGES && !REPLICA_NO_EQUAL_PAIR
enum OneActualExchangePreservesTheRecoverableValue<A: Structure, B: Structure, C: Structure>: Null {
    typealias P = OneExchangeReplicaRecovery<A, B, C>.RecoveredSource
    typealias Left = P.Left
    typealias Right = P.Right
}

enum RecoveredViewControlsActualRepairAndRetainsItsInput<A: Structure, B: Structure, C: Structure>: Null {
    typealias P = OneExchangeReplicaRecovery<A, B, C>
    typealias Left = Paired<P.RestoreOne.Answer.Left, Paired<P.RestoreTwo.Answer.Left,
        Paired<P.RestoreThree.Answer.Left, Paired<P.RestoreOther.Answer.Left, P.RestoreOne.Answer.Right>>>>
    typealias Right = Paired<P.Source.Left, Paired<P.Source.Left,
        Paired<P.Source.Left, Paired<P.Source.Left, P.One.Answer>>>>
}

enum ReplicaExchangeIsAnInvolutionOnThePresentedWhole<A: Structure, B: Structure,
    C: Structure, D: Structure, E: Structure>: Null {
    typealias S = ReplicaFrame<A, B, C, D, E>
    typealias U = ExchangeReplicaOne<S>
    typealias V = ExchangeReplicaTwo<S>
    typealias W = ExchangeReplicaThree<S>
    typealias Z = ExchangeReplicaTwoWithSecondReserve<S>
    typealias Left = Paired<ExchangeReplicaOne<U.Answer>.Answer,
        Paired<ExchangeReplicaTwo<V.Answer>.Answer,
        Paired<ExchangeReplicaThree<W.Answer>.Answer,
        ExchangeReplicaTwoWithSecondReserve<Z.Answer>.Answer>>>
    typealias Right = Paired<S, Paired<S, Paired<S, S>>>
}

enum EqualPairClausesAgreeOnTheirOverlap<A: Structure>: Null {
    typealias V = ThreeReplicaView<A, A, A>
    typealias Left = Paired<ReadEqualReplicas12<V>.Answer,
        Paired<ReadEqualReplicas13<V>.Answer, ReadEqualReplicas23<V>.Answer>>
    typealias Right = Paired<A, Paired<A, A>>
}

enum ReplicaAcquisitionDoesNotReceiveEitherReserve<A: Structure, B: Structure,
    C: Structure, D: Structure, E: Structure>: Null {
    typealias S = ReplicaFrame<A, B, C, D, E>
    typealias Left = ReadThreeReplicas<S>.Answer
    typealias Right = ThreeReplicaView<A, B, C>
}

enum TwoPermittedExchangesCanShareAViewWithAnotherOriginal<A: Structure, B: Structure>: Null {
    typealias P = TwoExchangeReplicaCollision<A, B>.SameAvailableInput
    typealias Left = P.Left
    typealias Right = P.Right
}

enum ARepeatedValueAfterTwoExchangesCanBeTheOtherContent<A: Structure, B: Structure>: Null {
    typealias P = TwoExchangeReplicaCollision<A, B>
    typealias Left = ReadEqualReplicas12<P.FirstView.Answer>.Answer
    typealias Right = P.SecondSource.Left.Left
}
#endif

#if REPLICA_TWO_EXCHANGES
enum RejectedOneExchangeGuaranteeAfterTwoActualExchanges: Null {
    typealias P = TwoExchangeReplicaCollision<Never, Examples.Succ<Never>>
    typealias Left = ReadEqualReplicas12<P.FirstView.Answer>.Answer
    typealias Right = P.FirstSource.Left.Left
}
#endif

#if REPLICA_NO_EQUAL_PAIR
enum RejectedUnequalPairCannotBeAnEqualPairReading: Null {
    typealias V = ThreeReplicaView<Never, Examples.Succ<Never>,
        Examples.Succ<Examples.Succ<Never>>>
    typealias Left = ReadEqualReplicas12<V>.Answer
    typealias Right = Never
}
#endif
