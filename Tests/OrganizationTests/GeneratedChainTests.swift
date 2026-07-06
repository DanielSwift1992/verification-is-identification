import XCTest
import Organization

// The generated roster's attributes are DERIVED, not looked up: private/gen_org.py decides only
// WHEN a field steps (a period boundary), and the compiler resolves the actual value by
// chasing `.Next` back to `Emp0000` (the pinned seed) — the same propagation `Coloring.swift`'s
// `Conflicts<Prev>` uses for its scheduler. These pin the chain at a few points so a
// regression (a `.Next` cycle wired wrong) fails the build, not just a silently wrong roster.
final class GeneratedChainTests: XCTestCase {
    func testChainDerivedAttributes() {
        // Emp0000 is the pinned seed.
        XCTAssertEqual(String(describing: Emp0000.Home.self), "Finance")
        XCTAssertEqual(String(describing: Emp0000.Rank.self), "IndividualContributor")
        // Emp0001: Rank/Given step every hire; Family/Born/Site do not (yet). Home does not
        // step every hire — it DWELLS (a variable period, `GenerateOrg.deptSteps`, so 200 hires
        // split unevenly across departments instead of an exact 50/50/50/50) — Finance holds
        // the first three hires (i=0,1,2) before its first step at i=3.
        XCTAssertEqual(String(describing: Emp0001.Home.self), "Finance")
        XCTAssertEqual(String(describing: Emp0001.Rank.self), "Lead")
        XCTAssertEqual(String(describing: Emp0001.Given.self), "Barbara")
        XCTAssertEqual(String(describing: Emp0001.Family.self), "Dijkstra")
        XCTAssertEqual(String(describing: Emp0001.Site.self), "OnSite")
        // Emp0003: Site steps for the first time (i=3, i%3==0); Home ALSO steps for the first
        // time here (i=3 is a `deptSteps` boundary) — Finance's three-hire dwell just ended.
        XCTAssertEqual(String(describing: Emp0003.Site.self), "Hybrid")
        XCTAssertEqual(String(describing: Emp0003.Home.self), "Engineering")
        // Emp0004: still inside Engineering's five-hire dwell (i=4..7), not yet stepped again.
        XCTAssertEqual(String(describing: Emp0004.Home.self), "Engineering")
        // Emp0012: Family steps for the first time (i=12, i%12==0).
        XCTAssertEqual(String(describing: Emp0012.Family.self), "Liskov")
        XCTAssertEqual(String(describing: Emp0012.Given.self), "Edsger")   // Given wraps every 12 too
        // Sex reads off Given, not its own chain.
        XCTAssertEqual(String(describing: Emp0001.Sex.self), "Female")   // Barbara → Female
    }
}
