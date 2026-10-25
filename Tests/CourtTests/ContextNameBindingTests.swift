import XCTest
@testable import Court

final class ContextNameBindingTests: XCTestCase {
    func testInheritedReferencesHaveOneCertifiedPlace() throws {
        let base = "public enum Leaf {}\npublic protocol P { associatedtype Axis }\npublic protocol Q: P where Axis == Leaf {}\n"
        let proof = try index(base)
        XCTAssertTrue(proof.certificate.references.contains {
            $0.line == 3 && $0.spelling == ScalarName("Axis")
                && $0.declaration == .init(parts: ["World", "P", "Axis"])
        })
        try proof.replay(proof.certificate)
        let qualified = try index(base.replacingOccurrences(of: "where Axis", with: "where Self.Axis"))
        let edge = try XCTUnwrap(qualified.certificate.references.first { $0.receiver != nil })
        var forged = edge
        forged.receiver = .init(parts: ["World", "Other"])
        let changedReceiver = ContextNameBinding.Certificate(schema: qualified.certificate.schema,
            selected: qualified.certificate.selected, inputs: qualified.certificate.inputs,
            declarations: qualified.certificate.declarations,
            references: qualified.certificate.references.map { $0 == edge ? forged : $0 })
        XCTAssertThrowsError(try qualified.replay(changedReceiver))
        XCTAssertThrowsError(try index("public enum Axis {}\n" + base)) { error in
            let message = String(describing: error)
            XCTAssertTrue(message.contains("ambiguous name Axis"))
            XCTAssertTrue(message.contains("World.Axis at World.swift:1"))
            XCTAssertTrue(message.contains("World.P.Axis at World.swift:3"))
        }
        let parents = try index("public protocol Base { associatedtype Target }\npublic protocol Target {}\npublic protocol Derived: Base, Target {}\n")
        XCTAssertTrue(parents.certificate.references.contains {
            $0.line == 3 && $0.spelling == ScalarName("Target")
                && $0.declaration == .init(parts: ["World", "Target"])
        })
        let conditional = try index("public enum Leaf {}\npublic protocol Base {}\npublic protocol P { associatedtype Axis }\npublic protocol Q: Base where Self: P, Axis == Leaf {}\n")
        XCTAssertTrue(conditional.certificate.references.contains {
            $0.line == 4 && $0.spelling == ScalarName("Axis")
                && $0.declaration == .init(parts: ["World", "P", "Axis"])
        })
        let regional = try index("public enum Axis {}\npublic protocol P { associatedtype Axis }\npublic protocol Q {}\nextension Q where Self: P { typealias Pick = Self.Axis }\nextension Q { typealias Other = Axis }\n")
        XCTAssertTrue(regional.certificate.references.contains {
            $0.line == 5 && $0.spelling == ScalarName("Axis")
                && $0.declaration == .init(parts: ["World", "Axis"])
        })
    }

    func testGenericParameterIsLexicalAndNeverAnOwnerMember() throws {
        XCTAssertThrowsError(try index("public enum Box<Param> {}\npublic typealias Pick = Box.Param\n")) { error in
            XCTAssertTrue(String(describing: error).contains("generic parameter, not a member"))
        }
        let source = "public protocol Maker { func make<Axis>(_ value: Axis) -> Axis }\n"
        let proof = try index(source)
        let parameter = try XCTUnwrap(proof.certificate.declarations.first { $0.kind == ScalarName("parameter") })
        XCTAssertTrue(parameter.place.parts[2].hasPrefix("make#"))
        XCTAssertEqual(parameter.place.parts.last, "Axis")
        XCTAssertEqual(proof.certificate.references.filter { $0.declaration == parameter.place }.count, 2)
        let multiline = try index("public protocol Maker { func make<Axis>(_ value: Axis) ->\n Axis\n}\npublic enum Outside {}\n")
        let multilineParameter = try XCTUnwrap(multiline.certificate.declarations.first { $0.kind == ScalarName("parameter") })
        XCTAssertEqual(multiline.certificate.references.filter { $0.declaration == multilineParameter.place }.count, 2)
        XCTAssertTrue(multiline.certificate.declarations.contains { $0.place == .init(parts: ["World", "Outside"]) })
    }

