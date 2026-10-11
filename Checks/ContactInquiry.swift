import VerificationIsIdentification
import Examples

typealias InquiryCases = ContactInquiryCycle<Never, Lit1>

// Every seam's generic constructor checks its own actual source, request,
// probe result and decoder. This instantiates the complete finite family.
enum InquiryCoversCycle<A: Structure, B: Structure>: Null {
    typealias C = ContactInquiryCycle<A, B>
    typealias Left = Paired<C.Seam01.Answer, Paired<C.Seam12.Answer,
        Paired<C.Seam23.Answer, Paired<C.Seam34.Answer, C.Seam40.Answer>>>>
    typealias Right = Paired<Paired<A, B>, Paired<Paired<A, B>,
        Paired<Paired<A, B>, Paired<Paired<A, B>, Paired<A, B>>>>>
}
typealias InquiryBinary = InquiryCoversCycle<Never, Lit1>
typealias InquiryStructural = InquiryCoversCycle<Paired<Never, Lit1>, Paired<Lit2, Never>>

// A request's actual input is the old fact, identical across the endpoints.
// The sender gets this command and P, not the seam or the two payloads.
enum InquiryRequestIsRecordOnly<A: Structure, B: Structure>: Null {
    typealias E = ContactSeam40
    typealias Request = ContactRequest<E, Paired<A, B>, FirstProjection>
    typealias Left = Paired<Request.Left, ContactSenderInput<ContactPort4, E, A, B, FirstProjection>.Answer>
    typealias Right = Paired<ReadyContactRecord<ContactPort0, E, A, B>.Answer, Paired<FirstProjection, ContactPort4>>
}

// One prepared instrument, one resident port and the parked old record.
// Its actual output contains precisely the decoder's inputs. The port and
// request survive; the reply is acquired once from that requested source.
enum InquiryResidentReply<P: Pair, E: Pair, A: Structure, B: Structure,
    Q: Structure, R: PredicateReading>: Null
where R.Left == Paired<Q, P>, R.Sigma == BeamSpace, R.Encoding == SaturationEncoding {
    typealias Instrument = PreparedTraceExtension<StartObservations<R.Left>, R>
    typealias Run = StepBeside<Instrument, FactOf<ContactRecord<ContactWorld<P, E, A, B>>>>
    typealias Final = Run.Right
    typealias Left = Paired<Final.Left.Left, Paired<Final.Right, Final.Left.Right.Right.Right.Right>>
    typealias Right = Paired<Paired<Q, P>, ContactInquiryEvidence<P, E, A, B, Q, R>.Answer>
}
typealias InquiryResidentFirst = InquiryResidentReply<ContactPort4, ContactSeam40, Never, Lit1, FirstProjection, RequestedFirstContactBit<ContactPort4>>
typealias InquiryResidentSecond = InquiryResidentReply<ContactPort1, ContactSeam01, Never, Lit1, SecondProjection, RequestedSecondContactBit<ContactPort1>>

// Neither fixed binary probe works across all seams without a request.
enum InquiryBlindFirstCollides: Null {
    typealias Left = ContactInquiryEvidence<ContactPort0, ContactSeam01, Never, Lit1, FirstProjection, RequestedFirstContactBit<ContactPort0>>.Answer
    typealias Right = ContactInquiryEvidence<ContactPort1, ContactSeam01, Never, Lit1, FirstProjection, RequestedFirstContactBit<ContactPort1>>.Answer
}
typealias InquiryBlindFirstDifferentAnswers = ZeroSuccessorBoundary<InquiryCases.Seam01.DirectP, InquiryCases.Seam01.DirectT, Never>
enum InquiryBlindSecondCollides: Null {
    typealias Left = ContactInquiryEvidence<ContactPort4, ContactSeam40, Never, Lit1, SecondProjection, RequestedSecondContactBit<ContactPort4>>.Answer
    typealias Right = ContactInquiryEvidence<ContactPort0, ContactSeam40, Never, Lit1, SecondProjection, RequestedSecondContactBit<ContactPort0>>.Answer
}
typealias InquiryBlindSecondDifferentAnswers = ZeroSuccessorBoundary<InquiryCases.Seam40.DirectP, InquiryCases.Seam40.DirectT, Never>

// Two fixed resident readings acquire the complete three-valued code. Their
// joint history still does not identify five ports without further evidence.
enum InquiryTwoProbesDoNotIdentifyPort: Null {
    typealias Left = AcquireContactCode<ContactPort0.Left, Never, Never>.Observation.Answer
    typealias Right = AcquireContactCode<ContactPort2.Left, Never, Never>.Observation.Answer
}
typealias InquiryPortIdentityDiffers = ZeroSuccessorBoundaryPairClass<Paired<ContactPort0.Left, ContactPort2.Left>, Lit1>

