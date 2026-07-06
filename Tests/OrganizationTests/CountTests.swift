import XCTest
import Organization

// `count` (VerificationIsIdentification/Primitive.swift) replaced the cons-list `.Length` for
// every `Open` type composed through `@StructureBuilder`. The risk it guards against: an
// `Employee` is `Pair`-shaped (`Open` via `Pair`, for its `Rank`/`Home` coordinate) but never
// customizes its own `body`, so without the `Body == Never` leaf rule it would silently count
// as zero — exactly the case a roster's members are made of. These pin the numbers so a
// regression (a leaf collapsing back to zero) fails the build, not just a printed total.
final class CountTests: XCTestCase {

    func testEmployeeLeavesCountAsOne() {
        XCTAssertEqual(Emp0002.count, 1, "an Employee atom is a leaf, not an empty composition")
    }

    func testBatchCountsItsEmployees() {
        XCTAssertEqual(Batch2026.count, 10, "ten employees listed in the body")
    }

    func testPasswordCountsItsDigits() {
        XCTAssertEqual(AlicePass.count, 4, "four digits listed in the body")
    }

    func testStandingReportCountsItsInvariants() {
        XCTAssertEqual(StandingReport.count, 4, "four invariants proved this build")
    }

    func testAllPlacesCountsTheSiteOrder() {
        XCTAssertEqual(AllPlaces.count, 10, "ten places in the navigation — sign-in is a card's own link, not a place")
    }

    func testCertifiedRulesCountsTheClasses() {
        XCTAssertEqual(CertifiedRules.count, 4, "one certified rule per department")
    }

    // GeneratedTeam.swift (private/gen_org.py) — `Company`/`AllAccesses` and the department/rank/
    // site `Team` types, converted from hand-authored `Hire<…>`/`Proven<…>`/`AlsoInDepartment<…>`
    // cons-chains to `body`-composed leaves (`VerifiedInDepartment`/`VerifiedAtRank`/
    // `VerifiedAtWorkplace`/`VerifiedView`, Filtering.swift). These pin the same numbers the old
    // `.Length` read off the chains, so the conversion is provably size-preserving.

    func testCompanyCountsTheWholeRoster() {
        XCTAssertEqual(Company.count, 200, "two hundred employees generated")
    }

    func testAllAccessesCountsEveryProof() {
        XCTAssertEqual(AllAccesses.count, 200, "one verified view per employee")
    }

    func testDepartmentTeamsPartitionTheRoster() {
        // Uneven by design (`GenerateOrg.deptSteps`'s own dwell-time comment) — a variable
        // period instead of a fixed one, so the four counts do not land on the same number the
        // way an exact `i % 4` would. The one invariant that must hold regardless of the exact
        // split is that they partition the WHOLE roster — every employee in exactly one team.
        XCTAssertEqual(FinanceTeam.count, 45)
        XCTAssertEqual(EngineeringTeam.count, 71)
        XCTAssertEqual(SalesTeam.count, 56)
        XCTAssertEqual(PeopleTeam.count, 28)
        XCTAssertEqual(FinanceTeam.count + EngineeringTeam.count + SalesTeam.count + PeopleTeam.count, Company.count)
    }

    func testRankTeamsPartitionTheRoster() {
        XCTAssertEqual(IndividualContributorTeam.count, 67)
        XCTAssertEqual(LeadTeam.count, 67)
        XCTAssertEqual(ManagerTeam.count, 66)
    }

    func testSiteTeamsPartitionTheRoster() {
        XCTAssertEqual(OnSiteTeam.count, 68)
        XCTAssertEqual(HybridTeam.count, 66)
        XCTAssertEqual(RemoteTeam.count, 66)
    }

    // `labels` (VerificationIsIdentification/Primitive.swift) — the third `Structure` reading,
    // each leaf's own name in body order. Guards the same leaf-collapse risk `count` guards.

    func testEmployeeLeafLabelsItself() {
        XCTAssertEqual(Emp0002.labels, ["Emp0002"])
    }

    func testBatchListsItsEmployeesInOrder() {
        XCTAssertEqual(Batch2026.labels, [
            "Emp0002", "Emp0100", "Emp0101", "Emp0102", "Emp0103",
            "Emp0104", "Emp0105", "Emp0106", "Emp0107", "Emp0108",
        ])
    }
}
