import XCTest
@testable import Court

final class ContextNameBindingTests: XCTestCase {
    func index(_ text: String) throws -> ContextNameBinding.Index {
        let source = CourtContext.Source(input: "World.swift", source: "World.swift",
            sha256: courtSHA256(Data(text.utf8)), namespace: "World", module: "World", role: "own",
            imports: [], at: [:], importAddresses: [])
        let world = try WhereJudge.read(text, contextV2: true, source: source.source)
        let file = CourtNotation.File(context: source, text: text, view: text, world: world,
            notation: try NotationScope(world.clean), excluded: nil, unchecked: [])
        return try ContextNameBinding.read([file], selected: source.input)
    }

    func testBindingReplayRequiresEveryOriginalEdgeAndPlace() throws {
        let read = try index("public enum Item {}\npublic typealias Pick = Item\n")
        let proof = read.certificate
        try read.replay(proof)
        XCTAssertFalse(proof.references.isEmpty)
        let edge = try XCTUnwrap(proof.references.first)
        let changed = ContextNameBinding.Reference(input: edge.input, scopes: edge.scopes, source: edge.source, line: edge.line,
            offset: edge.offset, end: edge.end, spelling: edge.spelling,
            declaration: .init(parts: ["Other", "Item"]))
        let replaced = ContextNameBinding.Certificate(schema: proof.schema, selected: proof.selected, inputs: proof.inputs,
            declarations: proof.declarations, references: [changed] + proof.references.dropFirst())
        XCTAssertThrowsError(try read.replay(replaced))
        let omitted = ContextNameBinding.Certificate(schema: proof.schema, selected: proof.selected, inputs: proof.inputs,
            declarations: proof.declarations, references: [])
        XCTAssertThrowsError(try read.replay(omitted))
        let added = ContextNameBinding.Certificate(schema: proof.schema, selected: proof.selected, inputs: proof.inputs,
            declarations: proof.declarations, references: proof.references + [edge])
        XCTAssertThrowsError(try read.replay(added))
        let absent = ContextNameBinding.Certificate(schema: proof.schema, selected: proof.selected, inputs: proof.inputs,
            declarations: [], references: proof.references)
        XCTAssertThrowsError(try read.replay(absent))
        let input = try XCTUnwrap(proof.inputs.first)
        let swapped = ContextNameBinding.Certificate(schema: proof.schema, selected: proof.selected,
            inputs: [.init(input: input.input, module: input.module, imports: input.imports, source: input.source, sha256: String(repeating: "0", count: 64), viewSHA256: input.viewSHA256)],
            declarations: proof.declarations, references: proof.references)
        XCTAssertThrowsError(try read.replay(swapped))
        let otherQuestion = ContextNameBinding.Certificate(schema: proof.schema,
            selected: ScalarName("Other.swift"), inputs: proof.inputs,
            declarations: proof.declarations, references: proof.references)
        XCTAssertThrowsError(try read.replay(otherQuestion))
        let unicode = try index("public enum Café {}\npublic typealias Pick = Café\n")
        let unicodeProof = unicode.certificate
        let written = try XCTUnwrap(unicodeProof.references.first)
        let equivalent = ContextNameBinding.Reference(input: written.input, scopes: written.scopes,
            source: written.source, line: written.line, offset: written.offset, end: written.end,
            spelling: ScalarName("Cafe\u{301}"), declaration: written.declaration)
        let counterfeit = ContextNameBinding.Certificate(schema: unicodeProof.schema,
            selected: unicodeProof.selected, inputs: unicodeProof.inputs,
            declarations: unicodeProof.declarations, references: [equivalent])
        XCTAssertThrowsError(try unicode.replay(counterfeit))
    }

    func testFragmentRefusesShadowingButReadsQualifiedAssociatedType() throws {
        let declarations = "public enum Axis {}\npublic protocol P { associatedtype Axis }\n"
        let ambiguous = declarations + "public protocol Q { associatedtype Axis\n typealias Pick = Axis }\n"
        XCTAssertThrowsError(try index(ambiguous)) { error in
            XCTAssertTrue(String(describing: error).contains("ambiguous name Axis"))
        }
        let qualified = try index(declarations + "public protocol Q { associatedtype Axis\n typealias Pick = Self.Axis }\n")
        XCTAssertTrue(qualified.certificate.references.contains { WhereJudge.sameNames($0.declaration.parts, ["World", "Q", "Axis"]) })
        try qualified.replay(qualified.certificate)
    }
}
