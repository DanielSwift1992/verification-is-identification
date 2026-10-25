import Foundation
import XCTest
@testable import Court

final class ScalarIdentityTests: XCTestCase {
    typealias R = DefinitionReduction
    private var root: URL {
        URL(fileURLWithPath: #filePath).deletingLastPathComponent()
            .deletingLastPathComponent().deletingLastPathComponent()
    }
    private func toolsURL() throws -> URL {
        let declared = try XCTUnwrap(ProcessInfo.processInfo.environment["VI_CHECK_BUILD_BIN"],
            "VI_CHECK_BUILD_BIN: declare the built Tools directory (swift build --show-bin-path)")
        #if os(Windows)
        let name = "Tools.exe"
        #else
        let name = "Tools"
        #endif
        return URL(fileURLWithPath: declared, isDirectory: true).appendingPathComponent(name)
    }
    func testTypedCertificateTextAndNameMapOrder() throws {
        let plain = StructuralSource.ReadingCertificate.Unit(kind: ";", lower: 0, upper: 1)
        let forged = StructuralSource.ReadingCertificate.Unit(kind: "\u{37E}", lower: 0, upper: 1)
        XCTAssertNotEqual(plain, forged)
        let values = ["é", "e\u{301}", "\u{212A}", "K"]
        let expected = ["K", "e\u{301}", "é", "\u{212A}"]
        for words in [values, Array(values.reversed())] {
            let map = NameMap(uniqueKeysWithValues: words.map { ($0, 1) })
            XCTAssertTrue(WhereJudge.sameNames(map.keys.sorted(), expected))
            XCTAssertTrue(WhereJudge.sameNames(map.sorted().map(\.key), expected))
        }
    }
    func testWhereCollisionIsAnAddressedInputRefusal() throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent("court-where-guard-" + UUID().uuidString)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        let file = directory.appendingPathComponent("collision.swift")
        try "enum Offé {}\nenum Offe\u{301} {}\n".write(to: file, atomically: true, encoding: .utf8)
        let process = Process(), output = Pipe()
        process.executableURL = try toolsURL()
        process.arguments = ["judge", "where", file.path]
        process.standardOutput = output
        process.standardError = output
        try process.run()
        let data = output.fileHandleForReading.readDataToEndOfFile()
        process.waitUntilExit()
        let text = String(decoding: data, as: UTF8.self)
        XCTAssertEqual(process.terminationStatus, 2, text)
        XCTAssertTrue(text.contains("distinct scalar spellings"), text)
        XCTAssertTrue(text.contains("collision.swift:1") && text.contains("collision.swift:2"), text)
        XCTAssertFalse(text.contains("internal error"), text)
        print("R9 where input refusal: " + text)
    }
    func testScalarIdentityDoesNotDependOnTheCollisionDiagnostic() throws {
        for (a, b) in [("Offé", "Offe\u{301}"), ("K", "\u{212A}"), ("Ω", "\u{2126}")] {
            XCTAssertTrue(a == b, "the diagnostic's canonical key is a different relation")
            XCTAssertFalse(WhereJudge.sameName(a, b))
            XCTAssertEqual(NameSet([a, b]).count, 2)
            let table = NameMap(uniqueKeysWithValues: [(a, 1), (b, 2)])
            XCTAssertEqual(table[a], 1); XCTAssertEqual(table[b], 2)
            let x = R.Expression.application(a, []), y = R.Expression.application(b, [])
            XCTAssertNotEqual(x, y)
            XCTAssertEqual(Set([x, y]).count, 2)
            XCTAssertNotEqual(R.Expression.field(x, a), R.Expression.field(x, b))
            XCTAssertNotEqual(ApplicationCourt.Goal.member(x, a), .member(x, b))
            XCTAssertNotEqual(ApplicationCourt.Goal.contract(x, a), .contract(x, b))
            XCTAssertNotEqual(ContinuationCourt.Shape.leaf(a), .leaf(b))
            XCTAssertNotEqual(WhereJudge.Selection.certificate(a), .certificate(b))
            XCTAssertNotEqual(WhereJudge.Selection.conformer(a), .conformer(b))
            XCTAssertNotEqual(R.Term.application(a, []), .application(b, []))
            var world = WhereJudge.World()
            world.aliases[a] = .init(parameters: [], body: "Unit")
            XCTAssertNil(world.aliases[b])
            let source = R.Source(world: world, rigid: [])
            XCTAssertEqual(try source.expansion(x), .application("Unit", []))
            XCTAssertNil(try source.expansion(y))
            print("R8 scalar identity: distinct \(a.unicodeScalars.map(\.value)) / \(b.unicodeScalars.map(\.value)); maps, terms and proof goals agree")
        }
        XCTAssertTrue(WhereJudge.sameName("Offe\u{301}", "Offe\u{301}"))
        XCTAssertFalse(WhereJudge.sameName("ﬁx", "fix"))
    }

