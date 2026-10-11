import VerificationIsIdentification
import Examples

// All current answers and all retained initial answers come from the actual
// two-probe paths. The decoder's expected values are actual catalogue addresses.
enum FourLeafAllAcquiredLaws: Null {
    typealias F = FourLeafAcquiredLaw
    typealias Left = Paired<Paired<Paired<Paired<Paired<F.I.Answer, F.I.RetainedInitialLaw.Right>, Paired<F.W.Answer, F.W.RetainedInitialLaw.Right>>, Paired<F.WW.Answer, F.WW.RetainedInitialLaw.Right>>, Paired<Paired<Paired<F.Z.Answer, F.Z.RetainedInitialLaw.Right>, Paired<F.ZW.Answer, F.ZW.RetainedInitialLaw.Right>>, Paired<F.ZWW.Answer, F.ZWW.RetainedInitialLaw.Right>>>, Paired<Paired<Paired<Paired<F.WZ.Answer, F.WZ.RetainedInitialLaw.Right>, Paired<F.WZW.Answer, F.WZW.RetainedInitialLaw.Right>>, Paired<F.WZWW.Answer, F.WZWW.RetainedInitialLaw.Right>>, Paired<Paired<Paired<F.WWZ.Answer, F.WWZ.RetainedInitialLaw.Right>, Paired<F.WWZW.Answer, F.WWZW.RetainedInitialLaw.Right>>, Paired<F.WWZWW.Answer, F.WWZWW.RetainedInitialLaw.Right>>>>
    typealias Right = Paired<Paired<Paired<Paired<Paired<FourLeafLawAddresses.I, FourLeafLawAddresses.I>, Paired<FourLeafLawAddresses.W, FourLeafLawAddresses.W>>, Paired<FourLeafLawAddresses.WW, FourLeafLawAddresses.WW>>, Paired<Paired<Paired<FourLeafLawAddresses.Z, FourLeafLawAddresses.Z>, Paired<FourLeafLawAddresses.ZW, FourLeafLawAddresses.ZW>>, Paired<FourLeafLawAddresses.ZWW, FourLeafLawAddresses.ZWW>>>, Paired<Paired<Paired<Paired<FourLeafLawAddresses.WZ, FourLeafLawAddresses.WZ>, Paired<FourLeafLawAddresses.WZW, FourLeafLawAddresses.WZW>>, Paired<FourLeafLawAddresses.WZWW, FourLeafLawAddresses.WZWW>>, Paired<Paired<Paired<FourLeafLawAddresses.WWZ, FourLeafLawAddresses.WWZ>, Paired<FourLeafLawAddresses.WWZW, FourLeafLawAddresses.WWZW>>, Paired<FourLeafLawAddresses.WWZWW, FourLeafLawAddresses.WWZWW>>>>
}

enum FourLeafOneFactQuestion: Null {
    typealias F = FourLeafAcquiredLaw
    typealias Q = F.I.Observation.Answer.Left.Left.Predicate
    typealias Left = Paired<Paired<Paired<Paired<Paired<F.I.Observation.Answer.Left.Left.Predicate, F.I.Observation.Answer.Left.Right.Predicate>, Paired<F.W.Observation.Answer.Left.Left.Predicate, F.W.Observation.Answer.Left.Right.Predicate>>, Paired<F.WW.Observation.Answer.Left.Left.Predicate, F.WW.Observation.Answer.Left.Right.Predicate>>, Paired<Paired<Paired<F.Z.Observation.Answer.Left.Left.Predicate, F.Z.Observation.Answer.Left.Right.Predicate>, Paired<F.ZW.Observation.Answer.Left.Left.Predicate, F.ZW.Observation.Answer.Left.Right.Predicate>>, Paired<F.ZWW.Observation.Answer.Left.Left.Predicate, F.ZWW.Observation.Answer.Left.Right.Predicate>>>, Paired<Paired<Paired<Paired<F.WZ.Observation.Answer.Left.Left.Predicate, F.WZ.Observation.Answer.Left.Right.Predicate>, Paired<F.WZW.Observation.Answer.Left.Left.Predicate, F.WZW.Observation.Answer.Left.Right.Predicate>>, Paired<F.WZWW.Observation.Answer.Left.Left.Predicate, F.WZWW.Observation.Answer.Left.Right.Predicate>>, Paired<Paired<Paired<F.WWZ.Observation.Answer.Left.Left.Predicate, F.WWZ.Observation.Answer.Left.Right.Predicate>, Paired<F.WWZW.Observation.Answer.Left.Left.Predicate, F.WWZW.Observation.Answer.Left.Right.Predicate>>, Paired<F.WWZWW.Observation.Answer.Left.Left.Predicate, F.WWZWW.Observation.Answer.Left.Right.Predicate>>>>
    typealias Right = Paired<Paired<Paired<Paired<Paired<Q, Q>, Paired<Q, Q>>, Paired<Q, Q>>, Paired<Paired<Paired<Q, Q>, Paired<Q, Q>>, Paired<Q, Q>>>, Paired<Paired<Paired<Paired<Q, Q>, Paired<Q, Q>>, Paired<Q, Q>>, Paired<Paired<Paired<Q, Q>, Paired<Q, Q>>, Paired<Q, Q>>>>
}

// A replacement second law can give the same visible fact. That alone does
// not permit it to replace the retained law at the actual focus boundary.
enum FourLeafChangedSecondLawSameFact: Null {
    typealias Second = FourLeafSecondProbe<FourLeafTwoProbe.FocusI.OutputLab>
    typealias Left = Second.I.Answer.Right
    typealias Right = Second.W.Answer.Right
}

enum FourLeafDiagonalIsNoLaw: Null {
    typealias F = FourLeafAcquiredLaw.I.Observation.Answer.Left.Left
    typealias Input = Paired<Paired<F, F>, FourLeafReplyTable>
    typealias Decode = FourLeafReplyDecoder<Input, Route00<FourLeafReplyTable>,
        Route00<FourLeafReplyTable.Row0>>
    typealias Left = Decode.Answer
    typealias Right = Never
}

#if LOCAL_PHASE_REPLACES_SECOND_LAW
enum RejectedFourLeafChangedSecondLaw: Pair {
    typealias Next = FourLeafSecondProbe<FourLeafTwoProbe.FocusI.OutputLab>.W
    typealias Path = FollowedPair<FourLeafTwoProbe.FocusI, Next>
    typealias Left = Path.Left
    typealias Right = Path.Right
}
#endif

#if LOCAL_PHASE_DECODER_WRONG_ROW
enum RejectedFourLeafDecoderRow: Pair {
    typealias Input = FourLeafAcquiredLaw.I.Observation.Answer
    typealias Decode = FourLeafReplyDecoder<Input, Route01<FourLeafReplyTable>,
        Route01<FourLeafReplyTable.Row1>>
    typealias Left = Decode.Left
    typealias Right = Decode.Answer
}
#endif

#if LOCAL_PHASE_DIAGONAL_IS_LAW
enum RejectedFourLeafDiagonalLaw: Null {
    typealias Left = FourLeafDiagonalIsNoLaw.Decode.Answer
    typealias Right = FourLeafLawAddresses.I
}
#endif

