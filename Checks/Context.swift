import VerificationIsIdentification
import Examples

typealias ComponentIdentity = Paired<Never, Paired<ExperimentQuiet, ExperimentSignal>>
typealias ComponentSwapTail = Paired<Never, Paired<ExperimentSignal, ExperimentQuiet>>
typealias AgreementAtFirstInput = JoinedVerdict<FirstTableReading<ComponentIdentity>, FirstTableReading<ComponentSwapTail>>
typealias AgreementAfterOutputContext = PostPairAgreement<AgreementAtFirstInput, ExperimentSignal>

enum PostContextDerivesAnswer<C: VerdictIsInvariant, S: Structure>: Null
where C.Answer: Structure {
    typealias Left = PostPairAgreement<C, S>.Left.Answer
    typealias Right = PostPairAgreement<C, S>.Right.Answer
}

enum PostContextRetainsInputScope<C: VerdictIsInvariant, S: Structure>: Null
where C.Answer: Structure {
    typealias Left = PostPairAgreement<C, S>.Left.Left
    typealias Right = C.Left.Left
}

#if FIRST_INPUT_CERTIFICATE_COVERS_NEW_INPUT
enum RejectedExpandedCertificateScope: Null {
    typealias Left = FirstTableReading<ComponentIdentity.Right>.Answer
    typealias Right = FirstTableReading<ComponentSwapTail.Right>.Answer
}
#endif

// SW3a: widening the admitted source family can preserve one question and
// remove another question's invariant answer. The readers use actual fields.
typealias CorrectionFirst<P: Pair> = FirstEvidenceImage<
    P, BeamSpace, SaturationEncoding, FirstProjection>
typealias CorrectionSecond<P: Pair> = SecondEvidenceImage<
    P, BeamSpace, SaturationEncoding, SecondProjection>
typealias ExpandedFirstAgreement<A: Structure, B: Structure, C: Structure> = JoinedVerdict<
    CorrectionFirst<Paired<A, B>>, CorrectionFirst<Paired<A, C>>>

// No output-equality premise is requested from the caller.
enum ScopeChangeKeepsFirst<A: Structure, B: Structure, C: Structure>: Null {
    typealias Left = ExpandedFirstAgreement<A, B, C>.Answer
    typealias Right = A
}

// Both members of the declared expanded family are the certificate's sources.
enum CorrectionCoversExpandedFamily<A: Structure, B: Structure, C: Structure>: Null {
    typealias Certificate = ExpandedFirstAgreement<A, B, C>
    typealias Left = Paired<Certificate.Left.Left, Certificate.Right.Left>
    typealias Right = Paired<Paired<A, B>, Paired<A, C>>
}

enum FirstRestatementSurvives<A: Structure, B: Structure, C: Structure, S: Structure>: Null {
    typealias Left = PostPairAgreement<ExpandedFirstAgreement<A, B, C>, S>.Answer
    typealias Right = Paired<A, S>
}

typealias CorrectionOriginal = Paired<Never, Never>
typealias CorrectionAdditional = Paired<Never, Lit1>
typealias OriginalSecondAgreement = SingletonVerdict<CorrectionSecond<CorrectionOriginal>>
typealias CorrectedSecondObstruction = ZeroSuccessorBoundary<
    CorrectionSecond<CorrectionOriginal>, CorrectionSecond<CorrectionAdditional>, Never>

// A descendant can ignore precisely the varying field. Its new proof uses
// both expanded sources without requiring their second answers to agree.
typealias CorrectionTaggedSecond<P: Pair, S: Structure> = PostPairReading<
    CorrectionSecond<P>, S> where P.Right: Structure
typealias CorrectionTag<P: Pair, S: Structure> = SequentialReading<
    CorrectionTaggedSecond<P, S>,
    SecondEvidenceImage<CorrectionTaggedSecond<P, S>.Answer,
        BeamSpace, SaturationEncoding, SecondProjection>
> where P.Right: Structure

typealias ExpandedTagAgreement<A: Structure, B: Structure, C: Structure, S: Structure> = JoinedVerdict<
    CorrectionTag<Paired<A, B>, S>, CorrectionTag<Paired<A, C>, S>>

enum CoarseDescendantSurvives<A: Structure, B: Structure, C: Structure, S: Structure>: Null {
    typealias Left = ExpandedTagAgreement<A, B, C, S>.Answer
    typealias Right = S
}

enum CoarseDescendantReadsExpandedFamily<A: Structure, B: Structure, C: Structure, S: Structure>: Null {
    typealias Certificate = ExpandedTagAgreement<A, B, C, S>
    typealias Left = Paired<Certificate.Left.Left, Certificate.Right.Left>
    typealias Right = Paired<Paired<A, B>, Paired<A, C>>
}

#if WHOLE_CORRECTION_OLD_SCOPE_COVERS_EXPANSION
enum RejectedCorrectionOldScope: Null {
    typealias Left = OriginalSecondAgreement.Right.Left
    typealias Right = CorrectionAdditional
}
#endif

#if WHOLE_CORRECTION_EXPANDED_SECOND_AGREES
typealias RejectedCorrectionSecondAgreement = JoinedVerdict<
    CorrectionSecond<CorrectionOriginal>, CorrectionSecond<CorrectionAdditional>>
#endif

#if WHOLE_CORRECTION_SECOND_RESTATEMENT_SURVIVES
typealias RejectedCorrectionSecondRestatement = JoinedVerdict<
    CorrectionTaggedSecond<CorrectionOriginal, Lit1>,
    CorrectionTaggedSecond<CorrectionAdditional, Lit1>>
#endif

#if FIRST_INPUT_CERTIFICATE_IDENTIFIES_WHOLE_FUNCTION
enum RejectedWholeFunctionFromSample: Null {
    typealias Left = ComponentIdentity
    typealias Right = ComponentSwapTail
}
#endif
