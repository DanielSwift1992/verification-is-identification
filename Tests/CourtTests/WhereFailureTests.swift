import Foundation
import XCTest
@testable import Court

final class WhereFailureTests: XCTestCase {
    private var root: URL!

    override func setUpWithError() throws {
        root = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: root, withIntermediateDirectories: true)
    }

    override func tearDownWithError() throws {
        try FileManager.default.removeItem(at: root)
    }

    private func write(_ text: String, name: String = "world.swift") throws -> String {
        let file = root.appendingPathComponent(name)
        try text.write(to: file, atomically: true, encoding: .utf8)
        return file.path
    }

    private func equality(_ argument: String) -> String {
        """
        enum A {}
        enum B {}
        enum Match<L, R> {}
        protocol Admitted {}
        extension Match: Admitted where L == R {}
        typealias Claim = Match<A, \(argument)>
        """
    }

    private func unsupported(_ action: () throws -> Void,
                             file: StaticString = #filePath, line: UInt = #line) {
        do {
            try action()
            XCTFail("expected a typed unsupported failure", file: file, line: line)
        } catch WhereJudge.Failure.unsupported(let messages) {
            XCTAssertFalse(messages.isEmpty, file: file, line: line)
        } catch {
            XCTFail("wrong category: \(error)", file: file, line: line)
        }
    }

    private func inputFailure(_ paths: [String],
                              file: StaticString = #filePath, line: UInt = #line) {
        do {
            _ = try WhereJudge.judge(paths)
            XCTFail("expected a typed input failure", file: file, line: line)
        } catch WhereJudge.Failure.input(let messages) {
            XCTAssertEqual(messages.count, 1, file: file, line: line)
        } catch {
            XCTFail("wrong category: \(error)", file: file, line: line)
        }
    }

    func testFailureAndRefusalDoNotTerminateTheCallingProcess() throws {
        let good = try write(equality("A"), name: "good.swift")
        let bad = try write(equality("B"), name: "bad.swift")
        let unread = try write("#unknownMacro\n", name: "unread.swift")
        // All three outcomes, followed by a fresh success, occur in one process.
        XCTAssertEqual(try WhereJudge.judge([good]).equalities, 1)
        XCTAssertEqual(try WhereJudge.judge([bad]).refusals.count, 1)
        unsupported { _ = try WhereJudge.judge([unread]) }
        inputFailure([root.appendingPathComponent("missing.swift").path])
        let repeated = try WhereJudge.judge([good])
        XCTAssertTrue(repeated.refusals.isEmpty)
        XCTAssertEqual(repeated.equalities, 1)
    }

    func testDuplicateConformerParametersReturnFailureAndAllowNextJudgment() throws {
        let bad = try write("protocol Plain {}\nenum Duplicate<T, T>: Plain {}\n")
        do {
            _ = try WhereJudge.judge([bad])
            XCTFail("duplicate parameters must return an unsupported failure")
        } catch WhereJudge.Failure.unsupported(let messages) {
            XCTAssertEqual(messages, ["\(bad):2: duplicate declaration 'Duplicate.T' in the same owner; first \(bad):2"])
        }
        let good = try write(equality("A"), name: "good.swift")
        let result = try WhereJudge.judge([good])
        XCTAssertTrue(result.refusals.isEmpty)
        XCTAssertEqual(result.equalities, 1)
    }

    func testInputFailuresHaveTheirOwnCategory() throws {
        inputFailure([])
        let good = try write(equality("A"))
        inputFailure([good, root.appendingPathComponent("missing-definitions.swift").path])
        let invalid = root.appendingPathComponent("invalid-utf8.swift")
        try Data([0xff, 0xfe, 0xff]).write(to: invalid)
        inputFailure([invalid.path])
    }

    func testReductionCycleAndGenericMembershipAreUnsupported() throws {
        let cycle = try write("typealias Loop = Loop\n" + equality("Loop"))
        unsupported { _ = try WhereJudge.judge([cycle]) }
        let generic = try write("""
        protocol Required {}
        enum Atom {}
        enum Box<T>: Required {}
        protocol Admitted {}
        enum Use<T> {}
        extension Use: Admitted where T: Required {}
        typealias Claim = Use<Box<Atom>>
        """)
        unsupported { _ = try WhereJudge.judge([generic]) }
    }

    func testUnreadApplicationDiagnosticsRemainSeparateAndAddressed() throws {
        let path = try write(equality("A") + """

        enum Optional<T> {}
        typealias First = Optional<Match<A, A>>
        typealias Second = Optional<Match<A, B>>
        """)
        do {
            _ = try WhereJudge.judge([path])
            XCTFail("nested applications must not be hidden by a good certificate")
        } catch WhereJudge.Failure.unsupported(let messages) {
            XCTAssertEqual(messages.count, 2)
            guard messages.count == 2 else { return }
            XCTAssertTrue(messages[0].contains("line 8"))
            XCTAssertTrue(messages[1].contains("line 9"))
        }
    }
}

