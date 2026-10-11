import VerificationIsIdentification

/// Fifteen actual contacts, indexed by the pairs of six matching readings.
/// The Petersen matching catalogue identifies these pairs with graph edges.
/// This constructor carries incidence only; it does not assert that an
/// arbitrary contact value is a valid noiseless graph comparison.
public enum PetersenContactRows<A: Structure, B: Structure, C: Structure,
    D: Structure, E: Structure, F: Structure, G: Structure, H: Structure,
    I: Structure, J: Structure, K: Structure, L: Structure, M: Structure,
    N: Structure, O: Structure>: Pair {
    public typealias Source = Paired<Paired<A, Paired<B, Paired<C, Paired<D, E>>>>,
        Paired<Paired<F, Paired<G, Paired<H, I>>>,
            Paired<Paired<J, Paired<K, L>>, Paired<Paired<M, N>, O>>>>
    public typealias Left = Source
    public typealias M0 = Source.Left
    public typealias M1 = Paired<Source.Left.Left, Source.Right.Left>
    public typealias M2 = Paired<Source.Left.Right.Left,
        Paired<Source.Right.Left.Left, Source.Right.Right.Left>>
    public typealias M3 = Paired<Source.Left.Right.Right.Left,
        Paired<Source.Right.Left.Right.Left,
            Paired<Source.Right.Right.Left.Left, Source.Right.Right.Right.Left>>>
    public typealias M4 = Paired<Source.Left.Right.Right.Right.Left,
        Paired<Source.Right.Left.Right.Right.Left,
            Paired<Source.Right.Right.Left.Right.Left,
                Paired<Source.Right.Right.Right.Left.Left, Source.Right.Right.Right.Right>>>>
    public typealias M5 = Paired<Source.Left.Right.Right.Right.Right,
        Paired<Source.Right.Left.Right.Right.Right,
            Paired<Source.Right.Right.Left.Right.Right,
                Paired<Source.Right.Right.Right.Left.Right, Source.Right.Right.Right.Right>>>>
    public typealias Right = Paired<M0, Paired<M1, Paired<M2, Paired<M3, Paired<M4, M5>>>>>

    /// The first occurrence of each edge reconstructs the supplied source.
    public typealias FirstCopies = Paired<M0, Paired<M1.Right,
        Paired<M2.Right.Right, Paired<M3.Right.Right.Right, M4.Right.Right.Right.Right>>>>
    /// Its second occurrence uses the other matching's actual source field.
    public typealias SecondCopies = Paired<
        Paired<M1.Left, Paired<M2.Left, Paired<M3.Left, Paired<M4.Left, M5.Left>>>>,
        Paired<Paired<M2.Right.Left, Paired<M3.Right.Left, Paired<M4.Right.Left, M5.Right.Left>>>,
            Paired<Paired<M3.Right.Right.Left, Paired<M4.Right.Right.Left, M5.Right.Right.Left>>,
                Paired<Paired<M4.Right.Right.Right.Left, M5.Right.Right.Right.Left>,
                    M5.Right.Right.Right.Right>>>>
    public enum BothCopiesUseTheSource: Null {
        public typealias Left = Paired<FirstCopies, SecondCopies>
        public typealias Right = Paired<Source, Source>
    }
    /// Five full matching rows already cover all fifteen raw edge values.
    /// This is raw support coverage, not recovery from five arbitrary bits.
    public typealias LastRowFromFive = Paired<M0.Right.Right.Right.Right,
        Paired<M1.Right.Right.Right.Right, Paired<M2.Right.Right.Right.Right,
            Paired<M3.Right.Right.Right.Right, M4.Right.Right.Right.Right>>>>
    public enum ExcludedRawRowRemainsCovered: Null {
        public typealias Left = LastRowFromFive
        public typealias Right = M5
    }
}

/// One changed contact is shared by M0 and M1; it is not one fresh error
/// independently chosen inside each reading. The other four rows survive.
public enum OneSharedContactChange<X: Structure, Y: Structure>: Close {
    public typealias Before = PetersenContactRows<X, X, X, X, X, X, X, X, X, X, X, X, X, X, X>
    public typealias After = PetersenContactRows<Y, X, X, X, X, X, X, X, X, X, X, X, X, X, X>
    public enum BothAffectedRows: Null {
        public typealias Left = Paired<After.M0.Left, After.M1.Left>
        public typealias Right = Paired<Y, Y>
    }
    public enum OtherRowsArePreserved: Null {
        public typealias Left = Paired<After.M2, Paired<After.M3, Paired<After.M4, After.M5>>>
        public typealias Right = Paired<Before.M2, Paired<Before.M3, Paired<Before.M4, Before.M5>>>
    }
}

/// Ones on edges 01, 02, 12 of the matching-index graph. The first three
/// actual matching rows contain two ones each; the others contain none.
/// Their zero parity and the raw record's failed admission are proved in M64at.
public enum PetersenTriangleRecord: Close {
    public typealias Rows = PetersenContactRows<Lit1, Lit1, Never, Never, Never,
        Lit1, Never, Never, Never, Never, Never, Never, Never, Never, Never>
    public typealias TwoOnes = Paired<Lit1, Paired<Lit1, Paired<Never, Paired<Never, Never>>>>
    public typealias NoOnes = Paired<Never, Paired<Never, Paired<Never, Paired<Never, Never>>>>
    public enum ActualEvenRows: Null {
        public typealias Left = Rows.Right
        public typealias Right = Paired<TwoOnes, Paired<TwoOnes,
            Paired<TwoOnes, Paired<NoOnes, Paired<NoOnes, NoOnes>>>>>
    }
}
