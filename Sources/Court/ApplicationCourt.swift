import Foundation

/// Application closure over the structural type-relation fragment.
/// Raw declaration equations compute obligations; only a checked closed graph
/// establishes that those obligations hold. No Boolean admission flag is used.
enum ApplicationCourt {
    typealias R = DefinitionReduction
    typealias E = R.Expression
    typealias Failure = R.Failure

    enum Goal: Hashable {
        case root(E), form(E), member(E, String), contract(E, String)
        var text: String {
            switch self {
            case let .root(e): return "root " + e.text
            case let .form(e): return "form " + e.text
            case let .member(e, p): return e.text + " : " + p
            case let .contract(e, p): return "relations " + e.text + " / " + p
            }
        }
    }
    struct Node {
        let reductions: [R.Derivation]
        let dependencies: Set<Goal>
        let prerequisites: Set<Goal>
    }
    struct Derivation {
        let root: E
        var nodes: [Goal: Node]
    }

    /// A local rule interpreter. During replay, every requested reduction must
    /// be supplied by the finite proof and is checked, without normalizing again.
    final class Step {
        let source: StructuralSource
        let goal: Goal
        let proposed: [R.Derivation]?
        var readIndex = 0
        var reductions: [R.Derivation] = []
        var dependencies: Set<Goal> = [], prerequisites: Set<Goal> = []
        init(_ goal: Goal, _ source: StructuralSource, replay: [R.Derivation]?) {
            self.goal = goal
            self.source = source
            self.proposed = replay
        }
        func add(_ dependency: Goal, strict: Bool = false) {
            dependencies.insert(dependency)
            if strict { prerequisites.insert(dependency) }
        }
        func declaration(_ name: String) throws -> StructuralSource.Declaration {
            guard let d = source.declarations[name] else {
                throw Failure("no source declaration for '\(name)'")
            }
            guard d.unsupported.isEmpty else {
                throw Failure("unsupported \(name): \(d.unsupported.joined(separator: "; "))")
            }
            return d
        }
        func parse(_ s: String) throws -> E { try R.parse(s) }

        func account(_ proof: R.Derivation) {
            switch proof {
            case .name: break
            case let .arguments(_, ps): ps.forEach(account)
            case let .field(p, _): account(p)
            case let .join(a, b):
                account(a)
                account(b)
            case let .unfold(input, p):
                let owner: E
                switch input {
                case .application: owner = input
                case let .field(o, axis):
                    owner = o
                    if case let .application(name, _) = o,
                        let provider = source.defaultProviders[name]?[axis]
                    {
                        add(.member(o, provider))
                    }
                }
                // The owner's own body computes its conditions without assuming
                // its admission. Other guarded applications remain prerequisites.
                if goal != .form(owner) { add(.form(owner), strict: true) }
                account(p)
            }
        }
        func read(_ expression: E, headOnly: Bool = true) throws -> E {
            let raw = R.Source(world: source.syntax, rigid: [])
            let proof: R.Derivation
            if let proposed {
                guard readIndex < proposed.count else {
                    throw Failure("missing reduction at \(goal.text)")
                }
                proof = proposed[readIndex]
                readIndex += 1
            } else {
                proof = try R.derive(
                    expression, source: raw, depthLimit: 128, nodeLimit: 50_000, headOnly: headOnly)
            }
            let ends = try R.replay(proof, source: raw, nodeLimit: 100_000)
            guard ends.input == expression else {
                throw Failure("reduction changes the question at \(goal.text)")
            }
            reductions.append(proof)
            account(proof)
            return ends.output
        }

