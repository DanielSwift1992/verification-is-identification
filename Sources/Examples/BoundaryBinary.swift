import VerificationIsIdentification

/// A concrete source retains its third field even though VC69's interface
/// reads only the four alpha/beta coordinates of a pair of such sources.
public enum BoundaryBeam<A: IntegerValued, B: IntegerValued, H: IntegerValued>: Close, BeamShape {
    public typealias AlphaLevel = A
    public typealias BetaLevel = B
    public typealias PaschenLevel = H
}

public typealias BoundaryWorking<A: Structure, C: Structure, B: Structure, D: Structure> = Paired<Paired<A, C>, Paired<B, D>>

/// These four admitted leaves derive their common classes from equal
/// answers or positive zero/successor obstructions, not from table labels.
public typealias Boundary00 = AgreedBoundaryPairClass<Paired<Never, Never>>
public typealias Boundary01 = ZeroSuccessorBoundaryPairClass<Paired<Never, Lit1>, Never>
public typealias Boundary10 = SuccessorZeroBoundaryPairClass<Paired<Lit1, Never>, Never>
public typealias Boundary11 = AgreedBoundaryPairClass<Paired<Lit1, Lit1>>

/// Full binary coverage, in coordinate order (a,c;b,d). Each table checks
/// the four comparison inputs against the actual working-coordinate image.
public typealias Boundary0000 = BoundaryTable<BoundaryWorking<Never, Never, Never, Never>, Boundary00, Boundary00, Boundary00, Boundary00>
public typealias Boundary0001 = BoundaryTable<BoundaryWorking<Never, Never, Never, Lit1>, Boundary00, Boundary01, Boundary00, Boundary01>
public typealias Boundary0010 = BoundaryTable<BoundaryWorking<Never, Never, Lit1, Never>, Boundary01, Boundary00, Boundary01, Boundary00>
public typealias Boundary0011 = BoundaryTable<BoundaryWorking<Never, Never, Lit1, Lit1>, Boundary01, Boundary01, Boundary01, Boundary01>
public typealias Boundary0100 = BoundaryTable<BoundaryWorking<Never, Lit1, Never, Never>, Boundary00, Boundary00, Boundary10, Boundary10>
public typealias Boundary0101 = BoundaryTable<BoundaryWorking<Never, Lit1, Never, Lit1>, Boundary00, Boundary01, Boundary10, Boundary11>
public typealias Boundary0110 = BoundaryTable<BoundaryWorking<Never, Lit1, Lit1, Never>, Boundary01, Boundary00, Boundary11, Boundary10>
public typealias Boundary0111 = BoundaryTable<BoundaryWorking<Never, Lit1, Lit1, Lit1>, Boundary01, Boundary01, Boundary11, Boundary11>
public typealias Boundary1000 = BoundaryTable<BoundaryWorking<Lit1, Never, Never, Never>, Boundary10, Boundary10, Boundary00, Boundary00>
public typealias Boundary1001 = BoundaryTable<BoundaryWorking<Lit1, Never, Never, Lit1>, Boundary10, Boundary11, Boundary00, Boundary01>
public typealias Boundary1010 = BoundaryTable<BoundaryWorking<Lit1, Never, Lit1, Never>, Boundary11, Boundary10, Boundary01, Boundary00>
public typealias Boundary1011 = BoundaryTable<BoundaryWorking<Lit1, Never, Lit1, Lit1>, Boundary11, Boundary11, Boundary01, Boundary01>
public typealias Boundary1100 = BoundaryTable<BoundaryWorking<Lit1, Lit1, Never, Never>, Boundary10, Boundary10, Boundary10, Boundary10>
public typealias Boundary1101 = BoundaryTable<BoundaryWorking<Lit1, Lit1, Never, Lit1>, Boundary10, Boundary11, Boundary10, Boundary11>
public typealias Boundary1110 = BoundaryTable<BoundaryWorking<Lit1, Lit1, Lit1, Never>, Boundary11, Boundary10, Boundary11, Boundary10>
public typealias Boundary1111 = BoundaryTable<BoundaryWorking<Lit1, Lit1, Lit1, Lit1>, Boundary11, Boundary11, Boundary11, Boundary11>

