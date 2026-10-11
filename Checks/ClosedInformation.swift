import VerificationIsIdentification
import Examples

// The existing predecessor relation closes on these two actual forms.
// It fixes zero and sends one to zero; no new law marker is supplied.
typealias ResetLawZero = Never
typealias ResetLawOne = Lit1

enum PreparedLawHasItsActualLocalResult<S: Pair>: Null
where S.Right: Structure {
    typealias Left = ReadyLawState<S>.Right.Left.Left
    typealias Right = S.Right
}

enum CompleteLawExchangeReturns<S: Pair>: Null
where S.Right: Structure {
    typealias Left = ReadyLawState<S>.Right.Right
    typealias Right = ReadyLawState<S>
}

enum RecordedLawExchangeReturns<S: Pair>: Null
where S.Right: Structure {
    typealias Left = RecordedLawState<S>.Right.Right
    typealias Right = RecordedLawState<S>
}

enum LawOutputFieldsRecoverPreparation<S: Pair>: Null
where S.Right: Structure {
    typealias Left = ReadPreparedLawSource<RecordedLawState<S>.Left>.Right
    typealias Right = ReadyLawState<S>.Left
}

enum CompleteLawFieldsIdentifySources<S: Pair, T: Pair>: Null
where S.Right: Structure, T.Right: Structure,
      RecordedLawState<S>.Left == RecordedLawState<T>.Left {
    typealias Left = S
    typealias Right = T
}

enum LocalResetOutputsAgree: Null {
    typealias Left = ReadyLawState<ResetLawZero>.Right.Left.Left
    typealias Right = ReadyLawState<ResetLawOne>.Right.Left.Left
}

enum LocalResetReturnsItsPositiveSource: Null {
    typealias Left = ReadyLawState<ResetLawOne>.Right.Right.Left.Left
    typealias Right = Lit1
}

enum RepeatedLocalResetWouldStayZero: Null {
    typealias Left = ResetLawOne.Right.Right
    typealias Right = Never
}

// The predecessor law is idempotent on this entire declared local carrier.
enum LocalResetIsIdempotentOnDeclaredCarrier: Null {
    typealias Left = Paired<ResetLawZero.Right.Right, ResetLawOne.Right.Right>
    typealias Right = Paired<ResetLawZero.Right, ResetLawOne.Right>
}

// A prepared zero and the recorded image of one expose the same current
// zero. Their next whole steps give different local answers. Thus this
// current reading cannot carry one deterministic factor on both phases.
enum LocalResetCoarseInputsAgree: Null {
    typealias Left = ReadyLawState<ResetLawZero>.Left.Left
    typealias Right = RecordedLawState<ResetLawOne>.Left.Left
}
typealias LocalResetCoarseFutureRefusal = ZeroSuccessorBoundaryPairClass<
    Paired<ReadyLawState<ResetLawZero>.Right.Left.Left,
        RecordedLawState<ResetLawOne>.Right.Left.Left>, Never>

enum RecordedZeroIsStillAProperRecord: Null {
    typealias Left = ReadyLawState<ResetLawZero>.Right.Left.Right.Left
    typealias Right = ResetLawZero
}

enum ExtendedLawRecordFollowsSource<X: Pair>: Null
where X.Right: Pair, X.Right.Right: Structure {
    typealias Left = ExtendLawRecord<X>.Right.Right
    typealias Right = X.Right.Right
}

enum ExtendedLawRecordRecoversWhole<X: Pair>: Null
where X.Right: Pair, X.Right.Right: Structure {
    typealias Left = ExtendLawRecord<X>.Right.Left
    typealias Right = X
}

enum TwoRecordedLawStepsFollowSource<X: Pair>: Null
where X.Right: Pair, X.Right.Right: Pair, X.Right.Right.Right: Structure {
    typealias Left = ExtendLawRecord<ExtendLawRecord<X>.Right>.Right.Right
    typealias Right = X.Right.Right.Right
}

typealias ZeroLawRecord = Paired<Never, ResetLawZero>
typealias FirstZeroLawRecord = ExtendLawRecord<ZeroLawRecord>.Right
typealias SecondZeroLawRecord = ExtendLawRecord<FirstZeroLawRecord>.Right

enum RepeatedZeroRecordsHaveTheSameLocalForm: Null {
    typealias Left = FirstZeroLawRecord.Right
    typealias Right = SecondZeroLawRecord.Right
}

typealias RecordedSwapCycle = RecordedSwapReturn<Lit1, Never>
// One fixed address Right.Right.Left separates the initial and final records.
typealias RecordedSwapCyclePositiveRefusal = ZeroSuccessorBoundaryPairClass<
    Paired<RecordedSwapCycle.Before.Right.Right.Left,
        RecordedSwapCycle.After.Right.Right.Left>, Never>

#if WHOLE_SWAP_RETURN_ERASES_HISTORY
enum RejectedSwapReturnHistory: Null {
    typealias Left = RecordedSwapCycle.After
    typealias Right = RecordedSwapCycle.Before
}
#endif

#if WHOLE_LAW_REPEATED_ZERO_ERASES_OCCURRENCE
enum RejectedLawOccurrenceErasure: Null {
    typealias Left = FirstZeroLawRecord
    typealias Right = SecondZeroLawRecord
}
#endif

#if WHOLE_LAW_LOCAL_IMAGE_IDENTIFIES_SOURCE
enum RejectedLawLocalRecovery: Null {
    typealias Left = ReadPreparedLawSource<RecordedLawState<ResetLawZero>.Left>.Right
    typealias Right = ReadPreparedLawSource<RecordedLawState<ResetLawOne>.Left>.Right
}
#endif

#if WHOLE_LAW_EXCHANGE_IS_REPEATED_LOCAL_RESET
enum RejectedLawResetReuse: Null {
    typealias Left = ReadyLawState<ResetLawOne>.Right.Right.Left.Left
    typealias Right = ResetLawOne.Right.Right
}
#endif

#if WHOLE_LAW_READY_IS_RECORDED
enum RejectedLawReadyRecordCollapse: Null {
    typealias Left = ReadyLawState<ResetLawZero>.Left
    typealias Right = RecordedLawState<ResetLawZero>.Left
}
#endif

#if WHOLE_LAW_RECORD_ACCEPTS_OTHER_RESULT
enum RejectedLawOtherLocalResult: Null {
    typealias Left = RecordedLawState<ResetLawOne>.Left
    typealias Right = Paired<ResetLawOne, Paired<ResetLawOne, Never>>
}
#endif

// Either addressed prerequisite can supply the new occurrence. The source
// and the operation that actually supplied it remain in the complete record.
typealias FirstOccurrence<B: Structure> = FirstEvidenceImage<Paired<Lit1, B>, Never, Never, FirstProjection>
typealias SecondOccurrence<A: Structure> = SecondEvidenceImage<Paired<A, Lit1>, Never, Never, SecondProjection>

enum FirstWitnessConstructsOccurrence<B: Structure>: Null {
    typealias Left = OccurrenceImage<FirstOccurrence<B>>.Answer
    typealias Right = Paired<Paired<Lit1, B>, Lit1>
}

enum SecondWitnessConstructsOccurrence<A: Structure>: Null {
    typealias Left = OccurrenceImage<SecondOccurrence<A>>.Answer
    typealias Right = Paired<Paired<A, Lit1>, Lit1>
}

enum OccurrenceRecoversItsActualSource<R: PredicateReading>: Null
where R.Left: Structure, R.Predicate: Structure, R.Answer == Lit1 {
    typealias Left = WitnessedOccurrence<R>.Right.Left
    typealias Right = R.Left
}

enum OccurrenceRetainsItsActualOperation<R: PredicateReading>: Null
where R.Left: Structure, R.Predicate: Structure, R.Answer == Lit1 {
    typealias Left = WitnessedOccurrence<R>.Right.Right.Left
    typealias Right = R.Predicate
}

enum SameOccurrenceImageCanOmitDifferentWitnesses: Null {
    typealias Left = OccurrenceImage<FirstOccurrence<Lit1>>.Answer
    typealias Right = OccurrenceImage<SecondOccurrence<Lit1>>.Answer
}

// Positive witnesses: c is admitted without b and without a respectively.
enum FirstOccurrenceNeedsNoSecondPrerequisite: Null {
    typealias Left = WitnessedOccurrence<FirstOccurrence<Never>>.Right.Left.Right
    typealias Right = Never
}

enum SecondOccurrenceNeedsNoFirstPrerequisite: Null {
    typealias Left = WitnessedOccurrence<SecondOccurrence<Never>>.Right.Left.Left
    typealias Right = Never
}

#if WHOLE_OCCURRENCE_WITHOUT_FIRST_WITNESS
typealias RejectedAbsentFirstWitness = WitnessedOccurrence<
    FirstEvidenceImage<Paired<Never, Never>, Never, Never, FirstProjection>
>
#endif

#if WHOLE_OCCURRENCE_WITHOUT_SECOND_WITNESS
typealias RejectedAbsentSecondWitness = WitnessedOccurrence<
    SecondEvidenceImage<Paired<Never, Never>, Never, Never, SecondProjection>
>
#endif

#if WHOLE_OCCURRENCE_IMAGE_ERASES_WITNESS
enum RejectedOccurrenceWitnessErasure: Null {
    typealias Left = WitnessedOccurrence<FirstOccurrence<Lit1>>.Right
    typealias Right = WitnessedOccurrence<SecondOccurrence<Lit1>>.Right
}
#endif

