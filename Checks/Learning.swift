import VerificationIsIdentification
import Examples

enum ConstantPredictionReturnsTraining<L: Null>: Null {
    typealias Left = SecondTableReading<L>.Answer
    typealias Right = L.Left
}

enum PredictedAnswersAgree<L: Null, R: Null>: Null
where L.Left == R.Left {
    typealias Left = PredictionsFromConstantTables<L, R>.Left.Answer
    typealias Right = PredictionsFromConstantTables<L, R>.Right.Answer
}

// The same observed first input occurs in a constant and a nonconstant law.
enum SameTrainingObservation: Null {
    typealias Left = ConstantTable<Never>.Left
    typealias Right = Paired<Never, ExperimentSignal>.Left
}

typealias LearnedConstantPrediction = ConstantPredictionReturnsTraining<ConstantTable<Never>>
typealias ConstantFamilyAgreement = PredictedAnswersAgree<ConstantTable<Never>, Never>

#if TRAINING_AGREEMENT_IMPLIES_TEST_AGREEMENT
typealias RejectedUnseenPrediction = JoinedVerdict<SecondTableReading<ConstantTable<Never>>, SecondTableReading<Paired<Never, ExperimentSignal>>>
#endif

#if OBSERVATION_PROVES_CONSTANT_FAMILY
typealias RejectedConstantFamily = PredictionsFromConstantTables<ConstantTable<Never>, Paired<Never, ExperimentSignal>>
#endif

// The answer is read from the output memory of the matched transition.
enum PreparedMemoryAnswersSource<T: Pair>: Null
where T.Left: Structure {
    typealias Left = PreparedFirstAnswerIsCertified<T>.Right.Answer
    typealias Right = T.Left
}

typealias AcquiredQuietAnswer = PreparedMemoryAnswersSource<Paired<ExperimentQuiet, ExperimentSignal>>

#if UNPREPARED_MEMORY_COUNTS_AS_READING
typealias RejectedUnpreparedReading = ReadyFirstMemory<Paired<ExperimentQuiet, ExperimentQuiet>>
#endif

#if ACQUIRED_FIRST_ANSWER_IS_SECOND
enum RejectedAcquiredSecond: Null {
    typealias Left = PreparedFirstAnswerIsCertified<Paired<ExperimentQuiet, ExperimentSignal>>.Right.Answer
    typealias Right = ExperimentSignal
}
#endif

#if SAME_MEMORY_VALUE_CHANGES_QUESTION
typealias RejectedMemoryQuestion = JoinedVerdict<
    ReadyFirstMemory<Paired<ExperimentSignal, ExperimentQuiet>>,
    SecondTableReading<ConstantTable<ExperimentQuiet>>
>
#endif
