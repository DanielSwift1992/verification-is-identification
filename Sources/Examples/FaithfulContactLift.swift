import VerificationIsIdentification

/// Three phase exchanges derived from existing projections. These act on an
/// arbitrary ordered triple; six permutations of three distinct labels give
/// the six phase states used in the thirty-state carrier.
public enum ThreeSlotContacts<A: Structure, B: Structure, C: Structure>: Close {
    public typealias Input = AddressTriple<A, B, C>
    public typealias First = FirstEvidenceImage<Input, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Tail = SecondEvidenceImage<Input, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Second = SequentialReading<Tail,
        FirstEvidenceImage<Paired<B, C>, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Third = SequentialReading<Tail,
        SecondEvidenceImage<Paired<B, C>, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Identity = IdentityReading<Input, BeamSpace, SaturationEncoding>
    public typealias ZeroOne = SwapFirstTwoTriple<Input>
    public typealias ZeroTwo = JointEvidence<Third, JointEvidence<Second, First>>
    public typealias OneTwo = PairedApplication<IdentityReading<A, BeamSpace, SaturationEncoding>,
        SwapBoundaryReading<Paired<B, C>>>
    public enum Endpoints: Null {
        public typealias Left = AddressTriple<ZeroOne.Answer, ZeroTwo.Answer, OneTwo.Answer>
        public typealias Right = AddressTriple<AddressTriple<B, A, C>,
            AddressTriple<C, B, A>, AddressTriple<A, C, B>>
    }
    public enum Involutions: Null {
        public typealias AReturn = FollowedPair<ZeroOne, ThreeSlotContacts<B, A, C>.ZeroOne>
        public typealias BReturn = FollowedPair<ZeroTwo, ThreeSlotContacts<C, B, A>.ZeroTwo>
        public typealias CReturn = FollowedPair<OneTwo, ThreeSlotContacts<A, C, B>.OneTwo>
        public typealias Left = AddressTriple<AReturn.Right, BReturn.Right, CReturn.Right>
        public typealias Right = AddressTriple<Input, Input, Input>
    }
}

/// The five source rows of each of four total contacts. At center and the
/// selected leaf the phase stays; at another leaf j it receives the S4/V4
/// image of the leaf transposition (i j). The coset construction in VC102
/// supplies their one common action, instead of a stage-independent phase rule.
public enum FaithfulFourLeafRows<A: Structure, B: Structure, C: Structure>: Close {
    public typealias Phase = ThreeSlotContacts<A, B, C>
    public typealias C0 = PairedApplication<FourLeafStage0<Lit1, Never, Never, Never, Never>, Phase.Identity>
    public typealias C1 = PairedApplication<FourLeafStage1<Lit1, Never, Never, Never, Never>, Phase.Identity>
    public typealias C2 = PairedApplication<FourLeafStage2<Lit1, Never, Never, Never, Never>, Phase.Identity>
    public typealias C3 = PairedApplication<FourLeafStage3<Lit1, Never, Never, Never, Never>, Phase.Identity>
    public typealias L00 = PairedApplication<FourLeafStage0<Never, Lit1, Never, Never, Never>, Phase.Identity>
    public typealias L01 = PairedApplication<FourLeafStage1<Never, Lit1, Never, Never, Never>, Phase.ZeroOne>
    public typealias L02 = PairedApplication<FourLeafStage2<Never, Lit1, Never, Never, Never>, Phase.ZeroTwo>
    public typealias L03 = PairedApplication<FourLeafStage3<Never, Lit1, Never, Never, Never>, Phase.OneTwo>
    public typealias L10 = PairedApplication<FourLeafStage0<Never, Never, Lit1, Never, Never>, Phase.ZeroOne>
    public typealias L11 = PairedApplication<FourLeafStage1<Never, Never, Lit1, Never, Never>, Phase.Identity>
    public typealias L12 = PairedApplication<FourLeafStage2<Never, Never, Lit1, Never, Never>, Phase.OneTwo>
    public typealias L13 = PairedApplication<FourLeafStage3<Never, Never, Lit1, Never, Never>, Phase.ZeroTwo>
    public typealias L20 = PairedApplication<FourLeafStage0<Never, Never, Never, Lit1, Never>, Phase.ZeroTwo>
    public typealias L21 = PairedApplication<FourLeafStage1<Never, Never, Never, Lit1, Never>, Phase.OneTwo>
    public typealias L22 = PairedApplication<FourLeafStage2<Never, Never, Never, Lit1, Never>, Phase.Identity>
    public typealias L23 = PairedApplication<FourLeafStage3<Never, Never, Never, Lit1, Never>, Phase.ZeroOne>
    public typealias L30 = PairedApplication<FourLeafStage0<Never, Never, Never, Never, Lit1>, Phase.OneTwo>
    public typealias L31 = PairedApplication<FourLeafStage1<Never, Never, Never, Never, Lit1>, Phase.ZeroTwo>
    public typealias L32 = PairedApplication<FourLeafStage2<Never, Never, Never, Never, Lit1>, Phase.ZeroOne>
    public typealias L33 = PairedApplication<FourLeafStage3<Never, Never, Never, Never, Lit1>, Phase.Identity>
}

/// Six actual triple preparations, not six uncalibrated phase names.
public enum FaithfulFourLeafPhases: Close {
    public typealias E = FaithfulFourLeafRows<Never, Lit1, Lit2>
    public typealias A = FaithfulFourLeafRows<Lit1, Never, Lit2>
    public typealias B = FaithfulFourLeafRows<Lit2, Lit1, Never>
    public typealias C = FaithfulFourLeafRows<Never, Lit2, Lit1>
    public typealias P = FaithfulFourLeafRows<Lit2, Never, Lit1>
    public typealias Q = FaithfulFourLeafRows<Lit1, Lit2, Never>
}
