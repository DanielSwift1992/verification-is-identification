import XCTest
import VerificationIsIdentification

final class NotationTests: XCTestCase {
    func testTheoryReexportsSharedConstructors() {
        XCTAssertEqual(VerificationIsIdentification.Paired<VerificationIsIdentification.Unit, Never>.count, 1)
        XCTAssertEqual(Tally<U4>.typeName, "4")
        XCTAssertEqual(Numeral._3.count, 1)
        func acceptsInteger<N: IntegerValued>(_: N.Type) {}
        acceptsInteger(Zero.self)
        acceptsInteger(Succ<Never>.self)
    }
}
