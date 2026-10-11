import VerificationIsIdentification
import Examples

#if !OVERLAPPING_READING_SPLIT
enum AllFifteenEdgesHaveTheSameTwoAddressedCopies<A: Structure, B: Structure,
    C: Structure, D: Structure, E: Structure, F: Structure, G: Structure,
    H: Structure, I: Structure, J: Structure, K: Structure, L: Structure,
    M: Structure, N: Structure, O: Structure>: Null {
    typealias R = PetersenContactRows<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>
    typealias Left = R.BothCopiesUseTheSource.Left
    typealias Right = R.BothCopiesUseTheSource.Right
}

enum FiveFullRowsCoverTheExcludedRawRow<A: Structure, B: Structure,
    C: Structure, D: Structure, E: Structure, F: Structure, G: Structure,
    H: Structure, I: Structure, J: Structure, K: Structure, L: Structure,
    M: Structure, N: Structure, O: Structure>: Null {
    typealias R = PetersenContactRows<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>
    typealias Left = R.ExcludedRawRowRemainsCovered.Left
    typealias Right = R.ExcludedRawRowRemainsCovered.Right
}

enum OneSharedContactChangesItsTwoRowsTogether<X: Structure, Y: Structure>: Null {
    typealias C = OneSharedContactChange<X, Y>
    typealias Left = Paired<C.BothAffectedRows.Left, C.OtherRowsArePreserved.Left>
    typealias Right = Paired<C.BothAffectedRows.Right, C.OtherRowsArePreserved.Right>
}

enum TheChangedSharedContactHasAnActualContrast: Null {
    typealias C = OneSharedContactChange<Never, Examples.Succ<Never>>
    typealias Left = Paired<C.Before.M0.Left, C.After.M1.Left>
    typealias Right = Paired<Never, Examples.Succ<Never>>
}

enum TheRefusedRawTriangleHasTheDisplayedEvenMatchingRows: Null {
    typealias Left = PetersenTriangleRecord.ActualEvenRows.Left
    typealias Right = PetersenTriangleRecord.ActualEvenRows.Right
}
#endif

#if OVERLAPPING_READING_SPLIT
enum RejectedTheSharedContactChangesInOnlyOneReading: Null {
    typealias C = OneSharedContactChange<Never, Examples.Succ<Never>>
    typealias Left = C.After.M0.Left
    typealias Right = C.Before.M1.Left
}
#endif
