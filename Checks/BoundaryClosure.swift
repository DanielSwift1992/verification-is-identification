import VerificationIsIdentification
import Examples

typealias ClosureSource<A: IntegerValued, C: IntegerValued, B: IntegerValued, D: IntegerValued> = Paired<BoundaryBeam<A, C, Never>, BoundaryBeam<B, D, Lit1>>

// The next operation consumes the actual previous output, including beta.
enum ClosureMixed<P: Pair>: Pair
where P.Left: BeamShape & Structure, P.Right: BeamShape & Structure {
    typealias E = BoundaryCoordinatesExchange<P>
    typealias S = BoundaryCoordinatesSwap<E.SourceStep.Answer>
    typealias ES = JoinedTransition<E, S>
    typealias E2 = BoundaryCoordinatesExchange<S.SourceStep.Answer>
    typealias ESE = JoinedTransition<ES, E2>
    typealias S2 = BoundaryCoordinatesSwap<E2.SourceStep.Answer>
    typealias ESES = JoinedTransition<ESE, S2>
    typealias Left = P
    typealias Right = ESES
}

enum ClosureDoubleExchange<P: Pair>: Null
where P.Left: BeamShape, P.Right: BeamShape {
    typealias E = BoundaryCoordinatesExchange<P>
    typealias EE = JoinedTransition<E, BoundaryCoordinatesExchange<E.SourceStep.Answer>>
    typealias Left = EE.Right.Answer
    typealias Right = BoundaryCoordinates<P>.Answer
}

enum ClosureBothBlocksExchange<P: Pair>: Null
where P.Left: BeamShape & Structure, P.Right: BeamShape & Structure {
    typealias Path = ClosureMixed<P>.ESES
    typealias Left = Path.Right.Answer
    typealias Right = BoundaryWorking<P.Left.BetaLevel, P.Left.AlphaLevel, P.Right.BetaLevel, P.Right.AlphaLevel>
}

enum ClosureHiddenFieldsRemain<P: Pair>: Null
where P.Left: BeamShape & Structure, P.Right: BeamShape & Structure {
    typealias End = ClosureMixed<P>.ESES.SourceStep.Answer
    typealias Left = Paired<End.Left.PaschenLevel, End.Right.PaschenLevel>
    typealias Right = Paired<P.Left.PaschenLevel, P.Right.PaschenLevel>
}

// Four words read every table cell; these identities hold for arbitrary
// structural entries, before restricting the table to the binary grammar.
enum ClosureFourSeparators<I: Pair>: Null
where I.Left: Pair, I.Right: Pair,
      I.Left.Left: Structure, I.Left.Right: Structure,
      I.Right.Left: Structure, I.Right.Right: Structure {
    typealias E = ExchangeTableRows<I>
    typealias S = TransposeBoundaryTable<I>
    typealias SE = ExchangeTableRows<S.Answer>
    typealias SES = TransposeBoundaryTable<SE.Answer>
    typealias ES = TransposeBoundaryTable<E.Answer>
    typealias ESE = ExchangeTableRows<ES.Answer>
    typealias ESES = TransposeBoundaryTable<ESE.Answer>
    typealias Left = Paired<Paired<ReadBoundaryTable<I>.Answer, ReadBoundaryTable<SES.Answer>.Answer>, Paired<ReadBoundaryTable<E.Answer>.Answer, ReadBoundaryTable<ESES.Answer>.Answer>>
    typealias Right = Paired<Paired<I.Left.Left, I.Left.Right>, Paired<I.Right.Left, I.Right.Right>>
}

enum ClosureOnlyMergedPair: Null {
    typealias Left = Boundary0011.Answer
    typealias Right = Boundary1100.Answer
}
enum ClosureMergedClassFixed: Null {
    typealias T = Boundary0011.Answer
    typealias Left = Paired<ExchangeTableRows<T>.Answer, TransposeBoundaryTable<T>.Answer>
    typealias Right = Paired<T, T>
}

