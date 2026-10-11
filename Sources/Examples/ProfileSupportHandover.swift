import VerificationIsIdentification

public enum AlternateProfileSupportQuestion: Close {}
public enum ExchangeRetiredProfileCellQuestion: Close {}

/// The alternative nine-cell support: A1, B012, C012, D12.
/// A0 is absent; C1 replaces its role in separating A from C.
public enum AlternateContactProfileReadings<A: Pair, B: Pair, C: Pair, D: Pair>: PredicateReading
where A.Left: Pair, A.Left.Left: Pair, A.Right: Structure,
      A.Left.Right: Structure, A.Left.Left.Right: Structure,
      B.Left: Pair, B.Left.Left: Pair, B.Right: Structure,
      B.Left.Right: Structure, B.Left.Left.Right: Structure,
      C.Left: Pair, C.Left.Left: Pair, C.Right: Structure,
      C.Left.Right: Structure, C.Left.Left.Right: Structure,
      D.Left: Pair, D.Left.Left: Pair, D.Right: Structure,
      D.Left.Right: Structure, D.Left.Left.Right: Structure {
    public typealias D12 = JointEvidence<ContactProfile<D>.Q1, ContactProfile<D>.Q2>
    public typealias Actual = PairedApplication<
        PairedApplication<ContactProfile<A>.Q1, ContactProfile<B>>,
        PairedApplication<ContactProfile<C>, D12>>
    public typealias Left = BoundaryWorking<A, B, C, D>
    public typealias Right = BoundaryWorking<A.Left.Right, ContactProfile<B>.Answer,
        ContactProfile<C>.Answer, Paired<D.Left.Right, D.Left.Left.Right>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = AlternateProfileSupportQuestion
    public typealias Answer = Right
    public enum Endpoint: Null {
        public typealias Left = Paired<Actual.Left, Actual.Answer>
        public typealias Right = Paired<AlternateContactProfileReadings.Left, AlternateContactProfileReadings.Answer>
    }
}

/// One actual swap exchanges A0 with the supplied resident reserve. The
/// former A0 survives in that reserve; no literal replacement is fabricated.
public enum ExchangeRetiredProfileCell<W: Pair>: PredicateReading
where W.Left: Pair, W.Left.Left: Pair, W.Left.Left.Left: Pair,
      W.Left.Left.Left.Left: Structure, W.Left.Left.Left.Right: Structure,
      W.Left.Left.Right: Structure, W.Left.Right: Structure, W.Right: Structure {
    public typealias Table = FirstEvidenceImage<W, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Reserve = SecondEvidenceImage<W, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Low = SequentialReading<Table,
        FirstEvidenceImage<W.Left, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias High = SequentialReading<Table,
        SecondEvidenceImage<W.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias A = SequentialReading<Low,
        FirstEvidenceImage<W.Left.Left, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias B = SequentialReading<Low,
        SecondEvidenceImage<W.Left.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias ATail = SequentialReading<A,
        FirstEvidenceImage<W.Left.Left.Left, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias A0 = SequentialReading<A,
        SecondEvidenceImage<W.Left.Left.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias NewA = JointEvidence<ATail, Reserve>
    public typealias NewTable = JointEvidence<JointEvidence<NewA, B>, High>
    public typealias Actual = JointEvidence<NewTable, A0>
    public typealias Left = W
    public typealias Right = Paired<Paired<Paired<Paired<W.Left.Left.Left.Left, W.Right>,
        W.Left.Left.Right>, W.Left.Right>, W.Left.Left.Left.Right>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = ExchangeRetiredProfileCellQuestion
    public typealias Answer = Right
    public enum Endpoint: Null {
        public typealias Left = Actual.Answer
        public typealias Right = ExchangeRetiredProfileCell.Answer
    }
}

