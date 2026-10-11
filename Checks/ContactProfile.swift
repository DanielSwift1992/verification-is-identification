import VerificationIsIdentification
import Examples

#if !LOCAL_PHASE_PROFILE_THIRD && !LOCAL_PHASE_PROFILE_PATTERN && !LOCAL_PHASE_PROFILE_SOURCE && !LOCAL_PHASE_PROFILE_RETURN && !LOCAL_PHASE_PROFILE_IMAGE_IDENTITY && !LOCAL_PHASE_PROFILE_ROTATION && !LOCAL_PHASE_PROFILE_SPARSE_PATTERN
enum AcquiredProfileSelectsResidentPayloads<K: Structure, A: Structure, B: Structure>: Null {
    typealias X = ContactProfileExperiment<K, A, B>
    typealias Left = Paired<X.ChosenPayloads.Left, X.KeepsBothPayloads.Left>
    typealias Right = Paired<X.ChosenPayloads.Right, X.KeepsBothPayloads.Right>
}

enum AcquiredProfileQuestionHasIndependentRawPositions<K: Structure>: Null {
    typealias X = ContactProfileExperiment<K, Never, Lit1>
    typealias Left = X.RawQuestion.Left
    typealias Right = X.RawQuestion.Right
}

enum ChangedUnreadImagesKeepLocalInputs<K: Structure, L: Structure, A: Structure, B: Structure>: Null {
    typealias X = ContactProfileTailChange<K, L, A, B>
    typealias Left = X.Left
    typealias Right = X.Right
}

enum AcquiredProfilesUseThirdObservation<K: Structure>: Null {
    typealias X = ContactProfileExperiment<K, Never, Lit1>
    typealias Left = Paired<X.TwoObservationsAgree.Left, X.ThirdObservationSeparates.Left>
    typealias Right = Paired<X.TwoObservationsAgree.Right, X.ThirdObservationSeparates.Right>
}

enum AcquiredProfilesAllowNonreturn: Null {
    typealias F = ContactProfileFamily<Never, Never, RoutingAddress01>
    typealias Left = Paired<F.PositiveReading.Left, Paired<F.A.Right, F.A.Left.Left.Left.Right>>
    typealias Right = Paired<Lit1, Paired<Never, Lit1>>
}

/// The four-image scope matters: a different outside image can share a
/// calibrated profile and still have a different actual continuation.
enum SameProfileDoesNotIdentifyEveryImage: Null {
    typealias A = ContactProfileChain<Never, Never, Never, RoutingAddress00>
    typealias B = ContactProfileChain<Never, Never, Never, RoutingAddress01>
    typealias Left = Paired<Paired<FactOf<ContactProfile<A>>, A.Left.Left.Left.Right>,
        Paired<FactOf<ContactProfile<B>>, B.Left.Left.Left.Right>>
    typealias ProfileFact = FactOf<ContactProfile<A>>
    typealias Right = Paired<Paired<ProfileFact, Never>, Paired<ProfileFact, Lit1>>
}

enum AnyOtherProfileSymbolsCanRemainUnknown<C: Structure, D: Structure, K: Structure>: Null {
    typealias F = ContactProfileFamily<C, D, K>
    typealias Left = Paired<F.ObservedPattern.Left, F.PositiveReading.Left>
    typealias Right = Paired<F.ObservedPattern.Right, F.PositiveReading.Right>
}

enum ProfileCollisionPropagates<P: Pair>: Null
where P.Left: Pair, P.Right: Pair,
      P.Left.Left: Structure, P.Left.Right: Structure,
      P.Right.Left: Structure, P.Right.Right: Structure,
      AddressTriple<P.Left.Right, P.Right.Left, P.Left.Left>
        == AddressTriple<P.Right.Left, P.Left.Left, P.Left.Right> {
    typealias Left = ProfileCollision23<P>.Left
    typealias Right = ProfileCollision23<P>.Right
}

enum NineReadingsRetainSixSeparators<X: Structure, Y: Structure, Z: Structure, K: Structure>: Null {
    typealias F = SparseContactProfileFamily<X, Y, Z, K>
    typealias Left = Paired<F.NineActualValues.Left, F.SixActualSeparators.Left>
    typealias Right = Paired<F.NineActualValues.Right, F.SixActualSeparators.Right>
}