#if WHOLE_OCCURRENCE_USES_OTHER_SOURCE
enum RejectedOccurrenceOtherSource: Null {
    typealias Left = OccurrenceImage<FirstOccurrence<Never>>.Left
    typealias Right = WitnessedOccurrence<SecondOccurrence<Never>>.Right
}
#endif

// Recovery follows from the existing Permanent relation for arbitrary R.
enum PreviousWholeFollows<R: Permanent>: Null {
    typealias Left = R.Right.Left
    typealias Right = R.Left
}

enum PreviousConstructionFollows<Before: Structure, Event: Structure>: Null {
    typealias Left = RetainedWhole<Before, Event>.Right.Left
    typealias Right = Before
}

// Swift keeps distinct wrapper names. These prove component recovery, rather
// than pretending InternalSwap<InternalSwap<S>> is nominally equal to S.
enum WholeLeftReturns<S: Pair>: Null {
    typealias Left = InternalSwap<InternalSwap<S>>.Left
    typealias Right = S.Left
}

enum WholeRightReturns<S: Pair>: Null {
    typealias Left = InternalSwap<InternalSwap<S>>.Right
    typealias Right = S.Right
}

// The exchange recovers every weight, independent of its numeric meaning.
enum ParityWeightExchangeReturns<W: Pair>: Null
where W.Left: Pair, W.Right: Pair,
      W.Left.Left: Pair, W.Left.Right: Pair,
      W.Right.Left: Pair, W.Right.Right: Pair,
      W.Left.Left.Left: Structure, W.Left.Left.Right: Structure,
      W.Left.Right.Left: Structure, W.Left.Right.Right: Structure,
      W.Right.Left.Left: Structure, W.Right.Left.Right: Structure,
      W.Right.Right.Left: Structure, W.Right.Right.Right: Structure {
    typealias Left = ExchangeParityWeights<ExchangeParityWeights<W>.Right>.Right
    typealias Right = RoutingCoordinates<W>.Answer
}

// Unit weights on even and odd parity supports, each normalized by four
// in the article. Neither source is declared equal to its marginal tables.
typealias EvenParityWeights = Paired<MatrixEntries<Lit1, Never, Never, Lit1>,
    MatrixEntries<Never, Lit1, Lit1, Never>>
typealias OddParityWeights = Paired<MatrixEntries<Never, Lit1, Lit1, Never>,
    MatrixEntries<Lit1, Never, Never, Lit1>>
typealias SumWeight01 = AddZero<Lit1>
typealias SumWeight10 = AddSuccessor<AddZero<Never>>
typealias EvenMarginalSum = AddNaturalMatrices<
    SumWeight10, SumWeight01, SumWeight01, SumWeight10>
typealias OddMarginalSum = AddNaturalMatrices<
    SumWeight01, SumWeight10, SumWeight10, SumWeight01>

// Each arithmetic input is checked against the actual regrouped source.
enum AllEvenMarginalOperandsMatch: Null {
    typealias Left = ThreeBitMarginalOperands<EvenParityWeights>.Right
    typealias Right = AddressTriple<EvenMarginalSum.Left,
        EvenMarginalSum.Left, EvenMarginalSum.Left>
}
enum AllOddMarginalOperandsMatch: Null {
    typealias Left = ThreeBitMarginalOperands<OddParityWeights>.Right
    typealias Right = AddressTriple<OddMarginalSum.Left,
        OddMarginalSum.Left, OddMarginalSum.Left>
}
enum AllPairMarginalsAgree: Null {
    typealias Left = Paired<EvenMarginalSum.Answer, OddMarginalSum.Answer>
    typealias Right = Paired<MatrixEntries<Lit1, Lit1, Lit1, Lit1>,
        MatrixEntries<Lit1, Lit1, Lit1, Lit1>>
}

typealias RevealedEvenParity = ExchangeParityWeights<EvenParityWeights>.Right
typealias RevealedOddParity = ExchangeParityWeights<OddParityWeights>.Right
typealias SumWeight00 = AddZero<Never>
typealias SumWeight11 = AddSuccessor<AddZero<Lit1>>
typealias RevealedEvenSum = AddNaturalMatrices<
    SumWeight11, SumWeight00, SumWeight00, SumWeight11>
typealias RevealedOddSum = AddNaturalMatrices<
    SumWeight00, SumWeight11, SumWeight11, SumWeight00>
enum RevealedMarginalOperandsMatch: Null {
    typealias Left = Paired<ThreeBitMarginalOperands<RevealedEvenParity>.WithoutLast,
        ThreeBitMarginalOperands<RevealedOddParity>.WithoutLast>
    typealias Right = Paired<RevealedEvenSum.Left, RevealedOddSum.Left>
}
enum RevealedPairHasOppositeRelations: Null {
    typealias Left = Paired<RevealedEvenSum.Answer, RevealedOddSum.Answer>
    typealias Right = Paired<MatrixEntries<Lit2, Never, Never, Lit2>,
        MatrixEntries<Never, Lit2, Lit2, Never>>
}
typealias HiddenWholeWeightDiffers = ZeroSuccessorBoundaryPairClass<
    Paired<OddParityWeights.Left.Left.Left, EvenParityWeights.Left.Left.Left>, Never>
typealias RevealedJointWeightDiffers = ZeroSuccessorBoundaryPairClass<
    Paired<RevealedOddSum.Answer.Left.Left, RevealedEvenSum.Answer.Left.Left>, Lit1>

// VC23a's four-valued latent centre is the actual input pair of the existing
// finite parity clauses. No new truth table or runtime XOR is introduced.
typealias LatentParityTriple<R: PredicateReading> = AddressTriple<
    R.Left.Left, R.Left.Right, R.Answer.Left>
where R.Left: Pair, R.Answer: Pair, R.Left.Left: Structure,
      R.Left.Right: Structure, R.Answer.Left: Structure
enum LatentPairConstructsAllEvenTriples: Null {
    typealias Left = Paired<
        Paired<LatentParityTriple<EqualPairParity<Never>>, LatentParityTriple<ZeroOneParity>>,
        Paired<LatentParityTriple<OneZeroParity>, LatentParityTriple<EqualPairParity<Lit1>>>>
    typealias Right = Paired<
        Paired<AddressTriple<Never, Never, Never>, AddressTriple<Never, Lit1, Lit1>>,
        Paired<AddressTriple<Lit1, Never, Lit1>, AddressTriple<Lit1, Lit1, Never>>>
}

// Majority on a repeated-value schema is an existing projection. The three
// clauses below cover Boolean triples by which two positions share a value.
typealias MajorityFirstTwo<A: Structure, B: Structure> = FirstEvidenceImage<
    AddressTriple<A, A, B>, BeamSpace, SaturationEncoding, FirstProjection>
typealias MajorityOuter<A: Structure, B: Structure> = FirstEvidenceImage<
    AddressTriple<A, B, A>, BeamSpace, SaturationEncoding, FirstProjection>
typealias MajorityLastTwo<A: Structure, B: Structure> = SequentialReading<
    SecondEvidenceImage<AddressTriple<B, A, A>, BeamSpace, SaturationEncoding, SecondProjection>,
    FirstEvidenceImage<Paired<A, A>, BeamSpace, SaturationEncoding, FirstProjection>>
typealias MajorityParityRow1 = LatentParityTriple<EqualPairParity<Lit1>>
typealias MajorityParityRow2 = LatentParityTriple<OneZeroParity>
typealias MajorityParityRow3 = LatentParityTriple<ZeroOneParity>
enum MajorityReadsActualParityColumns: Null {
    typealias Left = AddressTriple<
        AddressTriple<MajorityParityRow1.Left, MajorityParityRow2.Left, MajorityParityRow3.Left>,
        AddressTriple<MajorityParityRow1.Right.Left, MajorityParityRow2.Right.Left, MajorityParityRow3.Right.Left>,
        AddressTriple<MajorityParityRow1.Right.Right, MajorityParityRow2.Right.Right, MajorityParityRow3.Right.Right>>
    typealias Right = AddressTriple<MajorityFirstTwo<Lit1, Never>.Left,
        MajorityOuter<Lit1, Never>.Left, MajorityLastTwo<Lit1, Never>.Left>
}
typealias MajorityParityOutput = AddressTriple<MajorityFirstTwo<Lit1, Never>.Answer,
    MajorityOuter<Lit1, Never>.Answer, MajorityLastTwo<Lit1, Never>.Answer>
typealias MajorityFirstPairParity = EqualPairParity<MajorityParityOutput.Left>
enum MajorityParityCheckUsesActualPair: Null {
    typealias Left = MajorityFirstPairParity.Left
    typealias Right = Paired<MajorityParityOutput.Left, MajorityParityOutput.Right.Left>
}
typealias MajorityBreaksEvenParity = ZeroSuccessorBoundaryPairClass<
    Paired<MajorityFirstPairParity.Answer.Left, MajorityParityOutput.Right.Right>, Never>

// VC23d: an actual odd support implies a true input literal. These are
// finite constructor expressions over Never/Lit1, with every input and
// support position retained. The parity clauses already belong to VI.
// Arbitrary Pair conformances are not admitted proofs of this grammar.
enum EmptySupportedParity: Pair {
    typealias Left = Paired<Never, Never>
    typealias Right = Never
}

