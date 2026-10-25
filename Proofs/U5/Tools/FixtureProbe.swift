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
func certificate(_ c: C.RelatedCertificate, _ r: C.RelatedReading, _ sorts: [String]) -> String {
    switch c.conclusion {
    case let .constructed(selections, p):
        let sels = list(selections.map { s in
            "⟨\(path(s.output)), \(path(s.input)), \(basis(s.basis))⟩"
        })
        return "(.constructed ⟨\(sels), \(program(p))⟩)"
    case let .obstructed(o):
        precondition(o.residue == nil)
        let classes = o.classes.map { b in
            "⟨\(sorts.firstIndex(where: { WhereJudge.sameName($0, b.sort.text) })!), \(list(b.leaves.map(path)))⟩"
        }
        return "(.obstructed ⟨\(path(o.question)), \(list(classes))⟩)"
    }
}

@main struct FixtureProbe {
    static func main() throws {
        let args = CommandLine.arguments
        precondition(args.count == 3, "FixtureProbe REPO OUTPUT_DIRECTORY")
        let root = args[1], out = args[2]
        try FileManager.default.createDirectory(atPath: out, withIntermediateDirectories: true)
        let inputs = ["Sources/Notation/Primitive.swift", "Contracts/Court/continuation-relations-v1/cases.swift"]
        let source = try StructuralSource(files: inputs.map { ($0, try WhereJudge.fileText(root + "/" + $0)) })
        let names = ["AddressIdentity", "OneEquality", "EqualityChain", "ReversedChain", "JointQuestion", "AliasedView", "DisconnectedClass", "SameSortDifferentPlaces", "DisplayCoincidence", "TwoSorts", "DuplicatedOrigin", "WholeAsObservation"]
        var lean = "-- Generated observations by Tools/FixtureProbe.swift; bridge is not a proved reader.\nimport U5.Obstruction\n\nnamespace U5.ContractCases\n\n"
        var records: [[String: Any]] = []
        for name in names {
            var c = try C.deriveRelated(name, source: source)
            if case var .obstructed(o) = c.conclusion {
                // Explicit legal format-2 core, not a silently ignored extension.
                o.residue = nil; c.conclusion = .obstructed(o)
            }
            let r = try C.relatedReading(name, certificate: c, source: source)
            var sorts: [String] = []
            for (_, s) in r.source.leaves where !sorts.contains(where: { WhereJudge.sameName($0, s) }) { sorts.append(s) }
            let edges = list(r.edges.map { "⟨\(path($0.address)), \(path($0.left)), \(path($0.right))⟩" })
            lean += "def \(name) : Model := ⟨\(shape(r.source, sorts)), \(places(r.observation)), \(places(r.question)), \(edges)⟩\n"
            func emit(_ suffix: String, _ cert: C.RelatedCertificate, expected: Bool) throws {
                let id = name + suffix
                var accepted = false, conclusion = "unresolved", message = ""
                do {
                    let holds = try C.verifyRelated(name, certificate: cert, source: source)
                    accepted = true; conclusion = holds ? "constructed" : "obstructed"
                } catch { message = String(describing: error) }
                precondition(accepted == expected, "Unexpected Swift result for \(id): \(message)")
                let data = try C.encodeRelated(cert)
                try data.write(to: URL(fileURLWithPath: out + "/" + id + ".json"))
                records.append(["case": id, "request": name, "accepted": accepted, "conclusion": conclusion, "diagnostic": message, "sorts": sorts])
                lean += "def \(id)Cert : Certificate := \(certificate(cert, r, sorts))\n"
                lean += "theorem \(id)_observed : check \(name) \(id)Cert = \(expected) := by decide\n\n"
            }
            try emit("", c, expected: true)
            if case let .constructed(ss, p) = c.conclusion {
                func mutate(_ suffix: String, _ edit: (inout C.Selection) -> Void) throws {
                    var bad = c, sels = ss; edit(&sels[0]); bad.conclusion = .constructed(sels, p)
                    try emit(suffix, bad, expected: false)
                }
                if name == "OneEquality" {
                    try mutate("BadOutput") { $0.output = [.left] }
                    try mutate("BadInput") { $0.input = [.right] }
                    try mutate("ValuesGround") { $0.basis = .observedValues }
                    try mutate("FalseAddress") { $0.basis = .address }
                    try mutate("EmptyPath") { $0.basis = .sourceRelation([]) }
                    try mutate("AbsentEdge") { $0.basis = .sourceRelation([.init(edge: [.right], reversed: false)]) }
                    try mutate("WrongDirection") { $0.basis = .sourceRelation([.init(edge: [], reversed: true)]) }
                    var short = c; short.conclusion = .constructed([], p)
                    try emit("MissingSelection", short, expected: false)
                    var extra = c; extra.conclusion = .constructed(ss + ss, p)
                    try emit("ExtraSelection", extra, expected: false)
                    var bad = c; bad.conclusion = .constructed(ss, .pair(p, p))
                    try emit("BadProgram", bad, expected: false)
                }
                if name == "EqualityChain" {
                    try mutate("BrokenChain") { $0.basis = .sourceRelation([.init(edge: [.right], reversed: false), .init(edge: [.left], reversed: false)]) }
                    try mutate("WrongEndpoint") { $0.basis = .sourceRelation([.init(edge: [.left], reversed: false)]) }
                }
            } else if case let .obstructed(original) = c.conclusion {
                func mutate(_ suffix: String, _ edit: (inout C.Obstruction) -> Void) throws {
                    var bad = c, o = original; edit(&o); bad.conclusion = .obstructed(o)
                    try emit(suffix, bad, expected: false)
                }
                if name == "SameSortDifferentPlaces" {
                    try mutate("BadQuestion") { $0.question = [.left] }
                    try mutate("LostLeaf") { $0.classes.removeLast() }
                    try mutate("DuplicateLeaf") { $0.classes[0].leaves.append($0.classes[0].leaves[0]) }
                    try mutate("EmptyClass") { $0.classes.append(.init(sort: $0.classes[0].sort, leaves: [])) }
                    try mutate("ObservedBlock") { $0.classes[0].leaves += $0.classes[1].leaves; $0.classes.removeLast() }
                }
                if name == "TwoSorts" {
                    try mutate("WrongSort") { $0.classes[1].sort = $0.classes[0].sort }
                }
                if name == "DisconnectedClass" {
                    try mutate("BrokenEdge") {
                        let p = $0.classes[0].leaves.removeLast()
                        $0.classes.append(.init(sort: $0.classes[0].sort, leaves: [p]))
                    }
                }
            }
        }
        lean += "end U5.ContractCases\n"
        try lean.write(toFile: out + "/ContractCases.lean", atomically: true, encoding: .utf8)
        let data = try JSONSerialization.data(withJSONObject: records, options: [.sortedKeys, .prettyPrinted])
        try data.write(to: URL(fileURLWithPath: out + "/observations.json"))
        print("\(records.count) Swift core-certificate observations exported; no correspondence theorem claimed")
    }
}