/// Repack the old nine-cell fact and one newly acquired C1. Only these two
/// facts enter; the discarded A0 remains in F but is absent from this image.
public enum RelayProfileSupport<F: HasVerdict & Structure, G: HasVerdict & Structure>: PredicateReading
where F.Sigma == BeamSpace, G.Sigma == BeamSpace,
      F.Encoding == SaturationEncoding, G.Encoding == SaturationEncoding,
      F.Answer: Pair, F.Answer.Left: Pair, F.Answer.Left.Left: Pair,
      F.Answer.Right: Pair, F.Answer.Right.Left: Pair,
      F.Answer.Left.Left.Right: Structure, F.Answer.Left.Right: Structure,
      F.Answer.Right.Left.Left: Structure, F.Answer.Right.Left.Right: Structure,
      F.Answer.Right.Right: Structure, G.Answer: Structure {
    public typealias Left = Paired<F, G>
    public typealias OldFact = FirstEvidenceImage<Left, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias NewFact = SecondEvidenceImage<Left, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Old = SequentialReading<OldFact, ReadRecordedAnswer<F>>
    public typealias C1 = SequentialReading<NewFact, ReadRecordedAnswer<G>>
    public typealias Low = SequentialReading<Old,
        FirstEvidenceImage<F.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias High = SequentialReading<Old,
        SecondEvidenceImage<F.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias A01 = SequentialReading<Low,
        FirstEvidenceImage<F.Answer.Left, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias A1 = SequentialReading<A01,
        SecondEvidenceImage<F.Answer.Left.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias B = SequentialReading<Low,
        SecondEvidenceImage<F.Answer.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias C02 = SequentialReading<High,
        FirstEvidenceImage<F.Answer.Right, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias C0 = SequentialReading<C02,
        FirstEvidenceImage<F.Answer.Right.Left, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias C2 = SequentialReading<C02,
        SecondEvidenceImage<F.Answer.Right.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias D = SequentialReading<High,
        SecondEvidenceImage<F.Answer.Right, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Actual = JointEvidence<JointEvidence<A1, B>,
        JointEvidence<JointEvidence<C0, JointEvidence<C1, C2>>, D>>
    public typealias Right = BoundaryWorking<F.Answer.Left.Left.Right, F.Answer.Left.Right,
        AddressTriple<F.Answer.Right.Left.Left, G.Answer, F.Answer.Right.Left.Right>, F.Answer.Right.Right>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = AlternateProfileSupportQuestion
    public typealias Answer = Right
    public enum Endpoint: Null {
        public typealias Left = Actual.Answer
        public typealias Right = RelayProfileSupport.Answer
    }
}

/// Only the source at the first field is read. The question is R's actual
/// question; naming it is backed by the projection/composition endpoint.
public enum ReadFirstProfileSource<W: Pair, R: PredicateReading>: PredicateReading
where W.Left == R.Left, R.Sigma == BeamSpace, R.Encoding == SaturationEncoding {
    public typealias Source = FirstEvidenceImage<W, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Actual = SequentialReading<Source, R>
    public typealias Left = W
    public typealias Right = R.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = R.Predicate
    public typealias Answer = Right
    public enum Endpoint: Null {
        public typealias Left = Actual.Answer
        public typealias Right = ReadFirstProfileSource.Answer
    }
}

