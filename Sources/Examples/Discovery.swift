import VerificationIsIdentification

public enum ExperimentQuiet: Close {}
public enum ExperimentSignal: Close {}

/// Shift two structured letters, exchanging the fields of the outgoing one
/// before returning it at the tail. The actual applications and their seam
/// are retained. On letters Paired<A, B>/Paired<B, A>, this is the twisted
/// two-letter shift in Matter M39, with no probability or runtime premise.
public typealias TwistedPairShift<X: Pair, Y: Pair> = SequentialReading<
    PairedApplication<SwapBoundaryReading<X>, IdentityReading<Y, BeamSpace, SaturationEncoding>>,
    SwapBoundaryReading<Paired<Paired<X.Right, X.Left>, Y>>
>
where X.Left: Structure, X.Right: Structure

/// The second application consumes precisely the first application's answer.
public typealias DoubleTwistedPairShift<X: Pair, Y: Pair> = SequentialReading<
    TwistedPairShift<X, Y>,
    TwistedPairShift<TwistedPairShift<X, Y>.Answer.Left, TwistedPairShift<X, Y>.Answer.Right>
>
where X.Left: Structure, X.Right: Structure, Y.Left: Structure, Y.Right: Structure

/// Four explicitly named states, with observation at Left and the two next
/// states at Right.Left and Right.Right. A finite transition graph can cycle.
/// It is not a claim that recursively expanding this graph gives a finite tree.
public enum TrapExperiment: Close {
    public enum A: Pair {
        public typealias Left = ExperimentQuiet
        public typealias Right = Paired<Signal, A>
    }
    public enum B: Pair {
        public typealias Left = ExperimentQuiet
        public typealias Right = Paired<A, Signal>
    }
    public enum C: Pair {
        public typealias Left = ExperimentQuiet
        public typealias Right = Paired<A, A>
    }
    public enum Signal: Pair {
        public typealias Left = ExperimentSignal
        public typealias Right = Paired<A, A>
    }
}

/// Each operation exchanges its named candidate with Signal. Every original
/// state survives, allowing a later question to separate an unresolved pair.
public enum ReversibleExperiment: Close {
    public enum A: Pair {
        public typealias Left = ExperimentQuiet
        public typealias Right = Paired<Signal, A>
    }
    public enum B: Pair {
        public typealias Left = ExperimentQuiet
        public typealias Right = Paired<B, Signal>
    }
    public enum C: Pair {
        public typealias Left = ExperimentQuiet
        public typealias Right = Paired<C, C>
    }
    public enum Signal: Pair {
        public typealias Left = ExperimentSignal
        public typealias Right = Paired<A, B>
    }
}

/// The two observations after performing the first operation and then the
/// second, computed from the table. Initial observation is a separate premise.
public enum TwoQuestionTrace<S: Pair>: Pair
where S.Right: Pair, S.Right.Left: Pair,
      S.Right.Left.Right: Pair, S.Right.Left.Right.Right: Pair {
    public typealias Left = S.Right.Left.Left
    public typealias Right = S.Right.Left.Right.Right.Left
}

/// The reduced first operation may merge current states. Its history extension
/// retains the actual prior source as part of the next whole. It asserts no
/// fixed memory capacity and no inverse defined on every possible record.
public enum RecordedFirstQuestion<S: Pair>: Permanent
where S.Right: Pair, S.Right.Left: Structure {
    public typealias Left = S
    public typealias Right = Paired<S, S.Right.Left>
}

/// Carry the required original answer through a first-question intervention.
/// Left is the evolving state and Right is its certified original answer tag.
/// Tags annotate candidate possibilities, not an answer already available to
/// the experimenter. Initial tag correctness is a premise of this transport.
public enum AdvanceQuestionTag<C: Pair>: Pair
where C.Left: Pair, C.Left.Right: Pair {
    public typealias Left = C.Left.Right.Left
    public typealias Right = C.Right
}

/// The existing experiment table has two action occurrences at each state.
public typealias DiscoveryActions<S: Pair> = CandidateFork<
    CandidateLeaf<S.Right.Left>, CandidateLeaf<S.Right.Right>>
