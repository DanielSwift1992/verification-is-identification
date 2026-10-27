import Foundation
import XCTest
@testable import Court

final class NotationScopeTests: XCTestCase {
    func testClosedSiblingsAndLocalScopesKeepTheirLexicalOwners() throws {
        let text = """
        enum Empty {}
        enum Outer {
            enum First { enum Leaf {} }
            func local() { enum Local {} }
            enum Second: P { enum Leaf {} }
        }
        enum Last { enum Leaf {} }
        """
        let scope = try NotationScope(text)
        XCTAssertEqual(scope.declarations.map(\.qualified),
            ["Empty", "Outer", "Outer.First", "Outer.First.Leaf", "Local",
             "Outer.Second", "Outer.Second.Leaf", "Last", "Last.Leaf"])
        XCTAssertEqual(scope.namespaces, NameSet(["Outer", "Outer.First", "Last"]))
        // The query denotes the last source declaration whose half-open
        // header/body interval contains this UTF-16 position, including gaps
        // after a child closes and the exact start/close boundaries.
        for offset in -1...text.utf16.count {
            let expected = scope.declarations.last { $0.start <= offset && offset < $0.close }
            XCTAssertEqual(scope.owner(at: offset)?.start, expected?.start, "UTF-16 offset \(offset)")
        }
        for declaration in scope.declarations {
            XCTAssertEqual(scope.owner(at: declaration.open)?.qualified, declaration.qualified)
            XCTAssertEqual(String(decoding: Array(text.utf16)[declaration.close - 1..<declaration.close], as: UTF16.self), "}")
        }
    }

    func testImportAndDottedHeadersAreNotDeclarations() throws {
        // Preserve the existing header finder's cross-line boundary after an
        // import. This performance change does not widen that fragment.
        let cases: [(String, [String])] = [
            ("import enum A.Hidden\nenum First {}", []),
            ("A .\u{00A0}enum Hidden {}\nenum First {}", ["First"]),
            ("enum First {}\nimport\u{00A0}struct B.Hidden\nenum Last {}", ["First"]),
            ("enum Last { class func member() { enum Local {} } enum Child {} }",
                ["Last", "Local", "Last.Child"]),
        ]
        for (text, expected) in cases {
            XCTAssertEqual(try NotationScope(text).declarations.map(\.qualified), expected, text)
        }
    }

    func testCollectedRefusalsRetainSourceOrderAndLineAddresses() throws {
        let text = """
        enum Generic<T> { enum Child {} }
        enum Plain { struct Child {} }
        struct Carrier { enum Child {} }
        enum Last { enum Child {} }
        """
        let messages = NotationScope.unreadDeclarations(text)
        XCTAssertEqual(messages, [
            "cannot read line 1: nested declaration 'Child' has an unsupported enclosing type",
            "cannot read line 2: nested struct 'Plain.Child' is outside the declared notation fragment",
            "cannot read line 3: nested declaration 'Child' has an unsupported enclosing type",
        ])
        XCTAssertThrowsError(try NotationScope("enum Open {")) { error in
            XCTAssertTrue(String(describing: error).contains("unterminated declaration body"))
        }
    }
}
