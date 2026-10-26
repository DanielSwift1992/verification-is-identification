import Foundation
import XCTest
import ContinuationRecord
@testable import Court

final class ContinuationRecordDifferentialTests: XCTestCase {
    typealias C = ContinuationCourt
    typealias R = RecordContinuation
    private var root: URL {
        URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
    }
    private func source(_ fixture: String) throws -> StructuralSource {
        try StructuralSource(files: ["Sources/Notation/Primitive.swift", "Contracts/Court/continuation-relations-v1/" + fixture].map {
            ($0, try WhereJudge.fileText(root.appendingPathComponent($0).path))
        })
    }
    private func missing(_ conclusion: C.RelatedConclusion) -> [[[C.Side]]] {
        guard case let .obstructed(p) = conclusion, let residue = p.residue else { return [] }
        return residue.needed.map { p.classes[$0.block].leaves }
    }
    // These are unread declarations, not admitted worlds. Translate the refused
    // condition to the record grammar, rather than inventing a valid (T,E).
    private func unreadRecord(_ request: String) throws -> Data {
        var value: [String: Any] = ["schema": 1,
            "source": [["pair": [1, 2]], ["sort": 0], ["sort": 0]],
            "equalities": [], "observation": ["place": [0]], "question": ["place": [1]]]
        switch request {
        case "CrossSortEquality":
            value["source"] = [["pair": [1, 2]], ["sort": 0], ["sort": 1]]
            value["equalities"] = [["at": [], "left": [0], "right": [1], "basis": "declared"]]
        case "MismatchedEdgeTrees":
            value["equalities"] = [["at": [], "left": [[0], [1]], "right": [1], "basis": "declared"]]
        case "SortIsNotSourcePlace": value["question"] = ["sort": 0]
        case "UnrootedObservation": value["observation"] = ["pair": [["place": [0]], ["sort": 0]]]
        case "UnrootedQuestionAlias": value["question"] = ["pair": [["sort": 0], ["sort": 0]]]
        case "ForeignWholeView": value["question"] = ["place": [1], "whole": 1]
        case "MisspelledWholeAxis": value["Equality"] = ["left": [0], "right": [1]]
        case "UnreadWholeAxis": value["Spare"] = ["place": [1]]
        default: throw C.Failure("no declared unread-record counterpart for " + request)
        }
        return try JSONSerialization.data(withJSONObject: value, options: [.sortedKeys])
    }
    func testEveryU5U6ContractCaseHasTheSameJudgment() throws {
        let file = root.appendingPathComponent("Contracts/Court/continuation-relations-v1/contract.json")
        let contract = try XCTUnwrap(JSONSerialization.jsonObject(with: Data(contentsOf: file)) as? [String: Any])
        let cases = try XCTUnwrap(contract["cases"] as? [[String: Any]])
        let retention = try XCTUnwrap(contract["retention"] as? [String: Any])
        let retained = try XCTUnwrap(retention["cases"] as? [[String: Any]])
        var constructed = 0, obstructed = 0, unread = 0, plans = 0
        for (rows, fixture, retain) in [(cases, "cases.swift", false), (retained, "retention-cases.swift", true)] {
            let s = try source(fixture)
            for row in rows {
                let name = try XCTUnwrap(row["request"] as? String)
                if row["outcome"] as? String == "unsupported" {
                    XCTAssertThrowsError(try C.deriveRelated(name, source: s))
                    do { _ = try R.read(unreadRecord(name)); XCTFail("record admitted " + name) }
                    catch { XCTAssertTrue(String(describing: error).contains("record.")); print("T0109 differential \(name): Swift unread / record unread: \(error)") }
                    unread += 1; continue
                }
                let old = try C.deriveRelated(name, source: s, retain: retain)
                let reading = try C.relatedReading(name, certificate: old, source: s)
                let bytes = try R.encode(reading.core), world = try R.read(bytes)
                let proof = try R.derive(world, retain: retain)
                let oldHolds = try C.verifyRelated(name, certificate: old, source: s)
                let newHolds = try R.verify(proof, world: world)
                XCTAssertEqual(oldHolds, newHolds, name)
                XCTAssertEqual(missing(old.conclusion), missing(proof.conclusion), name)
                let oldPlan = try retain ? old : C.deriveRelated(name, source: s, retain: true)
                let newPlan = try retain ? proof : R.derive(world, retain: true)
                XCTAssertEqual(oldPlan.retention?.leaves.count ?? 0, newPlan.retention?.leaves.count ?? 0, name)
                XCTAssertTrue(try R.verify(newPlan, world: world, retain: true))
                if let minimum = row["minimum_leaves"] as? Int { XCTAssertEqual(newPlan.retention?.leaves.count ?? 0, minimum, name) }
                let replayed = try R.decodeCertificate(R.encodeCertificate(proof))
                XCTAssertEqual(try R.verify(replayed, world: world, retain: retain), retain || oldHolds)
                if oldHolds { constructed += 1 } else { obstructed += 1 }
                if retain { plans += 1 }
                print("T0109 differential \(name): \(oldHolds ? "constructed" : "obstructed"), minimum \(newPlan.retention?.leaves.count ?? 0), record \(String(decoding: bytes, as: UTF8.self))")
            }
        }
        XCTAssertEqual(constructed + obstructed + unread, cases.count + retained.count)
        XCTAssertEqual(plans, retained.count)
        print("T0109 differential complete: \(constructed) constructed / \(obstructed) obstructed / \(unread) unread / \(plans) U6 plans")
    }
    func testIndependentExecutableAndCourtRecordEntryAgree() throws {
        let s = try source("cases.swift"), old = try C.deriveRelated("SameSortDifferentPlaces", source: s)
        let r = try C.relatedReading("SameSortDifferentPlaces", certificate: old, source: s)
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent("vi-record-cli-" + UUID().uuidString)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        let world = directory.appendingPathComponent("world.json"), proof = directory.appendingPathComponent("proof.json")
        try R.encode(r.core).write(to: world)
        let bin = try XCTUnwrap(ProcessInfo.processInfo.environment["VI_CHECK_BUILD_BIN"])
        #if os(Windows)
        let suffix = ".exe"
        #else
        let suffix = ""
        #endif
        func run(_ name: String, _ arguments: [String]) throws -> (Int32, Data) {
            let p = Process(), pipe = Pipe()
            p.executableURL = URL(fileURLWithPath: bin).appendingPathComponent(name + suffix)
            p.arguments = arguments; p.standardOutput = pipe; p.standardError = pipe
            try p.run(); let bytes = pipe.fileHandleForReading.readDataToEndOfFile(); p.waitUntilExit()
            return (p.terminationStatus, bytes)
        }
        for retain in [false, true] {
            let flag = retain ? ["--retain"] : []
            let native = try run("RecordCourt", flag + ["--certificate", proof.path, world.path])
            let facade = try run("Tools", ["judge", "continue", "--record"] + flag + [world.path])
            XCTAssertEqual(native.0, retain ? 0 : 1); XCTAssertEqual(native.0, facade.0)
            XCTAssertEqual(native.1, facade.1)
            let replay = try run("RecordCourt", ["replay"] + flag + [proof.path, world.path])
            XCTAssertEqual(replay.0, native.0); XCTAssertEqual(replay.1, native.1)
            let facadeReplay = try run("Tools", ["judge", "replay-continuation", "--record"] + flag + [proof.path, world.path])
            XCTAssertEqual(facadeReplay.0, native.0); XCTAssertEqual(facadeReplay.1, native.1)
        }
        print("T0109 standalone RecordCourt and Court facade: U5/U6 construction and replay agree")
    }
}