enum AppendUnselectedLiteral<P: Pair, X: Structure>: Pair
where P.Left: Pair, P.Left.Left: Structure, P.Left.Right: Structure {
    typealias Left = Paired<Paired<P.Left.Left, X>, Paired<P.Left.Right, Never>>
    typealias Right = P.Right
}

enum AppendSelectedLiteralToEven<P: Pair>: Pair
where P.Left: Pair, P.Left.Left: Structure, P.Left.Right: Structure,
      P.Right == Never {
    typealias Left = Paired<Paired<P.Left.Left, Lit1>, Paired<P.Left.Right, Lit1>>
    typealias Right = ZeroOneParity.Answer.Left
}

enum AppendSelectedLiteralToOdd<P: Pair>: Pair
where P.Left: Pair, P.Left.Left: Structure, P.Left.Right: Structure,
      P.Right == Lit1 {
    typealias Left = Paired<Paired<P.Left.Left, Lit1>, Paired<P.Left.Right, Lit1>>
    typealias Right = EqualPairParity<Lit1>.Answer.Left
}

enum ReadOddSupport<S: Structure, P: Pair>: Pair
where P.Left: Pair, P.Left.Left == S, P.Right == Lit1 {
    typealias Left = S
    typealias Right = P.Left.Right
}

typealias LiteralList3<A: Structure, B: Structure, C: Structure> =
    Paired<Paired<Paired<Never, A>, B>, C>
typealias FirstLiteralSupport<B: Structure, C: Structure> =
    AppendUnselectedLiteral<AppendUnselectedLiteral<
        AppendSelectedLiteralToEven<EmptySupportedParity>, B>, C>
typealias MiddleLiteralSupport<A: Structure, C: Structure> =
    AppendUnselectedLiteral<AppendSelectedLiteralToEven<
        AppendUnselectedLiteral<EmptySupportedParity, A>>, C>
typealias LastLiteralSupport<A: Structure, B: Structure> =
    AppendSelectedLiteralToEven<AppendUnselectedLiteral<
        AppendUnselectedLiteral<EmptySupportedParity, A>, B>>

enum AnyActualTruePositionSuppliesOddSupport<A: Structure, B: Structure>: Null {
    typealias First = ReadOddSupport<LiteralList3<Lit1, A, B>, FirstLiteralSupport<A, B>>
    typealias Middle = ReadOddSupport<LiteralList3<A, Lit1, B>, MiddleLiteralSupport<A, B>>
    typealias Last = ReadOddSupport<LiteralList3<A, B, Lit1>, LastLiteralSupport<A, B>>
    typealias Left = AddressTriple<First.Right, Middle.Right, Last.Right>
    typealias Right = AddressTriple<LiteralList3<Lit1, Never, Never>,
        LiteralList3<Never, Lit1, Never>, LiteralList3<Never, Never, Lit1>>
}

// Existing odd evidence remains valid after adding any unselected literal.
// The generic body derives both retained fields from the extension.
enum OddSupportSurvivesAnUnusedLiteral<P: Pair, X: Structure>: Null
where P.Left: Pair, P.Left.Left: Structure, P.Left.Right: Structure,
      P.Right == Lit1 {
    typealias Extension = AppendUnselectedLiteral<P, X>
    typealias Read = ReadOddSupport<Extension.Left.Left, Extension>
    typealias Left = Paired<Read.Left.Left, Read.Right.Left>
    typealias Right = Paired<P.Left.Left, P.Left.Right>
}

typealias TwoSelectedLiterals = AppendSelectedLiteralToOdd<
    AppendSelectedLiteralToEven<EmptySupportedParity>>
typealias ThreeSelectedLiterals = AppendSelectedLiteralToEven<TwoSelectedLiterals>
typealias AllThreeCanSupportTheSameClause = ReadOddSupport<
    LiteralList3<Lit1, Lit1, Lit1>, ThreeSelectedLiterals>
typealias NoSelectedLiteral = AppendUnselectedLiteral<AppendUnselectedLiteral<
    AppendUnselectedLiteral<EmptySupportedParity, Never>, Never>, Never>
enum ThirdSelectionUsesTheRetainedParity: Null {
    typealias Left = Paired<TwoSelectedLiterals.Right, ThreeSelectedLiterals.Right>
    typealias Right = Paired<Never, Lit1>
}

// The arbitrary ternary contact needs only its zero and three unit rows.
// All four other entries remain generic and are never queried here.
// The record retains one actual table for both admission and refusal.
enum FourContactsSupplyClauseSupports<T: Pair, A: Structure, B: Structure>: Pair
where T.Left: Pair, T.Right: Pair,
      T.Left.Left: Pair, T.Left.Right: Pair, T.Right.Left: Pair,
      T.Left.Left.Left == Never,
      T.Left.Left.Right == Lit1, T.Left.Right.Left == Lit1,
      T.Right.Left.Left == Lit1 {
    typealias First = ReadOddSupport<LiteralList3<T.Right.Left.Left, A, B>,
        FirstLiteralSupport<A, B>>
    typealias Middle = ReadOddSupport<LiteralList3<A, T.Left.Right.Left, B>,
        MiddleLiteralSupport<A, B>>
    typealias Last = ReadOddSupport<LiteralList3<A, B, T.Left.Left.Right>,
        LastLiteralSupport<A, B>>
    typealias AllOffRefusal = ZeroSuccessorBoundaryPairClass<
        Paired<T.Left.Left.Left, T.Right.Left.Left>, Never>
    typealias Left = T
    typealias Right = AddressTriple<First.Right, Middle.Right, Last.Right>
}

typealias ContactWithFourUnknownEntries<U: Structure, V: Structure,
    W: Structure, X: Structure> = Paired<
        MatrixEntries<Never, Lit1, Lit1, U>, MatrixEntries<Lit1, V, W, X>>

enum FourFactsSufficeForEveryRemainder<U: Structure, V: Structure,
    W: Structure, X: Structure>: Null {
    typealias Source = ContactWithFourUnknownEntries<U, V, W, X>
    typealias Certificate = FourContactsSupplyClauseSupports<Source, Never, Never>
    typealias Left = Paired<Certificate.Left, Certificate.Right>
    typealias Right = Paired<Source,
        AddressTriple<LiteralList3<Lit1, Never, Never>,
            LiteralList3<Never, Lit1, Never>, LiteralList3<Never, Never, Lit1>>>
}

typealias UnitRowsOnly = ContactWithFourUnknownEntries<Never, Never, Never, Never>
typealias UnitRowsAndAllThree = ContactWithFourUnknownEntries<Never, Never, Never, Lit1>
enum SameClauseSupportsDoNotIdentifyThePrimitive: Null {
    typealias Left = FourContactsSupplyClauseSupports<UnitRowsOnly, Never, Never>.Right
    typealias Right = FourContactsSupplyClauseSupports<UnitRowsAndAllThree, Never, Never>.Right
}
typealias TheRetainedPrimitiveTablesDiffer = ZeroSuccessorBoundaryPairClass<
    Paired<UnitRowsOnly.Right.Right.Right, UnitRowsAndAllThree.Right.Right.Right>, Never>

#if WHOLE_CLAUSE_CONTACT_OMITS_MIDDLE_ADMISSION
typealias RejectedClauseMissingContact = FourContactsSupplyClauseSupports<
    Paired<MatrixEntries<Never, Lit1, Never, Never>,
        MatrixEntries<Lit1, Never, Never, Never>>, Never, Never>
#endif
#if WHOLE_CLAUSE_CONTACT_ALLOWS_EMPTY_SUPPORT
typealias RejectedClauseAllowsEmptyContact = FourContactsSupplyClauseSupports<
    Paired<MatrixEntries<Lit1, Lit1, Lit1, Never>,
        MatrixEntries<Lit1, Never, Never, Never>>, Never, Never>
#endif

#if WHOLE_CLAUSE_SUPPORT_INVENTS_TRUE_INPUT
typealias RejectedClauseInventsTrueInput = ReadOddSupport<
    LiteralList3<Never, Never, Never>, FirstLiteralSupport<Never, Never>>
#endif
#if WHOLE_CLAUSE_EMPTY_SUPPORT_IS_ODD
typealias RejectedClauseEmptySupport = ReadOddSupport<
    LiteralList3<Never, Never, Never>, NoSelectedLiteral>
#endif
#if WHOLE_CLAUSE_EVEN_SUPPORT_IS_ODD
typealias RejectedClauseEvenSupport = ReadOddSupport<
    Paired<Paired<Never, Lit1>, Lit1>, TwoSelectedLiterals>
#endif
#if WHOLE_CLAUSE_RESTARTS_PARITY
typealias RejectedClauseRestartsParity = AppendSelectedLiteralToEven<
    AppendSelectedLiteralToEven<EmptySupportedParity>>
#endif

#if WHOLE_BINARY_CONSTRAINTS_EXPRESS_PARITY
enum RejectedMajorityClosedParity: Null {
    typealias Left = MajorityFirstPairParity.Answer.Left
    typealias Right = MajorityParityOutput.Right.Right
}
#endif

#if WHOLE_PAIR_MARGINALS_IDENTIFY_JOINT
enum RejectedPairMarginalCompleteness: Null {
    typealias Left = EvenParityWeights
    typealias Right = OddParityWeights
}
#endif

#if WHOLE_PAIR_MARGINALS_PREDICT_CONTINUATION
enum RejectedPairMarginalContinuation: Null {
    typealias Left = RevealedEvenSum.Answer
    typealias Right = RevealedOddSum.Answer
}
#endif

