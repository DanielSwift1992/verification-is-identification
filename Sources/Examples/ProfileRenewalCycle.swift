import VerificationIsIdentification

/// Zip two actual four-cell columns into four row keys. This is a
/// coordinate reading, not an assertion that those keys are distinct.
public enum ProfilePairRows<A: Pair, B: Pair>: PredicateReading
where A.Left: Pair, A.Right: Pair, B.Left: Pair, B.Right: Pair,
      A.Left.Left: Structure, A.Left.Right: Structure, A.Right.Left: Structure, A.Right.Right: Structure,
      B.Left.Left: Structure, B.Left.Right: Structure, B.Right.Left: Structure, B.Right.Right: Structure {
    public typealias P = FourProfileCells<A>
    public typealias Q = FourProfileCells<B>
    public typealias Actual = JointEvidence<
        JointEvidence<PairedApplication<P.A, Q.A>, PairedApplication<P.B, Q.B>>,
        JointEvidence<PairedApplication<P.C0, Q.C0>, PairedApplication<P.D, Q.D>>>
    public typealias Left = Paired<A, B>
    public typealias Right = BoundaryWorking<Paired<A.Left.Left, B.Left.Left>,
        Paired<A.Left.Right, B.Left.Right>, Paired<A.Right.Left, B.Right.Left>,
        Paired<A.Right.Right, B.Right.Right>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
    public enum Endpoint: Null {
        public typealias Left = Actual.Answer
        public typealias Right = ProfilePairRows.Answer
    }
}

/// Fixed resident row permutation [0,3,1,2]. It regroups the rows by the
/// next common coordinate and uses every input field exactly once.
public enum TurnProfileRows<C: Pair>: PredicateReading
where C.Left: Pair, C.Right: Pair,
      C.Left.Left: Structure, C.Left.Right: Structure,
      C.Right.Left: Structure, C.Right.Right: Structure {
    public typealias Cells = FourProfileCells<C>
    public typealias Actual = JointEvidence<JointEvidence<Cells.A, Cells.D>,
        JointEvidence<Cells.B, Cells.C0>>
    public typealias Left = C
    public typealias Right = BoundaryWorking<C.Left.Left, C.Right.Right, C.Left.Right, C.Right.Left>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
    public enum Endpoint: Null {
        public typealias Left = Actual.Answer
        public typealias Right = TurnProfileRows.Answer
    }
}

/// Move (X,Y,Z) to (turn Y,turn Z,turn X). This is an explicit
/// reversible rearrangement, not an implicit change of source names.
public enum TurnProfileRoles<X: Pair, Y: Pair, Z: Pair>: PredicateReading
where X.Left: Pair, X.Right: Pair, Y.Left: Pair, Y.Right: Pair, Z.Left: Pair, Z.Right: Pair,
      X.Left.Left: Structure, X.Left.Right: Structure, X.Right.Left: Structure, X.Right.Right: Structure,
      Y.Left.Left: Structure, Y.Left.Right: Structure, Y.Right.Left: Structure, Y.Right.Right: Structure,
      Z.Left.Left: Structure, Z.Left.Right: Structure, Z.Right.Left: Structure, Z.Right.Right: Structure {
    public typealias Left = AddressTriple<X, Y, Z>
    public typealias V = RenewalColumns<Left>
    public typealias RX = SequentialReading<V.X, TurnProfileRows<X>>
    public typealias RY = SequentialReading<V.Y, TurnProfileRows<Y>>
    public typealias RZ = SequentialReading<V.Z, TurnProfileRows<Z>>
    public typealias Actual = JointEvidence<RY, JointEvidence<RZ, RX>>
    public typealias Right = AddressTriple<TurnProfileRows<Y>.Answer,
        TurnProfileRows<Z>.Answer, TurnProfileRows<X>.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
    public enum Endpoint: Null {
        public typealias Left = Actual.Answer
        public typealias Right = TurnProfileRoles.Answer
    }
}

