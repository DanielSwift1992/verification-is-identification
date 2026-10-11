import VerificationIsIdentification
import Examples

enum ExcursionIntermediateActions<A: Structure, B: Structure,
    C: Structure, D: Structure>: Close {
    typealias T = FourLeafPhase0<A, B, C, D>
    typealias W = FourLeafPhaseWord<A, B, C, D>
    typealias TW = FollowedPair<T, FourLeafPhaseWord<B, A, C, D>>
    typealias WT = FollowedPair<W, FourLeafPhase0<D, B, A, C>>
}

#if !LOCAL_PHASE_EXCURSION_INTERMEDIATE_APPLICABLE && !LOCAL_PHASE_EXCURSION_TWO_READS_SUFFICE && !LOCAL_PHASE_EXCURSION_RETURN_ERASES_RECORDS && !LOCAL_PHASE_EXCURSION_MERGES_POSITIVE_MEMORY
enum ExcursionReturnsSourceWithFacts<A: Structure, B: Structure,
    C: Structure, D: Structure, K: Structure>: Null {
    typealias E = PhaseProbeExcursion<A, B, C, D>
    typealias Whole = StepBeside<E, K>
    typealias Left = AddressTriple<E.Actual.Right.Left.Left.Left,
        E.AcquiredPoints.Left, Whole.Right.Right>
    typealias Right = AddressTriple<E.Initial, AddressTriple<A, D, C>, K>
}

enum ExcursionCalibratedVerdicts: Null {
    typealias E = PhaseExcursionCalibration
    typealias Left = Paired<E.Verdicts.Left, E.PositiveSources.Left>
    typealias Right = Paired<E.Verdicts.Right, E.PositiveSources.Right>
}

enum ExcursionChangesIntermediateQuestion<A: Structure, B: Structure,
    C: Structure, D: Structure>: Null {
    typealias E = ExcursionIntermediateActions<A, B, C, D>
    typealias Left = Paired<E.TW.Right, E.WT.Right>
    typealias Right = Paired<BoundaryWorking<D, A, B, C>, BoundaryWorking<B, D, A, C>>
}

// Actual first and second records agree. The third resolves identity versus
// the exchange 1/2, whose acquired verdicts are opposite.
enum ExcursionTwoRecordsCollide: Null {
    typealias I = PhaseExcursionCalibration.P0123
    typealias N = PhaseExcursionCalibration.P0213
    typealias Left = AddressTriple<I.Decode.Left.Left.Left,
        I.Decode.Left.Left.Right.Left, Paired<I.Read.Answer, N.Read.Answer>>
    typealias Right = AddressTriple<N.Decode.Left.Left.Left,
        N.Decode.Left.Left.Right.Left, Paired<Lit1, Never>>
}

enum ExcursionPositiveMemoriesDiffer: Null {
    typealias I = PhaseExcursionCalibration.P0123
    typealias W = PhaseExcursionCalibration.P3102
    typealias Left = AddressTriple<I.Decode.Left.Left.Left.Answer,
        W.Decode.Left.Left.Left.Answer, Paired<I.Read.Answer, W.Read.Answer>>
    typealias Right = AddressTriple<RoutingAddress00, RoutingAddress11, Paired<Lit1, Lit1>>
}
#endif

#if LOCAL_PHASE_EXCURSION_INTERMEDIATE_APPLICABLE
enum RejectedExcursionIntermediateApplicability: Null {
    typealias E = ExcursionIntermediateActions<RoutingAddress00,
        RoutingAddress01, RoutingAddress10, RoutingAddress11>
    typealias Left = E.TW.Right
    typealias Right = E.WT.Right
}
#endif

#if LOCAL_PHASE_EXCURSION_TWO_READS_SUFFICE
enum RejectedExcursionTwoReadings: Null {
    typealias Left = PhaseExcursionCalibration.P0123.Read.Answer
    typealias Right = PhaseExcursionCalibration.P0213.Read.Answer
}
#endif

#if LOCAL_PHASE_EXCURSION_RETURN_ERASES_RECORDS
enum RejectedExcursionErasesRecords: Null {
    typealias E = PhaseProbeExcursion<RoutingAddress00,
        RoutingAddress01, RoutingAddress10, RoutingAddress11>
    typealias Left = E.Actual.Right
    typealias Right = E.Initial
}
#endif

#if LOCAL_PHASE_EXCURSION_MERGES_POSITIVE_MEMORY
enum RejectedExcursionMergesPositiveMemory: Null {
    typealias Left = PhaseExcursionCalibration.P0123.Decode.Left
    typealias Right = PhaseExcursionCalibration.P3102.Decode.Left
}
#endif
