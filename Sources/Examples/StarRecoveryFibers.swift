import VerificationIsIdentification

/// Four actual contact predecessors of one center preparation. Context is
/// retained by every contact. These are available contact rows; the edge
/// policy in VC106 selects only its two endpoints as center predecessors.
public enum StarContactPredecessors<E: Structure>: Close {
    public typealias Context = IdentityReading<E, BeamSpace, SaturationEncoding>
    public typealias From0 = PairedApplication<FourLeafStage0<Never, Lit1, Never, Never, Never>, Context>
    public typealias From1 = PairedApplication<FourLeafStage1<Never, Never, Lit1, Never, Never>, Context>
    public typealias From2 = PairedApplication<FourLeafStage2<Never, Never, Never, Lit1, Never>, Context>
    public typealias From3 = PairedApplication<FourLeafStage3<Never, Never, Never, Never, Lit1>, Context>
    public typealias To0 = PairedApplication<FourLeafStage0<Lit1, Never, Never, Never, Never>, Context>
    public typealias To1 = PairedApplication<FourLeafStage1<Lit1, Never, Never, Never, Never>, Context>
    public typealias To2 = PairedApplication<FourLeafStage2<Lit1, Never, Never, Never, Never>, Context>
    public typealias To3 = PairedApplication<FourLeafStage3<Lit1, Never, Never, Never, Never>, Context>
    public typealias Center = Paired<FourLeafCenter, E>
    public enum CommonCurrentSource: Null {
        public typealias Left = BoundaryWorking<From0.Answer, From1.Answer, From2.Answer, From3.Answer>
        public typealias Right = BoundaryWorking<Center, Center, Center, Center>
    }
    public enum TheContactAddressRestoresItsSource: Null {
        public typealias R0 = FollowedPair<From0, To0>
        public typealias R1 = FollowedPair<From1, To1>
        public typealias R2 = FollowedPair<From2, To2>
        public typealias R3 = FollowedPair<From3, To3>
        public typealias Left = BoundaryWorking<R0.Answer, R1.Answer, R2.Answer, R3.Answer>
        public typealias Right = BoundaryWorking<From0.Left, From1.Left, From2.Left, From3.Left>
    }
}

/// One witnessed edge of the address-conflict graph. Merging the two address
/// records produces the same complete decoder input for distinct sources.
/// The arbitrary retained context may include the edge and a fixed program.
public enum MergedStarAddressInput<E: Structure, C: Structure>: Null {
    public typealias P = StarContactPredecessors<E>
    public typealias Left = Paired<P.From0.Answer, C>
    public typealias Right = Paired<P.From1.Answer, C>
}
