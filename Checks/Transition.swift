import VerificationIsIdentification
import Examples

enum FinalImageFollows<T: CommutingTransition>: Null {
    typealias Left = T.ImageStep.Answer
    typealias Right = T.Right.Answer
}

enum ComposedEndpointFollows<
    F: CommutingTransition,
    G: CommutingTransition
>: Null where F.Right == G.Left {
    typealias Left = JoinedTransition<F, G>.ImageStep.Answer
    typealias Right = G.Right.Answer
}

typealias SwapThenForget<B: BeamShape> = JoinedTransition<SwapTransition<B>, ForgetTransition<SwapVisible<B>>>
typealias VisibleRoundTrip<B: BeamShape> = JoinedTransition<SwapThenForget<B>, SwapTransition<ForgetHidden<SwapVisible<B>>>>

// The observation returns for every B, although its hidden coordinate was erased.
enum RoundTripImageFollows<B: BeamShape>: Null {
    typealias Left = VisibleRoundTrip<B>.Right.Answer
    typealias Right = EyeImage<B>
}

typealias EmptyPath = IdentityTransition<VisibleReading<RedBeamWithIR>>
typealias OneStep = AppendSwap<EmptyPath, RedBeamWithIR>
typealias MixedPath = FinalImageFollows<VisibleRoundTrip<RedBeamWithIR>>
typealias ErasedButSameImage = RoundTripImageFollows<RedBeamWithIR>

// Each mutation changes just one square address or context. Supplied reading
// records isolate the relation being tested, independently of optical evaluation.
#if STEP_SOURCE_INPUT || STEP_SOURCE_OUTPUT || STEP_IMAGE_INPUT || STEP_IMAGE_OUTPUT || STEP_OPERATION || STEP_CONTEXT
#if STEP_SOURCE_INPUT
typealias MutatedSource = RedBeamWithIR
#else
typealias MutatedSource = RedBeam
#endif
#if STEP_SOURCE_OUTPUT
typealias MutatedOutput = SwapVisible<RedBeamWithIR>
#else
typealias MutatedOutput = SwapVisible<RedBeam>
#endif
#if STEP_IMAGE_INPUT
typealias MutatedImageInput = Lit1
#else
typealias MutatedImageInput = EyeImage<RedBeam>
#endif
#if STEP_IMAGE_OUTPUT
typealias MutatedImageOutput = Lit1
#else
typealias MutatedImageOutput = EyeImage<SwapVisible<RedBeam>>
#endif
#if STEP_OPERATION
typealias MutatedOperation = ForgetHiddenOperation
#else
typealias MutatedOperation = SwapOperation
#endif
#if STEP_CONTEXT
typealias MutatedContext = OtherEncoding
#else
typealias MutatedContext = EyeEncoding
#endif

enum RejectedSquare: CommutingTransition {
    typealias Left = VisibleReading<RedBeam>
    typealias Right = VisibleReading<SwapVisible<RedBeam>>
    typealias Sigma = BeamSpace
    typealias Encoding = EyeEncoding
    typealias Operation = SwapOperation
    typealias SourceStep = RecordedReading<BeamSpace, EyeEncoding, SwapOperation, MutatedOutput, MutatedSource>
    typealias ImageStep = RecordedReading<BeamSpace, MutatedContext, MutatedOperation, MutatedImageOutput, MutatedImageInput>
}
#endif

#if STEP_QUESTION
enum RejectedStepQuestion: ObservedTransition {
    typealias Left = VisibleReading<RedBeam>
    typealias Right = RecordedReading<BeamSpace, EyeEncoding, OtherQuestion, EyeImage<SwapVisible<RedBeam>>, SwapVisible<RedBeam>>
    typealias Sigma = BeamSpace
    typealias Encoding = EyeEncoding
    typealias Operation = SwapOperation
}
#endif

#if STEP_MIDDLE
// Current images match, but the second step starts at another source. Image
// agreement is not permission to invent an actual source execution path.
typealias RejectedMiddle = JoinedTransition<SwapTransition<RedBeam>, ForgetTransition<SwapVisible<RedBeamWithIR>>>
#endif

#if STEP_EXPOSURE
// No identity decoder can implement this observation-revealing operation on
// every beam. The earlier metameric counterexample rules out any image-only
// deterministic decoder, while this mutation checks the proposed witness.
enum RejectedExposure<B: BeamShape>: CommutingTransition {
    typealias Left = VisibleReading<B>
    typealias Right = VisibleReading<ExposeHidden<B>>
    typealias Sigma = BeamSpace
    typealias Encoding = EyeEncoding
    typealias Operation = ForgetHiddenOperation
    typealias SourceStep = RecordedReading<BeamSpace, EyeEncoding, ForgetHiddenOperation, ExposeHidden<B>, B>
    typealias ImageStep = ForgetImageReading<EyeImage<B>>
}
#endif

#if STEP_INVERSE
enum RejectedErasureInverse: Null {
    typealias Left = VisibleRoundTrip<RedBeamWithIR>.Left.Left.PaschenLevel
    typealias Right = VisibleRoundTrip<RedBeamWithIR>.Right.Left.PaschenLevel
}
#endif

// More recorded coordinates preserve answers to an old question, but need
// not preserve closure of that larger record under the same operation.
enum AlphaSurvivesExposure<B: BeamShape>: Null {
    typealias Left = ExposeHiddenAsBeta<B>.AlphaLevel
    typealias Right = B.AlphaLevel
}

#if STEP_RICHER_IMAGE
typealias RejectedRicherImage = JoinedVerdict<
    VisibleReading<ExposeHiddenAsBeta<RedBeam>>,
    VisibleReading<ExposeHiddenAsBeta<RedBeamWithIR>>
>
#endif
