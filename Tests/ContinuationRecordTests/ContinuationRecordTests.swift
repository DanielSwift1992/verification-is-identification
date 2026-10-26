import Foundation
import XCTest
import ContinuationRecord

final class ContinuationRecordTests: XCTestCase {
    typealias C = ContinuationCore
    typealias R = RecordContinuation
    private func world(_ equal: Bool = false) throws -> R.World {
        let edges: [C.SourceEdge] = equal ? [.init(address: [], left: [.left], right: [.right])] : []
        let reading = C.Reading(whole: .init(source: .pair(.leaf("S"), .leaf("S")), edges: edges),
            observation: .leaf([.left]), question: .leaf([.right]))
        return try R.read(R.encode(reading))
    }
    private func refuses(_ label: String, _ address: String, _ body: () throws -> Void,
                         file: StaticString = #filePath, line: UInt = #line) {
        do { try body(); XCTFail("admitted " + label, file: file, line: line) }
        catch {
            let why = String(describing: error)
            XCTAssertTrue(why.contains(address), why, file: file, line: line)
            print("T0109 refusal \(label): \(why)")
        }
    }
    func testOccurrenceIdentityAndDeclaredEquality() throws {
        let distinct = try world(), joined = try world(true)
        let a = try R.derive(distinct), b = try R.derive(joined)
        XCTAssertFalse(try R.verify(a, world: distinct))
        XCTAssertTrue(try R.verify(b, world: joined))
        let retained = try R.derive(distinct, retain: true)
        XCTAssertEqual(retained.retention?.leaves, [[.right]])
        XCTAssertTrue(try R.verify(retained, world: distinct, retain: true))
        XCTAssertEqual(try R.encode(distinct.reading), distinct.canonical)
        let renamed = C.Reading(whole: .init(source: .pair(.leaf("Renamed"), .leaf("Renamed")), edges: []), observation: .leaf([.left]), question: .leaf([.right]))
        XCTAssertEqual(try R.encode(renamed), distinct.canonical)
        let root = C.Reading(whole: .init(source: .leaf("S"), edges: []), observation: .leaf([]), question: .leaf([]))
        let single = try R.read(R.encode(root)), identity = try R.derive(single, retain: true)
        XCTAssertTrue(try R.verify(identity, world: single, retain: true)); XCTAssertNil(identity.retention)
        print("T0109 same sort, distinct places: obstructed; declared E: constructed; U6 minimum: 1; sort renaming: same record")
    }
    func testMalformedRecordsAreAddressed() throws {
        let text = String(decoding: try world().canonical, as: UTF8.self)
        let cases: [(String, String, String)] = [
            ("unknown place", text.replacingOccurrences(of: "\"question\":{\"place\":[1]}", with: "\"question\":{\"place\":[1,0]}"), "record.question.place"),
            ("nonleaf", text.replacingOccurrences(of: "\"place\":[1]", with: "\"place\":[]"), "record.question.place"),
            ("cycle", text.replacingOccurrences(of: "\"pair\":[1,2]", with: "\"pair\":[0,2]"), "record.source[0].pair[0]"),
            ("shared tree node", text.replacingOccurrences(of: "\"pair\":[1,2]", with: "\"pair\":[1,1]"), "record.source[0].pair[1]"),
            ("unknown node", text.replacingOccurrences(of: "\"pair\":[1,2]", with: "\"pair\":[1,99]"), "record.source[0].pair[1]"),
            ("duplicate key", text.replacingOccurrences(of: "\"schema\":1", with: "\"schema\":1,\"schema\":1"), "record.schema"),
            ("escaped duplicate key", text.replacingOccurrences(of: "\"schema\":1", with: "\"schema\":1,\"schem\\u0061\":1"), "record.schema"),
            ("extra bytes", text + "{}", "record"),
            ("trailing newline", text + "\n", "record: noncanonical"),
            ("BOM", "\u{FEFF}" + text, "record"),
            ("Swift is not the record grammar", "enum World<S> {}", "record"),
            ("unread action", text.replacingOccurrences(of: "\"schema\":1", with: "\"Actions\":[],\"schema\":1"), "record.Actions"),
            ("wrong version", text.replacingOccurrences(of: "\"schema\":1", with: "\"schema\":3"), "record.schema"),
            ("noncanonical sort", text.replacingOccurrences(of: "\"sort\":0", with: "\"sort\":9"), "record: noncanonical"),
            ("unknown source field", text.replacingOccurrences(of: "{\"sort\":0}", with: "{\"sort\":0,\"value\":0}"), "record.source[1].value")
        ]
        for (name, input, address) in cases { refuses(name, address) { _ = try R.read(Data(input.utf8)) } }
        let equal = String(decoding: try world(true).canonical, as: UTF8.self)
        let cross = equal.replacingOccurrences(of: "\"source\":[{\"pair\":[1,2]},{\"sort\":0},{\"sort\":0}]", with: "\"source\":[{\"pair\":[1,2]},{\"sort\":0},{\"sort\":1}]")
        refuses("cross sort E", "record.equalities[0]") { _ = try R.read(Data(cross.utf8)) }
        refuses("observed coincidence", "record.equalities[0].basis") {
            _ = try R.read(Data(equal.replacingOccurrences(of: "\"declared\"", with: "\"observedValues\"").utf8))
        }
        let invalid = Data([0xFF])
        refuses("invalid UTF8", "record") { _ = try R.read(invalid) }
    }
    func testCertificatesReplayWithoutSearchAndRefuseForgeries() throws {
        let a = try world(), b = try world(true)
        let p = try R.derive(a, retain: true)
        let bytes = try R.encodeCertificate(p)
        XCTAssertTrue(try R.verify(R.decodeCertificate(bytes), world: a, retain: true))
        XCTAssertFalse(try R.verify(p, world: a))
        refuses("substituted record", "certificate.record") { _ = try R.verify(p, world: b, retain: true) }
        var wrong = p; wrong.retention?.leaves = []
        refuses("missing residual", "certificate.retention.leaves") { _ = try R.verify(wrong, world: a, retain: true) }
        wrong = p; wrong.retention?.leaves.append([.left])
        refuses("extra residual", "certificate.retention.leaves") { _ = try R.verify(wrong, world: a, retain: true) }
        wrong = p; wrong.retention?.leaves = [[.left]]
        refuses("wrong class", "certificate.retention.leaves[0]") { _ = try R.verify(wrong, world: a, retain: true) }
        wrong = p; wrong.retention?.program = .pick([])
        refuses("forged decoder", "certificate.retention.program") { _ = try R.verify(wrong, world: a, retain: true) }
        if case let .obstructed(obstruction) = p.conclusion {
            var changed = obstruction
            changed.classes[0].leaves.append(contentsOf: changed.classes[1].leaves)
            changed.classes.removeLast()
            wrong = p; wrong.conclusion = .obstructed(changed)
            refuses("forged partition", "certificate.partition.question") { _ = try R.verify(wrong, world: a, retain: true) }
            changed = obstruction; changed.residue?.connections = []
            wrong = p; wrong.conclusion = .obstructed(changed)
            refuses("missing exact class forest", "certificate.residue.connections") { _ = try R.verify(wrong, world: a, retain: true) }
        }
        var constructed = try R.derive(b)
        guard case let .constructed(selections, program) = constructed.conclusion else { return XCTFail("no construction") }
        var forged = selections; forged[0].basis = .observedValues
        constructed.conclusion = .constructed(forged, program)
        refuses("observed value proof", "certificate.selections[0].basis") { _ = try R.verify(constructed, world: b) }
        forged[0].basis = .sourceRelation([.init(edge: [.left], reversed: false)])
        constructed.conclusion = .constructed(forged, program)
        refuses("forged E path", "certificate.selections[0].basis") { _ = try R.verify(constructed, world: b) }
        forged[0].basis = .address; constructed.conclusion = .constructed(forged, program)
        refuses("forged address identity", "certificate.selections[0].basis") { _ = try R.verify(constructed, world: b) }
        let source = String(decoding: bytes, as: UTF8.self)
        refuses("duplicate certificate key", "certificate.format") {
            _ = try R.decodeCertificate(Data(source.replacingOccurrences(of: "\"format\" : 8", with: "\"format\" : 8, \"format\" : 8").utf8))
        }
        var question = C.Places.leaf([.left])
        for _ in 0..<61 { question = .pair(question, .leaf([.left])) }
        let deep = C.Reading(whole: a.reading.whole, observation: .pair(.leaf([.left]), .leaf([.right])), question: question)
        let deepWorld = try R.read(R.encode(deep)), deepProof = try R.derive(deepWorld)
        XCTAssertTrue(try R.verify(R.decodeCertificate(R.encodeCertificate(deepProof)), world: deepWorld))
        print("T0109 depth: admitted 61-pair Question; constructed certificate replays")
    }
    func testRelationCyclesDoNotMakePairTreeCycles() throws {
        let s: C.Shape = .pair(.leaf("S"), .pair(.leaf("S"), .leaf("S")))
        let paths: [C.Path] = [[.left], [.right, .left], [.right, .right]]
        let edges = paths.indices.map { C.SourceEdge(address: [.left] + Array(repeating: .right, count: $0), left: paths[$0], right: paths[($0 + 1) % 3]) }
        let reading = C.Reading(whole: .init(source: s, edges: edges), observation: .leaf(paths[0]), question: .leaf(paths[2]))
        let w = try R.read(R.encode(reading)); let p = try R.derive(w)
        XCTAssertTrue(try R.verify(p, world: w))
        print("T0109 finite E cycle: admitted; pair tree cycles remain unread")
    }
}
