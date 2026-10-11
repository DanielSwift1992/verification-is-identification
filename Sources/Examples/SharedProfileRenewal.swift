import VerificationIsIdentification

/// These two readings exchange addressed values, not their names. Every
/// field is retained once; they apply to arbitrary structural contents.
public typealias ExchangeFirstProfilePair<C: Pair> = PairedApplication<
    SwapBoundaryReading<C.Left>, IdentityReading<C.Right, BeamSpace, SaturationEncoding>>
where C.Left: Pair, C.Left.Left: Structure, C.Left.Right: Structure, C.Right: Structure

public typealias ExchangeSecondProfilePair<C: Pair> = PairedApplication<
    IdentityReading<C.Left, BeamSpace, SaturationEncoding>, SwapBoundaryReading<C.Right>>
where C.Right: Pair, C.Right.Left: Structure, C.Right.Right: Structure, C.Left: Structure

/// Two participants modify different columns of one retained source.
/// Disjoint writes commute. This says nothing by itself about the other
/// participant's old chart or about release of the common Z coordinate.
public enum SharedProfileChanges<A: Structure, B: Structure, C: Structure, D: Structure,
    E: Structure, F: Structure, G: Structure, H: Structure,
    I: Structure, J: Structure, K: Structure, L: Structure>: Close {
    public typealias X = BoundaryWorking<A, B, C, D>
    public typealias Y = BoundaryWorking<E, F, G, H>
    public typealias Z = BoundaryWorking<I, J, K, L>
    public typealias Table = AddressTriple<X, Y, Z>
    public typealias V = RenewalColumns<Table>
    public typealias XFirst = PairedApplication<ExchangeFirstProfilePair<X>,
        IdentityReading<Paired<Y, Z>, BeamSpace, SaturationEncoding>>
    public typealias XSecond = PairedApplication<ExchangeSecondProfilePair<X>,
        IdentityReading<Paired<Y, Z>, BeamSpace, SaturationEncoding>>
    public typealias YFirst = V.FlipYFirst
    public typealias YSecond = V.FlipYSecond
    public typealias AfterX = AddressTriple<BoundaryWorking<B, A, C, D>, Y, Z>
    public typealias AfterY = AddressTriple<X, BoundaryWorking<F, E, G, H>, Z>
    public typealias AfterXViews = RenewalColumns<AfterX>
    public typealias AfterYChanges = SharedProfileChanges<A, B, C, D, F, E, G, H, I, J, K, L>
    public typealias XY = SequentialReading<XFirst, AfterXViews.FlipYFirst>
    public typealias YX = SequentialReading<YFirst, AfterYChanges.XFirst>
    public typealias Cross = SequentialReading<XFirst, AfterXViews.FlipYSecond>
    public typealias BothX = PairedApplication<
        PairedApplication<SwapBoundaryReading<X.Left>, SwapBoundaryReading<X.Right>>,
        IdentityReading<Paired<Y, Z>, BeamSpace, SaturationEncoding>>
    public typealias Both = AddressTriple<BoundaryWorking<B, A, C, D>, BoundaryWorking<F, E, G, H>, Z>
    public enum CommutingWrites: Null {
        public typealias Left = Paired<XY.Answer, YX.Answer>
        public typealias Right = Paired<Both, Both>
    }
    public enum OtherCurrentChartIsFixed: Null {
        public typealias Left = Paired<AfterXViews.YZ.Answer, RenewalColumns<AfterY>.XZ.Answer>
        public typealias Right = Paired<V.YZ.Answer, V.XZ.Answer>
    }
    public enum EachWriteReturns: Null {
        public typealias XX = SequentialReading<XFirst,
            SharedProfileChanges<B, A, C, D, E, F, G, H, I, J, K, L>.XFirst>
        public typealias YY = SequentialReading<YFirst, AfterYChanges.YFirst>
        public typealias Left = Paired<XX.Answer, YY.Answer>
        public typealias Right = Paired<Table, Table>
    }
}

