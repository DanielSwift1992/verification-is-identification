import VerificationIsIdentification
import Examples

// Independently existing phase catalogue in the order I,W,WW; P,PW,PWW;
// WP,WPW,WPWW; WWP,WWPW,WWPWW. The actual clock and context are retained.
enum PhaseBasisExpected<A: Structure, B: Structure, C: Structure, D: Structure,
    K: Structure, R: Structure>: Close {
    typealias V = PhaseWordCatalogue<A, B, C, D>
    typealias Pure = Paired<Paired<Paired<V.I.Right, K>, R>,
        Paired<Paired<Paired<V.W.Right, K>, R>, Paired<Paired<V.WW.Right, K>, R>>>
    typealias Row0 = Paired<Paired<Paired<V.WZW.Right, K>, R>,
        Paired<Paired<Paired<V.WZWW.Right, K>, R>, Paired<Paired<V.WZ.Right, K>, R>>>
    typealias Row1 = Paired<Paired<Paired<V.WWZW.Right, K>, R>,
        Paired<Paired<Paired<V.WWZWW.Right, K>, R>, Paired<Paired<V.WWZ.Right, K>, R>>>
    typealias Row2 = Paired<Paired<Paired<V.ZW.Right, K>, R>,
        Paired<Paired<Paired<V.ZWW.Right, K>, R>, Paired<Paired<V.Z.Right, K>, R>>>
    typealias Answers = Paired<Pure, Paired<Row0, Paired<Row1, Row2>>>
    typealias Source = Paired<Paired<V.Initial, K>, R>
    typealias Starts = Paired<Source, Paired<Source, Source>>
}

#if !LOCAL_PHASE_BASIS_MERGES_EQUAL_COST && !LOCAL_PHASE_BASIS_REUSES_UNTRANSFORMED_SOURCE
enum PhaseBasisAllAnswers<A: Structure, B: Structure, C: Structure,
    D: Structure, R: Structure>: Null {
    typealias P = PhaseBasisProfile<A, B, C, D, R>
    typealias Left = Paired<P.Zero.Answers, Paired<P.One.Answers, P.Two.Answers>>
    typealias Right = Paired<PhaseBasisExpected<A, B, C, D, PhaseBridgeClock.Zero, R>.Answers,
        Paired<PhaseBasisExpected<A, B, C, D, PhaseBridgeClock.One, R>.Answers,
            PhaseBasisExpected<A, B, C, D, PhaseBridgeClock.Two, R>.Answers>>
}

enum PhaseBasisCommonSource<A: Structure, B: Structure, C: Structure,
    D: Structure, R: Structure>: Null {
    typealias P = PhaseBasisProfile<A, B, C, D, R>
    typealias Left = Paired<P.Zero.Starts, Paired<P.One.Starts, P.Two.Starts>>
    typealias Right = Paired<PhaseBasisExpected<A, B, C, D, PhaseBridgeClock.Zero, R>.Starts,
        Paired<PhaseBasisExpected<A, B, C, D, PhaseBridgeClock.One, R>.Starts,
            PhaseBasisExpected<A, B, C, D, PhaseBridgeClock.Two, R>.Starts>>
}

// An optimal basis does not make arbitrary concatenations optimal:
// two P calls cost 14, while W P W has the same full endpoint and costs 9.
enum PhaseBasisComposedReduction<A: Structure, B: Structure, C: Structure,
    D: Structure, R: Structure>: Null {
    typealias First = PrimitivePhaseReturnCore<A, B, C, D>
    typealias Second = PrimitivePhaseReturnCore<A, D, B, C>
    typealias Zero = FollowedPair<StepBeside<First.AtZero, R>, StepBeside<Second.AtZero, R>>
    typealias One = FollowedPair<StepBeside<First.AtOne, R>, StepBeside<Second.AtOne, R>>
    typealias Two = FollowedPair<StepBeside<First.AtTwo, R>, StepBeside<Second.AtTwo, R>>
    typealias Profile = PhaseBasisProfile<A, B, C, D, R>
    typealias Left = Paired<Zero.Right, Paired<One.Right, Two.Right>>
    typealias Right = Paired<Profile.Zero.Row1.W.Right,
        Paired<Profile.One.Row1.W.Right, Profile.Two.Row1.W.Right>>
}
#endif

enum PhaseBasisFixture: Close {
    typealias A = RoutingAddress00
    typealias B = RoutingAddress01
    typealias C = RoutingAddress10
    typealias D = RoutingAddress11
    typealias P = PhaseBasisProfile<A, B, C, D, Never>
}

#if LOCAL_PHASE_BASIS_MERGES_EQUAL_COST
enum RejectedPhaseBasisEqualCostAsEqualAction: Null {
    typealias P = PhaseBasisFixture.P.Zero
    typealias Left = P.Row0.W.Right
    typealias Right = P.Row1.I.Right
}
#endif

#if LOCAL_PHASE_BASIS_REUSES_UNTRANSFORMED_SOURCE
enum RejectedPhaseBasisOldPrefixSource: Pair {
    typealias F = PhaseBasisFixture
    typealias P = PrimitivePhaseReturnCore<F.A, F.B, F.C, F.D>
    typealias Path = FollowedPair<F.P.Zero.W, StepBeside<P.AtZero, Never>>
    typealias Left = Path.Left
    typealias Right = Path.Right
}
#endif
