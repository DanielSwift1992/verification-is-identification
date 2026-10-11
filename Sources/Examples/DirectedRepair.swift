import VerificationIsIdentification

// A finite relational model motivated by M64aw's repair experiment. These
// are interface roles, not molecular species or a complete biochemical law.
public enum ProtectedFirst: Close {}
public enum ProtectedSecond: Close {}
public enum RepairClosed: Close {}
public enum RepairFirstOpen: Close {}
public enum RepairSecondOpen: Close {}
public enum RepairSpace: Close {}
public enum RepairEncoding: Close {}
public enum OpenRepairAction: Close {}
public enum TransferRepairAction: Close {}
public enum RestoreRepairAction: Close {}
public enum SealRepairAction: Close {}

/// Current contents, attached selection relation, actual access, retained
/// remainder. The remainder is inside the model, not outside the whole.
public typealias RepairSurface<P: Pair, M: Structure, O: Structure, H: Structure> =
    Paired<P, Paired<M, Paired<O, H>>>

public enum OpenSecondAgainstFirst<P: Pair, H: Structure>: PredicateReading {
    public typealias Left = RepairSurface<P, ProtectedFirst, RepairClosed, H>
    public typealias Right = RepairSurface<P, ProtectedFirst, RepairSecondOpen, H>
    public typealias Sigma = RepairSpace
    public typealias Encoding = RepairEncoding
    public typealias Predicate = OpenRepairAction
    public typealias Answer = Right
}

public enum OpenFirstAgainstSecond<P: Pair, H: Structure>: PredicateReading {
    public typealias Left = RepairSurface<P, ProtectedSecond, RepairClosed, H>
    public typealias Right = RepairSurface<P, ProtectedSecond, RepairFirstOpen, H>
    public typealias Sigma = RepairSpace
    public typealias Encoding = RepairEncoding
    public typealias Predicate = OpenRepairAction
    public typealias Answer = Right
}

/// The prepared opening suffices for this step; an upstream marker is not
/// requested again. The displaced content becomes an actual remainder.
public enum TransferIntoSecond<A: Structure, B: Structure, M: Structure,
    H: Structure>: PredicateReading {
    public typealias Left = RepairSurface<Paired<A, B>, M, RepairSecondOpen, H>
    public typealias Right = RepairSurface<Paired<A, A>, M, RepairSecondOpen, Paired<B, H>>
    public typealias Sigma = RepairSpace
    public typealias Encoding = RepairEncoding
    public typealias Predicate = TransferRepairAction
    public typealias Answer = Right
}

public enum TransferIntoFirst<A: Structure, B: Structure, M: Structure,
    H: Structure>: PredicateReading {
    public typealias Left = RepairSurface<Paired<A, B>, M, RepairFirstOpen, H>
    public typealias Right = RepairSurface<Paired<B, B>, M, RepairFirstOpen, Paired<A, H>>
    public typealias Sigma = RepairSpace
    public typealias Encoding = RepairEncoding
    public typealias Predicate = TransferRepairAction
    public typealias Answer = Right
}

/// An inverse on the presented equal-content, recorded-remainder family.
/// No environmental record of a real biochemical repair is asserted here.
public enum RestoreSecondFromRemainder<S: Pair>: PredicateReading
where S.Left: Pair, S.Right: Pair, S.Right.Right: Pair,
      S.Right.Right.Right: Pair,
      S.Left.Left == S.Left.Right,
      S.Right.Right.Left == RepairSecondOpen,
      S.Left.Left: Structure, S.Right.Left: Structure,
      S.Right.Right.Right.Left: Structure, S.Right.Right.Right.Right: Structure {
    public typealias Left = S
    public typealias Right = RepairSurface<
        Paired<S.Left.Left, S.Right.Right.Right.Left>, S.Right.Left,
        RepairSecondOpen, S.Right.Right.Right.Right>
    public typealias Sigma = RepairSpace
    public typealias Encoding = RepairEncoding
    public typealias Predicate = RestoreRepairAction
    public typealias Answer = Right
}

public enum SealSecondRepair<P: Pair, M: Structure, H: Structure>: PredicateReading {
    public typealias Left = RepairSurface<P, M, RepairSecondOpen, H>
    public typealias Right = RepairSurface<P, M, RepairClosed, H>
    public typealias Sigma = RepairSpace
    public typealias Encoding = RepairEncoding
    public typealias Predicate = SealRepairAction
    public typealias Answer = Right
}

public enum SealFirstRepair<P: Pair, M: Structure, H: Structure>: PredicateReading {
    public typealias Left = RepairSurface<P, M, RepairFirstOpen, H>
    public typealias Right = RepairSurface<P, M, RepairClosed, H>
    public typealias Sigma = RepairSpace
    public typealias Encoding = RepairEncoding
    public typealias Predicate = SealRepairAction
    public typealias Answer = Right
}

/// Every intermediate endpoint is the actual output of its predecessor.
/// Neither successful agreement nor equality with the target is a premise.
public enum FirstDirectedRepair<A: Structure, B: Structure, H: Structure>: Close {
    public typealias Open = OpenSecondAgainstFirst<Paired<A, B>, H>
    public typealias Transfer = TransferIntoSecond<A, B, ProtectedFirst, H>
    public typealias Seal = SealSecondRepair<Paired<A, A>, ProtectedFirst, Paired<B, H>>
    public typealias PreparedTransfer = SequentialReading<Open, Transfer>
    public typealias Path = SequentialReading<PreparedTransfer, Seal>
    public enum Agreement: Null {
        public typealias Left = Path.Answer.Left.Left
        public typealias Right = Path.Answer.Left.Right
    }
    public enum RetainedTarget: Null {
        public typealias Left = Path.Left.Left.Left
        public typealias Right = Path.Answer.Left.Left
    }
}

public enum SecondDirectedRepair<A: Structure, B: Structure, H: Structure>: Close {
    public typealias Open = OpenFirstAgainstSecond<Paired<A, B>, H>
    public typealias Transfer = TransferIntoFirst<A, B, ProtectedSecond, H>
    public typealias Seal = SealFirstRepair<Paired<B, B>, ProtectedSecond, Paired<A, H>>
    public typealias Path = SequentialReading<SequentialReading<Open, Transfer>, Seal>
    public enum Agreement: Null {
        public typealias Left = Path.Answer.Left.Left
        public typealias Right = Path.Answer.Left.Right
    }
}

/// Premature closure retains contents and selection, but changes the next
/// contact's actual source. Reopening from the same attached relation
/// restores applicability; the fact that it opened earlier does not.
public enum ReopenedFirstRepair<A: Structure, B: Structure, H: Structure>: Close {
    public typealias Open = OpenSecondAgainstFirst<Paired<A, B>, H>
    public typealias EarlySeal = SealSecondRepair<Paired<A, B>, ProtectedFirst, H>
    public typealias ClosedPrefix = SequentialReading<Open, EarlySeal>
    public typealias Reopened = SequentialReading<ClosedPrefix, Open>
    public typealias Transfer = TransferIntoSecond<A, B, ProtectedFirst, H>
    public typealias Seal = SealSecondRepair<Paired<A, A>, ProtectedFirst, Paired<B, H>>
    public typealias Path = SequentialReading<SequentialReading<Reopened, Transfer>, Seal>
    public enum SameFullEnd: Null {
        public typealias Left = Path.Answer
        public typealias Right = FirstDirectedRepair<A, B, H>.Path.Answer
    }
}
