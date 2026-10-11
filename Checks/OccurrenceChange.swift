import VerificationIsIdentification
import Examples

typealias ChangedRepliesNoRelativeDrift = PairedOccurrenceAcquisition<
    EqualPairParity<Never>, EqualPairParity<Examples.Succ<Never>>, Never, Never>
typealias ChangedRelativeDrift = PairedOccurrenceAcquisition<
    EqualPairParity<Never>, ZeroOneParity, Never, Never>
typealias SameChangedRelativeDrift = PairedOccurrenceAcquisition<
    EqualPairParity<Examples.Succ<Never>>, OneZeroParity, Examples.Succ<Never>, Never>

#if !OCCURRENCE_CHANGE_OLD && !OCCURRENCE_CHANGE_UNLINKED && !OCCURRENCE_CHANGE_WRONG_SOURCE
enum TheActualBeforeStepAfterPathRetainsItsSource<B: PredicateReading,
    T: PredicateReading, A: PredicateReading, H: Structure>: Null
where B.Left == T.Left, A.Left == T.Answer,
      B.Left: Structure, T.Answer: Structure, B.Answer: Structure, A.Answer: Structure,
      B.Sigma == BeamSpace, T.Sigma == BeamSpace, A.Sigma == BeamSpace,
      B.Encoding == SaturationEncoding, T.Encoding == SaturationEncoding,
      A.Encoding == SaturationEncoding {
    typealias C = RecordAcrossOccurrences<B, T, A, H>
    typealias Left = Paired<C.Endpoints.Left, C.OriginalRootSurvives.Left>
    typealias Right = Paired<C.Endpoints.Right, C.OriginalRootSurvives.Right>
}

enum TheFactMemoryHasNoAdditionalSourceOrTransitionField<B: PredicateReading,
    T: PredicateReading, A: PredicateReading, H: Structure>: Null
where B.Left == T.Left, A.Left == T.Answer,
      B.Left: Structure, T.Answer: Structure, B.Answer: Structure, A.Answer: Structure,
      B.Sigma == BeamSpace, T.Sigma == BeamSpace, A.Sigma == BeamSpace,
      B.Encoding == SaturationEncoding, T.Encoding == SaturationEncoding,
      A.Encoding == SaturationEncoding {
    typealias C = RecordAcrossOccurrences<B, T, A, H>
    typealias Left = C.OnlyTheTwoAcquiredFacts.Left
    typealias Right = C.OnlyTheTwoAcquiredFacts.Right
}

enum ChangedRawRepliesCanAcquireZeroRelativeChange: Null {
    typealias C = ChangedRepliesNoRelativeDrift.Acquisition
    typealias D = JointChangeFromFacts<C.Memory, EqualPairParity<Never>>
    typealias Left = D.Answer
    typealias Right = Never
}

enum AChangedRelativeAnswerIsAcquiredFromTheTwoFacts: Null {
    typealias C = ChangedRelativeDrift.Acquisition
    typealias D = JointChangeFromFacts<C.Memory, ZeroOneParity>
    typealias Left = D.Answer
    typealias Right = Examples.Succ<Never>
}

enum AllFourRelativeChangesUseTheirActualRecordedInputs: Null {
    typealias Z = ChangedRepliesNoRelativeDrift.Acquisition
    typealias O = ChangedRelativeDrift.Acquisition
    typealias Back = PairedOccurrenceAcquisition<ZeroOneParity,
        EqualPairParity<Never>, Never, Never>.Acquisition
    typealias Both = PairedOccurrenceAcquisition<ZeroOneParity,
        OneZeroParity, Never, Never>.Acquisition
    typealias Left = Paired<
        Paired<JointChangeFromFacts<Z.Memory, EqualPairParity<Never>>.Answer,
            JointChangeFromFacts<O.Memory, ZeroOneParity>.Answer>,
        Paired<JointChangeFromFacts<Back.Memory, OneZeroParity>.Answer,
            JointChangeFromFacts<Both.Memory, EqualPairParity<Examples.Succ<Never>>>.Answer>>
    typealias Right = Paired<Paired<Never, Examples.Succ<Never>>,
        Paired<Examples.Succ<Never>, Never>>
}

enum DifferentRawSourcesAndContextsHaveExactlyTheSameDecoderInput: Null {
    typealias Left = ChangedRelativeDrift.Acquisition.Memory
    typealias Right = SameChangedRelativeDrift.Acquisition.Memory
}

enum TheStoredEarlierAnswerAndCurrentAnswerAreDistinct: Null {
    typealias C = ChangedRelativeDrift.Acquisition
    typealias Left = Paired<C.Memory.Left.Answer.Left, C.Memory.Right.Answer.Left>
    typealias Right = Paired<Never, Examples.Succ<Never>>
}

enum TheTwoDifferentRawOccurrencesRemainInTheWhole: Null {
    typealias C = ChangedRepliesNoRelativeDrift.Acquisition
    typealias Left = Paired<C.Result.Left.Left.Left.Left.Left.Left,
        C.Result.Left.Right.Answer.Left.Left>
    typealias Right = Paired<Never, Examples.Succ<Never>>
}
#endif

#if OCCURRENCE_CHANGE_WRONG_SOURCE
enum RejectedCurrentAcquisitionUsesTheEarlierSource: Null {
    typealias C = ChangedRelativeDrift
    typealias Run = RecordAcrossOccurrences<C.Before, C.Step, C.Before, Never>
    typealias Left = Run.Endpoints.Left
    typealias Right = Run.Endpoints.Right
}
#endif

#if OCCURRENCE_CHANGE_OLD
enum RejectedTheOldFactIsTheCurrentAnswerAfterChange: Null {
    typealias C = ChangedRelativeDrift.Acquisition
    typealias Left = C.Memory.Left.Answer.Left
    typealias Right = C.Memory.Right.Answer.Left
}
#endif

#if OCCURRENCE_CHANGE_UNLINKED
enum RejectedOneChangedReplyLeavesTheAcquiredChangeUnchanged: Null {
    typealias Z = ChangedRepliesNoRelativeDrift.Acquisition
    typealias O = ChangedRelativeDrift.Acquisition
    typealias Left = JointChangeFromFacts<Z.Memory, EqualPairParity<Never>>.Answer
    typealias Right = JointChangeFromFacts<O.Memory, ZeroOneParity>.Answer
}
#endif
