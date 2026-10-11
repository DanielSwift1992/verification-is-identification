import VerificationIsIdentification

/// Left names the complete supplied source. Right combines selected fields
/// from its two forms. Equal Right images need not identify that source.
/// Canonical pair recombination satisfies the absorption laws of LQ16.
public enum PairRecombination<X: Pair>: Pair
where X.Left: Pair, X.Right: Pair,
      X.Left.Left: Structure, X.Right.Right: Structure {
    public typealias Left = X
    public typealias Right = Paired<X.Left.Left, X.Right.Right>
}

/// Equal complementary results force equality of both source field pairs.
/// No source-field equality is supplied separately. Canonical fields are
/// identified here, rather than arbitrary nominal Pair shells. [LQ16]
public enum ReversedCutAgreement<X: Pair>: Null
where X.Left: Pair, X.Right: Pair,
      X.Left.Left: Structure, X.Left.Right: Structure,
      X.Right.Left: Structure, X.Right.Right: Structure,
      PairRecombination<X>.Right == PairRecombination<Paired<X.Right, X.Left>>.Right {
    public typealias Left = Paired<X.Left.Left, X.Left.Right>
    public typealias Right = Paired<X.Right.Left, X.Right.Right>
}

/// Both source forms are resident in X. Keep both complementary results.
/// Twice applying this exchange recovers the four source fields in canonical
/// nested pairs. It does not reconstruct an arbitrary nominal Pair shell.
/// An additional admission relation must accept both results. [LQ16]
public enum ResidentCutExchange<X: Pair>: Pair
where X.Left: Pair, X.Right: Pair,
      X.Left.Left: Structure, X.Left.Right: Structure,
      X.Right.Left: Structure, X.Right.Right: Structure {
    public typealias Left = X
    public typealias Right = Paired<
        PairRecombination<X>.Right,
        PairRecombination<Paired<X.Right, X.Left>>.Right
    >
}

/// The two resident sources and the first crossed result are equality
/// contacts. Those three premises force the complementary contact too.
/// Its equality is derived, without adding it as a fourth premise. [LQ13, LQ16]
public enum EqualityContactCut<X: Pair>: Pair
where X.Left: Pair, X.Right: Pair,
      X.Left.Left: Pair, X.Left.Right: Pair,
      X.Right.Left: Pair, X.Right.Right: Pair,
      X.Left.Left.Right == X.Left.Right.Left,
      X.Right.Left.Right == X.Right.Right.Left,
      X.Left.Left.Right == X.Right.Right.Left {
    public typealias Left = X
    public typealias Right = ResidentCutExchange<X>.Right
}

/// X contains ((a, aPrime), (b, bPrime)), the boundary codes of four
/// independently addressed forms. Three equality contacts force the fourth.
/// A nonrectangular relation cannot be represented only by such codes. [LQ13]
public enum ThreeContactsForceFourth<X: Pair>: Null
where X.Left: Pair, X.Right: Pair,
      X.Left.Left == X.Right.Left,
      X.Left.Left == X.Right.Right,
      X.Left.Right == X.Right.Left {
    public typealias Left = X.Left.Right
    public typealias Right = X.Right.Right
}

/// Four context-addressed tables of two possible joint answers. The last
/// table exchanges the second-side entries of the first table. These are
/// admission records, without outcome weights or a physical implementation.
/// Balanced sampling gives the PR correlations discussed in IiS24.
public enum BinaryContactAlternatives<A: Structure, B: Structure>: Pair {
    public typealias Equal = MatrixEntries<A, A, B, B>
    public typealias Exchange = ResidentCutExchange<Equal>
    public typealias Opposed = Exchange.Right
    public typealias EqualColumns = TransposeEntries<Equal>
    public typealias OpposedColumns = TransposeEntries<Opposed>
    public typealias RealignedSecond = SwapBoundaryReading<OpposedColumns.Answer.Right>
    public typealias Left = MatrixEntries<Equal, Equal, Equal, Opposed>
    public typealias Right = Paired<EqualColumns.Answer, OpposedColumns.Answer>
}

