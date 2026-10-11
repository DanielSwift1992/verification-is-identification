import VerificationIsIdentification
import Examples

enum CommonLeft<A: IntegerValued>: Close, BeamShape {
    typealias AlphaLevel = A
    typealias BetaLevel = Never
    typealias PaschenLevel = Never
}
enum CommonRight<A: IntegerValued>: Close, BeamShape {
    typealias AlphaLevel = A
    typealias BetaLevel = Lit1
    typealias PaschenLevel = Lit1
}
enum CommonOldContent: Close {}
enum CommonOldArchive: Close {}

// Agreement follows from the resident component relation; the two component
// sources are distinct. Both applications are anchored at the whole pair.
typealias CommonPair<A: IntegerValued> = Paired<CommonLeft<A>, CommonRight<A>>
typealias CommonCertificate<A: IntegerValued> = JoinedVerdict<BoundaryFirstAlpha<CommonPair<A>>, BoundarySecondAlpha<CommonPair<A>>>

// VC84: either resident address suffices on this correlated source family.
// Reuse VC62 in reverse instead of introducing a second transfer mechanism.
typealias CommonRightFact<A: IntegerValued> = AcquireAnswer<CommonCertificate<A>.Right>
typealias CommonFirstFromRight<A: IntegerValued> = AnswerThroughAgreement<
    ReversedVerdict<CommonCertificate<A>>, CommonRightFact<A>
>

enum CommonAlternativeAccessUsesItsActualFact<A: IntegerValued>: Null {
    typealias Left = CommonFirstFromRight<A>.Observation
    typealias Right = CommonRightFact<A>.Observation
}

enum CommonAlternativeAccessKeepsItsDecoder<A: IntegerValued>: Null {
    typealias Left = CommonFirstFromRight<A>.Right
    typealias Right = CommonRightFact<A>.Right
}

enum CommonAlternativeFactsCarryTheSameAnswer<A: IntegerValued>: Null {
    typealias Left = AcquireAnswer<CommonCertificate<A>.Left>.Observation.Answer
    typealias Right = CommonRightFact<A>.Observation.Answer
}

// A constant observation models the empty available interface. It does not
// remove either actual source from the represented whole.
enum CommonEmptyImagesCoincide: Null {
    typealias Left = ConstantResetReading<CommonPair<Never>>.Answer
    typealias Right = ConstantResetReading<CommonPair<Lit1>>.Answer
}

enum CommonEmptyImagesHideDifferentRequiredAnswers: Null {
    typealias Left = Paired<CommonCertificate<Never>.Answer, CommonCertificate<Lit1>.Answer>
    typealias Right = Paired<ZeroSuccessorDistinction<Never>.Left, ZeroSuccessorDistinction<Never>.Right>
}

typealias CommonEmptyDecoder = FirstEvidenceImage<Never, BeamSpace, SaturationEncoding, AlphaQuestion>

enum CommonEmptyDecoderWorksOnTheZeroCase: ReadingFactors {
    typealias Left = CommonCertificate<Never>.Left
    typealias Observation = ConstantResetReading<CommonPair<Never>>
    typealias Right = CommonEmptyDecoder
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Predicate = AlphaQuestion
    typealias Answer = Left.Answer
}

#if COMMON_INTERSECTS_ALTERNATIVE_SUPPORTS
enum RejectedCommonEmptySupport: ReadingFactors {
    typealias Left = CommonCertificate<Lit1>.Left
    typealias Observation = ConstantResetReading<CommonPair<Lit1>>
    typealias Right = CommonEmptyDecoder
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Predicate = AlphaQuestion
    typealias Answer = Left.Answer
}
#endif

enum CommonResidentRun<A: IntegerValued, Tail: Structure>: Pair {
    typealias C = CommonCertificate<A>
    typealias T = StartObservations<CommonPair<A>>
    typealias Step = PreparedCommonTrace<T, C>
    typealias Prepare = PrepareTraceFromResidentSlot<T, C.Left, CommonOldContent, CommonOldArchive, Paired<Never, Tail>>
    typealias Read = StepBeside<Step, Prepare.Right.Right>
    typealias Park = ParkAcquiredTrace<T, C.Left, Paired<CommonOldArchive, CommonOldContent>, Tail>
    typealias F = CommonAnswerFromTrace<Step.Trace, C>
    typealias Left = Prepare.Left
    typealias Right = Park.Right
    typealias Answer = AnswerFromResidentArchive<Right, F>
}