/// Independent coordinate alphabets. Distinction needs A!=B, C!=D,
/// E!=F; the field identities below do not assume or manufacture that.
public enum RenewableProfileFrame<A: Structure, B: Structure,
    C: Structure, D: Structure, E: Structure, F: Structure>: Close {
    public typealias X = BoundaryWorking<A, B, B, A>
    public typealias Y = BoundaryWorking<C, D, C, D>
    public typealias Z = BoundaryWorking<E, E, F, F>
    public typealias Table = AddressTriple<X, Y, Z>
    public typealias Views = RenewalColumns<Table>
    public typealias ChangedY = BoundaryWorking<D, C, D, C>
    public typealias Turn = TurnProfileRoles<X, ChangedY, Z>
    public typealias Move = SequentialReading<Views.FlipY, Turn>
    public typealias Next = RenewableProfileFrame<D, C, E, F, A, B>
    public enum ReproducesPreparation: Null {
        public typealias Left = Move.Answer
        public typealias Right = Next.Table
    }
    public enum ThreeGrids: Null {
        public typealias Left = AddressTriple<ProfilePairRows<Y, Z>.Answer,
            ProfilePairRows<X, Z>.Answer, ProfilePairRows<X, Y>.Answer>
        public typealias Right = AddressTriple<
            BoundaryWorking<Paired<C, E>, Paired<D, E>, Paired<C, F>, Paired<D, F>>,
            BoundaryWorking<Paired<A, E>, Paired<B, E>, Paired<B, F>, Paired<A, F>>,
            BoundaryWorking<Paired<A, C>, Paired<B, D>, Paired<B, C>, Paired<A, D>>>
    }
    public typealias Second = Next.Move
    public typealias Third = RenewableProfileFrame<F, E, A, B, D, C>.Move
    public typealias Round = SequentialReading<Move, SequentialReading<Second, Third>>
    public typealias Opposite = RenewableProfileFrame<B, A, D, C, F, E>
    public enum EveryColumnChangesPolarity: Null {
        public typealias Left = Round.Answer
        public typealias Right = Opposite.Table
    }
}

/// Six repetitions restore the finite device fields. Appended acquisition
/// history is not returned or discarded by this device-word identity.
public enum RenewableProfileDeviceReturn<A: Structure, B: Structure,
    C: Structure, D: Structure, E: Structure, F: Structure>: Null {
    public typealias R = RenewableProfileFrame<A, B, C, D, E, F>
    public typealias Actual = SequentialReading<R.Round, R.Opposite.Round>
    public typealias Left = Actual.Answer
    public typealias Right = R.Table
}

/// The first half has switched from Y to X; the second still uses Y.
/// Both directions of the acquired first-pair contrast have a complete
/// lookup. U,V (unread X cells) never enter its keys or its payload table.
public enum MixedProfileAccess<P: Pair, U: Structure, V: Structure,
    M: Structure, N: Structure>: Close
where P.Left: Pair, P.Right: Pair,
      P.Left.Left: Structure, P.Left.Right: Structure,
      P.Right.Left: Structure, P.Right.Right: Structure {
    public typealias Y = BoundaryWorking<M, N, Never, Lit1>
    public typealias Z = BoundaryWorking<Never, Never, Lit1, Lit1>
    public typealias Forward = RenewalColumns<AddressTriple<BoundaryWorking<Never, Lit1, U, V>, Y, Z>>
    public typealias Reverse = RenewalColumns<AddressTriple<BoundaryWorking<Lit1, Never, U, V>, Y, Z>>
    public typealias FK = ProfilePairRows<Forward.Mixed.Answer.Left,
        Paired<Forward.Mixed.Answer.Right.Left, Forward.Mixed.Answer.Right.Right>>
    public typealias RK = ProfilePairRows<Reverse.Mixed.Answer.Left,
        Paired<Reverse.Mixed.Answer.Right.Left, Reverse.Mixed.Answer.Right.Right>>
    public typealias Reindex = PairedApplication<SwapBoundaryReading<P.Left>,
        IdentityReading<P.Right, BeamSpace, SaturationEncoding>>
    public typealias RP = Reindex.Answer
    public enum ForwardInputs: Null {
        public typealias Left = BoundaryWorking<Paired<FK.Answer.Left.Left, P>, Paired<FK.Answer.Left.Right, P>,
            Paired<FK.Answer.Right.Left, P>, Paired<FK.Answer.Right.Right, P>>
        public typealias Right = BoundaryWorking<Route00<P>.Left, Route01<P>.Left, Route10<P>.Left, Route11<P>.Left>
    }
    public enum ReverseInputs: Null {
        public typealias Left = BoundaryWorking<Paired<RK.Answer.Left.Left, RP>, Paired<RK.Answer.Left.Right, RP>,
            Paired<RK.Answer.Right.Left, RP>, Paired<RK.Answer.Right.Right, RP>>
        public typealias Right = BoundaryWorking<Route01<RP>.Left, Route00<RP>.Left, Route10<RP>.Left, Route11<RP>.Left>
    }
    public enum BothLookupsReturnRows: Null {
        public typealias Left = Paired<BoundaryWorking<Route00<P>.Answer, Route01<P>.Answer, Route10<P>.Answer, Route11<P>.Answer>,
            BoundaryWorking<Route01<RP>.Answer, Route00<RP>.Answer, Route10<RP>.Answer, Route11<RP>.Answer>>
        public typealias Fields = BoundaryWorking<P.Left.Left, P.Left.Right, P.Right.Left, P.Right.Right>
        public typealias Right = Paired<Fields, Fields>
    }
}

