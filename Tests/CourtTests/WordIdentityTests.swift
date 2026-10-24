import Foundation
import XCTest
@testable import Court

final class WordIdentityTests: XCTestCase {
    func testBatchRejectsDifferentScalarSpellingsWithBothAddresses() throws {
        for (first, second) in [("Offé", "Offe\u{301}"), ("OffK", "Off\u{212A}"), ("Ω", "\u{2126}")] {
            let files = [("one.swift", "enum \(first) {}"), ("two.swift", "\nenum \(second) {}")]
            for scope: WhereJudge.LexicalScope in [.notation, .projection, .declarations] {
                XCTAssertThrowsError(try WhereJudge.lexicalReadings(files, scope: scope)) { error in
                    let message = String(describing: error)
                    for required in ["distinct scalar spellings", "one.swift:1", "two.swift:2", first, second, "U+"] {
                        XCTAssertTrue(message.contains(required), message)
                    }
                }
            }
            XCTAssertThrowsError(try StructuralSource(files: files))
            XCTAssertThrowsError(try CountCourt.blocks(files))
            XCTAssertThrowsError(try WhereJudge.prepare(files.map { $0.0 }, load: { path in files.first { $0.0 == path }!.1 }))
        }
    }

    func testApplicationArgumentsParticipateBeforeCanonicalKeyLookup() throws {
        for (name, argument) in [("Lampé", "Lampe\u{301}"), ("Ω", "\u{2126}"), ("K", "\u{212A}")] {
            let files = [("world.swift", "protocol Counting {}\nenum Tick<X: Counting> {}\nenum \(name): Counting {}")]
            XCTAssertThrowsError(try StructuralSource(files: files, arguments: [("arguments[0]", "Tick<\(argument)>")])) { error in
                let message = String(describing: error)
                XCTAssertTrue(message.contains("world.swift:3"), message)
                XCTAssertTrue(message.contains("arguments[0]:1"), message)
            }
            let source = try StructuralSource(files: files, arguments: [("arguments[0]", "Tick<\(name)>")])
            XCTAssertNoThrow(try ApplicationCourt.derive(DefinitionReduction.parse("Tick<\(name)>"), source: source))
        }
    }

    func testRosterPredicateUsesTheSameBatchGuard() throws {
        let files = [("world.swift", "protocol Classé {}\nenum A: Classé {}")]
        XCTAssertThrowsError(try RosterResponse.World(files, predicate: "Classe\u{301}")) { error in
            let text = String(describing: error)
            XCTAssertTrue(text.contains("--protocol:1"), text)
            XCTAssertTrue(text.contains("world.swift:1"), text)
        }
        XCTAssertNoThrow(try RosterResponse.World(files, predicate: "Classé"))
    }

    func testContextNamePremisesParticipateWithTheirDeclaredAddresses() throws {
        for imported in ["Módulo", "Mo\u{301}dulo"] {
            let files = [("world.swift", "import \(imported)\nprotocol X {}"), ("lib.swift", "enum Library {}")]
            let texts = NameMap(uniqueKeysWithValues: files)
            let entries: [[String: Any]] = files.enumerated().map { i, file in
                let imports = i == 0 ? [imported] : []
                return ["input": file.0, "source": file.0, "sha256": courtSHA256(Data(file.1.utf8)),
                    "namespace": i == 0 ? "World" : "Lib", "module": i == 0 ? "World" : "Módulo",
                    "role": i == 0 ? "own" : "borrowed", "imports": imports,
                    "at": ["input": "manifest:\(i).input", "source": "manifest:\(i).source",
                        "sha256": "manifest:\(i).hash", "namespace": "manifest:\(i).namespace",
                        "module": "manifest:\(i).module", "role": "manifest:\(i).role",
                        "imports": imports.map { _ in "manifest:\(i).imports" }]]
            }
            let json = try JSONSerialization.data(withJSONObject: ["schema": "vi.court.context/2", "sources": entries, "intrinsics": []])
            let context = try CourtContext(text: String(decoding: json, as: UTF8.self), paths: files.map { $0.0 }, texts: texts)
            if imported.unicodeScalars.elementsEqual("Módulo".unicodeScalars) {
                XCTAssertNoThrow(try CourtNotation.read(context, texts: texts, selected: "world.swift", documents: []))
            } else {
                XCTAssertThrowsError(try CourtNotation.read(context, texts: texts, selected: "world.swift", documents: [])) { error in
                    let text = String(describing: error)
                    XCTAssertTrue(text.contains("distinct scalar spellings"), text)
                    XCTAssertTrue(text.contains("world.swift:1"), text)
                    XCTAssertTrue(text.contains("manifest:1.module"), text)
                }
            }
        }
    }

    func testWordGuardDoesNotCompareSeparateJudgementsOrCarrierContents() throws {
        for name in ["Offé", "Offe\u{301}"] {
            XCTAssertNoThrow(try StructuralSource(files: [("input.swift", "enum \(name) {}")]))
        }
        XCTAssertNoThrow(try WhereJudge.lexicalReadings([
            ("first.swift", "enum Offé {}"),
            ("second.swift", "// Offe\u{301}\nenum S { static var text: String { \"Offe\u{301}\" } }")
        ], scope: .declarations))
        XCTAssertThrowsError(try WhereJudge.lexicalReadings([
            ("first.swift", "enum Offé {}"),
            ("second.swift", "enum S { static var text: String { \"\\(Offe\u{301}.self)\" } }")
        ], scope: .declarations))
    }
}
