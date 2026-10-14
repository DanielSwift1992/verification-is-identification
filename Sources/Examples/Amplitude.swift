import VerificationIsIdentification

/// Expand one signed integer contribution into an existing unit word.
/// Finite constructor expressions below establish the expansion. This open
/// interface does not prove that an arbitrary supplied expansion is correct.
public protocol AmplitudeBlock {
    associatedtype Before: Bonds
    associatedtype After: Bonds
    associatedtype Magnitude: IntegerValued
    associatedtype Phase
}

public enum StartAmplitudeBlock<W: Bonds, P>: AmplitudeBlock {
    public typealias Before = W
    public typealias After = W
    public typealias Magnitude = Never
    public typealias Phase = P
}

public enum PositiveAmplitudeUnit<C: AmplitudeBlock>: AmplitudeBlock
where C.Phase == Phase0 {
    public typealias Before = C.Before
    public typealias After = In<C.After>
    public typealias Magnitude = Succ<C.Magnitude>
    public typealias Phase = C.Phase
}

public enum NegativeAmplitudeUnit<C: AmplitudeBlock>: AmplitudeBlock
where C.Phase == PhaseHalf {
    public typealias Before = C.Before
    public typealias After = Out<C.After>
    public typealias Magnitude = Succ<C.Magnitude>
    public typealias Phase = C.Phase
}

/// Original contributions and their accumulated unit word. In/Out provide
/// two existing counters, interpreted here as positive/negative amplitude
/// units. This interpretation does not identify amplitudes with ice bonds.
public protocol AmplitudeSum {
    associatedtype Source: Structure
    associatedtype Word: Bonds
}

public enum EmptyAmplitudeSum: AmplitudeSum {
    public typealias Source = Never
    public typealias Word = Vacuum
}

/// The block must start at the preceding word. Its computed magnitude and
/// phase reconstruct the actual appended contribution in the source.
public enum AppendAmplitudeBlock<S: AmplitudeSum, C: AmplitudeBlock>: AmplitudeSum
where C.Before == S.Word {
    public typealias Source = Paired<S.Source, Contribution<C.Magnitude, C.Phase>>
    public typealias Word = C.After
}

public enum SignedAmplitudeSpace: Close {}
public enum SignedAmplitudeEncoding: Close {}
public enum SignedTotalQuestion: Close {}

/// Exact zero of the signed amplitude under the finite unit interpretation.
/// Both counts come from the same source-bound expansion. No runtime sum
/// or caller-supplied answer appears here. Physical intensity is a later law.
public enum ZeroAmplitudeReading<S: AmplitudeSum>: PredicateReading
where S.Word.InCount == S.Word.OutCount {
    public typealias Left = S.Source
    public typealias Right = Never
    public typealias Answer = Never
    public typealias Sigma = SignedAmplitudeSpace
    public typealias Encoding = SignedAmplitudeEncoding
    public typealias Predicate = SignedTotalQuestion
}

/// A zero-amplitude pair of any supplied common magnitude. The original
/// source contains both amplitudes, with the two opposed phase coordinates.
public enum OppositeAmplitudeReading<M: IntegerValued>: PredicateReading {
    public typealias Left = Paired<Contribution<M, Phase0>, Contribution<M, PhaseHalf>>
    public typealias Right = Never
    public typealias Answer = Never
    public typealias Sigma = SignedAmplitudeSpace
    public typealias Encoding = SignedAmplitudeEncoding
    public typealias Predicate = SignedTotalQuestion
}

public enum NaturalArithmeticSpace: Close {}
public enum UnaryArithmeticEncoding: Close {}
public enum NaturalSumQuestion: Close {}
public enum NaturalProductQuestion: Close {}

/// Operand and answer coordinates for addition. Correctness is established
/// by the finite AddZero/AddSuccessor constructor grammar below, not by an
/// arbitrary conformance to this open interface. Never is its chosen zero.
///
/// First and Second name the two operands, and each constructor pairs them
/// as Left. A successor step reads the previous operands through these named
/// associated types. On Swift 6.2.3 a depth-36 chain then checks without the
/// slowdown of the nested-address form. Left stays an independent requirement. A protocol-level link from Left to First and
/// Second makes Swift 6.2 drop requirements that other signatures write
/// through Left.Left, and the Gram refusal fixtures catch that loss.
public protocol NaturalSum: PredicateReading
where Left: Pair, Left.Left: IntegerValued, Left.Right: IntegerValued,
      Answer: IntegerValued, Sigma == NaturalArithmeticSpace,
      Encoding == UnaryArithmeticEncoding, Predicate == NaturalSumQuestion {
    associatedtype First: IntegerValued
    associatedtype Second: IntegerValued
}

public enum AddZero<B: IntegerValued>: NaturalSum {
    public typealias First = Never
    public typealias Second = B
    public typealias Left = Paired<First, Second>
    public typealias Answer = B
    public typealias Right = Answer
    public typealias Sigma = NaturalArithmeticSpace
    public typealias Encoding = UnaryArithmeticEncoding
    public typealias Predicate = NaturalSumQuestion
}

/// One successor in the first operand becomes one in the same result.
public enum AddSuccessor<P: NaturalSum>: NaturalSum {
    public typealias First = Succ<P.First>
    public typealias Second = P.Second
    public typealias Left = Paired<First, Second>
    public typealias Answer = Succ<P.Answer>
    public typealias Right = Answer
    public typealias Sigma = NaturalArithmeticSpace
    public typealias Encoding = UnaryArithmeticEncoding
    public typealias Predicate = NaturalSumQuestion
}

/// Operand and answer coordinates for multiplication. The finite product
/// constructors must use additions from the finite sum grammar. A supplied
/// interface conformance alone does not establish its arithmetic meaning.
///
/// First and Second name the two operands, as in NaturalSum.
public protocol NaturalProduct: PredicateReading
where Left: Pair, Left.Left: IntegerValued, Left.Right: IntegerValued,
      Answer: IntegerValued, Sigma == NaturalArithmeticSpace,
      Encoding == UnaryArithmeticEncoding, Predicate == NaturalProductQuestion {
    associatedtype First: IntegerValued
    associatedtype Second: IntegerValued
}

public enum ProductZero<B: IntegerValued>: NaturalProduct {
    public typealias First = Never
    public typealias Second = B
    public typealias Left = Paired<First, Second>
    public typealias Answer = Never
    public typealias Right = Answer
    public typealias Sigma = NaturalArithmeticSpace
    public typealias Encoding = UnaryArithmeticEncoding
    public typealias Predicate = NaturalProductQuestion
}

/// The addition must start with the previous product and the same second
/// operand. Its computed answer becomes the next product, with no count call.
public enum ProductSuccessor<P: NaturalProduct, A: NaturalSum>: NaturalProduct
where A.First == P.Answer, A.Second == P.Second {
    public typealias First = Succ<P.First>
    public typealias Second = P.Second
    public typealias Left = Paired<First, Second>
    public typealias Answer = A.Answer
    public typealias Right = Answer
    public typealias Sigma = NaturalArithmeticSpace
    public typealias Encoding = UnaryArithmeticEncoding
    public typealias Predicate = NaturalProductQuestion
}
