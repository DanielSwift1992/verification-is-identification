import VerificationIsIdentification
import Examples

// Arithmetic derivations retain operands and compute canonical successors.
typealias ProductOne<N: IntegerValued> = ProductSuccessor<ProductZero<N>, AddZero<N>>
enum ProductByOneComputesOperand<N: IntegerValued>: Null {
    typealias Left = ProductOne<N>.Answer
    typealias Right = N
}

enum ProductStepComputesBothAddresses<P: NaturalProduct, A: NaturalSum>: Null
where A.Left.Left == P.Answer, A.Left.Right == P.Left.Right {
    typealias Step = ProductSuccessor<P, A>
    typealias Left = Paired<Step.Left, Step.Answer>
    typealias Right = Paired<Paired<Examples.Succ<P.Left.Left>, P.Left.Right>, A.Answer>
}

enum GramSharesOneFactor<P: NaturalProduct>: Null
where P.Left.Left == P.Left.Right {
    typealias Gram = NaturalGram<ProductOne<Lit1>, ProductOne<P.Left.Left>, P>
    typealias Left = Paired<Gram.Left, Gram.Answer>
    typealias Right = Paired<Paired<Lit1, P.Left.Left>,
        MatrixEntries<Lit1, P.Left.Left, P.Left.Left, P.Answer>>
}

typealias GramThree = Examples.Succ<Lit2>
typealias GramFour = Examples.Succ<GramThree>
typealias GramSix = Examples.Succ<Examples.Succ<GramFour>>
typealias GramNine = Examples.Succ<Examples.Succ<Examples.Succ<GramSix>>>
typealias AddTwoToTwo = AddSuccessor<AddSuccessor<AddZero<Lit2>>>
typealias AddThreeToThree = AddSuccessor<AddSuccessor<AddSuccessor<AddZero<GramThree>>>>
typealias AddSixToThree = AddSuccessor<AddSuccessor<AddSuccessor<AddThreeToThree>>>
typealias TwoSquared = ProductSuccessor<ProductOne<Lit2>, AddTwoToTwo>
typealias TwoTimesThree = ProductSuccessor<ProductOne<GramThree>, AddThreeToThree>
typealias ThreeSquared = ProductSuccessor<TwoTimesThree, AddSixToThree>
typealias GramTwoThree = NaturalGram<TwoSquared, TwoTimesThree, ThreeSquared>
typealias RecordedGram = AcquireAnswer<GramTwoThree>

enum GramMatrixComputedFromOriginalFactors: Null {
    typealias Left = Paired<RecordedGram.Left.Left, RecordedGram.Right.Answer>
    typealias Right = Paired<Paired<Lit2, GramThree>,
        MatrixEntries<GramFour, GramSix, GramSix, GramNine>>
}

// IiS12: the same natural products can describe a table of joint weights.
// Here the four entries are normalized by their sum 16, not by a matrix trace.
typealias JointTransportTwoTimesOne = ProductSuccessor<
    ProductOne<Lit1>, AddSuccessor<AddZero<Lit1>>>
typealias JointTransportThreeTimesOne = ProductSuccessor<
    JointTransportTwoTimesOne, AddSuccessor<AddSuccessor<AddZero<Lit1>>>>
typealias JointTransportProduct = NaturalGram<
    ThreeSquared, JointTransportThreeTimesOne, ProductOne<Lit1>>

enum LocalPreparationComputesProductWeights: Null {
    typealias Left = Paired<JointTransportProduct.Left, JointTransportProduct.Answer>
    typealias Right = Paired<Paired<GramThree, Lit1>,
        MatrixEntries<GramNine, GramThree, GramThree, Lit1>>
}

typealias ControlledWeightExchange<A: Structure, B: Structure, C: Structure, D: Structure> =
    PairedApplication<IdentityReading<Paired<A, B>, BeamSpace, SaturationEncoding>,
        SwapBoundaryReading<Paired<C, D>>>
typealias JointTransportPrepared = ControlledWeightExchange<Lit1, Never, Never, Never>
typealias JointTransportMixed = ControlledWeightExchange<
    JointTransportProduct.Answer.Left.Left, JointTransportProduct.Answer.Left.Right,
    JointTransportProduct.Answer.Right.Left, JointTransportProduct.Answer.Right.Right>

enum JointContactDistinguishesProductEncoding: Null {
    typealias Left = Paired<JointTransportPrepared.Answer, JointTransportMixed.Answer>
    typealias Right = Paired<JointTransportPrepared.Left,
        MatrixEntries<GramNine, GramThree, Lit1, GramThree>>
}

// Strip one shared successor from the actual moved weights 1 and 3.
typealias JointTransportWeightContrast = ZeroSuccessorBoundaryPairClass<Paired<
    JointTransportMixed.Answer.Right.Left.Right,
    JointTransportMixed.Left.Right.Left.Right>, Lit1>

#if BAD_SENSOR_LOCAL_TRANSPORT_IS_JOINT_TRANSPORT
enum RejectedLocalTransportIsJointTransport: Null {
    typealias Left = JointTransportMixed.Answer
    typealias Right = JointTransportMixed.Left
}
#endif

typealias GramOneZero = NaturalGram<ProductOne<Lit1>, ProductOne<Never>, ProductZero<Never>>
typealias GramZeroZero = NaturalGram<ProductZero<Never>, ProductZero<Never>, ProductZero<Never>>
typealias GramZeroOne = NaturalGram<ProductZero<Never>, ProductZero<Lit1>, ProductOne<Lit1>>
typealias FirstKrausGram = SequentialReading<
    PairedApplication<GramOneZero, GramZeroZero>,
    AddNaturalMatrices<AddSuccessor<AddZero<Never>>, AddZero<Never>, AddZero<Never>, AddZero<Never>>
>
typealias SecondKrausGram = SequentialReading<
    PairedApplication<GramZeroZero, GramZeroOne>,
    AddNaturalMatrices<AddZero<Never>, AddZero<Never>, AddZero<Never>, AddZero<Lit1>>
>
typealias KrausNormalization = SequentialReading<
    PairedApplication<FirstKrausGram, SecondKrausGram>,
    AddNaturalMatrices<AddSuccessor<AddZero<Never>>, AddZero<Never>, AddZero<Never>, AddZero<Lit1>>
>

enum KrausNormalizationComputesIdentity: Null {
    typealias Left = KrausNormalization.Answer
    typealias Right = MatrixEntries<Lit1, Never, Never, Lit1>
}

// Shared input operators, full recovery and local reduction form one
// generic chain for arbitrary entry descriptions, with no final equality
// or normalization answer as an extra caller premise.
enum BasisRecordCalculus<A: Structure, B: Structure, C: Structure, D: Structure>: Null {
    typealias Input = MatrixEntries<A, B, C, D>
    typealias Record = BasisRecordMatrix<Input>
    typealias Joint = Record.Answer
    typealias Recovery = SequentialReading<Record, RecoverBasisMatrix<Joint>>
    typealias FirstBlocks = FirstEvidenceImage<Joint, MatrixEntrySpace, MatrixEntryEncoding, FirstProjection>
    typealias LastBlocks = SecondEvidenceImage<Joint, MatrixEntrySpace, MatrixEntryEncoding, SecondProjection>
    typealias FirstBlock = SequentialReading<FirstBlocks,
        FirstEvidenceImage<Joint.Left, MatrixEntrySpace, MatrixEntryEncoding, FirstProjection>>
    typealias LastBlock = SequentialReading<LastBlocks,
        SecondEvidenceImage<Joint.Right, MatrixEntrySpace, MatrixEntryEncoding, SecondProjection>>
    typealias DiagonalBlocks = JointEvidence<FirstBlock, LastBlock>
    typealias Local = SequentialReading<SequentialReading<Record, DiagonalBlocks>, SumDisjointDiagonalEntries<A, D>>
    typealias AcquiredLocal = AcquireAnswer<Local>
    typealias Left = Paired<KrausNormalization.Left, Paired<Recovery.Answer, AcquiredLocal.Right.Answer>>
    typealias Right = Paired<Record.Left.Left, Paired<Input, MatrixEntries<A, Never, Never, D>>>
}

