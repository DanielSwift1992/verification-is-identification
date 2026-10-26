// Qualification only: export the existing Swift reader's typed objects.
import Foundation
import ContinuationRecord

typealias C = ContinuationCourt
typealias K = ContinuationCore
typealias R = RecordExtension
func object<T: Encodable>(_ value: T) throws -> Any { try JSONSerialization.jsonObject(with:JSONEncoder().encode(value)) }
func normalized(_ value: Any, sorts: [String]?, key: String = "") -> Any {
    if let s=value as? String, key == "sort", let sorts {
        return String(sorts.firstIndex(where: { K.sameSort($0,s) })!)
    }
    if let d=value as? [String:Any] { return d.mapValues { $0 }.reduce(into:[String:Any]()) { out,p in out[p.key]=normalized(p.value,sorts:sorts,key:p.key) } }
    if let a=value as? [Any] {
        let result=a.map { normalized($0,sorts:sorts) }
        if key == "capacities" { return result.sorted { Int(($0 as! [String:Any])["sort"] as! String)! < Int(($1 as! [String:Any])["sort"] as! String)! } }
        return result
    }
    return value
}
func sortNames(_ shapes: [K.Shape]) -> [String] {
    var result: [String]=[]
    for s in shapes.flatMap({ $0.leaves.map(\.1) }) where !result.contains(where: { K.sameSort($0,s) }) { result.append(s) }
    return result
}
func bindingCut(_ bs: [C.LeafBinding], source: Bool, at: K.Path = []) -> K.Places {
    if let b=bs.first(where: { $0.address == at }) { return .leaf(source ? b.source : b.output) }
    precondition(at.count<128 && !bs.isEmpty)
    return .pair(bindingCut(bs,source:source,at:at+[.left]),bindingCut(bs,source:source,at:at+[.right]))
}
@main struct RecordRestProbe {
    static func main() throws {
        let args=CommandLine.arguments; precondition(args.count==3)
        let root=args[1], out=args[2]
        precondition(!FileManager.default.fileExists(atPath:out),"Output must be absent")
        try FileManager.default.createDirectory(atPath:out,withIntermediateDirectories:true)
        let dir="Contracts/Court/continuation-relations-v1/"
        let manifest=try JSONSerialization.jsonObject(with:Data(contentsOf:URL(fileURLWithPath:root+"/"+dir+"contract.json"))) as! [String:Any]
        var rows:[[String:Any]]=[]
        for section in ["image","agreement","repetition"] {
            let spec=manifest[section] as! [String:Any], cases=spec["cases"] as! [[String:Any]]
            let inputs=["Sources/Notation/Primitive.swift",dir+(spec["fixture"] as! String)]
            let source=try StructuralSource(files:inputs.map { ($0,try WhereJudge.fileText(root+"/"+$0)) })
            for row in cases {
                let name=row["request"] as! String, id=section+"-"+name
                let mode: R.Mode = section == "image" ? .image : section == "agreement" ? .agreement : .repeats
                if let expected=row["address"] as? String {
                    var message=""
                    do {
                        if section == "image" { _=try C.deriveImage(name,source:source) }
                        else if section == "agreement" { _=try C.deriveAgreement(name,source:source) }
                        else { _=try C.deriveRelated(name,source:source,repeats:true) }
                        preconditionFailure("Expected Swift reading refusal: "+name)
                    } catch { message=String(describing:error) }
                    precondition(message.contains(expected),message)
                    rows.append(["id":id,"request":name,"section":section,"mode":mode.rawValue,"sourceRefusal":message,"expectedCode":2,"layer":"unread counterpart"])
                    continue
                }
                let bytes: Data, old: Any, oldHolds: Bool, sorts: [String]
                if section == "image" {
                    let c=try C.deriveImage(name,source:source), r=try C.imageReading(name,certificate:c,source:source)
                    bytes=R.encodeImage(whole:r.whole,image:r.image,promise:c.promise == nil ? nil : r.promise,hiddenActions:c.hiddenActions == nil ? nil : r.members)
                    old=try object(K.ImageJudgment(classes:c.classes,connections:c.connections,images:c.images))
                    oldHolds=try C.verifyImage(name,certificate:c,source:source); sorts=sortNames([r.whole.source])
                } else if section == "agreement" {
                    let c=try C.deriveAgreement(name,source:source), r=try C.agreementReading(name,certificate:c,source:source)
                    bytes=try R.encodeAgreement(whole:r.whole,output:r.output,question:r.question,promiseDeclared:c.promise != nil,
                        boundOutputs:c.boundOutputs == nil ? nil : bindingCut(r.bindings,source:false),
                        boundSources:c.boundSources == nil ? nil : bindingCut(r.bindings,source:true))
                    old=try object(K.AgreementJudgment(classes:c.classes,connections:c.connections,outputClasses:c.outputClasses,outputConnections:c.outputConnections,conclusion:c.conclusion))
                    oldHolds=try C.verifyAgreement(name,certificate:c,source:source); sorts=sortNames([r.whole.source,r.output.source])
                } else {
                    let c=try C.deriveRelated(name,source:source,repeats:true), r=try C.relatedReading(name,certificate:c,source:source)
                    bytes=try RecordContinuation.encodeActions(r.core,actionsDeclared:c.actions != nil)
                    old=try object(c.repetition!); oldHolds=try C.verifyRelatedRepetition(name,certificate:c,source:source); sorts=sortNames([r.source])
                }
                let w=try R.read(bytes,mode:mode), proof=try R.derive(w), holds=try R.verify(proof,world:w)
                precondition(holds==oldHolds,"verdict differs "+id)
                let fresh: Any
                switch w.question {
                case .image: fresh=try object(proof.image!)
                case .agreement: fresh=try object(proof.agreement!)
                case .repeats: fresh=try object(proof.repetition!)
                }
                let a=try JSONSerialization.data(withJSONObject:normalized(old,sorts:sorts),options:[.sortedKeys])
                let b=try JSONSerialization.data(withJSONObject:normalized(fresh,sorts:nil),options:[.sortedKeys])
                precondition(a==b,"normalized certificate differs "+id)
                try bytes.write(to:URL(fileURLWithPath:out+"/"+id+".world.json"))
                try R.encodeCertificate(proof).write(to:URL(fileURLWithPath:out+"/"+id+".proof.json"))
                rows.append(["id":id,"request":name,"section":section,"mode":mode.rawValue,"expectedCode":holds ? 0 : 1,
                    "normalizedPayloadsEqual":true,"sortRenaming":sorts,"layer":"admitted correspondence"])
            }
        }
        // Record-only witnesses for the new entrance's explicit boundary.
        func extra(_ id: String,_ bytes: Data,_ mode: R.Mode) throws {
            let w=try R.read(bytes,mode:mode), p=try R.derive(w)
            let holds = try R.verify(p,world:w)
            precondition(holds)
            try bytes.write(to:URL(fileURLWithPath:out+"/"+id+".world.json"))
            try R.encodeCertificate(p).write(to:URL(fileURLWithPath:out+"/"+id+".proof.json"))
            rows.append(["id":id,"request":id,"mode":mode.rawValue,"expectedCode":0,"layer":"record-only witness"])
        }
        func chain(_ n: Int) -> K.Shape { n == 11 ? .leaf("S11") : .pair(.leaf("S\(n)"),chain(n+1)) }
        let many=chain(0)
        try extra("RecordAgreementTwelveSorts",R.encodeAgreement(whole:.init(source:many,edges:[]),output:.init(source:many,edges:[]),question:K.sourcePlaces(many),promiseDeclared:false),.agreement)
        let tree: K.Shape = .pair(.leaf("S"),.pair(.leaf("S"),.leaf("S")))
        let q=K.sourcePlaces(tree)
        let repeatReading=K.Reading(whole:.init(source:tree,edges:[.init(address:[],left:[.left],right:[.right,.left])]),
            observation:.leaf([.left]),question:q,
            actions:[.init(address:[],image:.pair(.leaf([.left]),.pair(.leaf([.right,.right]),.leaf([.right,.right]))))],
            hiddenActions:[.init(address:[],image:q)])
        try extra("RecordRepeatWithoutU7",RecordContinuation.encodeActions(repeatReading),.repeats)
        try JSONSerialization.data(withJSONObject:rows,options:[.prettyPrinted,.sortedKeys]).write(to:URL(fileURLWithPath:out+"/worlds.json"))
        print("\(rows.count) rows; complete normalized payload comparison, not a proof of either reader")
    }
}
