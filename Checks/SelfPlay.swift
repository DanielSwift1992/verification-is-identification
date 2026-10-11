import VerificationIsIdentification
import Examples

enum SyntheticKeepsObservedField<T: Pair>: Null
where T.Left: Structure {
    typealias Left = SyntheticConstantRecord<T>.Right.Right.Left
    typealias Right = T.Left
}

enum SyntheticPredictionUsesOldReading<T: Pair>: Null
where T.Left: Structure {
    typealias Left = SyntheticConstantRecord<T>.Right.Right.Right
    typealias Right = T.Left
}

enum SyntheticRetainsActualLaw<T: Pair>: Null
where T.Left: Structure {
    typealias Left = SyntheticConstantRecord<T>.Right.Left
    typealias Right = T
}

enum SameReadingGeneratesSameTable<L: Pair, R: Pair>: Null
where L.Left: Structure, L.Left == R.Left {
    typealias Left = SyntheticConstantRecord<L>.Right.Right
    typealias Right = SyntheticConstantRecord<R>.Right.Right
}

typealias SameSyntheticDataAcrossActualLaws = SameReadingGeneratesSameTable<Paired<Never, Never>, Paired<Never, ExperimentSignal>>
typealias ActualLawSurvivesSelfLabeling = SyntheticRetainsActualLaw<Paired<Never, ExperimentSignal>>

#if SELF_LABEL_CERTIFIES_ACTUAL_SECOND_ANSWER
enum RejectedSelfLabelAsMeasurement: Null {
    typealias Actual = Paired<Never, ExperimentSignal>
    typealias Left = SyntheticConstantRecord<Actual>.Right.Right.Right
    typealias Right = SecondTableReading<Actual>.Answer
}
#endif
