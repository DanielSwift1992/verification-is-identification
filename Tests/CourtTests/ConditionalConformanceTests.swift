import Foundation
import XCTest
@testable import Court

final class ConditionalConformanceTests: XCTestCase {
    let root = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
        .deletingLastPathComponent().deletingLastPathComponent()
        .appendingPathComponent("Contracts/Court/conditional-conformances-v1")

    func input(_ name: String, countSelector: Bool = false) throws
        -> (CourtContext, NameMap<String>, String) {
        let path = name + ".json"
        var record = try JSONSerialization.jsonObject(with: Data(contentsOf: root.appendingPathComponent(path))) as! [String: Any]
        var sources = record["sources"] as! [[String: Any]]
        var texts: NameMap<String> = [:]
        for row in sources {
            let input = row["input"] as! String
            texts[input] = try WhereJudge.fileText(root.appendingPathComponent(input).path)
        }
        if countSelector {
            texts[name + ".swift"]! += """

            public protocol PredicateReading { associatedtype Predicate; associatedtype Encoding; associatedtype Sigma }
            public enum UnitsQuestion {}
            public enum UnaryArithmeticEncoding {}
            public enum Measure {}
            public enum CountReading: PredicateReading {
                public typealias Predicate = UnitsQuestion
                public typealias Encoding = UnaryArithmeticEncoding
                public typealias Sigma = Measure
            }

            """
            sources[0]["sha256"] = courtSHA256(Data(texts[name + ".swift"]!.utf8))
            record["sources"] = sources
        }
        let json = String(decoding: try JSONSerialization.data(withJSONObject: record), as: UTF8.self)
        texts[path] = json
        let context = try CourtContext(text: json, paths: sources.map { $0["input"] as! String }, texts: texts)
        return (context, texts, path)
    }

    func prepare(_ name: String) throws -> WhereJudge.Prepared {
        let (_, texts, context) = try input(name)
        return try WhereContext.prepare([name + ".swift", "Base.swift"], contextPath: context,
            load: { texts[$0]! }, documents: [], batch: true)
    }

    func testListSharesItsConditionAndContextBindingWithCountDiscovery() throws {
        let prepared = try prepare("Positive")
        XCTAssertEqual(prepared.world.gates.count, 2)
        XCTAssertTrue(try WhereJudge.evaluate(prepared, requireGrounds: true).refusals.isEmpty)
        let (context, texts, path) = try input("Positive", countSelector: true)
        let counted = try CourtNotation.countContext(context, contextPath: path, texts: texts, documents: [])
        XCTAssertEqual(counted.world.gates.count, 2)
        XCTAssertEqual(counted.world.gates.map(\.protocolLocation), prepared.world.gates.map(\.protocolLocation))
        let selectors = try CourtNotation.countQuestions(counted, input: "Positive.swift")
        XCTAssertEqual(selectors.count, 1)
        XCTAssertTrue(WhereJudge.sameName(selectors[0]["predicate"], "UnitsQuestion"))
        XCTAssertTrue(counted.world.contextNameBindingCertificate!.references.contains {
            $0.spelling == ScalarName("Base.Fenced") && $0.declaration == .init(parts: ["Base", "Fenced"])
        })
    }

    func testOnlyTheUnsatisfiedConformanceIsAddressed() throws {
        let result = try WhereJudge.evaluate(prepare("OneRefusal"), requireGrounds: true)
        XCTAssertEqual(result.refusals.count, 1, result.refusals.joined(separator: "\n"))
        XCTAssertTrue(result.refusals[0].contains("OneRefusal.swift:4:extension[0].conformances[1]"))
        XCTAssertTrue(result.refusals[0].contains("Fenced"))
        XCTAssertFalse(result.refusals[0].contains("[Base.Plain]"))
        let source = try WhereJudge.fileText(root.appendingPathComponent("Base.swift").path)
            + WhereJudge.fileText(root.appendingPathComponent("OneRefusal.swift").path)
                .replacingOccurrences(of: "import Base\n", with: "")
                .replacingOccurrences(of: "Base.", with: "")
        for text in [source, source.replacingOccurrences(of: "extension Use: Plain,\n Fenced", with: "extension Use: Plain where T.Home == Red {}\nextension Use: Fenced")] {
            let prepared = try WhereJudge.prepare(["SingleModule.swift"], load: { _ in text })
            let uncontextual = try WhereJudge.evaluate(prepared, requireGrounds: true)
            XCTAssertEqual(uncontextual.refusals.count, 1, uncontextual.refusals.joined(separator: "\n"))
            XCTAssertTrue(uncontextual.refusals[0].contains("[Fenced]"))
        }
    }

    func testUnknownProtocolRefusesBothReadersAtItsReference() throws {
        XCTAssertThrowsError(try prepare("Unknown")) { error in
            let messages = (error as? WhereJudge.Failure)?.messages.joined(separator: "\n") ?? String(describing: error)
            XCTAssertTrue(messages.contains("Unknown.swift:4"), messages)
            XCTAssertTrue(messages.contains("Missing"), messages)
        }
        let (context, texts, path) = try input("Unknown", countSelector: true)
        XCTAssertThrowsError(try CourtNotation.countContext(context, contextPath: path, texts: texts, documents: [])) { error in
            let messages = (error as? WhereJudge.Failure)?.messages.joined(separator: "\n") ?? String(describing: error)
            XCTAssertTrue(messages.contains("Unknown.swift:4"), messages)
            XCTAssertTrue(messages.contains("Missing"), messages)
        }
    }

    func testUnreadListSyntaxIsAddressed() throws {
        for header in ["extension Use: Plain & Fenced where T == T {}",
                       "extension Use: Plain, Fenced where {}",
                       "extension Use: Plain, Fenced where T == T"] {
            let source = "protocol Plain {}\nprotocol Fenced {}\nenum Use<T> {}\n" + header
            XCTAssertThrowsError(try WhereJudge.read(source, source: "Unread.swift")) { error in
                let messages = (error as? WhereJudge.Failure)?.messages.joined(separator: "\n") ?? String(describing: error)
                XCTAssertTrue(messages.contains("line 4"), messages)
            }
        }
        let source = """
        enum Container: Role {
            enum First {}
            enum Second {}
        }
        enum Namespace {
            enum Allowed {}
            struct Third {}
        }
        """
        let refusals = NotationScope.unreadDeclarations(source)
        XCTAssertEqual(refusals.count, 3)
        XCTAssertTrue(refusals[0].contains("line 2"))
        XCTAssertTrue(refusals[1].contains("line 3"))
        XCTAssertTrue(refusals[2].contains("line 7"))
        XCTAssertFalse(refusals.contains { $0.contains("Allowed") })
        XCTAssertThrowsError(try NotationScope(source)) { error in
            XCTAssertEqual((error as? WhereJudge.Failure)?.messages, [refusals[0]])
        }
    }
}