/// Repair a chart through a known first-pair exchange. The only input is
/// its acquired fact. The changed source and the other chart are absent.
public enum ExchangedChartFromFact<F: HasVerdict & Structure>: PredicateReading
where F.Sigma == BeamSpace, F.Encoding == SaturationEncoding,
      F.Answer: Pair, F.Answer.Left: Pair, F.Answer.Left.Left: Pair,
      F.Answer.Left.Left.Left: Structure, F.Answer.Left.Left.Right: Structure,
      F.Answer.Left.Right: Structure, F.Answer.Right: Structure {
    public typealias Column = FirstEvidenceImage<F.Answer, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Common = SecondEvidenceImage<F.Answer, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias First = SequentialReading<Column,
        FirstEvidenceImage<F.Answer.Left, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Second = SequentialReading<Column,
        SecondEvidenceImage<F.Answer.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias ChangedFirst = SequentialReading<First, SwapBoundaryReading<F.Answer.Left.Left>>
    public typealias Change = JointEvidence<JointEvidence<ChangedFirst, Second>, Common>
    public typealias Actual = SequentialReading<ReadRecordedAnswer<F>, Change>
    public typealias Left = F
    public typealias Right = Paired<Paired<Paired<F.Answer.Left.Left.Right,
        F.Answer.Left.Left.Left>, F.Answer.Left.Right>, F.Answer.Right>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = F.Predicate
    public typealias Answer = Right
    public enum Endpoint: Null {
        public typealias Left = Actual.Answer
        public typealias Right = ExchangedChartFromFact.Answer
    }
}

/// Actual acquisitions and two actual shared-source changes. Both old
/// records survive, but each current chart uses its own transported reading.
/// This proves the supplied fixed word, not delivery of an unknown command.
public enum SharedProfileChangeRecords<A: Structure, B: Structure, C: Structure, D: Structure,
    E: Structure, F: Structure, G: Structure, H: Structure,
    I: Structure, J: Structure, K: Structure, L: Structure, History: Structure>: Close {
    public typealias S = SharedProfileChanges<A, B, C, D, E, F, G, H, I, J, K, L>
    public typealias Root = Paired<S.Table, History>
    public typealias YRecord = ArchiveProfileRead<Root, S.V.YZ>
    public typealias XRecord = ArchiveProfileRead<YRecord.Right, S.V.XZ>
    public typealias Acquired = FollowedPair<YRecord, XRecord>
    public typealias FY = YRecord.Right.Right.Right
    public typealias FX = XRecord.Right.Right.Right
    public typealias N = XRecord.Right.Right
    public typealias XStep = StepBeside<S.XFirst, N>
    public typealias AfterX = FollowedPair<Acquired, XStep>
    public typealias YStep = StepBeside<S.AfterXViews.FlipYFirst, N>
    public typealias Actual = FollowedPair<AfterX, YStep>
    public typealias Current = Paired<S.Both, N>
    public typealias V = RenewalColumns<S.Both>
    public typealias Saved = SecondEvidenceImage<Current, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias XF = SequentialReading<Saved,
        SecondEvidenceImage<N, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias YF = SequentialReading<Saved, ReadFirstProfileSource<N,
        SecondEvidenceImage<N.Left, BeamSpace, SaturationEncoding, SecondProjection>>>
    public enum Endpoint: Null {
        public typealias Left = Actual.Right
        public typealias Right = Current
    }
    public enum CurrentXFromItsOwnFact: ReadingFactors {
        public typealias Left = ReadFirstProfileSource<Current, V.XZ>
        public typealias Observation = XF
        public typealias Right = ExchangedChartFromFact<FX>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = Left.Predicate
        public typealias Answer = Left.Answer
    }
    public enum CurrentYFromItsOwnFact: ReadingFactors {
        public typealias Left = ReadFirstProfileSource<Current, V.YZ>
        public typealias Observation = YF
        public typealias Right = ExchangedChartFromFact<FY>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = Left.Predicate
        public typealias Answer = Left.Answer
    }
}

/// The three paired exchanges generate the eight even shared changes of
/// M64x. Their grid fields are derived, with no final-grid caller premise.
public enum SharedRenewalGrids<A: Structure, B: Structure,
    C: Structure, D: Structure, E: Structure, F: Structure>: Close {
    public typealias R = RenewableProfileFrame<A, B, C, D, E, F>
    public typealias S = SharedProfileChanges<A, B, B, A, C, D, C, D, E, E, F, F>
    public typealias Same = ProfilePairRows<S.Both.Left, S.Both.Right.Left>
    public typealias Cross = ProfilePairRows<S.Cross.Answer.Left, S.Cross.Answer.Right.Left>
    public typealias Double = ProfilePairRows<S.BothX.Answer.Left, R.Y>
    public enum ThreeCompleteGrids: Null {
        public typealias Left = AddressTriple<Same.Answer, Cross.Answer, Double.Answer>
        public typealias Right = AddressTriple<
            BoundaryWorking<Paired<B, D>, Paired<A, C>, Paired<B, C>, Paired<A, D>>,
            BoundaryWorking<Paired<B, C>, Paired<A, D>, Paired<B, D>, Paired<A, C>>,
            BoundaryWorking<Paired<B, C>, Paired<A, D>, Paired<A, C>, Paired<B, D>>>
    }
    public typealias Single = ProfilePairRows<S.AfterX.Left, R.Y>
    public enum OneChangeMergesTheFutureKeys: Null {
        public typealias Left = Paired<Single.Answer.Left, Single.Answer.Right>
        public typealias Right = Paired<Paired<Paired<B, C>, Paired<A, D>>,
            Paired<Paired<B, C>, Paired<A, D>>>
    }
    /// Both partner words are odd, hence agree for the release question.
    /// Their complete current Y charts nevertheless differ when C!=D.
    public typealias SameY = RenewalColumns<S.Both>.YZ
    public typealias CrossY = RenewalColumns<S.Cross.Answer>.YZ
    public enum DifferentTransportedChartFields: Null {
        public typealias Left = Paired<SameY.Answer.Left, CrossY.Answer.Left>
        public typealias Right = Paired<BoundaryWorking<D, C, C, D>, BoundaryWorking<C, D, D, C>>
    }
}