// Exchange the two output factors by regrouping actual matrix entries.
// This is the specified basis-record family, not an arbitrary matrix rule.
enum ExchangeBasisRecordFactors<A: Structure, B: Structure, C: Structure, D: Structure>: PredicateReading {
    typealias Left = BasisRecordCalculus<A, B, C, D>.Joint
    typealias Block00 = Left.Left.Left
    typealias Block01 = Left.Left.Right
    typealias Block10 = Left.Right.Left
    typealias Block11 = Left.Right.Right
    typealias Answer = MatrixEntries<
        MatrixEntries<Block00.Left.Left, Block01.Left.Left, Block10.Left.Left, Block11.Left.Left>,
        MatrixEntries<Block00.Left.Right, Block01.Left.Right, Block10.Left.Right, Block11.Left.Right>,
        MatrixEntries<Block00.Right.Left, Block01.Right.Left, Block10.Right.Left, Block11.Right.Left>,
        MatrixEntries<Block00.Right.Right, Block01.Right.Right, Block10.Right.Right, Block11.Right.Right>>
    typealias Right = Answer
    typealias Sigma = MatrixEntrySpace
    typealias Encoding = MatrixEntryEncoding
    typealias Predicate = BasisRecordQuestion
}

enum BothBasisRecordMarginals<A: Structure, B: Structure, C: Structure, D: Structure>: Null {
    typealias Run = BasisRecordCalculus<A, B, C, D>
    typealias Exchange = ExchangeBasisRecordFactors<A, B, C, D>
    typealias ExchangedRecord = SequentialReading<Run.Record, Exchange>
    typealias OtherLocal = SequentialReading<
        SequentialReading<ExchangedRecord, Run.DiagonalBlocks>, SumDisjointDiagonalEntries<A, D>>
    typealias Marginals = Paired<Run.Local.Answer, OtherLocal.Answer>
    typealias Left = Paired<Exchange.Answer, Marginals>
    typealias Right = Paired<Run.Joint,
        Paired<MatrixEntries<A, Never, Never, D>, MatrixEntries<A, Never, Never, D>>>
}

enum BothMarginalsOmitCoherence<A: Structure, B: Structure, C: Structure, D: Structure,
    E: Structure, F: Structure>: Null {
    typealias Left = BothBasisRecordMarginals<A, B, C, D>.Marginals
    typealias Right = BothBasisRecordMarginals<A, E, F, D>.Marginals
}

// After division by two these are a mixed input and a pure bridge input.
// Both have the same two reduced outputs. The full joint entries differ.
typealias IncoherentBasisRecord = BothBasisRecordMarginals<Lit1, Never, Never, Lit1>
typealias CoherentBasisRecord = BothBasisRecordMarginals<Lit1, Lit1, Lit1, Lit1>
typealias JointBasisCoherenceContrast = ZeroSuccessorBoundaryPairClass<Paired<
    IncoherentBasisRecord.Run.Joint.Left.Right.Left.Right,
    CoherentBasisRecord.Run.Joint.Left.Right.Left.Right>, Never>

#if BAD_SENSOR_BOTH_MARGINALS_RECOVER_JOINT
enum RejectedBothMarginalsRecoverJoint: Null {
    typealias Left = IncoherentBasisRecord.Run.Joint
    typealias Right = CoherentBasisRecord.Run.Joint
}
#endif

enum DiagonalDeterminesLocalState<A: Structure, B: Structure, C: Structure, D: Structure>: ReadingFactors {
    typealias Run = BasisRecordCalculus<A, B, C, D>
    typealias Left = Run.Local
    typealias InputProjection = SequentialReading<
        SecondEvidenceImage<Left.Left, MatrixEntrySpace, MatrixEntryEncoding, SecondProjection>,
        SecondEvidenceImage<Left.Left.Right, MatrixEntrySpace, MatrixEntryEncoding, SecondProjection>
    >
    typealias Observation = SequentialReading<InputProjection, ReadMatrixDiagonal<Run.Input>>
    typealias Right = ExpandMatrixDiagonal<Observation.Answer, Left.Predicate>
    typealias Answer = Left.Answer
    typealias Sigma = MatrixEntrySpace
    typealias Encoding = MatrixEntryEncoding
    typealias Predicate = Left.Predicate
}

enum LocalStateFromAcquiredDiagonal<A: Structure, B: Structure, C: Structure, D: Structure>: Null {
    typealias F = DiagonalDeterminesLocalState<A, B, C, D>
    typealias Acquired = AnswerFromAcquiredObservation<F>
    typealias Left = Acquired.Right.Answer
    typealias Right = MatrixEntries<A, Never, Never, D>
}

enum DiagonalFactOmitsCoherence<A: Structure, B: Structure, C: Structure, D: Structure,
    E: Structure, F: Structure>: Null {
    typealias Left = FactOf<DiagonalDeterminesLocalState<A, B, C, D>.Observation>
    typealias Right = FactOf<DiagonalDeterminesLocalState<A, E, F, D>.Observation>
}

#if BAD_SENSOR_DIAGONAL_WRONG_FIELD
enum RejectedDiagonalObservationField: ReadingFactors {
    typealias F = DiagonalDeterminesLocalState<GramFour, GramSix, GramSix, GramNine>
    typealias Left = F.Left
    typealias Right = F.Right
    typealias Observation = SequentialReading<F.InputProjection,
        FirstEvidenceImage<F.Run.Input, MatrixEntrySpace, MatrixEntryEncoding, FirstProjection>>
    typealias Answer = F.Answer
    typealias Sigma = F.Sigma
    typealias Encoding = F.Encoding
    typealias Predicate = F.Predicate
}
#endif
#if BAD_SENSOR_DIAGONAL_WRONG_MEMORY
typealias DiagonalMemoryCase = DiagonalDeterminesLocalState<GramFour, GramSix, GramSix, GramNine>
typealias RejectedDiagonalMemory = DecodeRefinedEvidence<
    ReadRecordedAnswer<FactOf<DiagonalMemoryCase.Observation>>,
    ExpandMatrixDiagonal<Paired<GramFour, GramSix>, DiagonalMemoryCase.Predicate>
>
#endif

#if BAD_SENSOR_KRAUS_DUPLICATE_NORMALIZES
typealias DuplicateKrausNormalization = SequentialReading<
    PairedApplication<FirstKrausGram, FirstKrausGram>,
    AddNaturalMatrices<AddSuccessor<AddZero<Lit1>>, AddZero<Never>, AddZero<Never>, AddZero<Never>>
>
enum RejectedDuplicateKrausNormalization: Null {
    typealias Left = DuplicateKrausNormalization.Answer
    typealias Right = KrausNormalization.Answer
}
#endif
#if BAD_SENSOR_KRAUS_WRONG_OPERATORS
typealias RejectedKrausOperatorSource = SequentialReading<
    IdentityReading<Paired<Paired<Bell00, Bell00>, Paired<Bell00, RealBridgeMatrix>>, MatrixEntrySpace, MatrixEntryEncoding>,
    BasisRecordMatrix<RealBridgeMatrix>
>
#endif
#if BAD_SENSOR_KRAUS_WRONG_PREPARATION
typealias RejectedKrausRecordPreparation = SequentialReading<
    IdentityReading<Paired<BasisRecordOperators, Paired<Bell11, RealBridgeMatrix>>, MatrixEntrySpace, MatrixEntryEncoding>,
    BasisRecordMatrix<RealBridgeMatrix>
>
#endif
#if BAD_SENSOR_KRAUS_ERASES_JOINT_COHERENCE
enum RejectedJointCoherenceErasure: Null {
    typealias Left = BasisRecordMatrix<RealBridgeMatrix>.Answer.Left.Right
    typealias Right = MatrixEntries<Never, Never, Never, Never>
}
#endif
#if BAD_SENSOR_KRAUS_LOCAL_RECOVERS
enum RejectedLocalMatrixRecovery: Null {
    typealias Left = BasisRecordCalculus<Lit1, Lit1, Lit1, Lit1>.Local.Answer
    typealias Right = RealBridgeMatrix
}
#endif

typealias AddGramEntries = AddNaturalMatrices<
    AddSuccessor<AddZero<GramTwoThree.Answer.Left.Left>>,
    AddZero<GramTwoThree.Answer.Left.Right>,
    AddZero<GramTwoThree.Answer.Right.Left>,
    AddZero<GramTwoThree.Answer.Right.Right>
