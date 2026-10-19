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
            XCTAssertEqual(messages, ["cannot bind conformer 'Duplicate': duplicate generic parameters"])
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

        typealias First = Optional<Match<A, A>>
        typealias Second = Optional<Match<A, B>>
        """)
        do {
            _ = try WhereJudge.judge([path])
            XCTFail("nested applications must not be hidden by a good certificate")
        } catch WhereJudge.Failure.unsupported(let messages) {
            XCTAssertEqual(messages.count, 2)
            XCTAssertTrue(messages[0].contains("line 7"))
            XCTAssertTrue(messages[1].contains("line 8"))
        }
    }
}
