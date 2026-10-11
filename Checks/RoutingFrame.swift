import VerificationIsIdentification
import Examples

typealias FrameModule = IdentityRouting
typealias FrameExchangedModule = ExchangeFirstImage<FrameModule>.Answer
typealias FrameCrossed = ProbeThroughCrossedFrame<FrameModule>
typealias FrameDirect = ProbeThroughDirectFrame<FrameExchangedModule>
typealias FrameCompositeFactor = QuestionOnObservation<FrameCrossed, RoutingFromProbeImages<FrameCrossed.Answer>>
typealias FrameCompositeAcquired = AnswerFromAcquiredObservation<FrameCompositeFactor>

enum FrameFactsCannotIdentifyDecomposition: Null {
    typealias Left = FactOf<FrameCrossed>
    typealias Right = FactOf<FrameDirect>
}
enum FrameProbeRecoversCompositeRouting: Null {
    typealias Left = FrameCompositeAcquired.Answer
    typealias Right = FrameExchangedModule
}

enum FrameSameResponseForArbitraryData<A: Structure, C: Structure, B: Structure, D: Structure>: Null {
    typealias X = BoundaryWorking<A, C, B, D>
    typealias ModuleIdentity = RoutingApplication<FrameModule, X, Route00<X>, Route01<X>, Route10<X>, Route11<X>>
    typealias ModuleExchange = RoutingApplication<FrameExchangedModule, X, Route01<X>, Route00<X>, Route10<X>, Route11<X>>
    typealias Left = ExchangeFirstImage<ModuleIdentity.Answer>.Answer
    typealias Right = ModuleExchange.Answer
}

enum FrameKnownCorrection<A: Pair, C: Pair, B: Pair, D: Pair>: Null
where A.Left: Structure, A.Right: Structure, C.Left: Structure, C.Right: Structure,
      B.Left: Structure, B.Right: Structure, D.Left: Structure, D.Right: Structure {
    typealias I = BoundaryWorking<A, C, B, D>
    typealias Observed = ProbeThroughCrossedFrame<I>.Answer
    typealias Corrected = ExchangeFirstImage<RoutingFromProbeImages<Observed>.Answer>.Answer
    typealias Left = RoutingCoordinates<Corrected>.Answer
    typealias Right = RoutingCoordinates<I>.Answer
}

// The bare module routings differ at a positively distinguished bit, even
// though their framed response facts agree for every data input.
enum FrameModuleBitQuestion: Close {}
typealias FrameModuleDifference = ZeroSuccessorBoundary<SecondEvidenceImage<FrameModule.Left.Left, BeamSpace, SaturationEncoding, FrameModuleBitQuestion>, SecondEvidenceImage<FrameExchangedModule.Left.Left, BeamSpace, SaturationEncoding, FrameModuleBitQuestion>, Never>

#if FRAME_UNCALIBRATED_MODULE_RECOVERY
enum RejectedFrameModule: ReadingFactors {
    typealias Left = DecodeRefinedEvidence<FirstEvidenceImage<FrameCrossed.Left, BeamSpace, SaturationEncoding, RoutingQuestion>, RoutingCoordinates<FrameModule>>
    typealias Observation = FrameCrossed
    typealias Right = RoutingFromProbeImages<FrameCrossed.Answer>
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Predicate = RoutingQuestion
    typealias Answer = Left.Answer
}
#endif

// A shared unknown frame preserves and reflects coordinate equality.
// The two frame clauses and the involution supply both directions.
enum SharedFramePairAgreement<A: Structure, B: Structure>: Null {
    typealias P = Paired<A, B>
    typealias Observed = SharedCrossedPairFrame<Paired<P, P>>.Answer
    typealias Left = Observed.Left
    typealias Right = Observed.Right
}

enum SharedFramePairRecovery<A: Structure, B: Structure>: Null {
    typealias P = Paired<A, B>
    typealias Left = SwapBoundaryReading<SwapBoundaryReading<P>.Answer>.Answer
    typealias Right = P
}

enum SharedFrameReflection<C: Null>: Null
where C.Left: Pair, C.Right: Pair,
      C.Left.Left: Structure, C.Left.Right: Structure,
      C.Right.Left: Structure, C.Right.Right: Structure {
    typealias Left = SharedFrameAgreement<C>.Left
    typealias Right = SharedFrameAgreement<C>.Right
}

// A positive difference at the first coordinate moves to the second.
enum SharedFrameCarriesContrast<A: Structure, B: Structure>: Null {
    typealias Before = Paired<Never, A>
    typealias After = Paired<Lit1, B>
    typealias Observed = SharedCrossedPairFrame<Paired<Before, After>>.Answer
    typealias Obstruction = ZeroSuccessorBoundaryPairClass<Paired<Observed.Left.Right, Observed.Right.Right>, Never>
    typealias Left = Observed.Left.Right
    typealias Right = Never
}

typealias RelativeFramePair = Paired<Never, Lit1>
typealias RelativeFrameReversed = Paired<Lit1, Never>

// M65's equality-controlled counterfamily retains its actual input fields.
typealias ResidentPattern<L: Structure, R: PredicateReading> = SequentialReading<
    SecondEvidenceImage<Paired<L, R.Left>, R.Sigma, R.Encoding, SecondProjection>, R
> where R.Left: Structure

typealias PatternTable<D: PredicateReading, AB: PredicateReading, AC: PredicateReading,
    BC: PredicateReading, All: PredicateReading> = PairedApplication<D,
        PairedApplication<AB, PairedApplication<AC, PairedApplication<BC, All>>>>
where D.Sigma == AB.Sigma, D.Sigma == AC.Sigma, D.Sigma == BC.Sigma, D.Sigma == All.Sigma,
      D.Encoding == AB.Encoding, D.Encoding == AC.Encoding, D.Encoding == BC.Encoding, D.Encoding == All.Encoding,
      D.Left: Structure, AB.Left: Structure, AC.Left: Structure, BC.Left: Structure, All.Left: Structure,
      D.Answer: Structure, AB.Answer: Structure, AC.Answer: Structure, BC.Answer: Structure, All.Answer: Structure

typealias SwapPattern<I: Pair> = SwapFirstTwoTriple<I>
where I.Right: Pair, I.Left: Structure, I.Right.Left: Structure, I.Right.Right: Structure