    func testPressCertificateNameForgeriesRefuseWithoutASecondGuard() throws {
        let state = "typealias Modé = Off\n"
        let rules = "enum TurnÓn { typealias Slot = ModéSlot; typealias From = Off; typealias Into = On }\n"
        let result = try Press.apply(["TurnÓn"], state: state, dictionary: rules)
        let proof = try XCTUnwrap(result.certificate)
        try Press.replay(proof, arguments: ["TurnÓn"], state: state, dictionary: rules, output: result.state)
        let bytes = try JSONEncoder().encode(proof)
        for field in ["slot", "rule", "arguments"] {
            var object = try XCTUnwrap(JSONSerialization.jsonObject(with: bytes) as? [String: Any])
            if field == "slot" { object["slot"] = "Mode\u{301}" }
            if field == "arguments" { object["arguments"] = ["TurnO\u{301}n"] }
            if field == "rule" {
                var candidates = try XCTUnwrap(object["candidates"] as? [[String: Any]])
                candidates[0]["rule"] = "TurnO\u{301}n"
                object["candidates"] = candidates
            }
            let forged = try CourtJSON.decoder().decode(Press.Certificate.self, from: JSONSerialization.data(withJSONObject: object))
            XCTAssertThrowsError(try Press.replay(forged, arguments: ["TurnÓn"], state: state, dictionary: rules, output: result.state)) { error in
                XCTAssertTrue(String(describing: error).contains("certificate"), String(describing: error))
                print("R8 Press certificate.\(field): \(error)")
            }
        }
    }

    func testJSONNameKeysCannotDisappearBeforeReplay() throws {
        let bytes = Data("{\"é\":1,\"e\\u0301\":2,\"\\u0001vi.name:00\":3}".utf8)
        let decoded = try CourtJSON.decoder().decode(NameMap<Int>.self, from: bytes)
        XCTAssertEqual(decoded.count, 3)
        XCTAssertEqual(decoded["é"], 1)
        XCTAssertEqual(decoded["e\u{301}"], 2)
        XCTAssertEqual(decoded["\u{1}vi.name:00"], 3)
        XCTAssertThrowsError(try JSONDecoder().decode(NameMap<Int>.self, from: bytes))
        XCTAssertThrowsError(try JSONEncoder().encode(decoded))
        for name in ["é", "e\u{301}", "K", "\u{212A}", "\u{1}vi.name:00"] {
            let map = NameMap(uniqueKeysWithValues: [(name, 1)])
            XCTAssertEqual(try CourtJSON.decoder().decode(NameMap<Int>.self, from: JSONEncoder().encode(map)), map)
        }
    }

    func testDerivedSlotCollisionRetainsTheActualTokenAddress() throws {
        let rules = "// first\n\nenum TurnOn {\n    typealias Slot = Mode\u{301}Slot\n    typealias From = Off\n    typealias Into = On\n}\n"
        let prefix = try XCTUnwrap(rules.range(of: "Mode\u{301}Slot"))
        let byte = rules[..<prefix.lowerBound].utf8.count
        XCTAssertThrowsError(try Press.apply(["TurnOn"], state: "typealias Modé = Off\n", dictionary: rules)) { error in
            let diagnostic = String(describing: error)
            XCTAssertTrue(diagnostic.contains("rules.swift:4 (byte \(byte))"), diagnostic)
            XCTAssertTrue(diagnostic.contains("state.swift:1 (byte 10)"), diagnostic)
            XCTAssertFalse(diagnostic.contains(") (byte"), diagnostic)
            print("R8 U4 actual Slot: " + diagnostic)
        }
    }

    func testLiteralRouteDoesNotIdentifyDifferentSlotSpellings() throws {
        let state = "extension Modé {\n    var typeName: String { \"a\" }\n}\n"
        let unchanged = try Press.apply(["append", "Modé", "b"], state: state, dictionary: "")
        XCTAssertTrue(unchanged.state.contains("\"ab\""))
        XCTAssertThrowsError(try Press.apply(["append", "Mode\u{301}", "b"], state: state, dictionary: "")) {
            XCTAssertTrue(String(describing: $0).contains("no literal slot"))
        }
    }

    func testRosterNormalAndProofNamesUseSourceScalarIdentity() throws {
        let files = [("roster.swift", "protocol Lamp { associatedtype Státé }\nenum Offé {}\nenum A: Lamp { typealias Státé = Offé }\n")]
        let world = try RosterResponse.World(files, predicate: "Lamp")
        let report = RosterResponse.answer(files, predicate: "Lamp")
        XCTAssertEqual(report.outcome, "holds")
        try world.replay(report)
        let bytes = try JSONEncoder().encode(report)
        for variant in ["normal", "whole proof", "axis key"] {
            let data: Data
            if variant == "axis key" {
                data = Data(String(decoding: bytes, as: UTF8.self).replacingOccurrences(of: "Státé", with: "Sta\u{301}te\u{301}").utf8)
            } else if variant == "whole proof" {
                data = Data(String(decoding: bytes, as: UTF8.self).replacingOccurrences(of: "Offé", with: "Offe\u{301}").utf8)
            } else {
                var object = try XCTUnwrap(JSONSerialization.jsonObject(with: bytes) as? [String: Any])
                var records = try XCTUnwrap(object["records"] as? [[String: Any]])
                var axes = try XCTUnwrap(records[0]["axes"] as? [String: [String: Any]])
                axes["Státé"]!["normal"] = "Offe\u{301}"
                records[0]["axes"] = axes; object["records"] = records
                data = try JSONSerialization.data(withJSONObject: object)
            }
            let forged = try CourtJSON.decoder().decode(RosterResponse.Report.self, from: data)
            XCTAssertThrowsError(try world.replay(forged)) { error in
                print("R8 roster \(variant): \(error)")
            }
        }
    }