/// Only the acquired facts enter the next-support decoder. The turn sends
/// the old XZ support to (turn Z,turn X), the next frame's YZ support.
public enum TurnedProfileFromFacts<F: HasVerdict & Structure,
    A: HasVerdict & Structure, B: HasVerdict & Structure>: PredicateReading
where F.Sigma == BeamSpace, A.Sigma == BeamSpace, B.Sigma == BeamSpace,
      F.Encoding == SaturationEncoding, A.Encoding == SaturationEncoding, B.Encoding == SaturationEncoding,
      F.Answer: Pair, F.Answer.Left: Structure,
      F.Answer.Right: Pair, F.Answer.Right.Left: Pair, F.Answer.Right.Right: Pair,
      F.Answer.Right.Left.Left: Structure, F.Answer.Right.Left.Right: Structure,
      F.Answer.Right.Right.Left: Structure, F.Answer.Right.Right.Right: Structure,
      A.Answer: Pair, B.Answer: Pair,
      A.Answer.Left: Structure, A.Answer.Right: Structure,
      B.Answer.Left: Structure, B.Answer.Right: Structure {
    public typealias Base = RenewedProfileFromFacts<F, A, B>
    public typealias Swap = SwapBoundaryReading<Base.Answer>
    public typealias Turn = PairedApplication<TurnProfileRows<Base.Answer.Right>, TurnProfileRows<Base.Answer.Left>>
    public typealias Actual = SequentialReading<Base, SequentialReading<Swap, Turn>>
    public typealias Left = Base.Left
    public typealias Right = Paired<TurnProfileRows<F.Answer.Right>.Answer,
        TurnProfileRows<Paired<A.Answer, B.Answer>>.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = OperationSequence<OperationSequence<SecondProjection, FirstProjection>,
        OperationSequence<SecondProjection, SecondProjection>>
    public typealias Answer = Right
    public enum Endpoint: Null {
        public typealias Left = Actual.Answer
        public typealias Right = TurnedProfileFromFacts.Answer
    }
}