/// In the two-symbol scope, a fourth coordinate that is a rectangle with
/// both Y and Z must have this orientation or its reversal. Pairing it
/// with X then identifies rows 0/3 and 1/2. M64z proves the exhaustion.
public enum FourthProfileCoordinateObstruction<A: Structure, B: Structure,
    C: Structure, D: Structure>: Null {
    public typealias X = BoundaryWorking<A, B, B, A>
    public typealias Fourth = BoundaryWorking<C, D, D, C>
    public typealias Keys = ProfilePairRows<X, Fourth>
    public typealias Left = Keys.Answer
    public typealias Right = BoundaryWorking<Paired<A, C>, Paired<B, D>, Paired<B, D>, Paired<A, C>>
}

/// Both transported charts select the original row's arbitrary payload.
/// The keys come from the two fact-only decoders at the actual changed
/// source. The payload rearrangements are fixed by the performed exchanges.
public enum SharedProfileLookup<P: Pair, H: Structure>: Close
where P.Left: Pair, P.Right: Pair,
      P.Left.Left: Structure, P.Left.Right: Structure,
      P.Right.Left: Structure, P.Right.Right: Structure {
    public typealias R = SharedProfileChangeRecords<Never, Lit1, Lit1, Never,
        Never, Lit1, Never, Lit1, Never, Never, Lit1, Lit1, H>
    public typealias RecordedX = R.CurrentXFromItsOwnFact.Right.Answer
    public typealias RecordedY = R.CurrentYFromItsOwnFact.Right.Answer
    public typealias XK = ProfilePairRows<RecordedX.Right, RecordedX.Left>
    public typealias YK = ProfilePairRows<RecordedY.Right, RecordedY.Left>
    public typealias OldXPayload = PairedApplication<IdentityReading<P.Left, BeamSpace, SaturationEncoding>,
        SwapBoundaryReading<P.Right>>
    public typealias XPayload = ExchangeFirstProfilePair<OldXPayload.Answer>
    public typealias YPayload = ExchangeFirstProfilePair<P>
    public typealias XP = XPayload.Answer
    public typealias YP = YPayload.Answer
    public enum ActualXInputs: Null {
        public typealias Left = BoundaryWorking<Paired<XK.Answer.Left.Left, XP>,
            Paired<XK.Answer.Left.Right, XP>, Paired<XK.Answer.Right.Left, XP>, Paired<XK.Answer.Right.Right, XP>>
        public typealias Right = BoundaryWorking<Route01<XP>.Left, Route00<XP>.Left,
            Route11<XP>.Left, Route10<XP>.Left>
    }
    public enum ActualYInputs: Null {
        public typealias Left = BoundaryWorking<Paired<YK.Answer.Left.Left, YP>,
            Paired<YK.Answer.Left.Right, YP>, Paired<YK.Answer.Right.Left, YP>, Paired<YK.Answer.Right.Right, YP>>
        public typealias Right = BoundaryWorking<Route01<YP>.Left, Route00<YP>.Left,
            Route10<YP>.Left, Route11<YP>.Left>
    }
    public enum BothChartsReturnEveryRow: Null {
        public typealias Left = Paired<
            BoundaryWorking<Route01<XP>.Answer, Route00<XP>.Answer, Route11<XP>.Answer, Route10<XP>.Answer>,
            BoundaryWorking<Route01<YP>.Answer, Route00<YP>.Answer, Route10<YP>.Answer, Route11<YP>.Answer>>
        public typealias Fields = BoundaryWorking<P.Left.Left, P.Left.Right, P.Right.Left, P.Right.Right>
        public typealias Right = Paired<Fields, Fields>
    }
    /// This is the actual stale-table result for row 0's changed YZ key.
    /// It is not generally that row's payload even though the key is valid.
    public typealias StaleRowZero = Route01<P>
}
