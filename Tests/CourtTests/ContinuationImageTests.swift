import Foundation
import XCTest
@testable import Court

final class ContinuationImageTests: XCTestCase {
    typealias C = ContinuationCourt
    private let directory = "Contracts/Court/continuation-relations-v1/"
    private var root: URL {
        URL(fileURLWithPath: #filePath).deletingLastPathComponent()
            .deletingLastPathComponent().deletingLastPathComponent()
    }
    private func world(_ fixture: String = "image-cases.swift", edit: ((String) -> String)? = nil) throws -> StructuralSource {
        let primitive = "Sources/VerificationIsIdentification/Primitive.swift"
        let path = directory + fixture
        let text = try String(contentsOf: root.appendingPathComponent(path), encoding: .utf8)
        return try StructuralSource(files: [
            (primitive, String(contentsOf: root.appendingPathComponent(primitive), encoding: .utf8)),
            (path, edit?(text) ?? text)
        ])
    }
    private func proof(_ request: String) throws -> C.ImageCertificate {
        try C.deriveImage(request, source: world())
    }
    private func refuses(_ label: String, at: String, _ body: () throws -> Void,
                         file: StaticString = #filePath, line: UInt = #line) {
        do { try body(); XCTFail("admitted " + label, file: file, line: line) }
        catch {
            let message = String(describing: error)
            XCTAssertTrue(message.contains(at), message, file: file, line: line)
            print("T0100 \(label): refused: \(message)")
        }
    }
    private func tamper(_ request: String, _ label: String, at: String,
                        _ edit: (inout C.ImageCertificate) -> Void,
                        file: StaticString = #filePath, line: UInt = #line) throws {
        var p = try proof(request)
        edit(&p)
        refuses(label, at: at, {
            let saved = try C.decodeImage(C.encodeImage(p))
            _ = try C.verifyImage(request, certificate: saved, source: world())
        }, file: file, line: line)
    }
    func testNamedImageContractAndSerializedReplay() throws {
        let data = try Data(contentsOf: root.appendingPathComponent(directory + "contract.json"))
        let doc = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])
        let section = try XCTUnwrap(doc["image"] as? [String: Any])
        XCTAssertEqual(section["sha256"] as? String,
                       courtSHA256(try Data(contentsOf: root.appendingPathComponent(directory + "image-cases.swift"))))
        let cases = try XCTUnwrap(section["cases"] as? [[String: Any]])
        XCTAssertEqual(cases.count, 29)
        let source = try world()
        for entry in cases {
            let request = try XCTUnwrap(entry["request"] as? String)
            if let at = entry["address"] as? String {
                refuses(request, at: at) { _ = try C.deriveImage(request, source: source) }
                continue
            }
            let p = try C.deriveImage(request, source: source)
            let bytes = try C.encodeImage(p), saved = try C.decodeImage(bytes)
            XCTAssertEqual(try C.verifyImage(request, certificate: saved, source: source), entry["holds"] as? Bool)
            XCTAssertEqual(try C.encodeImage(saved), bytes)
            let archive = try XCTUnwrap(JSONSerialization.jsonObject(with: bytes) as? [String: Any])
            XCTAssertEqual(archive["format"] as? Int, 6)
            print("T0100 \(request): \(entry["holds"] ?? "unknown"); serialized replay agrees")
        }
    }
    func testDerivedImageReplacesTheUnchangedSourceLaw() throws {
        let p = try proof("PermutedPromise")
        XCTAssertEqual(p.images[0].sourceClassIndices, [0, 1])
        XCTAssertEqual(p.images[0].classes[0].leaves, [[.left], [.right, .right]])
        XCTAssertEqual(p.images[0].classes[1].leaves, [[.right, .left]])
        let r = try C.imageReading(p.request, certificate: p, source: world())
        let blocks = try C.verifyPartition(p.classes, whole: r.whole)
        var budget = C.ActionBudget()
        let unchanged = try C.constructEvidence(r.members, reading: r.relation, blocks: blocks, budget: &budget)
        XCTAssertFalse(C.evidenceHolds(unchanged))
        XCTAssertTrue(try C.verifyImage(p.request, certificate: p, source: world()))
        let old = try proof("PermutedOldRelation")
        XCTAssertFalse(try C.verifyImage(old.request, certificate: old, source: world()))
        if case let .violated(edge) = old.images[0].promise { XCTAssertEqual(edge, []) }
        else { XCTFail("expected the old output relation to be separated") }
        XCTAssertEqual(try proof("DuplicateOutputPlaces").images[0].classes[0].leaves,
                       [[.left], [.right, .left]])
        XCTAssertEqual(try proof("ChainedImage").images[0].classes.count, 1)
        XCTAssertEqual(try proof("TwoSortImage").images[0].sourceClassIndices, [1, 0])
    }
    func testMarginalImagesKeepSelectorOriginsWithoutAddingIdentity() throws {
        let left = try proof("LeftMarginal"), right = try proof("RightMarginal")
        XCTAssertEqual(left.images[0].classes[0].leaves, right.images[0].classes[0].leaves)
        XCTAssertEqual(left.images[0].classes[0].sort, right.images[0].classes[0].sort)
        XCTAssertEqual(left.images[0].sourceClassIndices, [0])
        XCTAssertEqual(right.images[0].sourceClassIndices, [1])
        XCTAssertEqual(try C.imageReading(left.request, certificate: left, source: world()).image, .leaf([.left]))
        XCTAssertEqual(try C.imageReading(right.request, certificate: right, source: world()).image, .leaf([.right]))
        let omitted = try proof("OmittedIndependentPlaces")
        XCTAssertEqual(omitted.classes.count, 3)
        XCTAssertEqual(omitted.images[0].classes.count, 1)
        XCTAssertEqual(try proof("UnrestrictedImage").images[0].classes.count, 2)
        XCTAssertEqual(try proof("DuplicateImage").images[0].classes.count, 1)
        XCTAssertEqual(try proof("ScalarImage").images[0].classes[0].leaves, [[]])
        let omittedSort = try proof("OmittedSortImage")
        XCTAssertNotEqual(omittedSort.classes[0].sort, omittedSort.classes[1].sort)
        XCTAssertEqual(omittedSort.images[0].classes.count, 1)
    }
    func testExplicitJointImagesJudgeTheSourceOutputRelation() throws {
        let left = try proof("JointLeft"), right = try proof("JointRight")
        XCTAssertEqual(left.images[0].classes.map(\.leaves),
                       [[[.left, .left], [.right]], [[.left, .right]]])
        XCTAssertEqual(right.images[0].classes.map(\.leaves),
                       [[[.left, .left]], [[.left, .right], [.right]]])
        XCTAssertEqual(left.images[0].sourceClassIndices, [0, 1])
        XCTAssertEqual(right.images[0].sourceClassIndices, [0, 1])
        XCTAssertTrue(try C.verifyImage(left.request, certificate: C.decodeImage(C.encodeImage(left)), source: world()))
        XCTAssertFalse(try C.verifyImage(right.request, certificate: C.decodeImage(C.encodeImage(right)), source: world()))
        if case let .violated(edge) = right.images[0].promise { XCTAssertEqual(edge, []) }
        else { XCTFail("expected the source/output promise to separate") }
    }
    func testHiddenImageMustBeAnExactMemberDuringConstructionAndReplay() throws {
        refuses("template-is-not-a-member", at: "ImageTemplateIsNotAChoice.Image") {
            _ = try proof("ImageTemplateIsNotAChoice")
        }
        let withoutFamily = try world(edit: {
            $0.replacingOccurrences(of: "    typealias HiddenActions = Paired<Paired<Source.Left, Source.Left>, Paired<Source.Right, Source.Right>>\n", with: "")
        })
        let ordinary = try C.deriveImage("ImageTemplateIsNotAChoice", source: withoutFamily)
        XCTAssertFalse(try C.verifyImage(ordinary.request, certificate: ordinary, source: withoutFamily))
        let declaration = """

        enum ExactChoice<S: Structure> {
            typealias Source = Paired<S, S>
            typealias Equalities = Paired<Source.Left, Source.Right>
            typealias Image = Source.Left
            typealias HiddenActions = Paired<Source.Left, Source.Left>
        }
        enum AliasChoice<S: Structure> {
            typealias Source = Paired<S, S>
            typealias Selected = Source.Right
            typealias Image = Selected
            typealias HiddenActions = Paired<Source.Left, Selected>
        }
        """
        let valid = try world(edit: { $0 + declaration })
        var p = try C.deriveImage("ExactChoice", source: valid)
        let changed = try world(edit: { $0 + declaration.replacingOccurrences(
            of: "typealias Image = Source.Left", with: "typealias Image = Source.Right") })
        let context = try C.Context(p.request, source: changed, constructor: "Paired", requiredFields: ["Source", "Image"])
        p.image = try C.deriveRoute(.field(context.root, "Image"), context: context)
        // The new route is live and E-equivalent, but names another Source place.
        refuses("E-equivalence-is-not-family-membership", at: "ExactChoice.Image") {
            _ = try C.verifyImage(p.request, certificate: C.decodeImage(C.encodeImage(p)), source: changed)
        }
        refuses("nonmember-during-construction", at: "ExactChoice.Image") {
            _ = try C.deriveImage(p.request, source: changed)
        }
        let alias = try C.deriveImage("AliasChoice", source: valid)
        XCTAssertEqual(alias.images.map(\.member), [[.left], [.right]])
        XCTAssertTrue(try C.verifyImage(alias.request, certificate: C.decodeImage(C.encodeImage(alias)), source: valid))
    }
    func testHiddenPromisesDoNotRequireEqualValuesOrAnUnchangedImage() throws {
        let p = try proof("HiddenPairPromise")
        let r = try C.imageReading(p.request, certificate: p, source: world())
        XCTAssertEqual(p.images.map(\.member), [[.left], [.right]])
        XCTAssertNotEqual(p.images[0].sourceClassIndices, p.images[1].sourceClassIndices)
        let full = C.sourcePlaces(r.whole.source)
        let retained = C.RelatedReading(whole: r.whole, observation: full, question: full, hiddenActions: r.members)
        let oneStep = try C.constructDynamics(retained)
        try C.verifyDynamics(oneStep, reading: retained)
        guard case .disagreement? = oneStep.hidden?.conclusion else { return XCTFail("expected U8 disagreement") }
        XCTAssertTrue(try C.verifyImage(p.request, certificate: p, source: world()))
        let general = try proof("HiddenDifferentOutputShape")
        let generalReading = try C.imageReading(general.request, certificate: general, source: world())
        XCTAssertNotEqual(generalReading.output, generalReading.whole.source)
        XCTAssertEqual(general.images.count, 2)
        XCTAssertEqual(try proof("HiddenScalarOutput").images.map(\.member), [[.left], [.right]])
        let mixed = try proof("MixedImagePromises")
        if case let .violated(edge) = mixed.images[0].promise { XCTAssertEqual(edge, [.right]) }
        else { XCTFail("expected the second C-edge to be separated") }
        try tamper("HiddenPairPromise", "omitted-hidden-member", at: ".images:") { $0.images.removeLast() }
        try tamper("HiddenPairPromise", "member-outside-hidden-family", at: ".member:") {
            $0.images[1].member = [.right, .right]
        }
        try tamper("HiddenPairPromise", "omitted-hidden-family-reading", at: "HiddenPairPromise.HiddenActions") {
            $0.hiddenActions = nil
        }
        try tamper("HiddenMixedPromise", "healthy-member-substitutes-for-broken-member", at: "not the induced source class") {
            $0.images[0] = $0.images[1]
            $0.images[0].member = [.left]
        }
        try tamper("HiddenMixedPromise", "negative-first-member-does-not-skip-later-checks", at: ".images[1].promise:") {
            $0.images[1].promise = .holds([])
        }
        try tamper("MixedImagePromises", "good-C-edge-substituted-for-broken-edge", at: "does not separate source classes") {
            $0.images[0].promise = .violated(edge: [.left])
        }
    }
    func testInducedPartitionForgeries() throws {
        try tamper("PermutedPromise", "missing-output-leaf", at: ".classes:") {
            $0.images[0].classes[0].leaves.removeLast()
        }
        try tamper("PermutedPromise", "repeated-output-leaf", at: ".classes[0]") {
            $0.images[0].classes[0].leaves.append([.left])
        }
        try tamper("PermutedPromise", "nonleaf-output-address", at: ".classes[0]") {
            $0.images[0].classes[0].leaves[0] = []
        }
        try tamper("PermutedPromise", "merged-distinct-source-classes", at: "not the induced source class") {
            $0.images[0].classes[0].leaves.append([.right, .left])
            $0.images[0].classes.removeLast()
            $0.images[0].sourceClassIndices.removeLast()
            $0.images[0].connections = [[.sourceRelation([.init(edge: [], reversed: false)]), .address]]
        }
        try tamper("DuplicateImage", "split-one-induced-class", at: ".sourceClassIndices:") {
            let sort = $0.images[0].classes[0].sort
            $0.images[0].classes = [.init(sort: sort, leaves: [[.left]]), .init(sort: sort, leaves: [[.right]])]
            $0.images[0].sourceClassIndices = [0, 0]
            $0.images[0].connections = [[], []]
        }
        try tamper("DuplicateImage", "split-with-forged-distinct-origins", at: "not the induced source class") {
            let sort = $0.images[0].classes[0].sort
            $0.images[0].classes = [.init(sort: sort, leaves: [[.left]]), .init(sort: sort, leaves: [[.right]])]
            $0.images[0].sourceClassIndices = [0, 1]
            $0.images[0].connections = [[], []]
        }
        try tamper("PermutedPromise", "wrong-source-class-index", at: ".classes[0]") {
            $0.images[0].sourceClassIndices[0] = -1
        }
        try tamper("PermutedPromise", "missing-source-forest", at: "certificate.connections[0]") {
            $0.connections[0] = []
        }
        try tamper("PermutedPromise", "source-partition-breaks-E", at: "certificate.classes.E:") {
            let sort = $0.classes[0].sort
            $0.classes = [.init(sort: sort, leaves: [[.left]]), .init(sort: sort, leaves: [[.right, .left]]),
                          .init(sort: sort, leaves: [[.right, .right]])]
            $0.connections = [[], [], []]
        }
        try tamper("PermutedPromise", "missing-output-equality-path", at: ".connections[0]") {
            $0.images[0].connections[0] = []
        }
        try tamper("PermutedPromise", "path-not-from-E", at: ".connections[0][0]") {
            $0.images[0].connections[0][0] = .sourceRelation([.init(edge: [.left], reversed: false)])
        }
        try tamper("PermutedPromise", "value-coincidence-is-not-an-image-class", at: ".connections[0][0]") {
            $0.images[0].connections[0][0] = .observedValues
        }
        try tamper("PermutedPromise", "omitted-image-member", at: ".images:") { $0.images = [] }
        try tamper("PermutedPromise", "member-outside-declared-step", at: ".member:") { $0.images[0].member = [.left] }
    }
    func testRelativePromiseForgeries() throws {
        try tamper("IndependentPromise", "different-classes-claimed-to-hold", at: ".promise[0]") {
            $0.images[0].promise = .holds([.address])
        }
        try tamper("PermutedPromise", "omitted-promise-edge", at: ".promise:") { $0.images[0].promise = .holds([]) }
        try tamper("PermutedPromise", "forged-promise-E-path", at: ".promise[0]") {
            $0.images[0].promise = .holds([.sourceRelation([.init(edge: [.right], reversed: false)])])
        }
        try tamper("PermutedPromise", "equal-class-claimed-separated", at: "does not separate source classes") {
            $0.images[0].promise = .violated(edge: [])
        }
        try tamper("IndependentPromise", "undeclared-C-edge", at: "no declared C-edge") {
            $0.images[0].promise = .violated(edge: [.left])
        }
        try tamper("UnrestrictedImage", "empty-promise-claimed-violated", at: "no declared C-edge") {
            $0.images[0].promise = .violated(edge: [])
        }
        try tamper("PermutedPromise", "omitted-present-Promise", at: "PermutedPromise.Promise") { $0.promise = nil }
        try tamper("PermutedPromise", "Source-anchor-is-not-Image", at: "PermutedPromise.Promise") { $0.promise = .source }
        try tamper("PermutedPromise", "Image-anchor-is-not-Source", at: "PermutedPromise.Image") { $0.image = .image }
    }
    func testLiveImageAndPromiseMustMatchTheReadProof() throws {
        let p = try proof("PermutedPromise")
        let changedImage = try world(edit: {
            $0.replacingOccurrences(of: "Paired<Source.Left, Paired<Source.Right.Right, Source.Right.Left>>",
                                    with: "Paired<Source.Left, Paired<Source.Right.Left, Source.Right.Right>>")
        })
        refuses("changed-live-image", at: "PermutedPromise.Image") {
            _ = try C.verifyImage(p.request, certificate: p, source: changedImage)
        }
        let changedPromise = try world(edit: {
            $0.replacingOccurrences(of: "Paired<Image.Left, Image.Right.Right>", with: "Paired<Image.Left, Image.Right.Left>")
        })
        refuses("changed-live-promise", at: "PermutedPromise.Promise") {
            _ = try C.verifyImage(p.request, certificate: p, source: changedPromise)
        }
    }
    func testArchiveQuestionCannotMasquerade() throws {
        let p = try proof("PermutedPromise")
        var archive = try XCTUnwrap(JSONSerialization.jsonObject(with: C.encodeImage(p)) as? [String: Any])
        archive["format"] = 5
        refuses("image-archive-as-repeat", at: "expected format 6") {
            _ = try C.decodeImage(JSONSerialization.data(withJSONObject: archive))
        }
        let bytes = try C.encodeImage(p)
        XCTAssertThrowsError(try C.decodeRelated(bytes))
        let old = try C.deriveRelated("ReturnFirst", source: world("repeat-cases.swift"), repeats: true)
        XCTAssertThrowsError(try C.decodeImage(C.encodeRelated(old)))
    }
    func testAcceptedFormat5KeepsCanonicalBytes() throws {
        let data = try Data(contentsOf: root.appendingPathComponent(directory + "compatibility.json"))
        let manifest = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])
        let section = try XCTUnwrap(manifest["repeatArchives"] as? [String: Any])
        let entries = try XCTUnwrap(section["cases"] as? [[String: Any]])
        XCTAssertEqual(entries.count, 14)
        let source = try world("repeat-cases.swift")
        for entry in entries {
            let request = try XCTUnwrap(entry["request"] as? String)
            let p = try C.deriveRelated(request, source: source, repeats: true)
            let bytes = try C.encodeRelated(p)
            XCTAssertEqual(courtSHA256(bytes), entry["sha256"] as? String, request)
            _ = try C.verifyRelatedRepetition(request, certificate: C.decodeRelated(bytes), source: source)
            print("T0100 compatibility \(request): canonical format-5 archive unchanged")
        }
    }
}
