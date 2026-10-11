import VerificationIsIdentification
import Examples

enum AcquiredLeft<A: IntegerValued>: Close, BeamShape {
    typealias AlphaLevel = A
    typealias BetaLevel = Never
    typealias PaschenLevel = Never
}
enum AcquiredRight<A: IntegerValued>: Close, BeamShape {
    typealias AlphaLevel = A
    typealias BetaLevel = Lit1
    typealias PaschenLevel = Lit1
}

// A fixed schedule reads each component once. No equality premise chooses
// the second reading. Two slots are already present at the initial boundary.
enum AcquiredRun<A: IntegerValued, B: IntegerValued>: Pair {
    typealias Source = Paired<AcquiredLeft<A>, AcquiredRight<B>>
    typealias T = StartObservations<Source>
    typealias Advance = AdvancePreparedTrace<T, BoundaryFirstAlpha<Source>, BoundarySecondAlpha<Source>>
    typealias First = Advance.First
    typealias FirstBesideSlot = StepBeside<First, Never>
    typealias Second = Advance.Next
    typealias F = RetainTraceAnswer<Second.Trace, LastAnswerFromTrace<First.Trace>>
    typealias G = LastAnswerFromTrace<Second.Trace>
    typealias Left = FirstBesideSlot.Left
    typealias Right = Second.Right
}

enum AcquiredFirstSeam<A: IntegerValued, B: IntegerValued>: Null {
    typealias R = AcquiredRun<A, B>
    typealias Left = R.FirstBesideSlot.Right
    typealias Right = R.Advance.Left
}
enum AcquiredSecondSeam<A: IntegerValued, B: IntegerValued>: Null {
    typealias R = AcquiredRun<A, B>
    typealias Left = R.Advance.Right
    typealias Right = R.Second.Left
}

// Reconstruct the advance's input from its output coordinates. The old
// signal phase and the common channel are fixed on this prepared range.
enum AcquiredAdvanceRecovered<T: ObservationTrace, L: PredicateReading, R: PredicateReading>: Null
where T.Left: Structure, T.Left == L.Left, T.Left == R.Left,
      L.Sigma == R.Sigma, L.Encoding == R.Encoding, L.Predicate == R.Predicate {
    typealias Step = AdvancePreparedTrace<T, L, R>
    typealias W = Step.Right
    typealias Previous = Paired<W.Left, Paired<W.Right.Left, Paired<ExperimentSignal, W.Right.Right.Right.Left>>>
    typealias Left = Paired<Previous, W.Right.Right.Right.Right>
    typealias Right = Step.Left
}

enum AcquiredBothFactsRetained<A: IntegerValued, B: IntegerValued>: Null {
    typealias R = AcquiredRun<A, B>
    typealias Left = R.Second.Trace.Right
    typealias Right = Paired<Paired<Never, FactOf<BoundaryFirstAlpha<R.Source>>>, FactOf<BoundarySecondAlpha<R.Source>>>
}
enum AcquiredActualSourcesRetained<A: IntegerValued, B: IntegerValued>: Null {
    typealias R = AcquiredRun<A, B>
    typealias Left = R.Right.Left
    typealias Right = R.Source
}
enum AcquiredFirstAndSecondShareEvidence<A: IntegerValued, B: IntegerValued>: Null {
    typealias R = AcquiredRun<A, B>
    typealias Left = R.F.Observation
    typealias Right = R.G.Observation
}

// Only the acquired decoders are constrained to agree. Equality of their
// actual source answers is obtained through the two factorizations.
enum AcquiredMemoryForcesSource<F: ReadingFactors, G: ReadingFactors>: Null
where F.Observation == G.Observation, F.Predicate == G.Predicate,
      F.Right.Answer == G.Right.Answer {
    typealias C = JoinedVerdict<F.Right, G.Right>
    typealias SourceAgreement = AgreementFromMemory<F, G, C>
    typealias Left = SourceAgreement.Left.Answer
    typealias Right = SourceAgreement.Right.Answer
}
enum AcquiredMemoryForcesObstruction<F: ReadingFactors, G: ReadingFactors, N: IntegerValued>: Null
where F.Observation == G.Observation, F.Predicate == G.Predicate,
      F.Right.Answer == Never, G.Right.Answer == Examples.Succ<N> {
    typealias O = ZeroSuccessorFromMemory<F, G, N>
    typealias Left = Paired<O.Left, O.Right>
    typealias Right = Paired<F.Left.Answer, G.Left.Answer>
}