>
typealias TwoGramConstruction = SequentialReading<
    PairedApplication<GramOneZero, GramTwoThree>, AddGramEntries
>
typealias TwoGramRecord = AcquireAnswer<TwoGramConstruction>

enum SummedGramRetainsBothOriginalFactors: Null {
    typealias Left = Paired<TwoGramRecord.Left.Left, TwoGramRecord.Right.Answer>
    typealias Right = Paired<Paired<Paired<Lit1, Never>, Paired<Lit2, GramThree>>,
        MatrixEntries<Examples.Succ<GramFour>, GramSix, GramSix, GramNine>>
}

#if BAD_SENSOR_GRAM_SUM_SOURCE
typealias RejectedGramSumSource = SequentialReading<
    PairedApplication<GramOneZero, GramTwoThree>,
    AddNaturalMatrices<AddZero<GramFour>, AddZero<GramSix>, AddZero<GramSix>, AddZero<GramNine>>
>
#endif
#if BAD_SENSOR_GRAM_SUM_ERASES_FACTOR
enum RejectedGramSumErasesFactor: Null {
    typealias Left = TwoGramRecord.Right.Answer
    typealias Right = RecordedGram.Right.Answer
}
#endif

#if BAD_SENSOR_PRODUCT_RESTART
typealias RejectedProductRestart = ProductSuccessor<ProductOne<Lit2>, AddZero<Lit2>>
#endif
#if BAD_SENSOR_PRODUCT_OPERAND
typealias RejectedProductOperand = ProductSuccessor<ProductOne<Lit2>,
    AddSuccessor<AddSuccessor<AddZero<GramThree>>>>
#endif
#if BAD_SENSOR_GRAM_FIRST_FACTOR
typealias RejectedGramFirstFactor = NaturalGram<TwoTimesThree, TwoTimesThree, ThreeSquared>
#endif
#if BAD_SENSOR_GRAM_SECOND_FACTOR
typealias RejectedGramSecondFactor = NaturalGram<TwoSquared, TwoTimesThree, TwoSquared>
#endif
#if BAD_SENSOR_GRAM_COMPUTED_ENTRY
enum RejectedGramComputedEntry: Null {
    typealias Left = GramTwoThree.Answer.Left.Right
    typealias Right = GramFour
}
#endif

// Complete positivity tests a local rule in a retained joint context.
// The matrix is twice the Bell density operator in the article. Integer
// entries permit an exact signed expansion with the existing constructors.
typealias Bell00 = MatrixEntries<Lit1, Never, Never, Never>
typealias Bell01 = MatrixEntries<Never, Lit1, Never, Never>
typealias Bell10 = MatrixEntries<Never, Never, Lit1, Never>
typealias Bell11 = MatrixEntries<Never, Never, Never, Lit1>
typealias BellIntegerMatrix = MatrixEntries<Bell00, Bell01, Bell10, Bell11>
typealias BellPartialTranspose = PairedApplication<
    PairedApplication<TransposeEntries<Bell00>, TransposeEntries<Bell01>>,
    PairedApplication<TransposeEntries<Bell10>, TransposeEntries<Bell11>>
>

enum PartialTransposeKeepsActualSource: Null {
    typealias Left = BellPartialTranspose.Left
    typealias Right = BellIntegerMatrix
}

enum PartialTransposeComputesCrossEntries: Null {
    typealias Left = BellPartialTranspose.Answer
    typealias Right = MatrixEntries<Bell00, Bell10, Bell01, Bell11>
}

// Assemble the Choi blocks from four actual applications of the one
// generic local rule. Matrix units 01 and 10 are formal linear inputs,
// not separately preparable density operators.
typealias DephasingChoiApplications = PairedApplication<
    PairedApplication<BasisRecordCalculus<Lit1, Never, Never, Never>.Local,
        BasisRecordCalculus<Never, Lit1, Never, Never>.Local>,
    PairedApplication<BasisRecordCalculus<Never, Never, Lit1, Never>.Local,
        BasisRecordCalculus<Never, Never, Never, Lit1>.Local>
>
typealias TraceFirstProjector = TraceNaturalEntries<AddSuccessor<AddZero<Never>>, Never, Never>
typealias TraceZeroMatrix = TraceNaturalEntries<AddZero<Never>, Never, Never>
typealias TraceSecondProjector = TraceNaturalEntries<AddZero<Lit1>, Never, Never>
typealias DephasingChoiTrace = SequentialReading<DephasingChoiApplications,
    PairedApplication<PairedApplication<TraceFirstProjector, TraceZeroMatrix>,
        PairedApplication<TraceZeroMatrix, TraceSecondProjector>>>

enum ChoiMatrixFromActionHasPositiveConstruction: Null {
    typealias Left = DephasingChoiApplications.Answer
    typealias Right = BasisRecordMatrix<KrausNormalization.Answer>.Answer
}

enum ChoiTraceComputesNormalization: Null {
    typealias Left = DephasingChoiTrace.Answer
    typealias Right = KrausNormalization.Answer
}

typealias TransposeChoiTrace = SequentialReading<BellPartialTranspose,
    PairedApplication<
        PairedApplication<TraceFirstProjector, TraceNaturalEntries<AddZero<Never>, Never, Lit1>>,
        PairedApplication<TraceNaturalEntries<AddZero<Never>, Lit1, Never>, TraceSecondProjector>>>

// Correct partial trace coexists with the already derived negative weight.
enum TransposeChoiAlsoHasIdentityPartialTrace: Null {
    typealias Left = TransposeChoiTrace.Answer
    typealias Right = KrausNormalization.Answer
}

#if BAD_SENSOR_CHOI_TRACE_IDENTIFIES
enum RejectedChoiIdentificationFromTrace: Null {
    typealias Left = DephasingChoiApplications.Answer
    typealias Right = BellPartialTranspose.Answer
}
#endif
#if BAD_SENSOR_CHOI_OMITS_BLOCK_ACTION
enum RejectedChoiOffDiagonalReplacement: Null {
    typealias Left = DephasingChoiApplications.Answer.Left.Right
    typealias Right = Bell01
}
#endif
#if BAD_SENSOR_CHOI_TRACE_SOURCE
typealias RejectedChoiTraceSource = SequentialReading<DephasingChoiApplications,
    PairedApplication<
        PairedApplication<TraceFirstProjector, TraceNaturalEntries<AddZero<Never>, Never, Lit1>>,
        PairedApplication<TraceZeroMatrix, TraceSecondProjector>>>
#endif

enum EntryTransposeIsInvolution<A: Structure, B: Structure, C: Structure, D: Structure>: Null {
    typealias Source = MatrixEntries<A, B, C, D>
    typealias Twice = SequentialReading<TransposeEntries<Source>, TransposeEntries<TransposeEntries<Source>.Answer>>
    typealias Left = Twice.Answer
    typealias Right = Source
}

// These two distinct nonorthogonal pure probes are fixed by transpose.
typealias RealBridgeMatrix = MatrixEntries<Lit1, Lit1, Lit1, Lit1>
enum TransposePreservesRealProbes: Null {
    typealias Left = Paired<TransposeEntries<Bell00>.Answer, TransposeEntries<RealBridgeMatrix>.Answer>
    typealias Right = Paired<Bell00, RealBridgeMatrix>
}

typealias JointWeight = SequentialReading<
    BellPartialTranspose, AntisymmetricWeightTerms<BellPartialTranspose.Answer>
>
typealias JointWeightRecord = AcquireAnswer<JointWeight>

typealias WeightZero1 = AppendAmplitudeBlock<EmptyAmplitudeSum, StartAmplitudeBlock<Vacuum, Phase0>>
typealias WeightZero2 = AppendAmplitudeBlock<WeightZero1, StartAmplitudeBlock<WeightZero1.Word, Phase0>>
typealias WeightMinus1 = AppendAmplitudeBlock<WeightZero2,
    NegativeAmplitudeUnit<StartAmplitudeBlock<WeightZero2.Word, PhaseHalf>>>
typealias WeightMinus2 = AppendAmplitudeBlock<WeightMinus1,
    NegativeAmplitudeUnit<StartAmplitudeBlock<WeightMinus1.Word, PhaseHalf>>>

