import Foundation

/// Instantiates one nominal declaration's actual bounds before using its
/// conformances. A recursive conformance claim cannot supply its own ground.
enum GenericMembership {
    typealias Term = WhereJudge.Term
    enum Proof {
        case established
        case missing(String, open: Bool)
    }

    static func head(_ input: Term, world: WhereJudge.World, rigid: Set<String>) throws -> Term {
        let source = DefinitionReduction.Source(world: world, rigid: rigid)
        let builder = DefinitionReduction.SharedBuilder(source: source,
            work: DefinitionReduction.Work(10_000, phase: "membership construction"), depthLimit: 64)
        let term = try builder.arena.read(DefinitionReduction.parse(Press.serialize(input), allowRigidNames: true))
        let proof = try builder.derive(term, head: true)
        // Reduce the full nominal term as well as its head. This is the
        // existing reduction law, not a complete Swift validity check;
        // an alias may still erase an unused argument.
        _ = try builder.derive(term)
        let replay = try DefinitionReduction.replayShared(builder.proof, source: source,
            work: DefinitionReduction.Work(20_000, phase: "membership replay"))
        guard replay.ends[proof].input == replay.terms[term] else {
            try WhereJudge.fail("membership reduction changes its source")
        }
        return try replay.arena.expression(replay.ends[proof].output).legacy
    }

    static func check(_ input: Term, proto: String, site: String,
                      world: WhereJudge.World, rigid: Set<String>, counted: inout Int) throws -> [String] {
        var facts: [String: Set<String>] = [:]
        var equations: [(Term, Term)] = []
        for conformer in world.conformers.values {
            guard !conformer.parameters.isEmpty else { continue }
            let context = try WhereJudge.conformerContext(conformer, world)
            guard context.rigid.isSubset(of: rigid) else { continue }
            for requirement in world.genericRequirements[conformer.name] ?? [] {
                let left = try WhereJudge.substitute(WhereJudge.parseTerm(Substring(requirement.left)), context.bindings)
                if requirement.kind == .member {
                    facts[Press.serialize(left), default: []].formUnion(
                        WhereJudge.inheritedProtocols([requirement.right], world))
                } else {
                    let right = try WhereJudge.substitute(WhereJudge.parseTerm(Substring(requirement.right)), context.bindings)
                    equations.append((left, right))
                }
            }
        }
        func open(_ term: Term) -> Bool {
            term.head.contains("$free_") || term.args.contains { open($0) }
        }
        func equivalent(_ left: Term, _ right: Term) throws -> Bool {
            if try WhereJudge.compared(left, right, world, rigid: rigid).equal { return true }
            var reachable: Set<String> = [Press.serialize(left)], changed = true
            while changed {
                let old = reachable
                for (a, b) in equations {
                    let l = Press.serialize(a), r = Press.serialize(b)
                    if reachable.contains(l) { reachable.insert(r) }
                    if reachable.contains(r) { reachable.insert(l) }
                }
                changed = old != reachable
            }
            return reachable.contains(Press.serialize(right))
        }
        var active = Set<String>(), memo: [String: Proof] = [:], remaining = 10_000
        func prove(_ input: Term, _ required: String, depth: Int = 0) throws -> Proof {
            remaining -= 1
            guard remaining >= 0, depth <= 64 else {
                try WhereJudge.fail("generic membership work limit reached; no impossibility inferred")
            }
            guard world.protocolParents[required] != nil else {
                try WhereJudge.fail("no declared protocol grounds for '\(required)'")
            }
            let term = try head(input, world: world, rigid: rigid)
            let spelled = Press.serialize(term), key = spelled + ": " + required
            if facts[spelled]?.contains(required) == true { return .established }
            if let known = memo[key] { return known }
            guard active.insert(key).inserted else {
                try WhereJudge.fail("gated membership cycle at '\(key)' has no independent ground")
            }
            defer { active.remove(key) }
            if open(term) && term.args.isEmpty && world.conformers[term.head] == nil {
                return .missing("membership '\(key)' is not established by the declared parameter bounds", open: true)
            }
            guard let conformer = world.conformers[term.head] else {
                try WhereJudge.fail("no declared conformer grounds for '\(spelled)'")
            }
            guard conformer.parameters.count == term.args.count else {
                try WhereJudge.fail("generic application '\(spelled)' has unbound arguments")
            }
            if let unsupported = world.genericUnsupported[term.head], !unsupported.isEmpty {
                try WhereJudge.fail("generic application '\(spelled)' carries unread conditions: " + unsupported.joined(separator: ", "))
            }
            var bindings = Dictionary(uniqueKeysWithValues: zip(conformer.parameters, term.args))
            bindings["Self"] = term
            var axes = Set(conformer.table.keys)
            for parent in WhereJudge.inheritedProtocols(conformer.protocols, world) {
                axes.formUnion(world.protocolAxes[parent] ?? [])
            }
            for axis in axes {
                guard bindings[axis] == nil else { continue }
                bindings[axis] = Term(head: spelled + "." + axis, args: [])
            }
            func substituted(_ text: String) throws -> Term {
                try WhereJudge.substitute(WhereJudge.parseTerm(Substring(text)), bindings)
            }
            for bound in world.genericRequirements[term.head] ?? [] {
                let left = try substituted(bound.left)
                let reason = "generic application '\(spelled)' requires bound '\(bound.left) \(bound.kind == .member ? ":" : "==") \(bound.right)'"
                if bound.kind == .member {
                    counted += 1
                    if case let .missing(message, uncertain) = try prove(left, bound.right, depth: depth + 1) {
                        if uncertain { return .missing(reason + ": " + message, open: true) }
                        throw WhereJudge.Failure.refused([reason + ": " + message])
                    }
                } else {
                    let right = try substituted(bound.right)
                    if try !equivalent(left, right) {
                        if open(left) || open(right) { return .missing(reason + ": equality not established", open: true) }
                        throw WhereJudge.Failure.refused([reason + ": equality not established"])
                    }
                }
            }
            guard WhereJudge.wears(conformer, required, world) else {
                return .missing("'\(spelled)' does not carry '\(required)'", open: false)
            }
            for parent in WhereJudge.inheritedProtocols(conformer.protocols, world).sorted() {
                guard let gate = world.gatedProtocols[parent] else { continue }
                guard gate.unjudged.isEmpty else {
                    try WhereJudge.fail("gated protocol '\(parent)' carries unread conditions")
                }
                for (left, right) in gate.equalities {
                    if try !equivalent(substituted(left), substituted(right)) {
                        return .missing("'\(spelled): \(parent)' requires '\(left) == \(right)'", open: true)
                    }
                }
                for (left, needed) in gate.memberships {
                    counted += 1
                    if case let .missing(reason, uncertain) = try prove(substituted(left), needed, depth: depth + 1) {
                        return .missing("'\(spelled): \(parent)' requires '\(left): \(needed)': " + reason, open: uncertain)
                    }
                }
            }
            memo[key] = .established
            return .established
        }
        switch try prove(input, proto) {
        case .established: return []
        case let .missing(reason, _): return ["'\(site)': " + reason]
        }
    }
}
