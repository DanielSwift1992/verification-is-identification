import VerificationIsIdentification

/// The memory payload has no actual-source type parameter or source field.
public enum AnswerFact<
    S,
    E,
    Q,
    A
>: Close, HasVerdict {
    public typealias Sigma = S
    public typealias Encoding = E
    public typealias Predicate = Q
    public typealias Answer = A
}

public typealias FactOf<R: PredicateReading> = AnswerFact<
    R.Sigma,
    R.Encoding,
    R.Predicate,
    R.Answer
>

/// A reading becomes an internal record beside the retained source.
public enum RecordReading<R: PredicateReading>: RetainedReadingRecord
where R.Left: Structure {
    public typealias Reading = R
    public typealias Left = R.Left
    public typealias Right = Paired<
        R.Left,
        FactOf<R>
    >
}

public enum RecordReadingOperation: Close {}

public enum ObserveRecordedFact<R: PredicateReading>: PredicateReading
where R.Left: Structure {
    public typealias Left = R.Left
    public typealias Right = RecordReading<R>.Right.Right
    public typealias Sigma = R.Sigma
    public typealias Encoding = R.Encoding
    public typealias Predicate = RecordReadingOperation
    public typealias Answer = Right
}

public enum ReadRecordedAnswer<F: HasVerdict>: RecordedAnswerReading {
    public typealias Left = F
    public typealias Right = F.Answer
    public typealias Sigma = F.Sigma
    public typealias Encoding = F.Encoding
    public typealias Predicate = F.Predicate
    public typealias Answer = Right
}

/// No equality of source and memory answers is required from the caller.
/// Both answers reduce through the actual recorded application.
/// This preserves the supplied R. It does not prove that an arbitrary R
/// correctly answers an independently specified question about R.Left.
public enum AcquireAnswer<R: PredicateReading>: AcquiresAnswer
where R.Left: Structure {
    public typealias Left = R
    public typealias Record = RecordReading<R>
    public typealias Right = ReadRecordedAnswer<Record.Right.Right>
    public typealias Observation = ObserveRecordedFact<R>
    public typealias Sigma = R.Sigma
    public typealias Encoding = R.Encoding
    public typealias Predicate = R.Predicate
    public typealias Answer = R.Answer
}

/// Compose an evidence decoder with a question decoder. The question belongs
/// to the latter, while the former supplies its actual input representation.
public enum DecodeRefinedEvidence<
    Evidence: PredicateReading,
    Question: PredicateReading
>: PredicateReading
where Evidence.Answer == Question.Left, Evidence.Sigma == Question.Sigma,
      Evidence.Encoding == Question.Encoding {
    public typealias Left = Evidence.Left
    public typealias Right = Question.Answer
    public typealias Sigma = Question.Sigma
    public typealias Encoding = Question.Encoding
    public typealias Predicate = Question.Predicate
    public typealias Answer = Right
}

/// Define a source question by reading an observation and then its supplied
/// decoder. This certifies that composition; agreement with an independently
/// specified source question is a separate relation. [VI VC50]
public enum QuestionOnObservation<
    O: PredicateReading,
    Q: PredicateReading
>: ReadingFactors
where O.Answer == Q.Left, O.Sigma == Q.Sigma, O.Encoding == Q.Encoding {
    public typealias Left = DecodeRefinedEvidence<O, Q>
    public typealias Right = Q
    public typealias Observation = O
    public typealias Sigma = Q.Sigma
    public typealias Encoding = Q.Encoding
    public typealias Predicate = Q.Predicate
    public typealias Answer = Q.Answer
}

/// If G recovers F's observation, its image can answer F's question.
public enum AnswerOnRefinement<
    F: ReadingFactors,
    G: ReadingFactors
>: ReadingFactors
where G.Left == F.Observation {
    public typealias Left = F.Left
    public typealias Right = DecodeRefinedEvidence<
        G.Right,
        F.Right
    >
    public typealias Observation = G.Observation
    public typealias Sigma = F.Sigma
    public typealias Encoding = F.Encoding
    public typealias Predicate = F.Predicate
    public typealias Answer = F.Answer
}