typealias Acquired00 = AcquiredRun<Never, Never>
typealias Acquired01 = AcquiredRun<Never, Lit1>
typealias Acquired10 = AcquiredRun<Lit1, Never>
typealias Acquired11 = AcquiredRun<Lit1, Lit1>
typealias AcquiredMemoryAgreement00 = JoinedVerdict<Acquired00.F.Right, Acquired00.G.Right>
typealias AcquiredMemoryAgreement11 = JoinedVerdict<Acquired11.F.Right, Acquired11.G.Right>
typealias AcquiredAgreement00 = AgreementFromMemory<Acquired00.F, Acquired00.G, AcquiredMemoryAgreement00>
typealias AcquiredAgreement11 = AgreementFromMemory<Acquired11.F, Acquired11.G, AcquiredMemoryAgreement11>
typealias AcquiredObstruction01 = ZeroSuccessorFromMemory<Acquired01.F, Acquired01.G, Never>
typealias AcquiredObstruction10 = InternalSwap<ZeroSuccessorFromMemory<Acquired10.G, Acquired10.F, Never>>

// Every classifier takes only memory decoders. Their types contain no source
// parameter, while the separate factorization retains the actual source.
typealias AcquiredClass00 = AgreedMemoryBoundary<AcquiredMemoryAgreement00>
typealias AcquiredClass11 = AgreedMemoryBoundary<AcquiredMemoryAgreement11>
typealias AcquiredClass01 = ZeroSuccessorMemoryBoundary<Acquired01.F.Right, Acquired01.G.Right, Never>
typealias AcquiredClass10 = SuccessorZeroMemoryBoundary<Acquired10.F.Right, Acquired10.G.Right, Never>
typealias AcquiredSourceClass00 = QuestionOnObservation<Acquired00.F.Observation, AcquiredClass00>
typealias AcquiredSourceClass11 = QuestionOnObservation<Acquired11.F.Observation, AcquiredClass11>
typealias AcquiredSourceClass01 = QuestionOnObservation<Acquired01.F.Observation, AcquiredClass01>
typealias AcquiredSourceClass10 = QuestionOnObservation<Acquired10.F.Observation, AcquiredClass10>

enum AcquiredClassReadsReadyMemory: Null {
    typealias Left = AnswerInReadyWhole<Acquired01.Right, AcquiredSourceClass01>.Left
    typealias Right = Acquired01.Second.Trace.Right
}
enum AcquiredThreeImages: Null {
    typealias Left = Paired<AcquiredClass00.Answer, Paired<AcquiredClass11.Answer, AcquiredClass01.Answer>>
    typealias Right = Paired<FactOf<Acquired00.F.Left>, Paired<FactOf<Acquired11.F.Left>, ZeroSuccessorBoundaryImage<Acquired01.F.Left, Acquired01.G.Left, Never>>>
}
enum AcquiredFailureImagesAgree: Null {
    typealias Left = AcquiredClass01.Answer
    typealias Right = AcquiredClass10.Answer
}
enum AcquiredFailureOrientationRemains: Null {
    typealias Left = Paired<AcquiredObstruction01.Left, AcquiredObstruction10.Left>
    typealias Right = Paired<ZeroSuccessorDistinction<Never>.Left, ZeroSuccessorDistinction<Never>.Right>
}

// The newly obtained source agreement now feeds VC62. The last actual
// decoder serves both sides, with no additional reading or appended fact.
typealias AcquiredReuse00 = AnswerThroughAgreement<ReversedVerdict<AcquiredAgreement00>, Acquired00.G>
enum AcquiredAgreementEnablesReuse: SharedDecoder {
    typealias Left = Acquired00.G
    typealias Right = AcquiredReuse00
}
enum AcquiredReuseKeepsTrace: Null {
    typealias Left = AcquiredReuse00.Observation
    typealias Right = Acquired00.G.Observation
}

// Neither possible first value establishes whether agreement applies.
enum AcquiredZeroFirstStillOpen: Null {
    typealias Left = Acquired00.First.Trace.Right
    typealias Right = Acquired01.First.Trace.Right
}
enum AcquiredOneFirstStillOpen: Null {
    typealias Left = Acquired10.First.Trace.Right
    typealias Right = Acquired11.First.Trace.Right
}