enum LocalResetFollows<X: Structure>: Null {
    typealias Left = InternalSwap<Paired<X, Never>>.Left
    typealias Right = Never
}

enum InternalRecoveryFollows<X: Structure>: Null {
    typealias Left = InternalSwap<Paired<X, Never>>.Right
    typealias Right = X
}

#if WHOLE_RECORD_LOSS
enum RejectedRecordLoss: Permanent {
    typealias Left = Paired<Never, Never>
    typealias Right = Paired<Never, Never>
}
#endif

#if WHOLE_OUTPUT_MERGER
// Equal first components after local reset do not identify the whole outputs.
enum RejectedWholeMerger: Null {
    typealias Left = InternalSwap<Paired<Never, Never>>.Right
    typealias Right = InternalSwap<Paired<Paired<Never, Never>, Never>>.Right
}
#endif

enum CompressedAlphaReturns<B: BeamShape>: Null {
    typealias Left = BeamWithResidual<B>.Left.Left
    typealias Right = B.AlphaLevel
}

enum CompressedBetaReturns<B: BeamShape>: Null {
    typealias Left = BeamWithResidual<B>.Left.Right
    typealias Right = B.BetaLevel
}

enum CompressedHiddenReturns<B: BeamShape>: Null {
    typealias Left = BeamWithResidual<B>.Right
    typealias Right = B.PaschenLevel
}

#if COMPRESSED_RESIDUAL_LOSS
enum RejectedResidualLoss: Null {
    typealias Left = BeamWithResidual<RedBeamWithIR>.Right
    typealias Right = Never
}
#endif

// Equal sides give an equality witness, not identity with the syntax leaf.
enum EqualSidesWitness: Null {
    typealias Left = Never
    typealias Right = Never
}

// The existing non-Never carrier also satisfies Unique's projection law.
extension EqualSidesWitness: Unique {}

enum UniqueRetainsItsFixedProjection<U: Unique>: Null {
    typealias Left = U.Left.Left
    typealias Right = U.Left
}

// The common side's other projection remains unconstrained. This recursive
// nominal family is not a finite tree in the EiF constructor grammar.
enum LeftFixedWithResidual<A: Structure>: Pair {
    typealias Left = LeftFixedWithResidual<A>
    typealias Right = A
}

enum UniqueWithResidual<A: Structure>: Unique {
    typealias Left = LeftFixedWithResidual<A>
    typealias Right = LeftFixedWithResidual<A>
}

enum UniqueDoesNotEraseItsOtherProjection<A: Structure>: Null {
    typealias Left = UniqueWithResidual<A>.Left.Right
    typealias Right = A
}

// Measurable constrains each output, not the dependency between inputs
// and outputs of distinct declarations. IdentityReading derives Null
// directly from its existing source/answer equations.
enum ChosenMeasurement<S, A>: Measurable {
    typealias Left = S
    typealias Right = IdentityReading<A, BeamSpace, SaturationEncoding>
}

typealias MeasurementZero = ChosenMeasurement<Never, Never>
typealias MeasurementOne = ChosenMeasurement<Never, Lit1>
typealias SameInputDifferentMeasuredAnswers = ZeroSuccessorDistinction<Never>

enum MeasurementCounterexampleUsesItsActualOutputs: Null {
    typealias Left = Paired<MeasurementZero.Right.Left, MeasurementOne.Right.Left>
    typealias Right = Paired<SameInputDifferentMeasuredAnswers.Left, SameInputDifferentMeasuredAnswers.Right>
}

enum ChosenDecision<S, O: Pair>: Decidable {
    typealias Left = S
    typealias Right = O
}

typealias UnrestrictedDecision = ChosenDecision<Never, Paired<Lit2, Lit2>>

#if MARKER_MEASURABLE_FORCES_FUNCTIONALITY
enum RejectedMeasurementFunctionality: Null {
    typealias Left = MeasurementZero.Right.Left
    typealias Right = MeasurementOne.Right.Left
}
#endif

#if MARKER_DECIDABLE_FORCES_BINARY_VALUE
enum RejectedDecisionBit: Null {
    typealias Left = UnrestrictedDecision.Right.Left
    typealias Right = Lit1
}
#endif

#if UNIQUE_ERASES_RESIDUAL
enum RejectedUniqueResidualErasure: Null {
    typealias Left = UniqueWithResidual<Lit1>.Left.Right
    typealias Right = Never
}
#endif

#if EQUALITY_IS_NOT_FLOOR
enum RejectedEqualityAsFloor: Null {
    typealias Left = EqualSidesWitness
    typealias Right = Never
}
#endif

// Adding a second observation recovers the missing coordinate for any pair.
enum WindowRecoversLeft<S: Pair>: Null {
    typealias Left = SwapWindow<S>.Left
    typealias Right = S.Left
}

enum WindowRecoversRight<S: Pair>: Null {
    typealias Left = SwapWindow<S>.Right
    typealias Right = S.Right
}

// E(T(S)) = swap(E(S)), checked at both component addresses.
enum WindowStepLeft<S: Pair>: Null {
    typealias Left = SwapWindow<InternalSwap<S>>.Left
    typealias Right = InternalSwap<SwapWindow<S>>.Left
}

enum WindowStepRight<S: Pair>: Null {
    typealias Left = SwapWindow<InternalSwap<S>>.Right
    typealias Right = InternalSwap<SwapWindow<S>>.Right
}

enum LocalEqualityWitness<X>: Null {
    typealias Left = X
    typealias Right = X
}

enum GluedEndpointFollows<F: Null, G: Null>: Null where F.Right == G.Left {
    typealias Left = GluedEqualities<F, G>.Left
    typealias Right = G.Right
}

#if ONE_FRAME_PREDICTION
enum RejectedOneFramePrediction: Null {
    typealias Left = SwapWindow<Paired<Never, Never>>.Right
    typealias Right = SwapWindow<Paired<Never, Paired<Never, Never>>>.Right
}
#endif

#if GLUING_WITHOUT_SHARED_MIDDLE
enum RejectedUnmatchedSeam: Null {
    typealias Joined = GluedEqualities<LocalEqualityWitness<Never>, LocalEqualityWitness<Paired<Never, Never>>>
    typealias Left = Joined.Left
    typealias Right = Joined.Right
}
#endif

// M50: retaining the complete represented history and reading its current
// cut are different relations within one paired source.
enum HistoricalOccurrenceQuestion: Close {}
enum CurrentCutQuestion: Close {}

// VC23: mutual support of claims does not supply their proposed input witness.
// These are the two fields of the same recursive source, with distinct questions.
enum TailClaimQuestion: Close {}
enum TailInputQuestion: Close {}
typealias TailClaimReading<C: Structure> = SequentialReading<
    SecondEvidenceImage<ZeroInputClaimTail<C>, BeamSpace, SaturationEncoding, SecondProjection>,
    FirstEvidenceImage<ZeroInputClaimTail<C>.Right, BeamSpace, SaturationEncoding, TailClaimQuestion>
>
typealias TailInputReading<C: Structure> = FirstEvidenceImage<
    ZeroInputClaimTail<C>, BeamSpace, SaturationEncoding, TailInputQuestion
>

enum TailClaimHasRecursiveSupport<C: Structure>: Null {
    typealias Left = TailClaimReading<C>.Answer
    typealias Right = ZeroInputClaimTail<C>.Right.Right.Right.Left
}

enum EveryUnfoldingReturnsTheZeroInput<C: Structure>: Null {
    typealias Left = Paired<ZeroInputClaimTail<C>.Right.Right, TailInputReading<C>.Answer>
    typealias Right = Paired<ZeroInputClaimTail<C>, Never>
}

typealias ZeroClaimHasTailSupport = TailClaimHasRecursiveSupport<Never>
typealias OneClaimHasTailSupport = TailClaimHasRecursiveSupport<Lit1>
typealias PositiveTailClaimCanBeRecorded = WitnessedOccurrence<TailClaimReading<Lit1>>

#if WHOLE_TAIL_CLAIM_IS_INPUT_WITNESS
typealias RejectedTailClaimAsInputWitness = WitnessedOccurrence<TailInputReading<Lit1>>
#endif

// M55: normalize a latest-ended history by finite addresses from its latest
// occurrence. Adding one occurrence retains each old address N at Succ<N>.
// The family is unbounded; no single finite type contains the whole history.
typealias RetainOccurrenceAddress<N: IntegerValued> = Paired<N, Examples.Succ<N>>

enum RetainedAddressRecovers<N: IntegerValued>: Null {
    typealias Leg = RetainOccurrenceAddress<N>
    typealias Left = Leg.Right.Right
    typealias Right = Leg.Left
}

// The earlier step's fresh zero survives the next step as Succ<Never>.
// Each still earlier address Succ<N> survives as Succ<Succ<N>>. A common
// decoder derives their distinction for every N, without a size bound.
typealias OccurrenceSurvivesNextRetention<N: IntegerValued> = RetainedOccurrenceContrast<
    RetainOccurrenceAddress<Never>, RetainOccurrenceAddress<Examples.Succ<N>>, N
>

enum EarlierOccurrenceRemainsDistinguished<N: IntegerValued>: Null {
    typealias Left = OccurrenceSurvivesNextRetention<N>.Left
    typealias Right = Paired<Never, Examples.Succ<N>>
}

