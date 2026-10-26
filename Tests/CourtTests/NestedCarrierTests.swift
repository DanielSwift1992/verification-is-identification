import Foundation
import XCTest
@testable import Court

final class NestedCarrierTests: XCTestCase {
    let root = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
        .deletingLastPathComponent().deletingLastPathComponent()
        .appendingPathComponent("Contracts/Court/nested-carriers-v1")

    func prepare(_ name: String, count: Bool = false) throws -> WhereJudge.Prepared {
        let path = name + ".json"
        let text = try WhereJudge.fileText(root.appendingPathComponent(path).path)
        let record = try JSONSerialization.jsonObject(with: Data(text.utf8)) as! [String: Any]
        let inputs = (record["sources"] as! [[String: Any]]).map { $0["input"] as! String }
        if count {
            var texts: NameMap<String> = [path: text]
            for input in inputs { texts[input] = try WhereJudge.fileText(root.appendingPathComponent(input).path) }
            let context = try CourtContext(text: text, paths: inputs, texts: texts)
            return try CourtNotation.countContext(context, contextPath: path, texts: texts, documents: [])
        }
        return try WhereContext.prepare(inputs, contextPath: path,
            load: { try WhereJudge.fileText(self.root.appendingPathComponent($0).path) },
            documents: [], batch: true)
    }

    func testConformingOwnersRetainTheirOwnFieldsAndDistinctChildren() throws {
        let prepared = try prepare("Positive")
        XCTAssertTrue(try WhereJudge.evaluate(prepared, requireGrounds: true).refusals.isEmpty)
        for admitted in [prepared, try prepare("Positive", count: true)] {
            for owner in ["Company", "Ledger"] {
                XCTAssertFalse(admitted.world.namespaces.contains(owner))
                let carrier = try XCTUnwrap(admitted.world.conformers[owner])
                XCTAssertTrue(carrier.protocols.containsName("Carrier"))
                XCTAssertNotNil(carrier.table["Axis"])
                XCTAssertTrue(admitted.world.nestedNames.contains(owner + ".Slice"))
            }
        }
        let proof = try XCTUnwrap(prepared.world.contextNameBindingCertificate)
        XCTAssertTrue(proof.references.contains {
            $0.spelling == ScalarName("Ledger.Slice.Axis")
                && $0.declaration == .init(parts: ["World", "Ledger", "Slice", "Axis"])
        })
    }

    func testAmbiguousQualificationRefusesAtItsReference() throws {
        XCTAssertThrowsError(try prepare("Ambiguous")) { error in
            let message = String(describing: error)
            XCTAssertTrue(message.contains("Ambiguous.swift:3"), message)
            XCTAssertTrue(message.contains("Box"), message)
            XCTAssertTrue(message.contains("ambiguous"), message)
        }
    }

    func testOnlyAdmittedChildrenLeaveTheCarriersMemberProjection() throws {
        let text = "enum Company: Carrier { public enum Slice {}\n typealias Axis = Leaf\n static var body: Int { 0 } }"
        let notation = try NotationScope(text)
        let declarations = try notation.structural(text, origin: "World.swift", lent: [])
        let carrier = try XCTUnwrap(declarations.first { $0.name == "Company" })
        XCTAssertTrue(carrier.bodyWitness)
        XCTAssertTrue(carrier.unsupported.isEmpty, carrier.unsupported.joined(separator: "; "))
        XCTAssertEqual(carrier.fields["Axis"], "Leaf")
        XCTAssertEqual(carrier.fieldAccess["Axis"], "internal")
        for outside in ["enum Outer<T> { enum Inner {} }", "enum Outer: P { struct Inner {} }"] {
            XCTAssertThrowsError(try NotationScope(outside))
        }
        let plain = try NotationScope("enum Outer { enum Inner {} }")
        XCTAssertTrue(plain.namespaces.contains("Outer"))
    }
}
