import VerificationIsIdentification

/// A sequence names the first operation and then the second. It is an ordered
/// expression, with no assertion that the operations commute with each other.
public enum OperationSequence<
    First,
    Second
>: Pair {
    public typealias Left = First
    public typealias Right = Second
}

/// Expand two resident two-operation definitions into an ordered primitive
/// word. The definitions are data in the input, not an external dictionary.
public enum TwoMacroExpansion<T: Pair>: Pair
where T.Left: Pair, T.Right: Pair,
      T.Left.Left: Structure, T.Left.Right: Structure,
      T.Right.Left: Structure, T.Right.Right: Structure {
    public typealias Left = T.Left.Left
    public typealias Right = Paired<T.Left.Right, Paired<T.Right.Left, Paired<T.Right.Right, Never>>>
}

/// A fixed deterministic output context: pair the read answer with S.
/// The question names both the original reading and this context parameter.
public enum PostPairReading<
    R: PredicateReading,
    S: Structure
>: PredicateReading
where R.Answer: Structure {
    public typealias Left = R.Left
    public typealias Right = Paired<R.Answer, S>
    public typealias Sigma = R.Sigma
    public typealias Encoding = R.Encoding
    public typealias Predicate = OperationSequence<R.Predicate, S>
    public typealias Answer = Right
}

/// Lift an existing certificate through that same output context. The new
/// answer equality follows from C and the constructor, without a new premise.
public enum PostPairAgreement<
    C: VerdictIsInvariant,
    S: Structure
>: VerdictIsInvariant
where C.Answer: Structure {
    public typealias Left = PostPairReading<C.Left, S>
    public typealias Right = PostPairReading<C.Right, S>
    public typealias Sigma = C.Sigma
    public typealias Encoding = C.Encoding
    public typealias Predicate = OperationSequence<C.Predicate, S>
    public typealias Answer = Paired<C.Answer, S>
}

/// Sequential application requires the actual intermediate source to match.
/// Its semantics are composition of the supplied applications, within the
/// finite constructor grammar. An arbitrary PredicateReading is still a premise.
public enum SequentialReading<
    F: PredicateReading,
    G: PredicateReading
>: PredicateReading
where F.Answer == G.Left, F.Sigma == G.Sigma, F.Encoding == G.Encoding {
    public typealias Left = F.Left
    public typealias Right = G.Answer
    public typealias Sigma = F.Sigma
    public typealias Encoding = F.Encoding
    public typealias Predicate = OperationSequence<F.Predicate, G.Predicate>
    public typealias Answer = G.Answer
}

/// An established recovery through A then B supplies a reading at the cut
/// after A. Its decoder uses the actual suffix B and the endpoint decoder.
/// No correctness of a separately chosen middle reading is assumed. [M72]
public enum RecoveryBeforeSuffix<
    A: PredicateReading,
    B: PredicateReading,
    F: ReadingFactors
>: ReadingFactors
where A.Answer == B.Left, A.Sigma == B.Sigma, A.Encoding == B.Encoding,
      F.Observation == SequentialReading<A, B> {
    public typealias Left = F.Left
    public typealias Right = DecodeRefinedEvidence<B, F.Right>
    public typealias Observation = A
    public typealias Sigma = F.Sigma
    public typealias Encoding = F.Encoding
    public typealias Predicate = F.Predicate
    public typealias Answer = F.Answer
}

/// A supplied actual return recovers the source of an independently chosen
/// question. The decoder starts at the forward answer and follows that return;
/// no equality of question answers is requested from the caller. This is a
/// certificate for the supplied path, not knowledge of an unrecorded path.
public enum AnswerThroughReturn<
    Q: PredicateReading,
    A: PredicateReading,
    B: PredicateReading
>: ReadingFactors
where A.Left == Q.Left, B.Left == A.Answer, B.Answer == Q.Left,
      A.Sigma == Q.Sigma, B.Sigma == Q.Sigma,
      A.Encoding == Q.Encoding, B.Encoding == Q.Encoding {
    public typealias Left = Q
    public typealias Observation = A
    public typealias Right = DecodeRefinedEvidence<B, Q>
    public typealias Sigma = Q.Sigma
    public typealias Encoding = Q.Encoding
    public typealias Predicate = Q.Predicate
    public typealias Answer = Q.Answer
}

