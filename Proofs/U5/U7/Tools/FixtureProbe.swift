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

func image(_ i: C.ImageAction) -> String {
    "⟨\(path(i.member)), \(list(i.targets.map(String.init))), \(construction(i.selections, i.program))⟩"
}
func stable(_ s: C.StableView) -> String {
    let witnesses = list(s.classes.map { "⟨\($0.block), \(path($0.question)), \(list($0.word.map(path))), \(basis($0.basis))⟩" })
    return "⟨\(witnesses), \(list(s.representatives.map(path))), \(program(s.view)), \(list(s.actions.map(image))), \(construction(s.selections, s.decoder))⟩"
}
func certificate(_ c: C.RelatedCertificate, _ sorts: [String]) -> String {
    let d = c.dynamics!
    precondition(d.hiddenActions == nil && d.hidden == nil, "U8 is outside this bridge")
    let classes = list(d.classes.map { b in "⟨\((sorts.firstIndex(where: { WhereJudge.sameName($0, b.sort.text) }) ?? sorts.count)), \(list(b.leaves.map(path)))⟩" })
    let connections = list(d.connections.map { steps in list(steps.map { "⟨\(path($0.edge)), \($0.reversed)⟩" }) })
    let evidence = list(d.actions.map { e in
        let result: String
        switch e.preservation {
        case let .preserved(paths): result = "(.preserved \(list(paths.map(basis))))"
        case let .notPreserved(edge): result = "(.notPreserved \(path(edge)))"
        }
        return "⟨\(path(e.member)), \(result)⟩"
    })
    let s = d.stable.map { "(some \(stable($0)))" } ?? "none"
    return "⟨\(classes), \(connections), \(evidence), \(s)⟩"
}

