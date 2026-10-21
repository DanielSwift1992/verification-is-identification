import Swift

// ═══════════════════════════════════════════════════════════════
// VERDICT records the symmetry claim and checks a finite invariance fragment.
// The compiler binds
// the question, space, encoding and answers of presented readings. Generic
// constructors in Examples derive finite joins, selections and reversals.
// Checks/Verdict.swift exercises their implications and deliberate refusals.
// The finite constructor interpretation and its remaining encoding obligations
// are written in Verdict Is Invariant §§6a–6d.
// ═══════════════════════════════════════════════════════════════

// The unbound AmbiguityIsSymmetry/CarriedSymmetry interface is retired.
// VI1-VI1a retain the isomorphism and selection results under their premises.
// No generic group action is inferred from an encoding coordinate.

/// The question and its answer, within a stated space and encoding. The axes
/// are closed by ``PredicateReading`` and ``VerdictIsInvariant``. [VI 6a]
public protocol HasVerdict: HasEncoding {
    associatedtype Predicate
    associatedtype Answer
}

/// One recorded application: `Left` names its source, `Right` its answer.
/// The application is supplied by an encoding-specific type constructor. This
/// relation checks its output address, not the truth of an arbitrary evaluator.
/// A source may support several questions through separate reading types. [VI 6a]
/// An arbitrary conformer is not a derivation of an independently fixed source
/// question. Recording or decoding that conformer does not discharge this gap.
public protocol PredicateReading: Pair, HasVerdict
where Right == Answer {}

/// Two readings ask the same question in the same space and encoding. Their
/// answers remain free: agreeing on a question does not settle it. [VI 6a]
public protocol ComparedReadings: Pair
where Left: PredicateReading, Right: PredicateReading,
      Left.Sigma == Right.Sigma,
      Left.Encoding == Right.Encoding,
      Left.Predicate == Right.Predicate {}

/// Both recorded applications have the named answer. The source types need
/// not coincide. This checks a binary certificate, not an enumeration of all
/// possible candidates. Finite certificates compose by reading a certified
/// group as one candidate with the group's checked answer. [VI 3, 6a]
///
/// > Note: The old free Predicate axis did not check invariance. These equalities
/// > check every presented branch. Completeness of the presented candidate
/// > class and correctness of its reading remain premises of the encoding.
public protocol VerdictIsInvariant: ComparedReadings, HasVerdict
where Predicate == Left.Predicate, Sigma == Left.Sigma, Encoding == Left.Encoding,
      Answer == Left.Answer, Answer == Right.Answer {}

/// Retaining the left reading of a certified pair preserves the question and
/// answer: `Right.Answer == Left.Answer` follows through `Left.Left`.
/// The retained reading is a member, not a replacement with the same answer.
/// No answer equality is added here. The compiler inherits it. [VI 4, 6a]
public protocol VerdictRetainsLeft: Pair
where Left: VerdictIsInvariant, Right == Left.Left {}

/// Retaining the right reading preserves the certified answer through
/// `Left.Right`. The retained member cannot be an unrelated reading. [VI 4, 6a]
public protocol VerdictRetainsRight: Pair
where Left: VerdictIsInvariant, Right == Left.Right {}

/// Two certificates differ only in the order of their branches. Their answer,
/// question, encoding and space coincide through the exchanged readings. No
/// separate equality of answers is assumed. A generic reversal constructor
/// supplies the second certificate from the first. [VI 6a]
public protocol VerdictReorders: Pair
where Left: VerdictIsInvariant, Right: VerdictIsInvariant,
      Right.Left == Left.Right, Right.Right == Left.Left {}

/// A declared candidate representation within a space. The coverage relations
/// below bind this axis to leaves and branch addresses. [VI 6b]
public protocol HasCandidates: HasSigma {
    associatedtype Candidates
}

/// An application with a structural account of its candidate support. The
/// finite leaf and group constructors give this account its meaning. [VI 6b]
public protocol CandidateReading: PredicateReading, HasCandidates
where Candidates: Pair {}

/// A leaf records exactly its application source and a terminal right side.
/// A different source with the same answer cannot replace this address. [VI 6b]
public protocol CandidateLeafReading: CandidateReading
where Candidates.Left == Left, Candidates.Right == Never {}

/// A uniform join records both child supports without dropping either branch.
/// Its support is an ordered tree, not an extensional set normal form. [VI 6b]
public protocol VerdictCoversBranches: VerdictIsInvariant, HasCandidates
where Left: CandidateReading, Right: CandidateReading, Candidates: Pair,
      Candidates.Left == Left.Candidates, Candidates.Right == Right.Candidates {}

