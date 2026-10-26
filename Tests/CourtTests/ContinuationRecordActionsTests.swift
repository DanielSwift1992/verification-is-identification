import Foundation
import XCTest
import ContinuationRecord
@testable import Court

final class ContinuationRecordActionsTests: XCTestCase {
    typealias C = ContinuationCourt
    typealias R = RecordContinuation
    private var root: URL {
        URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
    }
    private func unread(_ name: String) throws -> Data {
        let base = "{\"schema\":2,\"source\":[{\"pair\":[1,2]},{\"sort\":0},{\"sort\":0}],\"equalities\":[],\"observation\":{\"place\":[0]},\"question\":{\"place\":[1]},\"actions\":[{\"at\":[],\"image\":[[0],[1]]}]}"
        let text: String
        switch name {
        case "MalformedActionShape": text = base.replacingOccurrences(of: "[[0],[1]]", with: "[[0]]")
        case "UnrootedAction": text = base.replacingOccurrences(of: "[[0],[1]]", with: "[{\"sort\":0},{\"sort\":0}]")
        case "UnreadActionAxis": text = base.replacingOccurrences(of: "\"actions\"", with: "\"Action\"")
        case "SortChangingAction":
            text = base.replacingOccurrences(of: "{\"sort\":0},{\"sort\":0}", with: "{\"sort\":0},{\"sort\":1}")
                .replacingOccurrences(of: "[[0],[1]]", with: "[[1],[0]]")
        default: throw C.Failure("unread counterpart missing: " + name)
        }
        return Data(text.utf8)
    }

