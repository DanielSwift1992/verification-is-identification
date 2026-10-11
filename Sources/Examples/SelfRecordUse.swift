import VerificationIsIdentification

public enum SelfRecordSpace: Close {}
public enum SelfRecordEncoding: Close {}
public enum SelfRecordAdvanceQuestion: Close {}
public enum SelfRecordProbeQuestion: Close {}
public enum SelfRecordRestoreQuestion: Close {}

/// Two currently addressed pairs and a remainder inside the same carrier.
public typealias SelfRecordState<X: Pair, M: Pair, H: Structure> =
    Paired<Paired<X, M>, H>

/// The working pair drives the next value. The other input is retained.
public enum AdvanceFromWorking<S: Pair>: PredicateReading
where S.Left: Pair, S.Left.Left: Pair, S.Left.Right: Pair,
      S.Left.Left.Left: Structure, S.Left.Left.Right: Structure,
      S.Right: Structure {
    public typealias Changed = SwapBoundaryReading<S.Left.Left>.Answer
    public typealias Left = S
    public typealias Right = SelfRecordState<Changed, Changed, Paired<S.Left.Right, S.Right>>
    public typealias Sigma = SelfRecordSpace
    public typealias Encoding = SelfRecordEncoding
    public typealias Predicate = SelfRecordAdvanceQuestion
    public typealias Answer = Right
}

/// The record pair drives the next value. The working input is retained.
public enum AdvanceFromRecord<S: Pair>: PredicateReading
where S.Left: Pair, S.Left.Left: Pair, S.Left.Right: Pair,
      S.Left.Right.Left: Structure, S.Left.Right.Right: Structure,
      S.Right: Structure {
    public typealias Changed = SwapBoundaryReading<S.Left.Right>.Answer
    public typealias Left = S
    public typealias Right = SelfRecordState<Changed, Changed, Paired<S.Left.Left, S.Right>>
    public typealias Sigma = SelfRecordSpace
    public typealias Encoding = SelfRecordEncoding
    public typealias Predicate = SelfRecordAdvanceQuestion
    public typealias Answer = Right
}

/// Change the record while retaining working contents and the old remainder.
public enum PerturbSelfRecord<S: Pair>: PredicateReading
where S.Left: Pair, S.Left.Left: Pair, S.Left.Right: Pair,
      S.Left.Right.Left: Structure, S.Left.Right.Right: Structure,
      S.Right: Structure {
    public typealias Left = S
    public typealias Right = SelfRecordState<S.Left.Left,
        SwapBoundaryReading<S.Left.Right>.Answer, S.Right>
    public typealias Sigma = SelfRecordSpace
    public typealias Encoding = SelfRecordEncoding
    public typealias Predicate = SelfRecordProbeQuestion
    public typealias Answer = Right
}

/// Both inverses read only the actual output and its retained remainder.
/// Equal working/record fields characterize the presented output family.
public enum RestoreWorkingDriven<T: Pair>: PredicateReading
where T.Left: Pair, T.Left.Left: Pair, T.Left.Left == T.Left.Right,
      T.Left.Left.Left: Structure, T.Left.Left.Right: Structure,
      T.Right: Pair, T.Right.Left: Pair, T.Right.Right: Structure {
    public typealias Left = T
    public typealias Right = SelfRecordState<SwapBoundaryReading<T.Left.Left>.Answer,
        T.Right.Left, T.Right.Right>
    public typealias Sigma = SelfRecordSpace
    public typealias Encoding = SelfRecordEncoding
    public typealias Predicate = SelfRecordRestoreQuestion
    public typealias Answer = Right
}

public enum RestoreRecordDriven<T: Pair>: PredicateReading
where T.Left: Pair, T.Left.Left: Pair, T.Left.Left == T.Left.Right,
      T.Left.Left.Left: Structure, T.Left.Left.Right: Structure,
      T.Right: Pair, T.Right.Left: Pair, T.Right.Right: Structure {
    public typealias Left = T
    public typealias Right = SelfRecordState<T.Right.Left,
        SwapBoundaryReading<T.Left.Left>.Answer, T.Right.Right>
    public typealias Sigma = SelfRecordSpace
    public typealias Encoding = SelfRecordEncoding
    public typealias Predicate = SelfRecordRestoreQuestion
    public typealias Answer = Right
}

/// A faithful current record hides which dependency drives the next step.
/// The common result is again faithful, so the paper's induction covers
/// every finite normal continuation, including the retained remainders.
public enum FaithfulSelfRecordStep<A: Structure, B: Structure, H: Structure>: Null {
    public typealias X = Paired<A, B>
    public typealias Source = SelfRecordState<X, X, H>
    public typealias Direct = AdvanceFromWorking<Source>
    public typealias Feedback = AdvanceFromRecord<Source>
    public typealias Left = Direct.Answer
    public typealias Right = Feedback.Answer
}

/// The original pair is a prepared internal reference, retained by the
/// probe and both candidate advances. No absolute names are used to compare
/// the resulting pair with it. Preparation/copying is an explicit input.
public enum SelfRecordProbe<A: Structure, B: Structure, H: Structure>: Close {
    public typealias X = Paired<A, B>
    public typealias Source = SelfRecordState<X, X, Paired<X, H>>
    public typealias Probe = PerturbSelfRecord<Source>
    public typealias Direct = SequentialReading<Probe, AdvanceFromWorking<Probe.Answer>>
    public typealias Feedback = SequentialReading<Probe, AdvanceFromRecord<Probe.Answer>>
    public enum DirectSwapsReference: Null {
        public typealias Left = Direct.Answer.Left.Left
        public typealias Right = SwapBoundaryReading<Direct.Answer.Right.Right.Left>.Answer
    }
    public enum FeedbackReturnsReference: Null {
        public typealias Left = Feedback.Answer.Left.Left
        public typealias Right = Feedback.Answer.Right.Right.Left
    }
}
