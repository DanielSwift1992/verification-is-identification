// Observation bridge only: compile with the pinned Sources/Court/*.swift.
// This exports existing typed Court data, never parses Swift or proves the bridge.
import Foundation

typealias C = ContinuationCourt
func path(_ p: C.Path) -> String { "[" + p.map { $0 == .left ? "false" : "true" }.joined(separator: ", ") + "]" }
func list(_ xs: [String]) -> String { "[" + xs.joined(separator: ", ") + "]" }
func places(_ p: C.Places) -> String {
    switch p {
    case let .leaf(p): return "(.leaf \(path(p)))"
    case let .pair(l, r): return "(.pair \(places(l)) \(places(r)))"
    }
}
func shape(_ t: C.Shape, _ sorts: [String]) -> String {
    switch t {
    case let .leaf(s): return "(.leaf \(sorts.firstIndex(where: { WhereJudge.sameName($0, s) })!))"
    case let .pair(l, r): return "(.pair \(shape(l, sorts)) \(shape(r, sorts)))"
    }
}
func program(_ p: C.Program) -> String {
    switch p {
    case let .pick(p): return "(.leaf \(path(p)))"
    case let .pair(l, r): return "(.pair \(program(l)) \(program(r)))"
    }
}
func basis(_ b: C.EqualityBasis) -> String {
    switch b {
    case .address: return ".address"
    case .observedValues: return ".observedValues"
    case let .sourceRelation(steps):
        return "(.sourceRelation \(list(steps.map { "⟨\(path($0.edge)), \($0.reversed)⟩" })))"
    }
}
func construction(_ selections: [C.Selection], _ p: C.Program) -> String {
    "⟨\(list(selections.map { "⟨\(path($0.output)), \(path($0.input)), \(basis($0.basis))⟩" })), \(program(p))⟩"
}

