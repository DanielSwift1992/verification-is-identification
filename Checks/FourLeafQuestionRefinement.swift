import VerificationIsIdentification
import Examples

// Continue every acquired endpoint by actually reading its two retained
// facts through the existing decoder, then record that answer beside the
// full source. The decoder receives no source or original law parameter.
enum FourLeafQuestionRefinement: Close {
    typealias R = FourLeafRefinedInquiry
    typealias ReadI = DecodeRefinedEvidence<R.FactorI.Observation, R.FactorI.Right>
    typealias CompleteI = FollowedPair<R.I, RecordReading<ReadI>>
    typealias ReadW = DecodeRefinedEvidence<R.FactorW.Observation, R.FactorW.Right>
    typealias CompleteW = FollowedPair<R.W, RecordReading<ReadW>>
    typealias ReadWW = DecodeRefinedEvidence<R.FactorWW.Observation, R.FactorWW.Right>
    typealias CompleteWW = FollowedPair<R.WW, RecordReading<ReadWW>>
    typealias ReadZ = DecodeRefinedEvidence<R.FactorZ.Observation, R.FactorZ.Right>
    typealias CompleteZ = FollowedPair<R.Z, RecordReading<ReadZ>>
    typealias ReadZW = DecodeRefinedEvidence<R.FactorZW.Observation, R.FactorZW.Right>
    typealias CompleteZW = FollowedPair<R.ZW, RecordReading<ReadZW>>
    typealias ReadZWW = DecodeRefinedEvidence<R.FactorZWW.Observation, R.FactorZWW.Right>
    typealias CompleteZWW = FollowedPair<R.ZWW, RecordReading<ReadZWW>>
    typealias ReadWZ = DecodeRefinedEvidence<R.FactorWZ.Observation, R.FactorWZ.Right>
    typealias CompleteWZ = FollowedPair<R.WZ, RecordReading<ReadWZ>>
    typealias ReadWZW = DecodeRefinedEvidence<R.FactorWZW.Observation, R.FactorWZW.Right>
    typealias CompleteWZW = FollowedPair<R.WZW, RecordReading<ReadWZW>>
    typealias ReadWZWW = DecodeRefinedEvidence<R.FactorWZWW.Observation, R.FactorWZWW.Right>
    typealias CompleteWZWW = FollowedPair<R.WZWW, RecordReading<ReadWZWW>>
    typealias ReadWWZ = DecodeRefinedEvidence<R.FactorWWZ.Observation, R.FactorWWZ.Right>
    typealias CompleteWWZ = FollowedPair<R.WWZ, RecordReading<ReadWWZ>>
    typealias ReadWWZW = DecodeRefinedEvidence<R.FactorWWZW.Observation, R.FactorWWZW.Right>
    typealias CompleteWWZW = FollowedPair<R.WWZW, RecordReading<ReadWWZW>>
    typealias ReadWWZWW = DecodeRefinedEvidence<R.FactorWWZWW.Observation, R.FactorWWZWW.Right>
    typealias CompleteWWZWW = FollowedPair<R.WWZWW, RecordReading<ReadWWZWW>>

