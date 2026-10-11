import VerificationIsIdentification

// Recursive basis-dimension expressions, with a check for dimension One.
// In the finite NoEigenstate/Eigenstate grammar the count is the number of
// basis-direction slots. An eigenspace of dimension g>1 has continuously
// many rays, not g possible states. Matter §5 proves the separate rank-one
// conditional-output theorem for an ideal projective instrument.

/// The one-successor dimension expression in this example's numeral grammar.
public typealias One = Succ<Never>

/// Names a dimension coordinate. The finite constructors below give it a
/// basis-slot interpretation, without supplying vectors or an operator.
public protocol Eigenspace { associatedtype Dimension: IntegerValued }

/// The terminal dimension expression, interpreted as zero basis directions.
public enum NoEigenstate: Eigenspace {
public typealias Dimension = Never }

/// Adds one basis-direction slot to the finite constructor expression.
/// It does not append every state vector belonging to an eigenspace.
public struct Eigenstate<
    Rest: Eigenspace
>: Eigenspace {
public typealias Dimension = Succ<Rest.Dimension> }

/// A declared admission marker. The conditional conformance below checks
/// Dimension==One. Its quantum meaning additionally needs an actual rank-one
/// projector and the specified instrument, as calculated in Matter §5.
public protocol IdentifyingMeasurement {}
extension Eigenstate: IdentifyingMeasurement
where Dimension == One {}

/// Admits a supplied IdentifyingMeasurement conformance. The finite
/// constructor case checks a dimension expression, not a physical outcome.
public enum Identified<
    Measurement: IdentifyingMeasurement
> {}

// The one-direction expression passes the supplied dimension test.
public typealias NonDegenerate = Identified<Eigenstate<NoEigenstate>>     // Dimension One ✓

// Four supplied basis slots, intended for the spinless Coulomb n=2 model.
// The constructor count does not derive the spectrum, include corrections,
// or enumerate the continuously many rays in the resulting eigenspace.
public typealias HydrogenLevel2 = Eigenstate<Eigenstate<Eigenstate<Eigenstate<NoEigenstate>>>>

// SHOW_REJECT checks Four against One and the legacy Unique coordinate.
// These refusals do not establish the physical interpretation of either type.
#if SHOW_REJECT
public typealias DegenerateIdentifies = Identified<HydrogenLevel2>   // Dimension Four ≠ One — refused
extension DegenerateMeasurement: SystemCrystallizes {}               // SolutionSet not Unique — refused
#endif

public enum MatrixEntrySpace: Close {}
public enum MatrixEntryEncoding: Close {}
public enum MatrixTransposeQuestion: Close {}
public enum AntisymmetricWeightQuestion: Close {}

/// Rows of a two-by-two matrix, or blocks of a two-factor matrix.
/// Entries need an explicit scalar interpretation, not a state marker.
public typealias MatrixEntries<A: Structure, B: Structure, C: Structure, D: Structure> =
    Paired<Paired<A, B>, Paired<C, D>>

/// Transpose actual entry addresses. Applied to every two-by-two block via
/// PairedApplication, this transposes the second tensor factor, not both.
public enum TransposeEntries<M: Pair>: PredicateReading
where M.Left: Pair, M.Right: Pair,
      M.Left.Left: Structure, M.Left.Right: Structure,
      M.Right.Left: Structure, M.Right.Right: Structure {
    public typealias Left = M
    public typealias Answer = MatrixEntries<
        M.Left.Left, M.Right.Left, M.Left.Right, M.Right.Right
    >
    public typealias Right = Answer
    public typealias Sigma = MatrixEntrySpace
    public typealias Encoding = MatrixEntryEncoding
    public typealias Predicate = MatrixTransposeQuestion
}

