import VerificationIsIdentification

/// The two available probe laws read actual coordinates. Their interpretation
/// does not come from an arbitrary PredicateReading conformance.
public typealias ContactFirstBit<P: Pair> = DecodeRefinedEvidence<
    SecondEvidenceImage<P, BeamSpace, SaturationEncoding, ContactCalibrationQuestion>,
    FirstEvidenceImage<P.Right, BeamSpace, SaturationEncoding,
        OperationSequence<ContactCalibrationQuestion, FirstProjection>>
>
where P.Right: Pair
public typealias ContactSecondBit<P: Pair> = DecodeRefinedEvidence<
    SecondEvidenceImage<P, BeamSpace, SaturationEncoding, ContactCalibrationQuestion>,
    SecondEvidenceImage<P.Right, BeamSpace, SaturationEncoding,
        OperationSequence<ContactCalibrationQuestion, SecondProjection>>
>
where P.Right: Pair

/// The request is a field of the sender's actual input. The old record and
/// payloads are absent from it. Each command invokes its fixed projection.
public typealias RequestedFirstContactBit<P: Pair> = DecodeRefinedEvidence<
    SecondEvidenceImage<Paired<FirstProjection, P>, BeamSpace, SaturationEncoding, SecondProjection>,
    ContactFirstBit<P>
>
where P.Right: Pair
public typealias RequestedSecondContactBit<P: Pair> = DecodeRefinedEvidence<
    SecondEvidenceImage<Paired<SecondProjection, P>, BeamSpace, SaturationEncoding, SecondProjection>,
    ContactSecondBit<P>
>
where P.Right: Pair

/// A current source beside an already available record. This shape is an
/// input premise. ContactChangeRetainsRecord supplies reuse across replacement.
public typealias ReadyContact<P: Pair, E: Pair, A: Structure, B: Structure> = Paired<
    ContactWorld<P, E, A, B>, FactOf<ContactRecord<ContactWorld<P, E, A, B>>>
>
public typealias ReadyContactSource<P: Pair, E: Pair, A: Structure, B: Structure> = FirstEvidenceImage<ReadyContact<P, E, A, B>, BeamSpace, SaturationEncoding, FirstProjection>
public typealias ReadyContactRecord<P: Pair, E: Pair, A: Structure, B: Structure> = SecondEvidenceImage<ReadyContact<P, E, A, B>, BeamSpace, SaturationEncoding, ContactRecordQuestion>
public typealias ReadyContactPort<P: Pair, E: Pair, A: Structure, B: Structure> = DecodeRefinedEvidence<
    ReadyContactSource<P, E, A, B>,
    FirstEvidenceImage<ContactWorld<P, E, A, B>, BeamSpace, SaturationEncoding, FirstProjection>
>

/// A fixed request clause reads only the old record. The five-cycle program
/// below uses First at seam40 and Second at the other four seams. This generic
/// constant constructor alone does not assert that every request is adequate.
public enum ContactRequest<E: Pair, D: Structure, Q: Structure>: PredicateReading {
    public typealias Left = AnswerFact<BeamSpace, SaturationEncoding, ContactRecordQuestion, Paired<E, D>>
    public typealias Right = Q
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Q
    public typealias Answer = Right
}
public typealias ContactSenderInput<P: Pair, E: Pair, A: Structure, B: Structure, Q: Structure> = JointEvidence<
    DecodeRefinedEvidence<ReadyContactRecord<P, E, A, B>, ContactRequest<E, Paired<A, B>, Q>>,
    ReadyContactPort<P, E, A, B>
>

/// One new reply fact joins the OLD record. R is the supplied probe program;
/// the constructors below fix it to one of the two actual coordinate readings.
public typealias ContactInquiryEvidence<P: Pair, E: Pair, A: Structure, B: Structure,
    Q: Structure, R: PredicateReading> = JointEvidence<
        ReadyContactRecord<P, E, A, B>,
        FactorOnSource<AcquireAnswer<R>, ContactSenderInput<P, E, A, B, Q>>.Observation
    >
where R.Left == Paired<Q, P>, R.Sigma == BeamSpace, R.Encoding == SaturationEncoding