// Arbitrary new payloads are allowed when the same projection retains the
// original occurrence. A new payload is not used to select the decoder.
typealias OccurrenceWithOtherCarriers<N: IntegerValued, A: Structure, B: Structure> = RetainedOccurrenceContrast<
    Paired<Never, Paired<A, Never>>, Paired<Examples.Succ<N>, Paired<B, Examples.Succ<N>>>, N
>

// Both maps act on the same address grammar. One and two retentions still
// give different correspondences, even though the endpoint order types agree.
enum TwoRetentionsRecoverTheirActualSource<N: IntegerValued>: Null {
    typealias First = RetainOccurrenceAddress<N>
    typealias Next = RetainOccurrenceAddress<First.Right>
    typealias Left = Next.Right.Right.Right
    typealias Right = First.Left
}

#if WHOLE_RETENTION_ENDPOINT_SHAPE_IS_IDENTITY
enum RejectedRetentionIdentity: Null {
    typealias Left = RetainOccurrenceAddress<Never>.Right
    typealias Right = RetainOccurrenceAddress<Never>.Left
}
#endif

#if WHOLE_RETENTION_MERGES_OCCURRENCES
enum RejectedRetentionOccurrenceMerger: Null {
    typealias Left = RetainOccurrenceAddress<Never>.Right
    typealias Right = RetainOccurrenceAddress<Lit1>.Right
}
#endif

#if WHOLE_RETENTION_ACCEPTS_RESET
typealias RejectedRetentionReset = RetainedOccurrenceContrast<
    Paired<Never, Paired<Never, Never>>,
    Paired<Lit1, Paired<Never, Never>>,
    Never
>
#endif

enum HistoricalProjectionRecovers<X: Structure, Y: Structure>: Null {
    typealias Whole = RetainedWhole<X, Y>.Right
    typealias Left = FirstEvidenceImage<Whole, BeamSpace, SaturationEncoding, HistoricalOccurrenceQuestion>.Answer
    typealias Right = X
}
enum CurrentProjectionCanOmitHistory<X: Structure, Y: Structure>: Null {
    typealias Whole = RetainedWhole<X, Y>.Right
    typealias Left = SecondEvidenceImage<Whole, BeamSpace, SaturationEncoding, CurrentCutQuestion>.Answer
    typealias Right = Y
}
typealias HistoryZeroCurrent = RetainedWhole<Never, Never>.Right
typealias HistoryOneCurrent = RetainedWhole<Lit1, Never>.Right
typealias SameCurrentDifferentHistories = JoinedVerdict<SecondEvidenceImage<HistoryZeroCurrent, BeamSpace, SaturationEncoding, CurrentCutQuestion>, SecondEvidenceImage<HistoryOneCurrent, BeamSpace, SaturationEncoding, CurrentCutQuestion>>
typealias HistoricalDistinctionStillHeld = ZeroSuccessorBoundary<FirstEvidenceImage<HistoryZeroCurrent, BeamSpace, SaturationEncoding, HistoricalOccurrenceQuestion>, FirstEvidenceImage<HistoryOneCurrent, BeamSpace, SaturationEncoding, HistoricalOccurrenceQuestion>, Never>

// M71: preserving every supplied reading of one retained source does not
// select an unconstrained new field. Both projections use the same R.
enum EarlierReadingAcrossDifferentExtensions<R: PredicateReading>: Null
where R.Left: Structure {
    typealias ZeroExtension = RetainedWhole<R.Left, Never>.Right
    typealias OneExtension = RetainedWhole<R.Left, Lit1>.Right
    typealias Left = DecodeRefinedEvidence<
        FirstEvidenceImage<ZeroExtension, R.Sigma, R.Encoding, HistoricalOccurrenceQuestion>, R
    >.Answer
    typealias Right = DecodeRefinedEvidence<
        FirstEvidenceImage<OneExtension, R.Sigma, R.Encoding, HistoricalOccurrenceQuestion>, R
    >.Answer
}

enum NewAnswersRemainDistinguished<H: Structure>: Null {
    typealias ZeroReading = SecondEvidenceImage<RetainedWhole<H, Never>.Right, BeamSpace, SaturationEncoding, CurrentCutQuestion>
    typealias OneReading = SecondEvidenceImage<RetainedWhole<H, Lit1>.Right, BeamSpace, SaturationEncoding, CurrentCutQuestion>
    typealias Contrast = ZeroSuccessorBoundary<ZeroReading, OneReading, Never>
    typealias Left = Paired<Contrast.Left, Contrast.Right>
    typealias Right = Paired<Never, Lit1>
}

#if WHOLE_RETAINED_SOURCE_FIXES_NEW_ANSWER
enum RejectedNewAnswerFromRetainedSource: Null {
    typealias Left = RetainedWhole<Never, Never>.Right.Right
    typealias Right = RetainedWhole<Never, Lit1>.Right.Right
}
#endif

// VC21's finite recovery step uses actual swaps in both directions. The
// observation keeps the pair, and its image step is the same concrete swap.
enum PairSwapSquare<A: Structure, B: Structure>: CommutingTransition {
    typealias Left = IdentityReading<Paired<A, B>, BeamSpace, SaturationEncoding>
    typealias Right = IdentityReading<Paired<B, A>, BeamSpace, SaturationEncoding>
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Operation = SwapOperation
    typealias SourceStep = SwapBoundaryReading<Paired<A, B>>
    typealias ImageStep = SourceStep
}

enum PredecessorReadingRecoversCurrentPair<A: Structure, B: Structure>: Null {
    typealias Certificate = CurrentAnswerFromPredecessor<
        PairSwapSquare<A, B>, SwapBoundaryReading<Paired<B, A>>
    >
    typealias Left = Certificate.Recovery.Answer
    typealias Right = Paired<B, A>
}

enum PredecessorRecoveryStartsAtCurrentPair<A: Structure, B: Structure>: Null {
    typealias Certificate = CurrentAnswerFromPredecessor<
        PairSwapSquare<A, B>, SwapBoundaryReading<Paired<B, A>>
    >
    typealias Left = Certificate.Recovery.Left
    typealias Right = Certificate.Current.Left
}

#if WHOLE_PREDECESSOR_OTHER_START
typealias RejectedPredecessorOtherStart = CurrentAnswerFromPredecessor<
    PairSwapSquare<Never, Lit1>,
    IdentityReading<Paired<Never, Lit1>, BeamSpace, SaturationEncoding>
>
#endif

#if WHOLE_PREDECESSOR_OTHER_END
typealias RejectedPredecessorOtherEnd = CurrentAnswerFromPredecessor<
    PairSwapSquare<Never, Lit1>,
    IdentityReading<Paired<Lit1, Never>, BeamSpace, SaturationEncoding>
>
#endif

// Adversary: each supplied image application captures the hidden B. Its
// operation tag agrees with swap, but its zero input does not determine B.
enum SourceSelectedImageStep<B: Structure>: PredicateReading {
    typealias Left = Never
    typealias Right = B
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Predicate = SwapOperation
    typealias Answer = B
}

enum PointwiseFirstSwap<B: Structure>: CommutingTransition {
    typealias Left = FirstEvidenceImage<Paired<Never, B>, BeamSpace, SaturationEncoding, FirstProjection>
    typealias Right = FirstEvidenceImage<Paired<B, Never>, BeamSpace, SaturationEncoding, FirstProjection>
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Operation = SwapOperation
    typealias SourceStep = SwapBoundaryReading<Paired<Never, B>>
    typealias ImageStep = SourceSelectedImageStep<B>
}

typealias CapturedPredecessorRecovery<B: Structure> = CurrentAnswerFromPredecessor<
    PointwiseFirstSwap<B>, SwapBoundaryReading<Paired<B, Never>>
>

enum PointwiseRecoveryReturnsCapturedField<B: Structure>: Null {
    typealias Left = CapturedPredecessorRecovery<B>.Recovery.Answer
    typealias Right = B
}

enum PointwiseRecoveriesHaveTheSameImage: Null {
    typealias Left = CapturedPredecessorRecovery<Never>.Observation.Answer
    typealias Right = CapturedPredecessorRecovery<Lit1>.Observation.Answer
}

typealias PointwiseRecoveryAnswersDiffer = ZeroSuccessorBoundary<
    CapturedPredecessorRecovery<Never>.Current,
    CapturedPredecessorRecovery<Lit1>.Current,
    Never
>

#if WHOLE_POINTWISE_RECOVERY_IS_UNIFORM
typealias RejectedPointwiseRecoveryAsUniform = JoinedVerdict<
    CapturedPredecessorRecovery<Never>.Current,
    CapturedPredecessorRecovery<Lit1>.Current
>
#endif

// M72 starts from endpoint recovery, then derives a decoder on the actual
// intermediate source. The original first projection at that source can fail.
enum FirstAnswerAfterTwoSwaps<S: Pair>: ReadingFactors
where S.Left: Structure, S.Right: Structure {
    typealias First = SwapBoundaryReading<S>
    typealias Second = SwapBoundaryReading<First.Answer>
    typealias Observation = SequentialReading<First, Second>
    typealias Left = FirstEvidenceImage<S, BeamSpace, SaturationEncoding, HistoricalOccurrenceQuestion>
    typealias Right = FirstEvidenceImage<Observation.Answer, BeamSpace, SaturationEncoding, HistoricalOccurrenceQuestion>
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Predicate = HistoricalOccurrenceQuestion
    typealias Answer = S.Left
}

typealias FirstAnswerAtMiddle<S: Pair> = RecoveryBeforeSuffix<
    SwapBoundaryReading<S>,
    SwapBoundaryReading<SwapBoundaryReading<S>.Answer>,
    FirstAnswerAfterTwoSwaps<S>
