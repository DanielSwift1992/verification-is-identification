import Foundation

// U10/U10a rules on addressed obligations, shared by both entrances.
extension ContinuationCore {
    static func uniqueSorts(_ values: [String]) -> [String] {
        var result: [String] = []
        for value in values
        where !result.contains(
                where: { sameSort($0,value) }) { result.append(value) }
        return result.sorted { $0.unicodeScalars.lexicographicallyPrecedes($1.unicodeScalars) }
    }
    public struct LeafBinding {
        public init(address: Path, output: Path, source: Path) { self.address = address
            self.output = output
            self.source = source }
        public let address: Path
        public let output: Path
        public let source: Path
    }
    public struct AgreementCapacity: Codable, Equatable {
        public static func == (a: Self, b: Self) -> Bool {
            sameSort(a.sort,b.sort) && a.requiredClasses == b.requiredClasses && a.outputClasses == b.outputClasses
                && a.fixedRequiredClasses == b.fixedRequiredClasses && a.freeOutputClasses == b.freeOutputClasses
                && a.minimumResidualLeaves == b.minimumResidualLeaves
        }

        public init(sort: String, requiredClasses: Int, outputClasses: Int, fixedRequiredClasses: Int, freeOutputClasses: Int, minimumResidualLeaves: Int) { self.sort = sort
            self.requiredClasses = requiredClasses
            self.outputClasses = outputClasses
            self.fixedRequiredClasses = fixedRequiredClasses
            self.freeOutputClasses = freeOutputClasses
            self.minimumResidualLeaves = minimumResidualLeaves }
        public var sort: String
        public var requiredClasses: Int
        public var outputClasses: Int
        public var fixedRequiredClasses: Int
        public var freeOutputClasses: Int
        public var minimumResidualLeaves: Int
    }
    public struct AgreementPlan: Codable {
        public init(assignments: [Path], step: Program, bindingBases: [EqualityBasis], needed: [RequiredClass], residualLeaves: [Path], residual: Program?, selections: [Selection], decoder: Program, capacities: [AgreementCapacity]) { self.assignments = assignments
            self.step = step
            self.bindingBases = bindingBases
            self.needed = needed
            self.residualLeaves = residualLeaves
            self.residual = residual
            self.selections = selections
            self.decoder = decoder
            self.capacities = capacities }
        // One Source leaf for each exact output C-class.
        public var assignments: [Path]
        public var step: Program
        public var bindingBases: [EqualityBasis]
        public var needed: [RequiredClass]
        public var residualLeaves: [Path]
        public var residual: Program?
        public var selections: [Selection]
        public var decoder: Program
        public var capacities: [AgreementCapacity]
    }
    public enum AgreementConclusion: Codable {
        case constructed(AgreementPlan)
        case unavailable(output: Path)
        case wrongSort(binding: Path)
        case incompatible(left: Path, right: Path)
    }
    public struct AgreementReading {
        public init(whole: WholeReading, output: WholeReading, question: Places, bindings: [LeafBinding]) { self.whole = whole
            self.output = output
            self.question = question
            self.bindings = bindings }
        public let whole: WholeReading
        public let output: WholeReading
        public let question: Places
        public let bindings: [LeafBinding]
        public var sourceReading: Reading {
            Reading(whole: whole, observation: sourcePlaces(whole.source), question: question)
        }
    }
    public static func agreementBindings(_ r: AgreementReading, sourceBlocks: [Path: Int],
                                   outputBlocks: [Path: Int]) throws -> (fixed: [Int: Int], issue: AgreementConclusion?) {
        var fixed: [Int: Int] = [:], first: [Int: Path] = [:]
        for binding in r.bindings {
            guard try sameSort(r.output.sort(binding.output), r.whole.sort(binding.source)) else {
                return (fixed, .wrongSort(binding: binding.address))
            }
            guard let target = outputBlocks[binding.output], let sourceClass = sourceBlocks[binding.source] else {
                throw Failure("binding: missing exact class")
            }
            if let previous = fixed[target], previous != sourceClass {
                return (fixed, .incompatible(left: first[target]!, right: binding.address))
            }
            fixed[target] = sourceClass
            if first[target] == nil { first[target] = binding.address }
        }
        return (fixed, nil)
    }
    public static func agreementCapacities(_ r: AgreementReading, sourceClasses: [PartitionClass],
                                    sourceBlocks: [Path: Int], outputClasses: [PartitionClass],
                                    fixed: [Int: Int]) -> [AgreementCapacity] {
        let required = Set(distinctClasses(r.question, blocks: sourceBlocks))
        let supplied = Set(fixed.values)
        let sorts = uniqueSorts(outputClasses.map(\.sort) + required.map { sourceClasses[$0].sort })
        return sorts.map { sort in
            let n = required.filter { sameSort(sourceClasses[$0].sort, sort) }.count
            let m = outputClasses.filter { sameSort($0.sort, sort) }.count
            let bound = required.intersection(supplied).filter { sameSort(sourceClasses[$0].sort, sort) }.count
            let free = outputClasses.indices.filter { sameSort(outputClasses[$0].sort, sort) && fixed[$0] == nil }.count
            return AgreementCapacity(sort: sort, requiredClasses: n, outputClasses: m, fixedRequiredClasses: bound,
                                     freeOutputClasses: free, minimumResidualLeaves: max(n - bound - free, 0))
        }
    }
    public static func agreementPlaces(_ r: AgreementReading, assignments: [Path],
                                 outputBlocks: [Path: Int], at: String) throws -> Places {
        guard assignments.count == Set(outputBlocks.values).count else {
            throw Failure(at + ".assignments: incomplete output C-class coverage")
        }
        let places = sourcePlaces(r.output.source)
        let origins = try places.leaves.map { leaf -> Path in
            guard let block = outputBlocks[leaf.source], assignments.indices.contains(block) else {
                throw Failure(at + ".assignments: missing output class")
            }
            let origin = assignments[block]
            do {
                guard try sameSort(r.whole.sort(origin), r.output.sort(leaf.source)) else { throw Failure("different sort") }
            } catch { throw Failure(at + ".assignments[\(block)]: " + String(describing: error)) }
            return origin
        }
        var index = 0
        func fill(_ node: Places) -> Places {
            switch node {
            case .leaf:
                defer { index += 1 }
                return .leaf(origins[index])
            case let .pair(l, r): return .pair(fill(l), fill(r))
            }
        }
        return fill(places)
    }
    public static func constructAgreement(_ r: AgreementReading, classes: [PartitionClass],
                                    blocks: [Path: Int], outputClasses: [PartitionClass],
                                    outputBlocks: [Path: Int]) throws -> AgreementConclusion {
        let available = classes.map(\.sort)
        for leaf in r.output.source.leaves {
            if !available.contains(
                where: { sameSort($0, leaf.1) }) { return .unavailable(output: leaf.0) }
        }
        let bindings = try agreementBindings(r, sourceBlocks: blocks, outputBlocks: outputBlocks)
        if let issue = bindings.issue { return issue }
        let required = distinctClasses(r.question, blocks: blocks)
        // Count all fixed classes before free classes choose new requested ones.
        var covered = Set(bindings.fixed.values), assignments: [Path] = []
        for (index, target) in outputClasses.enumerated() {
            let sourceClassIndex: Int
            if let fixed = bindings.fixed[index] { sourceClassIndex = fixed }
            else if let next = (required.first { sameSort(classes[$0].sort, target.sort) && !covered.contains($0) }) { sourceClassIndex = next }
            else if let fallback = (classes.firstIndex { sameSort($0.sort, target.sort) }) { sourceClassIndex = fallback }
            else { throw Failure("construction.agreement: unavailable output sort") }
            assignments.append(classes[sourceClassIndex].leaves[0])
            covered.insert(sourceClassIndex)
        }
        let p = try agreementPlaces(r, assignments: assignments, outputBlocks: outputBlocks, at: "construction.agreement")
        let reading = Reading(whole: r.whole, observation: p, question: r.question)
        let needed = try requiredClasses(reading, blocks: blocks)
        let leaves = needed.map { classes[$0.block].leaves[0] }
        let m = retainedPlaces(leaves)
        let joint = Reading(whole: r.whole, observation: m.map { .pair(p, $0) } ?? p, question: r.question)
        guard case let .constructed(selections, decoder) = try constructRelated(joint) else {
            throw Failure("construction.agreement: joint view does not cover Question")
        }
        var budget = ActionBudget()
        let bases = try r.bindings.map { binding -> EqualityBasis in
            try budget.spend(at: "construction.agreement.binding")
            guard case let .leaf(origin) = try p.at(binding.output) else { throw Failure("binding output is not a leaf") }
            return try constructionBasis(origin, binding.source, reading: r.sourceReading, budget: &budget)
        }
        let plan = try AgreementPlan(assignments: assignments,
            step: assembledProgram(p, inputs: p.leaves.map(\.source)), bindingBases: bases,
            needed: needed, residualLeaves: leaves, residual: m.map { try assembledProgram($0, inputs: leaves) },
            selections: selections, decoder: decoder,
            capacities: agreementCapacities(r, sourceClasses: classes, sourceBlocks: blocks,
                                           outputClasses: outputClasses, fixed: bindings.fixed))
        return .constructed(plan)
    }
    public static func verifyAgreementPlan(_ plan: AgreementPlan, request: String, reading r: AgreementReading,
                                     classes: [PartitionClass], blocks: [Path: Int],
                                     outputClasses: [PartitionClass], outputBlocks: [Path: Int],
                                     edges: [Path: SourceEdge], budget: inout ActionBudget) throws {
        let at = "certificate.conclusion.constructed._0"
        let binding = try agreementBindings(r, sourceBlocks: blocks, outputBlocks: outputBlocks)
        if let issue = binding.issue {
            switch issue {
            case let .wrongSort(address):
                throw Failure(at + ": wrongSort: " + pathText(request + ".BoundSources", address) + ": prescribed source has a different sort")
            case let .incompatible(left, right):
                throw Failure(at + ": incompatible: " + pathText(request + ".BoundSources", left)
                    + " and " + pathText(request + ".BoundSources", right) + ": different source classes in one output C-class")
            default: throw Failure(at + ": unsupported binding issue")
            }
        }
        let capacities = agreementCapacities(r, sourceClasses: classes, sourceBlocks: blocks,
                                             outputClasses: outputClasses, fixed: binding.fixed)
        guard plan.capacities == capacities else { throw Failure(at + ".capacities: counts differ from exact classes and fixed bindings") }
        let p = try agreementPlaces(r, assignments: plan.assignments, outputBlocks: outputBlocks, at: at)
        try budget.spend(plan.assignments.count + plan.residualLeaves.count, at: at)
        guard plan.step == (try assembledProgram(p, inputs: p.leaves.map(\.source))) else {
            throw Failure(at + ".step: term differs from C-class assignments")
        }
        guard plan.bindingBases.count == r.bindings.count else { throw Failure(at + ".bindingBases: incomplete binding coverage") }
        for (index, pair) in zip(plan.bindingBases, r.bindings).enumerated() {
            guard case let .leaf(origin) = try p.at(pair.1.output) else { throw Failure(at + ".bindingBases[\(index)]: nonleaf output") }
            try checkActionBasis(pair.0, from: origin, to: pair.1.source, reading: r.sourceReading,
                edges: edges, at: at + ".bindingBases[\(index)]", budget: &budget)
        }
        let reading = Reading(whole: r.whole, observation: p, question: r.question)
        let needed = try requiredClasses(reading, blocks: blocks)
        guard plan.needed == needed else { throw Failure(at + ".needed: required classes or Question addresses differ") }
        let lower = capacities.reduce(0) { $0 + $1.minimumResidualLeaves }
        guard plan.residualLeaves.count == needed.count, needed.count == lower else {
            throw Failure(at + ".residualLeaves: leaf count does not attain the global lower bound")
        }
        var supplied: Set<Int> = []
        let missing = Set(needed.map(\.block))
        for (index, leaf) in plan.residualLeaves.enumerated() {
            guard let block = blocks[leaf], missing.contains(block), supplied.insert(block).inserted else {
                throw Failure(at + ".residualLeaves[\(index)]: not a distinct required missing E-class")
            }
        }
        let m = retainedPlaces(plan.residualLeaves)
        let residual = try m.map { try assembledProgram($0, inputs: plan.residualLeaves) }
        guard plan.residual == residual else { throw Failure(at + ".residual: source term differs from retained addresses") }
        let joint = Reading(whole: r.whole, observation: m.map { .pair(p, $0) } ?? p, question: r.question)
        for selection in plan.selections {
            if case let .sourceRelation(path) = selection.basis { try budget.spend(path.count, at: at + ".selections") }
            else { try budget.spend(at: at + ".selections") }
        }
        try verifyRelatedProgram(plan.selections, program: plan.decoder, reading: joint,
                                 address: at, edgeIndex: edges, programField: "decoder", basisStepField: "sourceRelation._0")
    }
    // No equivalence closure, assignment search or plan construction in replay.

