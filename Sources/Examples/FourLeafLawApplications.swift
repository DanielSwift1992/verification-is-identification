import VerificationIsIdentification

/// The complete admitted family of word invocations. Each source carries its
/// own law address, and each selection starts at that source's actual library.
/// A/B/C/D are arbitrary phase contents; R is retained laboratory context.
public enum FourLeafLawApplications<A: Structure, B: Structure, C: Structure,
                                    D: Structure, R: Structure>: Close {
    public typealias RI = FourLeafWordRoot<A, B, C, D, FourLeafLawContext<FourLeafLawAddresses.I, R>>
    public typealias RW = FourLeafWordRoot<A, B, C, D, FourLeafLawContext<FourLeafLawAddresses.W, R>>
    public typealias RWW = FourLeafWordRoot<A, B, C, D, FourLeafLawContext<FourLeafLawAddresses.WW, R>>
    public typealias RZ = FourLeafWordRoot<A, B, C, D, FourLeafLawContext<FourLeafLawAddresses.Z, R>>
    public typealias RZW = FourLeafWordRoot<A, B, C, D, FourLeafLawContext<FourLeafLawAddresses.ZW, R>>
    public typealias RZWW = FourLeafWordRoot<A, B, C, D, FourLeafLawContext<FourLeafLawAddresses.ZWW, R>>
    public typealias RWZ = FourLeafWordRoot<A, B, C, D, FourLeafLawContext<FourLeafLawAddresses.WZ, R>>
    public typealias RWZW = FourLeafWordRoot<A, B, C, D, FourLeafLawContext<FourLeafLawAddresses.WZW, R>>
    public typealias RWZWW = FourLeafWordRoot<A, B, C, D, FourLeafLawContext<FourLeafLawAddresses.WZWW, R>>
    public typealias RWWZ = FourLeafWordRoot<A, B, C, D, FourLeafLawContext<FourLeafLawAddresses.WWZ, R>>
    public typealias RWWZW = FourLeafWordRoot<A, B, C, D, FourLeafLawContext<FourLeafLawAddresses.WWZW, R>>
    public typealias RWWZWW = FourLeafWordRoot<A, B, C, D, FourLeafLawContext<FourLeafLawAddresses.WWZWW, R>>
    public typealias I = RI.Selected<RI.SelectI>
    public typealias W = RW.Selected<RW.SelectW>
    public typealias WW = RWW.Selected<RWW.SelectWW>
    public typealias Z = RZ.Selected<RZ.SelectZ>
    public typealias ZW = RZW.Selected<RZW.SelectZW>
    public typealias ZWW = RZWW.Selected<RZWW.SelectZWW>
    public typealias WZ = RWZ.Selected<RWZ.SelectWZ>
    public typealias WZW = RWZW.Selected<RWZW.SelectWZW>
    public typealias WZWW = RWZWW.Selected<RWZWW.SelectWZWW>
    public typealias WWZ = RWWZ.Selected<RWWZ.SelectWWZ>
    public typealias WWZW = RWWZW.Selected<RWWZW.SelectWWZW>
    public typealias WWZWW = RWWZWW.Selected<RWWZWW.SelectWWZWW>

    public enum LawAndContextRemain: Null {
        public typealias Left = BoundaryWorking<
            Paired<I.Answer.Right.Right, Paired<W.Answer.Right.Right, WW.Answer.Right.Right>>,
            Paired<Z.Answer.Right.Right, Paired<ZW.Answer.Right.Right, ZWW.Answer.Right.Right>>,
            Paired<WZ.Answer.Right.Right, Paired<WZW.Answer.Right.Right, WZWW.Answer.Right.Right>>,
            Paired<WWZ.Answer.Right.Right, Paired<WWZW.Answer.Right.Right, WWZWW.Answer.Right.Right>>>
        public typealias Right = BoundaryWorking<
            Paired<I.Left.Right.Right, Paired<W.Left.Right.Right, WW.Left.Right.Right>>,
            Paired<Z.Left.Right.Right, Paired<ZW.Left.Right.Right, ZWW.Left.Right.Right>>,
            Paired<WZ.Left.Right.Right, Paired<WZW.Left.Right.Right, WZWW.Left.Right.Right>>,
            Paired<WWZ.Left.Right.Right, Paired<WWZW.Left.Right.Right, WWZWW.Left.Right.Right>>>
    }
}
