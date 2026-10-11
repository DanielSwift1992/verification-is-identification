import VerificationIsIdentification

/// An encoding clause sees the sender's actual old record. The request
/// channel is fixed; its address does not disclose the record or message.
/// This clause alone does not assert that the chosen message is adequate.
public enum EncodeContactRequest<E: Pair, D: Structure, M: Structure>: PredicateReading {
    public typealias Left = AnswerFact<BeamSpace, SaturationEncoding, ContactRecordQuestion, Paired<E, D>>
    public typealias Right = M
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = AcquisitionChoice
    public typealias Answer = Right
}

/// Both coordinate instruments are prepared at the executor before any
/// request. The source occurs once; neither readiness chooses the question.
public typealias ContactProbePreparation<P: Pair> = TwoResidentReadings<ContactFirstBit<P>, ContactSecondBit<P>>.Left
where P.Right: Pair

/// Deliver the acquired request instrument to the executor while retaining
/// the sender's source record, the executor's policy and both probe slots.
/// This is a field rearrangement of one supplied whole.
public enum DeliverContactRequest<W: Pair>: Pair
where W.Left: Pair, W.Left.Left: Structure, W.Left.Right: Structure,
      W.Right: Pair, W.Right.Left: Structure, W.Right.Right: Structure {
    public typealias Left = W
    public typealias Right = Paired<W.Left.Left,
        Paired<W.Right.Left, Paired<W.Left.Right, W.Right.Right>>>
}

public enum LocalContactRequest<P: Pair, E: Pair, A: Structure, B: Structure,
    J: Pair, M: Structure>: PredicateReading
where P.Right: Pair {
    public typealias Request = EncodeContactRequest<E, Paired<A, B>, M>
    public typealias Instrument = PreparedTraceExtension<StartObservations<Request.Left>, Request>
    public typealias Send = StepBeside<Instrument, Paired<J, ContactProbePreparation<P>>>
    public typealias Delivery = DeliverContactRequest<Send.Right>
    public typealias Path = FollowedPair<Send, Delivery>
    public typealias Left = Send.Left
    public typealias Right = Delivery.Right
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = AcquisitionChoice
    public typealias Answer = Right

    public enum Endpoints: Null {
        public typealias Left = Paired<LocalContactRequest.Left, LocalContactRequest.Right>
        public typealias Right = Paired<Path.Left, Path.Right>
    }

    /// A view used to choose the probe: only the delivered value and the
    /// resident policy. Neither the sender's record nor the port is an input.
    public typealias Message = Right.Right.Right.Left.Right.Right.Right
    public typealias Memory = Paired<Message.Answer, Right.Right.Left>
    public typealias Prepared = Right.Right.Right.Right

    public enum ExecutorInput: PredicateReading {
        public typealias Left = LocalContactRequest.Right
        public typealias Right = Paired<Prepared, Memory>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = AcquisitionChoice
        public typealias Answer = Right
    }

    public enum RetainedRecord: PredicateReading {
        public typealias Left = LocalContactRequest.Right
        public typealias Right = Left.Left
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = ContactRecordQuestion
        public typealias Answer = Right
    }
}

/// The two clauses of ONE resident table. Table entries are actions, not
/// required answers. Sharing J shares these entries across global branches.
public enum LocalPolicyAtZero<J: Pair>: PredicateReading {
    public typealias Left = Paired<Never, J>
    public typealias Right = J.Left
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = AcquisitionChoice
    public typealias Answer = Right
}
public enum LocalPolicyAtOne<J: Pair>: PredicateReading {
    public typealias Left = Paired<Lit1, J>
    public typealias Right = J.Right
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = AcquisitionChoice
    public typealias Answer = Right
}