/// The first-side answer lists agree; the second-side lists agree after
/// exchanging their alternative addresses. With equally weighted hidden
/// alternatives this preserves local distributions. It does not identify
/// the joint tables, establish weights, or identify addressed occurrences.
public enum BinaryContactLocalLists<A: Structure, B: Structure>: Null {
    public typealias Contact = BinaryContactAlternatives<A, B>
    public typealias Left = Contact.EqualColumns.Answer
    public typealias Right = Paired<
        Contact.OpposedColumns.Answer.Left, Contact.RealignedSecond.Answer
    >
}

/// Original and individually changed forms satisfy the equality contact.
/// Its final contact and both orders' source/answer agreement follow from
/// the existing corner and application proofs. Other admission conditions
/// require their own relation to these applications. [LQ13]
public enum IndependentContactOrders<F: PredicateReading, G: PredicateReading>: Null
where F.Sigma == G.Sigma, F.Encoding == G.Encoding,
      F.Left: Pair, F.Answer: Pair, G.Left: Pair, G.Answer: Pair,
      F.Left.Right == G.Left.Left,
      F.Answer.Right == G.Left.Left,
      F.Left.Right == G.Answer.Left {
    public typealias Orders = IndependentReadingOrders<F, G>
    public typealias Contact = ThreeContactsForceFourth<Cell<
        Cell<F.Left.Right, F.Answer.Right>,
        Cell<G.Left.Left, G.Answer.Left>
    >>
    public typealias Left = Cell<Orders.Left, Contact.Left>
    public typealias Right = Cell<Orders.Right, Contact.Right>
}

/// Exchange the first two positions, then the last two, then the first two.
/// The computed composite exchanges the outer positions. This supplies the
/// permutation obstruction to the third crossed equality seam in LQ13.
public enum AdjacentSwapConjugation<X: Structure, Y: Structure, Z: Structure>: Null {
    public typealias Source = AddressTriple<X, Y, Z>
    public typealias First = SwapFirstTwoTriple<Source>
    public typealias Middle = PairedApplication<
        IdentityReading<First.Answer.Left, BeamSpace, SaturationEncoding>,
        SwapBoundaryReading<First.Answer.Right>
    >
    public typealias Last = SwapFirstTwoTriple<Middle.Answer>
    public typealias Reading = SequentialReading<First, SequentialReading<Middle, Last>>
    public typealias Left = Paired<Reading.Left, Reading.Answer>
    public typealias Right = Paired<Source, AddressTriple<Z, Y, X>>
}

/// Four addressed pairs. Reversing polarity means exchanging a pair's
/// two fields, without a scalar interpretation or a phase assumption.
public typealias FramePolarityFlip<A: Pair, B: Pair, C: Pair, D: Pair> = PairedApplication<
    PairedApplication<SwapBoundaryReading<A>, SwapBoundaryReading<B>>,
    PairedApplication<SwapBoundaryReading<C>, SwapBoundaryReading<D>>
>
where A.Left: Structure, A.Right: Structure, B.Left: Structure, B.Right: Structure,
      C.Left: Structure, C.Right: Structure, D.Left: Structure, D.Right: Structure

/// Retain the first two pairs and reverse the last two.
public typealias LowerFrameFlip<A: Structure, B: Structure, C: Pair, D: Pair> = PairedApplication<
    IdentityReading<Paired<A, B>, BeamSpace, SaturationEncoding>,
    PairedApplication<SwapBoundaryReading<C>, SwapBoundaryReading<D>>
>
where C.Left: Structure, C.Right: Structure, D.Left: Structure, D.Right: Structure

/// Retain the first column and exchange the two fields of each second-column
/// frame. These are addressed exchanges, without a scalar interpretation.
public typealias AlternateFrameFlip<A: Structure, B: Pair, C: Structure, D: Pair> = PairedApplication<
    PairedApplication<IdentityReading<A, BeamSpace, SaturationEncoding>, SwapBoundaryReading<B>>,
    PairedApplication<IdentityReading<C, BeamSpace, SaturationEncoding>, SwapBoundaryReading<D>>