// The three positive constructor shapes are distinct on the declared
// grammar; these classes are answers, answers, and an addressed obstruction.
typealias ClosureJ0 = Boundary00.Answer
typealias ClosureB = Boundary01.Answer
typealias ClosureJ1 = Boundary11.Answer
typealias ClosureTable<A: Structure, B: Structure, C: Structure, D: Structure> = Paired<Paired<A, B>, Paired<C, D>>
enum ClosureDerivedTableRows: Null {
    typealias Left = Paired<Paired<Boundary0000.Answer, Boundary0001.Answer>, Paired<Paired<Boundary0010.Answer, Boundary0011.Answer>, Paired<Paired<Boundary0100.Answer, Boundary0101.Answer>, Paired<Paired<Boundary0110.Answer, Boundary0111.Answer>, Paired<Paired<Boundary1000.Answer, Boundary1001.Answer>, Paired<Paired<Boundary1010.Answer, Boundary1011.Answer>, Paired<Paired<Boundary1100.Answer, Boundary1101.Answer>, Paired<Boundary1110.Answer, Boundary1111.Answer>>>>>>>>
    typealias Right = Paired<Paired<ClosureTable<ClosureJ0, ClosureJ0, ClosureJ0, ClosureJ0>, ClosureTable<ClosureJ0, ClosureB, ClosureJ0, ClosureB>>, Paired<Paired<ClosureTable<ClosureB, ClosureJ0, ClosureB, ClosureJ0>, ClosureTable<ClosureB, ClosureB, ClosureB, ClosureB>>, Paired<Paired<ClosureTable<ClosureJ0, ClosureJ0, ClosureB, ClosureB>, ClosureTable<ClosureJ0, ClosureB, ClosureB, ClosureJ1>>, Paired<Paired<ClosureTable<ClosureB, ClosureJ0, ClosureJ1, ClosureB>, ClosureTable<ClosureB, ClosureB, ClosureJ1, ClosureJ1>>, Paired<Paired<ClosureTable<ClosureB, ClosureB, ClosureJ0, ClosureJ0>, ClosureTable<ClosureB, ClosureJ1, ClosureJ0, ClosureB>>, Paired<Paired<ClosureTable<ClosureJ1, ClosureB, ClosureB, ClosureJ0>, ClosureTable<ClosureJ1, ClosureJ1, ClosureB, ClosureB>>, Paired<Paired<ClosureTable<ClosureB, ClosureB, ClosureB, ClosureB>, ClosureTable<ClosureB, ClosureJ1, ClosureB, ClosureJ1>>, Paired<ClosureTable<ClosureJ1, ClosureB, ClosureJ1, ClosureB>, ClosureTable<ClosureJ1, ClosureJ1, ClosureJ1, ClosureJ1>>>>>>>>>
}

// A mixed source -> coordinates -> class-table path, with two reobserved
// squares and exact intermediate reading identity.
typealias ClosureP = ClosureSource<Lit1, Never, Never, Lit1>
typealias ClosureRawE = BoundaryCoordinatesExchange<ClosureP>
typealias ClosureTE = BoundaryTableExchange<Boundary1001.Left, Boundary10, Boundary11, Boundary00, Boundary01>
typealias ClosureE = ReobservedTransition<ClosureRawE, ClosureTE>
typealias ClosureRawS = BoundaryCoordinatesSwap<ClosureRawE.SourceStep.Answer>
typealias ClosureTS = BoundaryTableSwap<ClosureTE.SourceStep.Answer, Boundary00, Boundary01, Boundary10, Boundary11>
typealias ClosureS = ReobservedTransition<ClosureRawS, ClosureTS>
typealias ClosureES = JoinedTransition<ClosureE, ClosureS>

// A second exchange now uses the reversed comparison leaves returned by S.
typealias ClosureRawE2 = BoundaryCoordinatesExchange<ClosureRawS.SourceStep.Answer>
typealias ClosureTE2 = BoundaryTableExchange<ClosureTS.SourceStep.Answer, ReverseBoundaryComparison<Boundary00>, ReverseBoundaryComparison<Boundary10>, ReverseBoundaryComparison<Boundary01>, ReverseBoundaryComparison<Boundary11>>
typealias ClosureE2 = ReobservedTransition<ClosureRawE2, ClosureTE2>
typealias ClosureESE = JoinedTransition<ClosureES, ClosureE2>