enum CommonPreparationSeam<A: IntegerValued, Tail: Structure>: Null {
    typealias R = CommonResidentRun<A, Tail>
    typealias Left = R.Prepare.Right
    typealias Right = R.Read.Left
}
enum CommonParkingSeam<A: IntegerValued, Tail: Structure>: Null {
    typealias R = CommonResidentRun<A, Tail>
    typealias Left = R.Read.Right
    typealias Right = R.Park.Left
}

// An arbitrary existing observation can serve the agreed second application.
// It keeps both the actual observation and decoder without new premises.
enum CommonExistingAccess<C: VerdictIsInvariant, F: ReadingFactors>: SharedDecoder
where C.Left == F.Left, C.Right.Left == F.Left.Left {
    typealias Left = F
    typealias Right = AnswerThroughAgreement<C, F>
}
enum CommonReadyDecoders<T: ObservationTrace, C: VerdictIsInvariant>: Null
where T.Left: Structure, T.Left == C.Left.Left, C.Right.Left == T.Left {
    typealias Step = PreparedCommonTrace<T, C>
    typealias Left = AnswerInReadyWhole<Step.Right, LastAnswerFromTrace<Step.Trace>>
    typealias Right = AnswerInReadyWhole<Step.Right, CommonAnswerFromTrace<Step.Trace, C>>
}
enum CommonArchivedDecoders<A: IntegerValued, Tail: Structure>: Null {
    typealias R = CommonResidentRun<A, Tail>
    typealias Left = AnswerFromResidentArchive<R.Right, LastAnswerFromTrace<R.Step.Trace>>
    typealias Right = R.Answer
}
enum CommonSecondAnswerRecovered<A: IntegerValued, Tail: Structure>: Null {
    typealias R = CommonResidentRun<A, Tail>
    typealias Left = R.Answer.Answer
    typealias Right = R.Right.Left.Left.Right.AlphaLevel
}
enum CommonDecoderHasMemoryOnly<A: IntegerValued, Tail: Structure>: Null {
    typealias R = CommonResidentRun<A, Tail>
    typealias Left = R.Answer.Left
    typealias Right = ResidentTraceMemory<R.Right>
}
enum CommonSourcesRetained<A: IntegerValued, Tail: Structure>: Null {
    typealias R = CommonResidentRun<A, Tail>
    typealias Left = R.Right.Left.Left
    typealias Right = CommonPair<A>
}
enum CommonOldContentRetained<A: IntegerValued, Tail: Structure>: Null {
    typealias R = CommonResidentRun<A, Tail>
    typealias Left = R.Right.Right.Left.Left
    typealias Right = Paired<CommonOldArchive, CommonOldContent>
}
enum CommonOnlyOneFactParked<A: IntegerValued, Tail: Structure>: Null {
    typealias R = CommonResidentRun<A, Tail>
    typealias Left = R.Right.Right
    typealias Right = Paired<Paired<Paired<CommonOldArchive, CommonOldContent>, FactOf<R.C.Left>>, Tail>
}
enum CommonNoSecondReading<T: ExtendedObservationTrace, C: VerdictIsInvariant>: Null
where T.Reading == C.Left, C.Right.Left == T.Left {
    typealias Left = CommonAnswerFromTrace<T, C>.Observation
    typealias Right = TraceEvidence<T>
}

typealias CommonZero = CommonResidentRun<Never, Never>
typealias CommonOne = CommonResidentRun<Lit1, Never>

// The reserve is empty at completion, yet both answers remain readable.
enum CommonEmptyReserveStillAnswers: Null {
    typealias Left = CommonZero.Right.Right.Right
    typealias Right = Never
    typealias Answer = CommonZero.Answer
}

// Removing archive access leaves identical accessible work memories for two
// different required answers. The archive still exists inside each whole.
enum CommonRestrictedViewsCoincide: Null {
    typealias Left = CommonZero.Right.Left.Right
    typealias Right = CommonOne.Right.Left.Right
}
enum CommonRestrictedAnswersDiffer: Null {
    typealias Left = Paired<CommonZero.Answer.Answer, CommonOne.Answer.Answer>
    typealias Right = Paired<ZeroSuccessorDistinction<Never>.Left, ZeroSuccessorDistinction<Never>.Right>
}

// An incompatible pair has a valid first-side acquisition even with an
// arbitrary reserve tail. That reading does not certify common agreement.
typealias CommonUnequal = Paired<CommonLeft<Never>, CommonRight<Lit1>>
typealias CommonUnequalTrace = StartObservations<CommonUnequal>
typealias CommonUnequalStep = PreparedTraceExtension<CommonUnequalTrace, BoundaryFirstAlpha<CommonUnequal>>
typealias CommonUnequalObstruction = ZeroSuccessorBoundary<BoundaryFirstAlpha<CommonUnequal>, BoundarySecondAlpha<CommonUnequal>, Never>
typealias CommonUnequalPrepared<Tail: Structure> = PrepareTraceFromResidentSlot<CommonUnequalTrace, BoundaryFirstAlpha<CommonUnequal>, CommonOldContent, CommonOldArchive, Paired<Never, Tail>>

