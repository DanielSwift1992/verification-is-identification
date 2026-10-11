import VerificationIsIdentification
import Examples

#if !LOCAL_PHASE_CONTACT_DIAGRAM_OPEN_MERGE && !LOCAL_PHASE_CONTACT_DIAGRAM_EXTRA_RETURN && !LOCAL_PHASE_CONTACT_DIAGRAM_EXTENT
enum GenericContactClosure<T: TwoAndThreeStepReturn>: Null {
    typealias Left = ReturnsForceFixedPoint<T>.Left
    typealias Right = ReturnsForceFixedPoint<T>.Right
}

enum ContactIdentityControlsOtherReadings<T: Pair>: Null where T.Left == T {
    typealias Left = FixedPointForcesSecondReading<T>.Left
    typealias Right = FixedPointForcesSecondReading<T>.Right
}

enum OneDiagramDifferentIdentityAnswers: Null {
    typealias C = UnsettledContactIdentity
    typealias Left = Paired<C.SameAcquiredFact.Left, C.AlternatingContrast.Left>
    typealias Right = Paired<C.SameAcquiredFact.Right, C.AlternatingContrast.Right>
}

enum PositiveContactRecordRetainsSource<K: Structure>: Null {
    typealias R = UnsettledContactIdentity.AlternatingRecord
    typealias Path = StepBeside<R, K>
    typealias Left = Paired<Path.Right.Left.Left, Path.Right.Right>
    typealias Right = Paired<AlternatingContactModel, K>
}

enum ExtraReturnIsCompatible: Null {
    typealias Left = ReturnsForceFixedPoint<FixedContactModel>.Left
    typealias Right = ReturnsForceFixedPoint<FixedContactModel>.Right
}

enum EqualOutgoingReadings: Null {
    typealias F = MatchingSuccessorsModel
    typealias Left = Paired<F.SameSuccessors.Left, F.AdditionalReadingSeparates.Left>
    typealias Right = Paired<F.SameSuccessors.Right, F.AdditionalReadingSeparates.Right>
}
#endif

#if LOCAL_PHASE_CONTACT_DIAGRAM_OPEN_MERGE
enum RejectedContactDiagramOpenMerge: Null {
    typealias Left = UnsettledContactIdentity.OriginalSecond.Answer
    typealias Right = UnsettledContactIdentity.NextSecond.Answer
}
#endif

#if LOCAL_PHASE_CONTACT_DIAGRAM_EXTRA_RETURN
enum RejectedContactDiagramExtraReturn: Null {
    typealias Left = AlternatingContactModel.Left.Left.Left
    typealias Right = AlternatingContactModel
}
#endif

#if LOCAL_PHASE_CONTACT_DIAGRAM_EXTENT
enum RejectedContactDiagramExtent: Null {
    typealias Left = MatchingSuccessorsModel.ProbeA.Answer
    typealias Right = MatchingSuccessorsModel.ProbeB.Answer
}
#endif