/// One universally constructed renewal step. The same source family and
/// the next active support are both recovered at its actual endpoint.
/// Contrast admission uses the three distinguished coordinate pairs; no
/// final equality or next-support certificate is requested from the caller.
public enum RenewableProfileStep<A: Structure, B: Structure,
    C: Structure, D: Structure, E: Structure, F: Structure, H: Structure>: Close {
    public typealias Frame = RenewableProfileFrame<A, B, C, D, E, F>
    public typealias Read = AcquireRenewedProfile<A, B, B, A, C, D, C, D, E, E, F, F, H>
    public typealias Turn = StepBeside<Frame.Turn, Read.N>
    public typealias Actual = FollowedPair<Read.Actual, Turn>
    public typealias NextRoot = Paired<Frame.Next.Table, Read.N>
    public enum Endpoint: Null {
        public typealias Left = Paired<Actual.Left, Actual.Right>
        public typealias Right = Paired<Paired<Frame.Table, H>, NextRoot>
    }
    /// The joint orientation is present in the newly acquired records.
    /// It is stronger than two separate successful within-block contrasts.
    public enum RecordedCrossAgreement: Null {
        public typealias Left = Read.AF.Answer
        public typealias Right = SwapBoundaryReading<Read.BF.Answer>.Answer
    }
    public enum NextSupportFactors: ReadingFactors {
        public typealias Left = ReadFirstProfileSource<NextRoot, Frame.Next.Views.YZ>
        public typealias Observation = SequentialReading<
            SecondEvidenceImage<NextRoot, BeamSpace, SaturationEncoding, SecondProjection>, Read.NFields>
        public typealias Right = TurnedProfileFromFacts<Read.OldFact, Read.AF, Read.BF>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = Left.Predicate
        public typealias Answer = Left.Answer
    }
}

/// A preserved present YZ answer does not decide whether XZ will address
/// the rows. In Bad, the new X coordinate repeats Z within both blocks.
public enum RenewalAccessCanDisappear: Close {
    public typealias Good = RenewableProfileFrame<Never, Lit1, Never, Lit1, Never, Lit1>
    public typealias Bad = RenewalColumns<AddressTriple<Good.Z, Good.Y, Good.Z>>
    public typealias BadKeys = ProfilePairRows<Good.Z, Good.Z>
    public enum SamePresentSupport: Null {
        public typealias Left = Good.Views.YZ.Answer
        public typealias Right = Bad.YZ.Answer
    }
    public enum FutureKeysMerge: Null {
        public typealias Left = Paired<BadKeys.Answer.Left.Left, BadKeys.Answer.Right.Left>
        public typealias Right = Paired<BadKeys.Answer.Left.Right, BadKeys.Answer.Right.Right>
    }
    /// The one-cell premature handover has the same eight observed values
    /// at the good table and a table whose first two complete profiles merge.
    public typealias BadEarlyX = BoundaryWorking<Never, Never, Lit1, Never>
    public typealias BadEarlyY = BoundaryWorking<Lit1, Lit1, Never, Lit1>
    public enum SamePrematureSupport: Null {
        public typealias Left = Paired<Good.Z, BoundaryWorking<Good.X.Left.Left,
            Good.Y.Left.Right, Good.Y.Right.Left, Good.Y.Right.Right>>
        public typealias Right = Paired<Good.Z, BoundaryWorking<BadEarlyX.Left.Left,
            BadEarlyY.Left.Right, BadEarlyY.Right.Left, BadEarlyY.Right.Right>>
    }
    public enum PrematureRowsMerge: Null {
        public typealias Left = AddressTriple<BadEarlyX.Left.Left, BadEarlyY.Left.Left, Good.Z.Left.Left>
        public typealias Right = AddressTriple<BadEarlyX.Left.Right, BadEarlyY.Left.Right, Good.Z.Left.Right>
    }
    /// X=Y has two successful local contrasts and permits the first XZ
    /// handover. After flipping Y, X and Y still fail to address all rows.
    public typealias OneHandover = RenewalColumns<AddressTriple<Good.Y, Good.Y, Good.Z>>
    public typealias Later = RenewalColumns<OneHandover.FlipY.Answer>
    public typealias NextKeys = ProfilePairRows<Later.X.Answer, Later.Y.Answer>
    public enum CurrentPairsStillContrast: Null {
        public typealias Left = OneHandover.X.Answer
        public typealias Right = Paired<RoutingAddress01, RoutingAddress01>
    }
    public enum NextPairsMerge: Null {
        public typealias Left = NextKeys.Answer.Left
        public typealias Right = NextKeys.Answer.Right
    }
}

/// The other row regrouping [0,2,1,3], selected in the aligned branch.
public enum TransposeProfileRows<C: Pair>: PredicateReading
where C.Left: Pair, C.Right: Pair,
      C.Left.Left: Structure, C.Left.Right: Structure,
      C.Right.Left: Structure, C.Right.Right: Structure {
    public typealias Cells = FourProfileCells<C>
    public typealias Actual = JointEvidence<JointEvidence<Cells.A, Cells.C0>,
        JointEvidence<Cells.B, Cells.D>>
    public typealias Left = C
    public typealias Right = BoundaryWorking<C.Left.Left, C.Right.Left, C.Left.Right, C.Right.Right>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
    public enum Endpoint: Null {
        public typealias Left = Actual.Answer
        public typealias Right = TransposeProfileRows.Answer
    }
}