>
where B.Left: Structure, B.Right: Structure, D.Left: Structure, D.Right: Structure

/// Nine actual applications on four resident frames. Each frame has two
/// addressed fields. Reconstructing their canonical source avoids equating
/// a nominal Pair shell with its fields. The six context words below use
/// these same applications at their actual intermediate sources. [IiS22]
public enum FrameSquare<
    AP: Structure, AN: Structure, BP: Structure, BN: Structure,
    CP: Structure, CN: Structure, DP: Structure, DN: Structure
>: Pair {
    public typealias A = Paired<AP, AN>
    public typealias B = Paired<BP, BN>
    public typealias C = Paired<CP, CN>
    public typealias D = Paired<DP, DN>
    public typealias NA = Paired<AN, AP>
    public typealias NB = Paired<BN, BP>
    public typealias NC = Paired<CN, CP>
    public typealias ND = Paired<DN, DP>
    public typealias Left = MatrixEntries<A, B, C, D>
    public typealias N = FramePolarityFlip<A, B, C, D>
    public typealias X1 = SwapBoundaryReading<Left>
    public typealias X2 = PairedApplication<SwapBoundaryReading<Left.Left>, SwapBoundaryReading<Left.Right>>
    public typealias Z1 = LowerFrameFlip<A, B, C, D>
    public typealias Z2 = AlternateFrameFlip<A, B, C, D>
    public typealias A11 = X1
    public typealias A12 = X2
    public typealias A13 = SequentialReading<X1, PairedApplication<
        SwapBoundaryReading<Paired<C, D>>, SwapBoundaryReading<Paired<A, B>>>>
    public typealias A21 = Z2
    public typealias A22 = Z1
    public typealias A23 = SequentialReading<Z2, LowerFrameFlip<A, NB, C, ND>>
    public typealias A31 = SequentialReading<X1, AlternateFrameFlip<C, D, A, B>>
    public typealias A32 = SequentialReading<X2, LowerFrameFlip<B, A, D, C>>
    public typealias A33Prefix = SequentialReading<A31, PairedApplication<
        SwapBoundaryReading<Paired<C, ND>>, SwapBoundaryReading<Paired<A, NB>>>>
    public typealias A33 = SequentialReading<A33Prefix, LowerFrameFlip<ND, C, NB, A>>
    public typealias Right = AddressTriple<
        AddressTriple<A11.Answer, A12.Answer, A13.Answer>,
        AddressTriple<A21.Answer, A22.Answer, A23.Answer>,
        AddressTriple<A31.Answer, A32.Answer, A33.Answer>
    >
}

/// All eight fields remain arbitrary. Five context words return their
/// source and the sixth reverses every frame. These output equalities are
/// computed through the applications, without being caller premises.
public enum FrameSquareProducts<
    A: Structure, B: Structure, C: Structure, D: Structure,
    E: Structure, F: Structure, G: Structure, H: Structure
>: Null {
    public typealias Source = MatrixEntries<Paired<A, B>, Paired<C, D>, Paired<E, F>, Paired<G, H>>
    public typealias Square = FrameSquare<A, B, C, D, E, F, G, H>
    public typealias Row1 = SequentialReading<Square.A13, FrameSquare<G, H, E, F, C, D, A, B>.A13>
    public typealias Row2 = SequentialReading<Square.A23, FrameSquare<A, B, D, C, F, E, G, H>.A23>
    public typealias Row3 = SequentialReading<Square.A33, FrameSquare<H, G, E, F, C, D, B, A>.A33>
    public typealias Column1 = SequentialReading<Square.A31, FrameSquare<E, F, H, G, A, B, D, C>.A31>
    public typealias Column2 = SequentialReading<Square.A32, FrameSquare<C, D, A, B, H, G, F, E>.A32>
    public typealias Column3Prefix = SequentialReading<Square.A13, FrameSquare<G, H, E, F, C, D, A, B>.A23>
    public typealias Column3 = SequentialReading<Column3Prefix, FrameSquare<G, H, F, E, D, C, A, B>.A33>
    public typealias Left = Paired<
        AddressTriple<Row1.Answer, Row2.Answer, Row3.Answer>,
        AddressTriple<Column1.Answer, Column2.Answer, Column3.Answer>
    >
    public typealias Right = Paired<
        AddressTriple<Source, Source, Source>,
        AddressTriple<Source, Source, Square.N.Answer>
    >
}

