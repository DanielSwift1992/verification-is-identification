import VerificationIsIdentification

/// At the address of each forward law, carry its actual inverse word.
/// The complete compositions are derived in FourLeafInverseCalibration;
/// these are existing paths, not a table of asserted target output tuples.
public enum FourLeafInverseCatalogue<A: Structure, B: Structure, C: Structure,
    D: Structure, K: Structure>: Close {
    public typealias F = FourLeafJointCatalogue<A, B, C, D, K>
    public typealias Initial = F.Initial
    public typealias I = F.I
    public typealias W = F.WW
    public typealias WW = F.W
    public typealias Z = F.Z
    public typealias ZW = F.WWZ
    public typealias ZWW = F.WZ
    public typealias WZ = F.ZWW
    public typealias WZW = F.WWZWW
    public typealias WZWW = F.WZWW
    public typealias WWZ = F.ZW
    public typealias WWZW = F.WWZW
    public typealias WWZWW = F.WZW
}

public enum FourLeafInverseLibrary: Pair {
    public typealias W = FourLeafInverseCatalogue<Never, Never, Never, Never, Never>
    public typealias Left = Paired<
        Paired<W.I.Predicate, Paired<W.W.Predicate, W.WW.Predicate>>,
        Paired<W.Z.Predicate, Paired<W.ZW.Predicate, W.ZWW.Predicate>>>
    public typealias Right = Paired<
        Paired<W.WZ.Predicate, Paired<W.WZW.Predicate, W.WZWW.Predicate>>,
        Paired<W.WWZ.Predicate, Paired<W.WWZW.Predicate, W.WWZWW.Predicate>>>
}

/// Same occurrence addresses as the forward interface, different actual
/// leaf programs. A source-held law address therefore chooses its inverse
/// here without receiving an independently chosen inverse address.
public enum FourLeafInverseRoot<A: Structure, B: Structure, C: Structure,
                             D: Structure, K: Structure>: Pair {
    public typealias Words = FourLeafInverseCatalogue<A, B, C, D, K>
    public typealias PureTail = CandidateFork<CandidateLeaf<Words.W>, CandidateLeaf<Words.WW>>
    public typealias ZeroTail = CandidateFork<CandidateLeaf<Words.ZW>, CandidateLeaf<Words.ZWW>>
    public typealias OneTail = CandidateFork<CandidateLeaf<Words.WZW>, CandidateLeaf<Words.WZWW>>
    public typealias TwoTail = CandidateFork<CandidateLeaf<Words.WWZW>, CandidateLeaf<Words.WWZWW>>
    public typealias Pure = CandidateFork<CandidateLeaf<Words.I>, PureTail>
    public typealias Zero = CandidateFork<CandidateLeaf<Words.Z>, ZeroTail>
    public typealias One = CandidateFork<CandidateLeaf<Words.WZ>, OneTail>
    public typealias Two = CandidateFork<CandidateLeaf<Words.WWZ>, TwoTail>
    public typealias Low = CandidateFork<Pure, Zero>
    public typealias High = CandidateFork<One, Two>
    public typealias Catalogue = CandidateFork<Low, High>
    public typealias ActualExpression = BoundaryWorking<
        Paired<Words.I.Predicate, Paired<Words.W.Predicate, Words.WW.Predicate>>,
        Paired<Words.Z.Predicate, Paired<Words.ZW.Predicate, Words.ZWW.Predicate>>,
        Paired<Words.WZ.Predicate, Paired<Words.WZW.Predicate, Words.WZWW.Predicate>>,
        Paired<Words.WWZ.Predicate, Paired<Words.WWZW.Predicate, Words.WWZWW.Predicate>>>
    public typealias Expression = FourLeafInverseLibrary
    public typealias Left = Words.Initial
    public typealias Right = Paired<Expression, Catalogue>

    public enum LibraryMatches: Null {
        public typealias Left = ActualExpression
        public typealias Right = Paired<Expression.Left, Expression.Right>
    }

    public typealias PureI = SelectCandidateLeft<SelectCandidateLeaf<Words.I>, PureTail>
    public typealias PureW = SelectCandidateRight<CandidateLeaf<Words.I>,
        SelectCandidateLeft<SelectCandidateLeaf<Words.W>, CandidateLeaf<Words.WW>>>
    public typealias PureWW = SelectCandidateRight<CandidateLeaf<Words.I>,
        SelectCandidateRight<CandidateLeaf<Words.W>, SelectCandidateLeaf<Words.WW>>>
    public typealias ZeroZ = SelectCandidateLeft<SelectCandidateLeaf<Words.Z>, ZeroTail>
    public typealias ZeroZW = SelectCandidateRight<CandidateLeaf<Words.Z>,
        SelectCandidateLeft<SelectCandidateLeaf<Words.ZW>, CandidateLeaf<Words.ZWW>>>
    public typealias ZeroZWW = SelectCandidateRight<CandidateLeaf<Words.Z>,
        SelectCandidateRight<CandidateLeaf<Words.ZW>, SelectCandidateLeaf<Words.ZWW>>>
    public typealias OneWZ = SelectCandidateLeft<SelectCandidateLeaf<Words.WZ>, OneTail>
    public typealias OneWZW = SelectCandidateRight<CandidateLeaf<Words.WZ>,
        SelectCandidateLeft<SelectCandidateLeaf<Words.WZW>, CandidateLeaf<Words.WZWW>>>
    public typealias OneWZWW = SelectCandidateRight<CandidateLeaf<Words.WZ>,
        SelectCandidateRight<CandidateLeaf<Words.WZW>, SelectCandidateLeaf<Words.WZWW>>>
    public typealias TwoWWZ = SelectCandidateLeft<SelectCandidateLeaf<Words.WWZ>, TwoTail>
    public typealias TwoWWZW = SelectCandidateRight<CandidateLeaf<Words.WWZ>,
        SelectCandidateLeft<SelectCandidateLeaf<Words.WWZW>, CandidateLeaf<Words.WWZWW>>>
    public typealias TwoWWZWW = SelectCandidateRight<CandidateLeaf<Words.WWZ>,
        SelectCandidateRight<CandidateLeaf<Words.WWZW>, SelectCandidateLeaf<Words.WWZWW>>>

    public typealias SelectI = SelectCandidateLeft<SelectCandidateLeft<PureI, Zero>, High>
    public typealias SelectW = SelectCandidateLeft<SelectCandidateLeft<PureW, Zero>, High>
    public typealias SelectWW = SelectCandidateLeft<SelectCandidateLeft<PureWW, Zero>, High>
    public typealias SelectZ = SelectCandidateLeft<SelectCandidateRight<Pure, ZeroZ>, High>
    public typealias SelectZW = SelectCandidateLeft<SelectCandidateRight<Pure, ZeroZW>, High>
    public typealias SelectZWW = SelectCandidateLeft<SelectCandidateRight<Pure, ZeroZWW>, High>
    public typealias SelectWZ = SelectCandidateRight<Low, SelectCandidateLeft<OneWZ, Two>>
    public typealias SelectWZW = SelectCandidateRight<Low, SelectCandidateLeft<OneWZW, Two>>
    public typealias SelectWZWW = SelectCandidateRight<Low, SelectCandidateLeft<OneWZWW, Two>>
    public typealias SelectWWZ = SelectCandidateRight<Low, SelectCandidateRight<One, TwoWWZ>>
    public typealias SelectWWZW = SelectCandidateRight<Low, SelectCandidateRight<One, TwoWWZW>>
    public typealias SelectWWZWW = SelectCandidateRight<Low, SelectCandidateRight<One, TwoWWZWW>>

    public enum AddressesMatch: Null {
        public typealias Forward = FourLeafWordRoot<A, B, C, D, K>
        public typealias Left = BoundaryWorking<Paired<SelectI.Address, Paired<SelectW.Address, SelectWW.Address>>, Paired<SelectZ.Address, Paired<SelectZW.Address, SelectZWW.Address>>, Paired<SelectWZ.Address, Paired<SelectWZW.Address, SelectWZWW.Address>>, Paired<SelectWWZ.Address, Paired<SelectWWZW.Address, SelectWWZWW.Address>>>
        public typealias Right = BoundaryWorking<Paired<Forward.SelectI.Address, Paired<Forward.SelectW.Address, Forward.SelectWW.Address>>, Paired<Forward.SelectZ.Address, Paired<Forward.SelectZW.Address, Forward.SelectZWW.Address>>, Paired<Forward.SelectWZ.Address, Paired<Forward.SelectWZW.Address, Forward.SelectWZWW.Address>>, Paired<Forward.SelectWWZ.Address, Paired<Forward.SelectWWZW.Address, Forward.SelectWWZWW.Address>>>
    }
}