/// A reply bit is an answer to the requested coordinate question, not a
/// complete calibration. Prefixing zero forms a Route00/01 decoder address.
public enum ContactInquiryRow<E: Pair, Q: Structure, Bit: Structure, R: PredicateReading>: PredicateReading
where R.Left: Structure, R.Answer: Structure,
      R.Sigma == BeamSpace, R.Encoding == SaturationEncoding {
    public typealias Left = Paired<
        AnswerFact<BeamSpace, SaturationEncoding, ContactRecordQuestion, Paired<E, R.Left>>,
        AnswerFact<BeamSpace, SaturationEncoding, OperationSequence<ContactCalibrationQuestion, Q>, Bit>
    >
    public typealias Right = Paired<Paired<Never, Bit>, R.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RoutedValueQuestion
    public typealias Answer = Right
}

/// The second probe separates these source ports as 0/1. Actual source
/// coordinate premises suffice; no payload-answer equality is requested.
public enum ContactSecondInquiryForward<P: Pair, T: Pair, A: Structure, B: Structure>: ReadingFactors
where P.Left: Structure, T.Left: Structure, P.Right: Pair, T.Right: Pair,
      P.Right.Right == Never, T.Right.Right == Lit1 {
    public typealias E = Paired<P.Left, T.Left>
    public typealias D = Paired<A, B>
    public typealias DirectP = DecodeRefinedEvidence<ReadyContactSource<P, E, A, B>, ContactLeftValue<ContactWorld<P, E, A, B>>>
    public typealias DirectT = DecodeRefinedEvidence<ReadyContactSource<T, E, A, B>, ContactRightValue<ContactWorld<T, E, A, B>>>
    public typealias EvidenceP = ContactInquiryEvidence<P, E, A, B, SecondProjection, RequestedSecondContactBit<P>>
    public typealias EvidenceT = ContactInquiryEvidence<T, E, A, B, SecondProjection, RequestedSecondContactBit<T>>
    public typealias DecoderP = DecodeRefinedEvidence<ContactInquiryRow<E, SecondProjection, Never, ContactRowABAA<D>>, Route00<ContactRowABAA<D>.Answer>>
    public typealias DecoderT = DecodeRefinedEvidence<ContactInquiryRow<E, SecondProjection, Lit1, ContactRowABAA<D>>, Route01<ContactRowABAA<D>.Answer>>
    public typealias Left = PairedApplication<DirectP, DirectT>
    public typealias Observation = PairedApplication<EvidenceP, EvidenceT>
    public typealias Right = PairedApplication<DecoderP, DecoderT>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Left.Predicate
    public typealias Answer = Left.Answer
}

public enum ContactSecondInquiryBackward<P: Pair, T: Pair, A: Structure, B: Structure>: ReadingFactors
where P.Left: Structure, T.Left: Structure, P.Right: Pair, T.Right: Pair,
      P.Right.Right == Lit1, T.Right.Right == Never {
    public typealias E = Paired<P.Left, T.Left>
    public typealias D = Paired<A, B>
    public typealias DirectP = DecodeRefinedEvidence<ReadyContactSource<P, E, A, B>, ContactLeftValue<ContactWorld<P, E, A, B>>>
    public typealias DirectT = DecodeRefinedEvidence<ReadyContactSource<T, E, A, B>, ContactRightValue<ContactWorld<T, E, A, B>>>
    public typealias EvidenceP = ContactInquiryEvidence<P, E, A, B, SecondProjection, RequestedSecondContactBit<P>>
    public typealias EvidenceT = ContactInquiryEvidence<T, E, A, B, SecondProjection, RequestedSecondContactBit<T>>
    public typealias DecoderP = DecodeRefinedEvidence<ContactInquiryRow<E, SecondProjection, Lit1, ContactRowBAAA<D>>, Route01<ContactRowBAAA<D>.Answer>>
    public typealias DecoderT = DecodeRefinedEvidence<ContactInquiryRow<E, SecondProjection, Never, ContactRowBAAA<D>>, Route00<ContactRowBAAA<D>.Answer>>
    public typealias Left = PairedApplication<DirectP, DirectT>
    public typealias Observation = PairedApplication<EvidenceP, EvidenceT>
    public typealias Right = PairedApplication<DecoderP, DecoderT>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Left.Predicate
    public typealias Answer = Left.Answer
}

