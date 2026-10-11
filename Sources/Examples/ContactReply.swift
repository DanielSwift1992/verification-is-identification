import VerificationIsIdentification

/// Read the actual acquired payload into one fixed reply channel. The
/// probe's coordinate address stays in the source instrument, outside it.
public enum ContactReplyBit<F: Pair>: PredicateReading
where F.Right: Pair, F.Right.Left == ExperimentSignal,
      F.Right.Right: Pair, F.Right.Right.Right: HasVerdict & Structure {
    public typealias Left = F
    public typealias Right = F.Right.Right.Right.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RecordReadingOperation
    public typealias Answer = Right
}

/// Restore a fixed question address beside the received value. This alone
/// does not authorize choosing Q from information absent at the receiver.
/// Recover below proves its use for a supplied constant channel law.
public enum ContactReplyWithQuestion<M: Pair, Q: Structure>: PredicateReading
where M.Left: Structure, M.Right: HasVerdict & Structure,
      M.Right.Sigma == BeamSpace, M.Right.Encoding == SaturationEncoding,
      M.Right.Predicate == RecordReadingOperation {
    public typealias Left = M
    public typealias Right = Paired<M.Left,
        AnswerFact<BeamSpace, SaturationEncoding, Q, M.Right.Answer>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RecordReadingOperation
    public typealias Answer = Right
}

/// Continue a dispatched probe with a separately prepared reply carrier.
/// Only that carrier moves back. The probe's full record and the port stay
/// at the executor. R must supply the actual post-probe whole structure.
public enum ContactReplyCarrier<R: Pair>: Pair
where R.Left: Structure, R.Right: Pair,
      R.Right.Left: Pair, R.Right.Left.Left: Pair,
      R.Right.Left.Left.Left: Structure, R.Right.Left.Left.Right: Pair,
      R.Right.Left.Left.Right.Right: Pair,
      R.Right.Left.Left.Right.Right.Left == ExperimentSignal,
      R.Right.Left.Left.Right.Right.Right: Pair,
      R.Right.Left.Left.Right.Right.Right.Right: HasVerdict & Structure,
      R.Right.Left.Right: Structure,
      R.Right.Right: Pair, R.Right.Right.Left: Structure,
      R.Right.Right.Right: Structure {
    public typealias ProbeRecord = R.Right.Left.Left.Right
    public typealias Reading = ContactReplyBit<ProbeRecord>
    public typealias Transmission = PreparedTraceExtension<StartObservations<ProbeRecord>, Reading>
    public typealias Prefix = StepBeside<R, Transmission.Left.Right>

    public enum Focus: Pair {
        public typealias Left = Prefix.Right
        public typealias Right = Paired<Paired<ProbeRecord, Transmission.Left.Right>,
            Paired<R.Right.Left.Left.Left, Paired<R.Right.Left.Right, R.Right.Right>>>
    }
    public typealias Acquire = StepBeside<Transmission, Focus.Right.Right>

    public enum Return: Pair {
        public typealias Left = Acquire.Right
        public typealias Right = Paired<Paired<Left.Right.Right.Right.Left, Left.Left.Right>,
            Paired<Left.Right.Left, Paired<Left.Left.Left,
                Paired<Left.Right.Right.Left, Left.Right.Right.Right.Right>>>>
    }
    public typealias Path = FollowedPair<FollowedPair<FollowedPair<Prefix, Focus>, Acquire>, Return>
    public typealias Left = Prefix.Left
    public typealias Right = Return.Right

    public enum Endpoints: Null {
        public typealias Left = Paired<ContactReplyCarrier.Left, ContactReplyCarrier.Right>
        public typealias Right = Paired<Path.Left, Path.Right>
    }

    public enum Receiver: PredicateReading {
        public typealias Left = ContactReplyCarrier.Left
        public typealias Right = ReturnedContactFacts<ContactReplyCarrier.Right.Left>.Answer
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = RecordReadingOperation
        public typealias Answer = Right
    }

    /// The actual record and acquired probe fact before transmission.
    /// This source reading is used by the proof, not by the receiver.
    public enum ProbeFacts: PredicateReading {
        public typealias Left = ContactReplyCarrier.Left
        public typealias Right = Paired<R.Right.Right.Left, ProbeRecord.Right.Right.Right>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = RecordReadingOperation
        public typealias Answer = Right
    }

    public enum Recover<Q: Structure, Bit>: ReadingFactors
    where ProbeRecord.Right.Right.Right == AnswerFact<BeamSpace, SaturationEncoding, Q, Bit> {
        public typealias Left = ProbeFacts
        public typealias Observation = Receiver
        public typealias Right = ContactReplyWithQuestion<Observation.Answer, Q>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = RecordReadingOperation
        public typealias Answer = Left.Answer
    }
}

public typealias ContactSecondBitReturn<P: Pair, E: Pair, A: Structure,
    B: Structure, J: Pair> = ContactReplyCarrier<LocalSecondContactRun<P, E, A, B, J>.Prefix>
where P.Right: Pair, J.Left == SecondProjection

public typealias ContactFirstBitReturn<P: Pair, E: Pair, A: Structure,
    B: Structure, J: Pair> = ContactReplyCarrier<LocalFirstContactRun<P, E, A, B, J>.Prefix>
where P.Right: Pair, J.Right == FirstProjection

