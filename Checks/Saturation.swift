import VerificationIsIdentification
import Examples

// Source identity is absent from these premises. The aliases derive equality
// after each generator from equality of the complete input image.
enum FirstOperationPreservesImageAgreement<A: BeamShape, B: BeamShape>: Null
where FullSpectrumImage<A> == FullSpectrumImage<B> {
    typealias Left = SpectrumFirstAgreement<A, B>.Left.Answer
    typealias Right = SpectrumFirstAgreement<A, B>.Right.Answer
}

enum SecondOperationPreservesImageAgreement<A: BeamShape, B: BeamShape>: Null
where FullSpectrumImage<A> == FullSpectrumImage<B> {
    typealias Left = SpectrumSecondAgreement<A, B>.Left.Answer
    typealias Right = SpectrumSecondAgreement<A, B>.Right.Answer
}

// Both generators preserve the same relation, so their certificates also
// supply the premises for a mixed continuation.
enum MixedOperationsPreserveImageAgreement<A: BeamShape, B: BeamShape>: Null
where FullSpectrumImage<A> == FullSpectrumImage<B> {
    typealias Left = SpectrumFirstAgreement<SwapBetaHidden<A>, SwapBetaHidden<B>>.Left.Answer
    typealias Right = FullSpectrumImage<SwapVisible<SwapBetaHidden<B>>>
}

enum DoubleSwapRestoresCompleteImage<B: BeamShape>: Null {
    typealias Left = FullSpectrumImage<SwapVisible<SwapVisible<B>>>
    typealias Right = FullSpectrumImage<B>
}

// These instantiate both continuation certificates on different nominal types.
typealias RoundTripFirstAgreement<B: BeamShape> = SpectrumFirstAgreement<B, SwapVisible<SwapVisible<B>>>
typealias RoundTripSecondAgreement<B: BeamShape> = SpectrumSecondAgreement<B, SwapVisible<SwapVisible<B>>>

enum SpectrumAppendIsComposition<P: CommutingTransition, B: BeamShape>: Null
where P.Right == FullSpectrumReading<B> {
    typealias Left = AppendSpectrumFirst<P, B>
    typealias Right = JoinedTransition<P, SpectrumFirstTransition<B>>
}

// The image path needs the shared intermediate image. It can therefore use
// B's image without asserting that B is the actual intermediate source.
enum ImagePathMayChangeRepresentative<A: BeamShape, B: BeamShape>: Null
where FullSpectrumImage<SwapVisible<A>> == FullSpectrumImage<B> {
    typealias Path = SequentialReading<
        SwapSpectrumHead<FullSpectrumImage<A>>,
        SwapSpectrumTail<FullSpectrumImage<B>>
    >
    typealias Left = Path.Answer
    typealias Right = FullSpectrumImage<SwapBetaHidden<SwapVisible<A>>>
}

typealias ImagePathThroughEquivalentSource = ImagePathMayChangeRepresentative<
    RedBeam,
    SwapVisible<SwapVisible<SwapVisible<RedBeam>>>
>

// Each retained coordinate is a permitted future reading of the original
// alpha question. This is the minimality direction for the coordinate model.
enum SaturationKeepsPresent<B: BeamShape>: Null {
    typealias Left = FullSpectrumImage<B>.Left
    typealias Right = B.AlphaLevel
}

enum SaturationBetaIsFuture<B: BeamShape>: Null {
    typealias Left = FullSpectrumImage<B>.Right.Left
    typealias Right = SwapVisible<B>.AlphaLevel
}

enum SaturationHiddenIsMixedFuture<B: BeamShape>: Null {
    typealias Left = FullSpectrumImage<B>.Right.Right
    typealias Right = SwapVisible<SwapBetaHidden<B>>.AlphaLevel
}

// The converse direction: both operations update this representation from
// its own coordinates, so the resulting observation is autonomous.
enum SaturatedFirstStepFollows<B: BeamShape>: Null {
    typealias Left = SpectrumFirstTransition<B>.ImageStep.Answer
    typealias Right = FullSpectrumImage<SwapVisible<B>>
}

enum SaturatedSecondStepFollows<B: BeamShape>: Null {
    typealias Left = SpectrumSecondTransition<B>.ImageStep.Answer
    typealias Right = FullSpectrumImage<SwapBetaHidden<B>>
}

