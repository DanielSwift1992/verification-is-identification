import VerificationIsIdentification
import Examples

// Every stage and phase entry is checked under all three column involutions.
// Their products therefore cover all twelve stage/phase pairs, independently
// of the payload; the operations are the existing PairedApplication constructor.
enum StarStageColumnsReturn: Null {
    typealias S = LocalStarStage
    typealias Left = Paired<
        Paired<LocalStarColumn0<LocalStarColumn0<S.Center>.Answer>.Answer,
            Paired<LocalStarColumn0<LocalStarColumn0<S.A>.Answer>.Answer,
            Paired<LocalStarColumn0<LocalStarColumn0<S.B>.Answer>.Answer,
                LocalStarColumn0<LocalStarColumn0<S.C>.Answer>.Answer>>>,
        Paired<Paired<LocalStarColumn1<LocalStarColumn1<S.Center>.Answer>.Answer,
            Paired<LocalStarColumn1<LocalStarColumn1<S.A>.Answer>.Answer,
            Paired<LocalStarColumn1<LocalStarColumn1<S.B>.Answer>.Answer,
                LocalStarColumn1<LocalStarColumn1<S.C>.Answer>.Answer>>>,
        Paired<LocalStarColumn2<LocalStarColumn2<S.Center>.Answer>.Answer,
            Paired<LocalStarColumn2<LocalStarColumn2<S.A>.Answer>.Answer,
            Paired<LocalStarColumn2<LocalStarColumn2<S.B>.Answer>.Answer,
                LocalStarColumn2<LocalStarColumn2<S.C>.Answer>.Answer>>>>>
    typealias All = Paired<S.Center, Paired<S.A, Paired<S.B, S.C>>>
    typealias Right = Paired<All, Paired<All, All>>
}

enum StarPhaseColumnsReturn: Null {
    typealias P = LocalStarPhase
    typealias Left = Paired<
        Paired<LocalStarColumn0<LocalStarColumn0<P.Zero>.Answer>.Answer,
            Paired<LocalStarColumn0<LocalStarColumn0<P.One>.Answer>.Answer,
                LocalStarColumn0<LocalStarColumn0<P.Two>.Answer>.Answer>>,
        Paired<Paired<LocalStarColumn1<LocalStarColumn1<P.Zero>.Answer>.Answer,
            Paired<LocalStarColumn1<LocalStarColumn1<P.One>.Answer>.Answer,
                LocalStarColumn1<LocalStarColumn1<P.Two>.Answer>.Answer>>,
        Paired<LocalStarColumn2<LocalStarColumn2<P.Zero>.Answer>.Answer,
            Paired<LocalStarColumn2<LocalStarColumn2<P.One>.Answer>.Answer,
                LocalStarColumn2<LocalStarColumn2<P.Two>.Answer>.Answer>>>>
    typealias All = Paired<P.Zero, Paired<P.One, P.Two>>
    typealias Right = Paired<All, Paired<All, All>>
}

// Every other stage involution fixes the omitted leaf. Since these are
// permutations, they also preserve its complement. All three actions must
// therefore occur in a complete exploration from the center.
enum StarEachLeafNeedsItsAction: Null {
    typealias S = LocalStarStage
    typealias Left = Paired<Paired<LocalStarColumn1<S.A>.Answer, LocalStarColumn2<S.A>.Answer>,
        Paired<Paired<LocalStarColumn0<S.B>.Answer, LocalStarColumn2<S.B>.Answer>,
            Paired<LocalStarColumn0<S.C>.Answer, LocalStarColumn1<S.C>.Answer>>>
    typealias Right = Paired<Paired<S.A, S.A>, Paired<Paired<S.B, S.B>, Paired<S.C, S.C>>>
}