/// Symmetry is derived on each admitted binary leaf, including the two
/// constructor-distinct orientations of refusal. Recursive reversal adds
/// no new answer, so the comparison grammar is closed under side exchange.
public typealias BoundaryReverse00 = JoinedVerdict<ReverseBoundaryComparison<Boundary00>, Boundary00>
public typealias BoundaryReverse01 = JoinedVerdict<ReverseBoundaryComparison<Boundary01>, Boundary10>
public typealias BoundaryReverse10 = JoinedVerdict<ReverseBoundaryComparison<Boundary10>, Boundary01>
public typealias BoundaryReverse11 = JoinedVerdict<ReverseBoundaryComparison<Boundary11>, Boundary11>

/// An existing component channel at a second field address. Context and
/// question stay the beta channel; the actual paired source is retained.
public enum BoundaryFirstBeta<P: Pair>: PredicateReading
where P.Left: BeamShape {
    public typealias Left = P
    public typealias Right = P.Left.BetaLevel
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = BetaQuestion
    public typealias Answer = Right
}

public enum BoundarySecondBeta<P: Pair>: PredicateReading
where P.Right: BeamShape {
    public typealias Left = P
    public typealias Right = P.Right.BetaLevel
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = BetaQuestion
    public typealias Answer = Right
}

/// Four actual acquisitions at one source, with each old fact retained in
/// the next trace. A source address is carried by the factors, not supplied
/// as an extra input to the final coordinate decoder. [VI VC71]
public enum AcquiredBoundaryCoordinates<P: Pair>: ReadingFactors
where P.Left: BeamShape, P.Right: BeamShape {
    public typealias First = PreparedTraceExtension<StartObservations<P>, BoundaryFirstAlpha<P>>
    public typealias T1 = First.Trace
    public typealias Second = PreparedTraceExtension<T1, BoundaryFirstBeta<P>>
    public typealias T2 = Second.Trace
    public typealias Third = PreparedTraceExtension<T2, BoundarySecondAlpha<P>>
    public typealias T3 = Third.Trace
    public typealias Fourth = PreparedTraceExtension<T3, BoundarySecondBeta<P>>
    public typealias T4 = Fourth.Trace
    public typealias A = RetainTraceAnswer<T4, RetainTraceAnswer<T3, RetainTraceAnswer<T2, LastAnswerFromTrace<T1>>>>
    public typealias C = RetainTraceAnswer<T4, RetainTraceAnswer<T3, LastAnswerFromTrace<T2>>>
    public typealias B = RetainTraceAnswer<T4, LastAnswerFromTrace<T3>>
    public typealias D = LastAnswerFromTrace<T4>
    public typealias Joint = JointEvidenceFromMemory<JointEvidenceFromMemory<A, C>, JointEvidenceFromMemory<B, D>>
    public typealias Left = BoundaryCoordinates<P>
    public typealias Right = DecodeRefinedEvidence<Joint.Right, IdentityCoordinateImage<Joint.Answer>>
    public typealias Observation = Joint.Observation
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = BoundaryCoordinatesQuestion
    public typealias Answer = Left.Answer
}

/// The coordinate question on its own image. This names the declared
/// representation after component decoders have already assembled it.
public enum IdentityCoordinateImage<I>: PredicateReading {
    public typealias Left = I
    public typealias Right = I
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = BoundaryCoordinatesQuestion
    public typealias Answer = Right
}

/// The old preparation is a law of this input family, not a fresh reset.
public enum PreparedBoundaryCoordinatesImage<I: Pair>: PredicateReading
where I.Left: Structure, I.Right: Structure {
    public typealias Left = I
    public typealias Right = BoundaryWorking<I.Left, Never, I.Right, Lit1>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = BoundaryCoordinatesQuestion
    public typealias Answer = Right
}

public enum PreparedBoundaryCoordinatesFromAlpha<P: Pair>: ReadingFactors
where P.Left: BeamShape, P.Right: BeamShape,
      P.Left.BetaLevel == Never, P.Right.BetaLevel == Lit1 {
    public typealias Left = BoundaryCoordinates<P>
    public typealias Observation = BoundaryPairReading<P>
    public typealias Right = PreparedBoundaryCoordinatesImage<Observation.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = BoundaryCoordinatesQuestion
    public typealias Answer = Left.Answer
}
