import XCTest
import Examples

// Smoke checks for supplied examples and runtime presentation data. Generic
// implications and targeted refusals are checked in Checks/*.swift. These
// tests do not establish a physical model from its interface name.
final class DemoTests: XCTestCase {

    // Interface witnesses and the declared local vertex list.
    func testInstancesCrystallize() throws {
        _ = IceOxygen.self
        _ = QuantumMeasurement.self
        _ = HiggsGaugeInvariant.self
        let iceSurvivors: [Any.Type] = [
            HydrogenSurvivor1.self, HydrogenSurvivor2.self, HydrogenSurvivor3.self,
            HydrogenSurvivor4.self, HydrogenSurvivor5.self, HydrogenSurvivor6.self,
        ]
        XCTAssertEqual(iceSurvivors.count, 6, "ice admits 6 of 16 two-in/two-out vertices")
        XCTAssertFalse(hydrogenLines.isEmpty, "the E1 rule Δℓ = ±1 admits a spectrum")
        XCTAssertFalse(allowedReactions.isEmpty, "baryon number admits the conserving reactions")
        print("examples: interface witnesses, six declared ice vertices, admitted rule examples")
    }

    // The V=I loop as a scheduler — one forced assignment, |S| = 1.
    func testSchedulerCrystallizes() throws {
        _ = CrystallizedSchedule.self
        _ = ClosingConflict.self
        _ = PinnedScheduleIsForced<T0, T1, T2, T3>.self
        print("scheduler: assignment forced, |S|=1 — verification is identification")
    }
}
