import VerificationIsIdentification

/// M64b: changing both connection outputs through H conjugates their
/// relative law. H here exchanges slots 0/1; H W H is the actual word,
/// whose full payload action is P, not W.
public enum PhaseFrameDrift<A: Structure, B: Structure, C: Structure,
    D: Structure, R: Structure>: Close {
    public typealias H = FourLeafPhase0<A, B, C, D>
    public typealias Middle = FourLeafPhaseWord<B, A, C, D>
    public typealias Last = FourLeafPhase0<D, A, B, C>
    public typealias Crossed = StepBeside<FollowedPair<FollowedPair<H, Middle>, Last>, R>
    public typealias Original = StepBeside<FourLeafPhaseWord<A, B, C, D>, R>
    public typealias Changed = StepBeside<PhaseWordCatalogue<A, B, C, D>.WZW, R>

    public enum Conjugated: Null {
        public typealias Left = Paired<Crossed.Left, Crossed.Right>
        public typealias Right = Paired<Changed.Left, Changed.Right>
    }

    // A common change by W itself preserves the relative law W:
    // first W^-1=WW, then W, then W is four actual W contacts.
    public typealias WW = PhaseWordCatalogue<A, B, C, D>.WW
    public typealias Third = FourLeafPhaseWord<C, B, D, A>
    public typealias Fourth = FourLeafPhaseWord<A, B, C, D>
    public typealias Commuting = StepBeside<
        FollowedPair<FollowedPair<WW, Third>, Fourth>, R>
    public enum Preserved: Null {
        public typealias Left = Paired<Commuting.Left, Commuting.Right>
        public typealias Right = Paired<Original.Left, Original.Right>
    }

    // First acquire marker B at output 1 before the common change; then
    // marker C at output 3 after it. Both true facts fit the old even law W,
    // although the current relative law is Changed. The fields here are
    // actual path outputs; this is not a resident recording construction.
    public enum MixedFacts: Null {
        public typealias Left = Paired<Original.Right.Left.Left.Right,
            Crossed.Right.Left.Right.Right>
        public typealias Right = Paired<Original.Right.Left.Left.Right,
            Original.Right.Left.Right.Right>
    }
}