/// Select the actual application from a supplied current root:
/// (working source, (library expression, application catalogue)). The local
/// policy returns its finite path address. There is no independently supplied
/// primitive that can be substituted merely because its Predicate matches.
/// Root adequacy and the finite SelectCandidate grammar remain premises;
/// the root expression does not certify arbitrary application conformances.
public enum SelectedLocalApplication<
    Root: Pair,
    I: PredicateReading,
    D: PredicateReading,
    S: CandidateRemoval
>: PredicateReading
where Root.Right: Pair, Root.Right.Left: Structure,
      S.Left == Root.Right.Right, S.Right: PredicateReading,
      S.Right.Left == Root.Left, I.Left == Root.Left,
      I.Answer == D.Left, D.Answer == S.Address,
      I.Sigma == S.Right.Sigma, D.Sigma == S.Right.Sigma,
      I.Encoding == S.Right.Encoding, D.Encoding == S.Right.Encoding,
      D.Left: Pair, D.Left.Right: Structure {
    public typealias Primitive = S.Right
    public typealias Left = Root.Left
    public typealias Right = Primitive.Answer
    public typealias Sigma = Primitive.Sigma
    public typealias Encoding = Primitive.Encoding
    public typealias Predicate = OperationSequence<
        Root.Right.Left, OperationSequence<OperationSequence<I.Predicate, D.Predicate>, D.Left.Right>>
    public typealias Answer = Right
    public typealias Selection = SequentialReading<I, D>
}

/// A supplied return R reaches the source of the actual forward square P.
/// Reading there and applying P's image step recovers the current answer.
/// Both return endpoints are bound, with no new output equality premise.
/// This certifies the supplied applications, not a total inverse family. [VC21]
/// A common operation tag alone does not supply one decoder across sources.
public enum CurrentAnswerFromPredecessor<
    P: CommutingTransition,
    R: PredicateReading
>: Null
where R.Left == P.SourceStep.Answer, R.Answer == P.SourceStep.Left,
      R.Sigma == P.Sigma, R.Encoding == P.Encoding {
    public typealias Observation = SequentialReading<R, P.Left>
    public typealias Decoder = P.ImageStep
    public typealias Recovery = SequentialReading<Observation, Decoder>
    public typealias Current = P.Right
    public typealias Left = Recovery.Answer
    public typealias Right = Current.Answer
}

/// Apply F to the actual first input and G to the actual second input.
/// Lift both applications to one paired source, then combine their answers
/// through JointEvidence. This defines an application, not a physical clock.
public typealias PairedApplication<F: PredicateReading, G: PredicateReading> = JointEvidence<
    SequentialReading<FirstEvidenceImage<Paired<F.Left, G.Left>, F.Sigma, F.Encoding, FirstProjection>, F>,
    SequentialReading<SecondEvidenceImage<Paired<F.Left, G.Left>, G.Sigma, G.Encoding, SecondProjection>, G>
>
where F.Sigma == G.Sigma, F.Encoding == G.Encoding,
      F.Left: Structure, G.Left: Structure, F.Answer: Structure, G.Answer: Structure

/// Combine two independently supplied factorizations at their paired source.
/// Both decoders receive only their own observation; no answer equality is
/// added beyond the two supplied factors.
public enum PairedFactorization<F: ReadingFactors, G: ReadingFactors>: ReadingFactors
where F.Sigma == G.Sigma, F.Encoding == G.Encoding,
      F.Left.Left: Structure, G.Left.Left: Structure,
      F.Observation.Answer: Structure, G.Observation.Answer: Structure,
      F.Answer: Structure, G.Answer: Structure {
    public typealias Left = PairedApplication<F.Left, G.Left>
    public typealias Observation = PairedApplication<F.Observation, G.Observation>
    public typealias Right = PairedApplication<F.Right, G.Right>
    public typealias Sigma = F.Sigma
    public typealias Encoding = F.Encoding
    public typealias Predicate = Left.Predicate
    public typealias Answer = Paired<F.Answer, G.Answer>
}

