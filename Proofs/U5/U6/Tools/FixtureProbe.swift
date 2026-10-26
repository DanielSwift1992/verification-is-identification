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
func certificate(_ c: C.RelatedCertificate, _ sorts: [String]) -> String {
    switch c.conclusion {
    case let .constructed(ss, p):
        precondition(c.retention == nil)
        return "(.zero \(construction(ss, p)))"
    case let .obstructed(o):
        // No fields dropped: this is the full U6 part of format 3.
        let r = o.residue!, ret = c.retention!
        let classes = list(o.classes.map { b in
            "⟨\(sorts.firstIndex(where: { WhereJudge.sameName($0, b.sort.text) })!), \(list(b.leaves.map(path)))⟩"
        })
        let connections = list(r.connections.map { steps in
            list(steps.map { "⟨\(path($0.edge)), \($0.reversed)⟩" })
        })
        let needed = list(r.needed.map { "⟨\($0.block), \(list($0.questions.map(path)))⟩" })
        let retention = "⟨\(list(ret.leaves.map(path))), \(program(ret.view)), \(construction(ret.selections, ret.program))⟩"
        return "(.retained ⟨⟨\(path(o.question)), \(classes)⟩, ⟨\(connections), \(needed)⟩, \(retention)⟩)"
    }
}