    func testAllSeventeenActionCasesUseTheSameJudgment() throws {
        let contractBytes = try Data(contentsOf: root.appendingPathComponent("Contracts/Court/continuation-relations-v1/contract.json"))
        let contract = try XCTUnwrap(JSONSerialization.jsonObject(with: contractBytes) as? [String: Any])
        let section = try XCTUnwrap(contract["actions"] as? [String: Any])
        let rows = try XCTUnwrap(section["cases"] as? [[String: Any]])
        let s = try StructuralSource(files: ["Sources/Notation/Primitive.swift", "Contracts/Court/continuation-relations-v1/action-cases.swift"].map {
            ($0, try WhereJudge.fileText(root.appendingPathComponent($0).path))
        })
        let encoder = JSONEncoder(); encoder.outputFormatting = [.sortedKeys]
        var exported: [[String: Any]] = [], good = 0, unreadCount = 0
        for row in rows {
            let name = try XCTUnwrap(row["request"] as? String)
            if row["address"] as? String != nil {
                XCTAssertThrowsError(try C.deriveRelated(name, source: s, actions: true))
                let bytes = try unread(name)
                XCTAssertThrowsError(try R.read(bytes)) { error in XCTAssertTrue(String(describing: error).contains("record.")) }
                exported.append(["request": name, "outcome": "unsupported", "record": String(decoding: bytes, as: UTF8.self)])
                unreadCount += 1; continue
            }
            let old = try C.deriveRelated(name, source: s, actions: true)
            let reading = try C.relatedReading(name, certificate: old, source: s)
            let bytes = try R.encodeActions(reading.core, actionsDeclared: old.actions != nil)
            let world = try R.read(bytes), proof = try R.derive(world, actions: true)
            let oldHolds = try C.verifyRelatedActions(name, certificate: old, source: s)
            XCTAssertEqual(try R.verify(proof, world: world, actions: true), oldHolds, name)
            XCTAssertEqual(oldHolds, row["holds"] as? Bool, name)
            var normalized = try XCTUnwrap(old.dynamics), sorts: [String] = []
            for (_, sort) in reading.source.leaves where !sorts.contains(where: { ContinuationCore.sameSort($0, sort) }) { sorts.append(sort) }
            for i in normalized.classes.indices {
                normalized.classes[i].sort = String(try XCTUnwrap(sorts.firstIndex(where: { ContinuationCore.sameSort($0, normalized.classes[i].sort) })))
            }
            // This compares the entire payload, including classes, E-paths,
            // addressed words, stable view, image actions and hidden conclusion.
            XCTAssertEqual(try encoder.encode(normalized), try encoder.encode(proof.dynamics), name)
            let saved = try R.decodeCertificate(R.encodeCertificate(proof))
            XCTAssertEqual(try R.verify(saved, world: world, actions: true), oldHolds, name)
            XCTAssertThrowsError(try R.verify(proof, world: world))
            exported.append(["request": name, "outcome": oldHolds ? "constructed" : "obstructed", "record": String(decoding: bytes, as: UTF8.self)])
            good += 1
        }
        XCTAssertEqual(rows.count, 17); XCTAssertEqual(good, 13); XCTAssertEqual(unreadCount, 4)
        if let out = ProcessInfo.processInfo.environment["VI_RECORD_ACTION_EXPORT"] {
            let result: [String: Any] = ["contract_sha256": courtSHA256(contractBytes), "cases": exported]
            try JSONSerialization.data(withJSONObject: result, options: [.prettyPrinted, .sortedKeys]).write(to: URL(fileURLWithPath: out))
        }
        print("T0117 differential: 17/17; 13 admitted payloads agree, including classes/words/stable view; 4 explicitly unread counterparts")
    }
    func testActionCLIEntrancesAndCheckedBytePrintingAgree() throws {
        let source = try StructuralSource(files: ["Sources/Notation/Primitive.swift", "Contracts/Court/continuation-relations-v1/action-cases.swift"].map {
            ($0, try WhereJudge.fileText(root.appendingPathComponent($0).path))
        })
        let bin = try XCTUnwrap(ProcessInfo.processInfo.environment["VI_CHECK_BUILD_BIN"])
        #if os(Windows)
        let suffix = ".exe"
        #else
        let suffix = ""
        #endif
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent("vi-record-actions-cli-" + UUID().uuidString)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        func run(_ tool: String, _ arguments: [String]) throws -> (Int32, Data) {
            let process = Process(), pipe = Pipe()
            process.executableURL = URL(fileURLWithPath: bin).appendingPathComponent(tool + suffix)
            process.arguments = arguments; process.standardOutput = pipe; process.standardError = pipe
            try process.run()
            let bytes = pipe.fileHandleForReading.readDataToEndOfFile(); process.waitUntilExit()
            return (process.terminationStatus, bytes)
        }
        for (name, expected) in [("HiddenCommon", Int32(0)), ("HiddenDisagreement", Int32(1))] {
            let old = try C.deriveRelated(name, source: source, actions: true)
            let reading = try C.relatedReading(name, certificate: old, source: source)
            let world = directory.appendingPathComponent(name + ".world.json"), proof = directory.appendingPathComponent(name + ".proof.json")
            try R.encodeActions(reading.core, actionsDeclared: old.actions != nil).write(to: world)
            let native = try run("RecordCourt", ["--actions", "--certificate", proof.path, world.path])
            let facade = try run("Tools", ["judge", "continue", "--record", "--actions", world.path])
            XCTAssertEqual(native.0, expected); XCTAssertEqual(facade.0, expected)
            XCTAssertEqual(native.1, facade.1)
            let object = try JSONSerialization.jsonObject(with: Data(contentsOf: proof))
            let compact = try JSONSerialization.data(withJSONObject: object, options: [.sortedKeys])
            for bytes in [compact, compact + Data("\n".utf8)] {
                try bytes.write(to: proof)
                let replay = try run("RecordCourt", ["replay", "--actions", proof.path, world.path])
                let replayFacade = try run("Tools", ["judge", "replay-continuation", "--record", "--actions", proof.path, world.path])
                XCTAssertEqual(replay.0, expected); XCTAssertEqual(replayFacade.0, expected)
                XCTAssertEqual(replay.1, compact + Data("\n".utf8)); XCTAssertEqual(replayFacade.1, replay.1)
            }
        }
        let schema1 = directory.appendingPathComponent("schema1.world.json"), proof1 = directory.appendingPathComponent("schema1.proof.json")
        let reading1 = ContinuationCore.Reading(whole: .init(source: .pair(.leaf("S"), .leaf("S")), edges: []), observation: .leaf([.left]), question: .leaf([.right]))
        let bytes1 = try R.encode(reading1); try bytes1.write(to: schema1)
        let world1 = try R.read(bytes1)
        for retain in [false, true] {
            let value = try JSONSerialization.jsonObject(with: R.encodeCertificate(R.derive(world1, retain: retain)))
            let compact = try JSONSerialization.data(withJSONObject: value, options: [.sortedKeys])
            let flags = retain ? ["--retain"] : []
            for bytes in [compact, compact + Data("\n".utf8)] {
                try bytes.write(to: proof1)
                let native = try run("RecordCourt", ["replay"] + flags + [proof1.path, schema1.path])
                let facade = try run("Tools", ["judge", "replay-continuation", "--record"] + flags + [proof1.path, schema1.path])
                XCTAssertEqual(native.0, retain ? 0 : 1); XCTAssertEqual(native.0, facade.0)
                XCTAssertEqual(native.1, compact + Data("\n".utf8)); XCTAssertEqual(native.1, facade.1)
            }
        }
    }
}
