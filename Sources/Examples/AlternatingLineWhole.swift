import VerificationIsIdentification

/// The same balanced carrier shape is used for an independent preparation
/// family and for domains of actual selected rows. This alias does no search.
public typealias AlternatingLineColumn<
    A: Structure, B: Structure, C: Structure,
    D: Structure, E: Structure, F: Structure, Last: Structure
> = Paired<Paired<A, Paired<B, C>>, Paired<Paired<D, Paired<E, F>>, Last>>

/// The declared twenty-five preparations at one stage, independently of U.
public enum AlternatingLineSources<S: Structure, K: Structure>: Close {
    public typealias P = TwentyFivePhaseLine
    public typealias Points = AlternatingLineColumn<
        BoundaryWorking<LocalPhaseWorld<S, P.C0.Even, K>, LocalPhaseWorld<S, P.C0.Odd, K>, LocalPhaseWorld<S, P.C1.Even, K>, LocalPhaseWorld<S, P.C1.Odd, K>>,
        BoundaryWorking<LocalPhaseWorld<S, P.C2.Even, K>, LocalPhaseWorld<S, P.C2.Odd, K>, LocalPhaseWorld<S, P.C3.Even, K>, LocalPhaseWorld<S, P.C3.Odd, K>>,
        BoundaryWorking<LocalPhaseWorld<S, P.C4.Even, K>, LocalPhaseWorld<S, P.C4.Odd, K>, LocalPhaseWorld<S, P.C5.Even, K>, LocalPhaseWorld<S, P.C5.Odd, K>>,
        BoundaryWorking<LocalPhaseWorld<S, P.C6.Even, K>, LocalPhaseWorld<S, P.C6.Odd, K>, LocalPhaseWorld<S, P.C7.Even, K>, LocalPhaseWorld<S, P.C7.Odd, K>>,
        BoundaryWorking<LocalPhaseWorld<S, P.C8.Even, K>, LocalPhaseWorld<S, P.C8.Odd, K>, LocalPhaseWorld<S, P.C9.Even, K>, LocalPhaseWorld<S, P.C9.Odd, K>>,
        BoundaryWorking<LocalPhaseWorld<S, P.C10.Even, K>, LocalPhaseWorld<S, P.C10.Odd, K>, LocalPhaseWorld<S, P.C11.Even, K>, LocalPhaseWorld<S, P.C11.Odd, K>>,
        LocalPhaseWorld<S, P.Top, K>>
}

/// Every source below comes from an actual row of the 52-cycle, one of the
/// 23 two-cycles, or the 27 fixed points. The equality with the independent
/// five-by-twenty-five family checks coverage without a second policy table.
/// Distinct phase expressions and distinct stage slots give disjoint sources.
/// The generic remainder at center Even0 is deliberately absent: that source
/// already belongs to the main cycle.
public enum AlternatingLineWhole<K: Structure>: Close {
    public typealias P = TwentyFivePhaseLine
    public typealias T = AlternatingLineTravel<K>
    public typealias R0 = AlternatingLineRemainder<P.J0, K>
    public typealias R1 = AlternatingLineRemainder<P.J1, K>
    public typealias R2 = AlternatingLineRemainder<P.J2, K>
    public typealias R3 = AlternatingLineRemainder<P.J3, K>
    public typealias R4 = AlternatingLineRemainder<P.J4, K>
    public typealias R5 = AlternatingLineRemainder<P.J5, K>
    public typealias R6 = AlternatingLineRemainder<P.J6, K>
    public typealias R7 = AlternatingLineRemainder<P.J7, K>
    public typealias R8 = AlternatingLineRemainder<P.J8, K>
    public typealias R9 = AlternatingLineRemainder<P.J9, K>
    public typealias R10 = AlternatingLineRemainder<P.J10, K>
    public typealias R11 = AlternatingLineRemainder<P.J11, K>
    public typealias Center = AlternatingLineColumn<
        BoundaryWorking<T.BottomEnter.Left, R0.FromOdd.Left, R1.FromEven.Left, R1.FromOdd.Left>,
        BoundaryWorking<R2.FromEven.Left, R2.FromOdd.Left, R3.FromEven.Left, R3.FromOdd.Left>,
        BoundaryWorking<R4.FromEven.Left, R4.FromOdd.Left, R5.FromEven.Left, R5.FromOdd.Left>,
        BoundaryWorking<R6.FromEven.Left, R6.FromOdd.Left, R7.FromEven.Left, R7.FromOdd.Left>,
        BoundaryWorking<R8.FromEven.Left, R8.FromOdd.Left, R9.FromEven.Left, R9.FromOdd.Left>,
        BoundaryWorking<R10.FromEven.Left, R10.FromOdd.Left, R11.FromEven.Left, R11.FromOdd.Left>,
        T.TopEnter.Left>

    public typealias Leaf0 = AlternatingLineColumn<
        BoundaryWorking<T.D0.UpFirst.Left, T.D0.UpSecond.Left, T.D1.UpFirst.Left, T.D1.UpSecond.Left>,
        BoundaryWorking<T.D2.UpFirst.Left, T.D2.UpSecond.Left, T.D3.UpFirst.Left, T.D3.UpSecond.Left>,
        BoundaryWorking<T.D4.UpFirst.Left, T.D4.UpSecond.Left, T.D5.UpFirst.Left, T.D5.UpSecond.Left>,
        BoundaryWorking<T.D6.UpFirst.Left, T.D6.UpSecond.Left, T.D7.UpFirst.Left, T.D7.UpSecond.Left>,
        BoundaryWorking<T.D8.UpFirst.Left, T.D8.UpSecond.Left, T.D9.UpFirst.Left, T.D9.UpSecond.Left>,
        BoundaryWorking<T.D10.UpFirst.Left, T.D10.UpSecond.Left, T.D11.UpFirst.Left, T.D11.UpSecond.Left>,
        T.TopLeave.Left>