enum StarCycleCoversTwelve<V: Structure>: Null {
    typealias S = LocalStarStage
    typealias P = LocalStarPhase
    typealias A = LocalStarRound<S.Center, V>
    typealias B = LocalStarRound<A.Answer.Left, V>
    typealias C = LocalStarRound<B.Answer.Left, V>
    typealias D = LocalStarRound<C.Answer.Left, V>
    typealias Path = SequentialReading<SequentialReading<SequentialReading<A, B>, C>, D>
    typealias Actual = Paired<Paired<A.First.Left, Paired<A.Second.Left, A.Third.Left>>,
        Paired<Paired<B.First.Left, Paired<B.Second.Left, B.Third.Left>>,
        Paired<Paired<C.First.Left, Paired<C.Second.Left, C.Third.Left>>,
            Paired<D.First.Left, Paired<D.Second.Left, D.Third.Left>>>>>
    typealias Expected = Paired<
        Paired<LocalPhaseWorld<S.Center, P.Zero, V>,
            Paired<LocalPhaseWorld<S.A, P.One, V>, LocalPhaseWorld<S.A, P.Two, V>>>,
        Paired<Paired<LocalPhaseWorld<S.A, P.Zero, V>,
            Paired<LocalPhaseWorld<S.Center, P.One, V>, LocalPhaseWorld<S.B, P.Two, V>>>,
        Paired<Paired<LocalPhaseWorld<S.B, P.Zero, V>,
            Paired<LocalPhaseWorld<S.B, P.One, V>, LocalPhaseWorld<S.Center, P.Two, V>>>,
        Paired<LocalPhaseWorld<S.C, P.Zero, V>,
            Paired<LocalPhaseWorld<S.C, P.One, V>, LocalPhaseWorld<S.C, P.Two, V>>>>>>
    typealias Left = Paired<Path.Answer, Actual>
    typealias Right = Paired<Path.Left, Expected>
}

// At an output phase 1/2/0, the inverse row selects operation 0/1/2.
// The twelve actual outputs are undone; the source is not a hidden input.
enum StarLocalInverseCoversTwelve<V: Structure>: Null {
    typealias R = StarCycleCoversTwelve<V>
    typealias A = R.A
    typealias B = R.B
    typealias C = R.C
    typealias D = R.D
    typealias Left = Paired<
        Paired<LocalStarStep0<A.First.Answer.Left, A.First.Answer.Right.Left, V>.Answer,
        Paired<LocalStarStep1<A.Second.Answer.Left, A.Second.Answer.Right.Left, V>.Answer,
            LocalStarStep2<A.Third.Answer.Left, A.Third.Answer.Right.Left, V>.Answer>>,
        Paired<Paired<LocalStarStep0<B.First.Answer.Left, B.First.Answer.Right.Left, V>.Answer,
        Paired<LocalStarStep1<B.Second.Answer.Left, B.Second.Answer.Right.Left, V>.Answer,
            LocalStarStep2<B.Third.Answer.Left, B.Third.Answer.Right.Left, V>.Answer>>,
        Paired<Paired<LocalStarStep0<C.First.Answer.Left, C.First.Answer.Right.Left, V>.Answer,
        Paired<LocalStarStep1<C.Second.Answer.Left, C.Second.Answer.Right.Left, V>.Answer,
            LocalStarStep2<C.Third.Answer.Left, C.Third.Answer.Right.Left, V>.Answer>>,
        Paired<LocalStarStep0<D.First.Answer.Left, D.First.Answer.Right.Left, V>.Answer,
        Paired<LocalStarStep1<D.Second.Answer.Left, D.Second.Answer.Right.Left, V>.Answer,
            LocalStarStep2<D.Third.Answer.Left, D.Third.Answer.Right.Left, V>.Answer>>>>>
    typealias Right = R.Actual
}

enum StarControlIgnoresStageAndPayload<S: Structure, T: Structure, C: Pair,
    A: Structure, B: Structure, J: Pair>: Null where C.Left: Structure {
    typealias Left = LocalStarInput<S, C, A, J>.Answer
    typealias Right = LocalStarInput<T, C, B, J>.Answer
}

enum StarSharesOriginalAnswerDecoder<V: Structure>: Null {
    typealias Star = LocalStarFindsOriginal<V>
    typealias Chain = LocalPhaseFindsOriginal<V>
    typealias Left = Paired<Star.Answer, Paired<Star.Observation.Answer, Star.Right>>
    typealias Right = Paired<Chain.Answer, Paired<Chain.Observation.Answer, Chain.Right>>
}