/// Read the four signed integer terms of v* M v for v=(0,1,-1,0).
/// The source stores two-by-two blocks, each itself two-by-two. Only the
/// four accessed entries need integer interpretations. Normalization of a
/// physical state and probe is a positive scale supplied in the article.
public enum AntisymmetricWeightTerms<M: Pair>: PredicateReading
where M.Left: Pair, M.Right: Pair,
      M.Left.Left: Pair, M.Left.Right: Pair,
      M.Right.Left: Pair, M.Right.Right: Pair,
      M.Left.Left.Right: Pair, M.Left.Right.Right: Pair,
      M.Right.Left.Left: Pair, M.Right.Right.Left: Pair,
      M.Left.Left.Right.Right: IntegerValued,
      M.Right.Right.Left.Left: IntegerValued,
      M.Left.Right.Right.Left: IntegerValued,
      M.Right.Left.Left.Right: IntegerValued {
    public typealias Left = M
    public typealias Answer = Paired<Paired<Paired<Paired<Never,
        Contribution<M.Left.Left.Right.Right, Phase0>>,
        Contribution<M.Right.Right.Left.Left, Phase0>>,
        Contribution<M.Left.Right.Right.Left, PhaseHalf>>,
        Contribution<M.Right.Left.Left.Right, PhaseHalf>>
    public typealias Right = Answer
    public typealias Sigma = MatrixEntrySpace
    public typealias Encoding = MatrixEntryEncoding
    public typealias Predicate = AntisymmetricWeightQuestion
}

public enum GramMatrixQuestion: Close {}

/// Construct the actual matrix (a*a, a*b; a*b, b*b) from three arithmetic
/// derivations sharing the two source coefficients. Positivity follows from
/// this Gram factorization under the finite natural-number interpretation.
/// General complex factors and arbitrary NaturalProduct conformances need
/// their own justification. No positivity marker is required or supplied.
public enum NaturalGram<AA: NaturalProduct, AB: NaturalProduct, BB: NaturalProduct>: PredicateReading
where AA.Left.Left == AB.Left.Left, AA.Left.Right == AB.Left.Left,
      BB.Left.Left == AB.Left.Right, BB.Left.Right == AB.Left.Right {
    public typealias Left = AB.Left
    public typealias Answer = MatrixEntries<AA.Answer, AB.Answer, AB.Answer, BB.Answer>
    public typealias Right = Answer
    public typealias Sigma = MatrixEntrySpace
    public typealias Encoding = MatrixEntryEncoding
    public typealias Predicate = GramMatrixQuestion
}

public enum MatrixSumQuestion: Close {}

/// The four additions reconstruct both original matrices from their actual
/// operands and the result from their answers. Composing this with paired
/// Gram readings keeps their source factors linked to the summed matrix.
public enum AddNaturalMatrices<A: NaturalSum, B: NaturalSum, C: NaturalSum, D: NaturalSum>: PredicateReading {
    public typealias Left = Paired<
        MatrixEntries<A.Left.Left, B.Left.Left, C.Left.Left, D.Left.Left>,
        MatrixEntries<A.Left.Right, B.Left.Right, C.Left.Right, D.Left.Right>
    >
    public typealias Answer = MatrixEntries<A.Answer, B.Answer, C.Answer, D.Answer>
    public typealias Right = Answer
    public typealias Sigma = MatrixEntrySpace
    public typealias Encoding = MatrixEntryEncoding
    public typealias Predicate = MatrixSumQuestion
}

public typealias BasisRecordOperators = Paired<
    MatrixEntries<Lit1, Never, Never, Never>,
    MatrixEntries<Never, Never, Never, Lit1>
>
public enum BasisRecordQuestion: Close {}
public enum RecoverBasisMatrixQuestion: Close {}

/// The source contains both specified operators, the prepared record state
/// |0><0| and the input matrix. This fixes the preparation slice explicitly.
/// Output block (j,k) is K_j M K_k*. It retains the cross-record terms.
/// The article establishes this entry formula and its Kraus interpretation.
public enum BasisRecordMatrix<M: Pair>: PredicateReading
where M.Left: Pair, M.Right: Pair,
      M.Left.Left: Structure, M.Left.Right: Structure,
      M.Right.Left: Structure, M.Right.Right: Structure {
    public typealias Left = Paired<BasisRecordOperators,
        Paired<MatrixEntries<Lit1, Never, Never, Never>, M>>
    public typealias Answer = MatrixEntries<
        MatrixEntries<M.Left.Left, Never, Never, Never>,
        MatrixEntries<Never, M.Left.Right, Never, Never>,
        MatrixEntries<Never, Never, M.Right.Left, Never>,
        MatrixEntries<Never, Never, Never, M.Right.Right>
    >
    public typealias Right = Answer
    public typealias Sigma = MatrixEntrySpace
    public typealias Encoding = MatrixEntryEncoding
    public typealias Predicate = BasisRecordQuestion
}