enum CommonFirstMeasurementCannotDiscoverAgreement: Null {
    typealias Left = CommonZero.Step.Trace.Right
    typealias Right = CommonUnequalStep.Trace.Right
}
enum CommonExtraMemoryCannotDiscoverAgreement<Tail: Structure>: Null {
    typealias Left = Paired<CommonZero.Step.Trace.Right, Tail>
    typealias Right = Paired<CommonUnequalStep.Trace.Right, Tail>
}
enum CommonWholeKeepsUnmeasuredDifference: Null {
    typealias Left = Paired<CommonZero.Step.Right.Left.Right.AlphaLevel, CommonUnequalStep.Right.Left.Right.AlphaLevel>
    typealias Right = Paired<CommonUnequalObstruction.Left, CommonUnequalObstruction.Right>
}

typealias CommonAt<W, P: Pair> = P where W == P.Left

#if COMMON_UNEQUAL_WITH_PREPARATION
typealias CommonAmpleMemory = CommonUnequalPrepared<Paired<Never, Paired<Never, Never>>>
typealias RejectedCommonUnequal = PreparedCommonTrace<CommonUnequalTrace, JoinedVerdict<BoundaryFirstAlpha<CommonUnequal>, BoundarySecondAlpha<CommonUnequal>>>
#endif

#if COMMON_OTHER_ACTUAL_SOURCE
typealias CommonForeignCertificate = JoinedVerdict<CommonCertificate<Never>.Left, BoundarySecondAlpha<Paired<CommonRight<Never>, CommonLeft<Never>>>>
typealias RejectedCommonForeign = AnswerThroughAgreement<CommonForeignCertificate, LastAnswerFromTrace<CommonZero.Step.Trace>>
#endif

#if COMMON_OTHER_ACTUAL_READING
typealias CommonOtherTrace = AppendObservation<CommonZero.T, CommonZero.C.Right>
typealias RejectedCommonReading = CommonAnswerFromTrace<CommonOtherTrace, CommonZero.C>
#endif

#if COMMON_OCCUPIED_WORKSPACE
typealias RejectedCommonOccupied = CommonAt<CommonZero.Prepare.Work, CommonZero.Step>
#endif

#if COMMON_OTHER_CHANNEL
typealias CommonWrongChannel = Paired<CommonPair<Never>, Paired<ChannelOf<SpectrumBetaSource<CommonLeft<Never>>>, CommonZero.Step.Left.Right.Right>>
typealias RejectedCommonChannel = CommonAt<CommonWrongChannel, CommonZero.Step>
#endif

#if COMMON_NO_PREPARATION_RESERVE
typealias CommonNoReserve = Paired<CommonZero.Prepare.Work, Paired<CommonOldArchive, Never>>
typealias RejectedCommonReserve = CommonAt<CommonNoReserve, CommonZero.Prepare>
#endif

#if COMMON_NO_PARKING_RESERVE
typealias CommonOneSlotPrepare = PrepareTraceFromResidentSlot<CommonZero.T, CommonZero.C.Left, CommonOldContent, CommonOldArchive, Never>
typealias CommonOneSlotRead = StepBeside<CommonZero.Step, CommonOneSlotPrepare.Right.Right>
typealias RejectedCommonParkingReserve = CommonAt<CommonOneSlotRead.Right, CommonZero.Park>
#endif

#if COMMON_ARCHIVE_INACCESSIBLE
typealias RejectedCommonAccess = AnswerInTrace<CommonZero.T, CommonZero.F>
#endif

#if COMMON_REPLACEMENT_ARCHIVE
typealias CommonOtherArchive = Paired<CommonZero.Right.Left, CommonOne.Right.Right>
typealias RejectedCommonArchive = AnswerFromResidentArchive<CommonOtherArchive, CommonZero.F>
#endif

#if COMMON_FIRST_FACT_CERTIFIES_SECOND
enum RejectedCommonUnmeasured: VerdictIsInvariant {
    typealias Left = BoundarySecondAlpha<CommonUnequal>
    typealias Right = LatestObservation<CommonUnequalStep.Trace.Right>
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Predicate = AlphaQuestion
    typealias Answer = Left.Answer
}
#endif
