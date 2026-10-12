import VerificationIsIdentification

// The finite certificate constructors: the compiler checks each generic body
// under its premises. There is no runtime predicate or answer-selection code.

/// A singleton is the same reading in both positions, with one source in its
/// support. Equality of answers follows by substitution, with no extra premise.
public enum SingletonVerdict<R: PredicateReading>: VerdictIsInvariant {
    public typealias Left = R
    public typealias Right = R
    public typealias Sigma = R.Sigma
    public typealias Encoding = R.Encoding
    public typealias Predicate = R.Predicate
    public typealias Answer = R.Answer
}

/// When both readings return their actual source, agreement of their
/// answers identifies those sources. Source equality is the conclusion,
/// not a supplied premise. Arbitrary coarser readings need not satisfy
/// these identity laws. [V=I U2]
public enum IdentityVerdictIdentifiesSources<C: VerdictIsInvariant>: Null
where C.Left.Answer == C.Left.Left, C.Right.Answer == C.Right.Left {
    public typealias Left = C.Left.Left
    public typealias Right = C.Right.Left
}

/// Reuse the existing support grammar with an actual identity reading.
public typealias CoveredIdentity<X, S, E> = CoveredLeaf<IdentityReading<X, S, E>>

/// A certified group can be a branch of a larger finite certificate. Its source
/// records both child readings, and its answer is inherited from the certificate.
/// This lifts the question to its uniform groups, not to an extra physical beam.
/// Only finite expressions built by these constructors are claimed here; an
/// arbitrary recursive protocol conformance is not a finiteness proof.
public enum CertifiedGroup<C: VerdictIsInvariant>: PredicateReading {
    public typealias Certificate = C
    public typealias Left = Paired<C.Left, C.Right>
    public typealias Right = C.Answer
    public typealias Sigma = C.Sigma
    public typealias Encoding = C.Encoding
    public typealias Predicate = C.Predicate
    public typealias Answer = C.Answer
}

/// The generic body derives the reversed certificate from C alone. It does
/// not ask the caller to supply a second invariance premise.
public enum ReversedVerdict<C: VerdictIsInvariant>: VerdictIsInvariant {
    public typealias Left = C.Right
    public typealias Right = C.Left
    public typealias Sigma = C.Sigma
    public typealias Encoding = C.Encoding
    public typealias Predicate = C.Predicate
    public typealias Answer = C.Answer
}

/// The relation between a certificate and its derived reversal.
public enum ReorderVerdict<C: VerdictIsInvariant>: VerdictReorders {
    public typealias Left = C
    public typealias Right = ReversedVerdict<C>
}

/// The left member carries the old verdict by the lattice's equalities.
public enum RetainLeftVerdict<C: VerdictIsInvariant>: VerdictRetainsLeft {
    public typealias Left = C
    public typealias Right = C.Left
}

/// The right member carries the old verdict by the lattice's equalities.
public enum RetainRightVerdict<C: VerdictIsInvariant>: VerdictRetainsRight {
    public typealias Left = C
    public typealias Right = C.Right
}

/// Ask only for a beam's visible image. The answer is computed by the existing
/// EyeImage type alias, not supplied as a separate, unchecked answer parameter.
public enum VisibleReading<B: BeamShape>: PredicateReading {
    public typealias Left = B
    public typealias Right = EyeImage<B>
    public typealias Sigma = BeamSpace
    public typealias Encoding = EyeEncoding
    public typealias Predicate = VisibleQuestion
    public typealias Answer = EyeImage<B>
}

/// Ask for the infrared coordinate of the same source. Keeping this question
/// distinct prevents equal-looking answer types from joining unlike questions.
public enum InfraredReading<B: BeamShape>: PredicateReading {
    public typealias Left = B
    public typealias Right = B.PaschenLevel
    public typealias Sigma = BeamSpace
    public typealias Encoding = PrismSeparator
    public typealias Predicate = InfraredQuestion
    public typealias Answer = B.PaschenLevel
}

