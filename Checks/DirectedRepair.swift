import VerificationIsIdentification
import Examples

#if !DIRECTED_REPAIR_SEALED && !DIRECTED_REPAIR_WRONG_SIDE && !DIRECTED_REPAIR_AGREEMENT
enum DirectedRepairDerivesTheSelectedContents<A: Structure, B: Structure, H: Structure>: Null {
    typealias P = FirstDirectedRepair<A, B, H>.Path
    typealias Left = P.Answer
    typealias Right = RepairSurface<Paired<A, A>, ProtectedFirst, RepairClosed, Paired<B, H>>
}

enum PreparedAccessNeedsNoUpstreamSelectionMarker<A: Structure, B: Structure, H: Structure>: Null {
    typealias T = TransferIntoSecond<A, B, Never, H>
    typealias S = SealSecondRepair<Paired<A, A>, Never, Paired<B, H>>
    typealias P = SequentialReading<T, S>
    typealias Left = P.Answer
    typealias Right = RepairSurface<Paired<A, A>, Never, RepairClosed, Paired<B, H>>
}

enum DisplacedContentMakesThePresentedTransferRecoverable<A: Structure, B: Structure,
    M: Structure, H: Structure>: Null {
    typealias T = TransferIntoSecond<A, B, M, H>
    typealias P = SequentialReading<T, RestoreSecondFromRemainder<T.Answer>>
    typealias Left = P.Left
    typealias Right = P.Answer
}

enum PrematureClosurePreservesTheContentsAndSelection<A: Structure, B: Structure,
    H: Structure>: Null {
    typealias P = ReopenedFirstRepair<A, B, H>.ClosedPrefix
    typealias Left = Paired<P.Answer.Left, P.Answer.Right.Left>
    typealias Right = Paired<P.Left.Left, P.Left.Right.Left>
}

enum ActualReopeningRestoresTheSameFullResult<A: Structure, B: Structure, H: Structure>: Null {
    typealias P = ReopenedFirstRepair<A, B, H>.SameFullEnd
    typealias Left = P.Left
    typealias Right = P.Right
}

enum RecordingAnOpeningRetainsItsActualOccurrence<A: Structure, B: Structure, H: Structure>: Null {
    typealias O = OpenSecondAgainstFirst<Paired<A, B>, H>
    typealias R = RecordReading<O>
    typealias Left = Paired<R.Right.Left, R.Right.Right.Answer>
    typealias Right = Paired<O.Left, O.Answer>
}

enum AlreadyAgreedContentsNeedNoChoiceOfTemplate<A: Structure, H: Structure>: Null {
    typealias Left = FirstDirectedRepair<A, A, H>.Path.Answer.Left
    typealias Right = SecondDirectedRepair<A, A, H>.Path.Answer.Left
}
#endif

#if DIRECTED_REPAIR_SEALED
enum RejectedEarlierOpeningDoesNotEnableTheSealedSource: Null {
    typealias P = ReopenedFirstRepair<Never, Examples.Succ<Never>, Never>
    typealias Invalid = SequentialReading<P.ClosedPrefix, P.Transfer>
    typealias Left = Invalid.Answer
    typealias Right = P.Transfer.Answer
}
#endif

#if DIRECTED_REPAIR_WRONG_SIDE
enum RejectedOppositeOpeningIsNotTheSamePreparedContact: Null {
    typealias O = OpenSecondAgainstFirst<Paired<Never, Examples.Succ<Never>>, Never>
    typealias T = TransferIntoFirst<Never, Examples.Succ<Never>, ProtectedFirst, Never>
    typealias Invalid = SequentialReading<O, T>
    typealias Left = Invalid.Answer
    typealias Right = T.Answer
}
#endif

#if DIRECTED_REPAIR_AGREEMENT
enum RejectedAgreementAloneDoesNotIdentifyTheRestoredContents: Null {
    typealias Left = FirstDirectedRepair<Never, Examples.Succ<Never>, Never>.Path.Answer.Left
    typealias Right = SecondDirectedRepair<Never, Examples.Succ<Never>, Never>.Path.Answer.Left
}
#endif
