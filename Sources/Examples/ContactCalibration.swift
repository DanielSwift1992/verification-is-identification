import VerificationIsIdentification

public enum ContactRecordQuestion: Close {}
public enum ContactCalibrationQuestion: Close {}

/// Five addressed ports carry a chosen resident calibration. The code is a
/// design of this interface; it is not inferred from the name of a port.
public typealias ContactPort0 = Paired<Never, RoutingAddress00>
public typealias ContactPort1 = Paired<Lit1, RoutingAddress01>
public typealias ContactPort2 = Paired<Lit2, RoutingAddress00>
public typealias ContactPort3 = Paired<Succ<Lit2>, RoutingAddress01>
public typealias ContactPort4 = Paired<Succ<Succ<Lit2>>, RoutingAddress10>
public typealias ContactSeam01 = Paired<ContactPort0.Left, ContactPort1.Left>
public typealias ContactSeam12 = Paired<ContactPort1.Left, ContactPort2.Left>
public typealias ContactSeam23 = Paired<ContactPort2.Left, ContactPort3.Left>
public typealias ContactSeam34 = Paired<ContactPort3.Left, ContactPort4.Left>
public typealias ContactSeam40 = Paired<ContactPort4.Left, ContactPort0.Left>

/// The active port, addressed seam and both payloads remain in one source.
public typealias ContactWorld<P: Pair, E: Pair, A: Structure, B: Structure> = Paired<P, Paired<E, Paired<A, B>>>

/// Independent source question: the payload at the active endpoint.
/// Each clause requires actual endpoint identity, without using calibration.
public enum ContactLeftValue<W: Pair>: PredicateReading
where W.Left: Pair, W.Right: Pair, W.Right.Left: Pair, W.Right.Right: Pair,
      W.Left.Left == W.Right.Left.Left {
    public typealias Left = W
    public typealias Right = W.Right.Right.Left
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RoutedValueQuestion
    public typealias Answer = Right
}
public enum ContactRightValue<W: Pair>: PredicateReading
where W.Left: Pair, W.Right: Pair, W.Right.Left: Pair, W.Right.Right: Pair,
      W.Left.Left == W.Right.Left.Right {
    public typealias Left = W
    public typealias Right = W.Right.Right.Right
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RoutedValueQuestion
    public typealias Answer = Right
}

public typealias ContactRecord<W: Pair> = SecondEvidenceImage<W, BeamSpace, SaturationEncoding, ContactRecordQuestion>
public typealias ContactCalibration<W: Pair> = DecodeRefinedEvidence<
    FirstEvidenceImage<W, BeamSpace, SaturationEncoding, FirstProjection>,
    SecondEvidenceImage<W.Left, BeamSpace, SaturationEncoding, ContactCalibrationQuestion>
>
where W.Left: Pair

/// The decoder receives these two facts, with no port identity field.
public typealias ContactFacts<W: Pair> = JointEvidence<
    AcquireAnswer<ContactRecord<W>>.Observation,
    AcquireAnswer<ContactCalibration<W>>.Observation
>
where W.Left: Pair

/// Actual projection programs construct the decoder rows. No evaluator or
/// arbitrary answer is supplied. Only the finite clauses below use these rows.
public typealias ContactA<D: Pair> = FirstEvidenceImage<D, BeamSpace, SaturationEncoding, FirstProjection>
public typealias ContactB<D: Pair> = SecondEvidenceImage<D, BeamSpace, SaturationEncoding, SecondProjection>
public typealias ContactRowABAA<D: Pair> = JointEvidence<JointEvidence<ContactA<D>, ContactB<D>>, JointEvidence<ContactA<D>, ContactA<D>>>
where D.Left: Structure, D.Right: Structure
public typealias ContactRowBAAA<D: Pair> = JointEvidence<JointEvidence<ContactB<D>, ContactA<D>>, JointEvidence<ContactA<D>, ContactA<D>>>
where D.Left: Structure, D.Right: Structure
public typealias ContactRowAABA<D: Pair> = JointEvidence<JointEvidence<ContactA<D>, ContactA<D>>, JointEvidence<ContactB<D>, ContactA<D>>>
where D.Left: Structure, D.Right: Structure

