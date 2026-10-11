import VerificationIsIdentification

public enum ReplicaContactSpace: Close {}
public enum ReplicaContactEncoding: Close {}
public enum ReplicaExchangeAction: Close {}
public enum ReplicaViewQuestion: Close {}
public enum ReplicaValueQuestion: Close {}
public enum ReplicaRestoreAction: Close {}

public typealias ThreeReplicaView<A: Structure, B: Structure, C: Structure> =
    Paired<A, Paired<B, C>>
public typealias ReplicaFrame<A: Structure, B: Structure, C: Structure,
    D: Structure, E: Structure> = Paired<ThreeReplicaView<A, B, C>, Paired<D, E>>

// These four clauses specify actual transpositions, not a marker saying
// that a named operation affects at most one replica. All storage is internal.
public enum ExchangeReplicaOne<F: Pair>: PredicateReading
where F.Left: Pair, F.Left.Right: Pair, F.Right: Pair,
      F.Left.Left: Structure, F.Left.Right.Left: Structure,
      F.Left.Right.Right: Structure, F.Right.Left: Structure, F.Right.Right: Structure {
    public typealias Left = F
    public typealias Right = ReplicaFrame<F.Right.Left, F.Left.Right.Left,
        F.Left.Right.Right, F.Left.Left, F.Right.Right>
    public typealias Sigma = ReplicaContactSpace
    public typealias Encoding = ReplicaContactEncoding
    public typealias Predicate = ReplicaExchangeAction
    public typealias Answer = Right
}

public enum ExchangeReplicaTwo<F: Pair>: PredicateReading
where F.Left: Pair, F.Left.Right: Pair, F.Right: Pair,
      F.Left.Left: Structure, F.Left.Right.Left: Structure,
      F.Left.Right.Right: Structure, F.Right.Left: Structure, F.Right.Right: Structure {
    public typealias Left = F
    public typealias Right = ReplicaFrame<F.Left.Left, F.Right.Left,
        F.Left.Right.Right, F.Left.Right.Left, F.Right.Right>
    public typealias Sigma = ReplicaContactSpace
    public typealias Encoding = ReplicaContactEncoding
    public typealias Predicate = ReplicaExchangeAction
    public typealias Answer = Right
}

public enum ExchangeReplicaThree<F: Pair>: PredicateReading
where F.Left: Pair, F.Left.Right: Pair, F.Right: Pair,
      F.Left.Left: Structure, F.Left.Right.Left: Structure,
      F.Left.Right.Right: Structure, F.Right.Left: Structure, F.Right.Right: Structure {
    public typealias Left = F
    public typealias Right = ReplicaFrame<F.Left.Left, F.Left.Right.Left,
        F.Right.Left, F.Left.Right.Right, F.Right.Right>
    public typealias Sigma = ReplicaContactSpace
    public typealias Encoding = ReplicaContactEncoding
    public typealias Predicate = ReplicaExchangeAction
    public typealias Answer = Right
}

public enum ExchangeReplicaTwoWithSecondReserve<F: Pair>: PredicateReading
where F.Left: Pair, F.Left.Right: Pair, F.Right: Pair,
      F.Left.Left: Structure, F.Left.Right.Left: Structure,
      F.Left.Right.Right: Structure, F.Right.Left: Structure, F.Right.Right: Structure {
    public typealias Left = F
    public typealias Right = ReplicaFrame<F.Left.Left, F.Right.Right,
        F.Left.Right.Right, F.Right.Left, F.Left.Right.Left>
    public typealias Sigma = ReplicaContactSpace
    public typealias Encoding = ReplicaContactEncoding
    public typealias Predicate = ReplicaExchangeAction
    public typealias Answer = Right
}

/// Acquisition omits both reserves and the contact address.
public enum ReadThreeReplicas<F: Pair>: PredicateReading
where F.Left: Structure {
    public typealias Left = F
    public typealias Right = F.Left
    public typealias Sigma = ReplicaContactSpace
    public typealias Encoding = ReplicaContactEncoding
    public typealias Predicate = ReplicaViewQuestion
    public typealias Answer = Right
}

/// The three finite clauses inspect only their current view. Their domains
/// cover the one-exchange image of a homogeneous preparation; every overlap
/// has the same answer. The historical interpretation is proved in M64aw.
public enum ReadEqualReplicas12<V: Pair>: PredicateReading
where V.Right: Pair, V.Left == V.Right.Left, V.Left: Structure {
    public typealias Left = V
    public typealias Right = V.Left
    public typealias Sigma = ReplicaContactSpace
    public typealias Encoding = ReplicaContactEncoding
    public typealias Predicate = ReplicaValueQuestion
    public typealias Answer = Right
}

