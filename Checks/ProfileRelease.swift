import VerificationIsIdentification
import Examples

#if !LOCAL_PHASE_RELEASE_SAME && !LOCAL_PHASE_RELEASE_MISSING
enum EntireFirstColumnCanRemainUnknown<A: Structure, B: Structure, C: Structure, D: Structure,
    K: Structure, L: Structure, M: Structure, N: Structure>: Null {
    typealias R = RectangularProfiles<A, B, C, D, K, L, M, N>
    typealias Left = Paired<R.EightActualValues.Left, R.SixSeparators.Left>
    typealias Right = Paired<R.EightActualValues.Right, R.SixSeparators.Right>
}

enum AcquiredRectangleSurvivesActualExchange<Z: Structure, K: Structure, V: Structure>: Null {
    typealias R = RectangularProfileExchange<Z, K, V>
    typealias F = R.CurrentSupportFactors
    typealias Left = AddressTriple<Paired<R.Actual.Left, R.Actual.Right>,
        Paired<F.Left.Left, F.Observation.Answer>, F.Left.Answer>
    typealias Right = AddressTriple<Paired<R.Root, R.After>,
        Paired<F.Observation.Left, F.Right.Left>, F.Right.Answer>
}

enum OldRecordDoesNotSelectReleaseBranch<K: Structure>: Null {
    typealias R = ProfileReleaseInquiry<K>
    typealias Left = AddressTriple<R.SameOldFacts.Left,
        R.EitherFirstQueryCanRemainAmbiguous.Left, R.MissingLastCellCanMerge.Left>
    typealias Right = AddressTriple<R.SameOldFacts.Right,
        R.EitherFirstQueryCanRemainAmbiguous.Right, R.MissingLastCellCanMerge.Right>
}
#endif

#if LOCAL_PHASE_RELEASE_SAME
enum RejectedDistinctRectangleRows: Null {
    typealias R = RectangularProfiles<Never, Never, Never, Never, Never, Never, Never, Never>
    typealias Left = LastTwoContactProfile<R.A>.Answer
    typealias Right = LastTwoContactProfile<R.C>.Answer
}
#endif

#if LOCAL_PHASE_RELEASE_MISSING
/// Omitting A2 leaves A/C with the same q1 and a possible identical image.
enum RejectedRectangleWithoutLastCell: Null {
    typealias R = ProfileReleaseInquiry<Never>
    typealias Left = ContactProfile<R.F01.A>.Q2.Answer
    typealias Right = ContactProfile<R.F11.A>.Q2.Answer
}
#endif
