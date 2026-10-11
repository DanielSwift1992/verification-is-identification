import VerificationIsIdentification
import Examples

// The preparation is W's fixed point, not an independently chosen frame zero.
enum IntrinsicPhasePreparation: Null {
    typealias AtB = PhaseAlignmentObstruction<Never, Lit1, Never, Never>
    typealias AtA = PhaseAlignmentObstruction<Lit1, Never, Never, Never>
    typealias Left = Paired<AtB.W.Right,
        Paired<Paired<AtB.Q1.Right, AtB.Q2.Right>, AtA.W.Right>>
    typealias Right = Paired<FourLeafPhaseMark1,
        Paired<Paired<FourLeafPhaseMark0, FourLeafPhaseMark0>, FourLeafPhaseMark2>>
}

// From that intrinsic preparation the first joint step agrees. The second
// returns in one system and reaches a distinct phase in the other.
enum PhaseJointReturnSeparates: Null {
    typealias P = IntrinsicPhasePreparation.AtB
    typealias Left = Paired<Paired<P.Joint1.Right, P.Joint2.Right>,
        Paired<P.Joint1Square.Right, P.Joint2Square.Right>>
    typealias Right = Paired<Paired<FourLeafPhaseMark2, FourLeafPhaseMark2>,
        Paired<FourLeafPhaseMark1, FourLeafPhaseMark3>>
}

// Once the intrinsic frame is supplied, one Q query at a distinguishes the
// only two remaining three-cycle laws with Q(b)=a.
enum RemainingPhaseContact: Null {
    typealias P = IntrinsicPhasePreparation.AtA
    typealias Left = Paired<P.Q1.Right, P.Q2.Right>
    typealias Right = Paired<FourLeafPhaseMark2, FourLeafPhaseMark3>
}

// A contact may be translated to a word when the comparison contract permits
// this change of granularity. The current source is carried through each step.
enum PhaseContactWordTranslation<A: Structure, B: Structure,
    C: Structure, D: Structure>: Null {
    typealias P = PhaseAlignmentObstruction<A, B, C, D>
    typealias Q1ThroughQ2 = FollowedPair<P.W, PhaseWordCatalogue<D, B, A, C>.WZ>
    typealias Q2ThroughQ1 = FollowedPair<P.Words.WW, PhaseWordCatalogue<C, B, D, A>.WWZ>
    typealias ZThroughQ1 = FollowedPair<P.W, PhaseWordCatalogue<D, B, A, C>.WWZ>
    typealias ZThroughQ2 = FollowedPair<P.Words.WW, PhaseWordCatalogue<C, B, D, A>.WZ>
    typealias Left = Paired<Paired<Q1ThroughQ2.Right, Q2ThroughQ1.Right>,
        Paired<ZThroughQ1.Right, ZThroughQ2.Right>>
    typealias Right = Paired<Paired<P.Q1.Right, P.Q2.Right>,
        Paired<P.Words.Z.Right, P.Words.Z.Right>>
}

#if LOCAL_PHASE_INDIVIDUAL_PERIODS_ALIGN_GAMES
enum RejectedPhaseAlignmentFromIndividualPeriods: Null {
    typealias P = IntrinsicPhasePreparation.AtB
    typealias Left = P.Joint1Square.Right
    typealias Right = P.Joint2Square.Right
}
#endif
