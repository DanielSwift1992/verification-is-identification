import VerificationIsIdentification

/// VC100q: actual complete paths for four decreasing word replacements.
/// P retains its seven original contacts through PrimitivePhaseReturnCore;
/// no rewrite is admitted merely from a name or from a projected phase.
public enum PhaseBasisReduction<A: Structure, B: Structure, C: Structure,
    D: Structure, R: Structure>: Close {
    public typealias Profile = PhaseBasisProfile<A, B, C, D, R>
    public typealias AfterP = PrimitivePhaseReturnCore<A, D, B, C>
    public typealias AfterPW = PrimitivePhaseReturnCore<C, D, A, B>
    public typealias AfterPWW = PrimitivePhaseReturnCore<B, D, C, A>

    public enum Zero: Close {
        public typealias V = Profile.Zero
        public typealias WWW = FollowedPair<V.WW,
            WorkingPhaseW<C, B, D, A, PhaseBridgeClock.Zero, R>>
        public typealias PP = FollowedPair<V.Row0.I, StepBeside<AfterP.AtZero, R>>
        public typealias PWP = FollowedPair<V.Row0.W, StepBeside<AfterPW.AtZero, R>>
        public typealias PWWP = FollowedPair<V.Row0.WW, StepBeside<AfterPWW.AtZero, R>>
        public typealias Long = Paired<Paired<WWW.Left, WWW.Right>,
            Paired<Paired<PP.Left, PP.Right>,
                Paired<Paired<PWP.Left, PWP.Right>, Paired<PWWP.Left, PWWP.Right>>>>
        public typealias Short = Paired<Paired<V.I.Left, V.I.Right>,
            Paired<Paired<V.Row1.W.Left, V.Row1.W.Right>,
                Paired<Paired<V.WW.Left, V.WW.Right>,
                    Paired<V.Row2.WW.Left, V.Row2.WW.Right>>>>
        public enum Endpoints: Null {
            public typealias Left = Long
            public typealias Right = Short
        }
    }

    public enum One: Close {
        public typealias V = Profile.One
        public typealias WWW = FollowedPair<V.WW,
            WorkingPhaseW<C, B, D, A, PhaseBridgeClock.One, R>>
        public typealias PP = FollowedPair<V.Row0.I, StepBeside<AfterP.AtOne, R>>
        public typealias PWP = FollowedPair<V.Row0.W, StepBeside<AfterPW.AtOne, R>>
        public typealias PWWP = FollowedPair<V.Row0.WW, StepBeside<AfterPWW.AtOne, R>>
        public typealias Long = Paired<Paired<WWW.Left, WWW.Right>,
            Paired<Paired<PP.Left, PP.Right>,
                Paired<Paired<PWP.Left, PWP.Right>, Paired<PWWP.Left, PWWP.Right>>>>
        public typealias Short = Paired<Paired<V.I.Left, V.I.Right>,
            Paired<Paired<V.Row1.W.Left, V.Row1.W.Right>,
                Paired<Paired<V.WW.Left, V.WW.Right>,
                    Paired<V.Row2.WW.Left, V.Row2.WW.Right>>>>
        public enum Endpoints: Null {
            public typealias Left = Long
            public typealias Right = Short
        }
    }

    public enum Two: Close {
        public typealias V = Profile.Two
        public typealias WWW = FollowedPair<V.WW,
            WorkingPhaseW<C, B, D, A, PhaseBridgeClock.Two, R>>
        public typealias PP = FollowedPair<V.Row0.I, StepBeside<AfterP.AtTwo, R>>
        public typealias PWP = FollowedPair<V.Row0.W, StepBeside<AfterPW.AtTwo, R>>
        public typealias PWWP = FollowedPair<V.Row0.WW, StepBeside<AfterPWW.AtTwo, R>>
        public typealias Long = Paired<Paired<WWW.Left, WWW.Right>,
            Paired<Paired<PP.Left, PP.Right>,
                Paired<Paired<PWP.Left, PWP.Right>, Paired<PWWP.Left, PWWP.Right>>>>
        public typealias Short = Paired<Paired<V.I.Left, V.I.Right>,
            Paired<Paired<V.Row1.W.Left, V.Row1.W.Right>,
                Paired<Paired<V.WW.Left, V.WW.Right>,
                    Paired<V.Row2.WW.Left, V.Row2.WW.Right>>>>
        public enum Endpoints: Null {
            public typealias Left = Long
            public typealias Right = Short
        }
    }
}

/// Replace an established application inside an actual prefix and suffix.
/// Only the replacement's own full endpoints and the old seams are supplied.
/// The new seams and equality of the two complete applications are derived.
/// This claims no equality of contact histories or intermediate readings.
public enum EndpointSubstitution<Before: Pair, F: Pair, G: Pair, After: Pair>: Null
where Before.Left: Structure, After.Right: Structure,
      Before.Right == F.Left, F.Left == G.Left,
      F.Right == G.Right, F.Right == After.Left {
    public typealias Original = FollowedPair<FollowedPair<Before, F>, After>
    public typealias Replacement = FollowedPair<FollowedPair<Before, G>, After>
    public typealias Left = Paired<Original.Left, Original.Right>
    public typealias Right = Paired<Replacement.Left, Replacement.Right>
}