>
where S.Left: Structure, S.Right: Structure

// This decoder has only its middle input. It receives no earlier source,
// earlier answer, or source-selected program as another parameter.
typealias ReadAfterResidentSwap<M: Pair> = DecodeRefinedEvidence<
    SwapBoundaryReading<M>,
    FirstEvidenceImage<SwapBoundaryReading<M>.Answer, BeamSpace, SaturationEncoding, HistoricalOccurrenceQuestion>
>
where M.Left: Structure, M.Right: Structure

enum MiddleRecoveryHasOnlyItsActualInput<S: Pair>: Null
where S.Left: Structure, S.Right: Structure {
    typealias Left = FirstAnswerAtMiddle<S>.Right
    typealias Right = ReadAfterResidentSwap<SwapBoundaryReading<S>.Answer>
}

enum MiddleRecoveryIsTheOtherField<S: Pair>: Null
where S.Left: Structure, S.Right: Structure {
    typealias Left = FirstAnswerAtMiddle<S>.Right.Answer
    typealias Right = SwapBoundaryReading<S>.Answer.Right
}

typealias RecoverySourceZero = Paired<Never, Never>
typealias RecoverySourceOne = Paired<Lit1, Never>
typealias RecoveryMiddleZero = SwapBoundaryReading<RecoverySourceZero>.Answer
typealias RecoveryMiddleOne = SwapBoundaryReading<RecoverySourceOne>.Answer

enum BothMiddleFirstFieldsAreTheSame: Null {
    typealias Left = RecoveryMiddleZero.Left
    typealias Right = RecoveryMiddleOne.Left
}

typealias RecoveredContrastAfterSameLocalImage = ZeroSuccessorBoundary<
    ReadAfterResidentSwap<RecoveryMiddleZero>, ReadAfterResidentSwap<RecoveryMiddleOne>, Never
>

#if WHOLE_RECOVERY_NAIVE_MIDDLE_READING
enum RejectedNaiveMiddleReading: Null {
    typealias Left = RecoveryMiddleOne.Left
    typealias Right = FirstAnswerAtMiddle<RecoverySourceOne>.Right.Answer
}
#endif

#if WHOLE_RECOVERY_COARSE_CUT
typealias RejectedRecoveryCoarseCut = RecoveryBeforeSuffix<
    SequentialReading<
        SwapBoundaryReading<RecoverySourceOne>,
        FirstEvidenceImage<RecoveryMiddleOne, BeamSpace, SaturationEncoding, CurrentCutQuestion>
    >,
    SwapBoundaryReading<RecoveryMiddleOne>,
    FirstAnswerAfterTwoSwaps<RecoverySourceOne>
>
#endif

#if WHOLE_RECOVERY_OTHER_SUFFIX
typealias RejectedRecoveryOtherSuffix = RecoveryBeforeSuffix<
    SwapBoundaryReading<RecoverySourceOne>,
    IdentityReading<RecoveryMiddleOne, BeamSpace, SaturationEncoding>,
    FirstAnswerAfterTwoSwaps<RecoverySourceOne>
>
#endif

// M55: closing a recovery chain derives the reverse of its first leg.
// The reverse decoder is composed from the other actual legs. The caller
// supplies no separate reverse certificate or equality of its final answers.
enum RecoveryCycleDerivesReverse<
    First: ReadingFactors,
    Next: ReadingFactors,
    Closing: ReadingFactors
>: Null
where Next.Left == First.Observation,
      Closing.Left == Next.Observation,
      Closing.Observation == First.Left {
    typealias Reverse = AnswerOnRefinement<Next, Closing>
    typealias Left = Paired<Reverse.Left, Reverse.Observation>
    typealias Right = Paired<First.Observation, First.Left>
}

// VC9: include the actual evidence in the answer without acquiring again.
// F supplies the original source-bound recovery. The graph's paired answer
// and unchanged decoder input are derived, not additional caller equalities.
enum AnswerAndEvidenceUseTheSameObservation<F: ReadingFactors>: Null
where F.Answer: Structure, F.Observation.Answer: Structure {
    typealias Lift = AnswerWithItsEvidence<F>
    typealias Left = Paired<Lift.Observation, Lift.Right.Left>
    typealias Right = Paired<F.Observation, F.Observation.Answer>
}

enum AnswerAndEvidenceRecoverActualFields<F: ReadingFactors>: Null
where F.Answer: Structure, F.Observation.Answer: Structure {
    typealias Left = AnswerWithItsEvidence<F>.Right.Answer
    typealias Right = Paired<F.Answer, F.Observation.Answer>
}

typealias RecordedIdentityIncludesItsOwnEvidence<S: Structure> = AnswerWithItsEvidence<
    AcquireAnswer<IdentityReading<S, BeamSpace, SaturationEncoding>>
>

// VC9: this record recovers the complete source and predicts its swap.
// Its specified identity step does not update it to the swapped source.
enum PassiveCompleteRecord<A: Structure, B: Structure>: Null {
    typealias Source = Paired<A, B>
    typealias Record = RetainedWhole<Source, Never>.Right
    typealias Read = FirstEvidenceImage<
        Record, BeamSpace, SaturationEncoding, FirstProjection>
    typealias SourceStep = SwapBoundaryReading<Source>
    typealias Prediction = SequentialReading<Read, SwapBoundaryReading<Read.Answer>>
    typealias RecordStep = IdentityReading<Record, BeamSpace, SaturationEncoding>
    typealias TargetRecord = RetainedWhole<SourceStep.Answer, Never>.Right
    typealias ActualRecord = RecordStep.Answer
    typealias Left = Paired<Read.Answer, Prediction.Answer>
    typealias Right = Paired<Source, SourceStep.Answer>
}

typealias PassiveRecordTrackingContrast = ZeroSuccessorBoundaryPairClass<
    Paired<
        PassiveCompleteRecord<Never, Lit1>.ActualRecord.Left.Left,
        PassiveCompleteRecord<Never, Lit1>.TargetRecord.Left.Left
    >, Never
>

#if WHOLE_COMPLETE_RECOVERY_FORCES_TRACKING
enum RejectedCompleteRecoveryTracking: Null {
    typealias SourceCase = PassiveCompleteRecord<Never, Lit1>
    typealias Left = SourceCase.TargetRecord
    typealias Right = SourceCase.ActualRecord
}
#endif

// M71 / VC9: adding the actual evidence to a first-coordinate answer
// retains no information about an unobserved second coordinate.
typealias FirstAnswerWithEvidence<A: Structure, B: Structure> = AnswerWithItsEvidence<
    QuestionOnObservation<
        FirstEvidenceImage<Paired<A, B>, BeamSpace, SaturationEncoding, EarlierFirstQuestion>,
        IdentityReading<A, BeamSpace, SaturationEncoding>
    >
>

enum FirstAnswerAndEvidenceOmitSecond<A: Structure, B: Structure, C: Structure>: Null {
    typealias Left = FirstAnswerWithEvidence<A, B>.Right.Answer
    typealias Right = FirstAnswerWithEvidence<A, C>.Right.Answer
}

// This decoder receives only the retained record. Its first projection
// supplies the source consumed by the next, second-coordinate reading.
typealias SecondAnswerFromRecord<O: Pair> = SequentialReading<
    FirstEvidenceImage<O, BeamSpace, SaturationEncoding, FirstProjection>,
    SecondEvidenceImage<O.Left, BeamSpace, SaturationEncoding, EarlierSecondQuestion>
> where O.Left: Pair

typealias FirstAnswerRecord<A: Structure, B: Structure> =
    RecordReading<FirstAnswerWithEvidence<A, B>.Left>.Right

enum FirstAnswerRecordRetainsSecond<A: Structure, B: Structure>: Null {
    typealias Left = SecondAnswerFromRecord<FirstAnswerRecord<A, B>>.Answer
    typealias Right = B
}

typealias EvidenceOmittedSecondContrast = ZeroSuccessorBoundary<
    SecondAnswerFromRecord<FirstAnswerRecord<Never, Never>>,
    SecondAnswerFromRecord<FirstAnswerRecord<Never, Lit1>>, Never>

#if WHOLE_ANSWER_EVIDENCE_ANSWERS_NEW_QUESTION
enum RejectedEvidenceAnswersNewQuestion: ReadingFactors {
    typealias Left = SecondEvidenceImage<
        Paired<Never, Lit1>, BeamSpace, SaturationEncoding, EarlierSecondQuestion>
    typealias Observation = FirstAnswerWithEvidence<Never, Lit1>.Left
    typealias Right = SecondEvidenceImage<
        Observation.Answer, BeamSpace, SaturationEncoding, EarlierSecondQuestion>
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Predicate = EarlierSecondQuestion
    typealias Answer = Left.Answer
}
#endif

typealias CycleBaseReading<S: Structure> = IdentityReading<S, BeamSpace, SaturationEncoding>
typealias CycleRepeatedReading<S: Structure> = JointEvidence<CycleBaseReading<S>, CycleBaseReading<S>>
typealias CycleRepeatedAgain<S: Structure> = JointEvidence<CycleRepeatedReading<S>, CycleRepeatedReading<S>>