/// Acquiring F's observation supplies the same decoder input through a fact.
/// The fact's payload has no source type parameter. [VI VC50]
public typealias AnswerFromAcquiredObservation<F: ReadingFactors> = AnswerOnRefinement<
    F,
    AcquireAnswer<F.Observation>
>
where F.Observation.Left: Structure

public enum RefineAnswer<
    F: ReadingFactors,
    G: ReadingFactors
>: RefinementPreservesAnswer
where G.Left == F.Observation {
    public typealias Left = F
    public typealias Right = G
    public typealias Conclusion = AnswerOnRefinement<
        F,
        G
    >
}

/// A joint observation uses two readings of the very same source.
public enum JointEvidence<
    A: PredicateReading,
    B: PredicateReading
>: PredicateReading
where A.Left == B.Left, A.Sigma == B.Sigma, A.Encoding == B.Encoding,
      A.Answer: Structure, B.Answer: Structure {
    public typealias Left = A.Left
    public typealias Right = Paired<
        A.Answer,
        B.Answer
    >
    public typealias Sigma = A.Sigma
    public typealias Encoding = A.Encoding
    public typealias Predicate = OperationSequence<
        A.Predicate,
        B.Predicate
    >
    public typealias Answer = Right
}

public enum FirstEvidenceImage<
    I: Pair,
    S,
    E,
    Q
>: PredicateReading {
    public typealias Left = I
    public typealias Right = I.Left
    public typealias Sigma = S
    public typealias Encoding = E
    public typealias Predicate = Q
    public typealias Answer = Right
}

public enum JointEvidenceRetainsFirst<
    A: PredicateReading,
    B: PredicateReading
>: ReadingFactors
where A.Left == B.Left, A.Sigma == B.Sigma, A.Encoding == B.Encoding,
      A.Answer: Structure, B.Answer: Structure {
    public typealias Left = A
    public typealias Observation = JointEvidence<
        A,
        B
    >
    public typealias Right = FirstEvidenceImage<
        Observation.Answer,
        A.Sigma,
        A.Encoding,
        A.Predicate
    >
    public typealias Sigma = A.Sigma
    public typealias Encoding = A.Encoding
    public typealias Predicate = A.Predicate
    public typealias Answer = A.Answer
}

/// This decoder interprets the first value as the second answer. Its use for
/// a source is certified below only in the constant-table family.
public enum ConstantSecondDecoder<B>: PredicateReading {
    public typealias Left = B
    public typealias Right = B
    public typealias Sigma = Never
    public typealias Encoding = Never
    public typealias Predicate = SecondTableQuestion
    public typealias Answer = B
}

public enum ConstantSecondFactors<T: Null>: ReadingFactors {
    public typealias Left = SecondTableReading<T>
    public typealias Observation = FirstTableReading<T>
    public typealias Right = ConstantSecondDecoder<T.Left>
    public typealias Sigma = Never
    public typealias Encoding = Never
    public typealias Predicate = SecondTableQuestion
    public typealias Answer = T.Left
}

/// The source is fixed. Its prepared trace has no acquired reading.
public enum StartObservations<S>: EmptyObservationTrace {
    public typealias Left = S
    public typealias Right = Never
}

public enum AppendObservation<
    T: ObservationTrace,
    R: PredicateReading
>: ExtendedObservationTrace
where T.Left == R.Left {
    public typealias Previous = T
    public typealias Reading = R
    public typealias Left = T.Left
    public typealias Right = Paired<
        T.Right,
        FactOf<R>
    >
}

/// Read the last memory slot. Source is absent from this decoder's arguments.
public enum LatestObservation<M: Pair>: PredicateReading
where M.Right: HasVerdict {
    public typealias Left = M
    public typealias Right = M.Right.Answer
    public typealias Sigma = M.Right.Sigma
    public typealias Encoding = M.Right.Encoding
    public typealias Predicate = M.Right.Predicate
    public typealias Answer = Right
}

