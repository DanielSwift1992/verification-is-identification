import VerificationIsIdentification

/// One source contains U's fixed address program, an unknown word address,
/// the fixed instruction which reads that address, and the rest of the lab.
/// The word library is finite and independently given by the actual paths.
public typealias FourLeafLawContext<L: Structure, R: Structure> = Paired<
    FourLeafAddressProgram, Paired<L, Paired<FirstProjection, R>>>

/// One resident library object with the actual twelve word expressions in
/// its fields. The general root derives equality of those fields below;
/// this is not a marker asserting that an unrelated library is trustworthy.
public enum FourLeafWordLibrary: Pair {
    public typealias W = FourLeafJointCatalogue<Never, Never, Never, Never, Never>
    public typealias Left = Paired<
        Paired<W.I.Predicate, Paired<W.W.Predicate, W.WW.Predicate>>,
        Paired<W.Z.Predicate, Paired<W.ZW.Predicate, W.ZWW.Predicate>>>
    public typealias Right = Paired<
        Paired<W.WZ.Predicate, Paired<W.WZW.Predicate, W.WZWW.Predicate>>,
        Paired<W.WWZ.Predicate, Paired<W.WWZW.Predicate, W.WWZWW.Predicate>>>
}

/// Read the actual law address and resident selector instruction. The phase,
/// stage, reserve probe and previous facts are not arguments of this selector.
public enum FourLeafLawInput<P: Structure, K: Pair>: PredicateReading
where K.Right: Pair, K.Right.Left: Structure, K.Right.Right: Pair,
      K.Right.Right.Left: Structure {
    public typealias Source = LocalPhaseWorld<FourLeafCenter, P, K>
    public typealias Tail = SecondEvidenceImage<Source, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Context = SequentialReading<Tail,
        SecondEvidenceImage<Tail.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias LawFields = SequentialReading<Context,
        SecondEvidenceImage<K, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Address = SequentialReading<LawFields,
        FirstEvidenceImage<K.Right, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Rest = SequentialReading<LawFields,
        SecondEvidenceImage<K.Right, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Program = SequentialReading<Rest,
        FirstEvidenceImage<K.Right.Right, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Actual = JointEvidence<Address, Program>
    public typealias Left = Source
    public typealias Right = Paired<K.Right.Left, K.Right.Right.Left>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Actual.Answer
}

/// Rebuild the same finite library at the actual prepared phase and retained
/// context. Its occurrence addresses depend only on this tree, not on the
/// working payloads or which word happens to be chosen by the source.
public enum FourLeafWordRoot<A: Structure, B: Structure, C: Structure,
                             D: Structure, K: Structure>: Pair {
    public typealias Words = FourLeafJointCatalogue<A, B, C, D, K>
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
    public typealias Expression = FourLeafWordLibrary
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

    /// The existing root-bound selector consumes the law address from this
    /// source. Choosing the candidate by its answer or by its name is not an
    /// alternative input to this construction. The admitted S are the twelve
    /// actual finite selection paths above, not arbitrary conformances.
    public enum Selected<S: CandidateRemoval>: PredicateReading
    where K: Pair, K.Right: Pair, K.Right.Left: Structure,
          K.Right.Right: Pair, K.Right.Right.Left == FirstProjection,
          S.Left == Catalogue, S.Right: PredicateReading,
          S.Right.Left == Words.Initial, S.Address == K.Right.Left,
          S.Right.Sigma == BeamSpace, S.Right.Encoding == SaturationEncoding {
        public typealias Input = FourLeafLawInput<BoundaryWorking<A, B, C, D>, K>
        public typealias Choice = FirstEvidenceImage<Input.Answer,
            BeamSpace, SaturationEncoding, FirstProjection>
        public typealias Actual = SelectedLocalApplication<FourLeafWordRoot, Input, Choice, S>
        public typealias Left = Words.Initial
        public typealias Right = Actual.Answer
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = Actual.Predicate
        public typealias Answer = Right
    }
}

/// These are actual occurrence paths in the same-shaped current catalogue.
/// The prototype supplies their layout; it is not an unobserved law value.
public enum FourLeafLawAddresses: Close {
    public typealias Root = FourLeafWordRoot<Never, Never, Never, Never, Never>
    public typealias I = Root.SelectI.Address
    public typealias W = Root.SelectW.Address
    public typealias WW = Root.SelectWW.Address
    public typealias Z = Root.SelectZ.Address
    public typealias ZW = Root.SelectZW.Address
    public typealias ZWW = Root.SelectZWW.Address
    public typealias WZ = Root.SelectWZ.Address
    public typealias WZW = Root.SelectWZW.Address
    public typealias WZWW = Root.SelectWZWW.Address
    public typealias WWZ = Root.SelectWWZ.Address
    public typealias WWZW = Root.SelectWWZW.Address
    public typealias WWZWW = Root.SelectWWZWW.Address
}
