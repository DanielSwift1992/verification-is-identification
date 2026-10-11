import VerificationIsIdentification
import Examples

#if !RELATIVE_CORRECTION_MORE_ERRORS && !RELATIVE_CORRECTION_SOURCE
enum TheThreeRepeatedCasesAgreeOnTheirActualOverlap<Q: Structure>: Null {
    typealias C = RepeatedAnswerOverlap<Paired<Q, Paired<Q, Q>>>
    typealias Left = C.Left
    typealias Right = C.Right
}

enum AnyOneChangedPathAnswerIsCorrected<Q: Structure, X: Structure>: Null {
    typealias C = OneDefectTriple<Q, X>
    typealias Left = C.AllAnswers.Left
    typealias Right = C.AllAnswers.Right
}

enum CorrectionKeepsEveryOriginalTriple<Q: Structure, X: Structure>: Null {
    typealias C = OneDefectTriple<Q, X>
    typealias Left = C.RetainedRecords.Left
    typealias Right = C.RetainedRecords.Right
}

enum BothBinaryAnswersAndAllChangedPathPositionsAreCovered: Null {
    typealias Z = OneDefectTriple<Never, Examples.Succ<Never>>
    typealias O = OneDefectTriple<Examples.Succ<Never>, Never>
    typealias Left = Paired<Z.AllAnswers.Left, O.AllAnswers.Left>
    typealias Right = Paired<Z.AllAnswers.Right, O.AllAnswers.Right>
}

enum TheLargerDefectFamilySharesOneAvailableRecord: Null {
    typealias C = WiderDefectAmbiguity
    typealias Left = Paired<C.SameAvailableRecord.Left, C.AnswerAndAlternative.Left>
    typealias Right = Paired<C.SameAvailableRecord.Right, C.AnswerAndAlternative.Right>
}

enum EqualCorrectedAnswersDoNotDiscardTheChangedRecord: Null {
    typealias C = OneDefectTriple<Never, Examples.Succ<Never>>
    typealias Left = Paired<Paired<C.A.Answer, C.C.Answer>,
        Paired<C.RecordedA.Right.Left.Left, C.RecordedC.Right.Left.Left>>
    typealias Right = Paired<Paired<Never, Never>, Paired<Examples.Succ<Never>, Never>>
}
#endif

#if RELATIVE_CORRECTION_MORE_ERRORS
enum RejectedOneErrorConclusionCoversTwoErrors: Null {
    typealias Left = WiderDefectAmbiguity.Decoder.Answer
    typealias Right = Examples.Succ<Never>
}
#endif

#if RELATIVE_CORRECTION_SOURCE
enum RejectedCorrectedAnswerIdentifiesTheAvailableTriple: Null {
    typealias C = OneDefectTriple<Never, Examples.Succ<Never>>
    typealias Left = C.RecordedA.Right.Left.Left
    typealias Right = C.RecordedC.Right.Left.Left
}
#endif