@main struct U7FixtureProbe {
    static func main() throws {
        let args = CommandLine.arguments
        precondition(args.count == 3, "U7FixtureProbe REPO OUTPUT_DIRECTORY")
        let root = args[1], out = args[2]
        try FileManager.default.createDirectory(atPath: out, withIntermediateDirectories: true)
        let inputs = ["Sources/Notation/Primitive.swift", "Contracts/Court/continuation-relations-v1/action-cases.swift"]
        let source = try StructuralSource(files: inputs.map { ($0, try WhereJudge.fileText(root + "/" + $0)) })
        let names = ["PreservesEqualities", "BreaksEqualities", "CyclicQuestion", "EmptyActions", "NoncommutingWords"]
        var lean = "-- Generated finite observations; not a proved bridge.\nimport U7.Words\n\nnamespace U7.ContractCases\nopen U5\n\n"
        var records: [[String: Any]] = []
        for name in names {
            let c = try C.deriveRelated(name, source: source, actions: true)
            let r = try C.relatedReading(name, certificate: c, source: source)
            precondition(r.hiddenActions == nil, "U8 is outside this bridge")
            var sorts: [String] = []
            for (_, s) in r.source.leaves where !sorts.contains(where: { WhereJudge.sameName($0, s) }) { sorts.append(s) }
            let edges = list(r.edges.map { "⟨\(path($0.address)), \(path($0.left)), \(path($0.right))⟩" })
            lean += "def \(name) : Model := ⟨\(shape(r.source, sorts)), \(places(r.observation)), \(places(r.question)), \(edges)⟩\n"
            lean += "def \(name)Actions : List Action := \(list(r.actions.map { "⟨\(path($0.address)), \(places($0.image))⟩" }))\n"
            func emit(_ suffix: String, _ cert: C.RelatedCertificate, expected: Bool) throws {
                let id = name + suffix
                var accepted = false, holds = false, message = ""
                do { holds = try C.verifyRelatedActions(name, certificate: cert, source: source); accepted = true }
                catch { message = String(describing: error) }
                precondition(accepted == expected, "Unexpected Swift result for \(id): \(message)")
                try C.encodeRelated(cert).write(to: URL(fileURLWithPath: out + "/" + id + ".json"))
                records.append(["case": id, "request": name, "accepted": accepted, "holds": holds,
                                "diagnostic": message, "sorts": sorts, "layer": "U7 normalized certificate"])
                lean += "def \(id)Cert : U7.Certificate := \(certificate(cert, sorts))\n"
                lean += "theorem \(id)_observed : U7.check \(name) \(name)Actions \(id)Cert = \(expected) := by decide\n"
                if accepted {
                    lean += "theorem \(id)_conclusion : \(id)Cert.stable.isSome = \(holds) := by decide\n"
                }
                lean += "\n"
            }
            func mutate(_ suffix: String, _ edit: (inout C.Dynamics) -> Void) throws {
                var bad = c; edit(&bad.dynamics!); try emit(suffix, bad, expected: false)
            }
            try emit("", c, expected: true)
            if name == "BreaksEqualities" {
                try mutate("UnknownRefusalEdge") { $0.actions[0].preservation = .notPreserved(edge: [.right]) }
                try mutate("FalsePreservation") { $0.actions[0].preservation = .preserved([.address]) }
                try mutate("MissingEvidence") { $0.actions = [] }
                continue
            }
            if name == "EmptyActions" {
                try mutate("LostEmptyWord") { $0.stable!.classes[0].word = [[]] }
                try mutate("WrongDecoder") { $0.stable!.decoder = .pick([.left]) }
                try mutate("UnknownView") { $0.stable!.view = .pick([.left]) }
                continue
            }
            try mutate("LostClosure") { $0.stable!.actions = [] }
            if name == "PreservesEqualities" {
                try mutate("NoStable") { $0.stable = nil }
                try mutate("MissingEvidence") { $0.actions = [] }
                try mutate("ExtraEvidence") { $0.actions += $0.actions }
                try mutate("WrongMember") { $0.actions[0].member = [.left] }
                try mutate("MissingEdgeGround") { $0.actions[0].preservation = .preserved([]) }
                try mutate("ObservedValuesGround") { $0.actions[0].preservation = .preserved([.observedValues]) }
                try mutate("WrongEdgeGround") { $0.actions[0].preservation = .preserved([.address]) }
                try mutate("FalseRefusal") { $0.actions[0].preservation = .notPreserved(edge: []); $0.stable = nil }
                try mutate("MissingForests") { $0.connections = [] }
                try mutate("MissingForestEdge") { $0.connections[0] = [] }
                try mutate("ReversedForestEdge") { $0.connections[0][0].reversed.toggle() }
                try mutate("WrongSort") { $0.classes[0].sort = ScalarName("Other") }
                try mutate("MissingWitness") { $0.stable!.classes = [] }
                try mutate("WrongQuestion") { $0.stable!.classes[0].question = [.left] }
                try mutate("UnknownWordMember") { $0.stable!.classes[0].word = [[.left]] }
                try mutate("UnknownBlock") { $0.stable!.classes[0].block = 999 }
                try mutate("BadWitnessGround") { $0.stable!.classes[0].basis = .observedValues }
                try mutate("WrongRepresentative") { $0.stable!.representatives[0] = [.right, .right] }
                try mutate("WrongView") { $0.stable!.view = .pick([.right, .right]) }
                try mutate("WrongImageMember") { $0.stable!.actions[0].member = [.left] }
                try mutate("MissingTargets") { $0.stable!.actions[0].targets = [] }
                try mutate("InvalidTarget") { $0.stable!.actions[0].targets = [999] }
                try mutate("MissingImageSelections") { $0.stable!.actions[0].selections = [] }
                try mutate("WrongImageProgram") { $0.stable!.actions[0].program = .pick([.left]) }
                try mutate("WrongImageGround") { $0.stable!.actions[0].selections[0].basis = .address }
                try mutate("MissingDecoder") { $0.stable!.selections = [] }
                try mutate("WrongDecoderProgram") { $0.stable!.decoder = .pick([.left]) }
                try mutate("WrongDecoderGround") { $0.stable!.selections[0].basis = .observedValues }
                // Another representative of the same E-class is legal; regenerate only its proof.
                var alt = c
                let reps: [C.Path] = [[.right, .left]], view = C.retainedPlaces(reps)!
                let partition = C.constructPartition(r)
                var budget = C.ActionBudget()
                alt.dynamics!.stable!.representatives = reps
                alt.dynamics!.stable!.classes[0].basis = try C.constructionBasis([.left], reps[0], reading: r, budget: &budget)
                alt.dynamics!.stable!.view = try C.assembledProgram(view, inputs: reps)
                alt.dynamics!.stable!.actions = try r.actions.map { try C.imageAction($0, view: view, classList: [0], classes: partition.classes, blocks: partition.blocks, reading: r) }
                let cut = C.RelatedReading(whole: r.whole, observation: view, question: r.question)
                guard case let .constructed(ss, p) = try C.constructRelated(cut) else { fatalError("decoder") }
                alt.dynamics!.stable!.selections = ss; alt.dynamics!.stable!.decoder = p
                try emit("OtherRepresentative", alt, expected: true)
            }
            if name == "CyclicQuestion" {
                try mutate("LostEmptyWord") { $0.stable!.classes[0].word = [[], [], []] }
                try mutate("WrongWord") { $0.stable!.classes[1].word = [] }
                try mutate("DuplicateClass") { $0.stable!.classes[1] = $0.stable!.classes[0] }
                try mutate("LostRepresentative") { $0.stable!.representatives.removeLast() }
                try mutate("WrongClosureTarget") { $0.stable!.actions[0].targets[0] = 0 }
                try mutate("UnbalancedView") {
                    let p = $0.stable!.representatives
                    $0.stable!.view = .pair(.pair(.pick(p[0]), .pick(p[1])), .pick(p[2]))
                }
            }
            if name == "NoncommutingWords" {
                try mutate("ReversedWord") { $0.stable!.classes[2].word.reverse() }
                try mutate("PermutedImageActions") { $0.stable!.actions.reverse() }
                try mutate("PermutedEvidence") { $0.actions.reverse() }
            }
        }
        // Rejected source readings have no normalized Action/Certificate to export.
        // Their observations are explicit, and are not called Lean agreement tests.
        for name in ["SortChangingAction", "MalformedActionShape", "UnrootedAction", "UnreadActionAxis"] {
            var message = ""
            do { _ = try C.deriveRelated(name, source: source, actions: true); preconditionFailure("Expected refusal: \(name)") }
            catch { message = String(describing: error) }
            records.append(["case": name, "accepted": false, "diagnostic": message, "layer": "Swift reading only"])
        }
        lean += "end U7.ContractCases\n"
        try lean.write(toFile: out + "/ContractCases.lean", atomically: true, encoding: .utf8)
        try JSONSerialization.data(withJSONObject: records, options: [.sortedKeys, .prettyPrinted]).write(to: URL(fileURLWithPath: out + "/observations.json"))
        print("\(records.count) U7 Swift observations exported; model/code correspondence is not a theorem")
    }
}
