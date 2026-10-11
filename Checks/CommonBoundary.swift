import VerificationIsIdentification
import Examples

enum BoundaryLeft<V: IntegerValued>: Close, BeamShape {
    typealias AlphaLevel = V
    typealias BetaLevel = Never
    typealias PaschenLevel = Never
}
enum BoundaryRight<V: IntegerValued>: Close, BeamShape {
    typealias AlphaLevel = V
    typealias BetaLevel = Never
    typealias PaschenLevel = Lit1
}

typealias BoundaryL0 = SpectrumAlphaSource<BoundaryLeft<Never>>
typealias BoundaryL1 = SpectrumAlphaSource<BoundaryLeft<Lit1>>
typealias BoundaryR0 = SpectrumAlphaSource<BoundaryRight<Never>>
typealias BoundaryR1 = SpectrumAlphaSource<BoundaryRight<Lit1>>
typealias BoundaryV00 = JoinedVerdict<BoundaryL0, BoundaryR0>
typealias BoundaryV11 = JoinedVerdict<BoundaryL1, BoundaryR1>
typealias BoundaryRecord00 = CommonFactConstruction<Never, BoundaryV00>
typealias BoundaryRecord11 = CommonFactConstruction<Never, BoundaryV11>
typealias BoundaryRecord01 = ZeroSuccessorBoundaryRecord<Never, BoundaryL0, BoundaryR1, Never>
typealias BoundaryRecord10 = SuccessorZeroBoundaryRecord<Never, BoundaryL1, BoundaryR0, Never>

// Necessity is inherited from one actual shared decoder, not assumed answer
// equality. Conversely a verdict constructs that decoder via canonical facts.
enum CommonBoundaryNecessity<S: SharedDecoder>: Null {
    typealias Certificate = AnswersThroughSharedDecoder<S>
    typealias Left = Certificate.Left.Answer
    typealias Right = Certificate.Right.Answer
}

enum CommonBoundarySufficiency<C: VerdictIsInvariant>: Null
where C.Left.Left: Structure, C.Right.Left: Structure {
    typealias Shared = SharedFactFromVerdict<C>
    typealias Left = Shared.Left.Right
    typealias Right = Shared.Right.Right
}

enum BoundaryFromResidentEquality<L: BeamShape & Structure, R: BeamShape & Structure>: Null
where L.AlphaLevel == R.AlphaLevel {
    typealias C = JoinedVerdict<SpectrumAlphaSource<L>, SpectrumAlphaSource<R>>
    typealias Common = SharedFactFromVerdict<C>
    typealias Left = Common.Left.Right.Answer
    typealias Right = R.AlphaLevel
}

// Both source-specific factorizations take exactly the common output fact.
enum BoundaryFirstDecoderAtRecord<H: Structure, C: VerdictIsInvariant>: Null
where C.Left.Left: Structure, C.Right.Left: Structure {
    typealias Record = CommonFactConstruction<H, C>
    typealias Left = SharedFactFromVerdict<C>.Left.Right.Left
    typealias Right = Record.Right.Right
}
enum BoundarySecondDecoderAtRecord<H: Structure, C: VerdictIsInvariant>: Null
where C.Left.Left: Structure, C.Right.Left: Structure {
    typealias Record = CommonFactConstruction<H, C>
    typealias Left = SharedFactFromVerdict<C>.Right.Right.Left
    typealias Right = Record.Right.Right
}

enum BoundaryBothSourcesRetained<H: Structure, C: VerdictIsInvariant>: Null
where C.Left.Left: Structure, C.Right.Left: Structure {
    typealias Left = RecordedOperands<CommonFactConstruction<H, C>>
    typealias Right = Paired<C.Left.Left, C.Right.Left>
}

enum BoundarySharedDecoderBuildsActualRecord<H: Structure, S: SharedDecoder>: Null
where S.Left.Left.Left: Structure, S.Right.Left.Left: Structure {
    typealias Left = CommonFactFromSharedDecoder<H, S>.Right.Right
    typealias Right = FactOf<S.Left.Left>
}

// An old source-bound factorization already supplies a valid common decoder.
// It can therefore feed the new construction without a new answer premise.
typealias BoundaryOldShared = SharedVisibleImage<RedBeam, RedBeamWithIR>
typealias BoundaryFromOldProof = CommonFactFromSharedDecoder<Never, BoundaryOldShared>
typealias BoundaryCanonicalShared = SharedFactFromVerdict<AnswersThroughSharedDecoder<BoundaryOldShared>>
typealias BoundaryDifferentRealizationsAgree = CommonAnswerAcrossRealizations<BoundaryOldShared, BoundaryCanonicalShared>

