import VerificationIsIdentification
import Examples

// The common action identity is derived through Choice.Answer. The caller
// supplies no equality between Action.Predicate or the original answers.
enum AQCommonActionFollows<
    L: AdequateResidueContinuation,
    R: AdequateResidueContinuation
>: Null
where L.Choice == R.Choice {
    typealias Left = L.Action.Predicate
    typealias Right = R.Action.Predicate
}

enum AQSpace {}
enum AQEncoding {}
enum AQOriginalQuestion {}
enum AQInputQuestion {}
enum AQChoiceQuestion {}
enum AQHistoryQuestion {}
enum AQReady {}
enum AQChanged {}
enum AQEmptyHistory {}
enum AQExperimentHistory {}
enum AQPayloadA {}
enum AQPayloadB {}
enum AQCompleteInput {}
enum AQRestore {}
enum AQAlternateRestore {}
enum AQUnrelatedResidue {}

enum AQPair<A, B>: Pair {
    typealias Left = A
    typealias Right = B
}

enum AQState<P, Clock, History>: Pair {
    typealias Left = P
    typealias Right = AQPair<Clock, History>
}

typealias AQInitial<P> = AQState<P, AQReady, AQEmptyHistory>
typealias AQReached<P> = AQState<P, AQChanged, AQExperimentHistory>

enum AQReading<Source, Image, Question>: PredicateReading {
    typealias Left = Source
    typealias Right = Image
    typealias Sigma = AQSpace
    typealias Encoding = AQEncoding
    typealias Predicate = Question
    typealias Answer = Image
}

// The stipulated question uses payload and clock, and omits history.
enum AQQuestionAt<S: Pair>: PredicateReading
where S.Right: Pair {
    typealias Left = S
    typealias Right = AQPair<S.Left, S.Right.Left>
    typealias Sigma = AQSpace
    typealias Encoding = AQEncoding
    typealias Predicate = AQOriginalQuestion
    typealias Answer = Right
}

// The stipulated residue is the actual experiment history, read at both ends.
enum AQHistoryAt<S: Pair>: PredicateReading
where S.Right: Pair {
    typealias Left = S
    typealias Right = S.Right.Right
    typealias Sigma = AQSpace
    typealias Encoding = AQEncoding
    typealias Predicate = AQHistoryQuestion
    typealias Answer = Right
}

enum AQRetainedHistory<Y: Pair, Z: Pair>: VerdictIsInvariant
where Y.Right: Pair, Z.Right: Pair, Y.Right.Right == Z.Right.Right {
    typealias Left = AQHistoryAt<Y>
    typealias Right = AQHistoryAt<Z>
    typealias Sigma = AQSpace
    typealias Encoding = AQEncoding
    typealias Predicate = AQHistoryQuestion
    typealias Answer = Left.Answer
}

// The given action law changes the clock and retains payload and actual history.
// The finite model supplies this law for Restore and AlternateRestore.
enum AQActionAt<S: Pair, Program>: PredicateReading
where S.Right: Pair {
    typealias Left = S
    typealias Right = AQState<S.Left, AQReady, S.Right.Right>
    typealias Sigma = AQSpace
    typealias Encoding = AQEncoding
    typealias Predicate = Program
    typealias Answer = Right
}

enum AQRestored<P, Program>: AdequateResidueContinuation {
    typealias SourceResidue = AQPair<AQInitial<P>, AQReached<P>>
    typealias Input = AQReading<AQReached<P>, AQCompleteInput, AQInputQuestion>
    typealias Choice = AQReading<AQCompleteInput, Program, AQChoiceQuestion>
    typealias Action = AQActionAt<AQReached<P>, Program>
    typealias ResidueRecord = AQRetainedHistory<AQReached<P>, Action.Answer>
    typealias Left = AQQuestionAt<AQInitial<P>>
    typealias Right = AQQuestionAt<Action.Answer>
    typealias Sigma = AQSpace
    typealias Encoding = AQEncoding
    typealias Predicate = AQOriginalQuestion
    typealias Answer = Left.Answer
}

typealias AQFirst = AQRestored<AQPayloadA, AQRestore>
typealias AQSecond = AQRestored<AQPayloadB, AQRestore>
typealias AQCommonRows = CommonAdequateContinuationRows<AQFirst, AQSecond>
typealias AQDerivedAction = AQCommonActionFollows<AQFirst, AQSecond>
typealias AQAlternateRows = CommonAdequateContinuationRows<
    AQRestored<AQPayloadA, AQAlternateRestore>,
    AQRestored<AQPayloadB, AQAlternateRestore>
>

#if AQ_BAD_RESIDUE
enum AQRejectedResidue: AdequateResidueContinuation {
    typealias SourceResidue = AQFirst.SourceResidue
    typealias ResidueRecord = AQFirst.ResidueRecord
    typealias Input = AQFirst.Input
    typealias Choice = AQFirst.Choice
    typealias Action = AQReading<AQUnrelatedResidue, AQFirst.Action.Answer, AQRestore>
    typealias Left = AQFirst.Left
    typealias Right = AQFirst.Right
    typealias Sigma = AQSpace
    typealias Encoding = AQEncoding
    typealias Predicate = AQOriginalQuestion
    typealias Answer = Left.Answer
}
#endif

#if AQ_BAD_CHOICE
enum AQRejectedChoice: AdequateResidueContinuation {
    typealias SourceResidue = AQFirst.SourceResidue
    typealias ResidueRecord = AQFirst.ResidueRecord
    typealias Input = AQFirst.Input
    typealias Choice = AQReading<AQCompleteInput, AQAlternateRestore, AQChoiceQuestion>
    typealias Action = AQFirst.Action
    typealias Left = AQFirst.Left
    typealias Right = AQFirst.Right
    typealias Sigma = AQSpace
    typealias Encoding = AQEncoding
    typealias Predicate = AQOriginalQuestion
    typealias Answer = Left.Answer
}
#endif

#if AQ_BAD_ORIGINAL_ANSWER
enum AQRejectedOriginalAnswer: AdequateResidueContinuation {
    typealias SourceResidue = AQFirst.SourceResidue
    typealias ResidueRecord = AQFirst.ResidueRecord
    typealias Input = AQFirst.Input
    typealias Choice = AQFirst.Choice
    typealias Action = AQFirst.Action
    typealias Left = AQFirst.Left
    typealias Right = AQReading<AQFirst.Action.Answer, AQSecond.Answer, AQOriginalQuestion>
    typealias Sigma = AQSpace
    typealias Encoding = AQEncoding
    typealias Predicate = AQOriginalQuestion
    typealias Answer = Left.Answer
}
#endif

#if AQ_BAD_LOST_RESIDUE
// The original answer is restored, but the actual experiment history is erased.
enum AQRejectedLostResidue: AdequateResidueContinuation {
    typealias SourceResidue = AQFirst.SourceResidue
    typealias Input = AQFirst.Input
    typealias Choice = AQFirst.Choice
    typealias Action = AQReading<AQReached<AQPayloadA>, AQInitial<AQPayloadA>, AQRestore>
    typealias ResidueRecord = AQRetainedHistory<AQReached<AQPayloadA>, Action.Answer>
    typealias Left = AQFirst.Left
    typealias Right = AQQuestionAt<Action.Answer>
    typealias Sigma = AQSpace
    typealias Encoding = AQEncoding
    typealias Predicate = AQOriginalQuestion
    typealias Answer = Left.Answer
}
#endif
