import VerificationIsIdentification
import Examples

enum CyclicFirstReadingReturns<T: Pair>: Null
where T.Left: Structure, T.Right: Pair,
      T.Right.Left: Structure, T.Right.Right: Structure {
    typealias Left = RotateThree<RotateThree<RotateThree<T>>>.Left
    typealias Right = T.Left
}

enum CyclicSecondFieldReturns<T: Pair>: Null
where T.Left: Structure, T.Right: Pair,
      T.Right.Left: Structure, T.Right.Right: Structure {
    typealias Left = RotateThree<RotateThree<RotateThree<T>>>.Right.Left
    typealias Right = T.Right.Left
}

enum CyclicThirdFieldReturns<T: Pair>: Null
where T.Left: Structure, T.Right: Pair,
      T.Right.Left: Structure, T.Right.Right: Structure {
    typealias Left = RotateThree<RotateThree<RotateThree<T>>>.Right.Right
    typealias Right = T.Right.Right
}

typealias ThreeFieldTape = Paired<Never, Paired<ExperimentSignal, Never>>
typealias TapeReturnsFirst = CyclicFirstReadingReturns<ThreeFieldTape>
typealias TapeRetainsSecond = CyclicSecondFieldReturns<ThreeFieldTape>

#if CYCLIC_FOURTH_READING_CAN_DIFFER
enum RejectedFreshFourthReading: Null {
    typealias Left = RotateThree<RotateThree<RotateThree<ThreeFieldTape>>>.Left
    typealias Right = ExperimentSignal
}
#endif

#if CYCLIC_TAPE_ERASES_SECOND_FIELD
enum RejectedTapeErasure: Null {
    typealias Left = RotateThree<RotateThree<RotateThree<ThreeFieldTape>>>.Right.Left
    typealias Right = Never
}
#endif
