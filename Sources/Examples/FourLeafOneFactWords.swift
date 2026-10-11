import VerificationIsIdentification

/// The first actual probe is sufficient to install and execute the value
/// effect on (A,B,B,B). All twelve source laws are covered; their remaining
/// differences are retained in the parked original source, not identified
/// with the representative chosen for this one application.
/// The joint resident witness uses one marked slot and three equal blanks.
/// The root and phase-word equations separately retain arbitrary payloads.
public enum FourLeafOneFactWords: Close {
    public typealias A = Lit1
    public typealias B = Never
    public typealias H = Never
    public typealias First = FourLeafTwoProbe.First

    public typealias DI = FourLeafEffectDecoder<First.I.Answer.Right,
        Route00<FourLeafEffectRepresentatives>>
    public typealias RI = FourLeafOneFactRoot<DI, A, B, H,
        First.I.Answer.Left, First.I.Answer.Right>
    public typealias ProbeI = StepBeside<First.I, RI.Focus.Resources>
    public typealias I = FollowedPair<ProbeI, RI.Run<RI.Root.SelectI>>

    public typealias DW = FourLeafEffectDecoder<First.W.Answer.Right,
        Route10<FourLeafEffectRepresentatives>>
    public typealias RW = FourLeafOneFactRoot<DW, A, B, H,
        First.W.Answer.Left, First.W.Answer.Right>
    public typealias ProbeW = StepBeside<First.W, RW.Focus.Resources>
    public typealias W = FollowedPair<ProbeW, RW.Run<RW.Root.SelectW>>

    public typealias DWW = FourLeafEffectDecoder<First.WW.Answer.Right,
        Route11<FourLeafEffectRepresentatives>>
    public typealias RWW = FourLeafOneFactRoot<DWW, A, B, H,
        First.WW.Answer.Left, First.WW.Answer.Right>
    public typealias ProbeWW = StepBeside<First.WW, RWW.Focus.Resources>
    public typealias WW = FollowedPair<ProbeWW, RWW.Run<RWW.Root.SelectWW>>

    public typealias DZ = FourLeafEffectDecoder<First.Z.Answer.Right,
        Route01<FourLeafEffectRepresentatives>>
    public typealias RZ = FourLeafOneFactRoot<DZ, A, B, H,
        First.Z.Answer.Left, First.Z.Answer.Right>
    public typealias ProbeZ = StepBeside<First.Z, RZ.Focus.Resources>
    public typealias Z = FollowedPair<ProbeZ, RZ.Run<RZ.Root.SelectZ>>

    public typealias DZW = FourLeafEffectDecoder<First.ZW.Answer.Right,
        Route01<FourLeafEffectRepresentatives>>
    public typealias RZW = FourLeafOneFactRoot<DZW, A, B, H,
        First.ZW.Answer.Left, First.ZW.Answer.Right>
    public typealias ProbeZW = StepBeside<First.ZW, RZW.Focus.Resources>
    public typealias ZW = FollowedPair<ProbeZW, RZW.Run<RZW.Root.SelectZ>>

    public typealias DZWW = FourLeafEffectDecoder<First.ZWW.Answer.Right,
        Route01<FourLeafEffectRepresentatives>>
    public typealias RZWW = FourLeafOneFactRoot<DZWW, A, B, H,
        First.ZWW.Answer.Left, First.ZWW.Answer.Right>
    public typealias ProbeZWW = StepBeside<First.ZWW, RZWW.Focus.Resources>
    public typealias ZWW = FollowedPair<ProbeZWW, RZWW.Run<RZWW.Root.SelectZ>>

    public typealias DWZ = FourLeafEffectDecoder<First.WZ.Answer.Right,
        Route11<FourLeafEffectRepresentatives>>
    public typealias RWZ = FourLeafOneFactRoot<DWZ, A, B, H,
        First.WZ.Answer.Left, First.WZ.Answer.Right>
    public typealias ProbeWZ = StepBeside<First.WZ, RWZ.Focus.Resources>
    public typealias WZ = FollowedPair<ProbeWZ, RWZ.Run<RWZ.Root.SelectWW>>

