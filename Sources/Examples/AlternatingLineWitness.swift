import VerificationIsIdentification

/// The actual word (A0 A1)^3 at leaf0. Its stage returns while its phase
/// crosses one edge of matching1. The phase is part of the source throughout.
public enum AlternatingLineReturn<J: IntegerValued, K: Structure>: PredicateReading {
    public typealias P = AlternatingPhaseCell<J>
    public typealias IE = IdentityReading<P.Even, BeamSpace, SaturationEncoding>
    public typealias IO = IdentityReading<P.Odd, BeamSpace, SaturationEncoding>
    public typealias S0 = PairedApplication<FourLeafStage0<Never, Lit1, Never, Never, Never>,
        ExperimentReadingBeside<IE, K>>
    public typealias S1 = PairedApplication<FourLeafStage1<Lit1, Never, Never, Never, Never>,
        ExperimentReadingBeside<P.WithinUp, K>>
    public typealias S2 = PairedApplication<FourLeafStage0<Never, Never, Lit1, Never, Never>,
        ExperimentReadingBeside<IO, K>>
    public typealias S3 = PairedApplication<FourLeafStage1<Never, Never, Lit1, Never, Never>,
        ExperimentReadingBeside<P.WithinDown, K>>
    public typealias S4 = PairedApplication<FourLeafStage0<Lit1, Never, Never, Never, Never>,
        ExperimentReadingBeside<IE, K>>
    public typealias S5 = PairedApplication<FourLeafStage1<Never, Lit1, Never, Never, Never>,
        ExperimentReadingBeside<P.WithinUp, K>>
    public typealias Actual = FollowedPair<FollowedPair<FollowedPair<S0, S1>, S2>,
        FollowedPair<FollowedPair<S3, S4>, S5>>
    public typealias Left = Actual.Left
    public typealias Right = Actual.Answer
    public typealias Sigma = Actual.Sigma
    public typealias Encoding = Actual.Encoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
    public enum StageReturns: Null {
        public typealias Left = AlternatingLineReturn.Left.Left
        public typealias Right = AlternatingLineReturn.Right.Left
    }
    public enum PhaseMoves: Null {
        public typealias Left = AlternatingLineReturn.Right.Right.Left
        public typealias Right = P.Odd
    }
}

/// After the return at the bottom, the same selected trajectory starts one
/// phase later. Twenty-four U contacts now reach center, while the baseline
/// twenty-four contacts still read leaf0. The actual common U consists of
/// the main cycle and the declared completion rows, not an arbitrary tag.
public enum AlternatingLineDelayedWitness<K: Structure>: Null {
    public typealias C = AlternatingLineTravel<K>
    public typealias R = AlternatingLineReturn<TwentyFivePhaseLine.J0, K>
    public typealias Tail = FollowedPair<FollowedPair<C.D1.Up, C.U1>,
        FollowedPair<FollowedPair<C.U2, C.U3>, FollowedPair<C.U4, C.U5>>>
    public typealias Changed = FollowedPair<
        FollowedPair<C.D0.UpSecond, Tail>, C.TopLeave>
    public typealias WithReturn = FollowedPair<R, Changed>
    public typealias Left = Paired<C.Up.Answer.Left, WithReturn.Answer.Left>
    public typealias Right = Paired<FourLeafStageLabels<Never, Lit1, Never, Never, Never>, FourLeafCenter>
}