/// Rename both message symbols and both table positions together. These
/// are views of the actual local input, with no source or target annotation.
public enum RenameZeroLocalRequest<J: Pair>: PredicateReading
where J.Left: Structure, J.Right: Structure {
    public typealias Left = Paired<Never, J>
    public typealias Right = Paired<Lit1, SwapBoundaryReading<J>.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = AcquisitionChoice
    public typealias Answer = Right
}
public enum RenameOneLocalRequest<J: Pair>: PredicateReading
where J.Left: Structure, J.Right: Structure {
    public typealias Left = Paired<Lit1, J>
    public typealias Right = Paired<Never, SwapBoundaryReading<J>.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = AcquisitionChoice
    public typealias Answer = Right
}
public enum RenamedZeroLocalChoice<J: Pair>: ReadingFactors
where J.Left: Structure, J.Right: Structure {
    public typealias Left = LocalPolicyAtZero<J>
    public typealias Observation = RenameZeroLocalRequest<J>
    public typealias Right = LocalPolicyAtOne<Observation.Answer.Right>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = AcquisitionChoice
    public typealias Answer = Left.Answer
}
public enum RenamedOneLocalChoice<J: Pair>: ReadingFactors
where J.Left: Structure, J.Right: Structure {
    public typealias Left = LocalPolicyAtOne<J>
    public typealias Observation = RenameOneLocalRequest<J>
    public typealias Right = LocalPolicyAtZero<Observation.Answer.Right>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = AcquisitionChoice
    public typealias Answer = Left.Answer
}

/// Select one of the two ALREADY resident instruments. The other slot and
/// the port survive. No hidden preparation chooses an instrument for us.
public typealias FirstResidentContactProbe<P: Pair> = StepBeside<
    PreparedTraceExtension<StartObservations<P>, ContactFirstBit<P>>,
    PreparedTraceExtension<StartObservations<P>, ContactSecondBit<P>>.Left.Right
>
where P.Right: Pair
public typealias SecondResidentContactProbe<P: Pair> = FollowedPair<
    ExchangeResidentInstruments<ContactProbePreparation<P>>,
    StepBeside<PreparedTraceExtension<StartObservations<P>, ContactSecondBit<P>>,
        PreparedTraceExtension<StartObservations<P>, ContactFirstBit<P>>.Left.Right>
>
where P.Right: Pair

/// These four clauses bind the selected action to the actual table field.
/// No conclusion about successful answer recovery is among their premises.
public typealias LocalZeroFirstProbe<P: Pair, J: Pair> = StepBeside<FirstResidentContactProbe<P>, Paired<Never, J>>
where P.Right: Pair, J.Left == FirstProjection
public typealias LocalZeroSecondProbe<P: Pair, J: Pair> = StepBeside<SecondResidentContactProbe<P>, Paired<Never, J>>
where P.Right: Pair, J.Left == SecondProjection
public typealias LocalOneFirstProbe<P: Pair, J: Pair> = StepBeside<FirstResidentContactProbe<P>, Paired<Lit1, J>>
where P.Right: Pair, J.Right == FirstProjection
public typealias LocalOneSecondProbe<P: Pair, J: Pair> = StepBeside<SecondResidentContactProbe<P>, Paired<Lit1, J>>
where P.Right: Pair, J.Right == SecondProjection

/// Read the acquired fact at the focused instrument. Memory, source and
/// unused slot remain in the execution endpoint, outside this reply view.
public typealias LocalProbeReply<R: Pair> = R.Right.Left.Left.Right.Right.Right.Right
where R.Right: Pair, R.Right.Left: Pair, R.Right.Left.Left: Pair,
      R.Right.Left.Left.Right: Pair, R.Right.Left.Left.Right.Right: Pair,
      R.Right.Left.Left.Right.Right.Left == ExperimentSignal,
      R.Right.Left.Left.Right.Right.Right: Pair,
      R.Right.Left.Left.Right.Right.Right.Right: HasVerdict & Structure

public enum LocalZeroSecondReply<P: Pair, J: Pair>: PredicateReading
where P.Right: Pair, J.Left == SecondProjection {
    public typealias Run = LocalZeroSecondProbe<P, J>
    public typealias Left = Run.Left
    public typealias Right = LocalProbeReply<Run>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RecordReadingOperation
    public typealias Answer = Right
}
public enum LocalOneFirstReply<P: Pair, J: Pair>: PredicateReading
where P.Right: Pair, J.Right == FirstProjection {
    public typealias Run = LocalOneFirstProbe<P, J>
    public typealias Left = Run.Left
    public typealias Right = LocalProbeReply<Run>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RecordReadingOperation
    public typealias Answer = Right
}

