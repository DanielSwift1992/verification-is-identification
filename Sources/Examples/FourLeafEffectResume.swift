import VerificationIsIdentification

/// Recover the parked source and first fact from the actual completed value
/// use. Its representative, changed payload and decoding record remain in a
/// separate resident remainder. This reassociation has an explicit inverse.
public enum FourLeafParkEffect<S: Structure, P: Structure, L: Structure,
    F: Structure, V: Structure, W: Structure, H: Structure>: Pair {
    public typealias Decoded = Paired<Paired<F, FourLeafEffectRepresentatives>, V>
    public typealias Archive = Paired<W, Paired<FourLeafReplyTable, H>>
    public typealias Left = LocalPhaseWorld<S, P,
        FourLeafLawContext<L, Paired<Decoded, Archive>>>
    public typealias Context = Left.Right.Right
    public typealias Lab = Context.Right.Right.Right
    public typealias ActualDecoded = Lab.Left
    public typealias ActualArchive = Lab.Right
    public typealias Original = Paired<ActualArchive.Left, ActualDecoded.Left.Left>
    public typealias RemainderLab = Paired<ActualDecoded.Left.Right,
        Paired<ActualDecoded.Right, ActualArchive.Right.Right>>
    public typealias RemainderContext = Paired<Context.Left,
        Paired<Context.Right.Left, Paired<Context.Right.Right.Left, RemainderLab>>>
    public typealias Remainder = LocalPhaseWorld<Left.Left, Left.Right.Left, RemainderContext>
    public typealias Right = Paired<Paired<Original, ActualArchive.Right.Left>, Remainder>

    public enum Undo: Pair {
        public typealias Left = FourLeafParkEffect.Right
        public typealias Original = Left.Left.Left
        public typealias Probe = Left.Right
        public typealias Context = Probe.Right.Right
        public typealias Lab = Context.Right.Right.Right
        public typealias Decoded = Paired<Paired<Original.Right, Lab.Left>, Lab.Right.Left>
        public typealias Archive = Paired<Original.Left, Paired<Left.Left.Right, Lab.Right.Right>>
        public typealias OldContext = Paired<Context.Left,
            Paired<Context.Right.Left, Paired<Context.Right.Right.Left, Paired<Decoded, Archive>>>>
        public typealias Right = LocalPhaseWorld<Probe.Left, Probe.Right.Left, OldContext>
    }
    public enum RestoresInput: Null {
        public typealias Left = Undo.Right
        public typealias Right = FourLeafParkEffect.Left
    }
}

/// A prepared second probe is focused and queried while the entire completed
/// value application is retained beside it. Exact intermediate source binding
/// prevents replacing the original unknown law with the earlier representative.
public enum FourLeafContinueInquiry<P: Pair, F: Pair, S: Pair, R: Structure>: Pair
where F.Left: Structure, F.Right: Structure,
      S.Left == F.Right, S.Right: Structure,
      P.Right == Paired<Paired<F.Left, FourLeafReplyTable>, R> {
    public typealias Focus = StepBeside<StepBeside<F, FourLeafReplyTable>, R>
    public typealias Second = StepBeside<StepBeside<S, FourLeafReplyTable>, R>
    public typealias Path = FollowedPair<P, FollowedPair<Focus, Second>>
    public typealias Left = Path.Left
    public typealias Right = Path.Right
}