where S.Right: Pair

/// One child support per observable outcome in the declared binary model.
public typealias DiscoveryChildren<Q: Pair, S: Pair> = CandidateFork<
    CandidateLeaf<Paired<ExperimentQuiet, Q>>,
    CandidateLeaf<Paired<ExperimentSignal, S>>>

/// Cover one actual successor while consuming its parent proof obligation.
/// The shared action address stays at the input/output seam. The child row
/// keeps the original target, and its branch matches the computed observation.
/// Child membership is reusable: several parents may reach one row.
/// All selections use the existing finite candidate-path interpretation.
public enum CoverDiscoverySuccessor<Q: Pair, S: Pair, P: CandidateRemoval,
    A: CandidateRemoval, B: CandidateRemoval, T: CandidateRemoval>: PredicateReading
where P.Right: Pair, P.Right.Left: Pair, P.Right.Left.Right: Pair,
      P.Right.Right: Structure,
      A.Left == DiscoveryActions<P.Right.Left>, A.Right: Pair,
      B.Left == DiscoveryChildren<Q, S>, B.Right: Pair, B.Right.Right: Pair,
      B.Right.Left == A.Right.Left,
      T.Left == B.Right.Right, T.Right == Paired<A.Right, P.Right.Right> {
    public typealias Left = Paired<A.Address, Paired<P.Left, DiscoveryChildren<Q, S>>>
    public typealias Answer = Paired<A.Address, Paired<P.Remainder, DiscoveryChildren<Q, S>>>
    public typealias Right = Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = A.Address
}

/// Every declared parent occurrence is discharged, with the same selected
/// action and child supports throughout the supplied finite composition.
/// This verifies one node's successor coverage, not the whole policy tree.
/// Its proof interpretation uses CoverDiscoverySuccessor and SequentialReading;
/// matching the endpoints of an arbitrary PredicateReading is insufficient.
public typealias CoveredDiscoverySuccessors<Parents: Pair, Q: Pair, S: Pair,
    A: Structure, R: PredicateReading> = R
where R.Left == Paired<A, Paired<Parents, DiscoveryChildren<Q, S>>>,
      R.Answer: Pair, R.Answer.Left == A, R.Answer.Right: Pair,
      R.Answer.Right.Left: EmptyCandidateSupport,
      R.Answer.Right.Right == DiscoveryChildren<Q, S>,
      R.Sigma == BeamSpace, R.Encoding == SaturationEncoding

/// The common original answer is derived from the rows of a nonempty support.
/// The finite CandidateLeaf/CandidateFork interpretation supplies coverage.
public protocol DiscoveryTerminalSupport: Pair {
    associatedtype OriginalAnswer: Structure
}

extension CandidateLeaf: DiscoveryTerminalSupport
where X: Pair, X.Left: Pair, X.Right: Structure {
    public typealias OriginalAnswer = X.Right
}

extension CandidateFork: DiscoveryTerminalSupport
where L: DiscoveryTerminalSupport, R: DiscoveryTerminalSupport,
      L.OriginalAnswer == R.OriginalAnswer {
    public typealias OriginalAnswer = L.OriginalAnswer
}

/// One common action followed by terminal quiet/signal answers. The same
/// supports used in successor coverage derive the two answers of the table.
/// Coverage uses finite CoverDiscoverySuccessor/SequentialReading expressions.
/// This constructor does not acquire an observation or execute the table.
public enum AnsweredDiscoveryNode<Parents: Pair, Q: DiscoveryTerminalSupport,
    S: DiscoveryTerminalSupport, A: Structure, R: PredicateReading>: Pair
where R.Left == Paired<A, Paired<Parents, DiscoveryChildren<Q, S>>>,
      R.Answer: Pair, R.Answer.Left == A, R.Answer.Right: Pair,
      R.Answer.Right.Left: EmptyCandidateSupport,
      R.Answer.Right.Right == DiscoveryChildren<Q, S>,
      R.Sigma == BeamSpace, R.Encoding == SaturationEncoding {
    public typealias Coverage = CoveredDiscoverySuccessors<Parents, Q, S, A, R>
    public typealias Left = Parents
    public typealias Answers = Paired<Q.OriginalAnswer, S.OriginalAnswer>
    public typealias Right = Paired<A, Answers>
}

