import Foundation
import XCTest
import ContinuationRecord

final class ContinuationRecordActionsAdmissionTests: XCTestCase {
    typealias C = ContinuationCore
    typealias R = RecordContinuation
    func testMissingAndExplicitEmptyFamiliesAndWriterDoNotDropAxes() throws {
        let source: C.Shape = .pair(.leaf("S"), .leaf("S"))
        let identity = C.ActionMember(address: [], image: .pair(.leaf([.left]), .leaf([.right])))
        let empty = C.Reading(whole: .init(source: source, edges: []), observation: .leaf([.left]), question: .leaf([.right]))
        let absent = try R.read(R.encodeActions(empty, actionsDeclared: false))
        let explicit = try R.read(R.encodeActions(empty))
        XCTAssertNotEqual(absent.canonical, explicit.canonical)
        for world in [absent, explicit] {
            let proof = try R.derive(world, actions: true)
            XCTAssertTrue(try R.verify(proof, world: world, actions: true))
            XCTAssertEqual(proof.dynamics?.actions.count, 0)
            XCTAssertThrowsError(try R.verify(proof, world: world))
            XCTAssertThrowsError(try R.derive(world, retain: true, actions: true))
        }
        let withActions = C.Reading(whole: empty.whole, observation: empty.observation, question: empty.question, actions: [identity])
        XCTAssertThrowsError(try R.encode(withActions))
        XCTAssertThrowsError(try R.encodeActions(withActions, actionsDeclared: false))
        let hiddenEmpty = C.Reading(whole: empty.whole, observation: empty.observation, question: empty.question, hiddenActions: [])
        XCTAssertThrowsError(try R.encodeActions(hiddenEmpty))
        // Same image at distinct member places is permitted, independently of G.
        let hs = [C.ActionMember(address: [.left], image: identity.image), C.ActionMember(address: [.right], image: identity.image)]
        let hidden = C.Reading(whole: empty.whole, observation: empty.observation, question: empty.question, hiddenActions: hs)
        let world = try R.read(R.encodeActions(hidden, actionsDeclared: false))
        XCTAssertTrue(try R.verify(R.derive(world, actions: true), world: world, actions: true))
    }
    func testSourceDepthAndRepeatedNodeAreDifferentRefusals() throws {
        let repeated = Data("{\"schema\":1,\"source\":[{\"pair\":[1,1]},{\"sort\":0}],\"equalities\":[],\"observation\":{\"place\":[0]},\"question\":{\"place\":[1]}}".utf8)
        XCTAssertThrowsError(try R.read(repeated)) { error in
            XCTAssertTrue(String(describing: error).contains("repeated tree node"))
            XCTAssertFalse(String(describing: error).contains("depth limit"))
        }
        var nodes: [String] = []
        func build(_ depth: Int) -> Int {
            let i = nodes.count; nodes.append("")
            if depth == 0 { nodes[i] = "{\"sort\":0}" }
            else {
                let l = build(depth - 1), r = build(0)
                nodes[i] = "{\"pair\":[\(l),\(r)]}"
            }
            return i
        }
        _ = build(128)
        let deep = "{\"schema\":1,\"source\":[" + nodes.joined(separator: ",") + "],\"equalities\":[],\"observation\":{\"place\":[1]},\"question\":{\"place\":[1]}}"
        XCTAssertThrowsError(try R.read(Data(deep.utf8))) { error in
            XCTAssertTrue(String(describing: error).contains("source depth limit"))
            XCTAssertFalse(String(describing: error).contains("repeated tree node"))
        }
    }
}
