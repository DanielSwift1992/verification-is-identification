import Foundation
import XCTest
@testable import Court

final class ContinuationRelationsTests: XCTestCase {
    typealias C = ContinuationCourt
    private let fixture = "Contracts/Court/continuation-relations-v1/cases.swift"
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
    private func constructed(_ request: String = "EqualityChain") throws -> (C.RelatedCertificate, [C.Selection], C.Program) {
        let p = try C.deriveRelated(request, source: world())
        guard case let .constructed(selections, program) = p.conclusion else {
            throw C.Failure("fixture did not construct")
        }
        return (p, selections, program)
    }
    private func obstructed(_ request: String = "DisconnectedClass") throws -> (C.RelatedCertificate, C.Obstruction) {
        let p = try C.deriveRelated(request, source: world())
        guard case let .obstructed(partition) = p.conclusion else {
            throw C.Failure("fixture did not obstruct")
        }
        return (p, partition)
    }
    private func refuses(_ id: String, address: String, _ body: () throws -> Void,
                         file: StaticString = #filePath, line: UInt = #line) {
        do {
            try body()
            XCTFail("admitted " + id, file: file, line: line)
        } catch {
            let diagnostic = String(describing: error)
            XCTAssertTrue(diagnostic.contains(address), diagnostic, file: file, line: line)
            print("T0088 \(id): refused: \(diagnostic)")
        }
    }
    func testNamedContractAndSerializedReplay() throws {
        let data = try Data(contentsOf: root.appendingPathComponent("Contracts/Court/continuation-relations-v1/contract.json"))
        let document = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])
        XCTAssertEqual(document["sha256"] as? String,
                       courtSHA256(try Data(contentsOf: root.appendingPathComponent(fixture))))
        let cases = try XCTUnwrap(document["cases"] as? [[String: String]])
        let s = try world()
        for entry in cases {
            let name = try XCTUnwrap(entry["request"])
            let outcome = try XCTUnwrap(entry["outcome"])
            if outcome == "unsupported" {
                refuses(name, address: try XCTUnwrap(entry["address"])) {
                    _ = try C.deriveRelated(name, source: s)
                }
            } else {
                let proof = try C.deriveRelated(name, source: s)
                let saved = try C.decodeRelated(C.encodeRelated(proof))
                let holds = try C.verifyRelated(name, certificate: saved, source: s)
                XCTAssertEqual(holds, outcome == "constructed", name)
                print("T0088 \(name): \(holds ? "constructed" : "obstructed"); serialized replay agrees")
            }
        }
        XCTAssertEqual(cases.count, 24)
    }
    func testOneEdgeChainAndAddressAreDifferentGrounds() throws {
        let (_, identity, _) = try constructed("AddressIdentity")
        guard case .address = identity[0].basis else { return XCTFail("identity ground") }
        let (_, one, _) = try constructed("OneEquality")
        guard case let .sourceRelation(a) = one[0].basis else { return XCTFail("source ground") }
        XCTAssertEqual(a.count, 1)
        let (_, chain, _) = try constructed()
        guard case let .sourceRelation(b) = chain[0].basis else { return XCTFail("source ground") }
        XCTAssertEqual(b.count, 2)
        let (_, reverse, _) = try constructed("ReversedChain")
        guard case let .sourceRelation(c) = reverse[0].basis else { return XCTFail("source ground") }
        XCTAssertTrue(c.allSatisfy(\.reversed))
    }
    func testForgedEPathRefusesWithAddress() throws {
        var (p, selections, program) = try constructed()
        selections[0].basis = .sourceRelation([.init(edge: [.right], reversed: false)])
        p.conclusion = .constructed(selections, program)
        refuses("forged-e-path", address: "certificate.selections[0].basis.path[0]") {
            _ = try C.verifyRelated(p.request, certificate: p, source: world())
        }
    }
    func testWrongPathEndpointAndForeignEdgeRefuse() throws {
        var (p, selections, program) = try constructed()
        selections[0].basis = .sourceRelation([.init(edge: [.left], reversed: false)])
        p.conclusion = .constructed(selections, program)
        refuses("wrong-e-endpoint", address: ".basis: E-path ends") {
            _ = try C.verifyRelated(p.request, certificate: p, source: world())
        }
        selections[0].basis = .sourceRelation([.init(edge: [.left, .left], reversed: false)])
        p.conclusion = .constructed(selections, program)
        refuses("foreign-e-edge", address: ".basis.path[0]") {
            _ = try C.verifyRelated(p.request, certificate: p, source: world())
        }
    }
    func testAddressIdentityCannotReplaceSourceEquality() throws {
        var (p, selections, program) = try constructed("OneEquality")
        selections[0].basis = .address
        p.conclusion = .constructed(selections, program)
        refuses("address-is-not-equality", address: ".basis: different source addresses") {
            _ = try C.verifyRelated(p.request, certificate: p, source: world())
        }
    }
    func testDisplayCoincidenceIsNotAnEqualityGround() throws {
        let s = try world()
        var p = try C.deriveRelated("DisplayCoincidence", source: s)
        p.conclusion = .constructed([.init(output: [], input: [], basis: .observedValues)], .pick([]))
        refuses("displayed-values-are-not-source-equality", address: ".basis: observed value coincidence") {
            _ = try C.verifyRelated(p.request, certificate: p, source: s)
        }
    }
    func testPartitionBreakingAnEEdgeRefuses() throws {
        var (p, partition) = try obstructed()
        partition.classes = [
            .init(sort: "$continuation0", leaves: [[.left, .left]]),
            .init(sort: "$continuation0", leaves: [[.left, .right]]),
            .init(sort: "$continuation0", leaves: [[.right, .left]]),
            .init(sort: "$continuation0", leaves: [[.right, .right]])
        ]
        p.conclusion = .obstructed(partition)
        refuses("partition-breaks-e-edge", address: "certificate.partition.E") {
            _ = try C.verifyRelated(p.request, certificate: p, source: world())
        }
    }
    func testNonseparatingPartitionRefuses() throws {
        var (p, partition) = try obstructed()
        partition.classes = [.init(sort: "$continuation0", leaves: [
            [.left, .left], [.left, .right], [.right, .left], [.right, .right]
        ])]
        p.conclusion = .obstructed(partition)
        refuses("partition-does-not-separate", address: "certificate.partition.question") {
            _ = try C.verifyRelated(p.request, certificate: p, source: world())
        }
    }
    func testCoarserSeparatingPartitionIsStillAValidObstruction() throws {
        var (p, partition) = try obstructed()
        // A coarser counterexample partition asserts no exact E-class names.
        partition.residue = nil
        partition.classes = [
            .init(sort: "$continuation0", leaves: [[.left, .left], [.left, .right]]),
            .init(sort: "$continuation0", leaves: [[.right, .left], [.right, .right]])
        ]
        p.conclusion = .obstructed(partition)
        XCTAssertFalse(try C.verifyRelated(p.request, certificate: p, source: world()))
    }
    func testCutsMapEachVisibleLeafToOneWholePlace() throws {
        let (p, selections, _) = try constructed("DuplicatedOrigin")
        let r = try C.relatedReading(p.request, certificate: p, source: world())
        XCTAssertEqual(r.observation.leaves.map(\.source), [[.left], [.left]])
        XCTAssertEqual(r.question.leaves.map(\.source), [[.left]])
        XCTAssertEqual(selections[0].input, [.left])
        let (whole, _, _) = try constructed("WholeAsObservation")
        let w = try C.relatedReading(whole.request, certificate: whole, source: world())
        XCTAssertEqual(w.question.leaves.map(\.source), [[.right], [.left]])
    }
    func testQuestionResidueNamesAllMissingClassesAndAddresses() throws {
        let (_, partition) = try obstructed("MultiClassResidue")
        let residue = try XCTUnwrap(partition.residue)
        XCTAssertEqual(residue.needed, [
            .init(block: 1, questions: [[.left], [.right, .right]]),
            .init(block: 2, questions: [[.right, .left]])
        ])
        XCTAssertEqual(partition.classes[1].leaves, [[.right, .left]])
        XCTAssertEqual(partition.classes[2].leaves, [[.right, .right]])
        let (_, joined) = try obstructed("ResidueEqualityClass")
        XCTAssertEqual(try XCTUnwrap(joined.residue).needed, [.init(block: 1, questions: [[.left], [.right]])])
        XCTAssertEqual(joined.classes[1].leaves, [[.right, .left], [.right, .right]])
        let (_, partial) = try obstructed("ResiduePartialQuestion")
        XCTAssertEqual(try XCTUnwrap(partial.residue).needed, [
            .init(block: 1, questions: [[.right, .left]]),
            .init(block: 2, questions: [[.right, .right]])
        ])
    }
    func testResidueCannotOmitClassesOrRetargetQuestionAddresses() throws {
        var (p, partition) = try obstructed("MultiClassResidue")
        partition.residue!.needed.removeLast()
        p.conclusion = .obstructed(partition)
        refuses("residue-omits-required-class", address: "certificate.residue.needed") {
            _ = try C.verifyRelated(p.request, certificate: p, source: world())
        }
        (p, partition) = try obstructed("MultiClassResidue")
        partition.residue!.needed[0].questions.removeLast()
        p.conclusion = .obstructed(partition)
        refuses("residue-omits-question-address", address: "certificate.residue.needed") {
            _ = try C.verifyRelated(p.request, certificate: p, source: world())
        }
    }
    func testClassNamesRequireDeclaredEConnections() throws {
        var (p, partition) = try obstructed("ResidueEqualityClass")
        partition.residue!.connections[1][0].reversed.toggle()
        p.conclusion = .obstructed(partition)
        refuses("residue-foreign-origin", address: "certificate.residue.connections[1][0]") {
            _ = try C.verifyRelated(p.request, certificate: p, source: world())
        }
        (p, partition) = try obstructed()
        partition.classes[1].leaves.append(contentsOf: partition.classes[2].leaves)
        partition.classes.removeLast()
        partition.residue!.connections.removeLast()
        partition.residue!.connections[1] = [.init(edge: [], reversed: false)]
        p.conclusion = .obstructed(partition)
        refuses("residue-merges-independent-places", address: "certificate.residue.connections[1][0]") {
            _ = try C.verifyRelated(p.request, certificate: p, source: world())
        }
    }
    func testClassForestCoverageAndEdgeAddressesRefuse() throws {
        var (p, partition) = try obstructed("ResidueEqualityClass")
        partition.residue!.connections[1].removeLast()
        p.conclusion = .obstructed(partition)
        refuses("residue-incomplete-forest", address: "certificate.residue.connections[1]") {
            _ = try C.verifyRelated(p.request, certificate: p, source: world())
        }
        (p, partition) = try obstructed("ResidueEqualityClass")
        partition.residue!.connections[1][0].edge = [.left]
        p.conclusion = .obstructed(partition)
        refuses("residue-foreign-edge", address: "certificate.residue.connections[1][0]") {
            _ = try C.verifyRelated(p.request, certificate: p, source: world())
        }
    }
    func testLiveWholeCannotAcquireAnUnreadAxis() throws {
        let (helpers, _, _) = try constructed("ReadWholeHelperAxes")
        XCTAssertTrue(try C.verifyRelated(helpers.request, certificate: helpers, source: world()))
        let (p, _, _) = try constructed("AddressIdentity")
        for axis in ["Equality", "Spare"] {
            let changed = try world {
                $0.replacingOccurrences(of: "enum AddressIdentity<S: Structure> {",
                    with: "enum AddressIdentity<S: Structure> {\n    typealias " + axis + " = Source.Right")
            }
            refuses("unread-live-axis-" + axis, address: "AddressIdentity." + axis) {
                _ = try C.verifyRelated(p.request, certificate: p, source: changed)
            }
        }
    }
    func testNonleafPartitionEntryHasItsCertificateAddress() throws {
        var (p, partition) = try obstructed()
        partition.classes[1].leaves = [[.right]]
        p.conclusion = .obstructed(partition)
        refuses("partition-nonleaf", address: "certificate.partition[1]: Source.Right") {
            _ = try C.verifyRelated(p.request, certificate: p, source: world())
        }
    }
    func testIncompletePartitionAndDifferentSortRefuse() throws {
        var (p, partition) = try obstructed()
        partition.classes.removeLast()
        p.conclusion = .obstructed(partition)
        refuses("incomplete-partition", address: "certificate.partition: incomplete") {
            _ = try C.verifyRelated(p.request, certificate: p, source: world())
        }
        (p, partition) = try obstructed()
        partition.classes[0].sort = "$continuation1"
        p.conclusion = .obstructed(partition)
        refuses("wrong-partition-sort", address: "certificate.partition[0]") {
            _ = try C.verifyRelated(p.request, certificate: p, source: world())
        }
    }
    func testQuestionAndLiveRelationCannotBeRetargeted() throws {
        let (p, _, _) = try constructed("OneEquality")
        let changedQuestion = try world {
            $0.replacingOccurrences(of: "typealias Question = Source.Right\n", with: "typealias Question = Source.Left\n")
        }
        refuses("changed-question", address: "OneEquality.Question") {
            _ = try C.verifyRelated(p.request, certificate: p, source: changedQuestion)
        }
        let changedE = try world {
            $0.replacingOccurrences(of: "typealias Equalities = Paired<Source.Left, Source.Right>",
                                    with: "typealias Equalities = Paired<Source.Left, Source.Left>")
        }
        refuses("changed-live-e", address: "OneEquality.Equalities") {
            _ = try C.verifyRelated(p.request, certificate: p, source: changedE)
        }
        var omitted = p
        omitted.equalities = nil
        refuses("omitted-live-e", address: "OneEquality.Equalities: changed relation coverage") {
            _ = try C.verifyRelated(omitted.request, certificate: omitted, source: world())
        }
    }
    func testOutputCoverageAndAssembledTermRefuse() throws {
        var (p, selections, program) = try constructed("JointQuestion")
        selections.removeLast()
        p.conclusion = .constructed(selections, program)
        refuses("missing-output-selection", address: "certificate.selections") {
            _ = try C.verifyRelated(p.request, certificate: p, source: world())
        }
        (p, selections, program) = try constructed("JointQuestion")
        p.conclusion = .constructed(selections, .pick([]))
        refuses("changed-assembled-term", address: "certificate.program") {
            _ = try C.verifyRelated(p.request, certificate: p, source: world())
        }
    }
    func testCRLFAndRenamedParameterPreserveOccurrenceRelations() throws {
        let s = try world { $0.replacingOccurrences(of: "\n", with: "\r\n") }
        let p = try C.deriveRelated("EqualityChain", source: s)
        XCTAssertTrue(try C.verifyRelated(p.request, certificate: p, source: s))
        let renamed = try world { $0.replacingOccurrences(of: "\\bS\\b", with: "Opaque", options: .regularExpression) }
        // The name of the request is preserved by selecting an unaffected fixture.
        let q = try C.deriveRelated("EqualityChain", source: renamed)
        XCTAssertTrue(try C.verifyRelated(q.request, certificate: q, source: renamed))
    }
}