public enum ContactFirstInquiryForward<P: Pair, T: Pair, A: Structure, B: Structure>: ReadingFactors
where P.Left: Structure, T.Left: Structure, P.Right: Pair, T.Right: Pair,
      P.Right.Left == Never, T.Right.Left == Lit1 {
    public typealias E = Paired<P.Left, T.Left>
    public typealias D = Paired<A, B>
    public typealias DirectP = DecodeRefinedEvidence<ReadyContactSource<P, E, A, B>, ContactLeftValue<ContactWorld<P, E, A, B>>>
    public typealias DirectT = DecodeRefinedEvidence<ReadyContactSource<T, E, A, B>, ContactRightValue<ContactWorld<T, E, A, B>>>
    public typealias EvidenceP = ContactInquiryEvidence<P, E, A, B, FirstProjection, RequestedFirstContactBit<P>>
    public typealias EvidenceT = ContactInquiryEvidence<T, E, A, B, FirstProjection, RequestedFirstContactBit<T>>
    public typealias DecoderP = DecodeRefinedEvidence<ContactInquiryRow<E, FirstProjection, Never, ContactRowABAA<D>>, Route00<ContactRowABAA<D>.Answer>>
    public typealias DecoderT = DecodeRefinedEvidence<ContactInquiryRow<E, FirstProjection, Lit1, ContactRowABAA<D>>, Route01<ContactRowABAA<D>.Answer>>
    public typealias Left = PairedApplication<DirectP, DirectT>
    public typealias Observation = PairedApplication<EvidenceP, EvidenceT>
    public typealias Right = PairedApplication<DecoderP, DecoderT>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Left.Predicate
    public typealias Answer = Left.Answer
}

public enum ContactFirstInquiryBackward<P: Pair, T: Pair, A: Structure, B: Structure>: ReadingFactors
where P.Left: Structure, T.Left: Structure, P.Right: Pair, T.Right: Pair,
      P.Right.Left == Lit1, T.Right.Left == Never {
    public typealias E = Paired<P.Left, T.Left>
    public typealias D = Paired<A, B>
    public typealias DirectP = DecodeRefinedEvidence<ReadyContactSource<P, E, A, B>, ContactLeftValue<ContactWorld<P, E, A, B>>>
    public typealias DirectT = DecodeRefinedEvidence<ReadyContactSource<T, E, A, B>, ContactRightValue<ContactWorld<T, E, A, B>>>
    public typealias EvidenceP = ContactInquiryEvidence<P, E, A, B, FirstProjection, RequestedFirstContactBit<P>>
    public typealias EvidenceT = ContactInquiryEvidence<T, E, A, B, FirstProjection, RequestedFirstContactBit<T>>
    public typealias DecoderP = DecodeRefinedEvidence<ContactInquiryRow<E, FirstProjection, Lit1, ContactRowBAAA<D>>, Route01<ContactRowBAAA<D>.Answer>>
    public typealias DecoderT = DecodeRefinedEvidence<ContactInquiryRow<E, FirstProjection, Never, ContactRowBAAA<D>>, Route00<ContactRowBAAA<D>.Answer>>
    public typealias Left = PairedApplication<DirectP, DirectT>
    public typealias Observation = PairedApplication<EvidenceP, EvidenceT>
    public typealias Right = PairedApplication<DecoderP, DecoderT>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Left.Predicate
    public typealias Answer = Left.Answer
}

/// Five request clauses, one of two commands and one binary reply per case.
public enum ContactInquiryCycle<A: Structure, B: Structure>: Close {
    public typealias Seam01 = ContactSecondInquiryForward<ContactPort0, ContactPort1, A, B>
    public typealias Seam12 = ContactSecondInquiryBackward<ContactPort1, ContactPort2, A, B>
    public typealias Seam23 = ContactSecondInquiryForward<ContactPort2, ContactPort3, A, B>
    public typealias Seam34 = ContactSecondInquiryBackward<ContactPort3, ContactPort4, A, B>
    public typealias Seam40 = ContactFirstInquiryBackward<ContactPort4, ContactPort0, A, B>
}