// Three independently read seeds are transported to each distinct leaf.
// Every decoder is an actual fixed return followed by the original projection.
// No finite-world or complete-state enumeration premise occurs in this witness.
enum StarTransportedSeeds<V: Structure>: Close {
    typealias S = LocalStarStage
    typealias P = LocalStarPhase
    typealias X0 = LocalPhaseWorld<S.Center, P.Zero, V>
    typealias X1 = LocalPhaseWorld<S.Center, P.One, V>
    typealias X2 = LocalPhaseWorld<S.Center, P.Two, V>
    typealias Q0 = LocalStarPhaseImage<X0>
    typealias Q1 = LocalStarPhaseImage<X1>
    typealias Q2 = LocalStarPhaseImage<X2>
    typealias A0 = LocalStarReturn0<X0>
    typealias A1 = LocalStarReturn0<X1>
    typealias A2 = LocalStarReturn0<X2>
    typealias B0 = LocalStarReturn1<X0>
    typealias B1 = LocalStarReturn1<X1>
    typealias B2 = LocalStarReturn1<X2>
    typealias C0 = LocalStarReturn2<X0>
    typealias C1 = LocalStarReturn2<X1>
    typealias C2 = LocalStarReturn2<X2>
    typealias FA0 = AnswerThroughReturn<Q0, A0, LocalStarReturn0<A0.Answer>>
    typealias FA1 = AnswerThroughReturn<Q1, A1, LocalStarReturn0<A1.Answer>>
    typealias FA2 = AnswerThroughReturn<Q2, A2, LocalStarReturn0<A2.Answer>>
    typealias FB0 = AnswerThroughReturn<Q0, B0, LocalStarReturn1<B0.Answer>>
    typealias FB1 = AnswerThroughReturn<Q1, B1, LocalStarReturn1<B1.Answer>>
    typealias FB2 = AnswerThroughReturn<Q2, B2, LocalStarReturn1<B2.Answer>>
    typealias FC0 = AnswerThroughReturn<Q0, C0, LocalStarReturn2<C0.Answer>>
    typealias FC1 = AnswerThroughReturn<Q1, C1, LocalStarReturn2<C1.Answer>>
    typealias FC2 = AnswerThroughReturn<Q2, C2, LocalStarReturn2<C2.Answer>>

    typealias ZeroOne = ZeroSuccessorBoundary<Q0, Q1, Never>
    typealias ZeroTwo = ZeroSuccessorBoundary<Q0, Q2, Lit1>
    typealias OneTwo = ZeroSuccessorBoundary<
        SecondEvidenceImage<Q1.Answer, BeamSpace, SaturationEncoding, SecondProjection>,
        SecondEvidenceImage<Q2.Answer, BeamSpace, SaturationEncoding, SecondProjection>, Never>

    enum Recovered: Null {
        typealias Triple = Paired<Q0.Answer, Paired<Q1.Answer, Q2.Answer>>
        typealias Left = Paired<Paired<FA0.Answer, Paired<FA1.Answer, FA2.Answer>>,
            Paired<Paired<FB0.Answer, Paired<FB1.Answer, FB2.Answer>>,
                Paired<FC0.Answer, Paired<FC1.Answer, FC2.Answer>>>>
        typealias Right = Paired<Triple, Paired<Triple, Triple>>
    }

    enum DistinctStages: Null {
        typealias Three = Examples.Succ<Lit2>
        typealias Left = Paired<
            Paired<LocalStageImage<X0>.Answer, Paired<LocalStageImage<X1>.Answer, LocalStageImage<X2>.Answer>>,
            Paired<Paired<LocalStageImage<A0.Answer>.Answer,
                Paired<LocalStageImage<A1.Answer>.Answer, LocalStageImage<A2.Answer>.Answer>>,
            Paired<Paired<LocalStageImage<B0.Answer>.Answer,
                Paired<LocalStageImage<B1.Answer>.Answer, LocalStageImage<B2.Answer>.Answer>>,
                Paired<LocalStageImage<C0.Answer>.Answer,
                    Paired<LocalStageImage<C1.Answer>.Answer, LocalStageImage<C2.Answer>.Answer>>>>>
        typealias Right = Paired<Paired<Never, Paired<Never, Never>>,
            Paired<Paired<Lit1, Paired<Lit1, Lit1>>,
            Paired<Paired<Lit2, Paired<Lit2, Lit2>>,
                Paired<Three, Paired<Three, Three>>>>>
    }
}

// Word 0,1,0 returns to the center but changes phase zero to two. The empty
// word from seed two reaches the same working carrier with another original
// phase. A changing path's resident control is included separately below.
enum StarUnknownReturnPath<V: Structure>: Null {
    typealias Seeds = StarTransportedSeeds<V>
    typealias A = LocalStarReturn0<Seeds.X0>
    typealias B = LocalStarReturn1<A.Answer>
    typealias C = LocalStarReturn0<B.Answer>
    typealias Path = SequentialReading<SequentialReading<A, B>, C>
    typealias Left = Path.Answer
    typealias Right = Seeds.X2
    typealias Obstruction = ZeroSuccessorBoundary<Seeds.Q0, Seeds.Q2, Lit1>
}

