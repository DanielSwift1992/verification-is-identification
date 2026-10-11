import VerificationIsIdentification

/// Two actual prefix readings meet at the same input of one supplied suffix.
/// No equality of the suffix answers is requested. The suffix may contain
/// any further admitted construction; its input binding remains essential.
public enum JoinedContinuation<A: Pair, B: Pair, R: PredicateReading>: Close
where A.Left == B.Left, R.Left == A.Left,
      R.Sigma == BeamSpace, R.Encoding == SaturationEncoding {
    public typealias PrefixA = FirstEvidenceImage<A, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias PrefixB = FirstEvidenceImage<B, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias PathA = SequentialReading<PrefixA, R>
    public typealias PathB = SequentialReading<PrefixB, R>
    public enum SameAnswer: Null {
        public typealias Left = PathA.Answer
        public typealias Right = PathB.Answer
    }
    public typealias RecordA = RecordReading<PathA>
    public typealias RecordB = RecordReading<PathB>
    public enum RetainedSources: Null {
        public typealias Left = Paired<RecordA.Right.Left, RecordB.Right.Left>
        public typealias Right = Paired<A, B>
    }
}

/// Equal current answers and a joined next input do not identify histories.
/// The private contrast is an actual additional projection of each root.
public enum JoinedRoots<K: Structure, V: Structure>: Close {
    public typealias A = Paired<K, Paired<V, Never>>
    public typealias B = Paired<K, Paired<V, Lit1>>
    public typealias TailA = SecondEvidenceImage<A, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias TailB = SecondEvidenceImage<B, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias VisibleA = SequentialReading<TailA,
        FirstEvidenceImage<TailA.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias VisibleB = SequentialReading<TailB,
        FirstEvidenceImage<TailB.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias PrivateA = SequentialReading<TailA,
        SecondEvidenceImage<TailA.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias PrivateB = SequentialReading<TailB,
        SecondEvidenceImage<TailB.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public enum CurrentAgreement: Null {
        public typealias Left = VisibleA.Answer
        public typealias Right = VisibleB.Answer
    }
    public enum PreservedContrast: Null {
        public typealias Left = Paired<PrivateA.Answer, PrivateB.Answer>
        public typealias Right = Paired<Never, Lit1>
    }
}

/// Equal current answers alone leave a later common reading unconstrained.
public enum UnjoinedVisibleRoots: Close {
    public typealias A = Paired<Paired<Never, Never>, Never>
    public typealias B = Paired<Paired<Never, Lit1>, Never>
    public typealias CurrentA = SecondEvidenceImage<A, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias CurrentB = SecondEvidenceImage<B, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias PrefixA = FirstEvidenceImage<A, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias PrefixB = FirstEvidenceImage<B, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias FutureA = SequentialReading<PrefixA,
        SecondEvidenceImage<PrefixA.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias FutureB = SequentialReading<PrefixB,
        SecondEvidenceImage<PrefixB.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public enum CurrentAgreement: Null {
        public typealias Left = CurrentA.Answer
        public typealias Right = CurrentB.Answer
    }
    public enum FutureContrast: Null {
        public typealias Left = Paired<FutureA.Answer, FutureB.Answer>
        public typealias Right = Paired<Never, Lit1>
    }
}
