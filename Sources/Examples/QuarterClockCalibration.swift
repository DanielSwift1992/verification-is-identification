import VerificationIsIdentification

/// Opposite four-slot turns, both constructed from actual adjacent exchanges.
/// This is a reversible phase action whose square need not be identity.
public enum FourSlotTurn<A: Structure, B: Structure, C: Structure, D: Structure>: Close {
    public typealias Input = BoundaryWorking<A, B, C, D>
    public typealias Forward = FollowedPair<FourLeafPhase0<A, B, C, D>,
        FollowedPair<FourLeafPhase1<B, A, C, D>, FourLeafPhase2<B, C, A, D>>>
    public typealias Backward = FollowedPair<FourLeafPhase2<A, B, C, D>,
        FollowedPair<FourLeafPhase1<A, B, D, C>, FourLeafPhase0<A, D, B, C>>>
    public typealias DF = FollowedPair<Backward, FourSlotTurn<D, A, B, C>.Forward>
    public typealias FD = FollowedPair<Forward, FourSlotTurn<B, C, D, A>.Backward>
    public typealias DD = FollowedPair<Backward, FourSlotTurn<D, A, B, C>.Backward>
    public typealias DDDD = FollowedPair<DD, FourSlotTurn<C, D, A, B>.DD>
    public typealias DDDF = FollowedPair<DD, FollowedPair<
        FourSlotTurn<C, D, A, B>.Backward, FourSlotTurn<B, C, D, A>.Forward>>
    public enum Endpoints: Null {
        public typealias Left = BoundaryWorking<Forward.Answer, Backward.Answer, DD.Answer, DDDF.Answer>
        public typealias Right = BoundaryWorking<BoundaryWorking<B, C, D, A>,
            BoundaryWorking<D, A, B, C>, BoundaryWorking<C, D, A, B>, BoundaryWorking<C, D, A, B>>
    }
    public enum InversesAndPeriod: Null {
        public typealias Left = AddressTriple<DF.Answer, FD.Answer, DDDD.Answer>
        public typealias Right = AddressTriple<Input, Input, Input>
    }
}

/// Give contacts0,2,3 the backward turn and contact1 the forward turn.
/// These are the actual phase words in VC101's six return equations.
/// Their stage words separately return by VC101. The direct-product model
/// therefore satisfies those six equations but not the contact involutions.
public enum QuarterClockSixReturns<A: Structure, B: Structure, C: Structure, D: Structure>: Null {
    public typealias T = FourSlotTurn<A, B, C, D>
    public typealias Pair01 = FollowedPair<T.DF, FollowedPair<T.DF, T.DF>>
    public typealias Pair12 = FollowedPair<T.FD, FollowedPair<T.FD, T.FD>>
    public typealias Pair13 = Pair12
    public typealias Triple120 = FollowedPair<FollowedPair<T.FD, T.FD>, FollowedPair<T.FD, T.FD>>
    public typealias Triple230 = FollowedPair<T.DDDD, T.DDDD>
    public typealias Triple231 = FollowedPair<T.DDDF, FourSlotTurn<C, D, A, B>.DDDF>
    public typealias Left = Paired<AddressTriple<Pair01.Answer, Pair12.Answer, Pair13.Answer>,
        AddressTriple<Triple120.Answer, Triple230.Answer, Triple231.Answer>>
    public typealias Right = Paired<AddressTriple<T.Input, T.Input, T.Input>,
        AddressTriple<T.Input, T.Input, T.Input>>
}

/// Contact0 really returns the complete stage permutation after two uses,
/// while rotating the arbitrary phase labels halfway. No phase equality is
/// requested from the caller to turn this into a spurious full involution.
public enum QuarterClockDoubleContact<O: Structure, A: Structure, B: Structure,
    C: Structure, D: Structure, P: Structure, Q: Structure, R: Structure, S: Structure>: Null {
    public typealias First = PairedApplication<FourLeafStage0<O, A, B, C, D>,
        FourSlotTurn<P, Q, R, S>.Backward>
    public typealias Second = PairedApplication<FourLeafStage0<A, O, B, C, D>,
        FourSlotTurn<S, P, Q, R>.Backward>
    public typealias Actual = FollowedPair<First, Second>
    public typealias Left = Actual.Answer
    public typealias Right = Paired<FourLeafStageLabels<O, A, B, C, D>, BoundaryWorking<R, S, P, Q>>
}