enum UnreadProfileCellsKeepCalibration<X: Structure, Y: Structure, Z: Structure, K: Structure>: Null {
    typealias F = SameSparseCalibration<X, Y, Z, K, Never, Never, Never, Never>
    typealias Left = F.Left
    typealias Right = F.Right
}

enum NineCalibrationStillActs<K: Structure, A: Structure, B: Structure>: Null {
    typealias F = SparseContactProfileExperiment<K, A, B>
    typealias Left = AddressTriple<F.SameQueryFacts.Left, F.SameChosenPayloads.Left, F.KeepsBothPayloads.Left>
    typealias Right = AddressTriple<F.SameQueryFacts.Right, F.SameChosenPayloads.Right, F.KeepsBothPayloads.Right>
}

enum MandatoryCellsAllowActualMerger: Null {
    typealias F = MandatoryProfilesCanMerge
    typealias Left = Paired<F.SameAcquiredFact.Left, F.ActualMerger.Left>
    typealias Right = Paired<F.SameAcquiredFact.Right, F.ActualMerger.Right>
}
#endif

#if LOCAL_PHASE_PROFILE_THIRD
enum RejectedProfileThird: Null {
    typealias X = ContactProfileExperiment<Never, Never, Lit1>
    typealias Wrong = CompareContactProfiles<X.DifferentFact,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>,
        Route00<ContactProfileBitEquality>, Route11<ContactProfileBoth>>
    typealias Left = Wrong.Answer
    typealias Right = Lit1
}
#endif

#if LOCAL_PHASE_PROFILE_PATTERN
enum RejectedProfilePattern: Null {
    typealias A = ContactProfileChain<Never, Lit1, Never, Never>
    typealias B = ContactProfileChain<Never, Never, Never, Never>
    typealias C = ContactProfileChain<Lit1, Never, Never, Never>
    typealias Reading = FourContactProfiles<A, B, C, B>
    typealias Left = AcceptedContactProfiles<FactOf<Reading>>.Answer
    typealias Right = Lit1
}
#endif

#if LOCAL_PHASE_PROFILE_SOURCE
enum RejectedProfileSource: Null {
    typealias X = ContactProfileExperiment<RoutingAddress00, Never, Lit1>
    typealias Y = ContactProfileExperiment<RoutingAddress01, Never, Lit1>
    typealias Wrong = AcquireContactProfileComparison<Y.Different,
        X.DifferentCalibration, Y.DifferentProfiles>
    typealias Left = Wrong.Right.Right.Answer
    typealias Right = Y.DifferentFact.Answer
}
#endif

#if LOCAL_PHASE_PROFILE_RETURN
enum RejectedProfileReturn: Null {
    typealias F = ContactProfileFamily<Never, Never, RoutingAddress01>
    typealias Left = F.A.Left.Left.Left
    typealias Right = F.A
}
#endif

#if LOCAL_PHASE_PROFILE_IMAGE_IDENTITY
enum RejectedProfileImageIdentity: Null {
    typealias Left = ContactProfileChain<Never, Never, Never, RoutingAddress00>
    typealias Right = ContactProfileChain<Never, Never, Never, RoutingAddress01>
}
#endif

#if LOCAL_PHASE_PROFILE_ROTATION
enum RejectedProfileRotation: Null {
    typealias F = SparseContactProfileFamily<Lit1, Never, Never, Never>
    typealias Full = FourContactProfiles<F.A, F.B, F.C, F.D>
    typealias Left = AcceptedContactProfiles<FactOf<Full>>.Answer
    typealias Right = Lit1
}
#endif

#if LOCAL_PHASE_PROFILE_SPARSE_PATTERN
enum RejectedSparseProfilePattern: Null {
    typealias A = ContactProfileChain<Never, Lit1, Never, Never>
    typealias B = ContactProfileChain<Never, Never, Lit1, Never>
    typealias C = ContactProfileChain<Lit1, Never, Never, Never>
    typealias Reading = NineContactProfileReadings<A, B, C, B>
    typealias Left = AcceptedSparseContactProfiles<FactOf<Reading>>.Answer
    typealias Right = Lit1
}
#endif
