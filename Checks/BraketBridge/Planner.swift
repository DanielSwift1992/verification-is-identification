import Foundation
import VerificationIsIdentification

// Finite fiber optimization for the declared classical joint law (IiS46).
// This is a named executable interpretation, not a new VI proof kernel.
struct Plan {
    let decisions: [String:String]
    let loss: Int, total: Int
    let witness: [Int]?
    var exact: Bool { loss == 0 }
}
func derive(_ m: Model) throws -> Plan {
    let choices = m.question == "State" ? ["I","X","Y","Z"] : ["0","1"]
    var counts: [String:[String:Int]] = [:]
    for i in 0..<16 where m.weights[i]>0 {
        counts[m.records[i],default:[:]][m.answers[i],default:0] += m.weights[i]
    }
    var chosen: [String:String] = [:], success = 0
    for key in counts.keys.sorted() {
        let c=counts[key]!
        let answer=choices.max { a,b in
            let ca=c[a,default:0],cb=c[b,default:0]
            return ca == cb ? choices.firstIndex(of:a)! > choices.firstIndex(of:b)! : ca<cb
        }!
        chosen[key]=answer; success += c[answer,default:0]
    }
    var witness: [Int]? = nil
    outer: for i in 0..<16 where m.weights[i]>0 {
        for j in (i+1)..<16 where m.weights[j]>0 {
            if m.records[i] == m.records[j] && m.answers[i] != m.answers[j] {
                witness=[i,j]; break outer
            }
        }
    }
    let total=m.weights.reduce(0,+)
    return Plan(decisions:chosen,loss:total-success,total:total,witness:witness)
}
func nested(_ xs: [String]) -> String {
    xs.reversed().reduce("Never") { "Paired<\($1),\($0)>" }
}
func token(_ a: String) -> String { a == "0" || a == "1" ? "QBit\(a)" : "Q\(a)" }
func entryName(_ name: String,_ key: String) -> String { "D_\(name)_\(key.isEmpty ? "empty" : key)" }
func certificate(_ m: Model,_ p: Plan) -> String {
    var text="// \(m.name): \(p.exact ? "exact row applications" : "record binding only; numerical bound is not a Swift theorem")\n"
    for key in p.decisions.keys.sorted() {
        let kt=nested(key.map { "QBit\($0)" })
        text += "typealias \(entryName(m.name,key)) = Decision<\(kt),\(token(p.decisions[key]!))>\n"
    }
    for i in 0..<16 {
        let cname="C_\(m.name)_row\(i)"
        if m.weights[i] == 0 {
            text += "enum \(cname): Null { typealias Left = \(m.name).Source.Right.Row\(i); typealias Right = Never }\n"
        } else {
            let cols=(0..<m.acquisitions.count).map { j in
                m.name+".Records."+String(repeating:"Right.",count:j)+"Left.Table.Row\(i)"
            }
            let actualKey=nested(cols),entry=entryName(m.name,m.records[i])
            if p.exact {
                text += "enum \(cname): Null { typealias Left = Paired<\(actualKey),\(m.name).Answer.Row\(i)>; typealias Right = Paired<\(entry).Left,\(entry).Right> }\n"
            } else {
                text += "enum \(cname): Null { typealias Left = \(actualKey); typealias Right = \(entry).Left }\n"
            }
        }
    }
    return text
}
func checkedEmitter(_ models: [Model],_ plans:[Plan], extraEmission: String = "") -> String {
    var s="import Foundation\nimport VerificationIsIdentification\n@main struct CheckedExport { static func main() throws {\n var output:[[String:Any]]=[]; var checkedSources:[[String:Any]]=[]\n"
    for (m,p) in zip(models,plans) {
        s += "do { let m = try model(\(m.name).self,name:\"\(m.name)\"); var d:[String:String]=[:]\n"
        for k in p.decisions.keys.sorted() {
            s += "let e_\(k.isEmpty ? "empty" : k) = try decision(\(entryName(m.name,k)).self); d[e_\(k.isEmpty ? "empty" : k).0]=e_\(k.isEmpty ? "empty" : k).1\n"
        }
        // Recompute bound from current typed model and insist checked decisions still
        // attain it. No stale phase-one JSON is used for executable continuation.
        s += "checkedSources.append(m.json); let current=try derive(m); try demand(current.decisions == d,\"Decoder changed after row checking\"); try demand(current.exact == \(p.exact),\"Exactness changed: regenerate row applications\"); output.append([\"name\":m.name,\"question\":m.question,\"record_count\":m.acquisitions.count,\"decisions\":d,\"execution\":try execution(question:m.question,decisions:d,recordCount:m.acquisitions.count),\"exact\":current.exact,\"loss_numerator\":current.loss,\"loss_denominator\":current.total]) }\n"
    }
    s += "let dir=URL(fileURLWithPath:CommandLine.arguments[1]).deletingLastPathComponent().path\ntry writeJSON([\"schema\":\"vi.braket.sources.v1\",\"control_count\":4,\"models\":checkedSources],to:dir+\"/sources.json\")\n"
    s += extraEmission
    s += "try writeJSON([\"schema\":\"vi.braket.continuations.v1\",\"plans\":output],to:CommandLine.arguments[1])\n} }\n"
    return s
}