public enum VisibleQuestion: Close {}
public enum InfraredQuestion: Close {}

/// Two distinct beams, one checked visible answer: source identification is
/// unnecessary for this question. The infrared question on this pair is open.
public typealias VisibleVerdict = JoinedVerdict<
    VisibleReading<RedBeam>,
    VisibleReading<RedBeamWithIR>
>

/// A third source differs in the hidden coordinate again. All three visible
/// readings agree, and the nested certificate checks the third branch too.
public enum RedBeamWithMoreIR: BeamShape {
    public typealias AlphaLevel = Lit1
    public typealias BetaLevel = Never
    public typealias PaschenLevel = Lit2
}

public typealias ThreeBeamVerdict = JoinedVerdict<
    CertifiedGroup<VisibleVerdict>,
    VisibleReading<RedBeamWithMoreIR>
>

/// The actual leaf at this node, or Never for a fork or the empty floor.
/// Binding it in the original conformance prevents a later alias from
/// redefining an existing leaf as an empty node.
public protocol CandidateNode: Pair {
    associatedtype Leaf: Pair
}

extension Never: CandidateNode {
    public typealias Leaf = Never
}

/// Canonical support syntax. A leaf is present even when its payload is Never.
public enum CandidateLeaf<X>: CandidateNode {
    public typealias Left = X
    public typealias Right = Never
    public typealias Leaf = Self
}

public enum CandidateFork<
    L: Pair,
    R: Pair
>: CandidateNode {
    public typealias Left = L
    public typealias Right = R
    public typealias Leaf = Never
}

/// A common candidate carried by a nonempty finite leaf/fork support.
/// The conformances below establish that interpretation on the constructor
/// grammar. An arbitrary conformance alone is not a coverage proof. [V=I U2]
public protocol SingleCandidateSupport: Pair {
    associatedtype Member
}

extension CandidateLeaf: SingleCandidateSupport {
    public typealias Member = X
}

extension CandidateFork: SingleCandidateSupport
where L: SingleCandidateSupport, R: SingleCandidateSupport, L.Member == R.Member {
    public typealias Member = L.Member
}

/// Read the common member from the independently checked declaration.
/// Coverage transfers it to the certificate's actual support by equality.
public enum DeclaredSingleCandidate<C: CoverageMatchesDeclaration>: Null
where C.Right: SingleCandidateSupport {
    public typealias Left = C.Left.Candidates.Member
    public typealias Right = C.Right.Member
}

/// A finite path selects an actual leaf of its source support. Left is that
/// support and Right is the selected candidate, not the reading's answer.
public enum SelectCandidateLeaf<X>: Pair {
    public typealias Left = CandidateLeaf<X>
    public typealias Right = X
}

public enum SelectCandidateLeft<P: Pair, R: Pair>: Pair
where P.Left: Pair {
    public typealias Left = CandidateFork<P.Left, R>
    public typealias Right = P.Right
}

public enum SelectCandidateRight<L: Pair, P: Pair>: Pair
where P.Left: Pair {
    public typealias Left = CandidateFork<L, P.Left>
    public typealias Right = P.Right
}

/// One response has support at both addressed catalogues in C. P and Q
/// must start at those actual catalogues; their selected responses agree.
/// Finite leaf-selection paths and recursive joins give this interpretation.
/// An arbitrary Pair conformance does not establish membership. This is a
/// common-response witness, not an enumeration of every response. [Matter M25a]
public enum CommonCandidateResponse<C: Pair, P: Pair, Q: Pair>: Pair
where C.Left == P.Left, C.Right == Q.Left, P.Right == Q.Right {
    public typealias Left = C
    public typealias Right = P.Right
}

/// A finite selection path also removes its selected occurrence. Forks stay
/// in place, so Address does not change when another leaf is removed.
public protocol CandidateRemoval: Pair
where Left: Pair {
    associatedtype Remainder: Pair
    associatedtype Address: Structure
}

