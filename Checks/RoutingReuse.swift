import VerificationIsIdentification
import Examples

typealias ReuseExchangeRouting = ExchangeFirstImage<IdentityRouting>.Answer

enum ReuseExchangeAllData<A: Structure, C: Structure, B: Structure, D: Structure>: Null {
    typealias X = BoundaryWorking<A, C, B, D>
    typealias F = RoutingApplicationFromProbes<ReuseExchangeRouting, X, Route01<X>, Route00<X>, Route10<X>, Route11<X>>
    typealias Acquired = AnswerOnRefinement<F, RoutingMemoryBesideInput<ReuseExchangeRouting, X>>
    typealias Left = Acquired.Answer
    typealias Right = BoundaryWorking<C, A, B, D>
}

enum ReuseRepeatedSelectionAllData<A: Structure, C: Structure, B: Structure, D: Structure>: Null {
    typealias X = BoundaryWorking<A, C, B, D>
    typealias I = BoundaryWorking<RoutingAddress00, RoutingAddress00, RoutingAddress00, RoutingAddress00>
    typealias F = RoutingApplicationFromProbes<I, X, Route00<X>, Route00<X>, Route00<X>, Route00<X>>
    typealias Left = AnswerOnRefinement<F, RoutingMemoryBesideInput<I, X>>.Answer
    typealias Right = BoundaryWorking<A, A, A, A>
}

enum ReuseDecoderInputIsMemoryAndData<A: Structure, C: Structure, B: Structure, D: Structure>: Null {
    typealias X = BoundaryWorking<A, C, B, D>
    typealias F = RoutingApplicationFromProbes<ReuseExchangeRouting, X, Route01<X>, Route00<X>, Route10<X>, Route11<X>>
    typealias Left = AnswerOnRefinement<F, RoutingMemoryBesideInput<ReuseExchangeRouting, X>>.Right.Left
    typealias Right = Paired<FactOf<RoutingProbeImages<ReuseExchangeRouting>>, X>
}

enum ReuseOneLawFactForDifferentInputs<X: Structure, Y: Structure>: Null {
    typealias Left = RoutingMemoryBesideInput<IdentityRouting, X>.Right.Left.Left
    typealias Right = RoutingMemoryBesideInput<IdentityRouting, Y>.Right.Left.Left
}

enum ReuseNominalIdentity: Pair {
    typealias Left = IdentityRouting.Left
    typealias Right = IdentityRouting.Right
}
enum ReuseActualSourceAbsentFromDecoder<A: Structure, C: Structure, B: Structure, D: Structure>: Null {
    typealias X = BoundaryWorking<A, C, B, D>
    typealias F = RoutingApplicationFromProbes<IdentityRouting, X, Route00<X>, Route01<X>, Route10<X>, Route11<X>>
    typealias G = RoutingApplicationFromProbes<ReuseNominalIdentity, X, Route00<X>, Route01<X>, Route10<X>, Route11<X>>
    typealias Left = AnswerOnRefinement<F, RoutingMemoryBesideInput<IdentityRouting, X>>.Right
    typealias Right = AnswerOnRefinement<G, RoutingMemoryBesideInput<ReuseNominalIdentity, X>>.Right
}

// Same known law, different new inputs, and positively different outputs.
typealias ReuseZeroData = BoundaryWorking<Never, Never, Never, Never>
typealias ReuseOneData = BoundaryWorking<Lit1, Never, Never, Never>
typealias ReuseZeroFactor = RoutingApplicationFromProbes<IdentityRouting, ReuseZeroData, Route00<ReuseZeroData>, Route01<ReuseZeroData>, Route10<ReuseZeroData>, Route11<ReuseZeroData>>
typealias ReuseOneFactor = RoutingApplicationFromProbes<IdentityRouting, ReuseOneData, Route00<ReuseOneData>, Route01<ReuseOneData>, Route10<ReuseOneData>, Route11<ReuseOneData>>
typealias ReuseZeroOutput = AnswerOnRefinement<ReuseZeroFactor, RoutingMemoryBesideInput<IdentityRouting, ReuseZeroData>>
typealias ReuseOneOutput = AnswerOnRefinement<ReuseOneFactor, RoutingMemoryBesideInput<IdentityRouting, ReuseOneData>>
typealias ReuseInputMatters = ZeroSuccessorBoundary<FirstEvidenceImage<ReuseZeroOutput.Answer.Left, BeamSpace, SaturationEncoding, RoutedValueQuestion>, FirstEvidenceImage<ReuseOneOutput.Answer.Left, BeamSpace, SaturationEncoding, RoutedValueQuestion>, Never>

