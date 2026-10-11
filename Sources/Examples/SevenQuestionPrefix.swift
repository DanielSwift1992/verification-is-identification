import VerificationIsIdentification

/// VC100d's seven-position obstruction uses four actual even phase words on
/// the unread first block and leaves three individually named suffix inputs
/// fixed. A suffix of equal values does not erase those occurrence addresses.
public enum SevenQuestionPrefix<A: Structure, B: Structure,
    C: Structure, D: Structure, E: Structure, F: Structure, G: Structure>: Close {
    public typealias Words = PhaseWordCatalogue<A, B, C, D>
    public typealias Suffix = Paired<E, Paired<F, G>>
    public typealias I = StepBeside<Words.I, Suffix>
    public typealias Fix0 = StepBeside<Words.WZW, Suffix>
    public typealias Fix1 = StepBeside<Words.W, Suffix>
    public typealias Fix2 = StepBeside<Words.WZ, Suffix>
    public typealias Fix3 = StepBeside<Words.WWZ, Suffix>

    public enum SamePreparedSource: Null {
        public typealias Left = BoundaryWorking<Fix0.Left, Fix1.Left, Fix2.Left, Fix3.Left>
        public typealias Right = BoundaryWorking<I.Left, I.Left, I.Left, I.Left>
    }
    public enum KeepsThreeNamedInputs: Null {
        public typealias Left = BoundaryWorking<Fix0.Right.Right, Fix1.Right.Right,
            Fix2.Right.Right, Fix3.Right.Right>
        public typealias Right = BoundaryWorking<Suffix, Suffix, Suffix, Suffix>
    }
}

/// Each alternative also fixes the chosen first-block point. Unit-marker
/// transport reads its destination, not merely the value at an output.
public enum SevenPrefixOneMorePoint: Null {
    public typealias Q0 = PhaseWordCatalogue<Lit1, Never, Never, Never>.WZW
    public typealias Q1 = PhaseWordCatalogue<Never, Lit1, Never, Never>.W
    public typealias Q2 = PhaseWordCatalogue<Never, Never, Lit1, Never>.WZ
    public typealias Q3 = PhaseWordCatalogue<Never, Never, Never, Lit1>.WWZ
    public typealias Left = BoundaryWorking<Q0.Right, Q1.Right, Q2.Right, Q3.Right>
    public typealias Right = BoundaryWorking<FourLeafPhaseMark0, FourLeafPhaseMark1,
        FourLeafPhaseMark2, FourLeafPhaseMark3>
}

/// Those same alternatives preserve the first question's value output.
/// Splitting A into four distinct values reintroduces their difference;
/// the negative consumer checks retain exactly the point agreement above.
public enum SevenPrefixCoarseAnswer<A: Structure, B: Structure>: Null {
    public typealias P = SevenQuestionPrefix<A, A, A, A, B, B, B>
    public typealias Left = BoundaryWorking<P.Fix0.Right, P.Fix1.Right, P.Fix2.Right, P.Fix3.Right>
    public typealias Right = BoundaryWorking<P.I.Right, P.I.Right, P.I.Right, P.I.Right>
}