// No coefficient or answer equality is supplied to the matrix operation.
// The expansion source equals its computed and actually acquired terms.
enum JointWeightExpansionUsesRecordedTerms: Null {
    typealias Left = WeightMinus2.Source
    typealias Right = JointWeightRecord.Right.Answer
}

enum JointWeightHasTwoNegativeUnits: Null {
    typealias Left = Paired<WeightMinus2.Word.InCount, WeightMinus2.Word.OutCount>
    typealias Right = Paired<Never, Lit2>
}

#if BAD_SENSOR_TRANSPOSE_IS_IDENTITY
enum RejectedPartialTransposeIdentity: Null {
    typealias Left = AntisymmetricWeightTerms<BellIntegerMatrix>.Answer
    typealias Right = JointWeight.Answer
}
#endif
#if BAD_SENSOR_TRANSPOSE_WEIGHT_ZERO
typealias RejectedTransposeWeightZero = ZeroAmplitudeReading<WeightMinus2>
#endif
#if BAD_SENSOR_TRANSPOSE_WRONG_SOURCE
typealias RejectedTransposeWeightSource = SequentialReading<
    BellPartialTranspose, AntisymmetricWeightTerms<BellIntegerMatrix>
>
#endif

// Derive coincidence for every starting sample. No image equality is a premise.
enum MixedSensorImagesAgree<P: SpectralSample>: Null {
    typealias Left = MixedSpectralVerdict<P>.Left.Answer
    typealias Right = MixedSpectralVerdict<P>.Right.Answer
}

typealias ThreeSeparateChannels = SensorAddC<SensorAddB<SensorAddA<SensorDark>>>
typealias OneSharedChannel = SensorAddD<SensorDark>

enum SeparateSourceIsComputed: Null {
    typealias Left = ThreeSeparateChannels.Left
    typealias Right = Paired<Paired<Lit1, Lit1>, Paired<Lit1, Never>>
}

enum SharedSourceIsComputed: Null {
    typealias Left = OneSharedChannel.Left
    typealias Right = Paired<Paired<Never, Never>, Paired<Never, Lit1>>
}

enum MixedImageIsComputed: Null {
    typealias Left = MixedSpectralVerdict<SensorDark>.Answer
    typealias Right = Paired<Lit1, Paired<Lit1, Lit1>>
}

enum FirstFourthChannelIsDark: Null {
    typealias Left = FourthChannelReading<ThreeSeparateChannels>.Answer
    typealias Right = Never
}

enum SecondFourthChannelIsLit: Null {
    typealias Left = FourthChannelReading<OneSharedChannel>.Answer
    typealias Right = Lit1
}

// Every channel contributes, including the fourth. Mutations below must fail
// on their named declaration, not on an unrelated fixture or missing module.
#if BAD_SENSOR_A
 typealias RejectedSensorA = JoinedVerdict<SensorDark, SensorAddA<SensorDark>>
#endif
#if BAD_SENSOR_B
 typealias RejectedSensorB = JoinedVerdict<SensorDark, SensorAddB<SensorDark>>
#endif
#if BAD_SENSOR_C
 typealias RejectedSensorC = JoinedVerdict<SensorDark, SensorAddC<SensorDark>>
#endif
#if BAD_SENSOR_D
 typealias RejectedSensorD = JoinedVerdict<SensorDark, SensorAddD<SensorDark>>
#endif
#if BAD_SENSOR_SEPARATOR
 typealias RejectedSensorSeparator = JoinedVerdict<
    FourthChannelReading<ThreeSeparateChannels>, FourthChannelReading<OneSharedChannel>
 >
#endif
#if BAD_SENSOR_MIX
 typealias RejectedSensorMix = JoinedVerdict<
    SensorAddB<SensorAddA<SensorDark>>, OneSharedChannel
 >
#endif
#if BAD_SENSOR_QUESTION
 typealias RejectedSensorQuestion = JoinedVerdict<
    FourthChannelReading<ThreeSeparateChannels>, ThreeSeparateChannels
 >
#endif

// The old OppositePair accidentally accepted only Lit1. This generic body
// requires its conformance for every common magnitude, including zero.
func oppositeAmplitudeIsGeneric<M: IntegerValued>(_: M.Type) {
    func requireOpposites<T: SettlesToDark>(_: T.Type) {}
    requireOpposites(OppositePair<Contribution<M, Phase0>, Contribution<M, PhaseHalf>>.self)
}

enum OppositeReadingKeepsSource<M: IntegerValued>: Null {
    typealias Left = OppositeAmplitudeReading<M>.Left
    typealias Right = Paired<Contribution<M, Phase0>, Contribution<M, PhaseHalf>>
}

typealias FirstPositiveBlock = PositiveAmplitudeUnit<StartAmplitudeBlock<Vacuum, Phase0>>
typealias FirstPositiveSum = AppendAmplitudeBlock<EmptyAmplitudeSum, FirstPositiveBlock>
typealias SecondPositiveBlock = PositiveAmplitudeUnit<StartAmplitudeBlock<FirstPositiveSum.Word, Phase0>>
typealias TwoPositiveSum = AppendAmplitudeBlock<FirstPositiveSum, SecondPositiveBlock>
typealias NegativeTwoBlock = NegativeAmplitudeUnit<NegativeAmplitudeUnit<
    StartAmplitudeBlock<TwoPositiveSum.Word, PhaseHalf>
>>
typealias CancelUnequalMagnitudes = AppendAmplitudeBlock<TwoPositiveSum, NegativeTwoBlock>

enum ThreeContributionsAreOriginal: Null {
    typealias Left = ZeroAmplitudeReading<CancelUnequalMagnitudes>.Left
    typealias Right = Paired<
        Paired<Paired<Never, Contribution<Lit1, Phase0>>, Contribution<Lit1, Phase0>>,
        Contribution<Lit2, PhaseHalf>
    >
}

enum ThreeContributionsTotalZero: Null {
    typealias Left = ZeroAmplitudeReading<CancelUnequalMagnitudes>.Answer
    typealias Right = Never
}

typealias ZeroOnEmptySource = ZeroAmplitudeReading<EmptyAmplitudeSum>

#if BAD_SENSOR_AMPLITUDE_RESTART
 typealias RejectedAmplitudeRestart = AppendAmplitudeBlock<FirstPositiveSum, FirstPositiveBlock>
#endif
#if BAD_SENSOR_AMPLITUDE_SIGN
 typealias RejectedAmplitudeSign = PositiveAmplitudeUnit<StartAmplitudeBlock<Vacuum, PhaseHalf>>
#endif
#if BAD_SENSOR_AMPLITUDE_RESIDUE
 typealias RejectedAmplitudeResidue = ZeroAmplitudeReading<TwoPositiveSum>
#endif
#if BAD_SENSOR_AMPLITUDE_MAGNITUDE
 enum RejectedAmplitudeMagnitude: Null {
     typealias Left = ZeroAmplitudeReading<CancelUnequalMagnitudes>.Left.Right
     typealias Right = Contribution<Lit1, PhaseHalf>
 }
#endif
#if BAD_SENSOR_OPPOSITE_MAGNITUDE
 func rejectedOppositeMagnitude() {
     func RejectedOppositeMagnitude<T: SettlesToDark>(_: T.Type) {}
     RejectedOppositeMagnitude(OppositePair<Contribution<Lit1, Phase0>, Contribution<Lit2, PhaseHalf>>.self)
 }
#endif
#if BAD_SENSOR_OPPOSITE_PHASE
 func rejectedOppositePhase() {
     func RejectedOppositePhase<T: SettlesToDark>(_: T.Type) {}
     RejectedOppositePhase(OppositePair<Contribution<Lit2, Phase0>, Contribution<Lit2, Phase0>>.self)
 }
#endif

