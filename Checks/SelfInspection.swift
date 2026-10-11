import VerificationIsIdentification
import Examples

enum FirstSelfReading<T: Pair>: Null
where T.Left: Pair, T.Right: Pair {
    typealias Left = DiagonalReadings<T>.Left
    typealias Right = T.Left.Left
}

enum SecondSelfReading<T: Pair>: Null
where T.Left: Pair, T.Right: Pair {
    typealias Left = DiagonalReadings<T>.Right
    typealias Right = T.Right.Right
}

typealias RestrictedEvaluator = Paired<Paired<Never, Never>, Paired<Never, ExperimentSignal>>
typealias MissingDiagonalComplement = Paired<ExperimentSignal, Never>

enum ValidFiniteSelfApplication: Null {
    typealias Left = DiagonalReadings<RestrictedEvaluator>.Right
    typealias Right = ExperimentSignal
}

typealias FixedSwapRow<A: Structure, B: Structure> = Paired<Paired<A, A>, Paired<B, B>>
typealias FixedSwapEvaluator<A: Structure, B: Structure> = Paired<FixedSwapRow<A, B>, FixedSwapRow<A, B>>

enum FirstRepresentedSwapIsFixed<A: Structure, B: Structure>: Null {
    typealias Witness = FirstDiagonalFixedPoint<
        FixedSwapEvaluator<A, B>,
        SwapBoundaryReading<Paired<A, A>>,
        SwapBoundaryReading<Paired<B, B>>
    >
    typealias Left = Witness.Left
    typealias Right = Witness.Right
}

enum SecondRepresentedSwapIsFixed<A: Structure, B: Structure>: Null {
    typealias Witness = SecondDiagonalFixedPoint<
        FixedSwapEvaluator<A, B>,
        SwapBoundaryReading<Paired<A, A>>,
        SwapBoundaryReading<Paired<B, B>>
    >
    typealias Left = Witness.Left
    typealias Right = Witness.Right
}

typealias UnfixedSwapA = Paired<Never, ExperimentSignal>
typealias UnfixedSwapB = Paired<ExperimentSignal, Never>
typealias UnfixedSwapEvaluator = Paired<
    Paired<UnfixedSwapA, UnfixedSwapA>,
    Paired<UnfixedSwapA, UnfixedSwapB>
>

#if DIAGONAL_NONFIXED_FIRST_ROW
typealias RejectedUnfixedFirstRow = FirstDiagonalFixedPoint<
    UnfixedSwapEvaluator, SwapBoundaryReading<UnfixedSwapA>, SwapBoundaryReading<UnfixedSwapB>
>
#endif

#if DIAGONAL_NONFIXED_SECOND_ROW
typealias RejectedUnfixedSecondRow = SecondDiagonalFixedPoint<
    UnfixedSwapEvaluator, SwapBoundaryReading<UnfixedSwapA>, SwapBoundaryReading<UnfixedSwapB>
>
#endif

#if DIAGONAL_COMPLEMENT_HAS_CODE_ZERO
enum RejectedDiagonalCodeZero: Null {
    typealias Left = MissingDiagonalComplement.Left
    typealias Right = RestrictedEvaluator.Left.Left
}
#endif

#if DIAGONAL_COMPLEMENT_HAS_CODE_ONE
enum RejectedDiagonalCodeOne: Null {
    typealias Left = MissingDiagonalComplement.Right
    typealias Right = RestrictedEvaluator.Right.Right
}
#endif
