import Foundation
import XCTest
@testable import Court

final class ContinuationActionsTests: XCTestCase {
    typealias C = ContinuationCourt
    private let fixture = "Contracts/Court/continuation-relations-v1/action-cases.swift"
    private var root: URL {
        URL(fileURLWithPath: #filePath).deletingLastPathComponent()
            .deletingLastPathComponent().deletingLastPathComponent()
    }
    private func world(_ edit: ((String) -> String)? = nil) throws -> StructuralSource {
        let primitive = "Sources/Notation/Primitive.swift"
        let text = try String(contentsOf: root.appendingPathComponent(fixture), encoding: .utf8)
        return try StructuralSource(files: [
            (primitive, String(contentsOf: root.appendingPathComponent(primitive), encoding: .utf8)),
            (fixture, edit?(text) ?? text)
        ])
    }
    private func proof(_ request: String) throws -> C.RelatedCertificate {
        try C.deriveRelated(request, source: world(), actions: true)
    }
    private func refuses(_ id: String, address: String, _ body: () throws -> Void,
                         file: StaticString = #filePath, line: UInt = #line) {
        do {
            try body()
            XCTFail("admitted " + id, file: file, line: line)
        } catch {
            let message = String(describing: error)
            XCTAssertTrue(message.contains(address), message, file: file, line: line)
            print("T0096 \(id): refused: \(message)")
        }
    }
    private func tamper(_ request: String, _ id: String, address: String,
                        _ edit: (inout C.RelatedCertificate) -> Void,
                        file: StaticString = #filePath, line: UInt = #line) throws {
        var p = try proof(request)
        edit(&p)
        refuses(id, address: address, {
            let saved = try C.decodeRelated(C.encodeRelated(p))
            _ = try C.verifyRelatedActions(request, certificate: saved, source: world())
        }, file: file, line: line)
    }
    func testNamedContractAndSerializedReplay() throws {
        let data = try Data(contentsOf: root.appendingPathComponent("Contracts/Court/continuation-relations-v1/contract.json"))
        let document = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])
        let actions = try XCTUnwrap(document["actions"] as? [String: Any])
        XCTAssertEqual(actions["fixture"] as? String, "action-cases.swift")
        XCTAssertEqual(actions["sha256"] as? String, courtSHA256(try Data(contentsOf: root.appendingPathComponent(fixture))))
        let cases = try XCTUnwrap(actions["cases"] as? [[String: Any]])
        XCTAssertEqual(cases.count, 17)
        let source = try world()
        for entry in cases {
            let request = try XCTUnwrap(entry["request"] as? String)
            if let address = entry["address"] as? String {
                refuses(request, address: address) {
                    _ = try C.deriveRelated(request, source: source, actions: true)
                }
            } else {
                let p = try C.deriveRelated(request, source: source, actions: true)
                let bytes = try C.encodeRelated(p)
                let saved = try C.decodeRelated(bytes)
                let holds = try C.verifyRelatedActions(request, certificate: saved, source: source)
                XCTAssertEqual(holds, entry["holds"] as? Bool, request)
                var refusal: String?
                if saved.dynamics?.stable == nil {
                    refusal = "preservation"
                } else if let evidence = saved.dynamics?.hiddenActions, !C.evidenceHolds(evidence) {
                    refusal = "preservation"
                } else if let hidden = saved.dynamics?.hidden {
                    switch hidden.conclusion {
                    case .outside: refusal = "outside"
                    case .disagreement: refusal = "disagreement"
                    case .common: break
                    }
                }
                XCTAssertEqual(refusal, entry["refusal"] as? String, request)
                XCTAssertEqual(refusal == nil, holds, request)
                XCTAssertEqual(try C.encodeRelated(saved), bytes)
                let archive = try XCTUnwrap(JSONSerialization.jsonObject(with: bytes) as? [String: Any])
                XCTAssertEqual(archive["format"] as? Int, 4)
                print("T0096 \(request): \(holds ? "constructed" : "certified refusal"); serialized replay agrees")
            }
        }
    }
    func testClosureWordsCycleAndEmptyFamily() throws {
        let p = try proof("CyclicQuestion")
        let stable = try XCTUnwrap(p.dynamics?.stable)
        XCTAssertEqual(stable.representatives, [[.left], [.right, .right], [.right, .left]])
        XCTAssertEqual(stable.classes.map(\.word.count), [0, 1, 2])
        XCTAssertEqual(stable.actions[0].targets, [1, 2, 0])
        let reading = try C.relatedReading(p.request, certificate: p, source: world())
        // Fixed first-coordinate question after g reads c; the transported
        // second-coordinate question after this g reads the original a.
        XCTAssertEqual(try reading.actions[0].imageOf([.left]), [.right, .right])
        XCTAssertEqual(try reading.actions[0].imageOf([.right, .left]), [.left])
        let empty = try proof("EmptyActions")
        XCTAssertNil(empty.actions)
        XCTAssertNil(empty.hiddenActions)
        XCTAssertEqual(empty.dynamics?.actions.count, 0)
        XCTAssertEqual(empty.dynamics?.stable?.representatives, [[.right, .right]])
        XCTAssertEqual(empty.dynamics?.stable?.classes[0].word, [])
        XCTAssertNil(empty.dynamics?.hidden)
        XCTAssertFalse(try C.verifyRelated(empty.request, certificate: empty, source: world()))
        XCTAssertTrue(try C.verifyRelatedActions(empty.request, certificate: empty, source: world()))
    }
    func testWordDirectionForNoncommutingActions() throws {
        let stable = try XCTUnwrap(proof("NoncommutingWords").dynamics?.stable)
        XCTAssertEqual(stable.representatives, [[.left], [.right, .left], [.right, .right]])
        XCTAssertEqual(stable.classes[2].word, [[.left], [.right]])
        try tamper("NoncommutingWords", "reversed-composition-order", address: ".word:") {
            $0.dynamics!.stable!.classes[2].word.reverse()
        }
    }
    func testHiddenOutcomesAndConditionalClosure() throws {
        let a = try proof("HiddenOutside")
        guard case let .outside(member, observation, image)? = a.dynamics?.hidden?.conclusion else {
            return XCTFail("outside certificate")
        }
        XCTAssertEqual(member, [])
        XCTAssertEqual(observation, [])
        XCTAssertEqual(image, [.right])
        let b = try proof("HiddenDisagreement")
        guard case .disagreement? = b.dynamics?.hidden?.conclusion else { return XCTFail("disagreement certificate") }
        XCTAssertEqual(b.dynamics?.hidden?.closureInheritedFromStableView, true)
        let common = try proof("HiddenCommon")
        guard case let .common(actions, k)? = common.dynamics?.hidden?.conclusion else { return XCTFail("common k") }
        XCTAssertEqual(k, .pick([]))
        XCTAssertEqual(actions.count, 2)
        XCTAssertEqual(common.dynamics?.hidden?.closureInheritedFromStableView, false)
        // H need not be a subfamily of G; nor does absent G prohibit U8.
        XCTAssertTrue(try C.verifyRelatedActions("HiddenOnly", certificate: proof("HiddenOnly"), source: world()))
    }
    func testCommonProgramOnEquivalentRepeatedObservationPlaces() throws {
        let p = try proof("HiddenEquivalentProjections")
        guard case let .common(actions, k)? = p.dynamics?.hidden?.conclusion else { return XCTFail("common k") }
        XCTAssertEqual(k, .pair(.pick([.left]), .pick([.right])))
        XCTAssertEqual(actions.map(\.program), [k, k])
        guard case .sourceRelation = actions[1].selections[0].basis else { return XCTFail("E-path for fixed k") }
        XCTAssertTrue(try C.verifyRelatedActions(p.request, certificate: p, source: world()))
    }
    func testFamilyBoundariesAliasesAndLiveCoverage() throws {
        let scalar = try proof("ScalarActions")
        XCTAssertEqual(scalar.dynamics?.actions.map(\.member), [[.left], [.right, .left], [.right, .right]])
        let aliased = try proof("AliasedActions")
        XCTAssertEqual(aliased.dynamics?.actions.map(\.member), [[.left], [.right]])
        XCTAssertEqual(aliased.dynamics?.hiddenActions?.map(\.member), [[]])
        try tamper("AliasedActions", "omitted-actions-reading", address: "AliasedActions.Actions") { $0.actions = nil }
        try tamper("AliasedActions", "omitted-hidden-reading", address: "AliasedActions.HiddenActions") { $0.hiddenActions = nil }
        try tamper("AliasedActions", "member-address-substitution", address: ".member:") { $0.dynamics!.actions[0].member = [.right] }
        try tamper("AliasedActions", "omitted-family-member", address: ".actions:") { $0.dynamics!.actions.removeLast() }
        let source = try world {
            $0.replacingOccurrences(of: "typealias Actions = Paired<Source, Exchanged<Source>>",
                                    with: "typealias Actions = Paired<Exchanged<Source>, Source>")
        }
        refuses("changed-live-actions", address: "AliasedActions.Actions") {
            _ = try C.verifyRelatedActions(aliased.request, certificate: aliased, source: source)
        }
    }
    func testPreservationAndExactClassForgeries() throws {
        try tamper("PreservesEqualities", "forged-image-e-path", address: ".preservation[0]") {
            $0.dynamics!.actions[0].preservation = .preserved([.sourceRelation([.init(edge: [.left], reversed: false)])])
        }
        try tamper("PreservesEqualities", "value-coincidence-is-not-preservation", address: ".preservation[0]") {
            $0.dynamics!.actions[0].preservation = .preserved([.observedValues])
        }
        try tamper("PreservesEqualities", "false-preservation-refusal", address: ".preservation.edge:") {
            $0.dynamics!.actions[0].preservation = .notPreserved(edge: [])
        }
        try tamper("BreaksEqualities", "false-preservation-claim", address: ".preservation[0]") {
            $0.dynamics!.actions[0].preservation = .preserved([.address])
        }
        try tamper("PreservesEqualities", "broken-exact-class-forest", address: ".connections[0]:") {
            $0.dynamics!.connections[0] = []
        }
        try tamper("CyclicQuestion", "duplicate-partition-place", address: ".classes[1]") {
            $0.dynamics!.classes[1].leaves = [[.left]]
        }
        try tamper("HiddenInvalidEqualities", "omitted-hidden-evidence", address: ".hiddenActions:") {
            $0.dynamics!.hiddenActions = nil
        }
        // Regression for replay's former per-path charge of the entire E index.
        // This only constructs a written record, not fillings of its sorts.
        var origins: [String] = []
        func sourceTree(_ count: Int, at path: String) -> String {
            if count == 1 {
                origins.append(path)
                return "S"
            }
            let left = count / 2
            return "Paired<\(sourceTree(left, at: path + ".Left")), \(sourceTree(count - left, at: path + ".Right"))>"
        }
        func product(_ leaves: ArraySlice<String>) -> String {
            if leaves.count == 1 { return leaves.first! }
            let half = leaves.count / 2
            return "Paired<\(product(leaves.prefix(half))), \(product(leaves.dropFirst(half)))>"
        }
        let shape = sourceTree(321, at: "Source")
        let text = """
        enum LongChain<S: Structure> {
            typealias Source = \(shape)
            typealias Observation = \(origins[0])
            typealias Question = \(origins[0])
            typealias Equalities = Paired<\(product(origins.dropLast())), \(product(origins.dropFirst()))>
            typealias Actions = Paired<Source, Source>
            typealias HiddenActions = Actions
        }
        """
        let primitive = "Sources/Notation/Primitive.swift"
        let source = try StructuralSource(files: [
            (primitive, String(contentsOf: root.appendingPathComponent(primitive), encoding: .utf8)),
            ("long-chain.swift", text)
        ])
        let p = try C.deriveRelated("LongChain", source: source, actions: true)
        let saved = try C.decodeRelated(C.encodeRelated(p))
        XCTAssertTrue(try C.verifyRelatedActions("LongChain", certificate: saved, source: source))
        XCTAssertEqual(saved.dynamics?.actions.count, 2)
        XCTAssertEqual(saved.dynamics?.hiddenActions?.count, 2)
        for member in try XCTUnwrap(saved.dynamics?.actions) {
            guard case let .preserved(paths) = member.preservation else { return XCTFail("preserved chain") }
            XCTAssertEqual(paths.count, 320)
            for path in paths {
                guard case let .sourceRelation(steps) = path else { return XCTFail("one-edge path") }
                XCTAssertEqual(steps.count, 1)
            }
        }
        print("T0096 large-chain: 320 E-edges, two identity actions and hidden members; serialized replay holds")
        var forged = saved
        guard case var .preserved(paths) = forged.dynamics!.actions[0].preservation else { return XCTFail("preserved chain") }
        paths[319] = .address
        forged.dynamics!.actions[0].preservation = .preserved(paths)
        refuses("large-chain-forged-path", address: ".preservation[319]") {
            _ = try C.verifyRelatedActions("LongChain", certificate: forged, source: source)
        }
    }
    func testStableViewAndWordForgeries() throws {
        try tamper("CyclicQuestion", "forged-word-witness", address: ".word:") {
            $0.dynamics!.stable!.classes[2].word.removeLast()
        }
        try tamper("CyclicQuestion", "foreign-word-member", address: ".word[0]") {
            $0.dynamics!.stable!.classes[1].word = [[.left]]
        }
        try tamper("CyclicQuestion", "forged-closure-edge", address: ".targets[0]") {
            $0.dynamics!.stable!.actions[0].targets[0] = 0
        }
        try tamper("CyclicQuestion", "negative-closure-index", address: ".targets[0]") {
            $0.dynamics!.stable!.actions[0].targets[0] = -1
        }
        try tamper("CyclicQuestion", "wrong-view-representative", address: ".representatives[0]") {
            $0.dynamics!.stable!.representatives[0] = [.right, .right]
        }
        try tamper("CyclicQuestion", "nonleaf-view-representative", address: ".representatives[0]") {
            $0.dynamics!.stable!.representatives[0] = []
        }
        try tamper("CyclicQuestion", "forged-view-term", address: ".stable.view:") {
            $0.dynamics!.stable!.view = .pick([])
        }
        try tamper("CyclicQuestion", "forged-image-action", address: ".program:") {
            $0.dynamics!.stable!.actions[0].program = .pick([])
        }
        try tamper("CyclicQuestion", "forged-question-decoder", address: ".decoder.program:") {
            $0.dynamics!.stable!.decoder = .pick([.right])
        }
        try tamper("CyclicQuestion", "omitted-stable-view", address: ".stable:") { $0.dynamics!.stable = nil }
    }
    func testHiddenCertificateAndCommonActionForgeries() throws {
        try tamper("HiddenCommon", "forged-common-k", address: ".program:") {
            guard case let .common(actions, _) = $0.dynamics!.hidden!.conclusion else { return }
            $0.dynamics!.hidden!.conclusion = .common(actions: actions, program: .pair(.pick([]), .pick([])))
        }
        try tamper("HiddenEquivalentProjections", "forged-common-e-path", address: ".basis") {
            guard case var .common(actions, k) = $0.dynamics!.hidden!.conclusion else { return }
            actions[1].selections[0].basis = .address
            $0.dynamics!.hidden!.conclusion = .common(actions: actions, program: k)
        }
        try tamper("HiddenOutside", "forged-outside-certificate", address: ".outside:") {
            $0.dynamics!.hidden!.conclusion = .outside(member: [], observation: [], image: [.left])
        }
        try tamper("HiddenDisagreement", "forged-disagreement-certificate", address: ".disagreement:") {
            $0.dynamics!.hidden!.conclusion = .disagreement(left: [.left], right: [.left], observation: [.left],
                                                         leftImage: [.left], rightImage: [.left])
        }
        try tamper("HiddenDisagreement", "nonleaf-hidden-witness", address: ".observation:") {
            $0.dynamics!.hidden!.conclusion = .disagreement(left: [.left], right: [.right], observation: [],
                                                         leftImage: [.left], rightImage: [.right])
        }
        try tamper("HiddenDisagreement", "false-inherited-closure", address: ".closureInheritedFromStableView:") {
            $0.dynamics!.hidden!.closureInheritedFromStableView = false
        }
    }
    func testArchiveModeCannotMasquerade() throws {
        let p = try proof("CyclicQuestion")
        var archive = try XCTUnwrap(JSONSerialization.jsonObject(with: C.encodeRelated(p)) as? [String: Any])
        archive["format"] = 2
        refuses("format-4-proof-as-format-2", address: "certificate: expected format 2") {
            _ = try C.decodeRelated(JSONSerialization.data(withJSONObject: archive))
        }
        let old = try C.deriveRelated("EmptyActions", source: world())
        refuses("old-archive-is-not-u7", address: "certificate.dynamics:") {
            _ = try C.verifyRelatedActions(old.request, certificate: old, source: world())
        }
    }
    func testAcceptedFormats2And3KeepCanonicalBytes() throws {
        let directory = "Contracts/Court/continuation-relations-v1/"
        let data = try Data(contentsOf: root.appendingPathComponent(directory + "compatibility.json"))
        let manifest = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])
        let cases = try XCTUnwrap(manifest["cases"] as? [[String: Any]])
        XCTAssertEqual(cases.count, 21)
        let primitive = "Sources/Notation/Primitive.swift"
        for entry in cases {
            let request = try XCTUnwrap(entry["request"] as? String)
            let fixture = directory + (try XCTUnwrap(entry["fixture"] as? String))
            let source = try StructuralSource(files: [
                (primitive, String(contentsOf: root.appendingPathComponent(primitive), encoding: .utf8)),
                (fixture, String(contentsOf: root.appendingPathComponent(fixture), encoding: .utf8))
            ])
            let p = try C.deriveRelated(request, source: source, retain: entry["retain"] as? Bool == true)
            let encoded = try C.encodeRelated(p)
            XCTAssertEqual(courtSHA256(encoded), entry["sha256"] as? String, request)
            let saved = try C.decodeRelated(encoded)
            _ = try C.verifyRelated(request, certificate: saved, source: source)
            print("T0096 compatibility \(request): canonical archive unchanged")
        }
    }
}