// Actual operation outputs compose through SequentialReading. No algebraic
// identities are premises of this generic proof over four arbitrary terms.
enum SignedModeAlgebra<AP: Structure, AN: Structure, BP: Structure, BN: Structure>: Null {
    typealias S = SignedModes<AP, AN, BP, BN>
    typealias XX = SequentialReading<ExchangeModes<S>, ExchangeModes<ExchangeModes<S>.Answer>>
    typealias ZZ = SequentialReading<ReverseSecondPhase<S>, ReverseSecondPhase<ReverseSecondPhase<S>.Answer>>
    typealias XZ = SequentialReading<ReverseSecondPhase<S>, ExchangeModes<ReverseSecondPhase<S>.Answer>>
    typealias ZX = SequentialReading<ExchangeModes<S>, ReverseSecondPhase<ExchangeModes<S>.Answer>>
    typealias MinusZX = SequentialReading<ZX, ReverseBothPhases<ZX.Answer>>
    typealias Left = Paired<XX.Answer, Paired<ZZ.Answer, XZ.Answer>>
    typealias Right = Paired<S, Paired<S, MinusZX.Answer>>
}

enum CommonPhaseCommutes<AP: Structure, AN: Structure, BP: Structure, BN: Structure>: Null {
    typealias S = SignedModes<AP, AN, BP, BN>
    typealias N = ReverseBothPhases<S>
    typealias Left = Paired<ExchangeModes<N.Answer>.Answer, ReverseSecondPhase<N.Answer>.Answer>
    typealias Right = Paired<
        ReverseBothPhases<ExchangeModes<S>.Answer>.Answer,
        ReverseBothPhases<ReverseSecondPhase<S>.Answer>.Answer
    >
}

// IiS10: the same primitive rephasing occurs in both compared orders.
// All four sign choices are composed from actual source fields. Their
// common output reversal preserves the opposite-branch relation.
enum BalancedOrderRephasing<AP: Structure, AN: Structure, BP: Structure, BN: Structure>: Null {
    typealias S = SignedModes<AP, AN, BP, BN>
    typealias X = ExchangeModes<S>
    typealias Z = ReverseSecondPhase<S>
    typealias NX = SequentialReading<X, ReverseBothPhases<X.Answer>>
    typealias NZ = SequentialReading<Z, ReverseBothPhases<Z.Answer>>
    typealias U = SequentialReading<Z, ExchangeModes<Z.Answer>>
    typealias V = SequentialReading<X, ReverseSecondPhase<X.Answer>>
    typealias RephaseX_U = SequentialReading<U, ReverseBothPhases<U.Answer>>
    typealias RephaseX_V = SequentialReading<NX, ReverseSecondPhase<NX.Answer>>
    typealias RephaseZ_U = SequentialReading<NZ, ExchangeModes<NZ.Answer>>
    typealias RephaseZ_V = SequentialReading<V, ReverseBothPhases<V.Answer>>
    typealias RephaseBoth_U = SequentialReading<RephaseZ_U,
        ReverseBothPhases<RephaseZ_U.Answer>>
    typealias RephaseBoth_V = SequentialReading<RephaseX_V,
        ReverseBothPhases<RephaseX_V.Answer>>
    typealias Base = Paired<U.Answer, V.Answer>
    typealias CommonReversal = PairedApplication<
        ReverseBothPhases<U.Answer>, ReverseBothPhases<V.Answer>>
    typealias ChangedX = Paired<RephaseX_U.Answer, RephaseX_V.Answer>
    typealias ChangedZ = Paired<RephaseZ_U.Answer, RephaseZ_V.Answer>
    typealias ChangedBoth = Paired<RephaseBoth_U.Answer, RephaseBoth_V.Answer>
    typealias Left = MatrixEntries<Base, ChangedX, ChangedZ, ChangedBoth>
    typealias Right = MatrixEntries<Base,
        CommonReversal.Answer, CommonReversal.Answer, Base>
    typealias DarkBase = CancelOppositeBranches<Base>
    typealias DarkX = CancelOppositeBranches<ChangedX>
    typealias DarkZ = CancelOppositeBranches<ChangedZ>
    typealias DarkBoth = CancelOppositeBranches<ChangedBoth>
    // A reversal introduced on only one route has a different contract.
    typealias OneRouteOnly = Paired<RephaseX_U.Answer, V.Answer>
}

enum OneRouteRephasingMakesOrdersAgree<A: Structure, B: Structure,
    C: Structure, D: Structure>: Null {
    typealias Changed = BalancedOrderRephasing<A, B, C, D>.OneRouteOnly
    typealias Left = Changed.Left
    typealias Right = Changed.Right
}

#if BAD_SENSOR_ORDER_UNBALANCED_CANCELS
typealias RejectedUnbalancedOrderCancellation = CancelOppositeBranches<
    BalancedOrderRephasing<Lit1, Never, Never, Never>.OneRouteOnly>
#endif
#if BAD_SENSOR_ORDER_COMMON_CHANGE_IS_ONE_ROUTE
enum RejectedCommonOrderChangeIsOneRoute: Null {
    typealias C = BalancedOrderRephasing<Lit1, Never, Never, Never>
    typealias Left = C.ChangedX
    typealias Right = C.OneRouteOnly
}
#endif

typealias SingleModeInput = SignedModes<Lit1, Never, Never, Never>

// IiS12: here the two signed coordinates are the real and imaginary
// parts of one coefficient. XZ and ZX therefore multiply by i and -i.
// This scalar interpretation differs from their two-mode gate use above.
typealias QuarterTurnCoefficient<S: Pair> = SequentialReading<ReverseSecondPhase<S>,
    ExchangeModes<ReverseSecondPhase<S>.Answer>>
where S.Left: Pair, S.Right: Pair,
      S.Left.Left: Structure, S.Left.Right: Structure,
      S.Right.Left: Structure, S.Right.Right: Structure

enum PhaseCycleCancellation<A: Structure, B: Structure,
    C: Structure, D: Structure>: Null {
    typealias S = SignedModes<A, B, C, D>
    typealias Q1 = QuarterTurnCoefficient<S>
    typealias Q2 = SequentialReading<Q1, QuarterTurnCoefficient<Q1.Answer>>
    typealias Q3 = SequentialReading<Q2, QuarterTurnCoefficient<Q2.Answer>>
    typealias Q4 = SequentialReading<Q3, QuarterTurnCoefficient<Q3.Answer>>
    typealias Terms = MatrixEntries<S, Q1.Answer, Q2.Answer, Q3.Answer>
    typealias Even = CancelOppositeBranches<Paired<Terms.Left.Left, Terms.Right.Left>>
    typealias Odd = CancelOppositeBranches<Paired<Terms.Left.Right, Terms.Right.Right>>
    typealias Q6 = SequentialReading<Q4, Q2>
    typealias SecondEven = CancelOppositeBranches<Paired<Q4.Answer, Q6.Answer>>
    typealias Zero = SignedModes<Never, Never, Never, Never>
    typealias Left = MatrixEntries<Q4.Answer, Even.Answer, Odd.Answer, SecondEven.Answer>
    typealias Right = MatrixEntries<S, Zero, Zero, Zero>
}
#if BAD_SENSOR_PHASE_CYCLE_ERASES_FOURTH_HARMONIC
enum RejectedFourthHarmonicErasure: Null {
    typealias C = PhaseCycleCancellation<Lit1, Never, Never, Never>
    typealias Left = C.Q4.Answer
    typealias Right = C.Zero
}
#endif

// LiR12: unit couplings and zero detuning in the one-side-site array.
// SignedModes are the real and imaginary parts of one scalar here. The
// four-phase word supplies both free leads. The side amplitude is retained
// as two contributions, so every local cancellation uses actual terms.
enum ResonantSideContact<A: Structure, B: Structure,
    C: Structure, D: Structure>: Null {
    typealias Phase = PhaseCycleCancellation<A, B, C, D>
    typealias S = Phase.S
    typealias Zero = Phase.Zero
    typealias Reflected = ReverseBothPhases<S>
    typealias Node = CancelOppositeBranches<Paired<S, Reflected.Answer>>
    typealias IncomingBefore = Phase.Q3
    typealias ReflectedBefore = SequentialReading<Reflected,
        QuarterTurnCoefficient<Reflected.Answer>>
    typealias SideTerms = Paired<Phase.Q1.Answer, Phase.Q1.Answer>
    typealias JunctionTerms = Paired<
        Paired<IncomingBefore.Answer, ReflectedBefore.Answer>, SideTerms>
    typealias FirstResidual = CancelOppositeBranches<
        Paired<JunctionTerms.Left.Left, JunctionTerms.Right.Left>>
    typealias SecondResidual = CancelOppositeBranches<
        Paired<JunctionTerms.Left.Right, JunctionTerms.Right.Right>>
    // With no wave incident from the right, continuity uses this node as
    // the transmitted coefficient. Its next lead value is computed too.
    typealias TransmittedNext = QuarterTurnCoefficient<Node.Answer>
    typealias Left = AddressTriple<Node.Answer,
        Paired<FirstResidual.Answer, SecondResidual.Answer>,
        Paired<ReflectedBefore.Answer, TransmittedNext.Answer>>
    typealias Right = AddressTriple<Zero, Paired<Zero, Zero>,
        Paired<IncomingBefore.Answer, Zero>>
}