/// Two applications of the existing twisted pair shift, one on each half.
public typealias PairedQuarterTurn<A: Pair, B: Pair, C: Pair, D: Pair> = PairedApplication<
    TwistedPairShift<A, B>, TwistedPairShift<C, D>
>
where A.Left: Structure, A.Right: Structure, C.Left: Structure, C.Right: Structure

/// Exchange the halves, then reverse the second and third resulting pairs.
public typealias CrossedQuarterTurn<A: Pair, B: Structure, C: Structure, D: Pair> = SequentialReading<
    SwapBoundaryReading<MatrixEntries<A, B, C, D>>,
    PairedApplication<
        PairedApplication<IdentityReading<C, BeamSpace, SaturationEncoding>, SwapBoundaryReading<D>>,
        PairedApplication<SwapBoundaryReading<A>, IdentityReading<B, BeamSpace, SaturationEncoding>>
    >
>
where A.Left: Structure, A.Right: Structure, D.Left: Structure, D.Right: Structure

/// Both pairs of actions have the same central crossing residual Z.
/// The P/Q squares return the source, while the I/J squares give Z.
/// Repeating the combined P/Q or I/J action gives Z in both cases.
/// Eight arbitrary fields are assembled into four constructor pairs.
/// This does not identify a reconstructed pair with a nominal Pair shell.
/// Every application consumes the preceding result. No group identities
/// or equality of the resulting words are premises. [Liquid LQ13]
public enum SameCommutatorDifferentSquares<
    A: Structure, B: Structure, C: Structure, D: Structure,
    E: Structure, F: Structure, G: Structure, H: Structure