typealias SaturationEmpty = IdentityTransition<FullSpectrumReading<RedBeamWithIR>>
typealias SaturationAfterSecond = AppendSpectrumSecond<SaturationEmpty, RedBeamWithIR>
typealias SaturationAfterMixed = AppendSpectrumFirst<SaturationAfterSecond, SwapBetaHidden<RedBeamWithIR>>

enum SaturatedMixedStepFollows: Null {
    typealias Left = SaturationAfterMixed.ImageStep.Answer.Left
    typealias Right = RedBeamWithIR.PaschenLevel
}

// Under only swap_bc, alpha is already sufficient for its own update.
enum AlphaClosedUnderSecond<B: BeamShape>: Null {
    typealias Left = SwapBetaHidden<B>.AlphaLevel
    typealias Right = B.AlphaLevel
}

// Under only swap_ab, the visible pair is autonomous (existing SwapTransition).
enum VisibleClosedUnderFirst<B: BeamShape>: Null {
    typealias Left = SwapTransition<B>.ImageStep.Answer
    typealias Right = EyeImage<SwapVisible<B>>
}

#if SATURATION_SEPARATE_JOIN
// The two sources have the same alpha and visible pair. The mixed word
// exposes the coordinate absent from both separately completed descriptions.
typealias RejectedSeparateSaturation = JoinedVerdict<
    AlphaReading<SwapVisible<SwapBetaHidden<RedBeam>>>,
    AlphaReading<SwapVisible<SwapBetaHidden<RedBeamWithIR>>>
>
#endif

#if SATURATION_EQUAL_IMAGE_IS_SOURCE
// This refuses nominal equality. It does not exhibit an observing operation
// that distinguishes the sources under the declared two-swap vocabulary.
enum RejectedImageAsSourceIdentity: Null {
    typealias Left = RedBeam
    typealias Right = SwapVisible<SwapVisible<RedBeam>>
}
#endif

#if SATURATION_EQUAL_IMAGE_IS_PATH_ENDPOINT
// The two proposed middle sources have equal complete images. This path
// constructor requires the actual source reading, not an image representative.
typealias RejectedImageAsPathEndpoint = JoinedTransition<
    SpectrumFirstTransition<RedBeam>,
    SpectrumSecondTransition<SwapVisible<SwapVisible<SwapVisible<RedBeam>>>>
>
#endif

#if SATURATION_AGREEMENT_WITHOUT_COMPLETE_IMAGE
typealias RejectedIncompleteImageAgreement = SpectrumFirstAgreement<RedBeam, RedBeamWithIR>
#endif

#if SATURATION_REVERSE_WORD
enum RejectedSaturationWordOrder: Null {
    typealias Left = FullSpectrumImage<RedBeamWithIR>.Right.Right
    typealias Right = SwapBetaHidden<SwapVisible<RedBeamWithIR>>.AlphaLevel
}
#endif

#if SATURATION_MISSING_FIELD
// Every address and operation label matches, but the proposed visible-image
// identity update cannot reproduce a hidden coordinate entering beta.
enum RejectedSaturationWithoutHidden<B: BeamShape>: CommutingTransition {
    typealias Left = VisibleReading<B>
    typealias Right = VisibleReading<SwapBetaHidden<B>>
    typealias Sigma = BeamSpace
    typealias Encoding = EyeEncoding
    typealias Operation = SwapBetaHiddenOperation
    typealias SourceStep = RecordedReading<BeamSpace, EyeEncoding, SwapBetaHiddenOperation, SwapBetaHidden<B>, B>
    typealias ImageStep = RecordedReading<BeamSpace, EyeEncoding, SwapBetaHiddenOperation, EyeImage<B>, EyeImage<B>>
}
#endif

#if SATURATION_WRONG_UPDATE
// Wrong computed image operation, with the correct label and input address.
enum RejectedSaturationImageUpdate: CommutingTransition {
    typealias Left = FullSpectrumReading<RedBeam>
    typealias Right = FullSpectrumReading<SwapBetaHidden<RedBeam>>
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Operation = SwapBetaHiddenOperation
    typealias SourceStep = HiddenSwapSource<RedBeam>
    typealias ImageStep = RecordedReading<BeamSpace, SaturationEncoding, SwapBetaHiddenOperation, SwapSpectrumHead<FullSpectrumImage<RedBeam>>.Answer, FullSpectrumImage<RedBeam>>
}
#endif
