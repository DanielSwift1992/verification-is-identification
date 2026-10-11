import VerificationIsIdentification

public enum ProfileXZSupportQuestion: Close {}
public enum ProfileMixedSupportQuestion: Close {}

/// Four addressed projections, with no assumption about the cell values.
public enum FourProfileCells<C: Pair>: Close
where C.Left: Pair, C.Right: Pair,
      C.Left.Left: Structure, C.Left.Right: Structure,
      C.Right.Left: Structure, C.Right.Right: Structure {
    public typealias Low = FirstEvidenceImage<C, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias High = SecondEvidenceImage<C, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias A = SequentialReading<Low, FirstEvidenceImage<C.Left, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias B = SequentialReading<Low, SecondEvidenceImage<C.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias C0 = SequentialReading<High, FirstEvidenceImage<C.Right, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias D = SequentialReading<High, SecondEvidenceImage<C.Right, BeamSpace, SaturationEncoding, SecondProjection>>
}

/// Column-major representation (X,(Y,Z)). The outer pair in a column
/// groups the two rows at each value of the retained Z coordinate.
public enum RenewalColumns<T: Pair>: Close
where T.Right: Pair, T.Left: Pair, T.Left.Left: Pair, T.Left.Right: Pair,
      T.Right.Left: Pair, T.Right.Left.Left: Pair, T.Right.Left.Right: Pair,
      T.Right.Right: Pair, T.Right.Right.Left: Pair, T.Right.Right.Right: Pair,
      T.Left.Left.Left: Structure, T.Left.Left.Right: Structure,
      T.Left.Right.Left: Structure, T.Left.Right.Right: Structure,
      T.Right.Left.Left.Left: Structure, T.Right.Left.Left.Right: Structure,
      T.Right.Left.Right.Left: Structure, T.Right.Left.Right.Right: Structure,
      T.Right.Right.Left.Left: Structure, T.Right.Right.Left.Right: Structure,
      T.Right.Right.Right.Left: Structure, T.Right.Right.Right.Right: Structure {
    public typealias X = FirstEvidenceImage<T, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Rest = SecondEvidenceImage<T, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Y = SequentialReading<Rest, FirstEvidenceImage<T.Right, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Z = SequentialReading<Rest, SecondEvidenceImage<T.Right, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias YZ = JointEvidence<Y, Z>
    public typealias X0 = SequentialReading<X, FourProfileCells<T.Left>.A>
    public typealias X1 = SequentialReading<X, FourProfileCells<T.Left>.B>
    public typealias X2 = SequentialReading<X, FourProfileCells<T.Left>.C0>
    public typealias X3 = SequentialReading<X, FourProfileCells<T.Left>.D>
    public typealias FirstXPair = SequentialReading<X,
        FirstEvidenceImage<T.Left, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias SecondXPair = SequentialReading<X,
        SecondEvidenceImage<T.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias SecondYPair = SequentialReading<Y,
        SecondEvidenceImage<T.Right.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public enum Mixed: PredicateReading {
        public typealias Actual = JointEvidence<Z, JointEvidence<FirstXPair, SecondYPair>>
        public typealias Left = T
        public typealias Right = Paired<T.Right.Right, Paired<T.Left.Left, T.Right.Left.Right>>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = ProfileMixedSupportQuestion
        public typealias Answer = Right
        public enum Endpoint: Null {
            public typealias Left = Actual.Answer
            public typealias Right = Mixed.Answer
        }
    }
    public enum XZ: PredicateReading {
        public typealias Actual = JointEvidence<X, Z>
        public typealias Left = T
        public typealias Right = Paired<T.Left, T.Right.Right>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = ProfileXZSupportQuestion
        public typealias Answer = Right
        public enum Endpoint: Null {
            public typealias Left = Actual.Answer
            public typealias Right = XZ.Answer
        }
    }
    /// Exchange the two Y values in each row pair. X,Z and all their
    /// fields remain at the same addresses. The exchange is its own inverse.
    public typealias FlipY = PairedApplication<
        IdentityReading<T.Left, BeamSpace, SaturationEncoding>,
        PairedApplication<PairedApplication<SwapBoundaryReading<T.Right.Left.Left>,
            SwapBoundaryReading<T.Right.Left.Right>>,
            IdentityReading<T.Right.Right, BeamSpace, SaturationEncoding>>>
    public typealias FlipYFirst = PairedApplication<IdentityReading<T.Left, BeamSpace, SaturationEncoding>,
        PairedApplication<PairedApplication<SwapBoundaryReading<T.Right.Left.Left>,
            IdentityReading<T.Right.Left.Right, BeamSpace, SaturationEncoding>>,
            IdentityReading<T.Right.Right, BeamSpace, SaturationEncoding>>>
    public typealias FlipYSecond = PairedApplication<IdentityReading<T.Left, BeamSpace, SaturationEncoding>,
        PairedApplication<PairedApplication<IdentityReading<T.Right.Left.Left, BeamSpace, SaturationEncoding>,
            SwapBoundaryReading<T.Right.Left.Right>>,
            IdentityReading<T.Right.Right, BeamSpace, SaturationEncoding>>>
}

