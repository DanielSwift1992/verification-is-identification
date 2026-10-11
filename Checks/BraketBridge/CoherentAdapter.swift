// Named foreign door for the bounded exact two-block source language.
import Foundation
import VerificationIsIdentification

func coherentPhase<K: Structure>(_ type: K.Type) throws -> Int {
    if type == CoherentPhase0.self { return 0 }
    if type == CoherentPhase1.self { return 1 }
    if type == CoherentPhase2.self { return 2 }
    if type == CoherentPhase3.self { return 3 }
    throw BridgeError.unsupported("Uninterpreted coherent phase")
}
func coherentBlock<B: CoherentBlock>(_ type: B.Type) throws -> [String:Any] {
    let word: String
    if B.Word.self == CoherentI<CoherentPhase0>.Word.self { word="I" }
    else if B.Word.self == CoherentX<CoherentPhase0>.Word.self { word="X" }
    else if B.Word.self == CoherentZ<CoherentPhase0>.Word.self { word="Z" }
    else if B.Word.self == CoherentXZ<CoherentPhase0>.Word.self { word="XZ" }
    else { throw BridgeError.unsupported("Uninterpreted coherent block word") }
    return ["phase":try coherentPhase(B.Phase.self),"word":word]
}
protocol EmitCoherentIdeal: CoherentIdeal { static var word: [String] { get } }
extension CoherentIdealEmpty: EmitCoherentIdeal { static var word: [String] { [] } }
extension CoherentIdealH: EmitCoherentIdeal where T: EmitCoherentIdeal {
    static var word: [String] { T.word + ["h"] }
}
extension CoherentIdealS1: EmitCoherentIdeal where T: EmitCoherentIdeal {
    static var word: [String] { T.word + ["s"] }
}
extension CoherentIdealS2: EmitCoherentIdeal where T: EmitCoherentIdeal {
    static var word: [String] { T.word + ["s","s"] }
}
extension CoherentIdealS3: EmitCoherentIdeal where T: EmitCoherentIdeal {
    static var word: [String] { T.word + ["s","s","s"] }
}
protocol EmitCoherentProgram: CoherentProgram {
    static func operations() throws -> [[String:Any]]
}
extension CoherentSourceStart: EmitCoherentProgram {
    static func operations() throws -> [[String:Any]] { [] }
}
extension CoherentH: EmitCoherentProgram where P: EmitCoherentProgram {
    static func operations() throws -> [[String:Any]] { try P.operations()+[["gate":"h"]] }
}
extension CoherentS: EmitCoherentProgram where P: EmitCoherentProgram {
    static func operations() throws -> [[String:Any]] { try P.operations()+[["gate":"s"]] }
}
extension CoherentCZ: EmitCoherentProgram where P: EmitCoherentProgram {
    static func operations() throws -> [[String:Any]] { try P.operations()+[["gate":"cz","memory":"source-M"]] }
}
extension CoherentCX: EmitCoherentProgram where P: EmitCoherentProgram {
    static func operations() throws -> [[String:Any]] { try P.operations()+[["gate":"cx","memory":"source-M"]] }
}
extension CoherentPublicX0: EmitCoherentProgram where P: EmitCoherentProgram {
    static func operations() throws -> [[String:Any]] { try P.operations()+[["gate":"public_x","value":0]] }
}
extension CoherentPublicX1: EmitCoherentProgram where P: EmitCoherentProgram {
    static func operations() throws -> [[String:Any]] { try P.operations()+[["gate":"public_x","value":1]] }
}
extension CoherentPublicZ0: EmitCoherentProgram where P: EmitCoherentProgram {
    static func operations() throws -> [[String:Any]] { try P.operations()+[["gate":"public_z","value":0]] }
}
extension CoherentPublicZ1: EmitCoherentProgram where P: EmitCoherentProgram {
    static func operations() throws -> [[String:Any]] { try P.operations()+[["gate":"public_z","value":1]] }
}
// MemoryS has mathematical semantics in the core fragment, but this external
// interface does not grant local memory gates. No emitter conformance exists.
extension CoherentWithdraw: EmitCoherentProgram where P: EmitCoherentProgram {
    static func operations() throws -> [[String:Any]] { try P.operations()+[["gate":"withdraw_memory"]] }
}
struct CoherentModel {
    let name: String, publicBit: Int, operations: [[String:Any]], ideal: [String], blocks: [[String:Any]]
    var json: [String:Any] { ["name":name,"public":publicBit,"operations":operations,"ideal":ideal,"blocks":blocks] }
}
func coherentModel<P: EmitCoherentProgram>(_ root: P.Type, name: String) throws -> CoherentModel {
    guard let ideal=P.Ideal.self as? any EmitCoherentIdeal.Type else { throw BridgeError.unsupported("Uninterpreted ideal word") }
    let publicBit=try bit(P.Public.self)
    return try CoherentModel(name:name,publicBit:publicBit == "1" ? 1:0, operations:P.operations(),ideal:ideal.word,
        blocks:[coherentBlock(P.Block0.self),coherentBlock(P.Block1.self)])
}
struct CoherentCase { let source: CoherentModel, candidates: [CoherentModel] }
struct CoherentChoice {
    let goal: String, source: CoherentModel, candidate: CoherentModel, suffix: [[String:Any]], interactions: Int
}
func chooseCoherent(_ entry: CoherentCase, goal: String) throws -> CoherentChoice {
    try demand(goal == "data" || goal == "joint", "Unsupported coherent output")
    var eligible=[CoherentChoice]()
    for candidate in entry.candidates {
        let prefix=Array(candidate.operations.prefix(entry.source.operations.count))
        try demand(candidate.publicBit == entry.source.publicBit && (prefix as NSArray).isEqual(to:entry.source.operations),
                   "Candidate does not continue this source")
        // A failed ideal normalization is unproved in this fragment, not a
        // claim that the represented unitary is physically different.
        if candidate.ideal != ["h"] || !candidate.blocks.allSatisfy({$0["word"] as? String == "I"}) { continue }
        if goal == "joint" && candidate.blocks[0]["phase"] as? Int != candidate.blocks[1]["phase"] as? Int { continue }
        let suffix=Array(candidate.operations.dropFirst(entry.source.operations.count))
        let interactions=suffix.filter { ["cx","cz"].contains($0["gate"] as? String ?? "") }.count
        eligible.append(CoherentChoice(goal:goal,source:entry.source,candidate:candidate,suffix:suffix,interactions:interactions))
    }
    guard let chosen=eligible.min(by: { a,b in a.interactions == b.interactions ? a.suffix.count < b.suffix.count : a.interactions < b.interactions }) else {
        throw BridgeError.unsupported("No certified candidate in this finite catalogue")
    }
    return chosen
}
