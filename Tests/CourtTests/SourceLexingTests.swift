import Foundation
import XCTest
@testable import Court

final class SourceLexingTests: XCTestCase {
    struct Input: Decodable { let source: String; let lent: [String] }
    func testLexicalFormTable() throws {
        let root = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
            .deletingLastPathComponent().deletingLastPathComponent()
        let table = try String(contentsOf: root.appendingPathComponent("Contracts/Press/v0.2/calculus.md"), encoding: .utf8)
        var seen: Set<String> = [], decisions = 0
        for line in table.components(separatedBy: "\n") where line.hasPrefix("| L") {
            let cells = line.components(separatedBy: "|").map { $0.trimmingCharacters(in: .whitespaces) }
            XCTAssertEqual(cells.count, 9, line)
            guard cells.count == 9 else { continue }
            let id = cells[1]
            XCTAssertTrue(seen.insert(id).inserted, "duplicate form " + id)
            XCTAssertTrue(cells[7].hasPrefix("``") && cells[7].hasSuffix("``"), line)
            let json = String(cells[7].dropFirst(2).dropLast(2))
            let data = Data(json.utf8)
            let input: Input
            if let source = try? JSONDecoder().decode(String.self, from: data) { input = Input(source: source, lent: []) }
            else { input = try JSONDecoder().decode(Input.self, from: data) }
            let source = input.source, lent = Set(input.lent)
            let scopes: [WhereJudge.LexicalScope] = [.notation, .projection, .declarations]
            for column in 0..<4 {
                let expected = cells[column + 3]
                do {
                    if column == 3 { _ = try WhereJudge.stripComments(source, lent: lent) }
                    else { _ = try WhereJudge.lexicalReading(source, scope: scopes[column], lent: lent) }
                    XCTAssertEqual(expected, "read", "\(id) mode \(column) admitted instead of \(expected)")
                    print("lexical form \(id)/\(column): read")
                } catch {
                    let reason: String
                    if let failure = error as? WhereJudge.Failure { reason = failure.messages.joined(separator: "; ") }
                    else { reason = String(describing: error) }
                    XCTAssertNotEqual(expected, "read", "\(id) mode \(column): \(reason)")
                    XCTAssertTrue(reason.contains(expected), "\(id) mode \(column): \(reason), wanted \(expected)")
                    print("lexical form \(id)/\(column): refused: \(reason)")
                }
                decisions += 1
            }
        }
        XCTAssertEqual(seen.count, 73, "the complete declared lexical table must run")
        XCTAssertEqual(decisions, 292)
    }
}
