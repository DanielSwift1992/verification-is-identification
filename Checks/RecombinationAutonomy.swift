import VerificationIsIdentification
import Examples

/// A locally returning reading whose next addressed return already fails.
/// The source itself is one reversible five-cycle.
enum DelayedFrameDrift: Close {
    enum A: Pair {
        typealias Left = B
        typealias Right = Never
    }
    enum B: Pair {
        typealias Left = C
        typealias Right = Never
    }
    enum C: Pair {
        typealias Left = D
        typealias Right = Never
    }
    enum D: Pair {
        typealias Left = E
        typealias Right = Never
    }
    enum E: Pair {
        typealias Left = A
        typealias Right = Examples.Succ<Never>
    }
}

#if !LOCAL_PHASE_CUT_FIRST && !LOCAL_PHASE_CUT_SECOND && !LOCAL_PHASE_CUT_RETURN && !LOCAL_PHASE_CUT_STATIONARY && !LOCAL_PHASE_CUT_RECORD
enum TheCurrentAndFutureAnswersUseTheirActualPaths<N: Pair>: Null
where N.Left: Pair, N.Right: Structure, N.Left.Right: Structure {
    typealias Left = PresentAndNext<N>.Endpoint.Left
    typealias Right = PresentAndNext<N>.Endpoint.Right
}

enum AReadingReturnDerivesTheFrameUpdate<N: Pair>: Null
where N.Left: Pair, N.Left.Left: Pair, N.Left.Left.Left: Pair,
      N.Right: Structure, N.Left.Right: Structure, N.Left.Left.Right: Structure,
      N.Left.Left.Left.Right == N.Right {
    typealias Left = ThreeReadingReturnFrame<N>.Left
    typealias Right = ThreeReadingReturnFrame<N>.Right
}

enum EveryActualSourceReturns<A: Structure, B: Structure>: Null {
    typealias C = ThreeCycleWithFixed<A, B>
    typealias Left = C.AllReturns.Left
    typealias Right = C.AllReturns.Right
}

enum TheTemporalPairsCoverAllFourCodes<A: Structure, B: Structure>: Null {
    typealias C = ThreeCycleWithFixed<A, B>
    typealias Left = C.TemporalTable.Left
    typealias Right = C.TemporalTable.Right
}

enum TheRotationIsDerivedAtAllFourSources<A: Structure, B: Structure>: Null {
    typealias C = ThreeCycleWithFixed<A, B>
    typealias P = ThreeReadingReturnFrame<C.P>
    typealias Q = ThreeReadingReturnFrame<C.Q>
    typealias R = ThreeReadingReturnFrame<C.R>
    typealias F = ThreeReadingReturnFrame<C.F>
    typealias Left = Paired<Paired<P.Left, Q.Left>, Paired<R.Left, F.Left>>
    typealias Right = Paired<Paired<P.Right, Q.Right>, Paired<R.Right, F.Right>>
}

enum BothSingleChannelsHaveActualContrasts: Null {
    typealias C = ThreeCycleWithFixed<Never, Examples.Succ<Never>>
    typealias Left = Paired<C.FirstChannelContrast.Left, C.SecondChannelContrast.Left>
    typealias Right = Paired<C.FirstChannelContrast.Right, C.SecondChannelContrast.Right>
}

enum TheTwoAcquisitionsReturnOnlyTheWorkingSource<N: Pair, H: Structure>: Null
where N.Left: Pair, N.Left.Left: Pair, N.Left.Left.Left == N,
      N.Right: Structure, N.Left.Right: Structure {
    typealias C = RecordThreeCycle<N, H>
    typealias Left = C.Endpoint.Left
    typealias Right = C.Endpoint.Right
}