/// Attach the actually recorded calibration to a row made from the recorded
/// payload. R's meaning is its supplied program, not its question label.
public enum ContactPreparedRow<E: Pair, C: Structure, R: PredicateReading>: PredicateReading
where R.Left: Structure, R.Answer: Structure,
      R.Sigma == BeamSpace, R.Encoding == SaturationEncoding {
    public typealias Left = Paired<
        AnswerFact<BeamSpace, SaturationEncoding, ContactRecordQuestion, Paired<E, R.Left>>,
        AnswerFact<BeamSpace, SaturationEncoding, ContactCalibrationQuestion, C>
    >
    public typealias Right = Paired<C, R.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RoutedValueQuestion
    public typealias Answer = Right
}

/// One family proof covers both endpoints of all five seams for arbitrary
/// payloads. Each decoder clause is the existing Route00/01/10 applied to an
/// actual projection row. PairedApplication packages the proof obligations;
/// it is not a claim that one experiment acquired ten independent sources.
public enum CalibratedContactCycle<A: Structure, B: Structure>: Close {
    public typealias D = Paired<A, B>
    public typealias W01L = ContactWorld<ContactPort0, ContactSeam01, A, B>
    public typealias W01R = ContactWorld<ContactPort1, ContactSeam01, A, B>
    public typealias W12L = ContactWorld<ContactPort1, ContactSeam12, A, B>
    public typealias W12R = ContactWorld<ContactPort2, ContactSeam12, A, B>
    public typealias W23L = ContactWorld<ContactPort2, ContactSeam23, A, B>
    public typealias W23R = ContactWorld<ContactPort3, ContactSeam23, A, B>
    public typealias W34L = ContactWorld<ContactPort3, ContactSeam34, A, B>
    public typealias W34R = ContactWorld<ContactPort4, ContactSeam34, A, B>
    public typealias W40L = ContactWorld<ContactPort4, ContactSeam40, A, B>
    public typealias W40R = ContactWorld<ContactPort0, ContactSeam40, A, B>

    public typealias Decode01L = DecodeRefinedEvidence<ContactPreparedRow<ContactSeam01, RoutingAddress00, ContactRowABAA<D>>, Route00<ContactRowABAA<D>.Answer>>
    public typealias Decode01R = DecodeRefinedEvidence<ContactPreparedRow<ContactSeam01, RoutingAddress01, ContactRowABAA<D>>, Route01<ContactRowABAA<D>.Answer>>
    public typealias Decode12L = DecodeRefinedEvidence<ContactPreparedRow<ContactSeam12, RoutingAddress01, ContactRowBAAA<D>>, Route01<ContactRowBAAA<D>.Answer>>
    public typealias Decode12R = DecodeRefinedEvidence<ContactPreparedRow<ContactSeam12, RoutingAddress00, ContactRowBAAA<D>>, Route00<ContactRowBAAA<D>.Answer>>
    public typealias Decode23L = DecodeRefinedEvidence<ContactPreparedRow<ContactSeam23, RoutingAddress00, ContactRowABAA<D>>, Route00<ContactRowABAA<D>.Answer>>
    public typealias Decode23R = DecodeRefinedEvidence<ContactPreparedRow<ContactSeam23, RoutingAddress01, ContactRowABAA<D>>, Route01<ContactRowABAA<D>.Answer>>
    public typealias Decode34L = DecodeRefinedEvidence<ContactPreparedRow<ContactSeam34, RoutingAddress01, ContactRowAABA<D>>, Route01<ContactRowAABA<D>.Answer>>
    public typealias Decode34R = DecodeRefinedEvidence<ContactPreparedRow<ContactSeam34, RoutingAddress10, ContactRowAABA<D>>, Route10<ContactRowAABA<D>.Answer>>
    public typealias Decode40L = DecodeRefinedEvidence<ContactPreparedRow<ContactSeam40, RoutingAddress10, ContactRowBAAA<D>>, Route10<ContactRowBAAA<D>.Answer>>
    public typealias Decode40R = DecodeRefinedEvidence<ContactPreparedRow<ContactSeam40, RoutingAddress00, ContactRowBAAA<D>>, Route00<ContactRowBAAA<D>.Answer>>

