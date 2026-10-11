import VerificationIsIdentification
import Examples

enum ProbePairKeepsOneSource<A: PredicateReading, B: PredicateReading>: Null
where A.Left == B.Left, A.Left: Structure {
    typealias Run = TwoResidentReadings<A, B>
    typealias Left = Run.Right.Left.Left
    typealias Right = Run.Left.Left.Left
}
enum ProbePairFocusIsItsOwnInverse<A: PredicateReading, B: PredicateReading>: Null
where A.Left == B.Left, A.Left: Structure {
    typealias Run = TwoResidentReadings<A, B>
    typealias Left = ExchangeResidentInstruments<Run.Focus.Right>.Right
    typealias Right = Run.Focus.Left
}
enum ProbePairPreparedPredecessors<A: PredicateReading, B: PredicateReading>: Null
where A.Left == B.Left, A.Left: Structure {
    typealias Run = TwoResidentReadings<A, B>
    typealias Left = Paired<Paired<PreparedPredecessor<Run.FirstRead.Right>.Left, PreparedPredecessor<Run.FirstRead.Right>.Right>, Paired<PreparedPredecessor<Run.SecondRead.Right>.Left, PreparedPredecessor<Run.SecondRead.Right>.Right>>
    typealias Right = Paired<Run.FirstRead.Left, Run.SecondRead.Left>
}
enum ProbePairRecordsActualReadings<A: PredicateReading, B: PredicateReading>: Null
where A.Left == B.Left, A.Left: Structure {
    typealias Left = ResidentProbeFacts<TwoResidentReadings<A, B>.Right>
    typealias Right = Paired<FactOf<A>, FactOf<B>>
}
enum ProbePairFirstRecordSurvivesSecond<A: PredicateReading, B: PredicateReading>: Null
where A.Left == B.Left, A.Left: Structure {
    typealias Run = TwoResidentReadings<A, B>
    typealias Left = Run.Right.Right
    typealias Right = Run.FirstRead.Right.Right
}

typealias ResidentRoutingA = FirstRoutingProbe<IdentityRouting>
typealias ResidentRoutingB = SecondRoutingProbe<IdentityRouting>
typealias ResidentRoutingRun = TwoResidentReadings<ResidentRoutingA, ResidentRoutingB>
typealias ResidentRoutingEvidence = TwoResidentAnswers<ResidentRoutingA, ResidentRoutingB>
typealias ResidentRoutingRecovery = AnswerOnRefinement<RoutingFromProbes<IdentityRouting>, ResidentRoutingEvidence>
typealias ResidentRoutingDecoder = AnswerInResidentProbePair<ResidentRoutingRun.Right, ResidentRoutingRecovery>
enum ProbePairRecoversFromTwoRecords: Null {
    typealias Left = ResidentRoutingDecoder.Answer
    typealias Right = IdentityRouting
}
enum ProbePairDecoderHasNoWhole: Null {
    typealias Left = ResidentRoutingDecoder.Left
    typealias Right = Paired<FactOf<ResidentRoutingA>, FactOf<ResidentRoutingB>>
}

// The same two resident facts suffice for the new-input factorization.
typealias ResidentRoutingData = BoundaryWorking<Never, Lit1, Never, Lit1>
typealias ResidentRoutingApply = RoutingApplicationFromProbes<IdentityRouting, ResidentRoutingData, Route00<ResidentRoutingData>, Route01<ResidentRoutingData>, Route10<ResidentRoutingData>, Route11<ResidentRoutingData>>
typealias ResidentRoutingReuse = AnswerOnRefinement<ResidentRoutingApply, EvidenceBesideInput<ResidentRoutingEvidence, ResidentRoutingData>>
enum ProbePairReusesTheResidentFacts: Null {
    typealias Left = ResidentRoutingReuse.Right.Left
    typealias Right = Paired<ResidentProbeFacts<ResidentRoutingRun.Right>, ResidentRoutingData>
}

#if PROBEPAIR_SKIPS_FOCUS
typealias RejectedProbePairFocus = FollowedPair<ResidentRoutingRun.First, ResidentRoutingRun.Second>
#endif
#if PROBEPAIR_REUSES_FIRST_SLOT
typealias RejectedProbePairSlot = FollowedPair<ResidentRoutingRun.First, ResidentRoutingRun.First>
#endif
#if PROBEPAIR_UNREAD_SECOND
typealias RejectedProbePairUnread = AnswerInResidentProbePair<ResidentRoutingRun.Focus.Right, ResidentRoutingRecovery>
#endif
#if PROBEPAIR_MISSING_SECOND_INSTRUMENT
enum RejectedProbePairMissing: Null {
    typealias Left = ResidentRoutingRun.Left
    typealias Right = ResidentRoutingRun.FirstRead.Left
}
#endif
#if PROBEPAIR_OTHER_SOURCE
typealias RejectedProbePairSource = TwoResidentReadings<ResidentRoutingA, SecondRoutingProbe<ExchangeFirstImage<IdentityRouting>.Answer>>
#endif
#if PROBEPAIR_SWAPPED_RECORDS
enum RejectedProbePairOrder: Null {
    typealias Left = ResidentRoutingDecoder.Left
    typealias Right = Paired<FactOf<ResidentRoutingB>, FactOf<ResidentRoutingA>>
}
#endif
#if PROBEPAIR_SAME_CHANNEL_FOR_BOTH
typealias ProbePairWrongInstrument = Paired<ChannelOf<ResidentRoutingB>, ResidentRoutingRun.Right.Right.Right>
typealias ProbePairWrongWhole = Paired<ResidentRoutingRun.Right.Left, ProbePairWrongInstrument>
typealias RejectedProbePairChannel = AnswerInResidentProbePair<ProbePairWrongWhole, ResidentRoutingRecovery>
#endif

// Recover the complete prepared input from the final whole's coordinates.
// Both record copies can be uncomputed on this actual construction range
// because the same source remains. This is not indefinite retained learning.
enum ProbePairFullPreparationRecovered<A: PredicateReading, B: PredicateReading>: Null
where A.Left == B.Left, A.Left: Structure {
    typealias Run = TwoResidentReadings<A, B>
    typealias W = Run.Right
    typealias FirstInstrument = Paired<W.Left.Left, W.Right>
    typealias FirstBlank = PreparedPredecessor<FirstInstrument>.Right
    typealias SecondBlank = PreparedPredecessor<W.Left>.Right
    typealias Left = Paired<Paired<W.Left.Left, FirstBlank>, SecondBlank>
    typealias Right = Run.Left
}
