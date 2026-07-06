import XCTest
import VerificationIsIdentification
import DocumentKit

// The realizer keeps an unspelled name (users never write `DoorOf<...>` directly); the
// CAPITALIZED FUNCTION is the only spelling, resolving the func/type name clash Swift forbids.
public enum DoorOf<T: Structure>: Close {}
extension DoorOf { public static var typeName: String { "[" + T.typeName + "]" } }
public func Door<T: Structure>(_ t: () -> T.Type) -> DoorOf<T>.Type { DoorOf<T>.self }

enum FinanceVaultProbe: Close {}
extension FinanceVaultProbe { static var typeName: String { "FV" } }

enum ProbeNested: Open {
    @StructureBuilder static var body: some Structure {
        Door { Door { FinanceVaultProbe.self } }
    }
}

final class ScratchProbeTests: XCTestCase {
    func testTypeDoorWorks() {
        print("PROBE =", ProbeNested.typeName)
        XCTAssertEqual(ProbeNested.typeName, "[[FV]]")
    }
}