typealias SwapPatternTable = PatternTable<
    ResidentPattern<SwapOperation, SwapPattern<AddressTriple<Never, Lit1, Lit2>>>,
    ResidentPattern<SwapOperation, SwapPattern<AddressTriple<Never, Never, Lit1>>>,
    ResidentPattern<SwapOperation, SwapPattern<AddressTriple<Never, Lit1, Never>>>,
    ResidentPattern<SwapOperation, SwapPattern<AddressTriple<Never, Lit1, Lit1>>>,
    ResidentPattern<SwapOperation, SwapPattern<AddressTriple<Never, Never, Never>>>
>
typealias SwapPatternCertificate = TriplePatternCertificate<SwapOperation, SwapPatternTable,
    SelectSecondMarkerProfile, SelectFirstMarkerProfile, SelectThirdMarkerProfile>

typealias FirstTripleData<A, B, C> = SelectCandidateLeft<SelectCandidateLeaf<A>,
    CandidateFork<CandidateLeaf<B>, CandidateLeaf<C>>>
typealias SecondTripleData<A, B, C> = SelectCandidateRight<CandidateLeaf<A>,
    SelectCandidateLeft<SelectCandidateLeaf<B>, CandidateLeaf<C>>>
typealias ThirdTripleData<A, B, C> = SelectCandidateRight<CandidateLeaf<A>,
    SelectCandidateRight<CandidateLeaf<B>, SelectCandidateLeaf<C>>>

enum AcquiredPatternLawAppliesToArbitraryData<A: Structure, B: Structure, C: Structure>: Null {
    typealias Data = AddressTriple<A, B, C>
    typealias Acquisition = PairedSourceReadings<AcquireAnswer<SwapPatternCertificate.Record>.Observation,
        IdentityReading<Data, BeamSpace, SaturationEncoding>>
    typealias Decoder = SwapPatternCertificate.Use<Data,
        SecondTripleData<A, B, C>, FirstTripleData<A, B, C>, ThirdTripleData<A, B, C>>
    typealias Run = SequentialReading<Acquisition, Decoder>
    typealias Left = Run.Answer
    typealias Right = SwapPattern<Data>.Answer
}

enum PatternMemoryRetainsOnlyTheSignature: Null {
    typealias Left = SwapPatternCertificate.Record.Answer
    typealias Right = AddressTriple<Lit1, Never, Lit2>
}

#if FRAME_PATTERN_EQUAL_VALUES_WRONG_PATH
typealias RejectedPatternEqualValuesWrongPath = SwapPatternCertificate.Use<AddressTriple<Never, Never, Never>,
    FirstTripleData<Never, Never, Never>, FirstTripleData<Never, Never, Never>, ThirdTripleData<Never, Never, Never>>
#endif

#if FRAME_PATTERN_WRONG_SIGNATURE
// Same context, question and triple shape; only the recorded positions differ.
typealias WrongPatternSignature = FirstEvidenceImage<
    Paired<AddressTriple<Never, Lit1, Lit2>, Never>, BeamSpace, SaturationEncoding, RoutedOutputQuestion>
typealias WrongPatternMemory = PairedSourceReadings<
    AcquireAnswer<WrongPatternSignature>.Observation,
    IdentityReading<AddressTriple<Never, Lit1, Lit2>, BeamSpace, SaturationEncoding>>
typealias RejectedPatternWrongSignature = SequentialReading<WrongPatternMemory,
    SwapPatternCertificate.Use<AddressTriple<Never, Lit1, Lit2>,
        SecondTripleData<Never, Lit1, Lit2>, FirstTripleData<Never, Lit1, Lit2>, ThirdTripleData<Never, Lit1, Lit2>>>
#endif

typealias EqualityPatternTable = PatternTable<
    ResidentPattern<RouteByThirdEqualityQuestion, ThirdOutsideZeroOne<Never>>,
    ResidentPattern<RouteByThirdEqualityQuestion, IdentityReading<AddressTriple<Never, Never, Lit1>, BeamSpace, SaturationEncoding>>,
    ResidentPattern<RouteByThirdEqualityQuestion, ThirdMatchesFirst<Never, Lit1>>,
    ResidentPattern<RouteByThirdEqualityQuestion, ThirdMatchesSecond<Never, Lit1>>,
    ResidentPattern<RouteByThirdEqualityQuestion, ThirdMatchesFirst<Never, Never>>
>

enum EqualityPatternTableKeepsDistinctRow: Null {
    typealias Left = EqualityPatternTable.Answer.Left
    typealias Right = AddressTriple<Never, Lit1, Lit2>
}
typealias EqualityPatternTableContrast = ZeroSuccessorBoundaryPairClass<
    Paired<TriplePatternImages<SelectFirstMarkerProfile, SelectSecondMarkerProfile, SelectThirdMarkerProfile>.Right.Right.Right.Left.Left,
        EqualityPatternTable.Answer.Right.Right.Left.Left>, Never>

// Read the original prepared contents independently of the law's responses.
typealias PatternContents<L: Structure> = PatternTable<
    SecondEvidenceImage<TriplePatternSources<L>.Left, BeamSpace, SaturationEncoding, SecondProjection>,
    SecondEvidenceImage<TriplePatternSources<L>.Right.Left, BeamSpace, SaturationEncoding, SecondProjection>,
    SecondEvidenceImage<TriplePatternSources<L>.Right.Right.Left, BeamSpace, SaturationEncoding, SecondProjection>,
    SecondEvidenceImage<TriplePatternSources<L>.Right.Right.Right.Left, BeamSpace, SaturationEncoding, SecondProjection>,
    SecondEvidenceImage<TriplePatternSources<L>.Right.Right.Right.Right, BeamSpace, SaturationEncoding, SecondProjection>
>

// Apply the inverse to the actual answers, including their changed patterns.
typealias EqualityReturnApplications = PatternTable<
    ThirdOutsideZeroOne<Never>,
    IdentityReading<AddressTriple<Never, Never, Lit1>, BeamSpace, SaturationEncoding>,
    ThirdMatchesSecond<Lit1, Never>,
    ThirdMatchesFirst<Lit1, Never>,
    ThirdMatchesFirst<Never, Never>
