import VerificationIsIdentification
import Examples

#if !LOCAL_PHASE_HANDOVER_RETIRED && !LOCAL_PHASE_HANDOVER_UNACQUIRED && !LOCAL_PHASE_HANDOVER_SOURCE
enum AcquiredReplacementAppliesAfterChange<A: Structure, D: Structure, K: Structure, V: Structure>: Null {
    typealias X = ProfileSupportHandover<A, D, K, V>
    typealias F = X.CurrentSupportFactors
    typealias Left = AddressTriple<Paired<X.Actual.Left, X.Actual.Right>,
        Paired<F.Left.Left, F.Observation.Answer>, F.Left.Answer>
    typealias Right = AddressTriple<Paired<X.Root, X.AfterShift>,
        Paired<F.Observation.Left, F.Right.Left>, F.Right.Answer>
}

enum HandoverKeepsSeparatorsAndHistory<A: Structure, D: Structure, K: Structure, V: Structure>: Null {
    typealias X = ProfileSupportHandover<A, D, K, V>
    typealias Left = AddressTriple<X.SixCurrentSeparators.Left,
        X.RetainedFacts.Left, X.ChangedCellAndPreservedReserve.Left>
    typealias Right = AddressTriple<X.SixCurrentSeparators.Right,
        X.RetainedFacts.Right, X.ChangedCellAndPreservedReserve.Right>
}

enum HandoverSwapIsReversible<A: Structure, D: Structure, K: Structure, V: Structure>: Null {
    typealias X = ProfileSupportHandover<A, D, K, V>.FullSwapReturns
    typealias Left = X.Left
    typealias Right = X.Right
}

enum UnusedReserveDoesNotEnterNewSupport<A: Structure, D: Structure, K: Structure, V: Structure,
    B: Structure, C: Structure, L: Structure, W: Structure>: Null {
    typealias X = ProfileSupportHandover<A, D, K, V>
    typealias Y = ProfileSupportHandover<B, C, L, W>
    typealias Left = Paired<X.CurrentSupportFactors.Observation.Answer,
        FactOf<X.CurrentReading>>
    typealias Right = Paired<Y.CurrentSupportFactors.Observation.Answer,
        FactOf<Y.CurrentReading>>
}

/// A change of support does not invalidate the old fact indiscriminately:
/// exchanging equal cell values preserves its applicability as well.
enum UnchangedRetiredCellStillSupportsOldReading<K: Structure>: Null {
    typealias X = ProfileSupportHandover<K, K, K, Never>
    typealias R = NineContactProfileReadings<X.UpdatedA, X.H.B, X.H.C, X.H.D>
    typealias Left = R.Answer
    typealias Right = X.F.Answer
}

enum SameOldSupportAllowsDifferentPostcontactAnswers<K: Structure>: Null {
    typealias X = MissingReplacementCanMerge<K>
    typealias Left = AddressTriple<X.SameOldFact.Left,
        X.ReplacementDiffers.Left, X.ActualMerger.Left>
    typealias Right = AddressTriple<X.SameOldFact.Right,
        X.ReplacementDiffers.Right, X.ActualMerger.Right>
}
#endif

#if LOCAL_PHASE_HANDOVER_RETIRED
/// The old fact remains historical evidence, but its changed A0 is no
/// longer a decoder of the old nine-cell question at the current root.
enum RejectedRetiredProfileFact: ReadingFactors {
    typealias X = ProfileSupportHandover<Never, Never, Never, Lit1>
    typealias R = NineContactProfileReadings<X.UpdatedA, X.H.B, X.H.C, X.H.D>
    typealias Memory = X.AfterShift.Left
    typealias Left = ReadFirstProfileSource<Memory, ReadFirstProfileSource<X.NewRoot, R>>
    typealias Observation = SecondEvidenceImage<Memory, BeamSpace, SaturationEncoding, SecondProjection>
    typealias Right = ReadRecordedAnswer<X.F>
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Predicate = R.Predicate
    typealias Answer = R.Answer
}
#endif

#if LOCAL_PHASE_HANDOVER_UNACQUIRED
/// Equal old facts admit different replacement readings. No function of
/// that old fact alone gives both of these independently specified answers.
enum RejectedUnacquiredProfileReplacement: Null {
    typealias X = MissingReplacementCanMerge<Never>
    typealias Left = ContactProfile<X.Good.C>.Q1.Answer
    typealias Right = ContactProfile<X.Other.C>.Q1.Answer
}
#endif

#if LOCAL_PHASE_HANDOVER_SOURCE
/// Matching value facts do not join acquisitions at different sources.
enum RejectedOtherProfileSource: Null {
    typealias X = ProfileSupportHandover<Never, Never, RoutingAddress00, Lit1>
    typealias Y = ProfileSupportHandover<Never, Never, RoutingAddress01, Lit1>
    typealias Wrong = FollowedPair<X.OldRecord, Y.ExtraRecord>
    typealias Left = Wrong.Right
    typealias Right = Y.AfterExtra
}
#endif