/// Assemble the existing source factor and reply recovery through the
/// shared composition theorem. Each Proof preserves the original question.
public enum ContactSecondBitForward<P: Pair, T: Pair, A: Structure,
    B: Structure, J: Pair>: Close
where P.Left: Structure, T.Left: Structure, P.Right: Pair, T.Right: Pair,
      P.Right.Right == Never, T.Right.Right == Lit1, J.Left == SecondProjection {
    public typealias Original = LocalSecondForward<P, T, A, B, J>
    public typealias X = ContactSecondBitReturn<P, Original.E, A, B, J>
    public typealias Y = ContactSecondBitReturn<T, Original.E, A, B, J>
    public typealias Before = PairedApplication<
        FirstEvidenceImage<X.Left, BeamSpace, SaturationEncoding, FirstProjection>,
        FirstEvidenceImage<Y.Left, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Recovery = PairedFactorization<
        X.Recover<OperationSequence<ContactCalibrationQuestion, SecondProjection>, Never>,
        Y.Recover<OperationSequence<ContactCalibrationQuestion, SecondProjection>, Lit1>>
    public typealias Proof = AnswerOnSourceRecovery<Original, Before, Recovery>
}

public enum ContactSecondBitBackward<P: Pair, T: Pair, A: Structure,
    B: Structure, J: Pair>: Close
where P.Left: Structure, T.Left: Structure, P.Right: Pair, T.Right: Pair,
      P.Right.Right == Lit1, T.Right.Right == Never, J.Left == SecondProjection {
    public typealias Original = LocalSecondBackward<P, T, A, B, J>
    public typealias X = ContactSecondBitReturn<P, Original.E, A, B, J>
    public typealias Y = ContactSecondBitReturn<T, Original.E, A, B, J>
    public typealias Before = PairedApplication<
        FirstEvidenceImage<X.Left, BeamSpace, SaturationEncoding, FirstProjection>,
        FirstEvidenceImage<Y.Left, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Recovery = PairedFactorization<
        X.Recover<OperationSequence<ContactCalibrationQuestion, SecondProjection>, Lit1>,
        Y.Recover<OperationSequence<ContactCalibrationQuestion, SecondProjection>, Never>>
    public typealias Proof = AnswerOnSourceRecovery<Original, Before, Recovery>
}

public enum ContactFirstBitForward<P: Pair, T: Pair, A: Structure,
    B: Structure, J: Pair>: Close
where P.Left: Structure, T.Left: Structure, P.Right: Pair, T.Right: Pair,
      P.Right.Left == Never, T.Right.Left == Lit1, J.Right == FirstProjection {
    public typealias Original = LocalFirstForward<P, T, A, B, J>
    public typealias X = ContactFirstBitReturn<P, Original.E, A, B, J>
    public typealias Y = ContactFirstBitReturn<T, Original.E, A, B, J>
    public typealias Before = PairedApplication<
        FirstEvidenceImage<X.Left, BeamSpace, SaturationEncoding, FirstProjection>,
        FirstEvidenceImage<Y.Left, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Recovery = PairedFactorization<
        X.Recover<OperationSequence<ContactCalibrationQuestion, FirstProjection>, Never>,
        Y.Recover<OperationSequence<ContactCalibrationQuestion, FirstProjection>, Lit1>>
    public typealias Proof = AnswerOnSourceRecovery<Original, Before, Recovery>
}

public enum ContactFirstBitBackward<P: Pair, T: Pair, A: Structure,
    B: Structure, J: Pair>: Close
where P.Left: Structure, T.Left: Structure, P.Right: Pair, T.Right: Pair,
      P.Right.Left == Lit1, T.Right.Left == Never, J.Right == FirstProjection {
    public typealias Original = LocalFirstBackward<P, T, A, B, J>
    public typealias X = ContactFirstBitReturn<P, Original.E, A, B, J>
    public typealias Y = ContactFirstBitReturn<T, Original.E, A, B, J>
    public typealias Before = PairedApplication<
        FirstEvidenceImage<X.Left, BeamSpace, SaturationEncoding, FirstProjection>,
        FirstEvidenceImage<Y.Left, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Recovery = PairedFactorization<
        X.Recover<OperationSequence<ContactCalibrationQuestion, FirstProjection>, Lit1>,
        Y.Recover<OperationSequence<ContactCalibrationQuestion, FirstProjection>, Never>>
    public typealias Proof = AnswerOnSourceRecovery<Original, Before, Recovery>
}
public enum ContactBitCycle<A: Structure, B: Structure, J: Pair>: Close
where J.Left == SecondProjection, J.Right == FirstProjection {
    public typealias Seam01 = ContactSecondBitForward<ContactPort0, ContactPort1, A, B, J>
    public typealias Seam12 = ContactSecondBitBackward<ContactPort1, ContactPort2, A, B, J>
    public typealias Seam23 = ContactSecondBitForward<ContactPort2, ContactPort3, A, B, J>
    public typealias Seam34 = ContactSecondBitBackward<ContactPort3, ContactPort4, A, B, J>
    public typealias OtherSeam34 = ContactFirstBitForward<ContactPort3, ContactPort4, A, B, J>
    public typealias Seam40 = ContactFirstBitBackward<ContactPort4, ContactPort0, A, B, J>
}