>
enum EqualityPatternsRecoverTheirPreparedContents: ReadingFactors {
    typealias Contents = PatternContents<RouteByThirdEqualityQuestion>
    typealias Left = DecodeRefinedEvidence<Contents,
        IdentityReading<Contents.Answer, BeamSpace, SaturationEncoding>>
    typealias Observation = EqualityPatternTable
    typealias Right = DecodeRefinedEvidence<EqualityReturnApplications,
        IdentityReading<EqualityReturnApplications.Answer, BeamSpace, SaturationEncoding>>
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Predicate = Left.Predicate
    typealias Answer = Left.Answer
}

#if FRAME_PATTERN_FALSE_RECOVERY
// Input binding succeeds. Retaining the forward answers fails recovery.
enum RejectedPatternFalseRecovery: ReadingFactors {
    typealias Left = EqualityPatternsRecoverTheirPreparedContents.Left
    typealias Observation = EqualityPatternTable
    typealias Right = IdentityReading<Observation.Answer, BeamSpace, SaturationEncoding>
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Predicate = Left.Predicate
    typealias Answer = Left.Answer
}
#endif

#if FRAME_PATTERN_EQUALITY_DEPENDENCE
typealias RejectedPatternEqualityDependence = TriplePatternCertificate<RouteByThirdEqualityQuestion, EqualityPatternTable,
    SelectFirstMarkerProfile, SelectSecondMarkerProfile, SelectThirdMarkerProfile>
#endif
#if FRAME_PATTERN_WRONG_LAW
typealias MixedLawPatternTable = PatternTable<
    ResidentPattern<SwapOperation, SwapPattern<AddressTriple<Never, Lit1, Lit2>>>,
    ResidentPattern<SwapOperation, SwapPattern<AddressTriple<Never, Never, Lit1>>>,
    ResidentPattern<SwapOperation, SwapPattern<AddressTriple<Never, Lit1, Never>>>,
    ResidentPattern<SwapOperation, SwapPattern<AddressTriple<Never, Lit1, Lit1>>>,
    ResidentPattern<IdentityOperation, SwapPattern<AddressTriple<Never, Never, Never>>>
>
typealias RejectedPatternWrongLaw = TriplePatternCertificate<SwapOperation, MixedLawPatternTable,
    SelectSecondMarkerProfile, SelectFirstMarkerProfile, SelectThirdMarkerProfile>
#endif
#if FRAME_PATTERN_FOREIGN_SELECTION
typealias RejectedPatternForeignSelection = TriplePatternCertificate<SwapOperation, SwapPatternTable,
    SelectCandidateLeaf<SecondMarkerProfile>, SelectFirstMarkerProfile, SelectThirdMarkerProfile>
#endif

enum EqualityRoutingRecoversFirstMatch<A: Structure, B: Structure>: Null {
    typealias Run = SequentialReading<ThirdMatchesFirst<A, B>, ThirdMatchesSecond<B, A>>
    typealias Left = Run.Answer
    typealias Right = Run.Left
}

enum EqualityRoutingRecoversSecondMatch<A: Structure, B: Structure>: Null {
    typealias Run = SequentialReading<ThirdMatchesSecond<A, B>, ThirdMatchesFirst<B, A>>
    typealias Left = Run.Answer
    typealias Right = Run.Left
}

enum EqualityRoutingKeepsDistinctPreparation: Null {
    typealias Left = ThirdOutsideZeroOne<Never>.Answer
    typealias Right = AddressTriple<Never, Lit1, Lit2>
}

// These three source schemas cover every triple with at most two contents.
// When the first two agree, either branch of the conditional returns A,A,B.
// The other two schemas use the actual match clauses. A and B may also agree.
enum TwoContentEqualityRoutingNeedsNoGuard<A: Structure, B: Structure>: Null {
    typealias FirstTwoAgree = AddressTriple<A, A, B>
    typealias Left = AddressTriple<
        IdentityReading<FirstTwoAgree, BeamSpace, SaturationEncoding>.Answer,
        ThirdMatchesFirst<A, B>.Answer,
        ThirdMatchesSecond<A, B>.Answer>
    typealias Right = AddressTriple<
        SwapPattern<FirstTwoAgree>.Answer,
        SwapPattern<AddressTriple<A, B, A>>.Answer,
        SwapPattern<AddressTriple<A, B, B>>.Answer>
}

// Agreement on the entire two-content domain leaves the three-content law
// question open. The actual distinct preparation supplies a positive contrast.
typealias TwoContentAgreementLeavesLawContrast = ZeroSuccessorBoundaryPairClass<
    Paired<ThirdOutsideZeroOne<Never>.Answer.Left,
        SwapPattern<AddressTriple<Never, Lit1, Lit2>>.Answer.Left>, Never>

#if FRAME_TWO_CONTENT_AGREEMENT_IDENTIFIES_LAW
enum RejectedTwoContentLawIdentification: Null {
    typealias Left = ThirdOutsideZeroOne<Never>.Answer
    typealias Right = SwapPattern<AddressTriple<Never, Lit1, Lit2>>.Answer
}
#endif

// The local pair, reserve and law address occur in one actual source.
typealias InternalProbeWorld<L: Structure, C: Structure> = Paired<L, Paired<Paired<Never, Lit1>, C>>
typealias InternalAvailablePair<L: Structure, C: Structure> = SequentialReading<
    SecondEvidenceImage<InternalProbeWorld<L, C>, BeamSpace, SaturationEncoding, SecondProjection>,
    FirstEvidenceImage<InternalProbeWorld<L, C>.Right, BeamSpace, SaturationEncoding, FirstProjection>>
typealias InternalFirst<L: Structure, C: Structure> = SequentialReading<InternalAvailablePair<L, C>,
    FirstEvidenceImage<Paired<Never, Lit1>, BeamSpace, SaturationEncoding, FirstProjection>>
typealias InternalSecond<L: Structure, C: Structure> = SequentialReading<InternalAvailablePair<L, C>,
    SecondEvidenceImage<Paired<Never, Lit1>, BeamSpace, SaturationEncoding, SecondProjection>>
typealias InternalReserve<L: Structure, C: Structure> = SequentialReading<
    SecondEvidenceImage<InternalProbeWorld<L, C>, BeamSpace, SaturationEncoding, SecondProjection>,
    SecondEvidenceImage<InternalProbeWorld<L, C>.Right, BeamSpace, SaturationEncoding, SecondProjection>>