/// Reconstruct the independent question's world from the actual initial
/// port and sender record. This is a verifier reading, not the local policy.
public enum ContactBeforeLocalRequest<P: Pair, E: Pair, A: Structure, B: Structure,
    J: Pair, M: Structure>: PredicateReading
where P.Right: Pair {
    public typealias Left = LocalContactRequest<P, E, A, B, J, M>.Left
    public typealias Right = Paired<Left.Right.Right.Left.Left, Left.Left.Left.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = FirstProjection
    public typealias Answer = Right
}

/// Focus the already prepared pair beside the retained sender record,
/// policy and received request. No component is copied or discarded.
public enum FocusPreparedContact<W: Pair>: Pair
where W.Left: Structure, W.Right: Pair, W.Right.Left: Structure,
      W.Right.Right: Pair, W.Right.Right.Left: Structure, W.Right.Right.Right: Structure {
    public typealias Left = W
    public typealias Right = Paired<W.Right.Right.Right,
        Paired<W.Left, Paired<W.Right.Left, W.Right.Right.Left>>>
}

/// The filled probe instrument returns to the sender's record. The port,
/// unused instrument, policy and request instrument stay at the executor.
public enum ReturnContactReply<W: Pair>: Pair
where W.Left: Pair, W.Left.Left: Pair,
      W.Left.Left.Left: Structure, W.Left.Left.Right: Structure, W.Left.Right: Structure,
      W.Right: Pair, W.Right.Left: Structure, W.Right.Right: Pair,
      W.Right.Right.Left: Structure, W.Right.Right.Right: Structure {
    public typealias Left = W
    public typealias Right = Paired<Paired<W.Right.Left, W.Left.Left.Right>,
        Paired<W.Left.Left.Left, Paired<W.Left.Right, W.Right.Right>>>
}

/// The receiver reads only its retained record and the returned instrument.
/// A readiness phase cannot be read as a received fact.
public enum ReturnedContactFacts<S: Pair>: PredicateReading
where S.Left: Structure, S.Right: Pair, S.Right.Right: Pair,
      S.Right.Right.Left == ExperimentSignal, S.Right.Right.Right: Pair,
      S.Right.Right.Right.Right: HasVerdict & Structure {
    public typealias Left = S
    public typealias Right = Paired<S.Left, S.Right.Right.Right.Right>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RecordReadingOperation
    public typealias Answer = Right
}

/// One zero request, one locally selected Second probe and one returned
/// reply. Exact intermediate whole objects compose all four relations.
public enum LocalSecondContactRun<P: Pair, E: Pair, A: Structure, B: Structure,
    J: Pair>: Pair
where P.Right: Pair, J.Left == SecondProjection {
    public typealias Request = LocalContactRequest<P, E, A, B, J, Never>
    public typealias Choice = LocalPolicyAtZero<Request.Right.Right.Left>
    public typealias Focus = FocusPreparedContact<Request.Right>
    public typealias Probe = StepBeside<SecondResidentContactProbe<P>, Focus.Right.Right>
    public typealias Return = ReturnContactReply<Probe.Right>
    public enum Prefix: Pair {
        public typealias Path = FollowedPair<FollowedPair<Request, Focus>, Probe>
        public typealias Left = Request.Left
        public typealias Right = Probe.Right
        public enum Endpoints: Null {
            public typealias Left = Paired<Prefix.Left, Prefix.Right>
            public typealias Right = Paired<Path.Left, Path.Right>
        }
    }
    public typealias Path = FollowedPair<Prefix, Return>
    public typealias Left = Prefix.Left
    public typealias Right = Return.Right

    public enum Endpoints: Null {
        public typealias Left = Paired<LocalSecondContactRun.Left, LocalSecondContactRun.Right>
        public typealias Right = Paired<Path.Left, Path.Right>
    }

    public enum ActualLocalChoice: Null {
        public typealias Left = Paired<Request.Memory, Choice.Answer>
        public typealias Right = Paired<Choice.Left, LocalProbeReply<Probe>.Predicate.Right>
    }
}

