import Foundation
import XCTest
@testable import Court

final class ContinuationRepetitionTests: XCTestCase {
    typealias C = ContinuationCourt
    private let directory = "Contracts/Court/continuation-relations-v1/"
    private var root: URL {
        URL(fileURLWithPath: #filePath).deletingLastPathComponent()
            .deletingLastPathComponent().deletingLastPathComponent()
    }
    private func world(_ fixture: String = "repeat-cases.swift", edit: ((String) -> String)? = nil) throws -> StructuralSource {
        let primitive = "Sources/Notation/Primitive.swift"
        let path = directory + fixture
        let text = try String(contentsOf: root.appendingPathComponent(path), encoding: .utf8)
        return try StructuralSource(files: [
            (primitive, String(contentsOf: root.appendingPathComponent(primitive), encoding: .utf8)),
            (path, edit?(text) ?? text)
        ])
    }
    private func proof(_ request: String) throws -> C.RelatedCertificate {
        try C.deriveRelated(request, source: world(), repeats: true)
    }
    private func block(_ p: C.RelatedCertificate) throws -> C.ReturnBlock {
        guard case let .returned(value)? = p.repetition?.conclusion else {
            throw C.Failure("test expected a returned block")
        }
        return value
    }
    private func editBlock(_ p: inout C.RelatedCertificate, _ edit: (inout C.ReturnBlock) -> Void) {
        guard case var .returned(value)? = p.repetition?.conclusion else { return XCTFail("returned block") }
        edit(&value)
        p.repetition!.conclusion = .returned(value)
    }
    private func refuses(_ label: String, at: String, _ body: () throws -> Void,
                         file: StaticString = #filePath, line: UInt = #line) {
        do {
            try body()
            XCTFail("admitted " + label, file: file, line: line)
        } catch {
            let message = String(describing: error)
            XCTAssertTrue(message.contains(at), message, file: file, line: line)
            print("T0099 \(label): refused: \(message)")
        }
    }
    private func tamper(_ request: String, _ label: String, at: String,
                        _ edit: (inout C.RelatedCertificate) -> Void,
                        file: StaticString = #filePath, line: UInt = #line) throws {
        var p = try proof(request)
        edit(&p)
        refuses(label, at: at, {
            let saved = try C.decodeRelated(C.encodeRelated(p))
            _ = try C.verifyRelatedRepetition(request, certificate: saved, source: world())
        }, file: file, line: line)
    }
    func testNamedContractAndSerializedReplay() throws {
        let data = try Data(contentsOf: root.appendingPathComponent(directory + "contract.json"))
        let document = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])
        let section = try XCTUnwrap(document["repetition"] as? [String: Any])
        XCTAssertEqual(section["sha256"] as? String, courtSHA256(try Data(contentsOf: root.appendingPathComponent(directory + "repeat-cases.swift"))))
        let cases = try XCTUnwrap(section["cases"] as? [[String: Any]])
        XCTAssertEqual(cases.count, 17)
        let source = try world()
        for entry in cases {
            let request = try XCTUnwrap(entry["request"] as? String)
            if let address = entry["address"] as? String {
                refuses(request, at: address) { _ = try C.deriveRelated(request, source: source, repeats: true) }
                continue
            }
            let p = try C.deriveRelated(request, source: source, repeats: true)
            let encoded = try C.encodeRelated(p)
            let saved = try C.decodeRelated(encoded)
            let holds = try C.verifyRelatedRepetition(request, certificate: saved, source: source)
            if let calls = entry["calls"] as? String {
                XCTAssertTrue(holds)
                XCTAssertEqual(try block(saved).calls, calls)
                XCTAssertEqual(try block(saved).additionalCalls, String(Int(calls)! - 1))
            } else {
                XCTAssertFalse(holds)
                let kind = saved.repetition?.conclusion == nil ? "preservation" : "tail"
                XCTAssertEqual(entry["refusal"] as? String, kind)
            }
            XCTAssertEqual(try C.encodeRelated(saved), encoded)
            let archive = try XCTUnwrap(JSONSerialization.jsonObject(with: encoded) as? [String: Any])
            XCTAssertEqual(archive["format"] as? Int, 5)
            print("T0099 \(request): \(entry["calls"] ?? entry["refusal"] ?? "unknown"); serialized replay agrees")
        }
    }
    func testQuestionDeterminesThreeOrSixCallsAndClassCycles() throws {
        let first = try block(proof("ReturnFirst"))
        XCTAssertEqual(first.calls, "3")
        XCTAssertEqual(first.additionalCalls, "2")
        XCTAssertEqual(first.cycles.map(\.length), [1, 3])
        let whole = try proof("ReturnWhole")
        XCTAssertEqual(try block(whole).calls, "6")
        XCTAssertEqual(try block(whole).additionalCalls, "5")
        XCTAssertEqual(try block(whole).cycles.map(\.length), [1, 2, 2, 3, 3, 3])
        XCTAssertFalse(try C.verifyRelated(whole.request.text, certificate: whole, source: world()))
        XCTAssertTrue(try C.verifyRelatedRepetition(whole.request.text, certificate: whole, source: world()))
        XCTAssertEqual(try block(proof("FourCycle")).cycles[0].length, 4)
        XCTAssertEqual(try block(proof("EqualClassReturn")).cycles.map(\.length), [1])
        XCTAssertEqual(try block(proof("DuplicateReturnQuestion")).cycles.count, 2)
        XCTAssertEqual(try block(proof("ScalarRepeats")).cycles.map(\.member), [[.left], [.right, .left], [.right, .right]])
    }
    func testFixedHiddenEpisodeIsNotIndependentChoiceOrCurrentTarget() throws {
        let p = try proof("AliasedRepeats")
        XCTAssertEqual(try block(p).calls, "2")
        let oneStep = try C.deriveRelated(p.request.text, source: world(), actions: true)
        XCTAssertFalse(try C.verifyRelatedActions(p.request.text, certificate: oneStep, source: world()))
        let r = try C.relatedReading(p.request.text, certificate: p, source: world())
        let members = try XCTUnwrap(r.hiddenActions)
        let origin: C.Path = [.left]
        for member in members {
            XCTAssertEqual(try member.imageOf(member.imageOf(origin)), origin)
        }
        XCTAssertNotEqual(try members[1].imageOf(members[0].imageOf(origin)), origin)
        let changed = try world(edit: {
            $0.replacingOccurrences(of: "enum ReturnFirst<S: Structure> {\n    typealias Source = Paired<S, Paired<S, S>>\n    typealias Observation = Source.Left\n    typealias Question = Source.Left",
                                    with: "enum ReturnFirst<S: Structure> {\n    typealias Source = Paired<S, Paired<S, S>>\n    typealias Observation = Source.Left\n    typealias Question = Source.Right.Left")
        })
        let old = try proof("ReturnFirst")
        refuses("retarget-original-question", at: "ReturnFirst.Question") {
            _ = try C.verifyRelatedRepetition(old.request.text, certificate: old, source: changed)
        }
    }
    func testCycleAndArithmeticForgeries() throws {
        try tamper("TailQuestion", "tail-as-returned", at: "cycle must start and return") {
            $0.repetition!.conclusion = .returned(.init(
                cycles: [.init(member: [], block: 1, vertices: [1, 0, 0], length: 2)],
                arithmetic: [.init(gcd: 1, multiplier: 2, value: "2")],
                calls: "2", additionalCalls: "1"))
        }
        try tamper("ReturnFirst", "cycle-does-not-return", at: ".vertices") { p in
            editBlock(&p) { $0.cycles[1].vertices[3] = 1 }
        }
        try tamper("ReturnFirst", "wrong-cycle-length", at: ".length:") { p in
            editBlock(&p) { $0.cycles[1].length = 2 }
        }
        try tamper("ReturnFirst", "nonmultiple-calls", at: ".calls:") { p in
            editBlock(&p) { $0.calls = "2" }
        }
        try tamper("ReturnFirst", "nonleast-multiple", at: ".calls:") { p in
            editBlock(&p) { $0.calls = "6"; $0.additionalCalls = "5" }
        }
        try tamper("ReturnFirst", "zero-total-calls", at: ".calls:") { p in
            editBlock(&p) { $0.calls = "0" }
        }
        try tamper("ReturnFirst", "noncanonical-call-numeral", at: ".calls:") { p in
            editBlock(&p) { $0.calls = "03" }
        }
        try tamper("ReturnFirst", "wrong-additional-call-count", at: ".additionalCalls:") { p in
            editBlock(&p) { $0.additionalCalls = "3" }
        }
        try tamper("ReturnFirst", "forged-gcd", at: ".arithmetic[1]") { p in
            editBlock(&p) { $0.arithmetic[1].gcd = 3 }
        }
        try tamper("ReturnFirst", "forged-lcm-multiplier", at: ".arithmetic[1]") { p in
            editBlock(&p) { $0.arithmetic[1].multiplier = 2 }
        }
        try tamper("ReturnFirst", "forged-lcm-value", at: ".arithmetic[1].value:") { p in
            editBlock(&p) { $0.arithmetic[1].value = "6" }
        }
        try tamper("ReturnFirst", "missing-pair", at: ".cycles:") { p in
            editBlock(&p) { $0.cycles.removeLast() }
        }
        try tamper("ReturnFirst", "foreign-cycle-member", at: ".cycles[1]") { p in
            editBlock(&p) { $0.cycles[1].member = [.right, .left] }
        }
        try tamper("ReturnFirst", "cycle-for-another-question-class", at: ".cycles[1]") { p in
            editBlock(&p) { $0.cycles[1].block = 1 }
        }
        try tamper("ReturnFirst", "repeated-cycle-before-end", at: ".vertices:") { p in
            editBlock(&p) { $0.cycles[1].vertices = [0, 0, 0] }
        }
    }
    func testTailCertificateForgeriesAndQuestionSpecificity() throws {
        let p = try proof("TailQuestion")
        guard case let .obstructed(tail)? = p.repetition?.conclusion else { return XCTFail("tail") }
        XCTAssertEqual(tail.vertices, [1, 0, 0])
        XCTAssertEqual(tail.repeatedIndex, 1)
        XCTAssertEqual(try block(proof("FixedQuestion")).calls, "1")
        XCTAssertEqual(try block(proof("OtherClassesMayHaveTails")).calls, "1")
        try tamper("TailQuestion", "wrong-first-repeat-index", at: ".repeatedIndex:") {
            $0.repetition!.conclusion = .obstructed(.init(member: [], block: 1, vertices: [1, 0, 0], repeatedIndex: 0))
        }
        try tamper("TailQuestion", "tail-repeats-its-start", at: ".vertices") {
            $0.repetition!.conclusion = .obstructed(.init(member: [], block: 1, vertices: [1, 0, 1], repeatedIndex: 0))
        }
        try tamper("AliasedRepeats", "cycle-claimed-as-tail", at: ".repeatedIndex:") {
            $0.repetition!.conclusion = .obstructed(.init(member: [.right], block: 0, vertices: [0, 1, 0], repeatedIndex: 0))
        }
        try tamper("TailQuestion", "foreign-tail-member", at: ".member:") {
            $0.repetition!.conclusion = .obstructed(.init(member: [.left], block: 1, vertices: [1, 0, 0], repeatedIndex: 1))
        }
        try tamper("TailQuestion", "tail-outside-question", at: ".block:") {
            $0.repetition!.conclusion = .obstructed(.init(member: [], block: 0, vertices: [0, 0], repeatedIndex: 0))
        }
        try tamper("LongReturnTail", "walk-skips-class-image", at: ".vertices[1]") {
            $0.repetition!.conclusion = .obstructed(.init(member: [], block: 3, vertices: [3, 1, 0, 0], repeatedIndex: 2))
        }
    }
    func testExactClassesPreservationCoverageAndPremiseForgeries() throws {
        try tamper("EqualClassReturn", "substituted-preservation-path", at: ".preservation[0]") {
            $0.repetition!.hiddenActions[0].preservation = .preserved([.address])
        }
        try tamper("EqualClassReturn", "missing-exact-class-forest", at: ".connections[0]:") {
            $0.repetition!.connections[0] = []
        }
        try tamper("ReturnFirst", "coarsened-independent-classes", at: ".connections") {
            let moved = $0.repetition!.classes[1].leaves
            $0.repetition!.classes[0].leaves.append(contentsOf: moved)
            $0.repetition!.classes.remove(at: 1)
        }
        try tamper("ReturnFirst", "omitted-question-class", at: ".required:") { $0.repetition!.required = [] }
        try tamper("ReturnFirst", "omitted-hidden-preservation", at: ".hiddenActions:") { $0.repetition!.hiddenActions.removeLast() }
        try tamper("ReturnFirst", "missing-u11-conclusion", at: ".conclusion:") { $0.repetition!.conclusion = nil }
        try tamper("ReturnFirst", "omitted-hidden-reading", at: "ReturnFirst.HiddenActions") { $0.hiddenActions = nil }
    }
    func testExactCallCountBeyondMachineInteger() throws {
        let periods = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53]
        var origins: [String] = []
        func sourceTree(_ n: Int, _ path: String) -> String {
            if n == 1 { origins.append(path); return "S" }
            let half = n / 2
            return "Paired<\(sourceTree(half, path + ".Left")), \(sourceTree(n - half, path + ".Right"))>"
        }
        func product(_ leaves: ArraySlice<String>) -> String {
            if leaves.count == 1 { return leaves.first! }
            let half = leaves.count / 2
            return "Paired<\(product(leaves.prefix(half))), \(product(leaves.dropFirst(half)))>"
        }
        let count = periods.reduce(0, +)
        let shape = sourceTree(count, "Source")
        var images: [String] = [], questions: [String] = [], start = 0
        for length in periods {
            questions.append(origins[start])
            for offset in 0..<length { images.append(origins[start + (offset + 1) % length]) }
            start += length
        }
        // Rebuild the same balanced T shape with image leaves, rather than a
        // separate family encoding or a simulation of contents.
        let text = """
        enum LargeReturn<S: Structure> {
            typealias Source = \(shape)
            typealias Observation = \(origins[0])
            typealias Question = \(product(questions[...]))
            typealias HiddenActions = \(product(images[...]))
        }
        """
        let primitive = "Sources/Notation/Primitive.swift"
        let source = try StructuralSource(files: [
            (primitive, String(contentsOf: root.appendingPathComponent(primitive), encoding: .utf8)),
            ("large-return.swift", text)
        ])
        let p = try C.deriveRelated("LargeReturn", source: source, repeats: true)
        let saved = try C.decodeRelated(C.encodeRelated(p))
        let result = try block(saved)
        XCTAssertEqual(result.cycles.map(\.length), periods)
        XCTAssertEqual(result.calls, "32589158477190044730")
        XCTAssertEqual(result.additionalCalls, "32589158477190044729")
        XCTAssertNil(Int(result.calls))
        XCTAssertTrue(try C.verifyRelatedRepetition(p.request.text, certificate: saved, source: source))
        print("T0099 LargeReturn: \(count) classes, exact least count \(result.calls); serialized replay agrees")
    }
    func testFormat5CannotMasqueradeAsEarlierJudgment() throws {
        let p = try proof("ReturnFirst")
        var archive = try XCTUnwrap(JSONSerialization.jsonObject(with: C.encodeRelated(p)) as? [String: Any])
        archive["format"] = 4
        refuses("format5-as-format4", at: "certificate: expected format 2") {
            _ = try C.decodeRelated(JSONSerialization.data(withJSONObject: archive))
        }
        let old = try C.deriveRelated("AliasedRepeats", source: world(), actions: true)
        refuses("old-actions-archive-is-not-u11", at: "certificate.repetition:") {
            _ = try C.verifyRelatedRepetition(old.request.text, certificate: old, source: world())
        }
        refuses("combined-action-and-repeat-questions", at: "--repeat") {
            _ = try C.deriveRelated("ReturnFirst", source: world(), actions: true, repeats: true)
        }
        var budget = C.ActionBudget()
        budget.remaining = 0
        refuses("arithmetic-budget-is-unresolved", at: "action proof work limit") {
            _ = try C.ReturnCount("1", at: "certificate.repetition.calls", budget: &budget)
        }
    }
    func testAcceptedFormat4CanonicalBytesAndReplay() throws {
        let data = try Data(contentsOf: root.appendingPathComponent(directory + "compatibility.json"))
        let document = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])
        let section = try XCTUnwrap(document["actions"] as? [String: Any])
        let cases = try XCTUnwrap(section["cases"] as? [[String: Any]])
        XCTAssertEqual(cases.count, 13)
        let source = try world("action-cases.swift")
        for entry in cases {
            let request = try XCTUnwrap(entry["request"] as? String)
            let p = try C.deriveRelated(request, source: source, actions: true)
            let encoded = try C.encodeRelated(p)
            XCTAssertEqual(courtSHA256(encoded), entry["sha256"] as? String, request)
            _ = try C.verifyRelatedActions(request, certificate: C.decodeRelated(encoded), source: source)
            print("T0099 compatibility \(request): canonical format 4 unchanged")
        }
    }
}