public enum ReadEqualReplicas13<V: Pair>: PredicateReading
where V.Right: Pair, V.Left == V.Right.Right, V.Left: Structure {
    public typealias Left = V
    public typealias Right = V.Left
    public typealias Sigma = ReplicaContactSpace
    public typealias Encoding = ReplicaContactEncoding
    public typealias Predicate = ReplicaValueQuestion
    public typealias Answer = Right
}

public enum ReadEqualReplicas23<V: Pair>: PredicateReading
where V.Right: Pair, V.Right.Left == V.Right.Right, V.Right.Left: Structure {
    public typealias Left = V
    public typealias Right = V.Right.Left
    public typealias Sigma = ReplicaContactSpace
    public typealias Encoding = ReplicaContactEncoding
    public typealias Predicate = ReplicaValueQuestion
    public typealias Answer = Right
}

/// An explicitly admitted repair contact, separate from reading sufficiency.
/// Its control comes from a reading of the current view alone. The complete
/// current input is retained as a remainder, recoverable by projection.
/// Arbitrary reading conformances do not establish historical correctness;
/// the one-exchange proof uses only the three equality clauses above.
public enum RestoreReplicasFromReading<D: PredicateReading, R: Structure>: PredicateReading
where D.Left: Structure, D.Answer: Structure,
      D.Sigma == ReplicaContactSpace, D.Encoding == ReplicaContactEncoding {
    public typealias Left = Paired<D.Left, R>
    public typealias Right = Paired<ThreeReplicaView<D.Answer, D.Answer, D.Answer>, Left>
    public typealias Sigma = ReplicaContactSpace
    public typealias Encoding = ReplicaContactEncoding
    public typealias Predicate = ReplicaRestoreAction
    public typealias Answer = Right
}

public enum OneExchangeReplicaRecovery<A: Structure, B: Structure, C: Structure>: Close {
    public typealias Source = ReplicaFrame<A, A, A, B, C>
    public typealias One = ExchangeReplicaOne<Source>
    public typealias Two = ExchangeReplicaTwo<Source>
    public typealias Three = ExchangeReplicaThree<Source>
    public typealias OtherReserve = ExchangeReplicaTwoWithSecondReserve<Source>
    public typealias SeenOne = SequentialReading<One, ReadThreeReplicas<One.Answer>>
    public typealias SeenTwo = SequentialReading<Two, ReadThreeReplicas<Two.Answer>>
    public typealias SeenThree = SequentialReading<Three, ReadThreeReplicas<Three.Answer>>
    public typealias SeenOther = SequentialReading<OtherReserve, ReadThreeReplicas<OtherReserve.Answer>>
    public typealias AnswerOne = SequentialReading<SeenOne, ReadEqualReplicas23<SeenOne.Answer>>
    public typealias AnswerTwo = SequentialReading<SeenTwo, ReadEqualReplicas13<SeenTwo.Answer>>
    public typealias AnswerThree = SequentialReading<SeenThree, ReadEqualReplicas12<SeenThree.Answer>>
    public typealias AnswerOther = SequentialReading<SeenOther, ReadEqualReplicas13<SeenOther.Answer>>
    public typealias RestoreOne = SequentialReading<One,
        RestoreReplicasFromReading<ReadEqualReplicas23<SeenOne.Answer>, One.Answer.Right>>
    public typealias RestoreTwo = SequentialReading<Two,
        RestoreReplicasFromReading<ReadEqualReplicas13<SeenTwo.Answer>, Two.Answer.Right>>
    public typealias RestoreThree = SequentialReading<Three,
        RestoreReplicasFromReading<ReadEqualReplicas12<SeenThree.Answer>, Three.Answer.Right>>
    public typealias RestoreOther = SequentialReading<OtherReserve,
        RestoreReplicasFromReading<ReadEqualReplicas13<SeenOther.Answer>, OtherReserve.Answer.Right>>
    public enum RecoveredSource: Null {
        public typealias Left = Paired<AnswerOne.Answer, Paired<AnswerTwo.Answer,
            Paired<AnswerThree.Answer, AnswerOther.Answer>>>
        public typealias Right = Paired<Source.Left.Left, Paired<Source.Left.Left,
            Paired<Source.Left.Left, Source.Left.Left>>>
    }
}

public enum TwoExchangeReplicaCollision<A: Structure, B: Structure>: Close {
    public typealias FirstSource = ReplicaFrame<A, A, A, B, B>
    public typealias FirstStep = ExchangeReplicaOne<FirstSource>
    public typealias FirstPath = SequentialReading<FirstStep,
        ExchangeReplicaTwoWithSecondReserve<FirstStep.Answer>>
    public typealias SecondSource = ReplicaFrame<B, B, B, A, A>
    public typealias SecondPath = ExchangeReplicaThree<SecondSource>
    public typealias FirstView = ReadThreeReplicas<FirstPath.Answer>
    public typealias SecondView = ReadThreeReplicas<SecondPath.Answer>
    public enum SameAvailableInput: Null {
        public typealias Left = FirstView.Answer
        public typealias Right = SecondView.Answer
    }
}