    public typealias DWZW = FourLeafEffectDecoder<First.WZW.Answer.Right,
        Route00<FourLeafEffectRepresentatives>>
    public typealias RWZW = FourLeafOneFactRoot<DWZW, A, B, H,
        First.WZW.Answer.Left, First.WZW.Answer.Right>
    public typealias ProbeWZW = StepBeside<First.WZW, RWZW.Focus.Resources>
    public typealias WZW = FollowedPair<ProbeWZW, RWZW.Run<RWZW.Root.SelectI>>

    public typealias DWZWW = FourLeafEffectDecoder<First.WZWW.Answer.Right,
        Route10<FourLeafEffectRepresentatives>>
    public typealias RWZWW = FourLeafOneFactRoot<DWZWW, A, B, H,
        First.WZWW.Answer.Left, First.WZWW.Answer.Right>
    public typealias ProbeWZWW = StepBeside<First.WZWW, RWZWW.Focus.Resources>
    public typealias WZWW = FollowedPair<ProbeWZWW, RWZWW.Run<RWZWW.Root.SelectW>>

    public typealias DWWZ = FourLeafEffectDecoder<First.WWZ.Answer.Right,
        Route10<FourLeafEffectRepresentatives>>
    public typealias RWWZ = FourLeafOneFactRoot<DWWZ, A, B, H,
        First.WWZ.Answer.Left, First.WWZ.Answer.Right>
    public typealias ProbeWWZ = StepBeside<First.WWZ, RWWZ.Focus.Resources>
    public typealias WWZ = FollowedPair<ProbeWWZ, RWWZ.Run<RWWZ.Root.SelectW>>

    public typealias DWWZW = FourLeafEffectDecoder<First.WWZW.Answer.Right,
        Route11<FourLeafEffectRepresentatives>>
    public typealias RWWZW = FourLeafOneFactRoot<DWWZW, A, B, H,
        First.WWZW.Answer.Left, First.WWZW.Answer.Right>
    public typealias ProbeWWZW = StepBeside<First.WWZW, RWWZW.Focus.Resources>
    public typealias WWZW = FollowedPair<ProbeWWZW, RWWZW.Run<RWWZW.Root.SelectWW>>

    public typealias DWWZWW = FourLeafEffectDecoder<First.WWZWW.Answer.Right,
        Route00<FourLeafEffectRepresentatives>>
    public typealias RWWZWW = FourLeafOneFactRoot<DWWZWW, A, B, H,
        First.WWZWW.Answer.Left, First.WWZWW.Answer.Right>
    public typealias ProbeWWZWW = StepBeside<First.WWZWW, RWWZWW.Focus.Resources>
    public typealias WWZWW = FollowedPair<ProbeWWZWW, RWWZWW.Run<RWWZWW.Root.SelectI>>

    public enum ReproducesValueEffect: Null {
        public typealias Original = PhaseWordCatalogue<A, B, B, B>
        public typealias Left = BoundaryWorking<Paired<I.Right.Right.Left, Paired<W.Right.Right.Left, WW.Right.Right.Left>>, Paired<Z.Right.Right.Left, Paired<ZW.Right.Right.Left, ZWW.Right.Right.Left>>, Paired<WZ.Right.Right.Left, Paired<WZW.Right.Right.Left, WZWW.Right.Right.Left>>, Paired<WWZ.Right.Right.Left, Paired<WWZW.Right.Right.Left, WWZWW.Right.Right.Left>>>
        public typealias Right = BoundaryWorking<Paired<Original.I.Right, Paired<Original.W.Right, Original.WW.Right>>, Paired<Original.Z.Right, Paired<Original.ZW.Right, Original.ZWW.Right>>, Paired<Original.WZ.Right, Paired<Original.WZW.Right, Original.WZWW.Right>>, Paired<Original.WWZ.Right, Paired<Original.WWZW.Right, Original.WWZWW.Right>>>
    }
}
