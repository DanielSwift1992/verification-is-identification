// Explicit extension of the finite external door: retained control cells and
// terminal acquisitions. A cell is allocated by the very Z action it controls.
import Foundation
import VerificationIsIdentification

extension RetainedQuantumZ1: EmitProgram where P: EmitProgram {
    static func operations() throws -> [[String:Any]] {
        let prefix=try P.operations()
        let slot=prefix.filter { $0["gate"] as? String == "retained_z" }.count
        return prefix + [["gate":"retained_z","control":1,"cell":slot]]
    }
}
extension DestroyResidents: EmitProgram where P: EmitProgram {
    static func operations() throws -> [[String:Any]] {
        try P.operations() + [["gate":"withdraw_residents"]]
    }
}
protocol EmitAcquisition: AcquiresAnswer { static func controlIndices() throws -> [Int] }
extension AcquireFirstResident: EmitAcquisition where P: EmitProgram {
    static func controlIndices() throws -> [Int] {
        let resident=try currentResident(P.operations())
        try demand(resident.control == 1, "Only the retained Z1 producer is interpreted")
        return [resident.control]
    }
}
extension ContactReplyRecord: EmitRecord where A: EmitAcquisition {
    static func recordOperations() throws -> [Int] { try A.controlIndices() }
}

struct ContactOption {
    let id: String, cell: Int, after: Model
}
struct AcquisitionRequest {
    let name: String, before: Model, contacts: [ContactOption]
}
// Both sides come from the same acquisition constructor. Names only identify
// exported declarations; matching names does not establish this relationship.
func contactRequest<P: QuantumResidentProgram & EmitProgram, R: EmitRecords, Q: EmitQuestion>(
    _ root: ContactAugmented<P,R,Q>.Type, name: String, beforeName: String, afterName: String
) throws -> AcquisitionRequest where R.Source == P.Source, Q.Left == P.Frame,
    Q.Sigma == QuantumHistorySpace, Q.Encoding == QuantumHistoryEncoding,
    P.Residents: Pair, P.Residents.Left: HasVerdict,
    P.Residents.Left.Answer: QuantumBitTable,
    P.Residents.Left.Sigma == QuantumHistorySpace,
    P.Residents.Left.Encoding == QuantumHistoryEncoding {
    let before=try model(root.Base.self,name:beforeName)
    let after=try model(root.Continuation.self,name:afterName)
    return try AcquisitionRequest(name:name,before:before,
        contacts:[ContactOption(id:"first-current-resident",cell:currentCell(before.operations),after:after)])
}
func currentResident(_ operations: [[String:Any]]) throws -> (cell: Int, control: Int) {
    var cells=[(cell: Int, control: Int)]()
    for op in operations {
        switch op["gate"] as? String {
        case "retained_z":
            guard let cell=op["cell"] as? Int, let control=op["control"] as? Int else { throw BridgeError.invalid("Missing producer cell/control") }
            cells.insert((cell,control),at:0)
        case "withdraw_residents": cells=[]
        case "h","s","z": break
        default: throw BridgeError.unsupported("Resident preservation not established")
        }
    }
    guard let first=cells.first else { throw BridgeError.unsupported("No current resident contact") }
    return first
}
func currentCell(_ operations: [[String:Any]]) throws -> Int {
    try currentResident(operations).cell
}
// Phase-two requests must use models already re-read and checked by this
// consumer. A new or redirected request cannot bypass the row applications.
func checkedAcquisitionRequests(_ requests: [AcquisitionRequest], sources: [[String:Any]]) throws -> [[String:Any]] {
    var registry=[String:NSDictionary]()
    for source in sources {
        guard let name=source["name"] as? String else { throw BridgeError.invalid("Unnamed checked source") }
        try demand(registry[name] == nil, "Duplicate checked source")
        registry[name]=source as NSDictionary
    }
    for request in requests {
        for m in [request.before]+request.contacts.map({$0.after}) {
            guard let checked=registry[m.name] else { throw BridgeError.invalid("Request has no checked source") }
            try demand(checked.isEqual(to:m.json), "Request differs from checked source")
        }
        for option in request.contacts {
            let resident=try currentResident(request.before.operations)
            try demand(option.id == "first-current-resident" && option.cell == resident.cell,
                       "Contact differs from current resident")
            let before=request.before, after=option.after
            let recordsExtend=after.records.count == before.records.count && zip(after.records,before.records).allSatisfy { new,old in
                new.count == old.count+1 && (new.first == "0" || new.first == "1") && String(new.dropFirst()) == old
            }
            try demand(after.question == before.question &&
                       (after.operations as NSArray).isEqual(to:before.operations) &&
                       after.weights == before.weights && after.frames == before.frames && after.answers == before.answers &&
                       after.acquisitions == [[resident.control]]+before.acquisitions && recordsExtend,
                       "Contact does not refine this source question")
        }
    }
    return try requests.map(chooseAcquisition)
}
func chooseAcquisition(_ request: AcquisitionRequest) throws -> [String:Any] {
    let base=try derive(request.before)
    if base.exact {
        let backend=request.before.question == "State" ? "unitary_quantum_continuation" : "terminal_measurement"
        return ["name":request.name,"before":request.before.name,"selected":request.before.name,
          "action":"skip","contacts":0,"backend":backend,"reason":"existing record suffices"]
    }
    for option in request.contacts {
        let after=try derive(option.after)
        if after.exact {
            let backend=request.before.question == "State" ? "unsupported_live_quantum_feedback" : "terminal_measurement"
            return ["name":request.name,"before":request.before.name,"selected":option.after.name,
              "action":"acquire","contact_id":option.id,"cell":option.cell,"contacts":1,
              "backend":backend,"reason":"reply refines every nonempty record fiber"]
        }
    }
    return ["name":request.name,"before":request.before.name,"selected":request.before.name,
      "action":"unavailable","contacts":0,"backend":"bounded_only",
      "reason":"no declared contact makes the requested output exact"]
}