@main struct U6FixtureProbe {
    static func main() throws {
        let args = CommandLine.arguments
        precondition(args.count == 3, "U6FixtureProbe REPO OUTPUT_DIRECTORY")
        let root = args[1], out = args[2]
        try FileManager.default.createDirectory(atPath: out, withIntermediateDirectories: true)
        let inputs = ["Sources/Notation/Primitive.swift", "Contracts/Court/continuation-relations-v1/retention-cases.swift", "Contracts/Court/continuation-relations-v1/cases.swift"]
        let source = try StructuralSource(files: inputs.map { ($0, try WhereJudge.fileText(root + "/" + $0)) })
        let names = ["RetainOneClass", "RetainTwoSorts", "RetainRepeatedClass", "RetainFromClassOutsideViews", "RetainNothing", "MultiClassResidue"]
        var lean = "-- Generated finite observations; not a proved bridge.\nimport U6.Minimality\n\nnamespace U6.ContractCases\nopen U5\n\n"
        var records: [[String: Any]] = []
        for name in names {
            let c = try C.deriveRelated(name, source: source, retain: true)
            let r = try C.relatedReading(name, certificate: c, source: source)
            var sorts: [String] = []
            for (_, s) in r.source.leaves where !sorts.contains(where: { WhereJudge.sameName($0, s) }) { sorts.append(s) }
            let edges = list(r.edges.map { "⟨\(path($0.address)), \(path($0.left)), \(path($0.right))⟩" })
            lean += "def \(name) : Model := ⟨\(shape(r.source, sorts)), \(places(r.observation)), \(places(r.question)), \(edges)⟩\n"
            func emit(_ suffix: String, _ cert: C.RelatedCertificate, expected: Bool) throws {
                let id = name + suffix
                var accepted = false, count = -1, message = ""
                do { count = try C.verifyRelatedRetention(name, certificate: cert, source: source); accepted = true }
                catch { message = String(describing: error) }
                precondition(accepted == expected, "Unexpected Swift result for \(id): \(message)")
                let data = try C.encodeRelated(cert)
                try data.write(to: URL(fileURLWithPath: out + "/" + id + ".json"))
                records.append(["case": id, "request": name, "accepted": accepted, "leaves": count, "diagnostic": message, "sorts": sorts])
                lean += "def \(id)Cert : U6.Certificate := \(certificate(cert, sorts))\n"
                lean += "theorem \(id)_observed : U6.check \(name) \(id)Cert = \(expected) := by decide\n"
                if accepted { lean += "theorem \(id)_leaves : leafCount \(id)Cert = \(count) := by decide\n" }
                lean += "\n"
            }
            try emit("", c, expected: true)
            if case .constructed = c.conclusion {
                var bad = c
                if case let .constructed(original, p) = bad.conclusion {
                    var ss = original
                    ss[0].basis = .observedValues; bad.conclusion = .constructed(ss, p)
                }
                try emit("BadBasis", bad, expected: false)
                continue
            }
            func mutate(_ suffix: String, _ edit: (inout C.RelatedCertificate) -> Void) throws {
                var bad = c; edit(&bad); try emit(suffix, bad, expected: false)
            }
            func residue(_ suffix: String, _ edit: (inout C.Obstruction) -> Void) throws {
                var bad = c
                if case var .obstructed(o) = bad.conclusion { edit(&o); bad.conclusion = .obstructed(o) }
                try emit(suffix, bad, expected: false)
            }
            if name == "RetainOneClass" {
                try mutate("MissingLeaf") { $0.retention!.leaves = [] }
                try mutate("ExtraLeaf") { $0.retention!.leaves += $0.retention!.leaves }
                try mutate("ObservedLeaf") { $0.retention!.leaves = [[.left]]; $0.retention!.view = .pick([.left]) }
                try mutate("WrongView") { $0.retention!.view = .pick([.left]) }
                try mutate("WrongProgram") { $0.retention!.program = .pick([.left]) }
                try mutate("BadInput") { $0.retention!.selections[0].input = [.left, .left] }
                try mutate("BadOutput") { $0.retention!.selections[0].output = [.left] }
                try mutate("ObservedValues") { $0.retention!.selections[0].basis = .observedValues }
                try mutate("MissingSelection") { $0.retention!.selections = [] }
                try residue("NoForestRows") { $0.residue!.connections = [] }
                try residue("MissingNeeded") { $0.residue!.needed = [] }
                try residue("DuplicateNeeded") { $0.residue!.needed += $0.residue!.needed }
                try residue("ObservedNeeded") { $0.residue!.needed[0].block = 0 }
                try residue("WrongQuestionPath") { $0.residue!.needed[0].questions = [[.right]] }
            }
            if name == "RetainTwoSorts" {
                try residue("PermutedNeeded") { $0.residue!.needed.reverse() }
                try mutate("DuplicateClass") { $0.retention!.leaves[1] = $0.retention!.leaves[0] }
                var alternate = c
                let leaves = Array(c.retention!.leaves.reversed()), m = C.retainedPlaces(leaves)!
                let joint = C.RelatedReading(whole: r.whole, observation: .pair(r.observation, m), question: r.question)
                guard case let .constructed(ss, p) = try C.constructRelated(joint) else { fatalError("expected decoder") }
                alternate.retention = try .init(leaves: leaves, view: C.assembledProgram(m, inputs: leaves), selections: ss, program: p)
                try emit("PermutedRetention", alternate, expected: true)
                try mutate("PermutationWithoutDecoder") {
                    $0.retention!.leaves.reverse()
                    $0.retention!.view = .pair(.pick(leaves[0]), .pick(leaves[1]))
                }
            }
            if name == "RetainRepeatedClass" {
                try residue("LostRepeatedQuestion") { $0.residue!.needed[0].questions.removeLast() }
                try residue("PermutedQuestionPaths") { $0.residue!.needed[0].questions.reverse() }
            }
            if name == "MultiClassResidue" {
                try residue("CoarseWithoutForest") {
                    $0.classes[1].leaves += $0.classes[2].leaves
                    $0.classes.removeLast()
                    $0.residue!.connections.removeLast()
                    $0.residue!.needed[0].questions += $0.residue!.needed[1].questions
                    $0.residue!.needed.removeLast()
                }
            }
            if name == "RetainFromClassOutsideViews" {
                try residue("MissingForestEdge") { $0.residue!.connections[0] = [] }
                try residue("ReversedForestEdge") { $0.residue!.connections[0][0].reversed.toggle() }
                try residue("UnknownForestEdge") { $0.residue!.connections[0][0].edge = [.right] }
                try mutate("NoEqualityGround") { $0.retention!.selections[0].basis = .address }
                var alternate = c
                let leaves: [C.Path] = [[.right, .left]], m = C.retainedPlaces(leaves)!
                let joint = C.RelatedReading(whole: r.whole, observation: .pair(r.observation, m), question: r.question)
                guard case let .constructed(ss, p) = try C.constructRelated(joint) else { fatalError("expected decoder") }
                alternate.retention = try .init(leaves: leaves, view: C.assembledProgram(m, inputs: leaves), selections: ss, program: p)
                try emit("OtherRepresentative", alternate, expected: true)
            }
        }
        lean += "end U6.ContractCases\n"
        try lean.write(toFile: out + "/ContractCases.lean", atomically: true, encoding: .utf8)
        try JSONSerialization.data(withJSONObject: records, options: [.sortedKeys, .prettyPrinted]).write(to: URL(fileURLWithPath: out + "/observations.json"))
        print("\(records.count) U6 Swift observations exported; model/code correspondence is not a theorem")
    }
}
