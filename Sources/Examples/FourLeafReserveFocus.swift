import VerificationIsIdentification

/// A second actual probe is already prepared inside the initial laboratory.
/// Its stage and phase are carried together. R contains other retained parts.
public typealias FourLeafPreparedReserve<R: Structure> = Paired<
    Paired<FourLeafCenter, FourLeafPhaseMark1>, R>

/// After the first fact, exchange the current probe with that resident reserve.
/// The law address and both selector programs stay in their actual fields.
/// The old probe, its phase and its fact are parked together; nothing is reset.
public enum FourLeafReserveFocus<S: Structure, C: Structure, L: Structure,
                                 R: Structure, F: Structure>: Pair {
    public typealias Left = Paired<
        LocalPhaseWorld<S, C, FourLeafLawContext<L, FourLeafPreparedReserve<R>>>, F>
    public typealias Current = Left.Left
    public typealias Context = Current.Right.Right
    public typealias LawFields = Context.Right
    public typealias SelectorAndLab = LawFields.Right
    public typealias Lab = SelectorAndLab.Right
    public typealias Reserve = Lab.Left
    public typealias Parked = Paired<Paired<Current.Left, Current.Right.Left>, Left.Right>
    public typealias OutputLab = Paired<Parked, Lab.Right>
    public typealias OutputContext = Paired<Context.Left,
        Paired<LawFields.Left, Paired<SelectorAndLab.Left, OutputLab>>>
    public typealias Right = LocalPhaseWorld<Reserve.Left, Reserve.Right, OutputContext>

    /// Recover the exact canonical input by exchanging the same resident
    /// fields. This is an actual inverse, not a premise that the move is lossless.
    public enum Undo: Pair {
        public typealias Left = FourLeafReserveFocus.Right
        public typealias Context = Left.Right.Right
        public typealias LawFields = Context.Right
        public typealias SelectorAndLab = LawFields.Right
        public typealias Lab = SelectorAndLab.Right
        public typealias Old = Lab.Left
        public typealias Probe = Old.Left
        public typealias Reserve = Paired<Left.Left, Left.Right.Left>
        public typealias OldLab = Paired<Reserve, Lab.Right>
        public typealias OldContext = Paired<Context.Left,
            Paired<LawFields.Left, Paired<SelectorAndLab.Left, OldLab>>>
        public typealias Right = Paired<LocalPhaseWorld<Probe.Left, Probe.Right, OldContext>, Old.Right>
    }
    public enum RestoresInput: Null {
        public typealias Left = Undo.Right
        public typealias Right = FourLeafReserveFocus.Left
    }
    public enum RetainsLaw: Null {
        public typealias Left = FourLeafReserveFocus.Right.Right.Right.Right.Left
        public typealias Right = L
    }
}
