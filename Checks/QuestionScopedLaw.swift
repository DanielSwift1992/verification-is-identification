import VerificationIsIdentification
import Examples

typealias ScopedProbe00 = JoinedVerdict<FirstSelectionProbe<SelectionCalibration00>, Route00<RoutingProbeP>>
typealias ScopedProbe01 = JoinedVerdict<FirstSelectionProbe<SelectionCalibration01>, Route01<RoutingProbeP>>
typealias ScopedProbe10 = JoinedVerdict<FirstSelectionProbe<SelectionCalibration10>, Route10<RoutingProbeP>>
typealias ScopedProbe11 = JoinedVerdict<FirstSelectionProbe<SelectionCalibration11>, Route11<RoutingProbeP>>

enum ScopedAllRowAnswers<A: Structure, B: Structure>: Null {
    typealias Left = BoundaryWorking<RowSelection00<A, B>.Answer, RowSelection01<A, B>.Answer, RowSelection10<A, B>.Answer, RowSelection11<A, B>.Answer>
    typealias Right = RowRepeatedData<A, B>
}
enum ScopedZeroRowsShareOneDecoder<A: Structure, B: Structure>: SharedDecoder {
    typealias Left = RowSelection00<A, B>
    typealias Right = RowSelection01<A, B>
}
enum ScopedOneRowsShareOneDecoder<A: Structure, B: Structure>: SharedDecoder {
    typealias Left = RowSelection10<A, B>
    typealias Right = RowSelection11<A, B>
}
enum ScopedDecoderHasNoColumn<A: Structure, B: Structure>: Null {
    typealias Left = RowSelection00<A, B>.Right.Left
    typealias Right = Paired<AnswerFact<BeamSpace, SaturationEncoding, RoutedValueQuestion, Never>, RowRepeatedData<A, B>>
}
enum ScopedPreparedProbeProducesActualFact<C: Null, X: Structure>: Null
where C.Right: Pair, C.Right.Left: Structure, C.Right.Right: Structure {
    typealias Reading = FirstSelectionProbe<C>
    typealias Step = StepBeside<PreparedTraceExtension<StartObservations<Reading.Left>, Reading>, X>
    typealias Left = Paired<Step.Right.Left.Right.Right.Right.Right, Step.Right.Right>
    typealias Right = SelectionProbeMemory<C, X>.Answer
}
enum ScopedConstantAnswerNeedsOnlyData<A: Structure>: Null {
    typealias Left = ConstantSelectionAnswer<A>.Left
    typealias Right = RowRepeatedData<A, A>
}
enum ScopedConstantAllFour<A: Structure>: Null {
    typealias Left = ConstantSelectionEvidence<A>.Left
    typealias Right = BoundaryWorking<ConstantSelectionAnswer<A>.Answer, ConstantSelectionAnswer<A>.Answer, ConstantSelectionAnswer<A>.Answer, ConstantSelectionAnswer<A>.Answer>
}

typealias ScopedColumnStillDifferent = ZeroSuccessorBoundary<SecondEvidenceImage<RoutingAddress00, BeamSpace, SaturationEncoding, RoutingQuestion>, SecondEvidenceImage<RoutingAddress01, BeamSpace, SaturationEncoding, RoutingQuestion>, Never>
typealias ScopedRowReadingNecessary = ZeroSuccessorBoundary<RowSelection00<Never, Lit1>.Left, RowSelection10<Never, Lit1>.Left, Never>
enum ScopedSecondProbeDoesNotFindRow: Null {
    typealias Left = Route00<RoutingProbeQ>.Answer
    typealias Right = Route10<RoutingProbeQ>.Answer
}
enum ScopedFirstProbeDoesNotFindColumn: Null {
    typealias Left = FirstSelectionProbe<SelectionCalibration00>.Answer
    typealias Right = FirstSelectionProbe<SelectionCalibration01>.Answer
}
typealias ScopedNewDataReopensColumn = ZeroSuccessorBoundary<Route00<RoutingProbeQ>, Route01<RoutingProbeQ>, Never>

// For this one supplied input, neither permitted probe alone suffices.
// Choosing between p and q from the known data cannot remove this boundary.
typealias ScopedDiagonalData = BoundaryWorking<Never, Lit1, Lit1, Never>
typealias ScopedPNeedsAnotherProbe = ZeroSuccessorBoundary<Route00<ScopedDiagonalData>, Route01<ScopedDiagonalData>, Never>
typealias ScopedQNeedsAnotherProbe = ZeroSuccessorBoundary<Route00<ScopedDiagonalData>, Route10<ScopedDiagonalData>, Never>