typealias InternalOldPreparation<L: Structure, C: Structure> = JointEvidence<InternalFirst<L, C>,
    JointEvidence<InternalSecond<L, C>, InternalFirst<L, C>>>
typealias InternalNewPreparation<L: Structure, C: Structure> = JointEvidence<InternalFirst<L, C>,
    JointEvidence<InternalSecond<L, C>, InternalReserve<L, C>>>

// The recorded question concerns the first actual output coordinate. Its
// vocabulary is shared by both instruments and both admitted law witnesses.
typealias InternalProbeFirstAnswer<P: PredicateReading, R: PredicateReading> = DecodeRefinedEvidence<
    P, DecodeRefinedEvidence<R, FirstEvidenceImage<R.Answer, BeamSpace, SaturationEncoding, RoutedValueQuestion>>>
where P.Answer == R.Left, P.Sigma == BeamSpace, R.Sigma == BeamSpace,
      P.Encoding == SaturationEncoding, R.Encoding == SaturationEncoding, R.Answer: Pair

// Preparation must not encode prior knowledge of the law being identified.
enum InternalPreparationsDoNotReadLawAddress<L: Structure, M: Structure, C: Structure>: Null {
    typealias Left = Paired<InternalOldPreparation<L, C>.Answer, InternalNewPreparation<L, C>.Answer>
    typealias Right = Paired<InternalOldPreparation<M, C>.Answer, InternalNewPreparation<M, C>.Answer>
}
enum OldInternalFactDoesNotReadReserve<C: Structure, D: Structure>: Null {
    typealias Left = FactOf<InternalProbeFirstAnswer<
        InternalOldPreparation<RouteByThirdEqualityQuestion, C>, ThirdMatchesFirst<Never, Lit1>>>
    typealias Right = FactOf<InternalProbeFirstAnswer<
        InternalOldPreparation<RouteByThirdEqualityQuestion, D>, ThirdMatchesFirst<Never, Lit1>>>
}

typealias InternalOldEquality = InternalProbeFirstAnswer<
    InternalOldPreparation<RouteByThirdEqualityQuestion, Lit2>, ThirdMatchesFirst<Never, Lit1>>
typealias InternalOldSwap = InternalProbeFirstAnswer<
    InternalOldPreparation<SwapOperation, Lit2>, SwapFirstTwoTriple<AddressTriple<Never, Lit1, Never>>>
typealias InternalNewEquality = InternalProbeFirstAnswer<
    InternalNewPreparation<RouteByThirdEqualityQuestion, Lit2>, ThirdOutsideZeroOne<Never>>
typealias InternalNewSwap = InternalProbeFirstAnswer<
    InternalNewPreparation<SwapOperation, Lit2>, SwapFirstTwoTriple<AddressTriple<Never, Lit1, Lit2>>>

typealias InternalEqualityRun = TwoResidentReadings<InternalOldEquality, InternalNewEquality>
typealias InternalSwapRun = TwoResidentReadings<InternalOldSwap, InternalNewSwap>
typealias InternalEqualityFacts = ResidentProbeFacts<InternalEqualityRun.Right>
typealias InternalSwapFacts = ResidentProbeFacts<InternalSwapRun.Right>
typealias InternalEqualityReadback = TwoResidentAnswers<InternalOldEquality, InternalNewEquality>
typealias InternalSwapReadback = TwoResidentAnswers<InternalOldSwap, InternalNewSwap>

enum OldInternalRecordDoesNotDistinguishTheLaws: Null {
    typealias Left = InternalEqualityFacts.Left
    typealias Right = InternalSwapFacts.Left
}
typealias NewInternalRecordDistinguishesTheLaws = ZeroSuccessorBoundaryPairClass<
    Paired<ReadRecordedAnswer<InternalEqualityFacts.Right>.Answer,
        ReadRecordedAnswer<InternalSwapFacts.Right>.Answer>, Never>

typealias RepeatedReserveEquality = InternalProbeFirstAnswer<
    InternalNewPreparation<RouteByThirdEqualityQuestion, Lit1>, ThirdMatchesSecond<Never, Lit1>>
typealias RepeatedReserveSwap = InternalProbeFirstAnswer<
    InternalNewPreparation<SwapOperation, Lit1>, SwapFirstTwoTriple<AddressTriple<Never, Lit1, Lit1>>>
enum AThirdResidentAddressDoesNotSupplyAThirdContent: Null {
    typealias Left = FactOf<RepeatedReserveEquality>
    typealias Right = FactOf<RepeatedReserveSwap>
}
enum UncalibratedReserveLeavesTheNewLawFactAmbiguous: Null {
    typealias Left = FactOf<RepeatedReserveEquality>
    typealias Right = InternalSwapFacts.Right
}

// If the reserve value is not part of the established preparation contract,
// the same resident protocol can acquire it beside the law-response fact.
typealias InternalCalibratedEquality = TwoResidentAnswers<
    InternalReserve<RouteByThirdEqualityQuestion, Lit2>, InternalNewEquality>
typealias InternalCalibratedSwap = TwoResidentAnswers<
    InternalReserve<SwapOperation, Lit2>, InternalNewSwap>
enum InternalCalibrationIsSharedByTheLawCases: Null {
    typealias Left = InternalCalibratedEquality.Observation.Answer.Left
    typealias Right = InternalCalibratedSwap.Observation.Answer.Left
}
typealias CalibratedInternalRecordsDistinguishTheLaws = ZeroSuccessorBoundaryPairClass<
    Paired<InternalCalibratedEquality.Right.Answer.Right,
        InternalCalibratedSwap.Right.Answer.Right>, Never>

#if FRAME_RESERVE_NOT_READ
// The old preparation returns 010, not the 012 required by this law clause.
typealias RejectedUnreadReserve = InternalProbeFirstAnswer<
    InternalOldPreparation<RouteByThirdEqualityQuestion, Lit2>, ThirdOutsideZeroOne<Never>>
#endif
#if FRAME_CALIBRATION_OTHER_RESERVE
typealias RejectedCalibrationOtherReserve = TwoResidentAnswers<
    InternalReserve<RouteByThirdEqualityQuestion, Lit2>, RepeatedReserveEquality>
#endif