    public typealias Leaf1 = AlternatingLineColumn<
        BoundaryWorking<R0.ToOdd.Left, AlternatingLineFixedLeaf1<P.C0.Odd, K>.Left, R1.ToOdd.Left, R1.ToEven.Left>,
        BoundaryWorking<R2.ToOdd.Left, R2.ToEven.Left, R3.ToOdd.Left, R3.ToEven.Left>,
        BoundaryWorking<R4.ToOdd.Left, R4.ToEven.Left, R5.ToOdd.Left, R5.ToEven.Left>,
        BoundaryWorking<R6.ToOdd.Left, R6.ToEven.Left, R7.ToOdd.Left, R7.ToEven.Left>,
        BoundaryWorking<R8.ToOdd.Left, R8.ToEven.Left, R9.ToOdd.Left, R9.ToEven.Left>,
        BoundaryWorking<R10.ToOdd.Left, R10.ToEven.Left, R11.ToOdd.Left, R11.ToEven.Left>,
        AlternatingLineFixedLeaf1<P.Top, K>.Left>

    public typealias Leaf2 = AlternatingLineColumn<
        BoundaryWorking<AlternatingLineFixedLeaf2<P.C0.Even, K>.Left, AlternatingLineFixedLeaf2<P.C0.Odd, K>.Left, AlternatingLineFixedLeaf2<P.C1.Even, K>.Left, AlternatingLineFixedLeaf2<P.C1.Odd, K>.Left>,
        BoundaryWorking<AlternatingLineFixedLeaf2<P.C2.Even, K>.Left, AlternatingLineFixedLeaf2<P.C2.Odd, K>.Left, AlternatingLineFixedLeaf2<P.C3.Even, K>.Left, AlternatingLineFixedLeaf2<P.C3.Odd, K>.Left>,
        BoundaryWorking<AlternatingLineFixedLeaf2<P.C4.Even, K>.Left, AlternatingLineFixedLeaf2<P.C4.Odd, K>.Left, AlternatingLineFixedLeaf2<P.C5.Even, K>.Left, AlternatingLineFixedLeaf2<P.C5.Odd, K>.Left>,
        BoundaryWorking<AlternatingLineFixedLeaf2<P.C6.Even, K>.Left, AlternatingLineFixedLeaf2<P.C6.Odd, K>.Left, AlternatingLineFixedLeaf2<P.C7.Even, K>.Left, AlternatingLineFixedLeaf2<P.C7.Odd, K>.Left>,
        BoundaryWorking<AlternatingLineFixedLeaf2<P.C8.Even, K>.Left, AlternatingLineFixedLeaf2<P.C8.Odd, K>.Left, AlternatingLineFixedLeaf2<P.C9.Even, K>.Left, AlternatingLineFixedLeaf2<P.C9.Odd, K>.Left>,
        BoundaryWorking<AlternatingLineFixedLeaf2<P.C10.Even, K>.Left, AlternatingLineFixedLeaf2<P.C10.Odd, K>.Left, AlternatingLineFixedLeaf2<P.C11.Even, K>.Left, AlternatingLineFixedLeaf2<P.C11.Odd, K>.Left>,
        AlternatingLineFixedLeaf2<P.Top, K>.Left>

    public typealias Leaf3 = AlternatingLineColumn<
        BoundaryWorking<T.BottomLeave.Left, T.D0.DownSecond.Left, T.D0.DownFirst.Left, T.D1.DownSecond.Left>,
        BoundaryWorking<T.D1.DownFirst.Left, T.D2.DownSecond.Left, T.D2.DownFirst.Left, T.D3.DownSecond.Left>,
        BoundaryWorking<T.D3.DownFirst.Left, T.D4.DownSecond.Left, T.D4.DownFirst.Left, T.D5.DownSecond.Left>,
        BoundaryWorking<T.D5.DownFirst.Left, T.D6.DownSecond.Left, T.D6.DownFirst.Left, T.D7.DownSecond.Left>,
        BoundaryWorking<T.D7.DownFirst.Left, T.D8.DownSecond.Left, T.D8.DownFirst.Left, T.D9.DownSecond.Left>,
        BoundaryWorking<T.D9.DownFirst.Left, T.D10.DownSecond.Left, T.D10.DownFirst.Left, T.D11.DownSecond.Left>,
        T.D11.DownFirst.Left>

    public enum SourceCoverage: Null {
        public typealias Left = FourLeafStageLabels<Center, Leaf0, Leaf1, Leaf2, Leaf3>
        public typealias Right = FourLeafStageLabels<
            AlternatingLineSources<FourLeafCenter, K>.Points,
            AlternatingLineSources<FourLeafStageLabels<Never, Lit1, Never, Never, Never>, K>.Points,
            AlternatingLineSources<FourLeafStageLabels<Never, Never, Lit1, Never, Never>, K>.Points,
            AlternatingLineSources<FourLeafStageLabels<Never, Never, Never, Lit1, Never>, K>.Points,
            AlternatingLineSources<FourLeafStageLabels<Never, Never, Never, Never, Lit1>, K>.Points>
    }
}

