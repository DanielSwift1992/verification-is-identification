import VerificationIsIdentification

public enum ReactionCountSpace: Close {}
public enum FirstCountBirthAction: Close {}
public enum SecondCountBirthAction: Close {}
public enum JointRemovalAction: Close {}
public enum FirstCountLossAction: Close {}

public enum FirstCountBirth<P: Pair>: PredicateReading
where P.Left: IntegerValued, P.Right: IntegerValued {
    public typealias Left = P
    public typealias Right = Paired<Examples.Succ<P.Left>, P.Right>
    public typealias Sigma = ReactionCountSpace
    public typealias Encoding = UnaryArithmeticEncoding
    public typealias Predicate = FirstCountBirthAction
    public typealias Answer = Right
}

public enum SecondCountBirth<P: Pair>: PredicateReading
where P.Left: IntegerValued, P.Right: IntegerValued {
    public typealias Left = P
    public typealias Right = Paired<P.Left, Examples.Succ<P.Right>>
    public typealias Sigma = ReactionCountSpace
    public typealias Encoding = UnaryArithmeticEncoding
    public typealias Predicate = SecondCountBirthAction
    public typealias Answer = Right
}

/// One reaction consumes one actual successor at each of two source fields.
/// Its source grammar excludes an empty reactant. This is a local count
/// model; chemical products and surrounding matter are not declared absent.
public enum JointCountRemoval<A: IntegerValued, B: IntegerValued>: PredicateReading {
    public typealias Left = Paired<Examples.Succ<A>, Examples.Succ<B>>
    public typealias Right = Paired<A, B>
    public typealias Sigma = ReactionCountSpace
    public typealias Encoding = UnaryArithmeticEncoding
    public typealias Predicate = JointRemovalAction
    public typealias Answer = Right
}

/// A genuinely different event: one count disappears without a coupled loss
/// of the other. It is not a constructor of the balanced-removal grammar.
public enum FirstCountLoss<A: IntegerValued, B: IntegerValued>: PredicateReading {
    public typealias Left = Paired<Examples.Succ<A>, B>
    public typealias Right = Paired<A, B>
    public typealias Sigma = ReactionCountSpace
    public typealias Encoding = UnaryArithmeticEncoding
    public typealias Predicate = FirstCountLossAction
    public typealias Answer = Right
}

/// Shape of a count-balance witness: Left is current counts; Right is the
/// initial counts augmented by their respective birth events. Their signed
/// differences agree in the finite Start/Reference/Sensing/Removal grammar.
/// That interpretation is proved by induction in M64av. The open protocol,
/// arbitrary conformances and cyclic IntegerValued types do not prove it.
public protocol JointEventBalance: Pair
where Left: Pair, Right: Pair,
      Left.Left: IntegerValued, Left.Right: IntegerValued,
      Right.Left: IntegerValued, Right.Right: IntegerValued {}

public enum StartEventBalance<A: IntegerValued, B: IntegerValued>: JointEventBalance {
    public typealias Left = Paired<A, B>
    public typealias Right = Left
}

public enum ReferenceEventBalance<P: JointEventBalance>: JointEventBalance {
    public typealias Earlier = P
    public typealias Event = FirstCountBirth<P.Left>
    public typealias Left = Event.Answer
    public typealias Right = Paired<Examples.Succ<P.Right.Left>, P.Right.Right>
}

public enum SensingEventBalance<P: JointEventBalance>: JointEventBalance {
    public typealias Earlier = P
    public typealias Event = SecondCountBirth<P.Left>
    public typealias Left = Event.Answer
    public typealias Right = Paired<P.Right.Left, Examples.Succ<P.Right.Right>>
}

/// In the finite construction grammar, the earlier witness supplies the
/// actual enabled source. No equality of final differences, final counts
/// or removed counts is asked of the caller. Each current field must be
/// an actual successor. The grammar constructs Paired at every step, so
/// Event.Left equals P.Left there. For an arbitrary open conformance,
/// equal fields do not identify P.Left with that event source. The two
/// field equations replace one equation on the whole pair, which made
/// Swift 6.2.3 crash while generating code for this conformance.
public enum RemovalEventBalance<P: JointEventBalance,
    A: IntegerValued, B: IntegerValued>: JointEventBalance
where P.Left.Left == Examples.Succ<A>, P.Left.Right == Examples.Succ<B> {
    public typealias Earlier = P
    public typealias Event = JointCountRemoval<A, B>
    public typealias Left = Event.Answer
    public typealias Right = P.Right
    public typealias RecordedEvent = RecordReading<Event>
}

/// A finite prefix with two reference births, one sensing birth and one
/// joint removal. Actual counts retain one net reference increment; the
/// birth ledger retains both births, without pretending the event vanished.
public enum UnbalancedBirthPrefix<A: IntegerValued, B: IntegerValued>: Close {
    public typealias Start = StartEventBalance<A, B>
    public typealias First = ReferenceEventBalance<Start>
    public typealias Second = ReferenceEventBalance<First>
    public typealias Third = SensingEventBalance<Second>
    public typealias End = RemovalEventBalance<Third, Examples.Succ<A>, B>
    public typealias FirstTwo = SequentialReading<First.Event, Second.Event>
    public typealias FirstThree = SequentialReading<FirstTwo, Third.Event>
    public typealias Path = SequentialReading<FirstThree, End.Event>
    public enum CurrentAndLedger: Null {
        public typealias Left = Paired<Path.Answer, End.Right>
        public typealias Right = Paired<Paired<Examples.Succ<A>, B>, Paired<Examples.Succ<Examples.Succ<A>>, Examples.Succ<B>>>
    }
}
