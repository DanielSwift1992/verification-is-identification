import VerificationIsIdentification
import Examples

enum TransportAnswerFollows<F: ReadingFactors, G: ReadingFactors>: Null
where F.Right == G.Left {
    typealias Left = JoinedFactorization<F, G>.Right.Answer
    typealias Right = F.Left.Answer
}

enum TransportSourceFollows<F: ReadingFactors, G: ReadingFactors>: Null
where F.Right == G.Left {
    typealias Left = JoinedFactorization<F, G>.Observation.Left
    typealias Right = F.Left.Left
}

enum TransportDestinationFollows<F: ReadingFactors, G: ReadingFactors>: Null
where F.Right == G.Left {
    typealias Left = JoinedFactorization<F, G>.Observation.Answer
    typealias Right = G.Right.Left
}

enum TransferredPayloadFollows<P: Pair>: Null
where P.Left: Structure, P.Right: Structure {
    typealias Path = JoinedFactorization<LayoutFactorization<P>, PayloadFactorization<Paired<P.Right, P.Left>>>
    typealias Left = Path.Right.Answer
    typealias Right = P.Left
}

enum EmptyTransportFollows<R: PredicateReading>: Null {
    typealias Left = IdentityFactorization<R>.Observation.Answer
    typealias Right = R.Left
}

enum NativeCodeRetained<R: PredicateReading>: Null {
    typealias Left = AddressedReading<R>.Left.Left
    typealias Right = R.Encoding
}

typealias TransportInput = Paired<Lit1, Never>
typealias TransportWire = Paired<Never, Lit1>
typealias TransportFirst = LayoutFactorization<TransportInput>
typealias TransportSecond = PayloadFactorization<TransportWire>
typealias TransportPath = JoinedFactorization<TransportFirst, TransportSecond>
typealias TransportWithEmptyStart = JoinedFactorization<IdentityFactorization<TransportFirst.Left>, TransportPath>
typealias TransportWithEmptyEnd = JoinedFactorization<TransportWithEmptyStart, IdentityFactorization<TransportPath.Right>>
typealias TransportThreeStepAnswer = TransportAnswerFollows<TransportWithEmptyStart, IdentityFactorization<TransportPath.Right>>

// Changed wire content can leave the payload answer equal. It still cannot
// replace the actual intermediate reading in a composed transfer.
#if TRANSPORT_MIDDLE_SOURCE
typealias RejectedTransportMiddle = JoinedFactorization<TransportFirst, PayloadFactorization<Paired<Lit2, Lit1>>>
#endif

// Raw data, question and answer coincide here. The original layout code differs.
#if TRANSPORT_MIDDLE_CODE
typealias RelabeledMiddle = RecordedReading<TransportSpace, NativeLayout, PayloadQuestion, Lit1, TransportWire>
typealias RejectedTransportCode = JoinedFactorization<TransportFirst, IdentityFactorization<AddressedReading<RelabeledMiddle>>>
#endif

#if TRANSPORT_INPUT_CODE || TRANSPORT_OUTPUT_CODE || TRANSPORT_OUTPUT_VALUE
#if TRANSPORT_INPUT_CODE
typealias TransferInputCode = WireLayout
#else
typealias TransferInputCode = NativeLayout
#endif
#if TRANSPORT_OUTPUT_CODE
typealias TransferOutputCode = NativeLayout
#else
typealias TransferOutputCode = WireLayout
#endif
#if TRANSPORT_OUTPUT_VALUE
typealias TransferOutputValue = TransportInput
#else
typealias TransferOutputValue = TransportWire
#endif

enum RejectedTransportEndpoint: ReadingFactors {
    typealias Left = TransportFirst.Left
    typealias Right = TransportFirst.Right
    typealias Sigma = TransportSpace
    typealias Encoding = TransportEnvelope
    typealias Predicate = PayloadQuestion
    typealias Answer = Lit1
    typealias Observation = RecordedReading<TransportSpace, TransportEnvelope, ReverseLayoutOperation, AddressedRepresentation<TransferOutputCode, TransferOutputValue>, AddressedRepresentation<TransferInputCode, TransportInput>>
}
#endif

#if TRANSPORT_QUESTION || TRANSPORT_CONTEXT
#if TRANSPORT_QUESTION
typealias TransferQuestion = InfraredQuestion
#else
typealias TransferQuestion = PayloadQuestion
#endif
#if TRANSPORT_CONTEXT
typealias TransferContext = BeamSpace
#else
typealias TransferContext = TransportSpace
#endif

enum RejectedTransportReading: ReadingFactors {
    typealias Left = TransportFirst.Left
    typealias Right = AddressedReading<RecordedReading<TransferContext, WireLayout, TransferQuestion, Lit1, TransportWire>>
    typealias Observation = LayoutObservation<TransportInput>
    typealias Sigma = TransportSpace
    typealias Encoding = TransportEnvelope
    typealias Predicate = PayloadQuestion
    typealias Answer = Lit1
}
#endif

// Using the native decoder after reversing the layout reads the wrong field.
// Shared labels cannot turn that actual projection into a correct decoder.
#if TRANSPORT_WRONG_DECODER
enum RejectedTransportDecoder: ReadingFactors {
    typealias Left = AddressedReading<NativePayload<TransportWire>>
    typealias Right = AddressedReading<ScalarPayload<Lit1>>
    typealias Observation = RecordedReading<TransportSpace, TransportEnvelope, ProjectPayloadOperation, Right.Left, Left.Left>
    typealias Sigma = TransportSpace
    typealias Encoding = TransportEnvelope
    typealias Predicate = PayloadQuestion
    typealias Answer = Lit1
}
#endif

#if TRANSPORT_IDENTIFIES_SOURCE
enum RejectedTransportIdentity: Null {
    typealias Left = TransportPath.Left.Left
    typealias Right = TransportPath.Right.Left
}
#endif

#if TRANSPORT_RECOVERS_HIDDEN
// The common output cannot distinguish these two different native sources.
enum RejectedTransportRecovery: Null {
    typealias Original = Paired<Lit1, Lit2>
    typealias Path = JoinedFactorization<LayoutFactorization<Original>, PayloadFactorization<Paired<Lit2, Lit1>>>
    typealias Left = Paired<Path.Right.Answer, Never>
    typealias Right = Original
}
#endif

enum HiddenSourcesSharePayload<X: Structure, H: Structure, J: Structure>: Null {
    typealias First = JoinedFactorization<LayoutFactorization<Paired<X, H>>, PayloadFactorization<Paired<H, X>>>
    typealias Second = JoinedFactorization<LayoutFactorization<Paired<X, J>>, PayloadFactorization<Paired<J, X>>>
    typealias Left = First.Right.Left
    typealias Right = Second.Right.Left
}
