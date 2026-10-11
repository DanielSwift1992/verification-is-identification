import VerificationIsIdentification

/// Normal forms of the four acquired records. The producer equality below
/// is checked for arbitrary stage labels and K; these records have no such
/// parameters, nor any field carrying a private original source.
public enum FourLeafSelectionRecords: Close {
    public typealias Question = FourLeafSelected0<Never>.Selection.Predicate
    public typealias Fact0 = AnswerFact<BeamSpace, SaturationEncoding, Question, FourLeafAddressRoot.Select0.Address>
    public typealias Fact1 = AnswerFact<BeamSpace, SaturationEncoding, Question, FourLeafAddressRoot.Select1.Address>
    public typealias Fact2 = AnswerFact<BeamSpace, SaturationEncoding, Question, FourLeafAddressRoot.Select2.Address>
    public typealias Fact3 = AnswerFact<BeamSpace, SaturationEncoding, Question, FourLeafAddressRoot.Select3.Address>
}

/// Acquire the actually selected address in each of the four phase clauses,
/// then select that address from the new current root. The same contact is
/// an involution; the next ordinary U selection would be a different contact.
/// Each return retains its own acquired fact and arbitrary initial context K.
public enum FourLeafRecordedReturn<O: Structure, A: Structure, B: Structure,
    C: Structure, D: Structure, K: Structure>: Close {
    public typealias U = FourLeafControl<O, A, B, C, D, K>

    public typealias F0 = U.At0
    public typealias Keep0 = KeepSelectionInContext<F0.RecordedPrimitive.Answer>
    public typealias Context0 = Paired<FourLeafAddressProgram, Paired<K, FourLeafSelectionRecords.Fact0>>
    public typealias R0 = FourLeafControlRoot<A, O, B, C, D,
        Never, Lit1, Never, Never, Context0>
    public typealias I0 = RecordedLocalChoiceInput<R0.Left>
    public typealias Back0 = SelectedLocalApplication<R0, I0, ReadLocalChoice<I0.Answer>, R0.Select0>
    public typealias Expose0 = ExposeSelectionBesideTarget<Back0.Answer>
    public typealias Path0 = FollowedPair<F0.RecordedPrimitive,
        FollowedPair<Keep0, FollowedPair<Back0, Expose0>>>

    public typealias F1 = U.At1
    public typealias Keep1 = KeepSelectionInContext<F1.RecordedPrimitive.Answer>
    public typealias Context1 = Paired<FourLeafAddressProgram, Paired<K, FourLeafSelectionRecords.Fact1>>
    public typealias R1 = FourLeafControlRoot<B, A, O, C, D,
        Never, Never, Lit1, Never, Context1>
    public typealias I1 = RecordedLocalChoiceInput<R1.Left>
    public typealias Back1 = SelectedLocalApplication<R1, I1, ReadLocalChoice<I1.Answer>, R1.Select1>
    public typealias Expose1 = ExposeSelectionBesideTarget<Back1.Answer>
    public typealias Path1 = FollowedPair<F1.RecordedPrimitive,
        FollowedPair<Keep1, FollowedPair<Back1, Expose1>>>

    public typealias F2 = U.At2
    public typealias Keep2 = KeepSelectionInContext<F2.RecordedPrimitive.Answer>
    public typealias Context2 = Paired<FourLeafAddressProgram, Paired<K, FourLeafSelectionRecords.Fact2>>
    public typealias R2 = FourLeafControlRoot<C, A, B, O, D,
        Never, Never, Never, Lit1, Context2>
    public typealias I2 = RecordedLocalChoiceInput<R2.Left>
    public typealias Back2 = SelectedLocalApplication<R2, I2, ReadLocalChoice<I2.Answer>, R2.Select2>
    public typealias Expose2 = ExposeSelectionBesideTarget<Back2.Answer>
    public typealias Path2 = FollowedPair<F2.RecordedPrimitive,
        FollowedPair<Keep2, FollowedPair<Back2, Expose2>>>

    public typealias F3 = U.At3
    public typealias Keep3 = KeepSelectionInContext<F3.RecordedPrimitive.Answer>
    public typealias Context3 = Paired<FourLeafAddressProgram, Paired<K, FourLeafSelectionRecords.Fact3>>
    public typealias R3 = FourLeafControlRoot<D, A, B, C, O,
        Lit1, Never, Never, Never, Context3>
    public typealias I3 = RecordedLocalChoiceInput<R3.Left>
    public typealias Back3 = SelectedLocalApplication<R3, I3, ReadLocalChoice<I3.Answer>, R3.Select3>
    public typealias Expose3 = ExposeSelectionBesideTarget<Back3.Answer>
    public typealias Path3 = FollowedPair<F3.RecordedPrimitive,
        FollowedPair<Keep3, FollowedPair<Back3, Expose3>>>

    public enum AcquiredRecords: Null {
        public typealias Left = BoundaryWorking<F0.RecordedPrimitive.Answer.Right,
            F1.RecordedPrimitive.Answer.Right, F2.RecordedPrimitive.Answer.Right, F3.RecordedPrimitive.Answer.Right>
        public typealias Right = BoundaryWorking<FourLeafSelectionRecords.Fact0, FourLeafSelectionRecords.Fact1,
            FourLeafSelectionRecords.Fact2, FourLeafSelectionRecords.Fact3>
    }
    public enum TargetsReturnWithTheirFacts: Null {
        public typealias Left = BoundaryWorking<Path0.Right, Path1.Right, Path2.Right, Path3.Right>
        public typealias Right = BoundaryWorking<Paired<F0.Left, F0.SelectionFact>,
            Paired<F1.Left, F1.SelectionFact>, Paired<F2.Left, F2.SelectionFact>, Paired<F3.Left, F3.SelectionFact>>
    }
    public enum SameSelectionQuestion: Null {
        public typealias Left = AddressTriple<F1.SelectionFact.Predicate,
            F2.SelectionFact.Predicate, F3.SelectionFact.Predicate>
        public typealias Right = AddressTriple<F0.SelectionFact.Predicate,
            F0.SelectionFact.Predicate, F0.SelectionFact.Predicate>
    }
}
