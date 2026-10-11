import VerificationIsIdentification
import Examples

enum ObservationRetainsSource<S: Pair>: Null
where S.Left: Structure {
    typealias Left = PreparedObservation<S>.Right.Left
    typealias Right = PreparedObservation<S>.Left.Left
}

enum ObservationReadsDeclaredField<S: Pair>: Null
where S.Left: Structure {
    typealias Left = PreparedObservation<S>.Right.Right.Right
    typealias Right = S.Left
}

enum ObservationMarksReadiness<S: Pair>: Null
where S.Left: Structure {
    typealias Left = PreparedObservation<S>.Right.Right.Left
    typealias Right = ExperimentSignal
}

// B and C have equal question fields and different residual structure.
enum RareSourceB: Pair {
    typealias Left = ExperimentSignal
    typealias Right = Never
}
enum RareSourceC: Pair {
    typealias Left = ExperimentSignal
    typealias Right = Paired<Never, Never>
}

enum EqualRareReadings: Null {
    typealias Left = PreparedObservation<RareSourceB>.Right.Right.Right
    typealias Right = PreparedObservation<RareSourceC>.Right.Right.Right
}

#if OBSERVATION_WITHOUT_PREPARATION
enum RejectedUnpreparedObservation: Null {
    typealias Left = PreparedObservation<RareSourceB>.Left.Right.Right
    typealias Right = ExperimentSignal
}
#endif

#if EQUAL_READING_ERASES_RESIDUAL
enum RejectedObservationResidualMerger: Null {
    typealias Left = PreparedObservation<RareSourceB>.Right.Left.Right
    typealias Right = PreparedObservation<RareSourceC>.Right.Left.Right
}
#endif
