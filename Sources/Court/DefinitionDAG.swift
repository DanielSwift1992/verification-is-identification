import Foundation

// The count reader shares expressions and derivations. The where reader keeps
// its existing tree calculus. References save work; they do not assert results.
extension DefinitionReduction {
    final class Work {
        var remaining: Int
        var nodes = 0, edges = 0, substitutions = 0, visits = 0
        var proofNodes = 0, proofEdges = 0
        let phase: String
        init(_ limit: Int, phase: String) {
            remaining = limit
            self.phase = phase
        }
        func spend(_ n: Int = 1) throws {
            guard n >= 0, remaining >= n else {
                throw Failure("count \(phase) work limit reached; no impossibility inferred")
            }
            remaining -= n
        }
        func visit() throws {
            try spend()
            visits += 1
        }
        var measurements: [String: Int] {
            [
                "terms": nodes, "term_edges": edges, "substitutions": substitutions,
                "visits": visits, "proof_nodes": proofNodes, "proof_edges": proofEdges,
            ]
        }
    }

    enum Term: Hashable {
        case application(String, [Int])
        case field(Int, String)
        static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case let (.application(a, xs), .application(b, ys)): return WhereJudge.sameName(a, b) && xs == ys
            case let (.field(x, a), .field(y, b)): return x == y && WhereJudge.sameName(a, b)
            default: return false
            }
        }
        func hash(into hasher: inout Hasher) {
            switch self {
            case let .application(n, args):
                hasher.combine(0)
                hasher.combine(ScalarName(n))
                hasher.combine(args)
            case let .field(e, n):
                hasher.combine(1)
                hasher.combine(e)
                hasher.combine(ScalarName(n))
            }
        }
        var references: [Int] {
            switch self {
            case let .application(_, a): return a
            case let .field(o, _): return [o]
            }
        }
    }

    final class Arena {
        let source: Source
        let work: Work
        var terms: [Term] = []
        var depths: [Int] = []
        private
        var interned: [Term: Int] = [:]
        private
        var parsed: NameMap<Expression> = [:]
        init(source: Source, work: Work) {
            self.source = source
            self.work = work
        }
        func get(_ id: Int) throws -> Term {
            guard terms.indices.contains(id) else { throw Failure("invalid count term reference") }
            return terms[id]
        }
        func add(_ term: Term) throws -> Int {
            try work.visit()
            if let id = interned[term] { return id }
            let refs = term.references
            guard refs.allSatisfy({ terms.indices.contains($0) }) else {
                throw Failure("count term reference is not earlier than its node")
            }
            let depth = 1 + (refs.map { depths[$0] }.max() ?? 0)
            guard depth <= 128 else { throw Failure("expression exceeds validation depth limit") }
            switch term {
            case let .application(name, args):
                let validName = source.world.nestedNames.contains(name)
                    ? true : try parse(name, allowRigidNames: true) == .application(name, [])
                guard validName else {
                    throw Failure("malformed name in derivation input")
                }
                try source.checkApplication(name, args.count)
            case let .field(_, axis):
                guard try parse(axis) == .application(axis, []) else { throw Failure("malformed field") }
            }
            try work.spend(1 + refs.count)
            work.nodes += 1
            work.edges += refs.count
            let id = terms.count
            terms.append(term)
            depths.append(depth)
            interned[term] = id
            return id
        }
        func read(_ expression: Expression, bindings: NameMap<Int> = [:]) throws -> Int {
            try work.visit()
            if source.world.nestedNames.contains(expression.text) {
                return try add(.application(expression.text, []))
            }
            switch expression {
            case let .application(name, args):
                if let replacement = bindings[name] {
                    guard args.isEmpty else {
                        throw Failure("parameter '\(name)' used as a type constructor")
                    }
                    return replacement
                }
                return try add(.application(name.text, args.map { try read($0, bindings: bindings) }))
            case let .field(owner, axis): return try add(.field(read(owner, bindings: bindings), axis.text))
            }
        }
        func body(_ text: String, bindings: NameMap<Int>) throws -> Int {
            let expression: Expression
            if let old = parsed[text] {
                expression = old
            } else {
                expression = try parse(text)
                parsed[text] = expression
            }
            try work.spend()
            work.substitutions += 1
            return try read(expression, bindings: bindings)
        }
        // The same source equations as Source.expansion, with simultaneous
        // substitution of references instead of copying their entire trees.
        func expansion(_ id: Int) throws -> Int? {
            switch try get(id) {
            case let .application(name, args):
                try source.checkApplication(name, args.count)
                guard !source.rigid.contains(name), let d = source.world.aliases[name] else { return nil }
                return try body(d.body, bindings: NameMap(uniqueKeysWithValues: zip(d.parameters, args)))
            case let .field(owner, axis):
                guard case let .application(name, args) = try get(owner) else { return nil }
                if source.world.intrinsicSwift, WhereJudge.sameName(name, "Swift"), args.isEmpty {
                    if WhereJudge.sameName(axis, "Never") || (source.world.contextVersion == 2 && WhereJudge.sameName(axis, "String")) {
                        return try add(.application(axis, []))
                    }
                }
                if source.world.namespaces.contains(name) {
                    throw Failure("no declaration of nested name '\(self.text(id))'")
                }
                try source.checkApplication(name, args.count)
                guard let (d, text) = try source.memberDefinition(name, axis: axis, spelled: self.text(id)) else {
                    return nil
                }
                var bindings = NameMap(uniqueKeysWithValues: zip(d.parameters, args))
                bindings["Self"] = owner
                for sibling in d.table.keys.sorted()
                where bindings[sibling] == nil {
                    bindings[sibling] = try add(.field(owner, sibling))
                }
                return try body(text, bindings: bindings)
            }
        }
        func expression(_ id: Int) throws -> Expression {
            try work.visit()
            switch try get(id) {
            case let .application(n, a): return .application(n, try a.map(expression))
            case let .field(o, a): return .field(try expression(o), a)
            }
        }
        // Diagnostics must not turn sharing back into an unbounded tree walk.
        func text(_ id: Int) -> String {
            var left = 10_000
            func walk(_ id: Int) -> String {
                guard left > 0, terms.indices.contains(id) else { return "…" }
                left -= 1
                switch terms[id] {
                case let .application(n, a):
                    return a.isEmpty ? n : n + "<" + a.map(walk).joined(separator: ", ") + ">"
                case let .field(o, a): return walk(o) + "." + a
                }
            }
            return walk(id)
        }
    }

    enum SharedStep {
        case name(String)
        case arguments(String, [Int])
        case field(Int, String)
        case unfold(Int, Int)  // source term, continuation proof
        case join(Int, Int)
        var references: [Int] {
            switch self {
            case .name: return []
            case let .arguments(_, a): return a
            case let .field(o, _): return [o]
            case let .unfold(_, p): return [p]
            case let .join(a, b): return [a, b]
            }
        }
    }
    struct SharedEnds {
        let input: Int
        let output: Int
        let depth: Int
    }
    struct SharedProof {
        var terms: [Term]
        var steps: [SharedStep]
    }
    struct ModeKey: Hashable {
        let term: Int
        let head: Bool
    }

    final class SharedBuilder {
        let arena: Arena
        let depthLimit: Int
        var steps: [SharedStep] = []
        var ends: [SharedEnds] = []
        private
        var memo: [ModeKey: Int] = [:]
        private
        var identity: [Int: Int] = [:]
        private
        var active = Set<ModeKey>()
        init(source: Source, work: Work, depthLimit: Int = 128) {
            arena = Arena(source: source, work: work)
            self.depthLimit = depthLimit
        }
        var proof: SharedProof { SharedProof(terms: arena.terms, steps: steps) }
        func append(_ step: SharedStep, input: Int, output: Int) throws -> Int {
            let refs = step.references
            let depth = 1 + (refs.map { ends[$0].depth }.max() ?? 0)
            guard depth < 512 else { throw Failure("derivation replay limit reached") }
            try arena.work.spend(1 + refs.count)
            arena.work.proofNodes += 1
            arena.work.proofEdges += refs.count
            let id = steps.count
            steps.append(step)
            ends.append(SharedEnds(input: input, output: output, depth: depth))
            return id
        }
        func unchanged(_ id: Int) throws -> Int {
            try arena.work.visit()
            if let known = identity[id] { return known }
            let step: SharedStep
            switch try arena.get(id) {
            case let .application(n, a): step = a.isEmpty ? .name(n) : .arguments(n, try a.map(unchanged))
            case let .field(o, a): step = .field(try unchanged(o), a)
            }
            let p = try append(step, input: id, output: id)
            identity[id] = p
            return p
        }
        func derive(_ id: Int, head: Bool = false, depth: Int = 0) throws -> Int {
            try arena.work.visit()
            guard depth <= depthLimit else {
                throw Failure("normalization limit reached at '\(arena.text(id))'; no impossibility inferred")
            }
            let key = ModeKey(term: id, head: head)
            if let known = memo[key] { return known }
            guard active.insert(key).inserted else {
                throw Failure("cyclic count definition at '\(arena.text(id))'; no impossibility inferred")
            }
            defer { active.remove(key) }
            let p: Int
            switch try arena.get(id) {
            case let .application(n, a):
                if let body = try arena.expansion(id) {
                    let child = try derive(body, head: head, depth: depth + 1)
                    p = try append(.unfold(id, child), input: id, output: ends[child].output)
                } else if a.isEmpty || head {
                    p = try unchanged(id)
                } else {
                    let children = try a.map { try derive($0, depth: depth + 1) }
                    let output = try arena.add(.application(n, children.map { ends[$0].output }))
                    p = try append(.arguments(n, children), input: id, output: output)
                }
            case let .field(owner, axis):
                let ownerProof = try derive(owner, head: true, depth: depth + 1)
                let at = try arena.add(.field(ends[ownerProof].output, axis))
                let field = try append(.field(ownerProof, axis), input: id, output: at)
                if let body = try arena.expansion(at) {
                    let child = try derive(body, head: head, depth: depth + 1)
                    let unfolded = try append(.unfold(at, child), input: at, output: ends[child].output)
                    p = try append(.join(field, unfolded), input: id, output: ends[child].output)
                } else {
                    p = field
                }
            }
            memo[key] = p
            return p
        }
    }

    struct SharedReplay {
        let arena: Arena
        let terms: [Int]
        let ends: [SharedEnds]
    }
    // Replay owns a fresh arena and reconstructs every endpoint. It never calls
    // SharedBuilder and never reads a builder's memo or asserted numeric value.
    static func replayShared(_ proof: SharedProof, source: Source, work: Work) throws -> SharedReplay {
        let arena = Arena(source: source, work: work)
        var terms: [Int] = []
        var ends: [SharedEnds] = []
        for term in proof.terms {
            guard term.references.allSatisfy({ terms.indices.contains($0) }) else {
                throw Failure("count term reference is not earlier than its node")
            }
            switch term {
            case let .application(n, a): terms.append(try arena.add(.application(n, a.map { terms[$0] })))
            case let .field(o, a): terms.append(try arena.add(.field(terms[o], a)))
            }
        }
        for step in proof.steps {
            let refs = step.references
            guard refs.allSatisfy({ ends.indices.contains($0) }) else {
                throw Failure("count proof reference is not earlier than its node")
            }
            let depth = 1 + (refs.map { ends[$0].depth }.max() ?? 0)
            guard depth < 512 else { throw Failure("derivation replay limit reached") }
            try work.spend(1 + refs.count)
            work.proofNodes += 1
            work.proofEdges += refs.count
            let input: Int
            let output: Int
            switch step {
            case let .name(n):
                input = try arena.add(.application(n, []))
                output = input
            case let .arguments(n, a):
                input = try arena.add(.application(n, a.map { ends[$0].input }))
                output = try arena.add(.application(n, a.map { ends[$0].output }))
            case let .field(o, a):
                input = try arena.add(.field(ends[o].input, a))
                output = try arena.add(.field(ends[o].output, a))
            case let .unfold(t, continuation):
                guard terms.indices.contains(t) else { throw Failure("invalid count term reference") }
                input = terms[t]
                guard let body = try arena.expansion(input) else {
                    throw Failure("no source definition to unfold at '\(arena.text(input))'")
                }
                guard ends[continuation].input == body else {
                    throw Failure("unfolded body differs from source at '\(arena.text(input))'")
                }
                output = ends[continuation].output
            case let .join(a, b):
                guard ends[a].output == ends[b].input else {
                    throw Failure("derivations have different shared boundaries")
                }
                input = ends[a].input
                output = ends[b].output
            }
            ends.append(SharedEnds(input: input, output: output, depth: depth))
        }
        return SharedReplay(arena: arena, terms: terms, ends: ends)
    }
}
