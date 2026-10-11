import VerificationIsIdentification

public enum ClockMassSpace: Close {}
public enum ClockMassEncoding: Close {}
public enum ExpandClockMassQuestion: Close {}
public enum GroupClockMassQuestion: Close {}

/// Two symbolic class masses, each used at its two actual occurrences.
/// A positive numerical interpretation is separate; no probability or rate
/// semantics follow from arbitrary Structure conformance. M64ax supplies
/// the stationary-measure derivation for the four-cycle example.
public enum ExpandClockClassMass<C: Pair>: PredicateReading
where C.Left: Structure, C.Right: Structure {
    public typealias Left = C
    public typealias Right = Paired<Paired<C.Left, C.Left>, Paired<C.Right, C.Right>>
    public typealias Sigma = ClockMassSpace
    public typealias Encoding = ClockMassEncoding
    public typealias Predicate = ExpandClockMassQuestion
    public typealias Answer = Right
}

/// The source is ordered by clock class, with outcome 0 and 1 in each.
/// Readdress its actual four occurrences by outcome, retaining their masses.
public enum GroupClockMassByOutcome<F: Pair>: PredicateReading
where F.Left: Pair, F.Right: Pair,
      F.Left.Left: Structure, F.Left.Right: Structure,
      F.Right.Left: Structure, F.Right.Right: Structure {
    public typealias Left = F
    public typealias Right = Paired<Paired<F.Left.Left, F.Right.Left>,
        Paired<F.Left.Right, F.Right.Right>>
    public typealias Sigma = ClockMassSpace
    public typealias Encoding = ClockMassEncoding
    public typealias Predicate = GroupClockMassQuestion
    public typealias Answer = Right
}

/// An exact equality of the two formal mass lists is stronger than equality
/// of their sums and suffices for every additive positive interpretation.
/// It is derived from actual shared class fields, not requested as a premise.
public enum ClockBalancedMass<C: Pair>: Close
where C.Left: Structure, C.Right: Structure {
    public typealias Expansion = ExpandClockClassMass<C>
    public typealias Grouping = GroupClockMassByOutcome<Expansion.Answer>
    public typealias Reading = SequentialReading<Expansion, Grouping>
    public enum EqualMassLists: Null {
        public typealias Left = Reading.Answer.Left
        public typealias Right = Reading.Answer.Right
    }
}