/// Reassociation keeps the stored fields of the canonical pairs used here.
/// It does not assert recovery of arbitrary nominal Pair shells.
public enum ReassociateProfileRecord<W: Pair>: Pair
where W.Left: Pair, W.Left.Left: Structure, W.Left.Right: Structure, W.Right: Structure {
    public typealias Left = W
    public typealias Right = Paired<W.Left.Left, Paired<W.Left.Right, W.Right>>
}

/// The actual reading is lifted to this resident source before recording.
public enum ArchiveProfileRead<W: Pair, R: PredicateReading>: Pair
where W.Left == R.Left, W.Left: Structure, W.Right: Structure,
      R.Sigma == BeamSpace, R.Encoding == SaturationEncoding {
    public typealias Reading = ReadFirstProfileSource<W, R>
    public typealias Record = RecordReading<Reading>
    public typealias Actual = FollowedPair<Record, ReassociateProfileRecord<Record.Right>>
    public typealias Left = W
    public typealias Right = Paired<W.Left, Paired<W.Right, FactOf<R>>>
    public enum Endpoint: Null {
        public typealias Left = Actual.Right
        public typealias Right = ArchiveProfileRead.Right
    }
}

/// This decoder receives the old YZ fact and just the two newly acquired
/// X facts. The current source and its other two X cells are absent.
public enum MixedProfileFromFacts<F: HasVerdict & Structure,
    A: HasVerdict & Structure>: PredicateReading
where F.Sigma == BeamSpace, A.Sigma == BeamSpace,
      F.Encoding == SaturationEncoding, A.Encoding == SaturationEncoding,
      F.Answer: Pair, F.Answer.Left: Pair, F.Answer.Right: Structure,
      F.Answer.Left.Right: Structure, A.Answer: Structure {
    public typealias Values = PairedApplication<ReadRecordedAnswer<F>,
        ReadRecordedAnswer<A>>
    public typealias V = Values.Answer
    public typealias Old = FirstEvidenceImage<V, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Z = SequentialReading<Old, SecondEvidenceImage<V.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Y = SequentialReading<Old, FirstEvidenceImage<V.Left, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias RemainingY = SequentialReading<Y, SecondEvidenceImage<V.Left.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias NewX = SecondEvidenceImage<V, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Actual = SequentialReading<Values, JointEvidence<Z, JointEvidence<NewX, RemainingY>>>
    public typealias Left = Values.Left
    public typealias Right = Paired<F.Answer.Right, Paired<A.Answer, F.Answer.Left.Right>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = ProfileMixedSupportQuestion
    public typealias Answer = Right
    public enum Endpoint: Null {
        public typealias Left = Actual.Answer
        public typealias Right = MixedProfileFromFacts.Answer
    }
}

/// Reassemble XZ from the four actual X facts and the retained Z fields.
public enum RenewedProfileFromFacts<F: HasVerdict & Structure,
    A: HasVerdict & Structure, B: HasVerdict & Structure>: PredicateReading
where F.Sigma == BeamSpace, A.Sigma == BeamSpace, B.Sigma == BeamSpace,
      F.Encoding == SaturationEncoding, A.Encoding == SaturationEncoding,
      B.Encoding == SaturationEncoding,
      F.Answer: Pair, F.Answer.Left: Structure, F.Answer.Right: Structure,
      A.Answer: Structure, B.Answer: Structure {
    public typealias Values = PairedApplication<ReadRecordedAnswer<F>,
        PairedApplication<ReadRecordedAnswer<A>, ReadRecordedAnswer<B>>>
    public typealias V = Values.Answer
    public typealias Old = FirstEvidenceImage<V, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Z = SequentialReading<Old, SecondEvidenceImage<V.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias X = SecondEvidenceImage<V, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Actual = SequentialReading<Values, JointEvidence<X, Z>>
    public typealias Left = Values.Left
    public typealias Right = Paired<Paired<A.Answer, B.Answer>, F.Answer.Right>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = ProfileXZSupportQuestion
    public typealias Answer = Right
    public enum Endpoint: Null {
        public typealias Left = Actual.Answer
        public typealias Right = RenewedProfileFromFacts.Answer
    }
}