typealias UnitResonantSide = ResonantSideContact<Lit1, Never, Never, Never>
typealias ResonantInputDiffersFromSilence = SuccessorZeroBoundaryPairClass<
    Paired<UnitResonantSide.S.Left.Left,
        UnitResonantSide.Node.Answer.Left.Left>, Never>

#if BAD_SENSOR_RESONANT_REMOVES_REFLECTION
typealias RejectedResonantMissingReflection = CancelOppositeBranches<
    Paired<UnitResonantSide.S, UnitResonantSide.Zero>>
#endif

#if BAD_SENSOR_RESONANT_REVERSES_SIDE
typealias RejectedResonantSideSign = CancelOppositeBranches<
    Paired<UnitResonantSide.JunctionTerms.Left.Left,
        ReverseBothPhases<UnitResonantSide.SideTerms.Left>.Answer>>
#endif

#if BAD_SENSOR_RESONANT_TRANSMITS
enum RejectedResonantTransmission: Null {
    typealias Left = UnitResonantSide.Node.Answer
    typealias Right = UnitResonantSide.S
}
#endif

// At zero detuning, a unit-coupling side-chain equation reads
// previous + next = 0. Retain the current field when shifting the window.
// This supplies a local recurrence certificate, not a spectrum solver.
enum SideRecurrenceStep<W: Pair>: Null
where W.Left: Pair, W.Left.Left: Pair, W.Left.Right: Pair,
      W.Left.Left.Left: Structure, W.Left.Left.Right: Structure,
      W.Left.Right.Left: Structure, W.Left.Right.Right: Structure,
      W.Right: Structure {
    typealias Before = W
    typealias Next = ReverseBothPhases<W.Left>
    typealias After = Paired<W.Right, Next.Answer>
    typealias Residual = CancelOppositeBranches<Paired<Before.Left, After.Right>>
    typealias Zero = SignedModes<Never, Never, Never, Never>
    typealias Left = Paired<After.Left, Residual.Answer>
    typealias Right = Paired<Before.Right, Zero>
}

// The two-site attachment admits the free transmitted field: d1=0,
// d2=-A. Every side equation uses the source window of the preceding one.
enum TransparentSidePair<A: Structure, B: Structure,
    C: Structure, D: Structure>: Null {
    typealias Phase = PhaseCycleCancellation<A, B, C, D>
    typealias S = Phase.S
    typealias Zero = Phase.Zero
    typealias First = SideRecurrenceStep<Paired<S, Zero>>
    typealias Second = SideRecurrenceStep<First.After>
    typealias Node = First.Before.Left
    typealias Fields = Paired<First.Before.Right, First.After.Right>
    typealias LeadResidual = Phase.Odd
    typealias Left = AddressTriple<Fields.Left, Second.After.Right,
        Paired<First.Residual.Answer, LeadResidual.Answer>>
    typealias Right = AddressTriple<Zero, Zero, Paired<Zero, Zero>>
}

// Adding two sites preserves a zero terminal value; the final retained
// amplitude changes sign. The equality follows from the actual two steps.
enum ExtendSideEndByPair<A: Structure, B: Structure,
    C: Structure, D: Structure>: Null {
    typealias Last = SignedModes<A, B, C, D>
    typealias Zero = SignedModes<Never, Never, Never, Never>
    typealias First = SideRecurrenceStep<Paired<Last, Zero>>
    typealias Second = SideRecurrenceStep<First.After>
    typealias Left = Paired<Second.After.Right,
        Paired<First.Residual.Answer, Second.Residual.Answer>>
    typealias Right = Paired<Zero, Paired<Zero, Zero>>
}

typealias UnitTransparentSide = TransparentSidePair<Lit1, Never, Never, Never>
typealias AddedSidePairHasNonzeroField = ZeroSuccessorBoundaryPairClass<Paired<
    UnitTransparentSide.Fields.Right.Left.Left,
    UnitTransparentSide.Fields.Right.Left.Right>, Never>

#if BAD_SENSOR_SIDE_PAIR_STAYS_OPAQUE
enum RejectedSidePairStillOpaque: Null {
    typealias Left = UnitTransparentSide.Node
    typealias Right = UnitResonantSide.Node.Answer
}
#endif

#if BAD_SENSOR_SIDE_PAIR_RESTARTS_WINDOW
enum RejectedSidePairRestart: Null {
    typealias Left = UnitTransparentSide.Second.Before
    typealias Right = UnitTransparentSide.First.Before
}
#endif

// SiE12: the unit triangle has a hidden mode (0, A, -A) at lambda=-1.
// The two other rows each contain the contact's actual zero field and
// the opposite leaf. The image below uses the additive identity at zero.
enum TriangleHiddenMode<A: Structure, B: Structure,
    C: Structure, D: Structure>: Null {
    typealias S = SignedModes<A, B, C, D>
    typealias Zero = SignedModes<Never, Never, Never, Never>
    typealias Reversed = ReverseBothPhases<S>
    typealias Fields = Paired<Zero, Paired<S, Reversed.Answer>>
    typealias Contact = CancelOppositeBranches<Fields.Right>
    typealias Image = Paired<Contact.Answer,
        Paired<Fields.Right.Right, Fields.Right.Left>>
    typealias NegativeContact = ReverseBothPhases<Fields.Left>
    typealias NegativeFirst = ReverseBothPhases<Fields.Right.Left>
    typealias NegativeSecond = ReverseBothPhases<Fields.Right.Right>
    typealias Left = Paired<Fields.Left, Image>
    typealias Right = Paired<Zero, Paired<NegativeContact.Answer,
        Paired<NegativeFirst.Answer, NegativeSecond.Answer>>>
}

typealias UnitTriangleMode = TriangleHiddenMode<Lit1, Never, Never, Never>
typealias TriangleHasNonzeroField = SuccessorZeroBoundaryPairClass<Paired<
    UnitTriangleMode.Fields.Right.Left.Left.Left,
    UnitTriangleMode.Fields.Left.Left.Left>, Never>

#if BAD_SENSOR_TRIANGLE_MODE_IS_ZERO
enum RejectedTriangleModeIsZero: Null {
    typealias Left = UnitTriangleMode.Fields.Right.Left
    typealias Right = UnitTriangleMode.Fields.Left
}
#endif

// Removing edge 0--2 leaves only the first leaf in row 0. It cannot
// satisfy the same zero contact equation for this nonzero mode.
#if BAD_SENSOR_OPEN_PATH_KEEPS_TRIANGLE_MODE
typealias RejectedPathKeepsTriangleMode = CancelOppositeBranches<Paired<
    UnitTriangleMode.Fields.Right.Left, UnitTriangleMode.Fields.Left>>
#endif

// SG4: epsilon=1 in U_epsilon is (retained, internal) ->
// (internal, -retained). The chosen loop field is the reversed source.
// The sewn field agrees on both sides, while the retained output reverses.
// This is the finite endpoint witness, not a type proof of the real limit.
enum SewnQuarterTurn<AP: Structure, AN: Structure>: Null {
    typealias Input = SignedModes<AP, AN, AN, AP>
    typealias Exchange = ExchangeModes<Input>
    typealias Contact = SequentialReading<Exchange,
        ReverseSecondPhase<Exchange.Answer>>
    typealias Left = Paired<Contact.Answer.Right, Contact.Answer.Left>
    typealias Right = Paired<Input.Right, ReverseBothPhases<Input>.Answer.Left>
    typealias RemovedCoupling = IdentityReading<Input, TwoModeSpace, ModePhaseEncoding>
    // A resident bypass preserves the relative phase used to read the sign.
    typealias Reference = SignedModes<Input.Left.Left, Input.Left.Right, Never, Never>
    typealias ThroughLoop = SignedModes<Contact.Answer.Left.Left,
        Contact.Answer.Left.Right, Never, Never>
    typealias Compared = CancelOppositeBranches<Paired<Reference, ThroughLoop>>
    typealias ThroughRemoved = SignedModes<RemovedCoupling.Answer.Left.Left,
        RemovedCoupling.Answer.Left.Right, Never, Never>
}

