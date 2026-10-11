// Named foreign interpretation boundary for QuantumContinuation.swift.
// No parser, type-name semantics, fallback Pair interpretation, or hidden valuation.
import Foundation
import VerificationIsIdentification

enum BridgeError: Error { case unsupported(String), invalid(String) }
func demand(_ condition: Bool, _ message: String) throws {
    if !condition { throw BridgeError.invalid(message) }
}
func bit<T: QuantumBit>(_ t: T.Type) throws -> String {
    if t == QBit0.self { return "0" }
    if t == QBit1.self { return "1" }
    throw BridgeError.unsupported("Uninterpreted bit constructor")
}
func pauli<T: QuantumPauli>(_ t: T.Type) throws -> String {
    if t == QI.self { return "I" }; if t == QX.self { return "X" }
    if t == QY.self { return "Y" }; if t == QZ.self { return "Z" }
    throw BridgeError.unsupported("Uninterpreted Pauli constructor")
}
protocol EmitWeight { static var value: Int { get } }
extension Never: EmitWeight { static var value: Int { 0 } }
extension QuantumUnitWeight: EmitWeight { static var value: Int { 1 } }
extension Paired: EmitWeight where L: EmitWeight, R: EmitWeight {
    static var value: Int { L.value + R.value }
}
func weight<W: Structure>(_ t: W.Type) throws -> Int {
    guard let w = t as? any EmitWeight.Type else {
        throw BridgeError.unsupported("Uninterpreted weight expression")
    }
    if w.value == 0 && t != Never.self {
        throw BridgeError.unsupported("Zero weights must use canonical Never")
    }
    return w.value
}
func frameRows<F: QuantumFrameTable>(_ t: F.Type) throws -> [String] {
    try [pauli(F.Row0.self), pauli(F.Row1.self), pauli(F.Row2.self), pauli(F.Row3.self), pauli(F.Row4.self), pauli(F.Row5.self), pauli(F.Row6.self), pauli(F.Row7.self), pauli(F.Row8.self), pauli(F.Row9.self), pauli(F.Row10.self), pauli(F.Row11.self), pauli(F.Row12.self), pauli(F.Row13.self), pauli(F.Row14.self), pauli(F.Row15.self)]
}
func bitRows<B: QuantumBitTable>(_ t: B.Type) throws -> [String] {
    try [bit(B.Row0.self), bit(B.Row1.self), bit(B.Row2.self), bit(B.Row3.self), bit(B.Row4.self), bit(B.Row5.self), bit(B.Row6.self), bit(B.Row7.self), bit(B.Row8.self), bit(B.Row9.self), bit(B.Row10.self), bit(B.Row11.self), bit(B.Row12.self), bit(B.Row13.self), bit(B.Row14.self), bit(B.Row15.self)]
}
func weightRows<W: QuantumWeightTable>(_ t: W.Type) throws -> [Int] {
    try [weight(W.Row0.self), weight(W.Row1.self), weight(W.Row2.self), weight(W.Row3.self), weight(W.Row4.self), weight(W.Row5.self), weight(W.Row6.self), weight(W.Row7.self), weight(W.Row8.self), weight(W.Row9.self), weight(W.Row10.self), weight(W.Row11.self), weight(W.Row12.self), weight(W.Row13.self), weight(W.Row14.self), weight(W.Row15.self)]
}
protocol EmitProgram: QuantumProgram {
    static func operations() throws -> [[String: Any]]
}
extension QuantumStart: EmitProgram { static func operations() throws -> [[String: Any]] { [] } }
extension QuantumH: EmitProgram where P: EmitProgram {
 static func operations() throws -> [[String: Any]] { try P.operations() + [["gate": "h"]] }
}
extension QuantumS: EmitProgram where P: EmitProgram {
 static func operations() throws -> [[String: Any]] { try P.operations() + [["gate": "s"]] }
}
extension QuantumZ0: EmitProgram where P: EmitProgram {
 static func operations() throws -> [[String: Any]] { try P.operations() + [["gate": "z", "control": 0]] }
}
extension QuantumZ1: EmitProgram where P: EmitProgram {
 static func operations() throws -> [[String: Any]] { try P.operations() + [["gate": "z", "control": 1]] }
}
extension QuantumZ2: EmitProgram where P: EmitProgram {
 static func operations() throws -> [[String: Any]] { try P.operations() + [["gate": "z", "control": 2]] }
}
extension QuantumZ3: EmitProgram where P: EmitProgram {
 static func operations() throws -> [[String: Any]] { try P.operations() + [["gate": "z", "control": 3]] }
}
protocol EmitRecord: QuantumRecord {
    static func recordOperations() throws -> [Int]
}
extension RecordZero: EmitRecord { static func recordOperations() throws -> [Int] { [] } }
extension RecordToggle0: EmitRecord where R: EmitRecord {
 static func recordOperations() throws -> [Int] { try R.recordOperations() + [0] }
}
extension RecordToggle1: EmitRecord where R: EmitRecord {
 static func recordOperations() throws -> [Int] { try R.recordOperations() + [1] }
}
extension RecordToggle2: EmitRecord where R: EmitRecord {
 static func recordOperations() throws -> [Int] { try R.recordOperations() + [2] }
}
extension RecordToggle3: EmitRecord where R: EmitRecord {
 static func recordOperations() throws -> [Int] { try R.recordOperations() + [3] }
}
protocol EmitRecords: QuantumRecordList {
    static func columns() throws -> [[String]]
    static func acquisitions() throws -> [[Int]]
}
extension QuantumNoRecords: EmitRecords {
    static func columns() throws -> [[String]] { [] }
    static func acquisitions() throws -> [[Int]] { [] }
}
extension QuantumRecordsCons: EmitRecords where R: EmitRecord, Rest: EmitRecords {
    static func columns() throws -> [[String]] { try [bitRows(R.Table.self)] + Rest.columns() }
    static func acquisitions() throws -> [[Int]] { try [R.recordOperations()] + Rest.acquisitions() }
}
protocol EmitQuestion: PredicateReading {
    static var kind: String { get }
    static func answers() throws -> [String]
}
extension ReadX: EmitQuestion { static var kind: String { "X" }; static func answers() throws -> [String] { try bitRows(Answer.self) } }
extension ReadY: EmitQuestion { static var kind: String { "Y" }; static func answers() throws -> [String] { try bitRows(Answer.self) } }
extension ReadZ: EmitQuestion { static var kind: String { "Z" }; static func answers() throws -> [String] { try bitRows(Answer.self) } }
extension ReadState: EmitQuestion { static var kind: String { "State" }; static func answers() throws -> [String] { try frameRows(Answer.self) } }