typealias InternalEqualityCalibrationTrace = AppendObservation<
    StartObservations<InternalNewEquality.Left>, InternalReserve<RouteByThirdEqualityQuestion, Lit2>>
typealias InternalSwapCalibrationTrace = AppendObservation<
    StartObservations<InternalNewSwap.Left>, InternalReserve<SwapOperation, Lit2>>

enum ChooseCommonOutputQuestion: PredicateReading {
    typealias Left = Lit2
    typealias Right = ChannelOf<InternalNewEquality>
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Predicate = AcquisitionChoice
    typealias Answer = Right
}
typealias InternalQuestionChoice = DecodeRefinedEvidence<
    LatestObservation<InternalEqualityCalibrationTrace.Right>, ChooseCommonOutputQuestion>
typealias OldPreparationThroughQuestionChoice = SelectedTraceExtension<
    InternalEqualityCalibrationTrace, InternalOldEquality, InternalQuestionChoice>
typealias NewPreparationThroughQuestionChoice = SelectedTraceExtension<
    InternalEqualityCalibrationTrace, InternalNewEquality, InternalQuestionChoice>
enum AQuestionAddressDoesNotSelectThePreparation: Null {
    typealias Left = OldPreparationThroughQuestionChoice.Left
    typealias Right = NewPreparationThroughQuestionChoice.Left
}
typealias SameQuestionPermitsDifferentPreparedResponses = ZeroSuccessorBoundaryPairClass<
    Paired<NewPreparationThroughQuestionChoice.Right.Right.Right.Right.Right.Answer,
        OldPreparationThroughQuestionChoice.Right.Right.Right.Right.Right.Answer>, Never>

// The policy reads the calibrated value, not the unknown law or its source.
enum ChooseSecondPreparedInstrument: PredicateReading {
    typealias Left = Lit2
    typealias Right = Paired<Lit1, Never>
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Predicate = AcquisitionChoice
    typealias Answer = Right
}
typealias InternalEqualityChoice = DecodeRefinedEvidence<
    LatestObservation<InternalEqualityCalibrationTrace.Right>, ChooseSecondPreparedInstrument>
typealias InternalSwapChoice = DecodeRefinedEvidence<
    LatestObservation<InternalSwapCalibrationTrace.Right>, ChooseSecondPreparedInstrument>
typealias InternalEqualityCatalogue = CandidateFork<CandidateLeaf<InternalOldEquality>, CandidateLeaf<InternalNewEquality>>
typealias InternalSwapCatalogue = CandidateFork<CandidateLeaf<InternalOldSwap>, CandidateLeaf<InternalNewSwap>>
typealias SelectNewEqualityInstrument = SelectCandidateRight<CandidateLeaf<InternalOldEquality>, SelectCandidateLeaf<InternalNewEquality>>
typealias SelectNewSwapInstrument = SelectCandidateRight<CandidateLeaf<InternalOldSwap>, SelectCandidateLeaf<InternalNewSwap>>
typealias SelectedInternalEquality = SelectedResidentTraceExtension<
    InternalEqualityCalibrationTrace, InternalEqualityCatalogue, SelectNewEqualityInstrument, InternalEqualityChoice>
typealias SelectedInternalSwap = SelectedResidentTraceExtension<
    InternalSwapCalibrationTrace, InternalSwapCatalogue, SelectNewSwapInstrument, InternalSwapChoice>
enum InternalInstrumentPolicyDoesNotReadTheLaw: Null {
    typealias Left = InternalEqualityChoice
    typealias Right = InternalSwapChoice
}
typealias SelectedInternalRecordsDistinguishTheLaws = ZeroSuccessorBoundaryPairClass<
    Paired<SelectedInternalEquality.Right.Left.Right.Right.Right.Right.Answer,
        SelectedInternalSwap.Right.Left.Right.Right.Right.Right.Answer>, Never>

#if FRAME_SELECTED_OLD_PREPARATION
typealias SelectOldEqualityInstrument = SelectCandidateLeft<SelectCandidateLeaf<InternalOldEquality>, CandidateLeaf<InternalNewEquality>>
typealias RejectedSelectedOldPreparation = SelectedResidentTraceExtension<
    InternalEqualityCalibrationTrace, InternalEqualityCatalogue, SelectOldEqualityInstrument, InternalEqualityChoice>
#endif
#if FRAME_SELECTED_FOREIGN_CATALOGUE
typealias RejectedSelectedForeignCatalogue = SelectedResidentTraceExtension<
    InternalEqualityCalibrationTrace, InternalEqualityCatalogue, SelectNewSwapInstrument, InternalEqualityChoice>
#endif
#if FRAME_CHOICE_REPEATED_RESERVE
typealias RepeatedReserveTrace = AppendObservation<
    StartObservations<RepeatedReserveEquality.Left>, InternalReserve<RouteByThirdEqualityQuestion, Lit1>>
typealias RejectedChoiceFromRepeatedReserve = DecodeRefinedEvidence<
    LatestObservation<RepeatedReserveTrace.Right>, ChooseSecondPreparedInstrument>
#endif

typealias LastFourCoordinate<X: Pair> = SequentialReading<
    SecondEvidenceImage<X, BeamSpace, SaturationEncoding, SecondProjection>,
    SecondEvidenceImage<X.Right, BeamSpace, SaturationEncoding, SecondProjection>
> where X.Right: Pair

// Two clauses on their actual repeated-field preparations. Each reads only
// the first and last fields because those preparations supply the others.
typealias ChangeMultiplicity31To22<A: Structure, B: Structure> = JointEvidence<
    JointEvidence<FirstDataCoordinate<BoundaryWorking<A, A, A, B>>,
        FirstDataCoordinate<BoundaryWorking<A, A, A, B>>>,
    JointEvidence<LastFourCoordinate<BoundaryWorking<A, A, A, B>>,
        LastFourCoordinate<BoundaryWorking<A, A, A, B>>>>
typealias ChangeMultiplicity22To31<A: Structure, B: Structure> = JointEvidence<
    JointEvidence<FirstDataCoordinate<BoundaryWorking<A, A, B, B>>,
        FirstDataCoordinate<BoundaryWorking<A, A, B, B>>>,
    JointEvidence<FirstDataCoordinate<BoundaryWorking<A, A, B, B>>,
        LastFourCoordinate<BoundaryWorking<A, A, B, B>>>>

