import Foundation

func coherentCertificates(_ choices: [CoherentChoice]) -> String {
    var source="import VerificationIsIdentification\n"
    for choice in choices {
        let witness=choice.goal == "data" ? "CoherentDataWitness" : "CoherentJointWitness"
        source += "typealias Checked_\(choice.goal)_\(choice.source.publicBit) = \(witness)<\(choice.candidate.name)>\n"
    }
    // Positive nonzero common phase: this would fail an unnecessarily strong
    // rule demanding zero phase instead of equality within the quantum pair.
    source += "typealias Checked_CommonPhase = CoherentJointWitness<CohCommon1>\n"
    return source
}
func coherentCheckedEmitter(_ choices: [CoherentChoice]) -> String {
    var s="import Foundation\nimport VerificationIsIdentification\n@main struct CheckedCoherentExport { static func main() throws {\nlet dir=CommandLine.arguments[1]; let current=try coherentCases(); var plans:[[String:Any]]=[]\n"
    for choice in choices {
        let r=choice.source.publicBit, goal=choice.goal
        s += "do { let m=try coherentModel(Checked_\(goal)_\(r).Program.self,name:\"\(choice.candidate.name)\"); guard let entry=current.first(where:{$0.source.publicBit == \(r)}) else { throw BridgeError.invalid(\"Missing current coherent source\") }; let c=try chooseCoherent(entry,goal:\"\(goal)\"); try demand((m.json as NSDictionary).isEqual(to:c.candidate.json),\"Coherent choice changed after witness checking\"); plans.append([\"public\":m.publicBit,\"goal\":\"\(goal)\",\"candidate\":m.name,\"source\":c.source.name,\"source_operations\":c.source.operations,\"correction_operations\":c.suffix,\"ideal\":m.ideal,\"blocks\":m.blocks,\"interactions\":c.interactions,\"measurements\":0,\"memory\":\"source-M\"] as [String:Any]) }\n"
    }
    s += "_ = Checked_CommonPhase.self\ntry writeJSON([\"schema\":\"vi.coherent.models.v1\",\"models\":current.flatMap{$0.candidates}.map{$0.json}],to:dir+\"/coherent-models.json\")\ntry writeJSON([\"schema\":\"vi.coherent.continuations.v1\",\"plans\":plans],to:dir+\"/coherent-continuations.json\")\n} }\n"
    return s
}
@main struct CoherentExport {
    static func main() throws {
        let dir=CommandLine.arguments[1], entries=try coherentCases()
        let choices=try entries.flatMap { entry in try [chooseCoherent(entry,goal:"data"),chooseCoherent(entry,goal:"joint")] }
        try coherentCertificates(choices).write(toFile:dir+"/CoherentCertificates.swift",atomically:true,encoding:.utf8)
        try coherentCheckedEmitter(choices).write(toFile:dir+"/CheckedCoherentExport.swift",atomically:true,encoding:.utf8)
        try writeJSON(["schema":"vi.coherent.proposals.v1","choices":choices.map { ["public":$0.source.publicBit,"goal":$0.goal,"candidate":$0.candidate.name,"interactions":$0.interactions] as [String:Any] }],to:dir+"/coherent-proposals.json")
    }
}
