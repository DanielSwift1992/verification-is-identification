import XCTest
import VerificationIsIdentification
import DocumentKit

// The metatype door, exercised end to end: a Type-cased function is the only spelling of
// its combinator (the func/type name-clash rule Swift itself forces), and the fold reads
// the nested doors back out through typeName — the §S17 idiom every markup door stands on.
public enum DoorOf<T: Structure>: Close {}
extension DoorOf { public static var typeName: String { "[" + T.typeName + "]" } }
public func Door<T: Structure>(_ t: () -> T.Type) -> DoorOf<T>.Type { DoorOf<T>.self }

enum DoorContent: Close {}
extension DoorContent { static var typeName: String { "FV" } }

enum NestedDoors: Open {
    @StructureBuilder static var body: some Structure {
        Door { Door { DoorContent.self } }
    }
}

final class MetatypeDoorTests: XCTestCase {
    func testNestedDoorsFoldThroughTypeName() {
        XCTAssertEqual(NestedDoors.typeName, "[[FV]]")
    }
}