/// Pair the answers at the first/second channel addresses. AcquireContactCode
/// below supplies their common-source acquisition; these channel constraints
/// alone do not establish where arbitrary supplied facts were acquired.
public enum ContactCodeFromTwoFacts<M: Pair>: PredicateReading
where M.Left: HasVerdict, M.Right: HasVerdict,
      M.Left.Sigma == BeamSpace, M.Right.Sigma == BeamSpace,
      M.Left.Encoding == SaturationEncoding, M.Right.Encoding == SaturationEncoding,
      M.Left.Predicate == OperationSequence<ContactCalibrationQuestion, FirstProjection>,
      M.Right.Predicate == OperationSequence<ContactCalibrationQuestion, SecondProjection>,
      M.Left.Answer: Structure, M.Right.Answer: Structure {
    public typealias Left = M
    public typealias Right = Paired<M.Left.Answer, M.Right.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = ContactCalibrationQuestion
    public typealias Answer = Right
}
public enum AcquireContactCode<I: Structure, A: Structure, B: Structure>: ReadingFactors {
    public typealias P = Paired<I, Paired<A, B>>
    public typealias Left = SecondEvidenceImage<P, BeamSpace, SaturationEncoding, ContactCalibrationQuestion>
    public typealias Observation = ObserveTwoResidentFacts<ContactFirstBit<P>, ContactSecondBit<P>>
    public typealias Right = ContactCodeFromTwoFacts<Observation.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = ContactCalibrationQuestion
    public typealias Answer = Left.Answer
}

/// An additional record admits ports 0, 1 and 4 together. Its independent
/// routing question gives A at code00, and B at code01/code10. Both probes
/// together answer it; either probe alone leaves an unequal-answer pair.
public enum ContactStarRecord: Close {}
public enum ContactStarArgument<C: Structure, A: Structure, B: Structure>: PredicateReading {
    public typealias Left = Paired<C, Paired<ContactStarRecord, BoundaryWorking<A, B, B, B>>>
    public typealias Right = Paired<C, BoundaryWorking<A, B, B, B>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RoutedValueQuestion
    public typealias Answer = Right
}
public enum ContactStar<A: Structure, B: Structure>: Close {
    public typealias Values = BoundaryWorking<A, B, B, B>
    public typealias D = Paired<ContactStarRecord, Values>
    public typealias Code0 = SecondEvidenceImage<ContactPort0, BeamSpace, SaturationEncoding, ContactCalibrationQuestion>
    public typealias Code1 = SecondEvidenceImage<ContactPort1, BeamSpace, SaturationEncoding, ContactCalibrationQuestion>
    public typealias Code4 = SecondEvidenceImage<ContactPort4, BeamSpace, SaturationEncoding, ContactCalibrationQuestion>
    public typealias Select0 = DecodeRefinedEvidence<ContactStarArgument<RoutingAddress00, A, B>, Route00<Values>>
    public typealias Select1 = DecodeRefinedEvidence<ContactStarArgument<RoutingAddress01, A, B>, Route01<Values>>
    public typealias Select4 = DecodeRefinedEvidence<ContactStarArgument<RoutingAddress10, A, B>, Route10<Values>>
    public typealias Direct0 = DecodeRefinedEvidence<ReadingBesideInput<Code0, D>, Select0>
    public typealias Direct1 = DecodeRefinedEvidence<ReadingBesideInput<Code1, D>, Select1>
    public typealias Direct4 = DecodeRefinedEvidence<ReadingBesideInput<Code4, D>, Select4>
    public typealias Read0 = EvidenceBesideInput<AcquireContactCode<ContactPort0.Left, ContactPort0.Right.Left, ContactPort0.Right.Right>, D>
    public typealias Read1 = EvidenceBesideInput<AcquireContactCode<ContactPort1.Left, ContactPort1.Right.Left, ContactPort1.Right.Right>, D>
    public typealias Read4 = EvidenceBesideInput<AcquireContactCode<ContactPort4.Left, ContactPort4.Right.Left, ContactPort4.Right.Right>, D>