#if BAD_SENSOR_SEWN_LOOP_IGNORES_COUPLING
typealias RejectedSewnLoopIgnoresCoupling = CancelOppositeBranches<Paired<
    SewnQuarterTurn<Lit1, Never>.Reference,
    SewnQuarterTurn<Lit1, Never>.ThroughRemoved>>
#endif

enum RelativePhasePreparation<A: Structure, B: Structure,
    C: Structure, D: Structure>: Null {
    typealias S = SignedModes<A, B, C, D>
    typealias Keep = IdentityReading<S, TwoModeSpace, ModePhaseEncoding>
    typealias Negate = ReverseBothPhases<S>
    typealias PlusI = QuarterTurnCoefficient<S>
    typealias MinusI = SequentialReading<ExchangeModes<S>,
        ReverseSecondPhase<ExchangeModes<S>.Answer>>
    typealias MinusIAfterPlusI = SequentialReading<PlusI,
        SequentialReading<ExchangeModes<PlusI.Answer>,
            ReverseSecondPhase<ExchangeModes<PlusI.Answer>.Answer>>>
    // The four coefficient addresses are 00, 01, 10, 11. Products of
    // the scalar phases are their actual sequential applications to S.
    typealias SameAtZero = MatrixEntries<Keep.Answer, Keep.Answer,
        Keep.Answer, Keep.Answer>
    typealias OppositeAtZero = MatrixEntries<Keep.Answer, Negate.Answer,
        Keep.Answer, Negate.Answer>
    typealias OppositeAtQuarter = MatrixEntries<Keep.Answer, MinusI.Answer,
        PlusI.Answer, MinusIAfterPlusI.Answer>
    typealias Middle = Paired<OppositeAtQuarter.Left.Right,
        OppositeAtQuarter.Right.Left>
    typealias MiddleCancels = CancelOppositeBranches<Middle>
    typealias Corners = Paired<OppositeAtQuarter.Left.Left,
        OppositeAtQuarter.Right.Right>
    typealias Zero = SignedModes<Never, Never, Never, Never>
    typealias SelectedMiddle = MatrixEntries<Zero, Middle.Left, Middle.Right, Zero>
    typealias Left = Paired<MiddleCancels.Answer, Corners>
    typealias Right = Paired<Zero, Paired<S, S>>
}

// For the unit coefficient, the overlap numerator with SameAtZero is
// 1 - i + i + 1. The middle terms cancel above. This addition uses the
// actual positive real coordinates of the two remaining coefficients.
enum QuarterPhaseOverlapNumerator: Null {
    typealias P = RelativePhasePreparation<Lit1, Never, Never, Never>
    typealias Sum = AddSuccessor<AddZero<P.Corners.Right.Left.Left>>
    typealias Left = Paired<Sum.Left, Sum.Answer>
    typealias Right = Paired<Paired<P.Corners.Left.Left.Left,
        P.Corners.Right.Left.Left>, Lit2>
}
typealias QuarterPhaseOverlapSeparatesZero = SuccessorZeroBoundaryPairClass<
    Paired<QuarterPhaseOverlapNumerator.Sum.Answer, Never>, Lit1>

// The proposed perfect comparison uses the positive Gram matrix of (1,1)
// on the middle sector. Its weight on that same factor is norm^4, while
// the input's normalization is norm^2. Both derive from the same factor.
typealias ComparisonCandidateGram = NaturalGram<
    ProductOne<Lit1>, ProductOne<Lit1>, ProductOne<Lit1>>
typealias ComparisonProbeNorm = SequentialReading<ComparisonCandidateGram,
    TraceNaturalEntries<AddSuccessor<AddZero<Lit1>>, Lit1, Lit1>>
typealias ComparisonCandidateWeight = ProductSuccessor<
    ProductOne<ComparisonProbeNorm.Answer>, AddTwoToTwo>
enum ComparisonCandidateWeightUsesSameProbe: Null {
    typealias Left = Paired<ComparisonCandidateWeight.Left,
        Paired<ComparisonProbeNorm.Left, ComparisonCandidateWeight.Answer>>
    typealias Right = Paired<Paired<ComparisonProbeNorm.Answer, ComparisonProbeNorm.Answer>,
        Paired<ComparisonCandidateGram.Left, GramFour>>
}
typealias ComparisonNormBlock = PositiveAmplitudeUnit<PositiveAmplitudeUnit<
    StartAmplitudeBlock<Vacuum, Phase0>>>
typealias ComparisonNormSum = AppendAmplitudeBlock<EmptyAmplitudeSum, ComparisonNormBlock>
typealias ComparisonWeightBlock = NegativeAmplitudeUnit<NegativeAmplitudeUnit<
    NegativeAmplitudeUnit<NegativeAmplitudeUnit<
        StartAmplitudeBlock<ComparisonNormSum.Word, PhaseHalf>>>>>
typealias ComparisonComplementSum = AppendAmplitudeBlock<ComparisonNormSum, ComparisonWeightBlock>
enum ComparisonComplementUsesActualWeights: Null {
    typealias Left = ComparisonComplementSum.Source
    typealias Right = Paired<Paired<Never, Contribution<ComparisonProbeNorm.Answer, Phase0>>,
        Contribution<ComparisonCandidateWeight.Answer, PhaseHalf>>
}
enum ComparisonComplementIsNegative: Null {
    typealias Excess = AddSuccessor<AddSuccessor<
        AddZero<ComparisonComplementSum.Word.InCount>>>
    typealias Left = Paired<Excess.Left, Excess.Answer>
    typealias Right = Paired<Paired<Lit2, ComparisonComplementSum.Word.InCount>,
        ComparisonComplementSum.Word.OutCount>
}
#if BAD_SENSOR_PHASE_CANDIDATE_COMPLEMENT_IS_ZERO
enum RejectedComparisonComplementZero: Null {
    typealias Left = ComparisonComplementSum.Word.InCount
    typealias Right = ComparisonComplementSum.Word.OutCount
}
#endif

// The same four coefficient addresses admit symmetric and antisymmetric
// encodings. Their exchange relations follow from the actual transpose.
enum ExchangeParityEncoding<A: Structure, B: Structure,
    C: Structure, D: Structure>: Null {
    typealias S = SignedModes<A, B, C, D>
    typealias Zero = SignedModes<Never, Never, Never, Never>
    typealias N = ReverseBothPhases<S>
    typealias Plus = MatrixEntries<Zero, S, S, Zero>
    typealias Minus = MatrixEntries<Zero, N.Answer, S, Zero>
    typealias SwapPlus = TransposeEntries<Plus>
    typealias SwapMinus = TransposeEntries<Minus>
    typealias NegateMinus = PairedApplication<
        PairedApplication<ReverseBothPhases<Zero>, ReverseBothPhases<N.Answer>>,
        PairedApplication<N, ReverseBothPhases<Zero>>>
    typealias Left = Paired<SwapPlus.Answer, Paired<NegateMinus.Left, SwapMinus.Answer>>
    typealias Right = Paired<Plus, Paired<Minus, NegateMinus.Answer>>
}