/// Two local applications on disjoint pair fields have the same paired
/// source and answer in either order and in PairedApplication. Intermediate
/// records and operation descriptions need not agree. No output equality
/// between the orders is supplied by the caller. [Distance G14b]
public enum IndependentReadingOrders<F: PredicateReading, G: PredicateReading>: Null
where F.Sigma == G.Sigma, F.Encoding == G.Encoding,
      F.Left: Structure, G.Left: Structure, F.Answer: Structure, G.Answer: Structure {
    public typealias FirstThenSecond = SequentialReading<
        PairedApplication<F, IdentityReading<G.Left, G.Sigma, G.Encoding>>,
        PairedApplication<IdentityReading<F.Answer, F.Sigma, F.Encoding>, G>
    >
    public typealias SecondThenFirst = SequentialReading<
        PairedApplication<IdentityReading<F.Left, F.Sigma, F.Encoding>, G>,
        PairedApplication<F, IdentityReading<G.Answer, G.Sigma, G.Encoding>>
    >
    public typealias Together = PairedApplication<F, G>
    public typealias Left = Paired<
        Paired<FirstThenSecond.Left, FirstThenSecond.Answer>,
        Paired<SecondThenFirst.Left, SecondThenFirst.Answer>
    >
    public typealias Right = Paired<
        Paired<Together.Left, Together.Answer>,
        Paired<Together.Left, Together.Answer>
    >
}

/// The compiler derives the outer square from its two inner squares. There
/// is no independent equality premise between the final image and observation.
public enum JoinedTransition<
    F: CommutingTransition,
    G: CommutingTransition
>: CommutingTransition
where F.Right == G.Left {
    public typealias Left = F.Left
    public typealias Right = G.Right
    public typealias Sigma = F.Sigma
    public typealias Encoding = F.Encoding
    public typealias Operation = OperationSequence<F.Operation, G.Operation>
    public typealias SourceStep = SequentialReading<F.SourceStep, G.SourceStep>
    public typealias ImageStep = SequentialReading<F.ImageStep, G.ImageStep>
}

/// Compose changes of representation across the same actual middle action.
/// P connects sources to images; Q connects those images to another image.
/// The final square follows without a premise about its final answer. Exact
/// partial-domain reflection remains a property of the supplied families,
/// not a consequence of one successful square alone. [VI VC51]
public enum ReobservedTransition<
    P: CommutingTransition,
    Q: CommutingTransition
>: CommutingTransition
where P.ImageStep == Q.SourceStep {
    public typealias Left = DecodeRefinedEvidence<P.Left, Q.Left>
    public typealias Right = DecodeRefinedEvidence<P.Right, Q.Right>
    public typealias Sigma = P.Sigma
    public typealias Encoding = P.Encoding
    public typealias Operation = P.Operation
    public typealias SourceStep = P.SourceStep
    public typealias ImageStep = Q.ImageStep
}

/// A question at the end of a certified path factors through its initial
/// image. Both answer paths name the operation followed by that question.
/// The caller supplies the endpoint factorization, not the final equality.
public enum QuestionAlongTransition<
    P: CommutingTransition,
    F: ReadingFactors
>: ReadingFactors
where F.Observation == P.Right {
    public typealias Left = SequentialReading<P.SourceStep, F.Left>
    public typealias Right = SequentialReading<P.ImageStep, F.Right>
    public typealias Observation = P.Left
    public typealias Sigma = P.Sigma
    public typealias Encoding = P.Encoding
    public typealias Predicate = OperationSequence<P.Operation, F.Predicate>
    public typealias Answer = F.Answer
}

/// An arbitrary certified path and endpoint question reuse evidence of the
/// initial image. Neither final answer nor final source is an extra premise.
/// The operation path remains part of the question. [VI VC52]
public typealias FutureOnEvidence<
    P: CommutingTransition,
    F: ReadingFactors,
    G: ReadingFactors