/// A grouped application inherits its certificate's support, answer and context.
/// Its source address is the certificate node, not an additional source. [VI 6b]
public protocol CandidateGroupReading: CandidateReading
where Certificate: VerdictCoversBranches, Left == Certificate,
      Candidates == Certificate.Candidates, Answer == Certificate.Answer,
      Sigma == Certificate.Sigma, Encoding == Certificate.Encoding,
      Predicate == Certificate.Predicate {
    associatedtype Certificate
}

/// The computed support equals a separately supplied declaration. Within the
/// finite constructor grammar this checks coverage of that tree. Adequacy of
/// the declaration to an external domain is an additional obligation. [VI 6b]
public protocol CoverageMatchesDeclaration: Pair
where Left: VerdictCoversBranches, Right == Left.Candidates {}

/// The direct question and its reading through an observed image agree.
/// Observation relates the original source to the decoder's input. The two
/// answer paths are checked by the inherited invariance equations. [VI 6c]
/// AC5 needs this factorization over its complete admitted family, whose
/// coverage is additional to a supplied branch certificate. [AiC AC5]
public protocol ReadingFactors: VerdictIsInvariant
where Observation: PredicateReading, Observation.Sigma == Sigma,
      Observation.Encoding == Encoding, Observation.Left == Left.Left,
      Observation.Answer == Right.Left {
    associatedtype Observation
}

/// Two factorizations share the actual decoder reading. The direct answers
/// consequently coincide. Shared image or question labels alone would not
/// establish the functional consistency of arbitrary reading records. [VI 6c]
/// This is the supplied-reading fragment of MiC1's verdict transport through
/// an actual input image. Applicability and law support remain premises. [MiC MiC1]
public protocol SharedDecoder: Pair
where Left: ReadingFactors, Right: ReadingFactors, Left.Right == Right.Right {}

/// The new whole retains its source and a fact containing the question,
/// encoding and answer. The fact exposes no source coordinate. [VI 6n]
public protocol RetainedReadingRecord: Permanent
where Reading: PredicateReading, Reading.Left == Left,
      Right.Right: HasVerdict,
      Right.Right.Sigma == Reading.Sigma,
      Right.Right.Encoding == Reading.Encoding,
      Right.Right.Predicate == Reading.Predicate,
      Right.Right.Answer == Reading.Answer {
    associatedtype Reading
}

/// Read the stored fact, with its original question and encoding.
/// The answer follows from the actual memory slot. [VI 6n]
public protocol RecordedAnswerReading: PredicateReading
where Left: HasVerdict,
      Sigma == Left.Sigma, Encoding == Left.Encoding,
      Predicate == Left.Predicate, Answer == Left.Answer {}

/// A direct question factors through the fact produced by recording it.
/// The recorded application, source and decoder input are the actual endpoints.
/// The generic recording constructor derives this relation. [VI 6n]
public protocol AcquiresAnswer: ReadingFactors
where Record: RetainedReadingRecord, Record.Reading == Left,
      Record.Right.Right == Observation.Answer, Right: RecordedAnswerReading {
    associatedtype Record
}

/// The second factorization recovers the evidence used by the first.
/// Their seam is the complete evidence reading, including its source. [VI 6n]
public protocol EvidenceRefinesQuestion: Pair
where Left: ReadingFactors, Right: ReadingFactors,
      Right.Left == Left.Observation {}

/// A question previously decoded from coarse evidence is decoded from its
/// refinement. The conclusion uses the refined observation and old question.
/// RefineAnswer supplies it without asking for the final equality. [VI 6n]
public protocol RefinementPreservesAnswer: EvidenceRefinesQuestion
where Conclusion: ReadingFactors, Conclusion.Left == Left.Left,
      Conclusion.Observation == Right.Observation,
      Conclusion.Answer == Left.Answer {
    associatedtype Conclusion
}

/// A source and its recorded evidence. The memory itself gives the history,
/// without a second coordinate counting the same extensions. [VI 6n]
public protocol ObservationTrace: Pair
where Right: Structure {}

/// The prepared trace has no observations. Never is the memory floor. [VI 6n]
public protocol EmptyObservationTrace: ObservationTrace
where Right == Never {}

/// One extension records a reading of this source and retains prior memory.
/// The new fact is present in the extension itself. [VI 6n]
/// Earlier facts keep their contexts, which need not match the new reading.
public protocol ExtendedObservationTrace: ObservationTrace
where Previous: ObservationTrace, Reading: PredicateReading,
      Left == Previous.Left, Reading.Left == Left,
      Right: Pair, Right.Left == Previous.Right,
      Right.Right: HasVerdict,
      Right.Right.Sigma == Reading.Sigma,
      Right.Right.Encoding == Reading.Encoding,
      Right.Right.Predicate == Reading.Predicate,
      Right.Right.Answer == Reading.Answer {
    associatedtype Previous
    associatedtype Reading
}
