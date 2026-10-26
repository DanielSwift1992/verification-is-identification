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
func visibleCertificate(_ c: C.RelatedCertificate, _ sorts: [String]) -> String {
    let d = c.dynamics!
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

func hiddenConclusion(_ h: C.HiddenConclusion) -> String {
    switch h {
    case let .common(images, p): return "(.common \(list(images.map(image))) \(program(p)))"
    case let .outside(member, observation, image): return "(.outside \(path(member)) \(path(observation)) \(path(image)))"
    case let .disagreement(left, right, observation, leftImage, rightImage):
        return "(.disagreement \(path(left)) \(path(right)) \(path(observation)) \(path(leftImage)) \(path(rightImage)))"
    }
}
func certificate(_ c: C.RelatedCertificate, _ sorts: [String]) -> String {
    let d = c.dynamics!
    precondition(d.hiddenActions != nil && c.retention == nil && c.repetition == nil)
    let evidence = list(d.hiddenActions!.map { e in
        let result: String
        switch e.preservation {
        case let .preserved(paths): result = "(.preserved \(list(paths.map(basis))))"
        case let .notPreserved(edge): result = "(.notPreserved \(path(edge)))"
        }
        return "⟨\(path(e.member)), \(result)⟩"
    })
    let hidden = d.hidden.map { h in
        "(some ⟨\(list(h.classes.map(String.init))), \(hiddenConclusion(h.conclusion)), \(h.closureInheritedFromStableView)⟩)"
    } ?? "none"
    return "⟨\(visibleCertificate(c, sorts)), \(evidence), \(hidden)⟩"
}
func kind(_ c: C.RelatedCertificate) -> String {
    guard let h = c.dynamics!.hidden else { return "preservation" }
    switch h.conclusion {
    case .common: return "common"
    case .outside: return "outside"
    case .disagreement: return "disagreement"
    }
}

@main struct U8FixtureProbe {
    static func main() throws {
        let args = CommandLine.arguments
        precondition(args.count == 3, "U8FixtureProbe REPO OUTPUT_DIRECTORY")
        let root = args[1], out = args[2]
        try FileManager.default.createDirectory(atPath: out, withIntermediateDirectories: true)
        let inputs = ["Sources/Notation/Primitive.swift", "Contracts/Court/continuation-relations-v1/action-cases.swift"]
        let source = try StructuralSource(files: inputs.map { ($0, try WhereJudge.fileText(root + "/" + $0)) })
        let names = ["HiddenDisagreement", "HiddenCommon", "HiddenOutside", "HiddenInvalidEqualities",
                     "HiddenEquivalentProjections", "AliasedActions", "HiddenOnly", "ScalarActions"]
        var lean = "-- Generated finite observations; not a proved bridge.\nimport U8.Soundness\n\nnamespace U8.ContractCases\nopen U5 U7\n\n"
        var records: [[String: Any]] = []
        for name in names {
            let c = try C.deriveRelated(name, source: source, actions: true)
            let r = try C.relatedReading(name, certificate: c, source: source)
            precondition(r.hiddenActions != nil && !r.hiddenActions!.isEmpty)
            var sorts: [String] = []
            for (_, s) in r.source.leaves where !sorts.contains(where: { WhereJudge.sameName($0, s) }) { sorts.append(s) }
            let edges = list(r.edges.map { "⟨\(path($0.address)), \(path($0.left)), \(path($0.right))⟩" })
            lean += "def \(name) : Model := ⟨\(shape(r.source, sorts)), \(places(r.observation)), \(places(r.question)), \(edges)⟩\n"
            lean += "def \(name)Actions : List Action := \(list(r.actions.map { "⟨\(path($0.address)), \(places($0.image))⟩" }))\n"
            lean += "def \(name)Hidden : List Action := \(list(r.hiddenActions!.map { "⟨\(path($0.address)), \(places($0.image))⟩" }))\n"
            func emit(_ suffix: String, _ cert: C.RelatedCertificate, expected: Bool) throws {
                let id = name + suffix
                var accepted = false, holds = false, message = ""
                do { holds = try C.verifyRelatedActions(name, certificate: cert, source: source); accepted = true }
                catch { message = String(describing: error) }
                precondition(accepted == expected, "Unexpected Swift result for \(id): \(message)")
                try C.encodeRelated(cert).write(to: URL(fileURLWithPath: out + "/" + id + ".json"))
                records.append(["case": id, "request": name, "accepted": accepted, "holds": holds,
                                "kind": kind(cert), "diagnostic": message, "sorts": sorts])
                lean += "def \(id)Cert : U8.Certificate := \(certificate(cert, sorts))\n"
                lean += "theorem \(id)_observed : U8.check \(name) \(name)Actions \(name)Hidden \(id)Cert = \(expected) := by decide\n"
                if accepted {
                    lean += "theorem \(id)_conclusion : verdict \(id)Cert = .\(kind(cert)) := by decide\n"
                }
                lean += "\n"
            }
            func mutate(_ suffix: String, _ edit: (inout C.Dynamics) -> Void) throws {
                var bad = c; edit(&bad.dynamics!); try emit(suffix, bad, expected: false)
            }
            func common(_ suffix: String, _ edit: (inout [C.ImageAction], inout C.Program) -> Void) throws {
                var bad = c
                guard case var .common(images, program) = bad.dynamics!.hidden!.conclusion else { fatalError("common expected") }
                edit(&images, &program)
                bad.dynamics!.hidden!.conclusion = .common(actions: images, program: program)
                try emit(suffix, bad, expected: false)
            }
            try emit("", c, expected: true)
            try mutate("LostHiddenEvidence") { $0.hiddenActions = [] }
            try mutate("ExtraHiddenEvidence") { $0.hiddenActions! += $0.hiddenActions! }
            try mutate("WrongHiddenMember") { $0.hiddenActions![0].member = [.right, .right, .right] }
            if c.dynamics!.hidden == nil {
                try mutate("UnknownPreservationEdge") { $0.hiddenActions![0].preservation = .notPreserved(edge: [.right]) }
                try mutate("FalsePreservation") { $0.hiddenActions![0].preservation = .preserved([.address]) }
                continue
            }
            try mutate("LostHiddenJudgment") { $0.hidden = nil }
            try mutate("MissingClasses") { $0.hidden!.classes = [] }
            try mutate("DuplicateClass") { $0.hidden!.classes += [$0.hidden!.classes[0]] }
            try mutate("UnknownClass") { $0.hidden!.classes[0] = 999 }
            try mutate("FalseInheritance") { $0.hidden!.closureInheritedFromStableView.toggle() }
            if name == "HiddenOutside" {
                try mutate("UnknownOutsideMember") { $0.hidden!.conclusion = .outside(member: [.left], observation: [], image: [.right]) }
                try mutate("NonLeafObservation") { $0.hidden!.conclusion = .outside(member: [], observation: [.left], image: [.right]) }
                try mutate("FalseOutsideImage") { $0.hidden!.conclusion = .outside(member: [], observation: [], image: [.left]) }
                try mutate("UnknownOutsideImage") { $0.hidden!.conclusion = .outside(member: [], observation: [], image: [.right, .right]) }
            }
            if name == "HiddenDisagreement" {
                try mutate("ClassOrder") { $0.hidden!.classes.reverse() }
                try mutate("UnknownDisagreementMember") { $0.hidden!.conclusion = .disagreement(left: [], right: [.right], observation: [.left], leftImage: [.left], rightImage: [.right]) }
                try mutate("SameMember") { $0.hidden!.conclusion = .disagreement(left: [.left], right: [.left], observation: [.left], leftImage: [.left], rightImage: [.left]) }
                try mutate("NonLeafDisagreementObservation") { $0.hidden!.conclusion = .disagreement(left: [.left], right: [.right], observation: [], leftImage: [.left], rightImage: [.right]) }
                try mutate("FalseLeftImage") { $0.hidden!.conclusion = .disagreement(left: [.left], right: [.right], observation: [.left], leftImage: [.right], rightImage: [.right]) }
                try mutate("FalseRightImage") { $0.hidden!.conclusion = .disagreement(left: [.left], right: [.right], observation: [.left], leftImage: [.left], rightImage: [.left]) }
                try mutate("CoarsePartitionWithoutForest") {
                    $0.classes[0].leaves += $0.classes[1].leaves; $0.classes.removeLast(); $0.connections.removeLast()
                }
            }
            if case .common = c.dynamics!.hidden!.conclusion {
                try common("MissingCommonMember") { $0.removeLast(); _ = $1 }
                try common("WrongCommonMember") { $0[0].member = [.right, .right, .right]; _ = $1 }
                try common("WrongCommonProgram") { _, p in p = .pick([.left, .left, .left]) }
                try common("WrongMemberProgram") { images, _ in images[0].program = .pick([.right, .right]) }
                try common("MissingTargets") { images, _ in images[0].targets = [] }
                try common("InvalidTarget") { images, _ in images[0].targets[0] = 999 }
                try common("MissingSelections") { images, _ in images[0].selections = [] }
                try common("WrongOutput") { images, _ in images[0].selections[0].output = [.right, .right, .right] }
                try common("WrongInput") { images, _ in images[0].selections[0].input = [.right, .right, .right] }
                try common("ObservedValues") { images, _ in images[0].selections[0].basis = .observedValues }
            }
            if name == "HiddenEquivalentProjections" {
                try mutate("LostPreservationGround") { $0.hiddenActions![0].preservation = .preserved([]) }
                try mutate("FalsePreservationGround") { $0.hiddenActions![1].preservation = .preserved([.address]) }
                try mutate("EqualClassesDisagreement") { $0.hidden!.conclusion = .disagreement(left: [.left], right: [.right], observation: [.left], leftImage: [.left], rightImage: [.right]) }
                // A different common selector is lawful because the held coordinates are E-equal.
                var alternate = c, budget = C.ActionBudget()
                guard case let .common(original, _) = c.dynamics!.hidden!.conclusion else { fatalError("common") }
                var changed = original
                for (index, action) in r.hiddenActions!.enumerated() {
                    let image = try C.actionImage(action, of: r.observation)
                    changed[index].selections = try image.leaves.map { leaf in
                        try .init(output: leaf.output, input: [.right], basis: C.constructionBasis([.right], leaf.source, reading: r, budget: &budget))
                    }
                    changed[index].program = .pair(.pick([.right]), .pick([.right]))
                }
                let alternateProgram = changed[0].program
                alternate.dynamics!.hidden!.conclusion = .common(actions: changed, program: alternateProgram)
                try emit("OtherCommonProgram", alternate, expected: true)
                var independent = c
                var mixed = original
                mixed[0] = changed[0]
                independent.dynamics!.hidden!.conclusion = .common(actions: mixed, program: original[0].program)
                try emit("IndividuallyValidDifferentPrograms", independent, expected: false)
            }
        }
        lean += "end U8.ContractCases\n"
        try lean.write(toFile: out + "/ContractCases.lean", atomically: true, encoding: .utf8)
        try JSONSerialization.data(withJSONObject: records, options: [.sortedKeys, .prettyPrinted]).write(to: URL(fileURLWithPath: out + "/observations.json"))
        print("\(records.count) U8 Swift observations exported; model/code correspondence is not a theorem")
    }
}
