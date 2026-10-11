import VerificationIsIdentification

/// Two pairs of three-cycle actions have the same individual action shapes
/// and frame roles, but incompatible joint periods. The words and every
/// intermediate source below are the existing actual phase constructions.
public enum PhaseAlignmentObstruction<A: Structure, B: Structure,
    C: Structure, D: Structure>: Close {
    public typealias Words = PhaseWordCatalogue<A, B, C, D>
    public typealias Initial = Words.Initial
    public typealias W = Words.W
    public typealias Q1 = Words.WWZ
    public typealias Q2 = Words.WZ
    public typealias WCube = FollowedPair<Words.WW, FourLeafPhaseWord<C, B, D, A>>
    public typealias Q1Square = FollowedPair<Q1, PhaseWordCatalogue<B, C, A, D>.WWZ>
    public typealias Q1Cube = FollowedPair<Q1Square, PhaseWordCatalogue<C, A, B, D>.WWZ>
    public typealias Q2Square = FollowedPair<Q2, PhaseWordCatalogue<B, D, C, A>.WZ>
    public typealias Q2Cube = FollowedPair<Q2Square, PhaseWordCatalogue<D, A, C, B>.WZ>

    // Words are in performed order: Q1 then W, and Q2 then W.
    public typealias Joint1 = Words.WWZW
    public typealias Joint2 = Words.WZW
    public typealias Joint1Square = FollowedPair<Joint1,
        PhaseWordCatalogue<D, C, B, A>.WWZW>
    public typealias Joint2Square = FollowedPair<Joint2,
        PhaseWordCatalogue<A, D, B, C>.WZW>
    public typealias Joint2Cube = FollowedPair<Joint2Square,
        PhaseWordCatalogue<A, C, D, B>.WZW>

    public enum IndividualCubesReturn: Null {
        public typealias Left = Paired<WCube.Right, Paired<Q1Cube.Right, Q2Cube.Right>>
        public typealias Right = Paired<Initial, Paired<Initial, Initial>>
    }
    public enum JointReturns: Null {
        public typealias Left = Paired<Joint1Square.Right, Joint2Cube.Right>
        public typealias Right = Paired<Initial, Initial>
    }
}
