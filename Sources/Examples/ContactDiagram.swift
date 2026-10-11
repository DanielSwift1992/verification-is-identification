import VerificationIsIdentification

/// A finite graph constraint: two applications of the actual common Left
/// contact return to this node. It does not require a one-step return.
public protocol TwoStepContactReturn: Pair
where Left: Pair, Left.Left == Self {}

/// The third return is a further observed equation, not an inverse law.
public protocol TwoAndThreeStepReturn: TwoStepContactReturn
where Left.Left.Left == Self {}

/// The shared contact transports the two-step identity by one step.
/// Combining it with the third return forces a one-step identity.
public enum ReturnsForceFixedPoint<T: TwoAndThreeStepReturn>: Null {
    public typealias Left = T
    public typealias Right = T.Left
}

/// If the first contact returned in one step, a reading through the actual
/// common Right contact would have to give the same answer at both nodes.
public enum FixedPointForcesSecondReading<T: Pair>: Null
where T.Left == T {
    public typealias Left = T.Right
    public typealias Right = T.Left.Right
}

public enum TwoStepReturnQuestion: Close {}

/// An admitted positive comparison branch. Its actual iterated projection
/// and its identity reading are equated before the true bit is recorded.
public enum ReadTwoStepReturn<T: TwoStepContactReturn>: PredicateReading {
    public typealias First = FirstEvidenceImage<T, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Next = FirstEvidenceImage<T.Left, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Twice = SequentialReading<First, Next>
    public typealias Original = IdentityReading<T, BeamSpace, SaturationEncoding>
    public enum ActualEquality: Null {
        public typealias Left = Twice.Answer
        public typealias Right = Original.Answer
    }
    public typealias Left = T
    public typealias Right = Lit1
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = TwoStepReturnQuestion
    public typealias Answer = Right
}

/// The same finite contact diagram admits both this one-point realization
/// and the following two-point realization. These are not two actual worlds.
public enum FixedContactModel: TwoAndThreeStepReturn {
    public typealias Left = FixedContactModel
    public typealias Right = Never
}

public enum AlternatingContactModel: TwoStepContactReturn {
    public enum Other: TwoStepContactReturn {
        public typealias Left = AlternatingContactModel
        public typealias Right = Lit1
    }
    public typealias Left = Other
    public typealias Right = Never
}

public enum UnsettledContactIdentity: Close {
    public typealias FixedReading = ReadTwoStepReturn<FixedContactModel>
    public typealias AlternatingReading = ReadTwoStepReturn<AlternatingContactModel>
    public typealias FixedRecord = RecordReading<FixedReading>
    public typealias AlternatingRecord = RecordReading<AlternatingReading>
    public enum SameAcquiredFact: Null {
        public typealias Left = FixedRecord.Right.Right
        public typealias Right = AlternatingRecord.Right.Right
    }
    public enum FixedIdentity: Null {
        public typealias Left = FixedContactModel
        public typealias Right = FixedContactModel.Left
    }
    public typealias OriginalSecond = SecondEvidenceImage<AlternatingContactModel,
        BeamSpace, SaturationEncoding, SecondProjection>
    public typealias FirstContact = FirstEvidenceImage<AlternatingContactModel,
        BeamSpace, SaturationEncoding, FirstProjection>
    public typealias NextSecond = SequentialReading<FirstContact,
        SecondEvidenceImage<FirstContact.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Contrast = ZeroSuccessorDistinction<Never>
    public enum AlternatingContrast: Null {
        public typealias Left = Paired<OriginalSecond.Answer, NextSecond.Answer>
        public typealias Right = Paired<Contrast.Left, Contrast.Right>
    }
}

/// Matching the two supplied successors does not exclude another internal
/// reading. The additional Answer field supplies a positive distinction;
/// different nominal spellings alone are not the witness used here.
public enum MatchingSuccessorsModel: Pair {
    public enum Node<V: Structure>: Pair, HasVerdict {
        public typealias Left = Never
        public typealias Right = Never
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = GivenDistinctionQuestion
        public typealias Answer = V
    }
    public enum GivenDistinctionQuestion: Close {}
    public typealias A = Node<Never>
    public typealias B = Node<Lit1>
    public typealias Left = A
    public typealias Right = B
    public enum SameSuccessors: Null {
        public typealias Left = Paired<A.Left, A.Right>
        public typealias Right = Paired<B.Left, B.Right>
    }
    public typealias ProbeA = ReadRecordedAnswer<A>
    public typealias ProbeB = ReadRecordedAnswer<B>
    public enum AdditionalReadingSeparates: Null {
        public typealias Left = Paired<ProbeA.Answer, ProbeB.Answer>
        public typealias Right = Paired<Never, Lit1>
    }
}
