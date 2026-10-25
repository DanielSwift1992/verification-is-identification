import Foundation
import XCTest
@testable import Court

final class WholeLawCoverTests: XCTestCase {
    typealias C = ContinuationCourt
    private let fixture = "Contracts/Court/whole-law-cover-v1/cases.swift"
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
    private func refuses(_ address: String, _ body: () throws -> Void,
                         file: StaticString = #filePath, line: UInt = #line) {
        do {
            try body()
            XCTFail("admitted " + address, file: file, line: line)
        } catch {
            let message = String(describing: error)
            XCTAssertTrue(message.contains(address), message, file: file, line: line)
            print("T0090 refused: " + message)
        }
    }
    private func proof(_ request: String = "SharedLeaf") throws -> C.LawCoverCertificate {
        try C.deriveLawCover(request, source: world())
    }
    func testNamedContractAndSerializedReplay() throws {
        let json = try Data(contentsOf: root.appendingPathComponent("Contracts/Court/whole-law-cover-v1/contract.json"))
        let document = try XCTUnwrap(JSONSerialization.jsonObject(with: json) as? [String: Any])
        XCTAssertEqual(document["sha256"] as? String,
                       courtSHA256(try Data(contentsOf: root.appendingPathComponent(fixture))))
        let cases = try XCTUnwrap(document["cases"] as? [[String: String]])
        let source = try world()
        for entry in cases {
            let name = try XCTUnwrap(entry["request"])
            let outcome = try XCTUnwrap(entry["outcome"])
            if outcome == "unsupported" {
                refuses(try XCTUnwrap(entry["address"])) { _ = try C.deriveLawCover(name, source: source) }
            } else {
                let p = try C.deriveLawCover(name, source: source)
                let saved = try C.decodeLawCover(C.encodeLawCover(p))
                XCTAssertEqual(try C.verifyLawCover(name, certificate: saved, source: source), outcome == "holds", name)
                XCTAssertEqual(try C.encodeLawCover(p), try C.encodeLawCover(saved))
                print("T0090 \(name): \(outcome); serialized replay agrees")
            }
        }
        XCTAssertEqual(cases.count, 17)
        try checkArchiveOutputLimit()
    }
    private func checkArchiveOutputLimit() throws {
        // This accepted-size source produces an archive above the shared 8 MB limit.
        func tree(_ items: [String]) -> String {
            if items.count == 1 { return items[0] }
            let mid = items.count / 2
            return "Paired<" + tree(Array(items[..<mid])) + ", " + tree(Array(items[mid...])) + ">"
        }
        func leaves(_ depth: Int, _ prefix: String) -> [String] {
            if depth == 0 { return [prefix] }
            return leaves(depth - 1, prefix + ".Left") + leaves(depth - 1, prefix + ".Right")
        }
        let names = leaves(10, "Source")
        XCTAssertEqual(names.count, 1024)
        let text = "import VerificationIsIdentification\nenum Big<S: Structure> {\n"
            + "typealias Source = " + tree(Array(repeating: "S", count: names.count))
            + "\ntypealias Equalities = Paired<" + tree(Array(names.dropLast())) + ", "
            + tree(Array(names.dropFirst())) + ">\n"
            + "typealias First = Paired<Source.Left, Source.Right>\n"
            + "typealias Coverage = Paired<First, Source>\n}\n"
        let primitive = "Sources/Notation/Primitive.swift"
        let source = try StructuralSource(files: [
            (primitive, String(contentsOf: root.appendingPathComponent(primitive), encoding: .utf8)),
            ("big.swift", text)
        ])
        let p = try C.deriveLawCover("Big", source: source)
        XCTAssertTrue(try C.verifyLawCover("Big", certificate: p, source: source))
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        let raw = try encoder.encode(C.LawCoverArchive(format: 1, question: "whole-law-cover", certificate: p))
        XCTAssertGreaterThan(raw.count, 8_000_000)
        print("T0090 output boundary: 1024 leaves, \(raw.count) archive bytes")
        refuses("certificate: output limit; no obstruction inferred") { _ = try C.encodeLawCover(p) }
        refuses("certificate: archive byte limit") { _ = try C.decodeLawCover(raw) }
    }
    func testForeignEEdgeAndBrokenClassRefuse() throws {
        var p = try proof()
        p.connections[0][0].edge = [.right, .right]
        refuses("certificate.connections[0][0]") { _ = try C.verifyLawCover(p.request.text, certificate: p, source: world()) }
        p = try proof()
        p.classes[0].leaves.removeLast()
        p.classes.append(.init(sort: "$continuation0", leaves: [[.right, .right]]))
        p.connections[0].removeLast()
        p.connections.append([])
        refuses("partition breaks a declared E-edge") { _ = try C.verifyLawCover(p.request.text, certificate: p, source: world()) }
    }
    func testClosedButCoarserPartitionNeedsAnEForest() throws {
        var p = try proof("NoEqualities")
        p.classes = [.init(sort: "$continuation0", leaves: [[.left], [.right]])]
        p.connections = [[.init(edge: [], reversed: false)]]
        refuses("no declared E-edge") { _ = try C.verifyLawCover(p.request.text, certificate: p, source: world()) }
    }
    func testLocalTreeNeedsItsWholeClassAndVisibleLink() throws {
        var p = try proof()
        guard case var .holds(trees) = p.conclusion else { return XCTFail("expected holds") }
        trees[0].links[0].domain = [.left, .left]
        p.conclusion = .holds(trees)
        refuses("not visible in the declared domain") { _ = try C.verifyLawCover(p.request.text, certificate: p, source: world()) }
        p = try proof()
        guard case var .holds(other) = p.conclusion else { return XCTFail("expected holds") }
        other[0].links[0].to = other[0].root
        p.conclusion = .holds(other)
        refuses("does not attach a new member") { _ = try C.verifyLawCover(p.request.text, certificate: p, source: world()) }
    }
    func testCountermodelSubsetUniquenessAndProperness() throws {
        let original = try proof("FalseBridge")
        guard case let .refused(model) = original.conclusion else { return XCTFail("expected refused") }
        let members = original.classes[model.block].leaves
        for (one, address) in [
            ([], "nonempty proper subset"),
            (members, "nonempty proper subset"),
            (model.one + model.one, "repeated source address"),
            ([[C.Side.right, .left]], "S is not a subset of K")
        ] {
            var p = original
            var bad = model
            bad.one = one
            p.conclusion = .refused(bad)
            refuses(address) { _ = try C.verifyLawCover(p.request.text, certificate: p, source: world()) }
        }
    }
    func testCountermodelCrossingAndLocalExtensions() throws {
        var p = try proof("SeparatedClass")
        guard case var .refused(model) = p.conclusion else { return XCTFail("expected refused") }
        model.crossing = [.left]
        p.conclusion = .refused(model)
        refuses(".crossing: no declared E-edge") { _ = try C.verifyLawCover(p.request.text, certificate: p, source: world()) }
        p = try proof()
        p.conclusion = .refused(.init(block: 0, one: [[.left]], crossing: [.left]))
        refuses("domain splits S") { _ = try C.verifyLawCover(p.request.text, certificate: p, source: world()) }
    }
    func testDiscardedDomainAndChangedLiveCoverageRefuse() throws {
        var p = try proof("ThreeDomains")
        func drop(_ r: C.RouteProof) -> C.RouteProof {
            switch r {
            case let .definition(input, arguments, child): return .definition(input, arguments, drop(child))
            case let .pair(l, _): return l
            default: return r
            }
        }
        p.coverage = drop(p.coverage)
        refuses("route body differs from the live source") { _ = try C.verifyLawCover(p.request.text, certificate: p, source: world()) }
        let saved = try proof()
        let changed = try world { $0.replacingOccurrences(of: "typealias Coverage = Paired<First, Second>",
                                                          with: "typealias Coverage = Paired<Second, First>") }
        refuses("route body differs from the live source") { _ = try C.verifyLawCover(saved.request.text, certificate: saved, source: changed) }
    }
    func testChangedLiveEAndRequestRefuse() throws {
        let saved = try proof("SeparatedClass")
        let changed = try world { $0.replacingOccurrences(of: "typealias Equalities = Paired<Source.Left, Source.Right>",
                                                          with: "typealias Equalities = Paired<Source.Right, Source.Left>") }
        refuses("route body differs from the live source") { _ = try C.verifyLawCover(saved.request.text, certificate: saved, source: changed) }
        refuses("request or constructor substituted") { _ = try C.verifyLawCover("NoEqualities", certificate: saved, source: world()) }
    }
    func testSameRouteProofBindsFamilyAndRenamedOpaqueSort() throws {
        let source = try world { $0.replacingOccurrences(of: #"\bS\b"#, with: "Unseen", options: .regularExpression)
            .replacingOccurrences(of: "\n", with: "\r\n") }
        let p = try C.deriveLawCover("SharedLeaf", source: source)
        XCTAssertTrue(try C.verifyLawCover(p.request.text, certificate: p, source: source))
        XCTAssertEqual(try C.encodeLawCover(p), try C.encodeLawCover(proof()))
        var bad = p
        bad.coverage = .domain(.source)
        refuses("family endpoint substituted") { _ = try C.verifyLawCover(p.request.text, certificate: bad, source: world()) }
        refuses("domain boundary outside a family") {
            let c = try C.Context("SharedLeaf", source: world(), requiredFields: ["Source", "Coverage"])
            _ = try C.replayRoute(.domain(.source), context: c, source: .leaf("$continuation0"))
        }
    }
}