// More fields do not by themselves give strictly more recoverable content.
// The source is unrestricted. Every leg uses existing reading constructors.
typealias RepeatedEvidenceRecoveryCycle<S: Structure> = RecoveryCycleDerivesReverse<
    JointEvidenceRetainsFirst<CycleBaseReading<S>, CycleBaseReading<S>>,
    JointEvidenceRetainsFirst<CycleRepeatedReading<S>, CycleRepeatedReading<S>>,
    IdentityFactorization<CycleRepeatedAgain<S>>
>

enum RepeatedEvidenceReverseIsComputed<S: Structure>: Null {
    typealias Left = RepeatedEvidenceRecoveryCycle<S>.Reverse.Right.Answer
    typealias Right = Paired<S, S>
}

// The earlier M72 sources (0,0) and (0,1) have equal first images and a
// positively different second answer. That contrast witnesses strictness.
// These three certificates are individually valid, but the last returns
// to the full source reading rather than to the coarse first image.
#if WHOLE_RECOVERY_CYCLE_FALSE_RETURN
typealias RejectedRecoveryCycleFalseReturn = RecoveryCycleDerivesReverse<
    IdentityFactorization<FirstEvidenceImage<RecoveryMiddleOne, BeamSpace, SaturationEncoding, CurrentCutQuestion>>,
    JointEvidenceRetainsFirst<CycleBaseReading<RecoveryMiddleOne>, CycleBaseReading<RecoveryMiddleOne>>,
    IdentityFactorization<CycleRepeatedReading<RecoveryMiddleOne>>
>
#endif

// M51: once the complete represented source returns, every fixed reading
// on that source has the same answer. The generic R is not only a bit read.
enum AnyReadingAfterWholeReturn<S: Pair, R: PredicateReading>: Null
where S.Left: Structure, S.Right: Structure,
      R.Left == Paired<S.Left, S.Right> {
    typealias Returned = Paired<InternalSwap<InternalSwap<S>>.Left, InternalSwap<InternalSwap<S>>.Right>
    typealias Left = DecodeRefinedEvidence<IdentityReading<Returned, R.Sigma, R.Encoding>, R>.Answer
    typealias Right = R.Answer
}

// M52: agreement of mutual records is preserved for arbitrary update laws.
// It therefore does not select the laws that preserve the original value.
enum MutualRecordsBefore<R: PredicateReading>: Null
where R.Left: Structure, R.Answer: Structure, R.Predicate: Structure {
    typealias Left = MutualRecordUpdate<R>.Left.Right.Left
    typealias Right = MutualRecordUpdate<R>.Left.Right.Right
}
enum MutualRecordsAfter<R: PredicateReading>: Null
where R.Left: Structure, R.Answer: Structure, R.Predicate: Structure {
    typealias Left = MutualRecordUpdate<R>.Right.Right.Left
    typealias Right = MutualRecordUpdate<R>.Right.Right.Right
}
enum MutualRecordsRetainResidentLaw<R: PredicateReading>: Null
where R.Left: Structure, R.Answer: Structure, R.Predicate: Structure {
    typealias Left = MutualRecordUpdate<R>.Left.Left
    typealias Right = MutualRecordUpdate<R>.Right.Left
}
enum MutualRecordsHistoryRetainsSource<R: PredicateReading>: Null
where R.Left: Structure, R.Answer: Structure, R.Predicate: Structure {
    typealias Left = MutualRecordUpdate<R>.Left.Right.Left
    typealias Right = R.Left
}
enum MutualRecordsIdentityPreserves<X: Structure>: Null {
    typealias Step = MutualRecordUpdate<IdentityReading<X, BeamSpace, SaturationEncoding>>
    typealias Left = Step.Right.Right.Left
    typealias Right = X
}
enum MutualRecordsResetMerges<X: Structure, Y: Structure>: Null {
    typealias Left = MutualRecordUpdate<ConstantResetReading<X>>.Right
    typealias Right = MutualRecordUpdate<ConstantResetReading<Y>>.Right
}
typealias MutualResetZeroHistory = MutualRecordUpdate<ConstantResetReading<Never>>
typealias MutualResetOneHistory = MutualRecordUpdate<ConstantResetReading<Lit1>>
typealias MutualResetHistoriesRemainDistinct = ZeroSuccessorBoundary<FirstEvidenceImage<MutualResetZeroHistory.Left.Right, BeamSpace, SaturationEncoding, HistoricalOccurrenceQuestion>, FirstEvidenceImage<MutualResetOneHistory.Left.Right, BeamSpace, SaturationEncoding, HistoricalOccurrenceQuestion>, Never>

#if WHOLE_MUTUAL_RECORDS_FORCE_PRESERVATION
enum RejectedMutualRecordsPreservation: Null {
    typealias Left = MutualResetOneHistory.Right.Right.Left
    typealias Right = MutualResetOneHistory.Left.Right.Left
}
#endif

// M53: reciprocal dependence still permits joint mergers. These are all
// four rows of the declared binary parity law, plus the invertible swap.
typealias Parity00 = EqualPairParity<Never>
typealias Parity11 = EqualPairParity<Lit1>
typealias Parity01 = ZeroOneParity
typealias Parity10 = OneZeroParity
typealias ParityPeerResponseA0 = ZeroSuccessorBoundary<SecondEvidenceImage<Parity00.Answer, BeamSpace, SaturationEncoding, EarlierSecondQuestion>, SecondEvidenceImage<Parity10.Answer, BeamSpace, SaturationEncoding, EarlierSecondQuestion>, Never>
typealias ParityPeerResponseA1 = ZeroSuccessorBoundary<SecondEvidenceImage<Parity11.Answer, BeamSpace, SaturationEncoding, EarlierSecondQuestion>, SecondEvidenceImage<Parity01.Answer, BeamSpace, SaturationEncoding, EarlierSecondQuestion>, Never>
typealias ParityPeerResponseB0 = ZeroSuccessorBoundary<FirstEvidenceImage<Parity00.Answer, BeamSpace, SaturationEncoding, EarlierFirstQuestion>, FirstEvidenceImage<Parity01.Answer, BeamSpace, SaturationEncoding, EarlierFirstQuestion>, Never>
typealias ParityPeerResponseB1 = ZeroSuccessorBoundary<FirstEvidenceImage<Parity11.Answer, BeamSpace, SaturationEncoding, EarlierFirstQuestion>, FirstEvidenceImage<Parity10.Answer, BeamSpace, SaturationEncoding, EarlierFirstQuestion>, Never>
typealias SwapPeerResponseA<B: Structure> = ZeroSuccessorBoundary<SecondEvidenceImage<SwapBoundaryReading<Paired<Never, B>>.Answer, BeamSpace, SaturationEncoding, EarlierSecondQuestion>, SecondEvidenceImage<SwapBoundaryReading<Paired<Lit1, B>>.Answer, BeamSpace, SaturationEncoding, EarlierSecondQuestion>, Never>
typealias SwapPeerResponseB<A: Structure> = ZeroSuccessorBoundary<FirstEvidenceImage<SwapBoundaryReading<Paired<A, Never>>.Answer, BeamSpace, SaturationEncoding, EarlierFirstQuestion>, FirstEvidenceImage<SwapBoundaryReading<Paired<A, Lit1>>.Answer, BeamSpace, SaturationEncoding, EarlierFirstQuestion>, Never>
enum CoupledParityMergesWithLawInside<X: Structure, Y: Structure>: Null {
    typealias Left = ReadingWithResidentLaw<EqualPairParity<X>>.Answer
    typealias Right = ReadingWithResidentLaw<EqualPairParity<Y>>.Answer
}
enum CoupledParityHistoryRetainsSource<X: Structure>: Null {
    typealias History = RecordReading<ReadingWithResidentLaw<EqualPairParity<X>>>.Right
    typealias Left = History.Left.Left.Left
    typealias Right = X
}

// M54: two local witnesses of the earlier coordinates combine through the
// existing common-image constructor into whole-coordinate recovery.
enum EarlierCoordinatesRecoveredTogether<P: Pair>: Null
where P.Left: Structure, P.Right: Structure {
    typealias Left = EarlierPairThroughSwap<P>.Answer
    typealias Right = Paired<P.Left, P.Right>
}
enum EarlierRecoveryUsesOnlyLaterImage<P: Pair>: Null
where P.Left: Structure, P.Right: Structure {
    typealias Left = EarlierPairThroughSwap<P>.Right.Left
    typealias Right = SwapBoundaryReading<P>.Answer
}
enum EarlierRecoveryWithResidentLaw<A: Structure, B: Structure>: Null {
    typealias P = Paired<A, B>
    typealias F = EvidenceBesideInput<EarlierPairThroughSwap<P>, SwapOperation>
    typealias Left = F.Answer
    typealias Right = Paired<P, SwapOperation>
}
#if WHOLE_RECIPROCAL_INFLUENCE_PRESERVES
enum RejectedReciprocalInfluencePreservation: Null {
    typealias Left = Parity11.Left
    typealias Right = Parity11.Answer
}
#endif
#if WHOLE_WITNESS_WRONG_NEXT_ADDRESS
enum RejectedWitnessWrongNextAddress: ReadingFactors {
    typealias P = Paired<Never, Lit1>
    typealias Left = FirstEvidenceImage<P, BeamSpace, SaturationEncoding, EarlierFirstQuestion>
    typealias Observation = SwapBoundaryReading<P>
    typealias Right = FirstEvidenceImage<Observation.Answer, BeamSpace, SaturationEncoding, EarlierFirstQuestion>
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Predicate = EarlierFirstQuestion
    typealias Answer = Left.Answer
}
#endif