enum BoundaryRealizationAnswerFollows<S: SharedDecoder, T: SharedDecoder>: Null
where S.Left.Left == T.Left.Left {
    typealias C = CommonAnswerAcrossRealizations<S, T>
    typealias Left = C.Left.Answer
    typealias Right = C.Right.Answer
}

enum BoundaryCanonicalizationPreservesAnswer: Null {
    typealias Left = ReadRecordedAnswer<BoundaryFromOldProof.Right.Right>.Answer
    typealias Right = BoundaryOldShared.Left.Right.Answer
}

// A finer shared image supplies the same alpha decoder by projection. The
// weaker common-fact construction follows without another answer premise.
enum BoundaryFromFullImage<L: BeamShape, R: BeamShape>: SharedDecoder
where FullSpectrumImage<L> == FullSpectrumImage<R> {
    typealias Left = SpectrumAlphaFactors<L>
    typealias Right = SpectrumAlphaFactors<R>
}
typealias BoundaryRefinementInhabited = CommonFactFromSharedDecoder<Never, BoundaryFromFullImage<BoundaryLeft<Never>, BoundaryLeft<Never>>>

enum BoundaryCoarseAgreementLeavesHiddenDifference: Null {
    typealias Left = Paired<BoundaryL0.Left.PaschenLevel, BoundaryR0.Left.PaschenLevel>
    typealias Right = Paired<ZeroSuccessorDistinction<Never>.Left, ZeroSuccessorDistinction<Never>.Right>
}

enum BoundaryObstructionBoundToReadings: Null {
    typealias O = ZeroSuccessorBoundary<BoundaryL0, BoundaryR1, Never>
    typealias Left = Paired<O.Left, O.Right>
    typealias Right = Paired<BoundaryL0.Answer, BoundaryR1.Answer>
}

enum BoundaryReverseObstructionBoundToReadings: Null {
    typealias O = SuccessorZeroBoundary<BoundaryL1, BoundaryR0, Never>
    typealias Left = Paired<O.Left, O.Right>
    typealias Right = Paired<BoundaryL1.Answer, BoundaryR0.Answer>
}

enum BoundaryRejectionRetainsActualSources: Null {
    typealias Left = RecordedOperands<BoundaryRecord01>
    typealias Right = Paired<BoundaryL0.Left, BoundaryR1.Left>
}

// A successful image is the common fact. Both failed directions project to
// the same context-tagged refusal image. The full records keep orientation.
typealias BoundaryImage00 = BoundaryRecord00.Right.Right
typealias BoundaryImage11 = BoundaryRecord11.Right.Right
typealias BoundaryImage01 = ZeroSuccessorBoundaryImage<BoundaryL0, BoundaryR1, Never>
typealias BoundaryImage10 = SuccessorZeroBoundaryImage<BoundaryL1, BoundaryR0, Never>

enum BoundaryFailedDirectionsShareImage: Null {
    typealias Left = BoundaryImage01
    typealias Right = BoundaryImage10
}

enum BoundarySuccessfulImagesDistinguishAnswers: Null {
    typealias Left = Paired<ReadRecordedAnswer<BoundaryImage00>.Answer, ReadRecordedAnswer<BoundaryImage11>.Answer>
    typealias Right = Paired<ZeroSuccessorDistinction<Never>.Left, ZeroSuccessorDistinction<Never>.Right>
}

// Reading only the first answer conflates an available and a blocked input.
enum BoundaryFirstAnswerConflatesDomain: Null {
    typealias Left = BoundaryL0.Answer
    typealias Right = BoundaryRecord01.Right.Right.Right.Left
}

// A joint memory can retain unequal answers at different addresses. Such
// coexistence is not the common decoder required by the construction.
typealias BoundarySeparateFacts = Paired<FactOf<BoundaryL0>, FactOf<BoundaryR1>>
enum BoundarySeparateAddressesKeepDifference: Null {
    typealias Left = Paired<ReadRecordedAnswer<BoundarySeparateFacts.Left>.Answer, ReadRecordedAnswer<BoundarySeparateFacts.Right>.Answer>
    typealias Right = Paired<Never, Lit1>
}

