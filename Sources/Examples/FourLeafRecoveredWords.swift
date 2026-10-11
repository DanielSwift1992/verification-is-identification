import VerificationIsIdentification

/// All twelve recovered laws act on a new, arbitrary symbolic phase source.
/// Each selection is bound to the address decoded from the acquired facts.
/// Its future phase action is derived; it is not supplied as a where premise.
public enum FourLeafRecoveredWords<A: Structure, B: Structure,
                                   C: Structure, D: Structure>: Close {
    public typealias RI = FourLeafRecoveredRoot<FourLeafAcquiredLaw.I.Right, A, B, C, D>
    public typealias I = RI.Run<RI.Root.SelectI>
    public typealias RW = FourLeafRecoveredRoot<FourLeafAcquiredLaw.W.Right, A, B, C, D>
    public typealias W = RW.Run<RW.Root.SelectW>
    public typealias RWW = FourLeafRecoveredRoot<FourLeafAcquiredLaw.WW.Right, A, B, C, D>
    public typealias WW = RWW.Run<RWW.Root.SelectWW>
    public typealias RZ = FourLeafRecoveredRoot<FourLeafAcquiredLaw.Z.Right, A, B, C, D>
    public typealias Z = RZ.Run<RZ.Root.SelectZ>
    public typealias RZW = FourLeafRecoveredRoot<FourLeafAcquiredLaw.ZW.Right, A, B, C, D>
    public typealias ZW = RZW.Run<RZW.Root.SelectZW>
    public typealias RZWW = FourLeafRecoveredRoot<FourLeafAcquiredLaw.ZWW.Right, A, B, C, D>
    public typealias ZWW = RZWW.Run<RZWW.Root.SelectZWW>
    public typealias RWZ = FourLeafRecoveredRoot<FourLeafAcquiredLaw.WZ.Right, A, B, C, D>
    public typealias WZ = RWZ.Run<RWZ.Root.SelectWZ>
    public typealias RWZW = FourLeafRecoveredRoot<FourLeafAcquiredLaw.WZW.Right, A, B, C, D>
    public typealias WZW = RWZW.Run<RWZW.Root.SelectWZW>
    public typealias RWZWW = FourLeafRecoveredRoot<FourLeafAcquiredLaw.WZWW.Right, A, B, C, D>
    public typealias WZWW = RWZWW.Run<RWZWW.Root.SelectWZWW>
    public typealias RWWZ = FourLeafRecoveredRoot<FourLeafAcquiredLaw.WWZ.Right, A, B, C, D>
    public typealias WWZ = RWWZ.Run<RWWZ.Root.SelectWWZ>
    public typealias RWWZW = FourLeafRecoveredRoot<FourLeafAcquiredLaw.WWZW.Right, A, B, C, D>
    public typealias WWZW = RWWZW.Run<RWWZW.Root.SelectWWZW>
    public typealias RWWZWW = FourLeafRecoveredRoot<FourLeafAcquiredLaw.WWZWW.Right, A, B, C, D>
    public typealias WWZWW = RWWZWW.Run<RWWZWW.Root.SelectWWZWW>

    public enum ReproducesAction: Null {
        public typealias Original = PhaseWordCatalogue<A, B, C, D>
        public typealias Left = Paired<Paired<Paired<Paired<I.Right.Right.Left, W.Right.Right.Left>, WW.Right.Right.Left>, Paired<Paired<Z.Right.Right.Left, ZW.Right.Right.Left>, ZWW.Right.Right.Left>>, Paired<Paired<Paired<WZ.Right.Right.Left, WZW.Right.Right.Left>, WZWW.Right.Right.Left>, Paired<Paired<WWZ.Right.Right.Left, WWZW.Right.Right.Left>, WWZWW.Right.Right.Left>>>
        public typealias Right = Paired<Paired<Paired<Paired<Original.I.Right, Original.W.Right>, Original.WW.Right>, Paired<Paired<Original.Z.Right, Original.ZW.Right>, Original.ZWW.Right>>, Paired<Paired<Paired<Original.WZ.Right, Original.WZW.Right>, Original.WZWW.Right>, Paired<Paired<Original.WWZ.Right, Original.WWZW.Right>, Original.WWZWW.Right>>>
    }

    public enum KeepsAcquiredInput: Null {
        public typealias Left = Paired<Paired<Paired<Paired<I.Left.Left, W.Left.Left>, WW.Left.Left>, Paired<Paired<Z.Left.Left, ZW.Left.Left>, ZWW.Left.Left>>, Paired<Paired<Paired<WZ.Left.Left, WZW.Left.Left>, WZWW.Left.Left>, Paired<Paired<WWZ.Left.Left, WWZW.Left.Left>, WWZWW.Left.Left>>>
        public typealias Right = Paired<Paired<Paired<Paired<FourLeafAcquiredLaw.I.Observation.Answer, FourLeafAcquiredLaw.W.Observation.Answer>, FourLeafAcquiredLaw.WW.Observation.Answer>, Paired<Paired<FourLeafAcquiredLaw.Z.Observation.Answer, FourLeafAcquiredLaw.ZW.Observation.Answer>, FourLeafAcquiredLaw.ZWW.Observation.Answer>>, Paired<Paired<Paired<FourLeafAcquiredLaw.WZ.Observation.Answer, FourLeafAcquiredLaw.WZW.Observation.Answer>, FourLeafAcquiredLaw.WZWW.Observation.Answer>, Paired<Paired<FourLeafAcquiredLaw.WWZ.Observation.Answer, FourLeafAcquiredLaw.WWZW.Observation.Answer>, FourLeafAcquiredLaw.WWZWW.Observation.Answer>>>
    }
}

