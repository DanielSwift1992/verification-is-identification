import VerificationIsIdentification
import Examples

// LocalCourtSame/Use are the existing equality gate in LocalPolicyCourt.
// These are concrete applications of current fields, not a generic theorem.
public typealias CourtBoundary = AlternativeBoundaryProduct
public typealias CourtBoundaryWhole = CourtBoundary.Product.Whole

public typealias BoundaryCourtRecoversFirst = LocalCourtSame<
    AddressTriple<CourtBoundaryWhole.Left.Left,
        CourtBoundaryWhole.Right.Left.Left, CourtBoundaryWhole.Right.Right.Left>,
    AddressTriple<Never, Never, Lit1>>
public typealias UseBoundaryCourtRecoversFirst = LocalCourtUse<BoundaryCourtRecoversFirst>
public typealias BoundaryCourtRecoversSecond = LocalCourtSame<
    AddressTriple<CourtBoundaryWhole.Left.Right,
        CourtBoundaryWhole.Right.Left.Right, CourtBoundaryWhole.Right.Right.Right>,
    AddressTriple<Never, Lit1, Never>>
public typealias UseBoundaryCourtRecoversSecond = LocalCourtUse<BoundaryCourtRecoversSecond>

public typealias BoundaryCourtFirstAlias = LocalCourtSame<
    CourtBoundaryWhole.Left.Left, CourtBoundaryWhole.Right.Left.Left>
public typealias UseBoundaryCourtFirstAlias = LocalCourtUse<BoundaryCourtFirstAlias>
public typealias BoundaryCourtSecondAlias = LocalCourtSame<
    CourtBoundaryWhole.Left.Right, CourtBoundaryWhole.Right.Right.Right>
public typealias UseBoundaryCourtSecondAlias = LocalCourtUse<BoundaryCourtSecondAlias>

public typealias BoundaryCourtABContrast = LocalCourtSame<
    Paired<CourtBoundary.ABFirst.Answer, CourtBoundary.ABSecond.Answer>, Paired<Never, Lit1>>
public typealias UseBoundaryCourtABContrast = LocalCourtUse<BoundaryCourtABContrast>
public typealias BoundaryCourtACContrast = LocalCourtSame<
    Paired<CourtBoundary.ACFirst.Answer, CourtBoundary.ACSecond.Answer>, Paired<Never, Lit1>>
public typealias UseBoundaryCourtACContrast = LocalCourtUse<BoundaryCourtACContrast>

public typealias BoundaryCourtABSource = LocalCourtSame<
    Paired<CourtBoundary.ABFirst.Left, CourtBoundary.ABSecond.Left>,
    Paired<CourtBoundaryWhole.Left, CourtBoundaryWhole.Right.Left>>
public typealias UseBoundaryCourtABSource = LocalCourtUse<BoundaryCourtABSource>
public typealias BoundaryCourtACSource = LocalCourtSame<
    Paired<CourtBoundary.ACFirst.Left, CourtBoundary.ACSecond.Left>,
    Paired<CourtBoundaryWhole.Left, CourtBoundaryWhole.Right.Right>>
public typealias UseBoundaryCourtACSource = LocalCourtUse<BoundaryCourtACSource>

// The equality-only court does not establish inline generic argument bounds.
// The selected Swift branch must fail admission even though its expanded
// field expression is reflexive in the court's term language.
#if LOCAL_PHASE_CONTACT_BOUNDARY_COURT_ADMISSION
public enum BoundaryCourtUnadmitted {}
public typealias RejectedBoundaryCourtAdmission = LocalCourtSame<
    ProductBoundary<BoundaryCourtUnadmitted, Never, Never, Never, Never, Never>.First.Left,
    BoundaryCourtUnadmitted>
public typealias UseRejectedBoundaryCourtAdmission = LocalCourtUse<RejectedBoundaryCourtAdmission>
#endif
