import VerificationIsIdentification

/// Four formal signed coefficients B,H,K,C. Two actual phase contacts
/// reverse H,C and K,C respectively. The four weighted observations below
/// certify a contrast before assigning complex values to the coefficients.
/// This source-side proof does not give a decoder private coefficient access.
public enum PhaseSelectiveContrast<
    BP: Structure, BN: Structure, HP: Structure, HN: Structure,
    KP: Structure, KN: Structure, CP: Structure, CN: Structure
>: Close {
    public typealias Source = Paired<SignedModes<BP, BN, HP, HN>,
        SignedModes<KP, KN, CP, CN>>
    public typealias U = PairedApplication<ReverseSecondPhase<Source.Left>,
        ReverseSecondPhase<Source.Right>>
    public typealias V = PairedApplication<
        IdentityReading<Source.Left, TwoModeSpace, ModePhaseEncoding>,
        ReverseBothPhases<Source.Right>>
    public typealias UV = SequentialReading<U, PairedApplication<
        IdentityReading<U.Answer.Left, TwoModeSpace, ModePhaseEncoding>,
        ReverseBothPhases<U.Answer.Right>>>
    public typealias VU = SequentialReading<V, PairedApplication<
        ReverseSecondPhase<V.Answer.Left>, ReverseSecondPhase<V.Answer.Right>>>
    public typealias UU = SequentialReading<U, PairedApplication<
        ReverseSecondPhase<U.Answer.Left>, ReverseSecondPhase<U.Answer.Right>>>
    public typealias VV = SequentialReading<V, PairedApplication<
        IdentityReading<V.Answer.Left, TwoModeSpace, ModePhaseEncoding>,
        ReverseBothPhases<V.Answer.Right>>>
    public typealias NegativeU = PairedApplication<
        ReverseBothPhases<U.Answer.Left>, ReverseBothPhases<U.Answer.Right>>
    public typealias NegativeV = PairedApplication<
        ReverseBothPhases<V.Answer.Left>, ReverseBothPhases<V.Answer.Right>>
    public typealias R0 = Source
    public typealias R1 = NegativeU.Answer
    public typealias R2 = NegativeV.Answer
    public typealias R3 = UV.Answer

    // Pair the actual signed contributions into opposite branches.
    // Commutative addition interprets these fixed regroupings as the same sum.
    public typealias CancelBackground = CancelOppositeBranches<Paired<
        Paired<R0.Left.Left, R3.Left.Left>,
        Paired<R1.Left.Left, R2.Left.Left>>>
    public typealias CancelFirst = CancelOppositeBranches<Paired<
        Paired<R0.Left.Right, R1.Left.Right>,
        Paired<R2.Left.Right, R3.Left.Right>>>
    public typealias CancelSecond = CancelOppositeBranches<Paired<
        Paired<R0.Right.Left, R2.Right.Left>,
        Paired<R1.Right.Left, R3.Right.Left>>>
    public typealias TargetTerms = Paired<Paired<R0.Right.Right, R1.Right.Right>,
        Paired<R2.Right.Right, R3.Right.Right>>

    public enum ContactsCommute: Null {
        public typealias Left = UV.Answer
        public typealias Right = VU.Answer
    }
    public enum ContactsReturn: Null {
        public typealias Left = Paired<UU.Answer, VV.Answer>
        public typealias Right = Paired<Source, Source>
    }
    public enum SuppressedTermsCancel: Null {
        public typealias Left = Paired<CancelBackground.Answer,
            Paired<CancelFirst.Answer, CancelSecond.Answer>>
        public typealias Zero = SignedModes<Never, Never, Never, Never>
        public typealias Right = Paired<Zero, Paired<Zero, Zero>>
    }
    public enum TargetAppearsFourTimes: Null {
        public typealias C = Source.Right.Right
        public typealias Left = TargetTerms
        public typealias Right = Paired<Paired<C, C>, Paired<C, C>>
    }
}
