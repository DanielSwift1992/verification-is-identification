import VerificationIsIdentification

public enum VisiblePartnerExchangeQuestion: Close {}
public enum PrivatePartnerFieldsQuestion: Close {}

/// Exchange the actual visible fields while a source-bound reading supplies
/// arbitrary private results. No autonomy of the private update is assumed.
public enum VisiblePartnerExchange<S: Pair, R: PredicateReading>: PredicateReading
where S.Left: Pair, S.Right: Pair,
      S.Left.Left: Structure, S.Right.Left: Structure,
      R.Left == S, R.Answer: Pair,
      R.Answer.Left: Structure, R.Answer.Right: Structure,
      R.Sigma == BeamSpace, R.Encoding == SaturationEncoding {
    public typealias Left = S
    public typealias Answer = Paired<
        Paired<S.Right.Left, R.Answer.Left>,
        Paired<S.Left.Left, R.Answer.Right>>
    public typealias Right = Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = VisiblePartnerExchangeQuestion
}

/// Two potentially different complete sources and private updates share
/// only their two visible input fields. Their visible replies agree.
public enum VisiblePartnerAgreement<S: Pair, T: Pair,
    R: PredicateReading, Q: PredicateReading>: Null
where S.Left: Pair, S.Right: Pair, T.Left: Pair, T.Right: Pair,
      S.Left.Left: Structure, S.Right.Left: Structure,
      S.Left.Left == T.Left.Left, S.Right.Left == T.Right.Left,
      R.Left == S, Q.Left == T, R.Answer: Pair, Q.Answer: Pair,
      R.Answer.Left: Structure, R.Answer.Right: Structure,
      Q.Answer.Left: Structure, Q.Answer.Right: Structure,
      R.Sigma == BeamSpace, Q.Sigma == BeamSpace,
      R.Encoding == SaturationEncoding, Q.Encoding == SaturationEncoding {
    public typealias A = VisiblePartnerExchange<S, R>
    public typealias B = VisiblePartnerExchange<T, Q>
    public typealias Left = Paired<A.Answer.Left.Left, A.Answer.Right.Left>
    public typealias Right = Paired<B.Answer.Left.Left, B.Answer.Right.Left>
}

/// The private identity case reads its two fields at their actual addresses.
public enum PrivatePartnerFields<S: Pair>: PredicateReading
where S.Left: Pair, S.Right: Pair,
      S.Left.Right: Structure, S.Right.Right: Structure {
    public typealias Left = S
    public typealias Answer = Paired<S.Left.Right, S.Right.Right>
    public typealias Right = Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = PrivatePartnerFieldsQuestion
}

/// Canonical four-field input: two exchanges return the complete input,
/// not just its visible image or an arbitrary nominal pair shell.
public enum VisiblePartnerReturn<A: Structure, P: Structure,
    B: Structure, Q: Structure>: Null {
    public typealias Source = Paired<Paired<A, P>, Paired<B, Q>>
    public typealias First = VisiblePartnerExchange<Source, PrivatePartnerFields<Source>>
    public typealias Second = VisiblePartnerExchange<First.Answer, PrivatePartnerFields<First.Answer>>
    public typealias Both = SequentialReading<First, Second>
    public typealias Left = Both.Answer
    public typealias Right = Source
}

/// Two clauses of the declared binary-control contact. The partner is
/// retained. Their actual outputs, not a common tag, give the two laws.
public typealias IdlePartner<P: Pair> = ReadingBesideInput<
    IdentityReading<P, BeamSpace, SaturationEncoding>, Never>
where P.Left: Structure, P.Right: Structure

public typealias ExposingPartner<P: Pair> = ReadingBesideInput<
    SwapBoundaryReading<P>, Lit1>
where P.Left: Structure, P.Right: Structure

public enum FreshPartnerContrast<A: Structure>: Close {
    public typealias X = Paired<A, Never>
    public typealias Y = Paired<A, Lit1>
    public typealias OldX = IdlePartner<X>
    public typealias OldY = IdlePartner<Y>
    public typealias NewX = ExposingPartner<X>
    public typealias NewY = ExposingPartner<Y>
    public typealias ReturnX = SequentialReading<NewX, ExposingPartner<NewX.Answer.Left>>
    public typealias ReturnY = SequentialReading<NewY, ExposingPartner<NewY.Answer.Left>>
    public enum OldReplies: Null {
        public typealias Left = OldX.Answer.Left.Left
        public typealias Right = OldY.Answer.Left.Left
    }
    public enum NewReplies: Null {
        public typealias Left = Paired<NewX.Answer.Left.Left, NewY.Answer.Left.Left>
        public typealias Right = Paired<Never, Lit1>
    }
    public enum ReturnAndPartner: Null {
        public typealias Left = Paired<
            Paired<ReturnX.Answer, ReturnY.Answer>,
            Paired<NewX.Answer.Right, NewY.Answer.Right>>
        public typealias Right = Paired<
            Paired<NewX.Left, NewY.Left>, Paired<Lit1, Lit1>>
    }
}