func edges(_ es: [C.SourceEdge]) -> String { list(es.map { "⟨\(path($0.address)), \(path($0.left)), \(path($0.right))⟩" }) }
func model(_ source: C.Shape, _ observation: C.Places, _ question: C.Places, _ es: [C.SourceEdge], _ sorts: [String]) -> String {
    "⟨\(shape(source, sorts)), \(places(observation)), \(places(question)), \(edges(es))⟩"
}
func classes(_ cs: [C.PartitionClass], _ sorts: [String]) -> String {
    list(cs.map { c in "⟨\(sorts.firstIndex(where: { WhereJudge.sameName($0, c.sort) }) ?? sorts.count), \(list(c.leaves.map(path)))⟩" })
}
func forest(_ fs: [[C.EqualityStep]]) -> String {
    list(fs.map { list($0.map { "⟨\(path($0.edge)), \($0.reversed)⟩" }) })
}
func imageCert(_ c: C.ImageCertificate, _ sorts: [String]) -> String {
    let images = list(c.images.map { i -> String in
        let promise: String
        switch i.promise {
        case let .holds(bs): promise = "(.holds \(list(bs.map(basis))))"
        case let .violated(e): promise = "(.violated \(path(e)))"
        }
        return "⟨\(path(i.member)), \(classes(i.classes, sorts)), \(list(i.sourceClassIndices.map(String.init))), \(list(i.connections.map { list($0.map(basis)) })), \(promise)⟩"
    })
    return "⟨\(classes(c.classes, sorts)), \(forest(c.connections)), \(images)⟩"
}
func agreementCert(_ c: C.AgreementCertificate, _ sorts: [String]) -> String {
    let conclusion: String
    switch c.conclusion {
    case let .constructed(p):
        let needed = list(p.needed.map { "⟨\($0.block), \(list($0.questions.map(path)))⟩" })
        let residual = p.residual.map { "(some \(program($0)))" } ?? "none"
        let capacities = list(p.capacities.sorted { sorts.firstIndex(of: $0.sort.text)! < sorts.firstIndex(of: $1.sort.text)! }.map { k in
            "⟨\(sorts.firstIndex(of: k.sort.text)!), \(k.requiredClasses), \(k.outputClasses), \(k.fixedRequiredClasses), \(k.freeOutputClasses), \(k.minimumResidualLeaves)⟩"
        })
        conclusion = "(.constructed ⟨\(list(p.assignments.map(path))), \(program(p.step)), \(list(p.bindingBases.map(basis))), \(needed), \(list(p.residualLeaves.map(path))), \(residual), \(construction(p.selections, p.decoder)), \(capacities)⟩)"
    case let .unavailable(p): conclusion = "(.unavailable \(path(p)))"
    case let .wrongSort(p): conclusion = "(.wrongSort \(path(p)))"
    case let .incompatible(a,b): conclusion = "(.incompatible \(path(a)) \(path(b)))"
    }
    return "⟨\(classes(c.classes, sorts)), \(forest(c.connections)), \(classes(c.outputClasses, sorts)), \(forest(c.outputConnections)), \(conclusion)⟩"
}
@main struct ImageAgreementProbe {
    static func main() throws {
        let args = CommandLine.arguments
        precondition(args.count == 3)
        let root = args[1], out = args[2]
        try FileManager.default.createDirectory(atPath: out, withIntermediateDirectories: true)
        let dir = "Contracts/Court/continuation-relations-v1/"
        let manifest = try JSONSerialization.jsonObject(with: Data(contentsOf: URL(fileURLWithPath: root + "/" + dir + "contract.json"))) as! [String:Any]
        for section in ["image", "agreement"] {
            let spec = manifest[section] as! [String:Any]
            let rows = spec["cases"] as! [[String:Any]]
            let inputs = ["Sources/Notation/Primitive.swift", dir + (spec["fixture"] as! String)]
            let source = try StructuralSource(files: inputs.map { ($0, try WhereJudge.fileText(root + "/" + $0)) })
            var lean = "-- Finite observations, not a proved Swift bridge.\nimport U9.Certificate\nimport U10.Negative\nset_option maxRecDepth 10000\nset_option maxHeartbeats 8000000\nnamespace \(section == "image" ? "U9" : "U10").ContractCases\nopen U5\n"
            var records: [[String:Any]] = []
            for row in rows {
                let name = row["request"] as! String
                if let expectedAddress = row["address"] as? String {
                    var diagnostic = ""
                    do {
                        if section == "image" { _ = try C.deriveImage(name, source: source) }
                        else { _ = try C.deriveAgreement(name, source: source) }
                        preconditionFailure("Expected reading refusal \(name)")
                    } catch { diagnostic = String(describing: error) }
                    precondition(diagnostic.contains(expectedAddress), diagnostic)
                    records.append(["case": name, "accepted": false, "diagnostic": diagnostic, "layer": "Swift reading only"])
                    continue
                }
                if section == "image" {
                    let cert = try C.deriveImage(name, source: source)
                    let r = try C.imageReading(name, certificate: cert, source: source)
                    let sorts = NameSet(r.whole.source.leaves.map { ScalarName($0.1) }).sorted()
                    lean += "def \(name) : Model := \(model(r.whole.source, r.image, r.image, r.whole.edges, sorts))\n"
                    lean += "def \(name)Members : List U9.Member := \(list(r.members.map { "⟨\(path($0.address)), \(places($0.image))⟩" }))\n"
                    lean += "def \(name)Promise : List Edge := \(edges(r.promise))\n"
                    func emit(_ suffix: String, _ c: C.ImageCertificate) throws {
                        let id = name + suffix
                        var accepted = false, holds = false, message = ""
                        do { holds = try C.verifyImage(name, certificate: c, source: source); accepted = true }
                        catch { message = String(describing: error) }
                        if suffix.isEmpty { precondition(accepted && holds == (row["holds"] as! Bool)) }
                        else { precondition(!accepted, "Expected forgery refusal \(id)") }
                        let bytes = try C.encodeImage(c)
                        try bytes.write(to: URL(fileURLWithPath: out + "/" + id + ".json"))
                        records.append(["case":id,"accepted":accepted,"holds":holds,"diagnostic":message,"layer":"normalized certificate"])
                        lean += "def \(id)Cert : U9.Certificate := \(imageCert(c,sorts))\n"
                        lean += "theorem \(id)_observed : U9.check \(name) \(name)Members \(name)Promise \(id)Cert = \(accepted) := by decide\n"
                        if accepted { lean += "theorem \(id)_verdict : (\(id)Cert.images.all (fun p => U9.verdict p.promise)) = \(holds) := by decide\n" }
                    }
                    try emit("", cert)
                    func bad(_ suffix: String, _ edit: (inout C.ImageCertificate) -> Void) throws { var c=cert; edit(&c); try emit(suffix,c) }
                    try bad("MissingSourceClasses") { $0.classes = [] }
                    try bad("MissingSourceForests") { $0.connections = [] }
                    try bad("MissingMembers") { $0.images = [] }
                    try bad("WrongMember") { $0.images[0].member.append(.left) }
                    try bad("WrongSourceClassIndex") { $0.images[0].sourceClassIndices[0] = 999 }
                    try bad("MissingOutputClasses") { $0.images[0].classes = [] }
                    try bad("MissingOutputConnections") { $0.images[0].connections = [] }
                    if !r.promise.isEmpty {
                        try bad("WrongPromise") {
                            switch $0.images[0].promise {
                            case .holds: $0.images[0].promise = .violated(edge: r.promise[0].address)
                            case .violated: $0.images[0].promise = .holds([])
                            }
                        }
                    }
                } else {
                    let cert = try C.deriveAgreement(name, source: source)
                    let r = try C.agreementReading(name, certificate: cert, source: source)
                    let sorts = NameSet((r.whole.source.leaves + r.output.source.leaves).map { ScalarName($0.1) }).sorted()
                    let s = r.sourceReading
                    let os = C.sourcePlaces(r.output.source)
                    let bindings = list(r.bindings.map { "⟨\(path($0.address)), \(path($0.output)), \(path($0.source))⟩" })
                    lean += "def \(name) : U10.Request := ⟨\(model(s.source,s.observation,s.question,s.edges,sorts)), \(model(r.output.source,os,os,r.output.edges,sorts)), \(bindings)⟩\n"
                    func emit(_ suffix: String, _ c: C.AgreementCertificate) throws {
                        let id = name + suffix
                        var accepted=false, holds=false, message=""
                        do { holds = try C.verifyAgreement(name, certificate: c, source: source); accepted=true }
                        catch { message=String(describing:error) }
                        if suffix.isEmpty { precondition(accepted && holds == (row["refusal"] == nil)) }
                        else { precondition(!accepted, "Expected forgery refusal \(id): \(message)") }
                        try C.encodeAgreement(c).write(to: URL(fileURLWithPath: out + "/" + id + ".json"))
                        records.append(["case":id,"accepted":accepted,"holds":holds,"diagnostic":message,"layer":"normalized certificate"])
                        lean += "def \(id)Cert : U10.Certificate := \(agreementCert(c,sorts))\n"
                        lean += "theorem \(id)_observed : U10.check \(name) \(id)Cert = \(accepted) := by decide\n"
                    }
                    try emit("",cert)
                    func bad(_ suffix: String, _ edit: (inout C.AgreementCertificate) -> Void) throws { var c=cert; edit(&c); try emit(suffix,c) }
                    try bad("MissingSourceClasses") { $0.classes=[] }
                    try bad("MissingSourceForests") { $0.connections=[] }
                    try bad("MissingOutputClasses") { $0.outputClasses=[] }
                    try bad("MissingOutputForests") { $0.outputConnections=[] }
                    switch cert.conclusion {
                    case .constructed:
                        func badPlan(_ suffix: String, _ edit: (inout C.AgreementPlan) -> Void) throws {
                            try bad(suffix) { c in if case var .constructed(p) = c.conclusion { edit(&p); c.conclusion = .constructed(p) } }
                        }
                        try badPlan("WrongStep") { $0.step = .pick(Array(repeating:.left,count:40)) }
                        try badPlan("MissingAssignments") { $0.assignments=[] }
                        try badPlan("WrongCapacity") { $0.capacities[0].minimumResidualLeaves += 1 }
                        try badPlan("WrongDecoder") { $0.decoder = .pick(Array(repeating:.right,count:40)) }
                        try badPlan("MissingSelections") { $0.selections=[] }
                        if !r.bindings.isEmpty { try badPlan("MissingBindingBases") { $0.bindingBases=[] } }
                        if name == "BindOriginal" {
                            try badPlan("ViolatesPrescribedSourceButDecodes") {
                                $0.assignments = [[.right]]
                                $0.step = .pair(.pick([.right]), .pick([.right]))
                                $0.needed = [.init(block: 0, questions: [[.left]])]
                                $0.residualLeaves = [[.left]]
                                $0.residual = .pick([.left])
                                $0.selections = [.init(output: [.left], input: [.right], basis: .address),
                                                 .init(output: [.right], input: [.left,.left], basis: .address)]
                                $0.decoder = .pair(.pick([.right]), .pick([.left,.left]))
                            }
                        }
                        if case let .constructed(p) = cert.conclusion, !p.residualLeaves.isEmpty {
                            try badPlan("MissingResidual") { $0.residual=nil }
                            try badPlan("RepeatedResidualLeaf") { $0.residualLeaves.append($0.residualLeaves[0]) }
                        }
                    case .unavailable: try bad("FalseUnavailable") { $0.conclusion = .unavailable(output: Array(repeating:.left,count:40)) }
                    case .wrongSort: try bad("UnknownBinding") { $0.conclusion = .wrongSort(binding: Array(repeating:.left,count:40)) }
                    case let .incompatible(a,_): try bad("SameBinding") { $0.conclusion = .incompatible(left:a,right:a) }
                    }
                }
            }
            lean += "end \(section == "image" ? "U9" : "U10").ContractCases\n"
            try lean.write(toFile:out + "/" + section + "-ContractCases.lean",atomically:true,encoding:.utf8)
            try JSONSerialization.data(withJSONObject: records, options:[.sortedKeys,.prettyPrinted]).write(to:URL(fileURLWithPath:out + "/" + section + "-observations.json"))
            print("\(section): \(rows.count) contract cases, \(records.count) observations")
        }
    }
}