        func bindings(_ owner: E, protocolName: String? = nil) throws -> [String: E] {
            guard case let .application(name, args) = owner else {
                throw Failure("owner is not exposed: \(owner.text)")
            }
            let d = try declaration(name)
            guard d.parameters.count == args.count else {
                throw Failure("wrong argument count for \(owner.text)")
            }
            var values = Dictionary(uniqueKeysWithValues: zip(d.parameters, args))
            values["Self"] = owner
            var axes = Set(source.syntax.conformers[name]?.table.keys.map { $0 } ?? [])
            let protos = protocolName.map { [$0] } ?? source.conformanceChoices(name).map { $0.0 }
            for p in source.protocolClosure(protos) {
                axes.formUnion(source.declarations[p]?.axes.map(\.name) ?? [])
            }
            for axis in axes
            where values[axis] == nil { values[axis] = .field(owner, axis) }
            return values
        }
        func require(
            _ requirements: [StructuralSource.Requirement], at owner: E,
            protocolName: String? = nil, strict: Bool
        ) throws {
            let env = try bindings(owner, protocolName: protocolName)
            for requirement in requirements {
                let left = try parse(requirement.left).substituting(env)
                switch requirement.kind {
                case .member: add(.member(left, requirement.right), strict: strict)
                case .equal:
                    let right = try parse(requirement.right).substituting(env)
                    let l = try read(left, headOnly: false)
                    let r = try read(right, headOnly: false)
                    guard l == r else {
                        throw Failure(
                            "unproved equality at \(goal.text): \(left.text) versus \(right.text)\n  \(l.text)\n  \(r.text)"
                        )
                    }
                }
            }
        }

        func plan() throws -> Node {
            switch goal {
            case let .root(expression):
                add(.form(expression), strict: true)
                let head = try read(expression)
                guard case let .application(name, _) = head else {
                    throw Failure("root has no declaration")
                }
                let d = try declaration(name)
                for p in d.parents { add(.member(head, p)) }
            case let .form(expression):
                switch expression {
                case .field:
                    let result = try read(expression)
                    guard result != expression else {
                        throw Failure("unresolved field \(expression.text)")
                    }
                    add(.form(result), strict: true)
                case let .application(name, args):
                    let d = try declaration(name)
                    guard d.kind != "protocol", d.parameters.count == args.count else {
                        throw Failure("not a nominal application: \(expression.text)")
                    }
                    for a in args { add(.form(a), strict: true) }
                    try require(d.requirements, at: expression, strict: true)
                    if d.kind == "typealias" {
                        let result = try read(expression)
                        guard result != expression else { throw Failure("alias did not unfold") }
                        add(.form(result), strict: true)
                    }
                }
            case let .member(expression, proto):
                let p = try declaration(proto)
                guard p.kind == "protocol" else { throw Failure("not a protocol: \(proto)") }
                // A projected associated-type witness participates in the
                // recursive structural record. Its owner's application still
                // has separate strict prerequisites. A nominal application
                // cannot borrow its own admission through this route.
                if case .field = expression {
                    add(.form(expression))
                } else {
                    add(.form(expression), strict: true)
                }
                let subject = try read(expression)
                if subject != expression {
                    add(.member(subject, proto))
                    break
                }
                guard case let .application(name, _) = subject else {
                    throw Failure("membership owner not exposed")
                }
                let d = try declaration(name)
                var witnesses: [(String, [StructuralSource.Requirement], [String])] = d.parents.map
                { ($0, [], []) }
                for ext in source.extensions[name] ?? [] {
                    witnesses += ext.parents.map { ($0, ext.requirements, ext.unsupported) }
                }
                let eligible = witnesses.filter { source.protocolClosure([$0.0]).contains(proto) }
                    .sorted { a, b in
                        let ac = source.protocolClosure([a.0]).count,
                            bc = source.protocolClosure([b.0]).count
                        return ac == bc ? a.0 < b.0 : ac < bc
                    }
                guard let witness = eligible.first else {
                    throw Failure("no source conformance \(subject.text) : \(proto)")
                }
                guard witness.2.isEmpty else { throw Failure("unsupported conformance on \(name)") }
                try require(witness.1, at: subject, strict: true)
                add(.contract(subject, witness.0))
            case let .contract(subject, proto):
                let d = try declaration(proto)
                guard d.kind == "protocol" else { throw Failure("not a protocol contract") }
                for p in d.parents { add(.contract(subject, p)) }
                for axis in d.axes {
                    add(.form(.field(subject, axis.name)))
                    try require(axis.constraints, at: subject, protocolName: proto, strict: false)
                }
                try require(d.requirements, at: subject, protocolName: proto, strict: false)
            }
            if let proposed, readIndex != proposed.count {
                throw Failure("unused reductions at \(goal.text)")
            }
            return Node(
                reductions: reductions, dependencies: dependencies, prerequisites: prerequisites)
        }
    }