public enum LocalFirstContactRun<P: Pair, E: Pair, A: Structure, B: Structure,
    J: Pair>: Pair
where P.Right: Pair, J.Right == FirstProjection {
    public typealias Request = LocalContactRequest<P, E, A, B, J, Lit1>
    public typealias Choice = LocalPolicyAtOne<Request.Right.Right.Left>
    public typealias Focus = FocusPreparedContact<Request.Right>
    public typealias Probe = StepBeside<FirstResidentContactProbe<P>, Focus.Right.Right>
    public typealias Return = ReturnContactReply<Probe.Right>
    public enum Prefix: Pair {
        public typealias Path = FollowedPair<FollowedPair<Request, Focus>, Probe>
        public typealias Left = Request.Left
        public typealias Right = Probe.Right
        public enum Endpoints: Null {
            public typealias Left = Paired<Prefix.Left, Prefix.Right>
            public typealias Right = Paired<Path.Left, Path.Right>
        }
    }
    public typealias Path = FollowedPair<Prefix, Return>
    public typealias Left = Prefix.Left
    public typealias Right = Return.Right

    public enum Endpoints: Null {
        public typealias Left = Paired<LocalFirstContactRun.Left, LocalFirstContactRun.Right>
        public typealias Right = Paired<Path.Left, Path.Right>
    }

    public enum ActualLocalChoice: Null {
        public typealias Left = Paired<Request.Memory, Choice.Answer>
        public typealias Right = Paired<Choice.Left, LocalProbeReply<Probe>.Predicate.Right>
    }
}

public enum ContactLocalZeroEvidence<P: Pair, E: Pair, A: Structure, B: Structure,
    J: Pair>: PredicateReading
where P.Right: Pair, J.Left == SecondProjection {
    public typealias Run = LocalSecondContactRun<P, E, A, B, J>
    public typealias Left = Run.Left
    public typealias Right = ReturnedContactFacts<Run.Right.Left>.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RecordReadingOperation
    public typealias Answer = Right
}

public enum ContactLocalOneEvidence<P: Pair, E: Pair, A: Structure, B: Structure,
    J: Pair>: PredicateReading
where P.Right: Pair, J.Right == FirstProjection {
    public typealias Run = LocalFirstContactRun<P, E, A, B, J>
    public typealias Left = Run.Left
    public typealias Right = ReturnedContactFacts<Run.Right.Left>.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RecordReadingOperation
    public typealias Answer = Right
}

/// The original endpoint questions meet the acquired reply through the
/// old decoders. One J is used at both source cases and every such seam.
public enum LocalSecondForward<P: Pair, T: Pair, A: Structure, B: Structure,
    J: Pair>: ReadingFactors
where P.Left: Structure, T.Left: Structure, P.Right: Pair, T.Right: Pair,
      P.Right.Right == Never, T.Right.Right == Lit1, J.Left == SecondProjection {
    public typealias E = Paired<P.Left, T.Left>
    public typealias SourceP = ContactBeforeLocalRequest<P, E, A, B, J, Never>
    public typealias SourceT = ContactBeforeLocalRequest<T, E, A, B, J, Never>
    public typealias DirectP = DecodeRefinedEvidence<SourceP, ContactLeftValue<SourceP.Answer>>
    public typealias DirectT = DecodeRefinedEvidence<SourceT, ContactRightValue<SourceT.Answer>>
    public typealias Left = PairedApplication<DirectP, DirectT>
    public typealias Observation = PairedApplication<ContactLocalZeroEvidence<P, E, A, B, J>, ContactLocalZeroEvidence<T, E, A, B, J>>
    public typealias Original = ContactSecondInquiryForward<P, T, A, B>
    public typealias Right = Original.Right
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Left.Predicate
    public typealias Answer = Left.Answer
}

public enum LocalSecondBackward<P: Pair, T: Pair, A: Structure, B: Structure,
    J: Pair>: ReadingFactors