    public enum At0: ReadingFactors {
        public typealias Left = Direct0
        public typealias Observation = Read0.Observation
        public typealias Right = DecodeRefinedEvidence<Read0.Right, Select0>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = RoutedValueQuestion
        public typealias Answer = Left.Answer
    }
    public enum At1: ReadingFactors {
        public typealias Left = Direct1
        public typealias Observation = Read1.Observation
        public typealias Right = DecodeRefinedEvidence<Read1.Right, Select1>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = RoutedValueQuestion
        public typealias Answer = Left.Answer
    }
    public enum At4: ReadingFactors {
        public typealias Left = Direct4
        public typealias Observation = Read4.Observation
        public typealias Right = DecodeRefinedEvidence<Read4.Right, Select4>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = RoutedValueQuestion
        public typealias Answer = Left.Answer
    }
    public enum OuterAgreement: VerdictIsInvariant {
        public typealias Left = Direct1
        public typealias Right = Direct4
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = RoutedValueQuestion
        public typealias Answer = Left.Answer
    }
}

/// Exchange the current port with a resident replacement, keeping the old
/// record, payload and displaced port. W is the ready source/record pair.
public enum ExchangeReadyContact<W: Pair, P: Pair>: PredicateReading
where W.Left: Pair, W.Left.Left: Structure, W.Left.Right: Structure, W.Right: Structure {
    public typealias Left = Paired<W, P>
    public typealias Right = Paired<Paired<Paired<P, W.Left.Right>, W.Right>, W.Left.Left>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RoutingReserveExchangeOperation
    public typealias Answer = Right
}

/// A known intervention exchanges the two actual endpoints before the reply.
/// The opposite decoder answers the ORIGINAL source question, not the new one.
public enum ContactInquiryAfterExchange<A: Structure, B: Structure>: ReadingFactors {
    public typealias Before = ReadyContact<ContactPort0, ContactSeam01, A, B>
    public typealias Change = ExchangeReadyContact<Before, ContactPort1>
    public typealias Current = DecodeRefinedEvidence<Change,
        FirstEvidenceImage<Change.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Left = DecodeRefinedEvidence<
        FirstEvidenceImage<Change.Left, BeamSpace, SaturationEncoding, FirstProjection>,
        ContactInquiryCycle<A, B>.Seam01.DirectP>
    public typealias Observation = DecodeRefinedEvidence<Current, ContactInquiryCycle<A, B>.Seam01.EvidenceT>
    public typealias Right = DecodeRefinedEvidence<
        ContactInquiryRow<ContactSeam01, SecondProjection, Lit1, ContactRowBAAA<Paired<A, B>>>,
        Route01<ContactRowBAAA<Paired<A, B>>.Answer>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RoutedValueQuestion
    public typealias Answer = Left.Answer
}

/// The other initial endpoint under that same known exchange law. Together
/// the two clauses cover an unknown initial endpoint, with decoder bit0→B,
/// bit1→A. Knowing one displayed case's port is not free participant evidence.
public enum ContactInquiryFromSecondEndpoint<A: Structure, B: Structure>: ReadingFactors {
    public typealias Before = ReadyContact<ContactPort1, ContactSeam01, A, B>
    public typealias Change = ExchangeReadyContact<Before, ContactPort0>
    public typealias Current = DecodeRefinedEvidence<Change,
        FirstEvidenceImage<Change.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Left = DecodeRefinedEvidence<
        FirstEvidenceImage<Change.Left, BeamSpace, SaturationEncoding, FirstProjection>,
        ContactInquiryCycle<A, B>.Seam01.DirectT>
    public typealias Observation = DecodeRefinedEvidence<Current, ContactInquiryCycle<A, B>.Seam01.EvidenceP>
    public typealias Right = DecodeRefinedEvidence<
        ContactInquiryRow<ContactSeam01, SecondProjection, Never, ContactRowBAAA<Paired<A, B>>>,
        Route00<ContactRowBAAA<Paired<A, B>>.Answer>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RoutedValueQuestion
    public typealias Answer = Left.Answer
}