// One constant input makes different laws agree, without identifying them.
typealias ReuseConstantIdentity = RoutingApplication<IdentityRouting, ReuseZeroData, Route00<ReuseZeroData>, Route01<ReuseZeroData>, Route10<ReuseZeroData>, Route11<ReuseZeroData>>
typealias ReuseConstantExchange = RoutingApplication<ReuseExchangeRouting, ReuseZeroData, Route01<ReuseZeroData>, Route00<ReuseZeroData>, Route10<ReuseZeroData>, Route11<ReuseZeroData>>
typealias ReuseConstantAgreement = JoinedVerdict<ReuseConstantIdentity, ReuseConstantExchange>

#if REUSE_NO_NEW_INPUT
typealias RejectedReuseNoInput = AnswerOnRefinement<ReuseOneFactor, AcquireAnswer<RoutingProbeImages<IdentityRouting>>>
#endif
#if REUSE_OTHER_NEW_INPUT
typealias RejectedReuseOtherInput = AnswerOnRefinement<ReuseOneFactor, RoutingMemoryBesideInput<IdentityRouting, ReuseZeroData>>
#endif
#if REUSE_OTHER_ACTUAL_ROUTING
typealias RejectedReuseRouting = AnswerOnRefinement<ReuseOneFactor, RoutingMemoryBesideInput<ReuseExchangeRouting, ReuseOneData>>
#endif
#if REUSE_EQUAL_FACT_OTHER_SOURCE
typealias RejectedReuseSource = AnswerOnRefinement<ReuseOneFactor, RoutingMemoryBesideInput<ReuseNominalIdentity, ReuseOneData>>
#endif
#if REUSE_WRONG_ADDRESS_CLAUSE
typealias RejectedReuseClause = RoutingApplication<IdentityRouting, ReuseOneData, Route01<ReuseOneData>, Route01<ReuseOneData>, Route10<ReuseOneData>, Route11<ReuseOneData>>
#endif
#if REUSE_HIDDEN_INPUT_EQUALITY
enum RejectedReuseInputEquality: Null {
    typealias Left = ReuseZeroOutput.Answer
    typealias Right = ReuseOneOutput.Answer
}
#endif
#if REUSE_SWAPPED_MEMORY_LAYOUT
enum RejectedReuseLayout: Null {
    typealias Left = ReuseOneOutput.Right.Left
    typealias Right = Paired<ReuseOneData, FactOf<RoutingProbeImages<IdentityRouting>>>
}
#endif
#if REUSE_OUTPUT_IDENTIFIES_LAW
enum RejectedReuseOutputLaw: Null {
    typealias Left = IdentityRouting
    typealias Right = ReuseExchangeRouting
}
#endif

// Reuse the learned K routing to supply the actual input of the existing
// common-answer table. No table answer is inserted as an extra premise.
typealias ReuseCrossRoute = CrossBoundaryImage<IdentityRouting>.Answer
typealias ReuseCrossData = BoundaryWorking<Never, Never, Lit1, Lit1>
typealias ReuseCrossFactor = RoutingApplicationFromProbes<ReuseCrossRoute, ReuseCrossData, Route11<ReuseCrossData>, Route01<ReuseCrossData>, Route10<ReuseCrossData>, Route00<ReuseCrossData>>
typealias ReuseCrossAcquired = AnswerOnRefinement<ReuseCrossFactor, RoutingMemoryBesideInput<ReuseCrossRoute, ReuseCrossData>>
typealias ReuseCrossTable = AnswerOnRefinement<QuestionOnObservation<ReuseCrossFactor.Left, Boundary1010>, ReuseCrossAcquired>
enum ReuseCommonTableFollowsAcquiredLaw: Null {
    typealias Left = ReuseCrossTable.Answer
    typealias Right = Boundary1010.Answer
}

#if REUSE_OLD_OUTPUT_TABLE
typealias RejectedReuseOldTable = AnswerOnRefinement<QuestionOnObservation<ReuseCrossFactor.Left, Boundary0011>, ReuseCrossAcquired>
#endif

