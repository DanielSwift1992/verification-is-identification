import VerificationIsIdentification
import Examples

#if !LOCAL_PHASE_CYCLIC_REPEAT && !LOCAL_PHASE_CYCLIC_ENDPOINT && !LOCAL_PHASE_CYCLIC_RETURN && !LOCAL_PHASE_CYCLIC_PARTNER
enum CyclicChangeHasActualRepeatedEndpoints<A: Structure, B: Structure, C: Structure>: Null {
    typealias R = CyclicProfileRepeatBoundary<A, B, C>
    typealias Left = R.ActualEndpoints.Left
    typealias Right = R.ActualEndpoints.Right
}

enum FirstCyclicChangePreservesTheCompleteGrid<A: Structure, B: Structure, C: Structure>: Null {
    typealias R = CyclicProfileRepeatBoundary<A, B, C>
    typealias Left = R.BothBeforeAndAfterHaveEveryPair.Left
    typealias Right = R.BothBeforeAndAfterHaveEveryPair.Right
}

enum RepeatedCyclicChangeCollidesAtTheSameX<A: Structure, B: Structure, C: Structure>: Null {
    typealias R = CyclicProfileRepeatBoundary<A, B, C>
    typealias Left = R.RepetitionHasThreeEqualKeys.Left
    typealias Right = R.RepetitionHasThreeEqualKeys.Right
}

enum KnownInverseRecoversThePreparedSource<A: Structure, B: Structure, C: Structure>: Null {
    typealias R = CyclicProfileRepeatBoundary<A, B, C>
    typealias Left = R.InverseReturnsPreparedSource.Left
    typealias Right = R.InverseReturnsPreparedSource.Right
}

enum IsolatedCyclesAndTheirActualInterleaving<A: Structure, B: Structure, C: Structure>: Null {
    typealias R = TwoCyclicControllers<A, B, C>
    typealias Left = AddressTriple<R.EachIsolatedCycleCloses.Left, R.SharedEndpoints.Left, R.BothSelectedTheSameWord.Left>
    typealias Right = AddressTriple<R.EachIsolatedCycleCloses.Right, R.SharedEndpoints.Right, R.BothSelectedTheSameWord.Right>
}
#endif

#if LOCAL_PHASE_CYCLIC_REPEAT
enum RejectedOnceSafeMeansRepeatSafe: Null {
    typealias R = CyclicProfileRepeatBoundary<Never, Lit1, Lit2>
    typealias Left = R.Twice.Answer.Left
    typealias Right = R.Reverse
}
#endif

#if LOCAL_PHASE_CYCLIC_ENDPOINT
enum RejectedSecondCyclicContactAtOldSource: Null {
    typealias R = CyclicProfileRepeatBoundary<Never, Lit1, Lit2>
    typealias Left = R.Second.Left
    typealias Right = R.Root
}
#endif

#if LOCAL_PHASE_CYCLIC_RETURN
enum RejectedTwoCyclicContactsReturnSource: Null {
    typealias R = CyclicProfileRepeatBoundary<Never, Lit1, Lit2>
    typealias Left = R.Twice.Answer
    typealias Right = R.Root
}
#endif

#if LOCAL_PHASE_CYCLIC_PARTNER
enum RejectedIsolatedRenewalMakesSharedPhasesCurrent: Null {
    typealias R = TwoCyclicControllers<Never, Lit1, Lit2>
    typealias Left = R.Actual.Answer.Left.Left
    typealias Right = R.R.Reverse
}
#endif
