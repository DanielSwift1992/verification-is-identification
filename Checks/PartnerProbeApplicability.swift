import VerificationIsIdentification
import Examples

/// Actual changes, not just nominal point tables for the counterexamples.
enum PartnerProbeActions<A: Structure, B: Structure,
    C: Structure, D: Structure>: Close {
    typealias Z = FourLeafShortPhaseWord<A, B, C, D>
    typealias Odd = FourLeafPhase2<A, B, C, D>
    typealias OddThenZ = FollowedPair<Odd, FourLeafShortPhaseWord<A, B, D, C>>
    typealias ZThenOdd = FollowedPair<Z, FourLeafPhase2<B, A, D, C>>
    typealias CurrentOddThenZ = FollowedPair<OddThenZ, FourLeafShortPhaseWord<B, A, C, D>>
    typealias ZThenCurrentOdd = FollowedPair<Z, PartnerProbeActions<B, A, D, C>.OddThenZ>

    // Exchange 1 and 3, leaving the nonpartner inputs 0 and 2 fixed.
    typealias N0 = FourLeafPhase1<A, B, C, D>
    typealias N1 = FollowedPair<N0, FourLeafPhase2<A, C, B, D>>
    typealias N = FollowedPair<N1, FourLeafPhase1<A, C, D, B>>
    typealias NThenZ = FollowedPair<N, FourLeafShortPhaseWord<A, D, C, B>>
    typealias ZThenN = FollowedPair<Z, PartnerProbeActions<B, A, D, C>.N>

    // The incompatible experiment reads 0 and, after this input exchange, 2.
    typealias P0 = FourLeafPhase0<A, B, C, D>
    typealias P1 = FollowedPair<P0, FourLeafPhase1<B, A, C, D>>
    typealias P = FollowedPair<P1, FourLeafPhase0<B, C, A, D>>
    typealias OtherP = PartnerProbeActions<A, D, C, B>.P
    typealias BadI = RepeatedPhaseProbe<P>
    typealias BadN = FollowedPair<N, RepeatedPhaseProbe<OtherP>>
    typealias BadIMemory = RetainedJointReplyMemory<Paired<BadI.Right, PhasePartnerTable>>
    typealias BadNMemory = RetainedJointReplyMemory<Paired<BadN.Right, PhasePartnerTable>>
    typealias PThenZ = FollowedPair<P, FourLeafShortPhaseWord<C, B, A, D>>
    typealias ZThenP = FollowedPair<Z, PartnerProbeActions<B, A, D, C>.P>
    typealias NP = FollowedPair<N, OtherP>
    typealias NPThenZ = FollowedPair<NP, FourLeafShortPhaseWord<C, D, A, B>>
    typealias ZThenNP = FollowedPair<Z, PartnerProbeActions<B, A, D, C>.NP>
}

#if !LOCAL_PHASE_PARTNER_IDENTIFIES_FRAME && !LOCAL_PHASE_PARTNER_ARBITRARY_INPUTS && !LOCAL_PHASE_PARTNER_FREEZES_SOURCE
enum PartnerClaimsAreUsable<C: Structure, D: Structure>: Null {
    typealias V = PartnerAcquiredVerdicts<C, D>
    typealias Q = PartnerVerdictAnswersCurrentSource<C, D>
    typealias Left = Paired<V.Left, Q.Left>
    typealias Right = Paired<V.Right, Q.Right>
}

enum PartnerTwoCompatibleSources<A: Structure, B: Structure,
    C: Structure, D: Structure>: Null {
    typealias F = PartnerProbeActions<A, B, C, D>
    typealias I = PartnerProbe<A, B, C, D>
    typealias O = PartnerProbe<A, B, D, C>
    typealias ActualOdd = FollowedPair<StepBeside<F.Odd, PhasePartnerTable>, O.Run>
    typealias Left = BoundaryWorking<I.Memory.Answer, F.OddThenZ.Right,
        ActualOdd.Right, F.CurrentOddThenZ.Right>
    typealias Right = BoundaryWorking<O.Memory.Answer, F.ZThenOdd.Right,
        O.Run.Right, F.ZThenCurrentOdd.Right>
}

enum PartnerCurrentSourcesReallyChanged<A: Structure, B: Structure,
    C: Structure, D: Structure>: Null {
    typealias I = PartnerProbe<A, B, C, D>
    typealias O = PartnerProbe<A, B, D, C>
    typealias Left = Paired<I.CurrentTable.Left, O.CurrentTable.Left>
    typealias Right = Paired<BoundaryWorking<B, A, D, C>, BoundaryWorking<B, A, C, D>>
}

// The two true fixed-port records are identical. The current tables differ
// in applicability: P does not commute with Z, whereas NP does.
enum PartnerNonpartnerAmbiguity<A: Structure, B: Structure,
    C: Structure, D: Structure>: Null {
    typealias F = PartnerProbeActions<A, B, C, D>
    typealias Left = Paired<F.BadIMemory.Answer, F.NPThenZ.Right>
    typealias Right = Paired<F.BadNMemory.Answer, F.ZThenNP.Right>
}

enum PartnerNonpartnerMismatch<A: Structure, B: Structure,
    C: Structure, D: Structure>: Null {
    typealias F = PartnerProbeActions<A, B, C, D>
    typealias Left = Paired<F.PThenZ.Right, F.ZThenP.Right>
    typealias Right = Paired<BoundaryWorking<B, C, D, A>, BoundaryWorking<D, A, B, C>>
}

// One actual step of the trapped-port argument in M64e. The equation is
// uniform in all four contents, so it repeats after any number of W steps.
enum PartnerTrappedPort<A: Structure, B: Structure,
    C: Structure, D: Structure>: Null {
    typealias W = FourLeafPhaseWord<A, B, C, D>
    typealias Before = RecordReading<PhaseLawProbe1<W.Left>>
    typealias Move = StepBeside<W, Before.Right.Right>
    typealias After = RecordReading<PhaseLawProbe1<W.Right>>
    typealias Path = FollowedPair<FollowedPair<Before, Move>,
        StepBeside<After, Before.Right.Right>>
    typealias Left = Path.Right.Left.Right
    typealias Right = Path.Right.Right
}
#endif

#if LOCAL_PHASE_PARTNER_IDENTIFIES_FRAME
enum RejectedPartnerIdentifiesFrame: Null {
    typealias A = RoutingAddress00
    typealias B = RoutingAddress01
    typealias C = RoutingAddress10
    typealias D = RoutingAddress11
    typealias Left = PartnerProbe<A, B, C, D>.CurrentTable.Left
    typealias Right = PartnerProbe<A, B, D, C>.CurrentTable.Left
}
#endif

#if LOCAL_PHASE_PARTNER_ARBITRARY_INPUTS
enum RejectedPartnerArbitraryInputs: Null {
    typealias F = PartnerProbeActions<RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11>
    typealias Left = F.PThenZ.Right
    typealias Right = F.ZThenP.Right
}
#endif

#if LOCAL_PHASE_PARTNER_FREEZES_SOURCE
enum RejectedPartnerFreezesSource: Null {
    typealias P = PartnerProbe<RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11>
    typealias Left = P.CurrentTable.Left
    typealias Right = P.Run.Left.Left
}
#endif
