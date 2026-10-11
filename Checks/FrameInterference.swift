import VerificationIsIdentification
import Examples

#if !LOCAL_PHASE_INTERFERENCE_STALE && !LOCAL_PHASE_INTERFERENCE_SAME && !LOCAL_PHASE_INTERFERENCE_ACTION && !LOCAL_PHASE_INTERFERENCE_SOURCE && !LOCAL_PHASE_INTERFERENCE_OPPOSITE && !LOCAL_PHASE_INTERFERENCE_ADJACENT
enum AnActualFrameChangeCanPreserveTheAcquiredQuestion<A: Structure, B: Structure, C: Structure, P: Structure>: Null {
    typealias F = FrameMovePreservesFixedPort<AddressTriple<A, B, C>, P>
    typealias Left = Paired<F.Left.Answer, F.R.Endpoint.Left>
    typealias Right = Paired<F.Right.Answer, F.R.Endpoint.Right>
}

enum IdenticalOldFactsAndKnownChangesLeaveDifferentCurrentReplies<A: Structure, B: Structure, C: Structure>: Null {
    typealias R = ThreePortInterference<A, B, C>
    typealias Left = Paired<R.SameOldInputAndKnownWord.Left, R.CurrentRepliesAreTheOtherOldField.Left>
    typealias Right = Paired<R.SameOldInputAndKnownWord.Right, R.CurrentRepliesAreTheOtherOldField.Right>
}

enum NewFrameFactsAreActuallyAcquiredAfterTheChange<A: Structure, B: Structure, C: Structure>: Null {
    typealias R = ThreePortInterference<A, B, C>
    typealias Left = AddressTriple<R.BothNewContactsAddressTheChangedSource.Left,
        R.New0.CurrentFixedPointFactors.Left.Answer, R.New1.CurrentFixedPointFactors.Left.Answer>
    typealias Right = AddressTriple<R.BothNewContactsAddressTheChangedSource.Right,
        R.New0.CurrentFixedPointFactors.Right.Answer, R.New1.CurrentFixedPointFactors.Right.Answer>
}

enum ReacquiredChoicesImplementTheCurrentCouplings<A: Structure, B: Structure, C: Structure>: Null {
    typealias R = ThreePortInterference<A, B, C>
    typealias Left = Paired<R.BothChoicesAreCoupledAtTheCurrentFrame.Left,
        R.ActualUsesRetainBothOccurrences.Left>
    typealias Right = Paired<R.BothChoicesAreCoupledAtTheCurrentFrame.Right,
        R.ActualUsesRetainBothOccurrences.Right>
}

enum TheCurrentSelectorHasOnlyItsNewFactAndPayload<A: Structure, B: Structure, C: Structure>: Null {
    typealias R = ThreePortInterference<A, B, C>
    typealias Left = Paired<R.D0.Left, R.D1.Left>
    typealias Right = Paired<Paired<R.New0.Read.Fact, R.P>, Paired<R.New1.Read.Fact, R.P>>
}

enum TransportedRequestStillReadsTheOriginalOccurrence<A: Structure, B: Structure, C: Structure, P: Structure>: Null {
    typealias R = FrameMoveTransportsRequest<AddressTriple<A, B, C>, P>
    typealias Left = Paired<R.OriginalOccurrence.Left, R.OldFactAnswersTransportedRequest.Left>
    typealias Right = Paired<R.OriginalOccurrence.Right, R.OldFactAnswersTransportedRequest.Right>
}

enum OldFactsExecuteBothTransportedRequestsWithoutReacquisition<A: Structure, B: Structure, C: Structure>: Null {
    typealias R = ThreePortInterference<A, B, C>
    typealias Left = Paired<R.BothOldChoicesServeTheTransportedRequest.Left,
        R.TransportedUsesNeedNoSecondFact.Left>
    typealias Right = Paired<R.BothOldChoicesServeTheTransportedRequest.Right,
        R.TransportedUsesNeedNoSecondFact.Right>
}

enum TheSameTurnsGiveTwoAndFourQuestionOrbits<A: Structure, B: Structure, C: Structure, D: Structure>: Null {
    typealias R = RotatingSwapQuestions<A, B, C, D>
    typealias Left = Paired<R.TwoQuestionClosure.Left, R.FourQuestionClosure.Left>
    typealias Right = Paired<R.TwoQuestionClosure.Right, R.FourQuestionClosure.Right>
}

enum TheQuestionOrbitRulesUseActualSourceWords<A: Structure, B: Structure, C: Structure, D: Structure>: Null {
    typealias R = RotatingSwapQuestions<A, B, C, D>
    typealias Left = R.AllWordsBeginAtTheActualWorkingSource.Left
    typealias Right = R.AllWordsBeginAtTheActualWorkingSource.Right
}
#endif

#if LOCAL_PHASE_INTERFERENCE_STALE
enum RejectedOldFrameFactStillAnswersAfterCrossing: ReadingFactors {
    typealias R = ThreePortInterference<Never, Lit1, Lit2>.Old0
    typealias Left = R.Current
    typealias Observation = R.OldFact
    typealias Right = ReadRecordedAnswer<R.Read.Fact>
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Predicate = Left.Predicate
    typealias Answer = Left.Answer
}
#endif

#if LOCAL_PHASE_INTERFERENCE_OPPOSITE
enum RejectedOppositeSwapSurvivesUnreportedTurn: Null {
    typealias R = RotatingSwapQuestions<Never, Lit1, Lit2, Examples.Succ<Lit2>>
    typealias Left = R.Opposite.Right
    typealias Right = R.TurnOpposite.Right
}
#endif

#if LOCAL_PHASE_INTERFERENCE_ADJACENT
enum RejectedTurnParityDeterminesAdjacentSwap: Null {
    typealias R = RotatingSwapQuestions<Never, Lit1, Lit2, Examples.Succ<Lit2>>
    typealias Left = FourLeafPhase0<Never, Lit1, Lit2, Examples.Succ<Lit2>>.Right
    typealias Right = R.TurnAdjacent1.Right
}
#endif

#if LOCAL_PHASE_INTERFERENCE_SAME
enum RejectedSameOldFactAndWordDetermineCurrentAnswer: Null {
    typealias R = ThreePortInterference<Never, Lit1, Lit2>
    typealias Left = R.Old0.Current.Answer
    typealias Right = R.Old1.Current.Answer
}
#endif

#if LOCAL_PHASE_INTERFERENCE_ACTION
enum RejectedTheOldSelectedSwapStillCouples: Null {
    typealias R = ThreePortInterference<Never, Lit1, Lit2>
    typealias Old = FrameSwapAt10<R.Old0.Read.Fact, R.P>
    typealias Left = TripleFrameMaps<Old.Answer>.F021.Answer
    typealias Right = SwapFirstTwoTriple<TripleFrameMaps<R.P>.F021.Answer>.Answer
}
#endif

#if LOCAL_PHASE_INTERFERENCE_SOURCE
enum RejectedReprobeCanUseThePrechangeSource: Null {
    typealias R = ThreePortInterference<Never, Lit1, Lit2>
    typealias Left = R.New0.Read.Root.Left
    typealias Right = R.T0
}
#endif
