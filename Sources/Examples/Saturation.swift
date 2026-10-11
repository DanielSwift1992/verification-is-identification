import VerificationIsIdentification

// Symbolic coordinate operations on the existing beam representation. No
// physical process converting spectral lines is asserted by these constructors.

// The concrete comparison sources also participate in retained records.
extension RedBeam: Close {}
extension RedBeamWithIR: Close {}

public enum SaturationEncoding: Close {}
public enum FullSpectrumQuestion: Close {}
public enum SwapBetaHiddenOperation: Close {}

/// Together with SwapVisible, this operation can expose all three coordinates
/// to the alpha question. Each individual vocabulary has a smaller closure.
public enum SwapBetaHidden<B: BeamShape>: Close, BeamShape {
    public typealias AlphaLevel = B.AlphaLevel
    public typealias BetaLevel = B.PaschenLevel
    public typealias PaschenLevel = B.BetaLevel
}

public typealias FullSpectrumImage<B: BeamShape> = Paired<B.AlphaLevel, Paired<B.BetaLevel, B.PaschenLevel>>

public enum FullSpectrumReading<B: BeamShape>: PredicateReading {
    public typealias Left = B
    public typealias Right = FullSpectrumImage<B>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = FullSpectrumQuestion
    public typealias Answer = Right
}

public enum SpectrumAlphaSource<B: BeamShape>: PredicateReading {
    public typealias Left = B
    public typealias Right = B.AlphaLevel
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = AlphaQuestion
    public typealias Answer = Right
}

public enum SpectrumAlphaImage<I: Pair>: PredicateReading {
    public typealias Left = I
    public typealias Right = I.Left
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = AlphaQuestion
    public typealias Answer = Right
}

/// The completed representation retains the original alpha question. The
/// equality follows by projection for every B, without an answer premise.
public enum SpectrumAlphaFactors<B: BeamShape>: ReadingFactors {
    public typealias Left = SpectrumAlphaSource<B>
    public typealias Right = SpectrumAlphaImage<FullSpectrumImage<B>>
    public typealias Observation = FullSpectrumReading<B>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = AlphaQuestion
    public typealias Answer = B.AlphaLevel
}

public enum SpectrumSwapSource<B: BeamShape>: PredicateReading {
    public typealias Left = B
    public typealias Right = SwapVisible<B>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = SwapOperation
    public typealias Answer = Right
}

public enum HiddenSwapSource<B: BeamShape>: PredicateReading {
    public typealias Left = B
    public typealias Right = SwapBetaHidden<B>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = SwapBetaHiddenOperation
    public typealias Answer = Right
}

/// Update (a,(b,c)) to (b,(a,c)) using the image alone.
public enum SwapSpectrumHead<I: Pair>: PredicateReading
where I.Left: Structure, I.Right: Pair,
      I.Right.Left: Structure, I.Right.Right: Structure {
    public typealias Left = I
    public typealias Right = Paired<I.Right.Left, Paired<I.Left, I.Right.Right>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = SwapOperation
    public typealias Answer = Right
}

/// Update (a,(b,c)) to (a,(c,b)) using the image alone.
public enum SwapSpectrumTail<I: Pair>: PredicateReading
where I.Left: Structure, I.Right: Pair,
      I.Right.Left: Structure, I.Right.Right: Structure {
    public typealias Left = I
    public typealias Right = Paired<I.Left, Paired<I.Right.Right, I.Right.Left>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = SwapBetaHiddenOperation
    public typealias Answer = Right
}

/// The first operation descends to the completed representation.
public enum SpectrumFirstTransition<B: BeamShape>: CommutingTransition {
    public typealias Left = FullSpectrumReading<B>
    public typealias Right = FullSpectrumReading<SwapVisible<B>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Operation = SwapOperation
    public typealias SourceStep = SpectrumSwapSource<B>
    public typealias ImageStep = SwapSpectrumHead<FullSpectrumImage<B>>
}

/// The second operation descends too. JoinedTransition therefore supplies
/// every compatible finite interleaving, not just repetitions of one step.
public enum SpectrumSecondTransition<B: BeamShape>: CommutingTransition {
    public typealias Left = FullSpectrumReading<B>
    public typealias Right = FullSpectrumReading<SwapBetaHidden<B>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Operation = SwapBetaHiddenOperation
    public typealias SourceStep = HiddenSwapSource<B>
    public typealias ImageStep = SwapSpectrumTail<FullSpectrumImage<B>>
}

/// Name the existing composition where its next source matches.
public typealias AppendSpectrumFirst<
    P: CommutingTransition,
    B: BeamShape
> = JoinedTransition<P, SpectrumFirstTransition<B>>
where P.Right == FullSpectrumReading<B>

public typealias AppendSpectrumSecond<
    P: CommutingTransition,
    B: BeamShape
> = JoinedTransition<P, SpectrumSecondTransition<B>>
where P.Right == FullSpectrumReading<B>

/// Equal complete images remain equal after the first operation. The output
/// certificate follows from the input image equality, without source identity.
public typealias SpectrumFirstAgreement<
    A: BeamShape,
    B: BeamShape
> = JoinedVerdict<
    FullSpectrumReading<SwapVisible<A>>,
    FullSpectrumReading<SwapVisible<B>>
>
where FullSpectrumImage<A> == FullSpectrumImage<B>

/// The other generator preserves that same relation. Induction therefore
/// covers all finite mixed words over these two operations. [VI VC44]
public typealias SpectrumSecondAgreement<
    A: BeamShape,
    B: BeamShape
> = JoinedVerdict<
    FullSpectrumReading<SwapBetaHidden<A>>,
    FullSpectrumReading<SwapBetaHidden<B>>
>
where FullSpectrumImage<A> == FullSpectrumImage<B>