> = AnswerOnRefinement<QuestionAlongTransition<P, F>, G>
where F.Observation == P.Right, G.Left == P.Left

public enum IdentityOperation: Close {}
public enum SwapOperation: Close {}
public enum ForgetHiddenOperation: Close {}

public enum IdentityReading<
    X,
    S,
    E
>: PredicateReading, Null {
    public typealias Left = X
    public typealias Right = X
    public typealias Sigma = S
    public typealias Encoding = E
    public typealias Predicate = IdentityOperation
    public typealias Answer = X
}

/// The empty path is a square for any supplied observation. It changes neither
/// source nor image, and provides the induction base without a new equality.
public enum IdentityTransition<R: PredicateReading>: CommutingTransition {
    public typealias Left = R
    public typealias Right = R
    public typealias Sigma = R.Sigma
    public typealias Encoding = R.Encoding
    public typealias Operation = IdentityOperation
    public typealias SourceStep = IdentityReading<R.Left, R.Sigma, R.Encoding>
    public typealias ImageStep = IdentityReading<R.Answer, R.Sigma, R.Encoding>
}

public enum SwapSourceReading<B: BeamShape>: PredicateReading {
    public typealias Left = B
    public typealias Right = SwapVisible<B>
    public typealias Sigma = BeamSpace
    public typealias Encoding = EyeEncoding
    public typealias Predicate = SwapOperation
    public typealias Answer = Right
}

public enum SwapImageReading<I: Pair>: PredicateReading
where I.Left: Structure, I.Right: Structure {
    public typealias Left = I
    public typealias Right = Paired<I.Right, I.Left>
    public typealias Sigma = BeamSpace
    public typealias Encoding = EyeEncoding
    public typealias Predicate = SwapOperation
    public typealias Answer = Right
}

public enum SwapTransition<B: BeamShape>: CommutingTransition {
    public typealias Left = VisibleReading<B>
    public typealias Right = VisibleReading<SwapVisible<B>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = EyeEncoding
    public typealias Operation = SwapOperation
    public typealias SourceStep = SwapSourceReading<B>
    public typealias ImageStep = SwapImageReading<EyeImage<B>>
}

/// A symbolic erasure, distinct from the book's permanent historical record.
/// The example concerns a current source representation and its visible image.
public enum ForgetHidden<B: BeamShape>: BeamShape {
    public typealias AlphaLevel = B.AlphaLevel
    public typealias BetaLevel = B.BetaLevel
    public typealias PaschenLevel = Never
}

public enum ForgetSourceReading<B: BeamShape>: PredicateReading {
    public typealias Left = B
    public typealias Right = ForgetHidden<B>
    public typealias Sigma = BeamSpace
    public typealias Encoding = EyeEncoding
    public typealias Predicate = ForgetHiddenOperation
    public typealias Answer = Right
}

public enum ForgetImageReading<I>: PredicateReading {
    public typealias Left = I
    public typealias Right = I
    public typealias Sigma = BeamSpace
    public typealias Encoding = EyeEncoding
    public typealias Predicate = ForgetHiddenOperation
    public typealias Answer = I
}

public enum ForgetTransition<B: BeamShape>: CommutingTransition {
    public typealias Left = VisibleReading<B>
    public typealias Right = VisibleReading<ForgetHidden<B>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = EyeEncoding
    public typealias Operation = ForgetHiddenOperation
    public typealias SourceStep = ForgetSourceReading<B>
    public typealias ImageStep = ForgetImageReading<EyeImage<B>>
}

/// The existing composition, named at its matching observation endpoint.
public typealias AppendSwap<
    P: CommutingTransition,
    B: BeamShape
> = JoinedTransition<P, SwapTransition<B>>
where P.Right == VisibleReading<B>

/// Alpha is preserved while a hidden coordinate becomes beta. The alpha
/// projection executes by itself, but the larger visible pair needs more data.
public enum ExposeHiddenAsBeta<B: BeamShape>: BeamShape {
    public typealias AlphaLevel = B.AlphaLevel
    public typealias BetaLevel = B.PaschenLevel
    public typealias PaschenLevel = B.PaschenLevel
}