typealias BoundaryAt<S, P: Pair> = P where P.Left == S

#if BOUNDARY_UNEQUAL_ANSWERS_SHARE_DECODER
enum RejectedBoundarySharedDecoder: SharedDecoder {
    typealias Left = AcquireAnswer<BoundaryL0>
    typealias Right = AcquireAnswer<BoundaryR1>
}
#endif

#if BOUNDARY_UNEQUAL_ANSWERS_FORM_VERDICT
typealias RejectedBoundaryVerdict = JoinedVerdict<BoundaryL0, BoundaryR1>
#endif

#if BOUNDARY_OTHER_QUESTION
typealias RejectedBoundaryQuestion = JoinedVerdict<BoundaryL0, SpectrumBetaSource<BoundaryRight<Never>>>
#endif

#if BOUNDARY_OTHER_ENCODING
enum BoundaryOtherCode: PredicateReading {
    typealias Left = BoundaryR0.Left
    typealias Right = BoundaryR0.Answer
    typealias Sigma = BoundaryR0.Sigma
    typealias Encoding = EyeEncoding
    typealias Predicate = BoundaryR0.Predicate
    typealias Answer = Right
}
typealias RejectedBoundaryEncoding = JoinedVerdict<BoundaryL0, BoundaryOtherCode>
#endif

#if BOUNDARY_SUBSTITUTES_EQUAL_VALUED_SOURCE
typealias RejectedBoundaryActualSource = BoundaryAt<Paired<Never, Paired<BoundaryL0.Left, BoundaryL0.Left>>, BoundaryRecord00>
#endif

#if BOUNDARY_OBSTRUCTION_WITH_EQUAL_ANSWERS
typealias RejectedBoundaryFalseObstruction = ZeroSuccessorBoundary<BoundaryL0, BoundaryR0, Never>
#endif

#if BOUNDARY_OBSTRUCTION_OTHER_SUCCESSOR
typealias RejectedBoundaryUnboundObstruction = ZeroSuccessorBoundary<BoundaryL0, BoundaryR1, Lit1>
#endif

#if BOUNDARY_REVERSES_OBSTRUCTION
enum RejectedBoundaryObstructionOrder: Null {
    typealias Left = BoundaryRecord01.Right.Right.Right.Left
    typealias Right = BoundaryR1.Answer
}
#endif

#if BOUNDARY_REFUSAL_IS_COMMON_FACT
typealias RejectedBoundaryRefusalFact = ReadRecordedAnswer<BoundaryRecord01.Right.Right>
#endif

#if BOUNDARY_FIRST_ANSWER_DETERMINES_DOMAIN
enum RejectedBoundaryFirstDomain: Null {
    typealias Left = BoundaryImage00
    typealias Right = BoundaryImage01
}
#endif

#if BOUNDARY_SAME_REFUSAL_IDENTIFIES_ORIENTATION
enum RejectedBoundaryOrientation: Null {
    typealias Left = BoundaryRecord01.Right.Right.Right
    typealias Right = BoundaryRecord10.Right.Right.Right
}
#endif

#if BOUNDARY_SAME_ANSWER_IDENTIFIES_SOURCES
enum RejectedBoundarySourceIdentity: Null {
    typealias Left = BoundaryL0.Left
    typealias Right = BoundaryR0.Left
}
#endif

#if BOUNDARY_CANONICAL_FACT_IS_ORIGINAL_IMAGE
enum RejectedBoundaryOriginalImage: Null {
    typealias Left = BoundaryFromOldProof.Right.Right
    typealias Right = BoundaryOldShared.Left.Observation.Answer
}
#endif

#if BOUNDARY_COARSE_AGREEMENT_FORCES_FINE
typealias RejectedBoundaryRefinement = JoinedVerdict<FullSpectrumReading<BoundaryL0.Left>, FullSpectrumReading<BoundaryR0.Left>>
#endif

#if BOUNDARY_SUBSTITUTES_EQUAL_VALUED_ANCHOR
typealias BoundaryReversed00 = JoinedVerdict<BoundaryR0, BoundaryL0>
typealias RejectedBoundaryAnchor = CommonAnswerAcrossRealizations<SharedFactFromVerdict<BoundaryV00>, SharedFactFromVerdict<BoundaryReversed00>>
#endif