// The generic transport relation does not certify membership in the four
// coordinate-selection constructors. A reading can borrow the address and
// question while supplying another answer. This is outside VC75's grammar.
enum ReuseForged00<X: Pair>: PredicateReading {
    typealias Left = Paired<RoutingAddress00, X>
    typealias Right = Lit1
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Predicate = RoutedValueQuestion
    typealias Answer = Right
}
typealias ReuseForgedFactor = RoutingApplicationFromProbes<IdentityRouting, ReuseZeroData, ReuseForged00<ReuseZeroData>, Route01<ReuseZeroData>, Route10<ReuseZeroData>, Route11<ReuseZeroData>>
typealias ReuseForgedAcquired = AnswerOnRefinement<ReuseForgedFactor, RoutingMemoryBesideInput<IdentityRouting, ReuseZeroData>>

enum ReuseForgedSameSource: Null {
    typealias Left = ReuseForgedFactor.Left.Left
    typealias Right = ReuseZeroFactor.Left.Left
}
enum ReuseForgedSameQuestion: ComparedReadings {
    typealias Left = ReuseZeroFactor.Left
    typealias Right = ReuseForgedFactor.Left
}
enum ReuseForgedSameDecoderInput: Null {
    typealias Left = ReuseForgedAcquired.Right.Left
    typealias Right = ReuseZeroOutput.Right.Left
}
enum ReuseTransportRetainsSuppliedClause: Null {
    typealias Left = ReuseForgedAcquired.Answer
    typealias Right = BoundaryWorking<Lit1, Never, Never, Never>
}
typealias ReuseGrammarPremiseMatters = ZeroSuccessorBoundary<FirstEvidenceImage<ReuseZeroOutput.Answer.Left, BeamSpace, SaturationEncoding, RoutedValueQuestion>, FirstEvidenceImage<ReuseForgedAcquired.Answer.Left, BeamSpace, SaturationEncoding, RoutedValueQuestion>, Never>

// Finish the calibration audit at the four primitive selections. These
// images come from actual applications to P/Q, not from assumed bit planes.
typealias ReuseIdentityCalibration = CalibratedRoutingBasis<SelectionCalibration00, SelectionCalibration01, SelectionCalibration10, SelectionCalibration11>
typealias ReuseRepeatedCalibration = CalibratedRoutingBasis<SelectionCalibration00, SelectionCalibration00, SelectionCalibration00, SelectionCalibration00>
enum ReuseCalibratedImagesAreTheOldImages: Null {
    typealias Left = ReuseIdentityCalibration.Images
    typealias Right = RoutingProbeImages<IdentityRouting>.Answer
}
enum ReuseCalibratedRepeatedAddress: Null {
    typealias Left = ReuseRepeatedCalibration.Right
    typealias Right = RepeatedFirstRouting
}

// Calibration on these two probes still does not establish the family.
// A constant-zero reading matches address 00 on both probes, but differs
// from coordinate selection when the newly supplied first value is one.
enum ReuseConstantZero00<X: Pair>: PredicateReading {
    typealias Left = Paired<RoutingAddress00, X>
    typealias Right = Never
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Predicate = RoutedValueQuestion
    typealias Answer = Right
}
enum ReuseConstantZeroPassesCalibration: Null {
    typealias Left = RoutingAddress00
    typealias Right = Paired<ReuseConstantZero00<RoutingProbeP>.Answer, ReuseConstantZero00<RoutingProbeQ>.Answer>
}
typealias ReuseCalibrationDoesNotProveFamily = ZeroSuccessorBoundary<ReuseConstantZero00<ReuseOneData>, Route00<ReuseOneData>, Never>

#if REUSE_CALIBRATION_WRONG_READING
enum RejectedReuseCalibrationReading: Null {
    typealias Left = RoutingAddress00
    typealias Right = Paired<ReuseForged00<RoutingProbeP>.Answer, ReuseForged00<RoutingProbeQ>.Answer>
}
#endif
#if REUSE_CALIBRATION_PROVES_ALL_INPUTS
enum RejectedReuseCalibrationAllInputs: Null {
    typealias Left = ReuseConstantZero00<ReuseOneData>.Answer
    typealias Right = Route00<ReuseOneData>.Answer
}
#endif

#if REUSE_SAME_INPUT_IS_SAME_DECODER
enum RejectedReuseDifferentDecoders: SharedDecoder {
    typealias Left = ReuseZeroOutput
    typealias Right = ReuseForgedAcquired
}
#endif