/// Generic live acquisition, with intermediate applicability and a real
/// exchange of the retired column. Contrast admission is the separate
/// finite calibration below; factorization alone is not that contrast.
public enum AcquireRenewedProfile<A0: Structure, A1: Structure, A2: Structure, A3: Structure,
    B0: Structure, B1: Structure, B2: Structure, B3: Structure,
    C0: Structure, C1: Structure, C2: Structure, C3: Structure, H: Structure>: Close {
    public typealias X = BoundaryWorking<A0, A1, A2, A3>
    public typealias Y = BoundaryWorking<B0, B1, B2, B3>
    public typealias Z = BoundaryWorking<C0, C1, C2, C3>
    public typealias Table = AddressTriple<X, Y, Z>
    public typealias V = RenewalColumns<Table>
    public typealias Root = Paired<Table, H>
    public typealias Old = ArchiveProfileRead<Root, V.YZ>
    public typealias A = ArchiveProfileRead<Old.Right, V.FirstXPair>
    public typealias FirstPair = FollowedPair<Old, A>
    public typealias FirstExchange = StepBeside<V.FlipYFirst, A.Right.Right>
    public typealias ChangedFirstPair = FollowedPair<FirstPair, FirstExchange>
    public typealias FirstTable = AddressTriple<X, BoundaryWorking<B1, B0, B2, B3>, Z>
    public typealias FirstRoot = Paired<FirstTable, A.Right.Right>
    public typealias FirstViews = RenewalColumns<FirstTable>
    public typealias B = ArchiveProfileRead<FirstRoot, FirstViews.SecondXPair>
    public typealias Acquired = FollowedPair<ChangedFirstPair, B>
    public typealias Shift = StepBeside<FirstViews.FlipYSecond, B.Right.Right>
    public typealias Actual = FollowedPair<Acquired, Shift>
    public typealias OldFact = Old.Right.Right.Right
    public typealias AF = A.Right.Right.Right
    public typealias BF = B.Right.Right.Right
    public typealias M = A.Right.Right
    public typealias MOld = ReadFirstProfileSource<M,
        SecondEvidenceImage<M.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias MA = SecondEvidenceImage<M, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias MFields = JointEvidence<MOld, MA>
    public enum MixedFactors: ReadingFactors {
        public typealias Left = ReadFirstProfileSource<FirstRoot, FirstViews.Mixed>
        public typealias Observation = SequentialReading<
            SecondEvidenceImage<FirstRoot, BeamSpace, SaturationEncoding, SecondProjection>, MFields>
        public typealias Right = MixedProfileFromFacts<OldFact, AF>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = ProfileMixedSupportQuestion
        public typealias Answer = Left.Answer
    }

    public typealias N = B.Right.Right
    public typealias NOld = ReadFirstProfileSource<N, ReadFirstProfileSource<N.Left,
        SecondEvidenceImage<N.Left.Left, BeamSpace, SaturationEncoding, SecondProjection>>>
    public typealias NA = ReadFirstProfileSource<N, SecondEvidenceImage<N.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias NB = SecondEvidenceImage<N, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias NFields = JointEvidence<NOld, JointEvidence<NA, NB>>
    public typealias New = RenewalColumns<AddressTriple<X, BoundaryWorking<B1, B0, B3, B2>, Z>>
    public enum AfterExchangeFactors: ReadingFactors {
        public typealias Left = ReadFirstProfileSource<Actual.Right, New.XZ>
        public typealias Observation = SequentialReading<
            SecondEvidenceImage<Actual.Right, BeamSpace, SaturationEncoding, SecondProjection>, NFields>
        public typealias Right = RenewedProfileFromFacts<OldFact, AF, BF>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = ProfileXZSupportQuestion
        public typealias Answer = Left.Answer
    }
    public enum Endpoints: Null {
        public typealias Left = Paired<Actual.Left, Actual.Right>
        public typealias Right = Paired<Root, Paired<V.FlipY.Answer, N>>
    }
    /// If the second acquired pair fails its contrast, undo the first
    /// exchange. Every newly acquired fact stays in the same archive.
    public typealias UndoFirst = StepBeside<FirstViews.FlipYFirst, N>
    public typealias Rollback = FollowedPair<Acquired, UndoFirst>
    public typealias RolledRoot = Paired<Table, N>
    public enum RollbackEndpoint: Null {
        public typealias Left = Rollback.Right
        public typealias Right = RolledRoot
    }
    public enum RollbackSupportFactors: ReadingFactors {
        public typealias Left = ReadFirstProfileSource<RolledRoot, V.YZ>
        public typealias Observation = SequentialReading<
            SecondEvidenceImage<RolledRoot, BeamSpace, SaturationEncoding, SecondProjection>, NOld>
        public typealias Right = ReadRecordedAnswer<OldFact>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = Left.Predicate
        public typealias Answer = Left.Answer
    }
}
