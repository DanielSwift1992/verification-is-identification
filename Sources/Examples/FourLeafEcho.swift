import VerificationIsIdentification

/// Two nineteen-step suffixes of the actual resident cycle. Their identical
/// grouping preserves one primitive instruction expression, U repeated19,
/// even though their current sources differ. No reset operation is supplied.
public enum FourLeafObservationLoops<K: Structure>: Close {
    public typealias C = FourLeafControlOrbit<K>
    public typealias A0 = FollowedPair<FollowedPair<C.S1, C.S2>, FollowedPair<C.S3, C.S4>>
    public typealias A1 = FollowedPair<FollowedPair<C.S5, C.S6>, FollowedPair<C.S7, C.S8>>
    public typealias A2 = FollowedPair<FollowedPair<C.S9, C.S10>, FollowedPair<C.S11, C.S12>>
    public typealias A3 = FollowedPair<FollowedPair<C.S13, C.S14>, FollowedPair<C.S15, C.S16>>
    public typealias A4 = FollowedPair<FollowedPair<C.S17, C.S18>, C.S19>
    public typealias Return0 = FollowedPair<FollowedPair<FollowedPair<A0, A1>, FollowedPair<A2, A3>>, A4>
    public typealias B0 = FollowedPair<FollowedPair<C.S6, C.S7>, FollowedPair<C.S8, C.S9>>
    public typealias B1 = FollowedPair<FollowedPair<C.S10, C.S11>, FollowedPair<C.S12, C.S13>>
    public typealias B2 = FollowedPair<FollowedPair<C.S14, C.S15>, FollowedPair<C.S16, C.S17>>
    public typealias B3 = FollowedPair<FollowedPair<C.S18, C.S19>, FollowedPair<C.S0, C.S1>>
    public typealias B4 = FollowedPair<FollowedPair<C.S2, C.S3>, C.S4>
    public typealias Return1 = FollowedPair<FollowedPair<FollowedPair<B0, B1>, FollowedPair<B2, B3>>, B4>
    public typealias Q0 = FirstEvidenceImage<C.S0.Answer, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Q1 = FirstEvidenceImage<C.S5.Answer, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias F0 = FactOf<Q0>
    public typealias F1 = FactOf<Q1>
    public enum Zero: PredicateReading {
        public typealias Actual = FollowedPair<FollowedPair<C.S0, RetainingRecordedReading<Q0>>,
            ExperimentReadingBeside<Return0, F0>>
        public typealias Left = C.S0.Left
        public typealias Right = Paired<C.S0.Left, F0>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = Actual.Predicate
        public typealias Answer = Right
        public enum Endpoints: Null {
            public typealias Left = Paired<Zero.Left, Zero.Right>
            public typealias Right = Paired<Actual.Left, Actual.Answer>
        }
    }
    public enum One: PredicateReading {
        public typealias Actual = FollowedPair<FollowedPair<C.S5, RetainingRecordedReading<Q1>>,
            ExperimentReadingBeside<Return1, F1>>
        public typealias Left = C.S5.Left
        public typealias Right = Paired<C.S5.Left, F1>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = Actual.Predicate
        public typealias Answer = Right
        public enum Endpoints: Null {
            public typealias Left = Paired<One.Left, One.Right>
            public typealias Right = Paired<Actual.Left, Actual.Answer>
        }
    }
    public enum SameInstruction: Null {
        public typealias Left = Zero.Predicate
        public typealias Right = One.Predicate
    }
}

/// One internally ordered experiment: acquire a baseline and continue U to
/// its original target; perform Z; acquire again with the same observation
/// program; continue U and perform Z again. Both facts and the used tape stay.
/// The count is52 contact actions and2 stage acquisitions, not a runtime loop.
public enum FourLeafEcho<K: Structure>: PredicateReading {
    public typealias L = FourLeafObservationLoops<K>
    public typealias Context = Paired<FourLeafAddressProgram, K>
    public typealias Z0 = FourLeafJointZ<Lit1, Never, Never, Never, Context>
    public typealias Z1 = FourLeafJointZ<Never, Lit1, Never, Never, Context>
    public typealias R0 = L.Zero
    public typealias R1 = ExperimentReadingBeside<Z0, L.F0>
    public typealias R2 = ExperimentReadingBeside<L.One, L.F0>
    public typealias R3 = ExperimentReadingBeside<ExperimentReadingBeside<Z1, L.F1>, L.F0>
    public typealias Tape = Paired<R0.Predicate, Paired<R1.Predicate, Paired<R2.Predicate, Paired<R3.Predicate, Never>>>>
    public typealias Past1 = Paired<R0.Predicate, Never>
    public typealias Past2 = Paired<R1.Predicate, Past1>
    public typealias Past3 = Paired<R2.Predicate, Past2>
    public typealias Past4 = Paired<R3.Predicate, Past3>
    public typealias First = ResidentBoundaryCommand<R0, Tape, Never>
    public typealias Second = ResidentBoundaryCommand<R1, Tape.Right, Past1>
    public typealias Third = ResidentBoundaryCommand<R2, Tape.Right.Right, Past2>
    public typealias Fourth = ResidentBoundaryCommand<R3, Tape.Right.Right.Right, Past3>
    public typealias Left = Paired<L.C.S0.Left, Paired<Tape, Never>>
    public typealias Right = Paired<Paired<Paired<L.C.S0.Left, L.F1>, L.F0>, Paired<Never, Past4>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = OperationSequence<OperationSequence<OperationSequence<R0.Predicate,
        R1.Predicate>, R2.Predicate>, R3.Predicate>
    public typealias Answer = Right
    public enum Seams: Null {
        public typealias Left = Paired<FourLeafEcho.Left, Paired<First.Answer,
            Paired<Second.Answer, Paired<Third.Answer, Fourth.Answer>>>>
        public typealias Right = Paired<First.Left, Paired<Second.Left,
            Paired<Third.Left, Paired<Fourth.Left, FourLeafEcho.Right>>>>
    }
    public enum TargetReturns: Null {
        public typealias Left = FourLeafEcho.Right.Left.Left.Left
        public typealias Right = FourLeafEcho.Left.Left
    }
}

/// The available result contains just the two actual stage facts, in their
/// acquisition order. Neither the restored target nor the command past is
/// passed into the answer reader.
public enum FourLeafEchoFacts<W: Pair>: PredicateReading
where W.Left: Pair, W.Left.Right: Structure,
      W.Left.Left: Pair, W.Left.Left.Right: Structure {
    public typealias Working = FirstEvidenceImage<W, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Inner = FollowedPair<Working,
        FirstEvidenceImage<Working.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias First = FollowedPair<Working,
        SecondEvidenceImage<Working.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Second = FollowedPair<Inner,
        SecondEvidenceImage<Inner.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Actual = JointEvidence<First, Second>
    public typealias Left = W
    public typealias Right = Actual.Answer
    public typealias Sigma = Actual.Sigma
    public typealias Encoding = Actual.Encoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
}

public typealias FourLeafEchoAnswers<K: Structure> = TwoRecordedAnswers<
    FourLeafEchoFacts<FourLeafEcho<K>.Answer>.Answer>