/// Each forward word followed by the same-address inverse returns its whole
/// source, including arbitrary K. Both orders occur in this involutive table.
public enum FourLeafInverseCalibration<A: Structure, B: Structure,
    C: Structure, D: Structure, K: Structure>: Null {
    public typealias F = FourLeafJointCatalogue<A, B, C, D, K>
    public typealias RI = FollowedPair<F.I, FourLeafInverseCatalogue<A, B, C, D, K>.I>
    public typealias RW = FollowedPair<F.W, FourLeafInverseCatalogue<D, B, A, C, K>.W>
    public typealias RWW = FollowedPair<F.WW, FourLeafInverseCatalogue<C, B, D, A, K>.WW>
    public typealias RZ = FollowedPair<F.Z, FourLeafInverseCatalogue<B, A, D, C, K>.Z>
    public typealias RZW = FollowedPair<F.ZW, FourLeafInverseCatalogue<C, A, B, D, K>.ZW>
    public typealias RZWW = FollowedPair<F.ZWW, FourLeafInverseCatalogue<D, A, C, B, K>.ZWW>
    public typealias RWZ = FollowedPair<F.WZ, FourLeafInverseCatalogue<B, D, C, A, K>.WZ>
    public typealias RWZW = FollowedPair<F.WZW, FourLeafInverseCatalogue<A, D, B, C, K>.WZW>
    public typealias RWZWW = FollowedPair<F.WZWW, FourLeafInverseCatalogue<C, D, A, B, K>.WZWW>
    public typealias RWWZ = FollowedPair<F.WWZ, FourLeafInverseCatalogue<B, C, A, D, K>.WWZ>
    public typealias RWWZW = FollowedPair<F.WWZW, FourLeafInverseCatalogue<D, C, B, A, K>.WWZW>
    public typealias RWWZWW = FollowedPair<F.WWZWW, FourLeafInverseCatalogue<A, C, D, B, K>.WWZWW>
    public typealias Left = BoundaryWorking<Paired<RI.Right, Paired<RW.Right, RWW.Right>>, Paired<RZ.Right, Paired<RZW.Right, RZWW.Right>>, Paired<RWZ.Right, Paired<RWZW.Right, RWZWW.Right>>, Paired<RWWZ.Right, Paired<RWWZW.Right, RWWZWW.Right>>>
    public typealias Right = BoundaryWorking<Paired<F.Initial, Paired<F.Initial, F.Initial>>, Paired<F.Initial, Paired<F.Initial, F.Initial>>, Paired<F.Initial, Paired<F.Initial, F.Initial>>, Paired<F.Initial, Paired<F.Initial, F.Initial>>>
}