extension SelectCandidateLeaf: CandidateRemoval {
    public typealias Remainder = Never
    public typealias Address = Never
}

extension SelectCandidateLeft: CandidateRemoval
where P: CandidateRemoval {
    public typealias Remainder = CandidateFork<P.Remainder, R>
    public typealias Address = Paired<Never, P.Address>
}

extension SelectCandidateRight: CandidateRemoval
where P: CandidateRemoval {
    public typealias Remainder = CandidateFork<L, P.Remainder>
    public typealias Address = Paired<Lit1, P.Address>
}

/// Removals in separate branches have one source, match both intermediate
/// remainders, and leave the same final support in either order. The four
/// equalities follow from the selection constructors. For actual occurrence
/// consumption, L and R must carry their finite selection interpretation.
public enum CandidateSiblingRemovalsCommute<L: CandidateRemoval, R: CandidateRemoval>: Null {
    public typealias FirstLeft = SelectCandidateLeft<L, R.Left>
    public typealias ThenRight = SelectCandidateRight<L.Remainder, R>
    public typealias FirstRight = SelectCandidateRight<L.Left, R>
    public typealias ThenLeft = SelectCandidateLeft<L, R.Remainder>

    public typealias Left = Paired<
        Paired<FirstLeft.Left, FirstLeft.Remainder>,
        Paired<FirstRight.Remainder, ThenRight.Remainder>
    >
    public typealias Right = Paired<
        Paired<FirstRight.Left, ThenRight.Left>,
        Paired<ThenLeft.Left, ThenLeft.Remainder>
    >
}

/// No leaf at this node or along either child axis. In particular a genuine
/// CandidateLeaf cannot satisfy Leaf == Never, even with an empty payload.
/// An empty cycle can satisfy this safety condition without having finite
/// depth. Exhausting a finite source still uses the actual removal sequence.
public protocol EmptyCandidateSupport: CandidateNode
where Leaf == Never, Left: EmptyCandidateSupport, Right: EmptyCandidateSupport {}

extension Never: EmptyCandidateSupport {}
extension CandidateFork: EmptyCandidateSupport
where L: EmptyCandidateSupport, R: EmptyCandidateSupport {}

/// The conditional constructor proofs below derive the selected candidate's
/// equality to the source's common member. The finite path grammar supplies
/// membership. An unrelated Pair conformance does not supply such a path.
public protocol SingletonCandidateSelection: Pair
where Left: SingleCandidateSupport, Right == Left.Member {}

extension SelectCandidateLeaf: SingletonCandidateSelection {}

extension SelectCandidateLeft: SingletonCandidateSelection
where P: SingletonCandidateSelection, R: SingleCandidateSupport,
      P.Left.Member == R.Member {}

extension SelectCandidateRight: SingletonCandidateSelection
where L: SingleCandidateSupport, P: SingletonCandidateSelection,
      L.Member == P.Left.Member {}

/// Both paths must start at the independently checked declaration. Their
/// candidate equality follows from the conditional path proofs, without an
/// equality premise between those candidates. [V=I U2a]
public enum IdentifyCoveredCandidates<
    C: CoverageMatchesDeclaration,
    P: SingletonCandidateSelection,
    T: SingletonCandidateSelection
>: Null
where P.Left == C.Right, T.Left == C.Right {
    public typealias Left = P.Right
    public typealias Right = T.Right
}

public enum CoveredLeaf<R: PredicateReading>: CandidateLeafReading {
    public typealias Left = R.Left
    public typealias Right = R.Answer
    public typealias Sigma = R.Sigma
    public typealias Encoding = R.Encoding
    public typealias Predicate = R.Predicate
    public typealias Answer = R.Answer
    public typealias Candidates = CandidateLeaf<R.Left>
}

public enum CoveredJoin<
    L: CandidateReading,
    R: CandidateReading