    func testContinuationAndCoverCertificateNamesUseTheSameIdentity() throws {
        let primitive = "Sources/Notation/Primitive.swift"
        let primitives = try String(contentsOf: root.appendingPathComponent(primitive), encoding: .utf8)
        let world = try StructuralSource(files: [(primitive, primitives), ("world.swift", """
        enum Identité<S: Structure> {
            typealias Source = Paired<S, S>
            typealias Observation = Source
            typealias Question = Source
        }
        enum Couvré<S: Structure> {
            typealias Source = Paired<S, S>
            typealias Coverage = Source
        }
        """)])
        typealias C = ContinuationCourt
        var plain = try C.derive("Identité", source: world)
        _ = try C.verify("Identité", certificate: plain, source: world)
        plain = C.Certificate(request: "Identite\u{301}", constructor: plain.constructor,
            source: plain.source, observation: plain.observation, question: plain.question,
            missing: plain.missing, program: plain.program)
        XCTAssertThrowsError(try C.verify("Identité", certificate: plain, source: world))
        var related = try C.deriveRelated("Identité", source: world)
        XCTAssertTrue(try C.verifyRelated("Identité", certificate: related, source: world))
        related.request = "Identite\u{301}"
        XCTAssertThrowsError(try C.verifyRelated("Identité", certificate: related, source: world))
        // Cover replay checks its request before reading a Coverage tree.
        var cover = try C.deriveLawCover("Couvré", source: world)
        _ = try C.verifyLawCover("Couvré", certificate: cover, source: world)
        cover.request = "Couvre\u{301}"
        XCTAssertThrowsError(try C.verifyLawCover("Couvré", certificate: cover, source: world))
    }

    func testCLICollisionGuardIsWiredBeforeEveryQuestion() throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent("court-name-cli-" + UUID().uuidString)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        let source = directory.appendingPathComponent("input.swift")
        try "enum Identité {}\n".write(to: source, atomically: true, encoding: .utf8)
        let bad = "Identite\u{301}"
        var cases: [(String, [String], String)] = [
            ("apply", ["apply", bad, source.path], "arguments[0]"),
            ("coverage", ["coverage", bad, source.path], "arguments[0]"),
            ("continue", ["continue", bad, source.path], "request"),
            ("relations", ["continue", "--relations", bad, source.path], "request"),
            ("retain", ["continue", "--relations", "--retain", bad, source.path], "request"),
            ("actions", ["continue", "--relations", "--actions", bad, source.path], "request"),
            ("image", ["continue", "--relations", "--image", bad, source.path], "request"),
            ("agreement", ["continue", "--relations", "--agreement", bad, source.path], "request"),
            ("repeat", ["continue", "--relations", "--repeat", bad, source.path], "request"),
            ("cover-law", ["cover-law", bad, source.path], "request"),
            ("count", ["count", source.path, "--predicate", "P", "--encoding", "E", "--sigma", bad], "--sigma")
        ]
        // The same --actions entry receives the actual U9/U10 declared inputs.
        // Its word guard must run before a question-specific field decision.
        for (label, fixture) in [("actions-U9", "image-cases.swift"), ("actions-U10", "agreement-cases.swift")] {
            let material = root.appendingPathComponent("Contracts/Court/continuation-relations-v1/" + fixture)
            let primitive = root.appendingPathComponent("Sources/Notation/Primitive.swift")
            cases.append((label, ["continue", "--relations", "--actions", bad, source.path, primitive.path, material.path], "request"))
        }
        for (label, arguments, origin) in cases {
            let output = directory.appendingPathComponent(label + ".log")
            FileManager.default.createFile(atPath: output.path, contents: nil)
            let stream = try FileHandle(forWritingTo: output)
            let process = Process()
            process.executableURL = try toolsURL()
            process.arguments = ["judge"] + arguments
            process.standardOutput = stream; process.standardError = stream
            try process.run()
            let limit = Date().addingTimeInterval(30)
            while process.isRunning && Date() < limit { Thread.sleep(forTimeInterval: 0.01) }
            if process.isRunning { process.terminate(); XCTFail(label + ": timed out") }
            process.waitUntilExit(); try stream.close()
            let text = try String(contentsOf: output, encoding: .utf8)
            XCTAssertEqual(process.terminationStatus, 2, label + ": " + text)
            for required in ["distinct scalar spellings", "input.swift:1", origin + ":1"] {
                XCTAssertTrue(text.contains(required), label + ": " + text)
            }
            print("R8 CLI \(label): exit \(process.terminationStatus); \(text)")
        }
    }
}