enum Multiplicity31Returns<A: Structure, B: Structure>: Null {
    typealias Run = SequentialReading<ChangeMultiplicity31To22<A, B>, ChangeMultiplicity22To31<A, B>>
    typealias Left = Run.Answer
    typealias Right = Run.Left
}
enum Multiplicity22Returns<A: Structure, B: Structure>: Null {
    typealias Run = SequentialReading<ChangeMultiplicity22To31<A, B>, ChangeMultiplicity31To22<A, B>>
    typealias Left = Run.Answer
    typealias Right = Run.Left
}
typealias MultiplicityChangeHasAnActualContrast = ZeroSuccessorBoundaryPairClass<
    Paired<ChangeMultiplicity31To22<Never, Lit1>.Left.Right.Left,
        ChangeMultiplicity31To22<Never, Lit1>.Answer.Right.Left>, Never>

typealias EqualityRoutingChangesMergedPreparation = ZeroSuccessorBoundaryPairClass<
    Paired<ThirdMatchesFirst<Never, Lit1>.Left.Left,
        ThirdMatchesFirst<Never, Lit1>.Answer.Left>, Never
>

#if FRAME_EQUALITY_FROZEN_ROUTING
enum RejectedEqualityFrozenRouting: Null {
    typealias Left = ThirdMatchesFirst<Never, Lit1>.Answer
    typealias Right = ThirdMatchesFirst<Never, Lit1>.Left
}
#endif

#if FRAME_EQUALITY_WRONG_RETURN
typealias RejectedEqualityWrongReturn = SequentialReading<
    ThirdMatchesFirst<Never, Lit1>, ThirdMatchesSecond<Never, Lit1>
>
#endif

// The two non-recovering uniform selection branches use existing projections.
typealias FirstSelectionTwice<P: Pair> = JointEvidence<
    FirstEvidenceImage<P, BeamSpace, SaturationEncoding, PairRelationQuestion>,
    FirstEvidenceImage<P, BeamSpace, SaturationEncoding, PairRelationQuestion>
> where P.Left: Structure
typealias SecondSelectionTwice<P: Pair> = JointEvidence<
    SecondEvidenceImage<P, BeamSpace, SaturationEncoding, PairRelationQuestion>,
    SecondEvidenceImage<P, BeamSpace, SaturationEncoding, PairRelationQuestion>
> where P.Right: Structure
enum FirstSelectionMergesSecondCoordinate: Null {
    typealias Left = FirstSelectionTwice<Paired<Never, Never>>.Answer
    typealias Right = FirstSelectionTwice<RelativeFramePair>.Answer
}
enum SecondSelectionMergesFirstCoordinate: Null {
    typealias Left = SecondSelectionTwice<RelativeFramePair>.Answer
    typealias Right = SecondSelectionTwice<Paired<Lit1, Lit1>>.Answer
}
typealias FirstSelectionSourceContrast = ZeroSuccessorBoundaryPairClass<
    Paired<FirstSelectionTwice<Paired<Never, Never>>.Left.Right, FirstSelectionTwice<RelativeFramePair>.Left.Right>, Never
>
typealias SecondSelectionSourceContrast = ZeroSuccessorBoundaryPairClass<
    Paired<SecondSelectionTwice<RelativeFramePair>.Left.Left, SecondSelectionTwice<Paired<Lit1, Lit1>>.Left.Left>, Never
>
typealias StableFrameSamePairs = SharedDirectPairFrame<Paired<RelativeFramePair, RelativeFramePair>>
typealias MixedFrameDifferentPairs = MixedPairFrame<Paired<RelativeFramePair, RelativeFrameReversed>>

enum SameImagesHideFrameDifference: Null {
    typealias Left = FactOf<StableFrameSamePairs>
    typealias Right = FactOf<MixedFrameDifferentPairs>
}

enum StableFrameSourcesAgree: Null {
    typealias Left = StableFrameSamePairs.Left.Left.Left
    typealias Right = StableFrameSamePairs.Left.Left.Right
}

typealias MixedFrameSourceContrast = ZeroSuccessorBoundaryPairClass<
    Paired<MixedFrameDifferentPairs.Left.Left.Left.Left, MixedFrameDifferentPairs.Left.Left.Right.Left>, Never
>

// A common contrast probe can have unknown absolute orientation. Acquisition
// retains each actual source, while the two reported facts can coincide.
typealias RelativeProbeII = AcquireAnswer<SharedDirectPairFrame<Paired<RelativeFramePair, RelativeFramePair>>>
typealias RelativeProbeSS = AcquireAnswer<SharedCrossedPairFrame<Paired<RelativeFrameReversed, RelativeFrameReversed>>>
typealias RelativeProbeIS = AcquireAnswer<MixedPairFrame<Paired<RelativeFramePair, RelativeFramePair>>>
typealias RelativeProbeSI = AcquireAnswer<ReversedMixedPairFrame<Paired<RelativeFrameReversed, RelativeFrameReversed>>>

enum SharedProbeLeavesAbsoluteOrientationOpen: Null {
    typealias Left = RelativeProbeII.Observation.Answer
    typealias Right = RelativeProbeSS.Observation.Answer
}
enum MixedProbeLeavesAbsoluteOrientationOpen: Null {
    typealias Left = RelativeProbeIS.Observation.Answer
    typealias Right = RelativeProbeSI.Observation.Answer
}
enum SharedProbeImagesAgree: Null {
    typealias Left = RelativeProbeII.Answer.Left
    typealias Right = RelativeProbeII.Answer.Right
}
typealias MixedProbeContrast = ZeroSuccessorBoundaryPairClass<
    Paired<RelativeProbeIS.Answer.Left.Left, RelativeProbeIS.Answer.Right.Left>, Never
>
typealias RelativeProbeSeparatesFrameRelations = ZeroSuccessorBoundaryPairClass<
    Paired<RelativeProbeII.Answer.Right.Left, RelativeProbeIS.Answer.Right.Left>, Never
>

// With diagonal data, every frame pair reports the same acquired fact.
enum DiagonalProbeCannotCalibrate<A: Structure>: Null {
    typealias P = Paired<A, A>
    typealias Left = FactOf<SharedDirectPairFrame<Paired<P, P>>>
    typealias Right = FactOf<MixedPairFrame<Paired<P, P>>>
}

