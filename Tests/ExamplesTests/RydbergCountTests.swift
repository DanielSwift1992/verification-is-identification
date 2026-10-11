import XCTest
import VerificationIsIdentification
import Examples

// These are readings of the declared examples through the built library.
// No independently named Plus/Times evaluator supplies their values.
final class RydbergCountTests: XCTestCase {
    private func checkCount<R: Pair>(
        _ relation: R.Type, file: StaticString = #filePath, line: UInt = #line
    ) where R.Left: Structure, R.Right: Structure {
        XCTAssertEqual(R.Left.count, R.Right.count,
            "Count mismatch in \(R.self)", file: file, line: line)
    }

    func testDeclaredEnergyStitchesThroughTheirOwnCountReading() {
        checkCount(ThirdFloorStitch.self)
        checkCount(SecondFloorStitch.self)
        checkCount(GroundFloorStitch.self)
        checkCount(TwoRoadsOneDrop.self)
    }

    // Foundation, imported by XCTest, also declares a Unit type.
    func testEqualCountsDoNotIdentifyTheirSources() {
        typealias One = VerificationIsIdentification.Unit
        XCTAssertEqual(Plus<One, Never>.count, Plus<Never, One>.count)
        XCTAssertNotEqual(ObjectIdentifier(Plus<One, Never>.self),
                          ObjectIdentifier(Plus<Never, One>.self))
    }
}