// A separately retained second-side fact can already supply the missing
// answer: compare that prefix with the last first-side reading. No new read.
typealias AcquiredReversePrefix = AppendObservation<Acquired00.T, BoundarySecondAlpha<Acquired00.Source>>
typealias AcquiredReverseTrace = AppendObservation<AcquiredReversePrefix, BoundaryFirstAlpha<Acquired00.Source>>
typealias AcquiredOldSecond = RetainTraceAnswer<AcquiredReverseTrace, LastAnswerFromTrace<AcquiredReversePrefix>>
typealias AcquiredNewFirst = LastAnswerFromTrace<AcquiredReverseTrace>
typealias AcquiredOldEvidenceAgreement = AgreementFromMemory<AcquiredNewFirst, AcquiredOldSecond, JoinedVerdict<AcquiredNewFirst.Right, AcquiredOldSecond.Right>>

// Another actual source has the same acquired memory. It can use the same
// classifier, but its observation cannot replace the first source's event.
typealias AcquiredTwinSource = Paired<AcquiredRight<Never>, AcquiredLeft<Never>>
typealias AcquiredTwinFirst = AppendObservation<StartObservations<AcquiredTwinSource>, BoundaryFirstAlpha<AcquiredTwinSource>>
typealias AcquiredTwinTrace = AppendObservation<AcquiredTwinFirst, BoundarySecondAlpha<AcquiredTwinSource>>
typealias AcquiredTwinF = RetainTraceAnswer<AcquiredTwinTrace, LastAnswerFromTrace<AcquiredTwinFirst>>
typealias AcquiredTwinG = LastAnswerFromTrace<AcquiredTwinTrace>
typealias AcquiredTwinClass = AgreedMemoryBoundary<JoinedVerdict<AcquiredTwinF.Right, AcquiredTwinG.Right>>
enum AcquiredClassifierHasNoSourceParameter: Null {
    typealias Left = AcquiredClass00
    typealias Right = AcquiredTwinClass
}

typealias AcquiredAt<W, P: Pair> = P where W == P.Left

#if EVIDENCE_ADVANCE_UNREAD
typealias RejectedEvidenceUnread = AcquiredAt<Acquired00.FirstBesideSlot.Left, Acquired00.Advance>
#endif
#if EVIDENCE_ADVANCE_NO_SLOT
typealias RejectedEvidenceNoSlot = AcquiredAt<Acquired00.First.Right, Acquired00.Advance>
#endif
#if EVIDENCE_ADVANCE_OCCUPIED_SLOT
typealias RejectedEvidenceOccupied = AcquiredAt<Paired<Acquired00.First.Right, FactOf<Acquired00.F.Left>>, Acquired00.Advance>
#endif
#if EVIDENCE_ADVANCE_OTHER_SOURCE
typealias RejectedEvidenceAdvanceSource = AdvancePreparedTrace<Acquired00.T, BoundaryFirstAlpha<Acquired00.Source>, BoundarySecondAlpha<AcquiredTwinSource>>
#endif
#if EVIDENCE_UNRELATED_OBSERVATIONS
typealias RejectedEvidenceForeign = AgreementFromMemory<Acquired00.F, AcquiredTwinG, JoinedVerdict<Acquired00.F.Right, AcquiredTwinG.Right>>
#endif
#if EVIDENCE_WRONG_MEMORY_DECODER
typealias RejectedEvidenceDecoder = AgreementFromMemory<Acquired00.F, Acquired00.G, JoinedVerdict<Acquired00.G.Right, Acquired00.F.Right>>
#endif
#if EVIDENCE_PREMATURE_CLASSIFICATION
typealias RejectedEvidencePremature = QuestionOnObservation<TraceEvidence<Acquired00.First.Trace>, AcquiredClass00>
#endif
#if EVIDENCE_UNEQUAL_AS_AGREEMENT
typealias RejectedEvidenceUnequal = AgreementFromMemory<Acquired01.F, Acquired01.G, JoinedVerdict<Acquired01.F.Right, Acquired01.G.Right>>
#endif
#if EVIDENCE_FALSE_OBSTRUCTION
typealias RejectedEvidenceObstruction = ZeroSuccessorFromMemory<Acquired00.F, Acquired00.G, Never>
#endif
#if EVIDENCE_FAILURE_IS_ANSWER
typealias RejectedEvidenceFailureFact = ReadRecordedAnswer<AcquiredClass01.Answer>
#endif
#if EVIDENCE_CLASS_ERASES_ORIENTATION
enum RejectedEvidenceOrientation: Null {
    typealias Left = Acquired01.Second.Trace.Right
    typealias Right = Acquired10.Second.Trace.Right
}
#endif
#if EVIDENCE_OLD_PERMISSION_NEW_SOURCE
typealias RejectedEvidenceOldPermission = AnswerThroughAgreement<AcquiredAgreement00, Acquired01.F>
#endif
