import VerificationIsIdentification

/// Read only nine actual cells: 01 at A, 012 at B, 02 at C, 12 at D.
/// The common u/q program is inherited from ContactProfile's projections.
public enum NineContactProfileReadings<A: Pair, B: Pair, C: Pair, D: Pair>: PredicateReading
where A.Left: Pair, A.Left.Left: Pair, A.Right: Structure,
      A.Left.Right: Structure, A.Left.Left.Right: Structure,
      B.Left: Pair, B.Left.Left: Pair, B.Right: Structure,
      B.Left.Right: Structure, B.Left.Left.Right: Structure,
      C.Left: Pair, C.Left.Left: Pair, C.Right: Structure,
      C.Left.Right: Structure, C.Left.Left.Right: Structure,
      D.Left: Pair, D.Left.Left: Pair, D.Right: Structure,
      D.Left.Right: Structure, D.Left.Left.Right: Structure {
    public typealias A01 = JointEvidence<ContactProfile<A>.Q0, ContactProfile<A>.Q1>
    public typealias C02 = JointEvidence<ContactProfile<C>.Q0, ContactProfile<C>.Q2>
    public typealias D12 = JointEvidence<ContactProfile<D>.Q1, ContactProfile<D>.Q2>
    public typealias Actual = PairedApplication<PairedApplication<A01, ContactProfile<B>>,
        PairedApplication<C02, D12>>
    public typealias Mandatory = PairedApplication<
        PairedApplication<ContactProfile<A>.Q1, ContactProfile<B>>,
        PairedApplication<ContactProfile<C>.Q0, ContactProfile<D>.Q2>>
    public typealias Left = BoundaryWorking<A, B, C, D>
    public typealias Right = BoundaryWorking<Paired<A.Right, A.Left.Right>, ContactProfile<B>.Answer,
        Paired<C.Right, C.Left.Left.Right>, Paired<D.Left.Right, D.Left.Left.Right>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
    public enum Endpoint: Null {
        public typealias Left = Paired<Actual.Left, Actual.Answer>
        public typealias Right = Paired<NineContactProfileReadings.Left, NineContactProfileReadings.Answer>
    }
}

/// A separating calibration without rotations. X,Y,Z need not agree.
/// These three unread symbols and the complete tail remain unrestricted.
public enum SparseContactProfileFamily<X: Structure, Y: Structure,
    Z: Structure, K: Structure>: Close {
    public typealias A = ContactProfileChain<Never, Lit1, X, K>
    public typealias B = ContactProfileChain<Never, Never, Never, K>
    public typealias C = ContactProfileChain<Lit1, Y, Never, K>
    public typealias D = ContactProfileChain<Z, Never, Lit1, K>
    public typealias Read = NineContactProfileReadings<A, B, C, D>
    public typealias Record = RecordReading<Read>
    public enum NineActualValues: Null {
        public typealias Left = Read.Answer
        public typealias Right = BoundaryWorking<Paired<Never, Lit1>, AddressTriple<Never, Never, Never>,
            Paired<Lit1, Never>, Paired<Never, Lit1>>
    }
    /// Every pair has an observed 0/1 separator: AB,AC,AD,BC,BD,CD.
    public enum SixActualSeparators: Null {
        public typealias Left = Paired<
            AddressTriple<Paired<A.Left.Right, B.Left.Right>, Paired<A.Right, C.Right>,
                Paired<A.Left.Right, D.Left.Right>>,
            AddressTriple<Paired<B.Right, C.Right>, Paired<B.Left.Left.Right, D.Left.Left.Right>,
                Paired<C.Left.Left.Right, D.Left.Left.Right>>>
        public typealias Right = Paired<
            AddressTriple<RoutingAddress10, RoutingAddress01, RoutingAddress10>,
            AddressTriple<RoutingAddress01, RoutingAddress01, RoutingAddress01>>
    }
}

public enum SameSparseCalibration<X: Structure, Y: Structure, Z: Structure,
    K: Structure, XX: Structure, YY: Structure, ZZ: Structure, KK: Structure>: Null {
    public typealias Left = SparseContactProfileFamily<X, Y, Z, K>.Record.Right.Right
    public typealias Right = SparseContactProfileFamily<XX, YY, ZZ, KK>.Record.Right.Right
}

/// This positive clause receives the nine observed values only. The three
/// unread profile cells cannot be recovered from this fact and are not used.
public enum AcceptedSparseContactProfiles<F: HasVerdict & Structure>: PredicateReading
where F.Sigma == BeamSpace, F.Encoding == SaturationEncoding,
      F.Answer == BoundaryWorking<RoutingAddress01, AddressTriple<Never, Never, Never>,
        RoutingAddress10, RoutingAddress01> {
    public typealias Values = ReadRecordedAnswer<F>
    public typealias FirstPair = SequentialReading<Values,
        FirstEvidenceImage<F.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias First = SequentialReading<FirstPair,
        FirstEvidenceImage<F.Answer.Left, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Actual = SequentialReading<First,
        SecondEvidenceImage<F.Answer.Left.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Left = F
    public typealias Right = F.Answer.Left.Left.Right
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = ContactProfileCalibrationQuestion
    public typealias Answer = Right
    public enum Endpoint: Null {
        public typealias Left = Actual.Answer
        public typealias Right = AcceptedSparseContactProfiles.Answer
    }
}

/// Intersect all minimum supports: the six mandatory cells are retained,
/// but three active source rows can now share one complete image 111.
public enum MandatoryProfilesCanMerge: Close {
    public typealias Good = SparseContactProfileFamily<Never, Never, Never, Never>
    public typealias Shared = ContactProfileChain<Lit1, Lit1, Lit1, Never>
    public typealias Bad = NineContactProfileReadings<Shared, Good.B, Shared, Shared>
    public enum SameAcquiredFact: Null {
        public typealias Left = FactOf<Good.Read.Mandatory>
        public typealias Right = FactOf<Bad.Mandatory>
    }
    public enum ActualMerger: Null {
        public typealias Left = AddressTriple<Bad.Left.Left.Left, Bad.Left.Right.Left, Bad.Left.Right.Right>
        public typealias Right = AddressTriple<Shared, Shared, Shared>
    }
}