struct Model {
    let name: String, question: String
    let operations: [[String: Any]], acquisitions: [[Int]], weights: [Int]
    let frames: [String], answers: [String], records: [String]
    var json: [String: Any] {
        ["name":name,"question":question,"operations":operations,"acquisitions":acquisitions,
         "rows":(0..<16).map { ["index":$0,"weight":weights[$0],"record":records[$0],"frame":frames[$0],"target":answers[$0]] as [String:Any] }]
    }
}
func model<P: EmitProgram,R: EmitRecords,Q: EmitQuestion>(
    _ root: QuantumContinuation<P,R,Q>.Type, name: String
) throws -> Model where P.Source == R.Source, Q.Left == P.Frame,
    Q.Sigma == QuantumHistorySpace, Q.Encoding == QuantumHistoryEncoding {
    let columns = try R.columns()
    try demand(columns.count <= 4, "At most four accessible record bits")
    let weights = try weightRows(P.Source.Right.self)
    try demand(weights.reduce(0,+)>0, "Empty source support")
    return try Model(name:name, question:Q.kind, operations:P.operations(),
        acquisitions:R.acquisitions(), weights:weights, frames:frameRows(P.Frame.self),
        answers:Q.answers(), records:(0..<16).map { i in columns.map { $0[i] }.joined() })
}

// These entries are not correctness markers. Their actual operands are reused
// by generated row equalities and by the only continuation emitter.
enum Decision<K: Structure,A: Structure>: Pair { typealias Left=K; typealias Right=A }
protocol EmitKey { static var key: String { get } }
extension Never: EmitKey { static var key: String { "" } }
extension QBit0: EmitKey { static var key: String { "0" } }
extension QBit1: EmitKey { static var key: String { "1" } }
extension Paired: EmitKey where L: EmitKey,R: EmitKey {
    static var key: String { L.key + R.key }
}
func decision<K: Structure & EmitKey,A: Structure>(_ d: Decision<K,A>.Type) throws -> (String,String) {
    if let b = A.self as? any QuantumBit.Type { return (K.key, try bit(b)) }
    if let p = A.self as? any QuantumPauli.Type { return (K.key, try pauli(p)) }
    throw BridgeError.unsupported("Uninterpreted answer constructor")
}
func writeJSON(_ x: Any, to path: String) throws {
    let data = try JSONSerialization.data(withJSONObject:x, options:[.prettyPrinted,.sortedKeys])
    try data.write(to:URL(fileURLWithPath:path))
}

// Interpreted physical operations of checked Decision entries. The payload
// address is local to the continuation; a Choi fixture relocates it explicitly.
func execution(question: String, decisions: [String:String], recordCount: Int) throws -> [String:Any] {
    var branches:[String:Any]=[:]
    for (key,answer) in decisions {
        if question == "State" {
            let table:[String:[String]]=["I":[],"X":["x"],"Y":["y"],"Z":["z"]]
            guard let gates=table[answer] else { throw BridgeError.unsupported("State correction") }
            branches[key] = ["gates":gates,"relabel":0]
        } else {
            try demand(answer == "0" || answer == "1", "Measurement correction bit")
            branches[key] = ["gates":[String](),"relabel":answer == "1" ? 1 : 0]
        }
    }
    let analyzer:[String]
    switch question {
    case "State","Z": analyzer=[]
    case "X": analyzer=["h"]
    case "Y": analyzer=["s","s","s","h"]
    default: throw BridgeError.unsupported("Output question")
    }
    return ["schema":"vi.braket.execution.v1","payload":0,
      "input_records":(0..<recordCount).map { "r\($0)" },"by_record":branches,
      "analyzer":analyzer,"measure_payload":question != "State",
      "output":question == "State" ? "unknown-quantum-state" : "one-classical-bit",
      "record_release":"after conditional correction/relabel; no later questions promised",
      "reference":"untouched if supplied by the caller"]
}