// One additional record makes BOTH queries inadequate on that same record.
// No feedback choice between them can resolve it in one source interaction.
typealias InquiryStar = ContactStar<Never, Lit1>
typealias InquiryStarFirst0 = ReadingBesideInput<AcquireAnswer<ContactFirstBit<ContactPort0>>.Observation, InquiryStar.D>
typealias InquiryStarFirst1 = ReadingBesideInput<AcquireAnswer<ContactFirstBit<ContactPort1>>.Observation, InquiryStar.D>
typealias InquiryStarSecond0 = ReadingBesideInput<AcquireAnswer<ContactSecondBit<ContactPort0>>.Observation, InquiryStar.D>
typealias InquiryStarSecond4 = ReadingBesideInput<AcquireAnswer<ContactSecondBit<ContactPort4>>.Observation, InquiryStar.D>
enum InquiryStarFirstCollision: Null {
    typealias Left = InquiryStarFirst0.Answer
    typealias Right = InquiryStarFirst1.Answer
}
enum InquiryStarSecondCollision: Null {
    typealias Left = InquiryStarSecond0.Answer
    typealias Right = InquiryStarSecond4.Answer
}
typealias InquiryStarFirstNeedsDifferentAnswers = ZeroSuccessorBoundary<InquiryStar.Direct0, InquiryStar.Direct1, Never>
typealias InquiryStarSecondNeedsDifferentAnswers = ZeroSuccessorBoundary<InquiryStar.Direct0, InquiryStar.Direct4, Never>
enum InquiryStarTwoProbesSuffice<A: Structure, B: Structure>: Null {
    typealias S = ContactStar<A, B>
    typealias Left = Paired<S.At0.Answer, Paired<S.At1.Answer, S.At4.Answer>>
    typealias Right = Paired<A, Paired<B, B>>
}

// A known invasive exchange changes the current answer. The transported
// decoder nevertheless returns the original question's value.
typealias InquiryExchange = ContactInquiryAfterExchange<Never, Lit1>
enum InquiryExchangeKeepsOriginalAnswer: Null {
    typealias Left = InquiryExchange.Answer
    typealias Right = Never
}
enum InquiryExchangeCoversBothOrigins<A: Structure, B: Structure>: Null {
    typealias Left = Paired<ContactInquiryAfterExchange<A, B>.Answer, ContactInquiryFromSecondEndpoint<A, B>.Answer>
    typealias Right = Paired<A, B>
}
enum InquiryExchangeAndNoExchangeShareReply: Null {
    typealias Left = InquiryExchange.Observation.Answer
    typealias Right = InquiryCases.Seam01.EvidenceT.Answer
}
typealias InquiryUnknownInterventionChangesTarget = ZeroSuccessorBoundary<InquiryExchange.Left, InquiryCases.Seam01.DirectT, Never>

#if CONTACT_INQUIRY_WRONG_COMMAND
typealias RejectedInquiryCommand = DecodeRefinedEvidence<
    ContactSenderInput<ContactPort4, ContactSeam40, Never, Lit1, SecondProjection>, RequestedFirstContactBit<ContactPort4>>
#endif

#if CONTACT_INQUIRY_BLIND_QUERY
typealias RejectedInquiryBlindQuery = ContactSecondInquiryBackward<ContactPort4, ContactPort0, Never, Lit1>
#endif

#if CONTACT_INQUIRY_AS_CALIBRATION
enum RejectedInquiryAsCalibration: Null {
    typealias Left = InquiryCases.Seam01.EvidenceP.Answer.Right
    typealias Right = FactOf<ContactCalibration<ContactWorld<ContactPort0, ContactSeam01, Never, Lit1>>>
}
#endif

#if CONTACT_INQUIRY_IGNORES_INTERVENTION
enum RejectedInquiryCurrentAsOriginal: ReadingFactors {
    typealias Left = InquiryExchange.Left
    typealias Observation = InquiryExchange.Observation
    typealias Right = InquiryCases.Seam01.DecoderT
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Predicate = RoutedValueQuestion
    typealias Answer = Left.Answer
}
#endif

#if CONTACT_INQUIRY_STAR_COLLAPSES_ANSWER
typealias RejectedInquiryStarAnswer = JoinedVerdict<InquiryStar.Direct0, InquiryStar.Direct1>
#endif