    enum RecordsOriginalLaw: Null {
        typealias Left = BoundaryWorking<Paired<CompleteI.Right.Right.Answer, Paired<CompleteW.Right.Right.Answer, CompleteWW.Right.Right.Answer>>, Paired<CompleteZ.Right.Right.Answer, Paired<CompleteZW.Right.Right.Answer, CompleteZWW.Right.Right.Answer>>, Paired<CompleteWZ.Right.Right.Answer, Paired<CompleteWZW.Right.Right.Answer, CompleteWZWW.Right.Right.Answer>>, Paired<CompleteWWZ.Right.Right.Answer, Paired<CompleteWWZW.Right.Right.Answer, CompleteWWZWW.Right.Right.Answer>>>
        typealias Right = BoundaryWorking<Paired<FourLeafLawAddresses.I, Paired<FourLeafLawAddresses.W, FourLeafLawAddresses.WW>>, Paired<FourLeafLawAddresses.Z, Paired<FourLeafLawAddresses.ZW, FourLeafLawAddresses.ZWW>>, Paired<FourLeafLawAddresses.WZ, Paired<FourLeafLawAddresses.WZW, FourLeafLawAddresses.WZWW>>, Paired<FourLeafLawAddresses.WWZ, Paired<FourLeafLawAddresses.WWZW, FourLeafLawAddresses.WWZWW>>>
    }
    enum OneQuestionForAllLaws: Null {
        typealias Left = BoundaryWorking<Paired<CompleteI.Right.Right.Predicate, Paired<CompleteW.Right.Right.Predicate, CompleteWW.Right.Right.Predicate>>, Paired<CompleteZ.Right.Right.Predicate, Paired<CompleteZW.Right.Right.Predicate, CompleteZWW.Right.Right.Predicate>>, Paired<CompleteWZ.Right.Right.Predicate, Paired<CompleteWZW.Right.Right.Predicate, CompleteWZWW.Right.Right.Predicate>>, Paired<CompleteWWZ.Right.Right.Predicate, Paired<CompleteWWZW.Right.Right.Predicate, CompleteWWZWW.Right.Right.Predicate>>>
        typealias Right = BoundaryWorking<Paired<FourLeafResidentLawQuestion, Paired<FourLeafResidentLawQuestion, FourLeafResidentLawQuestion>>, Paired<FourLeafResidentLawQuestion, Paired<FourLeafResidentLawQuestion, FourLeafResidentLawQuestion>>, Paired<FourLeafResidentLawQuestion, Paired<FourLeafResidentLawQuestion, FourLeafResidentLawQuestion>>, Paired<FourLeafResidentLawQuestion, Paired<FourLeafResidentLawQuestion, FourLeafResidentLawQuestion>>>
    }
    enum KeepsOriginalFirstFacts: Null {
        typealias Left = R.RetainsFirstFact.Left
        typealias Right = R.RetainsFirstFact.Right
    }
    enum KeepsUsedValue: Null {
        typealias Left = R.RetainsCompletedEffect.Left
        typealias Right = R.RetainsCompletedEffect.Right
    }
}

enum FourLeafWeakAgreement: Null {
    typealias Use = FourLeafOneFactWords
    typealias Left = Paired<Use.First.I.Answer.Right, Use.I.Right.Right.Left>
    typealias Right = Paired<Use.First.WZW.Answer.Right, Use.WZW.Right.Right.Left>
}

// An optimal two-point acquisition of (A,A,B,B) already identifies the even
// law. Keeping only its value answer forgets a distinction present in those
// acquired facts: I and Z agree here but disagree after splitting the A pair.
enum CurrentValueOmitsAcquiredDistinction: Null {
    typealias Old = PhaseWordCatalogue<Never, Never, Lit1, Lit1>
    typealias Left = Old.I.Right
    typealias Right = Old.Z.Right
}

enum RetainedFactsAnswerRefinement: Null {
    typealias Future = FourLeafRecoveredWords<RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress10>
    typealias Left = Paired<Future.I.Right.Right.Left, Future.Z.Right.Right.Left>
    typealias Right = Paired<BoundaryWorking<RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress10>, BoundaryWorking<RoutingAddress01,
        RoutingAddress00, RoutingAddress10, RoutingAddress10>>
}

#if LOCAL_PHASE_CURRENT_VALUE_IS_FUTURE_MEMORY
enum RejectedCurrentValueAsFutureMemory: Null {
    typealias Future = RetainedFactsAnswerRefinement.Future
    typealias Left = Future.I.Right.Right.Left
    typealias Right = Future.Z.Right.Right.Left
}
#endif

// WZW has the same weak value effect as the selected I. It is nevertheless
// not the word selected by this actual decoded address and resident program.
#if LOCAL_PHASE_WEAK_USE_IGNORES_CHOICE
enum RejectedWeakUseUnselectedWord: Pair {
    typealias Root = FourLeafOneFactWords.RWZW
    typealias Wrong = Root.Run<Root.Root.SelectWZW>
    typealias Left = Wrong.Left
    typealias Right = Wrong.Right
}
#endif

#if LOCAL_PHASE_WEAK_REPRESENTATIVE_IS_ORIGINAL
enum RejectedWeakRepresentativeAsOriginal: Null {
    typealias Left = FourLeafRefinedInquiry.FactorWZW.Answer
    typealias Right = FourLeafOneFactWords.RWZW.Install.Install.Context.Right.Left
}
#endif

#if LOCAL_PHASE_WEAK_REPLACES_PARKED_LAW
enum RejectedWeakReplacementAtResume: Pair {
    typealias R = FourLeafRefinedInquiry
    typealias Wrong = FourLeafContinueInquiry<R.UntilParkWZW,
        FourLeafTwoProbe.FocusI, FourLeafTwoProbe.SecondI, R.ParkWZW.Remainder>
    typealias Left = Wrong.Left
    typealias Right = Wrong.Right
}
#endif