enum TheDecoderConsumesTheTwoAcquiredFacts<N: Pair, H: Structure>: Null
where N.Left: Pair, N.Left.Left: Pair, N.Left.Left.Left == N,
      N.Right: Structure, N.Left.Right: Structure {
    typealias C = RecordThreeCycle<N, H>
    typealias Left = Paired<C.OnlyTheFactsEnterTheDecoder.Left, C.FactsRecoverTheTemporalPair.Left>
    typealias Right = Paired<C.OnlyTheFactsEnterTheDecoder.Right, C.FactsRecoverTheTemporalPair.Right>
}

enum EverySourceHasTheReturningAcquisition<A: Structure, B: Structure, H: Structure>: Null {
    typealias C = ThreeCycleWithFixed<A, B>
    typealias P = RecordThreeCycle<C.P, H>
    typealias Q = RecordThreeCycle<C.Q, H>
    typealias R = RecordThreeCycle<C.R, H>
    typealias F = RecordThreeCycle<C.F, H>
    typealias Left = Paired<Paired<P.Decoded.Answer, Q.Decoded.Answer>,
        Paired<R.Decoded.Answer, F.Decoded.Answer>>
    typealias Right = C.TemporalTable.Right
}

enum TheTransportedReadingHasTheOldAnswer<N: Pair>: Null
where N.Left: Pair, N.Left.Left: Pair, N.Left.Left.Left == N,
      N.Right: Structure, N.Left.Right: Structure {
    typealias C = TransportThreeCycleReading<N>
    typealias Left = C.AnswerReturns.Left
    typealias Right = C.AnswerReturns.Right
}

enum OneCertifiedFrameStepCanPrecedeAnActualDrift: Null {
    typealias A = ThreeReadingReturnFrame<DelayedFrameDrift.A>
    typealias B = ThreeContactObservation<DelayedFrameDrift.B>
    typealias C = ThreeContactObservation<DelayedFrameDrift.C>
    typealias Zero = AddressTriple<Never, Never, Never>
    typealias Different = AddressTriple<Never, Never, Examples.Succ<Never>>
    typealias Left = Paired<Paired<A.Before.Reading.Answer, B.Reading.Answer>,
        Paired<A.Left, C.Reading.Answer>>
    typealias Right = Paired<Paired<Zero, Zero>, Paired<Zero, Different>>
}
#endif

#if LOCAL_PHASE_CUT_FIRST
enum RejectedTheFirstBitHasItsOwnNextBit: Null {
    typealias C = ThreeCycleWithFixed<Never, Examples.Succ<Never>>
    typealias Left = C.P.Left.Right
    typealias Right = C.Q.Left.Right
}
#endif

#if LOCAL_PHASE_CUT_SECOND
enum RejectedTheSecondBitHasItsOwnNextBit: Null {
    typealias C = ThreeCycleWithFixed<Never, Examples.Succ<Never>>
    typealias Left = C.P.Left.Left.Right
    typealias Right = C.R.Left.Left.Right
}
#endif

#if LOCAL_PHASE_CUT_RETURN
enum RejectedAnUnreturnedQuestionHasTheCyclicFrame: Null {
    typealias C = ThreeReadingReturnFrame<DelayedFrameDrift.B>
    typealias Left = C.Left
    typealias Right = C.Right
}
#endif

#if LOCAL_PHASE_CUT_STATIONARY
enum RejectedTransportPreservesTheStationaryReading: Null {
    typealias C = ThreeCycleWithFixed<Never, Examples.Succ<Never>>
    typealias T = TransportThreeCycleReading<C.Q>
    typealias Left = T.Transported.Answer
    typealias Right = T.Old.AtNext.Answer
}
#endif

#if LOCAL_PHASE_CUT_RECORD
enum RejectedTheNextFactIsTheRestoredCurrentAnswer: Null {
    typealias C = ThreeCycleWithFixed<Never, Examples.Succ<Never>>
    typealias R = RecordThreeCycle<C.Q, Never>
    typealias Left = R.F1.Answer
    typealias Right = R.Result.Left.Right
}
#endif