// Agreement under an actually mixed connection would force the probe to
// be diagonal. The conclusion is obtained from the concrete probe images.
enum MixedProbeAgreementRequiresDiagonal<P: Pair, C: Null>: Null
where P.Left: Structure, P.Right: Structure,
      C.Left == MixedPairFrame<Paired<P, P>>.Answer.Left,
      C.Right == MixedPairFrame<Paired<P, P>>.Answer.Right {
    typealias Left = P.Left
    typealias Right = P.Right
}

enum RelativeCorrectionCoversNewData<A: Structure, B: Structure, C: Structure, D: Structure>: Null {
    typealias P = Paired<Paired<A, B>, Paired<C, D>>
    typealias Left = MixedFrameCorrection<P>.Left
    typealias Right = MixedFrameCorrection<P>.Right
}
enum RelativeCorrectionCoversOtherOrientation<A: Structure, B: Structure, C: Structure, D: Structure>: Null {
    typealias P = Paired<Paired<A, B>, Paired<C, D>>
    typealias Left = ReversedMixedFrameCorrection<P>.Left
    typealias Right = ReversedMixedFrameCorrection<P>.Right
}

// All eight cases: either orientation of the common contrast probe and
// each I/S frame pair. The facts contain the relative bit, not the source.
typealias BitProbe0 = Paired<RelativeFramePair, RelativeFramePair>
typealias BitProbe1 = Paired<RelativeFrameReversed, RelativeFrameReversed>
typealias BitII0 = AcquireAnswer<RelativeProbeBit<SharedDirectPairFrame<BitProbe0>, EqualPairParity<Never>>>
typealias BitII1 = AcquireAnswer<RelativeProbeBit<SharedDirectPairFrame<BitProbe1>, EqualPairParity<Lit1>>>
typealias BitSS0 = AcquireAnswer<RelativeProbeBit<SharedCrossedPairFrame<BitProbe0>, EqualPairParity<Lit1>>>
typealias BitSS1 = AcquireAnswer<RelativeProbeBit<SharedCrossedPairFrame<BitProbe1>, EqualPairParity<Never>>>
typealias BitIS0 = AcquireAnswer<RelativeProbeBit<MixedPairFrame<BitProbe0>, ZeroOneParity>>
typealias BitIS1 = AcquireAnswer<RelativeProbeBit<MixedPairFrame<BitProbe1>, OneZeroParity>>
typealias BitSI0 = AcquireAnswer<RelativeProbeBit<ReversedMixedPairFrame<BitProbe0>, OneZeroParity>>
typealias BitSI1 = AcquireAnswer<RelativeProbeBit<ReversedMixedPairFrame<BitProbe1>, ZeroOneParity>>

enum SharedBitFirstOrientation: Null { typealias Left = BitII0.Answer; typealias Right = Never }
enum SharedBitSecondOrientation: Null { typealias Left = BitII1.Observation.Answer; typealias Right = BitII0.Observation.Answer }
enum SharedBitCrossedFirst: Null { typealias Left = BitSS0.Observation.Answer; typealias Right = BitII0.Observation.Answer }
enum SharedBitCrossedSecond: Null { typealias Left = BitSS1.Observation.Answer; typealias Right = BitII0.Observation.Answer }
enum MixedBitFirstOrientation: Null { typealias Left = BitIS0.Answer; typealias Right = Lit1 }
enum MixedBitSecondOrientation: Null { typealias Left = BitIS1.Observation.Answer; typealias Right = BitIS0.Observation.Answer }
enum MixedBitReversedFirst: Null { typealias Left = BitSI0.Observation.Answer; typealias Right = BitIS0.Observation.Answer }
enum MixedBitReversedSecond: Null { typealias Left = BitSI1.Observation.Answer; typealias Right = BitIS0.Observation.Answer }

typealias RelativeBitClassesDiffer = ZeroSuccessorBoundaryPairClass<Paired<BitII0.Answer, BitIS0.Answer>, Never>
typealias SameRelativeBitHidesImageContrast = ZeroSuccessorBoundaryPairClass<
    Paired<SharedDirectPairFrame<BitProbe0>.Answer.Left.Left, SharedDirectPairFrame<BitProbe1>.Answer.Left.Left>, Never
>

// Reducing the visible fact leaves the whole source at its retained address.
enum RelativeBitRetainsSource<R: PredicateReading, P: PredicateReading>: Null
where R.Left: Structure, R.Answer: Pair, R.Answer.Left: Pair, R.Answer.Right: Pair,
      R.Answer.Left.Left: Structure, R.Answer.Right.Left: Structure,
      P.Left == Paired<R.Answer.Left.Left, R.Answer.Right.Left>,
      P.Answer: Pair, R.Sigma == P.Sigma, R.Encoding == P.Encoding {
    typealias Left = AcquireAnswer<RelativeProbeBit<R, P>>.Record.Right.Left
    typealias Right = R.Left
}

#if FRAME_RELATIVE_BIT_RECOVERS_PROBE_IMAGE
enum RejectedRelativeBitImageRecovery: Null {
    typealias Left = SharedDirectPairFrame<BitProbe0>.Answer
    typealias Right = SharedDirectPairFrame<BitProbe1>.Answer
}
#endif

// The acquired record is part of the same whole before the frame change.
// The new data can be any four structures, independently of the probe.
enum ReplayAcquisitionMeetsExchange<A: Structure, B: Structure, C: Structure, D: Structure>: Null {
    typealias P = Paired<Paired<A, B>, Paired<C, D>>
    typealias F = MixedFrameReplayAfterExchange<P>
    typealias Recorded = StepBeside<F.Acquisition.Record, MixedPairFrame<P>.Left>
    typealias Left = SwapBoundaryReading<Recorded.Right>.Answer
    typealias Right = F.Change.Left
}
enum ReplayPreservesActualArchive<A: Structure, B: Structure, C: Structure, D: Structure>: Null {
    typealias F = MixedFrameReplayAfterExchange<Paired<Paired<A, B>, Paired<C, D>>>
    typealias Left = F.Change.Left.Right
    typealias Right = F.Change.Right.Right
}
enum ReplayAnswersIndependentQuestion<A: Structure, B: Structure, C: Structure, D: Structure>: Null {
    typealias F = MixedFrameReplayAfterExchange<Paired<Paired<A, B>, Paired<C, D>>>
    typealias Left = F.Left.Answer
    typealias Right = F.Right.Answer
}
enum SharedFactDecodesNewCommonFrame<A: Structure, B: Structure, C: Structure, D: Structure>: Null {
    typealias P = Paired<Paired<A, B>, Paired<C, D>>
    typealias Image = SharedCrossedPairFrame<P>.Answer
    typealias Left = SharedFrameFactDecoder<Paired<BitII0.Observation.Answer, Image>>.Answer
    typealias Right = Image
}

