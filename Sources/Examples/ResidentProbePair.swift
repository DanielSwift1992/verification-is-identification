import VerificationIsIdentification

/// Relational composition at the exact intermediate object.
public enum FollowedPair<F: Pair, G: Pair>: Pair
where F.Right == G.Left {
    public typealias Left = F.Left
    public typealias Right = G.Right
}

/// The same path is already a reading when both actual steps are readings
/// in one encoding. This retains the composition's question expression;
/// no independently named evaluator or final-answer premise is added.
extension FollowedPair: HasSigma, HasEncoding, HasVerdict, PredicateReading
where F: PredicateReading, G: PredicateReading,
      F.Sigma == G.Sigma, F.Encoding == G.Encoding {
    public typealias Sigma = F.Sigma
    public typealias Encoding = F.Encoding
    public typealias Predicate = OperationSequence<F.Predicate, G.Predicate>
    public typealias Answer = G.Answer
}

public enum FollowedReadingEndpoints<F: PredicateReading, G: PredicateReading>: Null
where F.Answer == G.Left, F.Sigma == G.Sigma, F.Encoding == G.Encoding,
      F.Left: Structure, G.Answer: Structure {
    public typealias PairPath = FollowedPair<F, G>
    public typealias ReadingPath = SequentialReading<F, G>
    public typealias Left = Paired<PairPath.Left, Paired<PairPath.Answer, PairPath.Predicate>>
    public typealias Right = Paired<ReadingPath.Left, Paired<ReadingPath.Answer, ReadingPath.Predicate>>
}

/// Exchange which resident instrument is beside the source. The source
/// occurs once. Both instrument states survive, including their channels.
public enum ExchangeResidentInstruments<W: Pair>: Pair
where W.Left: Pair, W.Left.Left: Structure, W.Left.Right: Structure, W.Right: Structure {
    public typealias Left = W
    public typealias Right = Paired<Paired<W.Left.Left, W.Right>, W.Left.Right>
}

/// Two prepared instruments, one retained source. Acquisition of A leaves
/// B's ready instrument untouched. Focus exchanges their resident addresses,
/// then acquisition of B leaves A's acquired record untouched.
public enum TwoResidentReadings<A: PredicateReading, B: PredicateReading>: Pair
where A.Left == B.Left, A.Left: Structure {
    public typealias FirstRead = PreparedTraceExtension<StartObservations<A.Left>, A>
    public typealias SecondRead = PreparedTraceExtension<StartObservations<B.Left>, B>
    public typealias First = StepBeside<FirstRead, SecondRead.Left.Right>
    public typealias Focus = ExchangeResidentInstruments<First.Right>
    public typealias Second = StepBeside<SecondRead, FirstRead.Right.Right>
    public typealias Path = FollowedPair<FollowedPair<First, Focus>, Second>
    public typealias Left = Path.Left
    public typealias Right = Path.Right
}

/// The pair of facts at their final addresses: parked first instrument,
/// focused second instrument. This view contains no retained source.
public typealias ResidentProbeFacts<W: Pair> = Paired<
    W.Right.Right.Right.Right,
    W.Left.Right.Right.Right.Right
>
where W.Left: Pair, W.Left.Right: Pair,
      W.Left.Right.Right: Pair, W.Left.Right.Right.Left == ExperimentSignal,
      W.Left.Right.Right.Right: Pair, W.Left.Right.Right.Right.Right: HasVerdict & Structure,
      W.Right: Pair, W.Right.Right: Pair, W.Right.Right.Left == ExperimentSignal,
      W.Right.Right.Right: Pair, W.Right.Right.Right.Right: HasVerdict & Structure

/// Two recorded answers, with both question addresses carried in order.
public enum TwoRecordedAnswers<M: Pair>: PredicateReading
where M.Left: HasVerdict, M.Right: HasVerdict,
      M.Left.Sigma == M.Right.Sigma, M.Left.Encoding == M.Right.Encoding,
      M.Left.Answer: Structure, M.Right.Answer: Structure {
    public typealias Left = M
    public typealias Right = Paired<M.Left.Answer, M.Right.Answer>
    public typealias Sigma = M.Left.Sigma
    public typealias Encoding = M.Left.Encoding
    public typealias Predicate = OperationSequence<M.Left.Predicate, M.Right.Predicate>
    public typealias Answer = Right
}

/// This observation names the actual constructed records. Availability of
/// the initial prepared whole is supplied by TwoResidentReadings's Left.
public enum ObserveTwoResidentFacts<A: PredicateReading, B: PredicateReading>: PredicateReading
where A.Left == B.Left, A.Left: Structure,
      A.Sigma == B.Sigma, A.Encoding == B.Encoding {
    public typealias Run = TwoResidentReadings<A, B>
    public typealias Left = A.Left
    public typealias Right = ResidentProbeFacts<Run.Right>
    public typealias Sigma = A.Sigma
    public typealias Encoding = A.Encoding
    public typealias Predicate = RecordReadingOperation
    public typealias Answer = Right
}

/// The generic output equality follows from both actual trace extensions.
/// It does not infer that two arbitrary facts came from these readings.
public enum TwoResidentAnswers<A: PredicateReading, B: PredicateReading>: ReadingFactors
where A.Left == B.Left, A.Left: Structure,
      A.Sigma == B.Sigma, A.Encoding == B.Encoding,
      A.Answer: Structure, B.Answer: Structure {
    public typealias Left = JointEvidence<A, B>
    public typealias Observation = ObserveTwoResidentFacts<A, B>
    public typealias Right = TwoRecordedAnswers<Observation.Answer>
    public typealias Sigma = A.Sigma
    public typealias Encoding = A.Encoding
    public typealias Predicate = Left.Predicate
    public typealias Answer = Left.Answer
}

/// Existing source-bound evidence is readable at this final resident whole.
/// A source match, two signalled instruments, and the exact record view are
/// required. The returned decoder's input is the record pair, not W.
public typealias AnswerInResidentProbePair<W: Pair, F: ReadingFactors> = F.Right
where W.Left: Pair, W.Left.Left == F.Left.Left,
      W.Left.Right: Pair, W.Left.Right.Right: Pair,
      W.Left.Right.Right.Left == ExperimentSignal,
      W.Left.Right.Right.Right: Pair, W.Left.Right.Right.Right.Right: HasVerdict & Structure,
      W.Right: Pair, W.Right.Right: Pair, W.Right.Right.Left == ExperimentSignal,
      W.Right.Right.Right: Pair, W.Right.Right.Right.Right: HasVerdict & Structure,
      W.Right.Left == ChannelOf<ReadRecordedAnswer<W.Right.Right.Right.Right>>,
      W.Left.Right.Left == ChannelOf<ReadRecordedAnswer<W.Left.Right.Right.Right.Right>>,
      ResidentProbeFacts<W> == F.Observation.Answer
