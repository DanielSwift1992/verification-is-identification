import XCTest
@testable import Court

final class WitnessPriorityTests: XCTestCase {
    func index(_ inputs: [(String, String, String, [String])]) throws -> ContextNameBinding.Index {
        let files = try inputs.map { module, path, text, imports in
            let context = CourtContext.Source(input: path, source: path,
                sha256: courtSHA256(Data(text.utf8)), namespace: module, module: module, role: "own",
                imports: imports, at: [:], importAddresses: [])
            let world = try WhereJudge.read(text, contextV2: true, source: path)
            return CourtNotation.File(context: context, text: text, view: text, world: world,
                notation: try NotationScope(world.clean), excluded: nil, unchecked: [])
        }
        return try ContextNameBinding.read(files, selected: "World.swift")
    }

    func testAliasAndNestedWitnessesHaveOneConcretePlaceAndReplayRejectsTheRequirement() throws {
        let text = "public enum Leaf {}\npublic protocol P { associatedtype X }\npublic protocol Q: P {}\npublic enum Holder: Q { typealias X = Leaf\n typealias Pick = X }\npublic enum Nested: P { enum X {}\n typealias Pick = X }\n"
        let read = try index([("World", "World.swift", text, [])])
        let proof = read.certificate
        for owner in ["Holder", "Nested"] {
            XCTAssertTrue(proof.references.contains {
                $0.spelling == ScalarName("X") && $0.declaration == .init(parts: ["World", owner, "X"])
            })
        }
        try read.replay(proof)
        let edge = try XCTUnwrap(proof.references.first { $0.spelling == ScalarName("X") })
        let forged = ContextNameBinding.Reference(input: edge.input, scopes: edge.scopes,
            source: edge.source, line: edge.line, offset: edge.offset, end: edge.end,
            spelling: edge.spelling, declaration: .init(parts: ["World", "P", "X"]),
            receiver: edge.receiver, primaryAssociatedType: edge.primaryAssociatedType)
        let counterfeit = ContextNameBinding.Certificate(schema: proof.schema, selected: proof.selected,
            inputs: proof.inputs, declarations: proof.declarations,
            references: proof.references.map { $0 == edge ? forged : $0 })
        XCTAssertThrowsError(try read.replay(counterfeit)) { error in
            XCTAssertTrue(String(describing: error).contains("World.swift:\(edge.line): name binding reference differs"))
        }
    }

    func testOwnModuleRootsPrecedeImportsInReferencesHeadersAndExtensions() throws {
        let world = "import Kit\npublic enum Leaf {}\npublic enum Item {}\npublic protocol P { associatedtype X }\npublic enum Holder: P { typealias X = Leaf\n typealias Pick = X }\npublic typealias Pick = Item\nextension Item { public typealias Member = Leaf }\n"
        let kit = "public enum Item {}\npublic protocol P { associatedtype Other }\n"
        let read = try index([("World", "World.swift", world, ["Kit"]), ("Kit", "Kit.swift", kit, [])])
        XCTAssertTrue(read.certificate.declarations.contains { $0.place == .init(parts: ["World", "Item", "Member"]) })
        XCTAssertFalse(read.certificate.declarations.contains { $0.place == .init(parts: ["Kit", "Item", "Member"]) })
        XCTAssertTrue(read.certificate.references.contains { $0.spelling == ScalarName("P") && $0.declaration == .init(parts: ["World", "P"]) })
        XCTAssertTrue(read.certificate.references.contains { $0.spelling == ScalarName("Item") && $0.declaration == .init(parts: ["World", "Item"]) })
        try read.replay(read.certificate)
    }

    func testTwoImportsStillRefuseReferencesAndExtensionOwners() throws {
        let imports = [("Kit", "Kit.swift", "public enum Item {}\n", [String]()),
                       ("Other", "Other.swift", "public enum Item {}\n", [String]())]
        for tail in ["public typealias Pick = Item\n", "extension Item {}\n"] {
            XCTAssertThrowsError(try index([("World", "World.swift", "import Kit\nimport Other\n" + tail, ["Kit", "Other"])] + imports)) { error in
                let text = String(describing: error)
                XCTAssertTrue(text.contains("World.swift:3:"), text)
                XCTAssertTrue(text.contains("ambiguous"), text)
            }
        }
    }

    func testUnrelatedLexicalCompetitorsAndGenericContainerStillRefuse() throws {
        XCTAssertThrowsError(try index([
            ("World", "World.swift", "import Kit\npublic enum Leaf {}\npublic typealias Item = Leaf\nextension Item {}\n", ["Kit"]),
            ("Kit", "Kit.swift", "public enum Item {}\n", [])
        ])) { error in
            XCTAssertTrue(String(describing: error).contains("World.swift:4: extension owner 'Item' is a local typealias"))
        }
        for text in [
            "protocol P { associatedtype X }\nprotocol Q: P { typealias X = Never\n typealias Pick = X }\n",
            "enum X {}\nprotocol P { associatedtype X }\nenum Holder: P { typealias X = Never\n typealias Pick = X }\n",
            "protocol P { associatedtype X }\nenum Holder: P { typealias X = Never\n func use<X>(_ value: X) -> X {} }\n"
        ] {
            XCTAssertThrowsError(try index([("World", "World.swift", text, [])])) { error in
                XCTAssertTrue(String(describing: error).contains("ambiguous name X"))
            }
        }
        XCTAssertThrowsError(try NotationScope("enum Holder<T> { enum Child {} }"))
    }
}