typealias ClosureAcquisition = AcquiredBoundaryCoordinates<ClosureP>
typealias ClosureTableFactor = QuestionOnObservation<BoundaryCoordinates<ClosureP>, Boundary1001>
typealias ClosureAcquiredTable = AnswerOnRefinement<ClosureTableFactor, ClosureAcquisition>
typealias ClosureEndpoint = QuestionOnObservation<ClosureESE.Right, ReadBoundaryTable<ClosureESE.Right.Answer>>
typealias ClosureFuture = FutureOnEvidence<ClosureESE, ClosureEndpoint, ClosureAcquiredTable>
enum ClosureFutureReadsActualMemory: Null {
    typealias Left = ClosureFuture.Right.Left
    typealias Right = ClosureAcquisition.T4.Right
}
enum ClosureFutureAnswerDerived: Null {
    typealias Left = ClosureFuture.Answer
    typealias Right = ClosureB
}
enum ClosureCoordinateDecoderReadsOnlyMemory<P: Pair>: Null
where P.Left: BeamShape, P.Right: BeamShape {
    typealias A = AcquiredBoundaryCoordinates<P>
    typealias Left = A.Right.Left
    typealias Right = A.T4.Right
}

enum ClosureDecoderHasNoHiddenSource<A: IntegerValued, C: IntegerValued, B: IntegerValued, D: IntegerValued, H: IntegerValued, K: IntegerValued>: Null {
    typealias P = ClosureSource<A, C, B, D>
    typealias Q = Paired<BoundaryBeam<A, C, H>, BoundaryBeam<B, D, K>>
    typealias Left = AcquiredBoundaryCoordinates<P>.Right
    typealias Right = AcquiredBoundaryCoordinates<Q>.Right
}

// In the initial prepared family the old alpha evidence already determines
// the coordinates. Its two beta values are established by the family law.
typealias ClosureOldTrace = AdvancePreparedTrace<StartObservations<ClosureP>, BoundaryFirstAlpha<ClosureP>, BoundarySecondAlpha<ClosureP>>
typealias ClosureOldF = RetainTraceAnswer<ClosureOldTrace.Next.Trace, LastAnswerFromTrace<ClosureOldTrace.First.Trace>>
typealias ClosureOldG = LastAnswerFromTrace<ClosureOldTrace.Next.Trace>
typealias ClosureOldEvidence = JointEvidenceFromMemory<ClosureOldF, ClosureOldG>
typealias ClosureOldCoordinates = AnswerOnRefinement<PreparedBoundaryCoordinatesFromAlpha<ClosureP>, ClosureOldEvidence>
typealias ClosureOldTable = AnswerOnRefinement<ClosureTableFactor, ClosureOldCoordinates>
typealias ClosureOldFuture = FutureOnEvidence<ClosureESE, ClosureEndpoint, ClosureOldTable>
enum ClosurePreparedFutureNeedsNoNewRead: Null {
    typealias Left = ClosureOldFuture.Right.Left
    typealias Right = ClosureOldTrace.Next.Trace.Right
}
enum ClosureOldAndFullEvidenceAgree: Null {
    typealias Left = ClosureOldFuture.Answer
    typealias Right = ClosureFuture.Answer
}

// An alpha-only memory merges these sources, while one E distinguishes
// their common answers. Beta remains at its actual source address.
typealias ClosureMissing0 = ClosureSource<Never, Never, Never, Never>
typealias ClosureMissing1 = ClosureSource<Never, Lit1, Never, Never>
enum ClosureOldAlphaMemorySame: Null {
    typealias Left = FactOf<BoundaryPairReading<ClosureMissing0>>
    typealias Right = FactOf<BoundaryPairReading<ClosureMissing1>>
}
enum ClosureMissingBetaPositive: Pair {
    typealias Witness = ZeroSuccessorBoundary<BoundaryFirstBeta<ClosureMissing0>, BoundaryFirstBeta<ClosureMissing1>, Never>
    typealias Left = Witness.Left
    typealias Right = Witness.Right
}
typealias ClosureExtraQuestion = ZeroSuccessorBoundary<BoundaryFirstAlpha<ClosureSource<Never, Never, Lit1, Lit1>>, BoundaryFirstAlpha<ClosureSource<Lit1, Lit1, Never, Never>>, Never>

// The resident word supplies the operation order and retains consumed heads.
typealias ClosureTape = Paired<FirstFieldsOperation, Paired<SwapOperation, Never>>
typealias ClosureCommandE = ResidentBoundaryCommand<ClosureRawE.SourceStep, ClosureTape, Never>
typealias ClosureCommandS = ResidentBoundaryCommand<ClosureRawS.SourceStep, ClosureTape.Right, Paired<FirstFieldsOperation, Never>>
enum ClosureResidentMiddle: Null {
    typealias Left = ClosureCommandE.Right
    typealias Right = ClosureCommandS.Left
}
enum ClosureResidentRecordRetainsWhole: Null {
    typealias Record = RecordedBoundaryCommand<ClosureRawE.SourceStep, ClosureTape, Never>
    typealias Left = Record.Right.Left
    typealias Right = ClosureCommandE.Left
}

