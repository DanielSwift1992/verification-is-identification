import Foundation
import XCTest
@testable import Court

final class ConditionalBodyTests: XCTestCase {
    private struct Case: Decodable {
        let id: String
        let source: String
        let sha256: String
        let outcome: String
        let directive: String?
        let line: Int?
        let byte: Int?
        let excluded: Int?
        var diagnostic: String {
            "conditional directive '#\(directive!)' inside a body is outside structural projection scope"
        }
    }
    private struct Contract: Decodable {
        let schema: String
        let cases: [Case]
        let files: [String: String]
        let commands: [[String]]
    }
    private var root: URL {
        URL(fileURLWithPath: #filePath).deletingLastPathComponent()
            .deletingLastPathComponent().deletingLastPathComponent()
    }
    private var directory: URL { root.appendingPathComponent("Contracts/Court/structural-reading-v1") }
    private func contract() throws -> Contract {
        let result = try JSONDecoder().decode(Contract.self, from: Data(contentsOf: directory.appendingPathComponent("contract.json")))
        XCTAssertEqual(result.schema, "vi.court.structural-reading/1")
        XCTAssertEqual(result.cases.count, 24)
        XCTAssertEqual(Set(result.cases.map(\.id)).count, result.cases.count)
        for (file, sha) in result.files {
            XCTAssertEqual(courtSHA256(try Data(contentsOf: directory.appendingPathComponent(file))), sha, file)
        }
        for entry in result.cases { XCTAssertEqual(courtSHA256(Data(entry.source.utf8)), entry.sha256, entry.id) }
        XCTAssertEqual(result.cases.first?.source, try String(contentsOf: directory.appendingPathComponent("h3f.swift"), encoding: .utf8))
        return result
    }
    func testBodyConditionalBoundaryUsesTheCommonLexicalReading() throws {
        for entry in try contract().cases {
            let origin = entry.id + ".swift"
            let reading = try WhereJudge.lexicalReading(entry.source, scope: .projection, carrying: true)
            if entry.outcome == "read" {
                let result = try StructuralSource.regions(entry.source, origin: origin, scope: .projection, lexical: reading)
                XCTAssertEqual(result.excludedConditionals, entry.excluded, entry.id)
                XCTAssertEqual(result.certificate.units.last?.upper, result.tokens.count, entry.id)
                XCTAssertNoThrow(try StructuralSource(files: [(origin, entry.source)]), entry.id)
                print("structural boundary \(entry.id): read; excluded \(result.excludedConditionals)")
            } else {
                let expected = "\(origin):\(entry.line!): \(entry.diagnostic) (byte \(entry.byte!))"
                for read in [
                    { _ = try StructuralSource.regions(entry.source, origin: origin, scope: .projection, lexical: reading) },
                    { _ = try StructuralSource(files: [("first.swift", "enum First {}"), (origin, entry.source)]) }
                ] {
                    XCTAssertThrowsError(try read(), entry.id) { error in
                        XCTAssertEqual(String(describing: error), expected, entry.id)
                        print("structural boundary \(entry.id): \(error)")
                    }
                }
            }
        }
    }
    func testConditionalBodyRefusesBeforeAllThreeCLIQuestions() throws {
        let declared = try XCTUnwrap(ProcessInfo.processInfo.environment["VI_CHECK_BUILD_BIN"],
            "VI_CHECK_BUILD_BIN: declare the built Tools directory (swift build --show-bin-path)")
        #if os(Windows)
        let executable = "Tools.exe"
        #else
        let executable = "Tools"
        #endif
        let tools = URL(fileURLWithPath: declared, isDirectory: true).appendingPathComponent(executable)
        let temporary = FileManager.default.temporaryDirectory.appendingPathComponent("court-body-" + UUID().uuidString)
        try FileManager.default.createDirectory(at: temporary, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: temporary) }
        let fixture = try contract()
        for entry in fixture.cases {
            let source = temporary.appendingPathComponent(entry.id + ".swift")
            try Data(entry.source.utf8).write(to: source)
            for (index, command) in fixture.commands.enumerated() {
                let output = temporary.appendingPathComponent("output.log")
                FileManager.default.createFile(atPath: output.path, contents: nil)
                let stream = try FileHandle(forWritingTo: output)
                let process = Process()
                process.executableURL = tools
                process.arguments = ["judge"] + command + [root.appendingPathComponent("Sources/Notation/Primitive.swift").path,
                    directory.appendingPathComponent("queries.swift").path, source.path]
                process.standardOutput = stream; process.standardError = stream
                try process.run()
                let limit = Date().addingTimeInterval(30)
                while process.isRunning && Date() < limit { Thread.sleep(forTimeInterval: 0.01) }
                if process.isRunning { process.terminate(); XCTFail(entry.id + ": timed out") }
                process.waitUntilExit(); try stream.close()
                let text = try String(contentsOf: output, encoding: .utf8)
                if entry.outcome == "unsupported" {
                    XCTAssertEqual(process.terminationStatus, 2, text)
                    XCTAssertTrue(text.contains("\(source.path):\(entry.line!): \(entry.diagnostic) (byte \(entry.byte!))"), text)
                    XCTAssertFalse(text.contains("✓"), text)
                    XCTAssertFalse(text.contains("\"certificate\""), text)
                } else {
                    XCTAssertEqual(process.terminationStatus, 0, entry.id + ": " + text)
                    XCTAssertTrue(text.contains(["✓ APPLICATION", "✓ FINITE COVERAGE", "\"constructed\""][index]), text)
                }
                print("structural boundary CLI \(entry.id)/\(command.joined(separator: " ")): exit \(process.terminationStatus); \(text.prefix(300))")
            }
        }
    }
}