/// After changing only the first Y pair, aligned X blocks can enter the
/// same recurrent family. No second Y exchange is made in this branch.
public enum TurnAlignedProfile<A: Structure, B: Structure, C: Structure,
    D: Structure, E: Structure, F: Structure>: PredicateReading {
    public typealias X = BoundaryWorking<A, B, A, B>
    public typealias Y = BoundaryWorking<D, C, C, D>
    public typealias Z = BoundaryWorking<E, E, F, F>
    public typealias Left = AddressTriple<X, Y, Z>
    public typealias V = RenewalColumns<Left>
    public typealias RX = SequentialReading<V.X, TransposeProfileRows<X>>
    public typealias RY = SequentialReading<V.Y, TransposeProfileRows<Y>>
    public typealias RZ = SequentialReading<V.Z, TransposeProfileRows<Z>>
    public typealias Actual = JointEvidence<RY, JointEvidence<RZ, RX>>
    public typealias Right = AddressTriple<BoundaryWorking<D, C, C, D>,
        BoundaryWorking<E, F, E, F>, BoundaryWorking<A, A, B, B>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
    public enum Endpoint: Null {
        public typealias Left = Actual.Answer
        public typealias Right = TurnAlignedProfile.Answer
    }
}

public enum AlignedProfileEntry<A: Structure, B: Structure, C: Structure,
    D: Structure, E: Structure, F: Structure, H: Structure>: Close {
    public typealias Read = AcquireRenewedProfile<A, B, A, B, C, D, C, D, E, E, F, F, H>
    public typealias Turn = StepBeside<TurnAlignedProfile<A, B, C, D, E, F>, Read.N>
    public typealias Actual = FollowedPair<Read.Acquired, Turn>
    public typealias Next = RenewableProfileFrame<D, C, E, F, A, B>
    public enum Endpoint: Null {
        public typealias Left = Actual.Right
        public typealias Right = Paired<Next.Table, Read.N>
    }
    public enum RecordedAlignment: Null {
        public typealias Left = Read.AF.Answer
        public typealias Right = Read.BF.Answer
    }
    public enum NextSupportFromRecords: Null {
        public typealias OldZ = ReadRecordedAnswer<Read.OldFact>.Answer.Right
        public typealias NewX = Paired<ReadRecordedAnswer<Read.AF>.Answer, ReadRecordedAnswer<Read.BF>.Answer>
        public typealias Left = Paired<Read.NFields.Answer,
            Paired<TransposeProfileRows<OldZ>.Answer, TransposeProfileRows<NewX>.Answer>>
        public typealias Right = Paired<Paired<Read.OldFact, Paired<Read.AF, Read.BF>>, Next.Views.YZ.Answer>
    }
}

/// Normalization merges the device images of the two entry branches.
/// Their archive prefixes agree, but their final acquired pairs are AB
/// and BA. The complete output therefore still separates the branches
/// whenever A and B are distinguished.
public enum NormalizedRenewalRetainsOrientation<A: Structure, B: Structure,
    C: Structure, D: Structure, E: Structure, F: Structure, H: Structure>: Null {
    public typealias O = RenewableProfileStep<A, B, C, D, E, F, H>
    public typealias L = AlignedProfileEntry<A, B, C, D, E, F, H>
    public typealias Left = AddressTriple<Paired<O.Actual.Right.Left, L.Actual.Right.Left>,
        Paired<O.Read.N.Left, L.Read.N.Left>, Paired<O.Read.BF.Answer, L.Read.BF.Answer>>
    public typealias Right = AddressTriple<Paired<O.Frame.Next.Table, O.Frame.Next.Table>,
        Paired<O.Read.N.Left, O.Read.N.Left>, Paired<Paired<B, A>, Paired<A, B>>>
}
