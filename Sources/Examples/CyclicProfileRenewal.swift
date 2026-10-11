import VerificationIsIdentification

/// A cyclic reading of three actual addressed fields. This is a finite
/// permutation; the interpretation as addition modulo three is separate.
public enum CycleProfileTriple<T: Pair>: PredicateReading
where T.Right: Pair, T.Left: Structure, T.Right.Left: Structure, T.Right.Right: Structure {
    public typealias A = FirstEvidenceImage<T, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Rest = SecondEvidenceImage<T, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias B = SequentialReading<Rest,
        FirstEvidenceImage<T.Right, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias C = SequentialReading<Rest,
        SecondEvidenceImage<T.Right, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Actual = JointEvidence<B, JointEvidence<C, A>>
    public typealias Left = T
    public typealias Right = AddressTriple<T.Right.Left, T.Right.Right, T.Left>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
    public enum Endpoint: Null {
        public typealias Left = Actual.Answer
        public typealias Right = CycleProfileTriple.Answer
    }
}

public typealias CycleProfileTripleTwice<T: Pair> = SequentialReading<
    CycleProfileTriple<T>, CycleProfileTriple<CycleProfileTriple<T>.Answer>>
where T.Right: Pair, T.Left: Structure, T.Right.Left: Structure, T.Right.Right: Structure

/// On the three Z fibers, retain the first triple, rotate the second
/// once and the third twice. No candidate search or arithmetic runs here.
public enum CyclicProfileChange<A: Pair, B: Pair, C: Pair>: PredicateReading
where A: Structure, B.Right: Pair, C.Right: Pair,
      B.Left: Structure, B.Right.Left: Structure, B.Right.Right: Structure,
      C.Left: Structure, C.Right.Left: Structure, C.Right.Right: Structure {
    public typealias Actual = PairedApplication<IdentityReading<A, BeamSpace, SaturationEncoding>,
        PairedApplication<CycleProfileTriple<B>, CycleProfileTripleTwice<C>>>
    public typealias Left = AddressTriple<A, B, C>
    public typealias Right = AddressTriple<A, AddressTriple<B.Right.Left, B.Right.Right, B.Left>,
        AddressTriple<C.Right.Right, C.Left, C.Right.Left>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
    public enum Endpoint: Null {
        public typealias Left = Actual.Answer
        public typealias Right = CyclicProfileChange.Answer
    }
}

/// Zip actual three-cell columns. The construction claims only these
/// keys; distinction of the interpreted alphabet is established separately.
public enum TripleProfileKeys<X: Pair, Y: Pair>: PredicateReading
where X.Right: Pair, Y.Right: Pair,
      X.Left: Structure, X.Right.Left: Structure, X.Right.Right: Structure,
      Y.Left: Structure, Y.Right.Left: Structure, Y.Right.Right: Structure {
    public typealias P = CycleProfileTriple<X>
    public typealias Q = CycleProfileTriple<Y>
    public typealias Actual = JointEvidence<PairedApplication<P.A, Q.A>,
        JointEvidence<PairedApplication<P.B, Q.B>, PairedApplication<P.C, Q.C>>>
    public typealias Left = Paired<X, Y>
    public typealias Right = AddressTriple<Paired<X.Left, Y.Left>,
        Paired<X.Right.Left, Y.Right.Left>, Paired<X.Right.Right, Y.Right.Right>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
    public enum Endpoint: Null {
        public typealias Left = Actual.Answer
        public typealias Right = TripleProfileKeys.Answer
    }
}