    func testImportAndReexportCyclesRefuseAtTheDeclaredImport() throws {
        let sources = [("A", "@_exported import B\n", ["B"]), ("B", "import A\n", ["A"])]
        let files = try sources.map { name, text, imports -> CourtNotation.File in
            let context = CourtContext.Source(input: name + ".swift", source: name + ".swift",
                sha256: courtSHA256(Data(text.utf8)), namespace: name, module: name, role: "own",
                imports: imports, at: [:], importAddresses: [name + ".swift:1 imports"])
            let world = try WhereJudge.read(text, contextV2: true)
            return CourtNotation.File(context: context, text: text, view: text, world: world,
                notation: try NotationScope(world.clean), excluded: nil, unchecked: [])
        }
        XCTAssertThrowsError(try ContextNameBinding.read(files, selected: "A.swift")) { error in
            XCTAssertTrue(String(describing: error).contains("B.swift:1 imports: cyclic imports"))
        }
    }

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
        let defaultSource = "public enum Leaf {}\npublic protocol P { associatedtype Slot }\nextension P { public typealias Slot = Leaf }\n"
        let withDefault = try index(defaultSource)
        let slot = try XCTUnwrap(withDefault.certificate.declarations.first {
            WhereJudge.sameNames($0.place.parts, ["World", "P", "Slot"])
        })
        XCTAssertEqual(slot.kind, ScalarName("associatedtype"))
        XCTAssertEqual(slot.definitions.count, 1)
        try withDefault.replay(withDefault.certificate)
        var lostDefault = slot
        lostDefault.definitions = []
        let omittedDefault = ContextNameBinding.Certificate(schema: withDefault.certificate.schema,
            selected: withDefault.certificate.selected, inputs: withDefault.certificate.inputs,
            declarations: withDefault.certificate.declarations.map { $0.place == slot.place ? lostDefault : $0 },
            references: withDefault.certificate.references)
        XCTAssertThrowsError(try withDefault.replay(omittedDefault))
        XCTAssertThrowsError(try index(defaultSource + "extension P { public typealias Slot = Leaf }\n"))
        let supplied = [
            ("World", "World.swift", "import Kit\nextension Box { public typealias Item = Leaf }\npublic typealias Pick = Box.Item\n", ["Kit"]),
            ("Kit", "Kit.swift", "public enum Box {}\npublic enum Leaf {}\n", []),
        ]
        let units = try supplied.map { module, path, text, imports in
            let context = CourtContext.Source(input: path, source: path,
                sha256: courtSHA256(Data(text.utf8)), namespace: module, module: module, role: "own",
                imports: imports, at: [:], importAddresses: [])
            let world = try WhereJudge.read(text, contextV2: true, source: path)
            return CourtNotation.File(context: context, text: text, view: text, world: world,
                notation: try NotationScope(world.clean), excluded: nil, unchecked: [])
        }
        let foreign = try ContextNameBinding.read(units, selected: "World.swift")
        XCTAssertTrue(foreign.certificate.declarations.contains {
            WhereJudge.sameNames($0.place.parts, ["Kit", "Box", "Item"])
        })
        XCTAssertTrue(foreign.certificate.references.contains {
            WhereJudge.sameNames($0.declaration.parts, ["Kit", "Box", "Item"])
        })
        try foreign.replay(foreign.certificate)
        let reordered = try ContextNameBinding.read(Array(units.reversed()), selected: "World.swift")
        XCTAssertEqual(Set(foreign.certificate.declarations.map(\.place)),
            Set(reordered.certificate.declarations.map(\.place)))
    }
}
