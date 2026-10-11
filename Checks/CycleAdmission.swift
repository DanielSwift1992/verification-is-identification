import VerificationIsIdentification
import Examples

#if !CYCLE_ADMISSION_FALSE_ZERO && !CYCLE_ADMISSION_MIXED_SOURCE
enum CycleSupportsUseThePresentedFifteenContacts<A: Structure, B: Structure,
    C: Structure, D: Structure, E: Structure, F: Structure, G: Structure,
    H: Structure, I: Structure, J: Structure, K: Structure, L: Structure,
    M: Structure, N: Structure, O: Structure>: Null {
    typealias R = PetersenCycleReadings<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>
    typealias Left = R.Both.Answer
    typealias Right = Paired<Paired<K, Paired<C, Paired<H, Paired<B, G>>>>,
        Paired<M, Paired<D, Paired<A, Paired<F, J>>>>>
}

enum CycleChecksKeepTheSameRawSource<A: Structure, B: Structure,
    C: Structure, D: Structure, E: Structure, F: Structure, G: Structure,
    H: Structure, I: Structure, J: Structure, K: Structure, L: Structure,
    M: Structure, N: Structure, O: Structure>: Null {
    typealias R = PetersenCycleReadings<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>
    typealias Left = R.Both.Left
    typealias Right = R.Rows.Source
}

enum TheTwoAdditionalBitsSeparateAllFourHiddenCycleClasses: Null {
    typealias C = CycleAdmissionCases
    typealias Left = Paired<C.ZeroChecks.Answer, Paired<C.OuterChecks.Answer,
        Paired<C.InnerChecks.Answer, C.BothChecks.Answer>>>
    typealias Right = Paired<Paired<Never, Never>, Paired<Paired<Examples.Succ<Never>, Never>,
        Paired<Paired<Never, Examples.Succ<Never>>, Paired<Examples.Succ<Never>, Examples.Succ<Never>>>>>
}

enum ThePreviouslyHiddenTriangleHasAnAcquiredOddOuterCycle: Null {
    typealias C = CycleAdmissionCases
    typealias Left = Paired<C.TriangleChecks.Left, C.TriangleChecks.Answer>
    typealias Right = Paired<PetersenTriangleRecord.Rows.Source, Paired<Examples.Succ<Never>, Never>>
}

enum ARecordOfTheCycleChecksStillRetainsTheMatchingSource: Null {
    typealias C = CycleAdmissionCases
    typealias R = RecordReading<C.OuterChecks>
    typealias Left = Paired<R.Right.Left, R.Right.Right.Answer>
    typealias Right = Paired<C.OuterOnly.Rows.Source, Paired<Examples.Succ<Never>, Never>>
}
#endif

#if CYCLE_ADMISSION_FALSE_ZERO
enum RejectedTheHiddenTrianglePassesBothCycles: Null {
    typealias Left = CycleAdmissionCases.TriangleChecks.Answer
    typealias Right = Paired<Never, Never>
}
#endif

#if CYCLE_ADMISSION_MIXED_SOURCE
enum RejectedTheSecondCycleMayComeFromAnotherRawRecord: Null {
    typealias C = CycleAdmissionCases
    typealias Mixed = JointEvidence<C.OuterOne, C.ZeroInner>
    typealias Left = Mixed.Answer
    typealias Right = C.OuterChecks.Answer
}
#endif
