import VerificationIsIdentification

public enum DuplicateParityOperation: Close {}

/// On the declared binary carrier, equal inputs have zero parity. The
/// two other constructors below give the remaining rows of the same law.
public enum EqualPairParity<X: Structure>: PredicateReading {
    public typealias Left = Paired<X, X>
    public typealias Right = Paired<Never, Never>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = DuplicateParityOperation
    public typealias Answer = Right
}
public enum ZeroOneParity: PredicateReading {
    public typealias Left = Paired<Never, Lit1>
    public typealias Right = Paired<Lit1, Lit1>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = DuplicateParityOperation
    public typealias Answer = Right
}
public enum OneZeroParity: PredicateReading {
    public typealias Left = Paired<Lit1, Never>
    public typealias Right = Paired<Lit1, Lit1>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = DuplicateParityOperation
    public typealias Answer = Right
}

/// Keep the law address inside the input and output of the supplied reading.
/// This does not turn an arbitrary operation tag into a proof of its law.
public typealias ReadingWithResidentLaw<R: PredicateReading> = ReadingBesideInput<R, R.Predicate>
where R.Predicate: Structure, R.Left: Structure, R.Answer: Structure

public enum EarlierFirstQuestion: Close {}
public enum EarlierSecondQuestion: Close {}

/// The next second field witnesses the earlier first field under swap.
/// The answer equality follows from the transition and the addressed read.
public enum EarlierFirstThroughSwap<P: Pair>: ReadingFactors
where P.Left: Structure, P.Right: Structure {
    public typealias Left = FirstEvidenceImage<P, BeamSpace, SaturationEncoding, EarlierFirstQuestion>
    public typealias Observation = SwapBoundaryReading<P>
    public typealias Right = SecondEvidenceImage<Observation.Answer, BeamSpace, SaturationEncoding, EarlierFirstQuestion>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = EarlierFirstQuestion
    public typealias Answer = Left.Answer
}

/// The next first field witnesses the earlier second field under that same
/// actual transition. Both witnesses therefore consume the same later image.
public enum EarlierSecondThroughSwap<P: Pair>: ReadingFactors
where P.Left: Structure, P.Right: Structure {
    public typealias Left = SecondEvidenceImage<P, BeamSpace, SaturationEncoding, EarlierSecondQuestion>
    public typealias Observation = SwapBoundaryReading<P>
    public typealias Right = FirstEvidenceImage<Observation.Answer, BeamSpace, SaturationEncoding, EarlierSecondQuestion>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = EarlierSecondQuestion
    public typealias Answer = Left.Answer
}

/// Existing composition joins the two temporal witnesses into recovery of
/// the earlier coordinate pair. No whole-input equality is a caller premise.
public typealias EarlierPairThroughSwap<P: Pair> = JointEvidenceFromMemory<
    EarlierFirstThroughSwap<P>,
    EarlierSecondThroughSwap<P>
>
where P.Left: Structure, P.Right: Structure

/// A recursive record is admitted by Pair. Its left address returns itself.
/// This is outside the well-founded finite-tree interpretation. [Matter M55]
public enum SelfRetainingRecord: Pair {
    public typealias Left = SelfRetainingRecord
    public typealias Right = Never
}

/// Permanent alone permits equal endpoints on that recursive record.
/// Strict historical extension needs its own representation premise.
public enum StationaryRetention: Permanent {
    public typealias Left = SelfRetainingRecord
    public typealias Right = SelfRetainingRecord
}