enum ScopedChangedLawStillUsesOldFacts<A: Structure, B: Structure>: Null {
    typealias F = RowLawChangePreservesAnswer<A, B>
    typealias Left = Paired<F.Answer, F.Right.Left>
    typealias Right = Paired<A, RowSelection00<A, B>.Right.Left>
}
enum ScopedChangedLawIsActualEndpoint<A: Structure, B: Structure>: Null {
    typealias X = RowRepeatedData<A, B>
    typealias W = RowLawChangePreservesAnswer<A, B>.World
    typealias Left = ExchangeSelectionReserve<W>.Answer
    typealias Right = Paired<Paired<Paired<RoutingAddress01, RoutingProbeP>, X>, RoutingAddress00>
}
enum ScopedChangeTwiceRecoversWhole<A: Structure, B: Structure>: Null {
    typealias W = RowLawChangePreservesAnswer<A, B>.World
    typealias Left = ExchangeSelectionReserve<ExchangeSelectionReserve<W>.Answer>.Answer
    typealias Right = W
}
enum ScopedResidentEndpointMatchesQuestion<A: Structure, B: Structure>: Null {
    typealias Run = ScopedLawResidentRun<A, B>
    typealias W = Run.Right
    typealias Left = Paired<Paired<W.Left.Left.Left, W.Left.Right>, W.Right>
    typealias Right = ExchangeSelectionReserve<RowLawChangePreservesAnswer<A, B>.World>.Answer
}
enum ScopedResidentOldMemoryAnswersNewLaw<A: Structure, B: Structure>: Null {
    typealias W = ScopedLawResidentRun<A, B>.Right
    typealias Left = Paired<W.Left.Left.Right.Right.Right.Right, W.Left.Right>
    typealias Right = RowLawChangePreservesAnswer<A, B>.Right.Left
}
enum ScopedResidentRecordIsStillHistorical<A: Structure, B: Structure>: Null {
    typealias Run = ScopedLawResidentRun<A, B>
    typealias Left = Run.Acquisition.Right.Left.Left.Right
    typealias Right = Run.Change.Right.Left.Left.Right
}

typealias ScopedRows01 = RowRepeatedData<Never, Lit1>
typealias ScopedCrossRowFuture = SelectionAfterReserveChange<SelectionCalibration00, SelectionCalibration10, ScopedRows01, Route10<ScopedRows01>>
typealias ScopedWithinRowFuture = RowLawChangePreservesAnswer<Never, Lit1>
typealias ScopedCrossRowBreaksAnswer = ZeroSuccessorBoundary<ScopedWithinRowFuture.Left, ScopedCrossRowFuture, Never>
enum ScopedOldEvidenceOmitsReplacement: Null {
    typealias W = Paired<RowSelection00<Never, Lit1>.Left.Left, RoutingAddress10>
    typealias Other = FactorOnSource<RowSelection00<Never, Lit1>, FirstEvidenceImage<W, BeamSpace, SaturationEncoding, RoutedValueQuestion>>
    typealias Left = ScopedWithinRowFuture.Observation.Answer
    typealias Right = Other.Observation.Answer
}

#if SLAWS_ROW_PROBE_IDENTIFIES_LAW
enum RejectedScopedIdentity: Null {
    typealias Left = RoutingAddress00
    typealias Right = RoutingAddress01
}
#endif
#if SLAWS_NO_LAW_READING_ON_DISTINCT_ROWS
enum RejectedScopedNoReading: Null {
    typealias Left = RowSelection00<Never, Lit1>.Answer
    typealias Right = RowSelection10<Never, Lit1>.Answer
}
#endif
#if SLAWS_OLD_PROBE_COVERS_NEW_DATA
enum RejectedScopedNewData: Null {
    typealias Left = Route00<RoutingProbeQ>.Answer
    typealias Right = Route01<RoutingProbeQ>.Answer
}
#endif
#if SLAWS_WRONG_ROW_DECODER
enum RejectedScopedWrongRow: ReadingFactors {
    typealias Left = RowSelection10<Never, Lit1>.Left
    typealias Observation = RowSelection10<Never, Lit1>.Observation
    typealias Right = RowSelection00<Never, Lit1>.Right
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Predicate = RoutedValueQuestion
    typealias Answer = Left.Answer
}
#endif
#if SLAWS_ANY_REPLACEMENT_PRESERVES_ANSWER
enum RejectedScopedReplacement: Null {
    typealias Left = ScopedWithinRowFuture.Answer
    typealias Right = ScopedCrossRowFuture.Answer
}
#endif
#if SLAWS_ANSWER_PRESERVES_LAW
enum RejectedScopedLawUnchanged: Null {
    typealias W = RowLawChangePreservesAnswer<Never, Lit1>.World
    typealias Left = W.Left.Left.Left
    typealias Right = ExchangeSelectionReserve<W>.Answer.Left.Left.Left
}
#endif
#if SLAWS_CHANGE_ERASES_QUESTION
enum RejectedScopedChangeQuestion: Null {
    typealias Left = ScopedWithinRowFuture.Predicate
    typealias Right = RoutedValueQuestion
}
#endif