final class RosterTests: XCTestCase {
    let world = """
    protocol P { associatedtype Axis: Atom }
    protocol Atom {}
    enum A: Atom { static var typeName: String { #"carried Ω"# } }
    typealias Alias = A
    enum One: P { typealias Axis = Alias }
    enum Two { typealias Axis = A }
    extension Two: P {}
    """
    func testRosterReplaysAllRecordsAndSourceDefinedAxes() throws {
        let report = RosterResponse.answer([("world.swift", world)], predicate: "P")
        XCTAssertEqual(report.outcome, "holds", report.diagnostics.joined())
        XCTAssertEqual(report.records.map(\.name), ["One", "Two"])
        XCTAssertEqual(report.records.map { $0.axes["Axis"]!.normal }, ["A", "A"])
        XCTAssertEqual(report.records[0].axes["Axis"]!.literal?.judged, false)
        try RosterResponse.World([("world.swift", world)], predicate: "P").replay(report)
    }
    func object(_ report: RosterResponse.Report) throws -> [String: Any] {
        try JSONSerialization.jsonObject(with: JSONEncoder().encode(report)) as! [String: Any]
    }
    func changed(_ report: [String: Any]) throws -> RosterResponse.Report {
        try CourtJSON.decoder().decode(RosterResponse.Report.self, from: JSONSerialization.data(withJSONObject: report))
    }
    func testReplayRefusesForgedCoverageNormalFormsAndAdmission() throws {
        let w = try RosterResponse.World([("wórld.swift", world)], predicate: "P")
        let report = RosterResponse.answer(w.files, predicate: "P")
        for mutation in 0..<9 {
            var data = try object(report)
            var rows = data["records"] as! [[String: Any]]
            switch mutation {
            case 0: rows.removeLast()
            case 1:
                var axes = rows[0]["axes"] as! [String: [String: Any]]
                axes["Axis"]!["normal"] = "Alias"
                rows[0]["axes"] = axes
            case 2: rows[0]["admission"] = ["nodes": []]
            case 3:
                var axes = rows[0]["axes"] as! [String: [String: Any]]
                axes["Axis"]!["derivation"] = ["rule": "name", "term": "A", "children": []]
                rows[0]["axes"] = axes
            case 4: rows.swapAt(0, 1)
            case 5:
                func stopAtAlias(_ tree: [String: Any]) -> [String: Any] {
                    if tree["rule"] as? String == "unfold", tree["term"] as? String == "Alias" {
                        return ["rule": "name", "term": "Alias", "children": []]
                    }
                    var result = tree
                    result["children"] = (tree["children"] as! [[String: Any]]).map(stopAtAlias)
                    return result
                }
                var axes = rows[0]["axes"] as! [String: [String: Any]]
                axes["Axis"]!["normal"] = "Alias"
                axes["Axis"]!["literal"] = NSNull()
                axes["Axis"]!["derivation"] = stopAtAlias(axes["Axis"]!["derivation"] as! [String: Any])
                rows[0]["axes"] = axes
            case 6:
                var inputs = data["inputs"] as! [[String: Any]]
                inputs[0]["path"] = "wo\u{301}rld.swift"
                data["inputs"] = inputs
            case 7:
                var at = rows[0]["at"] as! [String: Any]
                at["path"] = "wo\u{301}rld.swift"
                rows[0]["at"] = at
            default:
                var axes = rows[0]["axes"] as! [String: [String: Any]]
                var literal = axes["Axis"]!["literal"] as! [String: Any]
                var at = literal["at"] as! [String: Any]
                at["path"] = "wo\u{301}rld.swift"
                literal["at"] = at
                axes["Axis"]!["literal"] = literal
                rows[0]["axes"] = axes
            }
            data["records"] = rows
            XCTAssertThrowsError(try w.replay(changed(data)), "mutation \(mutation)")
        }
        let altered = world.replacingOccurrences(of: "carried Ω", with: "carried β")
        XCTAssertThrowsError(try RosterResponse.World([("wórld.swift", altered)], predicate: "P").replay(report))
    }
    func testMissingAndRepeatedAxesRemainAddressed() {
        for source in ["protocol P { associatedtype A }\nenum X: P {}",
                       "protocol P { associatedtype A }\nenum Q {}\nenum X: P { typealias A = Q\ntypealias A = Q }"] {
            let r = RosterResponse.answer([("bad.swift", source)], predicate: "P")
            XCTAssertNotEqual(r.outcome, "holds")
            XCTAssertTrue(r.diagnostics.contains { $0.contains("bad.swift:") })
        }
    }
    func testUnreadSyntaxCannotHideConformersAndEmptyIsNotHolds() {
        for suffix in ["actor X: P {}", "class X: P {}", "enum Box { enum X: P {} }",
                       "#if FLAG\nenum X: P {}\n#endif", "func f() { enum X: P {} }",
                       "import X; actor Y: P {}", "typealias Q = P\nenum X: Q {}",
                       "enum X {}\ntypealias Q = X\nextension Q: P {}", "enum X<T>: P {}"] {
            let r = RosterResponse.answer([("bad.swift", "protocol P {}\n" + suffix)], predicate: "P")
            XCTAssertEqual(r.outcome, "unsupported", suffix)
            XCTAssertTrue(r.diagnostics.contains { $0.contains("bad.swift:") }, suffix)
        }
        XCTAssertEqual(RosterResponse.answer([("empty.swift", "protocol P {}")], predicate: "P").outcome, "empty")
        let duplicate = RosterResponse.answer([("first.swift", "protocol P {}\nenum X: P {}"), ("second.swift", "enum X: P {}")], predicate: "P")
        XCTAssertEqual(duplicate.diagnostics, ["second.swift:1: duplicate declaration X"])
        let external = RosterResponse.answer([("external.swift", "protocol P {}\n\nextension Missing: P {}")], predicate: "P")
        XCTAssertEqual(external.diagnostics, ["external.swift:3: open/external conformer 'Missing' is outside finite roster scope"])

    }
    func testLiteralByteSpanIsOriginalCRLFUnicodeAndNeverAClaim() throws {
        let text = "// Ω\r\nprotocol P {}\r\nenum X: P { static var typeName: String { #\"β\\n\"# } }\r\n"
        let r = RosterResponse.answer([("raw.swift", text)], predicate: "P")
        XCTAssertEqual(r.outcome, "holds", r.diagnostics.joined())
        let value = try XCTUnwrap(r.records.first?.literal)
        let original = Data(Array(text.utf8)[value.at.start..<value.at.end])
        XCTAssertEqual(Data(base64Encoded: value.bytes.text), original)
        XCTAssertEqual(String(data: original, encoding: .utf8), "β\\n")
        XCTAssertEqual(value.at.line, 3)
        XCTAssertFalse(value.judged)
    }
    func testComputedCarrierAndErasedDeclarationsAreUnsupported() {
        for body in ["static var typeName: String { #\"x\"# + #\"y\"# }",
                     "static let typeName: String = #\"x\"# + #\"y\"#",
                     "static var other: String { #\"x\"# }",
                     #"static var typeName: String { "\(notALiteral)" }"#,
                     ##"static var typeName: String { #"\#(notALiteral)"# }"##] {
            let r = RosterResponse.answer([("bad.swift", "protocol P {}\nenum X: P { \(body) }")], predicate: "P")
            XCTAssertEqual(r.outcome, "unsupported", body)
        }
    }
}
