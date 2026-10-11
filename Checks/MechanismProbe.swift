import VerificationIsIdentification
import Examples

typealias ProbeInput<A: IntegerValued, C: IntegerValued, B: IntegerValued, D: IntegerValued> = Paired<BoundaryBeam<A, C, Never>, BoundaryBeam<B, D, Never>>
typealias ProbeSeparates = ProbeInput<Never, Never, Never, Lit1>
typealias ProbeCoincides = ProbeInput<Never, Never, Never, Never>
typealias ProbeE = ExchangeBoundaryFirst<ProbeSeparates>
typealias ProbeK = CrossBoundaryReading<ProbeSeparates>

enum ProbeBothMechanismsHaveOneQuestion<P: Pair>: Null
where P.Left: BeamShape, P.Right: BeamShape {
    typealias Left = MechanismOutput<ExchangeBoundaryFirst<P>>.Predicate
    typealias Right = MechanismOutput<CrossBoundaryReading<P>>.Predicate
}
enum ProbeNoLawInObservationChannel<P: Pair>: Null
where P.Left: BeamShape, P.Right: BeamShape {
    typealias Left = ChannelOf<MechanismOutput<ExchangeBoundaryFirst<P>>>
    typealias Right = ChannelOf<MechanismOutput<CrossBoundaryReading<P>>>
}
enum ProbeBadInputHasOneRecordedFact: Null {
    typealias Left = FactOf<MechanismOutput<ExchangeBoundaryFirst<ProbeCoincides>>>
    typealias Right = FactOf<MechanismOutput<CrossBoundaryReading<ProbeCoincides>>>
}
typealias ProbePositiveSeparator = ZeroSuccessorBoundary<MechanismOutput<ProbeE>, MechanismOutput<ProbeK>, Never>

enum ProbePreparedFamilySeparates<A: IntegerValued, B: IntegerValued, H: IntegerValued, J: IntegerValued>: Null {
    typealias P = Paired<BoundaryBeam<A, Never, H>, BoundaryBeam<B, Lit1, J>>
    typealias Left = Paired<MechanismOutput<ExchangeBoundaryFirst<P>>.Answer, MechanismOutput<CrossBoundaryReading<P>>.Answer>
    typealias Right = Paired<Never, Lit1>
}
enum ProbeAcquiredLawFollows<P: Pair>: Null
where P.Left: BeamShape, P.Right: BeamShape,
      P.Left.BetaLevel == Never, P.Right.BetaLevel == Lit1 {
    typealias Left = Paired<AcquiredExchangeLaw<P>.Answer, AcquiredCrossLaw<P>.Answer>
    typealias Right = Paired<FirstFieldsOperation, CrossBoundaryOperation>
}
enum ProbeDecoderTakesOnlyOutcomeFacts<P: Pair>: Null
where P.Left: BeamShape, P.Right: BeamShape,
      P.Left.BetaLevel == Never, P.Right.BetaLevel == Lit1 {
    typealias Left = Paired<AcquiredExchangeLaw<P>.Right.Left, AcquiredCrossLaw<P>.Right.Left>
    typealias Right = Paired<AnswerFact<BeamSpace, SaturationEncoding, MechanismOutputQuestion, Never>, AnswerFact<BeamSpace, SaturationEncoding, MechanismOutputQuestion, Lit1>>
}
enum ProbeSourceAbsentFromDecoder<A: IntegerValued, B: IntegerValued, H: IntegerValued, J: IntegerValued>: Null {
    typealias P = Paired<BoundaryBeam<A, Never, H>, BoundaryBeam<B, Lit1, J>>
    typealias Left = AcquiredExchangeLaw<P>.Right
    typealias Right = AcquiredExchangeLaw<ProbeSeparates>.Right
}
enum ProbeTraceIsActualMemory<P: Pair>: Null
where P.Left: BeamShape, P.Right: BeamShape,
      P.Left.BetaLevel == Never, P.Right.BetaLevel == Lit1 {
    typealias Left = ExchangeLawFromTrace<P>.Right.Left
    typealias Right = PreparedMechanismProbe<ExchangeBoundaryFirst<P>>.Trace.Right
}

// The same zero record has incompatible law interpretations outside the
// prepared scope. A payload can be decoded, but that is not a valid factor.
enum ProbeZeroPayloadDoesNotCertifyScope: Null {
    typealias Left = FactOf<MechanismOutput<ProbeE>>
    typealias Right = FactOf<MechanismOutput<CrossBoundaryReading<ProbeCoincides>>>
}

// A third total permutation, S, gives E's response on this probe. It differs
// from E on another input. Thus one response cannot establish family closure.
typealias ProbeS = SwapBoundaryReading<ProbeSeparates>
enum ProbeExtendedFamilyHasSameOutcome: Null {
    typealias Left = FactOf<MechanismOutput<ProbeE>>
    typealias Right = FactOf<MechanismOutput<ProbeS>>
}
typealias ProbeOutsideSeparatorInput = ProbeInput<Never, Never, Lit1, Never>
typealias ProbeOutsideFamilyPositive = ZeroSuccessorBoundary<MechanismOutput<ExchangeBoundaryFirst<ProbeOutsideSeparatorInput>>, MechanismOutput<SwapBoundaryReading<ProbeOutsideSeparatorInput>>, Never>

#if PROBE_BAD_PREPARATION
typealias RejectedProbePreparation = ExchangeLawFromProbe<ProbeCoincides>
#endif
#if PROBE_OTHER_APPLICATION
typealias RejectedProbeApplication = AnswerOnRefinement<ExchangeLawFromProbe<ProbeSeparates>, AcquireAnswer<MechanismOutput<ProbeS>>>
#endif
#if PROBE_OTHER_PREPARED_SOURCE
typealias RejectedProbeSource = AnswerOnRefinement<ExchangeLawFromProbe<ProbeSeparates>, AcquireAnswer<MechanismOutput<ExchangeBoundaryFirst<ProbeInput<Lit1, Never, Never, Lit1>>>>>
#endif
#if PROBE_CONSTANT_LAW_FROM_BAD_RECORD
enum RejectedProbeBadRecord: ReadingFactors {
    typealias Left = MechanismLaw<CrossBoundaryReading<ProbeCoincides>>
    typealias Observation = ObserveRecordedFact<MechanismOutput<CrossBoundaryReading<ProbeCoincides>>>
    typealias Right = AcquiredExchangeLaw<ProbeSeparates>.Right
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Predicate = MechanismLawQuestion
    typealias Answer = Left.Answer
}
#endif
#if PROBE_RESPONSE_IDENTIFIES_EXTENDED_FAMILY
enum RejectedProbeFamily: ReadingFactors {
    typealias Left = MechanismLaw<ProbeS>
    typealias Observation = ObserveRecordedFact<MechanismOutput<ProbeS>>
    typealias Right = AcquiredExchangeLaw<ProbeSeparates>.Right
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Predicate = MechanismLawQuestion
    typealias Answer = Left.Answer
}
#endif
#if PROBE_RESPONSE_IS_LAW_TAG
enum RejectedProbeLawTag: Null {
    typealias Left = MechanismOutput<ProbeE>.Predicate
    typealias Right = ProbeE.Predicate
}
#endif
#if PROBE_EQUAL_FACT_IDENTIFIES_APPLICATION
enum RejectedProbeIdentity: Null {
    typealias Left = ProbeE
    typealias Right = ProbeS
}
#endif
