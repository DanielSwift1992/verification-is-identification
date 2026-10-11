import VerificationIsIdentification

/// Reuse the selection already tied to this root, then execute its actual
/// primitive beside the acquired address. Recording retains the source used
/// for selection; no second private choice or supplied address enters here.
extension SelectedLocalApplication
where Root.Left: Structure, Primitive.Answer: Structure {
    public typealias SelectionFact = FactOf<Selection>
    public enum RecordedPrimitive: PredicateReading {
        public typealias Actual = FollowedPair<RetainingRecordedReading<Selection>,
            ExperimentReadingBeside<Primitive, SelectionFact>>
        public typealias Left = Root.Left
        public typealias Right = Paired<Primitive.Answer, SelectionFact>
        public typealias Sigma = Primitive.Sigma
        public typealias Encoding = Primitive.Encoding
        public typealias Predicate = Actual.Predicate
        public typealias Answer = Right
        public enum Endpoints: Null {
            public typealias Left = Paired<RecordedPrimitive.Left, RecordedPrimitive.Right>
            public typealias Right = Paired<Actual.Left, Actual.Answer>
        }
    }
    public enum RecordedSelectionMatches: Null {
        public typealias Left = Paired<RecordedPrimitive.Left,
            Paired<RecordedPrimitive.Answer.Left, RecordedPrimitive.Answer.Right.Answer>>
        public typealias Right = Paired<Root.Left, Paired<Primitive.Answer, S.Address>>
    }
}

/// Place the already acquired address inside the working context. The old
/// program, payload, stage and phase all come from this actual source.
public enum KeepSelectionInContext<W: Pair>: Pair
where W.Left: Pair, W.Left.Left: Structure, W.Left.Right: Pair,
      W.Left.Right.Left: Structure, W.Left.Right.Right: Pair,
      W.Left.Right.Right.Left: Structure, W.Left.Right.Right.Right: Structure,
      W.Right: Structure {
    public typealias Source = W.Left
    public typealias Context = Source.Right.Right
    public typealias Left = W
    public typealias Right = LocalPhaseWorld<Source.Left, Source.Right.Left,
        Paired<Context.Left, Paired<Context.Right, W.Right>>>
}

/// The inverse rearrangement exposes the target with its original context
/// beside the retained address fact. It does not erase that fact.
public enum ExposeSelectionBesideTarget<W: Pair>: Pair
where W.Left: Structure, W.Right: Pair, W.Right.Left: Structure,
      W.Right.Right: Pair, W.Right.Right.Left: Structure,
      W.Right.Right.Right: Pair, W.Right.Right.Right.Left: Structure,
      W.Right.Right.Right.Right: Structure {
    public typealias Context = W.Right.Right
    public typealias Left = W
    public typealias Right = Paired<LocalPhaseWorld<W.Left, W.Right.Left,
        Paired<Context.Left, Context.Right.Left>>, Context.Right.Right>
}

/// Selection at the new source sees its actual acquired record and retained
/// address program. Neither the current phase nor the original source is a
/// decoder input.
public enum RecordedLocalChoiceInput<W: Pair>: PredicateReading
where W.Right: Pair, W.Right.Right: Pair,
      W.Right.Right.Left: Structure, W.Right.Right.Right: Pair,
      W.Right.Right.Right.Right: Structure {
    public typealias Tail = SecondEvidenceImage<W, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Context = FollowedPair<Tail,
        SecondEvidenceImage<Tail.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Program = FollowedPair<Context,
        FirstEvidenceImage<Context.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Rest = FollowedPair<Context,
        SecondEvidenceImage<Context.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Fact = FollowedPair<Rest,
        SecondEvidenceImage<Rest.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Actual = JointEvidence<Fact, Program>
    public typealias Left = W
    public typealias Right = Actual.Answer
    public typealias Sigma = Actual.Sigma
    public typealias Encoding = Actual.Encoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
}

public typealias ReadLocalChoice<M: Pair> = FollowedPair<
    FirstEvidenceImage<M, BeamSpace, SaturationEncoding, FirstProjection>, ReadRecordedAnswer<M.Left>>
where M.Left: HasVerdict, M.Left.Sigma == BeamSpace, M.Left.Encoding == SaturationEncoding
