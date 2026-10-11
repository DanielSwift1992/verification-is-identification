import VerificationIsIdentification
import Examples

// These are actual selected contacts at the two ends, not arithmetic on an
// externally evaluated trajectory. The twenty-fourth internal move reaches
// the last declared phase; the next contact exits the observed leaf.
enum AlternatingLineResidenceAndExit<K: Structure>: Null {
    typealias T = AlternatingLineTravel<K>
    typealias P = TwentyFivePhaseLine
    typealias Left = Paired<T.Up.Answer, T.BeforeExit.Answer>
    typealias Right = Paired<
        LocalPhaseWorld<FourLeafStageLabels<Never, Lit1, Never, Never, Never>, P.Top, K>,
        LocalPhaseWorld<FourLeafCenter, P.Top, K>>
}

enum AlternatingLineActualReturnHasVisibleContinuation<K: Structure>: Null {
    typealias W = AlternatingLineDelayedWitness<K>
    typealias Left = Paired<W.C.Up.Answer.Left.Left, W.WithReturn.Answer.Left.Left>
    typealias Right = Paired<Never, Lit1>
}

enum AlternatingLineMatchingEndsAreFixed: Null {
    typealias P = TwentyFivePhaseLine
    typealias Left = Paired<P.FirstAtTop.Answer, P.SecondAtBottom.Answer>
    typealias Right = Paired<P.Top, P.Bottom>
}

// Projection can erase the very update that made the long residence possible.
// The projected substitute is defined independently and has the same source.
enum AlternatingLineProjectedSubstitute<K: Structure>: Close {
    typealias P = AlternatingPhaseCell<TwentyFivePhaseLine.J0>
    typealias Actual = AlternatingLineSteps<TwentyFivePhaseLine.J0, K>.UpFirst
    typealias Substitute = PairedApplication<FourLeafStage1<Never, Lit1, Never, Never, Never>,
        ExperimentReadingBeside<IdentityReading<P.Even, BeamSpace, SaturationEncoding>, K>>
    enum SameSourceAndStageAnswer: Null {
        typealias Left = Paired<Actual.Left, Actual.Answer.Left>
        typealias Right = Paired<Substitute.Left, Substitute.Answer.Left>
    }
}

#if LOCAL_PHASE_LINE_STAGE_RETURN_IS_FULL_RETURN
enum RejectedAlternatingLineFullReturn: Null {
    typealias R = AlternatingLineReturn<TwentyFivePhaseLine.J0, Never>
    typealias Left = R.Left
    typealias Right = R.Answer
}
#endif

#if LOCAL_PHASE_LINE_PROJECTED_CONTACT_IS_ACTUAL
enum RejectedAlternatingLineProjectedContact: Null {
    typealias S = AlternatingLineProjectedSubstitute<Never>
    typealias Left = S.Actual.Answer
    typealias Right = S.Substitute.Answer
}
#endif

#if LOCAL_PHASE_LINE_MATCHING_CONTINUES_PAST_TOP
enum RejectedAlternatingLinePastTop: Null {
    typealias P = TwentyFivePhaseLine
    typealias Left = P.FirstAtTop.Answer
    typealias Right = AlternatingPhaseCell<P.J12>.WithinUp.Answer
}
#endif