#if BAD_SENSOR_PHASE_ENCODING_IDENTIFIES_LABELS
enum RejectedPhaseEncodedLabels: Null {
    typealias E = ExchangeParityEncoding<Lit1, Never, Never, Never>
    typealias Left = E.Plus
    typealias Right = E.Minus
}
#endif
#if BAD_SENSOR_PHASE_QUARTER_OVERLAP_ZERO
enum RejectedQuarterPhaseOverlapZero: Null {
    typealias Left = QuarterPhaseOverlapNumerator.Sum.Answer
    typealias Right = Never
}
#endif
#if BAD_SENSOR_PHASE_SIGN_CONTROLS_QUARTER_CORNERS
enum RejectedSignOnlyQuarterCorners: Null {
    typealias P = RelativePhasePreparation<Lit1, Never, Never, Never>
    typealias Left = P.Corners
    typealias Right = Paired<P.OppositeAtZero.Left.Left, P.OppositeAtZero.Right.Right>
}
#endif
#if BAD_SENSOR_PHASE_SELECTION_IS_WHOLE
enum RejectedPhaseSelectionAsWhole: Null {
    typealias P = RelativePhasePreparation<Lit1, Never, Never, Never>
    typealias Left = P.OppositeAtQuarter
    typealias Right = P.SelectedMiddle
}
#endif

// The old reversal has a fixed single-marker input. The old exchange has
// none among the four single-marker positions, as the slot calculation in
// IiS23 proves. This generic implication derives its equal-mode condition.
enum FixedExchangeForcesEqualModes<A: Structure, B: Structure, C: Structure, D: Structure>: Null
where ExchangeModes<SignedModes<A, B, C, D>>.Answer == SignedModes<A, B, C, D> {
    typealias Left = Paired<A, B>
    typealias Right = Paired<C, D>
}
enum ReversalRetainsFirstMarker: Null {
    typealias Left = ReverseSecondPhase<SingleModeInput>.Answer
    typealias Right = SingleModeInput
}

// The first four-place block retains both old actions exactly. Its image
// after exchanging blocks instead depends on the other resident block.
enum DualScaleOldActions<A: Structure, B: Structure, C: Structure, D: Structure,
                         E: Structure, F: Structure, G: Structure, H: Structure>: Null {
    typealias M = DualModeActions<A, B, C, D, E, F, G, H>
    typealias Old = SignedModes<A, B, C, D>
    typealias Left = AddressTriple<M.X.Answer.Left, M.Z.Answer.Left, M.Exchange.Answer.Left>
    typealias Right = AddressTriple<ExchangeModes<Old>.Answer, ReverseSecondPhase<Old>.Answer,
        SignedModes<E, F, G, H>>
}
typealias DualScaleMarker = DualModeReturns<Lit1, Never, Never, Never, Never, Never, Never, Never>
typealias DualScaleBlank = DualModeActions<Never, Never, Never, Never, Never, Never, Never, Never>
typealias DualScaleOtherBlock = DualModeActions<Never, Never, Never, Never, Lit1, Never, Never, Never>
enum DualScaleEqualOldViews: Null {
    typealias Left = DualScaleBlank.Left.Left
    typealias Right = DualScaleOtherBlock.Left.Left
}
typealias DualScaleNewViewContrast = ZeroSuccessorBoundaryPairClass<
    Paired<DualScaleBlank.Exchange.Answer.Left.Left.Left,
        DualScaleOtherBlock.Exchange.Answer.Left.Left.Left>, Never>
typealias DualScaleFourthStepContrast = ZeroSuccessorBoundaryPairClass<
    Paired<DualScaleMarker.Step4.Answer.Left.Left.Left,
        DualScaleMarker.M.Left.Left.Left.Left>, Never>

#if BAD_SENSOR_SCALE_FIXED_EXCHANGE
typealias RejectedScaleFixedExchange = FixedExchangeForcesEqualModes<Lit1, Never, Never, Never>
#endif
#if BAD_SENSOR_SCALE_FOUR_STEPS_RETURN
enum RejectedScaleFourStepReturn: Null {
    typealias Left = DualScaleMarker.Step4.Answer
    typealias Right = DualScaleMarker.M.Left
}
#endif
#if BAD_SENSOR_SCALE_OMITS_OTHER_BLOCK
enum RejectedScaleOtherBlock: Null {
    typealias Left = DualScaleBlank.Exchange.Answer.Left
    typealias Right = DualScaleOtherBlock.Exchange.Answer.Left
}
#endif
#if BAD_SENSOR_SCALE_RESTARTS_ROOT
typealias RejectedScaleRootSource = SequentialReading<DualScaleMarker.Step1, DualScaleMarker.Step1>
#endif
typealias ExchangeAfterFlip = SequentialReading<
    ReverseSecondPhase<SingleModeInput>,
    ExchangeModes<ReverseSecondPhase<SingleModeInput>.Answer>
>
typealias FlipAfterExchange = SequentialReading<
    ExchangeModes<SingleModeInput>,
    ReverseSecondPhase<ExchangeModes<SingleModeInput>.Answer>
>

#if BAD_SENSOR_MODES_COMMUTE
 enum RejectedModesCommute: Null {
     typealias Left = ExchangeAfterFlip.Answer
     typealias Right = FlipAfterExchange.Answer
 }
#endif
#if BAD_SENSOR_MODE_SOURCE
 typealias RejectedModeSource = SequentialReading<
     ExchangeModes<SingleModeInput>, ReverseSecondPhase<SingleModeInput>
 >
#endif
#if BAD_SENSOR_COMMON_IS_LOCAL_PHASE
 enum RejectedCommonAsLocalPhase: Null {
     typealias Left = ReverseBothPhases<SingleModeInput>.Answer
     typealias Right = ReverseSecondPhase<SingleModeInput>.Answer
 }
#endif

// The control is represented by two coherent amplitude branches, not by a
// classical branch choice. Existing PairedApplication retains the reference.
enum ControlledPhaseRecovery<AP: Structure, AN: Structure, BP: Structure, BN: Structure>: Null {
    typealias S = SignedModes<AP, AN, BP, BN>
    typealias KeepReference = IdentityReading<S, TwoModeSpace, ModePhaseEncoding>
    typealias U = SequentialReading<ReverseSecondPhase<S>, ExchangeModes<ReverseSecondPhase<S>.Answer>>
    typealias V = SequentialReading<ExchangeModes<S>, ReverseSecondPhase<ExchangeModes<S>.Answer>>
    typealias ControlledU = PairedApplication<KeepReference, U>
    typealias ControlledV = PairedApplication<KeepReference, V>
    // U inverse is ZX, applied to each actual branch result separately.
    typealias UndoU = SequentialReading<ExchangeModes<U.Answer>, ReverseSecondPhase<ExchangeModes<U.Answer>.Answer>>
    typealias UndoV = SequentialReading<ExchangeModes<V.Answer>, ReverseSecondPhase<ExchangeModes<V.Answer>.Answer>>
    typealias RecoveredU = SequentialReading<ControlledU, PairedApplication<KeepReference, UndoU>>
    typealias RecoveredV = SequentialReading<ControlledV, PairedApplication<KeepReference, UndoV>>
    typealias Left = Paired<RecoveredU.Answer, RecoveredV.Answer>
    typealias Right = Paired<Paired<S, S>, Paired<S, ReverseBothPhases<S>.Answer>>
    // This final zero follows from the actual composed output. No condition
    // on the four terms or separate claim of opposite branches is supplied.
    typealias DarkPort = SequentialReading<RecoveredV, CancelOppositeBranches<RecoveredV.Answer>>
}

enum ControlledDarkPortIsZero<AP: Structure, AN: Structure, BP: Structure, BN: Structure>: Null {
    typealias Left = ControlledPhaseRecovery<AP, AN, BP, BN>.DarkPort.Answer
    typealias Right = SignedModes<Never, Never, Never, Never>
}

#if BAD_SENSOR_CONTROL_ERASES_PHASE
 enum RejectedControlPhaseErasure: Null {
     typealias C = ControlledPhaseRecovery<Lit1, Never, Never, Never>
     typealias Left = C.RecoveredU.Answer
     typealias Right = C.RecoveredV.Answer
 }
#endif
#if BAD_SENSOR_CONTROL_ERASES_REFERENCE
 enum RejectedControlReferenceErasure: Null {
     typealias C = ControlledPhaseRecovery<Lit1, Never, Never, Never>
     typealias Left = C.RecoveredV.Answer
     typealias Right = Paired<
         ReverseBothPhases<SingleModeInput>.Answer,
         ReverseBothPhases<SingleModeInput>.Answer
     >
 }
#endif
#if BAD_SENSOR_EQUAL_BRANCHES_CANCEL
 typealias RejectedEqualBranchCancellation = CancelOppositeBranches<Paired<SingleModeInput, SingleModeInput>>
#endif