/// The declared observation selects a field of the prepared answer table.
/// Neither clause receives an original state or its verifier answer tag.
public enum ReadQuietDiscoveryAnswer<T: Pair>: Pair {
    public typealias Left = Paired<ExperimentQuiet, T>
    public typealias Right = T.Left
}

public enum ReadSignalDiscoveryAnswer<T: Pair>: Pair {
    public typealias Left = Paired<ExperimentSignal, T>
    public typealias Right = T.Right
}

/// Admit a proposed first-action decision against three actual source rows.
/// The first row produces signal, the other two quiet. Their required answers
/// therefore determine both table fields, with agreement required at quiet.
/// No supplied coverage, terminal conformance or selector establishes these
/// facts. The finite source shape and observation pattern are explicit scope.
/// The state descriptions may have cyclic continuations. Only their actual
/// first successors are needed, with no finite-whole or termination premise.
public enum FirstDiscoveryDecision<A: Pair, B: Pair, C: Pair, N: Pair>: Pair
where A.Left: Pair, B.Left: Pair, C.Left: Pair,
      A.Left.Right: Pair, B.Left.Right: Pair, C.Left.Right: Pair,
      A.Left.Right.Left: Pair, B.Left.Right.Left: Pair, C.Left.Right.Left: Pair,
      A.Left.Right.Left.Left == ExperimentSignal,
      B.Left.Right.Left.Left == ExperimentQuiet,
      C.Left.Right.Left.Left == ExperimentQuiet,
      A.Right: Structure, B.Right: Structure, C.Right == B.Right,
      N.Left == CandidateFork<CandidateLeaf<A>,
          CandidateFork<CandidateLeaf<B>, CandidateLeaf<C>>>,
      N.Right == Paired<Paired<Never, Never>, Paired<B.Right, A.Right>> {
    public typealias Left = N.Left
    public typealias Answers = Paired<B.Right, A.Right>
    public typealias Right = Paired<Paired<Never, Never>, Answers>

    /// The observation clauses compute all three original answers. Their
    /// equality is derived after admission, not a supplied proof parameter.
    public enum RecoversOriginalAnswers: Null {
        public typealias Left = AddressTriple<
            ReadSignalDiscoveryAnswer<Answers>.Right,
            ReadQuietDiscoveryAnswer<Answers>.Right,
            ReadQuietDiscoveryAnswer<Answers>.Right>
        public typealias Right = AddressTriple<A.Right, B.Right, C.Right>
    }
}

/// Retain a joint scene/controller step after matching both actual inputs.
/// This derives recovery and the two output projections. Observation-only
/// control is a separate property of the supplied Memory transition.
public enum RecordedControllerStep<
    Before: Pair,
    Scene: Pair,
    Memory: Pair
>: Permanent
where Scene.Left == Before.Left, Memory.Left == Before.Right,
      Scene.Right: Structure, Memory.Right: Structure {
    public typealias Left = Before
    public typealias Updated = Paired<Scene.Right, Memory.Right>
    public typealias Right = Paired<Before, Updated>
}

/// Read the source's declared question field into prepared blank memory.
/// The other internal register marks readiness. This is a symbolic prepared
/// transition, not a probability calculation or a complete physical model.
public enum PreparedObservation<S: Pair>: Pair
where S.Left: Structure {
    public typealias Left = Paired<S, Paired<ExperimentQuiet, ExperimentQuiet>>
    public typealias Right = Paired<S, Paired<ExperimentSignal, S.Left>>
}

/// A two-input constant law. Constancy is an explicit model restriction.
public enum ConstantTable<B: Structure>: Null {
    public typealias Left = B
    public typealias Right = B
}

public enum SecondTableQuestion: Close {}

public enum FirstTableQuestion: Close {}