/// Compression onto the two addressed basis-record directions. On an
/// actual BasisRecordMatrix output it recovers all four original entries.
public enum RecoverBasisMatrix<M: Pair>: PredicateReading
where M.Left: Pair, M.Right: Pair,
      M.Left.Left: Pair, M.Left.Right: Pair,
      M.Right.Left: Pair, M.Right.Right: Pair,
      M.Left.Left.Left: Pair, M.Left.Right.Left: Pair,
      M.Right.Left.Right: Pair, M.Right.Right.Right: Pair,
      M.Left.Left.Left.Left: Structure, M.Left.Right.Left.Right: Structure,
      M.Right.Left.Right.Left: Structure, M.Right.Right.Right.Right: Structure {
    public typealias Left = M
    public typealias Answer = MatrixEntries<
        M.Left.Left.Left.Left, M.Left.Right.Left.Right,
        M.Right.Left.Right.Left, M.Right.Right.Right.Right
    >
    public typealias Right = Answer
    public typealias Sigma = MatrixEntrySpace
    public typealias Encoding = MatrixEntryEncoding
    public typealias Predicate = RecoverBasisMatrixQuestion
}

/// Sum two disjoint diagonal blocks. The zeros are part of the actual
/// source, so arbitrary scalar terms A and D need no numerical adder.
public enum SumDisjointDiagonalEntries<A: Structure, D: Structure>: PredicateReading {
    public typealias Left = Paired<
        MatrixEntries<A, Never, Never, Never>,
        MatrixEntries<Never, Never, Never, D>
    >
    public typealias Answer = MatrixEntries<A, Never, Never, D>
    public typealias Right = Answer
    public typealias Sigma = MatrixEntrySpace
    public typealias Encoding = MatrixEntryEncoding
    public typealias Predicate = MatrixSumQuestion
}

public enum MatrixTraceQuestion: Close {}

/// The addition's actual operands occupy the two diagonal addresses.
/// Off-diagonal entries remain in the source and do not enter the trace.
public enum TraceNaturalEntries<A: NaturalSum, B: Structure, C: Structure>: PredicateReading {
    public typealias Left = MatrixEntries<A.Left.Left, B, C, A.Left.Right>
    public typealias Answer = A.Answer
    public typealias Right = Answer
    public typealias Sigma = MatrixEntrySpace
    public typealias Encoding = MatrixEntryEncoding
    public typealias Predicate = MatrixTraceQuestion
}

public enum MatrixDiagonalQuestion: Close {}

/// Read the actual diagonal, retaining no off-diagonal field in the image.
public enum ReadMatrixDiagonal<M: Pair>: PredicateReading
where M.Left: Pair, M.Right: Pair,
      M.Left.Left: Structure, M.Right.Right: Structure {
    public typealias Left = M
    public typealias Answer = Paired<M.Left.Left, M.Right.Right>
    public typealias Right = Answer
    public typealias Sigma = MatrixEntrySpace
    public typealias Encoding = MatrixEntryEncoding
    public typealias Predicate = MatrixDiagonalQuestion
}

/// Reconstruct a diagonal matrix using only this pair. Q identifies the
/// downstream question whose independently computed answer is compared.
public enum ExpandMatrixDiagonal<D: Pair, Q>: PredicateReading
where D.Left: Structure, D.Right: Structure {
    public typealias Left = D
    public typealias Answer = MatrixEntries<D.Left, Never, Never, D.Right>
    public typealias Right = Answer
    public typealias Sigma = MatrixEntrySpace
    public typealias Encoding = MatrixEntryEncoding
    public typealias Predicate = Q
}
