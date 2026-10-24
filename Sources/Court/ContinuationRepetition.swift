import Foundation

// U11 checks source-class orbits, not payload states. The supplied interface
// repeats one unknown fixed member; this court does not execute that interface.
extension ContinuationCourt {
    struct ReturnCycle: Codable {
        var member: Path
        var block: Int
        var vertices: [Int]
        var length: Int
    }
    struct ReturnArithmetic: Codable {
        var gcd: Int
        var multiplier: Int
        var value: String
    }
    struct ReturnBlock: Codable {
        var cycles: [ReturnCycle]
        var arithmetic: [ReturnArithmetic]
        // Canonical decimal naturals avoid a machine-integer call-count bound.
        var calls: String
        var additionalCalls: String
    }
    struct ReturnTail: Codable {
        var member: Path
        var block: Int
        var vertices: [Int]
        var repeatedIndex: Int
    }
    enum ReturnConclusion: Codable {
        case returned(ReturnBlock)
        case obstructed(ReturnTail)
    }
    struct Repetition: Codable {
        var classes: [PartitionClass]
        var connections: [[EqualityStep]]
        var required: [Int]
        var hiddenActions: [ActionEvidence]
        // Nil exactly when H fails the E-preservation premise of U11.
        var conclusion: ReturnConclusion?
    }
    // Exact arithmetic for the declared LCM rule. Only bounded cycle lengths
    // are machine integers; the call count is a finite decimal numeral.
    struct ReturnCount {
        var digits: [Int]
        init(digits: [Int]) { self.digits = digits }
        init(_ text: String, at: String, budget: inout ActionBudget) throws {
            let bytes = Array(text.utf8)
            try budget.spend(bytes.count, at: at)
            guard !bytes.isEmpty, bytes.allSatisfy({ $0 >= 48 && $0 <= 57 }),
                  bytes.count == 1 || bytes.first != 48 else {
                throw Failure(at + ": expected a canonical decimal natural")
            }
            digits = bytes.reversed().map { Int($0 - 48) }
        }
        var text: String { digits.reversed().map { String($0) }.joined() }
        func remainder(_ divisor: Int, at: String, budget: inout ActionBudget) throws -> Int {
            guard divisor > 0, divisor <= ActionBudget.limit else { throw Failure(at + ": cycle-length bound") }
            var value = 0
            for digit in digits.reversed() {
                try budget.spend(at: at)
                value = (value * 10 + digit) % divisor
            }
            return value
        }
        func multiplied(_ factor: Int, at: String, budget: inout ActionBudget) throws -> ReturnCount {
            guard factor > 0, factor <= ActionBudget.limit else { throw Failure(at + ": cycle-length bound") }
            var result: [Int] = [], carry = 0
            for digit in digits {
                try budget.spend(at: at)
                let value = digit * factor + carry
                result.append(value % 10)
                carry = value / 10
            }
            while carry > 0 {
                try budget.spend(at: at)
                result.append(carry % 10)
                carry /= 10
            }
            return .init(digits: result)
        }
        func predecessor(at: String, budget: inout ActionBudget) throws -> ReturnCount {
            guard digits != [0] else { throw Failure(at + ": total calls must be positive") }
            var result = digits, index = 0
            while result[index] == 0 {
                try budget.spend(at: at)
                result[index] = 9
                index += 1
            }
            try budget.spend(at: at)
            result[index] -= 1
            while result.count > 1, result.last == 0 { result.removeLast() }
            return .init(digits: result)
        }
    }
    static func returnGCD(_ count: ReturnCount, length: Int, at: String,
                          budget: inout ActionBudget) throws -> Int {
        var a = length, b = try count.remainder(length, at: at, budget: &budget)
        while b > 0 {
            try budget.spend(at: at)
            let next = a % b
            a = b
            b = next
        }
        return a
    }
    static func repetitionMembers(_ r: RelatedReading, at: String) throws -> [ActionMember] {
        guard let members = r.hiddenActions, !members.isEmpty else {
            throw Failure(at + ".HiddenActions: a nonempty declared family is required for U11")
        }
        return members
    }
    static func constructRepetition(_ r: RelatedReading, request: String) throws -> Repetition {
        let members = try repetitionMembers(r, at: request)
        var budget = ActionBudget()
        try budget.spend(r.source.leaves.count + r.edges.count, at: "construction.repetition")
        let (classes, connections, blocks) = constructPartition(r)
        let required = distinctClasses(r.question, blocks: blocks)
        let evidence = try constructEvidence(members, reading: r, blocks: blocks, budget: &budget)
        var result = Repetition(classes: classes, connections: connections, required: required,
                                hiddenActions: evidence, conclusion: nil)
        guard evidenceHolds(evidence) else { return result }
        var cycles: [ReturnCycle] = []
        for member in members {
            for block in required {
                var vertices = [block], visited = [block: 0], current = block
                while true {
                    try budget.spend(at: "construction.repetition.orbit")
                    let next = try classImage(member, block: current, classes: classes, blocks: blocks)
                    vertices.append(next)
                    if let index = visited[next] {
                        if next != block {
                            result.conclusion = .obstructed(.init(member: member.address, block: block,
                                vertices: vertices, repeatedIndex: index))
                            return result
                        }
                        cycles.append(.init(member: member.address, block: block,
                                            vertices: vertices, length: vertices.count - 1))
                        break
                    }
                    visited[next] = vertices.count - 1
                    current = next
                }
            }
        }
        var count = ReturnCount(digits: [1]), arithmetic: [ReturnArithmetic] = []
        for cycle in cycles {
            let gcd = try returnGCD(count, length: cycle.length, at: "construction.repetition.lcm", budget: &budget)
            let multiplier = cycle.length / gcd
            count = try count.multiplied(multiplier, at: "construction.repetition.lcm", budget: &budget)
            arithmetic.append(.init(gcd: gcd, multiplier: multiplier, value: count.text))
        }
        result.conclusion = try .returned(.init(cycles: cycles, arithmetic: arithmetic, calls: count.text,
            additionalCalls: count.predecessor(at: "construction.repetition.additionalCalls", budget: &budget).text))
        return result
    }