>: VerdictCoversBranches
where L.Sigma == R.Sigma, L.Encoding == R.Encoding,
      L.Predicate == R.Predicate, L.Answer == R.Answer {
    public typealias Left = L
    public typealias Right = R
    public typealias Sigma = L.Sigma
    public typealias Encoding = L.Encoding
    public typealias Predicate = L.Predicate
    public typealias Answer = L.Answer
    public typealias Candidates = CandidateFork<L.Candidates, R.Candidates>
}

public enum CoveredGroup<C: VerdictCoversBranches>: CandidateGroupReading {
    public typealias Certificate = C
    public typealias Left = C
    public typealias Right = C.Answer
    public typealias Sigma = C.Sigma
    public typealias Encoding = C.Encoding
    public typealias Predicate = C.Predicate
    public typealias Answer = C.Answer
    public typealias Candidates = C.Candidates
}

public enum CheckedCoverage<
    C: VerdictCoversBranches,
    Declaration
>: CoverageMatchesDeclaration
where C.Candidates == Declaration {
    public typealias Left = C
    public typealias Right = Declaration
}

public typealias CoveredTwoBeams = CoveredJoin<
    CoveredLeaf<VisibleReading<RedBeam>>,
    CoveredLeaf<VisibleReading<RedBeamWithIR>>
>
public typealias CoveredThreeBeams = CoveredJoin<
    CoveredGroup<CoveredTwoBeams>,
    CoveredLeaf<VisibleReading<RedBeamWithMoreIR>>
>

/// Independent declaration: deriving this alias from the certificate would
/// make the coverage comparison automatic and conceal omitted candidates.
public typealias DeclaredThreeBeams = CandidateFork<
    CandidateFork<CandidateLeaf<RedBeam>, CandidateLeaf<RedBeamWithIR>>,
    CandidateLeaf<RedBeamWithMoreIR>
>
public typealias ThreeBeamsCovered = CheckedCoverage<CoveredThreeBeams, DeclaredThreeBeams>

public enum AlphaQuestion: Close {}

/// Direct application to a beam.
public enum AlphaReading<B: BeamShape>: PredicateReading {
    public typealias Left = B
    public typealias Right = B.AlphaLevel
    public typealias Sigma = BeamSpace
    public typealias Encoding = EyeEncoding
    public typealias Predicate = AlphaQuestion
    public typealias Answer = B.AlphaLevel
}

/// Application through its visible image. Sigma and Encoding name the ambient
/// model, while Left names the representation actually consumed here.
public enum ImageAlphaReading<I: Pair>: PredicateReading {
    public typealias Left = I
    public typealias Right = I.Left
    public typealias Sigma = BeamSpace
    public typealias Encoding = EyeEncoding
    public typealias Predicate = AlphaQuestion
    public typealias Answer = I.Left
}

/// For every BeamShape, the visible projection retains the alpha coordinate.
/// The body derives the output equality by reducing EyeImage<B>. No answer
/// equality is requested from a caller, and no hidden coordinate is inspected.
public enum AlphaFactors<B: BeamShape>: ReadingFactors {
    public typealias Left = AlphaReading<B>
    public typealias Right = ImageAlphaReading<EyeImage<B>>
    public typealias Observation = VisibleReading<B>
    public typealias Sigma = BeamSpace
    public typealias Encoding = EyeEncoding
    public typealias Predicate = AlphaQuestion
    public typealias Answer = B.AlphaLevel
}

public enum SharedVisibleImage<
    L: BeamShape,
    R: BeamShape
>: SharedDecoder
where EyeImage<L> == EyeImage<R> {
    public typealias Left = AlphaFactors<L>
    public typealias Right = AlphaFactors<R>
}

/// Equality of direct answers follows from the shared intermediate reading.
public typealias AnswersThroughSharedDecoder<S: SharedDecoder> = JoinedVerdict<
    S.Left.Left,
    S.Right.Left
>

