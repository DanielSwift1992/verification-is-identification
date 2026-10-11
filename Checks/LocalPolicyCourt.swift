import VerificationIsIdentification
import Examples

// These are applications of the current lookup definitions. The separate
// court reads their source declarations verbatim; no lookup table is copied.
public protocol LocalCourtHolds {}
public enum LocalCourtSame<A, B> {}
extension LocalCourtSame: LocalCourtHolds
where A == B {}
public enum LocalCourtUse<C: LocalCourtHolds> {}

public typealias CourtPolicy = Paired<SecondProjection, FirstProjection>
public typealias CourtRenamedPolicy = Paired<FirstProjection, SecondProjection>
public typealias CourtZero = LocalPolicyAtZero<CourtPolicy>
public typealias CourtOne = LocalPolicyAtOne<CourtPolicy>
public typealias CourtRenamedZero = LocalPolicyAtOne<CourtRenamedPolicy>
public typealias CourtRenamedOne = LocalPolicyAtZero<CourtRenamedPolicy>

public typealias CourtZeroChoice = LocalCourtSame<CourtZero.Right, SecondProjection>
public typealias CourtOneChoice = LocalCourtSame<CourtOne.Right, FirstProjection>
public typealias CourtZeroInput = LocalCourtSame<CourtZero.Left, Paired<Never, CourtPolicy>>
public typealias CourtOneInput = LocalCourtSame<CourtOne.Left, Paired<Lit1, CourtPolicy>>
public typealias CourtZeroRenaming = LocalCourtSame<CourtZero.Right, CourtRenamedZero.Right>
public typealias CourtOneRenaming = LocalCourtSame<CourtOne.Right, CourtRenamedOne.Right>

// Make every gate obligation an actual conformance use in Swift as well.
public typealias CourtUsesZeroChoice = LocalCourtUse<CourtZeroChoice>
public typealias CourtUsesOneChoice = LocalCourtUse<CourtOneChoice>
public typealias CourtUsesZeroInput = LocalCourtUse<CourtZeroInput>
public typealias CourtUsesOneInput = LocalCourtUse<CourtOneInput>
public typealias CourtUsesZeroRenaming = LocalCourtUse<CourtZeroRenaming>
public typealias CourtUsesOneRenaming = LocalCourtUse<CourtOneRenaming>