where P.Left: Structure, T.Left: Structure, P.Right: Pair, T.Right: Pair,
      P.Right.Right == Lit1, T.Right.Right == Never, J.Left == SecondProjection {
    public typealias E = Paired<P.Left, T.Left>
    public typealias SourceP = ContactBeforeLocalRequest<P, E, A, B, J, Never>
    public typealias SourceT = ContactBeforeLocalRequest<T, E, A, B, J, Never>
    public typealias DirectP = DecodeRefinedEvidence<SourceP, ContactLeftValue<SourceP.Answer>>
    public typealias DirectT = DecodeRefinedEvidence<SourceT, ContactRightValue<SourceT.Answer>>
    public typealias Left = PairedApplication<DirectP, DirectT>
    public typealias Observation = PairedApplication<ContactLocalZeroEvidence<P, E, A, B, J>, ContactLocalZeroEvidence<T, E, A, B, J>>
    public typealias Original = ContactSecondInquiryBackward<P, T, A, B>
    public typealias Right = Original.Right
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Left.Predicate
    public typealias Answer = Left.Answer
}

public enum LocalFirstBackward<P: Pair, T: Pair, A: Structure, B: Structure,
    J: Pair>: ReadingFactors
where P.Left: Structure, T.Left: Structure, P.Right: Pair, T.Right: Pair,
      P.Right.Left == Lit1, T.Right.Left == Never, J.Right == FirstProjection {
    public typealias E = Paired<P.Left, T.Left>
    public typealias SourceP = ContactBeforeLocalRequest<P, E, A, B, J, Lit1>
    public typealias SourceT = ContactBeforeLocalRequest<T, E, A, B, J, Lit1>
    public typealias DirectP = DecodeRefinedEvidence<SourceP, ContactLeftValue<SourceP.Answer>>
    public typealias DirectT = DecodeRefinedEvidence<SourceT, ContactRightValue<SourceT.Answer>>
    public typealias Left = PairedApplication<DirectP, DirectT>
    public typealias Observation = PairedApplication<ContactLocalOneEvidence<P, E, A, B, J>, ContactLocalOneEvidence<T, E, A, B, J>>
    public typealias Original = ContactFirstInquiryBackward<P, T, A, B>
    public typealias Right = Original.Right
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Left.Predicate
    public typealias Answer = Left.Answer
}

public enum LocalFirstForward<P: Pair, T: Pair, A: Structure, B: Structure,
    J: Pair>: ReadingFactors
where P.Left: Structure, T.Left: Structure, P.Right: Pair, T.Right: Pair,
      P.Right.Left == Never, T.Right.Left == Lit1, J.Right == FirstProjection {
    public typealias E = Paired<P.Left, T.Left>
    public typealias SourceP = ContactBeforeLocalRequest<P, E, A, B, J, Lit1>
    public typealias SourceT = ContactBeforeLocalRequest<T, E, A, B, J, Lit1>
    public typealias DirectP = DecodeRefinedEvidence<SourceP, ContactLeftValue<SourceP.Answer>>
    public typealias DirectT = DecodeRefinedEvidence<SourceT, ContactRightValue<SourceT.Answer>>
    public typealias Left = PairedApplication<DirectP, DirectT>
    public typealias Observation = PairedApplication<ContactLocalOneEvidence<P, E, A, B, J>, ContactLocalOneEvidence<T, E, A, B, J>>
    public typealias Original = ContactFirstInquiryForward<P, T, A, B>
    public typealias Right = Original.Right
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Left.Predicate
    public typealias Answer = Left.Answer
}

public enum LocalContactCycle<A: Structure, B: Structure, J: Pair>: Close
where J.Left == SecondProjection, J.Right == FirstProjection {
    public typealias Seam01 = LocalSecondForward<ContactPort0, ContactPort1, A, B, J>
    public typealias Seam12 = LocalSecondBackward<ContactPort1, ContactPort2, A, B, J>
    public typealias Seam23 = LocalSecondForward<ContactPort2, ContactPort3, A, B, J>
    public typealias Seam34 = LocalSecondBackward<ContactPort3, ContactPort4, A, B, J>
    public typealias OtherSeam34 = LocalFirstForward<ContactPort3, ContactPort4, A, B, J>
    public typealias Seam40 = LocalFirstBackward<ContactPort4, ContactPort0, A, B, J>
}