/// One word takes a valid forward chart to another valid chart, then to
/// a chart with repeated XY keys. X and Z are carried through every step.
/// Three words return all fields. The first word is not uniformly safe
/// for the stronger release question merely because it was safe once.
public enum CyclicProfileRepeatBoundary<A: Structure, B: Structure, C: Structure>: Close {
    public typealias ABC = AddressTriple<A, B, C>
    public typealias BCA = AddressTriple<B, C, A>
    public typealias CAB = AddressTriple<C, A, B>
    public typealias X = AddressTriple<ABC, ABC, ABC>
    public typealias Z = AddressTriple<AddressTriple<A, A, A>,
        AddressTriple<B, B, B>, AddressTriple<C, C, C>>
    public typealias Forward = AddressTriple<ABC, BCA, CAB>
    public typealias Reverse = AddressTriple<ABC, CAB, BCA>
    public typealias Collapsed = X
    public typealias Context = Paired<X, Z>
    public typealias Root = Paired<Forward, Context>
    public typealias First = PairedApplication<CyclicProfileChange<ABC, BCA, CAB>,
        IdentityReading<Context, BeamSpace, SaturationEncoding>>
    public typealias Second = PairedApplication<CyclicProfileChange<ABC, CAB, BCA>,
        IdentityReading<Context, BeamSpace, SaturationEncoding>>
    public typealias Third = PairedApplication<CyclicProfileChange<ABC, ABC, ABC>,
        IdentityReading<Context, BeamSpace, SaturationEncoding>>
    public typealias Twice = SequentialReading<First, Second>
    public typealias Round = SequentialReading<Twice, Third>
    public typealias InverseFromReverse = SequentialReading<Second, Third>
    public enum ActualEndpoints: Null {
        public typealias Left = AddressTriple<First.Answer, Twice.Answer, Round.Answer>
        public typealias Right = AddressTriple<Paired<Reverse, Context>, Paired<Collapsed, Context>, Root>
    }
    public typealias ForwardKeys = AddressTriple<TripleProfileKeys<ABC, ABC>.Answer,
        TripleProfileKeys<ABC, BCA>.Answer, TripleProfileKeys<ABC, CAB>.Answer>
    public typealias ReverseKeys = AddressTriple<TripleProfileKeys<ABC, ABC>.Answer,
        TripleProfileKeys<ABC, CAB>.Answer, TripleProfileKeys<ABC, BCA>.Answer>
    public enum BothBeforeAndAfterHaveEveryPair: Null {
        public typealias AA = Paired<A, A>
        public typealias AB = Paired<A, B>
        public typealias AC = Paired<A, C>
        public typealias BA = Paired<B, A>
        public typealias BB = Paired<B, B>
        public typealias BC = Paired<B, C>
        public typealias CA = Paired<C, A>
        public typealias CB = Paired<C, B>
        public typealias CC = Paired<C, C>
        public typealias Left = Paired<ForwardKeys, ReverseKeys>
        public typealias Right = Paired<
            AddressTriple<AddressTriple<AA, BB, CC>, AddressTriple<AB, BC, CA>, AddressTriple<AC, BA, CB>>,
            AddressTriple<AddressTriple<AA, BB, CC>, AddressTriple<AC, BA, CB>, AddressTriple<AB, BC, CA>>>
    }
    public enum RepetitionHasThreeEqualKeys: Null {
        public typealias Changed = Twice.Answer.Left
        public typealias Left = AddressTriple<TripleProfileKeys<ABC, Changed.Left>.Answer,
            TripleProfileKeys<ABC, Changed.Right.Left>.Answer, TripleProfileKeys<ABC, Changed.Right.Right>.Answer>
        public typealias Same = TripleProfileKeys<ABC, ABC>.Answer
        public typealias Right = AddressTriple<Same, Same, Same>
    }
    public enum InverseReturnsPreparedSource: Null {
        public typealias Left = InverseFromReverse.Answer
        public typealias Right = Root
    }
}

/// Each isolated controller alternates the forward word and its inverse.
/// Sharing the device does not automatically update the partner's private
/// phase marker. Two forward selections then reach the bad common state.
public enum TwoCyclicControllers<A: Structure, B: Structure, C: Structure>: Close {
    public typealias R = CyclicProfileRepeatBoundary<A, B, C>
    public typealias Forward = Paired<Never, Lit1>
    public typealias Reverse = Paired<Lit1, Never>
    public typealias AloneFirst = PairedApplication<R.First, SwapBoundaryReading<Forward>>
    public typealias AloneBack = PairedApplication<R.InverseFromReverse, SwapBoundaryReading<Reverse>>
    public typealias Alone = SequentialReading<AloneFirst, AloneBack>
    public enum EachIsolatedCycleCloses: Null {
        public typealias Left = Alone.Answer
        public typealias Right = Paired<R.Root, Forward>
    }
    public typealias Root = Paired<R.Root, Paired<Forward, Forward>>
    public typealias FirstController = PairedApplication<R.First,
        PairedApplication<SwapBoundaryReading<Forward>, IdentityReading<Forward, BeamSpace, SaturationEncoding>>>
    public typealias SecondController = PairedApplication<R.Second,
        PairedApplication<IdentityReading<Reverse, BeamSpace, SaturationEncoding>, SwapBoundaryReading<Forward>>>
    public typealias Actual = SequentialReading<FirstController, SecondController>
    public enum SharedEndpoints: Null {
        public typealias Left = AddressTriple<FirstController.Left, FirstController.Answer, Actual.Answer>
        public typealias Right = AddressTriple<Root,
            Paired<Paired<R.Reverse, R.Context>, Paired<Reverse, Forward>>,
            Paired<Paired<R.Collapsed, R.Context>, Paired<Reverse, Reverse>>>
    }
    public enum BothSelectedTheSameWord: Null {
        public typealias Left = R.First.Predicate
        public typealias Right = R.Second.Predicate
    }
}
