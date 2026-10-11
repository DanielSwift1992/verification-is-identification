import VerificationIsIdentification

/// All twenty-four explicitly supplied permutation tables. Each row runs
/// the same excursion and reads only its actual acquired facts.
public enum PhaseExcursionCalibration: Close {
    public typealias P0123 = PhaseExcursionDecision<
        RoutingAddress00, RoutingAddress01, RoutingAddress10, RoutingAddress11,
        Route00<PhaseOrientationTable>, Route11<PhaseOrientationTable.Row0>, Route10<Route11<PhaseOrientationTable.Row0>.Answer>>
    public typealias P0132 = PhaseExcursionDecision<
        RoutingAddress00, RoutingAddress01, RoutingAddress11, RoutingAddress10,
        Route00<PhaseOrientationTable>, Route10<PhaseOrientationTable.Row0>, Route11<Route10<PhaseOrientationTable.Row0>.Answer>>
    public typealias P0213 = PhaseExcursionDecision<
        RoutingAddress00, RoutingAddress10, RoutingAddress01, RoutingAddress11,
        Route00<PhaseOrientationTable>, Route11<PhaseOrientationTable.Row0>, Route01<Route11<PhaseOrientationTable.Row0>.Answer>>
    public typealias P0231 = PhaseExcursionDecision<
        RoutingAddress00, RoutingAddress10, RoutingAddress11, RoutingAddress01,
        Route00<PhaseOrientationTable>, Route01<PhaseOrientationTable.Row0>, Route11<Route01<PhaseOrientationTable.Row0>.Answer>>
    public typealias P0312 = PhaseExcursionDecision<
        RoutingAddress00, RoutingAddress11, RoutingAddress01, RoutingAddress10,
        Route00<PhaseOrientationTable>, Route10<PhaseOrientationTable.Row0>, Route01<Route10<PhaseOrientationTable.Row0>.Answer>>
    public typealias P0321 = PhaseExcursionDecision<
        RoutingAddress00, RoutingAddress11, RoutingAddress10, RoutingAddress01,
        Route00<PhaseOrientationTable>, Route01<PhaseOrientationTable.Row0>, Route10<Route01<PhaseOrientationTable.Row0>.Answer>>
    public typealias P1023 = PhaseExcursionDecision<
        RoutingAddress01, RoutingAddress00, RoutingAddress10, RoutingAddress11,
        Route01<PhaseOrientationTable>, Route11<PhaseOrientationTable.Row1>, Route10<Route11<PhaseOrientationTable.Row1>.Answer>>
    public typealias P1032 = PhaseExcursionDecision<
        RoutingAddress01, RoutingAddress00, RoutingAddress11, RoutingAddress10,
        Route01<PhaseOrientationTable>, Route10<PhaseOrientationTable.Row1>, Route11<Route10<PhaseOrientationTable.Row1>.Answer>>
    public typealias P1203 = PhaseExcursionDecision<
        RoutingAddress01, RoutingAddress10, RoutingAddress00, RoutingAddress11,
        Route01<PhaseOrientationTable>, Route11<PhaseOrientationTable.Row1>, Route00<Route11<PhaseOrientationTable.Row1>.Answer>>
    public typealias P1230 = PhaseExcursionDecision<
        RoutingAddress01, RoutingAddress10, RoutingAddress11, RoutingAddress00,
        Route01<PhaseOrientationTable>, Route00<PhaseOrientationTable.Row1>, Route11<Route00<PhaseOrientationTable.Row1>.Answer>>
    public typealias P1302 = PhaseExcursionDecision<
        RoutingAddress01, RoutingAddress11, RoutingAddress00, RoutingAddress10,
        Route01<PhaseOrientationTable>, Route10<PhaseOrientationTable.Row1>, Route00<Route10<PhaseOrientationTable.Row1>.Answer>>
    public typealias P1320 = PhaseExcursionDecision<
        RoutingAddress01, RoutingAddress11, RoutingAddress10, RoutingAddress00,
        Route01<PhaseOrientationTable>, Route00<PhaseOrientationTable.Row1>, Route10<Route00<PhaseOrientationTable.Row1>.Answer>>
    public typealias P2013 = PhaseExcursionDecision<
        RoutingAddress10, RoutingAddress00, RoutingAddress01, RoutingAddress11,
        Route10<PhaseOrientationTable>, Route11<PhaseOrientationTable.Row2>, Route01<Route11<PhaseOrientationTable.Row2>.Answer>>
    public typealias P2031 = PhaseExcursionDecision<
        RoutingAddress10, RoutingAddress00, RoutingAddress11, RoutingAddress01,
        Route10<PhaseOrientationTable>, Route01<PhaseOrientationTable.Row2>, Route11<Route01<PhaseOrientationTable.Row2>.Answer>>
    public typealias P2103 = PhaseExcursionDecision<
        RoutingAddress10, RoutingAddress01, RoutingAddress00, RoutingAddress11,
        Route10<PhaseOrientationTable>, Route11<PhaseOrientationTable.Row2>, Route00<Route11<PhaseOrientationTable.Row2>.Answer>>
    public typealias P2130 = PhaseExcursionDecision<
        RoutingAddress10, RoutingAddress01, RoutingAddress11, RoutingAddress00,
        Route10<PhaseOrientationTable>, Route00<PhaseOrientationTable.Row2>, Route11<Route00<PhaseOrientationTable.Row2>.Answer>>
    public typealias P2301 = PhaseExcursionDecision<
        RoutingAddress10, RoutingAddress11, RoutingAddress00, RoutingAddress01,
        Route10<PhaseOrientationTable>, Route01<PhaseOrientationTable.Row2>, Route00<Route01<PhaseOrientationTable.Row2>.Answer>>
    public typealias P2310 = PhaseExcursionDecision<
        RoutingAddress10, RoutingAddress11, RoutingAddress01, RoutingAddress00,
        Route10<PhaseOrientationTable>, Route00<PhaseOrientationTable.Row2>, Route01<Route00<PhaseOrientationTable.Row2>.Answer>>
    public typealias P3012 = PhaseExcursionDecision<
        RoutingAddress11, RoutingAddress00, RoutingAddress01, RoutingAddress10,
        Route11<PhaseOrientationTable>, Route10<PhaseOrientationTable.Row3>, Route01<Route10<PhaseOrientationTable.Row3>.Answer>>
    public typealias P3021 = PhaseExcursionDecision<
        RoutingAddress11, RoutingAddress00, RoutingAddress10, RoutingAddress01,
        Route11<PhaseOrientationTable>, Route01<PhaseOrientationTable.Row3>, Route10<Route01<PhaseOrientationTable.Row3>.Answer>>
    public typealias P3102 = PhaseExcursionDecision<
        RoutingAddress11, RoutingAddress01, RoutingAddress00, RoutingAddress10,
        Route11<PhaseOrientationTable>, Route10<PhaseOrientationTable.Row3>, Route00<Route10<PhaseOrientationTable.Row3>.Answer>>
    public typealias P3120 = PhaseExcursionDecision<
        RoutingAddress11, RoutingAddress01, RoutingAddress10, RoutingAddress00,
        Route11<PhaseOrientationTable>, Route00<PhaseOrientationTable.Row3>, Route10<Route00<PhaseOrientationTable.Row3>.Answer>>
    public typealias P3201 = PhaseExcursionDecision<
        RoutingAddress11, RoutingAddress10, RoutingAddress00, RoutingAddress01,
        Route11<PhaseOrientationTable>, Route01<PhaseOrientationTable.Row3>, Route00<Route01<PhaseOrientationTable.Row3>.Answer>>
    public typealias P3210 = PhaseExcursionDecision<
        RoutingAddress11, RoutingAddress10, RoutingAddress01, RoutingAddress00,
        Route11<PhaseOrientationTable>, Route00<PhaseOrientationTable.Row3>, Route01<Route00<PhaseOrientationTable.Row3>.Answer>>
    public enum Verdicts: Null {
        public typealias Left = BoundaryWorking<
            AddressTriple<Paired<P0123.Read.Answer, P0132.Read.Answer>, Paired<P0213.Read.Answer, P0231.Read.Answer>, Paired<P0312.Read.Answer, P0321.Read.Answer>>,
            AddressTriple<Paired<P1023.Read.Answer, P1032.Read.Answer>, Paired<P1203.Read.Answer, P1230.Read.Answer>, Paired<P1302.Read.Answer, P1320.Read.Answer>>,
            AddressTriple<Paired<P2013.Read.Answer, P2031.Read.Answer>, Paired<P2103.Read.Answer, P2130.Read.Answer>, Paired<P2301.Read.Answer, P2310.Read.Answer>>,
            AddressTriple<Paired<P3012.Read.Answer, P3021.Read.Answer>, Paired<P3102.Read.Answer, P3120.Read.Answer>, Paired<P3201.Read.Answer, P3210.Read.Answer>>>
        public typealias No = Paired<Never, Never>
        public typealias Right = BoundaryWorking<
            AddressTriple<Paired<Lit1, Never>, No, No>,
            AddressTriple<No, No, No>,
            AddressTriple<No, Paired<Never, Lit1>, No>,
            AddressTriple<No, Paired<Lit1, Never>, No>>
    }
    public enum PositiveSources: Null {
        public typealias Words = PhaseWordCatalogue<RoutingAddress00,
            RoutingAddress01, RoutingAddress10, RoutingAddress11>
        public typealias Left = AddressTriple<P0123.Left.Left,
            P3102.Left.Left, P2130.Left.Left>
        public typealias Right = AddressTriple<Words.I.Right, Words.W.Right, Words.WW.Right>
    }
}
