import Foundation
import XCTest
@testable import Court

final class ContinuationAgreementTests: XCTestCase {
    typealias C = ContinuationCourt
    private let directory = "Contracts/Court/continuation-relations-v1/"
    private var root: URL {
        URL(fileURLWithPath: #filePath).deletingLastPathComponent()
            .deletingLastPathComponent().deletingLastPathComponent()
    }
    private func world(_ fixture: String = "agreement-cases.swift", edit: ((String) -> String)? = nil) throws -> StructuralSource {
        let primitive = "Sources/VerificationIsIdentification/Primitive.swift"
        let path = directory + fixture
        let text = try String(contentsOf: root.appendingPathComponent(path), encoding: .utf8)
        return try StructuralSource(files: [
            (primitive, String(contentsOf: root.appendingPathComponent(primitive), encoding: .utf8)),
            (path, edit?(text) ?? text)
        ])
    }
    private func proof(_ name: String) throws -> C.AgreementCertificate {
        try C.deriveAgreement(name, source: world())
    }
    private func plan(_ p: C.AgreementCertificate) throws -> C.AgreementPlan {
        guard case let .constructed(plan) = p.conclusion else { throw C.Failure("expected a constructed plan") }
        return plan
    }
    private func kind(_ p: C.AgreementCertificate) -> String {
        switch p.conclusion {
        case .constructed: return "constructed"
        case .unavailable: return "unavailable"
        case .wrongSort: return "wrongSort"
        case .incompatible: return "incompatible"
        }
    }
    private func refuses(_ label: String, at: String, _ body: () throws -> Void,
                         file: StaticString = #filePath, line: UInt = #line) {
        do { try body(); XCTFail("admitted " + label, file: file, line: line) }
        catch {
            let message = String(describing: error)
            XCTAssertTrue(message.contains(at), message, file: file, line: line)
            print("T0102 \(label): refused: \(message)")
        }
    }
    private func tamper(_ request: String, _ label: String, at: String,
                        _ edit: (inout C.AgreementCertificate) throws -> Void,
                        file: StaticString = #filePath, line: UInt = #line) throws {
        var p = try proof(request); try edit(&p)
        refuses(label, at: at, {
            let saved = try C.decodeAgreement(C.encodeAgreement(p))
            _ = try C.verifyAgreement(request, certificate: saved, source: world())
        }, file: file, line: line)
    }
    private func changePlan(_ p: inout C.AgreementCertificate, _ edit: (inout C.AgreementPlan) -> Void) throws {
        var result = try plan(p); edit(&result); p.conclusion = .constructed(result)
    }
    // Build an alternative valid U5 decoder before the global/binding refusal.
    private func replan(_ p: inout C.AgreementCertificate, assignments: [C.Path], leaves: [C.Path]) throws {
        let source = try world()
        let r = try C.agreementReading(p.request, certificate: p, source: source)
        let blocks = try C.verifyPartition(p.classes, whole: r.whole)
        let outputs = try C.verifyPartition(p.outputClasses, whole: r.output)
        let places = try C.agreementPlaces(r, assignments: assignments, outputBlocks: outputs, at: "test.plan")
        let reading = C.RelatedReading(whole: r.whole, observation: places, question: r.question)
        let m = C.retainedPlaces(leaves)
        let joint = C.RelatedReading(whole: r.whole, observation: m.map { .pair(places, $0) } ?? places, question: r.question)
        guard case let .constructed(selections, decoder) = try C.constructRelated(joint) else {
            return XCTFail("alternative plan did not retain Question")
        }
        try C.verifyRelatedProgram(selections, program: decoder, reading: joint, address: "test.valid-U5")
        var result = try plan(p)
        result.assignments = assignments
        result.step = try C.assembledProgram(places, inputs: places.leaves.map(\.source))
        result.needed = try C.requiredClasses(reading, blocks: blocks)
        result.residualLeaves = leaves
        result.residual = try m.map { try C.assembledProgram($0, inputs: leaves) }
        result.selections = selections; result.decoder = decoder
        p.conclusion = .constructed(result)
    }
    func testNamedAgreementContractAndSerializedReplay() throws {
        let data = try Data(contentsOf: root.appendingPathComponent(directory + "contract.json"))
        let doc = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])
        let section = try XCTUnwrap(doc["agreement"] as? [String: Any])
        XCTAssertEqual(section["sha256"] as? String,
                       courtSHA256(try Data(contentsOf: root.appendingPathComponent(directory + "agreement-cases.swift"))))
        let cases = try XCTUnwrap(section["cases"] as? [[String: Any]])
        XCTAssertEqual(cases.count, 37)
        let source = try world()
        for entry in cases {
            let name = try XCTUnwrap(entry["request"] as? String)
            if let at = entry["address"] as? String {
                refuses(name, at: at) { _ = try C.deriveAgreement(name, source: source) }
                continue
            }
            let p = try C.deriveAgreement(name, source: source)
            let raw = try C.encodeAgreement(p), saved = try C.decodeAgreement(raw)
            let holds = try C.verifyAgreement(name, certificate: saved, source: source)
            if let refusal = entry["refusal"] as? String {
                XCTAssertFalse(holds); XCTAssertEqual(kind(saved), refusal)
            } else {
                XCTAssertTrue(holds)
                XCTAssertEqual(try plan(saved).residualLeaves.count, entry["residualLeaves"] as? Int)
            }
            XCTAssertEqual(try C.encodeAgreement(saved), raw)
            print("T0102 \(name): \(kind(saved)); serialized replay agrees")
        }
    }
    func testThreeFieldsAndThePrescribedOrigin() throws {
        let three = try plan(proof("AgreeThree"))
        XCTAssertEqual(three.step, .pair(.pick([.left]), .pick([.left])))
        XCTAssertEqual(three.residualLeaves, [[.right, .left], [.right, .right]])
        XCTAssertEqual(three.residual, .pair(.pick([.right, .left]), .pick([.right, .right])))
        XCTAssertEqual(three.capacities[0].minimum, 2)
        let bound = try plan(proof("BindOriginal"))
        XCTAssertEqual(bound.step, .pair(.pick([.left]), .pick([.left])))
        XCTAssertEqual(bound.residualLeaves, [[.right]])
        try tamper("BindOriginal", "preserves-whole-but-wrong-origin", at: ".bindingBases[0]") {
            try replan(&$0, assignments: [[.right]], leaves: [[.left]])
        }
        try tamper("EmptySourceRelations", "locally-minimal-but-not-U10-minimal", at: ".residualLeaves:") {
            try replan(&$0, assignments: [[.left], [.left]], leaves: [[.right, .left], [.right, .right]])
        }
    }
    func testCapacityCountsAndZeroResidual() throws {
        let duplicate = try plan(proof("DuplicateFixed")).capacities[0]
        XCTAssertEqual([duplicate.required, duplicate.output, duplicate.fixedRequired, duplicate.free, duplicate.minimum], [3,2,1,0,2])
        let outside = try plan(proof("BoundOutsideQuestion")).capacities[0]
        XCTAssertEqual([outside.required, outside.fixedRequired, outside.free, outside.minimum], [1,0,0,1])
        let earlier = try plan(proof("FreeBeforeFixed"))
        XCTAssertEqual(earlier.assignments, [[.right, .left], [.left]])
        XCTAssertEqual(earlier.capacities[0].minimum, 1)
        let zero = try plan(proof("ZeroResidual"))
        XCTAssertTrue(zero.residualLeaves.isEmpty); XCTAssertNil(zero.residual)
        XCTAssertEqual(try plan(proof("FixedAndFreeCover")).residualLeaves.count, 0)
        let two = try plan(proof("TwoSortCapacity")).capacities
        XCTAssertEqual(two.map(\.minimum), [1,0])
        XCTAssertEqual(try plan(proof("QuestionSortNotInOutput")).residualLeaves, [[.right]])
        XCTAssertEqual(try plan(proof("RepeatedQuestion")).capacities[0].required, 1)
    }
    func testBindingsUseSourceClassesAndNotLiteralAddressIdentity() throws {
        let p = try proof("EquivalentBindings")
        let result = try plan(p)
        guard case .sourceRelation = result.bindingBases[1] else { return XCTFail("expected an E-path for the prescribed other address") }
        XCTAssertTrue(try C.verifyAgreement(p.request, certificate: p, source: world()))
        let chain = try plan(proof("ChainedBindings"))
        guard case let .sourceRelation(path) = chain.bindingBases[1] else { return XCTFail("expected the two-edge path") }
        XCTAssertEqual(path.count, 2)
        XCTAssertEqual(try plan(proof("BoundRepeatSameLeaf")).bindingBases.count, 2)
        XCTAssertEqual(try plan(proof("BoundDistinctSlots")).capacities[0].fixedRequired, 2)
    }
    func testPartitionAndStepForgeries() throws {
        try tamper("EqualSource", "split-source-E-class", at: ".sourceClasses.E:") {
            let sort = $0.classes[0].sort
            $0.classes = [.init(sort: sort, leaves: [[.left]]), .init(sort: sort, leaves: [[.right]])]
            $0.connections = [[],[]]
        }
        try tamper("EqualSource", "missing-source-forest", at: ".sourceConnections[0]") { $0.connections[0] = [] }
        try tamper("AgreeThree", "split-output-C-class", at: ".outputClasses.E:") {
            let sort = $0.outputClasses[0].sort
            $0.outputClasses = [.init(sort: sort, leaves: [[.left]]), .init(sort: sort, leaves: [[.right]])]
            $0.outputConnections = [[],[]]
        }
        try tamper("ZeroResidual", "merge-independent-C-classes", at: ".outputConnections[0][0]") {
            let sort = $0.outputClasses[0].sort
            $0.outputClasses = [.init(sort: sort, leaves: [[.left], [.right]])]
            $0.outputConnections = [[.init(edge: [], reversed: false)]]
        }
        try tamper("AgreeThree", "missing-C-forest", at: ".outputConnections[0]") { $0.outputConnections[0] = [] }
        try tamper("AgreeThree", "C-forest-uses-undeclared-edge", at: ".outputConnections[0][0]") {
            $0.outputConnections[0][0].edge = [.left]
        }
        try tamper("AgreeThree", "nonleaf-output-partition", at: ".outputClasses[0]") {
            $0.outputClasses[0].leaves[0] = []
        }
        try tamper("AgreeThree", "missing-class-assignment", at: ".assignments:") {
            try changePlan(&$0) { $0.assignments = [] }
        }
        try tamper("AgreeThree", "nonleaf-source-assignment", at: ".assignments[0]") {
            try changePlan(&$0) { $0.assignments[0] = [] }
        }
        try tamper("TwoSortCapacity", "assignment-of-another-sort", at: ".assignments[0]") {
            try changePlan(&$0) { $0.assignments[0] = [.right, .right] }
        }
        try tamper("AgreeThree", "one-C-class-assigned-two-E-classes", at: ".step:") {
            try changePlan(&$0) { $0.step = .pair(.pick([.left]), .pick([.right, .left])) }
        }
    }
    func testResidualAndCapacityForgeries() throws {
        try tamper("AgreeThree", "residual-below-bound", at: ".residualLeaves:") {
            try changePlan(&$0) { $0.residualLeaves.removeLast() }
        }
        try tamper("AgreeThree", "duplicate-residual-class", at: ".residualLeaves[1]") {
            try changePlan(&$0) { $0.residualLeaves[1] = $0.residualLeaves[0] }
        }
        try tamper("AgreeThree", "retain-already-covered-class", at: ".residualLeaves[0]") {
            try changePlan(&$0) { $0.residualLeaves[0] = [.left] }
        }
        try tamper("AgreeThree", "invented-lower-bound", at: ".capacities:") {
            try changePlan(&$0) { $0.capacities[0].minimum = 0 }
        }
        try tamper("DuplicateFixed", "fixed-classes-counted-with-multiplicity", at: ".capacities:") {
            try changePlan(&$0) { $0.capacities[0].fixedRequired = 2; $0.capacities[0].minimum = 1 }
        }
        try tamper("BoundOutsideQuestion", "outside-Q-counted-as-required", at: ".capacities:") {
            try changePlan(&$0) { $0.capacities[0].fixedRequired = 1; $0.capacities[0].minimum = 0 }
        }
        try tamper("AgreeThree", "arithmetic-overflow-claim", at: ".capacities:") {
            try changePlan(&$0) { $0.capacities[0].required = Int.max }
        }
        try tamper("AgreeThree", "missing-question-address", at: ".needed:") {
            try changePlan(&$0) { $0.needed[0].questions = [] }
        }
        try tamper("AgreeThree", "wrong-residual-term", at: ".residual:") {
            try changePlan(&$0) { $0.residual = .pick([.left]) }
        }
        try tamper("ZeroResidual", "zero-residual-invents-a-unit", at: ".residual:") {
            try changePlan(&$0) { $0.residual = .pick([]) }
        }
    }
    func testDecoderAndBindingForgeries() throws {
        try tamper("BindOriginal", "decoder-selects-same-sort-other-unknown", at: ".decoder.selections[0].basis") {
            try changePlan(&$0) {
                $0.selections[0].input = [.right]
                $0.decoder = .pair(.pick([.right]), .pick([.right]))
            }
        }
        try tamper("BindOriginal", "substituted-decoder-term", at: ".decoder.program:") {
            try changePlan(&$0) { $0.decoder = .pick([]) }
        }
        try tamper("EquivalentBindings", "binding-path-replaced-by-address", at: ".bindingBases[1]") {
            try changePlan(&$0) { $0.bindingBases[1] = .address }
        }
        try tamper("EquivalentBindings", "binding-uses-non-E-path", at: ".bindingBases[1]") {
            try changePlan(&$0) { $0.bindingBases[1] = .sourceRelation([.init(edge: [.left], reversed: false)]) }
        }
        try tamper("EquivalentBindings", "binding-uses-value-coincidence", at: ".bindingBases[1]") {
            try changePlan(&$0) { $0.bindingBases[1] = .observedValues }
        }
        try tamper("BindOriginal", "missing-binding-basis", at: ".bindingBases:") {
            try changePlan(&$0) { $0.bindingBases = [] }
        }
        try tamper("BindOriginal", "omitted-bound-output-axis", at: "BindOriginal.BoundOutputs") { $0.boundOutputs = nil }
        try tamper("BindOriginal", "source-is-not-output-binding", at: "BindOriginal.BoundOutputs") { $0.boundOutputs = .source }
        try tamper("BindOriginal", "output-is-not-source-binding", at: "BindOriginal.BoundSources") { $0.boundSources = .output }
        try tamper("AgreeThree", "promise-uses-source-anchor", at: "AgreeThree.Promise") { $0.promise = .source }
        try tamper("AgreeThree", "output-proof-belongs-to-source", at: "AgreeThree.Output") { $0.output = $0.source }
    }
    func testObstructionWitnessForgeries() throws {
        try tamper("AgreeThree", "unavailable-sort-is-available", at: ".unavailable:") { $0.conclusion = .unavailable(output: [.left]) }
        try tamper("AgreeThree", "unavailable-witness-is-not-a-leaf", at: ".unavailable.output:") { $0.conclusion = .unavailable(output: []) }
        try tamper("BindOriginal", "wrong-sort-witness-has-equal-sorts", at: ".wrongSort:") { $0.conclusion = .wrongSort(binding: []) }
        try tamper("BindOriginal", "foreign-binding-witness", at: ".wrongSort.binding:") { $0.conclusion = .wrongSort(binding: [.left]) }
        try tamper("EquivalentBindings", "equivalent-bindings-claimed-incompatible", at: ".incompatible:") {
            $0.conclusion = .incompatible(left: [.left], right: [.right])
        }
        try tamper("BoundDistinctSlots", "different-C-classes-claimed-incompatible", at: ".incompatible:") {
            $0.conclusion = .incompatible(left: [.left], right: [.right])
        }
        try tamper("IncompatibleBindings", "foreign-incompatible-binding", at: ".incompatible:") {
            $0.conclusion = .incompatible(left: [.left], right: [.right, .right])
        }
    }
    func testLiveInputCoverageAndArchiveModes() throws {
        let p = try proof("BindOriginal")
        for (label, old, new, address) in [
            ("changed-output", "typealias Output = Paired<S, S>", "typealias Output = S", "BindOriginal.Output"),
            ("changed-prescription", "typealias BoundSources = Source.Left", "typealias BoundSources = Source.Right", "BindOriginal.BoundSources"),
            ("changed-question", "typealias Question = Source\n", "typealias Question = Source.Left\n", "BindOriginal.Question"),
            ("changed-promise", "Paired<Output.Left, Output.Right>", "Paired<Output.Left, Output.Left>", "BindOriginal.Promise")
        ] {
            let changed = try world(edit: { $0.replacingOccurrences(of: old, with: new) })
            refuses(label, at: address) { _ = try C.verifyAgreement(p.request, certificate: p, source: changed) }
        }
        var archive = try XCTUnwrap(JSONSerialization.jsonObject(with: C.encodeAgreement(p)) as? [String: Any])
        archive["format"] = 6
        refuses("agreement-masquerades-as-image", at: "expected format 7") {
            _ = try C.decodeAgreement(JSONSerialization.data(withJSONObject: archive))
        }
        XCTAssertThrowsError(try C.decodeRelated(C.encodeAgreement(p)))
        XCTAssertThrowsError(try C.decodeImage(C.encodeAgreement(p)))
        let image = try C.deriveImage("PermutedPromise", source: world("image-cases.swift"))
        XCTAssertThrowsError(try C.decodeAgreement(C.encodeImage(image)))
    }
    func testReviewedFormat6KeepsCanonicalBytes() throws {
        let data = try Data(contentsOf: root.appendingPathComponent(directory + "compatibility.json"))
        let manifest = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])
        let section = try XCTUnwrap(manifest["imageArchives"] as? [String: Any])
        let cases = try XCTUnwrap(section["cases"] as? [[String: Any]])
        XCTAssertEqual(cases.count, 22)
        let source = try world("image-cases.swift")
        for entry in cases {
            let request = try XCTUnwrap(entry["request"] as? String)
            let p = try C.deriveImage(request, source: source)
            let raw = try C.encodeImage(p)
            XCTAssertEqual(courtSHA256(raw), entry["sha256"] as? String, request)
            XCTAssertEqual(try C.verifyImage(request, certificate: C.decodeImage(raw), source: source), entry["holds"] as? Bool)
            print("T0102 compatibility \(request): reviewed canonical format-6 archive unchanged")
        }
    }
}