// Four prepared seeds cover the reachable carrier in four disjoint orbits.
// These are witnesses of reachability, not an executed enumeration.
typealias ClosureSeed1 = ClosureMixed<ClosureSource<Never, Never, Never, Lit1>>
typealias ClosureSeed3 = ClosureMixed<ClosureSource<Lit1, Never, Lit1, Lit1>>
typealias ClosureSeed2 = ClosureMixed<ClosureSource<Lit1, Never, Never, Lit1>>
typealias ClosureSwap1 = BoundaryCoordinatesSwap<ClosureSeed1.Left>
typealias ClosureSwap1E = BoundaryCoordinatesExchange<ClosureSwap1.SourceStep.Answer>
typealias ClosureSwap1ES = BoundaryCoordinatesSwap<ClosureSwap1E.SourceStep.Answer>
enum ClosureOrbitOne: Null {
    typealias Left = Paired<BoundaryCoordinates<ClosureSeed1.Left>.Answer, Paired<ClosureSwap1.Right.Answer, Paired<ClosureSwap1E.Right.Answer, ClosureSwap1ES.Right.Answer>>>
    typealias Right = Paired<Boundary0001.Left, Paired<Boundary0100.Left, Paired<Boundary1000.Left, Boundary0010.Left>>>
}
enum ClosureOrbitThree: Null {
    typealias Left = Paired<BoundaryCoordinates<ClosureSeed3.Left>.Answer, Paired<ClosureSeed3.E.Right.Answer, Paired<BoundaryCoordinatesSwap<ClosureSeed3.Left>.Right.Answer, ClosureSeed3.ES.Right.Answer>>>
    typealias Right = Paired<Boundary1011.Left, Paired<Boundary0111.Left, Paired<Boundary1110.Left, Boundary1101.Left>>>
}
typealias ClosureSwap2 = BoundaryCoordinatesSwap<ClosureSeed2.Left>
typealias ClosureSwap2E = BoundaryCoordinatesExchange<ClosureSwap2.SourceStep.Answer>
typealias ClosureSwap2ES = BoundaryCoordinatesSwap<ClosureSwap2E.SourceStep.Answer>
enum ClosureOrbitMixed: Null {
    typealias Left = Paired<BoundaryCoordinates<ClosureSeed2.Left>.Answer, Paired<ClosureSeed2.E.Right.Answer, Paired<ClosureSwap2ES.Right.Answer, ClosureSeed2.ESES.Right.Answer>>>
    typealias Right = Paired<Boundary1001.Left, Paired<Boundary0101.Left, Paired<Boundary1010.Left, Boundary0110.Left>>>
}
enum ClosureOrbitHomogeneous: Null {
    typealias P = ClosureSource<Never, Never, Lit1, Lit1>
    typealias Left = Paired<BoundaryCoordinates<P>.Answer, BoundaryCoordinatesSwap<P>.Right.Answer>
    typealias Right = Paired<Boundary0011.Left, Boundary1100.Left>
}

// A changed connection exposes the formerly merged orientation while the
// observed question remains CommonBoundaryQuestion.
typealias ClosureCross0 = BoundaryCoordinatesCross<ClosureSource<Never, Never, Lit1, Lit1>>
typealias ClosureCross1 = BoundaryCoordinatesCross<ClosureSource<Lit1, Lit1, Never, Never>>
typealias ClosureCrossQuestion0 = QuestionOnObservation<ClosureCross0.Right, Boundary1010>
typealias ClosureCrossQuestion1 = QuestionOnObservation<ClosureCross1.Right, Boundary0101>
typealias ClosureCrossCommon0 = QuestionOnObservation<ClosureCrossQuestion0.Left, ReadBoundaryTable<ClosureCrossQuestion0.Answer>>
typealias ClosureCrossCommon1 = QuestionOnObservation<ClosureCrossQuestion1.Left, ReadBoundaryTable<ClosureCrossQuestion1.Answer>>
enum ClosureCrossSeparatesCommonAnswers: Null {
    typealias Left = Paired<ClosureCrossCommon1.Answer, ClosureCrossCommon0.Answer>
    typealias Right = Paired<ClosureJ0, ClosureJ1>
}
typealias ClosureCrossPositiveValue = ZeroSuccessorBoundary<ReadRecordedAnswer<ClosureCrossCommon1.Answer>, ReadRecordedAnswer<ClosureCrossCommon0.Answer>, Never>
enum ClosureCrossTwice<P: Pair>: Null
where P.Left: BeamShape, P.Right: BeamShape {
    typealias First = BoundaryCoordinatesCross<P>
    typealias Second = BoundaryCoordinatesCross<First.SourceStep.Answer>
    typealias Path = JoinedTransition<First, Second>
    typealias Left = Path.Right.Answer
    typealias Right = BoundaryCoordinates<P>.Answer
}
enum ClosureCrossRetainsHidden<P: Pair>: Null
where P.Left: BeamShape, P.Right: BeamShape {
    typealias End = CrossBoundaryReading<P>.Answer
    typealias Left = Paired<End.Left.PaschenLevel, End.Right.PaschenLevel>
    typealias Right = Paired<P.Left.PaschenLevel, P.Right.PaschenLevel>
}
typealias ClosureMixedCross = JoinedTransition<ClosureMixed<ClosureP>.ESES, BoundaryCoordinatesCross<ClosureMixed<ClosureP>.ESES.SourceStep.Answer>>