>: Null {
    public typealias FirstAxis = Paired<A, B>
    public typealias SecondAxis = Paired<C, D>
    public typealias ThirdAxis = Paired<E, F>
    public typealias FourthAxis = Paired<G, H>
    public typealias ReversedFirst = Paired<B, A>
    public typealias ReversedSecond = Paired<D, C>
    public typealias ReversedThird = Paired<F, E>
    public typealias ReversedFourth = Paired<H, G>
    public typealias Source = MatrixEntries<FirstAxis, SecondAxis, ThirdAxis, FourthAxis>
    public typealias Z = FramePolarityFlip<FirstAxis, SecondAxis, ThirdAxis, FourthAxis>
    public typealias P = SwapBoundaryReading<Source>
    public typealias Q = LowerFrameFlip<FirstAxis, SecondAxis, ThirdAxis, FourthAxis>
    public typealias I = PairedQuarterTurn<FirstAxis, SecondAxis, ThirdAxis, FourthAxis>
    public typealias J = CrossedQuarterTurn<FirstAxis, SecondAxis, ThirdAxis, FourthAxis>
    public typealias Z2 = SequentialReading<Z, FramePolarityFlip<
        ReversedFirst, ReversedSecond, ReversedThird, ReversedFourth>>
    public typealias P2 = SequentialReading<P, SwapBoundaryReading<
        MatrixEntries<ThirdAxis, FourthAxis, FirstAxis, SecondAxis>>>
    public typealias Q2 = SequentialReading<Q, LowerFrameFlip<
        FirstAxis, SecondAxis, ReversedThird, ReversedFourth>>
    public typealias I2 = SequentialReading<I, PairedQuarterTurn<
        SecondAxis, ReversedFirst, FourthAxis, ReversedThird>>
    public typealias J2 = SequentialReading<J, CrossedQuarterTurn<
        ThirdAxis, ReversedFourth, ReversedFirst, SecondAxis>>
    public typealias PQ = SequentialReading<P, LowerFrameFlip<
        ThirdAxis, FourthAxis, FirstAxis, SecondAxis>>
    public typealias QP = SequentialReading<Q, SwapBoundaryReading<
        MatrixEntries<FirstAxis, SecondAxis, ReversedThird, ReversedFourth>>>
    public typealias IJ = SequentialReading<I, CrossedQuarterTurn<
        SecondAxis, ReversedFirst, FourthAxis, ReversedThird>>
    public typealias JI = SequentialReading<J, PairedQuarterTurn<
        ThirdAxis, ReversedFourth, ReversedFirst, SecondAxis>>
    public typealias ZQP = SequentialReading<QP, FramePolarityFlip<
        ReversedThird, ReversedFourth, FirstAxis, SecondAxis>>
    public typealias ZJI = SequentialReading<JI, FramePolarityFlip<
        ReversedFourth, ReversedThird, SecondAxis, FirstAxis>>
    public typealias PQP = SequentialReading<PQ, SwapBoundaryReading<
        MatrixEntries<ThirdAxis, FourthAxis, ReversedFirst, ReversedSecond>>>
    public typealias PQ2 = SequentialReading<PQP, LowerFrameFlip<
        ReversedFirst, ReversedSecond, ThirdAxis, FourthAxis>>
    public typealias IJI = SequentialReading<IJ, PairedQuarterTurn<
        FourthAxis, ThirdAxis, ReversedSecond, ReversedFirst>>
    public typealias IJ2 = SequentialReading<IJI, CrossedQuarterTurn<
        ThirdAxis, ReversedFourth, ReversedFirst, SecondAxis>>
    public typealias Left = AddressTriple<
        AddressTriple<P2.Answer, Q2.Answer, Z2.Answer>,
        MatrixEntries<I2.Answer, J2.Answer, PQ.Answer, IJ.Answer>,
        Paired<PQ2.Answer, IJ2.Answer>
    >
    public typealias Right = AddressTriple<
        AddressTriple<Source, Source, Source>,
        MatrixEntries<Z.Answer, Z.Answer, ZQP.Answer, ZJI.Answer>,
        Paired<Z.Answer, Z.Answer>
    >
}

/// X contains ((local, partner), reserve). Local and reserve expose their
/// boundary on Right, and the partner exposes the same boundary on Left.
/// Exchange the resident local forms while retaining the actual partner.
/// The old local form becomes the reserve. [Liquid LQ13]
public enum ResidentContactExchange<X: Pair>: Pair
where X.Left: Pair, X.Left.Left: Pair, X.Left.Right: Pair, X.Right: Pair,
      X.Left.Left.Right == X.Left.Right.Left,
      X.Right.Right == X.Left.Right.Left {
    public typealias Left = X
    public typealias Right = Paired<Paired<X.Right, X.Left.Right>, X.Left.Left>
}

/// Both endpoints are contacts at their actual field addresses. Retaining
/// the partner forces the local boundary to agree before and after. No
/// equality between these two local boundary fields is supplied. [LQ13]
public enum RetainedPartnerForcesBoundary<P: Pair>: Null
where P.Left: Pair, P.Right: Pair,
      P.Left.Left: Pair, P.Left.Right: Pair,
      P.Right.Left: Pair, P.Right.Right: Pair,
      P.Left.Left.Right == P.Left.Right.Left,
      P.Right.Left.Right == P.Right.Right.Left,
      P.Left.Right == P.Right.Right {
    public typealias Left = P.Left.Left.Right
    public typealias Right = P.Right.Left.Right
}

