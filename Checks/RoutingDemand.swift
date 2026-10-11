import VerificationIsIdentification
import Examples

enum DemandOneCoordinateAllData<A: Structure, C: Structure, B: Structure, D: Structure>: Null {
    typealias X = BoundaryWorking<A, C, B, D>
    typealias Left = RepeatedFirstFromObservation<X>.Answer
    typealias Right = BoundaryWorking<A, A, A, A>
}
enum DemandDecoderHasOnlyLawAndOneValue<A: Structure, C: Structure, B: Structure, D: Structure>: Null {
    typealias X = BoundaryWorking<A, C, B, D>
    typealias Left = RepeatedFirstFromObservation<X>.Right.Left
    typealias Right = Paired<FactOf<RoutingProbeImages<RepeatedFirstRouting>>, A>
}
enum DemandUnusedCoordinatesAbsentFromDecoder<A: Structure, C: Structure, B: Structure, D: Structure>: Null {
    typealias Left = RepeatedFirstFromObservation<BoundaryWorking<A, C, B, D>>.Right
    typealias Right = RepeatedFirstFromObservation<BoundaryWorking<A, Never, Never, Never>>.Right
}

enum DemandOpaqueBranch: Close {}
enum DemandDoesNotRequireUnusedBranchShape<A: Structure>: Null {
    typealias X = Paired<Paired<A, DemandOpaqueBranch>, DemandOpaqueBranch>
    typealias Left = RepeatedFirstFromObservation<X>.Right
    typealias Right = RepeatedFirstFromObservation<BoundaryWorking<A, Never, Never, Never>>.Right
}

typealias DemandZeroInput = BoundaryWorking<Never, Never, Never, Never>
typealias DemandFirstOne = BoundaryWorking<Lit1, Never, Never, Never>
typealias DemandSecondOne = BoundaryWorking<Never, Lit1, Never, Never>
typealias DemandZeroFactor = RepeatedFirstFromObservation<DemandZeroInput>
typealias DemandOneFactor = RepeatedFirstFromObservation<DemandFirstOne>
typealias DemandOneReadNecessary = ZeroSuccessorBoundary<FirstEvidenceImage<DemandZeroFactor.Answer.Left, BeamSpace, SaturationEncoding, RoutedValueQuestion>, FirstEvidenceImage<DemandOneFactor.Answer.Left, BeamSpace, SaturationEncoding, RoutedValueQuestion>, Never>

// The same restricted data observation cannot predict identity's entire
// output. Its law fact is correct and fixed across the two actual inputs.
typealias DemandIdentityZero = RoutingApplication<IdentityRouting, DemandZeroInput, Route00<DemandZeroInput>, Route01<DemandZeroInput>, Route10<DemandZeroInput>, Route11<DemandZeroInput>>
typealias DemandIdentitySecond = RoutingApplication<IdentityRouting, DemandSecondOne, Route00<DemandSecondOne>, Route01<DemandSecondOne>, Route10<DemandSecondOne>, Route11<DemandSecondOne>>
enum DemandSameRestrictedObservationDifferentIdentityOutput: Null {
    typealias Left = PairedSourceReadings<AcquireAnswer<RoutingProbeImages<IdentityRouting>>.Observation, FirstDataCoordinate<DemandZeroInput>>.Answer
    typealias Right = PairedSourceReadings<AcquireAnswer<RoutingProbeImages<IdentityRouting>>.Observation, FirstDataCoordinate<DemandSecondOne>>.Answer
}
typealias DemandIdentityNeedsOmittedValue = ZeroSuccessorBoundary<SecondEvidenceImage<DemandIdentityZero.Answer.Left, BeamSpace, SaturationEncoding, RoutedValueQuestion>, SecondEvidenceImage<DemandIdentitySecond.Answer.Left, BeamSpace, SaturationEncoding, RoutedValueQuestion>, Never>

#if DEMAND_FIRST_SUFFICES_FOR_IDENTITY
enum RejectedDemandIdentity: Null {
    typealias Left = DemandIdentityZero.Answer
    typealias Right = DemandIdentitySecond.Answer
}
#endif
#if DEMAND_NO_DATA_NEEDED
enum RejectedDemandNoData: Null {
    typealias Left = DemandZeroFactor.Answer
    typealias Right = DemandOneFactor.Answer
}
#endif
#if DEMAND_DIFFERENT_LAW_FACT
typealias RejectedDemandLaw = RepeatFromFirstRecord<Paired<FactOf<RoutingProbeImages<IdentityRouting>>, Never>>
#endif
#if DEMAND_LAW_FACT_IS_DATA
typealias RejectedDemandMissing = RepeatFromFirstRecord<FactOf<RoutingProbeImages<RepeatedFirstRouting>>>
#endif
#if DEMAND_SWAPPED_ARGUMENTS
typealias RejectedDemandLayout = RepeatFromFirstRecord<Paired<Never, FactOf<RoutingProbeImages<RepeatedFirstRouting>>>>
#endif
#if DEMAND_RECOVERS_UNREAD_COORDINATE
enum RejectedDemandUnread: Null {
    typealias X = BoundaryWorking<Never, Lit1, Never, Never>
    typealias Left = RepeatedFirstFromObservation<X>.Right.Left.Right
    typealias Right = X.Left.Right
}
#endif
#if DEMAND_INVENTS_UNUSED_BRANCH_READ
typealias RejectedDemandShape = Route10<Paired<Paired<Never, DemandOpaqueBranch>, DemandOpaqueBranch>>
#endif