/// Read the first declared table field. This question does not certify any
/// other input or identify the entire function from one observed result.
public enum FirstTableReading<T: Pair>: PredicateReading {
    public typealias Left = T
    public typealias Right = T.Left
    public typealias Sigma = Never
    public typealias Encoding = Never
    public typealias Predicate = FirstTableQuestion
    public typealias Answer = T.Left
}

/// Read the second input of a declared two-input table.
public enum SecondTableReading<T: Pair>: PredicateReading {
    public typealias Left = T
    public typealias Right = T.Right
    public typealias Sigma = Never
    public typealias Encoding = Never
    public typealias Predicate = SecondTableQuestion
    public typealias Answer = T.Right
}

/// Equal training readings at the first input imply equal second predictions
/// within the constant-law family. The second-answer equality is derived.
/// Membership of an unknown physical law in this family is not established.
public enum PredictionsFromConstantTables<
    L: Null,
    R: Null
>: VerdictIsInvariant
where L.Left == R.Left {
    public typealias Left = SecondTableReading<L>
    public typealias Right = SecondTableReading<R>
    public typealias Sigma = Never
    public typealias Encoding = Never
    public typealias Predicate = SecondTableQuestion
    public typealias Answer = L.Left
}

/// Generate a constant teaching table from the actual law's first reading.
/// Retain the actual law separately. The synthetic second answer is computed
/// from the first reading and need not equal the actual second answer.
public enum SyntheticConstantRecord<T: Pair>: Permanent
where T.Left: Structure {
    public typealias Left = T
    public typealias Right = Paired<T, ConstantTable<T.Left>>
}

/// Self-application of a represented two-code evaluator: read row zero at
/// input zero and row one at input one. This finite projection requires no
/// representation of all predicates or of the diagonal complement.
public enum DiagonalReadings<T: Pair>: Pair
where T.Left: Pair, T.Right: Pair {
    public typealias Left = T.Left.Left
    public typealias Right = T.Right.Right
}

/// F and G act on this table's two diagonal answers. If their output pair
/// is represented by the first row, that row's self-answer is fixed by F.
/// The fixed-point equality follows from the row and input bindings. [PP15]
public enum FirstDiagonalFixedPoint<T: Pair, F: PredicateReading, G: PredicateReading>: Null
where T.Left: Pair, T.Right: Pair,
      F.Left == T.Left.Left, G.Left == T.Right.Right,
      F.Answer: Structure, G.Answer: Structure,
      T.Left == Paired<F.Answer, G.Answer> {
    public typealias Left = F.Left
    public typealias Right = F.Answer
}

/// Representation by the second row instead fixes its self-answer under G.
/// Neither constructor assumes that every possible question has a row.
public enum SecondDiagonalFixedPoint<T: Pair, F: PredicateReading, G: PredicateReading>: Null
where T.Left: Pair, T.Right: Pair,
      F.Left == T.Left.Left, G.Left == T.Right.Right,
      F.Answer: Structure, G.Answer: Structure,
      T.Right == Paired<F.Answer, G.Answer> {
    public typealias Left = G.Left
    public typealias Right = G.Answer
}

/// Read an answer only after the internal readiness register marks a record.
/// The ready marker is a type premise; how a physical marker is authenticated
/// remains outside this symbolic model.
public enum ReadyFirstMemory<M: Pair>: PredicateReading
where M.Left == ExperimentSignal {
    public typealias Left = M
    public typealias Right = M.Right
    public typealias Sigma = Never
    public typealias Encoding = Never
    public typealias Predicate = FirstTableQuestion
    public typealias Answer = M.Right
}

/// The prepared transition writes the source's first field. Reading its actual
/// output memory therefore answers that same question. Neither answer equality
/// nor a caller-supplied record is an additional premise of this constructor.
public enum PreparedFirstAnswerIsCertified<T: Pair>: VerdictIsInvariant
where T.Left: Structure {
    public typealias Left = FirstTableReading<T>
    public typealias Right = ReadyFirstMemory<PreparedObservation<T>.Right.Right>
    public typealias Sigma = Never
    public typealias Encoding = Never
    public typealias Predicate = FirstTableQuestion
    public typealias Answer = T.Left
}
