import VerificationIsIdentification

public enum RepeatedTripleQuestion: Close {}

/// On this record shape the repeated value is its actual first field.
/// The condition concerns the available record, not the unknown true bit
/// or an address identifying which path may be damaged.
public enum RepeatedFirstAnswer<M: Pair>: PredicateReading
where M.Right: Pair, M.Left: Structure, M.Left == M.Right.Left {
    public typealias Actual = FirstEvidenceImage<M, BeamSpace, SaturationEncoding, RepeatedTripleQuestion>
    public typealias Left = M
    public typealias Right = Actual.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RepeatedTripleQuestion
    public typealias Answer = Right
}

public enum RepeatedOuterAnswer<M: Pair>: PredicateReading
where M.Right: Pair, M.Left: Structure, M.Left == M.Right.Right {
    public typealias Actual = FirstEvidenceImage<M, BeamSpace, SaturationEncoding, RepeatedTripleQuestion>
    public typealias Left = M
    public typealias Right = Actual.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RepeatedTripleQuestion
    public typealias Answer = Right
}

public enum RepeatedLastAnswer<M: Pair>: PredicateReading
where M.Right: Pair, M.Right.Left: Structure, M.Right.Left == M.Right.Right {
    public typealias Tail = SecondEvidenceImage<M, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Field = FirstEvidenceImage<M.Right, BeamSpace, SaturationEncoding, RepeatedTripleQuestion>
    public typealias Actual = SequentialReading<Tail, Field>
    public typealias Left = M
    public typealias Right = Actual.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RepeatedTripleQuestion
    public typealias Answer = Right
}

/// Two matching-case choices overlap only when all three values agree.
/// This checks the shared answer on that overlap; the cases remain readings
/// with their own actual field paths, rather than a runtime voting procedure.
public enum RepeatedAnswerOverlap<M: Pair>: Null
where M.Right: Pair, M.Left: Structure,
      M.Left == M.Right.Left, M.Left == M.Right.Right {
    public typealias A = RepeatedFirstAnswer<M>
    public typealias B = RepeatedOuterAnswer<M>
    public typealias C = RepeatedLastAnswer<M>
    public typealias Left = Paired<A.Answer, B.Answer>
    public typealias Right = Paired<C.Answer, C.Answer>
}

/// Three path answers with at most one arbitrary replacement of Q.
/// No discarded whole or damaged-path identifier enters a decoder.
public enum OneDefectTriple<Q: Structure, X: Structure>: Close {
    public typealias First = Paired<X, Paired<Q, Q>>
    public typealias Middle = Paired<Q, Paired<X, Q>>
    public typealias Last = Paired<Q, Paired<Q, X>>
    public typealias A = RepeatedLastAnswer<First>
    public typealias B = RepeatedOuterAnswer<Middle>
    public typealias C = RepeatedFirstAnswer<Last>
    public enum AllAnswers: Null {
        public typealias Left = Paired<A.Answer, Paired<B.Answer, C.Answer>>
        public typealias Right = Paired<Q, Paired<Q, Q>>
    }
    public typealias RecordedA = RecordReading<A>
    public typealias RecordedB = RecordReading<B>
    public typealias RecordedC = RecordReading<C>
    public enum RetainedRecords: Null {
        public typealias Left = Paired<RecordedA.Right.Left,
            Paired<RecordedB.Right.Left, RecordedC.Right.Left>>
        public typealias Right = Paired<First, Paired<Middle, Last>>
    }
}

/// The identical available 010 triple is one change from 000 and two
/// changes from 111. The wider defect allowance changes what it determines.
public enum WiderDefectAmbiguity: Close {
    public typealias FromZero = OneDefectTriple<Never, Lit1>.Middle
    public typealias FromOne = Paired<Never, Paired<Lit1, Never>>
    public typealias Decoder = RepeatedOuterAnswer<FromZero>
    public enum SameAvailableRecord: Null {
        public typealias Left = FromZero
        public typealias Right = FromOne
    }
    public enum AnswerAndAlternative: Null {
        public typealias Left = Paired<Decoder.Answer, Lit1>
        public typealias Right = Paired<Never, Lit1>
    }
}