typealias FrameReplay = MixedFrameReplayAfterExchange<BitProbe0>
// Arbitrary replacement has another data source and direct/direct frames.
// It retains the very same acquired fact and reports the same new images.
typealias ReplacedFrameReading = SharedDirectPairFrame<FrameReplay.CurrentImage.Answer>
typealias ReplacedFrameWhole = Paired<ReplacedFrameReading.Left, FrameReplay.Acquisition.Record.Right>
typealias ReplacedFrameArchive = SecondEvidenceImage<ReplacedFrameWhole, BeamSpace, SaturationEncoding, RelativeFrameQuestion>
typealias ReplacedFrameFact = DecodeRefinedEvidence<
    ReplacedFrameArchive,
    SecondEvidenceImage<FrameReplay.Acquisition.Record.Right, BeamSpace, SaturationEncoding, RelativeFrameQuestion>
>
typealias ReplacedCurrentImage = DecodeRefinedEvidence<
    FirstEvidenceImage<ReplacedFrameWhole, BeamSpace, SaturationEncoding, PairRelationQuestion>, ReplacedFrameReading
>
typealias ReplacedFrameEvidenceReading = JointEvidence<ReplacedFrameFact, ReplacedCurrentImage>
typealias ReplacedFrameEvidence = ReplacedFrameEvidenceReading.Answer
enum SameEvidenceAcrossUntrackedFrameReplacement: Null {
    typealias Left = FrameReplay.Observation.Answer
    typealias Right = ReplacedFrameEvidence
}
enum SameArchiveAcrossUntrackedFrameReplacement: Null {
    typealias Left = FrameReplay.Archive.Answer
    typealias Right = ReplacedFrameArchive.Answer
}
enum SameDecoderAcrossUntrackedFrameReplacement: Null {
    typealias Left = FrameReplay.Right
    typealias Right = MixedFrameFactDecoder<ReplacedFrameEvidence>
}
typealias UntrackedReplacementChangesAnswer = SuccessorZeroBoundaryPairClass<
    Paired<FrameReplay.Left.Answer.Right.Left, ReplacedFrameReading.Answer.Right.Left>, Never
>

#if FRAME_OLD_CALIBRATION_COVERS_ARBITRARY_REPLACEMENT
enum RejectedUntrackedFrameReplay: Null {
    typealias Left = MixedFrameFactDecoder<ReplacedFrameEvidence>.Answer
    typealias Right = ReplacedFrameReading.Answer
}
#endif

#if FRAME_REPLAY_RECOVERS_ABSOLUTE_DATA
enum RejectedAbsoluteDataFromReplay: Null {
    typealias Left = FrameReplay.Right.Answer
    typealias Right = BitProbe0
}
#endif

#if FRAME_RELATIVE_BIT_ERASES_CLASS
enum RejectedRelativeBitClassMerger: Null {
    typealias Left = BitII0.Answer
    typealias Right = BitIS0.Answer
}
#endif

#if FRAME_PROBE_IDENTIFIES_ABSOLUTE_SOURCE
enum RejectedAbsoluteProbeSource: Null {
    typealias Left = RelativeProbeII.Left.Left.Left.Left.Left
    typealias Right = RelativeProbeSS.Left.Left.Left.Left.Left
}
#endif

#if FRAME_CONTRAST_PROBE_RELATIONS_AGREE
enum RejectedRelativeProbeMerger: Null {
    typealias Left = RelativeProbeII.Observation.Answer
    typealias Right = RelativeProbeIS.Observation.Answer
}
#endif

#if FRAME_DIAGONAL_CALIBRATION_COVERS_CONTRAST
enum RejectedDiagonalProbeReuse: Null {
    typealias NewData = Paired<RelativeFramePair, RelativeFramePair>
    typealias Left = SharedDirectPairFrame<NewData>.Answer
    typealias Right = MixedPairFrame<NewData>.Answer
}
#endif

#if FRAME_MIXED_IMAGES_FORCE_SOURCE_AGREEMENT
enum RejectedMixedFrameAgreement: Null {
    typealias Left = MixedFrameDifferentPairs.Left.Left.Left
    typealias Right = MixedFrameDifferentPairs.Left.Left.Right
}
#endif

#if FRAME_SHARED_ORIENTATION_IS_KNOWN
enum RejectedSharedOrientation: Null {
    typealias Left = SharedCrossedPairFrame<Paired<RelativeFramePair, RelativeFramePair>>.Answer.Left
    typealias Right = RelativeFramePair
}
#endif

#if FRAME_SHARED_CROSSING_ERASES_CONTRAST
enum RejectedSharedContrast: Null {
    typealias Observed = SharedCrossedPairFrame<Paired<RelativeFramePair, RelativeFrameReversed>>.Answer
    typealias Left = Observed.Left
    typealias Right = Observed.Right
}
#endif
#if FRAME_FACT_IDENTIFIES_WHOLE
enum RejectedFrameWhole: Null {
    typealias Left = FrameCrossed.Left
    typealias Right = FrameDirect.Left
}
#endif
#if FRAME_ORDER_CHANGE_IS_INVISIBLE
enum RejectedFrameOrder: Null {
    typealias Left = ProbeThroughDirectFrame<FrameModule>.Answer
    typealias Right = FrameCrossed.Answer
}
#endif
#if FRAME_WRONG_CALIBRATION
enum RejectedFrameCalibration: Null {
    typealias Observed = ProbeThroughDirectFrame<FrameModule>.Answer
    typealias Left = ExchangeFirstImage<RoutingFromProbeImages<Observed>.Answer>.Answer
    typealias Right = FrameModule
}
#endif
