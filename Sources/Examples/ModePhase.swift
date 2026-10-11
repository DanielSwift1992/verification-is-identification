import VerificationIsIdentification

/// Each coefficient is a formal difference (positive, negative). The two
/// outer coordinates are modes A and B. The interpretation uses an additive
/// group, with complex amplitudes as one instance. No norm or probability
/// law is supplied by this representation.
public typealias SignedModes<AP: Structure, AN: Structure, BP: Structure, BN: Structure> =
    Paired<Paired<AP, AN>, Paired<BP, BN>>

public enum TwoModeSpace: Close {}
public enum ModePhaseEncoding: Close {}
public enum ExchangeModesQuestion: Close {}
public enum ReverseSecondPhaseQuestion: Close {}
public enum ReverseBothPhasesQuestion: Close {}

/// X exchanges the two actual modes. The output uses canonical pairs so
/// composition recovers coordinates rather than an arbitrary nominal shell.
public enum ExchangeModes<S: Pair>: PredicateReading
where S.Left: Pair, S.Right: Pair,
      S.Left.Left: Structure, S.Left.Right: Structure,
      S.Right.Left: Structure, S.Right.Right: Structure {
    public typealias Left = S
    public typealias Answer = SignedModes<
        S.Right.Left, S.Right.Right, S.Left.Left, S.Left.Right
    >
    public typealias Right = Answer
    public typealias Sigma = TwoModeSpace
    public typealias Encoding = ModePhaseEncoding
    public typealias Predicate = ExchangeModesQuestion
}

/// Z reverses the sign of mode B by exchanging its two signed terms.
public enum ReverseSecondPhase<S: Pair>: PredicateReading
where S.Left: Pair, S.Right: Pair,
      S.Left.Left: Structure, S.Left.Right: Structure,
      S.Right.Left: Structure, S.Right.Right: Structure {
    public typealias Left = S
    public typealias Answer = SignedModes<
        S.Left.Left, S.Left.Right, S.Right.Right, S.Right.Left
    >
    public typealias Right = Answer
    public typealias Sigma = TwoModeSpace
    public typealias Encoding = ModePhaseEncoding
    public typealias Predicate = ReverseSecondPhaseQuestion
}

/// A common sign reversal. It retains the relation between A and B, but
/// need not be unobservable if another coherently related branch is present.
public enum ReverseBothPhases<S: Pair>: PredicateReading
where S.Left: Pair, S.Right: Pair,
      S.Left.Left: Structure, S.Left.Right: Structure,
      S.Right.Left: Structure, S.Right.Right: Structure {
    public typealias Left = S
    public typealias Answer = SignedModes<
        S.Left.Right, S.Left.Left, S.Right.Right, S.Right.Left
    >
    public typealias Right = Answer
    public typealias Sigma = TwoModeSpace
    public typealias Encoding = ModePhaseEncoding
    public typealias Predicate = ReverseBothPhasesQuestion
}

public enum CoherentBranchSumQuestion: Close {}

/// The corresponding modes of two coherently aligned branches are additive
/// inverses. Their summed amplitude is zero without evaluating any term.
/// Alignment and the additive interpretation belong to this declared model.
public enum CancelOppositeBranches<W: Pair>: PredicateReading
where W.Left: Pair, W.Left.Left: Pair, W.Left.Right: Pair,
      W.Left.Left.Left: Structure, W.Left.Left.Right: Structure,
      W.Left.Right.Left: Structure, W.Left.Right.Right: Structure,
      W.Right == ReverseBothPhases<W.Left>.Answer {
    public typealias Left = W
    public typealias Answer = SignedModes<Never, Never, Never, Never>
    public typealias Right = Answer
    public typealias Sigma = TwoModeSpace
    public typealias Encoding = ModePhaseEncoding
    public typealias Predicate = CoherentBranchSumQuestion
}

