import Notation

import Swift

/// A supplied continuation meets the original question at its final state.
/// The actual source-residue pair binds the acquired input, choice and action.
/// Availability, completion and coverage of all executions remain premises
/// of the stated action law. [Acquire Adequacy]
public protocol AdequateResidueContinuation: VerdictIsInvariant
where SourceResidue.Left == Left.Left,
      SourceResidue.Right == Input.Left,
      Action.Left == SourceResidue.Right,
      Action.Answer == Right.Left,
      ResidueRecord.Left.Left == SourceResidue.Right,
      ResidueRecord.Right.Left == Action.Answer,
      ResidueRecord.Sigma == Sigma, ResidueRecord.Encoding == Encoding,
      Choice.Left == Input.Answer,
      Choice.Answer == Action.Predicate,
      Input.Sigma == Sigma, Input.Encoding == Encoding,
      Action.Sigma == Sigma, Action.Encoding == Encoding,
      Choice.Sigma == Sigma, Choice.Encoding == Encoding {
    associatedtype SourceResidue: Pair
    associatedtype Input: PredicateReading
    associatedtype ResidueRecord: VerdictIsInvariant
    associatedtype Action: PredicateReading
    associatedtype Choice: PredicateReading
}