/// A proposed vacancy witness names an actual zero coordinate. Its right
/// side is the one-hot position mask. These three constructors express the
/// existential star clauses of VC23b, without choosing one uniformly.
public enum FirstVacancy<X: Pair>: Pair
where X.Left == Never, X.Right: Pair,
      X.Right.Left: Structure, X.Right.Right: Structure {
    public typealias Left = X
    public typealias Right = AddressTriple<Lit1, Never, Never>
}

public enum SecondVacancy<X: Pair>: Pair
where X.Left: Structure, X.Right: Pair, X.Right.Left == Never,
      X.Right.Right: Structure {
    public typealias Left = X
    public typealias Right = AddressTriple<Never, Lit1, Never>
}

public enum ThirdVacancy<X: Pair>: Pair
where X.Left: Structure, X.Right: Pair, X.Right.Left: Structure,
      X.Right.Right == Never {
    public typealias Left = X
    public typealias Right = AddressTriple<Never, Never, Lit1>
}

/// This operation exchanges alpha and beta only where alpha equals the third
/// coordinate. The condition is a relation of resident fields. [VI VC46]
public enum MatchedSwapOperation: Close {}

/// The source application exists in this constructor's domain of equal fields.
public enum MatchedSwapSource<B: BeamShape>: PredicateReading
where B.AlphaLevel == B.PaschenLevel {
    public typealias Left = B
    public typealias Right = SwapVisible<B>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = MatchedSwapOperation
    public typealias Answer = Right
}

/// The complete image carries the same equality condition at its own addresses.
public enum MatchedSwapImage<I: Pair>: PredicateReading
where I.Left: Structure, I.Right: Pair,
      I.Right.Left: Structure, I.Right.Right: Structure,
      I.Left == I.Right.Right {
    public typealias Left = I
    public typealias Right = SwapSpectrumHead<I>.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = MatchedSwapOperation
    public typealias Answer = Right
}

/// Both the condition and the resulting image follow by projection. The
/// source condition alone supplies the image condition and the output square.
public enum MatchedSwapTransition<B: BeamShape>: CommutingTransition
where B.AlphaLevel == B.PaschenLevel {
    public typealias Left = FullSpectrumReading<B>
    public typealias Right = FullSpectrumReading<SwapVisible<B>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Operation = MatchedSwapOperation
    public typealias SourceStep = MatchedSwapSource<B>
    public typealias ImageStep = MatchedSwapImage<FullSpectrumImage<B>>
}

/// At the successor the condition compares the old beta with the third field.
/// A two-step path therefore requires both resident comparisons to agree.
public typealias TwiceMatchedSwap<B: BeamShape> = JoinedTransition<
    MatchedSwapTransition<B>,
    MatchedSwapTransition<SwapVisible<B>>
>
where B.AlphaLevel == B.PaschenLevel, B.BetaLevel == B.PaschenLevel

/// The conditional future question retains the guarded operation in its name.
public typealias AlphaAfterMatchedSwap<B: BeamShape> = QuestionAlongTransition<
    MatchedSwapTransition<B>,
    SpectrumAlphaFactors<SwapVisible<B>>
>
where B.AlphaLevel == B.PaschenLevel

/// Distinct constructors in the declared numeral grammar. This ordered pair
/// is a positive obstruction to equality, not a general inequality oracle.
/// Even Succ<Never> having equal fields does not identify it with Never. [VI VC48]
public enum ZeroSuccessorDistinction<N: IntegerValued>: Pair {
    public typealias Left = Never
    public typealias Right = Succ<N>
}

/// Only the current answer remains when the guarded action is unavailable.
/// The constructor distinguishes this image from an enabled image with the
/// same answer; it does not identify the source. [VI VC49]
public enum BlockedAlpha<A: IntegerValued>: Close, HasVerdict {
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = AlphaQuestion
    public typealias Answer = A
}

/// An enabled image retains the current and next answers. Its source's third
/// coordinate is already fixed by the guard. [VI VC49]
public enum ReadyAlpha<A: IntegerValued, B: IntegerValued>: Pair, HasVerdict {
    public typealias Left = A
    public typealias Right = B
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = AlphaQuestion
    public typealias Answer = A
}

