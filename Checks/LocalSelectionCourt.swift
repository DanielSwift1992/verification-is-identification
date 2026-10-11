import VerificationIsIdentification
import Examples

// Use with LocalPolicyCourt.swift. Its conditional LocalCourtSame declaration
// demands these equalities in Swift. The gate adapter also presents this
// complete case, but currently expects a reader limit at SelectCandidateLeft's
// declaration-level where clause; it must not report that limit as inequality.
public typealias SelectionCourtSource = Paired<Never, Never>
public typealias SelectionCourtFirst = FirstEvidenceImage<
    SelectionCourtSource, BeamSpace, SaturationEncoding, AcquisitionChoice>
public typealias SelectionCourtSecond = SecondEvidenceImage<
    SelectionCourtSource, BeamSpace, SaturationEncoding, AcquisitionChoice>
public typealias SelectionCourtCatalogue = CandidateFork<
    CandidateLeaf<SelectionCourtFirst>, CandidateLeaf<SelectionCourtSecond>>
public typealias SelectionCourtChoose0 = SelectCandidateLeft<
    SelectCandidateLeaf<SelectionCourtFirst>, CandidateLeaf<SelectionCourtSecond>>
public typealias SelectionCourtChoose1 = SelectCandidateRight<
    CandidateLeaf<SelectionCourtFirst>, SelectCandidateLeaf<SelectionCourtSecond>>
public typealias SelectionCourtCounterfeit = SelectCandidateLeft<
    SelectCandidateLeaf<SelectionCourtSecond>, CandidateLeaf<SelectionCourtSecond>>
public typealias SelectionCourtBorrowed = FirstEvidenceImage<
    Paired<Never, Lit1>, BeamSpace, SaturationEncoding, AcquisitionChoice>

public typealias SelectionCourtRoot0 = LocalCourtSame<SelectionCourtChoose0.Left, SelectionCourtCatalogue>
public typealias SelectionCourtRoot1 = LocalCourtSame<SelectionCourtChoose1.Left, SelectionCourtCatalogue>
public typealias SelectionCourtActual0 = LocalCourtSame<SelectionCourtChoose0.Right, SelectionCourtFirst>
public typealias SelectionCourtActual1 = LocalCourtSame<SelectionCourtChoose1.Right, SelectionCourtSecond>
public typealias SelectionCourtSource0 = LocalCourtSame<SelectionCourtChoose0.Right.Left, SelectionCourtSource>
public typealias SelectionCourtSource1 = LocalCourtSame<SelectionCourtChoose1.Right.Left, SelectionCourtSource>
public typealias SelectionCourtEqualLabels = LocalCourtSame<SelectionCourtFirst.Predicate, SelectionCourtSecond.Predicate>
public typealias SelectionCourtEqualAnswers = LocalCourtSame<SelectionCourtFirst.Answer, SelectionCourtSecond.Answer>

public typealias SelectionCourtUsesRoot0 = LocalCourtUse<SelectionCourtRoot0>
public typealias SelectionCourtUsesRoot1 = LocalCourtUse<SelectionCourtRoot1>
public typealias SelectionCourtUsesActual0 = LocalCourtUse<SelectionCourtActual0>
public typealias SelectionCourtUsesActual1 = LocalCourtUse<SelectionCourtActual1>
public typealias SelectionCourtUsesSource0 = LocalCourtUse<SelectionCourtSource0>
public typealias SelectionCourtUsesSource1 = LocalCourtUse<SelectionCourtSource1>
public typealias SelectionCourtUsesEqualLabels = LocalCourtUse<SelectionCourtEqualLabels>
public typealias SelectionCourtUsesEqualAnswers = LocalCourtUse<SelectionCourtEqualAnswers>