    public enum Seam01: ReadingFactors {
        public typealias Left = PairedApplication<ContactLeftValue<W01L>, ContactRightValue<W01R>>
        public typealias Observation = PairedApplication<ContactFacts<W01L>, ContactFacts<W01R>>
        public typealias Right = PairedApplication<Decode01L, Decode01R>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = Left.Predicate
        public typealias Answer = Left.Answer
    }
    public enum Seam12: ReadingFactors {
        public typealias Left = PairedApplication<ContactLeftValue<W12L>, ContactRightValue<W12R>>
        public typealias Observation = PairedApplication<ContactFacts<W12L>, ContactFacts<W12R>>
        public typealias Right = PairedApplication<Decode12L, Decode12R>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = Left.Predicate
        public typealias Answer = Left.Answer
    }
    public enum Seam23: ReadingFactors {
        public typealias Left = PairedApplication<ContactLeftValue<W23L>, ContactRightValue<W23R>>
        public typealias Observation = PairedApplication<ContactFacts<W23L>, ContactFacts<W23R>>
        public typealias Right = PairedApplication<Decode23L, Decode23R>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = Left.Predicate
        public typealias Answer = Left.Answer
    }
    public enum Seam34: ReadingFactors {
        public typealias Left = PairedApplication<ContactLeftValue<W34L>, ContactRightValue<W34R>>
        public typealias Observation = PairedApplication<ContactFacts<W34L>, ContactFacts<W34R>>
        public typealias Right = PairedApplication<Decode34L, Decode34R>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = Left.Predicate
        public typealias Answer = Left.Answer
    }
    public enum Seam40: ReadingFactors {
        public typealias Left = PairedApplication<ContactLeftValue<W40L>, ContactRightValue<W40R>>
        public typealias Observation = PairedApplication<ContactFacts<W40L>, ContactFacts<W40R>>
        public typealias Right = PairedApplication<Decode40L, Decode40R>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = Left.Predicate
        public typealias Answer = Left.Answer
    }
}

/// Replace a resident contact while retaining the old port and the record's
/// source fields. This change does not itself guarantee endpoint admission.
public enum ContactReserveChange<W: Pair, P: Pair>: Pair
where W.Left: Structure, W.Right: Structure {
    public typealias Left = Paired<W, P>
    public typealias Right = Paired<Paired<P, W.Right>, W.Left>
}
public enum ContactChangeRetainsRecord<W: Pair, P: Pair>: Null
where W.Left: Structure, W.Right: Structure {
    public typealias Left = FactOf<ContactRecord<W>>
    public typealias Right = FactOf<ContactRecord<ContactReserveChange<W, P>.Right.Left>>
}

/// Each of five edges reverses the same two marker positions. Closing this
/// odd circuit forces those markers equal. The conclusion is not a premise.
/// For a genuine two-symbol alphabet, unequal neighbors must be opposites;
/// arbitrary Pair conformances are not claimed to form that alphabet.
public enum OddContactCalibration<C0: Pair, C1: Pair, C2: Pair, C3: Pair, C4: Pair>: Null
where C1.Left == C0.Right, C1.Right == C0.Left,
      C2.Left == C1.Right, C2.Right == C1.Left,
      C3.Left == C2.Right, C3.Right == C2.Left,
      C4.Left == C3.Right, C4.Right == C3.Left,
      C0.Left == C4.Right, C0.Right == C4.Left {
    public typealias Left = C0.Left
    public typealias Right = C0.Right
}
