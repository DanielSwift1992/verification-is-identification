import Foundation

extension CountCourt {
    enum SharedRule {
        case zero, unit
        case plus(Int, Int)
    }
    struct SharedCountNode {
        var input: Int
        var reduction: Int
        var rule: SharedRule
    }
    struct SharedCountProof {
        var reduction: R.SharedProof
        var nodes: [SharedCountNode]
    }
    final class SharedCounter {
        let builder: R.SharedBuilder
        var nodes: [SharedCountNode] = []
        private
        var memo: [Int: Int] = [:]
        private
        var active = Set<Int>()
        init(_ builder: R.SharedBuilder) { self.builder = builder }
        func derive(_ input: Int, depth: Int = 0) throws -> Int {
            let arena = builder.arena
            try arena.work.visit()
            guard depth < 128 else { throw Failure("count expression exceeds the finite reader budget") }
            if let known = memo[input] { return known }
            guard active.insert(input).inserted else {
                throw Failure("cyclic count proof; no impossibility inferred")
            }
            defer { active.remove(input) }
            let reduction = try builder.derive(input, head: true)
            let output = builder.ends[reduction].output
            let rule: SharedRule
            switch try arena.get(output) {
            case .application("Never", []): rule = .zero
            case .application("Unit", []): rule = .unit
            case let .application("Plus", args):
                guard args.count == 2 else { throw Failure("Plus must have exactly two count operands") }
                rule = .plus(try derive(args[0], depth: depth + 1), try derive(args[1], depth: depth + 1))
            default:
                throw Failure("'\(arena.text(output))' is outside the finite Unit/Never/Plus count fragment")
            }
            let edges: Int
            switch rule {
            case .plus: edges = 3
            default: edges = 1
            }
            try arena.work.spend(1 + edges)
            arena.work.proofNodes += 1
            arena.work.proofEdges += edges
            let id = nodes.count
            nodes.append(SharedCountNode(input: input, reduction: reduction, rule: rule))
            memo[input] = id
            return id
        }
        var proof: SharedCountProof { SharedCountProof(reduction: builder.proof, nodes: nodes) }
    }

    static func replaySharedCount(
        _ proof: SharedCountProof, source: R.Source,
        work: R.Work, roots: [(Int, E)]
    ) throws -> (R.SharedReplay, [Int64]) {
        let replay = try R.replayShared(proof.reduction, source: source, work: work)
        // Counts have the signed 64-bit boundary of Court v0.2 on every
        // carrier. Term references, depths and work accounts remain Int.
        var values: [Int64] = []
        var depths: [Int] = []
        for node in proof.nodes {
            guard replay.terms.indices.contains(node.input), replay.ends.indices.contains(node.reduction),
                replay.ends[node.reduction].input == replay.terms[node.input]
            else { throw Failure("count proof changes its source") }
            let output = replay.ends[node.reduction].output
            let value: Int64
            let depth: Int
            let edges: Int
            switch (node.rule, try replay.arena.get(output)) {
            case (.zero, .application("Never", [])):
                value = 0
                depth = 1
                edges = 1
            case (.unit, .application("Unit", [])):
                value = 1
                depth = 1
                edges = 1
            case let (.plus(a, b), .application("Plus", args)):
                guard args.count == 2 else { throw Failure("Plus proof must have exactly two operands") }
                guard values.indices.contains(a), values.indices.contains(b) else {
                    throw Failure("count proof reference is not earlier than its node")
                }
                guard replay.terms[proof.nodes[a].input] == args[0],
                    replay.terms[proof.nodes[b].input] == args[1]
                else { throw Failure("count proof changes its operand") }
                let (sum, overflow) = values[a].addingReportingOverflow(values[b])
                guard !overflow else {
                    // Keep the addressed v0.2 diagnostic, also used by Rust.
                    throw Failure("count exceeds Int.max at '\(replay.arena.text(replay.terms[node.input]))'")
                }
                value = sum
                depth = 1 + max(depths[a], depths[b])
                edges = 3
            default: throw Failure("count proof uses a rule without its source shape")
            }
            guard depth <= 128 else { throw Failure("count proof exceeds the replay budget") }
            try work.spend(1 + edges)
            work.proofNodes += 1
            work.proofEdges += edges
            values.append(value)
            depths.append(depth)
        }
        for (root, expected) in roots {
            guard proof.nodes.indices.contains(root),
                replay.terms[proof.nodes[root].input] == (try replay.arena.read(expected))
            else {
                throw Failure("count proof belongs to a different question")
            }
        }
        return (replay, values)
    }

    // A reader owns one immutable source and fresh work accounts. Neither a
    // preceding file nor a prior request can warm these accounts into success.
    final class Reader {
        let source: R.Source
        let construction: R.Work
        let replay: R.Work
        let builder: R.SharedBuilder
        init(source: R.Source, constructionLimit: Int = 50_000, replayLimit: Int = 100_000) {
            self.source = source
            construction = R.Work(constructionLimit, phase: "construction")
            replay = R.Work(replayLimit, phase: "replay")
            builder = R.SharedBuilder(source: source, work: construction)
        }
        func normal(_ input: E) throws -> E { try normal(input, head: false) }
        func normalHead(_ input: E) throws -> E { try normal(input, head: true) }
        private func normal(_ input: E, head: Bool) throws -> E {
            let term = try builder.arena.read(input)
            let proof = try builder.derive(term, head: head)
            let checked = try R.replayShared(builder.proof, source: source, work: replay)
            guard checked.ends[proof].input == checked.terms[term] else {
                throw Failure("field reduction changes its source")
            }
            return try checked.arena.expression(checked.ends[proof].output)
        }
        func reading(_ root: E) throws -> (rightEqualsAnswer: Bool, actual: Int64, declared: Int64) {
            let right = try builder.arena.read(.field(root, "Right"))
            let answer = try builder.arena.read(.field(root, "Answer"))
            let input = try builder.arena.read(.field(root, "Left"))
            let rightProof = try builder.derive(right)
            let answerProof = try builder.derive(answer)
            let count = SharedCounter(builder)
            let actual = try count.derive(input)
            let declared = try count.derive(answer)
            let (checked, values) = try replaySharedCount(
                count.proof, source: source, work: replay,
                roots: [(actual, .field(root, "Left")), (declared, .field(root, "Answer"))])
            guard checked.ends[rightProof].input == checked.terms[right],
                checked.ends[answerProof].input == checked.terms[answer]
            else {
                throw Failure("field reduction changes its source")
            }
            return (
                checked.ends[rightProof].output == checked.ends[answerProof].output, values[actual],
                values[declared]
            )
        }
        func count(_ input: E) throws -> Int64 {
            let term = try builder.arena.read(input)
            let counter = SharedCounter(builder)
            let root = try counter.derive(term)
            return try replaySharedCount(counter.proof, source: source, work: replay, roots: [(root, input)])
                .1[root]
        }
    }
}
