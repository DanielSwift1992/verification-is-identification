import Foundation

// U5–U11 addressed calculus. No source-language reader or nominal context.
public enum ContinuationCore {
    public struct Failure: Error, CustomStringConvertible {
        public let description: String
        public init(_ description: String) { self.description = description }
    }
    public typealias Path = [Side]

    public enum Side: String, Codable, Hashable {
        case left = "Left", right = "Right"
    }

    public indirect enum Shape: Equatable {
        case leaf(String), pair(Shape, Shape)
        public static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case let (.leaf(a), .leaf(b)): return sameSort(a, b)
            case let (.pair(a, b), .pair(c, d)): return a == c && b == d
            default: return false
            }
        }

        public func at(_ path: Path) throws -> Shape {
            var node = self
            for side in path {
                guard case let .pair(l, r) = node else {
                    throw Failure("route projects an opaque leaf")
                }
                node = side == .left ? l : r
            }
            return node
        }
        public var leaves: [(Path, String)] {
            switch self {
            case let .leaf(name): return [([], name)]
            case let .pair(l, r):
                return l.leaves.map { ([.left] + $0.0, $0.1) }
                    + r.leaves.map { ([.right] + $0.0, $0.1) }
            }
        }
    }

    public indirect enum Program: Codable, Equatable {
        case pick(Path), pair(Program, Program)
        public func apply(to input: Shape) throws -> Shape {
            var remaining = 100_000
            func walk(_ program: Program, _ depth: Int) throws -> Shape {
                guard remaining > 0, depth < 256 else {
                    throw Failure("program exceeds replay limit")
                }
                remaining -= 1
                switch program {
                case let .pick(path): return try input.at(path)
                case let .pair(l, r): return try .pair(walk(l, depth + 1), walk(r, depth + 1))
                }
            }
            return try walk(self, 0)
        }
    }

    public indirect enum Places: Equatable {
        case leaf(Path), pair(Places, Places)
        public func at(_ path: Path) throws -> Places {
            var node = self
            for side in path {
                guard case let .pair(l, r) = node else {
                    throw Failure("route projects an opaque source place")
                }
                node = side == .left ? l : r
            }
            return node
        }
        public var leaves: [(output: Path, source: Path)] {
            switch self {
            case let .leaf(path): return [([], path)]
            case let .pair(l, r):
                return l.leaves.map { ([.left] + $0.output, $0.source) }
                    + r.leaves.map { ([.right] + $0.output, $0.source) }
            }
        }
    }

    public struct SourceEdge {
        public let address: Path
        public let left: Path
        public let right: Path
        public init(address: Path, left: Path, right: Path) { self.address = address; self.left = left; self.right = right }
    }

    public struct EqualityStep: Codable {
        public var edge: Path
        public var reversed: Bool
        public init(edge: Path, reversed: Bool) { self.edge = edge; self.reversed = reversed }
    }

    public enum EqualityBasis: Codable {
        case address
        case sourceRelation([EqualityStep])
        // This ground is represented distinctly and always rejected.
        case observedValues
    }

    public struct Selection: Codable {
        public var output: Path
        public var input: Path
        public var basis: EqualityBasis
        public init(output: Path, input: Path, basis: EqualityBasis) { self.output = output; self.input = input; self.basis = basis }
    }

    public struct PartitionClass: Codable {
        public var sort: String
        public var leaves: [Path]
        public init(sort: String, leaves: [Path]) { self.sort = sort; self.leaves = leaves }
    }

    public struct RequiredClass: Codable, Equatable {
        public var block: Int
        public var questions: [Path]
        public init(block: Int, questions: [Path]) { self.block = block; self.questions = questions }
    }

    public struct QuestionResidue: Codable {
        // One incoming E-edge for every non-root member, in block order.
        // Together with the closed partition these forests certify exact E-classes.
        public var connections: [[EqualityStep]]
        public var needed: [RequiredClass]
        public init(connections: [[EqualityStep]], needed: [RequiredClass]) { self.connections = connections; self.needed = needed }
    }

    public struct Obstruction: Codable {
        public var question: Path
        public var classes: [PartitionClass]
        // Format-2 certificates without this extension retain only the original
        // obstruction judgment. They make no claim to name the question's residue.
        public var residue: QuestionResidue? = nil
        public init(question: Path, classes: [PartitionClass], residue: QuestionResidue? = nil) { self.question = question; self.classes = classes; self.residue = residue }
    }

    public enum RelatedConclusion: Codable {
        case constructed([Selection], Program)
        case obstructed(Obstruction)
    }

    public struct RelatedRetention: Codable {
        // One same-source leaf per required class; construction uses Question order.
        public var leaves: [Path]
        public var view: Program
        // U5 on the joint view: Left is Observation, Right is the retained view.
        public var selections: [Selection]
        public var program: Program
        public init(leaves: [Path], view: Program, selections: [Selection], program: Program) { self.leaves = leaves; self.view = view; self.selections = selections; self.program = program }
    }

    public struct WholeReading {
        public let source: Shape
        public let edges: [SourceEdge]
        public func sort(_ path: Path) throws -> String {
            guard case let .leaf(sort) = try source.at(path) else {
                throw Failure(pathText("Source", path) + ": expected a leaf occurrence")
            }
            return sort
        }
        public init(source: Shape, edges: [SourceEdge]) { self.source = source; self.edges = edges }
    }

    public struct Reading {
        public let whole: WholeReading
        public let observation: Places
        public let question: Places
        public let actions: [ActionMember]
        public let hiddenActions: [ActionMember]?
        public var edges: [SourceEdge] { whole.edges }
        public var source: Shape { whole.source }
        public init(whole: WholeReading, observation: Places, question: Places, actions: [ActionMember] = [], hiddenActions: [ActionMember]? = nil) {
            self.whole = whole; self.observation = observation; self.question = question
            self.actions = actions
            self.hiddenActions = hiddenActions
        }
        public func sort(_ path: Path) throws -> String { try whole.sort(path) }
    }
    public static func sameSort(_ a: String, _ b: String) -> Bool {
        a.unicodeScalars.elementsEqual(b.unicodeScalars)
    }

    public static func sourcePlaces(_ shape: Shape, path: Path = []) -> Places {
        switch shape {
        case .leaf: return .leaf(path)
        case let .pair(l, r):
            return .pair(sourcePlaces(l, path: path + [.left]), sourcePlaces(r, path: path + [.right]))
        }
    }

    public static func assembledProgram(_ shape: Places, inputs: [Path]) throws -> Program {
        var index = 0
        func walk(_ node: Places) throws -> Program {
            switch node {
            case .leaf:
                guard index < inputs.count else { throw Failure("certificate: missing output selection") }
                let path = inputs[index]
                index += 1
                return .pick(path)
            case let .pair(l, r): return try .pair(walk(l), walk(r))
            }
        }
        let result = try walk(shape)
        guard index == inputs.count else { throw Failure("certificate: extra output selections") }
        return result
    }

    public static func requiredClasses(_ r: Reading, blocks: [Path: Int]) throws -> [RequiredClass] {
        let observed = Set(r.observation.leaves.compactMap { blocks[$0.source] })
        var needed: [RequiredClass] = []
        var indices: [Int: Int] = [:]
        for leaf in r.question.leaves {
            guard let block = blocks[leaf.source] else { throw Failure("certificate.residue: missing source class") }
            if observed.contains(block) { continue }
            if let index = indices[block] {
                needed[index].questions.append(leaf.output)
            } else {
                indices[block] = needed.count
                needed.append(RequiredClass(block: block, questions: [leaf.output]))
            }
        }
        return needed
    }

    public static func verifyPartition(_ classes: [PartitionClass], whole: WholeReading,
                                at: String = "certificate.partition") throws -> [Path: Int] {
        let all = whole.source.leaves
        var blocks: [Path: Int] = [:]
        guard classes.count <= all.count else { throw Failure("\(at): too many classes") }
        for (index, block) in classes.enumerated() {
            guard !block.leaves.isEmpty else { throw Failure("\(at)[\(index)]: empty class") }
            for path in block.leaves {
                do {
                    guard try sameSort(whole.sort(path), block.sort), blocks.updateValue(index, forKey: path) == nil else {
                        throw Failure("repeated leaf or different sort")
                    }
                } catch { throw Failure("\(at)[\(index)]: " + String(describing: error)) }
            }
        }
        guard Set(blocks.keys) == Set(all.map { $0.0 }) else { throw Failure("\(at): incomplete source coverage") }
        for edge in whole.edges {
            guard blocks[edge.left] == blocks[edge.right] else {
                throw Failure(pathText(at + ".E", edge.address) + ": partition breaks a declared E-edge")
            }
        }
        return blocks
    }

    public static func verifyEForests(_ connections: [[EqualityStep]], classes: [PartitionClass],
                               edges: [Path: SourceEdge], at: String) throws {
        guard connections.count == classes.count else { throw Failure(at + ": incomplete class coverage") }
        for (index, block) in classes.enumerated() {
            let at = "\(at)[\(index)]"
            let steps = connections[index]
            guard steps.count == block.leaves.count - 1 else { throw Failure(at + ": incomplete class forest") }
            var connected: Set<Path> = [block.leaves[0]]
            for (offset, step) in steps.enumerated() {
                let here = at + "[\(offset)]"
                guard let edge = edges[step.edge] else { throw Failure(here + ": no declared E-edge at this address") }
                let from = step.reversed ? edge.right : edge.left
                let to = step.reversed ? edge.left : edge.right
                guard connected.contains(from), to == block.leaves[offset + 1] else {
                    throw Failure(here + ": E-edge does not connect the next class member")
                }
                connected.insert(to)
            }
        }
    }

    public static func verifyResidue(_ residue: QuestionResidue, classes: [PartitionClass],
                              blocks: [Path: Int], reading r: Reading,
                              edges: [Path: SourceEdge]) throws {
        try verifyEForests(residue.connections, classes: classes, edges: edges, at: "certificate.residue.connections")
        guard residue.needed == (try requiredClasses(r, blocks: blocks)) else {
            throw Failure("certificate.residue.needed: required classes or Question addresses differ")
        }
    }

    public static func verifyEqualityBasis(_ basis: EqualityBasis, from: Path, to: Path,
                                     edges: [Path: SourceEdge], at: String, stepField: String = "path",
                                     remainingSteps: inout Int) throws {
        switch basis {
        case .address:
            guard from == to else { throw Failure(at + ": different source addresses are not identical") }
        case let .sourceRelation(steps):
            guard !steps.isEmpty, steps.count <= 100_000 else { throw Failure(at + ": expected a finite E-path") }
            var current = from
            for (stepIndex, step) in steps.enumerated() {
                let here = at + "." + stepField + "[\(stepIndex)]"
                guard remainingSteps > 0 else { throw Failure(here + ": replay work limit") }
                remainingSteps -= 1
                guard let edge = edges[step.edge] else { throw Failure(here + ": no declared E-edge at this address") }
                let a = step.reversed ? edge.right : edge.left
                let b = step.reversed ? edge.left : edge.right
                guard current == a else { throw Failure(here + ": discontinuous E-path") }
                current = b
            }
            guard current == to else { throw Failure(at + ": E-path ends at another source leaf") }
        case .observedValues:
            throw Failure(at + ": observed value coincidence is not source equality")
        }
    }

    public static func verifyRelatedProgram(_ selections: [Selection], program: Program,
                                     reading r: Reading, address: String,
                                     edgeIndex: [Path: SourceEdge]? = nil,
                                     programField: String = "program",
                                     basisStepField: String = "path") throws {
        let edges = edgeIndex ?? Dictionary(uniqueKeysWithValues: r.edges.map { ($0.address, $0) })
        let required = r.question.leaves
        var remainingSteps = 100_000
        guard selections.count == required.count else { throw Failure(address + ".selections: incomplete output coverage") }
        for (index, pair) in zip(selections, required).enumerated() {
            let (selection, target) = pair
            let at = address + ".selections[\(index)]"
            let input: Places
            do { input = try r.observation.at(selection.input) }
            catch { throw Failure(at + ".input: " + String(describing: error)) }
            guard selection.output == target.output,
                case let .leaf(from) = input
            else { throw Failure(at + ": output or input is not the required leaf address") }
            guard try sameSort(r.sort(from), r.sort(target.source)) else { throw Failure(at + ": selected sort differs") }
            try verifyEqualityBasis(selection.basis, from: from, to: target.source,
                edges: edges, at: at + ".basis", stepField: basisStepField, remainingSteps: &remainingSteps)
        }
        guard program == (try assembledProgram(r.question, inputs: selections.map(\.input))) else {
            throw Failure(address + "." + programField + ": assembled term differs from the selected addresses")
        }
    }

    public static func retainedPlaces(_ leaves: [Path]) -> Places? {
        guard !leaves.isEmpty else { return nil }
        func build(_ lower: Int, _ upper: Int) -> Places {
            if upper - lower == 1 { return .leaf(leaves[lower]) }
            let middle = lower + (upper - lower) / 2
            return .pair(build(lower, middle), build(middle, upper))
        }
        return build(0, leaves.count)
    }

    public static func verifyRelatedRetentionPlan(_ retention: RelatedRetention, obstruction: Obstruction,
                                          blocks: [Path: Int], reading r: Reading) throws {
        guard let residue = obstruction.residue else {
            throw Failure("certificate.retention: exact residue proof is required for minimality")
        }
        guard retention.leaves.count == residue.needed.count else {
            throw Failure("certificate.retention.leaves: expected exactly one leaf per missing class")
        }
        let required = Set(residue.needed.map(\.block))
        var supplied: Set<Int> = []
        for (index, path) in retention.leaves.enumerated() {
            do {
                _ = try r.sort(path)
                guard let block = blocks[path], required.contains(block), supplied.insert(block).inserted else {
                    throw Failure("not a distinct required missing E-class")
                }
            } catch { throw Failure("certificate.retention.leaves[\(index)]: " + String(describing: error)) }
        }
        guard let m = retainedPlaces(retention.leaves) else {
            throw Failure("certificate.retention: an empty residual has no additional carrier")
        }
        guard retention.view == (try assembledProgram(m, inputs: retention.leaves)) else {
            throw Failure("certificate.retention.view: assembled source view differs from its addresses")
        }
        let joint = Reading(whole: r.whole, observation: .pair(r.observation, m),
                                       question: r.question)
        try verifyRelatedProgram(retention.selections, program: retention.program,
                                 reading: joint, address: "certificate.retention")
    }

    public static func constructRelated(_ r: Reading) throws -> RelatedConclusion {
        let adjacent = equalityGraph(r)
        // Equivalence closure retains a path from an observed occurrence.
        // No payloads or candidate programs are inspected.
        var reached: [Path: (input: Path, previous: Path?, step: EqualityStep?)] = [:]
        var pending: [Path] = []
        for leaf in r.observation.leaves
        where reached[leaf.source] == nil {
            reached[leaf.source] = (leaf.output, nil, nil)
            pending.append(leaf.source)
        }
        var cursor = 0
        while cursor < pending.count {
            let here = pending[cursor]
            cursor += 1
            for (next, step) in adjacent[here] ?? []
            where reached[next] == nil {
                let prior = reached[here]!
                reached[next] = (prior.input, here, step)
                pending.append(next)
            }
        }
        var selections: [Selection] = []
        var remainingSteps = 100_000
        for target in r.question.leaves {
            guard let route = reached[target.source] else {
                let (classes, connections, blocks) = constructPartition(r)
                let residue = try QuestionResidue(connections: connections, needed: requiredClasses(r, blocks: blocks))
                return .obstructed(Obstruction(question: target.output, classes: classes, residue: residue))
            }
            var steps: [EqualityStep] = []
            var endpoint = target.source
            while let link = reached[endpoint], let previous = link.previous, let step = link.step {
                guard remainingSteps > 0 else { throw Failure("construction equality-path work limit") }
                remainingSteps -= 1
                steps.append(step)
                endpoint = previous
            }
            selections.append(Selection(output: target.output, input: route.input,
                                        basis: steps.isEmpty ? .address : .sourceRelation(Array(steps.reversed()))))
        }
        return try .constructed(selections, assembledProgram(r.question, inputs: selections.map(\.input)))
    }

    public static func equalityGraph(_ whole: WholeReading) -> [Path: [(Path, EqualityStep)]] {
        var graph: [Path: [(Path, EqualityStep)]] = [:]
        for edge in whole.edges {
            graph[edge.left, default: []].append((edge.right, .init(edge: edge.address, reversed: false)))
            graph[edge.right, default: []].append((edge.left, .init(edge: edge.address, reversed: true)))
        }
        return graph
    }

    public static func equalityGraph(_ r: Reading) -> [Path: [(Path, EqualityStep)]] { equalityGraph(r.whole) }

    public static func constructPartition(_ whole: WholeReading) ->
        (classes: [PartitionClass], connections: [[EqualityStep]], blocks: [Path: Int]) {
        let adjacent = equalityGraph(whole)
        var seen: Set<Path> = [], classes: [PartitionClass] = [], connections: [[EqualityStep]] = []
        var blocks: [Path: Int] = [:]
        for (path, sort) in whole.source.leaves
        where seen.insert(path).inserted {
            var component = [path], forest: [EqualityStep] = []
            var cursor = 0
            while cursor < component.count {
                for (next, step) in adjacent[component[cursor]] ?? []
                where seen.insert(next).inserted {
                    component.append(next)
                    forest.append(step)
                }
                cursor += 1
            }
            for member in component { blocks[member] = classes.count }
            classes.append(.init(sort: sort, leaves: component))
            connections.append(forest)
        }
        return (classes, connections, blocks)
    }

    public static func constructPartition(_ r: Reading) -> (classes: [PartitionClass], connections: [[EqualityStep]], blocks: [Path: Int]) { constructPartition(r.whole) }

    public static func verify(_ conclusion: RelatedConclusion, retention: RelatedRetention?, reading r: Reading) throws -> Bool {
        let edges = Dictionary(uniqueKeysWithValues: r.edges.map { ($0.address, $0) })
        switch conclusion {
        case let .constructed(selections, program):
            guard retention == nil else {
                throw Failure("certificate.retention: no residual is needed by a constructed continuation")
            }
            try verifyRelatedProgram(selections, program: program, reading: r, address: "certificate")
            return true
        case let .obstructed(obstruction):
            let blocks = try verifyPartition(obstruction.classes, whole: r.whole)
            guard case let .leaf(missing) = try r.question.at(obstruction.question), let block = blocks[missing] else {
                throw Failure("certificate.partition.question: missing required leaf address")
            }
            let sort = try r.sort(missing)
            for leaf in r.observation.leaves
            where try sameSort(r.sort(leaf.source), sort) {
                guard blocks[leaf.source] != block else {
                    throw Failure("certificate.partition.question: partition does not separate the required class from Observation")
                }
            }
            if let residue = obstruction.residue {
                try verifyResidue(residue, classes: obstruction.classes, blocks: blocks, reading: r, edges: edges)
            }
            if let retention = retention {
                try verifyRelatedRetentionPlan(retention, obstruction: obstruction, blocks: blocks, reading: r)
            }
            return false
        }
    }

    public static func retention(_ conclusion: RelatedConclusion, reading r: Reading) throws -> RelatedRetention? {
        if case let .obstructed(obstruction) = conclusion,
            let residue = obstruction.residue {
            let leaves = residue.needed.map { obstruction.classes[$0.block].leaves[0] }
            guard let m = retainedPlaces(leaves) else { throw Failure("certificate.retention: missing source classes") }
            let joint = Reading(whole: r.whole, observation: .pair(r.observation, m),
                                       question: r.question)
            guard case let .constructed(selections, program) = try constructRelated(joint) else {
                throw Failure("certificate.retention: joint view does not cover Question")
            }
            return try RelatedRetention(leaves: leaves,
                view: assembledProgram(m, inputs: leaves), selections: selections, program: program)
        }
        return nil
    }
    public static func pathText(_ base: String, _ path: Path) -> String {
        base + path.map { "." + $0.rawValue }.joined()
    }
}