/// Acquire C1 from the same retained source, then exchange the retired cell
/// with arbitrary resident V. The two facts survive. The new support is
/// their applicable reading; it needs no separate stored validity record.
public enum ProfileSupportHandover<X: Structure, Z: Structure,
    K: Structure, V: Structure>: Close {
    public typealias H = SparseContactProfileFamily<X, Never, Z, K>
    public typealias Images = BoundaryWorking<H.A, H.B, H.C, H.D>
    public typealias Root = Paired<Images, V>
    public typealias F = FactOf<H.Read>
    public typealias OldReading = ReadFirstProfileSource<Root, H.Read>
    public typealias OldRecord = RecordReading<OldReading>
    public typealias AfterOld = Paired<Root, F>
    public typealias High = SecondEvidenceImage<Images, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias C = SequentialReading<High,
        FirstEvidenceImage<Images.Right, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias C1 = SequentialReading<C, ContactProfile<H.C>.Q1>
    public typealias ExtraAtRoot = ReadFirstProfileSource<Root, C1>
    public typealias Extra = ReadFirstProfileSource<AfterOld, ExtraAtRoot>
    public typealias G = FactOf<Extra>
    public typealias ExtraRecord = RecordReading<Extra>
    public typealias Acquired = FollowedPair<OldRecord, ExtraRecord>
    public typealias AfterExtra = Paired<AfterOld, G>
    public typealias Relay = RelayProfileSupport<F, G>
    public typealias Exchange = ExchangeRetiredProfileCell<Root>
    public typealias Shift = StepBeside<StepBeside<Exchange, F>, G>
    public typealias Actual = FollowedPair<Acquired, Shift>
    public typealias UpdatedA = ContactProfileChain<V, Lit1, X, K>
    public typealias NewRoot = Paired<BoundaryWorking<UpdatedA, H.B, H.C, H.D>, Never>
    public typealias AfterShift = Paired<Paired<NewRoot, F>, G>
    public typealias NewReading = AlternateContactProfileReadings<UpdatedA, H.B, H.C, H.D>
    public typealias AtNewRoot = ReadFirstProfileSource<NewRoot, NewReading>
    public typealias CurrentReading = ReadFirstProfileSource<AfterShift,
        ReadFirstProfileSource<AfterShift.Left, AtNewRoot>>
    public typealias Earlier = FirstEvidenceImage<AfterShift, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias OldFact = SequentialReading<Earlier,
        SecondEvidenceImage<AfterShift.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias ExtraFact = SecondEvidenceImage<AfterShift, BeamSpace, SaturationEncoding, SecondProjection>
    public enum CompleteEndpoints: Null {
        public typealias Left = Paired<Actual.Left, Actual.Right>
        public typealias Right = Paired<Root, AfterShift>
    }
    public enum CurrentSupportFactors: ReadingFactors {
        public typealias Left = CurrentReading
        public typealias Observation = JointEvidence<OldFact, ExtraFact>
        public typealias Right = Relay
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = AlternateProfileSupportQuestion
        public typealias Answer = CurrentReading.Answer
    }
    /// AB, AC, AD, BC, BD, CD use the new nine-cell support. The
    /// exchanged A0 is absent even when V is neither of the two symbols.
    public enum SixCurrentSeparators: Null {
        public typealias Left = Paired<
            AddressTriple<Paired<UpdatedA.Left.Right, H.B.Left.Right>,
                Paired<UpdatedA.Left.Right, H.C.Left.Right>,
                Paired<UpdatedA.Left.Right, H.D.Left.Right>>,
            AddressTriple<Paired<H.B.Right, H.C.Right>,
                Paired<H.B.Left.Left.Right, H.D.Left.Left.Right>,
                Paired<H.C.Left.Left.Right, H.D.Left.Left.Right>>>
        public typealias Right = Paired<
            AddressTriple<RoutingAddress10, RoutingAddress10, RoutingAddress10>,
            AddressTriple<RoutingAddress01, RoutingAddress01, RoutingAddress01>>
    }
    public enum RetainedFacts: Null {
        public typealias Left = Paired<AfterShift.Left.Right, AfterShift.Right>
        public typealias Right = Paired<F, G>
    }
    public enum ChangedCellAndPreservedReserve: Null {
        public typealias Left = Paired<Exchange.Answer.Left.Left.Left.Right, Exchange.Answer.Right>
        public typealias Right = Paired<V, Never>
    }
    public enum FullSwapReturns: Null {
        public typealias Left = ExchangeRetiredProfileCell<Exchange.Answer>.Answer
        public typealias Right = Root
    }
}

/// The old support does not determine its replacement. Changing only the
/// previously unread C1 preserves the old fact; the same A0 swap can then
/// identify A with C. A new actual C1 acquisition separates these cases.
public enum MissingReplacementCanMerge<K: Structure>: Close {
    public typealias Good = SparseContactProfileFamily<Never, Never, Never, K>
    public typealias Other = SparseContactProfileFamily<Never, Lit1, Never, K>
    public typealias Swap = ExchangeRetiredProfileCell<Paired<Other.Read.Left, Lit1>>
    public enum SameOldFact: Null {
        public typealias Left = FactOf<Good.Read>
        public typealias Right = FactOf<Other.Read>
    }
    public enum ReplacementDiffers: Null {
        public typealias Left = Paired<ContactProfile<Good.C>.Q1.Answer,
            ContactProfile<Other.C>.Q1.Answer>
        public typealias Right = RoutingAddress01
    }
    public enum ActualMerger: Null {
        public typealias Left = Swap.Answer.Left.Left.Left
        public typealias Right = Swap.Answer.Left.Right.Left
    }
}