// The converse direction of M54 is composition with an addressed projection
// of the supplied recovered whole, using the existing acquisition relations.
enum FirstQuestionFromWholeRecovery<F: ReadingFactors>: Null
where F.Answer: Pair {
    typealias Projection = FirstEvidenceImage<F.Answer, F.Sigma, F.Encoding, EarlierFirstQuestion>
    typealias Local = AnswerOnRefinement<QuestionOnObservation<F.Left, Projection>, F>
    typealias Left = Local.Answer
    typealias Right = F.Answer.Left
}
enum SecondQuestionFromWholeRecovery<F: ReadingFactors>: Null
where F.Answer: Pair {
    typealias Projection = SecondEvidenceImage<F.Answer, F.Sigma, F.Encoding, EarlierSecondQuestion>
    typealias Local = AnswerOnRefinement<QuestionOnObservation<F.Left, Projection>, F>
    typealias Left = Local.Answer
    typealias Right = F.Answer.Right
}

// LQ8a: four resident fields (x, x, r, r). Equal copies are an explicit
// preparation, not an operation that copies an arbitrary physical source.
// Field 1 is the current target, field 3 the participant's current record.
// TransposeEntries is reused only as a permutation of addressed fields.
typealias PreparedContact<X: Structure, R: Structure> = MatrixEntries<X, X, R, R>
typealias AcquireResidentCopy<X: Structure, R: Structure> = TransposeEntries<PreparedContact<X, R>>
typealias ImposeResidentCopy<X: Structure, R: Structure> = FollowedPair<
    SwapBoundaryReading<PreparedContact<X, R>>,
    TransposeEntries<SwapBoundaryReading<PreparedContact<X, R>>.Right>
>

typealias CurrentTargetAndRecord<W: Pair> = Paired<W.Left.Left, W.Right.Left>
where W.Left: Pair, W.Right: Pair,
      W.Left.Left: Structure, W.Right.Left: Structure

enum PriorRecordOmitsOriginalSource<X: Structure, Y: Structure, R: Structure>: Null {
    typealias Left = PreparedContact<X, R>.Right.Left
    typealias Right = PreparedContact<Y, R>.Right.Left
}

// Both operations are reversible on the full four-field carrier, before
// restricting to the preparation. FollowedPair checks the actual seam;
// it makes no claim that the two readings share a semantic question.
enum AcquisitionPermutationReturns<A: Structure, B: Structure, C: Structure, D: Structure>: Null {
    typealias Source = MatrixEntries<A, B, C, D>
    typealias Left = TransposeEntries<TransposeEntries<Source>.Right>.Right
    typealias Right = Source
}
enum ImpositionPermutationReturns<A: Structure, B: Structure, C: Structure, D: Structure>: Null {
    typealias Source = MatrixEntries<A, B, C, D>
    typealias Forward = FollowedPair<SwapBoundaryReading<Source>,
        TransposeEntries<SwapBoundaryReading<Source>.Right>>
    typealias Backward = FollowedPair<TransposeEntries<Forward.Right>,
        SwapBoundaryReading<TransposeEntries<Forward.Right>.Right>>
    typealias Left = Backward.Right
    typealias Right = Source
}

enum AcquisitionReadsOriginalSource<X: Structure, R: Structure>: Null {
    typealias Left = CurrentTargetAndRecord<AcquireResidentCopy<X, R>.Right>
    typealias Right = Paired<X, X>
}
enum ImpositionReadsPriorRecord<X: Structure, R: Structure>: Null {
    typealias Left = CurrentTargetAndRecord<ImposeResidentCopy<X, R>.Right>
    typealias Right = Paired<R, R>
}
enum AcquisitionRetainsBothOriginalFields<X: Structure, R: Structure>: Null {
    typealias Left = Paired<AcquireResidentCopy<X, R>.Right.Right.Left,
        AcquireResidentCopy<X, R>.Right.Left.Right>
    typealias Right = Paired<X, R>
}
enum ImpositionRetainsBothOriginalFields<X: Structure, R: Structure>: Null {
    typealias Left = Paired<ImposeResidentCopy<X, R>.Right.Left.Right,
        ImposeResidentCopy<X, R>.Right.Right.Left>
    typealias Right = Paired<X, R>
}

// Even the four output fields coincide under exchanged preparations.
// A single controlled whole must also retain which operation is resident.
enum AcquisitionAndImpositionOutputsCoincide<X: Structure, R: Structure>: Null {
    typealias Left = AcquireResidentCopy<X, R>.Right
    typealias Right = ImposeResidentCopy<R, X>.Right
}
typealias ResidentAcquisition<X: Structure, R: Structure> = StepBeside<AcquireResidentCopy<X, R>, Never>
typealias ResidentImposition<X: Structure, R: Structure> = StepBeside<ImposeResidentCopy<X, R>, Lit1>
enum BothContactModesRemainResident<X: Structure, R: Structure>: Null {
    typealias Left = Paired<ResidentAcquisition<X, R>.Right.Right,
        ResidentImposition<X, R>.Right.Right>
    typealias Right = Paired<ResidentAcquisition<X, R>.Left.Right,
        ResidentImposition<X, R>.Left.Right>
}

// Knowing the imposition mode still does not make its current contact
// identify the original target. This equality holds for arbitrary X, Y.
enum ImpositionContactOmitsOriginalSource<X: Structure, Y: Structure, R: Structure>: Null {
    typealias Left = Paired<CurrentTargetAndRecord<ResidentImposition<X, R>.Right.Left>,
        ResidentImposition<X, R>.Right.Right>
    typealias Right = Paired<CurrentTargetAndRecord<ResidentImposition<Y, R>.Right.Left>,
        ResidentImposition<Y, R>.Right.Right>
}
typealias ImpositionHiddenOriginContrast = ZeroSuccessorBoundaryPairClass<Paired<
    ImposeResidentCopy<Never, Never>.Right.Left.Right,
    ImposeResidentCopy<Lit1, Never>.Right.Left.Right>, Never>

#if WHOLE_CURRENT_AGREEMENT_IDENTIFIES_ORIGIN
enum RejectedAgreementAsAcquisition: Null {
    typealias Step = ImposeResidentCopy<Lit1, Never>
    typealias Left = CurrentTargetAndRecord<Step.Right>.Right
    typealias Right = Step.Left.Left.Left
}
#endif

#if WHOLE_ACQUISITION_IGNORES_COPY_BINDING
enum RejectedUnboundAcquisitionCopy: Null {
    typealias Step = TransposeEntries<MatrixEntries<Lit1, Never, Never, Never>>
    typealias Left = CurrentTargetAndRecord<Step.Right>.Right
    typealias Right = Step.Left.Left.Left
}
#endif

#if WHOLE_CONTACT_OUTPUT_ERASES_MODE
enum RejectedContactModeErasure: Null {
    typealias Left = ResidentAcquisition<Never, Lit1>.Right
    typealias Right = ResidentImposition<Lit1, Never>.Right
}
#endif

// Voice Theorem 3: each encoder swaps labels, each declared reader is the
// identity. The complete round trip returns its source, although neither
// local round trip does so on the zero/one source. The task is label recovery.
enum CompensatingTranslationsReturn<A: Structure, B: Structure>: Null {
    typealias Source = Paired<A, B>
    typealias First = SwapBoundaryReading<Source>
    typealias Second = SwapBoundaryReading<First.Answer>
    typealias ReadSecond = IdentityReading<Second.Answer, BeamSpace, SaturationEncoding>
    typealias ReadFirst = IdentityReading<ReadSecond.Answer, BeamSpace, SaturationEncoding>
    typealias RoundTrip = SequentialReading<SequentialReading<SequentialReading<
        First, Second>, ReadSecond>, ReadFirst>
    typealias Left = RoundTrip.Answer
    typealias Right = Source
}

// Repair the first encoding for its declared identity reader. The remaining
// swap is unchanged, so the previous complete recovery no longer applies.
enum OneTranslationRepairExchangesTheResult<A: Structure, B: Structure>: Null {
    typealias Source = Paired<A, B>
    typealias First = IdentityReading<Source, BeamSpace, SaturationEncoding>
    typealias Second = SwapBoundaryReading<First.Answer>
    typealias ReadSecond = IdentityReading<Second.Answer, BeamSpace, SaturationEncoding>
    typealias ReadFirst = IdentityReading<ReadSecond.Answer, BeamSpace, SaturationEncoding>
    typealias RoundTrip = SequentialReading<SequentialReading<SequentialReading<
        First, Second>, ReadSecond>, ReadFirst>
    typealias Left = RoundTrip.Answer
    typealias Right = Paired<B, A>
}

#if WHOLE_LOCAL_REPAIR_PRESERVES_COMPENSATED_RESULT
enum RejectedLocalRepairKeepsComposite: Null {
    typealias Repair = OneTranslationRepairExchangesTheResult<Never, Lit1>
    typealias Left = Repair.RoundTrip.Answer
    typealias Right = Repair.Source
}
#endif

#if WHOLE_FAITHFUL_COMPOSITE_CERTIFIES_EACH_LINK
enum RejectedCompositeCertifiesLocalReader: Null {
    typealias Source = CompensatingTranslationsReturn<Never, Lit1>.Source
    typealias Encode = SwapBoundaryReading<Source>
    typealias Read = IdentityReading<Encode.Answer, BeamSpace, SaturationEncoding>
    typealias Left = SequentialReading<Encode, Read>.Answer
    typealias Right = Source
}
#endif