/// Exchange the actual port in the prepared request whole with a resident
/// reserve. Both probe preparations, the record and the policy stay intact.
/// The displaced port is returned at the reserve address.
public enum ExchangePreparedContactPort<W: Pair, T: Structure>: Pair
where W.Left: Structure, W.Right: Pair, W.Right.Left: Structure,
      W.Right.Right: Pair, W.Right.Right.Left: Pair,
      W.Right.Right.Left.Left: Structure, W.Right.Right.Left.Right: Structure,
      W.Right.Right.Right: Structure {
    public typealias Left = Paired<W, T>
    public typealias Right = Paired<
        Paired<W.Left, Paired<W.Right.Left,
            Paired<Paired<T, W.Right.Right.Left.Right>, W.Right.Right.Right>>>,
        W.Right.Right.Left.Left>
}

/// A completed local run beside an untouched reserve returns its acquired
/// facts at this actual receiver address. The reserve is not a decoder input.
public enum ReservedContactReply<R: Pair>: PredicateReading
where R.Right: Pair, R.Right.Left: Pair, R.Right.Left.Left: Pair,
      R.Right.Left.Left.Left: Structure, R.Right.Left.Left.Right: Pair,
      R.Right.Left.Left.Right.Right: Pair,
      R.Right.Left.Left.Right.Right.Left == ExperimentSignal,
      R.Right.Left.Left.Right.Right.Right: Pair,
      R.Right.Left.Left.Right.Right.Right.Right: HasVerdict & Structure {
    public typealias Left = R.Left
    public typealias Right = ReturnedContactFacts<R.Right.Left.Left>.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RecordReadingOperation
    public typealias Answer = Right
}

public enum LocalExchangeFromFirst<A: Structure, B: Structure, J: Pair>: ReadingFactors
where J.Left == SecondProjection {
    public typealias Before = ContactBeforeLocalRequest<ContactPort0, ContactSeam01, A, B, J, Never>
    public typealias Exchange = ExchangePreparedContactPort<Before.Left, ContactPort1>
    public typealias Continue = StepBeside<LocalSecondContactRun<ContactPort1, ContactSeam01, A, B, J>, ContactPort0>
    public typealias Whole = FollowedPair<Exchange, Continue>
    public typealias Left = DecodeRefinedEvidence<
        FirstEvidenceImage<Whole.Left, BeamSpace, SaturationEncoding, FirstProjection>,
        DecodeRefinedEvidence<Before, ContactLeftValue<Before.Answer>>>
    public typealias Observation = ReservedContactReply<Whole>
    public typealias Right = ContactInquiryAfterExchange<A, B>.Right
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RoutedValueQuestion
    public typealias Answer = Left.Answer
}

public enum LocalExchangeFromSecond<A: Structure, B: Structure, J: Pair>: ReadingFactors
where J.Left == SecondProjection {
    public typealias Before = ContactBeforeLocalRequest<ContactPort1, ContactSeam01, A, B, J, Never>
    public typealias Exchange = ExchangePreparedContactPort<Before.Left, ContactPort0>
    public typealias Continue = StepBeside<LocalSecondContactRun<ContactPort0, ContactSeam01, A, B, J>, ContactPort1>
    public typealias Whole = FollowedPair<Exchange, Continue>
    public typealias Left = DecodeRefinedEvidence<
        FirstEvidenceImage<Whole.Left, BeamSpace, SaturationEncoding, FirstProjection>,
        DecodeRefinedEvidence<Before, ContactRightValue<Before.Answer>>>
    public typealias Observation = ReservedContactReply<Whole>
    public typealias Right = ContactInquiryFromSecondEndpoint<A, B>.Right
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RoutedValueQuestion
    public typealias Answer = Left.Answer
}
