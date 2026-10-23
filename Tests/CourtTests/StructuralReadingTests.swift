import Foundation
import XCTest
@testable import Court

final class StructuralReadingTests: XCTestCase {
    func testUnreadLiteralBoundariesReachBothStructuralConsumers() throws {
        let hazardous = ["#/\"/#", "/\"/", "##/\"/##", "\"v \\(/\"/)\"", "#\"\\#(1)\"#"]
        for literal in hazardous {
            let text = "enum Helper { static var value: String { \(literal) } }\n// enum Hidden {}\n"
            XCTAssertThrowsError(try StructuralSource.regions(text, origin: "input.swift"))
            XCTAssertThrowsError(try StructuralSource.tokens(text))
            XCTAssertThrowsError(try CountCourt.blocks([("input.swift", text)]))
        }
        let neighbor = "enum Helper { static var value: Int { 8 / 2 } }\n// #/\"/# /\"/\n"
        XCTAssertNoThrow(try StructuralSource.regions(neighbor, origin: "input.swift"))
        XCTAssertEqual(try CountCourt.blocks([("input.swift", neighbor)]).map(\.name), ["Helper"])
    }

    func testLiteralScopeIsExplicitAndScalarDelimitersCannotHide() throws {
        let raw = "enum X { static var typeName: String { #\"direct\"# } }"
        XCTAssertNoThrow(try StructuralSource.regions(raw, origin: "input.swift"))
        XCTAssertThrowsError(try StructuralSource.regions(raw, origin: "input.swift", scope: .projection))
        XCTAssertThrowsError(try StructuralSource.tokens(raw))
        let text = "enum X { static var typeName: String { \"\u{301}text\" } }\n// enum Hidden {}\n"
        let reading = try StructuralSource.regions(text, origin: "input.swift")
        XCTAssertEqual(reading.regions.map { $0.declaration.name }, ["X"])
        XCTAssertNoThrow(try StructuralSource.replayReading(reading.certificate, source: text, origin: "input.swift"))
        XCTAssertThrowsError(try StructuralSource.regions("enum X { static var r: Int { /\u{301}/ } }", origin: "input.swift"))
    }

    func testStrictConsumersShareTheSameAddressedReading() throws {
        let text = "// Ω\r\nprotocol P {}\r\nenum X: P {}\r\n"
        let read = try StructuralSource.regions(text, origin: "world.swift")
        let replay = try StructuralSource.replayReading(read.certificate, source: text, origin: "world.swift")
        let fromFiles = try StructuralSource(files: [("world.swift", text)], roster: true)
        let fromReading = try StructuralSource(files: [], roster: true, readings: [replay])
        XCTAssertEqual(fromFiles.addresses, fromReading.addresses)
        XCTAssertEqual(fromReading.addresses["X"]?.line, 3)
        XCTAssertEqual(read.tokens, replay.tokens)
        XCTAssertEqual(read.certificate.units, replay.certificate.units)
        let ambiguous = "enum X {}\ntypealias X = Y\n"
        XCTAssertThrowsError(try StructuralSource.regions(ambiguous, origin: "world.swift"))
        XCTAssertThrowsError(try StructuralSource(files: [("world.swift", ambiguous)], roster: true))
    }

    func testWholeInputRejectsAnInventedFirstTokenAndAnOmittedSuffix() throws {
        let active = "enum X {}\n", commented = "// " + active
        let proof = try StructuralSource.regions(active, origin: "world.swift").certificate
        let shifted = proof.tokens.map {
            StructuralSource.Token(word: $0.word, bytes: ($0.bytes.lowerBound + 3)..<($0.bytes.upperBound + 3))
        }
        XCTAssertThrowsError(try StructuralSource.replayReading(
            .init(tokens: shifted, units: proof.units), source: commented, origin: "world.swift"))
        XCTAssertThrowsError(try StructuralSource.replayReading(
            proof, source: active + "enum Y {}\n", origin: "world.swift"))
        XCTAssertThrowsError(try StructuralSource.replayReading(
            .init(tokens: [], units: []), source: active, origin: "world.swift"))
        let trivia = "// no declarations\r\n/* nor here */"
        let honest = try StructuralSource.regions(trivia, origin: "world.swift")
        XCTAssertNoThrow(try StructuralSource.replayReading(honest.certificate, source: trivia, origin: "world.swift"))
    }

    func testCarriedProjectionIsExplicitAndStrictReadingRefusesIt() throws {
        let text = "protocol P {}\n#if FLAG\nenum X: P {}\n#endif\nenum X {}\n"
        let projected = try StructuralSource.regions(text, origin: "world.swift", scope: .projection)
        XCTAssertEqual(projected.excludedConditionals, 1)
        XCTAssertEqual(projected.conditionalSubjects, ["X"])
        XCTAssertEqual(projected.certificate.units.last?.upper, projected.tokens.count)
        XCTAssertThrowsError(try StructuralSource.regions(text, origin: "world.swift"))
        XCTAssertThrowsError(try StructuralSource(files: [], roster: true, readings: [projected]))
        let source = try StructuralSource(files: [("world.swift", text)])
        XCTAssertTrue(source.declarations["X"]!.unsupported.contains("conditional compilation can alter this declaration"))
    }

    func testOneObligationGraphChecksExactRootsAcrossConsumers() throws {
        let source = try StructuralSource(files: [("world.swift", "protocol P {}\nenum X: P {}\nenum Y {}\n")], roster: true)
        let x = try DefinitionReduction.parse("X"), y = try DefinitionReduction.parse("Y")
        let roots: Set<ApplicationCourt.Goal> = [.member(x, "P"), .equal(x, x)]
        let proof = try ApplicationCourt.derive(roots, source: source)
        XCTAssertNoThrow(try ApplicationCourt.verify(roots, derivation: proof, source: source))
        XCTAssertThrowsError(try ApplicationCourt.verify([.member(x, "P")], derivation: proof, source: source))
        XCTAssertThrowsError(try ApplicationCourt.verify([.member(y, "P"), .equal(x, x)], derivation: proof, source: source))
        XCTAssertThrowsError(try ApplicationCourt.derive([.member(y, "P")], source: source))
        XCTAssertThrowsError(try ApplicationCourt.derive([.equal(x, y)], source: source))
    }
}