public enum InteractionClassQuestion: Close {}

/// Classify the complete image using only its resident coordinates.
public enum ReadySpectrumClass<I: Pair>: PredicateReading
where I.Left: IntegerValued, I.Right: Pair, I.Right.Left: IntegerValued,
      I.Left == I.Right.Right {
    public typealias Left = I
    public typealias Right = ReadyAlpha<I.Left, I.Right.Left>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = InteractionClassQuestion
    public typealias Answer = Right
}

/// Both ends of the obstruction are bound to actual image coordinates.
public enum ZeroBlockedSpectrumClass<I: Pair, N: IntegerValued>: PredicateReading
where I.Left == Never, I.Right: Pair, I.Right.Right == Succ<N> {
    public typealias Obstruction = ZeroSuccessorDistinction<N>
    public typealias Left = I
    public typealias Right = BlockedAlpha<I.Left>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = InteractionClassQuestion
    public typealias Answer = Right
}

public enum SuccessorBlockedSpectrumClass<I: Pair, N: IntegerValued>: PredicateReading
where I.Left == Succ<N>, I.Right: Pair, I.Right.Right == Never {
    public typealias Obstruction = InternalSwap<ZeroSuccessorDistinction<N>>
    public typealias Left = I
    public typealias Right = BlockedAlpha<I.Left>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = InteractionClassQuestion
    public typealias Answer = Right
}

/// Source classifications are names of the existing observation composition.
/// No second implementation of the classification lives at the source layer.
public typealias ReadyClassFactors<B: BeamShape> = QuestionOnObservation<
    FullSpectrumReading<B>,
    ReadySpectrumClass<FullSpectrumImage<B>>
>
where B.AlphaLevel == B.PaschenLevel

public typealias ZeroBlockedClassFactors<B: BeamShape, N: IntegerValued> = QuestionOnObservation<
    FullSpectrumReading<B>,
    ZeroBlockedSpectrumClass<FullSpectrumImage<B>, N>
>
where B.AlphaLevel == Never, B.PaschenLevel == Succ<N>

public typealias SuccessorBlockedClassFactors<B: BeamShape, N: IntegerValued> = QuestionOnObservation<
    FullSpectrumReading<B>,
    SuccessorBlockedSpectrumClass<FullSpectrumImage<B>, N>
>
where B.AlphaLevel == Succ<N>, B.PaschenLevel == Never

public typealias ReadyClassReading<B: BeamShape> = ReadyClassFactors<B>.Left
where B.AlphaLevel == B.PaschenLevel

public typealias ZeroBlockedClassReading<B: BeamShape, N: IntegerValued> = ZeroBlockedClassFactors<B, N>.Left
where B.AlphaLevel == Never, B.PaschenLevel == Succ<N>

public typealias SuccessorBlockedClassReading<B: BeamShape, N: IntegerValued> = SuccessorBlockedClassFactors<B, N>.Left
where B.AlphaLevel == Succ<N>, B.PaschenLevel == Never

/// These three clauses close the binary image fragment under the action.
/// They do not claim to decide every pair of IntegerValued conformers.
public enum RepeatReadyImage<A: IntegerValued>: PredicateReading {
    public typealias Left = ReadyAlpha<A, A>
    public typealias Right = Left
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = MatchedSwapOperation
    public typealias Answer = Right
}

public enum ZeroToSuccessorImage<N: IntegerValued>: PredicateReading {
    public typealias Left = ReadyAlpha<Never, Succ<N>>
    public typealias Right = BlockedAlpha<Succ<N>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = MatchedSwapOperation
    public typealias Answer = Right
}

public enum SuccessorToZeroImage<N: IntegerValued>: PredicateReading {
    public typealias Left = ReadyAlpha<Succ<N>, Never>
    public typealias Right = BlockedAlpha<Never>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = MatchedSwapOperation
    public typealias Answer = Right
}
