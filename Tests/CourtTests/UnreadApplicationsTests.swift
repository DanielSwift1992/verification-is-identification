import Foundation
import XCTest
@testable import Court

final class UnreadApplicationsTests: XCTestCase {
    private var root: URL {
        URL(fileURLWithPath: #filePath).deletingLastPathComponent()
            .deletingLastPathComponent().deletingLastPathComponent()
    }
    private struct Observation: Decodable, Equatable {
        let exit: Int32
        let stdout: String
        let stderr: String
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.exit == rhs.exit && lhs.stdout.utf8.elementsEqual(rhs.stdout.utf8)
                && lhs.stderr.utf8.elementsEqual(rhs.stderr.utf8)
        }
    }
    private struct Case: Decodable {
        let id: String
        let files: [String: String]
        let sha256: [String: String]
        let arguments: [String]
        let expected: Observation
        let wordClass: [String: Bool]?
    }
    private struct Contract: Decodable { let schema: String; let cases: [Case] }
    func testFrozenUnreadVerdictsAndAddresses() throws {
        let contract = try JSONDecoder().decode(Contract.self,
            from: Data(contentsOf: root.appendingPathComponent("Contracts/Court/unread-v1/contract.json")))
        XCTAssertEqual(contract.schema, "vi.where.unread/1")
        XCTAssertEqual(contract.cases.count, 48)
        XCTAssertEqual(contract.cases.filter { $0.wordClass == nil }.count, 46)
        let word = try NSRegularExpression(pattern: #"^\w$"#)
        var compared = 0, notCompared = 0
        func unmetWordClasses(_ classes: [String: Bool]) throws -> [String] {
            var missing: [String] = []
            for (hex, expected) in classes.sorted(by: { $0.key < $1.key }) {
                let value = try XCTUnwrap(UInt32(hex, radix: 16), "invalid scalar premise")
                let scalar = try XCTUnwrap(Unicode.Scalar(value), "invalid scalar premise")
                let text = String(scalar)
                let observed = word.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)) != nil
                if observed != expected { missing.append("U+\(hex) word=\(observed), requires \(expected)") }
            }
            return missing
        }
        XCTAssertTrue(try unmetWordClasses(["61": true]).isEmpty)
        XCTAssertEqual(try unmetWordClasses(["61": false]), ["U+61 word=true, requires false"])
        let declared = try XCTUnwrap(ProcessInfo.processInfo.environment["VI_CHECK_BUILD_BIN"],
            "VI_CHECK_BUILD_BIN: declare the built Tools directory")
        #if os(Windows)
        let name = "Tools.exe"
        #else
        let name = "Tools"
        #endif
        let tools = URL(fileURLWithPath: declared).appendingPathComponent(name)
        let temporary = FileManager.default.temporaryDirectory.appendingPathComponent("unread-" + UUID().uuidString)
        try FileManager.default.createDirectory(at: temporary, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: temporary) }
        for entry in contract.cases {
            let directory = temporary.appendingPathComponent(entry.id)
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            for (path, text) in entry.files {
                XCTAssertEqual(courtSHA256(Data(text.utf8)), entry.sha256[path], entry.id)
                try Data(text.utf8).write(to: directory.appendingPathComponent(path))
            }
            let missing = try unmetWordClasses(entry.wordClass ?? [:])
            if !missing.isEmpty {
                notCompared += 1
                print("unread contract \(entry.id): not-compared; " + missing.joined(separator: "; "))
                continue
            }
            let output = directory.appendingPathComponent("stdout"), error = directory.appendingPathComponent("stderr")
            FileManager.default.createFile(atPath: output.path, contents: nil)
            FileManager.default.createFile(atPath: error.path, contents: nil)
            let out = try FileHandle(forWritingTo: output), err = try FileHandle(forWritingTo: error)
            let process = Process()
            process.executableURL = tools
            process.currentDirectoryURL = directory
            process.arguments = ["judge", "where"] + entry.arguments
            process.standardOutput = out; process.standardError = err
            try process.run()
            let limit = Date().addingTimeInterval(30)
            while process.isRunning && Date() < limit { Thread.sleep(forTimeInterval: 0.01) }
            if process.isRunning { process.terminate(); XCTFail(entry.id + ": timed out") }
            process.waitUntilExit(); try out.close(); try err.close()
            XCTAssertEqual(Observation(exit: process.terminationStatus,
                stdout: try String(contentsOf: output, encoding: .utf8),
                stderr: try String(contentsOf: error, encoding: .utf8)), entry.expected, entry.id)
            compared += 1
            print("unread contract \(entry.id): exit \(process.terminationStatus)")
        }
        XCTAssertEqual(compared + notCompared, contract.cases.count)
        XCTAssertGreaterThanOrEqual(compared, 46)
        print("unread contract: compared \(compared)/48; not-compared \(notCompared)")
    }
    private func file(_ source: String) throws -> WhereJudge.World {
        let reading = try WhereJudge.strippedReading(source, notating: true)
        var world = WhereJudge.World()
        world.clean = reading.clean; world.notation = reading.notation
        var line = 1
        world.lineAt = reading.clean.utf16.map { unit in
            defer { if unit == 10 { line += 1 } }
            return line
        } + [line]
        return world
    }
    func testProjectionRetainsInterpolationAndQualifiedNameIdentity() throws {
        let text = """
        // A.B.Use<Bad>.self
        let literal = "A.B.Use<Bad>.self"
        #if OMIT
        let skipped = A.B.Use<Bad>.self
        #endif
        let interpolated = "\u{5C}(A.B.Use<Bad>.self)"
        func f(_ x: A . B.Use<Bad>, _ y: A.B . Use<Bad>) {}
        func g(_ z: X.ा.Use<Bad>) {}
        """
        let world = try file(text)
        let result = WhereJudge.unreadApplications(world, spans: [],
            heads: WhereJudge.UnreadHeads(["Use", "B.Use", "A.B.Use", "X.ा.Use"]))
        let places = result.applications.map { "\(world.lineAt[$0.at]):\($0.name)" }.sorted()
        XCTAssertEqual(places, ["6:A.B.Use", "6:B.Use", "6:Use", "7:B.Use", "7:Use", "7:Use", "8:Use", "8:X.ा.Use"])
        XCTAssertEqual(result.tokens, world.notation.count)
        let all = WhereJudge.unreadApplications(world,
            spans: [NSRange(location: 0, length: world.clean.utf16.count)],
            heads: WhereJudge.UnreadHeads(["Use", "B.Use", "A.B.Use", "X.ा.Use"]))
        XCTAssertTrue(all.applications.isEmpty)
        // Preserve the running carrier's legacy word boundary, including
        // private-use scalars whose classes differ between ICU distributions.
        // This is an offset comparison to the former regex, not an OS selector
        // or an assumed cross-platform output for the frozen CLI observation.
        let legacy = try NSRegularExpression(pattern: #"(?<![\w.])Use\s*<"#)
        for prefix in [" ", ".", "\u{F86F}", "\u{F870}"] {
            let source = "func f(_ x: " + prefix + "Use<Bad>.Type) {}"
            let carrier = try file(source)
            let expected = legacy.matches(in: carrier.clean,
                range: NSRange(carrier.clean.startIndex..., in: carrier.clean)).map { $0.range.location }
            let observed = WhereJudge.unreadApplications(carrier, spans: [],
                heads: WhereJudge.UnreadHeads(["Use"]))
            XCTAssertEqual(observed.applications.map { $0.at }, expected)
        }
    }
    func testDiscoveryWorkDoesNotMultiplyNamesByInputOrNesting() throws {
        for size in [32, 128, 512] {
            let source = "func f(_ x: " + String(repeating: "Use<", count: size)
                + "Good" + String(repeating: ">", count: size) + ".Type) {}"
            let world = try file(source)
            let small = WhereJudge.unreadApplications(world, spans: [], heads: WhereJudge.UnreadHeads(["Use"]))
            let names = NameSet(["Use"] + (0..<size).map { "Unused\($0)" })
            let large = WhereJudge.unreadApplications(world, spans: [], heads: WhereJudge.UnreadHeads(names))
            XCTAssertEqual(large.applications.count, size)
            XCTAssertEqual(large.tokens, world.notation.count)
            XCTAssertLessThanOrEqual(large.qualificationSteps, world.notation.count)
            XCTAssertEqual(large.openedAngles, size)
            XCTAssertEqual(large.closedAngles, large.openedAngles)
            XCTAssertEqual(large.tokens, small.tokens)
            XCTAssertEqual(large.qualificationSteps, small.qualificationSteps)
            let spans = (0..<size).map { _ in NSRange(location: 0, length: world.clean.utf16.count) }
            let covered = WhereJudge.unreadApplications(world, spans: spans, heads: WhereJudge.UnreadHeads(names))
            XCTAssertTrue(covered.applications.isEmpty)
            XCTAssertLessThanOrEqual(covered.spanAdvances, spans.count)
        }
    }
}
