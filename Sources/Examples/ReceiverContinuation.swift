import VerificationIsIdentification

/// Read the answer already obtained by this receiver. This neither acquires
/// another source nor reapplies R to its original input.
public enum ReceiverRecordedAnswer<R: PredicateReading>: PredicateReading, Null {
    public typealias Left = R.Answer
    public typealias Right = Left
    public typealias Sigma = R.Sigma
    public typealias Encoding = R.Encoding
    public typealias Predicate = R.Predicate
    public typealias Answer = Right
}

/// The connected use determines the answer. No independent Question/Answer
/// field or final equality is supplied to this constructor.
public enum ReceiverAnswerIsAvailable<R: PredicateReading>: ReadingFactors {
    public typealias Left = R
    public typealias Observation = R
    public typealias Right = ReceiverRecordedAnswer<R>
    public typealias Sigma = R.Sigma
    public typealias Encoding = R.Encoding
    public typealias Predicate = R.Predicate
    public typealias Answer = R.Answer
}

/// A sufficient construction reapplying the SAME bound receiver. Its input
/// requirement comes from R.Left; F recovers that input, not just R.Answer.
/// Full input recovery is not claimed minimal for every use. The supplied
/// readings and factors retain their existing interpretation obligations.
public enum ReapplyReceiverAfterRecovery<R: PredicateReading, F: ReadingFactors>: ReadingFactors
where F.Left == IdentityReading<R.Left, R.Sigma, R.Encoding> {
    public typealias Left = R
    public typealias Observation = F.Observation
    public typealias Right = DecodeRefinedEvidence<F.Right, R>
    public typealias Actual = SequentialReading<F.Right, R>
    public typealias Sigma = R.Sigma
    public typealias Encoding = R.Encoding
    public typealias Predicate = R.Predicate
    public typealias Answer = R.Answer
}

/// Decode the original identity question after an earlier exchange. The
/// decoder's actual exchange is explicit; the predicate names its source query.
public enum RecoverSwappedPair<M: Pair>: PredicateReading
where M.Left: Structure, M.Right: Structure {
    public typealias Actual = SwapBoundaryReading<M>
    public typealias Left = Actual.Left
    public typealias Right = Actual.Answer
    public typealias Sigma = Actual.Sigma
    public typealias Encoding = Actual.Encoding
    public typealias Predicate = IdentityOperation
    public typealias Answer = Right
}

public enum SwappedPairRecoversInput<A: Structure, B: Structure>: ReadingFactors {
    public typealias Source = Paired<A, B>
    public typealias Left = IdentityReading<Source, BeamSpace, SaturationEncoding>
    public typealias Observation = SwapBoundaryReading<Source>
    public typealias Right = RecoverSwappedPair<Observation.Answer>
    public typealias Sigma = Left.Sigma
    public typealias Encoding = Left.Encoding
    public typealias Predicate = Left.Predicate
    public typealias Answer = Left.Answer
}

/// Selecting the first or second receiver derives A or B. Equality between
/// those answers is not guaranteed without A == B. Both compositions use the
/// same recovered boundary; no second target description is supplied.
public enum RecoveredPairUses<A: Structure, B: Structure>: Pair {
    public typealias Recovery = SwappedPairRecoversInput<A, B>
    public typealias First = FirstEvidenceImage<Recovery.Source,
        BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Second = SecondEvidenceImage<Recovery.Source,
        BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Left = ReapplyReceiverAfterRecovery<First, Recovery>
    public typealias Right = ReapplyReceiverAfterRecovery<Second, Recovery>
}