#if CLOSURE_WRONG_MIDDLE
typealias RejectedClosureMiddle = JoinedTransition<ClosureRawE, BoundaryCoordinatesSwap<ClosureP>>
#endif
#if CLOSURE_REAPPLIES_ZERO
typealias RejectedClosureZero = BoundaryFirstZeroTransition<ClosureRawE.SourceStep.Answer>
#endif
#if CLOSURE_WRONG_COMPARISON_ADDRESS
typealias RejectedClosureAddress = BoundaryTable<Boundary1001.Left, Boundary01, Boundary11, Boundary00, Boundary01>
#endif
#if CLOSURE_WRONG_MEMORY_SOURCE
typealias RejectedClosureSource = AnswerOnRefinement<ClosureTableFactor, AcquiredBoundaryCoordinates<ClosureSource<Lit1, Never, Never, Never>>>
#endif
#if CLOSURE_ALPHA_ONLY_SUFFICES
typealias RejectedClosureAlpha = AnswerOnRefinement<ClosureTableFactor, AcquireAnswer<BoundaryPairReading<ClosureP>>>
#endif
#if CLOSURE_OTHER_ENDPOINT
typealias RejectedClosureEndpoint = FutureOnEvidence<ClosureESE, QuestionOnObservation<ClosureE.Right, ReadBoundaryTable<ClosureE.Right.Answer>>, ClosureAcquiredTable>
#endif
#if CLOSURE_ERASES_PATH
enum RejectedClosurePath: Null {
    typealias Left = ClosureFuture.Predicate
    typealias Right = CommonBoundaryQuestion
}
#endif
#if CLOSURE_RECOVERS_ORIENTATION
enum RejectedClosureOrientation: Null {
    typealias Left = Boundary0011.Left
    typealias Right = Boundary1100.Left
}
#endif
#if CLOSURE_FAILURE_IS_ANSWER
enum RejectedClosureFailure: HasVerdict {
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Predicate = AlphaQuestion
    typealias Answer = ClosureB.Answer
}
#endif
#if CLOSURE_HISTORY_IS_CURRENT
enum RejectedClosureHistory: Null {
    typealias Left = RetainedWhole<ClosureP, ClosureMixed<ClosureP>.ESES.SourceStep.Answer>
    typealias Right = ClosureP
}
#endif
#if CLOSURE_WRONG_RESIDENT_COMMAND
typealias RejectedClosureCommand = ResidentBoundaryCommand<ClosureRawE.SourceStep, Paired<SwapOperation, Never>, Never>
#endif
#if CLOSURE_PREPARATION_AFTER_EXCHANGE
typealias RejectedClosurePreparation = PreparedBoundaryCoordinatesFromAlpha<ClosureRawE.SourceStep.Answer>
#endif
#if CLOSURE_OLD_CLASS_SURVIVES_CROSS
enum RejectedClosureCrossClass: Null {
    typealias Left = ClosureCrossCommon0.Answer
    typealias Right = ClosureCrossCommon1.Answer
}
#endif
#if CLOSURE_CROSS_IS_OLD_OPERATION
typealias RejectedClosureCrossCommand = ResidentBoundaryCommand<ClosureCross0.SourceStep, Paired<FirstFieldsOperation, Never>, Never>
#endif
