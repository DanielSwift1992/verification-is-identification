import VerificationIsIdentification
import Examples

// VC100c: check the value decoder against the already derived word actions.
// Each decoder receives one actual first-probe fact and the supplied value
// table. No second fact or unknown law address is an input. This checks the
// question-specific factor at the interface, not a new resident installation.
enum FourLeafOneFactValue<A: Structure, B: Structure>: Null {
    typealias P = FourLeafFirstProbe<Never>
    typealias Actions = PhaseWordCatalogue<A, B, B, B>
    typealias Table = BoundaryWorking<
        BoundaryWorking<A, B, B, B>, BoundaryWorking<B, A, B, B>,
        BoundaryWorking<B, B, A, B>, BoundaryWorking<B, B, B, A>>
    typealias I = SequentialReading<ReadingBesideInput<ReadRecordedAnswer<P.I.Answer.Right>, Table>, Route00<Table>>
    typealias W = SequentialReading<ReadingBesideInput<ReadRecordedAnswer<P.W.Answer.Right>, Table>, Route10<Table>>
    typealias WW = SequentialReading<ReadingBesideInput<ReadRecordedAnswer<P.WW.Answer.Right>, Table>, Route11<Table>>
    typealias Z = SequentialReading<ReadingBesideInput<ReadRecordedAnswer<P.Z.Answer.Right>, Table>, Route01<Table>>
    typealias ZW = SequentialReading<ReadingBesideInput<ReadRecordedAnswer<P.ZW.Answer.Right>, Table>, Route01<Table>>
    typealias ZWW = SequentialReading<ReadingBesideInput<ReadRecordedAnswer<P.ZWW.Answer.Right>, Table>, Route01<Table>>
    typealias WZ = SequentialReading<ReadingBesideInput<ReadRecordedAnswer<P.WZ.Answer.Right>, Table>, Route11<Table>>
    typealias WZW = SequentialReading<ReadingBesideInput<ReadRecordedAnswer<P.WZW.Answer.Right>, Table>, Route00<Table>>
    typealias WZWW = SequentialReading<ReadingBesideInput<ReadRecordedAnswer<P.WZWW.Answer.Right>, Table>, Route10<Table>>
    typealias WWZ = SequentialReading<ReadingBesideInput<ReadRecordedAnswer<P.WWZ.Answer.Right>, Table>, Route10<Table>>
    typealias WWZW = SequentialReading<ReadingBesideInput<ReadRecordedAnswer<P.WWZW.Answer.Right>, Table>, Route11<Table>>
    typealias WWZWW = SequentialReading<ReadingBesideInput<ReadRecordedAnswer<P.WWZWW.Answer.Right>, Table>, Route00<Table>>
    typealias Left = BoundaryWorking<Paired<I.Answer, Paired<W.Answer, WW.Answer>>, Paired<Z.Answer, Paired<ZW.Answer, ZWW.Answer>>, Paired<WZ.Answer, Paired<WZW.Answer, WZWW.Answer>>, Paired<WWZ.Answer, Paired<WWZW.Answer, WWZWW.Answer>>>
    typealias Right = BoundaryWorking<Paired<Actions.I.Right, Paired<Actions.W.Right, Actions.WW.Right>>, Paired<Actions.Z.Right, Paired<Actions.ZW.Right, Actions.ZWW.Right>>, Paired<Actions.WZ.Right, Paired<Actions.WZW.Right, Actions.WZWW.Right>>, Paired<Actions.WWZ.Right, Paired<Actions.WWZW.Right, Actions.WWZWW.Right>>>
}

// These complete acquired facts agree although the whole laws differ.
enum FourLeafOneFactDoesNotIdentifyLaw: Null {
    typealias P = FourLeafFirstProbe<Never>
    typealias Left = P.I.Answer.Right
    typealias Right = P.WZW.Answer.Right
}

#if LOCAL_PHASE_VALUE_WRONG_ROW
enum RejectedOneFactValueRow: Pair {
    typealias P = FourLeafOneFactValue<Never, Lit1>
    typealias Wrong = SequentialReading<
        ReadingBesideInput<ReadRecordedAnswer<P.P.I.Answer.Right>, P.Table>,
        Route01<P.Table>>
    typealias Left = Wrong.Left
    typealias Right = Wrong.Answer
}
#endif

#if LOCAL_PHASE_VALUE_IS_WHOLE_LAW
enum RejectedOneFactWholeLaw: Null {
    typealias Actions = PhaseWordCatalogue<RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11>
    typealias Left = Actions.I.Right
    typealias Right = Actions.WZW.Right
}
#endif