    static func derive(_ root: E, source: StructuralSource, nodeLimit: Int = 20_000, predicate: String? = nil) throws
        -> Derivation
    {
        var nodes: [Goal: Node] = [:], work: [Goal] = [predicate.map { .member(root, $0) } ?? .root(root)]
        while let goal = work.popLast() {
            if nodes[goal] != nil { continue }
            guard nodes.count < nodeLimit else { throw Failure("application graph limit reached") }
            let node = try Step(goal, source, replay: nil).plan()
            nodes[goal] = node
            work += node.dependencies.sorted { $0.text > $1.text }
        }
        let result = Derivation(root: root, nodes: nodes)
        try verify(root, derivation: result, source: source, predicate: predicate)
        return result
    }

    static func verify(_ root: E, derivation: Derivation, source: StructuralSource, predicate: String? = nil) throws {
        guard root == derivation.root else {
            throw Failure("application proof belongs to a different root")
        }
        var seen: Set<Goal> = [], work: [Goal] = [predicate.map { .member(root, $0) } ?? .root(root)]
        while let goal = work.popLast() {
            if !seen.insert(goal).inserted { continue }
            guard let proposed = derivation.nodes[goal] else {
                throw Failure("missing dependency \(goal.text)")
            }
            let checked = try Step(goal, source, replay: proposed.reductions).plan()
            guard checked.dependencies == proposed.dependencies,
                checked.prerequisites == proposed.prerequisites
            else {
                throw Failure("changed dependency boundary at \(goal.text)")
            }
            work += checked.dependencies
        }
        guard seen == Set(derivation.nodes.keys) else {
            throw Failure("unrelated nodes appended to application proof")
        }
        // Structural protocol recursion may close coinductively. An admission
        // prerequisite may not be obtained from the very admission it supports.
        var reachMemo: [Goal: Set<Goal>] = [:]
        func reachable(_ start: Goal) -> Set<Goal> {
            if let known = reachMemo[start] { return known }
            var visited: Set<Goal> = [], pending: [Goal] = [start]
            while let q = pending.popLast() {
                if visited.insert(q).inserted { pending += derivation.nodes[q]!.dependencies }
            }
            reachMemo[start] = visited
            return visited
        }
        for (goal, node) in derivation.nodes {
            for dependency in node.prerequisites
            where reachable(dependency).contains(goal) {
                throw Failure("circular admission: \(goal.text) requires \(dependency.text)")
            }
        }
    }

    static func run(_ arguments: [String]) {
        do {
            guard arguments.count >= 2 else {
                throw Failure("usage: judge apply <root-expression> <source.swift ...>")
            }
            let root = try R.parse(arguments[0])
            let files = try arguments.dropFirst().map {
                ($0, try String(contentsOfFile: $0, encoding: .utf8))
            }
            let source = try StructuralSource(files: files)
            let proof = try derive(root, source: source)
            let reads = proof.nodes.values.reduce(0) { $0 + $1.reductions.count }
            print(
                "✓ APPLICATION: \(root.text); \(proof.nodes.count) closed structural obligations; \(reads) replayed reductions"
            )
            print(
                "Scope: declared type relations; value implementations and conditional-compilation blocks (\(source.excludedConditionals)) are not proved."
            )
        } catch {
            FileHandle.standardError.write(Data("✗ APPLICATION unresolved: \(error)\n".utf8))
            exit(2)
        }
    }
}