// Two center-based words exchange phases 0/2 and 0/1. These actual returns
// connect all three seeds for a fixed payload; neither word changes V.
enum StarReturnLoopsConnectSeeds<V: Structure>: Null {
    typealias Seeds = StarTransportedSeeds<V>
    typealias M0 = LocalStarReturn1<Seeds.A0.Answer>
    typealias M1 = LocalStarReturn1<Seeds.A1.Answer>
    typealias M2 = LocalStarReturn1<Seeds.A2.Answer>
    typealias N0 = LocalStarReturn2<Seeds.B0.Answer>
    typealias N1 = LocalStarReturn2<Seeds.B1.Answer>
    typealias N2 = LocalStarReturn2<Seeds.B2.Answer>
    typealias Left = Paired<
        Paired<LocalStarReturn0<M0.Answer>.Answer,
            Paired<LocalStarReturn0<M1.Answer>.Answer, LocalStarReturn0<M2.Answer>.Answer>>,
        Paired<LocalStarReturn1<N0.Answer>.Answer,
            Paired<LocalStarReturn1<N1.Answer>.Answer, LocalStarReturn1<N2.Answer>.Answer>>>
    typealias Right = Paired<Paired<Seeds.X2, Paired<Seeds.X1, Seeds.X0>>,
        Paired<Seeds.X1, Paired<Seeds.X0, Seeds.X2>>>
}

// The commands reside in the actual source and consumed heads remain there.
// Erasing control from the observation merges these final working images;
// their complete resident configurations have not been identified.
enum StarResidentUnknownPath<V: Structure>: Null {
    typealias Loop = StarUnknownReturnPath<V>
    typealias Tape = Paired<LocalStarTable.Left,
        Paired<LocalStarTable.Right.Left, Paired<LocalStarTable.Left, Never>>>
    typealias First = ResidentBoundaryCommand<Loop.A, Tape, Never>
    typealias Second = ResidentBoundaryCommand<Loop.B,
        First.Answer.Right.Left, First.Answer.Right.Right>
    typealias Third = ResidentBoundaryCommand<Loop.C,
        Second.Answer.Right.Left, Second.Answer.Right.Right>
    typealias Path = SequentialReading<SequentialReading<First, Second>, Third>
    typealias Idle = Paired<Loop.Seeds.X2, Paired<Never, Never>>
    typealias Left = FirstEvidenceImage<Path.Answer,
        BeamSpace, SaturationEncoding, FirstProjection>.Answer
    typealias Right = FirstEvidenceImage<Idle,
        BeamSpace, SaturationEncoding, FirstProjection>.Answer

    enum RetainsConsumedCommands: Null {
        typealias Left = Path.Answer.Right
        typealias Right = Paired<Never, Tape>
    }

    typealias Initial = FirstEvidenceImage<Path.Left,
        BeamSpace, SaturationEncoding, FirstProjection>
    typealias Original = DecodeRefinedEvidence<Initial, LocalStarPhaseImage<Initial.Answer>>
    typealias IdleWorking = FirstEvidenceImage<Idle,
        BeamSpace, SaturationEncoding, FirstProjection>
    typealias IdleOriginal = DecodeRefinedEvidence<IdleWorking, LocalStarPhaseImage<IdleWorking.Answer>>
    typealias Obstruction = ZeroSuccessorBoundary<Original, IdleOriginal, Lit1>
}

#if LOCAL_PHASE_STAR_FORGETS_RETURN_PATH
enum RejectedStarUnknownPathDecoder: Null {
    typealias SameInput = StarResidentUnknownPath<Never>
    typealias Left = SameInput.Original.Answer
    typealias Right = SameInput.IdleOriginal.Answer
}
#endif

#if LOCAL_PHASE_STAR_READS_CURRENT_AS_ORIGINAL
enum RejectedStarCurrentPhase: Null {
    typealias Seeds = StarTransportedSeeds<Never>
    typealias Left = LocalStarPhaseImage<Seeds.A0.Answer>.Answer
    typealias Right = Seeds.Q0.Answer
}
#endif

#if LOCAL_PHASE_STAR_USES_FORWARD_INVERSE
enum RejectedStarForwardInverse: Null {
    typealias Start = LocalStarControls<LocalStarStage.Center, Never>.First
    typealias Wrong = LocalStarControls<Start.Answer.Left, Never>.Second
    typealias Path = SequentialReading<Start, Wrong>
    typealias Left = Path.Answer
    typealias Right = Path.Left
}
#endif

#if LOCAL_PHASE_STAR_HAS_FREE_CLOCK
// The second operation fixes phase zero. The selected forward policy is
// what causes cyclic phase advance; there is no independent clock transition.
enum RejectedStarIndependentClock: Null {
    typealias Step = LocalStarStep1<LocalStarStage.Center, LocalStarPhase.Zero, Never>
    typealias Left = Step.Answer.Right.Left
    typealias Right = LocalStarPhase.One
}
#endif