    public struct AgreementJudgment: Codable {
        public var classes: [PartitionClass]
        public var connections: [[EqualityStep]]
        public var outputClasses: [PartitionClass]
        public var outputConnections: [[EqualityStep]]
        public var conclusion: AgreementConclusion
        public init(classes: [PartitionClass], connections: [[EqualityStep]], outputClasses: [PartitionClass], outputConnections: [[EqualityStep]], conclusion: AgreementConclusion) {
            self.classes = classes
            self.connections = connections
            self.outputClasses = outputClasses
            self.outputConnections = outputConnections
            self.conclusion = conclusion
        }
    }
    public static func constructAgreementJudgment(_ r: AgreementReading) throws -> AgreementJudgment {
        let (classes, connections, blocks) = constructPartition(r.whole)
        let (outputClasses, outputConnections, outputBlocks) = constructPartition(r.output)
        return try .init(classes: classes, connections: connections, outputClasses: outputClasses, outputConnections: outputConnections,
            conclusion: constructAgreement(r, classes: classes, blocks: blocks, outputClasses: outputClasses, outputBlocks: outputBlocks))
    }
    public static func verifyAgreement(_ p: AgreementJudgment, reading r: AgreementReading, request: String) throws -> Bool {
        var budget = ActionBudget()
        try budget.spend(r.whole.source.leaves.count + r.whole.edges.count
            + r.output.source.leaves.count + r.output.edges.count + r.bindings.count,
            at: "certificate")
        let blocks = try verifyPartition(p.classes, whole: r.whole, at: "certificate.classes")
        let edges = Dictionary(uniqueKeysWithValues: r.whole.edges.map { ($0.address, $0) })
        try verifyEForests(p.connections, classes: p.classes, edges: edges, at: "certificate.connections")
        let outputs = try verifyPartition(p.outputClasses, whole: r.output, at: "certificate.outputClasses")
        let cEdges = Dictionary(uniqueKeysWithValues: r.output.edges.map { ($0.address, $0) })
        try verifyEForests(p.outputConnections, classes: p.outputClasses, edges: cEdges, at: "certificate.outputConnections")
        switch p.conclusion {
        case let .constructed(plan):
            try verifyAgreementPlan(plan, request: request, reading: r, classes: p.classes, blocks: blocks,
                outputClasses: p.outputClasses, outputBlocks: outputs, edges: edges, budget: &budget)
            return true
        case let .unavailable(path):
            let sort: String
            do { sort = try r.output.sort(path) }
            catch { throw Failure("certificate.conclusion.unavailable.output: " + String(describing: error)) }
            guard !(p.classes.contains { sameSort($0.sort, sort) }) else {
                throw Failure("certificate.conclusion.unavailable.output: the sort is available at Source")
            }
        case let .wrongSort(address):
            guard let binding = (r.bindings.first { $0.address == address }) else {
                throw Failure("certificate.conclusion.wrongSort.binding: no declared binding at this address")
            }
            guard try !sameSort(r.output.sort(binding.output), r.whole.sort(binding.source)) else {
                throw Failure("certificate.conclusion.wrongSort.binding: binding sorts agree")
            }
        case let .incompatible(left, right):
            let bindings = Dictionary(uniqueKeysWithValues: r.bindings.map { ($0.address, $0) })
            guard let a = bindings[left], let b = bindings[right] else {
                throw Failure("certificate.conclusion.incompatible: no declared bindings at these addresses")
            }
            guard try sameSort(r.output.sort(a.output), r.whole.sort(a.source)),
                  try sameSort(r.output.sort(b.output), r.whole.sort(b.source)),
                  outputs[a.output] == outputs[b.output], blocks[a.source] != blocks[b.source] else {
                throw Failure("certificate.conclusion.incompatible: bindings do not separate source classes in one output C-class")
            }
        }
        return false
    }
}
