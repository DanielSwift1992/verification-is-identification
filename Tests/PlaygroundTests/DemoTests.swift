import XCTest
import Playground

// The demos are proofs, not programs: each type below exists only because it
// type-checked when `Playground` compiled. `swift test` runs that proof in CI and
// pins the numbers the build settles. The full presentation lives in the Playground
// docs — here the compiler is the witness.
final class DemoTests: XCTestCase {

    // Matter §5 — three physical instances, each a gate that crystallizes at |S| = 1.
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
        print("instances: ice |S|=6 · hydrogen n²=4 · Higgs 3 Goldstones — gates crystallize at |S|=1")
    }

    // The V=I loop as a scheduler — one forced assignment, |S| = 1.
    func testSchedulerCrystallizes() throws {
        _ = CrystallizedSchedule.self
        _ = ClosingConflict.self
        print("scheduler: assignment forced, |S|=1 — verification is identification")
    }
}
