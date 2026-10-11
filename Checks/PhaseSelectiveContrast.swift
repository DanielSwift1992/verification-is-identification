import VerificationIsIdentification
import Examples

enum PhaseContrastWorksForArbitraryCoefficients<
    A: Structure, B: Structure, C: Structure, D: Structure,
    E: Structure, F: Structure, G: Structure, H: Structure
>: Null {
    typealias P = PhaseSelectiveContrast<A, B, C, D, E, F, G, H>
    typealias Left = Paired<Paired<P.ContactsCommute.Left, P.ContactsReturn.Left>,
        Paired<P.SuppressedTermsCancel.Left, P.TargetAppearsFourTimes.Left>>
    typealias Right = Paired<Paired<P.ContactsCommute.Right, P.ContactsReturn.Right>,
        Paired<P.SuppressedTermsCancel.Right, P.TargetAppearsFourTimes.Right>>
}

typealias UnitTargetContrast = PhaseSelectiveContrast<Never, Never,
    Never, Never, Never, Never, Examples.Succ<Never>, Never>

enum DoubleContactRestoresTheTarget: Null {
    typealias Left = UnitTargetContrast.R3.Right.Right
    typealias Right = UnitTargetContrast.Source.Right.Right
}

enum OneContactActuallyReversesTheTarget: Null {
    typealias Left = UnitTargetContrast.U.Answer.Right.Right
    typealias Right = Paired<Never, Examples.Succ<Never>>
}

#if PHASE_CONTRAST_ERASES_TARGET
typealias RejectedSelectedNonzeroTargetIsCancelled = CancelOppositeBranches<
    UnitTargetContrast.TargetTerms>
#endif

#if PHASE_CONTRAST_MISSING_CORNER
enum RejectedSingleControlSuppliesTheDoubleControlCorner: Null {
    typealias Left = UnitTargetContrast.U.Answer
    typealias Right = UnitTargetContrast.UV.Answer
}
#endif
