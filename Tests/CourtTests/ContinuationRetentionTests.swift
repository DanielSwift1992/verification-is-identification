import Foundation
import XCTest
@testable import Court

final class ContinuationRetentionTests: XCTestCase {
    typealias C = ContinuationCourt
    private let fixture = "Contracts/Court/continuation-relations-v1/retention-cases.swift"
    private var root: URL {
        URL(fileURLWithPath: #filePath).deletingLastPathComponent()
            .deletingLastPathComponent().deletingLastPathComponent()
    }
    private func world(_ edit: ((String) -> String)? = nil) throws -> StructuralSource {
        let primitive = "Sources/VerificationIsIdentification/Primitive.swift"
        let text = try String(contentsOf: root.appendingPathComponent(fixture), encoding: .utf8)
        return try StructuralSource(files: [
            (primitive, String(contentsOf: root.appendingPathComponent(primitive), encoding: .utf8)),
            (fixture, edit?(text) ?? text)
        ])
    }
    private func plan(_ request: String = "RetainOneClass") throws -> C.RelatedCertificate {
        try C.deriveRelated(request, source: world(), retain: true)
    }
    private func refuses(_ id: String, address: String, _ body: () throws -> Void,
                         file: StaticString = #filePath, line: UInt = #line) {
        do {
            try body()
            XCTFail("admitted " + id, file: file, line: line)
        } catch {
            let message = String(describing: error)
            XCTAssertTrue(message.contains(address), message, file: file, line: line)
            print("T0094 \(id): refused: \(message)")
        }
    }
    func testNamedRetentionContractAndSerializedReplay() throws {
        let data = try Data(contentsOf: root.appendingPathComponent("Contracts/Court/continuation-relations-v1/contract.json"))
        let document = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])
        let retention = try XCTUnwrap(document["retention"] as? [String: Any])
        XCTAssertEqual(retention["fixture"] as? String, "retention-cases.swift")
        XCTAssertEqual(retention["sha256"] as? String,
                       courtSHA256(try Data(contentsOf: root.appendingPathComponent(fixture))))
        let cases = try XCTUnwrap(retention["cases"] as? [[String: Any]])
        XCTAssertEqual(cases.count, 5)
        let source = try world()
        for entry in cases {
            let name = try XCTUnwrap(entry["request"] as? String)
            let minimum = try XCTUnwrap(entry["minimum_leaves"] as? Int)
            let proof = try C.deriveRelated(name, source: source, retain: true)
            XCTAssertEqual(try C.verifyRelatedRetention(name, certificate: proof, source: source), minimum)
            // A plan for a joint view never becomes a decoder from P alone.
            XCTAssertEqual(try C.verifyRelated(name, certificate: proof, source: source), minimum == 0)
            let bytes = try C.encodeRelated(proof)
            let archive = try XCTUnwrap(JSONSerialization.jsonObject(with: bytes) as? [String: Any])
            XCTAssertEqual(archive["format"] as? Int, minimum == 0 ? 2 : 3)
            let saved = try C.decodeRelated(bytes)
            XCTAssertEqual(try C.verifyRelatedRetention(name, certificate: saved, source: source), minimum)
            XCTAssertEqual(try C.encodeRelated(saved), bytes)
            print("T0094 \(name): minimum \(minimum) source leaves; serialized replay agrees")
        }
    }
    func testJointViewAndRepeatedQuestionUseOneSameSourceLeaf() throws {
        let repeated = try plan("RetainRepeatedClass")
        let m = try XCTUnwrap(repeated.retention)
        XCTAssertEqual(m.leaves, [[.right]])
        XCTAssertEqual(m.view, .pick([.right]))
        XCTAssertEqual(m.selections.map(\.input), [[.right], [.right]])
        XCTAssertEqual(m.program, .pair(.pick([.right]), .pick([.right])))
        let two = try XCTUnwrap(plan("RetainTwoSorts").retention)
        XCTAssertEqual(two.leaves, [[.right, .left], [.right, .right]])
        XCTAssertEqual(two.view, .pair(.pick([.right, .left]), .pick([.right, .right])))
        XCTAssertEqual(two.program, .pair(.pick([.left]), .pair(.pick([.right, .left]), .pick([.right, .right]))))
        var reordered = try plan("RetainTwoSorts")
        reordered.retention!.leaves.reverse()
        reordered.retention!.view = .pair(.pick([.right, .right]), .pick([.right, .left]))
        reordered.retention!.selections[1].input = [.right, .right]
        reordered.retention!.selections[2].input = [.right, .left]
        reordered.retention!.program = .pair(.pick([.left]), .pair(.pick([.right, .right]), .pick([.right, .left])))
        XCTAssertEqual(try C.verifyRelatedRetention(reordered.request, certificate: reordered, source: world()), 2)
    }
    func testRepresentativeOutsideViewsAndAnotherValidRepresentative() throws {
        var proof = try plan("RetainFromClassOutsideViews")
        let m = try XCTUnwrap(proof.retention)
        XCTAssertEqual(m.leaves, [[.left]])
        guard case let .sourceRelation(path) = m.selections[0].basis else { return XCTFail("E-path required") }
        XCTAssertEqual(path.count, 1)
        XCTAssertEqual(path[0].edge, [])
        XCTAssertFalse(path[0].reversed)
        // The other member of the same class is also a valid minimal choice.
        proof.retention!.leaves = [[.right, .left]]
        proof.retention!.view = .pick([.right, .left])
        proof.retention!.selections[0].basis = .address
        XCTAssertEqual(try C.verifyRelatedRetention(proof.request, certificate: proof, source: world()), 1)
    }
    func testOmittedExtraWrongClassAndNonleafResidualRefuse() throws {
        let good = try plan()
        var changed = good
        changed.retention!.leaves = []
        refuses("omitted-class", address: "certificate.retention.leaves:") {
            _ = try C.verifyRelatedRetention(changed.request, certificate: changed, source: world())
        }
        changed = good
        changed.retention!.leaves.append([.right])
        refuses("extra-leaf-not-minimal", address: "certificate.retention.leaves:") {
            _ = try C.verifyRelatedRetention(changed.request, certificate: changed, source: world())
        }
        let paths: [C.Path] = [[.left], [.right, .left], []]
        for path in paths {
            changed = good
            changed.retention!.leaves = [path]
            refuses("wrong-or-unavailable-source-place", address: "certificate.retention.leaves[0]") {
                _ = try C.verifyRelatedRetention(changed.request, certificate: changed, source: world())
            }
        }
        changed = try plan("RetainTwoSorts")
        changed.retention!.leaves = [[.right, .left], [.right, .left]]
        refuses("duplicate-class-with-correct-leaf-count", address: "certificate.retention.leaves[1]") {
            _ = try C.verifyRelatedRetention(changed.request, certificate: changed, source: world())
        }
    }
    func testMinimalityRequiresExactClassesAndAPresentedRetainedView() throws {
        var proof = try plan()
        guard case var .obstructed(obstruction) = proof.conclusion else { return XCTFail("obstruction required") }
        obstruction.residue = nil
        proof.conclusion = .obstructed(obstruction)
        refuses("coarse-partition-does-not-prove-minimality", address: "certificate.retention: exact residue proof") {
            _ = try C.verifyRelatedRetention(proof.request, certificate: proof, source: world())
        }
        proof = try plan("RetainFromClassOutsideViews")
        guard case var .obstructed(exact) = proof.conclusion else { return XCTFail("obstruction required") }
        exact.residue!.connections[0] = []
        proof.conclusion = .obstructed(exact)
        refuses("broken-class-forest", address: "certificate.residue.connections[0]") {
            _ = try C.verifyRelatedRetention(proof.request, certificate: proof, source: world())
        }
        proof = try C.deriveRelated("RetainOneClass", source: world())
        XCTAssertFalse(try C.verifyRelated(proof.request, certificate: proof, source: world()))
        refuses("old-obstruction-is-not-a-retention-plan", address: "certificate.retention: no retained view") {
            _ = try C.verifyRelatedRetention(proof.request, certificate: proof, source: world())
        }
    }
    func testForgedEqualityPathViewAndDecoderRefuse() throws {
        var proof = try plan("RetainFromClassOutsideViews")
        proof.retention!.selections[0].basis = .sourceRelation([.init(edge: [.left], reversed: false)])
        refuses("forged-e-path", address: "certificate.retention.selections[0].basis.path[0]") {
            _ = try C.verifyRelatedRetention(proof.request, certificate: proof, source: world())
        }
        proof = try plan()
        proof.retention!.selections[0].input = [.left, .left]
        refuses("forged-joint-input", address: "certificate.retention.selections[0].input:") {
            _ = try C.verifyRelatedRetention(proof.request, certificate: proof, source: world())
        }
        proof = try plan()
        proof.retention!.view = .pick([])
        refuses("forged-retained-view", address: "certificate.retention.view:") {
            _ = try C.verifyRelatedRetention(proof.request, certificate: proof, source: world())
        }
        proof = try plan()
        proof.retention!.program = .pick([.left])
        refuses("forged-joint-decoder", address: "certificate.retention.program:") {
            _ = try C.verifyRelatedRetention(proof.request, certificate: proof, source: world())
        }
    }
    func testZeroResidualKeepsFormat2BytesAndFormatsCannotMasquerade() throws {
        let ordinary = try C.deriveRelated("RetainNothing", source: world())
        let retained = try plan("RetainNothing")
        XCTAssertNil(retained.retention)
        XCTAssertNil(C.retainedPlaces([]))
        XCTAssertEqual(try C.verifyRelatedRetention(retained.request, certificate: retained, source: world()), 0)
        XCTAssertEqual(try C.encodeRelated(ordinary), try C.encodeRelated(retained))
        for (proof, wrongFormat) in [(try plan(), 2), (ordinary, 3)] {
            var archive = try XCTUnwrap(JSONSerialization.jsonObject(with: C.encodeRelated(proof)) as? [String: Any])
            archive["format"] = wrongFormat
            refuses("format-does-not-match-retention-claim", address: "certificate: expected format 2") {
                _ = try C.decodeRelated(JSONSerialization.data(withJSONObject: archive))
            }
        }
    }
    func testLiveEqualitiesAndSourceCannotBeRetargeted() throws {
        let proof = try plan("RetainFromClassOutsideViews")
        let changedE = try world {
            $0.replacingOccurrences(of: "typealias Equalities = Paired<Source.Left, Source.Right.Left>",
                                    with: "typealias Equalities = Paired<Source.Right.Right, Source.Right.Left>")
        }
        refuses("changed-live-e", address: "RetainFromClassOutsideViews.Equalities") {
            _ = try C.verifyRelatedRetention(proof.request, certificate: proof, source: changedE)
        }
        let changedSource = try world {
            $0.replacingOccurrences(of: "typealias Source = Paired<S, Paired<S, S>>",
                                    with: "typealias Source = Paired<S, Paired<S, Paired<S, S>>>")
        }
        refuses("changed-live-source", address: "RetainFromClassOutsideViews.Source") {
            _ = try C.verifyRelatedRetention(proof.request, certificate: proof, source: changedSource)
        }
    }
}