/// Lift a constant-family answer through the memory of the first reading.
/// The compiler derives the second answer from T: Null and the recorded slot.
public enum ConstantSecondFromTrace<T: ExtendedObservationTrace>: ReadingFactors
where T.Left: Null, T.Reading == FirstTableReading<T.Left> {
    public typealias Left = SecondTableReading<T.Left>
    public typealias Right = DecodeRefinedEvidence<
        LatestObservation<T.Right>,
        ConstantSecondDecoder<T.Left.Left>
    >
    public typealias Observation = TraceEvidence<T>
    public typealias Sigma = Never
    public typealias Encoding = Never
    public typealias Predicate = SecondTableQuestion
    public typealias Answer = T.Left.Left
}

/// Expose the actual trace memory in a decoding context. Each stored fact
/// keeps its own context. This projection translates no fact and certifies
/// no independently specified source question. [VI VC42]
public enum TraceEvidenceIn<T: ExtendedObservationTrace, S, E>: PredicateReading {
    public typealias Left = T.Left
    public typealias Right = T.Right
    public typealias Sigma = S
    public typealias Encoding = E
    public typealias Predicate = RecordReadingOperation
    public typealias Answer = Right
}

/// The latest reading supplies this decoding context, without relabelling
/// the earlier facts. The trace constructors bind all readings to one source.
public typealias TraceEvidence<T: ExtendedObservationTrace> = TraceEvidenceIn<
    T, T.Reading.Sigma, T.Reading.Encoding
>

/// The complete trace extension pins the last fact to its actual reading.
public enum LastAnswerFromTrace<T: ExtendedObservationTrace>: ReadingFactors {
    public typealias Left = T.Reading
    public typealias Right = LatestObservation<T.Right>
    public typealias Observation = TraceEvidence<T>
    public typealias Sigma = T.Reading.Sigma
    public typealias Encoding = T.Reading.Encoding
    public typealias Predicate = T.Reading.Predicate
    public typealias Answer = T.Reading.Answer
}

/// The certificate's existing decoder, named where its source and memory fit.
/// No application object or before/after trace is introduced.
public typealias AnswerInTrace<
    T: ObservationTrace,
    F: ReadingFactors
> = F.Right
where F.Left.Left == T.Left, F.Observation.Answer == T.Right

/// A prefix decoder still answers after memory gains another record. Its
/// actual old input must be the new memory's retained prefix. Application
/// exposes the projection followed by that decoder. The public Predicate
/// keeps the old question, now asked of the retained prefix. [PiP2a]
public enum PrefixMemoryAnswer<
    R: PredicateReading,
    M: Pair
>: PredicateReading
where M.Left == R.Left {
    public typealias Application = SequentialReading<
        FirstEvidenceImage<M, R.Sigma, R.Encoding, FirstProjection>, R
    >
    public typealias Left = Application.Left
    public typealias Right = Application.Answer
    public typealias Sigma = R.Sigma
    public typealias Encoding = R.Encoding
    public typealias Predicate = R.Predicate
    public typealias Answer = Right
}

/// Adding a same-source observation preserves a certified prefix answer.
/// Its decoder keeps the original context regardless of the new fact's.
public enum RetainTraceAnswer<
    T: ExtendedObservationTrace,
    F: ReadingFactors
>: ReadingFactors
where F.Left.Left == T.Left, F.Observation.Answer == T.Previous.Right {
    public typealias Left = F.Left
    public typealias Right = PrefixMemoryAnswer<
        F.Right,
        T.Right
    >
    public typealias Observation = TraceEvidenceIn<T, F.Sigma, F.Encoding>
    public typealias Sigma = F.Sigma
    public typealias Encoding = F.Encoding
    public typealias Predicate = F.Predicate
    public typealias Answer = F.Answer
}