    // Replay checks only the supplied finite walks and arithmetic. It never
    // searches the class graph, finds an orbit or invokes a constructor.
    static func verifyReturnWalk(_ vertices: [Int], member: ActionMember,
                                 classes: [PartitionClass], blocks: [Path: Int], at: String,
                                 budget: inout ActionBudget) throws {
        guard vertices.count >= 2, vertices.count - 1 <= classes.count else {
            throw Failure(at + ": expected a finite first-repeat walk")
        }
        try budget.spend(vertices.count, at: at)
        guard Set(vertices.dropLast()).count == vertices.count - 1 else {
            throw Failure(at + ": a vertex repeats before the endpoint")
        }
        for (index, pair) in zip(vertices, vertices.dropFirst()).enumerated() {
            guard classes.indices.contains(pair.0), classes.indices.contains(pair.1),
                  try classImage(member, block: pair.0, classes: classes, blocks: blocks) == pair.1 else {
                throw Failure(at + "[\(index + 1)]: not the declared class image")
            }
        }
    }
    static func verifyReturnBlock(_ proof: ReturnBlock, members: [ActionMember], required: [Int],
                                  classes: [PartitionClass], blocks: [Path: Int],
                                  budget: inout ActionBudget) throws {
        let at = "certificate.repetition.conclusion.returned"
        let (pairs, overflow) = members.count.multipliedReportingOverflow(by: required.count)
        guard !overflow, proof.cycles.count == pairs, proof.arithmetic.count == pairs else {
            throw Failure(at + ".cycles: incomplete member/Question-class coverage")
        }
        var index = 0, count = ReturnCount(digits: [1])
        for member in members {
            for block in required {
                let here = at + ".cycles[\(index)]"
                let cycle = proof.cycles[index]
                guard cycle.member == member.address, cycle.block == block else {
                    throw Failure(here + ": different member, Question class or pair order")
                }
                try verifyReturnWalk(cycle.vertices, member: member, classes: classes, blocks: blocks,
                                     at: here + ".vertices", budget: &budget)
                guard cycle.vertices.first == block, cycle.vertices.last == block else {
                    throw Failure(here + ".vertices: cycle must start and return to the required class")
                }
                guard cycle.length == cycle.vertices.count - 1 else {
                    throw Failure(here + ".length: differs from the first return")
                }
                let arithmeticAt = at + ".arithmetic[\(index)]"
                let step = proof.arithmetic[index]
                let gcd = try returnGCD(count, length: cycle.length, at: arithmeticAt, budget: &budget)
                guard step.gcd == gcd, step.multiplier == cycle.length / gcd else {
                    throw Failure(arithmeticAt + ": incorrect gcd or LCM multiplier")
                }
                count = try count.multiplied(step.multiplier, at: arithmeticAt, budget: &budget)
                guard step.value == count.text else { throw Failure(arithmeticAt + ".value: not the exact LCM") }
                index += 1
            }
        }
        _ = try ReturnCount(proof.calls, at: at + ".calls", budget: &budget)
        guard proof.calls == count.text else { throw Failure(at + ".calls: expected the least positive common return") }
        let further = try count.predecessor(at: at + ".additionalCalls", budget: &budget)
        guard proof.additionalCalls == further.text else {
            throw Failure(at + ".additionalCalls: expected total calls minus the obligatory first call")
        }
    }
    static func verifyRepetition(_ proof: Repetition, reading r: RelatedReading,
                                 request: String) throws -> Bool {
        let at = "certificate.repetition"
        let members = try repetitionMembers(r, at: request)
        var budget = ActionBudget()
        try budget.spend(r.source.leaves.count + r.edges.count, at: at)
        let blocks = try verifyPartition(proof.classes, whole: r.whole, at: at + ".classes")
        let edges = Dictionary(uniqueKeysWithValues: r.edges.map { ($0.address, $0) })
        try verifyEForests(proof.connections, classes: proof.classes, edges: edges, at: at + ".connections")
        let required = distinctClasses(r.question, blocks: blocks)
        guard proof.required == required else { throw Failure(at + ".required: expected exactly the Question classes") }
        let holds = try verifyEvidence(proof.hiddenActions, members: members, reading: r, blocks: blocks,
            edges: edges, at: at + ".hiddenActions", budget: &budget)
        guard holds == (proof.conclusion != nil) else { throw Failure(at + ".conclusion: wrong preservation premise") }
        guard let conclusion = proof.conclusion else { return false }
        switch conclusion {
        case let .returned(block):
            try verifyReturnBlock(block, members: members, required: required, classes: proof.classes,
                                  blocks: blocks, budget: &budget)
            return true
        case let .obstructed(tail):
            let here = at + ".conclusion.obstructed"
            let supplied = members.first { $0.address == tail.member }
            guard let member = supplied else {
                throw Failure(here + ".member: no hidden member at this address")
            }
            guard required.contains(tail.block), tail.vertices.first == tail.block else {
                throw Failure(here + ".block: not the required Question class")
            }
            try verifyReturnWalk(tail.vertices, member: member, classes: proof.classes, blocks: blocks,
                                 at: here + ".vertices", budget: &budget)
            guard tail.repeatedIndex >= 0, tail.repeatedIndex < tail.vertices.count - 1,
                  tail.vertices.last == tail.vertices[tail.repeatedIndex], tail.vertices.last != tail.block else {
                throw Failure(here + ".repeatedIndex: expected the first repeated class different from the start")
            }
            return false
        }
    }
    static func verifyRelatedRepetition(_ request: String, certificate: RelatedCertificate,
                                        source: StructuralSource, constructor: String = "Paired") throws -> Bool {
        _ = try verifyRelated(request, certificate: certificate, source: source, constructor: constructor)
        guard let repetition = certificate.repetition else {
            throw Failure("certificate.repetition: no U11 judgment was presented")
        }
        // The common verifier above already checked this same proof once.
        if case .returned? = repetition.conclusion { return true }
        return false
    }
}
