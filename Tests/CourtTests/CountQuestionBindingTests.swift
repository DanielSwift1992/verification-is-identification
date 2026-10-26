import Foundation
import XCTest
@testable import Court

final class CountQuestionBindingTests: XCTestCase {
    let root = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
        .deletingLastPathComponent().deletingLastPathComponent()
        .appendingPathComponent("Contracts/Court/bound-questions-v1")

    func prepare(_ name: String) throws -> WhereJudge.Prepared {
        let path = name + ".json"
        let text = try String(contentsOf: root.appendingPathComponent(path), encoding: .utf8)
        let record = try JSONSerialization.jsonObject(with: Data(text.utf8)) as! [String: Any]
        let inputs = (record["sources"] as! [[String: Any]]).map { $0["input"] as! String }
        var texts: NameMap<String> = [path: text]
        for input in inputs {
            texts[input] = try String(contentsOf: root.appendingPathComponent(input), encoding: .utf8)
        }
        let context = try CourtContext(text: text, paths: inputs, texts: texts)
        return try CourtNotation.countContext(context, contextPath: path, texts: texts, documents: [])
    }

    func testDiscoveryUsesTheReplayedOwnerBindings() throws {
        let admitted = try prepare("Qualified")
        let selectors = try CourtNotation.countQuestions(admitted, input: "Qualified.swift")
        XCTAssertEqual(selectors.count, 1)
        XCTAssertTrue(WhereJudge.sameName(selectors.first?["predicate"], "UnitsQuestion"))
        XCTAssertTrue(WhereJudge.sameName(selectors.first?["encoding"], "UnaryArithmeticEncoding"))
        XCTAssertTrue(WhereJudge.sameName(selectors.first?["sigma"], "Measure"))
        XCTAssertTrue(admitted.world.contextNameBindingCertificate!.references.contains {
            $0.spelling == ScalarName("World.Note") && $0.declaration == .init(parts: ["World", "Note"])
        })
        XCTAssertThrowsError(try CourtNotation.countQuestions(admitted, input: "Missing.swift"))
        var world = admitted.world
        let proof = admitted.world.contextNameBindingCertificate!
        world.contextNameBindingCertificate = .init(schema: proof.schema, selected: proof.selected,
            inputs: proof.inputs, declarations: proof.declarations, references: [])
        let changed = WhereJudge.Prepared(path: admitted.path, world: world, ownAliases: admitted.ownAliases, excludesConditional: admitted.excludesConditional, boundFiles: admitted.boundFiles)
        XCTAssertThrowsError(try CourtNotation.countQuestions(changed, input: "Qualified.swift"))
    }

    func testDiscoveryRefusesUnboundExtensionOwnersAndOwnerlessSelf() throws {
        for (name, address, diagnostic) in [
            ("Unknown", "Unknown.swift:16", "scope owner 'World.Missing' is not provided"),
            ("Ambiguous", "Ambiguous.swift:18", "extension owner 'Box.Note' is missing or ambiguous"),
            ("Outside", "Outside.swift:14", "Self has no lexical owner")
        ] {
            XCTAssertThrowsError(try prepare(name)) { error in
                let message = (error as? WhereJudge.Failure)?.messages.joined(separator: "\n") ?? String(describing: error)
                XCTAssertTrue(message.contains(address), message)
                XCTAssertTrue(message.contains(diagnostic), message)
            }
        }
    }

    func testGenericSelfCarriesTheCertifiedOwnerParameters() throws {
        let admitted = try prepare("SelfOnly")
        let file = try XCTUnwrap(admitted.boundFiles.first { $0.context.input == "SelfOnly.swift" })
        XCTAssertTrue(file.view.contains("Reading<A,B,C>.Right"))
        let source = DefinitionReduction.Source(world: admitted.world, rigid: [])
        let result = try DefinitionReduction.normalForm(DefinitionReduction.parse("Probe.Answer"), source: source)
        XCTAssertEqual(result.output, try DefinitionReduction.parse("Plus<Unit,Unit>"))
    }
}
