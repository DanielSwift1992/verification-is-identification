import VerificationIsIdentification

public enum LastTwoProfileQuestion: Close {}

/// Both readings start from the same complete image. No q0 value enters.
public typealias LastTwoContactProfile<T: Pair> = JointEvidence<ContactProfile<T>.Q1, ContactProfile<T>.Q2>
where T.Left: Pair, T.Left.Left: Pair, T.Right: Structure,
      T.Left.Right: Structure, T.Left.Left.Right: Structure

public enum FourLastTwoProfiles<A: Pair, B: Pair, C: Pair, D: Pair>: PredicateReading
where A.Left: Pair, A.Left.Left: Pair, A.Right: Structure,
      A.Left.Right: Structure, A.Left.Left.Right: Structure,
      B.Left: Pair, B.Left.Left: Pair, B.Right: Structure,
      B.Left.Right: Structure, B.Left.Left.Right: Structure,
      C.Left: Pair, C.Left.Left: Pair, C.Right: Structure,
      C.Left.Right: Structure, C.Left.Left.Right: Structure,
      D.Left: Pair, D.Left.Left: Pair, D.Right: Structure,
      D.Left.Right: Structure, D.Left.Left.Right: Structure {
    public typealias Actual = PairedApplication<
        PairedApplication<LastTwoContactProfile<A>, LastTwoContactProfile<B>>,
        PairedApplication<LastTwoContactProfile<C>, LastTwoContactProfile<D>>>
    public typealias Left = BoundaryWorking<A, B, C, D>
    public typealias Right = BoundaryWorking<Paired<A.Left.Right, A.Left.Left.Right>,
        Paired<B.Left.Right, B.Left.Left.Right>, Paired<C.Left.Right, C.Left.Left.Right>,
        Paired<D.Left.Right, D.Left.Left.Right>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = LastTwoProfileQuestion
    public typealias Answer = Right
    public enum Endpoint: Null {
        public typealias Left = Paired<Actual.Left, Actual.Answer>
        public typealias Right = Paired<FourLastTwoProfiles.Left, FourLastTwoProfiles.Answer>
    }
}

/// The four binary addresses occur as actual suffixes. The complete first
/// column and each complete unread tail remain independent parameters.
public enum RectangularProfiles<A0: Structure, B0: Structure, C0: Structure, D0: Structure,
    KA: Structure, KB: Structure, KC: Structure, KD: Structure>: Close {
    public typealias A = ContactProfileChain<A0, Lit1, Lit1, KA>
    public typealias B = ContactProfileChain<B0, Never, Never, KB>
    public typealias C = ContactProfileChain<C0, Lit1, Never, KC>
    public typealias D = ContactProfileChain<D0, Never, Lit1, KD>
    public typealias Read = FourLastTwoProfiles<A, B, C, D>
    public enum EightActualValues: Null {
        public typealias Left = Read.Answer
        public typealias Right = BoundaryWorking<RoutingAddress11, RoutingAddress00,
            RoutingAddress10, RoutingAddress01>
    }
    /// AB, AC, AD, BC, BD, CD; each entry is an actual 0/1 contrast.
    public enum SixSeparators: Null {
        public typealias Left = Paired<
            AddressTriple<Paired<A.Left.Right, B.Left.Right>,
                Paired<A.Left.Left.Right, C.Left.Left.Right>, Paired<A.Left.Right, D.Left.Right>>,
            AddressTriple<Paired<B.Left.Right, C.Left.Right>,
                Paired<B.Left.Left.Right, D.Left.Left.Right>, Paired<C.Left.Right, D.Left.Right>>>
        public typealias Right = Paired<
            AddressTriple<RoutingAddress10, RoutingAddress10, RoutingAddress10>,
            AddressTriple<RoutingAddress01, RoutingAddress01, RoutingAddress10>>
    }
}

/// The already acquired second branch: C1=A2=1. Acquire the eight actual
/// suffix cells and exchange the former A0 with arbitrary resident V.
/// This constructs reuse of that certificate, not the two-query adaptive
/// policy that decides which branch to acquire from the old nine-cell fact.
public enum RectangularProfileExchange<Z: Structure, K: Structure, V: Structure>: Close {
    public typealias H = RectangularProfiles<Never, Never, Lit1, Z, K, K, K, K>
    public typealias Root = Paired<H.Read.Left, V>
    public typealias Reading = ReadFirstProfileSource<Root, H.Read>
    public typealias Fact = FactOf<Reading>
    public typealias Record = RecordReading<Reading>
    public typealias Exchange = ExchangeRetiredProfileCell<Root>
    public typealias Shift = StepBeside<Exchange, Fact>
    public typealias Actual = FollowedPair<Record, Shift>
    public typealias New = RectangularProfiles<V, Never, Lit1, Z, K, K, K, K>
    public typealias NewRoot = Paired<New.Read.Left, Never>
    public typealias After = Paired<NewRoot, Fact>
    public typealias Current = ReadFirstProfileSource<After, ReadFirstProfileSource<NewRoot, New.Read>>
    public enum Endpoints: Null {
        public typealias Left = Paired<Actual.Left, Actual.Right>
        public typealias Right = Paired<Root, After>
    }
    public enum CurrentSupportFactors: ReadingFactors {
        public typealias Left = Current
        public typealias Observation = SecondEvidenceImage<After, BeamSpace, SaturationEncoding, SecondProjection>
        public typealias Right = ReadRecordedAnswer<Fact>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = LastTwoProfileQuestion
        public typealias Answer = Current.Answer
    }
}

/// The two allowed first measurements each leave a binary ambiguity on
/// one branch. These equalities supply the lower-bound witnesses in M64s.
public enum ProfileReleaseInquiry<K: Structure>: Close {
    public typealias F00 = SparseContactProfileFamily<Never, Never, Never, K>
    public typealias F01 = SparseContactProfileFamily<Never, Lit1, Never, K>
    public typealias F10 = SparseContactProfileFamily<Lit1, Never, Never, K>
    public typealias F11 = SparseContactProfileFamily<Lit1, Lit1, Never, K>
    public enum SameOldFacts: Null {
        public typealias Left = BoundaryWorking<FactOf<F00.Read>, FactOf<F01.Read>,
            FactOf<F10.Read>, FactOf<F11.Read>>
        public typealias Right = BoundaryWorking<FactOf<F00.Read>, FactOf<F00.Read>,
            FactOf<F00.Read>, FactOf<F00.Read>>
    }
    public enum EitherFirstQueryCanRemainAmbiguous: Null {
        public typealias Left = Paired<
            Paired<ContactProfile<F01.C>.Q1.Answer, ContactProfile<F11.C>.Q1.Answer>,
            Paired<ContactProfile<F00.A>.Q2.Answer, ContactProfile<F01.A>.Q2.Answer>>
        public typealias Right = Paired<RoutingAddress11, RoutingAddress00>
    }
    public enum MissingLastCellCanMerge: Null {
        public typealias Before = RectangularProfiles<Never, Never, Lit1, Never, K, K, K, K>
        public typealias A = ContactProfileChain<Lit1, Lit1, Never, K>
        public typealias Left = A
        public typealias Right = Before.C
    }
}
