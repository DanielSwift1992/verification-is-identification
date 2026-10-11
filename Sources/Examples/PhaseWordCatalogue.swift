import VerificationIsIdentification

/// Twelve representatives of the even four-phase actions. W and Z are the
/// actual already-derived returning words, not additional primitive contacts.
/// Words list performed blocks from left to right. Every application starts
/// at the preceding actual output; the caller supplies only arbitrary labels.
public enum PhaseWordCatalogue<A: Structure, B: Structure,
                               C: Structure, D: Structure>: Close {
    public typealias Initial = BoundaryWorking<A, B, C, D>
    public typealias I = IdentityReading<Initial, BeamSpace, SaturationEncoding>
    public typealias W = FourLeafPhaseWord<A, B, C, D>
    public typealias WW = FollowedPair<W, FourLeafPhaseWord<D, B, A, C>>

    public typealias Z = FourLeafShortPhaseWord<A, B, C, D>
    public typealias ZW = FollowedPair<Z, FourLeafPhaseWord<B, A, D, C>>
    public typealias ZWW = FollowedPair<ZW, FourLeafPhaseWord<C, A, B, D>>
    public typealias WZ = FollowedPair<W, FourLeafShortPhaseWord<D, B, A, C>>
    public typealias WZW = FollowedPair<WZ, FourLeafPhaseWord<B, D, C, A>>
    public typealias WZWW = FollowedPair<WZW, FourLeafPhaseWord<A, D, B, C>>
    public typealias WWZ = FollowedPair<WW, FourLeafShortPhaseWord<C, B, D, A>>
    public typealias WWZW = FollowedPair<WWZ, FourLeafPhaseWord<B, C, A, D>>
    public typealias WWZWW = FollowedPair<WWZW, FourLeafPhaseWord<D, C, B, A>>

    public typealias Pure = CandidateFork<CandidateLeaf<I>,
        CandidateFork<CandidateLeaf<W>, CandidateLeaf<WW>>>
    public typealias ZeroPrefix = CandidateFork<CandidateLeaf<Z>,
        CandidateFork<CandidateLeaf<ZW>, CandidateLeaf<ZWW>>>
    public typealias OnePrefix = CandidateFork<CandidateLeaf<WZ>,
        CandidateFork<CandidateLeaf<WZW>, CandidateLeaf<WZWW>>>
    public typealias TwoPrefix = CandidateFork<CandidateLeaf<WWZ>,
        CandidateFork<CandidateLeaf<WWZW>, CandidateLeaf<WWZWW>>>
    public typealias Words = CandidateFork<CandidateFork<Pure, ZeroPrefix>,
        CandidateFork<OnePrefix, TwoPrefix>>

    /// This is the complete symbolic action at final addresses. These tuples
    /// carry tokens, so their inverse gives the destination of an input point.
    /// Distinctness requires distinct labels; no such premise is needed for
    /// the equations themselves or for their reuse after label substitution.
    public enum Outputs: Null {
        public typealias Left = BoundaryWorking<
            Paired<I.Right, Paired<W.Right, WW.Right>>,
            Paired<Z.Right, Paired<ZW.Right, ZWW.Right>>,
            Paired<WZ.Right, Paired<WZW.Right, WZWW.Right>>,
            Paired<WWZ.Right, Paired<WWZW.Right, WWZWW.Right>>>
        public typealias Right = BoundaryWorking<
            Paired<BoundaryWorking<A, B, C, D>,
                Paired<BoundaryWorking<D, B, A, C>, BoundaryWorking<C, B, D, A>>>,
            Paired<BoundaryWorking<B, A, D, C>,
                Paired<BoundaryWorking<C, A, B, D>, BoundaryWorking<D, A, C, B>>>,
            Paired<BoundaryWorking<B, D, C, A>,
                Paired<BoundaryWorking<A, D, B, C>, BoundaryWorking<C, D, A, B>>>,
            Paired<BoundaryWorking<B, C, A, D>,
                Paired<BoundaryWorking<D, C, B, A>, BoundaryWorking<A, C, D, B>>>>
    }

    public enum SharedSource: Null {
        public typealias Left = BoundaryWorking<
            Paired<I.Left, Paired<W.Left, WW.Left>>,
            Paired<Z.Left, Paired<ZW.Left, ZWW.Left>>,
            Paired<WZ.Left, Paired<WZW.Left, WZWW.Left>>,
            Paired<WWZ.Left, Paired<WWZW.Left, WWZWW.Left>>>
        public typealias Three = Paired<Initial, Paired<Initial, Initial>>
        public typealias Right = BoundaryWorking<Three, Three, Three, Three>
    }
}