/// The family's visible coordinates are fixed while its infrared coordinate
/// ranges over IntegerValued. Finiteness of arbitrary conformances is not needed.
public protocol RedVisibleBeam: BeamShape
where AlphaLevel == Lit1, BetaLevel == Never {}

extension RedBeam: RedVisibleBeam {}
extension RedBeamWithIR: RedVisibleBeam {}
extension RedBeamWithMoreIR: RedVisibleBeam {}

public enum RedWithHidden<H: IntegerValued>: RedVisibleBeam {
    public typealias AlphaLevel = Lit1
    public typealias BetaLevel = Never
    public typealias PaschenLevel = H
}

/// A finite generic proof covers any two members, including arbitrarily deep
/// finite Succ expressions. It does not enumerate or identify the hidden values.
public enum RedFamilyVerdict<
    L: RedVisibleBeam,
    R: RedVisibleBeam
>: VerdictIsInvariant {
    public typealias Left = VisibleReading<L>
    public typealias Right = VisibleReading<R>
    public typealias Sigma = BeamSpace
    public typealias Encoding = EyeEncoding
    public typealias Predicate = VisibleQuestion
    public typealias Answer = Paired<Lit1, Never>
}

/// A symbolic transformation that makes a hidden coordinate visible. This is
/// a countermodel for arbitrary operations, not a claim about optical physics.
public enum ExposeHidden<B: BeamShape>: BeamShape {
    public typealias AlphaLevel = B.PaschenLevel
    public typealias BetaLevel = Never
    public typealias PaschenLevel = Never
}

/// A symbolic transformation that exchanges visible coordinates and retains
/// the hidden one. Its visible result can be computed from the original image.
public enum SwapVisible<B: BeamShape>: Close, BeamShape {
    public typealias AlphaLevel = B.BetaLevel
    public typealias BetaLevel = B.AlphaLevel
    public typealias PaschenLevel = B.PaschenLevel
}

public enum SwappedVisibleQuestion: Close {}

public enum SwappedVisibleReading<B: BeamShape>: PredicateReading {
    public typealias Left = B
    public typealias Right = EyeImage<SwapVisible<B>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = EyeEncoding
    public typealias Predicate = SwappedVisibleQuestion
    public typealias Answer = Right
}

public enum ImageSwapReading<I: Pair>: PredicateReading
where I.Left: Structure, I.Right: Structure {
    public typealias Left = I
    public typealias Right = Paired<I.Right, I.Left>
    public typealias Sigma = BeamSpace
    public typealias Encoding = EyeEncoding
    public typealias Predicate = SwappedVisibleQuestion
    public typealias Answer = Right
}

/// The same factorization relation handles a future question. The constructor
/// checks the commuting square for the swap without consulting the hidden axis.
public enum SwapFactors<B: BeamShape>: ReadingFactors {
    public typealias Left = SwappedVisibleReading<B>
    public typealias Right = ImageSwapReading<EyeImage<B>>
    public typealias Observation = VisibleReading<B>
    public typealias Sigma = BeamSpace
    public typealias Encoding = EyeEncoding
    public typealias Predicate = SwappedVisibleQuestion
    public typealias Answer = EyeImage<SwapVisible<B>>
}

public enum SharedSwappedImage<
    L: BeamShape,
    R: BeamShape
>: SharedDecoder
where EyeImage<L> == EyeImage<R> {
    public typealias Left = SwapFactors<L>
    public typealias Right = SwapFactors<R>
}

/// Record a directly available answer and retain the actual source separately.
/// The transcript is Right.Right; it contains the answer and a fixed terminator.
/// The reading's correctness and availability remain premises. This constructor
/// proves neither a binary implementation nor preparation of physical memory.
public enum DirectAnswerRecord<R: PredicateReading>: Permanent
where R.Left: Structure, R.Answer: Structure {
    public typealias Left = R.Left
    public typealias Right = Paired<R.Left, Paired<R.Answer, Never>>
}
