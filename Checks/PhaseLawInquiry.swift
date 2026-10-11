import VerificationIsIdentification
import Examples

enum PhaseInquirySameTrueAnswers<A: Structure, B: Structure, C: Structure, D: Structure>: Null {
    typealias H = PhaseLawMixedHistory<A, B, C, D>
    typealias Left = Paired<H.NewFacts.Answer.Left.Answer, H.NewFacts.Answer.Right.Answer>
    typealias Right = Paired<A, B>
}

enum PhaseInquiryRecordsAreDifferentQuestions<A: Structure, B: Structure, C: Structure, D: Structure>: Null {
    typealias H = PhaseLawMixedHistory<A, B, C, D>
    typealias Left = Paired<H.NewFacts.Answer.Left.Predicate, H.NewFacts.Answer.Right.Predicate>
    typealias Right = Paired<OperationSequence<FirstProjection, FirstProjection>,
        OperationSequence<FirstProjection, SecondProjection>>
}

enum PhaseInquiryRetainsDifferentHistories<A: Structure, B: Structure, C: Structure, D: Structure>: Null {
    typealias H = PhaseLawMixedHistory<A, B, C, D>
    typealias Left = Paired<H.Stable.Right.Right, H.Changed.Right.Right>
    typealias Right = Paired<IdentityReading<H.Initial, BeamSpace, SaturationEncoding>, FourLeafPhaseWord<A, B, C, D>>
}

enum PhaseInquiryCurrentBoundary: Null {
    typealias H = PhaseLawMixedHistory<Never, Lit1, Lit2, Examples.Succ<Lit2>>
    typealias Left = Paired<H.OldLaw.Answer.Left.Left, H.NewLaw.Answer.Left.Left>
    typealias Right = Paired<Never, Examples.Succ<Lit2>>
}

// A question unaffected by the source change continues to have its answer.
enum PhaseInquirySecondAnswerSurvives<A: Structure, B: Structure, C: Structure, D: Structure>: Null {
    typealias H = PhaseLawMixedHistory<A, B, C, D>
    typealias Left = H.NewFacts.Answer.Right.Answer
    typealias Right = H.NewLaw.Answer.Left.Right
}

#if LOCAL_PHASE_INQUIRY_MIXES_CURRENT_LAW
enum RejectedPhaseInquiryCurrentLaw: Null {
    typealias H = PhaseLawMixedHistory<Never, Lit1, Lit2, Examples.Succ<Lit2>>
    typealias Left = H.OldLaw.Answer
    typealias Right = H.NewLaw.Answer
}
#endif

#if LOCAL_PHASE_INQUIRY_MIXES_SOURCES
enum RejectedPhaseInquiryOneSource: Pair {
    typealias H = PhaseLawMixedHistory<Never, Lit1, Lit2, Examples.Succ<Lit2>>
    typealias Both = JointEvidence<PhaseLawProbe0<H.Initial>,
        PhaseLawProbe1<FourLeafPhaseWord<Never, Lit1, Lit2, Examples.Succ<Lit2>>.Right>>
    typealias Left = Both.Left
    typealias Right = Both.Answer
}
#endif
