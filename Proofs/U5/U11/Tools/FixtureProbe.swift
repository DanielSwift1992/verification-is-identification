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
func certificate(_ p: C.Repetition, _ sorts: [String]) -> String {
    let classes = list(p.classes.map { b in "⟨\((sorts.firstIndex(where: { WhereJudge.sameName($0, b.sort) }) ?? sorts.count)), \(list(b.leaves.map(path)))⟩" })
    let connections = list(p.connections.map { list($0.map { "⟨\(path($0.edge)), \($0.reversed)⟩" }) })
    let evidence = list(p.hiddenActions.map { e in
        let result: String
        switch e.preservation {
        case let .preserved(paths): result = "(.preserved \(list(paths.map(basis))))"
        case let .notPreserved(edge): result = "(.notPreserved \(path(edge)))"
        }
        return "⟨\(path(e.member)), \(result)⟩"
    })
    let conclusion: String
    switch p.conclusion {
    case nil: conclusion = "none"
    case let .returned(b)?:
        let cycles = list(b.cycles.map { "⟨\(path($0.member)), \($0.block), \(list($0.vertices.map(String.init))), \($0.length)⟩" })
        let steps = list(b.arithmetic.map { "⟨\($0.gcd), \($0.multiplier), \($0.value)⟩" })
        conclusion = "(some (.returned ⟨\(cycles), \(steps), \(b.calls), \(b.additionalCalls)⟩))"
    case let .obstructed(t)?:
        conclusion = "(some (.obstructed ⟨\(path(t.member)), \(t.block), \(list(t.vertices.map(String.init))), \(t.repeatedIndex)⟩))"
    }
    return "⟨\(classes), \(connections), \(list(p.required.map(String.init))), \(evidence), \(conclusion)⟩"
}
func kind(_ p: C.Repetition) -> String {
    switch p.conclusion { case nil: return "preservation"; case .returned?: return "returned"; case .obstructed?: return "tail" }
}
@main struct U11FixtureProbe {
    static func main() throws {
        let args = CommandLine.arguments
        precondition(args.count == 3, "U11FixtureProbe REPO OUTPUT_DIRECTORY")
        let root = args[1], out = args[2]
        try FileManager.default.createDirectory(atPath: out, withIntermediateDirectories: true)
        let inputs = ["Sources/Notation/Primitive.swift", "Contracts/Court/continuation-relations-v1/repeat-cases.swift"]
        let source = try StructuralSource(files: inputs.map { ($0, try WhereJudge.fileText(root + "/" + $0)) })
        let contract = try JSONSerialization.jsonObject(with: Data(contentsOf: URL(fileURLWithPath: root + "/Contracts/Court/continuation-relations-v1/contract.json"))) as! [String: Any]
        let rows = (contract["repetition"] as! [String: Any])["cases"] as! [[String: String]]
        var lean = "-- Generated finite observations; not a proved Swift/Lean bridge.\nimport U11.Soundness\n\nnamespace U11.ContractCases\nopen U5 U7\n\n"
        var records: [[String: Any]] = []
        for row in rows {
            let name = row["request"]!
            if let address = row["address"] {
                var message = ""
                do { _ = try C.deriveRelated(name, source: source, repeats: true); fatalError("Expected input refusal") }
                catch { message = String(describing: error) }
                precondition(message.contains(address), "Different refusal address: \(message)")
                records.append(["case": name, "accepted": false, "scope": "Swift reader only", "diagnostic": message])
                continue
            }
            let c = try C.deriveRelated(name, source: source, repeats: true)
            let r = try C.relatedReading(name, certificate: c, source: source)
            var sorts: [String] = []
            for (_, s) in r.source.leaves where !sorts.contains(where: { WhereJudge.sameName($0, s) }) { sorts.append(s) }
            let edges = list(r.edges.map { "⟨\(path($0.address)), \(path($0.left)), \(path($0.right))⟩" })
            lean += "def \(name) : Model := ⟨\(shape(r.source, sorts)), \(places(r.observation)), \(places(r.question)), \(edges)⟩\n"
            lean += "def \(name)Hidden : List Action := \(list(r.hiddenActions!.map { "⟨\(path($0.address)), \(places($0.image))⟩" }))\n"
            func emit(_ suffix: String, _ cert: C.RelatedCertificate, expected: Bool) throws {
                let id = name + suffix
                var accepted = false, holds = false, message = ""
                do { holds = try C.verifyRelatedRepetition(name, certificate: cert, source: source); accepted = true }
                catch { message = String(describing: error) }
                precondition(accepted == expected, "Unexpected Swift result for \(id): \(message)")
                if suffix.isEmpty {
                    if let count = row["calls"] {
                        guard case let .returned(b)? = cert.repetition!.conclusion else { fatalError("Return expected") }
                        precondition(holds && b.calls == count)
                    } else { precondition(!holds && kind(cert.repetition!) == (row["refusal"]! == "tail" ? "tail" : "preservation")) }
                }
                try C.encodeRelated(cert).write(to: URL(fileURLWithPath: out + "/" + id + ".json"))
                records.append(["case": id, "request": name, "accepted": accepted, "holds": holds,
                                "kind": kind(cert.repetition!), "diagnostic": message, "scope": "Swift and Lean normalized certificate"])
                lean += "def \(id)Cert : U11.Certificate := \(certificate(cert.repetition!, sorts))\n"
                lean += "theorem \(id)_observed : U11.check \(name) \(name)Hidden \(id)Cert = \(expected) := by decide\n"
                if accepted { lean += "theorem \(id)_claim : U11.Claim \(name) \(name)Hidden \(id)Cert := U11.check_sound \(id)_observed\n" }
                lean += "\n"
            }
            func mutate(_ suffix: String, _ edit: (inout C.Repetition) -> Void) throws {
                var bad = c; edit(&bad.repetition!); try emit(suffix, bad, expected: false)
            }
            func block(_ suffix: String, _ edit: (inout C.ReturnBlock) -> Void) throws {
                var bad = c
                guard case var .returned(b)? = bad.repetition!.conclusion else { fatalError("return expected") }
                edit(&b); bad.repetition!.conclusion = .returned(b); try emit(suffix, bad, expected: false)
            }
            func tail(_ suffix: String, _ edit: (inout C.ReturnTail) -> Void) throws {
                var bad = c
                guard case var .obstructed(t)? = bad.repetition!.conclusion else { fatalError("tail expected") }
                edit(&t); bad.repetition!.conclusion = .obstructed(t); try emit(suffix, bad, expected: false)
            }
            try emit("", c, expected: true)
            try mutate("MissingRequired") { $0.required = [] }
            try mutate("ExtraRequired") { $0.required += [999] }
            try mutate("DuplicateRequired") { $0.required += [$0.required[0]] }
            try mutate("MissingEvidence") { $0.hiddenActions = [] }
            try mutate("ExtraEvidence") { $0.hiddenActions += $0.hiddenActions }
            try mutate("WrongMemberEvidence") { $0.hiddenActions[0].member += Array(repeating: .right, count: 8) }
            try mutate("MissingForests") { $0.connections = [] }
            try mutate("MissingClasses") { $0.classes = [] }
            if c.repetition!.required.count > 1 { try mutate("RequiredOrder") { $0.required.reverse() } }
            switch c.repetition!.conclusion {
            case nil:
                try mutate("FalsePreservation") { $0.hiddenActions[0].preservation = .preserved([]) }
                try mutate("UnknownPreservationEdge") { $0.hiddenActions[0].preservation = .notPreserved(edge: Array(repeating: .right, count: 8)) }
            case .returned?:
                try mutate("NoConclusion") { $0.conclusion = nil }
                try block("MissingCycles") { $0.cycles = [] }
                try block("ExtraCycle") { $0.cycles += [$0.cycles[0]] }
                try block("WrongMember") { $0.cycles[0].member += Array(repeating: .right, count: 8) }
                try block("WrongBlock") { $0.cycles[0].block = 999 }
                try block("WrongVertex") { $0.cycles[0].vertices[1] = 999 }
                try block("WrongLength") { $0.cycles[0].length += 1 }
                try block("RepeatedPrefix") { $0.cycles[0].vertices.insert($0.cycles[0].block, at: 1); $0.cycles[0].length += 1 }
                try block("EmptyWalk") { $0.cycles[0].vertices = [] }
                try block("ZeroWalk") { $0.cycles[0].vertices = [$0.cycles[0].block]; $0.cycles[0].length = 0 }
                try block("MissingArithmetic") { $0.arithmetic = [] }
                try block("ExtraArithmetic") { $0.arithmetic += [$0.arithmetic[0]] }
                try block("WrongGCD") { $0.arithmetic[0].gcd += 1 }
                try block("WrongMultiplier") { $0.arithmetic[0].multiplier += 1 }
                try block("WrongStepValue") { $0.arithmetic[0].value = String(Int($0.arithmetic[0].value)! + 1) }
                try block("WrongCalls") { $0.calls = String(Int($0.calls)! + 1) }
                try block("WrongAdditionalCalls") { $0.additionalCalls = String(Int($0.additionalCalls)! + 1) }
                try block("ZeroCalls") { $0.calls = "0" }
                if c.repetition!.required.count > 1 { try block("CycleOrder") { $0.cycles.reverse() } }
                if name == "EqualClassReturn" {
                    try mutate("LostEqualityGround") { $0.connections[0] = [] }
                    try mutate("LostPreservationGround") { $0.hiddenActions[0].preservation = .preserved([]) }
                }
            case .obstructed?:
                try mutate("NoConclusion") { $0.conclusion = nil }
                try tail("UnknownTailMember") { $0.member += Array(repeating: .right, count: 8) }
                try tail("WrongTailBlock") { $0.block = 999 }
                try tail("WrongTailVertex") { $0.vertices[1] = 999 }
                try tail("TailZeroIndex") { $0.repeatedIndex = 0 }
                try tail("TailUnknownIndex") { $0.repeatedIndex = 999 }
                try tail("TailRepeatedPrefix") { $0.vertices.insert($0.block, at: 1) }
                try tail("TailReturnsStart") { $0.vertices[$0.vertices.count-1] = $0.block }
            }
        }
        lean += "end U11.ContractCases\n"
        try lean.write(toFile: out + "/ContractCases.lean", atomically: true, encoding: .utf8)
        try JSONSerialization.data(withJSONObject: records, options: [.sortedKeys, .prettyPrinted]).write(to: URL(fileURLWithPath: out + "/observations.json"))
        print("\(records.count) U11 Swift observations exported; translation is not a theorem")
    }
}
