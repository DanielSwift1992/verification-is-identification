import VerificationIsIdentification
import Examples

// Two actual neighboring preparations at leaf zero. Their first three stage
// records coincide; the fourth reaches center in only the second history.
enum FourReadingBoundary {
    typealias C = FourLeafControlOrbit<Never>
    typealias First = AcquiredFourFirstFields<C.S1, C.S2, C.S3>
    typealias Second = AcquiredFourFirstFields<C.S2, C.S3, C.S4>
    typealias M = First.Observation.Answer
    typealias N = Second.Observation.Answer
}

enum FourReadingSameFirstThreeFacts: Null {
    typealias F = FourReadingBoundary
    typealias Left = Paired<F.M.Left, Paired<F.M.Right.Left, F.M.Right.Right.Left>>
    typealias Right = Paired<F.N.Left, Paired<F.N.Right.Left, F.N.Right.Right.Left>>
}

// The complete seven-command program is also the same. It contains no
// private initial-phase parameter that could distinguish the two histories.
enum FourReadingSameResidentTape: Null {
    typealias F = FourReadingBoundary
    typealias Left = F.First.Tape
    typealias Right = F.Second.Tape
}

enum FourReadingFourthFactSeparates: Null {
    typealias F = FourReadingBoundary
    typealias Left = Paired<F.M.Right.Right.Right.Answer.Left, F.N.Right.Right.Right.Answer.Left>
    typealias Right = Paired<Never, Lit1>
}

// The relevant initial question already differs while those three records
// agree: the phase marker at position one, not a nominal source-name test.
enum FourReadingUnmeasuredInitialDifference: Null {
    typealias C = FourReadingBoundary.C
    typealias Left = Paired<C.S1.Left.Right.Left.Left.Right, C.S2.Left.Right.Left.Left.Right>
    typealias Right = Paired<Lit1, Never>
}

enum FourReadingActuallyAcquiresTheFourWindow: Null {
    typealias F = FourReadingBoundary
    typealias L = FourLeafStageLabels<Never, Lit1, Never, Never, Never>
    typealias Left = Paired<F.First.Right.Answer, F.Second.Right.Answer>
    typealias Right = Paired<Paired<L, Paired<L, Paired<L, L>>>,
        Paired<L, Paired<L, Paired<L, FourLeafCenter>>>>
}

enum FourReadingKeepsCurrentTargetAndPast: Null {
    typealias F = FourReadingBoundary.First
    typealias C = FourReadingBoundary.C
    typealias Left = Paired<F.Path.Answer.Left.Left.Left.Left.Left,
        Paired<F.Path.Answer.Right.Left, F.Path.Answer.Right.Right>>
    typealias Right = Paired<C.S3.Answer, Paired<Never, F.Past7>>
}

#if LOCAL_PHASE_THREE_RECORDS_COMPLETE_WINDOW
enum RejectedFourReadingThreeFactsAreComplete: Null {
    typealias F = FourReadingBoundary
    typealias Left = F.First.Right.Answer
    typealias Right = F.Second.Right.Answer
}
#endif

#if LOCAL_PHASE_FOUR_READING_USES_OLD_SOURCE
enum RejectedFourReadingOldThirdSource: Pair {
    typealias C = FourReadingBoundary.C
    typealias Wrong = AcquiredFourFirstFields<C.S1, C.S2, C.S0>
    typealias Left = Wrong.Path.Left
    typealias Right = Wrong.Path.Answer
}
#endif