/// Two resident four-place blocks. X uses exchange on the first block and
/// reversal on the second, while Z uses the opposite roles. Exchanging the
/// blocks therefore exchanges these action roles. This is a finite address
/// construction, without an amplitude mixer or probability rule. [IiS23]
public enum DualModeActions<
    A: Structure, B: Structure, C: Structure, D: Structure,
    E: Structure, F: Structure, G: Structure, H: Structure
>: Pair {
    public typealias First = SignedModes<A, B, C, D>
    public typealias Second = SignedModes<E, F, G, H>
    public typealias Left = Paired<First, Second>
    public typealias X = PairedApplication<ExchangeModes<First>, ReverseSecondPhase<Second>>
    public typealias Z = PairedApplication<ReverseSecondPhase<First>, ExchangeModes<Second>>
    public typealias Exchange = ExchangeModes<Left>
    public typealias N = PairedApplication<ReverseBothPhases<First>, ReverseBothPhases<Second>>
    public typealias Step = SequentialReading<Z, ExchangeModes<Z.Answer>>
    public typealias Right = Paired<X.Answer, Z.Answer>
}

/// The role exchange conjugates X to Z and Z to X. Four composed Steps
/// reverse all eight fields, while eight return their original arrangement.
/// Intermediate arrangements are bound at actual SequentialReading seams.
/// No final answer equality or group law is a caller premise. [IiS23]
public enum DualModeReturns<
    A: Structure, B: Structure, C: Structure, D: Structure,
    E: Structure, F: Structure, G: Structure, H: Structure
>: Null {
    public typealias M = DualModeActions<A, B, C, D, E, F, G, H>
    public typealias Exchanged = DualModeActions<E, F, G, H, A, B, C, D>
    public typealias TwiceExchange = SequentialReading<M.Exchange, Exchanged.Exchange>
    public typealias HX = SequentialReading<M.Exchange, Exchanged.X>
    public typealias HZ = SequentialReading<M.Exchange, Exchanged.Z>
    public typealias HXH = SequentialReading<HX, ExchangeModes<HX.Answer>>
    public typealias HZH = SequentialReading<HZ, ExchangeModes<HZ.Answer>>
    public typealias TwiceX = SequentialReading<M.X, DualModeActions<C, D, A, B, E, F, H, G>.X>
    public typealias TwiceZ = SequentialReading<M.Z, DualModeActions<A, B, D, C, G, H, E, F>.Z>
    public typealias ZX = SequentialReading<M.Z, DualModeActions<A, B, D, C, G, H, E, F>.X>
    public typealias Step1 = M.Step
    public typealias Step2 = SequentialReading<Step1, DualModeActions<G, H, E, F, A, B, D, C>.Step>
    public typealias Step3 = SequentialReading<Step2, DualModeActions<D, C, A, B, G, H, F, E>.Step>
    public typealias Step4 = SequentialReading<Step3, DualModeActions<F, E, G, H, D, C, B, A>.Step>
    public typealias Step5 = SequentialReading<Step4, DualModeActions<B, A, D, C, F, E, H, G>.Step>
    public typealias Step6 = SequentialReading<Step5, DualModeActions<H, G, F, E, B, A, C, D>.Step>
    public typealias Step7 = SequentialReading<Step6, DualModeActions<C, D, B, A, H, G, E, F>.Step>
    public typealias Step8 = SequentialReading<Step7, DualModeActions<E, F, H, G, C, D, A, B>.Step>
    public typealias Left = AddressTriple<
        AddressTriple<TwiceExchange.Answer, HXH.Answer, HZH.Answer>,
        Paired<TwiceX.Answer, TwiceZ.Answer>,
        AddressTriple<Step2.Answer, Step4.Answer, Step8.Answer>
    >
    public typealias Right = AddressTriple<
        AddressTriple<M.Left, M.Z.Answer, M.X.Answer>,
        Paired<M.Left, M.Left>,
        AddressTriple<ZX.Answer, M.N.Answer, M.Left>
    >
}
